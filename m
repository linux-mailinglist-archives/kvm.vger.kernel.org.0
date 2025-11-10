Return-Path: <kvm+bounces-62568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 3680CC48928
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 19:32:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 042FA4F150B
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:30:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC26833710F;
	Mon, 10 Nov 2025 18:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BZJ2Qr4o"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E7B337BA7;
	Mon, 10 Nov 2025 18:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762799107; cv=none; b=envLFZQEDQcfV4v2enYQEDSpb4wjilD7md30zSw9IYiVb9KW9/rjJPLg5R66cuS+CSQl+d1o2YpuoG0+xt5eqIyNj2lw5/0N49wSE6S57cODfDiFnLPPfpKxGNl2drAZBPOBUJWQi+c6Hh/chartloEUsW7ioj33j4lW898j2eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762799107; c=relaxed/simple;
	bh=yv77DOMcvVXHx2A9/x6zUQan80ucLdQCNqzpepizjPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFA7tejqrYHt/L/KaJ/PPuq/JaWBFqa7hmxOBNBTnDNTAKWCY+HwlyTU/VZrmMYfR++zITUcY+c4v32+1G3aeMr1TTY2gi2tizgcVokZbHqz9vxXhTdvOdY2BgHu1ka4qSwWGepTdArOHa7VnrLHKx7YUe2uapGbZZeL2RHkhoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BZJ2Qr4o; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762799106; x=1794335106;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yv77DOMcvVXHx2A9/x6zUQan80ucLdQCNqzpepizjPU=;
  b=BZJ2Qr4o3TH/a76tMWsl6fVmOeLQnTXvV8VE3gLkhyfSgsrNlZXnr5E0
   oqPEgerHbJNtgYUHLhXhllWEX1A51ZxWd8Ximgx5X37XypY/NIDQKzCUx
   qWwLNCPqjWMk7BVOG1FL3CnfFHprdZW7biydnPb5cnWPLR/8gpn5fzrMm
   lmhJIqoKwX6ckCcBmNE0p0UTqWjR5PsvLA6jQ6PLTQR0aPjo7WLXJ0UNy
   xzGP/xInoNftQSvu9PK/2EKE1Iv5843aT+LbSvIEXwjq1QZPwcPSo9w++
   7mA/+DA/PVTOOM0yQG6Wq6YGSeqKBymMbYITrk1PctbSq5kleLoEpu6zE
   g==;
X-CSE-ConnectionGUID: zH2AhCNTT/uwx6f2xBG0eg==
X-CSE-MsgGUID: 802gRZkLQWiJ4oGn1e2wTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="76305523"
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="76305523"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 10:25:06 -0800
X-CSE-ConnectionGUID: XSsQtCZATrG/HScYGLFBmQ==
X-CSE-MsgGUID: VHm/Ym8GQU+P2xtd5K4AQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="219396233"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 10 Nov 2025 10:25:06 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	chao.gao@intel.com,
	zhao1.liu@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH RFC v1 17/20] KVM: x86: Prepare APX state setting in XCR0
Date: Mon, 10 Nov 2025 18:01:28 +0000
Message-ID: <20251110180131.28264-18-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251110180131.28264-1-chang.seok.bae@intel.com>
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Prepare the APX state enabling in XCR0 by implementing the previous
placeholders and ensuring its readiness.

APX introduces EGPRs, tracked as XSTATE component 19. Like other
XSAVE-managed states, EGPR availability is controlled through XCR0, and
the registers are accessible only in 64-bit mode.

At this point, only VMX supports EGPRs. SVM will require corresponding
extensions to handle EGPR indices.

The addition to the supported XCR0 mask should accompany guest CPUID
exposure, which will be done separately.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
RFC note
Not all callers may need to validate the XCR0 bit -- maybe a capability
bit. However, every exit associated with EGPRs should already have that
control bit set in the first place. Checking it explicitly does not
charge additional cost, so I have this for consistency.
---
 arch/x86/kvm/emulate.c        |  9 +++++++--
 arch/x86/kvm/kvm_cache_regs.h |  1 +
 arch/x86/kvm/kvm_emulate.h    |  1 +
 arch/x86/kvm/svm/svm.c        |  7 ++++++-
 arch/x86/kvm/vmx/vmx.h        |  9 ++++++++-
 arch/x86/kvm/x86.c            | 11 +++++++++++
 6 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index f9381a4055d6..ba3020e6f469 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4787,9 +4787,14 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
 	return rc;
 }
 
-static inline bool emul_egpr_enabled(struct x86_emulate_ctxt *ctxt __maybe_unused)
+/* EGPR availability is controlled by the APX feature bit in XCR0. */
+static inline bool emul_egpr_enabled(struct x86_emulate_ctxt *ctxt)
 {
-	return false;
+	u64 xcr0;
+
+	ctxt->ops->get_xcr(ctxt, XCR_XFEATURE_ENABLED_MASK, &xcr0);
+
+	return xcr0 & XFEATURE_MASK_APX;
 }
 
 int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int emulation_type)
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 8ddb01191d6f..acdb3751317c 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -3,6 +3,7 @@
 #define ASM_KVM_CACHE_REGS_H
 
 #include <linux/kvm_host.h>
+#include <asm/fpu/xcr.h>
 
 #define KVM_POSSIBLE_CR0_GUEST_BITS	(X86_CR0_TS | X86_CR0_WP)
 #define KVM_POSSIBLE_CR4_GUEST_BITS				  \
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index cc16211d61f6..673a82532c78 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -237,6 +237,7 @@ struct x86_emulate_ops {
 	bool (*is_smm)(struct x86_emulate_ctxt *ctxt);
 	int (*leave_smm)(struct x86_emulate_ctxt *ctxt);
 	void (*triple_fault)(struct x86_emulate_ctxt *ctxt);
+	int (*get_xcr)(struct x86_emulate_ctxt *ctxt, u32 index, u64 *xcr);
 	int (*set_xcr)(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr);
 
 	gva_t (*get_untagged_addr)(struct x86_emulate_ctxt *ctxt, gva_t addr,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3aa2c37754ef..e6a082686000 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5288,8 +5288,13 @@ static __init int svm_hardware_setup(void)
 	}
 	kvm_enable_efer_bits(EFER_NX);
 
+	/*
+	 * APX introduces EGPRs, which require additional VMCB support.
+	 * Disable APX until the necessary extensions are handled.
+	 */
 	kvm_caps.supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS |
-				     XFEATURE_MASK_BNDCSR);
+				     XFEATURE_MASK_BNDCSR  |
+				     XFEATURE_MASK_APX);
 
 	if (boot_cpu_has(X86_FEATURE_FXSR_OPT))
 		kvm_enable_efer_bits(EFER_FFXSR);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 6cf1eb739caf..784aa0504dce 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -372,7 +372,14 @@ struct vmx_insn_info {
 	union insn_info info;
 };
 
-static inline bool vmx_egpr_enabled(struct kvm_vcpu *vcpu __maybe_unused) { return false; }
+/*
+ * EGPR availability is controlled by the APX xfeature bit in XCR0 and is
+ * only accessible in 64-bit mode.
+ */
+static inline bool vmx_egpr_enabled(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.xcr0 & XFEATURE_MASK_APX && is_64_bit_mode(vcpu);
+}
 
 static inline struct vmx_insn_info vmx_get_insn_info(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4c8c2fc3bda6..e087db0f4153 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8843,6 +8843,16 @@ static void emulator_triple_fault(struct x86_emulate_ctxt *ctxt)
 	kvm_make_request(KVM_REQ_TRIPLE_FAULT, emul_to_vcpu(ctxt));
 }
 
+static int emulator_get_xcr(struct x86_emulate_ctxt *ctxt, u32 index, u64 *xcr)
+{
+	/* Only support XCR_XFEATURE_ENABLED_MASK now  */
+	if (index != XCR_XFEATURE_ENABLED_MASK)
+		return 1;
+
+	*xcr = emul_to_vcpu(ctxt)->arch.xcr0;
+	return 0;
+}
+
 static int emulator_set_xcr(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr)
 {
 	return __kvm_set_xcr(emul_to_vcpu(ctxt), index, xcr);
@@ -8915,6 +8925,7 @@ static const struct x86_emulate_ops emulate_ops = {
 	.is_smm              = emulator_is_smm,
 	.leave_smm           = emulator_leave_smm,
 	.triple_fault        = emulator_triple_fault,
+	.get_xcr             = emulator_get_xcr,
 	.set_xcr             = emulator_set_xcr,
 	.get_untagged_addr   = emulator_get_untagged_addr,
 	.is_canonical_addr   = emulator_is_canonical_addr,
-- 
2.51.0


