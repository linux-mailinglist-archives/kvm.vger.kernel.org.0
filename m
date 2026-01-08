Return-Path: <kvm+bounces-67433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DD878D051ED
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 18:42:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 12496303D7F9
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 17:33:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5801D2F9DA1;
	Thu,  8 Jan 2026 17:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mUoS13e1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B222EB841;
	Thu,  8 Jan 2026 17:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767893560; cv=none; b=hiMXG5vLIo9UonSvgwSTPUYWPTa/wQ+uD6EPTG5EzOK0O/SSxI+5pn03VcEVG1DkW/ZDZsj+XJGPosXXHrcPNGiQHNqsp9oBqwF10ddHRUPdFz3PGPUHmwLfkY+EQhl6M6BRPkDm7itY3m929zsAdk5hqCcbqsPD5harHaP0QNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767893560; c=relaxed/simple;
	bh=Znr7Dku9zVifoLC2dRkdX2LnqvsmlDNxYYJnQTiGVbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J4c1/8y7wfqx3ioEzX6BLGtM93mmWsb7HoRpR50oX+OIV1cl4XUs7DRKczvCssmxyAeYboH6mph5fIJ7U4B6mMUPspa+E8zRPz9hcKM0JPQd6pD3CEIuQStS6edxuxQfkPY1BxmvCHnQaRXir0O/7f/EgbrC0dSodkDFUkdl7tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mUoS13e1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A4DC16AAE;
	Thu,  8 Jan 2026 17:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767893560;
	bh=Znr7Dku9zVifoLC2dRkdX2LnqvsmlDNxYYJnQTiGVbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUoS13e1hLDfT4trH8rc84ThYzVTyq/TYhZm3BuQFFsQImi1R7eNpIpa9MBrsg/+G
	 CTjWLcDqWVgDnVwCdZbpv0DL/G1GyJh/K9+Uej7vbN7lU/J37Qb+Vhq+IPormQ+bcu
	 JbJiB25vPh4hoRL5Pdsbg1NBD8pGpHjMJOFvv8l40fxpYKl/WfUNUZfaf/tzrGxQt2
	 /N8ulW8wXR0nPTzojpEdxbWqHfH9TsUCkJjlUgHlAhE2O75OnjUQfLSQqs5eITVgxH
	 sSSzaxXBHY2EB8CSalZtaPm/kBgTGOrpmUjnZChjQkRR6Di5FUi5VjWMM/6H/HiiWI
	 2rFh1doEL6ivw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vdtsE-00000000W9F-0iLY;
	Thu, 08 Jan 2026 17:32:38 +0000
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
Subject: [PATCH v4 8/9] KVM: arm64: pkvm: Report optional ID register traps with a 0x18 syndrome
Date: Thu,  8 Jan 2026 17:32:32 +0000
Message-ID: <20260108173233.2911955-9-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260108173233.2911955-1-maz@kernel.org>
References: <20260108173233.2911955-1-maz@kernel.org>
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
index b197f3eb272c1..06d28621722ee 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -347,6 +347,18 @@ static bool pvm_gic_read_sre(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool pvm_idst_access(struct kvm_vcpu *vcpu,
+			    struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR2_EL1, IDS, IMP))
+		inject_sync64(vcpu, kvm_vcpu_get_esr(vcpu));
+	else
+		inject_undef64(vcpu);
+
+	return false;
+}
+
 /* Mark the specified system register as an AArch32 feature id register. */
 #define AARCH32(REG) { SYS_DESC(REG), .access = pvm_access_id_aarch32 }
 
@@ -477,6 +489,9 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 
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


