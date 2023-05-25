Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2BC2711449
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 20:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241961AbjEYSgS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 14:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241589AbjEYSfq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 14:35:46 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B79E76
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 11:34:23 -0700 (PDT)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1q2Fmw-004VoD-IY; Thu, 25 May 2023 20:34:14 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=vLvuHd+LAzIp2cUd2mozqN1y+pv5oHvYy+vbJE1B37o=; b=AJtJL/eKUCoy+JWWt7oeB7BQNO
        q6NRctL9gk2GrL+mtG5db4l0XxfeJz0wJFfCfKpjWlRtNtsp82zwiKV2FXqTi/pOR6uAvoJc86okJ
        NLdB2XbVvYF04EscpfoJs5ldQjgNjy0p9MUkvoSdLKcbu1XDBRXtWhYYDcX4S+bVMBvSxbT7jY31N
        uqalR27idH7YgHZiMpUwjZfC1+g6Q0fMaG1hLy8XhD6iZLsbzj2KSi+TiSb6LpK2rmv2Rth2gPYVd
        B6BdnoRz2IgCW/cQcyAvRbv0e+KgJgB9vtiLmg/7QlVeC6wsSoy0j4hYDdg2l6VjHMRuTu15+wBfn
        gNBgKqEA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1q2Fmv-0006W2-O7; Thu, 25 May 2023 20:34:14 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1q2Fmt-00047d-0l; Thu, 25 May 2023 20:34:11 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     seanjc@google.com
Cc:     pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 3/3] KVM: selftests: Add test for race in kvm_recalculate_apic_map()
Date:   Thu, 25 May 2023 20:33:47 +0200
Message-Id: <20230525183347.2562472-4-mhal@rbox.co>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230525183347.2562472-1-mhal@rbox.co>
References: <20230525183347.2562472-1-mhal@rbox.co>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Keep switching between LAPIC_MODE_X2APIC and LAPIC_MODE_DISABLED during
APIC map construction.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/x86_64/recalc_apic_map_race.c         | 110 ++++++++++++++++++
 2 files changed, 111 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/recalc_apic_map_race.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 7a5ff646e7e7..c9b8f16fb23f 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -116,6 +116,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
 TEST_GEN_PROGS_x86_64 += x86_64/amx_test
 TEST_GEN_PROGS_x86_64 += x86_64/max_vcpuid_cap_test
 TEST_GEN_PROGS_x86_64 += x86_64/triple_fault_event_test
+TEST_GEN_PROGS_x86_64 += x86_64/recalc_apic_map_race
 TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/x86_64/recalc_apic_map_race.c b/tools/testing/selftests/kvm/x86_64/recalc_apic_map_race.c
new file mode 100644
index 000000000000..1122df858623
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/recalc_apic_map_race.c
@@ -0,0 +1,110 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * recalc_apic_map_race
+ *
+ * Test for a race condition in kvm_recalculate_apic_map().
+ */
+
+#include <sys/ioctl.h>
+#include <pthread.h>
+#include <time.h>
+
+#include "processor.h"
+#include "test_util.h"
+#include "kvm_util.h"
+#include "apic.h"
+
+#define TIMEOUT			5	/* seconds */
+#define STUFFING		100
+
+#define LAPIC_MODE_DISABLED	0
+#define LAPIC_MODE_X2APIC	(MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE)
+#define MAX_XAPIC_ID		0xff
+
+static int add_vcpu(struct kvm_vm *vm, long id)
+{
+	int vcpu = __vm_ioctl(vm, KVM_CREATE_VCPU, (void *)id);
+
+	static struct {
+		struct kvm_cpuid2 head;
+		struct kvm_cpuid_entry2 entry;
+	} cpuid = {
+		.head.nent = 1,
+		/* X86_FEATURE_X2APIC */
+		.entry = {
+			.function = 0x1,
+			.index = 0,
+			.ecx = 1UL << 21
+		}
+	};
+
+	ASSERT_EQ(ioctl(vcpu, KVM_SET_CPUID2, &cpuid.head), 0);
+
+	return vcpu;
+}
+
+static void set_apicbase(int vcpu, u64 mode)
+{
+	struct {
+		struct kvm_msrs head;
+		struct kvm_msr_entry entry;
+	} msr = {
+		.head.nmsrs = 1,
+		.entry = {
+			.index = MSR_IA32_APICBASE,
+			.data = mode
+		}
+	};
+
+	ASSERT_EQ(ioctl(vcpu, KVM_SET_MSRS, &msr.head), msr.head.nmsrs);
+}
+
+static void *race(void *arg)
+{
+	struct kvm_lapic_state state = {};
+	int vcpu = *(int *)arg;
+
+	while (1) {
+		/* Trigger kvm_recalculate_apic_map(). */
+		ioctl(vcpu, KVM_SET_LAPIC, &state);
+		pthread_testcancel();
+	}
+
+	return NULL;
+}
+
+int main(void)
+{
+	int vcpu0, vcpuN, i;
+	struct kvm_vm *vm;
+	pthread_t thread;
+	time_t t;
+
+	vm = vm_create_barebones();
+	vm_create_irqchip(vm);
+
+	vcpu0 = add_vcpu(vm, 0);
+	vcpuN = add_vcpu(vm, KVM_MAX_VCPUS);
+
+	static_assert(MAX_XAPIC_ID + STUFFING < KVM_MAX_VCPUS);
+	for (i = 0; i < STUFFING; ++i)
+		close(add_vcpu(vm, MAX_XAPIC_ID + i));
+
+	ASSERT_EQ(pthread_create(&thread, NULL, race, &vcpu0), 0);
+
+	pr_info("Testing recalc_apic_map_race...\n");
+
+	for (t = time(NULL) + TIMEOUT; time(NULL) < t;) {
+		set_apicbase(vcpuN, LAPIC_MODE_X2APIC);
+		set_apicbase(vcpuN, LAPIC_MODE_DISABLED);
+	}
+
+	ASSERT_EQ(pthread_cancel(thread), 0);
+	ASSERT_EQ(pthread_join(thread, NULL), 0);
+
+	close(vcpu0);
+	close(vcpuN);
+	kvm_vm_release(vm);
+
+	return 0;
+}
-- 
2.40.1

