Return-Path: <kvm+bounces-63963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id AC7D7C75B48
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:34:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 240882E0ED
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 987BA36D4FC;
	Thu, 20 Nov 2025 17:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UmXkWokT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755CC36CDFC;
	Thu, 20 Nov 2025 17:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659568; cv=none; b=FmBjhe9zwoFHku247t6/FLSNqwz8sa6SUzB5Roy6wEg4fNKGYvybHlvMjdnuz5tpzjlj4U/5KGlxAWkD8KpFEmkDSC/PSbWiRbx7jKgS6j7+aTH5khCaM/ihAiUJO3l/6CQ6/Lgxp5xTAN4OVtKAi5QD5n1y5NrNvt7y+T8IsDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659568; c=relaxed/simple;
	bh=A+jC/oF78+efqRiv4n3Vh1E7Uqik67e2g5MwtDzhVy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AX8u3wuGtCmaIUpbmtRJdTY+JPRA0HdR7ptzfadFo1o4oJFWmOnmxx5JgqbjOykLnnD2X0u2yAhYKo+0BOuSIKCP/o9ZDMaODPi3UtnfpwMNCV0om1UNmsI2WngA71Y/uHlrPxueUj5Dcc8M3uD6nI5Xq8ZyIghqcyFof3pCXdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UmXkWokT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E32C16AAE;
	Thu, 20 Nov 2025 17:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659568;
	bh=A+jC/oF78+efqRiv4n3Vh1E7Uqik67e2g5MwtDzhVy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UmXkWokTG/hlinLUDc2RUMJO9tHqPinTvtp+J2EYguJU4H4Jj/P0K95kvL83DsDpx
	 2O4vDVj5tcDxXh4vdAJ4X59YZUTRhb/EnWrDUtts+y8ws1uU9/ZnznMd5/1eqtw3JJ
	 q82K/ua/uqA5+dJubGrzUtLPkJRdMK3FG7BGS19ZeNt2accZ0DrpyXdI/nzVcc/9Sr
	 g0V/kdO31QmIkq4cxloMvIJdggTn1HBBJC2CrvdQSoRiSBCU21F92EDOvPWBTUwyKW
	 dxad0R/pTs3yfJbFo3fNnTvnpae3JbnxHipnPL3tYjUUvjjXw+C1K/mY6VS3gyvCH4
	 1LYulMSkoRDIA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Q2-00000006y6g-0jk7;
	Thu, 20 Nov 2025 17:26:06 +0000
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
Subject: [PATCH v4 48/49] KVM: arm64: selftests: vgic_irq: Add Group-0 enable test
Date: Thu, 20 Nov 2025 17:25:38 +0000
Message-ID: <20251120172540.2267180-49-maz@kernel.org>
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

Add a new test case that inject a Group-0 interrupt together
with a bunch of Group-1 interrupts, Ack/EOI the G1 interrupts,
and only then enable G0, expecting to get the G0 interrupt.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/arm64/vgic_irq.c | 49 ++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_irq.c b/tools/testing/selftests/kvm/arm64/vgic_irq.c
index a53ab809fe8ae..ff2c75749f5c5 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_irq.c
@@ -846,6 +846,54 @@ static void guest_code_asym_dir(struct test_args *args, int cpuid)
 	GUEST_DONE();
 }
 
+static void guest_code_group_en(struct test_args *args, int cpuid)
+{
+	uint32_t intid;
+
+	gic_init(GIC_V3, 2);
+
+	gic_set_eoi_split(0);
+	gic_set_priority_mask(CPU_PRIO_MASK);
+	/* SGI0 is G0, which is disabled */
+	gic_irq_set_group(0, 0);
+
+	/* Configure all SGIs with decreasing priority */
+	for (intid = 0; intid < MIN_PPI; intid++) {
+		gic_set_priority(intid, (intid + 1) * 8);
+		gic_irq_enable(intid);
+		gic_irq_set_pending(intid);
+	}
+
+	/* Ack and EOI all G1 interrupts */
+	for (int i = 1; i < MIN_PPI; i++) {
+		intid = wait_for_and_activate_irq();
+
+		GUEST_ASSERT(intid < MIN_PPI);
+		gic_set_eoi(intid);
+		isb();
+	}
+
+	/*
+	 * Check that SGI0 is still pending, inactive, and that we cannot
+	 * ack anything.
+	 */
+	GUEST_ASSERT(gic_irq_get_pending(0));
+	GUEST_ASSERT(!gic_irq_get_active(0));
+	GUEST_ASSERT_IAR_EMPTY();
+	GUEST_ASSERT(read_sysreg_s(SYS_ICC_IAR0_EL1) == IAR_SPURIOUS);
+
+	/* Open the G0 gates, and verify we can ack SGI0 */
+	write_sysreg_s(1, SYS_ICC_IGRPEN0_EL1);
+	isb();
+
+	do {
+		intid = read_sysreg_s(SYS_ICC_IAR0_EL1);
+	} while (intid == IAR_SPURIOUS);
+
+	GUEST_ASSERT(intid == 0);
+	GUEST_DONE();
+}
+
 static void *test_vcpu_run(void *arg)
 {
 	struct kvm_vcpu *vcpu = arg;
@@ -962,6 +1010,7 @@ int main(int argc, char **argv)
 		test_vgic(nr_irqs, true /* level */, false /* eoi_split */);
 		test_vgic(nr_irqs, true /* level */, true /* eoi_split */);
 		test_vgic_two_cpus(guest_code_asym_dir);
+		test_vgic_two_cpus(guest_code_group_en);
 	} else {
 		test_vgic(nr_irqs, level_sensitive, eoi_split);
 	}
-- 
2.47.3


