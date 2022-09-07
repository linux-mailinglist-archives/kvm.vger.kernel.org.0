Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6B65AFA3B
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 04:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiIGCux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 22:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiIGCut (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 22:50:49 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D6938A4;
        Tue,  6 Sep 2022 19:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662519046; x=1694055046;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Jsb6uAEwqgmeboHEFCMSnT8EmBt+z5FDNcItFnNeD5s=;
  b=ARS0cFFnZnqj8IA8HT07guCIaJOwd0lMG0GW10Y9C50XLWvMymmRLh7Y
   UdkBB9R8vkGc5uwIBMXKY8uJNWywawA/tp1FgkbL36V1K1m6UfJMtTjBt
   g2wG4qW1NoFtklV79rkAAngD63H43F90bjeQw8rZ1cqGAcUMWwpNE7dUi
   xMZQEdYcNQv48pu1uSGGeDVuoxPVo81R0imeyg8+xaWDJUMEqok/GgXKv
   ha3OgCtZw7bFSEHgTaF8VB88679murt2JJZlFpBVIfDRGADzsSENtZpsW
   R4TVpr/uMXIWCXCtTpjVA9RkGmoYrMRV4RLXdKmPTxALtDwSPLzEodv0c
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="298078326"
X-IronPort-AV: E=Sophos;i="5.93,295,1654585200"; 
   d="scan'208";a="298078326"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 19:50:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,295,1654585200"; 
   d="scan'208";a="675972461"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga008.fm.intel.com with ESMTP; 06 Sep 2022 19:50:43 -0700
Date:   Wed, 7 Sep 2022 10:50:42 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 1/4] KVM: x86: move the event handling of
 KVM_REQ_GET_VMCS12_PAGES into a common function
Message-ID: <20220907025042.hvfww56wskwhsjwk@yy-desk-7060>
References: <20220828222544.1964917-1-mizhang@google.com>
 <20220828222544.1964917-2-mizhang@google.com>
 <YwzkvfT0AiwaojTx@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwzkvfT0AiwaojTx@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 29, 2022 at 04:09:33PM +0000, Sean Christopherson wrote:
> On Sun, Aug 28, 2022, Mingwei Zhang wrote:
> > Create a common function to handle kvm request in the vcpu_run loop. KVM
> > implicitly assumes the virtual APIC page being present + mapped into the
> > kernel address space when executing vmx_guest_apic_has_interrupts().
> > However, with demand paging KVM breaks the assumption, as the
> > KVM_REQ_GET_VMCS12_PAGES event isn't assessed before entering vcpu_block.
>
> KVM_REQ_GET_VMCS12_PAGES doesn't exist upstream.
>
> > Fix this by getting vmcs12 pages before inspecting the guest's APIC page.
> > Because of this fix, the event handling code of
> > KVM_REQ_GET_NESTED_STATE_PAGES becomes a common code path for both
> > vcpu_enter_guest() and vcpu_block(). Thus, put this code snippet into a
> > common helper function to avoid code duplication.
> >
> > Cc: Maxim Levitsky <mlevitsk@redhat.com>
> > Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> > Originally-by: Oliver Upton <oupton@google.com>
> > Signed-off-by: Oliver Upton <oupton@google.com>
>
> If you drop someone as author, then their SOB also needs to be jettisoned.
>
> > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > ---
> >  arch/x86/kvm/x86.c | 29 +++++++++++++++++++++++------
> >  1 file changed, 23 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index d7374d768296..3dcaac8f0584 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -10261,12 +10261,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >  			r = -EIO;
> >  			goto out;
> >  		}
> > -		if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
> > -			if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
> > -				r = 0;
> > -				goto out;
> > -			}
> > -		}
> >  		if (kvm_check_request(KVM_REQ_MMU_FREE_OBSOLETE_ROOTS, vcpu))
> >  			kvm_mmu_free_obsolete_roots(vcpu);
> >  		if (kvm_check_request(KVM_REQ_MIGRATE_TIMER, vcpu))
> > @@ -10666,6 +10660,23 @@ static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
> >  		!vcpu->arch.apf.halted);
> >  }
> >
> > +static int kvm_vcpu_handle_common_requests(struct kvm_vcpu *vcpu)
> > +{
> > +	if (kvm_request_pending(vcpu)) {
>
> Probably going to be a moot point, but write this as
>
> 	if (!kvm_request_pending(vcpu))
> 		return 1;
>
> to reduce indentation.
>
> > +		/*
> > +		 * Get the vmcs12 pages before checking for interrupts that
> > +		 * might unblock the guest if L1 is using virtual-interrupt
> > +		 * delivery.
> > +		 */
> > +		if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
> > +			if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu)))
>
> Similarly
>
> 	if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu) &&
> 	    unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu)))
> 		return 0;
>
> though I can see the argument for fully isolating each request.  But again, likely
> a moot point.
>
> > +				return 0;
> > +		}
> > +	}
> > +
> > +	return 1;
> > +}
> > +
> >  /* Called within kvm->srcu read side.  */
> >  static int vcpu_run(struct kvm_vcpu *vcpu)
> >  {
> > @@ -10681,6 +10692,12 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
> >  		 * this point can start executing an instruction.
> >  		 */
> >  		vcpu->arch.at_instruction_boundary = false;
> > +
> > +		/* Process common request regardless of vcpu state. */
> > +		r = kvm_vcpu_handle_common_requests(vcpu);
>
> IMO this is subtly a dangerous hook.  It implies that both vcpu_enter_guest()
> and vcpu_block() correctly handle requests becoming pending after the "common"
> check, but that's not actually the case.  If a request _needs_ to be handled
> before vcpu_block(), then ideally it should be explicitly queried in
> kvm_vcpu_check_block().  KVM_REQ_GET_NESTED_STATE_PAGES doesn't have issues because
> it's only ever set from the vCPU itself.
>
> Following that train of thought, KVM_REQ_GET_NESTED_STATE_PAGES really shouldn't
> even be a request.  Aha!  And we can do that in a way that would magically fix this
> bug, and would ensure we don't leave a trap for future us.
>
> KVM already provides KVM_REQ_UNBLOCK to prevent blocking the vCPU without actaully
> waking the vCPU, i.e. to kick the vCPU back into the vcpu_run() loop.  The request
> is provided specifically for scenarios like this where KVM needs to do work before
> blocking.
>
> Normally I'd say we should do this over multiple patches so that the "blocking"
> bug is fixed before doing the rework/cleanup, but I'm ok if we want to skip straight
> to the rework since we're obviously carrying an internal patch and no one else is
> likely to need the fix.  But I also wouldn't object to including an intermediate
> patch to fix the bug so that there's a better paper trail.
>
> E.g. as a very partial conversion:
>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/vmx/nested.c       |  2 +-
>  arch/x86/kvm/x86.c              | 12 ++++++++++++
>  arch/x86/kvm/x86.h              | 10 ++++++++++
>  4 files changed, 25 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 9345303c8c6d..bfca37419783 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -939,6 +939,8 @@ struct kvm_vcpu_arch {
>  	 */
>  	bool pdptrs_from_userspace;
>
> +	bool nested_get_pages_pending;
> +
>  #if IS_ENABLED(CONFIG_HYPERV)
>  	hpa_t hv_root_tdp;
>  #endif
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index ddd4367d4826..e83b145c3a35 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3446,7 +3446,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>  		 * to nested_get_vmcs12_pages before the next VM-entry.  The MSRs
>  		 * have already been set at vmentry time and should not be reset.
>  		 */
> -		kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
> +		kvm_nested_get_pages_set_pending(vcpu);
>  	}
>
>  	/*
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c0e3e7915a3a..0a7601ebffc6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9650,6 +9650,12 @@ int kvm_check_nested_events(struct kvm_vcpu *vcpu)
>  	return kvm_x86_ops.nested_ops->check_events(vcpu);
>  }
>
> +static int kvm_get_nested_state_pages(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->arch.nested_get_pages_pending = false;
> +	return kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu);
> +}
> +
>  static void kvm_inject_exception(struct kvm_vcpu *vcpu)
>  {
>  	trace_kvm_inj_exception(vcpu->arch.exception.nr,
> @@ -10700,6 +10706,12 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
>  		if (kvm_cpu_has_pending_timer(vcpu))
>  			kvm_inject_pending_timer_irqs(vcpu);
>
> +		if (vcpu->arch.nested_get_pages_pending) {
> +			r = kvm_get_nested_state_pages(vcpu);
> +			if (r <= 0)
> +				break;
> +		}
> +

Will this leads to skip the get_nested_state_pages for L2 first time
vmentry in every L2 running iteration ? Because with above changes
KVM_REQ_GET_NESTED_STATE_PAGES is not set in
nested_vmx_enter_non_root_mode() and
vcpu->arch.nested_get_pages_pending is not checked in
vcpu_enter_guest().

>  		if (dm_request_for_irq_injection(vcpu) &&
>  			kvm_vcpu_ready_for_interrupt_injection(vcpu)) {
>  			r = 0;
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 1926d2cb8e79..e35aac39dc73 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -481,4 +481,14 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>  			 unsigned int port, void *data,  unsigned int count,
>  			 int in);
>
> +static inline void kvm_nested_get_pages_set_pending(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * Here is a comment explaining why KVM needs to prevent the vCPU from
> +	 * blocking until the vCPU's nested pages have been loaded.
> +	 */
> +	vcpu->arch.nested_get_pages_pending = true;
> +	kvm_make_request(KVM_REQ_UNBLOCK, vcpu);
> +}
> +
>  #endif
>
> base-commit: 14a47a98151834c5bd2f6d8d592b01108a3f882a
> --
