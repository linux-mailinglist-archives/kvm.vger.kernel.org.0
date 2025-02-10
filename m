Return-Path: <kvm+bounces-37718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB713A2F78D
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 19:43:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 989A63A0271
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 18:43:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A388F2586FF;
	Mon, 10 Feb 2025 18:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XJvGMgnK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F821257AEF;
	Mon, 10 Feb 2025 18:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739212921; cv=none; b=pB4Ey7nhyX4o/SGXvfMpIsWtIuEmsZYUgwdMlR193/I4v8c3T+VZm6ygBtdMAVx6G2R3rHXBy+V6JUvpP6VJzE1V8oaPMl+leih+LV94VJTMZaaDxy0K2C+3otcTtIipvW2g9Qa97rYvFQJbLWL8/2xQ0UDYd+5ZOkONXOVbPXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739212921; c=relaxed/simple;
	bh=rU2TYcrSVmMfGkQ4GYq3i+DtVe9z7lqhLE7D+KpN5Fs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T435hLVaiafAVhYodPnCOTbSheR5OWauTgqt3OuTMkA15WVl/Fc6HeucqFBHut+9VKG0WNnJu2McpBoChe/FdhmZCA4sOFgSrLxx+gCNxzC10d+APkuje+99PGtCywKbccDe7L8piktEvv6LORwtYC1sCp+AIRthlGTsNlh7xjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XJvGMgnK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C16FC4CEE4;
	Mon, 10 Feb 2025 18:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739212921;
	bh=rU2TYcrSVmMfGkQ4GYq3i+DtVe9z7lqhLE7D+KpN5Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XJvGMgnK75CGy+Nz5vUY3SQPQFKNG0HDoJXQTFkt2ORHrdDULcpTgyN6P1BWpaOUg
	 SQMUnPDVa+2E9PP/rHqHS0X+HoR+Ns5/Edv4jm3oombOPx+QxadtKujA3ozmEs1L53
	 9LLMAj141lx3WPrbLZFhmAY7cmWRme5C6uOr7ZAeukoF57qMjN4uWG7imjoGWDFZ4f
	 xBa9ZWYos6wU32c4VPwIsCjNVD4ZulSrdiUen0N5q6SQk5IK5XjpixDMIMngS9R3ZU
	 Xbgy+cIlyJshw12u87iZ9gsUkndwRLCTCxnuf/BhXN9FVVJuFnqKDSnYSvF3b8VolT
	 GezSw4wQIm9Fg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1thYjH-002g2I-9z;
	Mon, 10 Feb 2025 18:41:59 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 09/18] KVM: arm64: Use computed masks as sanitisers for FGT registers
Date: Mon, 10 Feb 2025 18:41:40 +0000
Message-Id: <20250210184150.2145093-10-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250210184150.2145093-1-maz@kernel.org>
References: <20250210184150.2145093-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we have computed RES0 bits, use them to sanitise the
guest view of FGT registers.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 0c9387d2f5070..63fe1595f318d 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1118,8 +1118,8 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 		res0 |= HFGxTR_EL2_nS2POR_EL1;
 	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, AIE, IMP))
 		res0 |= (HFGxTR_EL2_nMAIR2_EL1 | HFGxTR_EL2_nAMAIR2_EL1);
-	set_sysreg_masks(kvm, HFGRTR_EL2, res0 | __HFGRTR_EL2_RES0, res1);
-	set_sysreg_masks(kvm, HFGWTR_EL2, res0 | __HFGWTR_EL2_RES0, res1);
+	set_sysreg_masks(kvm, HFGRTR_EL2, res0 | hfgrtr_masks.res0, res1);
+	set_sysreg_masks(kvm, HFGWTR_EL2, res0 | hfgwtr_masks.res0, res1);
 
 	/* HDFG[RW]TR_EL2 */
 	res0 = res1 = 0;
@@ -1157,7 +1157,7 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 			 HDFGRTR_EL2_nBRBDATA);
 	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P2))
 		res0 |= HDFGRTR_EL2_nPMSNEVFR_EL1;
-	set_sysreg_masks(kvm, HDFGRTR_EL2, res0 | HDFGRTR_EL2_RES0, res1);
+	set_sysreg_masks(kvm, HDFGRTR_EL2, res0 | hdfgrtr_masks.res0, res1);
 
 	/* Reuse the bits from the read-side and add the write-specific stuff */
 	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, IMP))
@@ -1166,10 +1166,10 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 		res0 |= HDFGWTR_EL2_TRCOSLAR;
 	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceFilt, IMP))
 		res0 |= HDFGWTR_EL2_TRFCR_EL1;
-	set_sysreg_masks(kvm, HFGWTR_EL2, res0 | HDFGWTR_EL2_RES0, res1);
+	set_sysreg_masks(kvm, HFGWTR_EL2, res0 | hdfgwtr_masks.res0, res1);
 
 	/* HFGITR_EL2 */
-	res0 = HFGITR_EL2_RES0;
+	res0 = hfgitr_masks.res0;
 	res1 = HFGITR_EL2_RES1;
 	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, DPB, DPB2))
 		res0 |= HFGITR_EL2_DCCVADP;
@@ -1203,7 +1203,7 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 	set_sysreg_masks(kvm, HFGITR_EL2, res0, res1);
 
 	/* HAFGRTR_EL2 - not a lot to see here */
-	res0 = HAFGRTR_EL2_RES0;
+	res0 = hafgrtr_masks.res0;
 	res1 = HAFGRTR_EL2_RES1;
 	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, AMU, V1P1))
 		res0 |= ~(res0 | res1);
-- 
2.39.2


