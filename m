Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7CAE30FBE
	for <lists+kvm@lfdr.de>; Fri, 31 May 2019 16:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfEaOPA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 May 2019 10:15:00 -0400
Received: from mail-qt1-f202.google.com ([209.85.160.202]:50189 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfEaOPA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 May 2019 10:15:00 -0400
Received: by mail-qt1-f202.google.com with SMTP id g30so640178qtm.17
        for <kvm@vger.kernel.org>; Fri, 31 May 2019 07:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=6uTYOpeCK2kjUWkrGYjsSCd9R3SM0lfkL/jgQ7hiIFI=;
        b=Y5iymSg2aiFfNb6lb3KzaPLpBXohcKglI3ndPq4W/1CU22gGqLN2oDJZmH8Vwe308l
         xRoDMmhxaagGfacYyweS6hANG/ST0PM1cjG+DiU8GZ8baFfUUhdzXkGYuaLdcHPqmOGv
         6WLbsfVil210R8ou19Fw5ip5lZUoLcgh4ENYvHr5b0lA4kfSyWUdc6QTU6l/OqEF+dAj
         cq4IJ8Tho6C/LgTNEyygmObDWJVU8VpmSX9s38PwnnupEYnf3mkz9fnc5FPBaB2iAYZd
         GGimzbyKg36byxofm6F30fjxhHJzVK7+Rp0WOn+SxPGvIOmfWCEt7QrC3XOjPxLLhpv1
         f3bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=6uTYOpeCK2kjUWkrGYjsSCd9R3SM0lfkL/jgQ7hiIFI=;
        b=rI255rHbDaCw16ivmJ7BbhZTNWHHfgoT7y/Vj1cBaJFGkvTe+E29/4LBbx5cCNuHbs
         Ecmt/iTcKeFJZw5t6UHmFt7Cn8SxQBGR2RGwFBkYGc+Dz+9V+FonkD2xi3WIMAkZn0D8
         GHrkGYGrU0J6hj/T8DTxKEmdoEjeFTsYh6JeKXtPiAd3CTOsQ8KZ7UNxaIRjKc9IZbib
         GHHJ68mL7uxggHoSItwDGl/ChaG1rQa/jQh4a/Wg/E20UM0sCEdBW+YxrC1q7H+JXWZy
         9/yYDMOUpqr6fOmEJmHNd8Y/Fo56qlGgZ7BktKsUcPlGPFENaYOpgeA3m782IJB1XSsh
         KH9A==
X-Gm-Message-State: APjAAAXRfYQp/s4GR5CF9zIA5/ErMV/Z69a1seoLg3H69VkE/HXYBwFT
        ykOOM1kjefMUU1rnL5D80B24su18NdJ2/q8J
X-Google-Smtp-Source: APXvYqxPUt2Yk6j+crUZGcjRPdGcoJg4uw5fGsBM378DhqGlyW6VBKZ5NZKT8eHT8lp+XGYZ80+tstbccO3oKm+C
X-Received: by 2002:a37:de07:: with SMTP id h7mr8751888qkj.41.1559312098712;
 Fri, 31 May 2019 07:14:58 -0700 (PDT)
Date:   Fri, 31 May 2019 07:14:52 -0700
Message-Id: <20190531141452.158909-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
Subject: [PATCH] tests: kvm: Check for a kernel warning
From:   Aaron Lewis <aaronlewis@google.com>
To:     jmattson@google.com, pshier@google.com, marcorr@google.com,
        kvm@vger.kernel.org
Cc:     Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running with /sys/module/kvm_intel/parameters/unrestricted_guest=N,
test that a kernel warning does not occur informing us that
vcpu->mmio_needed=1.  This can happen when KVM_RUN is called after a
triple fault.
This test was made to detect a bug that was reported by Syzkaller
(https://groups.google.com/forum/#!topic/syzkaller/lHfau8E3SOE) and
fixed with commit bbeac2830f4de ("KVM: X86: Fix residual mmio emulation
request to userspace").

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/kvm_util.h  |   2 +
 .../selftests/kvm/include/x86_64/processor.h  |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  36 +++++
 .../selftests/kvm/lib/x86_64/processor.c      |  16 +++
 .../selftests/kvm/x86_64/mmio_warning_test.c  | 126 ++++++++++++++++++
 7 files changed, 184 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/mmio_warning_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index df1bf9230a74..41266af0d3dc 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -2,6 +2,7 @@
 /x86_64/evmcs_test
 /x86_64/hyperv_cpuid
 /x86_64/kvm_create_max_vcpus
+/x86_64/mmio_warning_test
 /x86_64/platform_info_test
 /x86_64/set_sregs_test
 /x86_64/smm_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 79c524395ebe..670b938f1049 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -22,6 +22,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
 TEST_GEN_PROGS_x86_64 += x86_64/smm_test
 TEST_GEN_PROGS_x86_64 += x86_64/kvm_create_max_vcpus
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
+TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
 TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
 
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 8c6b9619797d..c5c427c86598 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -137,6 +137,8 @@ struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_size,
 				 void *guest_code);
 void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code);
 
+bool vm_is_unrestricted_guest(struct kvm_vm *vm);
+
 struct kvm_userspace_memory_region *
 kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
 				 uint64_t end);
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 6063d5b2f356..af4d26de32d1 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -303,6 +303,8 @@ static inline unsigned long get_xmm(int n)
 	return 0;
 }
 
+bool is_intel_cpu(void);
+
 struct kvm_x86_state;
 struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid,
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index e9113857f44e..b93b09ad9a11 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1584,3 +1584,39 @@ void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva)
 {
 	return addr_gpa2hva(vm, addr_gva2gpa(vm, gva));
 }
+
+/*
+ * Is Unrestricted Guest
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *
+ * Output Args: None
+ *
+ * Return: True if the unrestricted guest is set to 'Y', otherwise return false.
+ *
+ * Check if the unrestricted guest flag is enabled.
+ */
+bool vm_is_unrestricted_guest(struct kvm_vm *vm)
+{
+	char val = 'N';
+	size_t count;
+	FILE *f;
+
+	if (vm == NULL) {
+		/* Ensure that the KVM vendor-specific module is loaded. */
+		f = fopen(KVM_DEV_PATH, "r");
+		TEST_ASSERT(f != NULL, "Error in opening KVM dev file: %d",
+			    errno);
+		fclose(f);
+	}
+
+	f = fopen("/sys/module/kvm_intel/parameters/unrestricted_guest", "r");
+	if (f) {
+		count = fread(&val, sizeof(char), 1, f);
+		TEST_ASSERT(count == 1, "Unable to read from param file.");
+		fclose(f);
+	}
+
+	return val == 'Y';
+}
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index dc7fae9fa424..bcc0e70e1856 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1139,3 +1139,19 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *s
 			r);
 	}
 }
+
+bool is_intel_cpu(void)
+{
+	int eax, ebx, ecx, edx;
+	const uint32_t *chunk;
+	const int leaf = 0;
+
+	__asm__ __volatile__(
+		"cpuid"
+		: /* output */ "=a"(eax), "=b"(ebx),
+		  "=c"(ecx), "=d"(edx)
+		: /* input */ "0"(leaf), "2"(0));
+
+	chunk = (const uint32_t *)("GenuineIntel");
+	return (ebx == chunk[0] && edx == chunk[1] && ecx == chunk[2]);
+}
diff --git a/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
new file mode 100644
index 000000000000..00bb97d76000
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
@@ -0,0 +1,126 @@
+/*
+ * mmio_warning_test
+ *
+ * Copyright (C) 2019, Google LLC.
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.
+ *
+ * Test that we don't get a kernel warning when we call KVM_RUN after a
+ * triple fault occurs.  To get the triple fault to occur we call KVM_RUN
+ * on a VCPU that hasn't been properly setup.
+ *
+ */
+
+#define _GNU_SOURCE
+#include <fcntl.h>
+#include <kvm_util.h>
+#include <linux/kvm.h>
+#include <processor.h>
+#include <pthread.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <test_util.h>
+#include <unistd.h>
+
+#define NTHREAD 4
+#define NPROCESS 5
+
+struct thread_context {
+	int kvmcpu;
+	struct kvm_run *run;
+};
+
+void *thr(void *arg)
+{
+	struct thread_context *tc = (struct thread_context *)arg;
+	int res;
+	int kvmcpu = tc->kvmcpu;
+	struct kvm_run *run = tc->run;
+
+	res = ioctl(kvmcpu, KVM_RUN, 0);
+	printf("ret1=%d exit_reason=%d suberror=%d\n",
+		res, run->exit_reason, run->internal.suberror);
+
+	return 0;
+}
+
+void test(void)
+{
+	int i, kvm, kvmvm, kvmcpu;
+	pthread_t th[NTHREAD];
+	struct kvm_run *run;
+	struct thread_context tc;
+
+	kvm = open("/dev/kvm", O_RDWR);
+	TEST_ASSERT(kvm != -1, "failed to open /dev/kvm");
+	kvmvm = ioctl(kvm, KVM_CREATE_VM, 0);
+	TEST_ASSERT(kvmvm != -1, "KVM_CREATE_VM failed");
+	kvmcpu = ioctl(kvmvm, KVM_CREATE_VCPU, 0);
+	TEST_ASSERT(kvmcpu != -1, "KVM_CREATE_VCPU failed");
+	run = (struct kvm_run *)mmap(0, 4096, PROT_READ|PROT_WRITE, MAP_SHARED,
+				    kvmcpu, 0);
+	tc.kvmcpu = kvmcpu;
+	tc.run = run;
+	srand(getpid());
+	for (i = 0; i < NTHREAD; i++) {
+		pthread_create(&th[i], NULL, thr, (void *)(uintptr_t)&tc);
+		usleep(rand() % 10000);
+	}
+	for (i = 0; i < NTHREAD; i++)
+		pthread_join(th[i], NULL);
+}
+
+int get_warnings_count(void)
+{
+	int warnings;
+	FILE *f;
+
+	f = popen("dmesg | grep \"WARNING:\" | wc -l", "r");
+	fscanf(f, "%d", &warnings);
+	fclose(f);
+
+	return warnings;
+}
+
+int main(void)
+{
+	int warnings_before, warnings_after;
+
+	if (!is_intel_cpu()) {
+		printf("Must be run on an Intel CPU, skipping test\n");
+		exit(KSFT_SKIP);
+	}
+
+	if (vm_is_unrestricted_guest(NULL)) {
+		printf("Unrestricted guest must be disabled, skipping test\n");
+		exit(KSFT_SKIP);
+	}
+
+	warnings_before = get_warnings_count();
+
+	for (int i = 0; i < NPROCESS; ++i) {
+		int status;
+		int pid = fork();
+
+		if (pid < 0)
+			exit(1);
+		if (pid == 0) {
+			test();
+			exit(0);
+		}
+		while (waitpid(pid, &status, __WALL) != pid)
+			;
+	}
+
+	warnings_after = get_warnings_count();
+	TEST_ASSERT(warnings_before == warnings_after,
+		   "Warnings found in kernel.  Run 'dmesg' to inspect them.");
+
+	return 0;
+}
-- 
2.22.0.rc1.311.g5d7573a151-goog

