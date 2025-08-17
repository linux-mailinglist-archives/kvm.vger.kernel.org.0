Return-Path: <kvm+bounces-54845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F0D56B292EF
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 14:19:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D767F206B7D
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 12:19:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8139A246BB2;
	Sun, 17 Aug 2025 12:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MicD08+X"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC4E23958C;
	Sun, 17 Aug 2025 12:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755433176; cv=none; b=VPfrY7ElMrvLRUgCoXa2Rm3XZYK1t9rPMM6ejRrrjY35QXbHyZQbyzr2Dw0MrXScAvKgKsn16IzNeiF3BJYwAeDQKl8Aue8znl8+gfO/mUsgRe/VxJIYw8mvMzPnSD3oHWf0qC9f9x+BJoqj2061OwOWIpacYYwjcvnFrOQ+jXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755433176; c=relaxed/simple;
	bh=RBob3+AvRkvfEfvFXTw/GdVJZ/1+9Wc1qjUp0oWbL8s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UUIrKKvPN5NZHzoCZXE5g83ONPyiL+ykgYQa8o2mpqnV4LgBbDTQcQzX3NazJlKEKWrbQZl6ci0716uicf7/+bXjNrQirtBTJia1bzZp+N5cY1xKkca2zeDWmbigT6feXpwjiQ/nM9yp81WG61DIRUcdPQnQa7hpaqgrwkY3zXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MicD08+X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11866C4CEED;
	Sun, 17 Aug 2025 12:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755433176;
	bh=RBob3+AvRkvfEfvFXTw/GdVJZ/1+9Wc1qjUp0oWbL8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MicD08+XXo1pVla9xI65WfAi2HmvTpxnN1p3V1haJEKgtZ3Bu/8EECll9IreGSaQA
	 pJxYyA38557tr15fwtpmoLqVHp0rfPH1VCrv0bchLP/4FRKTb+3mhk4+jc+7HnnbGI
	 6aojR+VBxTyYGYYu7lwgi19wX3AyMC5AJ8yy515EFPLq4NPg0QBegCccDTB8EH1sAN
	 gBocqRuiHfmMkNK5f1Yqxj6NpuwzHWRyrpqAq2lrle5R7Ez6Ee4PTuQnt3vdtkCxmD
	 urcKFAgNqPajJMlSgn8RZWeOi/yIcA6eXr5vOYEuouWc69Mgz2475ZdlY9kVgzdkbG
	 IrP8XorUnEK7g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uncME-008L0z-RG;
	Sun, 17 Aug 2025 13:19:30 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Volodymyr Babchuk <volodymyr_babchuk@epam.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 2/4] KVM: arm64: Simplify sysreg access on exception delivery
Date: Sun, 17 Aug 2025 13:19:24 +0100
Message-Id: <20250817121926.217900-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250817121926.217900-1-maz@kernel.org>
References: <20250817121926.217900-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, volodymyr_babchuk@epam.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Distinguishing between NV and VHE is slightly pointless, and only
serves as an extra complication, or a way to introduce bugs, such
as the way SPSR_EL1 gets written without checking for the state
being resident.

Get rid if this silly distinction, and fix the bug in one go.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/exception.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index 3e67333197ab2..bef40ddb16dbc 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -22,36 +22,28 @@
 
 static inline u64 __vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 {
-	u64 val;
-
-	if (unlikely(vcpu_has_nv(vcpu)))
+	if (has_vhe())
 		return vcpu_read_sys_reg(vcpu, reg);
-	else if (vcpu_get_flag(vcpu, SYSREGS_ON_CPU) &&
-		 __vcpu_read_sys_reg_from_cpu(reg, &val))
-		return val;
 
 	return __vcpu_sys_reg(vcpu, reg);
 }
 
 static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 {
-	if (unlikely(vcpu_has_nv(vcpu)))
+	if (has_vhe())
 		vcpu_write_sys_reg(vcpu, val, reg);
-	else if (!vcpu_get_flag(vcpu, SYSREGS_ON_CPU) ||
-		 !__vcpu_write_sys_reg_to_cpu(val, reg))
+	else
 		__vcpu_assign_sys_reg(vcpu, reg, val);
 }
 
 static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long target_mode,
 			      u64 val)
 {
-	if (unlikely(vcpu_has_nv(vcpu))) {
+	if (has_vhe()) {
 		if (target_mode == PSR_MODE_EL1h)
 			vcpu_write_sys_reg(vcpu, val, SPSR_EL1);
 		else
 			vcpu_write_sys_reg(vcpu, val, SPSR_EL2);
-	} else if (has_vhe()) {
-		write_sysreg_el1(val, SYS_SPSR);
 	} else {
 		__vcpu_assign_sys_reg(vcpu, SPSR_EL1, val);
 	}
-- 
2.39.2


