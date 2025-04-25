Return-Path: <kvm+bounces-44321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D0AEA9CA24
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 15:26:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E70A1BA4EB7
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 13:26:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1AED25228A;
	Fri, 25 Apr 2025 13:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="M3O/0FPm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC6B78F2D
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 13:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745587573; cv=none; b=LpBWi+shgJj34G5vyM8MCeFannfvfZpNsXbfPecbnZxdG6whu3X8w8OH5VFWnoP3xsXe57CozlNlgj6R2E9adASyMfwgPyHgHhiyOB8DJTLcJZ9AioBCklIEblitj+E46ySp7zWv7F2l6IQdhlboPVL2wNiS0sNFwV4nCJgc+gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745587573; c=relaxed/simple;
	bh=j7KaWQjb0PncCTrObU98DGteOGAKCmk9pRp7BnXKXsA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RvhE+TB+p0BoDg9HdAOVrWGaZm4AWQjLMILdukIkkJPEomJ533utahUjXaR9HFQBIh8OsU5fuXDLibsd6/m54mtrhTn0iknZ0RtybxYabf0/sUYLBvk7v6ZFkF32xkf9i5LY4mBcXpQ62nH5JjhfaDOlezDv5SUMWXGF9d8N7lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=M3O/0FPm; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3913958ebf2so1745675f8f.3
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 06:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745587569; x=1746192369; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TvlFep0NPTyeHOqXKhU3kd0cu/zjg3rVdkJdrD1m0V0=;
        b=M3O/0FPmKufPGBttCeDM9qAKBjfCMh8j2t51JyKw5Ec6Yvse7VWKZP4OcPSANMMMr6
         dqaPa1XiVkIKIcMbZ//mm1M5jCeMZ0lr1RGuxmG8BikHEg23+eE3JWhkhnk/QX+jGd3V
         67OVElPxAquNyQAHVfrqIYhu32aoNjmkBQ2Sa9uDzIdy+Ob6by94M6EK7F1Bmvzu5fK8
         RuQgbyPWXxKTtrCZoNfvV6b+uvEsjl2EeDXPvIit4am8DIfMfuL4Iq3iPWNUR8saH2k8
         0tKiuKkH6fX4gtGaJlhlRZO/14ykP3fCmo9HdhcYmwLSiTwPONwYTX012qRAjm/rLJvP
         VxUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745587569; x=1746192369;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TvlFep0NPTyeHOqXKhU3kd0cu/zjg3rVdkJdrD1m0V0=;
        b=Ain6YFCgsQXZKSUZsKOiB/IiorFb910xZ5SRgB0KHnfwT1uWcbKNUNGv74Xh9oaDUv
         NDIkEb/qAfX4G2M8Oqo10hLeYugKl9GzXMiIN3VpCVp0tFcTCGR4rVsZH7oVAtRmfxMo
         l7vFnt4fJfqq6PigJJq2RuhnGDO3nnBexuvnGwxp5XeGpJPjXdu3O7Y0md+QKk1IPD9F
         i1iLN/TnhV5u5amMeaIpI4ar0VZMjwRBa1ZmjadGqPy/Izce7DOVdJXIfQMBssHLwmjb
         WUjT9pEQju5uTzGYAQsYTHu1UWw3SfkTwtRDvKQSWwrCXipZCkihmsJ4iPekOZnY2y4r
         dRNQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9rNNnsEdqvNbHq2ByzYDDXLTV01tp2sNGlRHJ0eze+a+ygYgIDB4fjiRCb7ChLt8jfHE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9QZOkFaZKpf9Fvo2oomJOpthawlArhAC3xGX8iQ+rUt9C1uJD
	2W5t+RlcEBtDsyROktrccysJBAfrTZtlmVU28CWmcKnKjYgUaGMIQD3Sx/wJ5jo=
X-Gm-Gg: ASbGnct7+vflorcJiEjY+iarcGF/vIM2uzkQZcp0XBkQnjnD5WjCCEvGNAIZfUGZ8P7
	NNOScbqKpN6ufineT7HVJ1hV6Ew2uqx2FyPjTflb5SpInBRixPa5ieWFVd81vGFFWp7tH7LW99E
	BgLA2ki80t2grgoreAmS3QYf84niAD0gZBtLINDptwSw7mPC5KNxPqJ30gKBqAK0EZxQd0Pxn0I
	7aAB2IOVKMiJj3ijiZ4yQzipyhu3KuhkIRVtGEUq8rP8a5h4NQXcm9A3WucfyQZgj3HmRY4/2Rw
	AMFXcVSv783FdN7hqzMtTdgxvoop
X-Google-Smtp-Source: AGHT+IHAbwTDTK6qggDHRlhV93l9pLMtShZ8GEckKUdC0DHFBCYPix0OUA97YQ1vX0PSGamSi/CZFQ==
X-Received: by 2002:a05:6000:2505:b0:38f:6287:6474 with SMTP id ffacd0b85a97d-3a074e1d88amr1847317f8f.15.1745587569386;
        Fri, 25 Apr 2025 06:26:09 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::f716])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a073e46976sm2369788f8f.63.2025.04.25.06.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Apr 2025 06:26:08 -0700 (PDT)
Date: Fri, 25 Apr 2025 15:26:08 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Mayuresh Chitale <mchitale@ventanamicro.com>
Subject: Re: [PATCH 4/5] KVM: RISC-V: reset VCPU state when becoming runnable
Message-ID: <20250425-2bc11e21ecef7269702c424e@orel>
References: <20250403112522.1566629-3-rkrcmar@ventanamicro.com>
 <20250403112522.1566629-7-rkrcmar@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250403112522.1566629-7-rkrcmar@ventanamicro.com>

On Thu, Apr 03, 2025 at 01:25:23PM +0200, Radim Krčmář wrote:
> Beware, this patch is "breaking" the userspace interface, because it
> fixes a KVM/QEMU bug where the boot VCPU is not being reset by KVM.
> 
> The VCPU reset paths are inconsistent right now.  KVM resets VCPUs that
> are brought up by KVM-accelerated SBI calls, but does nothing for VCPUs
> brought up through ioctls.

I guess we currently expect userspace to make a series of set-one-reg
ioctls in order to prepare ("reset") newly created vcpus, and I guess
the problem is that KVM isn't capturing the resulting configuration
in order to replay it when SBI HSM reset is invoked by the guest. But,
instead of capture-replay we could just exit to userspace on an SBI
HSM reset call and let userspace repeat what it did at vcpu-create
time.

> 
> We need to perform a KVM reset even when the VCPU is started through an
> ioctl.  This patch is one of the ways we can achieve it.
> 
> Assume that userspace has no business setting the post-reset state.
> KVM is de-facto the SBI implementation, as the SBI HSM acceleration
> cannot be disabled and userspace cannot control the reset state, so KVM
> should be in full control of the post-reset state.
> 
> Do not reset the pc and a1 registers, because SBI reset is expected to
> provide them and KVM has no idea what these registers should be -- only
> the userspace knows where it put the data.

s/userspace/guest/

> 
> An important consideration is resume.  Userspace might want to start
> with non-reset state.  Check ran_atleast_once to allow this, because
> KVM-SBI HSM creates some VCPUs as STOPPED.
> 
> The drawback is that userspace can still start the boot VCPU with an
> incorrect reset state, because there is no way to distinguish a freshly
> reset new VCPU on the KVM side (userspace might set some values by
> mistake) from a restored VCPU (userspace must set all values).

If there's a correct vs. incorrect reset state that KVM needs to enforce,
then we'll need a different API than just a bunch of set-one-reg calls,
or set/get-one-reg should be WARL for userpace.

> 
> The advantage of this solution is that it fixes current QEMU and makes
> some sense with the assumption that KVM implements SBI HSM.
> I do not like it too much, so I'd be in favor of a different solution if
> we can still afford to drop support for current userspaces.
> 
> For a cleaner solution, we should add interfaces to perform the KVM-SBI
> reset request on userspace demand.

That's what the change to kvm_arch_vcpu_ioctl_set_mpstate() in this
patch is providing, right?

> I think it would also be much better
> if userspace was in control of the post-reset state.

Agreed. Can we just exit to userspace on SBI HSM reset?

Thanks,
drew

> 
> Signed-off-by: Radim Krčmář <rkrcmar@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_host.h     |  1 +
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |  3 +++
>  arch/riscv/kvm/vcpu.c                 |  9 +++++++++
>  arch/riscv/kvm/vcpu_sbi.c             | 21 +++++++++++++++++++--
>  4 files changed, 32 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 0c8c9c05af91..9bbf8c4a286b 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -195,6 +195,7 @@ struct kvm_vcpu_smstateen_csr {
>  
>  struct kvm_vcpu_reset_state {
>  	spinlock_t lock;
> +	bool active;
>  	unsigned long pc;
>  	unsigned long a1;
>  };
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> index aaaa81355276..2c334a87e02a 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -57,6 +57,9 @@ void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
>  				     u32 type, u64 flags);
>  void kvm_riscv_vcpu_sbi_request_reset(struct kvm_vcpu *vcpu,
>                                        unsigned long pc, unsigned long a1);
> +void __kvm_riscv_vcpu_set_reset_state(struct kvm_vcpu *vcpu,
> +                                      unsigned long pc, unsigned long a1);
> +void kvm_riscv_vcpu_sbi_request_reset_from_userspace(struct kvm_vcpu *vcpu);
>  int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  int kvm_riscv_vcpu_set_reg_sbi_ext(struct kvm_vcpu *vcpu,
>  				   const struct kvm_one_reg *reg);
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index b8485c1c1ce4..4578863a39e3 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -58,6 +58,11 @@ static void kvm_riscv_vcpu_context_reset(struct kvm_vcpu *vcpu)
>  	struct kvm_vcpu_reset_state *reset_state = &vcpu->arch.reset_state;
>  	void *vector_datap = cntx->vector.datap;
>  
> +	spin_lock(&reset_state->lock);
> +	if (!reset_state->active)
> +		__kvm_riscv_vcpu_set_reset_state(vcpu, cntx->sepc, cntx->a1);
> +	spin_unlock(&reset_state->lock);
> +
>  	memset(cntx, 0, sizeof(*cntx));
>  	memset(csr, 0, sizeof(*csr));
>  
> @@ -520,6 +525,10 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
>  
>  	switch (mp_state->mp_state) {
>  	case KVM_MP_STATE_RUNNABLE:
> +		if (riscv_vcpu_supports_sbi_ext(vcpu, KVM_RISCV_SBI_EXT_HSM) &&
> +				vcpu->arch.ran_atleast_once &&
> +				kvm_riscv_vcpu_stopped(vcpu))
> +			kvm_riscv_vcpu_sbi_request_reset_from_userspace(vcpu);
>  		WRITE_ONCE(vcpu->arch.mp_state, *mp_state);
>  		break;
>  	case KVM_MP_STATE_STOPPED:
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index 3d7955e05cc3..77f9f0bd3842 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -156,12 +156,29 @@ void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
>  	run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
>  }
>  
> +/* must be called with held vcpu->arch.reset_state.lock */
> +void __kvm_riscv_vcpu_set_reset_state(struct kvm_vcpu *vcpu,
> +                                      unsigned long pc, unsigned long a1)
> +{
> +	vcpu->arch.reset_state.active = true;
> +	vcpu->arch.reset_state.pc = pc;
> +	vcpu->arch.reset_state.a1 = a1;
> +}
> +
>  void kvm_riscv_vcpu_sbi_request_reset(struct kvm_vcpu *vcpu,
>                                        unsigned long pc, unsigned long a1)
>  {
>  	spin_lock(&vcpu->arch.reset_state.lock);
> -	vcpu->arch.reset_state.pc = pc;
> -	vcpu->arch.reset_state.a1 = a1;
> +	__kvm_riscv_vcpu_set_reset_state(vcpu, pc, a1);
> +	spin_unlock(&vcpu->arch.reset_state.lock);
> +
> +	kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> +}
> +
> +void kvm_riscv_vcpu_sbi_request_reset_from_userspace(struct kvm_vcpu *vcpu)
> +{
> +	spin_lock(&vcpu->arch.reset_state.lock);
> +	vcpu->arch.reset_state.active = false;
>  	spin_unlock(&vcpu->arch.reset_state.lock);
>  
>  	kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> -- 
> 2.48.1
> 

