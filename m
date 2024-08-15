Return-Path: <kvm+bounces-24259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A370952EAB
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:01:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 77FF2B27024
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 13:01:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D32C19E7FA;
	Thu, 15 Aug 2024 13:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HMn4mA18"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA4944376;
	Thu, 15 Aug 2024 13:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723726807; cv=none; b=BQ1c/K4HLMGIcoUR5lFhLS+1oioeBikXIB/U0C/ilRIIehogkj9xBNQMd5BLaSpprpmmzlI6nMbyvcMaCxDPOl7q+ru31wF36+zoULapUNHvsIqSAASAIHpUr9qsWKrPUKA/TLe4hQ93yeXyTVYpQlRwAhjmUAeBWthpPF0gslY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723726807; c=relaxed/simple;
	bh=vrHRh1ie6Y+/25mrEk7jHWLcNcemrezm5Snx7mIYljY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o+Q8OukaYlzNmghgPLskcqedJcVSHVpmzxYT1ZvDAg9UMtMJ/AFOan7gVG18j7VdPYLDmgab2qbvJuvweOZpo+GSmZ5+0+qZen5ofBjmcKJcMraM1tNIweEyUV8PgdZWCzRE5GZrAn7bwgcn6GCL/OhA8lxQe5vx4PvGBKpYxuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HMn4mA18; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC94C32786;
	Thu, 15 Aug 2024 13:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723726807;
	bh=vrHRh1ie6Y+/25mrEk7jHWLcNcemrezm5Snx7mIYljY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HMn4mA18G7s9UOWzyejGPEPGijMXtpCN13tjdHV22Va5DMSWZ3Nek2cGhhNZWKt+J
	 HcZfvbVSMvGBmD8y+Rw2Cq/7aXjV/uHZwknjO6+AaV5IFouLz8QPXRrvkY/2buSajq
	 +TRCtwmYsJKQWweHy0GxnJWOnKPxXPJVLx2HezimdbUx1geIbW4VZtCUjBhOANXRcx
	 ovoq7rGGTkG+Aimizi7Ku/9OjSr08RTjivoTYt+CSMdXmjheTYxuxYg4rlQ1j6u727
	 gY9V/KBlqhctsI0psu6K+mT1WcoBvRPtMiFhcI43N2+8OmZ2FSw+oMEr3EJ9iYrvUD
	 LAJlN5mnMDHnA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sea5E-003xld-Bn;
	Thu, 15 Aug 2024 14:00:04 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 09/11] KVM: arm64: nv: Expose FEAT_LS64* to a nested guest
Date: Thu, 15 Aug 2024 13:59:57 +0100
Message-Id: <20240815125959.2097734-10-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240815125959.2097734-1-maz@kernel.org>
References: <20240815125959.2097734-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we correctly support FEAT_LS64*, don't hide it from nested
guests anymore.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index de789e0f1ae9..97b16127755e 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -808,10 +808,9 @@ static void limit_nv_id_regs(struct kvm *kvm)
 	val &= ~NV_FTR(ISAR0, TME);
 	kvm_set_vm_id_reg(kvm, SYS_ID_AA64ISAR0_EL1, val);
 
-	/* Support everything but Spec Invalidation and LS64 */
+	/* Support everything but Spec Invalidation */
 	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64ISAR1_EL1);
-	val &= ~(NV_FTR(ISAR1, LS64)	|
-		 NV_FTR(ISAR1, SPECRES));
+	val &= ~NV_FTR(ISAR1, SPECRES);
 	kvm_set_vm_id_reg(kvm, SYS_ID_AA64ISAR1_EL1, val);
 
 	/* No AMU, MPAM, S-EL2, or RAS */
-- 
2.39.2


