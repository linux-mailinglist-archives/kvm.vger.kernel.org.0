Return-Path: <kvm+bounces-63964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B1DAC75B4B
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:34:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 9D0E4291AA
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9A0336D4FE;
	Thu, 20 Nov 2025 17:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NbJbToWR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C613A8D5E;
	Thu, 20 Nov 2025 17:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659568; cv=none; b=DfPL+cgkKka98L5tbAeaZQRrvccP6MJ6YdjvU/5s5rnUuXFM6zrJOOTeL6KcvWNweAsM7eG5b4agixsTSrtlokPyjD0UcmBg7mL7IRC84uj80WgrSiA5RHCE/sTMx4PDNNOvbtSLBClHaiXo4bds3thito2jlYBVInZhnlAOveU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659568; c=relaxed/simple;
	bh=aut+4Oafn6tB11/ooAwwuBkrUn/fot5spF2GxBcIs7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z3E4N8ITt0oUfYkhSmsMzteJMKOA/9UQSxUKR2AqOwABHHCzMv4zMk9PXOYb1Y1aVXr5/9EOsPByFFRksxpdOMQRDQ/V+WCiHg5ghE1W5+61AFF733sIquQh/dUvqylOOPrLCfvzPDuF80NAFdtpotANaQSXoI+nR428RTTeXdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NbJbToWR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BA0C4CEF1;
	Thu, 20 Nov 2025 17:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659568;
	bh=aut+4Oafn6tB11/ooAwwuBkrUn/fot5spF2GxBcIs7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NbJbToWRNgRwkvzsygqIiz0PcursXGfjNIDNxHKHIj5VRa+uRbwlf5HXzvqYs313Y
	 ojkw1aej+bdTAg0Gy60WiGIGglkaPV0cEJ1LkXnq/kM1tyTS4WATYWTs3phGKXAg58
	 RnxkZWY8amhU7oFnykOVV//SkNBEV1nh8kpymTQlDeToyNQE8xLKurv7UpeSElJIef
	 EmIDsqkTMbJJPhPyyVqjIkNQlclRduyL5WFHzZf3Pyf4fLa+siojOyKHtAGc/22OJs
	 tw/+wxxeyMdNl23FHTG9oRZatmySKH+kbPn/aL7p7Sz1xujJ+DMP0Deyt4TeoVFoHn
	 A2kAGjgRttuCg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Q2-00000006y6g-1wYF;
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
Subject: [PATCH v4 49/49] KVM: arm64: selftests: vgic_irq: Add timer deactivation test
Date: Thu, 20 Nov 2025 17:25:39 +0000
Message-ID: <20251120172540.2267180-50-maz@kernel.org>
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

Add a new test case that triggers the HW deactivation emulation path
when trapping ICV_DIR_EL1. This is obviously tied to the way KVM
works now, but the test follows the expected architectural behaviour.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/arm64/vgic_irq.c | 65 ++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_irq.c b/tools/testing/selftests/kvm/arm64/vgic_irq.c
index ff2c75749f5c5..9858187c7b6ea 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_irq.c
@@ -894,6 +894,70 @@ static void guest_code_group_en(struct test_args *args, int cpuid)
 	GUEST_DONE();
 }
 
+static void guest_code_timer_spi(struct test_args *args, int cpuid)
+{
+	uint32_t intid;
+	u64 val;
+
+	gic_init(GIC_V3, 2);
+
+	gic_set_eoi_split(1);
+	gic_set_priority_mask(CPU_PRIO_MASK);
+
+	/* Add a pending SPI so that KVM starts trapping DIR */
+	gic_set_priority(MIN_SPI + cpuid, IRQ_DEFAULT_PRIO);
+	gic_irq_set_pending(MIN_SPI + cpuid);
+
+	/* Configure the timer with a higher priority, make it pending */
+	gic_set_priority(27, IRQ_DEFAULT_PRIO - 8);
+
+	isb();
+	val = read_sysreg(cntvct_el0);
+	write_sysreg(val, cntv_cval_el0);
+	write_sysreg(1, cntv_ctl_el0);
+	isb();
+
+	GUEST_ASSERT(gic_irq_get_pending(27));
+
+	/* Enable both interrupts */
+	gic_irq_enable(MIN_SPI + cpuid);
+	gic_irq_enable(27);
+
+	/* The timer must fire */
+	intid = wait_for_and_activate_irq();
+	GUEST_ASSERT(intid == 27);
+
+	/* Check that we can deassert it */
+	write_sysreg(0, cntv_ctl_el0);
+	isb();
+
+	GUEST_ASSERT(!gic_irq_get_pending(27));
+
+	/*
+	 * Priority drop, deactivation -- we expect that the host
+	 * deactivation will have been effective
+	 */
+	gic_set_eoi(27);
+	gic_set_dir(27);
+
+	GUEST_ASSERT(!gic_irq_get_active(27));
+
+	/* Do it one more time */
+	isb();
+	val = read_sysreg(cntvct_el0);
+	write_sysreg(val, cntv_cval_el0);
+	write_sysreg(1, cntv_ctl_el0);
+	isb();
+
+	GUEST_ASSERT(gic_irq_get_pending(27));
+
+	/* The timer must fire again */
+	intid = wait_for_and_activate_irq();
+	GUEST_ASSERT(intid == 27);
+
+	GUEST_DONE();
+}
+
 static void *test_vcpu_run(void *arg)
 {
 	struct kvm_vcpu *vcpu = arg;
@@ -1011,6 +1075,7 @@ int main(int argc, char **argv)
 		test_vgic(nr_irqs, true /* level */, true /* eoi_split */);
 		test_vgic_two_cpus(guest_code_asym_dir);
 		test_vgic_two_cpus(guest_code_group_en);
+		test_vgic_two_cpus(guest_code_timer_spi);
 	} else {
 		test_vgic(nr_irqs, level_sensitive, eoi_split);
 	}
-- 
2.47.3


