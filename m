Return-Path: <kvm+bounces-52317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 37671B03DD5
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 13:56:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 79DDB189FFDC
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 11:56:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E6B2248867;
	Mon, 14 Jul 2025 11:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dDI9htLt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926D5248880;
	Mon, 14 Jul 2025 11:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752494115; cv=none; b=q2khoujfRELzXsAjmZLzfNNjynczoCxfGF7rHF0STL7eEo4STJhq21bbsJPRE3GkzoHdKIFIgIHSY1FJW5CmydI42oXelW6LzQGuroeqN/44X0llPsgTOty6BtCRJRgN5e0WUf2uxCguzakbDCbhrxfByvoNKyhDTyB4NDUydpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752494115; c=relaxed/simple;
	bh=E+z5oColGmzAqHGbFuPOh0LuM0Ab2bg2xLXf1EpYhl8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jzVFQh3J4kzxLBQ7AnpYPA0chvULnKcdAw8XhSzxwCt9W8SyS8ibaHzaiUMyv4H9eS5+iJUHFvk1ECwLgzE7dFk0Ya/mHoXHXqxdDHpBXzrFTSobzkoMLwCnGWEnakNXQtFLZZd/xGAIoh9ld+RNaHFUziohsTQJrE3ccTrKgAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dDI9htLt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4240FC4CEED;
	Mon, 14 Jul 2025 11:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752494115;
	bh=E+z5oColGmzAqHGbFuPOh0LuM0Ab2bg2xLXf1EpYhl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dDI9htLtWSRicb6k9AG6NGSzRMvk5Uq9AYVRFuPUBtseJvYs4RQx8+377NnTVnoyQ
	 Z54k1pH1Vo+Msl4ZQc+c+l0+bY/T6M9p9iDULEx1QzjveG7fYgeXAkF2WDyadds7q3
	 bbSQsJPo3BbwCNmNyf+dst+MAetW/13EsvQVftmsPV/tDLMBbAeb6FQ6hc4r/IbmoG
	 Q4vjukQNSk0Wdkpsckx0faISSNXA7Z43OX2AYkE+ZD1ZphhppXOjKEqzWJem0UoL4o
	 iBHwZ6nn6XQ0nsvWNqOHvTGRzmYtyCaTebbpfWPfVUFP6oiDUhaSAZQARqe462+DXb
	 20dR6z9w4z5Aw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ubHm5-00FVUo-Fn;
	Mon, 14 Jul 2025 12:55:13 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 5/5] KVM: arm64: Tighten the definition of FEAT_PMUv3p9
Date: Mon, 14 Jul 2025 12:55:03 +0100
Message-Id: <20250714115503.3334242-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250714115503.3334242-1-maz@kernel.org>
References: <20250714115503.3334242-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The current definition of FEAT_PMUv3p9 doesn't check for the lack
of an IMPDEF PMU, which is encoded as 0b1111, but considered unsigned.

Use the recently introduced helper to address the issue (which is
harmless, as KVM never advertises an IMPDEF PMU).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 6ea968c1624e4..c829f9a385ccb 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -66,7 +66,6 @@ struct reg_bits_to_feat_map {
 #define FEAT_BRBE		ID_AA64DFR0_EL1, BRBE, IMP
 #define FEAT_TRC_SR		ID_AA64DFR0_EL1, TraceVer, IMP
 #define FEAT_PMUv3		ID_AA64DFR0_EL1, PMUVer, IMP
-#define FEAT_PMUv3p9		ID_AA64DFR0_EL1, PMUVer, V3P9
 #define FEAT_TRBE		ID_AA64DFR0_EL1, TraceBuffer, IMP
 #define FEAT_TRBEv1p1		ID_AA64DFR0_EL1, TraceBuffer, TRBE_V1P1
 #define FEAT_DoubleLock		ID_AA64DFR0_EL1, DoubleLock, IMP
@@ -289,6 +288,11 @@ static bool feat_pmuv3p7(struct kvm *kvm)
 	return check_pmu_revision(kvm, V3P7);
 }
 
+static bool feat_pmuv3p9(struct kvm *kvm)
+{
+	return check_pmu_revision(kvm, V3P9);
+}
+
 static bool compute_hcr_rw(struct kvm *kvm, u64 *bits)
 {
 	/* This is purely academic: AArch32 and NV are mutually exclusive */
@@ -747,7 +751,7 @@ static const struct reg_bits_to_feat_map hdfgrtr2_feat_map[] = {
 	NEEDS_FEAT(HDFGRTR2_EL2_nPMICFILTR_EL0	|
 		   HDFGRTR2_EL2_nPMICNTR_EL0,
 		   FEAT_PMUv3_ICNTR),
-	NEEDS_FEAT(HDFGRTR2_EL2_nPMUACR_EL1, FEAT_PMUv3p9),
+	NEEDS_FEAT(HDFGRTR2_EL2_nPMUACR_EL1, feat_pmuv3p9),
 	NEEDS_FEAT(HDFGRTR2_EL2_nPMSSCR_EL1	|
 		   HDFGRTR2_EL2_nPMSSDATA,
 		   FEAT_PMUv3_SS),
@@ -779,7 +783,7 @@ static const struct reg_bits_to_feat_map hdfgwtr2_feat_map[] = {
 		   FEAT_PMUv3_ICNTR),
 	NEEDS_FEAT(HDFGWTR2_EL2_nPMUACR_EL1	|
 		   HDFGWTR2_EL2_nPMZR_EL0,
-		   FEAT_PMUv3p9),
+		   feat_pmuv3p9),
 	NEEDS_FEAT(HDFGWTR2_EL2_nPMSSCR_EL1, FEAT_PMUv3_SS),
 	NEEDS_FEAT(HDFGWTR2_EL2_nPMIAR_EL1, FEAT_SEBEP),
 	NEEDS_FEAT(HDFGWTR2_EL2_nPMSDSFR_EL1, feat_spe_fds),
-- 
2.39.2


