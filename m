Return-Path: <kvm+bounces-62468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3585EC4442E
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 18:20:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B76194EAC1D
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 17:19:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C631F31283D;
	Sun,  9 Nov 2025 17:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GOds3juv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9610A3126D3;
	Sun,  9 Nov 2025 17:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762708601; cv=none; b=HUKgOPNGbET59YXYg/cjWqqZNb+GojlkYphdRAfy2HuC3E3jNBvN418wpgh0gfmAtpqkpL4Cyym6cWNLvy/hmHQDE5Kg0vhktnDcGm87S7k3gxeCLwsjCCgILB5kHImJq74AuVt0Y5OHKMt9iPIcUrFr+sGsz4eqTqs08uHwBn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762708601; c=relaxed/simple;
	bh=Ztm8vFx9rv1rEKhzOuokkcS00uXfV2CgOqJXj5pGoyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3Yv+KHIm78E8QmC6EnMgnNam2JVCZqVn5VuYccBTGkO6UXXtENuwTHAzX6xtH0QNRYjD9R+B1v/KvER60lXGof+PaIyU/r1KAZ4gSPQcEZWKq91RjjBQoqhj7Ly8A8pnC/TKu3OzwWhUfieiq+MzPGIbuQfzdmJ7uoQY4uasHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GOds3juv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747DCC19421;
	Sun,  9 Nov 2025 17:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762708601;
	bh=Ztm8vFx9rv1rEKhzOuokkcS00uXfV2CgOqJXj5pGoyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GOds3juvKRkaaweP1L1mc7M0J33F+wC+TgTOw9t8D+kWZCUR+PJ6VcHpfp0wH8iAM
	 pumfEGwk2S4RS75IUTxxGtKUiTRTJBcWevuKDnNod8r4c/bar6Blv/ErIjZKVdL67Z
	 Lv59BigHiKtPm3HMV9/g/htE/b2gF6ZQC+zoUBIbsXUZ0a4vIEzfC1KEQoewTTKPHO
	 rn/nr8fKYBjw73WS+xF86uFonlpJGw0nzTeim4HTF3lXA1Y+LlrxYwuRYErrxm2uMb
	 prUubEA9OvJdknakpRzeUpyervRHHV7ICNwei/UrDoCUnqzj59tnbHyr04Zq9uK9OG
	 AHKLmKDzdOgRw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vI91r-00000003exw-13dv;
	Sun, 09 Nov 2025 17:16:39 +0000
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
Subject: [PATCH v2 45/45] KVM: arm64: selftests: vgic_irq: Add timer deactivation test
Date: Sun,  9 Nov 2025 17:16:19 +0000
Message-ID: <20251109171619.1507205-46-maz@kernel.org>
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

Add a new test case that triggers the HW deactivation emulation path
when trapping ICV_DIR_EL1. This is obviously tied to the way KVM
works now, but the test follows the expected architectural behaviour.

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


