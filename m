Return-Path: <kvm+bounces-33735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 995F19F113B
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 16:45:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53994282B11
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 15:45:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0927084039;
	Fri, 13 Dec 2024 15:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KosRSCVU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0A92F24;
	Fri, 13 Dec 2024 15:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734104726; cv=none; b=FJHbaNRu5KMb2J5Pim2padqO3V0JpXbcMV8ctSRm/53YIIHlDfdMn4zNC3f6GU5aCGHEDmtCs+05/AXOWDvGxL0A40UQTn9p1d6l1VO1ZUABH8dEgijfKtn/7BbZBM+DG8QHMS9YfGZMEhf15hEmnh+fGG/OFiBfZcI6/hF9W8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734104726; c=relaxed/simple;
	bh=xJoYe5vrmmbHTTi0nrGcuHUklhFZyM7mMxzk9AlTj9k=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=XIBC5PU4dSqKWHrVIoA3qv+mV1VUVGo/Du9XrcGgToBCt/4/1TERnJ7jpCs/W2kVIcXora1VIaHC/dIcYsuB75QwhV+gJqgjotgfVfV9fiegMK0jmFY2AREI8+2bXMa/1wZljBjXQxE9TBQmXS0DUp8Y97eGbSvyhTQn14r3Z7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KosRSCVU; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734104723; x=1765640723;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=xJoYe5vrmmbHTTi0nrGcuHUklhFZyM7mMxzk9AlTj9k=;
  b=KosRSCVUbPGZA82pjT9KSOZ9IOB+0+7IhNRjuE6UoYKDCJFP1gUDDXD7
   I6RFlCFMXVN+q2lN/rEIfiKxXH2UqO6oNGhy8npUEqYDiDPvtEn3+t3Y9
   5J/AugP0rMpbfPht6TfFNjDmO1K+YOPgVkYv7bU/ooCrMQykTkchifVxo
   ePlnBiKhVmWxNWIVamwit+YGCidoWhyJzBIBnFzuAL5ZDN+aY8s6Oq4Hq
   R35lV06rOL5xy+guvg7jVRZ1Mdeo3LLJ9YdChKT5YghwbHPfHXHm3JK/w
   vRebuQiCeEuhsOolay9Evhqa5HUKYQxqQMRZxvunZJ6hqLaHBUr0ihvhi
   g==;
X-CSE-ConnectionGUID: jCNL8Dc/Tey2bzIWHbb6rA==
X-CSE-MsgGUID: IG1XAB+YSVOcSOsy+fE9Mg==
X-IronPort-AV: E=McAfee;i="6700,10204,11285"; a="51974625"
X-IronPort-AV: E=Sophos;i="6.12,231,1728975600"; 
   d="scan'208";a="51974625"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2024 07:45:22 -0800
X-CSE-ConnectionGUID: 0jcpM7VbSZmqvbMY0x8+oA==
X-CSE-MsgGUID: p6bv/cPaRR6t8X0acKxcdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="100725378"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.246.16.163])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2024 07:45:16 -0800
Message-ID: <8f30607d-6dae-4868-b016-efc95a2fc5a2@intel.com>
Date: Fri, 13 Dec 2024 17:45:09 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/7] x86/virt/tdx: Add SEAMCALL wrapper to enter/exit
 TDX guest
From: Adrian Hunter <adrian.hunter@intel.com>
To: Dave Hansen <dave.hansen@intel.com>, pbonzini@redhat.com,
 seanjc@google.com, kvm@vger.kernel.org, dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com,
 dmatlack@google.com, isaku.yamahata@intel.com, nik.borisov@suse.com,
 linux-kernel@vger.kernel.org, x86@kernel.org, yan.y.zhao@intel.com,
 chao.gao@intel.com, weijiang.yang@intel.com
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-2-adrian.hunter@intel.com>
 <fa817f29-e3ba-4c54-8600-e28cf6ab1953@intel.com>
 <0226840c-a975-42a5-9ddf-a54da7ef8746@intel.com>
 <56db8257-6da2-400d-8306-6e21d9af81f8@intel.com>
 <d1952eb7-8eb0-441b-85fc-3075c7b11cb9@intel.com>
 <6af0f1c3-92eb-407e-bb19-6aeca9701e41@intel.com>
 <ff4d5877-52ad-4e12-94a0-dfbe01a7a8a0@intel.com>
Content-Language: en-US
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <ff4d5877-52ad-4e12-94a0-dfbe01a7a8a0@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/12/24 20:43, Adrian Hunter wrote:
> The diff below shows another alternative.  This time using
> structs not a union.  The structs are easier to read than
> the union, and require copying arguments, which also allows
> using types that have sizes other than a GPR's (u64) size.

Dave, any comments on this one?

> 
> diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
> index 192ae798b214..85f87d90ac89 100644
> --- a/arch/x86/include/asm/shared/tdx.h
> +++ b/arch/x86/include/asm/shared/tdx.h
> @@ -21,20 +21,6 @@
>  /* TDCS fields. To be used by TDG.VM.WR and TDG.VM.RD module calls */
>  #define TDCS_NOTIFY_ENABLES		0x9100000000000010
>  
> -/* TDX hypercall Leaf IDs */
> -#define TDVMCALL_GET_TD_VM_CALL_INFO	0x10000
> -#define TDVMCALL_MAP_GPA		0x10001
> -#define TDVMCALL_GET_QUOTE		0x10002
> -#define TDVMCALL_REPORT_FATAL_ERROR	0x10003
> -
> -/*
> - * TDG.VP.VMCALL Status Codes (returned in R10)
> - */
> -#define TDVMCALL_STATUS_SUCCESS		0x0000000000000000ULL
> -#define TDVMCALL_STATUS_RETRY		0x0000000000000001ULL
> -#define TDVMCALL_STATUS_INVALID_OPERAND	0x8000000000000000ULL
> -#define TDVMCALL_STATUS_ALIGN_ERROR	0x8000000000000002ULL
> -
>  /*
>   * Bitmasks of exposed registers (with VMM).
>   */
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 01409a59224d..e4a45378a84b 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -33,6 +33,7 @@
>  
>  #ifndef __ASSEMBLY__
>  
> +#include <linux/kvm_types.h>
>  #include <uapi/asm/mce.h>
>  #include "tdx_global_metadata.h"
>  
> @@ -96,6 +97,7 @@ u64 __seamcall_saved_ret(u64 fn, struct tdx_module_args *args);
>  void tdx_init(void);
>  
>  #include <asm/archrandom.h>
> +#include <asm/vmx.h>
>  
>  typedef u64 (*sc_func_t)(u64 fn, struct tdx_module_args *args);
>  
> @@ -123,8 +125,122 @@ const struct tdx_sys_info *tdx_get_sysinfo(void);
>  int tdx_guest_keyid_alloc(void);
>  void tdx_guest_keyid_free(unsigned int keyid);
>  
> +/* TDG.VP.VMCALL Sub-function */
> +enum tdvmcall_subfn {
> +	TDVMCALL_NONE			= -1, /* Not a TDG.VP.VMCALL */
> +	TDVMCALL_GET_TD_VM_CALL_INFO	= 0x10000,
> +	TDVMCALL_MAP_GPA		= 0x10001,
> +	TDVMCALL_GET_QUOTE		= 0x10002,
> +	TDVMCALL_REPORT_FATAL_ERROR	= 0x10003,
> +	TDVMCALL_CPUID			= EXIT_REASON_CPUID,
> +	TDVMCALL_HLT			= EXIT_REASON_HLT,
> +	TDVMCALL_IO			= EXIT_REASON_IO_INSTRUCTION,
> +	TDVMCALL_RDMSR			= EXIT_REASON_MSR_READ,
> +	TDVMCALL_WRMSR			= EXIT_REASON_MSR_WRITE,
> +	TDVMCALL_MMIO			= EXIT_REASON_EPT_VIOLATION,
> +};
> +
> +enum tdx_io_direction {
> +	TDX_READ,
> +	TDX_WRITE
> +};
> +
> +/* TDG.VP.VMCALL Sub-function Completion Status Codes */
> +enum tdvmcall_status {
> +	TDVMCALL_STATUS_SUCCESS		= 0x0000000000000000ULL,
> +	TDVMCALL_STATUS_RETRY		= 0x0000000000000001ULL,
> +	TDVMCALL_STATUS_INVALID_OPERAND	= 0x8000000000000000ULL,
> +	TDVMCALL_STATUS_ALIGN_ERROR	= 0x8000000000000002ULL,
> +};
> +
> +struct tdh_vp_enter_in {
> +	/* TDG.VP.VMCALL common */
> +	enum tdvmcall_status	ret_code;
> +
> +	/* TDG.VP.VMCALL Sub-function return information */
> +
> +	/* TDVMCALL_GET_TD_VM_CALL_INFO */
> +	u64			gettdvmcallinfo[4];
> +
> +	/* TDVMCALL_MAP_GPA */
> +	gpa_t			failed_gpa;
> +
> +	/* TDVMCALL_CPUID */
> +	u32			eax;
> +	u32			ebx;
> +	u32			ecx;
> +	u32			edx;
> +
> +	/* TDVMCALL_IO (read), TDVMCALL_RDMSR or TDVMCALL_MMIO (read) */
> +	u64			value_read;
> +};
> +
> +#define TDX_ERR_DATA_SZ 8
> +
> +struct tdh_vp_enter_out {
> +	u64			exit_qual;
> +	u32			intr_info;
> +	u64			ext_exit_qual;
> +	gpa_t			gpa;
> +
> +	/* TDG.VP.VMCALL common */
> +	u32			reg_mask;
> +	u64			fn;		/* Non-zero for KVM hypercalls, zero otherwise */
> +	enum tdvmcall_subfn	subfn;
> +
> +	/* TDG.VP.VMCALL Sub-function arguments */
> +
> +	/* KVM hypercall */
> +	u64			nr;
> +	u64			p1;
> +	u64			p2;
> +	u64			p3;
> +	u64			p4;
> +
> +	/* TDVMCALL_GET_TD_VM_CALL_INFO */
> +	u64			leaf;
> +
> +	/* TDVMCALL_MAP_GPA */
> +	gpa_t			map_gpa;
> +	u64			map_gpa_size;
> +
> +	/* TDVMCALL_GET_QUOTE */
> +	gpa_t			shared_gpa;
> +	u64			shared_gpa_size;
> +
> +	/* TDVMCALL_REPORT_FATAL_ERROR */
> +	u64			err_codes;
> +	gpa_t			err_data_gpa;
> +	u64			err_data[TDX_ERR_DATA_SZ];
> +
> +	/* TDVMCALL_CPUID */
> +	u32			cpuid_leaf;
> +	u32			cpuid_subleaf;
> +
> +	/* TDVMCALL_MMIO */
> +	int			mmio_size;
> +	enum tdx_io_direction	mmio_direction;
> +	gpa_t			mmio_addr;
> +	u32			mmio_value;
> +
> +	/* TDVMCALL_HLT */
> +	bool			intr_blocked_flag;
> +
> +	/* TDVMCALL_IO_INSTRUCTION */
> +	int			io_size;
> +	enum tdx_io_direction	io_direction;
> +	u16			io_port;
> +	u32			io_value;
> +
> +	/* TDVMCALL_MSR_READ or TDVMCALL_MSR_WRITE */
> +	u32			msr;
> +
> +	/* TDVMCALL_MSR_WRITE */
> +	u64			write_value;
> +};
> +
>  /* SEAMCALL wrappers for creating/destroying/running TDX guests */
> -u64 tdh_vp_enter(u64 tdvpr, struct tdx_module_args *args);
> +u64 tdh_vp_enter(u64 tdvpr, const struct tdh_vp_enter_in *in, struct tdh_vp_enter_out *out);
>  u64 tdh_mng_addcx(u64 tdr, u64 tdcs);
>  u64 tdh_mem_page_add(u64 tdr, u64 gpa, u64 hpa, u64 source, u64 *rcx, u64 *rdx);
>  u64 tdh_mem_sept_add(u64 tdr, u64 gpa, u64 level, u64 hpa, u64 *rcx, u64 *rdx);
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 218801618e9a..a8283a03fdd4 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -256,57 +256,41 @@ static __always_inline bool tdx_check_exit_reason(struct kvm_vcpu *vcpu, u16 rea
>  
>  static __always_inline unsigned long tdexit_exit_qual(struct kvm_vcpu *vcpu)
>  {
> -	return kvm_rcx_read(vcpu);
> +	return to_tdx(vcpu)->vp_enter_out.exit_qual;
>  }
>  
>  static __always_inline unsigned long tdexit_ext_exit_qual(struct kvm_vcpu *vcpu)
>  {
> -	return kvm_rdx_read(vcpu);
> +	return to_tdx(vcpu)->vp_enter_out.ext_exit_qual;
>  }
>  
> -static __always_inline unsigned long tdexit_gpa(struct kvm_vcpu *vcpu)
> +static __always_inline gpa_t tdexit_gpa(struct kvm_vcpu *vcpu)
>  {
> -	return kvm_r8_read(vcpu);
> +	return to_tdx(vcpu)->vp_enter_out.gpa;
>  }
>  
>  static __always_inline unsigned long tdexit_intr_info(struct kvm_vcpu *vcpu)
>  {
> -	return kvm_r9_read(vcpu);
> +	return to_tdx(vcpu)->vp_enter_out.intr_info;
>  }
>  
> -#define BUILD_TDVMCALL_ACCESSORS(param, gpr)				\
> -static __always_inline							\
> -unsigned long tdvmcall_##param##_read(struct kvm_vcpu *vcpu)		\
> -{									\
> -	return kvm_##gpr##_read(vcpu);					\
> -}									\
> -static __always_inline void tdvmcall_##param##_write(struct kvm_vcpu *vcpu, \
> -						     unsigned long val)  \
> -{									\
> -	kvm_##gpr##_write(vcpu, val);					\
> -}
> -BUILD_TDVMCALL_ACCESSORS(a0, r12);
> -BUILD_TDVMCALL_ACCESSORS(a1, r13);
> -BUILD_TDVMCALL_ACCESSORS(a2, r14);
> -BUILD_TDVMCALL_ACCESSORS(a3, r15);
> -
> -static __always_inline unsigned long tdvmcall_exit_type(struct kvm_vcpu *vcpu)
> +static __always_inline unsigned long tdvmcall_fn(struct kvm_vcpu *vcpu)
>  {
> -	return kvm_r10_read(vcpu);
> +	return to_tdx(vcpu)->vp_enter_out.fn;
>  }
> -static __always_inline unsigned long tdvmcall_leaf(struct kvm_vcpu *vcpu)
> +static __always_inline enum tdvmcall_subfn tdvmcall_subfn(struct kvm_vcpu *vcpu)
>  {
> -	return kvm_r11_read(vcpu);
> +	return to_tdx(vcpu)->vp_enter_out.subfn;
>  }
>  static __always_inline void tdvmcall_set_return_code(struct kvm_vcpu *vcpu,
> -						     long val)
> +						     enum tdvmcall_status val)
>  {
> -	kvm_r10_write(vcpu, val);
> +	to_tdx(vcpu)->vp_enter_in.ret_code = val;
>  }
>  static __always_inline void tdvmcall_set_return_val(struct kvm_vcpu *vcpu,
>  						    unsigned long val)
>  {
> -	kvm_r11_write(vcpu, val);
> +	to_tdx(vcpu)->vp_enter_in.value_read = val;
>  }
>  
>  static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
> @@ -786,10 +770,10 @@ bool tdx_interrupt_allowed(struct kvm_vcpu *vcpu)
>  	 * passes the interrupt block flag.
>  	 */
>  	if (!tdx_check_exit_reason(vcpu, EXIT_REASON_TDCALL) ||
> -	    tdvmcall_exit_type(vcpu) || tdvmcall_leaf(vcpu) != EXIT_REASON_HLT)
> +	    tdvmcall_fn(vcpu) || tdvmcall_subfn(vcpu) != TDVMCALL_HLT)
>  	    return true;
>  
> -	return !tdvmcall_a0_read(vcpu);
> +	return !to_tdx(vcpu)->vp_enter_out.intr_blocked_flag;
>  }
>  
>  bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
> @@ -945,51 +929,10 @@ static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
>  static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_tdx *tdx = to_tdx(vcpu);
> -	struct tdx_module_args args;
>  
>  	guest_state_enter_irqoff();
>  
> -	/*
> -	 * TODO: optimization:
> -	 * - Eliminate copy between args and vcpu->arch.regs.
> -	 * - copyin/copyout registers only if (tdx->tdvmvall.regs_mask != 0)
> -	 *   which means TDG.VP.VMCALL.
> -	 */
> -	args = (struct tdx_module_args) {
> -		.rcx = tdx->tdvpr_pa,
> -#define REG(reg, REG)	.reg = vcpu->arch.regs[VCPU_REGS_ ## REG]
> -		REG(rdx, RDX),
> -		REG(r8,  R8),
> -		REG(r9,  R9),
> -		REG(r10, R10),
> -		REG(r11, R11),
> -		REG(r12, R12),
> -		REG(r13, R13),
> -		REG(r14, R14),
> -		REG(r15, R15),
> -		REG(rbx, RBX),
> -		REG(rdi, RDI),
> -		REG(rsi, RSI),
> -#undef REG
> -	};
> -
> -	tdx->vp_enter_ret = tdh_vp_enter(tdx->tdvpr_pa, &args);
> -
> -#define REG(reg, REG)	vcpu->arch.regs[VCPU_REGS_ ## REG] = args.reg
> -	REG(rcx, RCX);
> -	REG(rdx, RDX);
> -	REG(r8,  R8);
> -	REG(r9,  R9);
> -	REG(r10, R10);
> -	REG(r11, R11);
> -	REG(r12, R12);
> -	REG(r13, R13);
> -	REG(r14, R14);
> -	REG(r15, R15);
> -	REG(rbx, RBX);
> -	REG(rdi, RDI);
> -	REG(rsi, RSI);
> -#undef REG
> +	tdx->vp_enter_ret = tdh_vp_enter(tdx->tdvpr_pa, &tdx->vp_enter_in, &tdx->vp_enter_out);
>  
>  	if (tdx_check_exit_reason(vcpu, EXIT_REASON_EXCEPTION_NMI) &&
>  	    is_nmi(tdexit_intr_info(vcpu)))
> @@ -1128,8 +1071,15 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
>  
>  static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
>  {
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
>  	int r;
>  
> +	kvm_r10_write(vcpu, tdx->vp_enter_out.nr);
> +	kvm_r11_write(vcpu, tdx->vp_enter_out.p1);
> +	kvm_r12_write(vcpu, tdx->vp_enter_out.p2);
> +	kvm_r13_write(vcpu, tdx->vp_enter_out.p3);
> +	kvm_r14_write(vcpu, tdx->vp_enter_out.p4);
> +
>  	/*
>  	 * ABI for KVM tdvmcall argument:
>  	 * In Guest-Hypervisor Communication Interface(GHCI) specification,
> @@ -1137,13 +1087,12 @@ static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
>  	 * vendor-specific.  KVM uses this for KVM hypercall.  NOTE: KVM
>  	 * hypercall number starts from one.  Zero isn't used for KVM hypercall
>  	 * number.
> -	 *
> -	 * R10: KVM hypercall number
> -	 * arguments: R11, R12, R13, R14.
>  	 */
>  	r = __kvm_emulate_hypercall(vcpu, r10, r11, r12, r13, r14, true, 0,
>  				    complete_hypercall_exit);
>  
> +	tdvmcall_set_return_code(vcpu, kvm_r10_read(vcpu));
> +
>  	return r > 0;
>  }
>  
> @@ -1161,7 +1110,7 @@ static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
>  
>  	if(vcpu->run->hypercall.ret) {
>  		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
> -		kvm_r11_write(vcpu, tdx->map_gpa_next);
> +		tdx->vp_enter_in.failed_gpa = tdx->map_gpa_next;
>  		return 1;
>  	}
>  
> @@ -1182,7 +1131,7 @@ static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
>  	if (pi_has_pending_interrupt(vcpu) ||
>  	    kvm_test_request(KVM_REQ_NMI, vcpu) || vcpu->arch.nmi_pending) {
>  		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
> -		kvm_r11_write(vcpu, tdx->map_gpa_next);
> +		tdx->vp_enter_in.failed_gpa = tdx->map_gpa_next;
>  		return 1;
>  	}
>  
> @@ -1214,8 +1163,8 @@ static void __tdx_map_gpa(struct vcpu_tdx * tdx)
>  static int tdx_map_gpa(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_tdx * tdx = to_tdx(vcpu);
> -	u64 gpa = tdvmcall_a0_read(vcpu);
> -	u64 size = tdvmcall_a1_read(vcpu);
> +	u64 gpa  = tdx->vp_enter_out.map_gpa;
> +	u64 size = tdx->vp_enter_out.map_gpa_size;
>  	u64 ret;
>  
>  	/*
> @@ -1251,14 +1200,17 @@ static int tdx_map_gpa(struct kvm_vcpu *vcpu)
>  
>  error:
>  	tdvmcall_set_return_code(vcpu, ret);
> -	kvm_r11_write(vcpu, gpa);
> +	tdx->vp_enter_in.failed_gpa = gpa;
>  	return 1;
>  }
>  
>  static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
>  {
> -	u64 reg_mask = kvm_rcx_read(vcpu);
> -	u64* opt_regs;
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +	__u64 *data = &vcpu->run->system_event.data[0];
> +	u64 reg_mask = tdx->vp_enter_out.reg_mask;
> +	const int mask[] = {14, 15, 3, 7, 6, 8, 9, 2};
> +	int cnt = 0;
>  
>  	/*
>  	 * Skip sanity checks and let userspace decide what to do if sanity
> @@ -1266,32 +1218,20 @@ static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
>  	 */
>  	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
>  	vcpu->run->system_event.type = KVM_SYSTEM_EVENT_TDX_FATAL;
> -	vcpu->run->system_event.ndata = 10;
>  	/* Error codes. */
> -	vcpu->run->system_event.data[0] = tdvmcall_a0_read(vcpu);
> +	data[cnt++] = tdx->vp_enter_out.err_codes;
>  	/* GPA of additional information page. */
> -	vcpu->run->system_event.data[1] = tdvmcall_a1_read(vcpu);
> +	data[cnt++] = tdx->vp_enter_out.err_data_gpa;
> +
>  	/* Information passed via registers (up to 64 bytes). */
> -	opt_regs = &vcpu->run->system_event.data[2];
> +	for (int i = 0; i < TDX_ERR_DATA_SZ; i++) {
> +		if (reg_mask & BIT_ULL(mask[i]))
> +			data[cnt++] = tdx->vp_enter_out.err_data[i];
> +		else
> +			data[cnt++] = 0;
> +	}
>  
> -#define COPY_REG(REG, MASK)						\
> -	do {								\
> -		if (reg_mask & MASK)					\
> -			*opt_regs = kvm_ ## REG ## _read(vcpu);		\
> -		else							\
> -			*opt_regs = 0;					\
> -		opt_regs++;						\
> -	} while (0)
> -
> -	/* The order is defined in GHCI. */
> -	COPY_REG(r14, BIT_ULL(14));
> -	COPY_REG(r15, BIT_ULL(15));
> -	COPY_REG(rbx, BIT_ULL(3));
> -	COPY_REG(rdi, BIT_ULL(7));
> -	COPY_REG(rsi, BIT_ULL(6));
> -	COPY_REG(r8, BIT_ULL(8));
> -	COPY_REG(r9, BIT_ULL(9));
> -	COPY_REG(rdx, BIT_ULL(2));
> +	vcpu->run->system_event.ndata = cnt;
>  
>  	/*
>  	 * Set the status code according to GHCI spec, although the vCPU may
> @@ -1305,18 +1245,18 @@ static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
>  
>  static int tdx_emulate_cpuid(struct kvm_vcpu *vcpu)
>  {
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
>  	u32 eax, ebx, ecx, edx;
>  
> -	/* EAX and ECX for cpuid is stored in R12 and R13. */
> -	eax = tdvmcall_a0_read(vcpu);
> -	ecx = tdvmcall_a1_read(vcpu);
> +	eax = tdx->vp_enter_out.cpuid_leaf;
> +	ecx = tdx->vp_enter_out.cpuid_subleaf;
>  
>  	kvm_cpuid(vcpu, &eax, &ebx, &ecx, &edx, false);
>  
> -	tdvmcall_a0_write(vcpu, eax);
> -	tdvmcall_a1_write(vcpu, ebx);
> -	tdvmcall_a2_write(vcpu, ecx);
> -	tdvmcall_a3_write(vcpu, edx);
> +	tdx->vp_enter_in.eax = eax;
> +	tdx->vp_enter_in.ebx = ebx;
> +	tdx->vp_enter_in.ecx = ecx;
> +	tdx->vp_enter_in.edx = edx;
>  
>  	tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUCCESS);
>  
> @@ -1356,6 +1296,7 @@ static int tdx_complete_pio_in(struct kvm_vcpu *vcpu)
>  static int tdx_emulate_io(struct kvm_vcpu *vcpu)
>  {
>  	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
>  	unsigned long val = 0;
>  	unsigned int port;
>  	int size, ret;
> @@ -1363,9 +1304,9 @@ static int tdx_emulate_io(struct kvm_vcpu *vcpu)
>  
>  	++vcpu->stat.io_exits;
>  
> -	size = tdvmcall_a0_read(vcpu);
> -	write = tdvmcall_a1_read(vcpu);
> -	port = tdvmcall_a2_read(vcpu);
> +	size  = tdx->vp_enter_out.io_size;
> +	write = tdx->vp_enter_out.io_direction == TDX_WRITE;
> +	port  = tdx->vp_enter_out.io_port;
>  
>  	if (size != 1 && size != 2 && size != 4) {
>  		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
> @@ -1373,7 +1314,7 @@ static int tdx_emulate_io(struct kvm_vcpu *vcpu)
>  	}
>  
>  	if (write) {
> -		val = tdvmcall_a3_read(vcpu);
> +		val = tdx->vp_enter_out.io_value;
>  		ret = ctxt->ops->pio_out_emulated(ctxt, size, port, &val, 1);
>  	} else {
>  		ret = ctxt->ops->pio_in_emulated(ctxt, size, port, &val, 1);
> @@ -1443,14 +1384,15 @@ static inline int tdx_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, int size)
>  
>  static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
>  {
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
>  	int size, write, r;
>  	unsigned long val;
>  	gpa_t gpa;
>  
> -	size = tdvmcall_a0_read(vcpu);
> -	write = tdvmcall_a1_read(vcpu);
> -	gpa = tdvmcall_a2_read(vcpu);
> -	val = write ? tdvmcall_a3_read(vcpu) : 0;
> +	size  = tdx->vp_enter_out.mmio_size;
> +	write = tdx->vp_enter_out.mmio_direction == TDX_WRITE;
> +	gpa   = tdx->vp_enter_out.mmio_addr;
> +	val = write ? tdx->vp_enter_out.mmio_value : 0;
>  
>  	if (size != 1 && size != 2 && size != 4 && size != 8)
>  		goto error;
> @@ -1502,7 +1444,7 @@ static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
>  
>  static int tdx_emulate_rdmsr(struct kvm_vcpu *vcpu)
>  {
> -	u32 index = tdvmcall_a0_read(vcpu);
> +	u32 index = to_tdx(vcpu)->vp_enter_out.msr;
>  	u64 data;
>  
>  	if (!kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_READ) ||
> @@ -1520,8 +1462,8 @@ static int tdx_emulate_rdmsr(struct kvm_vcpu *vcpu)
>  
>  static int tdx_emulate_wrmsr(struct kvm_vcpu *vcpu)
>  {
> -	u32 index = tdvmcall_a0_read(vcpu);
> -	u64 data = tdvmcall_a1_read(vcpu);
> +	u32 index = to_tdx(vcpu)->vp_enter_out.msr;
> +	u64 data  = to_tdx(vcpu)->vp_enter_out.write_value;
>  
>  	if (!kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_WRITE) ||
>  	    kvm_set_msr(vcpu, index, data)) {
> @@ -1537,39 +1479,41 @@ static int tdx_emulate_wrmsr(struct kvm_vcpu *vcpu)
>  
>  static int tdx_get_td_vm_call_info(struct kvm_vcpu *vcpu)
>  {
> -	if (tdvmcall_a0_read(vcpu))
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +
> +	if (tdx->vp_enter_out.leaf) {
>  		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
> -	else {
> +	} else {
>  		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUCCESS);
> -		kvm_r11_write(vcpu, 0);
> -		tdvmcall_a0_write(vcpu, 0);
> -		tdvmcall_a1_write(vcpu, 0);
> -		tdvmcall_a2_write(vcpu, 0);
> +		tdx->vp_enter_in.gettdvmcallinfo[0] = 0;
> +		tdx->vp_enter_in.gettdvmcallinfo[1] = 0;
> +		tdx->vp_enter_in.gettdvmcallinfo[2] = 0;
> +		tdx->vp_enter_in.gettdvmcallinfo[3] = 0;
>  	}
>  	return 1;
>  }
>  
>  static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>  {
> -	if (tdvmcall_exit_type(vcpu))
> +	if (tdvmcall_fn(vcpu))
>  		return tdx_emulate_vmcall(vcpu);
>  
> -	switch (tdvmcall_leaf(vcpu)) {
> +	switch (tdvmcall_subfn(vcpu)) {
>  	case TDVMCALL_MAP_GPA:
>  		return tdx_map_gpa(vcpu);
>  	case TDVMCALL_REPORT_FATAL_ERROR:
>  		return tdx_report_fatal_error(vcpu);
> -	case EXIT_REASON_CPUID:
> +	case TDVMCALL_CPUID:
>  		return tdx_emulate_cpuid(vcpu);
> -	case EXIT_REASON_HLT:
> +	case TDVMCALL_HLT:
>  		return tdx_emulate_hlt(vcpu);
> -	case EXIT_REASON_IO_INSTRUCTION:
> +	case TDVMCALL_IO:
>  		return tdx_emulate_io(vcpu);
> -	case EXIT_REASON_EPT_VIOLATION:
> +	case TDVMCALL_MMIO:
>  		return tdx_emulate_mmio(vcpu);
> -	case EXIT_REASON_MSR_READ:
> +	case TDVMCALL_RDMSR:
>  		return tdx_emulate_rdmsr(vcpu);
> -	case EXIT_REASON_MSR_WRITE:
> +	case TDVMCALL_WRMSR:
>  		return tdx_emulate_wrmsr(vcpu);
>  	case TDVMCALL_GET_TD_VM_CALL_INFO:
>  		return tdx_get_td_vm_call_info(vcpu);
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 008180c0c30f..63d8b3359b10 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -69,6 +69,8 @@ struct vcpu_tdx {
>  	struct list_head cpu_list;
>  
>  	u64 vp_enter_ret;
> +	struct tdh_vp_enter_in vp_enter_in;
> +	struct tdh_vp_enter_out vp_enter_out;
>  
>  	enum vcpu_tdx_state state;
>  
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 16e0b598c4ec..895d9ea4aeba 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -33,6 +33,7 @@
>  #include <asm/msr-index.h>
>  #include <asm/msr.h>
>  #include <asm/cpufeature.h>
> +#include <asm/vmx.h>
>  #include <asm/tdx.h>
>  #include <asm/cpu_device_id.h>
>  #include <asm/processor.h>
> @@ -1600,11 +1601,122 @@ static inline u64 tdx_seamcall_sept(u64 op, struct tdx_module_args *in)
>  	return ret;
>  }
>  
> -noinstr u64 tdh_vp_enter(u64 tdvpr, struct tdx_module_args *args)
> +noinstr u64 tdh_vp_enter(u64 tdvpr, const struct tdh_vp_enter_in *in, struct tdh_vp_enter_out *out)
>  {
> -	args->rcx = tdvpr;
> +	struct tdx_module_args args = {
> +		.rcx = tdvpr,
> +		.r10 = in->ret_code,
> +	};
> +	u64 ret;
>  
> -	return __seamcall_saved_ret(TDH_VP_ENTER, args);
> +	/* If previous exit was TDG.VP.VMCALL */
> +	switch (out->subfn) {
> +	case TDVMCALL_GET_TD_VM_CALL_INFO:
> +		args.r11 = in->gettdvmcallinfo[0];
> +		args.r12 = in->gettdvmcallinfo[1];
> +		args.r13 = in->gettdvmcallinfo[2];
> +		args.r14 = in->gettdvmcallinfo[3];
> +		break;
> +	case TDVMCALL_MAP_GPA:
> +		args.r11 = in->failed_gpa;
> +		break;
> +	case TDVMCALL_CPUID:
> +		args.r12 = in->eax;
> +		args.r13 = in->ebx;
> +		args.r14 = in->ecx;
> +		args.r15 = in->edx;
> +		break;
> +	case TDVMCALL_IO:
> +	case TDVMCALL_RDMSR:
> +	case TDVMCALL_MMIO:
> +		args.r11 = in->value_read;
> +		break;
> +	case TDVMCALL_NONE:
> +	case TDVMCALL_GET_QUOTE:
> +	case TDVMCALL_REPORT_FATAL_ERROR:
> +	case TDVMCALL_HLT:
> +	case TDVMCALL_WRMSR:
> +		break;
> +	}
> +
> +	ret = __seamcall_saved_ret(TDH_VP_ENTER, &args);
> +
> +	if ((u16)ret == EXIT_REASON_TDCALL) {
> +		out->reg_mask		= args.rcx;
> +		out->fn = args.r10;
> +		if (out->fn) {
> +			out->nr		= args.r10;
> +			out->p1		= args.r11;
> +			out->p2		= args.r12;
> +			out->p3		= args.r13;
> +			out->p4		= args.r14;
> +			out->subfn	= TDVMCALL_NONE;
> +		} else {
> +			out->subfn	= args.r11;
> +		}
> +	} else {
> +		out->exit_qual		= args.rcx;
> +		out->ext_exit_qual	= args.rdx;
> +		out->gpa		= args.r8;
> +		out->intr_info		= args.r9;
> +		out->subfn		= TDVMCALL_NONE;
> +	}
> +
> +	switch (out->subfn) {
> +	case TDVMCALL_GET_TD_VM_CALL_INFO:
> +		out->leaf		= args.r12;
> +		break;
> +	case TDVMCALL_MAP_GPA:
> +		out->map_gpa		= args.r12;
> +		out->map_gpa_size	= args.r13;
> +		break;
> +	case TDVMCALL_CPUID:
> +		out->cpuid_leaf		= args.r12;
> +		out->cpuid_subleaf	= args.r13;
> +		break;
> +	case TDVMCALL_IO:
> +		out->io_size		= args.r12;
> +		out->io_direction	= args.r13 ? TDX_WRITE : TDX_READ;
> +		out->io_port		= args.r14;
> +		out->io_value		= args.r15;
> +		break;
> +	case TDVMCALL_RDMSR:
> +		out->msr		= args.r12;
> +		break;
> +	case TDVMCALL_MMIO:
> +		out->mmio_size		= args.r12;
> +		out->mmio_direction	= args.r13 ? TDX_WRITE : TDX_READ;
> +		out->mmio_addr		= args.r14;
> +		out->mmio_value		= args.r15;
> +		break;
> +	case TDVMCALL_NONE:
> +		break;
> +	case TDVMCALL_GET_QUOTE:
> +		out->shared_gpa		= args.r12;
> +		out->shared_gpa_size	= args.r13;
> +		break;
> +	case TDVMCALL_REPORT_FATAL_ERROR:
> +		out->err_codes		= args.r12;
> +		out->err_data_gpa	= args.r13;
> +		out->err_data[0]	= args.r14;
> +		out->err_data[1]	= args.r15;
> +		out->err_data[2]	= args.rbx;
> +		out->err_data[3]	= args.rdi;
> +		out->err_data[4]	= args.rsi;
> +		out->err_data[5]	= args.r8;
> +		out->err_data[6]	= args.r9;
> +		out->err_data[7]	= args.rdx;
> +		break;
> +	case TDVMCALL_HLT:
> +		out->intr_blocked_flag	= args.r12;
> +		break;
> +	case TDVMCALL_WRMSR:
> +		out->msr		= args.r12;
> +		out->write_value	= args.r13;
> +		break;
> +	}
> +
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(tdh_vp_enter);
>  


