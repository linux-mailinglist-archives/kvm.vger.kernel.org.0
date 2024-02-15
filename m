Return-Path: <kvm+bounces-8763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 24A378563E9
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 14:03:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C88D528A49F
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 13:03:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2423012FB29;
	Thu, 15 Feb 2024 13:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CRTGEx/j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A770212BF06;
	Thu, 15 Feb 2024 13:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708002156; cv=none; b=L2mQ4DPWuK29N3WnwoywNRIpgxzpLX3nNRF5xfgSyjVxb198OT9E8mIFmWVouajHs2U3rCwLF4tCuWOoGdUp5DSJVXiNOn7E07BfuYXe5KZN6CEmkIcsqXDquUABVTD1Uc49IUeLRgHjlLJZTYmA8p1XIUouKCZLmt7HVXbqin8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708002156; c=relaxed/simple;
	bh=rFnluREXCTsXDodZeJ12RC10HbHmX2bC2fcQYUPV5bQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nysj6F2uEfvgk80cONQPZrz98nE7qTKVutq1yFi5WzLpvlJ/UOnP38xJJ+Z9zJfeGdB4TV79fjqSJZM8PDFtaVwDC0IePv7OdwtHajiZhNof3YByJXjzYRofpSGxNxAGHGF7ggL+LMKR36H7wl9V6TbhD/H6hgFsujT9W0MptYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CRTGEx/j; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708002154; x=1739538154;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rFnluREXCTsXDodZeJ12RC10HbHmX2bC2fcQYUPV5bQ=;
  b=CRTGEx/jtbXPFdhSZh4sUI9T2F1lsYycMKmkCQescyPWJEY08dkT2RcZ
   YGbyYbkFEVARjalMhNaCTGvRUhwYVr4BZ34/p+CwgYJECGOUyLJPv+KYd
   VGTnjqaiAmfz7R78aVMsHqVxzfjjb/xP33pEDU9O0DdopdVz+REFLMZnF
   OiflknJNiP9Fr1TLX+/p5nqw0jKV0nzIVTA4HSOX4pui9GJG0EiSQZMeV
   3CNapgRqOhfNCJVgxM74IbbF60X+Lco2VgkLt4Vz4GD467RzqcpGFpNQL
   J6a3SnEGuAB0BnHl+lBFaHBlpoklOnvXx3AEpcdmEVfY77PKzMuUUco/n
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10984"; a="27534020"
X-IronPort-AV: E=Sophos;i="6.06,161,1705392000"; 
   d="scan'208";a="27534020"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2024 05:02:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,161,1705392000"; 
   d="scan'208";a="3596575"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa010.jf.intel.com with ESMTP; 15 Feb 2024 05:02:32 -0800
Date: Thu, 15 Feb 2024 20:58:43 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Li RongQing <lirongqing@baidu.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 1/2] KVM: x86: Move "KVM no-APIC vCPU" key management
 into local APIC code
Message-ID: <Zc4Kgz9et4uzlp/a@yilunxu-OptiPlex-7050>
References: <20240209222047.394389-1-seanjc@google.com>
 <20240209222047.394389-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240209222047.394389-2-seanjc@google.com>

On Fri, Feb 09, 2024 at 02:20:46PM -0800, Sean Christopherson wrote:
> Move incrementing and decrementing of kvm_has_noapic_vcpu into
> kvm_create_lapic() and kvm_free_lapic() respectively to fix a benign bug
> bug where KVM fails to decrement the count if vCPU creation ultimately
  ^

remove the duplicate word, others LGTM.

Reviewed-by: Xu Yilun <yilun.xu@linux.intel.com>

> fails, e.g. due to a memory allocation failing.
> 
> Note, the bug is benign as kvm_has_noapic_vcpu is used purely to optimize
> lapic_in_kernel() checks, and that optimization is quite dubious.  That,
> and practically speaking no setup that cares at all about performance runs
> with a userspace local APIC.
> 
> Reported-by: Li RongQing <lirongqing@baidu.com>
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/lapic.c | 27 ++++++++++++++++++++++++++-
>  arch/x86/kvm/x86.c   | 29 +++--------------------------
>  2 files changed, 29 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 3242f3da2457..681f6d82d015 100644
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
> @@ -2466,8 +2469,10 @@ void kvm_free_lapic(struct kvm_vcpu *vcpu)
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
> @@ -2809,6 +2814,11 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
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
> @@ -2844,6 +2854,21 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
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
> index b66c45e7f6f8..59119157bd20 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12053,27 +12053,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
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
> @@ -12194,8 +12176,6 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  	srcu_read_unlock(&vcpu->kvm->srcu, idx);
>  	free_page((unsigned long)vcpu->arch.pio_data);
>  	kvfree(vcpu->arch.cpuid_entries);
> -	if (!lapic_in_kernel(vcpu))
> -		static_branch_dec(&kvm_has_noapic_vcpu);
>  }
>  
>  void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> @@ -12472,9 +12452,6 @@ bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
>  	return (vcpu->arch.apic_base & MSR_IA32_APICBASE_BSP) != 0;
>  }
>  
> -__read_mostly DEFINE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
> -EXPORT_SYMBOL_GPL(kvm_has_noapic_vcpu);
> -
>  void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
>  {
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> -- 
> 2.43.0.687.g38aa6559b0-goog
> 
> 

