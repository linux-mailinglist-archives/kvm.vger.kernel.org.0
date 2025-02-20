Return-Path: <kvm+bounces-38697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F940A3DBAD
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 14:50:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB0613AE51A
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 13:49:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7967E1FDE2D;
	Thu, 20 Feb 2025 13:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BEPz/aTP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED44D1FAC46;
	Thu, 20 Feb 2025 13:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740059355; cv=none; b=HGNeVgIZEEIavyHA7YushDpIrTgU9iGDrStJcZM0O7r4xb3YSlB3lvJkYboNEcEvghGfevS1bqzVitYeSUQOAa4bAEcRcHCdtNq4w7ryXudwYq3jY09o1ZFP508+LyoosDPUA2XrAnX02r43UvxEeh2ZswW0UJX0/FRx9Rh+3+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740059355; c=relaxed/simple;
	bh=3rQ7sS5vZjM6vbenQtanAQbuJs7l4zbUMP/xYyxer3w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lbml5tyUBW6l1zWCQHWkqQfRxHSW4z/pThkwYzM0ZrlU8WBfYy38X3gY2HIxTfmi7x6ros31nK7i7wUyrTXq+hnHDvVtj6wH+6zSHltEHkh/9JeioGI7oBuDAIl4D3MB9sRrwv0kzEISuod9daKWsbo3wmZKZ5JAHrTZoFSLZ8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BEPz/aTP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D79DC4CEE6;
	Thu, 20 Feb 2025 13:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740059354;
	bh=3rQ7sS5vZjM6vbenQtanAQbuJs7l4zbUMP/xYyxer3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BEPz/aTPTduw/WwZHmTd29J8bXGomUyAaOSH8hnfnnN1hAlu8YMk40YR0yRWZ4eJM
	 EaPj7nWZd2dEX6uGMf6KGtgEmoTN6YSqB7H+JzPxNMn1/qib/FOZvblmzihLqxIWZ8
	 PJ9LC3/Qpx4GLDGBnWIKn1SQXxow3sZlDA/Ya85khltH4F+C1X+q+/V9yU7fVSAtzI
	 dR5h7EAjVhhKkggSPVY3hsQaexBrEdgvdsw2q6XBZek/YW9AQoPfFnzC0QOVvoG1B6
	 36XilgG1BEwN7Ydx2Wq1g4xGtBpEzpqecP/hz4NtDHvNbgChV/7Tn4js5ahK6g+jSz
	 97OeMlroi69ig==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tl6vQ-006DXp-En;
	Thu, 20 Feb 2025 13:49:12 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	gankulkarni@os.amperecomputing.com
Subject: [PATCH v2 04/14] KVM: arm64: Mark HCR.EL2.{NV*,AT} RES0 when ID_AA64MMFR4_EL1.NV_frac is 0
Date: Thu, 20 Feb 2025 13:48:57 +0000
Message-Id: <20250220134907.554085-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250220134907.554085-1-maz@kernel.org>
References: <20250220134907.554085-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Enforce HCR_EL2.{NV*,AT} being RES0 when NV2 is disabled, so that
we can actually rely on these bits never being flipped behind our back.

This of course relies on our earlier ID reg sanitising.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index ed3add7d32f66..9f140560a6f5d 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1021,10 +1021,11 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 		res0 |= HCR_FIEN;
 	if (!kvm_has_feat(kvm, ID_AA64MMFR2_EL1, FWB, IMP))
 		res0 |= HCR_FWB;
-	if (!kvm_has_feat(kvm, ID_AA64MMFR2_EL1, NV, NV2))
-		res0 |= HCR_NV2;
-	if (!kvm_has_feat(kvm, ID_AA64MMFR2_EL1, NV, IMP))
-		res0 |= (HCR_AT | HCR_NV1 | HCR_NV);
+	/* Implementation choice: NV2 is the only supported config */
+	if (!kvm_has_feat(kvm, ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY))
+		res0 |= (HCR_NV2 | HCR_NV | HCR_AT);
+	if (!kvm_has_feat(kvm, ID_AA64MMFR4_EL1, E2H0, NI))
+		res0 |= HCR_NV1;
 	if (!(kvm_vcpu_has_feature(kvm, KVM_ARM_VCPU_PTRAUTH_ADDRESS) &&
 	      kvm_vcpu_has_feature(kvm, KVM_ARM_VCPU_PTRAUTH_GENERIC)))
 		res0 |= (HCR_API | HCR_APK);
-- 
2.39.2


