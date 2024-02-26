Return-Path: <kvm+bounces-9803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0162E8670BB
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:25:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AB6E31F2D218
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:25:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 930F358139;
	Mon, 26 Feb 2024 10:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lMOn0Xlt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB945811A;
	Mon, 26 Feb 2024 10:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942075; cv=none; b=ujZPy2F5O5n9M+NA33iGPSetY8o6E5IXPe06UyKe1byuXDXPDqMNvT6pzDlnlm8yPlTHoaamwrS+hYOmn+vBKirpIq7QY4Cm7+nRoV+2eYbrXcXjCpCAmutiH4mbnN+xTe/MOU/c2N1yUFdGRxy+AJH4Y4lNxyp6ohK2HfGwxqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942075; c=relaxed/simple;
	bh=vqA6TJBDRvY50fGHqcQfGVUDuzRuFzAfHui2TaG7QnU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BfsZX8VPX9wJhuI68FenwKZn5S0qlibUwqmpB1CZvaLMBl1k/TlvjHRLKnkbDtozHrBj4nu86ZbYmiP1aevBX3pPfmqccmmFaKAsc2CdyyYTN30a4L1zdrVYCHXJhfYZgl62DEZ88IhfrM/FI64di1BC3S3drIggOJaOFpP+6ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lMOn0Xlt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540F6C433C7;
	Mon, 26 Feb 2024 10:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708942075;
	bh=vqA6TJBDRvY50fGHqcQfGVUDuzRuFzAfHui2TaG7QnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lMOn0XltExc2h7i10govRfqq+qo3gmuW0DYCHDNd8vsv8pPFGQtJ+ONIL30ZFsEm+
	 XwFAQPaa2xi3GE8YMNoIPlkrHCQ9/9JrVMpyMFW8bRCE0qvkfjn+1a1C0JjRLVkHfC
	 UkyxDoDoTBhQiwNGf7nV+5W0PhPYL9M5VP+yRr9pti/DPIvxfjE+LPVBy7Xva6n6zp
	 WWnsQlxhFIUxn0jzmNXwLkpFAN+5HGTwxdxZ5yfNhAwyNrzyJ/QVFGNdyepB/us8rI
	 wRD53YUbTOzbSHgSSo/Y4ovbivKPx6+eP2tGmK7TV6LXj+/K6pvZYitxXcxqAYXG9G
	 mHAASDXVhSKBw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1reXtk-006nQ5-Tq;
	Mon, 26 Feb 2024 10:07:50 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v2 13/13] KVM: arm64: nv: Advertise support for PAuth
Date: Mon, 26 Feb 2024 10:06:01 +0000
Message-Id: <20240226100601.2379693-14-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240226100601.2379693-1-maz@kernel.org>
References: <20240226100601.2379693-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we (hopefully) correctly handle ERETAx, drop the masking
of the PAuth feature (something that was not even complete, as
APA3 and AGA3 were still exposed).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index ced30c90521a..6813c7c7f00a 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -35,13 +35,9 @@ static u64 limit_nv_id_reg(u32 id, u64 val)
 		break;
 
 	case SYS_ID_AA64ISAR1_EL1:
-		/* Support everything but PtrAuth and Spec Invalidation */
+		/* Support everything but Spec Invalidation */
 		val &= ~(GENMASK_ULL(63, 56)	|
-			 NV_FTR(ISAR1, SPECRES)	|
-			 NV_FTR(ISAR1, GPI)	|
-			 NV_FTR(ISAR1, GPA)	|
-			 NV_FTR(ISAR1, API)	|
-			 NV_FTR(ISAR1, APA));
+			 NV_FTR(ISAR1, SPECRES));
 		break;
 
 	case SYS_ID_AA64PFR0_EL1:
-- 
2.39.2


