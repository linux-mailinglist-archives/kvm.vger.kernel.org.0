Return-Path: <kvm+bounces-62559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81DC2C488E9
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 19:29:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE0953BA3D7
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:28:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E83443314B6;
	Mon, 10 Nov 2025 18:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ioLe45+0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0C033290C;
	Mon, 10 Nov 2025 18:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762799091; cv=none; b=tYh4wWeeLyOQSIHbq8s3HQ5RlnVUqM1YPOK2ybVhhjt0R7jVus2P6s1v0uIetmltkjEK71wZ3VIgvZLYQt7SOmFyo1Q5xEr3ahRzEoPb/cRDP00j0flHazQvfqCCwv1Grf9XPnM8gHcyl8lD90WYIYPZeffaXGRbCfN99LvgS6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762799091; c=relaxed/simple;
	bh=O1ivPnUeRMjHpWyc8+K7OqTxpqzw1Cozcpk6Zyf1pRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HkhLhvNfRAnO2X7ijaX6vfIEGa40Qw/jfUcDXCjxH4S4sRZecTKnGS/V8ooqcmGQQKlw0tS03w85emokxRVQzZ0rPUtDB7522vozKyvbsiCJiJ3mlpdLBuIRanLpO2HYRkXQ/B9weUGSX18NAEb/pIqzQNClTtcUMf6ykTJETfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ioLe45+0; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762799090; x=1794335090;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O1ivPnUeRMjHpWyc8+K7OqTxpqzw1Cozcpk6Zyf1pRE=;
  b=ioLe45+0G1zQRd3yXCI35zv7D0wLtAXylcoB/zISjmMQPxtvjqeuaGAZ
   WlixTMVWpYvCrVvYr7stZJt+KFBukFRo0ftXc1kc3mIdL9quTa8LRBWUz
   C/l4DbZOyvKKVvc6H8Ucs8EEBygBxFo0qjGN43aysA3yG7J/dtvvXYLJ/
   eKZkWXFz+I2t7dnHridBP1I3oU+2uLW3IzRrkjxVNlP1X4Clj1det+AMl
   NRju7FCzSdRvXuWYBoFGS3ppAk37kvjppc9V8ungPhXmhTl17wSeABxgc
   DZhxmLyqL/4oHU3IrUaNLw5wT6rfxFUFzb8jtuRV2gMdRz3v2HXYe48lm
   g==;
X-CSE-ConnectionGUID: 9fCHG+FcShyAJatTGTyo0A==
X-CSE-MsgGUID: Gf1pMDYdQcCBnndJJJyy0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="76305505"
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="76305505"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 10:24:50 -0800
X-CSE-ConnectionGUID: 9P1taJqKT/W+2e+t/rkGsg==
X-CSE-MsgGUID: M951pyIKTrGyHaklOzahSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="219396147"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 10 Nov 2025 10:24:50 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	chao.gao@intel.com,
	zhao1.liu@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH RFC v1 08/20] KVM: VMX: Support extended register index in exit handling
Date: Mon, 10 Nov 2025 18:01:19 +0000
Message-ID: <20251110180131.28264-9-chang.seok.bae@intel.com>
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

Support to 5-bit register indices in VMCS fields when EGPRs are enabled.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
RFC note:
The "chicken bit" (XCR0.APX) checker is intentionally deferred, as the
emulator in the next series will do a similar check. Consolidating the
XCR0 handling at the end keeps the logic clearer during the feature
exposition.
---
 arch/x86/kvm/vmx/vmx.h | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index b8da6ebc35dc..6cf1eb739caf 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -374,12 +374,17 @@ struct vmx_insn_info {
 
 static inline bool vmx_egpr_enabled(struct kvm_vcpu *vcpu __maybe_unused) { return false; }
 
-static inline struct vmx_insn_info vmx_get_insn_info(struct kvm_vcpu *vcpu __maybe_unused)
+static inline struct vmx_insn_info vmx_get_insn_info(struct kvm_vcpu *vcpu)
 {
 	struct vmx_insn_info insn;
 
-	insn.extended  = false;
-	insn.info.word = vmcs_read32(VMX_INSTRUCTION_INFO);
+	if (vmx_egpr_enabled(vcpu)) {
+		insn.extended   = true;
+		insn.info.dword = vmcs_read64(EXTENDED_INSTRUCTION_INFO);
+	} else {
+		insn.extended  = false;
+		insn.info.word = vmcs_read32(VMX_INSTRUCTION_INFO);
+	}
 
 	return insn;
 }
@@ -415,7 +420,10 @@ static __always_inline unsigned long vmx_get_exit_qual(struct kvm_vcpu *vcpu)
 
 static inline int vmx_get_exit_qual_gpr(struct kvm_vcpu *vcpu)
 {
-	return (vmx_get_exit_qual(vcpu) >> 8) & 0xf;
+	if (vmx_egpr_enabled(vcpu))
+		return (vmx_get_exit_qual(vcpu) >> 8) & 0x1f;
+	else
+		return (vmx_get_exit_qual(vcpu) >> 8) & 0xf;
 }
 
 static __always_inline u32 vmx_get_intr_info(struct kvm_vcpu *vcpu)
-- 
2.51.0


