Return-Path: <kvm+bounces-32354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CA7539D5DCC
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 12:10:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 509311F23A45
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 11:10:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3652D1DE3B3;
	Fri, 22 Nov 2024 11:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h9UwxLz3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B787017B4E9;
	Fri, 22 Nov 2024 11:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732273826; cv=none; b=DGA/STVwm28Hwa9Zl7UtjDgK5PRLpcaMiL/i//BJ3kAmctmanY5NyAB0u18bAYFpGA4IeHgv45pV+ZTCnS0byU6v3uBFOD8tWUKRwaaJ5x2HVagRHQ2++QKOdpbKqA1/mYDgdpgOrWGd0M40kg//TzV0Ltwz0zTfnF5Ybdlq5Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732273826; c=relaxed/simple;
	bh=xzYJ81WpRveygJaJugSCk4IIQs4xQKJZZaONDDliyOs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wz1QxxO3NskJ7YMlxIayMs/Msfeh5bver1OFgDbb0UgAh2aSqQmMGrhtcJ4/uduC3YTt2WjQZCZ0GCo6X/D+8RueGB7PQnCHskWvVPo/xmcAbSABxA2/gA5rFMgzvp0IOIsc+fCaZOWIaq4yIqvRXlJaSoEp1lVJ6xm2fGMbx1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h9UwxLz3; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732273824; x=1763809824;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xzYJ81WpRveygJaJugSCk4IIQs4xQKJZZaONDDliyOs=;
  b=h9UwxLz3pq5Sd0ZGy/pSaRSREEKVkMec5RKcR4r4sIOWO4a6IjvQA5H1
   psZl/xNxXG3yp0EcKneXyozp31LdefTCNtyp/QyaJLYiZAtUOZWxryyJS
   /Je7U2nksNsTAgqFUTcbpBvBH2KZ6FTSXQLst604Ir+WtgVBCXf0//Jsm
   34bb9jJ4aQqF5bQjv2UD5YdIgq6+ysdpGfZa/i7u6P3UKyvDN0AVDrkXZ
   fDxPO49Nqa67ZCVmh3udQTmOPcmntUAWQVvqR06QO/C+c9ubNcBa6frH9
   KSobSJYwNnk8ljDAFWA3glsna6l6r9Z+l9Ty8fDjh2yLxfcqNnvwJo9Eu
   A==;
X-CSE-ConnectionGUID: RTePfq03SPycpMdYneWLXg==
X-CSE-MsgGUID: tmky7AuxSDqZA+9PDL95gg==
X-IronPort-AV: E=McAfee;i="6700,10204,11263"; a="32284414"
X-IronPort-AV: E=Sophos;i="6.12,175,1728975600"; 
   d="scan'208";a="32284414"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 03:10:24 -0800
X-CSE-ConnectionGUID: P6mODZDUR8OMFDwPd0N0BQ==
X-CSE-MsgGUID: ftYB1j50ReOw1B2EKRVIIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,175,1728975600"; 
   d="scan'208";a="90912776"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.245.115.59])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 03:10:18 -0800
Message-ID: <fa817f29-e3ba-4c54-8600-e28cf6ab1953@intel.com>
Date: Fri, 22 Nov 2024 13:10:10 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/7] x86/virt/tdx: Add SEAMCALL wrapper to enter/exit
 TDX guest
To: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com,
 dmatlack@google.com, isaku.yamahata@intel.com, nik.borisov@suse.com,
 linux-kernel@vger.kernel.org, x86@kernel.org, yan.y.zhao@intel.com,
 chao.gao@intel.com, weijiang.yang@intel.com
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-2-adrian.hunter@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20241121201448.36170-2-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 21/11/24 22:14, Adrian Hunter wrote:
> From: Kai Huang <kai.huang@intel.com>
> 
> Intel TDX protects guest VM's from malicious host and certain physical
> attacks.  TDX introduces a new operation mode, Secure Arbitration Mode
> (SEAM) to isolate and protect guest VM's.  A TDX guest VM runs in SEAM and,
> unlike VMX, direct control and interaction with the guest by the host VMM
> is not possible.  Instead, Intel TDX Module, which also runs in SEAM,
> provides a SEAMCALL API.
> 
> The SEAMCALL that provides the ability to enter a guest is TDH.VP.ENTER.
> The TDX Module processes TDH.VP.ENTER, and enters the guest via VMX
> VMLAUNCH/VMRESUME instructions.  When a guest VM-exit requires host VMM
> interaction, the TDH.VP.ENTER SEAMCALL returns to the host VMM (KVM).
> 
> Add tdh_vp_enter() to wrap the SEAMCALL invocation of TDH.VP.ENTER.
> 
> TDH.VP.ENTER is different from other SEAMCALLS in several ways:
>  - it may take some time to return as the guest executes
>  - it uses more arguments
>  - after it returns some host state may need to be restored
> 
> TDH.VP.ENTER arguments are passed through General Purpose Registers (GPRs).
> For the special case of the TD guest invoking TDG.VP.VMCALL, nearly any GPR
> can be used, as well as XMM0 to XMM15. Notably, RBP is not used, and Linux
> mandates the TDX Module feature NO_RBP_MOD, which is enforced elsewhere.
> Additionally, XMM registers are not required for the existing Guest
> Hypervisor Communication Interface and are handled by existing KVM code
> should they be modified by the guest.
> 
> There are 2 input formats and 5 output formats for TDH.VP.ENTER arguments.
> Input #1 : Initial entry or following a previous async. TD Exit
> Input #2 : Following a previous TDCALL(TDG.VP.VMCALL)
> Output #1 : On Error (No TD Entry)
> Output #2 : Async. Exits with a VMX Architectural Exit Reason
> Output #3 : Async. Exits with a non-VMX TD Exit Status
> Output #4 : Async. Exits with Cross-TD Exit Details
> Output #5 : On TDCALL(TDG.VP.VMCALL)
> 
> Currently, to keep things simple, the wrapper function does not attempt
> to support different formats, and just passes all the GPRs that could be
> used.  The GPR values are held by KVM in the area set aside for guest
> GPRs.  KVM code uses the guest GPR area (vcpu->arch.regs[]) to set up for
> or process results of tdh_vp_enter().
> 
> Therefore changing tdh_vp_enter() to use more complex argument formats
> would also alter the way KVM code interacts with tdh_vp_enter().
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  arch/x86/include/asm/tdx.h  | 1 +
>  arch/x86/virt/vmx/tdx/tdx.c | 8 ++++++++
>  arch/x86/virt/vmx/tdx/tdx.h | 1 +
>  3 files changed, 10 insertions(+)
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index fdc81799171e..77477b905dca 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -123,6 +123,7 @@ int tdx_guest_keyid_alloc(void);
>  void tdx_guest_keyid_free(unsigned int keyid);
>  
>  /* SEAMCALL wrappers for creating/destroying/running TDX guests */
> +u64 tdh_vp_enter(u64 tdvpr, struct tdx_module_args *args);
>  u64 tdh_mng_addcx(u64 tdr, u64 tdcs);
>  u64 tdh_mem_page_add(u64 tdr, u64 gpa, u64 hpa, u64 source, u64 *rcx, u64 *rdx);
>  u64 tdh_mem_sept_add(u64 tdr, u64 gpa, u64 level, u64 hpa, u64 *rcx, u64 *rdx);
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 04cb2f1d6deb..2a8997eb1ef1 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -1600,6 +1600,14 @@ static inline u64 tdx_seamcall_sept(u64 op, struct tdx_module_args *in)
>  	return ret;
>  }
>  
> +u64 tdh_vp_enter(u64 tdvpr, struct tdx_module_args *args)
> +{
> +	args->rcx = tdvpr;
> +
> +	return __seamcall_saved_ret(TDH_VP_ENTER, args);
> +}
> +EXPORT_SYMBOL_GPL(tdh_vp_enter);

One alternative could be to create a union to hold the arguments:

u64 tdh_vp_enter(u64 tdvpr, union tdh_vp_enter_args *vp_enter_args)
{
	struct tdx_module_args *args = (struct tdx_module_args *)vp_enter_args;

	args->rcx = tdvpr;

	return __seamcall_saved_ret(TDH_VP_ENTER, args);
}

The diff below shows what that would look like for KVM TDX, based on top
of:

	https://github.com/intel/tdx/tree/tdx_kvm_dev-2024-11-20

Define 'union tdh_vp_enter_args' to hold tdh_vp_enter() arguments
instead of using vcpu->arch.regs[].  For example, in tdexit_exit_qual()

	kvm_rcx_read(vcpu)

becomes:

	to_tdx(vcpu)->vp_enter_args.out.exit_qual

which has the advantage that it provides variable names for the different
arguments.

---
 arch/x86/include/asm/tdx.h  | 163 +++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.c      | 205 +++++++++++++++---------------------
 arch/x86/kvm/vmx/tdx.h      |   1 +
 arch/x86/virt/vmx/tdx/tdx.c |   4 +-
 4 files changed, 249 insertions(+), 124 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 01409a59224d..3568e6b36b77 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -123,8 +123,169 @@ const struct tdx_sys_info *tdx_get_sysinfo(void);
 int tdx_guest_keyid_alloc(void);
 void tdx_guest_keyid_free(unsigned int keyid);
 
+/* TDH.VP.ENTER Input Format #2 : Following a previous TDCALL(TDG.VP.VMCALL) */
+struct tdh_vp_enter_in {
+	u64	__vcpu_handle_and_flags; /* Don't use. tdh_vp_enter() will take care of it */
+	u64	unused[3];
+	u64	ret_code;
+	union {
+		u64 gettdvmcallinfo[4];
+		struct {
+			u64	failed_gpa;
+		} mapgpa;
+		struct {
+			u64	unused;
+			u64	eax;
+			u64	ebx;
+			u64	ecx;
+			u64	edx;
+		} cpuid;
+		/* Value read for IO, MMIO or RDMSR */
+		struct {
+			u64	value;
+		} read;
+	};
+};
+
+/*
+ * TDH.VP.ENTER Output Formats #2 and #3 combined:
+ *	#2 : Async TD exits with a VMX Architectural Exit Reason
+ *	#3 : Async TD exits with a non-VMX TD Exit Status
+ */
+struct tdh_vp_enter_out {
+	u64	exit_qual	: 32,	/* #2 only */
+		vm_idx		:  2,	/* #2 and #3 */
+		reserved_0	: 30;
+	u64	ext_exit_qual;		/* #2 only */
+	u64	gpa;			/* #2 only */
+	u64	interrupt_info	: 32,	/* #2 only */
+		reserved_1	: 32;
+	u64	unused[9];
+};
+
+/*
+ * KVM hypercall : Refer struct tdh_vp_enter_tdcall - fn is the non-zero
+ * hypercall number (nr), subfn is the first parameter (p1), and p2 to p3
+ * below are the remaining parameters.
+ */
+struct tdh_vp_enter_vmcall {
+	u64	p2;
+	u64	p3;
+	u64	p4;
+};
+
+/* TDVMCALL_GET_TD_VM_CALL_INFO */
+struct tdh_vp_enter_gettdvmcallinfo {
+	u64	leaf;
+};
+
+/* TDVMCALL_MAP_GPA */
+struct tdh_vp_enter_mapgpa {
+	u64	gpa;
+	u64	size;
+};
+
+/* TDVMCALL_GET_QUOTE */
+struct tdh_vp_enter_getquote {
+	u64	shared_gpa;
+	u64	size;
+};
+
+#define TDX_ERR_DATA_PART_1 5
+
+/* TDVMCALL_REPORT_FATAL_ERROR */
+struct tdh_vp_enter_reportfatalerror {
+	union {
+		u64	err_codes;
+		struct {
+			u64	err_code	: 32,
+				ext_err_code	: 31,
+				gpa_valid	:  1;
+		};
+	};
+	u64	err_data_gpa;
+	u64	err_data[TDX_ERR_DATA_PART_1];
+};
+
+/* EXIT_REASON_CPUID */
+struct tdh_vp_enter_cpuid {
+	u64	eax;
+	u64	ecx;
+};
+
+/* EXIT_REASON_EPT_VIOLATION */
+struct tdh_vp_enter_mmio {
+	u64	size;
+	u64	direction;
+	u64	mmio_addr;
+	u64	value;
+};
+
+/* EXIT_REASON_HLT */
+struct tdh_vp_enter_hlt {
+	u64	intr_blocked_flag;
+};
+
+/* EXIT_REASON_IO_INSTRUCTION */
+struct tdh_vp_enter_io {
+	u64	size;
+	u64	direction;
+	u64	port;
+	u64	value;
+};
+
+/* EXIT_REASON_MSR_READ */
+struct tdh_vp_enter_rd {
+	u64	msr;
+};
+
+/* EXIT_REASON_MSR_WRITE */
+struct  tdh_vp_enter_wr {
+	u64	msr;
+	u64	value;
+};
+
+#define TDX_ERR_DATA_PART_2 3
+
+/* TDH.VP.ENTER  Output Format #5 : On TDCALL(TDG.VP.VMCALL) */
+struct tdh_vp_enter_tdcall {
+	u64	reg_mask	: 32,
+		vm_idx		:  2,
+		reserved_0	: 30;
+	u64	data[TDX_ERR_DATA_PART_2];
+	u64	fn;	/* Non-zero for hypercalls, zero otherwise */
+	u64	subfn;
+	union {
+		struct tdh_vp_enter_vmcall 		vmcall;
+		struct tdh_vp_enter_gettdvmcallinfo	gettdvmcallinfo;
+		struct tdh_vp_enter_mapgpa		mapgpa;
+		struct tdh_vp_enter_getquote		getquote;
+		struct tdh_vp_enter_reportfatalerror	reportfatalerror;
+		struct tdh_vp_enter_cpuid		cpuid;
+		struct tdh_vp_enter_mmio		mmio;
+		struct tdh_vp_enter_hlt			hlt;
+		struct tdh_vp_enter_io			io;
+		struct tdh_vp_enter_rd			rd;
+		struct tdh_vp_enter_wr			wr;
+	};
+};
+
+/* Must be kept exactly in sync with struct tdx_module_args */
+union tdh_vp_enter_args {
+	/* Input Format #2 : Following a previous TDCALL(TDG.VP.VMCALL) */
+	struct tdh_vp_enter_in in;
+	/*
+	 * Output Formats #2 and #3 combined:
+	 *	#2 : Async TD exits with a VMX Architectural Exit Reason
+	 *	#3 : Async TD exits with a non-VMX TD Exit Status
+	 */
+	struct tdh_vp_enter_out out;
+	/* Output Format #5 : On TDCALL(TDG.VP.VMCALL) */
+	struct tdh_vp_enter_tdcall tdcall;
+};
+
 /* SEAMCALL wrappers for creating/destroying/running TDX guests */
-u64 tdh_vp_enter(u64 tdvpr, struct tdx_module_args *args);
+u64 tdh_vp_enter(u64 tdvpr, union tdh_vp_enter_args *tdh_vp_enter_args);
 u64 tdh_mng_addcx(u64 tdr, u64 tdcs);
 u64 tdh_mem_page_add(u64 tdr, u64 gpa, u64 hpa, u64 source, u64 *rcx, u64 *rdx);
 u64 tdh_mem_sept_add(u64 tdr, u64 gpa, u64 level, u64 hpa, u64 *rcx, u64 *rdx);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f5fc1a782b5b..56af7b8c71ab 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -211,57 +211,41 @@ static bool tdx_check_exit_reason(struct kvm_vcpu *vcpu, u16 reason)
 
 static __always_inline unsigned long tdexit_exit_qual(struct kvm_vcpu *vcpu)
 {
-	return kvm_rcx_read(vcpu);
+	return to_tdx(vcpu)->vp_enter_args.out.exit_qual;
 }
 
 static __always_inline unsigned long tdexit_ext_exit_qual(struct kvm_vcpu *vcpu)
 {
-	return kvm_rdx_read(vcpu);
+	return to_tdx(vcpu)->vp_enter_args.out.ext_exit_qual;
 }
 
 static __always_inline unsigned long tdexit_gpa(struct kvm_vcpu *vcpu)
 {
-	return kvm_r8_read(vcpu);
+	return to_tdx(vcpu)->vp_enter_args.out.gpa;
 }
 
 static __always_inline unsigned long tdexit_intr_info(struct kvm_vcpu *vcpu)
 {
-	return kvm_r9_read(vcpu);
+	return to_tdx(vcpu)->vp_enter_args.out.interrupt_info;
 }
 
-#define BUILD_TDVMCALL_ACCESSORS(param, gpr)				\
-static __always_inline							\
-unsigned long tdvmcall_##param##_read(struct kvm_vcpu *vcpu)		\
-{									\
-	return kvm_##gpr##_read(vcpu);					\
-}									\
-static __always_inline void tdvmcall_##param##_write(struct kvm_vcpu *vcpu, \
-						     unsigned long val)  \
-{									\
-	kvm_##gpr##_write(vcpu, val);					\
-}
-BUILD_TDVMCALL_ACCESSORS(a0, r12);
-BUILD_TDVMCALL_ACCESSORS(a1, r13);
-BUILD_TDVMCALL_ACCESSORS(a2, r14);
-BUILD_TDVMCALL_ACCESSORS(a3, r15);
-
 static __always_inline unsigned long tdvmcall_exit_type(struct kvm_vcpu *vcpu)
 {
-	return kvm_r10_read(vcpu);
+	return to_tdx(vcpu)->vp_enter_args.tdcall.fn;
 }
 static __always_inline unsigned long tdvmcall_leaf(struct kvm_vcpu *vcpu)
 {
-	return kvm_r11_read(vcpu);
+	return to_tdx(vcpu)->vp_enter_args.tdcall.subfn;
 }
 static __always_inline void tdvmcall_set_return_code(struct kvm_vcpu *vcpu,
 						     long val)
 {
-	kvm_r10_write(vcpu, val);
+	to_tdx(vcpu)->vp_enter_args.in.ret_code = val;
 }
 static __always_inline void tdvmcall_set_return_val(struct kvm_vcpu *vcpu,
 						    unsigned long val)
 {
-	kvm_r11_write(vcpu, val);
+	to_tdx(vcpu)->vp_enter_args.in.read.value = val;
 }
 
 static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
@@ -745,7 +729,7 @@ bool tdx_interrupt_allowed(struct kvm_vcpu *vcpu)
 	    tdvmcall_exit_type(vcpu) || tdvmcall_leaf(vcpu) != EXIT_REASON_HLT)
 	    return true;
 
-	return !tdvmcall_a0_read(vcpu);
+	return !to_tdx(vcpu)->vp_enter_args.tdcall.hlt.intr_blocked_flag;
 }
 
 bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
@@ -899,51 +883,10 @@ static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
 static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
-	struct tdx_module_args args;
 
 	guest_state_enter_irqoff();
 
-	/*
-	 * TODO: optimization:
-	 * - Eliminate copy between args and vcpu->arch.regs.
-	 * - copyin/copyout registers only if (tdx->tdvmvall.regs_mask != 0)
-	 *   which means TDG.VP.VMCALL.
-	 */
-	args = (struct tdx_module_args) {
-		.rcx = tdx->tdvpr_pa,
-#define REG(reg, REG)	.reg = vcpu->arch.regs[VCPU_REGS_ ## REG]
-		REG(rdx, RDX),
-		REG(r8,  R8),
-		REG(r9,  R9),
-		REG(r10, R10),
-		REG(r11, R11),
-		REG(r12, R12),
-		REG(r13, R13),
-		REG(r14, R14),
-		REG(r15, R15),
-		REG(rbx, RBX),
-		REG(rdi, RDI),
-		REG(rsi, RSI),
-#undef REG
-	};
-
-	tdx->vp_enter_ret = tdh_vp_enter(tdx->tdvpr_pa, &args);
-
-#define REG(reg, REG)	vcpu->arch.regs[VCPU_REGS_ ## REG] = args.reg
-	REG(rcx, RCX);
-	REG(rdx, RDX);
-	REG(r8,  R8);
-	REG(r9,  R9);
-	REG(r10, R10);
-	REG(r11, R11);
-	REG(r12, R12);
-	REG(r13, R13);
-	REG(r14, R14);
-	REG(r15, R15);
-	REG(rbx, RBX);
-	REG(rdi, RDI);
-	REG(rsi, RSI);
-#undef REG
+	tdx->vp_enter_ret = tdh_vp_enter(tdx->tdvpr_pa, &tdx->vp_enter_args);
 
 	if (tdx_check_exit_reason(vcpu, EXIT_REASON_EXCEPTION_NMI) &&
 	    is_nmi(tdexit_intr_info(vcpu)))
@@ -1083,8 +1026,15 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
 
 static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
 	int r;
 
+	kvm_r10_write(vcpu, tdx->vp_enter_args.tdcall.fn);
+	kvm_r11_write(vcpu, tdx->vp_enter_args.tdcall.subfn);
+	kvm_r12_write(vcpu, tdx->vp_enter_args.tdcall.vmcall.p2);
+	kvm_r13_write(vcpu, tdx->vp_enter_args.tdcall.vmcall.p3);
+	kvm_r14_write(vcpu, tdx->vp_enter_args.tdcall.vmcall.p4);
+
 	/*
 	 * ABI for KVM tdvmcall argument:
 	 * In Guest-Hypervisor Communication Interface(GHCI) specification,
@@ -1092,13 +1042,12 @@ static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
 	 * vendor-specific.  KVM uses this for KVM hypercall.  NOTE: KVM
 	 * hypercall number starts from one.  Zero isn't used for KVM hypercall
 	 * number.
-	 *
-	 * R10: KVM hypercall number
-	 * arguments: R11, R12, R13, R14.
 	 */
 	r = __kvm_emulate_hypercall(vcpu, r10, r11, r12, r13, r14, true, 0,
 				    R10, complete_hypercall_exit);
 
+	tdvmcall_set_return_code(vcpu, kvm_r10_read(vcpu));
+
 	return r > 0;
 }
 
@@ -1116,7 +1065,7 @@ static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
 
 	if(vcpu->run->hypercall.ret) {
 		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
-		kvm_r11_write(vcpu, tdx->map_gpa_next);
+		tdx->vp_enter_args.in.mapgpa.failed_gpa = tdx->map_gpa_next;
 		return 1;
 	}
 
@@ -1137,7 +1086,7 @@ static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
 	if (pi_has_pending_interrupt(vcpu) ||
 	    kvm_test_request(KVM_REQ_NMI, vcpu) || vcpu->arch.nmi_pending) {
 		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
-		kvm_r11_write(vcpu, tdx->map_gpa_next);
+		tdx->vp_enter_args.in.mapgpa.failed_gpa = tdx->map_gpa_next;
 		return 1;
 	}
 
@@ -1169,8 +1118,8 @@ static void __tdx_map_gpa(struct vcpu_tdx * tdx)
 static int tdx_map_gpa(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_tdx * tdx = to_tdx(vcpu);
-	u64 gpa = tdvmcall_a0_read(vcpu);
-	u64 size = tdvmcall_a1_read(vcpu);
+	u64 gpa  = tdx->vp_enter_args.tdcall.mapgpa.gpa;
+	u64 size = tdx->vp_enter_args.tdcall.mapgpa.size;
 	u64 ret;
 
 	/*
@@ -1206,14 +1155,19 @@ static int tdx_map_gpa(struct kvm_vcpu *vcpu)
 
 error:
 	tdvmcall_set_return_code(vcpu, ret);
-	kvm_r11_write(vcpu, gpa);
+	tdx->vp_enter_args.in.mapgpa.failed_gpa = gpa;
 	return 1;
 }
 
 static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
 {
-	u64 reg_mask = kvm_rcx_read(vcpu);
-	u64* opt_regs;
+	union tdh_vp_enter_args *args = &to_tdx(vcpu)->vp_enter_args;
+	__u64 *data = &vcpu->run->system_event.data[0];
+	u64 reg_mask = args->tdcall.reg_mask;
+	const int mask[] = {14, 15, 3, 7, 6};
+	int cnt = 0;
+
+	BUILD_BUG_ON(ARRAY_SIZE(mask) != TDX_ERR_DATA_PART_1);
 
 	/*
 	 * Skip sanity checks and let userspace decide what to do if sanity
@@ -1221,32 +1175,35 @@ static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
 	 */
 	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
 	vcpu->run->system_event.type = KVM_SYSTEM_EVENT_TDX_FATAL;
-	vcpu->run->system_event.ndata = 10;
 	/* Error codes. */
-	vcpu->run->system_event.data[0] = tdvmcall_a0_read(vcpu);
+	data[cnt++] = args->tdcall.reportfatalerror.err_codes;
 	/* GPA of additional information page. */
-	vcpu->run->system_event.data[1] = tdvmcall_a1_read(vcpu);
+	data[cnt++] = args->tdcall.reportfatalerror.err_data_gpa;
+
 	/* Information passed via registers (up to 64 bytes). */
-	opt_regs = &vcpu->run->system_event.data[2];
+	for (int i = 0; i < TDX_ERR_DATA_PART_1; i++) {
+		if (reg_mask & BIT_ULL(mask[i]))
+			data[cnt++] = args->tdcall.reportfatalerror.err_data[i];
+		else
+			data[cnt++] = 0;
+	}
 
-#define COPY_REG(REG, MASK)						\
-	do {								\
-		if (reg_mask & MASK)					\
-			*opt_regs = kvm_ ## REG ## _read(vcpu);		\
-		else							\
-			*opt_regs = 0;					\
-		opt_regs++;						\
-	} while (0)
+	if (reg_mask & BIT_ULL(8))
+		data[cnt++] = args->tdcall.data[1];
+	else
+		data[cnt++] = 0;
 
-	/* The order is defined in GHCI. */
-	COPY_REG(r14, BIT_ULL(14));
-	COPY_REG(r15, BIT_ULL(15));
-	COPY_REG(rbx, BIT_ULL(3));
-	COPY_REG(rdi, BIT_ULL(7));
-	COPY_REG(rsi, BIT_ULL(6));
-	COPY_REG(r8, BIT_ULL(8));
-	COPY_REG(r9, BIT_ULL(9));
-	COPY_REG(rdx, BIT_ULL(2));
+	if (reg_mask & BIT_ULL(9))
+		data[cnt++] = args->tdcall.data[2];
+	else
+		data[cnt++] = 0;
+
+	if (reg_mask & BIT_ULL(2))
+		data[cnt++] = args->tdcall.data[0];
+	else
+		data[cnt++] = 0;
+
+	vcpu->run->system_event.ndata = cnt;
 
 	/*
 	 * Set the status code according to GHCI spec, although the vCPU may
@@ -1260,18 +1217,18 @@ static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
 
 static int tdx_emulate_cpuid(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
 	u32 eax, ebx, ecx, edx;
 
-	/* EAX and ECX for cpuid is stored in R12 and R13. */
-	eax = tdvmcall_a0_read(vcpu);
-	ecx = tdvmcall_a1_read(vcpu);
+	eax = tdx->vp_enter_args.tdcall.cpuid.eax;
+	ecx = tdx->vp_enter_args.tdcall.cpuid.ecx;
 
 	kvm_cpuid(vcpu, &eax, &ebx, &ecx, &edx, false);
 
-	tdvmcall_a0_write(vcpu, eax);
-	tdvmcall_a1_write(vcpu, ebx);
-	tdvmcall_a2_write(vcpu, ecx);
-	tdvmcall_a3_write(vcpu, edx);
+	tdx->vp_enter_args.in.cpuid.eax = eax;
+	tdx->vp_enter_args.in.cpuid.ebx = ebx;
+	tdx->vp_enter_args.in.cpuid.ecx = ecx;
+	tdx->vp_enter_args.in.cpuid.edx = edx;
 
 	tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUCCESS);
 
@@ -1312,6 +1269,7 @@ static int tdx_complete_pio_in(struct kvm_vcpu *vcpu)
 static int tdx_emulate_io(struct kvm_vcpu *vcpu)
 {
 	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
 	unsigned long val = 0;
 	unsigned int port;
 	int size, ret;
@@ -1319,9 +1277,9 @@ static int tdx_emulate_io(struct kvm_vcpu *vcpu)
 
 	++vcpu->stat.io_exits;
 
-	size = tdvmcall_a0_read(vcpu);
-	write = tdvmcall_a1_read(vcpu);
-	port = tdvmcall_a2_read(vcpu);
+	size  = tdx->vp_enter_args.tdcall.io.size;
+	write = tdx->vp_enter_args.tdcall.io.direction;
+	port  = tdx->vp_enter_args.tdcall.io.port;
 
 	if (size != 1 && size != 2 && size != 4) {
 		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
@@ -1329,7 +1287,7 @@ static int tdx_emulate_io(struct kvm_vcpu *vcpu)
 	}
 
 	if (write) {
-		val = tdvmcall_a3_read(vcpu);
+		val = tdx->vp_enter_args.tdcall.io.value;
 		ret = ctxt->ops->pio_out_emulated(ctxt, size, port, &val, 1);
 	} else {
 		ret = ctxt->ops->pio_in_emulated(ctxt, size, port, &val, 1);
@@ -1397,14 +1355,15 @@ static inline int tdx_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, int size)
 
 static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
 	int size, write, r;
 	unsigned long val;
 	gpa_t gpa;
 
-	size = tdvmcall_a0_read(vcpu);
-	write = tdvmcall_a1_read(vcpu);
-	gpa = tdvmcall_a2_read(vcpu);
-	val = write ? tdvmcall_a3_read(vcpu) : 0;
+	size  = tdx->vp_enter_args.tdcall.mmio.size;
+	write = tdx->vp_enter_args.tdcall.mmio.direction;
+	gpa   = tdx->vp_enter_args.tdcall.mmio.mmio_addr;
+	val = write ? tdx->vp_enter_args.tdcall.mmio.value : 0;
 
 	if (size != 1 && size != 2 && size != 4 && size != 8)
 		goto error;
@@ -1456,7 +1415,7 @@ static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
 
 static int tdx_emulate_rdmsr(struct kvm_vcpu *vcpu)
 {
-	u32 index = tdvmcall_a0_read(vcpu);
+	u32 index = to_tdx(vcpu)->vp_enter_args.tdcall.rd.msr;
 	u64 data;
 
 	if (!kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_READ) ||
@@ -1474,8 +1433,8 @@ static int tdx_emulate_rdmsr(struct kvm_vcpu *vcpu)
 
 static int tdx_emulate_wrmsr(struct kvm_vcpu *vcpu)
 {
-	u32 index = tdvmcall_a0_read(vcpu);
-	u64 data = tdvmcall_a1_read(vcpu);
+	u32 index = to_tdx(vcpu)->vp_enter_args.tdcall.wr.msr;
+	u64 data  = to_tdx(vcpu)->vp_enter_args.tdcall.wr.value;
 
 	if (!kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_WRITE) ||
 	    kvm_set_msr(vcpu, index, data)) {
@@ -1491,14 +1450,16 @@ static int tdx_emulate_wrmsr(struct kvm_vcpu *vcpu)
 
 static int tdx_get_td_vm_call_info(struct kvm_vcpu *vcpu)
 {
-	if (tdvmcall_a0_read(vcpu))
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	if (tdx->vp_enter_args.tdcall.gettdvmcallinfo.leaf) {
 		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
-	else {
+	} else {
 		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUCCESS);
-		kvm_r11_write(vcpu, 0);
-		tdvmcall_a0_write(vcpu, 0);
-		tdvmcall_a1_write(vcpu, 0);
-		tdvmcall_a2_write(vcpu, 0);
+		tdx->vp_enter_args.in.gettdvmcallinfo[0] = 0;
+		tdx->vp_enter_args.in.gettdvmcallinfo[1] = 0;
+		tdx->vp_enter_args.in.gettdvmcallinfo[2] = 0;
+		tdx->vp_enter_args.in.gettdvmcallinfo[3] = 0;
 	}
 	return 1;
 }
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index c9daf71d358a..a0d33b048b7e 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -71,6 +71,7 @@ struct vcpu_tdx {
 	struct list_head cpu_list;
 
 	u64 vp_enter_ret;
+	union tdh_vp_enter_args vp_enter_args;
 
 	enum vcpu_tdx_state state;
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 16e0b598c4ec..d5c06c5eeaec 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1600,8 +1600,10 @@ static inline u64 tdx_seamcall_sept(u64 op, struct tdx_module_args *in)
 	return ret;
 }
 
-noinstr u64 tdh_vp_enter(u64 tdvpr, struct tdx_module_args *args)
+noinstr u64 tdh_vp_enter(u64 tdvpr, union tdh_vp_enter_args *vp_enter_args)
 {
+	struct tdx_module_args *args = (struct tdx_module_args *)vp_enter_args;
+
 	args->rcx = tdvpr;
 
 	return __seamcall_saved_ret(TDH_VP_ENTER, args);
-- 
2.43.0


