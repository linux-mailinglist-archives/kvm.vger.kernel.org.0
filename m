Return-Path: <kvm+bounces-20469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B031916884
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 15:01:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B86F1C229D9
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 13:01:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74CB515ECE5;
	Tue, 25 Jun 2024 13:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r1OtwqSQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980301DDF8;
	Tue, 25 Jun 2024 13:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719320449; cv=none; b=oOo9CKfHJ7OR1q5ioOedq2Jroqpc3lxSq2Bbrjje3HczrQftRs3JQOyn13gOZ7R1pqM4IV1BhTP9WQi0+9YcaHiRv7uNViuxxDwp0zn9tvEipSxpx4yc3k5WeNEUF/3UykFnjbn8ELJ0f9dzNMkDpNBsvuaoX9YVs8CyomxtWwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719320449; c=relaxed/simple;
	bh=Ejjuqz8zPkbWKSWyD7T0S9z70+g5+ZCQUqfk4w2mHlM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PAwrBNEvMXWi/3a9WHKBBYAzbzjSsk4zvRL68P0m0ASmvbngfJWpsubw4PKA8mryZlj/RjfwKvA4brqLpDsmFsnbW5cd6zufxOuxQm67fp4e3qenKLVW9LHhgqM9ofYUTkpCG4jzz7ks/ziZOWc24+Ib7Ah1/8BnLD2CDJtEVfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r1OtwqSQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502D7C4AF0A;
	Tue, 25 Jun 2024 13:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719320449;
	bh=Ejjuqz8zPkbWKSWyD7T0S9z70+g5+ZCQUqfk4w2mHlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r1OtwqSQh9cXxgW+K2Jx3zoUNvjYlcfeWzqTBMDSXbA4zVBN66FaaBvhDt5iDzczN
	 jzTrf8BWW30UwNuAaaGkCpyooUijxU9U/5lNCev58/Vwg8wtnOonkXoFYaktPlvu1r
	 06Wrh00zvg2W/fpEpQEsE3YVIAFOlZGKPkAnrZtPwOGjhs4QZ/QBjsjmFat+f/d42x
	 nco/AIdt6vRDQlmppW8aXSng/5Q3q0m36ccp8l5wOBgMCRImbdS4EpG9ZV7ZS36uYD
	 8W7CZGjJl090gGSF9LiRZhs/v5gCsUAJOFm8G5+37ji7YeT37CZXPentIgZblmBgWa
	 O+g0Naew7JABQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sM5mx-0079X4-Jj;
	Tue, 25 Jun 2024 14:00:47 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH 3/5] KVM: arm64: Make TCR2_EL1 save/restore dependent on the VM features
Date: Tue, 25 Jun 2024 14:00:39 +0100
Message-Id: <20240625130042.259175-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240625130042.259175-1-maz@kernel.org>
References: <20240625130042.259175-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As for other registers, save/restore of TCR2_EL1 should be gated
on the feature being actually present.

In the case of a nVHE hypervisor, it is perfectly fine to leave
the host value in the register, as HCRX_EL2.TCREn==0 imposes that
TCR2_EL1 is treated as 0.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index 4be6a7fa00708..ea2aeeff61db7 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -55,6 +55,17 @@ static inline bool ctxt_has_s1pie(struct kvm_cpu_context *ctxt)
 	return kvm_has_feat(kern_hyp_va(vcpu->kvm), ID_AA64MMFR3_EL1, S1PIE, IMP);
 }
 
+static inline bool ctxt_has_tcrx(struct kvm_cpu_context *ctxt)
+{
+	struct kvm_vcpu *vcpu;
+
+	if (!cpus_have_final_cap(ARM64_HAS_TCR2))
+		return false;
+
+	vcpu = ctxt_to_vcpu(ctxt);
+	return kvm_has_feat(kern_hyp_va(vcpu->kvm), ID_AA64MMFR3_EL1, TCRX, IMP);
+}
+
 static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt_sys_reg(ctxt, SCTLR_EL1)	= read_sysreg_el1(SYS_SCTLR);
@@ -62,7 +73,7 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 	ctxt_sys_reg(ctxt, TTBR0_EL1)	= read_sysreg_el1(SYS_TTBR0);
 	ctxt_sys_reg(ctxt, TTBR1_EL1)	= read_sysreg_el1(SYS_TTBR1);
 	ctxt_sys_reg(ctxt, TCR_EL1)	= read_sysreg_el1(SYS_TCR);
-	if (cpus_have_final_cap(ARM64_HAS_TCR2))
+	if (ctxt_has_tcrx(ctxt))
 		ctxt_sys_reg(ctxt, TCR2_EL1)	= read_sysreg_el1(SYS_TCR2);
 	ctxt_sys_reg(ctxt, ESR_EL1)	= read_sysreg_el1(SYS_ESR);
 	ctxt_sys_reg(ctxt, AFSR0_EL1)	= read_sysreg_el1(SYS_AFSR0);
@@ -138,7 +149,7 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 	write_sysreg_el1(ctxt_sys_reg(ctxt, CPACR_EL1),	SYS_CPACR);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, TTBR0_EL1),	SYS_TTBR0);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, TTBR1_EL1),	SYS_TTBR1);
-	if (cpus_have_final_cap(ARM64_HAS_TCR2))
+	if (ctxt_has_tcrx(ctxt))
 		write_sysreg_el1(ctxt_sys_reg(ctxt, TCR2_EL1),	SYS_TCR2);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, ESR_EL1),	SYS_ESR);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, AFSR0_EL1),	SYS_AFSR0);
-- 
2.39.2


