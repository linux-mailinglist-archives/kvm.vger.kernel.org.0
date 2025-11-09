Return-Path: <kvm+bounces-62463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2570FC4441F
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 18:20:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3D4624E9BD5
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 17:19:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BF413126B7;
	Sun,  9 Nov 2025 17:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eiTGmCBD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF123115B0;
	Sun,  9 Nov 2025 17:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762708600; cv=none; b=LL4GXgIahZSjkC53FjMNoLcjG/Q7VI+twwkD9cK+RxtZynsj2PXvSZzlqq1LFUAQrR902r6+7cZrGHmA6e2MaWMbTnwvmXTmlW4Ij4C+grG+OtOmlUa6OahfkYwPjdPfOn7Ro7gcs7Thb5muO++uqA/4xCgR1FQGEniB/PblIbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762708600; c=relaxed/simple;
	bh=j0th7GA0xqHLiepW7dUSxk4pKWMRkFmffQx8Rt9cZqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIgq7ivnGfo+q6WliM4ihZQSh1IqSzYbjqUtDlE+Cx3WlqHJ4qp/9kG6fo+DgiX4hPCx1QxhcRGeRzHPQeRORQcVJPKqNu930UUNOF8LQlzH/LtbToWxSUpcJlnxit/oEzMNIxAOTQNnqGFycwh3yE7kHfz5RJ9hpEItIktKtnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eiTGmCBD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10926C4CEF7;
	Sun,  9 Nov 2025 17:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762708600;
	bh=j0th7GA0xqHLiepW7dUSxk4pKWMRkFmffQx8Rt9cZqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eiTGmCBDQIfvLWBEZOzkwHw/3S0dPqucblw7usVylRbckdCoIZFflPWIHnm9opf5x
	 ZfGG32d/eNm8q7E4aorCti0MAtdT+ybe1PbU6APf/dHfxs0Mpi7pnhBkC9mI+5JLcC
	 cYKRGsuL0UVwOUnbSBAbSdNNu/w/N6ysVkI6XZghtItPjiV4pJCqs2yeEo5BfVTX2C
	 8ebG2wSnkGYtF8Lr6NPNPor9HiIOYOPoKyQN5BHEWNC1tf/vXub2mZASJo+9v34unL
	 NvkULZY2jD2ML8cCaPdKxR1RsJG6Kv4eeKGzUs7MbIm8trvkkaG75fqnAOm3LBj3It
	 V+qPNcbO37gTQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vI91q-00000003exw-0UOk;
	Sun, 09 Nov 2025 17:16:38 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: [PATCH v2 40/45] KVM: arm64: selftests: vgic_irq: Exclude timer-controlled interrupts
Date: Sun,  9 Nov 2025 17:16:14 +0000
Message-ID: <20251109171619.1507205-41-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251109171619.1507205-1-maz@kernel.org>
References: <20251109171619.1507205-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, Volodymyr_Babchuk@epam.com, yaoyuan@linux.alibaba.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The PPI injection API is clear that you can't inject the timer PPIs
from userspace, since they are controlled by the timers themselves.

Add an exclusion list for this purpose.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/arm64/vgic_irq.c | 31 ++++++++++++++++----
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_irq.c b/tools/testing/selftests/kvm/arm64/vgic_irq.c
index a8919ef3cea2e..b0415bdb89524 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_irq.c
@@ -359,8 +359,9 @@ static uint32_t wait_for_and_activate_irq(void)
  * interrupts for the whole test.
  */
 static void test_inject_preemption(struct test_args *args,
-		uint32_t first_intid, int num,
-		kvm_inject_cmd cmd)
+				   uint32_t first_intid, int num,
+				   const unsigned long *exclude,
+				   kvm_inject_cmd cmd)
 {
 	uint32_t intid, prio, step = KVM_PRIO_STEPS;
 	int i;
@@ -379,6 +380,10 @@ static void test_inject_preemption(struct test_args *args,
 	for (i = 0; i < num; i++) {
 		uint32_t tmp;
 		intid = i + first_intid;
+
+		if (exclude && test_bit(i, exclude))
+			continue;
+
 		KVM_INJECT(cmd, intid);
 		/* Each successive IRQ will preempt the previous one. */
 		tmp = wait_for_and_activate_irq();
@@ -390,6 +395,10 @@ static void test_inject_preemption(struct test_args *args,
 	/* finish handling the IRQs starting with the highest priority one. */
 	for (i = 0; i < num; i++) {
 		intid = num - i - 1 + first_intid;
+
+		if (exclude && test_bit(intid - first_intid, exclude))
+			continue;
+
 		gic_set_eoi(intid);
 		if (args->eoi_split)
 			gic_set_dir(intid);
@@ -397,8 +406,12 @@ static void test_inject_preemption(struct test_args *args,
 
 	local_irq_enable();
 
-	for (i = 0; i < num; i++)
+	for (i = 0; i < num; i++) {
+		if (exclude && test_bit(i, exclude))
+			continue;
+
 		GUEST_ASSERT(!gic_irq_get_active(i + first_intid));
+	}
 	GUEST_ASSERT_EQ(gic_read_ap1r0(), 0);
 	GUEST_ASSERT_IAR_EMPTY();
 
@@ -442,14 +455,20 @@ static void test_preemption(struct test_args *args, struct kvm_inject_desc *f)
 	 * number of concurrently active IRQs. The number of LRs implemented is
 	 * IMPLEMENTATION DEFINED, however, it seems that most implement 4.
 	 */
+	/* Timer PPIs cannot be injected from userspace */
+	static const unsigned long ppi_exclude = (BIT(27 - MIN_PPI) |
+						  BIT(30 - MIN_PPI) |
+						  BIT(28 - MIN_PPI) |
+						  BIT(26 - MIN_PPI));
+
 	if (f->sgi)
-		test_inject_preemption(args, MIN_SGI, 4, f->cmd);
+		test_inject_preemption(args, MIN_SGI, 4, NULL, f->cmd);
 
 	if (f->ppi)
-		test_inject_preemption(args, MIN_PPI, 4, f->cmd);
+		test_inject_preemption(args, MIN_PPI, 4, &ppi_exclude, f->cmd);
 
 	if (f->spi)
-		test_inject_preemption(args, MIN_SPI, 4, f->cmd);
+		test_inject_preemption(args, MIN_SPI, 4, NULL, f->cmd);
 }
 
 static void test_restore_active(struct test_args *args, struct kvm_inject_desc *f)
-- 
2.47.3


