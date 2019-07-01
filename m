Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD94267B2
	for <lists+kvm@lfdr.de>; Wed, 22 May 2019 18:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729592AbfEVQHN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 May 2019 12:07:13 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:41711 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728527AbfEVQHM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 May 2019 12:07:12 -0400
Received: by mail-pg1-f201.google.com with SMTP id d7so1931575pgc.8
        for <kvm@vger.kernel.org>; Wed, 22 May 2019 09:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Wk3se81P+G6+R69Xk9XXGxAXcg1LCgOzUsHGDKhbKF4=;
        b=oKjbHtqbkdBUyjk34rj44rXq0+hwj2+ajnBpfa4t9PAqqGeVvAPLwemaLNbrthgAwI
         uSTGXNmwoXsR3MHlHkz+FgQFeXzl+aj2tPxrQJ5V1TZ4dvxYqTw7a0HOewUg/FhaG5V4
         QNI8lflh4aV63gthUwvAYDKI0WxlzxXDomKFXOIwYoMAotywswhh6aT5ngC5kJYOCx/K
         SrvuQA53Fj+lkBBNOsAiXbU/2gxx1XUzflSlwNLHZB1Sdm/ajTT7e0RwVGicO4t95SNb
         QDQqh3FwSXdsecXFL5UtjbYjsZ6IEWHRSaiXbqPkdt4PgnqnsmHiloey09H+v1InoAVI
         QJAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Wk3se81P+G6+R69Xk9XXGxAXcg1LCgOzUsHGDKhbKF4=;
        b=n31IPGzSadgXy4HnWiUJIy5vOMEJ9GPGmnuMU0nuRanUSOPTwTH7WJjZejq4LnLJ9d
         DsOky/hCgChwUijBBUaZpiu4TcSB+SOAQWZbtZXjVN9ZlclmpIqrlxranU6KCKGe7KqK
         tvcPPuE/DCePH5jZwwTCtuAJZt2TMQJg6pIU9ryHj9N325BQmSMSN99ZRu8h1SNb+JXU
         p9xTXUKPOxHr53Xur+0mFL72DPAuKqyDKgrXnwzY44UBBkbFIbiwIrNjOo4qjZCifR5Q
         ZGonfc5CbnyEREmuCkZOic85oqpV9P0rB4u8OpxfQ3aLHLfFC/TRpfxRf0FcJs5qbFhl
         wsKg==
X-Gm-Message-State: APjAAAUhd5x1n+Yk00LMKJyhXcn2JmKp25hUlC8kagQ+WReZwoUm9Z6y
        z3oxctX/WHqm03xlDJ9+EvGOVi/v0y8hMbHL
X-Google-Smtp-Source: APXvYqycGzA9BEvVEp+QyUB3m/FbCzqmV3JEt6/PnzhT3Y7m9R0vR/r+a8h6qiYDoPuMH/KXOuty91pcRgqAahuw
X-Received: by 2002:a65:614d:: with SMTP id o13mr4537359pgv.309.1558541231069;
 Wed, 22 May 2019 09:07:11 -0700 (PDT)
Date:   Wed, 22 May 2019 09:07:07 -0700
Message-Id: <20190522160707.44830-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH] kvm: tests: Test that APICv is effective
From:   Aaron Lewis <aaronlewis@google.com>
To:     jmattson@google.com, pshier@google.com, marcorr@google.com,
        kvm@vger.kernel.org
Cc:     Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This test determines whether a read from the local APIC ID register in an L1 guest is significantly faster than a read of the local APIC current count register (implying that APICv is effective).

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   3 +-
 .../testing/selftests/kvm/include/kvm_util.h  |   2 +
 tools/testing/selftests/kvm/include/timing.h  |  53 +++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    |  41 +++++
 .../testing/selftests/kvm/x86_64/apicv_test.c | 145 ++++++++++++++++++
 6 files changed, 244 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/include/timing.h
 create mode 100644 tools/testing/selftests/kvm/x86_64/apicv_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index df1bf9230a74..25be14292031 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -1,3 +1,4 @@
+/x86_64/apicv_test
 /x86_64/cr4_cpuid_sync_test
 /x86_64/evmcs_test
 /x86_64/hyperv_cpuid
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 79c524395ebe..7f33b1d7fd56 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -10,7 +10,8 @@ LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/ucall.c lib/sparsebi
 LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c
 LIBKVM_aarch64 = lib/aarch64/processor.c
 
-TEST_GEN_PROGS_x86_64 = x86_64/platform_info_test
+TEST_GEN_PROGS_x86_64 = x86_64/apicv_test
+TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
 TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
 TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 8c6b9619797d..94ceedfeb373 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -146,6 +146,8 @@ allocate_kvm_dirty_log(struct kvm_userspace_memory_region *region);
 
 int vm_create_device(struct kvm_vm *vm, struct kvm_create_device *cd);
 
+bool vm_is_apicv_enabled(struct kvm_vm *vm);
+
 #define sync_global_to_guest(vm, g) ({				\
 	typeof(g) *_p = addr_gva2hva(vm, (vm_vaddr_t)&(g));	\
 	memcpy(_p, &(g), sizeof(g));				\
diff --git a/tools/testing/selftests/kvm/include/timing.h b/tools/testing/selftests/kvm/include/timing.h
new file mode 100644
index 000000000000..f97d5f4427dc
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/timing.h
@@ -0,0 +1,53 @@
+/*
+ * tools/testing/selftests/kvm/include/timing.h
+ *
+ * Copyright (C) 2019, Google LLC.
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.
+ *
+ */
+
+#ifndef SELFTEST_TIMING_H
+#define SELFTEST_TIMING_H
+
+/*
+ * Time the execution of 'fn' over the indicated number of iterations, and
+ * return the minimum (in TSC cycles).
+ */
+static inline u64 min_time(unsigned int iter, void (*fn)(void *arg), void *arg)
+{
+	u64 min = ~0ull;
+	unsigned int i;
+
+	for (i = 0; i < iter; i++) {
+		u64 cycles;
+		u64 start;
+
+		/*
+		 * Ensure all prior reads and writes are complete before
+		 * calling rdtsc().  This is necessary so the loads and stores
+		 * that are in flight prior to the first call to rdtsc don't
+		 * cause the memory barriers to stall after the callback is
+		 * called.
+		 * Note: Only a write barrier is needed because rdtsc() calls
+		 * a read barrier before reading the tsc.
+		 */
+		asm volatile("sfence");
+		start = rdtsc();
+
+		fn(arg);
+
+		/*
+		 * Ensure all reads and writes from the callback are complete
+		 * before calling rdtsc().  Again, rdtsc() will call a read
+		 * barrier, so just a write barrier is needed.
+		 */
+		asm volatile("sfence");
+		cycles = rdtsc() - start;
+		if (cycles < min)
+			min = cycles;
+	}
+	return min;
+}
+
+#endif /* SELFTEST_TIMING_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index e9113857f44e..b52e2201ab1c 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1584,3 +1584,44 @@ void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva)
 {
 	return addr_gpa2hva(vm, addr_gva2gpa(vm, gva));
 }
+
+/*
+ * Is APICv Enabled
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *
+ * Output Args: None
+ *
+ * Return: True if the VM has APICv enabled, False if it is not enabled.
+ *
+ * Check if APICv is enabled for this vm.
+ */
+bool vm_is_apicv_enabled(struct kvm_vm *vm)
+{
+	char val;
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
+	f = fopen("/sys/module/kvm_intel/parameters/enable_apicv", "r");
+	if (f == NULL)
+		f = fopen("/sys/module/kvm_intel/parameters/enable_apicv", "r");
+
+	TEST_ASSERT(f != NULL, "Error in opening EPT/NPT param file: %d",
+		    errno);
+
+	count = fread(&val, sizeof(char), 1, f);
+	TEST_ASSERT(count == 1, "Unable to read from EPT param file.");
+
+	fclose(f);
+
+	return val == 'Y';
+}
diff --git a/tools/testing/selftests/kvm/x86_64/apicv_test.c b/tools/testing/selftests/kvm/x86_64/apicv_test.c
new file mode 100644
index 000000000000..d31f00db9ce6
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/apicv_test.c
@@ -0,0 +1,145 @@
+/*
+ * APICv Effectiveness Test --
+ *
+ *  This test determines whether a read from the local APIC ID register in an L1
+ *  guest is significantly faster than a read of the local APIC current count
+ *  register (implying that APICv is effective).
+ */
+
+#define _GNU_SOURCE
+#include <fcntl.h>
+#include <sched.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/stat.h>
+#include <test_util.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "timing.h"
+#include "vmx.h"
+
+#define VCPU_ID		5
+#define APIC_ADDR	0xfee00000ULL
+#define APIC_ID		0x20
+#define APIC_TMCCT	0x390
+#define ITERATIONS	100
+
+#define PORT_INPUT	0
+#define PORT_OUTPUT	1
+
+#define SPEEDUP		3
+
+static inline uint64_t l1_vmexit(uint16_t port, uint64_t time)
+{
+	uint64_t input;
+
+	__asm__ __volatile__("in %%dx, %%al"
+			     :	"=S"(input) : "d"(port), "D"(time) : "eax");
+	return input;
+}
+
+void read_apic_register(void *offset)
+{
+	*(volatile uint32_t *)(APIC_ADDR + (uint64_t)offset);
+}
+
+void measure_apic_read(void)
+{
+	uint64_t offset;
+	uint64_t min;
+
+	offset = l1_vmexit(PORT_INPUT, 0);
+	min = min_time(ITERATIONS, read_apic_register, (void *)offset);
+	l1_vmexit(PORT_OUTPUT, min);
+}
+
+void guest_l1_entry(void)
+{
+	do {
+		measure_apic_read();
+	} while (true);
+}
+
+void verify_io_exit(struct kvm_vm *vm, uint16_t port)
+{
+	unsigned int exit_reason;
+	struct kvm_run *state;
+
+	state = vcpu_state(vm, VCPU_ID);
+	exit_reason = state->exit_reason;
+	TEST_ASSERT(
+		exit_reason == KVM_EXIT_IO,
+		"Unexpected exit reason: %u (%s)\n",
+		exit_reason, exit_reason_str(exit_reason));
+	TEST_ASSERT(
+		state->io.port == port,
+		"Unexpected I/O port: %u\n",
+		state->io.port);
+}
+
+uint64_t query_apic_read(struct kvm_vm *vm, uint64_t offset)
+{
+	struct kvm_regs regs;
+
+	vcpu_run(vm, VCPU_ID);
+	verify_io_exit(vm, PORT_INPUT);
+	vcpu_regs_get(vm, VCPU_ID, &regs);
+	regs.rsi = offset;
+	vcpu_regs_set(vm, VCPU_ID, &regs);
+
+	vcpu_run(vm, VCPU_ID);
+	verify_io_exit(vm, PORT_OUTPUT);
+	vcpu_regs_get(vm, VCPU_ID, &regs);
+
+	printf("APIC offset %#lx reads take %llu cycles\n", offset, regs.rdi);
+
+	return regs.rdi;
+}
+
+bool check_apicv(struct kvm_vm *vm)
+{
+	uint64_t fast = query_apic_read(vm, APIC_ID);
+	uint64_t slow = query_apic_read(vm, APIC_TMCCT);
+
+	return fast * SPEEDUP < slow;
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vm *vm;
+	struct kvm_cpuid2 *cpuid = kvm_get_supported_cpuid();
+	struct kvm_cpuid_entry2 *entry = kvm_get_supported_cpuid_entry(0x1);
+
+	setbuf(stdout, NULL);
+
+	vm = vm_create_default(VCPU_ID, 0, guest_l1_entry);
+
+	if(!vm_is_apicv_enabled(vm)) {
+		printf("APICv not available, skipping test\n");
+		exit(KSFT_SKIP);
+	}
+
+	virt_pg_map(vm, APIC_ADDR, APIC_ADDR, 0);
+
+	/* Disable CPUID.01H:ECX.VMX */
+	entry->ecx |= CPUID_VMX;
+	vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+
+	TEST_ASSERT(check_apicv(vm),
+		    "APICv is ineffective without CPUID.01H:ECX.VMX\n");
+
+	/* Enable CPUID.01H:ECX.VMX */
+	entry->ecx &= ~CPUID_VMX;
+	vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+
+	printf("nVMX enabled.\n");
+	TEST_ASSERT(check_apicv(vm),
+		    "APICv is ineffective with CPUID.01H:ECX.VMX\n");
+
+	kvm_vm_free(vm);
+	free(cpuid);
+
+	return 0;
+}
-- 
2.21.0.1020.gf2820cf01a-goog

