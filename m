Return-Path: <kvm+bounces-62553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7226AC488C8
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 19:27:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAE963B91BC
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:26:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D11B330301;
	Mon, 10 Nov 2025 18:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nYep8g6h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F96C32ED46;
	Mon, 10 Nov 2025 18:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762799078; cv=none; b=f/MJw15nSPqeuqbdnCKKwGqf0CPdtjK82ciluLDtlbPxWUxIltpHIFe0Thj2i1VSb3IZLD55nhZYKca3MXcGYglPfrL9CEubEZ2AHSfmRFPLVIp2ABzJcrWXv/jm+uqfYIRGv8oXYRxV+M29m9rO6suN94zqTyxEcD/CKOG4g7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762799078; c=relaxed/simple;
	bh=NefA63Pt7iC0ongl/5CkrpdKXbIXnrDJwvgQ440aYxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bVVYaMhr/OrpFiNNUmA65awRaNh4KSVUPRLseO6254wqc+gJ94amMdI+S+tqjraAYcgvry/Y90A4oF8t3YrEcerlq4nRHTSMLosAhkOG5RcHewkwm3HktPKMQrKcSf4PKsjLZkOjq/QiXutkeEZJW+uDNGuHMnRKZ1ysN+X/G1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nYep8g6h; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762799077; x=1794335077;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NefA63Pt7iC0ongl/5CkrpdKXbIXnrDJwvgQ440aYxk=;
  b=nYep8g6hYE+ASveaOMWEndlkEC++X2Ded60T7inufE3bBL29wzUAdxkk
   ztKOlEvqzhecfUzZk+lWh4JweFARnBEJA282omHr1N+LjVStAJhgaOeGy
   BJTXx3uo49FXgPLYTWeFFnlYbVaiVp4nMkdcUScPBj3+i8BQjgalcw7hn
   CCxmKxmllwVX0zhbrboUSl7WpQcTOyR0Lgr3cM+bbychRfj6qTNcQBFDl
   7q77TG/NNAi6WX7Nt4xRUxBCK5fdl/nzwjx8OREPQDbYqWhznash/FFvQ
   yDR0hV7uyAzBFi7se2VdJsm1fClr+8zwHHx8v06MjEs6QQ7WlA1T+OaPP
   w==;
X-CSE-ConnectionGUID: TmmsN5o2QQ2LhMjFGchO/Q==
X-CSE-MsgGUID: rcsGcnKpSKyDrXSiQDY0QA==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="76305481"
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="76305481"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 10:24:37 -0800
X-CSE-ConnectionGUID: oQA/fvitRviOmblbQ7Hu9A==
X-CSE-MsgGUID: 4WqVmKFZSg6q5DtdP51mEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="219396040"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 10 Nov 2025 10:24:37 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	chao.gao@intel.com,
	zhao1.liu@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH RFC v1 02/20] KVM: x86: Refactor GPR accessors to differentiate register access types
Date: Mon, 10 Nov 2025 18:01:13 +0000
Message-ID: <20251110180131.28264-3-chang.seok.bae@intel.com>
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

Refactor the GPR accessors to introduce internal helpers to distinguish
between legacy and extended registers.

x86 CPUs introduce additional GPRs, but those registers will initially
remain unused in the kernel and will not be saved in KVM register cache
on every VM exit. Guest states are expected to remain live in hardware
registers.

This abstraction layer centralizes the selection of access methods,
providing a unified interface. For now, the EGPR accessors are
placeholders to be implemented later.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
 arch/x86/include/asm/kvm_host.h      | 18 ++++++++++++
 arch/x86/include/asm/kvm_vcpu_regs.h | 16 ++++++++++
 arch/x86/kvm/fpu.h                   |  6 ++++
 arch/x86/kvm/x86.h                   | 44 ++++++++++++++++++++++++++--
 4 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 48598d017d6f..940f83c121cf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -212,6 +212,24 @@ enum {
 	VCPU_SREG_GS,
 	VCPU_SREG_TR,
 	VCPU_SREG_LDTR,
+#ifdef CONFIG_X86_64
+	VCPU_XREG_R16 = __VCPU_XREG_R16,
+	VCPU_XREG_R17 = __VCPU_XREG_R17,
+	VCPU_XREG_R18 = __VCPU_XREG_R18,
+	VCPU_XREG_R19 = __VCPU_XREG_R19,
+	VCPU_XREG_R20 = __VCPU_XREG_R20,
+	VCPU_XREG_R21 = __VCPU_XREG_R21,
+	VCPU_XREG_R22 = __VCPU_XREG_R22,
+	VCPU_XREG_R23 = __VCPU_XREG_R23,
+	VCPU_XREG_R24 = __VCPU_XREG_R24,
+	VCPU_XREG_R25 = __VCPU_XREG_R25,
+	VCPU_XREG_R26 = __VCPU_XREG_R26,
+	VCPU_XREG_R27 = __VCPU_XREG_R27,
+	VCPU_XREG_R28 = __VCPU_XREG_R28,
+	VCPU_XREG_R29 = __VCPU_XREG_R29,
+	VCPU_XREG_R30 = __VCPU_XREG_R30,
+	VCPU_XREG_R31 = __VCPU_XREG_R31,
+#endif
 };
 
 enum exit_fastpath_completion {
diff --git a/arch/x86/include/asm/kvm_vcpu_regs.h b/arch/x86/include/asm/kvm_vcpu_regs.h
index 1af2cb59233b..dd0cc171f405 100644
--- a/arch/x86/include/asm/kvm_vcpu_regs.h
+++ b/arch/x86/include/asm/kvm_vcpu_regs.h
@@ -20,6 +20,22 @@
 #define __VCPU_REGS_R13 13
 #define __VCPU_REGS_R14 14
 #define __VCPU_REGS_R15 15
+#define __VCPU_XREG_R16 16
+#define __VCPU_XREG_R17 17
+#define __VCPU_XREG_R18 18
+#define __VCPU_XREG_R19 19
+#define __VCPU_XREG_R20 20
+#define __VCPU_XREG_R21 21
+#define __VCPU_XREG_R22 22
+#define __VCPU_XREG_R23 23
+#define __VCPU_XREG_R24 24
+#define __VCPU_XREG_R25 25
+#define __VCPU_XREG_R26 26
+#define __VCPU_XREG_R27 27
+#define __VCPU_XREG_R28 28
+#define __VCPU_XREG_R29 29
+#define __VCPU_XREG_R30 30
+#define __VCPU_XREG_R31 31
 #endif
 
 #endif /* _ASM_X86_KVM_VCPU_REGS_H */
diff --git a/arch/x86/kvm/fpu.h b/arch/x86/kvm/fpu.h
index 3ba12888bf66..159239b3a651 100644
--- a/arch/x86/kvm/fpu.h
+++ b/arch/x86/kvm/fpu.h
@@ -4,6 +4,7 @@
 #define __KVM_FPU_H_
 
 #include <asm/fpu/api.h>
+#include <asm/kvm_vcpu_regs.h>
 
 typedef u32		__attribute__((vector_size(16))) sse128_t;
 #define __sse128_u	union { sse128_t vec; u64 as_u64[2]; u32 as_u32[4]; }
@@ -137,4 +138,9 @@ static inline void kvm_write_mmx_reg(int reg, const u64 *data)
 	kvm_fpu_put();
 }
 
+#ifdef CONFIG_X86_64
+static inline unsigned long kvm_read_egpr(int reg) { return 0; }
+static inline void kvm_write_egpr(int reg, unsigned long data) { }
+#endif
+
 #endif
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 4edadd64d3d5..74ae8f12b5a1 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -400,9 +400,49 @@ static inline bool vcpu_match_mmio_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
 	return false;
 }
 
+#ifdef CONFIG_X86_64
+static inline unsigned long _kvm_gpr_read(struct kvm_vcpu *vcpu, int reg)
+{
+	switch (reg) {
+	case VCPU_REGS_RAX ... VCPU_REGS_R15:
+		return kvm_register_read_raw(vcpu, reg);
+	case VCPU_XREG_R16 ... VCPU_XREG_R31:
+		return kvm_read_egpr(reg);
+	default:
+		WARN_ON_ONCE(1);
+	}
+
+	return 0;
+}
+
+static inline void _kvm_gpr_write(struct kvm_vcpu *vcpu, int reg, unsigned long val)
+{
+	switch (reg) {
+	case VCPU_REGS_RAX ... VCPU_REGS_R15:
+		kvm_register_write_raw(vcpu, reg, val);
+		break;
+	case VCPU_XREG_R16 ... VCPU_XREG_R31:
+		kvm_write_egpr(reg, val);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+	}
+}
+#else
+static inline unsigned long _kvm_gpr_read(struct kvm_vcpu *vcpu, int reg)
+{
+	return kvm_register_read_raw(vcpu, reg);
+}
+
+static inline void _kvm_gpr_write(struct kvm_vcpu *vcpu, int reg, unsigned long val)
+{
+	kvm_register_write_raw(vcpu, reg, val);
+}
+#endif
+
 static inline unsigned long kvm_gpr_read(struct kvm_vcpu *vcpu, int reg)
 {
-	unsigned long val = kvm_register_read_raw(vcpu, reg);
+	unsigned long val = _kvm_gpr_read(vcpu, reg);
 
 	return is_64_bit_mode(vcpu) ? val : (u32)val;
 }
@@ -411,7 +451,7 @@ static inline void kvm_gpr_write(struct kvm_vcpu *vcpu, int reg, unsigned long v
 {
 	if (!is_64_bit_mode(vcpu))
 		val = (u32)val;
-	return kvm_register_write_raw(vcpu, reg, val);
+	_kvm_gpr_write(vcpu, reg, val);
 }
 
 static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
-- 
2.51.0


