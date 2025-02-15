Return-Path: <kvm+bounces-38305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A8D2A36FD6
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 18:39:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9835170AC1
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 17:39:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 302721FCD12;
	Sat, 15 Feb 2025 17:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XVSI0zHL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96951EDA1D;
	Sat, 15 Feb 2025 17:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739641103; cv=none; b=e+geNqXfKZWsT4xTcyyE9vY1/L3DnWyG2nfT1WqZC+5JcPY4cruC9t2tDlmKXrp3xxh+WQ4CZZ50an3Mo5hOGk/GdaF6TNYCiMgVSmyEQjS2SYcbwiOHD9dcdd/X+2PYu5LI30YrLFYP5fZnQdeuvJ1TWHUM8AIlo/hvQ2Rzp+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739641103; c=relaxed/simple;
	bh=LEtVaxB4lu5XK8RmKO0qA5NQ+6d1p7e+by5R5CODK9s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ac574jgycpVFQ61RRY4VUh31YtqXmAx96gGcvjN5ajR35+R8u9dfekn8EYK0yySEYWn06rPg1GaqCUsJcolvyR4lDif3nM7gyzuUseCtjOVcEZkh0iJ+EGysIdtEJrrQtimEPIYuKqecHgTHRsbWvGktewS1wGElbRg/rjSd8rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XVSI0zHL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64CC4C4CEE2;
	Sat, 15 Feb 2025 17:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739641103;
	bh=LEtVaxB4lu5XK8RmKO0qA5NQ+6d1p7e+by5R5CODK9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XVSI0zHLC6pVpMWWixZWs/IeXYmpkEGpueetvHUOEBajEl6mIhJBCQYOoXdYM8HJZ
	 54SXNktOK6WmF5moD+rkMCIAesUCq4pFOuJMAfIn00Gt0zMGebzSPVdXm6oxRzCt8S
	 qmArK2Uc+hhDOMrvhtAJZyh7MF8zWm7XtatrJu/NZdELFfpWVErC/iX97ia6EHJf8O
	 JW5dGRdrsheYAcwUn5Ux7nyZOIToqI6VDaJTRSRoPz/I7fLVDHHMRu14jyqiaPC5O6
	 cd/tXI4Vm1B+tHYmoxTxNWkUTAdqvIESZUorTvfn6Hx6SrnVJngUalnq//4Mfrnrbt
	 7S53d6vr16K/g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tjM7R-004Pqp-Kd;
	Sat, 15 Feb 2025 17:38:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 07/14] KVM: arm64: Make ID_REG_LIMIT_FIELD_ENUM() more widely available
Date: Sat, 15 Feb 2025 17:38:09 +0000
Message-Id: <20250215173816.3767330-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250215173816.3767330-1-maz@kernel.org>
References: <20250215173816.3767330-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com
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
index b1bd1a47e7caa..885cdef77d01e 100644
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


