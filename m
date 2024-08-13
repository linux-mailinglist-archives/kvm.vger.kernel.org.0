Return-Path: <kvm+bounces-23964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0009E950209
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 12:08:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B04AD283AF6
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 10:08:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 887C819B59D;
	Tue, 13 Aug 2024 10:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C54js7vh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB03219B3C7;
	Tue, 13 Aug 2024 10:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723543583; cv=none; b=WbLy9KXreOUd7I3+LigRSbzsuJOVLqF6E/yHBnEya/cBENoQXdy7d/PttFX3co3yCzcMtYKVcy7sxs+IXK+U0O2BOsxuwjEhRrWtro53Jke+Z2/IyU2/jP1T2GVDh4PqLVch6/jWup4kAtKyDm9yeCzjmP+MD61Ea1W7nea5S7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723543583; c=relaxed/simple;
	bh=vSHhjuKzB4XiKT8IC31iaRepSYA94uoZc8/lCfNk+mU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qgrvdMJ6Y1SRj+JDFsIS2ZVVqA9BK0sHG3DM0yqwLT0JvuTKmQ9iU2HzSDfJrgvDsHmGpLVXmQSBJV5rwpjTjA3BNHMSpUDI/OD/dwXVJ0zDqUB6JegKhLQiI27g1MFWyLf2grQ4NAj6bHy3IQeZcpmUCQu/qQuV9trWuyn1Tgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C54js7vh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5FFC4AF12;
	Tue, 13 Aug 2024 10:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723543583;
	bh=vSHhjuKzB4XiKT8IC31iaRepSYA94uoZc8/lCfNk+mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C54js7vh+jUxyAnie49ehuXwSaF8cTk++XqfbsBy09wi2Pdsszoz78IjhRy2Gqg9r
	 G2ESrh3ZiwnPp0ND6rgmuBKJn8eVEpwbF436pnKGNIZ2sjqKsRGOFyBu1qhuBHomr3
	 rk4HXeezTqpVvFdnXCynPGY8s/6mAsg1CpnrXO7zUXIBE5fV2GpzNNO66qL2alyYRS
	 UFqcUsdJHf2/tu3x1N3Hynt4hXa4fOZphPtYFV3asz/RAX46Ie6eB/VTN+MWkemo8f
	 bFCDGNUQrELTJUy3FZELu7BLph+GvBXihzsyy/+5G5t3egJBZMsSCz6m2Xwt3rlPNX
	 FRx3NHxddKH6Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sdoQ1-003INM-QA;
	Tue, 13 Aug 2024 11:06:21 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Przemyslaw Gaj <pgaj@cadence.com>
Subject: [PATCH v3 10/18] KVM: arm64: nv: Add basic emulation of AT S1E1{R,W}P
Date: Tue, 13 Aug 2024 11:05:32 +0100
Message-Id: <20240813100540.1955263-11-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240813100540.1955263-1-maz@kernel.org>
References: <20240813100540.1955263-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, anshuman.khandual@arm.com, pgaj@cadence.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Building on top of our primitive AT S1E{0,1}{R,W} emulation,
add minimal support for the FEAT_PAN2 instructions, momentary
context-switching PSTATE.PAN so that it takes effect in the
context of the guest.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index da378ad834cd..92df948350e1 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -49,6 +49,28 @@ static void __mmu_config_restore(struct mmu_config *config)
 	write_sysreg(config->vtcr,	vtcr_el2);
 }
 
+static bool at_s1e1p_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
+{
+	u64 host_pan;
+	bool fail;
+
+	host_pan = read_sysreg_s(SYS_PSTATE_PAN);
+	write_sysreg_s(*vcpu_cpsr(vcpu) & PSTATE_PAN, SYS_PSTATE_PAN);
+
+	switch (op) {
+	case OP_AT_S1E1RP:
+		fail = __kvm_at(OP_AT_S1E1RP, vaddr);
+		break;
+	case OP_AT_S1E1WP:
+		fail = __kvm_at(OP_AT_S1E1WP, vaddr);
+		break;
+	}
+
+	write_sysreg_s(host_pan, SYS_PSTATE_PAN);
+
+	return fail;
+}
+
 /*
  * Return the PAR_EL1 value as the result of a valid translation.
  *
@@ -105,6 +127,10 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	isb();
 
 	switch (op) {
+	case OP_AT_S1E1RP:
+	case OP_AT_S1E1WP:
+		fail = at_s1e1p_fast(vcpu, op, vaddr);
+		break;
 	case OP_AT_S1E1R:
 		fail = __kvm_at(OP_AT_S1E1R, vaddr);
 		break;
-- 
2.39.2


