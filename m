Return-Path: <kvm+bounces-62467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA94BC44446
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 18:22:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C0163A64D8
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 17:19:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66A0D31282F;
	Sun,  9 Nov 2025 17:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e5E4TOH4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B983126AF;
	Sun,  9 Nov 2025 17:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762708601; cv=none; b=Z5qCV0L4V9gP93IwZtnVbDGCaRIUtfYtFCIF739rfzAUSV9wt8eLIUkjpa4LYDjil0YvshNhKJ3BuVVrU22WVwa/UDC397peRFwKyEbfJAD5WU/AEeoCKqBcd2wqj+G0btckYSVXWDnNp4Oj64UHNUP+UA3ukU3E25T0Yf7fBAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762708601; c=relaxed/simple;
	bh=I5APLz+GD8a1KVLow3b+A72ufSgd/FLpBeo0S8g/E18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtVrSXGwGqnPFxfM/2E4HeriPYFMpI/mDKytEXK3wHZI+CV42gLMrjJgfthjcQ3W4LVHJfjRDVmdQbDYiTmnjKjhKXKw1Yn2wIug041o2VHNq/vk/GMRqkUex51CBAFsZp6S5NrWVNnomkdKbuHi22dMwUwkXug2zw55OrdDu4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e5E4TOH4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EEB6C16AAE;
	Sun,  9 Nov 2025 17:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762708601;
	bh=I5APLz+GD8a1KVLow3b+A72ufSgd/FLpBeo0S8g/E18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e5E4TOH4WjKmNvTONUKp/Ec1MOy7OqSQ4IdnjTTFEKaYsRQ6FmiqyNMFfPFXSmEhb
	 jkosMB9W50mruh3QGqzwmKNI63m4emU6t5Qj1jRZkbwsOGXihEJ7kNZlL00gu+qtjp
	 cuTcHWTwHXZ80DbyxIBhv3xQQ2bxAn/JM1KCZOMnhU3kLGBrrh9+dyzvNns66WZSnC
	 uC5eXumgCg4km02qB5r7d+VCWGe7NG6gJx7FDZ/WAKqyYylturE1xp9qaYg1wbLhLp
	 ZAXrHJGLY9B898QiOiSb8QCltIdcRxWbn4LCa461FhMWJm/5zHA7RbmQeLt9eGU43R
	 3HoaDsaVDcOtw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vI91r-00000003exw-05Ib;
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
Subject: [PATCH v2 44/45] KVM: arm64: selftests: vgic_irq: Add Group-0 enable test
Date: Sun,  9 Nov 2025 17:16:18 +0000
Message-ID: <20251109171619.1507205-45-maz@kernel.org>
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

Add a new test case that inject a Group-0 interrupt together
with a bunch of Group-1 interrupts, Ack/EOI the G1 interrupts,
and only then enable G0, expecting to get the G0 interrupt.

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


