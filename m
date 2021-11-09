Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415E344A4E3
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 03:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241697AbhKICmS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 21:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241788AbhKICmO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 21:42:14 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B416AC061766
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 18:39:29 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id n13-20020a170902d2cd00b0014228ffc40dso6592104plc.4
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 18:39:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LozXdBeHm1wVJM1zXtUi3Myaa0mOvHQ8f6t6MIK9jqk=;
        b=c2JYScEky9XAjrfUtUpSg0+Ds/y5sqhLsY4MTjk1ZRyQ5jTN+xr18kK5ALfBIkdJGl
         BeTxqMZXPXkFlv4W77QPonZYelqiEfHTUeYu01+VAXEyh4srKCMpNR+w2H9ZSisj6hju
         7jgBEmL+2HSlqRH1z1zJQ/QAV2sdf8sCUkO+o8EsS4uAsJECUV0vi3YBRAl3UAKJH0EA
         HBq6OmaB1EQtEJAPCRn1DJ4qj1NMNQsGDGLtfDzdCihW10n5RBHQl7TDLI5YCYIwKtq3
         O2rmB73ClJb40oSoNLany273Jisyaex1z4lIO4QMIMxDWU4lmLzAfD71VVa6calQR9Z3
         3BMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LozXdBeHm1wVJM1zXtUi3Myaa0mOvHQ8f6t6MIK9jqk=;
        b=COPPFlhVTkiEGlrd7cEfmeMhCsR4ikxy+kDqAi0YkhA5NQ8pscPeMeORTjYXhaTYV1
         h+abLhtHDEvYX5j5Gcgj9L1TLGeAqhu4iOE3cQutI99VczcnKy4rdhu5GjLiZ5/6DcHr
         6AatFBD8BQ6XE+7qJw11MNKoSmKSEr02C8/8bCuUm5QD57/EmSiClmkKYZY5F7aYtflA
         b7Cgv2jTh2740c/HoFiTUlWNhDOu9PzLhf8ontV+X8oUQbd0UrbxqtrJ2icQjVUtuHVS
         yiBZUzA/LY9D0uYy+osD5KJ2wdwc3lgILfaSDZbywpkhaYmf/+CPpuCJhUGA0Np9AG/j
         Iueg==
X-Gm-Message-State: AOAM5331WuMY+ZcX6Ms4mVLh47JBFdgB8Qbp9T/klUvo65lxWkUyZBmz
        e52aOq25CDud6fnkebwqyKUMX1a+qeIamH9DlVkukUppbC9AHQI1Ka3LjpMAmkdMpsJKrw1M85S
        uPkSR1xp5toUnwuRpnzcs9cTXweRCg1H8rRpkS10mRMKURQhNBJEq8sZlKizrmVQ=
X-Google-Smtp-Source: ABdhPJyd3cmlccdsr0jYFtsQ/AxEtNcZxg4ERBnu9kTbLsShBB+WnJdZ2O9U6SlWXTQFEJZRY28W/+iC5/C0mQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:aa7:8755:0:b0:494:67a6:1c84 with SMTP id
 g21-20020aa78755000000b0049467a61c84mr37627084pfo.26.1636425569082; Mon, 08
 Nov 2021 18:39:29 -0800 (PST)
Date:   Mon,  8 Nov 2021 18:38:59 -0800
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Message-Id: <20211109023906.1091208-11-ricarkol@google.com>
Mime-Version: 1.0
References: <20211109023906.1091208-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 10/17] KVM: selftests: aarch64: add preemption tests in vgic_irq
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add tests for IRQ preemption (having more than one activated IRQ at the
same time).  This test injects multiple concurrent IRQs and handles them
without handling the actual exceptions.  This is done by masking
interrupts for the whole test.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_irq.c  | 91 ++++++++++++++++++-
 1 file changed, 90 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index 3e18fa224280..b9080aa75a14 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -41,6 +41,7 @@ struct test_args {
  */
 #define KVM_NUM_PRIOS		32
 #define KVM_PRIO_SHIFT		3 /* steps of 8 = 1 << 3 */
+#define KVM_PRIO_STEPS		(1 << KVM_PRIO_SHIFT) /* 8 */
 #define LOWEST_PRIO		(KVM_NUM_PRIOS - 1)
 #define CPU_PRIO_MASK		(LOWEST_PRIO << KVM_PRIO_SHIFT)	/* 0xf8 */
 #define IRQ_DEFAULT_PRIO	(LOWEST_PRIO - 1)
@@ -212,6 +213,74 @@ static void guest_inject(struct test_args *args,
 	reset_priorities(args);
 }
 
+/*
+ * Polls the IAR until it's not a spurious interrupt.
+ *
+ * This function should only be used in test_inject_preemption (with IRQs
+ * masked).
+ */
+static uint32_t wait_for_and_activate_irq(void)
+{
+	uint32_t intid;
+
+	do {
+		asm volatile("wfi" : : : "memory");
+		intid = gic_get_and_ack_irq();
+	} while (intid == IAR_SPURIOUS);
+
+	return intid;
+}
+
+/*
+ * Inject multiple concurrent IRQs (num IRQs starting at first_intid) and
+ * handle them without handling the actual exceptions.  This is done by masking
+ * interrupts for the whole test.
+ */
+static void test_inject_preemption(struct test_args *args,
+		uint32_t first_intid, int num,
+		kvm_inject_cmd cmd)
+{
+	uint32_t intid, prio, step = KVM_PRIO_STEPS;
+	int i;
+
+	/* Set the priorities of the first (KVM_NUM_PRIOS - 1) IRQs
+	 * in descending order, so intid+1 can preempt intid.
+	 */
+	for (i = 0, prio = (num - 1) * step; i < num; i++, prio -= step) {
+		GUEST_ASSERT(prio >= 0);
+		intid = i + first_intid;
+		gic_set_priority(intid, prio);
+	}
+
+	local_irq_disable();
+
+	for (i = 0; i < num; i++) {
+		uint32_t tmp;
+		intid = i + first_intid;
+		kvm_inject_call(cmd, intid, 1);
+		/* Each successive IRQ will preempt the previous one. */
+		tmp = wait_for_and_activate_irq();
+		GUEST_ASSERT_EQ(tmp, intid);
+	}
+
+	/* finish handling the IRQs starting with the highest priority one. */
+	for (i = 0; i < num; i++) {
+		intid = num - i - 1 + first_intid;
+		gic_set_eoi(intid);
+		if (args->eoi_split)
+			gic_set_dir(intid);
+	}
+
+	local_irq_enable();
+
+	for (i = 0; i < num; i++)
+		GUEST_ASSERT(!gic_irq_get_active(i + first_intid));
+	GUEST_ASSERT_EQ(gic_read_ap1r0(), 0);
+	GUEST_ASSERT_IAR_EMPTY();
+
+	reset_priorities(args);
+}
+
 static void test_injection(struct test_args *args, struct kvm_inject_desc *f)
 {
 	uint32_t nr_irqs = args->nr_irqs;
@@ -231,6 +300,24 @@ static void test_injection(struct test_args *args, struct kvm_inject_desc *f)
 	}
 }
 
+static void test_preemption(struct test_args *args, struct kvm_inject_desc *f)
+{
+	/*
+	 * Test up to 4 levels of preemption. The reason is that KVM doesn't
+	 * currently implement the ability to have more than the number-of-LRs
+	 * number of concurrently active IRQs. The number of LRs implemented is
+	 * IMPLEMENTATION DEFINED, however, it seems that most implement 4.
+	 */
+	if (f->sgi)
+		test_inject_preemption(args, MIN_SGI, 4, f->cmd);
+
+	if (f->ppi)
+		test_inject_preemption(args, MIN_PPI, 4, f->cmd);
+
+	if (f->spi)
+		test_inject_preemption(args, MIN_SPI, 4, f->cmd);
+}
+
 static void guest_code(struct test_args args)
 {
 	uint32_t i, nr_irqs = args.nr_irqs;
@@ -249,8 +336,10 @@ static void guest_code(struct test_args args)
 	local_irq_enable();
 
 	/* Start the tests. */
-	for_each_inject_fn(inject_edge_fns, f)
+	for_each_inject_fn(inject_edge_fns, f) {
 		test_injection(&args, f);
+		test_preemption(&args, f);
+	}
 
 	GUEST_DONE();
 }
-- 
2.34.0.rc0.344.g81b53c2807-goog

