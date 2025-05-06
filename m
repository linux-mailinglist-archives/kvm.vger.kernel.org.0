Return-Path: <kvm+bounces-45631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D24A3AACB53
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 18:46:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 859467B404B
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:44:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AB41286D7D;
	Tue,  6 May 2025 16:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ygth1+ur"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A122286D4A;
	Tue,  6 May 2025 16:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746549852; cv=none; b=Gq00iTExViUZ0ZAfV6SX6oYr9gWiprVko9nPjnkyB8xgzCJFn+FGZ3Mkh4NjHn/88ouDNn1sXioKsmoLew+dRYxJ85LXqrgIlbUKa+3n0zpNfrN9k/UIIObIhH0HgnSZA7ccV3DZJQOBHlWBdhWPsflYljRKHeOY7+PReW/EMlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746549852; c=relaxed/simple;
	bh=cXLy+//a+Wbc2PWFhsn34/2XszY14fVQQbnlUcjHWGg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IFnJrO/ZP4o86SP3ufvzHf5opnlDeP+7buwmNCsdKsKz5uciVMnv3VaBT2r03tfB/qteU/mMmcslJVW1yPR+3cSOSzkILEdRdSmSR7cCNUo6SkyKJHPxPlDTV1wpZbmirvDjdAHU/ks8QWmRKkFC7HHA+IopGTjuUjxNaqx8xvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ygth1+ur; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229D8C4CEF7;
	Tue,  6 May 2025 16:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746549852;
	bh=cXLy+//a+Wbc2PWFhsn34/2XszY14fVQQbnlUcjHWGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ygth1+urekfiF1GRYwFFvJEHLIbPemK0bhY89b4zJ/liMXixm3F4MhM2NYHsUJHE0
	 vqC6Z/LsjU9njN3du52P5ckCK6DCNH1cFLGUo6dqNkIn1FQ8OYqG3G9yQxqOZgBvfC
	 wNs/Bly56x6rUS2/GY1R7v253Na9nwlKGVtGXoOTr1gmcwg4+9uqXnE1Oq7LVm6rAm
	 WG6621bg6lYO/U6wI4vCagZZNdvoOlyi7j0YMmtmEdKIuLY4VSHiE0l30j9+qJ9QWv
	 sIkMpq33EELMWkjzBSKlkL3SKtvomLbuYHExsxI+vwB67cOi6Ia1PGQ37mKBU/0cMv
	 byMxCmZNHrizQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uCLOs-00CJkN-Cj;
	Tue, 06 May 2025 17:44:10 +0100
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
	Catalin Marinas <catalin.marinas@arm.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH v4 19/43] KVM: arm64: Restrict ACCDATA_EL1 undef to FEAT_LS64_ACCDATA being disabled
Date: Tue,  6 May 2025 17:43:24 +0100
Message-Id: <20250506164348.346001-20-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250506164348.346001-1-maz@kernel.org>
References: <20250506164348.346001-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com, ben.horgan@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We currently unconditionally make ACCDATA_EL1 accesses UNDEF.

As we are about to support it, restrict the UNDEF behaviour to cases
where FEAT_LS64_ACCDATA is not exposed to the guest.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6e01b06bedcae..ce347ddb6fae0 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5150,10 +5150,12 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 	kvm->arch.fgu[HFGRTR_GROUP] = (HFGRTR_EL2_nAMAIR2_EL1		|
 				       HFGRTR_EL2_nMAIR2_EL1		|
 				       HFGRTR_EL2_nS2POR_EL1		|
-				       HFGRTR_EL2_nACCDATA_EL1		|
 				       HFGRTR_EL2_nSMPRI_EL1_MASK	|
 				       HFGRTR_EL2_nTPIDR2_EL0_MASK);
 
+	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA))
+		kvm->arch.fgu[HFGRTR_GROUP] |= HFGRTR_EL2_nACCDATA_EL1;
+
 	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
 		kvm->arch.fgu[HFGITR_GROUP] |= (HFGITR_EL2_TLBIRVAALE1OS|
 						HFGITR_EL2_TLBIRVALE1OS	|
-- 
2.39.2


