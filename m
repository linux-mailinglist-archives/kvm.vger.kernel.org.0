Return-Path: <kvm+bounces-65267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FBF8CA31A2
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 10:54:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8A7C5314D005
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 09:49:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D960A335568;
	Thu,  4 Dec 2025 09:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EpHdCmRa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122012C1581;
	Thu,  4 Dec 2025 09:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764841718; cv=none; b=mPtw3/dEyyXWK3FNWTZqIJdi+Jdp4YmFJmZksuuYZ7rWtEmw3ghDS2EYku4JqQWWsyJWP8EQImkiFC/gN5iQSxbycqa2ibTi55K++8Wnt6+n09BF4tK44Q/7bZ9MsAhHfxSYJErTErJVimvLb0qVbZD1PaJ3NhgqT05xnHfpiwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764841718; c=relaxed/simple;
	bh=AnEvmpTr3N6uKP3Ug85RiyieiVqnPxJy70xw+6xKC30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vu1GsXbpHbas7oxGkHacnYT2/3UBPfnqdW/r5qwz5qgjhFSUedL0J6kdrReYc8RxaIPeF/z9y/WxFp5cNgmbmz/jIOz6fT4LiUFF5/hcbStva3HS1CHPrXwm1wxPQ4Fxy3RiuahiXETYWMiL3XVgF7UTss6einO99BI3rVBI2Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EpHdCmRa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC8AC4CEFB;
	Thu,  4 Dec 2025 09:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764841717;
	bh=AnEvmpTr3N6uKP3Ug85RiyieiVqnPxJy70xw+6xKC30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EpHdCmRaO82yJfpohRIB3I+ZAGxhJfwktHJCuHDL0bIcNI2ZeeRS7XQqpQzHdP3Kd
	 shP0hP8+9TTrGVfLWKic/L2Xn+gikkz1gPsWd78chwoFrWkVzOScIcfpF9MMVGPtBg
	 UtFHoORw2q6xdyABQ1CxP755byIARAOCzo3dT1Plbah/tpb6xUYw3HzG+BXH8djHTP
	 9oKrfiLZ0NBo8XIQZPZevPonX+XBf6U2GI1iqe+V+1RAnu7A7qpDzi0uaB+nmCiVlP
	 +ApMAPjSxoold1i+5ksscwlKU/EY8QUk4YfkL9WfjS7Y6yLeIGcFr9ymDjoedL4F/E
	 3nN3AguUApbFQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vR5wx-0000000AP90-3zzH;
	Thu, 04 Dec 2025 09:48:36 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: [PATCH v3 8/9] KVM: arm64: pkvm: Report optional ID register traps with a 0x18 syndrome
Date: Thu,  4 Dec 2025 09:48:05 +0000
Message-ID: <20251204094806.3846619-9-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251204094806.3846619-1-maz@kernel.org>
References: <20251204094806.3846619-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, ben.horgan@arm.com, yaoyuan@linux.alibaba.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

With FEAT_IDST, unimplemented system registers in the feature ID space
must be reported using EC=0x18 at the closest handling EL, rather than
with an UNDEF.

Most of these system registers are always implemented thanks to their
dependency on FEAT_AA64, except for a set of (currently) three registers:
GMID_EL1 (depending on MTE2), CCSIDR2_EL1 (depending on FEAT_CCIDX),
and SMIDR_EL1 (depending on SME).

For these three registers, report their trap as EC=0x18 if they
end-up trapping into KVM and that FEAT_IDST is implemented in the guest.
Otherwise, just make them UNDEF.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 876b36d3d4788..efc36645f4b5a 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -347,6 +347,18 @@ static bool pvm_gic_read_sre(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool pvm_idst_access(struct kvm_vcpu *vcpu,
+			    struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	if (kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR2_EL1, IDS, NI))
+		inject_undef64(vcpu);
+	else
+		inject_sync64(vcpu, kvm_vcpu_get_esr(vcpu));
+
+	return false;
+}
+
 /* Mark the specified system register as an AArch32 feature id register. */
 #define AARCH32(REG) { SYS_DESC(REG), .access = pvm_access_id_aarch32 }
 
@@ -472,6 +484,9 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 
 	HOST_HANDLED(SYS_CCSIDR_EL1),
 	HOST_HANDLED(SYS_CLIDR_EL1),
+	{ SYS_DESC(SYS_CCSIDR2_EL1), .access = pvm_idst_access },
+	{ SYS_DESC(SYS_GMID_EL1), .access = pvm_idst_access },
+	{ SYS_DESC(SYS_SMIDR_EL1), .access = pvm_idst_access },
 	HOST_HANDLED(SYS_AIDR_EL1),
 	HOST_HANDLED(SYS_CSSELR_EL1),
 	HOST_HANDLED(SYS_CTR_EL0),
-- 
2.47.3


