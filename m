Return-Path: <kvm+bounces-38699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A41AA3DBB2
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 14:50:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8738B189F9B5
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 13:50:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E6101FE46F;
	Thu, 20 Feb 2025 13:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AU18isSq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEFD1FAC5E;
	Thu, 20 Feb 2025 13:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740059355; cv=none; b=KrggPblzjbPVvFFEZemWUS2rDWZ20WRLqsahW8OHJdLKFXspXgGRqw+SzapQcG1TZRefqtDBJDgMD9CbJb6Pj914sIUFxm7p02k0Ds9tXd25F21jwz7t0fsB9K7lLlxwC7+3s/DS3oYSDh8tNCkrSVZU/AtoXOBxHCcIIjQ07/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740059355; c=relaxed/simple;
	bh=BbvYn+ZZ1IWZiQh4LZNEmsttX+u4/bUxfHPvQig08+k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mbvWiW99n/AI3xNsThgrGKkqyBcgmW1sHOc1+gvNpYOCvCzUg2F3fof/xWkeUuXENGt4eCUINvFPCVpu3Gu/MNUvm2S5BuSJBOLL7bwGF+GHG6hrB35oAQlJCK2VWcvWU4EGWFXXjVZQ+mfrDpOXmYUZSPsiB6y8oyMvF2icFDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AU18isSq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2EA3C4CEE2;
	Thu, 20 Feb 2025 13:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740059355;
	bh=BbvYn+ZZ1IWZiQh4LZNEmsttX+u4/bUxfHPvQig08+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AU18isSqWYLy6+aT9kxnKouS93bJw8eSqe8O4WymKrrJUVwY9JO+Q+o6A2s7iE5Ai
	 b+0dDiuM5ZBOXmRmVtA/eyA+DOSkOuPUeNPO8D6FXOHZO2cpVY4F8RBpRCaeFfVn2f
	 io+UoOIWA8sMtq0b/v6Ra3/LmaakEBc5OvxRIPBZbvptngyhNymJ61RS/fUk21bV2B
	 Z23kO5VVScXkf579l5nnO+nMgKWp/BHTgcRMRWUZfh0eJkQAjXfZcU+EfN3WGJYJaf
	 o6ITX4xXQ6KvqOj97meFBD80CTFHApu5boQfBuFoXqQ0k74vdpJD2jPptRXoPHFF2o
	 PP9H3VTg4j17w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tl6vR-006DXp-05;
	Thu, 20 Feb 2025 13:49:13 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	gankulkarni@os.amperecomputing.com
Subject: [PATCH v2 07/14] KVM: arm64: Make ID_REG_LIMIT_FIELD_ENUM() more widely available
Date: Thu, 20 Feb 2025 13:49:00 +0000
Message-Id: <20250220134907.554085-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250220134907.554085-1-maz@kernel.org>
References: <20250220134907.554085-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

ID_REG_LIMIT_FIELD_ENUM() is a useful macro to limit the idreg
features exposed to guest and userspace, and the NV code can
make use of it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 10 ----------
 arch/arm64/kvm/sys_regs.h | 10 ++++++++++
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 678213dc15513..d14daadb8a7c0 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1803,16 +1803,6 @@ static u64 sanitise_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
 	return val;
 }
 
-#define ID_REG_LIMIT_FIELD_ENUM(val, reg, field, limit)			       \
-({									       \
-	u64 __f_val = FIELD_GET(reg##_##field##_MASK, val);		       \
-	(val) &= ~reg##_##field##_MASK;					       \
-	(val) |= FIELD_PREP(reg##_##field##_MASK,			       \
-			    min(__f_val,				       \
-				(u64)SYS_FIELD_VALUE(reg, field, limit)));     \
-	(val);								       \
-})
-
 static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
 {
 	val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, V8P8);
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 1d94ed6efad2c..cc6338d387663 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -247,4 +247,14 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu);
 	CRn(sys_reg_CRn(reg)), CRm(sys_reg_CRm(reg)),	\
 	Op2(sys_reg_Op2(reg))
 
+#define ID_REG_LIMIT_FIELD_ENUM(val, reg, field, limit)			       \
+({									       \
+	u64 __f_val = FIELD_GET(reg##_##field##_MASK, val);		       \
+	(val) &= ~reg##_##field##_MASK;					       \
+	(val) |= FIELD_PREP(reg##_##field##_MASK,			       \
+			    min(__f_val,				       \
+				(u64)SYS_FIELD_VALUE(reg, field, limit)));     \
+	(val);								       \
+})
+
 #endif /* __ARM64_KVM_SYS_REGS_LOCAL_H__ */
-- 
2.39.2


