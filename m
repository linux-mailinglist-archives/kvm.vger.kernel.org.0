Return-Path: <kvm+bounces-23978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A10A9502B0
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 12:44:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3468C1F21CF5
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 10:44:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 241E719A298;
	Tue, 13 Aug 2024 10:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T7XdkZfI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8A71940AB;
	Tue, 13 Aug 2024 10:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723545850; cv=none; b=WMmwe1jrkA1IlpVSImWcvVpqil0Sd8uqPY5i0eVgvZTwpRmRVn9MkgZZgFi3+wFaNyybePCMY/VS+DzD/Hdp7TBvliwQDstI9dtT6rffG0Ut1AFgyyVfJBvg1V6siwmoHVqL6IELnv8FbN+UYwUY3NexlrDHMetmVfuCH5fCHgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723545850; c=relaxed/simple;
	bh=grh5Q/rcvt9bAWN63AYijQmUwGmeLeQjuYTHuxc1Nk8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kuiRthN/qolVJG6ekwMJaJ3AVvUmoKpk199BuM2n/fsfVlkKc3rxlQRkv63Rm1NjTx6a8YWT2zyeI6XA9a7ND4rMR2E6oVjf0i2G0ZQdexyL+4ec2MDT2WoYvAWd09L519KNpjCAKzhOcalSyi06nZfUJtfQnzO9vWGdW7j7KpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T7XdkZfI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2D6C4AF12;
	Tue, 13 Aug 2024 10:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723545850;
	bh=grh5Q/rcvt9bAWN63AYijQmUwGmeLeQjuYTHuxc1Nk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7XdkZfIKQI/o4vHfkrOphq+uCn6ZiOWMW6Z3RfcSq5PZVazBzwK/otddYOT6MW6G
	 CjjtpoVYiqbQkEA9UcwzH52GL0oe5q5fvp05OYBNsXkSWlKG7yh+MJfTLCldtu9GKt
	 8gh2nDQKWax1x8JpLVH7ciZdAdOPZfBc08ha6KdrZ0T4bh4ndRqQultuWWOeyRreJT
	 mw8B7wDku6OFEA9rMiWK1TWtwBH5JyiRjjL8l1sFX3gKtGfnGpvWpFNvk/oG5cXoz+
	 3EbRYsDPlh2PXffqme7PYJn0e86x2Fwte06S0FcTghfsEZY2JnX5OsI0wj9au2kWcn
	 /24Sty68asTBA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sdp0Z-003JD1-V9;
	Tue, 13 Aug 2024 11:44:08 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v3 1/8] KVM: arm64: Move SVCR into the sysreg array
Date: Tue, 13 Aug 2024 11:43:53 +0100
Message-Id: <20240813104400.1956132-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240813104400.1956132-1-maz@kernel.org>
References: <20240813104400.1956132-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, tabba@google.com, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

SVCR is just a system register, and has no purpose being outside
of the sysreg array. If anything, it only makes it more difficult
to eventually support SME one day. If ever.

Move it into the array with its little friends, and associate it
with a visibility predicate.

Although this is dead code, it at least paves the way for the
next set of FP-related extensions.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  4 +++-
 arch/arm64/kvm/fpsimd.c           |  2 +-
 arch/arm64/kvm/sys_regs.c         | 11 ++++++++++-
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a33f5996ca9f..e244e3176b56 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -446,6 +446,9 @@ enum vcpu_sysreg {
 	GCR_EL1,	/* Tag Control Register */
 	TFSRE0_EL1,	/* Tag Fault Status Register (EL0) */
 
+	/* FP/SIMD/SVE */
+	SVCR,
+
 	/* 32bit specific registers. */
 	DACR32_EL2,	/* Domain Access Control Register */
 	IFSR32_EL2,	/* Instruction Fault Status Register */
@@ -664,7 +667,6 @@ struct kvm_vcpu_arch {
 	void *sve_state;
 	enum fp_type fp_type;
 	unsigned int sve_max_vl;
-	u64 svcr;
 	u64 fpmr;
 
 	/* Stage 2 paging state used by the hardware on next switch */
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index c53e5b14038d..e6425414d301 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -134,7 +134,7 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 		fp_state.sve_state = vcpu->arch.sve_state;
 		fp_state.sve_vl = vcpu->arch.sve_max_vl;
 		fp_state.sme_state = NULL;
-		fp_state.svcr = &vcpu->arch.svcr;
+		fp_state.svcr = &__vcpu_sys_reg(vcpu, SVCR);
 		fp_state.fpmr = &vcpu->arch.fpmr;
 		fp_state.fp_type = &vcpu->arch.fp_type;
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c90324060436..2dc6cab43b2f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1669,6 +1669,15 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
+static unsigned int sme_visibility(const struct kvm_vcpu *vcpu,
+				   const struct sys_reg_desc *rd)
+{
+	if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, SME, IMP))
+		return 0;
+
+	return REG_HIDDEN;
+}
+
 static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 					  const struct sys_reg_desc *rd)
 {
@@ -2535,7 +2544,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 			     CTR_EL0_IDC_MASK |
 			     CTR_EL0_DminLine_MASK |
 			     CTR_EL0_IminLine_MASK),
-	{ SYS_DESC(SYS_SVCR), undef_access },
+	{ SYS_DESC(SYS_SVCR), undef_access, reset_val, SVCR, 0, .visibility = sme_visibility  },
 
 	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr, .reset = reset_pmcr,
 	  .reg = PMCR_EL0, .get_user = get_pmcr, .set_user = set_pmcr },
-- 
2.39.2


