Return-Path: <kvm+bounces-24255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A2418952EA7
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:01:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5752C1F21CEF
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 13:01:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F69C19B3DD;
	Thu, 15 Aug 2024 13:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b50XmLDK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD49219E7F6;
	Thu, 15 Aug 2024 13:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723726805; cv=none; b=qLqg9+4c6hUR6mmpHPuus2zF+roK5EOJTo4yVVEkCf1R3yKKJw+wunVf5642HYdpvnIrgR+49GCOx45mTkT77D6KbBtYK0OgrxGVuwLvVfRsknEG3uer8lY8x8muygv6rn6u3KhZAS4ZiPShe3ZQu5xPsEkfCjAkClsAWV/UC+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723726805; c=relaxed/simple;
	bh=elhHN6q3wNJu3gQxFTv4Q2GV0VvzvpMyf883cw9HyZA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Fl7pgsYS6OKHcsbawQkRxxJZLWMr81s6D6xZrdXfinHeTKtD/dh5weNo6nfbHchArhunlsr/8y5wJAc80/9ar81aZbuzoZMj6V48usYomh7Z621Lv+gek0eBOjl77fwzTrwedbgdd39ceyI9F9NeuS0dJEeX/pjUlroisphFcTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b50XmLDK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A5CC4AF0E;
	Thu, 15 Aug 2024 13:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723726805;
	bh=elhHN6q3wNJu3gQxFTv4Q2GV0VvzvpMyf883cw9HyZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b50XmLDKgpWqwQ+J+8Fpdlz/fsF7bOuMPyQSHI0DWZlCE26lvNsnoot1nc1YKM2LP
	 KtfGZDwXz8TylnYtwKDgK+NU7p+b9o2e//UARF2g1+4CyFV0kFKGNzpCdQSZL1z2p1
	 1yFo6zgCSgpBSdslbED2E3p6jKwUNAEO0b8rbkZ9l6VCzjywWB177PHfQnkGU3gqhB
	 SqbIkYM7iWFA128/tBHy/4dLlDCI9RG5lye112XL3hpXJAsV9xrt+mPP9aRLG+zkL0
	 5rgNfFb7zmO3d+fx6M4TLEzbarCj/aBQhjBoqqBlVTZkQMgmMvOT+zuV+ogY5CI4Q3
	 xUAtk0CXgenXA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sea5D-003xld-Vb;
	Thu, 15 Aug 2024 14:00:04 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 07/11] KVM: arm64: Restrict ACCDATA_EL1 undef to FEAT_ST64_ACCDATA being disabled
Date: Thu, 15 Aug 2024 13:59:55 +0100
Message-Id: <20240815125959.2097734-8-maz@kernel.org>
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

We currently unconditionally make ACCDATA_EL1 accesses UNDEF.

As we are about to support it, restrict the UNDEF behaviour to cases
where FEAT_ST64_ACCDATA is not exposed to the guest.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7b540811aa38..39c2ee15dc0a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4580,10 +4580,12 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 				       HFGxTR_EL2_nS2POR_EL1		|
 				       HFGxTR_EL2_nPOR_EL1		|
 				       HFGxTR_EL2_nPOR_EL0		|
-				       HFGxTR_EL2_nACCDATA_EL1		|
 				       HFGxTR_EL2_nSMPRI_EL1_MASK	|
 				       HFGxTR_EL2_nTPIDR2_EL0_MASK);
 
+	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA))
+		kvm->arch.fgu[HFGxTR_GROUP] |= HFGxTR_EL2_nACCDATA_EL1;
+
 	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
 		kvm->arch.fgu[HFGITR_GROUP] |= (HFGITR_EL2_TLBIRVAALE1OS|
 						HFGITR_EL2_TLBIRVALE1OS	|
-- 
2.39.2


