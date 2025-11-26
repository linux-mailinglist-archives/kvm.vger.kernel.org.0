Return-Path: <kvm+bounces-64683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71455C8ACCF
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 17:02:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16E8D3B8BF7
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 16:00:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5B84331A6C;
	Wed, 26 Nov 2025 16:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tsHZeA3D"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFF13054DF;
	Wed, 26 Nov 2025 16:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764172802; cv=none; b=EDgnUqKpaec64WyvmMb9f40KfNjHRsDK5hDoVBxxk4r26uyI+QpwmBng+IauXPZWoVfO5zguKUZs4Yg2SmKiJUub3RS/VriP3CD+4sttvmwIQtNaBOxdC7sZvsD/8xAcQlXcgaBcOWURQ5Nxoy9u6ttHIVeRY73whSsSRUwk4U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764172802; c=relaxed/simple;
	bh=lG82/RXgkPqZWZ9aTc82QWQFUkM4bvI4ZqnGwoup1FM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=URC3GV0lSegj6lSWVuQoi30vpL99/Kt/xAqEmPdwvzRsiHlxHuD0QLBh8bi79I7nDQ//rzupNbFAg/ShtOPuAx22BP2QrYpUp9z+uk7nV9RAoiioF7dPU7mvdF3O9DNna7tfyppYlOAsHphZ+Ticxmn4KiL3MCQtpzT46XEutiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tsHZeA3D; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60AEEC4CEF8;
	Wed, 26 Nov 2025 16:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764172801;
	bh=lG82/RXgkPqZWZ9aTc82QWQFUkM4bvI4ZqnGwoup1FM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tsHZeA3DuZqbjciM77jiElM91agDFeS851U5NSeB1UqRqSVMsvpzz3hLdtwAEVMAX
	 JTQTNmdNELRr6ZAWia7dtpfCy9fRbgtOqKcS/ID+/AuxzwyRm9GFr/sVjbDV6zU9Hj
	 XO4LQS/HhcYIO0O8CB+HupwfvSwgL6Uwm5A5oY9cUmXC9LLOd1j62m7zXQ2nPOu6/A
	 oqmgGz/rn780uUSXLMBmHgoE2llN6wwXFHxu/1b9DKyDa1BGCwS66A8MpvrH1tN8uH
	 dPqIZNcS5WBs2Y/o1jbCz4iJAaHliZNd+w4tYk8qUtrJXdGZv7KiXsHTVMbIoWZmmb
	 IdiAAGD/32Nog==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vOHvz-00000008WrH-0wRD;
	Wed, 26 Nov 2025 15:59:59 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH v2 4/5] KVM: arm64: Report optional ID register traps with a 0x18 syndrome
Date: Wed, 26 Nov 2025 15:59:50 +0000
Message-ID: <20251126155951.1146317-5-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251126155951.1146317-1-maz@kernel.org>
References: <20251126155951.1146317-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, ben.horgan@arm.com
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
end-up trapping into KVM and that FEAT_IDST is not implemented in the
guest. Otherwise, just make them UNDEF.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2ca6862e935b5..7705f703e7c6d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -82,6 +82,16 @@ static bool write_to_read_only(struct kvm_vcpu *vcpu,
 			"sys_reg write to read-only register");
 }
 
+static bool idst_access(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			const struct sys_reg_desc *r)
+{
+	if (kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR2_EL1, IDS, 0x0))
+		return undef_access(vcpu, p, r);
+
+	kvm_inject_sync(vcpu, kvm_vcpu_get_esr(vcpu));
+	return false;
+}
+
 enum sr_loc_attr {
 	SR_LOC_MEMORY	= 0,	  /* Register definitely in memory */
 	SR_LOC_LOADED	= BIT(0), /* Register on CPU, unless it cannot */
@@ -3399,9 +3409,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CCSIDR_EL1), access_ccsidr },
 	{ SYS_DESC(SYS_CLIDR_EL1), access_clidr, reset_clidr, CLIDR_EL1,
 	  .set_user = set_clidr, .val = ~CLIDR_EL1_RES0 },
-	{ SYS_DESC(SYS_CCSIDR2_EL1), undef_access },
-	{ SYS_DESC(SYS_GMID_EL1), undef_access },
-	{ SYS_DESC(SYS_SMIDR_EL1), undef_access },
+	{ SYS_DESC(SYS_CCSIDR2_EL1), idst_access },
+	{ SYS_DESC(SYS_GMID_EL1), idst_access },
+	{ SYS_DESC(SYS_SMIDR_EL1), idst_access },
 	IMPLEMENTATION_ID(AIDR_EL1, GENMASK_ULL(63, 0)),
 	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
 	ID_FILTERED(CTR_EL0, ctr_el0,
-- 
2.47.3


