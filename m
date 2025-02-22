Return-Path: <kvm+bounces-38930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 122FDA404C7
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 02:42:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2DC7119E1904
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 01:42:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1100D201034;
	Sat, 22 Feb 2025 01:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gs93dp8M"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9595B200130;
	Sat, 22 Feb 2025 01:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740188469; cv=none; b=Oei0EbD/eJ7aU5/u5CsV3yX1rheAnqTEz0/4bQSKY8CboSxogVK7Ixsg/Y31Y96RI7k/sI2P3xM0QGJ6CUijUZDba0B0JKGomMkUDhD6bocbnVfI8mDTMvAx/1stEOpti2VwG8KGRokJ9YsXpYuEAwGw/SMP8UWduaPKEwMzvJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740188469; c=relaxed/simple;
	bh=za4bNwA2okJnYR/YSYB+oyMuCgwn6f1EQ8xQRtbHG0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Suz/AbzadkPvQzvo5ZCHjyYtnqW7sLMdPN6V4a9vkIl0j4vIsx85oc4g9dnNaAcXKufjL4C2W64Rm+2vQIMWevVBwrlAIvzvf4bJ4gipHMH/qt5gx//sMuDape/n+PfyAYYbOurNu51nvSSvOCqV/MxIfJr672EDduHnyGbxY9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gs93dp8M; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740188467; x=1771724467;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=za4bNwA2okJnYR/YSYB+oyMuCgwn6f1EQ8xQRtbHG0U=;
  b=gs93dp8M+J52PEVF8GbcaU/h5DwR6HVKjYbgQevm2C70sqKGSekzxIcD
   RcWL1CIMDre7f9LxkDAuaeRh+D2o40qaU1ImeHNoKVaWLC6XsnTDMdcI4
   ddxkaQ/pxg8y0GyxO3Udc0VDWLqvEEB080noVWm+CycP0/m0AZwrJpToy
   Q0QniRWVG2aoiy0l9tf2vBblnDugMu/NBpreDx6UzgxGIamgNkeYiVRUU
   5nu9ms0VtZz0xX4LKEeQjTohP/SruZ1VPd3o37nSRHC5vUmHbIhfrjHEx
   y3vroGdz7qrlT+gyuRTFV1eyiQSjGreSBVFOnfBSLpBc0beIb384hQuvA
   Q==;
X-CSE-ConnectionGUID: CpPlL0+PTlG6tILbmzy9UQ==
X-CSE-MsgGUID: Ud/CrJ4ZRu+i9/IATgH0cg==
X-IronPort-AV: E=McAfee;i="6700,10204,11352"; a="40893272"
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="40893272"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:41:07 -0800
X-CSE-ConnectionGUID: u+K80Uy6RvyjIfrWOJTEBQ==
X-CSE-MsgGUID: DzAoefyURqGOTEj5octNDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="146370246"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:41:04 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH v3 4/9] KVM: TDX: Add a place holder for handler of TDX hypercalls (TDG.VP.VMCALL)
Date: Sat, 22 Feb 2025 09:42:20 +0800
Message-ID: <20250222014225.897298-5-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250222014225.897298-1-binbin.wu@linux.intel.com>
References: <20250222014225.897298-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a place holder and related helper functions for preparation of
TDG.VP.VMCALL handling.

The TDX module specification defines TDG.VP.VMCALL API (TDVMCALL for short)
for the guest TD to call hypercall to VMM.  When the guest TD issues a
TDVMCALL, the guest TD exits to VMM with a new exit reason.  The arguments
from the guest TD and returned values from the VMM are passed in the guest
registers.  The guest RCX register indicates which registers are used.
Define helper functions to access those registers.

A new VMX exit reason TDCALL is added to indicate the exit is due to
TDVMCALL from the guest TD.  Define the TDCALL exit reason and add a place
holder to handle such exit.

Some leafs of TDCALL will be morphed to another VMX exit reason instead of
EXIT_REASON_TDCALL, add a helper tdcall_to_vmx_exit_reason() as a place
holder to do the conversion.

Suggested-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
---
Hypercalls exit to userspace v3:
- Add missing blank new lines. (Chao)
- Do not morph all leafs less than 0x10000 unconditionally. (Chao)

Hypercalls exit to userspace v2:
- Get/set tdvmcall inputs/outputs from/to vp_enter_args.
- Morph the guest requested exit reason (via TDVMCALL) to KVM's tracked
  exit reason when it could, i.e. when the TDVMCALL leaf number is less
  than 0x10000. (Sean)
- Drop helpers for read/write a0~a3.

Hypercalls exit to userspace v1:
- Update changelog.
- Drop the unused tdx->tdvmcall. (Chao)
- Use TDVMCALL_STATUS prefix for TDX call status codes (Binbin)
---
 arch/x86/include/uapi/asm/vmx.h |  4 ++-
 arch/x86/kvm/vmx/tdx.c          | 60 ++++++++++++++++++++++++++++++++-
 2 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index a5faf6d88f1b..6a9f268a2d2c 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -92,6 +92,7 @@
 #define EXIT_REASON_TPAUSE              68
 #define EXIT_REASON_BUS_LOCK            74
 #define EXIT_REASON_NOTIFY              75
+#define EXIT_REASON_TDCALL              77
 
 #define VMX_EXIT_REASONS \
 	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
@@ -155,7 +156,8 @@
 	{ EXIT_REASON_UMWAIT,                "UMWAIT" }, \
 	{ EXIT_REASON_TPAUSE,                "TPAUSE" }, \
 	{ EXIT_REASON_BUS_LOCK,              "BUS_LOCK" }, \
-	{ EXIT_REASON_NOTIFY,                "NOTIFY" }
+	{ EXIT_REASON_NOTIFY,                "NOTIFY" }, \
+	{ EXIT_REASON_TDCALL,                "TDCALL" }
 
 #define VMX_EXIT_REASON_FLAGS \
 	{ VMX_EXIT_REASONS_FAILED_VMENTRY,	"FAILED_VMENTRY" }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 4e46ebfb849a..7a5f375d976a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -224,6 +224,28 @@ static bool tdx_operand_busy(u64 err)
  */
 static DEFINE_PER_CPU(struct list_head, associated_tdvcpus);
 
+static __always_inline unsigned long tdvmcall_exit_type(struct kvm_vcpu *vcpu)
+{
+	return to_tdx(vcpu)->vp_enter_args.r10;
+}
+
+static __always_inline unsigned long tdvmcall_leaf(struct kvm_vcpu *vcpu)
+{
+	return to_tdx(vcpu)->vp_enter_args.r11;
+}
+
+static __always_inline void tdvmcall_set_return_code(struct kvm_vcpu *vcpu,
+						     long val)
+{
+	to_tdx(vcpu)->vp_enter_args.r10 = val;
+}
+
+static __always_inline void tdvmcall_set_return_val(struct kvm_vcpu *vcpu,
+						    unsigned long val)
+{
+	to_tdx(vcpu)->vp_enter_args.r11 = val;
+}
+
 static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
 {
 	tdx_guest_keyid_free(kvm_tdx->hkid);
@@ -799,9 +821,20 @@ static bool tdx_guest_state_is_invalid(struct kvm_vcpu *vcpu)
 		!guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES));
 }
 
+static __always_inline u32 tdcall_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
+{
+	switch (tdvmcall_leaf(vcpu)) {
+	default:
+		break;
+	}
+
+	return EXIT_REASON_TDCALL;
+}
+
 static __always_inline u32 tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	u32 exit_reason;
 
 	switch (tdx->vp_enter_ret & TDX_SEAMCALL_STATUS_MASK) {
 	case TDX_SUCCESS:
@@ -814,7 +847,19 @@ static __always_inline u32 tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
 		return -1u;
 	}
 
-	return tdx->vp_enter_ret;
+	exit_reason = tdx->vp_enter_ret;
+
+	switch (exit_reason) {
+	case EXIT_REASON_TDCALL:
+		if (tdvmcall_exit_type(vcpu))
+			return EXIT_REASON_VMCALL;
+
+		return tdcall_to_vmx_exit_reason(vcpu);
+	default:
+		break;
+	}
+
+	return exit_reason;
 }
 
 static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu)
@@ -922,6 +967,17 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 	return tdx_exit_handlers_fastpath(vcpu);
 }
 
+static int handle_tdvmcall(struct kvm_vcpu *vcpu)
+{
+	switch (tdvmcall_leaf(vcpu)) {
+	default:
+		break;
+	}
+
+	tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
+	return 1;
+}
+
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 {
 	u64 shared_bit = (pgd_level == 5) ? TDX_SHARED_BIT_PWL_5 :
@@ -1280,6 +1336,8 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 		vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
 		vcpu->mmio_needed = 0;
 		return 0;
+	case EXIT_REASON_TDCALL:
+		return handle_tdvmcall(vcpu);
 	default:
 		break;
 	}
-- 
2.46.0


