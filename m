Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B284D6FE010
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 16:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237444AbjEJOYp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 10:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237382AbjEJOYf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 10:24:35 -0400
X-Greylist: delayed 1152 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 10 May 2023 07:24:03 PDT
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22369032
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 07:24:03 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pwkQy-00GkQL-0O
        for kvm@vger.kernel.org; Wed, 10 May 2023 16:04:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=FRsovGMKe6nPh+tGQucZ3lJSR96MELmrO+xJqzY0gyc=; b=Y6/g9DhdnUSSZ47aE6yDy2q0gt
        j3U3fDJf8aYuo6NW2omK6AGIYk7K81KYZuQYqX+xqxJyhr0odHCfakd540dsjNT8xD1DYInerMOMt
        EdW8Rm4kKOZQy1D1xvWCr80ivfC5IknFVssBKBS8jyKbeq3O5jb1V8/okTY2a+3zIPEDHBDi++Dkv
        oc/svok7qkdqyPdj07uSHaXofSrSEc6QtDXqfZ0bmCLgIPsyiRQA0/BWYma8za5Cc4Bafohcd8IGC
        zS0024mHzrkz+HL4LnFnM+6D8Q5Ob95mTy8YReHkSqs4YGu6RyviMqSCZhS2N6XZP8dfOQJanf2ub
        A3wP+YNw==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pwkQx-0000r2-83; Wed, 10 May 2023 16:04:47 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pwkQm-0003HK-PU; Wed, 10 May 2023 16:04:36 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, shuah@kernel.org, Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 2/2] KVM: selftests: Add tests for vcpu_array[0] races
Date:   Wed, 10 May 2023 16:04:10 +0200
Message-Id: <20230510140410.1093987-3-mhal@rbox.co>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230510140410.1093987-1-mhal@rbox.co>
References: <20230510140410.1093987-1-mhal@rbox.co>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Exercise races between xa_insert()+xa_erase() in KVM_CREATE_VCPU vs. users
of kvm_get_vcpu() and kvm_for_each_vcpu(): KVM_IRQ_ROUTING_XEN_EVTCHN,
KVM_RESET_DIRTY_RINGS, KVM_SET_PMU_EVENT_FILTER, KVM_X86_SET_MSR_FILTER.

Warning: long time-outs.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/vcpu_array_races.c  | 198 ++++++++++++++++++
 2 files changed, 199 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/vcpu_array_races.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 7a5ff646e7e7..6c253c0bb589 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -131,6 +131,7 @@ TEST_GEN_PROGS_x86_64 += set_memory_region_test
 TEST_GEN_PROGS_x86_64 += steal_time
 TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
 TEST_GEN_PROGS_x86_64 += system_counter_offset_test
+TEST_GEN_PROGS_x86_64 += vcpu_array_races
 
 # Compiled outputs used by test targets
 TEST_GEN_PROGS_EXTENDED_x86_64 += x86_64/nx_huge_pages_test
diff --git a/tools/testing/selftests/kvm/vcpu_array_races.c b/tools/testing/selftests/kvm/vcpu_array_races.c
new file mode 100644
index 000000000000..b1a4f6fcead5
--- /dev/null
+++ b/tools/testing/selftests/kvm/vcpu_array_races.c
@@ -0,0 +1,198 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * vcpu_array_races
+ *
+ * Tests for vcpu_array[0] races between KVM_CREATE_VCPU and
+ * KVM_IRQ_ROUTING_XEN_EVTCHN, KVM_RESET_DIRTY_RINGS,
+ * KVM_SET_PMU_EVENT_FILTER, KVM_X86_SET_MSR_FILTER.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <err.h>
+#include <pthread.h>
+#include <sys/resource.h>
+
+#include "test_util.h"
+
+#include "kvm_util.h"
+#include "asm/kvm.h"
+#include "linux/kvm.h"
+
+struct rlimit rl;
+
+static struct kvm_vm *setup_vm(void)
+{
+	struct rlimit reduced;
+	struct kvm_vm *vm;
+
+	vm = vm_create_barebones();
+
+	/* Required for racing against DIRTY_RINGS. */
+	vm_enable_cap(vm, KVM_CAP_DIRTY_LOG_RING, 1 << 16);
+
+	/* Required for racing against XEN_EVTCHN. */
+	vm_ioctl(vm, KVM_CREATE_IRQCHIP, NULL);
+
+	/* Make KVM_CREATE_VCPU fail. */
+	reduced = (struct rlimit) {0, rl.rlim_max};
+	TEST_ASSERT(!setrlimit(RLIMIT_NOFILE, &reduced), "setrlimit() failed");
+
+	return vm;
+}
+
+static void vcpu_array_race(void *(*racer)(void *), int tout)
+{
+	struct kvm_vm *vm;
+	pthread_t thread;
+	time_t t;
+	int ret;
+
+	vm = setup_vm();
+
+	TEST_ASSERT(!pthread_create(&thread, NULL, racer, (void *)vm),
+		    "pthread_create() failed");
+
+	while (tout--) {
+		for (t = time(NULL); t == time(NULL);) {
+			ret = __vm_ioctl(vm, KVM_CREATE_VCPU, (void *)0);
+			TEST_ASSERT(ret == -1 && errno == EMFILE,
+				    "KVM_CREATE_VCPU ret: %d, errno: %d",
+				    ret, errno);
+		};
+		pr_info(".");
+	}
+
+	TEST_ASSERT(!pthread_cancel(thread), "pthread_cancel() failed");
+	TEST_ASSERT(!pthread_join(thread, NULL), "pthread_join() failed");
+
+	pr_info("\n");
+	kvm_vm_release(vm);
+
+	TEST_ASSERT(!setrlimit(RLIMIT_NOFILE, &rl), "setrlimit() failed");
+}
+
+static void *dirty_rings(void *arg)
+{
+	struct kvm_vm *vm = (struct kvm_vm *)arg;
+
+	while (1) {
+		vm_ioctl(vm, KVM_RESET_DIRTY_RINGS, NULL);
+		pthread_testcancel();
+	}
+
+	return NULL;
+}
+
+static void *xen_evtchn(void *arg)
+{
+	struct kvm_vm *vm = (struct kvm_vm *)arg;
+
+	struct {
+		struct kvm_irq_routing info;
+		struct kvm_irq_routing_entry entry;
+	} routing = {
+		.info = {
+			.nr = 1,
+			.flags = 0
+		},
+		.entry = {
+			.gsi = 0,
+			.type = KVM_IRQ_ROUTING_XEN_EVTCHN,
+			.flags = 0,
+			.u.xen_evtchn = {
+				.port = 0,
+				.vcpu = 0,
+				.priority = KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL
+			}
+		}
+	};
+
+	struct kvm_irq_level irq = {
+		.irq = 0,
+		.level = 1
+	};
+
+	while (1) {
+		vm_ioctl(vm, KVM_SET_GSI_ROUTING, &routing.info);
+		vm_ioctl(vm, KVM_IRQ_LINE, &irq);
+		pthread_testcancel();
+	}
+
+	return NULL;
+}
+
+static void *pmu_event_filter(void *arg)
+{
+	struct kvm_vm *vm = (struct kvm_vm *)arg;
+
+	struct kvm_pmu_event_filter filter = {
+		.action = KVM_PMU_EVENT_ALLOW,
+		.flags = 0,
+		.nevents = 0
+	};
+
+	while (1) {
+		vm_ioctl(vm, KVM_SET_PMU_EVENT_FILTER, &filter);
+		pthread_testcancel();
+	}
+
+	return NULL;
+}
+
+static void *msr_filter(void *arg)
+{
+	struct kvm_vm *vm = (struct kvm_vm *)arg;
+
+	struct kvm_msr_filter filter = {
+		.flags = 0,
+		.ranges = {{0}}
+	};
+
+	while (1) {
+		vm_ioctl(vm, KVM_X86_SET_MSR_FILTER, &filter);
+		pthread_testcancel();
+	}
+
+	return NULL;
+}
+
+int main(void)
+{
+	TEST_ASSERT(!getrlimit(RLIMIT_NOFILE, &rl), "getrlimit() failed");
+
+	pr_info("Testing vcpu_array races\n");
+
+	/*
+	 * BUG: KASAN: user-memory-access in kvm_xen_set_evtchn_fast+0xce/0x660 [kvm]
+	 * Read of size 1 at addr 00000000000011ec by task a.out/954
+	 */
+	pr_info("KVM_IRQ_ROUTING_XEN_EVTCHN\n");
+	vcpu_array_race(xen_evtchn, 5);
+
+	/*
+	 * BUG: KASAN: vmalloc-out-of-bounds in kvm_dirty_ring_reset+0x6c/0x2b0 [kvm]
+	 * Read of size 4 at addr ffffc90009150000 by task a.out/954
+	 */
+	pr_info("KVM_RESET_DIRTY_RINGS\n");
+	vcpu_array_race(dirty_rings, 15);
+
+	/*
+	 * BUG: KASAN: slab-use-after-free in rcuwait_wake_up+0x47/0x160
+	 * Read of size 8 at addr ffff888149545260 by task a.out/952
+	 */
+	pr_info("KVM_SET_PMU_EVENT_FILTER (takes 10 minutes)\n");
+	vcpu_array_race(pmu_event_filter, 10 * 60);
+
+	/*
+	 * BUG: KASAN: slab-use-after-free in kvm_make_vcpu_request+0x6b/0x120 [kvm]
+	 * Write of size 4 at addr ffff88810a15d1b4 by task a.out/955
+	 */
+	pr_info("KVM_X86_SET_MSR_FILTER (takes 15 minutes)\n");
+	vcpu_array_race(msr_filter, 15 * 60);
+
+	return 0;
+}
-- 
2.40.1

