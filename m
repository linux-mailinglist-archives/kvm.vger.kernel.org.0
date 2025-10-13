Return-Path: <kvm+bounces-59877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEBB6BD2106
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 10:32:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FFB43C2406
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 08:32:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC7442F618F;
	Mon, 13 Oct 2025 08:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PBPA9FmX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAABD2EACF0;
	Mon, 13 Oct 2025 08:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760344339; cv=none; b=tBk7hE5t10QVH2yvEPhKVHQ81gauzfHVHqgz+OBXKqaZzRbEFSlreh++BdVur9DLcMElAQly9hY+ZyaifiRyjIVc86qyReJiyo7Ehw4uOQxb+47nRV53BLaev9tpeDV+7GwWjG/KauHlL5g/GmREOpbxVEPfXKKFIkx8iBJ0GG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760344339; c=relaxed/simple;
	bh=D5mMnchbyvZg4t4adKmnSUlfgUWF0WYaKcUhZLciJSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFTAGFhIjF4Sv9hyW99e9zXipv1RzBLWyASw4fAI66YGkYYcYVnRa6DQJN6qWxIqJ0nLMk1o/yFRuF2qEyaA8A7I9sNA98Njwm1c+ZNKc9vnqJLBNVUpZgDeyM0QjVotRK5mpwkYpKHvP7WyzpsfsKbeYori9vupBLwPQho2UG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PBPA9FmX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4DFEC116B1;
	Mon, 13 Oct 2025 08:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760344338;
	bh=D5mMnchbyvZg4t4adKmnSUlfgUWF0WYaKcUhZLciJSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PBPA9FmXsfbsP6M+MZ8IeDralkp5eT036+ENvP6mubgarjnY9ZN4EVmASFsGY6P6n
	 DY1P5zwuBaOhL0aDZV8/Smc+5p53PAouyd5yA3BU6siKgAm1sDltClg9TZOCYhunBX
	 zmzXfJQPePW95oshLj/t+7ArZMzI3P8c1O3t9oYMkbIws/Y7Ny+viaPW0xkS2CZFdj
	 D1ocjZE1H11OJ0cngGyUoWtUM4gmsMYOvOavxm79GDyNu1r/nTW05u/6YZWy9OsmOs
	 TTvHackZ96ZeOeFP0pEkXwCbK+RMhCD8ywwPjURBgdlXQrq68aodN0OyOZUYk6VbrQ
	 dqUOjRGJ4Qa2Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v8Dya-0000000DRrP-3TOs;
	Mon, 13 Oct 2025 08:32:16 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	stable@vger.kernel.org
Subject: [PATCH 1/3] KVM: arm64: Make ID_PFR1_EL1.GIC writable
Date: Mon, 13 Oct 2025 09:32:05 +0100
Message-ID: <20251013083207.518998-2-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251013083207.518998-1-maz@kernel.org>
References: <20251013083207.518998-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, peter.maydell@linaro.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Similarly to ID_AA64PFR0_EL1.GIC, relax ID_PFR1_EL1.GIC to be writable.

Fixes: 5cb57a1aff755 ("KVM: arm64: Zero ID_AA64PFR0_EL1.GIC when no GICv3 is presented to the guest")
Reported-by: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/kvm/sys_regs.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b29f72478a50d..73dcefe51a3e7 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2528,6 +2528,12 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
 	.val = mask,				\
 }
 
+#define AA32_ID_WRITABLE(name, mask) {		\
+	ID_DESC(name),				\
+	.visibility = aa32_id_visibility,	\
+	.val = mask,				\
+}
+
 /* sys_reg_desc initialiser for cpufeature ID registers that need filtering */
 #define ID_FILTERED(sysreg, name, mask) {	\
 	ID_DESC(sysreg),				\
@@ -3040,7 +3046,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	/* AArch64 mappings of the AArch32 ID registers */
 	/* CRm=1 */
 	AA32_ID_SANITISED(ID_PFR0_EL1),
-	AA32_ID_SANITISED(ID_PFR1_EL1),
+	AA32_ID_WRITABLE(ID_PFR1_EL1, ID_PFR1_EL1_GIC),
 	{ SYS_DESC(SYS_ID_DFR0_EL1),
 	  .access = access_id_reg,
 	  .get_user = get_id_reg,
-- 
2.47.3


