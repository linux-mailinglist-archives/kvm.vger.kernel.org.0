Return-Path: <kvm+bounces-21861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B2A293513D
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 19:26:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B739F1C20EE0
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 17:26:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D42781459E2;
	Thu, 18 Jul 2024 17:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f2iqnngK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050F5143892;
	Thu, 18 Jul 2024 17:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721323596; cv=none; b=cBwaVL6dazyI3+osZAmfGah7RxaU/TTnD8fhL/OokLcOtJieLAd5knheWkQ8YVXDpE46llgZI/bWSad+YC81/nDixJZhN10ZukMHz6wR0QBgy8y3xMsKLfZOBsAlkfr6jOcKK7bYvr8rTKUFsBHEHPJUqLtw+eVKHW+a/Mav5gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721323596; c=relaxed/simple;
	bh=+d5eh0z6xjhhhwdaQ0g67V4EjIHpa95pnKbaxP6L64U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BgVEo6uu/WG1UnKwxrrthpoYSTnmMvAESMMzv7tDcZaY3EJy/W428MKzOWiS6t89I831YuKMYBuALlM1sTsZ48c4ORh5k71dBZ18SFB8gnOkUEVkrMTL2SV7PGEtq2VfU70O6qdQ2I/mrUn7Qy89exgZHndTNuRyjh4ogD5i9/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f2iqnngK; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721323594; x=1752859594;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=+d5eh0z6xjhhhwdaQ0g67V4EjIHpa95pnKbaxP6L64U=;
  b=f2iqnngKxmCk2wzrpdzMtNVDiSDV0eHqGQ3Lt7ROtRo43np8HjFn4EiO
   23J+9f3m3f8Svou7o/2H5rOrAnZlUZlQrThwvOTPr3jdOCdzaWUr6EgaP
   UwS9ss4W8RdGvRJyB2ouvltYe+u5JxX59f5Nqmfq0AKFj2yoopdBa6xLq
   j165psgUiK6gb1Xz55gVtQXGXzX4Uj8iQuoFF6fVzO22uwmOeogLID2nS
   RKC22DAXG3M+/8cjPuxdl4+ybEcTLLBDFMSvWJqGN9JAUDvcD2L0ry7x8
   gyZ9jlD4eXWJt+L66i4LcB4kCkPXGlE9D94e+5lYILu2iEvebJTJLyoaf
   A==;
X-CSE-ConnectionGUID: CAZTVO8BRwaDe/0JWUVgNg==
X-CSE-MsgGUID: 46c2Xd84ToCXZL/DSiV7LQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="36443413"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="36443413"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 10:26:33 -0700
X-CSE-ConnectionGUID: CvnKnu6/QQi6I/BFdJW1CQ==
X-CSE-MsgGUID: honD/yp7RTSSqvBfExkz4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="50701285"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 10:26:32 -0700
Date: Thu, 18 Jul 2024 10:26:31 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	rick.p.edgecombe@intel.com
Subject: Re: [PATCH v19 117/130] KVM: TDX: Silently ignore INIT/SIPI
Message-ID: <20240718172631.GI1900928@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <4a4225de42be0f7568c5ecb5c22f2029f8e91d62.1708933498.git.isaku.yamahata@intel.com>
 <c45a1448-09ee-4750-bf86-28295dfc6089@linux.intel.com>
 <20240716225504.GE1900928@ls.amr.corp.intel.com>
 <d55d3c5a-41d9-46bd-91da-f07187501bfa@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d55d3c5a-41d9-46bd-91da-f07187501bfa@linux.intel.com>

On Thu, Jul 18, 2024 at 09:42:11AM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 7/17/2024 6:55 AM, Isaku Yamahata wrote:
> > On Mon, Jun 17, 2024 at 09:20:36AM +0800,
> > Binbin Wu <binbin.wu@linux.intel.com> wrote:
> > 
> > > 
> > > On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> > > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > 
> > > > The TDX module API doesn't provide API for VMM to inject INIT IPI and SIPI.
> > > > Instead it defines the different protocols to boot application processors.
> > > > Ignore INIT and SIPI events for the TDX guest.
> > > > 
> > > > There are two options. 1) (silently) ignore INIT/SIPI request or 2) return
> > > > error to guest TDs somehow.  Given that TDX guest is paravirtualized to
> > > > boot AP, the option 1 is chosen for simplicity.
> > > > 
> > > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > ---
> > > >    arch/x86/include/asm/kvm-x86-ops.h |  1 +
> > > >    arch/x86/include/asm/kvm_host.h    |  2 ++
> > > >    arch/x86/kvm/lapic.c               | 19 +++++++++++-------
> > > >    arch/x86/kvm/svm/svm.c             |  1 +
> > > >    arch/x86/kvm/vmx/main.c            | 32 ++++++++++++++++++++++++++++--
> > > >    arch/x86/kvm/vmx/tdx.c             |  4 ++--
> > > >    6 files changed, 48 insertions(+), 11 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > > > index 22d93d4124c8..85c04aad6ab3 100644
> > > > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > > > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > > > @@ -149,6 +149,7 @@ KVM_X86_OP_OPTIONAL(migrate_timers)
> > > >    KVM_X86_OP(msr_filter_changed)
> > > >    KVM_X86_OP(complete_emulated_msr)
> > > >    KVM_X86_OP(vcpu_deliver_sipi_vector)
> > > > +KVM_X86_OP(vcpu_deliver_init)
> > > >    KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
> > > >    KVM_X86_OP_OPTIONAL(get_untagged_addr)
> > > >    KVM_X86_OP_OPTIONAL_RET0(gmem_max_level)
> > > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > > index bb8be091f996..2686c080820b 100644
> > > > --- a/arch/x86/include/asm/kvm_host.h
> > > > +++ b/arch/x86/include/asm/kvm_host.h
> > > > @@ -1836,6 +1836,7 @@ struct kvm_x86_ops {
> > > >    	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
> > > >    	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
> > > > +	void (*vcpu_deliver_init)(struct kvm_vcpu *vcpu);
> > > >    	/*
> > > >    	 * Returns vCPU specific APICv inhibit reasons
> > > > @@ -2092,6 +2093,7 @@ void kvm_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
> > > >    void kvm_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
> > > >    int kvm_load_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector, int seg);
> > > >    void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
> > > > +void kvm_vcpu_deliver_init(struct kvm_vcpu *vcpu);
> > > >    int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
> > > >    		    int reason, bool has_error_code, u32 error_code);
> > > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > > index 8025c7f614e0..431074679e83 100644
> > > > --- a/arch/x86/kvm/lapic.c
> > > > +++ b/arch/x86/kvm/lapic.c
> > > > @@ -3268,6 +3268,16 @@ int kvm_lapic_set_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len)
> > > >    	return 0;
> > > >    }
> > > > +void kvm_vcpu_deliver_init(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +	kvm_vcpu_reset(vcpu, true);
> > > > +	if (kvm_vcpu_is_bsp(vcpu))
> > > > +		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> > > > +	else
> > > > +		vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(kvm_vcpu_deliver_init);
> > > > +
> > > >    int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
> > > >    {
> > > >    	struct kvm_lapic *apic = vcpu->arch.apic;
> > > > @@ -3299,13 +3309,8 @@ int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
> > > >    		return 0;
> > > >    	}
> > > > -	if (test_and_clear_bit(KVM_APIC_INIT, &apic->pending_events)) {
> > > > -		kvm_vcpu_reset(vcpu, true);
> > > > -		if (kvm_vcpu_is_bsp(apic->vcpu))
> > > > -			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> > > > -		else
> > > > -			vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
> > > > -	}
> > > > +	if (test_and_clear_bit(KVM_APIC_INIT, &apic->pending_events))
> > > > +		static_call(kvm_x86_vcpu_deliver_init)(vcpu);
> > > >    	if (test_and_clear_bit(KVM_APIC_SIPI, &apic->pending_events)) {
> > > >    		if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED) {
> > > >    			/* evaluate pending_events before reading the vector */
> > > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > > index f76dd52d29ba..27546d993809 100644
> > > > --- a/arch/x86/kvm/svm/svm.c
> > > > +++ b/arch/x86/kvm/svm/svm.c
> > > > @@ -5037,6 +5037,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
> > > >    	.complete_emulated_msr = svm_complete_emulated_msr,
> > > >    	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
> > > > +	.vcpu_deliver_init = kvm_vcpu_deliver_init,
> > > >    	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
> > > >    };
> > > > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > > > index 4f3b872cd401..84d2dc818cf7 100644
> > > > --- a/arch/x86/kvm/vmx/main.c
> > > > +++ b/arch/x86/kvm/vmx/main.c
> > > > @@ -320,6 +320,14 @@ static void vt_enable_smi_window(struct kvm_vcpu *vcpu)
> > > >    }
> > > >    #endif
> > > > +static bool vt_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +	if (is_td_vcpu(vcpu))
> > > > +		return true;
> > > Since for TD, INIT is always blocked, then in kvm_apic_accept_events(), the
> > > code path to handle INIT/SIPI delivery will not be called, i.e, the OPs
> > > .vcpu_deliver_init() and .vcpu_deliver_sipi_vector() are never called for
> > > TD.
> > > Seems no need to add the new interface  vcpu_deliver_init or the new wrapper
> > > vt_vcpu_deliver_sipi_vector().
> > > 
> > > And consider the INIT/SIPI for TD:
> > > - Normally, for TD, INIT ans SIPI should not be set in APIC's
> > > pending_events.
> > >    Maybe we can call KVM_BUG_ON() in vt_apic_init_signal_blocked() for TD?
> > > - If INIT and SIPI are allowed be set in APIC's pending_events for somehow,
> > > the current code has a problem, it will never clear INIT bit in APIC's
> > > pending_events.
> > >    Then kvm_apic_accept_events() needs to execute more check code if INIT was
> > > once set.
> > >    INIT bit should be cleared with this assumption.
> > 
> > KVM_SET_MP_STATE and KVM_SET_VCPU_EVENTS can set INIT/SIPI by the user space.
> > If we change those two IOCTLs to reject INIT/SIPI for TDX, we can go for the
> > above "Normally" option.  Because I didn't want to touch the common functions, I
> > ended in extra callbacks.  The user space shouldn't use those two IOCTLs for
> > TDX, though.
> 
> Even though INIT/SIPI can be set by userspace to APIC's pending_events,
> for TD, INIT is always blocked, then in kvm_apic_accept_events(), the
> code path to handle INIT/SIPI delivery will not be called, i.e, the OPs
> .vcpu_deliver_init() and .vcpu_deliver_sipi_vector() are never called for
> TD.
> 
> Can we just drop the new OPs .vcpu_deliver_init() and the new wrapper
> vt_vcpu_deliver_sipi_vector()?

Ah, you're right. We simply always block INIT/SIPI.  We should update the commit
message.  How about this?  Added option 3.

The TDX module API doesn't provide API for VMM to inject INIT IPI and SIPI.
Instead it defines the different protocols to boot application processors.
Ignore INIT and SIPI events for the TDX guest.

There are two options. 1) (silently) ignore INIT/SIPI request or 2) return
error to guest TDs somehow.  3) Always block INIT/SIPI always.
Given that TDX guest is paravirtualized to boot AP, the option 3
is chosen for simplicity.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

