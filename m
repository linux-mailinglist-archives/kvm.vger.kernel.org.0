Return-Path: <kvm+bounces-44430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97654A9DAA1
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 14:30:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF373461451
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 12:30:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ED4E253320;
	Sat, 26 Apr 2025 12:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="skrm/nPL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C852522BD;
	Sat, 26 Apr 2025 12:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745670535; cv=none; b=RSQRqV3QOM3JKFJ+juab7fLj9H2KKqOlQB/LKENL7U3750k+5+tFyI10Xt+R/uy95uX4W3mPWc5RPUNYkjgHPWTqdnlB7A50y8S9xTSYQ5ECUlTuSehcvc5gB61V45eB2VjRK3g5HIehZJ+ndTdgj00ArsPu7YRYxlHDvFRsSAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745670535; c=relaxed/simple;
	bh=LyW63IDsD513vLKhwXs5Pn8n+SMo4tx9SsM1UwXEgds=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Of4HFUomyWe4WCGmTwh8CSFANOqYIB395oKsNjyfYaHjJt7JyBz79/HwgZMHPwsKRsXwdkoK2j1YX2h0TS+5JGUzYLXK4hosRR6788jNOgyAczohGo54gUG0GxN4PL3SYd1+M85/LXDn9oNogIzLmhiJObqApD2Eutu1mMaguVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=skrm/nPL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E3AC4CEE2;
	Sat, 26 Apr 2025 12:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745670535;
	bh=LyW63IDsD513vLKhwXs5Pn8n+SMo4tx9SsM1UwXEgds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=skrm/nPLn0PQ/PM54fKmf4ip7NCwd6aKMS8MilFQsifLLZcpe2EI+fOi7X/ywoOPc
	 Sg3iYTf+pzsnoAqftWStJXScPBLZdo86YqzlumWxT0uNJGq0RLj5RQXyz9mWdzk9Zo
	 wH2BZPstgB23/6XrT64vzq250byd5bXbIyJ9AUWFhtV6gmchsmDlSKgcn21tvxnm2B
	 6157kIBNSuQ7Mb+AeKUeUEg3ifY6Oq4Rv0tmkJJqbqkzXsKR0C6Wh/Zv6DIhjMEhZ5
	 xZvr9zCqh+W8DT7AW30UA7nxx3Ohjcx8KZCSUZvf5gy/EJ1BOy08MEZXea6/9ivJoI
	 4V8GEncjga8mQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u8eeL-0092VH-HV;
	Sat, 26 Apr 2025 13:28:53 +0100
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
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 18/42] KVM: arm64: Restrict ACCDATA_EL1 undef to FEAT_ST64_ACCDATA being disabled
Date: Sat, 26 Apr 2025 13:28:12 +0100
Message-Id: <20250426122836.3341523-19-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250426122836.3341523-1-maz@kernel.org>
References: <20250426122836.3341523-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
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


