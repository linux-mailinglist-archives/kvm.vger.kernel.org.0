Return-Path: <kvm+bounces-38299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 34472A36FD1
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 18:38:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38177188BF22
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 17:38:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05F651EEA5A;
	Sat, 15 Feb 2025 17:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZqNdv9ij"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C56C1DF982;
	Sat, 15 Feb 2025 17:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739641103; cv=none; b=fqCT1P1TBGbUewGDMNMcIh7RLWrWJa/zSg60vQA9pZbSO90T6Q5NB7Dnm73o9mUXXpOV0x9lDK+thwPRIP0p5XQAecESH8yRKvZxlvpL/daE8e3iV4QhbK6AMeHuCH2PACSoYdZyta6hKScS9whDu69iXxVudueCX0wKCyXclZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739641103; c=relaxed/simple;
	bh=3rQ7sS5vZjM6vbenQtanAQbuJs7l4zbUMP/xYyxer3w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=asqo0T2GWd0Wj+FdaQLPSYImI9ZYqoBUyhuUeoPIRM1vzh+1zK3z+aCu/4chlp4ugkUCQMYtcc+Itw5L5qCAjkvCc0HU9NewGtqONXZnCuY+YBFiRvDIs0NmOae7g5akhu6hy0WMrqsLb2vF9UBBhPIEtH9LqLG1Q8ieXb9Ajjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZqNdv9ij; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F321CC4CEE6;
	Sat, 15 Feb 2025 17:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739641103;
	bh=3rQ7sS5vZjM6vbenQtanAQbuJs7l4zbUMP/xYyxer3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZqNdv9ijD2WnHJbw/M4ayw7EwnhIIy8oV6Fh84I+iq/RQLXdwMoc9i5FOXPcix+w0
	 h3KehIgFEtI/eeg1w/7yrPkqamDb4dBv7i+r7v++Qh8F/igG8+Q1/U5gsSp0g5ezdR
	 kxCe2qmpj7WVxDGBBtXrBT85gJ/MdjlpxdhtLiW27F8JDmrYUGMO4b2v3J1/blzJXo
	 FQWL+XUbtQfoKQHuxJ1CKhwk12Gty2DE2IY4X3q6Wdv5Zo7WLoiHpUQsIO9bJ1zrSQ
	 FtQQEqMiDscJbt9t85ZdMXxiuTBQBdi7n173lS4rnBNHVakFG6ZK4Xs+w1CVjZQTHS
	 kuPs1TMyRbkIw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tjM7R-004Pqp-2F;
	Sat, 15 Feb 2025 17:38:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 04/14] KVM: arm64: Mark HCR.EL2.{NV*,AT} RES0 when ID_AA64MMFR4_EL1.NV_frac is 0
Date: Sat, 15 Feb 2025 17:38:06 +0000
Message-Id: <20250215173816.3767330-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250215173816.3767330-1-maz@kernel.org>
References: <20250215173816.3767330-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com
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


