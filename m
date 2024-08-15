Return-Path: <kvm+bounces-24253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7084F952EA5
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:00:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 00CA9B267DB
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 13:00:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E6E019F499;
	Thu, 15 Aug 2024 13:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qMKdasHC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5081E19DF58;
	Thu, 15 Aug 2024 13:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723726805; cv=none; b=OHjE7XvCAC6BX3alvJgSNlG2BwVyC5YZhk7LGFOZLASgVhErB43X35kuA1cn1Th1dlR+/bvz4aTLjpco1UY1QkQ/P1eRuHzFjAXmfAVUvzYoMiCRqOt+xvciISGqXplfYZxxSrvD+weVOMvcuOML9dJOc5kwiw+kn6f2FA52nLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723726805; c=relaxed/simple;
	bh=7yPgO+gFWmtYo2hX7bb0kFw4QbZDVO3VBIpTe6cAldM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HD4yz4A6y3+ccpaIksl+IxQ2/tZstv6sVyiKZtC9dYuvAITbLThIfXgbUeJRhVH/ZHb38f1aLWNUaa/7hbWxeaBoafE0mgQbKDMk/VxwynBypBgxpJvPyrPf2/i3wBU2GIt5RIi84AoJOVkgOo/zgIN3EbRT5T02OlIVBuSuzPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qMKdasHC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C020C4AF0D;
	Thu, 15 Aug 2024 13:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723726805;
	bh=7yPgO+gFWmtYo2hX7bb0kFw4QbZDVO3VBIpTe6cAldM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qMKdasHC5YS4Rlmnbt4dvh5r5AeObcjiPwiU5fwMpoeNG++dJLoCFXsPjq356SVYU
	 mpbfTqsooVdK10bPI4f38Y3Uu/JpTPRVjds06qwEFCH1gh7O3IvR1glCp68CA9tuSN
	 d/SbJlubQ3OkvlsQ79Gn80vWJSC+Foaf6tgdIBxr18GcmhKN2Q7NCPCB3sOOpX00lO
	 4h96kJtkEDJP7O0VWc4Qgfeb0VmLczZJ6Jgv+J4ETDwUVgU6RjdMOtjgh5+FXBBCSr
	 ld3uO4dsTgfhOmNixEyYLcnYZ/L4HWk4BqFH6NjqepLMr4YwZuvYoGlTxhoQWlaiFd
	 owrwbNvWUlZhw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sea5D-003xld-Dl;
	Thu, 15 Aug 2024 14:00:03 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 04/11] KVM: arm64: Add context-switch of ACCDATA_EL1
Date: Thu, 15 Aug 2024 13:59:52 +0100
Message-Id: <20240815125959.2097734-5-maz@kernel.org>
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

Add ACCDATA_EL1 save/restore as part of the EL0 context. This is
conditioned on the guest's view of ID_AA64ISAR1_EL1.LS64 reporting
that this register is supported.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 29 +++++++++++++++++-----
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index 4c0fdabaf8ae..d23d7113261b 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -21,12 +21,6 @@ static inline void __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
 	ctxt_sys_reg(ctxt, MDSCR_EL1)	= read_sysreg(mdscr_el1);
 }
 
-static inline void __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
-{
-	ctxt_sys_reg(ctxt, TPIDR_EL0)	= read_sysreg(tpidr_el0);
-	ctxt_sys_reg(ctxt, TPIDRRO_EL0)	= read_sysreg(tpidrro_el0);
-}
-
 static inline struct kvm_vcpu *ctxt_to_vcpu(struct kvm_cpu_context *ctxt)
 {
 	struct kvm_vcpu *vcpu = ctxt->__hyp_running_vcpu;
@@ -66,6 +60,26 @@ static inline bool ctxt_has_tcrx(struct kvm_cpu_context *ctxt)
 	return kvm_has_feat(kern_hyp_va(vcpu->kvm), ID_AA64MMFR3_EL1, TCRX, IMP);
 }
 
+static inline bool ctxt_has_accdata(struct kvm_cpu_context *ctxt)
+{
+	struct kvm_vcpu *vcpu = ctxt_to_vcpu(ctxt);
+
+	return kvm_has_feat(kern_hyp_va(vcpu->kvm), ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA);
+}
+
+static inline void __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
+{
+	ctxt_sys_reg(ctxt, TPIDR_EL0)	= read_sysreg(tpidr_el0);
+	ctxt_sys_reg(ctxt, TPIDRRO_EL0)	= read_sysreg(tpidrro_el0);
+
+	/*
+	 * Despite the appearances, ACCDATA_EL1 is part of the EL0
+	 * context, as it can only be used using ST64BV0.
+	 */
+	if (ctxt_has_accdata(ctxt))
+		ctxt_sys_reg(ctxt, ACCDATA_EL1)	= read_sysreg_s(SYS_ACCDATA_EL1);
+}
+
 static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt_sys_reg(ctxt, SCTLR_EL1)	= read_sysreg_el1(SYS_SCTLR);
@@ -126,6 +140,9 @@ static inline void __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
 {
 	write_sysreg(ctxt_sys_reg(ctxt, TPIDR_EL0),	tpidr_el0);
 	write_sysreg(ctxt_sys_reg(ctxt, TPIDRRO_EL0),	tpidrro_el0);
+
+	if (ctxt_has_accdata(ctxt))
+		write_sysreg_s(ctxt_sys_reg(ctxt, ACCDATA_EL1), SYS_ACCDATA_EL1);
 }
 
 static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
-- 
2.39.2


