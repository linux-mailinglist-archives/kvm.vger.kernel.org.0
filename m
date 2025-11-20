Return-Path: <kvm+bounces-63959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DDF4C75BA2
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:38:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 713E24E1FEA
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:32:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90C443A8D5A;
	Thu, 20 Nov 2025 17:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WG+chxVV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482683A9C1B;
	Thu, 20 Nov 2025 17:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659567; cv=none; b=BHW5ha+jwaeUVNEx+IJLYdnxtgNvg15qQBbMgnAI67mfKxZGgGmsSWX/VGtPYCUDIxNUYdWRw85UEYR7/txe0lvsM2LLidOfqLs5CVzpsfb1INYNvOLCLbNdh2IOoyntPtQ5ksBIGWc23QUn2HdA4Q7KW3KWvKizCmTkgpF2vXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659567; c=relaxed/simple;
	bh=jCvnrPftqEsyiN8DzIt9mFf2b52ipWjvxmhQO/3Ya7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nkYPYnh4RzeFVo9+r7y0WKiEUpKjpeEy0MrrD0beoLf0cxpGRoIT/Wdp7DQmkutH/LDuf2Fp+5fSkdHWW6K9pQVfyBQcq9m/lJwoeDzESxyvqE+ovcYowU86AOLnQtzqWa7rspKMDafeqnEesDnxlX2lNr3VkB2yYerNhcrKpV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WG+chxVV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5B7C116C6;
	Thu, 20 Nov 2025 17:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659567;
	bh=jCvnrPftqEsyiN8DzIt9mFf2b52ipWjvxmhQO/3Ya7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WG+chxVVuHYkoRKjfub2O11OUQjMEwtg/bBlsKDOc6o/oGqwb6VkP39uGeMJcjVot
	 bMDttdKRMsCu/xXc3SC2+ueuA6WmN6FzK8noP/zGiLPwN6oBewEztjMmUZjvEHbYEM
	 6lsK9Gof6/0oYFexienEzveargf9GLgzMjdJxNpL4w0C5XGIU719FiPNGSK6deZaG1
	 CYocKgLCOybRcY2DjJsPD7zALlU1I8dD9YxBIqMZgEUGqPNGOtcbtrSt+BsSBmsuMO
	 tLdqzM/BmjXfxJjUBgrBT4kkdAvTe0mR1br+5ACnNtFSKUNh8OIHkYab3WTV8afGJY
	 w1RV/zAYxAgGQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Q1-00000006y6g-1ZVw;
	Thu, 20 Nov 2025 17:26:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 45/49] KVM: arm64: selftests: vgic_irq: Remove LR-bound limitation
Date: Thu, 20 Nov 2025 17:25:35 +0000
Message-ID: <20251120172540.2267180-46-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251120172540.2267180-1-maz@kernel.org>
References: <20251120172540.2267180-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, tabba@google.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Good news: our GIC emulation is not completely broken, and we can
activate as many interrupts as we want.

Bump the test to cover all the SGIs, all the allowed PPIs, and
31 SPIs. Yes, 31, because we have 31 available priorities, and the
test is not happy with having two interrupts with the same priority.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/arm64/vgic_irq.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_irq.c b/tools/testing/selftests/kvm/arm64/vgic_irq.c
index b0415bdb89524..9d4761f1a3204 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_irq.c
@@ -449,12 +449,6 @@ static void test_injection_failure(struct test_args *args,
 
 static void test_preemption(struct test_args *args, struct kvm_inject_desc *f)
 {
-	/*
-	 * Test up to 4 levels of preemption. The reason is that KVM doesn't
-	 * currently implement the ability to have more than the number-of-LRs
-	 * number of concurrently active IRQs. The number of LRs implemented is
-	 * IMPLEMENTATION DEFINED, however, it seems that most implement 4.
-	 */
 	/* Timer PPIs cannot be injected from userspace */
 	static const unsigned long ppi_exclude = (BIT(27 - MIN_PPI) |
 						  BIT(30 - MIN_PPI) |
@@ -462,26 +456,25 @@ static void test_preemption(struct test_args *args, struct kvm_inject_desc *f)
 						  BIT(26 - MIN_PPI));
 
 	if (f->sgi)
-		test_inject_preemption(args, MIN_SGI, 4, NULL, f->cmd);
+		test_inject_preemption(args, MIN_SGI, 16, NULL, f->cmd);
 
 	if (f->ppi)
-		test_inject_preemption(args, MIN_PPI, 4, &ppi_exclude, f->cmd);
+		test_inject_preemption(args, MIN_PPI, 16, &ppi_exclude, f->cmd);
 
 	if (f->spi)
-		test_inject_preemption(args, MIN_SPI, 4, NULL, f->cmd);
+		test_inject_preemption(args, MIN_SPI, 31, NULL, f->cmd);
 }
 
 static void test_restore_active(struct test_args *args, struct kvm_inject_desc *f)
 {
-	/* Test up to 4 active IRQs. Same reason as in test_preemption. */
 	if (f->sgi)
-		guest_restore_active(args, MIN_SGI, 4, f->cmd);
+		guest_restore_active(args, MIN_SGI, 16, f->cmd);
 
 	if (f->ppi)
-		guest_restore_active(args, MIN_PPI, 4, f->cmd);
+		guest_restore_active(args, MIN_PPI, 16, f->cmd);
 
 	if (f->spi)
-		guest_restore_active(args, MIN_SPI, 4, f->cmd);
+		guest_restore_active(args, MIN_SPI, 31, f->cmd);
 }
 
 static void guest_code(struct test_args *args)
-- 
2.47.3


