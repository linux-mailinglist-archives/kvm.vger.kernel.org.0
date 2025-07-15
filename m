Return-Path: <kvm+bounces-52410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D39CB04DCD
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 04:22:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB0151AA3AB1
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 02:22:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96DB12D0278;
	Tue, 15 Jul 2025 02:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NldwZkVw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FFB2C3274;
	Tue, 15 Jul 2025 02:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752546127; cv=none; b=st2jXQP1mKSDQDVKm7LEjXubCggAMkbKJu4o5FTvaybAFZPAvb2Skp+XamoapDdUi6tQ6a55btGssgrrOIk0nwaxbJYeOPpp7qT6WUlwWHrZGUXaD7R2WfuJBK95jX3dpwMIMrUks0XmD70QyxNlsKmZtXDG+gHmbGpFZC8j0K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752546127; c=relaxed/simple;
	bh=VoIDI81IF1mhhatNTQ8YKevKRHp5bKCm0PTI8ZSA4PU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LopGrLjdl/SgAj1dzDNoXi0QmqjNFpUNSOYA9DC2dVLD4eEYBTF8SjLAEON3pzhC7O3x553KnPigMN3fjmhWU4ClP9guDU0DuRcvBh7R9pmlGLEHB0xO+pYn41VDgU0cCgzKykZ3lMoNMmSWdVkT1ZTIjZA2fGSfhuhOYvnRDXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NldwZkVw; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752546125; x=1784082125;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VoIDI81IF1mhhatNTQ8YKevKRHp5bKCm0PTI8ZSA4PU=;
  b=NldwZkVwyRSXzdDv/1cEOtWQNfkrw9M0Pjl4zOluHVcEvJuYjeLU3a4w
   G/JPtUscxLD+qNJJL0pa1OS39L7nIRFKKhJq85USP7Z34vtVDI0P5Lkde
   oWWcjZIlYPeHU3IzUb1HgWCDWcQswSrVqEfq0leYSMtkoWLqW9/vchLeB
   E3Q6cycoZmG6q2BpwJK3GTDzOMahWyLG3/jVpIckboMg4lsyQA6NOd0GP
   m0RSATkl+qXBPI7VFX35YIY8+8yWbEKlu/rRwyoFA9DwA6UCmBfYxEro7
   wwZyFfby7teeNWK6RVQdvjfLRJp38s5+zNzVvKNgNaghYP8taAthexIwP
   g==;
X-CSE-ConnectionGUID: U6Al39TQTNCFH9uo9TU5eQ==
X-CSE-MsgGUID: kL2jOphzT5G3TWQFMq+Q7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="66202883"
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="66202883"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 19:22:04 -0700
X-CSE-ConnectionGUID: m8NdxOPgTZqYskL23oqUnQ==
X-CSE-MsgGUID: zTe4wbnlSRG/z7AiMP3+wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="157814824"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.57]) ([10.124.240.57])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 19:22:00 -0700
Message-ID: <03934334-a4b6-4c9f-ad99-5f8041836065@linux.intel.com>
Date: Tue, 15 Jul 2025 10:21:58 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 02/11] KVM: Add KVM_GET_LAPIC_W_EXTAPIC and
 KVM_SET_LAPIC_W_EXTAPIC for extapic
To: Manali Shukla <manali.shukla@amd.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, nikunj@amd.com, bp@alien8.de,
 peterz@infradead.org, mingo@redhat.com, mizhang@google.com,
 thomas.lendacky@amd.com, ravi.bangoria@amd.com, Sandipan.Das@amd.com
References: <20250627162550.14197-1-manali.shukla@amd.com>
 <20250627162550.14197-3-manali.shukla@amd.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250627162550.14197-3-manali.shukla@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 6/28/2025 12:25 AM, Manali Shukla wrote:
> Modern AMD processors expose four additional extended LVT registers in
> the extended APIC register space, which can be used for additional
> interrupt sources such as instruction-based sampling and others.
>
> To support this, introduce two new vCPU-based IOCTLs:
> KVM_GET_LAPIC_W_EXTAPIC and KVM_SET_LAPIC_W_EXTAPIC. These IOCTLs works
> similarly to KVM_GET_LAPIC and KVM_SET_LAPIC, but operate on APIC page
> with extended APIC register space located at APIC offsets 400h-530h.
>
> These IOCTLs are intended for use when extended APIC support is
> enabled in the guest. They allow saving and restoring the full APIC
> page, including the extended registers.
>
> To support this, the `struct kvm_lapic_state_w_extapic` has been made
> extensible rather than hardcoding its size, improving forward
> compatibility.
>
> Documentation for the new IOCTLs has also been added.
>
> For more details on the extended APIC space, refer to AMD Programmer’s
> Manual Volume 2, Section 16.4.5: Extended Interrupts.
> https://bugzilla.kernel.org/attachment.cgi?id=306250
>
> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
> ---
>  Documentation/virt/kvm/api.rst  | 23 ++++++++++++++++++++
>  arch/x86/include/uapi/asm/kvm.h |  5 +++++
>  arch/x86/kvm/lapic.c            | 12 ++++++-----
>  arch/x86/kvm/lapic.h            |  6 ++++--
>  arch/x86/kvm/x86.c              | 37 ++++++++++++++++++++++++---------
>  include/uapi/linux/kvm.h        | 10 +++++++++
>  6 files changed, 76 insertions(+), 17 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 1bd2d42e6424..0ca11d43f833 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -2041,6 +2041,18 @@ error.
>  Reads the Local APIC registers and copies them into the input argument.  The
>  data format and layout are the same as documented in the architecture manual.
>  
> +::
> +
> +  #define KVM_APIC_EXT_REG_SIZE 0x540
> +  struct kvm_lapic_state_w_extapic {
> +	__DECLARE_FLEX_ARRAY(__u8, regs);
> +  };
> +
> +Applications should use KVM_GET_LAPIC_W_EXTAPIC ioctl if extended APIC is
> +enabled. KVM_GET_LAPIC_W_EXTAPIC reads Local APIC registers with extended
> +APIC register space located at offsets 400h-530h and copies them into input
> +argument.
> +
>  If KVM_X2APIC_API_USE_32BIT_IDS feature of KVM_CAP_X2APIC_API is
>  enabled, then the format of APIC_ID register depends on the APIC mode
>  (reported by MSR_IA32_APICBASE) of its VCPU.  x2APIC stores APIC ID in
> @@ -2072,6 +2084,17 @@ always uses xAPIC format.
>  Copies the input argument into the Local APIC registers.  The data format
>  and layout are the same as documented in the architecture manual.
>  
> +::
> +
> +  #define KVM_APIC_EXT_REG_SIZE 0x540
> +  struct kvm_lapic_state_w_extapic {
> +	__DECLARE_FLEX_ARRAY(__u8, regs);
> +  };
> +
> +Applications should use KVM_SET_LAPIC_W_EXTAPIC ioctl if extended APIC is enabled.
> +KVM_SET_LAPIC_W_EXTAPIC copies input arguments with extended APIC register into
> +Local APIC and extended APIC registers.
> +
>  The format of the APIC ID register (bytes 32-35 of struct kvm_lapic_state's
>  regs field) depends on the state of the KVM_CAP_X2APIC_API capability.
>  See the note in KVM_GET_LAPIC.
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 6f3499507c5e..91c3c5b8cae3 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -124,6 +124,11 @@ struct kvm_lapic_state {
>  	char regs[KVM_APIC_REG_SIZE];
>  };
>  
> +#define KVM_APIC_EXT_REG_SIZE 0x540
> +struct kvm_lapic_state_w_extapic {
> +	__DECLARE_FLEX_ARRAY(__u8, regs);
> +};

The name "kvm_lapic_state_w_extapic" seems a little bit too long, maybe
"kvm_ext_lapic_state" is enough?


> +
>  struct kvm_segment {
>  	__u64 base;
>  	__u32 limit;
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 73418dc0ebb2..00ca2b0faa45 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -3046,7 +3046,7 @@ void kvm_apic_ack_interrupt(struct kvm_vcpu *vcpu, int vector)
>  EXPORT_SYMBOL_GPL(kvm_apic_ack_interrupt);
>  
>  static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
> -		struct kvm_lapic_state *s, bool set)
> +		struct kvm_lapic_state_w_extapic *s, bool set)
>  {
>  	if (apic_x2apic_mode(vcpu->arch.apic)) {
>  		u32 x2apic_id = kvm_x2apic_id(vcpu->arch.apic);
> @@ -3097,9 +3097,10 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> -int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
> +int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state_w_extapic *s,
> +		       unsigned int size)
>  {
> -	memcpy(s->regs, vcpu->arch.apic->regs, sizeof(*s));
> +	memcpy(s->regs, vcpu->arch.apic->regs, size);
>  
>  	/*
>  	 * Get calculated timer current count for remaining timer period (if
> @@ -3111,7 +3112,8 @@ int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
>  	return kvm_apic_state_fixup(vcpu, s, false);
>  }
>  
> -int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
> +int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state_w_extapic *s,
> +		       unsigned int size)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  	int r;
> @@ -3126,7 +3128,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
>  		kvm_recalculate_apic_map(vcpu->kvm);
>  		return r;
>  	}
> -	memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
> +	memcpy(vcpu->arch.apic->regs, s->regs, size);
>  
>  	atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
>  	kvm_recalculate_apic_map(vcpu->kvm);
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 4518b4e0552f..7ad946b3738d 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -120,9 +120,11 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
>  void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high);
>  
>  int kvm_apic_set_base(struct kvm_vcpu *vcpu, u64 value, bool host_initiated);
> -int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
> -int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
>  void kvm_apic_update_hwapic_isr(struct kvm_vcpu *vcpu);
> +int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state_w_extapic *s,
> +		       unsigned int size);
> +int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state_w_extapic *s,
> +		       unsigned int size);
>  int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu);
>  
>  u64 kvm_get_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c880a512005e..c273bbbbbcc6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5156,25 +5156,25 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  }
>  
>  static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
> -				    struct kvm_lapic_state *s)
> +				    struct kvm_lapic_state_w_extapic *s, unsigned int size)
>  {
>  	if (vcpu->arch.apic->guest_apic_protected)
>  		return -EINVAL;
>  
>  	kvm_x86_call(sync_pir_to_irr)(vcpu);
>  
> -	return kvm_apic_get_state(vcpu, s);
> +	return kvm_apic_get_state(vcpu, s, size);
>  }
>  
>  static int kvm_vcpu_ioctl_set_lapic(struct kvm_vcpu *vcpu,
> -				    struct kvm_lapic_state *s)
> +				    struct kvm_lapic_state_w_extapic *s, unsigned int size)
>  {
>  	int r;
>  
>  	if (vcpu->arch.apic->guest_apic_protected)
>  		return -EINVAL;
>  
> -	r = kvm_apic_set_state(vcpu, s);
> +	r = kvm_apic_set_state(vcpu, s, size);
>  	if (r)
>  		return r;
>  	update_cr8_intercept(vcpu);
> @@ -5903,10 +5903,11 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  {
>  	struct kvm_vcpu *vcpu = filp->private_data;
>  	void __user *argp = (void __user *)arg;
> +	unsigned long size;
>  	int r;
>  	union {
>  		struct kvm_sregs2 *sregs2;
> -		struct kvm_lapic_state *lapic;
> +		struct kvm_lapic_state_w_extapic *lapic;
>  		struct kvm_xsave *xsave;
>  		struct kvm_xcrs *xcrs;
>  		void *buffer;
> @@ -5916,35 +5917,51 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  
>  	u.buffer = NULL;
>  	switch (ioctl) {
> +	case KVM_GET_LAPIC_W_EXTAPIC:
>  	case KVM_GET_LAPIC: {
>  		r = -EINVAL;
>  		if (!lapic_in_kernel(vcpu))
>  			goto out;
> -		u.lapic = kzalloc(sizeof(struct kvm_lapic_state), GFP_KERNEL);
> +
> +		if (ioctl == KVM_GET_LAPIC_W_EXTAPIC)
> +			size = struct_size(u.lapic, regs, KVM_APIC_EXT_REG_SIZE);
> +		else
> +			size = sizeof(struct kvm_lapic_state);
> +
> +		u.lapic = kzalloc(size, GFP_KERNEL);
>  
>  		r = -ENOMEM;
>  		if (!u.lapic)
>  			goto out;
> -		r = kvm_vcpu_ioctl_get_lapic(vcpu, u.lapic);
> +		r = kvm_vcpu_ioctl_get_lapic(vcpu, u.lapic, size);
>  		if (r)
>  			goto out;
> +
>  		r = -EFAULT;
> -		if (copy_to_user(argp, u.lapic, sizeof(struct kvm_lapic_state)))
> +		if (copy_to_user(argp, u.lapic, size))
>  			goto out;
> +
>  		r = 0;
>  		break;
>  	}
> +	case KVM_SET_LAPIC_W_EXTAPIC:
>  	case KVM_SET_LAPIC: {
>  		r = -EINVAL;
>  		if (!lapic_in_kernel(vcpu))
>  			goto out;
> -		u.lapic = memdup_user(argp, sizeof(*u.lapic));
> +
> +		if (ioctl == KVM_SET_LAPIC_W_EXTAPIC)
> +			size = struct_size(u.lapic, regs, KVM_APIC_EXT_REG_SIZE);
> +		else
> +			size = sizeof(struct kvm_lapic_state);
> +		u.lapic = memdup_user(argp, size);
> +
>  		if (IS_ERR(u.lapic)) {
>  			r = PTR_ERR(u.lapic);
>  			goto out_nofree;
>  		}
>  
> -		r = kvm_vcpu_ioctl_set_lapic(vcpu, u.lapic);
> +		r = kvm_vcpu_ioctl_set_lapic(vcpu, u.lapic, size);
>  		break;
>  	}
>  	case KVM_INTERRUPT: {
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index d00b85cb168c..cf23c1b52c49 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1290,6 +1290,16 @@ struct kvm_vfio_spapr_tce {
>  #define KVM_SET_FPU               _IOW(KVMIO,  0x8d, struct kvm_fpu)
>  #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
>  #define KVM_SET_LAPIC             _IOW(KVMIO,  0x8f, struct kvm_lapic_state)
> +/*
> + * Added to save/restore local APIC registers with extended APIC (extapic)
> + * register space.
> + *
> + * Qemu emulates extapic logic only when KVM enables extapic functionality via
> + * KVM capability. In the condition where Qemu sets extapic registers, but KVM doesn't
> + * set extapic capability, Qemu ends up using KVM_GET_LAPIC and KVM_SET_LAPIC.
> + */
> +#define KVM_GET_LAPIC_W_EXTAPIC   _IOR(KVMIO,  0x8e, struct kvm_lapic_state_w_extapic)
> +#define KVM_SET_LAPIC_W_EXTAPIC   _IOW(KVMIO,  0x8f, struct kvm_lapic_state_w_extapic)
>  #define KVM_SET_CPUID2            _IOW(KVMIO,  0x90, struct kvm_cpuid2)
>  #define KVM_GET_CPUID2            _IOWR(KVMIO, 0x91, struct kvm_cpuid2)
>  /* Available with KVM_CAP_VAPIC */

