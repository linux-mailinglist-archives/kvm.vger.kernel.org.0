Return-Path: <kvm+bounces-29750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C19E39B18CF
	for <lists+kvm@lfdr.de>; Sat, 26 Oct 2024 16:53:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F05DC1C20DED
	for <lists+kvm@lfdr.de>; Sat, 26 Oct 2024 14:53:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F31F622612;
	Sat, 26 Oct 2024 14:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IDXAYO04"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7417D2746C
	for <kvm@vger.kernel.org>; Sat, 26 Oct 2024 14:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729954396; cv=none; b=MGahjcNGV4g9wqTwJS9Y2fhRmfskE1uO7HULizhwoiP76HGLiqCcSm3mEjx/W1zIP/gGmI0aL5G6uwka+k0VIVOE5hx2+ZdY3bKulYX6DjGm56G3lgcnmHpn9T1EEVH9xUw9/wZkI28WnuGzqVhc9+GypPlLnk7OtcTeDQAw5n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729954396; c=relaxed/simple;
	bh=0ZAutvhhGaFlmj1XmFap9brpWl2bniA/D2BddoTQ/jM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jlPbLx2NZBtkoAd6ZGwyEZWq3lSXqViIgRLAQBZ75IDSx39x7x+NjX8AARMMjfe2exhLWoytmcAvnQaixApWaPlqJDm4/apks4AEBjE7BKypVxAUfY9cnhOF3dUTAz0DgiDngqQ3O0xQ0uxVCSeb2bcj44UX+lu8qm9PrwQ+x2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IDXAYO04; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sat, 26 Oct 2024 07:53:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729954390;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f6oEY5I2mn6JavjYEYeWI4XafhLDooXmCGvLmqMJIxw=;
	b=IDXAYO04odV2PC/0FFjwWPsKKHzqtlkfTZw+5+KuPl8w5Mo++yXHzLsZTEF+ZR0DNjAfqL
	zSWPUbrqLaREWWiScSQsS5jxMFGdimkChYtRQ3L6M0S4/mZk4JHQiWuyT1ybNlLbsQlnI0
	vAy0Oz+0NMusUx+JOGzqoh6uH80Rnlw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH] KVM: arm64: Mark the VM as dead for failed
 initializations
Message-ID: <Zx0CT1gdSWVyKLuD@linux.dev>
References: <20241025221220.2985227-1-rananta@google.com>
 <Zxx_X9-MdmAFzHUO@linux.dev>
 <87ttcztili.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ttcztili.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Oct 26, 2024 at 08:43:21AM +0100, Marc Zyngier wrote:
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index bf64fed9820e..c315bc1a4e9a 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -74,8 +74,6 @@ enum kvm_mode kvm_get_mode(void);
>  static inline enum kvm_mode kvm_get_mode(void) { return KVM_MODE_NONE; };
>  #endif
>  
> -DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
> -
>  extern unsigned int __ro_after_init kvm_sve_max_vl;
>  extern unsigned int __ro_after_init kvm_host_sve_max_vl;
>  int __init kvm_arm_init_sve(void);
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 879982b1cc73..1215df590418 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -206,8 +206,7 @@ void get_timer_map(struct kvm_vcpu *vcpu, struct timer_map *map)
>  
>  static inline bool userspace_irqchip(struct kvm *kvm)
>  {
> -	return static_branch_unlikely(&userspace_irqchip_in_use) &&
> -		unlikely(!irqchip_in_kernel(kvm));
> +	return unlikely(!irqchip_in_kernel(kvm));
>  }
>  
>  static void soft_timer_start(struct hrtimer *hrt, u64 ns)
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 48cafb65d6ac..70ff9a20ef3a 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -69,7 +69,6 @@ DECLARE_KVM_NVHE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
>  static bool vgic_present, kvm_arm_initialised;
>  
>  static DEFINE_PER_CPU(unsigned char, kvm_hyp_initialized);
> -DEFINE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
>  
>  bool is_kvm_arm_initialised(void)
>  {
> @@ -503,9 +502,6 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>  
>  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  {
> -	if (vcpu_has_run_once(vcpu) && unlikely(!irqchip_in_kernel(vcpu->kvm)))
> -		static_branch_dec(&userspace_irqchip_in_use);
> -
>  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
>  	kvm_timer_vcpu_terminate(vcpu);
>  	kvm_pmu_vcpu_destroy(vcpu);
> @@ -848,14 +844,6 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
>  			return ret;
>  	}
>  
> -	if (!irqchip_in_kernel(kvm)) {
> -		/*
> -		 * Tell the rest of the code that there are userspace irqchip
> -		 * VMs in the wild.
> -		 */
> -		static_branch_inc(&userspace_irqchip_in_use);
> -	}
> -
>  	/*
>  	 * Initialize traps for protected VMs.
>  	 * NOTE: Move to run in EL2 directly, rather than via a hypercall, once
> @@ -1077,7 +1065,7 @@ static bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu, int *ret)
>  	 * state gets updated in kvm_timer_update_run and
>  	 * kvm_pmu_update_run below).
>  	 */
> -	if (static_branch_unlikely(&userspace_irqchip_in_use)) {
> +	if (unlikely(!irqchip_in_kernel(vcpu->kvm))) {
>  		if (kvm_timer_should_notify_user(vcpu) ||
>  		    kvm_pmu_should_notify_user(vcpu)) {
>  			*ret = -EINTR;
> @@ -1199,7 +1187,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  			vcpu->mode = OUTSIDE_GUEST_MODE;
>  			isb(); /* Ensure work in x_flush_hwstate is committed */
>  			kvm_pmu_sync_hwstate(vcpu);
> -			if (static_branch_unlikely(&userspace_irqchip_in_use))
> +			if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
>  				kvm_timer_sync_user(vcpu);
>  			kvm_vgic_sync_hwstate(vcpu);
>  			local_irq_enable();
> @@ -1245,7 +1233,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  		 * we don't want vtimer interrupts to race with syncing the
>  		 * timer virtual interrupt state.
>  		 */
> -		if (static_branch_unlikely(&userspace_irqchip_in_use))
> +		if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
>  			kvm_timer_sync_user(vcpu);
>  
>  		kvm_arch_vcpu_ctxsync_fp(vcpu);
> 
> I think this would fix the problem you're seeing without changing the
> userspace view of an erroneous configuration. It would also pave the
> way for the complete removal of the interrupt notification to
> userspace, which I claim has no user and is just a shit idea.

Yeah, looks like this ought to get it done.

Even with a fix for this particular issue I do wonder if we should
categorically harden against late initialization failures and un-init
the vCPU (or bug VM, where necessary) to avoid dealing with half-baked
vCPUs/VMs across our UAPI surfaces.

A sane userspace will probably crash when KVM_RUN returns EINVAL anyway.

-- 
Thanks,
Oliver

