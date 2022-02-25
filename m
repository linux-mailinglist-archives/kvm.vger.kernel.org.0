Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA3E4C47EF
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 15:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241903AbiBYOx6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 09:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241892AbiBYOxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 09:53:55 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E2291768C7;
        Fri, 25 Feb 2022 06:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description;
        bh=bVNksrkyfCZkw72l2Lmf3YXG6RWMxYTYlvtghNym4IU=; b=WGyGoGg9EikNBO8/QyFF6g18md
        RNtApwTyd4RFodlgM3+Ef0ZdACVELdIgbtCQwjUfyA3+Z/nXStipnlqJN4l1oxnzbkWhe4b8obgE2
        ZH2DHAoWVJJciBIAo1bMr6mH4bFEwMyc5+vB6e/SxpMqjbgPdZNMJAd+nLoEAzm/+WlftPtMYbdK6
        IMxcG+oGSIF1kXZml25RlqHtA6TFnmOhZLwzwtqdp3qoe07+xgSYcaOEIC5IJle14buIGiKsyJ8iM
        hVtzxOYOogAyQdUsLil8SIHYdQH/+WxyIDs7rZ00h7IDbR5HIaMM0ugocGdhm10XWpPSZnzT3pAJe
        wGds7MDg==;
Received: from [2001:8b0:10b:1:85c4:81a:fb42:714d] (helo=i7.infradead.org)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nNbxy-00CzCO-L6; Fri, 25 Feb 2022 14:53:06 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nNbxx-0009Pm-SY; Fri, 25 Feb 2022 14:53:05 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Suleiman Souhlal <suleiman@google.com>,
        Anton Romanov <romanton@google.com>
Subject: [PATCH 3/3] KVM: x86: Test case for TSC scaling and offset sync
Date:   Fri, 25 Feb 2022 14:53:04 +0000
Message-Id: <20220225145304.36166-4-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220225145304.36166-1-dwmw2@infradead.org>
References: <20220225145304.36166-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/tsc_scaling_sync.c   | 119 ++++++++++++++++++
 2 files changed, 120 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 06c3a4602bcc..33b57f8c6251 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -65,6 +65,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/state_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_preemption_timer_test
 TEST_GEN_PROGS_x86_64 += x86_64/svm_vmcall_test
 TEST_GEN_PROGS_x86_64 += x86_64/svm_int_ctl_test
+TEST_GEN_PROGS_x86_64 += x86_64/tsc_scaling_sync
 TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
 TEST_GEN_PROGS_x86_64 += x86_64/userspace_io_test
 TEST_GEN_PROGS_x86_64 += x86_64/userspace_msr_exit_test
diff --git a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
new file mode 100644
index 000000000000..f0083d8cfe98
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
@@ -0,0 +1,119 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * svm_vmcall_test
+ *
+ * Copyright © 2021 Amazon.com, Inc. or its affiliates.
+ *
+ * Xen shared_info / pvclock testing
+ */
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+#include <stdint.h>
+#include <time.h>
+#include <sched.h>
+#include <signal.h>
+#include <pthread.h>
+
+#define NR_TEST_VCPUS 20
+
+static struct kvm_vm *vm;
+pthread_spinlock_t create_lock;
+
+#define TEST_TSC_KHZ    2345678UL
+#define TEST_TSC_OFFSET 200000000
+
+uint64_t tsc_sync;
+static void guest_code(void)
+{
+	uint64_t start_tsc, local_tsc, tmp;
+
+	start_tsc = rdtsc();
+	do {
+		tmp = READ_ONCE(tsc_sync);
+		local_tsc = rdtsc();
+		WRITE_ONCE(tsc_sync, local_tsc);
+		if (unlikely(local_tsc < tmp))
+			GUEST_SYNC_ARGS(0, local_tsc, tmp, 0, 0);
+
+	} while (local_tsc - start_tsc < 5000 * TEST_TSC_KHZ);
+
+	GUEST_DONE();
+}
+
+
+static void *run_vcpu(void *_cpu_nr)
+{
+	unsigned long cpu = (unsigned long)_cpu_nr;
+	unsigned long failures = 0;
+	static bool first_cpu_done;
+
+	/* The kernel is fine, but vm_vcpu_add_default() needs locking */
+	pthread_spin_lock(&create_lock);
+
+	vm_vcpu_add_default(vm, cpu, guest_code);
+
+	if (!first_cpu_done) {
+		first_cpu_done = true;
+		vcpu_set_msr(vm, cpu, MSR_IA32_TSC, TEST_TSC_OFFSET);
+	}
+
+	pthread_spin_unlock(&create_lock);
+
+	for (;;) {
+		volatile struct kvm_run *run = vcpu_state(vm, cpu);
+                struct ucall uc;
+
+                vcpu_run(vm, cpu);
+                TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+                            "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
+                            run->exit_reason,
+                            exit_reason_str(run->exit_reason));
+
+                switch (get_ucall(vm, cpu, &uc)) {
+                case UCALL_DONE:
+			goto out;
+
+                case UCALL_SYNC:
+			printf("Guest %ld sync %lx %lx %ld\n", cpu, uc.args[2], uc.args[3], uc.args[2] - uc.args[3]);
+			failures++;
+			break;
+
+                default:
+                        TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	}
+ out:
+	return (void *)failures;
+}
+
+int main(int argc, char *argv[])
+{
+        if (!kvm_check_cap(KVM_CAP_VM_TSC_CONTROL)) {
+		print_skip("KVM_CAP_VM_TSC_CONTROL not available");
+		exit(KSFT_SKIP);
+	}
+
+	vm = vm_create_default_with_vcpus(0, DEFAULT_STACK_PGS * NR_TEST_VCPUS, 0, guest_code, NULL);
+	vm_ioctl(vm, KVM_SET_TSC_KHZ, (void *) TEST_TSC_KHZ);
+
+	pthread_spin_init(&create_lock, PTHREAD_PROCESS_PRIVATE);
+	pthread_t cpu_threads[NR_TEST_VCPUS];
+	unsigned long cpu;
+	for (cpu = 0; cpu < NR_TEST_VCPUS; cpu++)
+		pthread_create(&cpu_threads[cpu], NULL, run_vcpu, (void *)cpu);
+
+	unsigned long failures = 0;
+	for (cpu = 0; cpu < NR_TEST_VCPUS; cpu++) {
+		void *this_cpu_failures;
+		pthread_join(cpu_threads[cpu], &this_cpu_failures);
+		failures += (unsigned long)this_cpu_failures;
+	}
+
+	TEST_ASSERT(!failures, "TSC sync failed");
+	pthread_spin_destroy(&create_lock);
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.33.1

