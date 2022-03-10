Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 780964D4F9B
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 17:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbiCJQre (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 11:47:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244005AbiCJQr0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 11:47:26 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179A7192E2D
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 08:46:06 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id y3-20020a1709029b8300b0014c8bcb70a1so2992689plp.3
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 08:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fbxWpZEa6eY/UYN831/It4hPjXSSXrSY82CYIn9xG4k=;
        b=Va2QgQuftz6KeYn+NlohEVeWMRJNDL0ugIP1b+C9U3Y8BFpEEHWDfng5rES6HHZLOX
         vMH7Egye4Q+YUkyTrSZWRSrW7mxmJrFdlVfyWeiUgDEa41fqBHapehDrsTlJCG5ODnai
         EPQ04Bw60k1WvIyDg2ws80xj5/Ly0/4qnrFuXgx+Zre/9eqncifndEPIJj/8xKi0nBOg
         E1dlQr+uuFm4cRzpo49sDK6OoP/1CVNlVSV0LEBMJkZQD9ZbVedzSAA/YHkBEYHC5FUA
         JLAwbQsquD47DVpGdhkP34ch3hQ4bTVO3jkZyiNGoPrPgrsJpSH5joz2+mtrnOcmA1CO
         beHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fbxWpZEa6eY/UYN831/It4hPjXSSXrSY82CYIn9xG4k=;
        b=civOQoOBNHeqOHo9AmLQZehMIjgzPi4X5X+Oi9AX4DXe0Nzt4iIVBMMatzmJdc6tJP
         gO406iI1zdpeIIL4ORwOu3b/I6iP7I3dPpUMaHRcms/UAIQNpF93aUxNvIcqF+3SQNbw
         JKpIKGOiAfh+vPBRYKQD2Dvnx3eydW8z8Z9R3rgA1/MJ1AkDmc5oB1o3mCtGlCjF1NHh
         exusD8uF7TRFfi6KrlOVsRqVEwCaXFssCo0zYTNmHrf6D/G1ipfnPfEYHwMK0t/cJjce
         j28/J3XcawrNGNC/kBeVVHgbiOGvkGnSi88or3v7SvYA+kCn18gmaU2m5jbgo4y4mUc1
         L8Ag==
X-Gm-Message-State: AOAM533yckm8fm9vGsqKm6ZqfpS34QBiiJ+OVkHzGiG1bpUfOI6bapqL
        XKOhEqegvse+AADL0+t6arRaUSDSPwI3
X-Google-Smtp-Source: ABdhPJxNF8wOqc7sqaSmZcCBX9Tn2IXOfjzmrlDs/E6jF56PwaHYESssAe/kFm9XHLtJR98dk1VRmGRxquDe
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:2d58:733f:1853:8e86])
 (user=bgardon job=sendgmr) by 2002:a63:715:0:b0:380:cf1d:6765 with SMTP id
 21-20020a630715000000b00380cf1d6765mr4732500pgh.577.1646930765503; Thu, 10
 Mar 2022 08:46:05 -0800 (PST)
Date:   Thu, 10 Mar 2022 08:45:26 -0800
In-Reply-To: <20220310164532.1821490-1-bgardon@google.com>
Message-Id: <20220310164532.1821490-8-bgardon@google.com>
Mime-Version: 1.0
References: <20220310164532.1821490-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH 07/13] selftests: KVM: Add NX huge pages test
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There's currently no test coverage of NX hugepages in KVM selftests, so
add a basic test to ensure that the feature works as intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   3 +-
 .../kvm/lib/x86_64/nx_huge_pages_guest.S      |  45 +++++++
 .../selftests/kvm/x86_64/nx_huge_pages_test.c | 122 ++++++++++++++++++
 .../kvm/x86_64/nx_huge_pages_test.sh          |  25 ++++
 4 files changed, 194 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/nx_huge_pages_guest.S
 create mode 100644 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
 create mode 100755 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 04099f453b59..6ee30c0df323 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -38,7 +38,7 @@ ifeq ($(ARCH),riscv)
 endif
 
 LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/rbtree.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c lib/perf_test_util.c
-LIBKVM_x86_64 = lib/x86_64/apic.c lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
+LIBKVM_x86_64 = lib/x86_64/apic.c lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S lib/x86_64/nx_huge_pages_guest.S
 LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c lib/aarch64/gic.c lib/aarch64/gic_v3.c lib/aarch64/vgic.c
 LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
 LIBKVM_riscv = lib/riscv/processor.c lib/riscv/ucall.c
@@ -56,6 +56,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/kvm_clock_test
 TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
 TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
 TEST_GEN_PROGS_x86_64 += x86_64/mmu_role_test
+TEST_GEN_PROGS_x86_64 += x86_64/nx_huge_pages_test
 TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
 TEST_GEN_PROGS_x86_64 += x86_64/pmu_event_filter_test
 TEST_GEN_PROGS_x86_64 += x86_64/set_boot_cpu_id
diff --git a/tools/testing/selftests/kvm/lib/x86_64/nx_huge_pages_guest.S b/tools/testing/selftests/kvm/lib/x86_64/nx_huge_pages_guest.S
new file mode 100644
index 000000000000..09c66b9562a3
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/x86_64/nx_huge_pages_guest.S
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * tools/testing/selftests/kvm/nx_huge_page_guest.S
+ *
+ * Copyright (C) 2022, Google LLC.
+ */
+
+.include "kvm_util.h"
+
+#define HPAGE_SIZE 	(2*1024*1024)
+#define PORT_SUCCESS	0x70
+
+.global guest_code0
+.global guest_code1
+
+.align HPAGE_SIZE
+exit_vm:
+	mov    $0x1,%edi
+	mov    $0x2,%esi
+	mov    a_string,%edx
+	mov    $0x1,%ecx
+	xor    %eax,%eax
+	jmp    ucall
+
+
+guest_code0:
+	mov data1, %eax
+	mov data2, %eax
+	jmp exit_vm
+
+.align HPAGE_SIZE
+guest_code1:
+	mov data1, %eax
+	mov data2, %eax
+	jmp exit_vm
+data1:
+.quad	0
+
+.align HPAGE_SIZE
+data2:
+.quad	0
+a_string:
+.string "why does the ucall function take a string argument?"
+
+
diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
new file mode 100644
index 000000000000..5cbcc777d0ab
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
@@ -0,0 +1,122 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * tools/testing/selftests/kvm/nx_huge_page_test.c
+ *
+ * Usage: to be run via nx_huge_page_test.sh, which does the necessary
+ * environment setup and teardown
+ *
+ * Copyright (C) 2022, Google LLC.
+ */
+
+#define _GNU_SOURCE
+
+#include <stdint.h>
+#include <fcntl.h>
+
+#include <test_util.h>
+#include "kvm_util.h"
+
+#define HPAGE_SLOT		MEMSLOT(10)
+#define HPAGE_PADDR_START       (10*1024*1024)
+#define HPAGE_SLOT_NPAGES	(100*1024*1024/4096)
+
+/* Defined in nx_huge_page_guest.S */
+void guest_code0(void);
+void guest_code1(void);
+
+static void run_guest_code(struct kvm_vm *vm, void (*guest_code)(void))
+{
+	struct kvm_regs regs;
+
+	vcpu_regs_get(vm, 0, &regs);
+	regs.rip = (uint64_t)guest_code;
+	vcpu_regs_set(vm, 0, &regs);
+	vcpu_run(vm, 0);
+}
+
+static void check_2m_page_count(struct kvm_vm *vm, int expected_pages_2m)
+{
+	int actual_pages_2m;
+
+	actual_pages_2m = vm_get_single_stat(vm, "pages_2m");
+
+	TEST_ASSERT(actual_pages_2m == expected_pages_2m,
+		    "Unexpected 2m page count. Expected %d, got %d",
+		    expected_pages_2m, actual_pages_2m);
+}
+
+static void check_split_count(struct kvm_vm *vm, int expected_splits)
+{
+	int actual_splits;
+
+	actual_splits = vm_get_single_stat(vm, "nx_lpage_splits");
+
+	TEST_ASSERT(actual_splits == expected_splits,
+		    "Unexpected nx lpage split count. Expected %d, got %d",
+		    expected_splits, actual_splits);
+}
+
+int main(int argc, char **argv)
+{
+	struct kvm_vm *vm;
+
+	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
+
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_HUGETLB,
+				    HPAGE_PADDR_START, HPAGE_SLOT,
+				    HPAGE_SLOT_NPAGES, 0);
+
+	kvm_vm_elf_load(vm, program_invocation_name, HPAGE_SLOT);
+
+	vm_vcpu_add_default(vm, 0, guest_code0);
+
+	check_2m_page_count(vm, 0);
+	check_split_count(vm, 0);
+
+	/*
+	 * Running guest_code0 will access data1 and data2.
+	 * This should result in part of the huge page containing guest_code0,
+	 * and part of the hugepage containing the ucall function being mapped
+	 * at 4K. The huge pages containing data1 and data2 will be mapped
+	 * at 2M.
+	 */
+	run_guest_code(vm, guest_code0);
+	check_2m_page_count(vm, 2);
+	check_split_count(vm, 2);
+
+	/*
+	 * guest_code1 is in the same huge page as data1, so it will cause
+	 * that huge page to be remapped at 4k.
+	 */
+	run_guest_code(vm, guest_code1);
+	check_2m_page_count(vm, 1);
+	check_split_count(vm, 3);
+
+	/* Run guest_code0 again to check that is has no effect. */
+	run_guest_code(vm, guest_code0);
+	check_2m_page_count(vm, 1);
+	check_split_count(vm, 3);
+
+	/* Give recovery thread time to run */
+	sleep(3);
+	check_2m_page_count(vm, 1);
+	check_split_count(vm, 0);
+
+	/*
+	 * The split 2M pages should have been reclaimed, so run guest_code0
+	 * again to check that pages are mapped at 2M again.
+	 */
+	run_guest_code(vm, guest_code0);
+	check_2m_page_count(vm, 2);
+	check_split_count(vm, 2);
+
+	/* Pages are once again split from running guest_code1. */
+	run_guest_code(vm, guest_code1);
+	check_2m_page_count(vm, 1);
+	check_split_count(vm, 3);
+
+	kvm_vm_free(vm);
+
+	return 0;
+}
+
diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
new file mode 100755
index 000000000000..a5f946fb0626
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
@@ -0,0 +1,25 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0-only */
+
+# tools/testing/selftests/kvm/nx_huge_page_test.sh
+# Copyright (C) 2022, Google LLC.
+
+NX_HUGE_PAGES=$(cat /sys/module/kvm/parameters/nx_huge_pages)
+NX_HUGE_PAGES_RECOVERY_RATIO=$(cat /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio)
+NX_HUGE_PAGES_RECOVERY_PERIOD=$(cat /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms)
+HUGE_PAGES=$(cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages)
+
+echo 1 > /sys/module/kvm/parameters/nx_huge_pages
+echo 1 > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
+echo 2 > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
+echo 200 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
+
+./nx_huge_pages_test
+RET=$?
+
+echo $NX_HUGE_PAGES > /sys/module/kvm/parameters/nx_huge_pages
+echo $NX_HUGE_PAGES_RECOVERY_RATIO > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
+echo $NX_HUGE_PAGES_RECOVERY_PERIOD > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
+echo $HUGE_PAGES > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
+
+exit $RET
-- 
2.35.1.616.g0bdcbb4464-goog

