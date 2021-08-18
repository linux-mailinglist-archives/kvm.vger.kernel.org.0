Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 747283EFF94
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 10:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231971AbhHRIvj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 04:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbhHRIvf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 04:51:35 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D607FC0617A8
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 01:51:00 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id k21-20020a5e93150000b02905b30d664397so829647iom.0
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 01:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Wes1UjyhNb61b4GTAEq2Q+YSBftTpn4TLv1okMP9rPY=;
        b=ZK5M9W68s5nTbzUHPvmL+qtsMzhMy+l1OrZh8ZuK50KIGHllTOP/A8fEdzPdWyXyyy
         u0Gw9qiHmvT8ZiIGpnkpF7ANyq+1T5vZr1QHUUrPHl1ItdDDluF5IbIspLapmCaxmWLQ
         T/wqrv5JGdaRa3B9ETygi2KX6LfbPdeXbwPMrPkmYftPkUCc9HOmZt+cuyxkElsy3CO5
         6nxWCk0d7Ph0HqEAuIHrKl5fahxkEIusx2+WYVMdHcw298EF2j+FvvgLsbJ+JLJCnNM8
         jSHvKldxrQ9Yyt2QJturqRZ9lRIUlFcTO8vwuzF/pYU2fyha6a9CniIbkUp0jKptBa+S
         zh9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Wes1UjyhNb61b4GTAEq2Q+YSBftTpn4TLv1okMP9rPY=;
        b=JRvEJa8PMQWWtUaWoCKu439bVesGUwF28qAJHQhPhq+A6O7qeNfUMxTVBQep0v2TNd
         n6dmiSVFAy4iVKiuPaVettv9oYUd2TnjS4qay/Npl7swfxKSuwy+FGBd1iH7LQKxZALl
         1AUryw++N0Ne3pAqWFILyMPrtJqlUOpExcQ707kkS0+/ww2Dc8r6rlGIxOJ9K3zl6b6l
         y7ofJ1v458l6IOOlttDxX9FiGynIClhhfcnr0r29KIUj8HWbvEidtge3dD3VqEgSRP3N
         Y6Cd6FzWHAZa0T5kbtPYGTpQPA1h3fOigVhIkUzOSPEZ3ML14s1pAhIMYWXNrP8JJ1eg
         wu8w==
X-Gm-Message-State: AOAM530k1y/hG2RNrKR+AuuCccn+Xbrj0aRWkuhjfB3NqFhM06HJqOWV
        NWKGwVrWWvVqazLfYSll6rEnzShl+vWgifcH9ytUAtMLfD7fVGh+UKpvcD/0AyMqQfSGIDizhpK
        31HXNMb+6m3nC4J7tuSDmnOodKz5z3dQrq0NS5wozol5DhnYhE+xNTYtE1w==
X-Google-Smtp-Source: ABdhPJy1RMvdwtOyt0N5TjIFDfranB+puWXV4+WT/ytcFX8r9cHhydBVlxTN0laPL8LiyiaqHtJfcCK0/Cw=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:6605:: with SMTP id a5mr5715036ilc.15.1629276660243;
 Wed, 18 Aug 2021 01:51:00 -0700 (PDT)
Date:   Wed, 18 Aug 2021 08:50:47 +0000
In-Reply-To: <20210818085047.1005285-1-oupton@google.com>
Message-Id: <20210818085047.1005285-5-oupton@google.com>
Mime-Version: 1.0
References: <20210818085047.1005285-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 4/4] selftests: KVM: Introduce psci_cpu_on_test
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a test for aarch64 that ensures CPU resets induced by PSCI are
reflected in the target vCPU's state, even if the target is never run
again. This is a regression test for a race between vCPU migration and
PSCI.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/psci_cpu_on_test.c  | 121 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |   3 +
 4 files changed, 126 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 0709af0144c8..98053d3afbda 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 /aarch64/debug-exceptions
 /aarch64/get-reg-list
+/aarch64/psci_cpu_on_test
 /aarch64/vgic_init
 /s390x/memop
 /s390x/resets
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 5832f510a16c..5d05801ab816 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -86,6 +86,7 @@ TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
 
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
+TEST_GEN_PROGS_aarch64 += aarch64/psci_cpu_on_test
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += demand_paging_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
new file mode 100644
index 000000000000..17a6234b4b42
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
@@ -0,0 +1,121 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * psci_cpu_on_test - Test that the observable state of a vCPU targeted by the
+ * CPU_ON PSCI call matches what the caller requested.
+ *
+ * Copyright (c) 2021 Google LLC.
+ *
+ * This is a regression test for a race between KVM servicing the PSCI call and
+ * userspace reading the vCPUs registers.
+ */
+
+#define _GNU_SOURCE
+
+#include <linux/psci.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "test_util.h"
+
+#define VCPU_ID_SOURCE 0
+#define VCPU_ID_TARGET 1
+
+#define CPU_ON_ENTRY_ADDR 0xfeedf00dul
+#define CPU_ON_CONTEXT_ID 0xdeadc0deul
+
+static uint64_t psci_cpu_on(uint64_t target_cpu, uint64_t entry_addr,
+			    uint64_t context_id)
+{
+	register uint64_t x0 asm("x0") = PSCI_0_2_FN64_CPU_ON;
+	register uint64_t x1 asm("x1") = target_cpu;
+	register uint64_t x2 asm("x2") = entry_addr;
+	register uint64_t x3 asm("x3") = context_id;
+
+	asm("hvc #0"
+	    : "=r"(x0)
+	    : "r"(x0), "r"(x1), "r"(x2), "r"(x3)
+	    : "memory");
+
+	return x0;
+}
+
+static uint64_t psci_affinity_info(uint64_t target_affinity,
+				   uint64_t lowest_affinity_level)
+{
+	register uint64_t x0 asm("x0") = PSCI_0_2_FN64_AFFINITY_INFO;
+	register uint64_t x1 asm("x1") = target_affinity;
+	register uint64_t x2 asm("x2") = lowest_affinity_level;
+
+	asm("hvc #0"
+	    : "=r"(x0)
+	    : "r"(x0), "r"(x1), "r"(x2)
+	    : "memory");
+
+	return x0;
+}
+
+static void guest_main(uint64_t target_cpu)
+{
+	GUEST_ASSERT(!psci_cpu_on(target_cpu, CPU_ON_ENTRY_ADDR, CPU_ON_CONTEXT_ID));
+	uint64_t target_state;
+
+	do {
+		target_state = psci_affinity_info(target_cpu, 0);
+
+		GUEST_ASSERT((target_state == PSCI_0_2_AFFINITY_LEVEL_ON) ||
+			     (target_state == PSCI_0_2_AFFINITY_LEVEL_OFF));
+	} while (target_state != PSCI_0_2_AFFINITY_LEVEL_ON);
+
+	GUEST_DONE();
+}
+
+int main(void)
+{
+	uint64_t target_mpidr, obs_pc, obs_x0;
+	struct kvm_vcpu_init init;
+	struct kvm_vm *vm;
+	struct ucall uc;
+
+	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
+	kvm_vm_elf_load(vm, program_invocation_name);
+	ucall_init(vm, NULL);
+
+	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
+	init.features[0] |= (1 << KVM_ARM_VCPU_PSCI_0_2);
+
+	aarch64_vcpu_add_default(vm, VCPU_ID_SOURCE, &init, guest_main);
+
+	/*
+	 * make sure the target is already off when executing the test.
+	 */
+	init.features[0] |= (1 << KVM_ARM_VCPU_POWER_OFF);
+	aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_main);
+
+	get_reg(vm, VCPU_ID_TARGET, ARM64_SYS_REG(MPIDR_EL1), &target_mpidr);
+	vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
+	vcpu_run(vm, VCPU_ID_SOURCE);
+
+	switch (get_ucall(vm, VCPU_ID_SOURCE, &uc)) {
+	case UCALL_DONE:
+		break;
+	case UCALL_ABORT:
+		TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0], __FILE__,
+			  uc.args[1]);
+		break;
+	default:
+		TEST_FAIL("Unhandled ucall: %lu", uc.cmd);
+	}
+
+	get_reg(vm, VCPU_ID_TARGET, ARM64_CORE_REG(regs.pc), &obs_pc);
+	get_reg(vm, VCPU_ID_TARGET, ARM64_CORE_REG(regs.regs[0]), &obs_x0);
+
+	TEST_ASSERT(obs_pc == CPU_ON_ENTRY_ADDR,
+		    "unexpected target cpu pc: %lx (expected: %lx)",
+		    obs_pc, CPU_ON_ENTRY_ADDR);
+	TEST_ASSERT(obs_x0 == CPU_ON_CONTEXT_ID,
+		    "unexpected target context id: %lx (expected: %lx)",
+		    obs_x0, CPU_ON_CONTEXT_ID);
+
+	kvm_vm_free(vm);
+	return 0;
+}
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 27dc5c2e56b9..c0273aefa63d 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -17,6 +17,7 @@
 #define CPACR_EL1               3, 0,  1, 0, 2
 #define TCR_EL1                 3, 0,  2, 0, 2
 #define MAIR_EL1                3, 0, 10, 2, 0
+#define MPIDR_EL1               3, 0,  0, 0, 5
 #define TTBR0_EL1               3, 0,  2, 0, 0
 #define SCTLR_EL1               3, 0,  1, 0, 0
 #define VBAR_EL1                3, 0, 12, 0, 0
@@ -40,6 +41,8 @@
 			  (0xfful << (4 * 8)) | \
 			  (0xbbul << (5 * 8)))
 
+#define MPIDR_HWID_BITMASK (0xff00fffffful)
+
 static inline void get_reg(struct kvm_vm *vm, uint32_t vcpuid, uint64_t id, uint64_t *addr)
 {
 	struct kvm_one_reg reg;
-- 
2.33.0.rc1.237.g0d66db33f3-goog

