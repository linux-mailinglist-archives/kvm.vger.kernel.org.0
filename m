Return-Path: <kvm+bounces-38705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 01CFAA3DBB5
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 14:50:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCE6C3AD3C4
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 13:50:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27FC91FF1BA;
	Thu, 20 Feb 2025 13:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L5j8g6Mo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308591FCFF0;
	Thu, 20 Feb 2025 13:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740059356; cv=none; b=lk984GEy7UwlBo8xUcuMExvEJBVailt0WNwuogm/I6qciRIUAtI8o4j5hkFbBsg5eEc9qS+8sLNX/FuXg2/yP2nUwOAsZg8gfwB4puX1thJJXwNfEmvpx8JGjOhlSIrtqOQCnrC8KZ4wOkCly2ECDYV3lcvbzYdEY+fT2mKKwOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740059356; c=relaxed/simple;
	bh=l6/K3TgHqFMCERF5V5TBAO9LtyJHG0zZIRxuUinA74M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=snXWd0dOAoaf8p/R4L0Qm3BVv9GeFWp+zB89PqPOsn0Dr9MVg3KSbi3aP6VDwE3l0fPKwFUKgyH8Il/axWypvIgw9lw43wCuOlXS6lNnxk0wvVC5T3e9u6qb1+mIhGLK2uiP8q2XukAXNBPYlo7YBNiBWKap0CIrec5SRd504Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L5j8g6Mo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB7CC4CEE8;
	Thu, 20 Feb 2025 13:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740059355;
	bh=l6/K3TgHqFMCERF5V5TBAO9LtyJHG0zZIRxuUinA74M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L5j8g6MotW9B6VRczEP/rJSMp2qFv5aoukQHV67ZTOz9JYZUOdR+DFsLI8NelAlXh
	 xB0iAuMFzRrE1Xv7I+9p4lzysoCJbZBHu5OJlTeqTMRo0Fb+Kd3qZZceJoVWdU684e
	 VOItSdR7ukVPwk9Td16MzNiBQztdbbttWUhWgbplxL5KMKHhiVU27GVpRhntMvx/Ku
	 hHJYljRLqc73efr0wlW822gKOYt9Mp+Ymm9LMEVonDP98WU7ug1OJZO1S1rjpK4bgX
	 yAB10Xfor18INIyuJN9k3xRJ/+0e7ffpP2PaK72/K1fSBerubcg6n0QTUz4PUuXor8
	 hRa38VWZQNGWA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tl6vR-006DXp-VR;
	Thu, 20 Feb 2025 13:49:14 +0000
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
Subject: [PATCH v2 12/14] KVM: arm64: Advertise FEAT_ECV when possible
Date: Thu, 20 Feb 2025 13:49:05 +0000
Message-Id: <20250220134907.554085-13-maz@kernel.org>
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

We can advertise support for FEAT_ECV if supported on the HW as
long as we limit it to the basic trap bits, and not advertise
CNTPOFF_EL2 support, even if the host has it (the short story
being that CNTPOFF_EL2 is not virtualisable).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 5ec5acb6310e9..d55c296fcb27a 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -848,14 +848,16 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 		break;
 
 	case SYS_ID_AA64MMFR0_EL1:
-		/* Hide ECV, ExS, Secure Memory */
-		val &= ~(ID_AA64MMFR0_EL1_EVC		|
-			 ID_AA64MMFR0_EL1_EXS		|
+		/* Hide ExS, Secure Memory */
+		val &= ~(ID_AA64MMFR0_EL1_EXS		|
 			 ID_AA64MMFR0_EL1_TGRAN4_2	|
 			 ID_AA64MMFR0_EL1_TGRAN16_2	|
 			 ID_AA64MMFR0_EL1_TGRAN64_2	|
 			 ID_AA64MMFR0_EL1_SNSMEM);
 
+		/* Hide CNTPOFF if present */
+		val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR0_EL1, ECV, IMP);
+
 		/* Disallow unsupported S2 page sizes */
 		switch (PAGE_SIZE) {
 		case SZ_64K:
-- 
2.39.2


