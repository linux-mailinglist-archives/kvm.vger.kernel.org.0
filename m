Return-Path: <kvm+bounces-4512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C8228133FF
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 16:07:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD4DA28330C
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 15:07:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 415B95C065;
	Thu, 14 Dec 2023 15:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ALWihmsb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829F2126
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 07:07:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702566425; x=1734102425;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3rYxUFnyj6H+mivjpnzLPMEVZJUcTzbO+zo3JRPAMEs=;
  b=ALWihmsb2rD6H6OkESv+WIgQF0o8KeGsKWEd8Hkg9tFYYT/KmR70iwQp
   OmooND2DSqB8GEIKUX09SEhM4PfRgJXiu1+kUpBCTBeB3D/NvT06h3zEk
   xPhlS+2GhRbzOt5yUokJQuIdmL49dH3UZclb7Rs0+YOhYM4tgp8BcJ8/z
   Dm5GjWlMncbNAluUVWkoO7lqDzf3MQQkLTjxBH+oirSJG01Ndfdhi/urf
   +FNUmNRVpH3LXqsQlOO+Z65CCg9MShlrkHRbPoIaxAnD1Ruj2hn7+Rk1S
   XUX7+Jbj1kqsLsYQYRW+ec8+Q05k0ih4yoGX+12PEFyEOgzV3oKAVbbf6
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="375287230"
X-IronPort-AV: E=Sophos;i="6.04,275,1695711600"; 
   d="scan'208";a="375287230"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2023 07:07:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="750563105"
X-IronPort-AV: E=Sophos;i="6.04,275,1695711600"; 
   d="scan'208";a="750563105"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orsmga006.jf.intel.com with ESMTP; 14 Dec 2023 07:07:02 -0800
Date: Thu, 14 Dec 2023 23:04:38 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Li RongQing <lirongqing@baidu.com>, x86@kernel.org, kvm@vger.kernel.org,
	mlevitsk@redhat.com
Subject: Re: [PATCH v2] KVM: x86: fix kvm_has_noapic_vcpu updates when fail
 to create vcpu
Message-ID: <ZXsZhkhWQnORrxe+@yilunxu-OptiPlex-7050>
References: <20231123010424.10274-1-lirongqing@baidu.com>
 <ZWoQfVxynCVv2_CB@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWoQfVxynCVv2_CB@google.com>

On Fri, Dec 01, 2023 at 08:57:33AM -0800, Sean Christopherson wrote:
> On Thu, Nov 23, 2023, Li RongQing wrote:
> > Static key kvm_has_noapic_vcpu should be reduced when fail to create
> > vcpu, opportunistically change to call kvm_free_lapic only when LAPIC
> > is in kernel in kvm_arch_vcpu_destroy
> 
> Heh, this has been on my todo list for a comically long time.
> 
> > Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> > Signed-off-by: Li RongQing <lirongqing@baidu.com>
> > ---
> > diff v1: call kvm_free_lapic conditionally in kvm_arch_vcpu_destroy
> > 
> >  arch/x86/kvm/x86.c | 14 ++++++++++----
> >  1 file changed, 10 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 2c92407..3cadf28 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -12079,7 +12079,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >  	kfree(vcpu->arch.mci_ctl2_banks);
> >  	free_page((unsigned long)vcpu->arch.pio_data);
> >  fail_free_lapic:
> > -	kvm_free_lapic(vcpu);
> > +	if (lapic_in_kernel(vcpu))
> > +		kvm_free_lapic(vcpu);
> > +	else
> > +		static_branch_dec(&kvm_has_noapic_vcpu);
> >  fail_mmu_destroy:
> >  	kvm_mmu_destroy(vcpu);
> >  	return r;
> > @@ -12122,14 +12125,17 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
> >  	kvm_pmu_destroy(vcpu);
> >  	kfree(vcpu->arch.mce_banks);
> >  	kfree(vcpu->arch.mci_ctl2_banks);
> > -	kvm_free_lapic(vcpu);
> > +
> > +	if (lapic_in_kernel(vcpu))
> > +		kvm_free_lapic(vcpu);
> > +	else
> > +		static_branch_dec(&kvm_has_noapic_vcpu);
> 
> Rather than split code like this, what if we let the APIC code deal with bumping
> the static branch?  The effect of this bug is purely just loss of an optimization
> that has *very* dubious value to begin with, i.e. having a minimal diff isn't a
> priority.  lapic.h already declares kvm_has_noapic_vcpu, so this would make lapic.*
> the sole owner of the code.
> 
> E.g. (untested)
> 
> ---
>  arch/x86/kvm/lapic.c | 27 ++++++++++++++++++++++++++-
>  arch/x86/kvm/x86.c   | 29 +++--------------------------
>  2 files changed, 29 insertions(+), 27 deletions(-)

This good to me.

Reviewed-by: Xu Yilun <yilun.xu@linux.intel.com>

> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index f5fab29c827f..45ffc7d1e49e 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -124,6 +124,9 @@ static inline int __apic_test_and_clear_vector(int vec, void *bitmap)
>  	return __test_and_clear_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
>  }
>  
> +__read_mostly DEFINE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
> +EXPORT_SYMBOL_GPL(kvm_has_noapic_vcpu);
> +
>  __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(apic_hw_disabled, HZ);
>  __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(apic_sw_disabled, HZ);
>  
> @@ -2467,8 +2470,10 @@ void kvm_free_lapic(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  
> -	if (!vcpu->arch.apic)
> +	if (!vcpu->arch.apic) {
> +		static_branch_dec(&kvm_has_noapic_vcpu);
>  		return;
> +	}
>  
>  	hrtimer_cancel(&apic->lapic_timer.timer);
>  
> @@ -2810,6 +2815,11 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
>  
>  	ASSERT(vcpu != NULL);
>  
> +	if (!irqchip_in_kernel(vcpu->kvm)) {
> +		static_branch_inc(&kvm_has_noapic_vcpu);
> +		return 0;
> +	}
> +
>  	apic = kzalloc(sizeof(*apic), GFP_KERNEL_ACCOUNT);
>  	if (!apic)
>  		goto nomem;
> @@ -2845,6 +2855,21 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
>  	static_branch_inc(&apic_sw_disabled.key); /* sw disabled at reset */
>  	kvm_iodevice_init(&apic->dev, &apic_mmio_ops);
>  
> +	/*
> +	 * Defer evaluating inhibits until the vCPU is first run, as this vCPU
> +	 * will not get notified of any changes until this vCPU is visible to
> +	 * other vCPUs (marked online and added to the set of vCPUs).
> +	 *
> +	 * Opportunistically mark APICv active as VMX in particularly is highly
> +	 * unlikely to have inhibits.  Ignore the current per-VM APICv state so
> +	 * that vCPU creation is guaranteed to run with a deterministic value,
> +	 * the request will ensure the vCPU gets the correct state before VM-Entry.
> +	 */
> +	if (enable_apicv) {
> +		apic->apicv_active = true;
> +		kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
> +	}
> +
>  	return 0;
>  nomem_free_apic:
>  	kfree(apic);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0572172f2e94..7d7d65c60276 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12014,27 +12014,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	if (r < 0)
>  		return r;
>  
> -	if (irqchip_in_kernel(vcpu->kvm)) {
> -		r = kvm_create_lapic(vcpu, lapic_timer_advance_ns);
> -		if (r < 0)
> -			goto fail_mmu_destroy;
> -
> -		/*
> -		 * Defer evaluating inhibits until the vCPU is first run, as
> -		 * this vCPU will not get notified of any changes until this
> -		 * vCPU is visible to other vCPUs (marked online and added to
> -		 * the set of vCPUs).  Opportunistically mark APICv active as
> -		 * VMX in particularly is highly unlikely to have inhibits.
> -		 * Ignore the current per-VM APICv state so that vCPU creation
> -		 * is guaranteed to run with a deterministic value, the request
> -		 * will ensure the vCPU gets the correct state before VM-Entry.
> -		 */
> -		if (enable_apicv) {
> -			vcpu->arch.apic->apicv_active = true;
> -			kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
> -		}
> -	} else
> -		static_branch_inc(&kvm_has_noapic_vcpu);
> +	r = kvm_create_lapic(vcpu, lapic_timer_advance_ns);
> +	if (r < 0)
> +		goto fail_mmu_destroy;
>  
>  	r = -ENOMEM;
>  
> @@ -12155,8 +12137,6 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  	srcu_read_unlock(&vcpu->kvm->srcu, idx);
>  	free_page((unsigned long)vcpu->arch.pio_data);
>  	kvfree(vcpu->arch.cpuid_entries);
> -	if (!lapic_in_kernel(vcpu))
> -		static_branch_dec(&kvm_has_noapic_vcpu);
>  }
>  
>  void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> @@ -12433,9 +12413,6 @@ bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
>  	return (vcpu->arch.apic_base & MSR_IA32_APICBASE_BSP) != 0;
>  }
>  
> -__read_mostly DEFINE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
> -EXPORT_SYMBOL_GPL(kvm_has_noapic_vcpu);
> -
>  void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
>  {
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> 
> base-commit: 1d4405b36808dc8c2d9b65b627c2af4b62fe017e
> -- 
> 
> 

