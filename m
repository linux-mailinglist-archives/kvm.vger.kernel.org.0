Return-Path: <kvm+bounces-62543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 317D8C485AC
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:33:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A58614EAC4B
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 17:30:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D84E2D0628;
	Mon, 10 Nov 2025 17:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p7ZvE2yO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5F92BEC30;
	Mon, 10 Nov 2025 17:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762795837; cv=none; b=WJGkMQBPMKhWkfRthOQ7m6t7RLjYrHzMzTiH4sXXN9ziXkPg72wqu4pvv5XQx+QvmiDDwtUCxlMF0CWFYRPd6AXzi8Eo1PNvQMdS5zEXRW3qxZdsM72XPN3nFcf6kMp8kL1CU3QDnsjf2vVdDwxPfvM56hr9RoH/KGTNS7/DbUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762795837; c=relaxed/simple;
	bh=Oj/DqEQrV3Z259MuriU+WvexyYI+Pm4QRY0TAayDktc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hEH5g6z6/Ut0V/teWLv5qZxOATGkQ+dfPwrPY2IcaTEvySefqLPVjkHUjL3pD8MoUe97q1B0pGJ5X0daZGwRcNGpD47KPr8GYJ2rL45/w2llIM2a6yvMJG3qZo9lflJF9Na16mbIZesLCP38fEKGuQdmMPyUWNR68ea7ChHxK2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p7ZvE2yO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED17BC116D0;
	Mon, 10 Nov 2025 17:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762795837;
	bh=Oj/DqEQrV3Z259MuriU+WvexyYI+Pm4QRY0TAayDktc=;
	h=From:To:Cc:Subject:Date:From;
	b=p7ZvE2yOSxPMxI9k96VnPKPody/hqdXDOjY4pOxW9QPZv0XhGbpvv4KbOK1eUbOkK
	 Ha4GUAsyRsnA2/us3FNs2OpzXg5CoEi1/IKlpitwQ3rQOyKgso3qmENI3+L2SLywkD
	 B823d/1BQy5cb6ndVOW7sUMK8/V8IKZbqQu+51QvCrGOcxFRCHQMELROYB4mD3iBPb
	 itRF6bLq4dmVIQJ2VGiPkpA1Rj15+ExgXjwAV3NiwYbIZKahslYR5peo05FHWLpNyl
	 qOcVyDNRnvVIqryUi1QyHB0XF3IIhSW+ihHBi0YPA98fmXI9KrY7QlqYjoXTtghHi4
	 EAQopUty1q+tg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vIVis-00000003xP9-2G1B;
	Mon, 10 Nov 2025 17:30:34 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH] KVM: arm64: Finalize ID registers only once per VM
Date: Mon, 10 Nov 2025 17:30:10 +0000
Message-ID: <20251110173010.1918424-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Owing to the ID registers being global to the VM, there is no point
in computing them more than once.  However, recent changes making
use of kvm_set_vm_id_reg() outlined that we repeatedly hammer
the ID registers when we shouldn't.

Gate the ID reg update on the VM having never run.

Fixes: 50e7cce81b9b2 ("KVM: arm64: Limit clearing of ID_{AA64PFR0,PFR1}_EL1.GIC to userspace irqchip")
Fixes: 5cb57a1aff755 ("KVM: arm64: Zero ID_AA64PFR0_EL1.GIC when no GICv3 is presented to the guest")
Closes: https://lore.kernel.org/r/aRHf6x5umkTYhYJ3@finisterre.sirena.org.uk
Reported-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3bf7005258f07..19afcd833d6fa 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5624,7 +5624,11 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
 
 	guard(mutex)(&kvm->arch.config_lock);
 
-	if (!irqchip_in_kernel(kvm)) {
+	/*
+	 * This hacks into the ID registers, so only perform it when the
+	 * first vcpu runs, or the kvm_set_vm_id_reg() helper will scream.
+	 */
+	if (!irqchip_in_kernel(kvm) && !kvm_vm_has_ran_once(kvm)) {
 		u64 val;
 
 		val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1) & ~ID_AA64PFR0_EL1_GIC;
-- 
2.47.3


