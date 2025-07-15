Return-Path: <kvm+bounces-52412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48A05B04E73
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 05:00:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6CF7217F61B
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 03:00:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 631DD2D1900;
	Tue, 15 Jul 2025 02:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VwigAkba"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B632D0C65;
	Tue, 15 Jul 2025 02:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752548290; cv=none; b=Gvxdtg+1+IcnXna7GQ3KTuOc9I2qezHY4hO158TIYARiAA1MKwBROIW1kB/gtS40FjkDq884S/2cwyA9/iWI2mL9lRwNd+2GvjleRkwBLxnqXn9OLyNv8x48TSiYFEdx0dx42ProJD8VICp7xt1Xo6M+/9JC91kpzwA8sEQq94U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752548290; c=relaxed/simple;
	bh=6yTgUKJorR47kxn96iQ3GqWt6LE97FTkIzEnwVaE3as=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iIGORd60U0DhaD4LgSQJKyRQrVKB7tM/7vBVFg9rnzmtXhLOHarrz+2pvWzWeQMlpIhQPK5tyVKtE6P+7ePYxcWMfHzVy2VSskD6wqgd9ZC6zeWiGy0jEhdkV7AgcX6iQ9mI5FIZxkrWrPTqtIciVnVlAPFssuEvSeKME1ebvlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VwigAkba; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752548288; x=1784084288;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6yTgUKJorR47kxn96iQ3GqWt6LE97FTkIzEnwVaE3as=;
  b=VwigAkbaszrQ2PthPacJ5nWmRbzZyYenn/Kna2YtAWmgy73lk4Phxhew
   3TRdsite5erGPzUOl6scJMXxZFJ86jCx0IRDF+4o0hKyK3g4lzx5VLSZn
   cFasdbiwYg15Ksh0TcFF4mVjuw79PHfKbBqBb08azwEfHt9kiNmurN/rW
   ej2ATBjnBOLxtuylwlIa/pm+o4pgKbsuqSlPhdgLVZBS3aJgvGWhpr9dj
   X4ihcpqH7CvHN7++7UOjPF05tIVgPqFAOCm+EE5zrNFIcZHhKyZEEeAv8
   jwz9Dsji88yJbtMKofkIWylxpH7UXQK7fUGG7hFTkalXc2GSwyqdFFTlV
   w==;
X-CSE-ConnectionGUID: +9N9OWdKSeCJ+sqwi4i99A==
X-CSE-MsgGUID: JNhesDZjSCmXug5fZKfCRQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="72331725"
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="72331725"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 19:58:07 -0700
X-CSE-ConnectionGUID: CF4GwnOOSTi92XbIzlfJ2Q==
X-CSE-MsgGUID: zeZ2AhbVTAmb4Uuu5p3PFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="157609384"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.57]) ([10.124.240.57])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 19:58:04 -0700
Message-ID: <3b37d820-12cd-4f33-b059-66e12693b779@linux.intel.com>
Date: Tue, 15 Jul 2025 10:58:01 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 04/11] KVM: x86: Add emulation support for Extented LVT
 registers
To: Manali Shukla <manali.shukla@amd.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, nikunj@amd.com, bp@alien8.de,
 peterz@infradead.org, mingo@redhat.com, mizhang@google.com,
 thomas.lendacky@amd.com, ravi.bangoria@amd.com, Sandipan.Das@amd.com
References: <20250627162550.14197-1-manali.shukla@amd.com>
 <20250627162550.14197-5-manali.shukla@amd.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250627162550.14197-5-manali.shukla@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 6/28/2025 12:25 AM, Manali Shukla wrote:
> From: Santosh Shukla <santosh.shukla@amd.com>
>
> The local interrupts are extended to include more LVT registers in
> order to allow additional interrupt sources, like Instruction Based
> Sampling (IBS) and many more.
>
> Currently there are four additional LVT registers defined and they are
> located at APIC offsets 400h-530h.
>
> AMD IBS driver is designed to use EXTLVT (Extended interrupt local
> vector table) by default for driver initialization.
>
> Extended LVT registers are required to be emulated to initialize the
> guest IBS driver successfully.
>
> Please refer to Section 16.4.5 in AMD Programmer's Manual Volume 2 at
> https://bugzilla.kernel.org/attachment.cgi?id=306250 for more details
> on Extended LVT.
>
> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> Co-developed-by: Manali Shukla <manali.shukla@amd.com>
> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
> ---
>  arch/x86/include/asm/apicdef.h | 17 +++++++++
>  arch/x86/kvm/cpuid.c           |  6 +++
>  arch/x86/kvm/lapic.c           | 69 +++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/lapic.h           |  1 +
>  arch/x86/kvm/svm/avic.c        |  4 ++
>  arch/x86/kvm/svm/svm.c         |  4 ++
>  6 files changed, 99 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
> index 094106b6a538..4c0f580578aa 100644
> --- a/arch/x86/include/asm/apicdef.h
> +++ b/arch/x86/include/asm/apicdef.h
> @@ -146,6 +146,23 @@
>  #define		APIC_EILVT_MSG_EXT	0x7
>  #define		APIC_EILVT_MASKED	(1 << 16)
>  
> +/*
> + * Initialize extended APIC registers to the default value when guest
> + * is started and EXTAPIC feature is enabled on the guest.
> + *
> + * APIC_EFEAT is a read only Extended APIC feature register, whose
> + * default value is 0x00040007. However, bits 0, 1, and 2 represent
> + * features that are not currently emulated by KVM. Therefore, these
> + * bits must be cleared during initialization. As a result, the
> + * default value used for APIC_EFEAT in KVM is 0x00040000.
> + *
> + * APIC_ECTRL is a read-write Extended APIC control register, whose
> + * default value is 0x0.
> + */
> +
> +#define		APIC_EFEAT_DEFAULT	0x00040000
> +#define		APIC_ECTRL_DEFAULT	0x0
> +
>  #define APIC_BASE (fix_to_virt(FIX_APIC_BASE))
>  #define APIC_BASE_MSR		0x800
>  #define APIC_X2APIC_ID_MSR	0x802
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index eb7be340138b..7270d22fbf31 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -458,6 +458,12 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	/* Invoke the vendor callback only after the above state is updated. */
>  	kvm_x86_call(vcpu_after_set_cpuid)(vcpu);
>  
> +	/*
> +	 * Initialize extended LVT registers at guest startup to support delivery
> +	 * of interrupts via the extended APIC space (offsets 0x400–0x530).
> +	 */
> +	kvm_apic_init_eilvt_regs(vcpu);
> +
>  	/*
>  	 * Except for the MMU, which needs to do its thing any vendor specific
>  	 * adjustments to the reserved GPA bits.
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 00ca2b0faa45..cffe44eb3f2b 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1624,9 +1624,13 @@ static inline struct kvm_lapic *to_lapic(struct kvm_io_device *dev)
>  }
>  
>  #define APIC_REG_MASK(reg)	(1ull << ((reg) >> 4))
> +#define APIC_REG_EXT_MASK(reg)	(1ull << (((reg) >> 4) - 0x40))

It seems there is no difference on the MASK definition between
APIC_REG_MASK() and APIC_REG_EXT_MASK(). Why not directly use the original
APIC_REG_MASK()?

BTW, If we indeed need to define this new macro, could we define the macro
like blow?

#define APIC_REG_EXT_MASK(reg)	(1ull << (((reg) - 0x400) >> 4))

It's more easily to understand. 


>  #define APIC_REGS_MASK(first, count) \
>  	(APIC_REG_MASK(first) * ((1ull << (count)) - 1))
>  
> +#define APIC_LAST_REG_OFFSET		0x3f0
> +#define APIC_EXT_LAST_REG_OFFSET	0x530
> +
>  u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic)
>  {
>  	/* Leave bits '0' for reserved and write-only registers. */
> @@ -1668,6 +1672,8 @@ EXPORT_SYMBOL_GPL(kvm_lapic_readable_reg_mask);
>  static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
>  			      void *data)
>  {
> +	u64 valid_reg_ext_mask = 0;
> +	unsigned int last_reg = APIC_LAST_REG_OFFSET;
>  	unsigned char alignment = offset & 0xf;
>  	u32 result;
>  
> @@ -1677,13 +1683,44 @@ static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
>  	 */
>  	WARN_ON_ONCE(apic_x2apic_mode(apic) && offset == APIC_ICR);
>  
> +	/*
> +	 * The local interrupts are extended to include LVT registers to allow
> +	 * additional interrupt sources when the EXTAPIC feature bit is enabled.
> +	 * The Extended Interrupt LVT registers are located at APIC offsets 400-530h.
> +	 */
> +	if (guest_cpu_cap_has(apic->vcpu, X86_FEATURE_EXTAPIC)) {
> +		valid_reg_ext_mask =
> +			APIC_REG_EXT_MASK(APIC_EFEAT) |
> +			APIC_REG_EXT_MASK(APIC_ECTRL) |
> +			APIC_REG_EXT_MASK(APIC_EILVTn(0)) |
> +			APIC_REG_EXT_MASK(APIC_EILVTn(1)) |
> +			APIC_REG_EXT_MASK(APIC_EILVTn(2)) |
> +			APIC_REG_EXT_MASK(APIC_EILVTn(3));
> +		last_reg = APIC_EXT_LAST_REG_OFFSET;
> +	}

Why not move this code piece into kvm_lapic_readable_reg_mask() and
directly use APIC_REG_MASK() for these extended regs? Then we don't need to
modify the below code. 


> +
>  	if (alignment + len > 4)
>  		return 1;
>  
> -	if (offset > 0x3f0 ||
> -	    !(kvm_lapic_readable_reg_mask(apic) & APIC_REG_MASK(offset)))
> +	if (offset > last_reg)
>  		return 1;
>  
> +	switch (offset) {
> +	/*
> +	 * Section 16.3.2 in the AMD Programmer's Manual Volume 2 states:
> +	 * "APIC registers are aligned to 16-byte offsets and must be accessed
> +	 * using naturally-aligned DWORD size read and writes."
> +	 */
> +	case KVM_APIC_REG_SIZE ... KVM_APIC_EXT_REG_SIZE - 16:
> +		if (!(valid_reg_ext_mask & APIC_REG_EXT_MASK(offset)))
> +			return 1;
> +		break;
> +	default:
> +		if (!(kvm_lapic_readable_reg_mask(apic) & APIC_REG_MASK(offset)))
> +			return 1;
> +
> +	}
> +
>  	result = __apic_read(apic, offset & ~0xf);
>  
>  	trace_kvm_apic_read(offset, result);
> @@ -2419,6 +2456,14 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>  		else
>  			kvm_apic_send_ipi(apic, APIC_DEST_SELF | val, 0);
>  		break;
> +
> +	case APIC_ECTRL:
> +	case APIC_EILVTn(0):
> +	case APIC_EILVTn(1):
> +	case APIC_EILVTn(2):
> +	case APIC_EILVTn(3):
> +		kvm_lapic_set_reg(apic, reg, val);
> +		break;
>  	default:
>  		ret = 1;
>  		break;
> @@ -2757,6 +2802,24 @@ void kvm_inhibit_apic_access_page(struct kvm_vcpu *vcpu)
>  	kvm_vcpu_srcu_read_lock(vcpu);
>  }
>  
> +/*
> + * Initialize extended APIC registers to the default value when guest is
> + * started. The extended APIC registers should only be initialized when the
> + * EXTAPIC feature is enabled on the guest.
> + */
> +void kvm_apic_init_eilvt_regs(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_lapic *apic = vcpu->arch.apic;
> +	int i;
> +
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_EXTAPIC)) {
> +		kvm_lapic_set_reg(apic, APIC_EFEAT, APIC_EFEAT_DEFAULT);
> +		kvm_lapic_set_reg(apic, APIC_ECTRL, APIC_ECTRL_DEFAULT);
> +		for (i = 0; i < APIC_EILVT_NR_MAX; i++)
> +			kvm_lapic_set_reg(apic, APIC_EILVTn(i), APIC_EILVT_MASKED);
> +	}
> +}
> +
>  void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
> @@ -2818,6 +2881,8 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>  		kvm_lapic_set_reg(apic, APIC_ISR + 0x10 * i, 0);
>  		kvm_lapic_set_reg(apic, APIC_TMR + 0x10 * i, 0);
>  	}
> +	kvm_apic_init_eilvt_regs(vcpu);
> +
>  	kvm_apic_update_apicv(vcpu);
>  	update_divide_count(apic);
>  	atomic_set(&apic->lapic_timer.pending, 0);
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 7ad946b3738d..ff0f9eb3417b 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -96,6 +96,7 @@ void kvm_apic_ack_interrupt(struct kvm_vcpu *vcpu, int vector);
>  int kvm_apic_accept_pic_intr(struct kvm_vcpu *vcpu);
>  int kvm_apic_accept_events(struct kvm_vcpu *vcpu);
>  void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event);
> +void kvm_apic_init_eilvt_regs(struct kvm_vcpu *vcpu);
>  u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu);
>  void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
>  void kvm_lapic_set_eoi(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 7338879d1c0c..323927fb6f57 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -682,6 +682,10 @@ static bool is_avic_unaccelerated_access_trap(u32 offset)
>  	case APIC_LVTERR:
>  	case APIC_TMICT:
>  	case APIC_TDCR:
> +	case APIC_EILVTn(0):
> +	case APIC_EILVTn(1):
> +	case APIC_EILVTn(2):
> +	case APIC_EILVTn(3):
>  		ret = true;
>  		break;
>  	default:
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index fffc3320ea00..f9a7ff37ea10 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -791,6 +791,10 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
>  		X2APIC_MSR(APIC_TMICT),
>  		X2APIC_MSR(APIC_TMCCT),
>  		X2APIC_MSR(APIC_TDCR),
> +		X2APIC_MSR(APIC_EILVTn(0)),
> +		X2APIC_MSR(APIC_EILVTn(1)),
> +		X2APIC_MSR(APIC_EILVTn(2)),
> +		X2APIC_MSR(APIC_EILVTn(3)),
>  	};
>  	int i;
>  

