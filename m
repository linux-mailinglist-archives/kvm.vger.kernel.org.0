Return-Path: <kvm+bounces-44452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F23AA9DAB7
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 14:33:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABB579A4454
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 12:32:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DD842566E4;
	Sat, 26 Apr 2025 12:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UcWrAa/8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5706255E2B;
	Sat, 26 Apr 2025 12:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745670543; cv=none; b=Id7op1YZXYDEcO3xPJF52pa4xPUzQSJuDTQzRYDDdQ/G6oNlikOc+M48vXhSGqUSkRDWPZBxY2ji/5YSWsNSmTyu+AjWL0THh29oIGaRIWIoHBRg45s7CuRArXaXw36E9G7GCLDRsv6Wlgq3/s1/9L6yFu8CGxtS2Y4mvGh4rdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745670543; c=relaxed/simple;
	bh=x30AyqJd+6kV4qqEkdexdcfVsNcYCTucDK0MVL8lfUE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hQ06hu5+lel7MMYlIgR1tK0KYQE0vlWGc6OvLlfIbxw6ufI242lngcXJeH9xtEPi9NagxaOODG4gDDpJAcud/rXtSPXUdlW/nVamvBVZRtVkeJ8VKCYbsSeVzJtUmaMFPx/T8zb8IuYo2J6MRyQkrpIFp7p2a0sFfLuAv1QB1EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UcWrAa/8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D11FC4CEE2;
	Sat, 26 Apr 2025 12:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745670543;
	bh=x30AyqJd+6kV4qqEkdexdcfVsNcYCTucDK0MVL8lfUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UcWrAa/819EBBMpwX4cGSrHzk3VEYJq6zeK0NPQhOv/2Ih/FOdi0aukt07h1nZG1Q
	 i/JBo18OBPlZl+VOvOxUe2f9KzKNN1MmAC6fDGSGD9/nz2bel+1IGrkucX0cNGlUV5
	 WppDys9jIe1BOHW+cBXDgb5HxBr+9YM4J8aPbgdccdEWoRzS8fG4fmwXsw8BM6n8XB
	 k5tG3DIe0nJtOxd1VC+rFl0uG7HkVqBwun+sdQUK8ACu3MgpgAtE99nEbK5fWb0rhF
	 7Qj7JQoPWrIvVSQ8QSh2+/l7VpwwexIuVk3oVdcJi+CUc8Tz98+cObvNfdMWj0SlY2
	 ppYaET9/usgKA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u8eeT-0092VH-BK;
	Sat, 26 Apr 2025 13:29:01 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 40/42] KVM: arm64: Allow sysreg ranges for FGT descriptors
Date: Sat, 26 Apr 2025 13:28:34 +0100
Message-Id: <20250426122836.3341523-41-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250426122836.3341523-1-maz@kernel.org>
References: <20250426122836.3341523-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Just like we allow sysreg ranges for Coarse Grained Trap descriptors,
allow them for Fine Grain Traps as well.

This comes with a warning that not all ranges are suitable for this
particular definition of ranges.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 120 +++++++++++---------------------
 1 file changed, 39 insertions(+), 81 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index e2a843675da96..9c7ecfccbd6e9 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -622,6 +622,11 @@ struct encoding_to_trap_config {
 	const unsigned int		line;
 };
 
+/*
+ * WARNING: using ranges is a treacherous endeavour, as sysregs that
+ * are part of an architectural range are not necessarily contiguous
+ * in the [Op0,Op1,CRn,CRm,Ops] space. Tread carefully.
+ */
 #define SR_RANGE_TRAP(sr_start, sr_end, trap_id)			\
 	{								\
 		.encoding	= sr_start,				\
@@ -1289,15 +1294,19 @@ enum fg_filter_id {
 
 #define FGT(g, b, p)		__FGT(g, b, p, __NO_FGF__)
 
-#define SR_FGF(sr, g, b, p, f)					\
+/* Same warning applies: use carefully */
+#define SR_FGF_RANGE(sr, e, g, b, p, f)				\
 	{							\
 		.encoding	= sr,				\
-		.end		= sr,				\
+		.end		= e,				\
 		.tc		= __FGT(g, b, p, f),		\
 		.line = __LINE__,				\
 	}
 
-#define SR_FGT(sr, g, b, p)	SR_FGF(sr, g, b, p, __NO_FGF__)
+#define SR_FGF(sr, g, b, p, f) 	SR_FGF_RANGE(sr, sr, g, b, p, f)
+#define SR_FGT(sr, g, b, p)	SR_FGF_RANGE(sr, sr, g, b, p, __NO_FGF__)
+#define SR_FGT_RANGE(sr, end, g, b, p)	\
+				SR_FGF_RANGE(sr, end, g, b, p, __NO_FGF__)
 
 static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
 	/* HFGRTR_EL2, HFGWTR_EL2 */
@@ -1794,68 +1803,12 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
 	SR_FGT(SYS_PMCNTENSET_EL0, 	HDFGRTR, PMCNTEN, 1),
 	SR_FGT(SYS_PMCCNTR_EL0, 	HDFGRTR, PMCCNTR_EL0, 1),
 	SR_FGT(SYS_PMCCFILTR_EL0, 	HDFGRTR, PMCCFILTR_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(0), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(1), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(2), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(3), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(4), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(5), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(6), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(7), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(8), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(9), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(10), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(11), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(12), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(13), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(14), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(15), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(16), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(17), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(18), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(19), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(20), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(21), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(22), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(23), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(24), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(25), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(26), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(27), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(28), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(29), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVTYPERn_EL0(30), 	HDFGRTR, PMEVTYPERn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(0), 	HDFGRTR, PMEVCNTRn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(1), 	HDFGRTR, PMEVCNTRn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(2), 	HDFGRTR, PMEVCNTRn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(3), 	HDFGRTR, PMEVCNTRn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(4), 	HDFGRTR, PMEVCNTRn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(5), 	HDFGRTR, PMEVCNTRn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(6), 	HDFGRTR, PMEVCNTRn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(7), 	HDFGRTR, PMEVCNTRn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(8), 	HDFGRTR, PMEVCNTRn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(9), 	HDFGRTR, PMEVCNTRn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(10), 	HDFGRTR, PMEVCNTRn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(11), 	HDFGRTR, PMEVCNTRn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(12), 	HDFGRTR, PMEVCNTRn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(13), 	HDFGRTR, PMEVCNTRn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(14), 	HDFGRTR, PMEVCNTRn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(15), 	HDFGRTR, PMEVCNTRn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(16), 	HDFGRTR, PMEVCNTRn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(17), 	HDFGRTR, PMEVCNTRn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(18), 	HDFGRTR, PMEVCNTRn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(19), 	HDFGRTR, PMEVCNTRn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(20), 	HDFGRTR, PMEVCNTRn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(21), 	HDFGRTR, PMEVCNTRn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(22), 	HDFGRTR, PMEVCNTRn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(23), 	HDFGRTR, PMEVCNTRn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(24), 	HDFGRTR, PMEVCNTRn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(25), 	HDFGRTR, PMEVCNTRn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(26), 	HDFGRTR, PMEVCNTRn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(27), 	HDFGRTR, PMEVCNTRn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(28), 	HDFGRTR, PMEVCNTRn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(29), 	HDFGRTR, PMEVCNTRn_EL0, 1),
-	SR_FGT(SYS_PMEVCNTRn_EL0(30), 	HDFGRTR, PMEVCNTRn_EL0, 1),
+	SR_FGT_RANGE(SYS_PMEVTYPERn_EL0(0),
+		     SYS_PMEVTYPERn_EL0(30),
+		     HDFGRTR, PMEVTYPERn_EL0, 1),
+	SR_FGT_RANGE(SYS_PMEVCNTRn_EL0(0),
+		     SYS_PMEVCNTRn_EL0(30),
+		     HDFGRTR, PMEVCNTRn_EL0, 1),
 	SR_FGT(SYS_OSDLR_EL1, 		HDFGRTR, OSDLR_EL1, 1),
 	SR_FGT(SYS_OSECCR_EL1, 		HDFGRTR, OSECCR_EL1, 1),
 	SR_FGT(SYS_OSLSR_EL1, 		HDFGRTR, OSLSR_EL1, 1),
@@ -2172,6 +2125,9 @@ static __init int check_all_fgt_masks(int ret)
 	return ret ?: err;
 }
 
+#define for_each_encoding_in(__x, __s, __e)	\
+	for (u32 __x = __s; __x <= __e; __x = encoding_next(__x))
+
 int __init populate_nv_trap_config(void)
 {
 	int ret = 0;
@@ -2191,7 +2147,7 @@ int __init populate_nv_trap_config(void)
 			ret = -EINVAL;
 		}
 
-		for (u32 enc = cgt->encoding; enc <= cgt->end; enc = encoding_next(enc)) {
+		for_each_encoding_in(enc, cgt->encoding, cgt->end) {
 			prev = xa_store(&sr_forward_xa, enc,
 					xa_mk_value(cgt->tc.val), GFP_KERNEL);
 			if (prev && !xa_is_err(prev)) {
@@ -2226,25 +2182,27 @@ int __init populate_nv_trap_config(void)
 			print_nv_trap_error(fgt, "Invalid FGT", ret);
 		}
 
-		tc = get_trap_config(fgt->encoding);
+		for_each_encoding_in(enc, fgt->encoding, fgt->end) {
+			tc = get_trap_config(enc);
 
-		if (tc.fgt) {
-			ret = -EINVAL;
-			print_nv_trap_error(fgt, "Duplicate FGT", ret);
-		}
+			if (tc.fgt) {
+				ret = -EINVAL;
+				print_nv_trap_error(fgt, "Duplicate FGT", ret);
+			}
 
-		tc.val |= fgt->tc.val;
-		prev = xa_store(&sr_forward_xa, fgt->encoding,
-				xa_mk_value(tc.val), GFP_KERNEL);
+			tc.val |= fgt->tc.val;
+			prev = xa_store(&sr_forward_xa, enc,
+					xa_mk_value(tc.val), GFP_KERNEL);
 
-		if (xa_is_err(prev)) {
-			ret = xa_err(prev);
-			print_nv_trap_error(fgt, "Failed FGT insertion", ret);
-		}
+			if (xa_is_err(prev)) {
+				ret = xa_err(prev);
+				print_nv_trap_error(fgt, "Failed FGT insertion", ret);
+			}
 
-		if (!aggregate_fgt(tc)) {
-			ret = -EINVAL;
-			print_nv_trap_error(fgt, "FGT bit is reserved", ret);
+			if (!aggregate_fgt(tc)) {
+				ret = -EINVAL;
+				print_nv_trap_error(fgt, "FGT bit is reserved", ret);
+			}
 		}
 	}
 
-- 
2.39.2


