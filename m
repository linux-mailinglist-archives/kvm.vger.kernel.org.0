Return-Path: <kvm+bounces-41306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19C33A65D4C
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 19:54:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D96C23A8C97
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:53:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E3701E1E02;
	Mon, 17 Mar 2025 18:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iMSpHCd/"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509131E52D
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 18:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742237642; cv=none; b=JnjtW1ChvsvrJKYpjGXHE8f5N2mk2bT15i/SXOPlM24DTKA9V+pHk4oLssHvZrLgStByNh1IIsmax1msVZdLfq5ReB06BNAwSfGV48Vydyq9CDImdyNYOkEWE32ns9tKQaCE4WxckMDxWGMMGbucW7is4qaTRL3Wugfb0sf9Sew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742237642; c=relaxed/simple;
	bh=v3IjjMSp3AskTHbHNGMF6+/6dNnwDoNYU1raEVnTz1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mn2zX5PjoLZMgkwlaNuPS60CCUcqtRwEvwhOhfj4xHMCml6JLKIKZomk9bEmbWdYoBJ54YyiiSifB+ylyDSPUN5AsR/8msesV+bDglLo7VR9sMb+Y2Sil728oj1blY5YgHOUO4lkqhqNr8k+f2gXpXfxm4wffShEKxd0jSk6uNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iMSpHCd/; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 17 Mar 2025 18:53:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742237637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ME6ZP/jpNOt4xywGEx9OKIfYPkygBSiWAxXdnIVIoMM=;
	b=iMSpHCd/LCOhDHKkQK/9qcAMjlnRhR/ZK12Y16TuHznfyuGTp8/9hR156vEyi/Cb3eMTZe
	Sj9qRixveSaQZK6wuFj2vWdehyA8l1NZzyA3dqFM2s1zIEUzMNjeTmogeIBPSfsGiXGe+X
	15/tGLAeTcmptdm0UuCJeYT3D20+eHM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Add a module param to control and enumerate
 device posted IRQs
Message-ID: <Z9hvwW2C-7_ivkPU@google.com>
References: <20250315025615.2367411-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250315025615.2367411-1-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Mar 14, 2025 at 07:56:15PM -0700, Sean Christopherson wrote:
> Add a module param to allow disabling device posted interrupts without
> having to sacrifice all of APICv/AVIC, and to also effectively enumerate
> to userspace whether or not KVM may be utilizing device posted IRQs.
> Disabling device posted interrupts is very desirable for testing, and can
> even be desirable for production environments, e.g. if the host kernel
> wants to interpose on device interrupts.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/svm/avic.c         | 3 +--
>  arch/x86/kvm/vmx/posted_intr.c  | 7 +++----
>  arch/x86/kvm/x86.c              | 9 ++++++++-
>  4 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d881e7d276b1..bf11c5ee50cb 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1922,6 +1922,7 @@ struct kvm_arch_async_pf {
>  extern u32 __read_mostly kvm_nr_uret_msrs;
>  extern bool __read_mostly allow_smaller_maxphyaddr;
>  extern bool __read_mostly enable_apicv;
> +extern bool __read_mostly enable_device_posted_irqs;
>  extern struct kvm_x86_ops kvm_x86_ops;
>  
>  #define kvm_x86_call(func) static_call(kvm_x86_##func)
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 65fd245a9953..e0f519565393 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -898,8 +898,7 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
>  	struct kvm_irq_routing_table *irq_rt;
>  	int idx, ret = 0;
>  
> -	if (!kvm_arch_has_assigned_device(kvm) ||
> -	    !irq_remapping_cap(IRQ_POSTING_CAP))
> +	if (!kvm_arch_has_assigned_device(kvm) || !enable_device_posted_irqs)

This function will now also be skipped if enable_apicv is false. Is this
always the case here for some reason? Sorry if I missed something
obvious.

>  		return 0;
>  
>  	pr_debug("SVM: %s: host_irq=%#x, guest_irq=%#x, set=%#x\n",
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index ec08fa3caf43..a03988a138c5 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -134,9 +134,8 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
>  
>  static bool vmx_can_use_vtd_pi(struct kvm *kvm)
>  {
> -	return irqchip_in_kernel(kvm) && enable_apicv &&
> -		kvm_arch_has_assigned_device(kvm) &&
> -		irq_remapping_cap(IRQ_POSTING_CAP);
> +	return irqchip_in_kernel(kvm) && enable_device_posted_irqs &&
> +	       kvm_arch_has_assigned_device(kvm);
>  }
>  
>  /*
> @@ -254,7 +253,7 @@ bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu)
>   */
>  void vmx_pi_start_assignment(struct kvm *kvm)
>  {
> -	if (!irq_remapping_cap(IRQ_POSTING_CAP))
> +	if (!enable_device_posted_irqs)

Ditto here.

>  		return;
>  
>  	kvm_make_all_cpus_request(kvm, KVM_REQ_UNBLOCK);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 69c20a68a3f0..1b14319975b7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -227,6 +227,10 @@ EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
>  bool __read_mostly enable_apicv = true;
>  EXPORT_SYMBOL_GPL(enable_apicv);
>  
> +bool __read_mostly enable_device_posted_irqs = true;
> +module_param(enable_device_posted_irqs, bool, 0444);
> +EXPORT_SYMBOL_GPL(enable_device_posted_irqs);
> +
>  const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
>  	KVM_GENERIC_VM_STATS(),
>  	STATS_DESC_COUNTER(VM, mmu_shadow_zapped),
> @@ -9772,6 +9776,9 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  	if (r != 0)
>  		goto out_mmu_exit;
>  
> +	enable_device_posted_irqs = enable_device_posted_irqs && enable_apicv &&
> +				    irq_remapping_cap(IRQ_POSTING_CAP);

Maybe this is clearer:

	enable_device_posted_irqs &= enable_avivc && irq_remapping_cap(IRQ_POSTING_CAP);

> +
>  	kvm_ops_update(ops);
>  
>  	for_each_online_cpu(cpu) {
> @@ -13552,7 +13559,7 @@ EXPORT_SYMBOL_GPL(kvm_arch_has_noncoherent_dma);
>  
>  bool kvm_arch_has_irq_bypass(void)
>  {
> -	return enable_apicv && irq_remapping_cap(IRQ_POSTING_CAP);
> +	return enable_device_posted_irqs;
>  }
>  
>  int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
> 
> base-commit: c9ea48bb6ee6b28bbc956c1e8af98044618fed5e
> -- 
> 2.49.0.rc1.451.g8f38331e32-goog
> 
> 

