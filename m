Return-Path: <kvm+bounces-65263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id ABD9ACA319F
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 10:53:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 455A9314A717
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 09:48:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31E8833890B;
	Thu,  4 Dec 2025 09:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gVP2oguJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B14338580;
	Thu,  4 Dec 2025 09:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764841717; cv=none; b=u5H4VdKXN0ZHC0V351/Tw344IMIrcZRDIg1hicB6cZ+q3sKVkhQ65TJRoDXkFzByt5NPww9Hb8eNOqAvcDQiYsck89OsLAGh8S4w4/IbNZyR97NyngYH67M4wBnb4x4aAC5/oSg1h3LUM3RAagtzwGNSqsC6Evo205JZcsOYf+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764841717; c=relaxed/simple;
	bh=9h9YsTsk5vn4vCNtdHh8qjme05rekVSJ2pUxZ7SnzH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcU+2aqgiwMAP/P1REbH4cdNgjtAhSHpMN8YmjkqE0LFOcELSe/NlvV+45qy/d/hfokq8SrZtfXufIhFTuaqRis/7SpajFQDHqGY6173qGL85vHC/a7e4RkTWDRdr1vR3H3GTW7bo8MkGEmnjlWXJ6ben91czS9OSdPjdz5L3qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gVP2oguJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88668C19424;
	Thu,  4 Dec 2025 09:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764841717;
	bh=9h9YsTsk5vn4vCNtdHh8qjme05rekVSJ2pUxZ7SnzH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gVP2oguJz42dqE3YljNBpawv/MxrxWGRUluteUC3wevwekNYQXj0k4f0Tg2ABSJ0M
	 XC+moOejr7Dt5feDdNx/Go6gEx4e6F6R2KYlS6NyUNGMw+IHDDgrCO9lKAY2+34uVv
	 ISY5Tt0aYj6mhjB+hZq5+QCpc5QQ2bb5UxXpUzg8sO95/OKRlMlLQWYsY8LoaryvTQ
	 RbZnvwkwDOmhCzb/WqPxlC5QUedDNH5GW2+DK3uPpAoSpoJ8H2WlKeB4OlGGZj7wia
	 9rpoQWlMgP1DDiCTJ3tVbpLN4RWUkiEfrCoX53R3l5ibn3b/xgGKz2MPjCe6EsT3OZ
	 0YY+gQxCLt/pQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vR5wx-0000000AP90-36QO;
	Thu, 04 Dec 2025 09:48:35 +0000
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
Subject: [PATCH v3 7/9] KVM: arm64: pkvm: Add a generic synchronous exception injection primitive
Date: Thu,  4 Dec 2025 09:48:04 +0000
Message-ID: <20251204094806.3846619-8-maz@kernel.org>
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

Similarly to the "classic" KVM code, pKVM doesn't have an "anything
goes" synchronous exception injection primitive.

Carve one out of the UNDEF injection code.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 107d62921b168..876b36d3d4788 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -243,16 +243,15 @@ static u64 pvm_calc_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 	}
 }
 
-/*
- * Inject an unknown/undefined exception to an AArch64 guest while most of its
- * sysregs are live.
- */
-static void inject_undef64(struct kvm_vcpu *vcpu)
+static void inject_sync64(struct kvm_vcpu *vcpu, u64 esr)
 {
-	u64 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
-
 	*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
 	*vcpu_cpsr(vcpu) = read_sysreg_el2(SYS_SPSR);
+
+	/*
+	 * Make sure we have the latest update to VBAR_EL1, as pKVM
+	 * handles traps very early, before sysregs are resync'ed
+	 */
 	__vcpu_assign_sys_reg(vcpu, VBAR_EL1, read_sysreg_el1(SYS_VBAR));
 
 	kvm_pend_exception(vcpu, EXCEPT_AA64_EL1_SYNC);
@@ -265,6 +264,15 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 	write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
 }
 
+/*
+ * Inject an unknown/undefined exception to an AArch64 guest while most of its
+ * sysregs are live.
+ */
+static void inject_undef64(struct kvm_vcpu *vcpu)
+{
+	inject_sync64(vcpu, (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT));
+}
+
 static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		       struct sys_reg_desc const *r)
 {
-- 
2.47.3


