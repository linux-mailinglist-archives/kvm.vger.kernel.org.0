Return-Path: <kvm+bounces-24010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B1D2950822
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 16:48:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3706F287159
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 14:48:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DBF31A08A3;
	Tue, 13 Aug 2024 14:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZA/cF76l"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16ECF1A01D3;
	Tue, 13 Aug 2024 14:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723560480; cv=none; b=FL9WjQJxN03eKD0jy7MQNNdRyi83H1aH8ekAi6+iEK58kUAJX+KwN+FfXlAUPCitAYplOg3G4iGd9vHF+So3mrMVtQ3UsIiihdcJmCysWQOpYMUJ7s92Hxt+pyZnIvHY1z+Fg6LFJkYos/2mgE4GBTiQ8a1xdz0x0lUtkqRZOMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723560480; c=relaxed/simple;
	bh=NGd3Mb3ENRIp6A9T4Pf1BLV4E8SBAeETl4uymIM47B8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qJ67SQTqFiv1ICYoYYW4mWFnjA2E34r3whTpUywr9EP9XGB0tmGkO9fA7NzP67Nke5KOHmZwJGsBeCvQ9R6WEYEmokdRoXDZLDBMZZftAyT3c3jKCtDlIsPtLQhtmbeEh+tZFqmHI9qIEFT1iwOryCzHDfVC8EonCyVZoc+6vTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZA/cF76l; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E791AC4AF0B;
	Tue, 13 Aug 2024 14:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723560479;
	bh=NGd3Mb3ENRIp6A9T4Pf1BLV4E8SBAeETl4uymIM47B8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZA/cF76l6U156/7LIc2fvEMyZ/LqNWJOCvoHqGEcaRoIFBRHx34ofDm7JDFScY9Xa
	 kvh3IFoiTQP5HA/Q0ZMoSz5Cm3gcG1YYFFSo3cHTERn7HBl0p2id9i83w+VH4VLmyj
	 oNFKJNh3MnAUuck9qOE3sF/zTsOyfNkNIA7JMWwnYnosxSiSivHUqKXUaZGfCDTvY0
	 zTLPKn/fmy2V1SQc+IYbtdwhRC3kUYoRPEWDCgeOA4BcehfCopq/4K7mf/FuFgiz5i
	 r8l3B92M+scQXu3f8sIPvkGQfVj6jEvzXqOt/XR08rwSYLdm1sKQqjWKlhccKlANyB
	 GWAECsoxuJqdQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sdsoY-003O27-3L;
	Tue, 13 Aug 2024 15:47:58 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH 10/10] KVM: arm64: Sanitise ID_AA64MMFR3_EL1
Date: Tue, 13 Aug 2024 15:47:38 +0100
Message-Id: <20240813144738.2048302-11-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240813144738.2048302-1-maz@kernel.org>
References: <20240813144738.2048302-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the missing sanitisation of ID_AA64MMFR3_EL1, making sure we
solely expose S1PIE and TCRX (we currently don't support anything
else).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a5f604e24e05..d0b4509e59cb 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1608,6 +1608,9 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 	case SYS_ID_AA64MMFR2_EL1:
 		val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
 		break;
+	case SYS_ID_AA64MMFR3_EL1:
+		val &= ID_AA64MMFR3_EL1_TCRX | ID_AA64MMFR3_EL1_S1PIE;
+		break;
 	case SYS_ID_MMFR4_EL1:
 		val &= ~ARM64_FEATURE_MASK(ID_MMFR4_EL1_CCIDX);
 		break;
@@ -2470,7 +2473,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 					ID_AA64MMFR2_EL1_IDS |
 					ID_AA64MMFR2_EL1_NV |
 					ID_AA64MMFR2_EL1_CCIDX)),
-	ID_SANITISED(ID_AA64MMFR3_EL1),
+	ID_WRITABLE(ID_AA64MMFR3_EL1, (ID_AA64MMFR3_EL1_TCRX	|
+				       ID_AA64MMFR3_EL1_S1PIE)),
 	ID_SANITISED(ID_AA64MMFR4_EL1),
 	ID_UNALLOCATED(7,5),
 	ID_UNALLOCATED(7,6),
-- 
2.39.2


