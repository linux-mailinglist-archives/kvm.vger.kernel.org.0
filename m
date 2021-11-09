Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3860744A4E7
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 03:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241902AbhKICmV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 21:42:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241774AbhKICmT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 21:42:19 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D29C061764
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 18:39:34 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id o8-20020a170902d4c800b001424abc88f3so3433724plg.2
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 18:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4fIWsaJ7AG87Eny4Oj2wlGi/WPege+GzmpcyzUfC/nA=;
        b=sdqIJ3tNj+06Vs15yWGRFfTW5dZ5joj8Aa4fZvsD8ZJrR1TY4RD/KU3ZhZDuX8zqXS
         wimZE18x7boDFaqI2o9fz/QPYw0q4wIeA2M9biLAx6U7CTFizQZXHO+EPT18un50aKVL
         vJVLjTJjbl4u0KKT9ezFMhwF0s9VsQIR6iKTrGnzAY56A0FERJrzPZBAaeiNvQ7my23/
         Dofo88qFQnotiAM1LbZSwq0IPtpjDc2OoruW/txUm7GEGHc7XUnnG4RsNdEemQRQz4J9
         OF24uosRg+LaLXfoIgQ2nqkLyWmFTP3BeuBBwOMKLU9XbmpM9YSjvS9Ifgxny8BCGo9p
         7Ztw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4fIWsaJ7AG87Eny4Oj2wlGi/WPege+GzmpcyzUfC/nA=;
        b=8E/tWRaGhTWASsmXiCxFc4QujBL0wzxx7SekjtsJBXQDbP7rTNi/d6bvX6wUL1nOtl
         tCsxNVAyRXY+c3DihMl0V3X6HqqAS+qcBvzKpQohk2aRoyoe6KDEw5f0H3gtmiTSdEgg
         9Bs1cElK/FpeC+S944JEI2FmWdf9h0A4TzgGeAEZb3+04a3Y2HNoc6qDcSFYOd9Fn4b1
         NHOeCU/9M9vEROYyZLe7oLUEmIOAsoG2TFI3vVAyrkcrwU7PMLk6AWGwLpGKo38Z5kv1
         QNUop1Y5mfVkCXiIcaX7e+Jqwkn/pWALbXr6iTqEOzmk+2BrkPoqvLSOcBe7XouKIGcR
         42PA==
X-Gm-Message-State: AOAM530iuhpAHLWcNrhmpmGmQ2Ys7+GW3HVF5+VXVyZdWLKnZY06gwn4
        fR6f82JXDL5v42TEPnjLO4VEirpuKI9algPNie7qACD9Ros8KiT0h2NqMmwYZHhky2onC+EjqQi
        Gv6oOOAHgqcMfYVe/ieSo1sBOYs17Yff3njEyayZMGGtnbjl2uetovPi9g7dMUoM=
X-Google-Smtp-Source: ABdhPJxe7TUOGiysiHJWhoUKues6FGuvEwSAAtB2niN2S8OEli6XrUWSVccmzL0bWu42GNXILmsof4dgznU+5Q==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:4d8f:: with SMTP id
 oj15mr3295394pjb.127.1636425573621; Mon, 08 Nov 2021 18:39:33 -0800 (PST)
Date:   Mon,  8 Nov 2021 18:39:02 -0800
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Message-Id: <20211109023906.1091208-14-ricarkol@google.com>
Mime-Version: 1.0
References: <20211109023906.1091208-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 13/17] KVM: selftests: aarch64: add test_inject_fail to vgic_irq
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

Add tests for failed injections to vgic_irq. This tests that KVM can
handle bogus IRQ numbers.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_irq.c  | 122 +++++++++++++++---
 .../testing/selftests/kvm/lib/aarch64/vgic.c  |   7 +-
 2 files changed, 109 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index bc1b6fd684fc..9f1674b3a45c 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -68,21 +68,28 @@ struct kvm_inject_args {
 	uint32_t first_intid;
 	uint32_t num;
 	int level;
+	bool expect_failure;
 };
 
 /* Used on the guest side to perform the hypercall. */
 static void kvm_inject_call(kvm_inject_cmd cmd, uint32_t first_intid,
-			uint32_t num, int level);
+		uint32_t num, int level, bool expect_failure);
 
 /* Used on the host side to get the hypercall info. */
 static void kvm_inject_get_call(struct kvm_vm *vm, struct ucall *uc,
 		struct kvm_inject_args *args);
 
-#define KVM_INJECT(cmd, intid)							\
-	kvm_inject_call(cmd, intid, 1, -1 /* not used */)
+#define _KVM_INJECT_MULTI(cmd, intid, num, expect_failure)			\
+	kvm_inject_call(cmd, intid, num, -1 /* not used */, expect_failure)
 
 #define KVM_INJECT_MULTI(cmd, intid, num)					\
-	kvm_inject_call(cmd, intid, num, -1 /* not used */)
+	_KVM_INJECT_MULTI(cmd, intid, num, false)
+
+#define _KVM_INJECT(cmd, intid, expect_failure)					\
+	_KVM_INJECT_MULTI(cmd, intid, 1, expect_failure)
+
+#define KVM_INJECT(cmd, intid)							\
+	_KVM_INJECT_MULTI(cmd, intid, 1, false)
 
 struct kvm_inject_desc {
 	kvm_inject_cmd cmd;
@@ -158,13 +165,14 @@ static void guest_irq_generic_handler(bool eoi_split, bool level_sensitive)
 }
 
 static void kvm_inject_call(kvm_inject_cmd cmd, uint32_t first_intid,
-			uint32_t num, int level)
+		uint32_t num, int level, bool expect_failure)
 {
 	struct kvm_inject_args args = {
 		.cmd = cmd,
 		.first_intid = first_intid,
 		.num = num,
 		.level = level,
+		.expect_failure = expect_failure,
 	};
 	GUEST_SYNC(&args);
 }
@@ -206,7 +214,19 @@ static void reset_priorities(struct test_args *args)
 
 static void guest_set_irq_line(uint32_t intid, uint32_t level)
 {
-	kvm_inject_call(KVM_SET_IRQ_LINE, intid, 1, level);
+	kvm_inject_call(KVM_SET_IRQ_LINE, intid, 1, level, false);
+}
+
+static void test_inject_fail(struct test_args *args,
+		uint32_t intid, kvm_inject_cmd cmd)
+{
+	reset_stats();
+
+	_KVM_INJECT(cmd, intid, true);
+	/* no IRQ to handle on entry */
+
+	GUEST_ASSERT_EQ(irq_handled, 0);
+	GUEST_ASSERT_IAR_EMPTY();
 }
 
 static void guest_inject(struct test_args *args,
@@ -330,6 +350,16 @@ static void test_injection(struct test_args *args, struct kvm_inject_desc *f)
 	}
 }
 
+static void test_injection_failure(struct test_args *args,
+		struct kvm_inject_desc *f)
+{
+	uint32_t bad_intid[] = { args->nr_irqs, 1020, 1024, 1120, 5120, ~0U, };
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(bad_intid); i++)
+		test_inject_fail(args, bad_intid[i], f->cmd);
+}
+
 static void test_preemption(struct test_args *args, struct kvm_inject_desc *f)
 {
 	/*
@@ -376,11 +406,61 @@ static void guest_code(struct test_args args)
 	for_each_inject_fn(inject_fns, f) {
 		test_injection(&args, f);
 		test_preemption(&args, f);
+		test_injection_failure(&args, f);
 	}
 
 	GUEST_DONE();
 }
 
+static void kvm_irq_line_check(struct kvm_vm *vm, uint32_t intid, int level,
+			struct test_args *test_args, bool expect_failure)
+{
+	int ret;
+
+	if (!expect_failure) {
+		kvm_arm_irq_line(vm, intid, level);
+	} else {
+		/* The interface doesn't allow larger intid's. */
+		if (intid > KVM_ARM_IRQ_NUM_MASK)
+			return;
+
+		ret = _kvm_arm_irq_line(vm, intid, level);
+		TEST_ASSERT(ret != 0 && errno == EINVAL,
+				"Bad intid %i did not cause KVM_IRQ_LINE "
+				"error: rc: %i errno: %i", intid, ret, errno);
+	}
+}
+
+void kvm_irq_set_level_info_check(int gic_fd, uint32_t intid, int level,
+			bool expect_failure)
+{
+	if (!expect_failure) {
+		kvm_irq_set_level_info(gic_fd, intid, level);
+	} else {
+		int ret = _kvm_irq_set_level_info(gic_fd, intid, level);
+		/*
+		 * The kernel silently fails for invalid SPIs and SGIs (which
+		 * are not level-sensitive). It only checks for intid to not
+		 * spill over 1U << 10 (the max reserved SPI). Also, callers
+		 * are supposed to mask the intid with 0x3ff (1023).
+		 */
+		if (intid > VGIC_MAX_RESERVED)
+			TEST_ASSERT(ret != 0 && errno == EINVAL,
+				"Bad intid %i did not cause VGIC_GRP_LEVEL_INFO "
+				"error: rc: %i errno: %i", intid, ret, errno);
+		else
+			TEST_ASSERT(!ret, "KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO "
+				"for intid %i failed, rc: %i errno: %i",
+				intid, ret, errno);
+	}
+}
+
+/* handles the valid case: intid=0xffffffff num=1 */
+#define for_each_intid(first, num, tmp, i)					\
+	for ((tmp) = (i) = (first);						\
+		(tmp) < (uint64_t)(first) + (uint64_t)(num);			\
+		(tmp)++, (i)++)
+
 static void run_guest_cmd(struct kvm_vm *vm, int gic_fd,
 		struct kvm_inject_args *inject_args,
 		struct test_args *test_args)
@@ -389,28 +469,36 @@ static void run_guest_cmd(struct kvm_vm *vm, int gic_fd,
 	uint32_t intid = inject_args->first_intid;
 	uint32_t num = inject_args->num;
 	int level = inject_args->level;
+	bool expect_failure = inject_args->expect_failure;
+	uint64_t tmp;
 	uint32_t i;
 
-	assert(intid < UINT_MAX - num);
+	/* handles the valid case: intid=0xffffffff num=1 */
+	assert(intid < UINT_MAX - num || num == 1);
 
 	switch (cmd) {
 	case KVM_INJECT_EDGE_IRQ_LINE:
-		for (i = intid; i < intid + num; i++)
-			kvm_arm_irq_line(vm, i, 1);
-		for (i = intid; i < intid + num; i++)
-			kvm_arm_irq_line(vm, i, 0);
+		for_each_intid(intid, num, tmp, i)
+			kvm_irq_line_check(vm, i, 1, test_args,
+					expect_failure);
+		for_each_intid(intid, num, tmp, i)
+			kvm_irq_line_check(vm, i, 0, test_args,
+					expect_failure);
 		break;
 	case KVM_SET_IRQ_LINE:
-		for (i = intid; i < intid + num; i++)
-			kvm_arm_irq_line(vm, i, level);
+		for_each_intid(intid, num, tmp, i)
+			kvm_irq_line_check(vm, i, level, test_args,
+					expect_failure);
 		break;
 	case KVM_SET_IRQ_LINE_HIGH:
-		for (i = intid; i < intid + num; i++)
-			kvm_arm_irq_line(vm, i, 1);
+		for_each_intid(intid, num, tmp, i)
+			kvm_irq_line_check(vm, i, 1, test_args,
+					expect_failure);
 		break;
 	case KVM_SET_LEVEL_INFO_HIGH:
-		for (i = intid; i < intid + num; i++)
-			kvm_irq_set_level_info(gic_fd, i, 1);
+		for_each_intid(intid, num, tmp, i)
+			kvm_irq_set_level_info_check(gic_fd, i, 1,
+					expect_failure);
 		break;
 	default:
 		break;
diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
index 84206d7c92b4..b3a0fca0d780 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -110,12 +110,13 @@ int _kvm_arm_irq_line(struct kvm_vm *vm, uint32_t intid, int level)
 {
 	uint32_t irq = intid & KVM_ARM_IRQ_NUM_MASK;
 
+	TEST_ASSERT(!INTID_IS_SGI(intid), "KVM_IRQ_LINE's interface itself "
+		"doesn't allow injecting SGIs. There's no mask for it.");
+
 	if (INTID_IS_PPI(intid))
 		irq |= KVM_ARM_IRQ_TYPE_PPI << KVM_ARM_IRQ_TYPE_SHIFT;
-	else if (INTID_IS_SPI(intid))
-		irq |= KVM_ARM_IRQ_TYPE_SPI << KVM_ARM_IRQ_TYPE_SHIFT;
 	else
-		TEST_FAIL("KVM_IRQ_LINE can't be used with SGIs.");
+		irq |= KVM_ARM_IRQ_TYPE_SPI << KVM_ARM_IRQ_TYPE_SHIFT;
 
 	return _kvm_irq_line(vm, irq, level);
 }
-- 
2.34.0.rc0.344.g81b53c2807-goog

