Return-Path: <kvm+bounces-67431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 809B7D058BE
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 19:31:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 94EDD3747FF7
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 17:33:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5798E2C234E;
	Thu,  8 Jan 2026 17:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u4D83xWw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A802E0412;
	Thu,  8 Jan 2026 17:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767893560; cv=none; b=Y+ZJhQRhjwGQOO3vHbTVsM5/Tt8q5ywlTZr+d7WHsKgAWuIEQm2Q9hZUro/K2llfJCywAWqLYsNE7K/QHiUHb9d808lLVZmnVqs/jQoDc1SZJNgVQFM/F4wZpcxgr3yz2sWallIP9fplCp3fX+mgGxGPJz6LlEqCekOg6FB4swQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767893560; c=relaxed/simple;
	bh=14vGUcf2My30ymRVUO1QsDP5Hi0obb2aytzKycfx2Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s88bN+bbBzKEpqwERBPzYVBbgbG47Tpc7M/6YPZSNPzdI2zWm2rBizpz5P/9houcjGNqBT2TEK4EQr9h9/svj9f5D6GsBJk9iR79e8lP3rcaFiMzF68TChUqyY8vIGjsOl9aUd+u3G+NExpBiJ+RTmMG5kRRj3rU0GMHQ49rc7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u4D83xWw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC78C116D0;
	Thu,  8 Jan 2026 17:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767893559;
	bh=14vGUcf2My30ymRVUO1QsDP5Hi0obb2aytzKycfx2Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u4D83xWwCfw/8NYVqph4QrAD0S9o22dQ4EOuUbcbiYK6GPM6U47qqhJYpyme78gaK
	 L9TfBPvfV09ZADN/5He32Zyd7QdbaDxWCTs0f28Qx+ax4094BjKtIOb/LpVVUzF/nf
	 fvBE+0cCEpbYXAPAGXg+IU90MQbpXthLY/CvCHgI33ZRdaTaTMbiG9MwmI2gUWTRzT
	 gcpxN8NJVV/yREJB3zsCckv6u18RCjGs4LJi8HJ998AlCaxAky8pg6laBVAs0QjhfT
	 J72von3j+UYBGPAiTE2IUyslyXs1meOx4f1c04+ZarIrgIMw6s1fhcz7iKIKh+lR8e
	 ffrdqw3H5fsfQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vdtsD-00000000W9F-3yCX;
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
Subject: [PATCH v4 7/9] KVM: arm64: pkvm: Add a generic synchronous exception injection primitive
Date: Thu,  8 Jan 2026 17:32:31 +0000
Message-ID: <20260108173233.2911955-8-maz@kernel.org>
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

Similarly to the "classic" KVM code, pKVM doesn't have an "anything
goes" synchronous exception injection primitive.

Carve one out of the UNDEF injection code.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 4db0562f5bfa4..b197f3eb272c1 100644
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


