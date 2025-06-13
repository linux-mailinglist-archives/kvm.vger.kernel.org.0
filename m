Return-Path: <kvm+bounces-49520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 04CBBAD9634
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 22:24:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B9113BAD09
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 20:24:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4A9E25BF1D;
	Fri, 13 Jun 2025 20:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KUWAQV2I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f73.google.com (mail-vs1-f73.google.com [209.85.217.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAAC253F03
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 20:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749846204; cv=none; b=E03zWUzC/bM3yTws0wB9DtrgMyE79Zwf4kLR8mKtNID4vGSyHJmiFSRYMS3E2om6wj+FxF3TTaDf5KLycCv4kbUH7x5wpU6enQmQdjmvu8LnoqrEMka0Q0RHf2F2uvTf2YuLkTN2YiUb/YO11sN3I4x7k2jchsUi6KF7UItJzE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749846204; c=relaxed/simple;
	bh=59Iy6rW99a1WmCSYZewQQsUiKBtGxHTFVJJ6e22aVhg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eekPN6O0Ga8mMzNpvtOIpuccaEWT2sgKCplxCoUfm46ie9ndyVeciMs+RpCxg0kV02SJTkgtOyIdxmrJDX6/Bila4H1y4njXOlxT8+cC8ZzW9EZat5b3jtKgQw+OVWzMqoBjE3ZZ1bGyblcTiiKElzNkxVznAa5d06Vmtk07jxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KUWAQV2I; arc=none smtp.client-ip=209.85.217.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vs1-f73.google.com with SMTP id ada2fe7eead31-4e7b071c243so566342137.3
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 13:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749846201; x=1750451001; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XzW1XmGn2aMxciKqb55qIDnqTsupaBqldoKo6HBQgdg=;
        b=KUWAQV2IJ2Z+tJXzQt7b0Oddc58VtJraHNrqKPx64OrCIhI5h0+qn4xdsC0z0RbQaC
         xAdmLqiS8q6AOcCvZE6Ja1IfT0upGAuEzEdIqM2G9OAADo5FPVrZCyT+BeF7LlJcfvN6
         dBBcaLUA9wCcg3RD1/1uIFhOdqnLONqJPQlFV27i2vyR6Vr3T4Mdko4S+QbRFHB8ll/U
         hoqWGsA7R6HrmlNWtnGyLkpdD/dbdCNpIAwphYee3DfneEeSAddeEkfqx0kMpW7zAfxS
         iPr+BXurPC1e2VO5A3fAb/1nmh69GmbXBtajgScgS/wAszI9mm38Q7Q+WQyAPyglCJ5I
         kVeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749846201; x=1750451001;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XzW1XmGn2aMxciKqb55qIDnqTsupaBqldoKo6HBQgdg=;
        b=I1YjkftP7PG30xb5PeZ6fhZOCdH0Z5bxiimS53CUPpDKjE9a5/gNrBJS2KrVm3/0s7
         ExbtZnxl4WWWmNJ1LtVT4g9/nHvu+zha46jTaPoSxviqny8gKrBWrcQLWjz4da1l3aiM
         pM3UQV7SS/s7x3vjaze6wZVf5hemlYDAT2I9fq+Tq0bUUop7QA32goulFIsXy63cOHRL
         KX9K3FHpB5nopMxEdLOf9eTeIKFh//2nEsXAAXlmovREsosPc14vvpg1V9l/Cyu5vC+x
         VKOi938buh8SXwoFVv08AQ1qwoyHJ5Z0wjghvnIvf4CUvV4D/i+gBvPWnX+5qTfOMtev
         Yo5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVHGHobAVFA7dC6rcYuoigyU50y8FsrgnnscAecrHUyV5oJOjSmazoNs/E0WVaxwHJzWfY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8TmyOH4CzXexgB0F2bVctVc3Q7ZOUQPfuNYKM0AtA15TpuVda
	q+60GRidqFESQQeUJycnkB6QyvAdB6nA3rquaOVb4wzJSiOhAJvsB4ifXxlC8d3/e4TEb++ZEXn
	NftKJkRgaKM3aprSldAFJmw==
X-Google-Smtp-Source: AGHT+IE0NRHrDMwWtpGIEcKCTxD5Kf4jPxTrfVXerE3Nehmx+tOQQdnuX2HHZR/1hH8/WLBcgQXhf/bWdS+qG9E+
X-Received: from uae4.prod.google.com ([2002:a05:6130:8104:b0:87e:e774:76ee])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:418d:b0:4dd:b82d:e0de with SMTP id ada2fe7eead31-4e7f6223165mr1228261137.17.1749846201672;
 Fri, 13 Jun 2025 13:23:21 -0700 (PDT)
Date: Fri, 13 Jun 2025 20:23:12 +0000
In-Reply-To: <20250613202315.2790592-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250613202315.2790592-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
Message-ID: <20250613202315.2790592-6-jthoughton@google.com>
Subject: [PATCH v4 5/7] KVM: selftests: Introduce a selftest to measure
 execution performance
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Vipin Sharma <vipinsh@google.com>, David Matlack <dmatlack@google.com>, 
	James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: David Matlack <dmatlack@google.com>

Introduce a new selftest, execute_perf_test, that uses the
perf_test_util framework to measure the performance of executing code
within a VM. This test is similar to the other perf_test_util-based
tests in that it spins up a variable number of vCPUs and runs them
concurrently, accessing memory.

In order to support execution, extend perf_test_util to populate guest
memory with return instructions rather than random garbage. This way
memory can be execute simply by calling it.

Currently only x86_64 supports execution, but other architectures can be
easily added by providing their return code instruction.

Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/execute_perf_test.c | 199 ++++++++++++++++++
 .../testing/selftests/kvm/include/memstress.h |   4 +
 tools/testing/selftests/kvm/lib/memstress.c   |  25 ++-
 4 files changed, 227 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/execute_perf_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 38b95998e1e6b..0dc435e944632 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -137,6 +137,7 @@ TEST_GEN_PROGS_x86 += x86/recalc_apic_map_test
 TEST_GEN_PROGS_x86 += access_tracking_perf_test
 TEST_GEN_PROGS_x86 += coalesced_io_test
 TEST_GEN_PROGS_x86 += dirty_log_perf_test
+TEST_GEN_PROGS_x86 += execute_perf_test
 TEST_GEN_PROGS_x86 += guest_memfd_test
 TEST_GEN_PROGS_x86 += hardware_disable_test
 TEST_GEN_PROGS_x86 += memslot_modification_stress_test
diff --git a/tools/testing/selftests/kvm/execute_perf_test.c b/tools/testing/selftests/kvm/execute_perf_test.c
new file mode 100644
index 0000000000000..f7cbfd8184497
--- /dev/null
+++ b/tools/testing/selftests/kvm/execute_perf_test.c
@@ -0,0 +1,199 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <inttypes.h>
+#include <limits.h>
+#include <pthread.h>
+#include <sys/mman.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+
+#include "kvm_util.h"
+#include "test_util.h"
+#include "memstress.h"
+#include "guest_modes.h"
+#include "ucall_common.h"
+
+/* Global variable used to synchronize all of the vCPU threads. */
+static int iteration;
+
+/* Set to true when vCPU threads should exit. */
+static bool done;
+
+/* The iteration that was last completed by each vCPU. */
+static int vcpu_last_completed_iteration[KVM_MAX_VCPUS];
+
+/* Whether to overlap the regions of memory vCPUs access. */
+static bool overlap_memory_access;
+
+struct test_params {
+	/* The backing source for the region of memory. */
+	enum vm_mem_backing_src_type backing_src;
+
+	/* The amount of memory to allocate for each vCPU. */
+	uint64_t vcpu_memory_bytes;
+
+	/* The number of vCPUs to create in the VM. */
+	int nr_vcpus;
+
+	/* The number of execute iterations the test will run. */
+	int iterations;
+};
+
+static void assert_ucall(struct kvm_vcpu *vcpu, uint64_t expected_ucall)
+{
+	struct ucall uc = {};
+
+	TEST_ASSERT(expected_ucall == get_ucall(vcpu, &uc),
+		    "Guest exited unexpectedly (expected ucall %" PRIu64
+		    ", got %" PRIu64 ")",
+		    expected_ucall, uc.cmd);
+}
+
+static bool spin_wait_for_next_iteration(int *current_iteration)
+{
+	int last_iteration = *current_iteration;
+
+	do {
+		if (READ_ONCE(done))
+			return false;
+
+		*current_iteration = READ_ONCE(iteration);
+	} while (last_iteration == *current_iteration);
+
+	return true;
+}
+
+static void vcpu_thread_main(struct memstress_vcpu_args *vcpu_args)
+{
+	struct kvm_vcpu *vcpu = vcpu_args->vcpu;
+	int current_iteration = 0;
+
+	while (spin_wait_for_next_iteration(&current_iteration)) {
+		vcpu_run(vcpu);
+		assert_ucall(vcpu, UCALL_SYNC);
+		vcpu_last_completed_iteration[vcpu->id] = current_iteration;
+	}
+}
+
+static void spin_wait_for_vcpu(struct kvm_vcpu *vcpu, int target_iteration)
+{
+	while (READ_ONCE(vcpu_last_completed_iteration[vcpu->id]) !=
+	       target_iteration) {
+		continue;
+	}
+}
+
+static void run_iteration(struct kvm_vm *vm, const char *description)
+{
+	struct timespec ts_elapsed;
+	struct timespec ts_start;
+	struct kvm_vcpu *vcpu;
+	int next_iteration;
+
+	/* Kick off the vCPUs by incrementing iteration. */
+	next_iteration = ++iteration;
+
+	clock_gettime(CLOCK_MONOTONIC, &ts_start);
+
+	/* Wait for all vCPUs to finish the iteration. */
+	list_for_each_entry(vcpu, &vm->vcpus, list)
+		spin_wait_for_vcpu(vcpu, next_iteration);
+
+	ts_elapsed = timespec_elapsed(ts_start);
+	pr_info("%-30s: %ld.%09lds\n",
+		description, ts_elapsed.tv_sec, ts_elapsed.tv_nsec);
+}
+
+static void run_test(enum vm_guest_mode mode, void *arg)
+{
+	struct test_params *params = arg;
+	struct kvm_vm *vm;
+	int i;
+
+	vm = memstress_create_vm(mode, params->nr_vcpus,
+				 params->vcpu_memory_bytes, 1,
+				 params->backing_src, !overlap_memory_access);
+
+	memstress_start_vcpu_threads(params->nr_vcpus, vcpu_thread_main);
+
+	pr_info("\n");
+
+	memstress_set_write_percent(vm, 100);
+	run_iteration(vm, "Populating memory");
+
+	run_iteration(vm, "Writing to memory");
+
+	memstress_set_execute(vm, true);
+	for (i = 0; i < params->iterations; ++i)
+		run_iteration(vm, "Executing from memory");
+
+	/* Set done to signal the vCPU threads to exit */
+	done = true;
+
+	memstress_join_vcpu_threads(params->nr_vcpus);
+	memstress_destroy_vm(vm);
+}
+
+static void help(char *name)
+{
+	puts("");
+	printf("usage: %s [-h] [-m mode] [-b vcpu_bytes] [-v nr_vcpus] [-o] "
+	       "[-s mem_type] [-i iterations]\n",
+	       name);
+	puts("");
+	printf(" -h: Display this help message.");
+	guest_modes_help();
+	printf(" -b: specify the size of the memory region which should be\n"
+	       "     dirtied by each vCPU. e.g. 10M or 3G.\n"
+	       "     (default: 1G)\n");
+	printf(" -i: specify the number iterations to execute from memory.\n");
+	printf(" -v: specify the number of vCPUs to run.\n");
+	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
+	       "     them into a separate region of memory for each vCPU.\n");
+	backing_src_help("-s");
+	puts("");
+	exit(0);
+}
+
+int main(int argc, char *argv[])
+{
+	struct test_params params = {
+		.backing_src = DEFAULT_VM_MEM_SRC,
+		.vcpu_memory_bytes = DEFAULT_PER_VCPU_MEM_SIZE,
+		.nr_vcpus = 1,
+		.iterations = 1,
+	};
+	int opt;
+
+	guest_modes_append_default();
+
+	while ((opt = getopt(argc, argv, "hm:b:i:v:os:")) != -1) {
+		switch (opt) {
+		case 'm':
+			guest_modes_cmdline(optarg);
+			break;
+		case 'b':
+			params.vcpu_memory_bytes = parse_size(optarg);
+			break;
+		case 'i':
+			params.iterations = atoi(optarg);
+			break;
+		case 'v':
+			params.nr_vcpus = atoi(optarg);
+			break;
+		case 'o':
+			overlap_memory_access = true;
+			break;
+		case 's':
+			params.backing_src = parse_backing_src_type(optarg);
+			break;
+		case 'h':
+		default:
+			help(argv[0]);
+			break;
+		}
+	}
+
+	for_each_guest_mode(run_test, &params);
+
+	return 0;
+}
diff --git a/tools/testing/selftests/kvm/include/memstress.h b/tools/testing/selftests/kvm/include/memstress.h
index 9071eb6dea60a..ab2a0c05e3fd2 100644
--- a/tools/testing/selftests/kvm/include/memstress.h
+++ b/tools/testing/selftests/kvm/include/memstress.h
@@ -50,6 +50,9 @@ struct memstress_args {
  	/* Test is done, stop running vCPUs. */
  	bool stop_vcpus;
 
+	/* If vCPUs should execute from memory. */
+	bool execute;
+
 	struct memstress_vcpu_args vcpu_args[KVM_MAX_VCPUS];
 };
 
@@ -63,6 +66,7 @@ void memstress_destroy_vm(struct kvm_vm *vm);
 
 void memstress_set_write_percent(struct kvm_vm *vm, uint32_t write_percent);
 void memstress_set_random_access(struct kvm_vm *vm, bool random_access);
+void memstress_set_execute(struct kvm_vm *vm, bool execute);
 
 void memstress_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct memstress_vcpu_args *));
 void memstress_join_vcpu_threads(int vcpus);
diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/selftests/kvm/lib/memstress.c
index 313277486a1de..49677742ec92d 100644
--- a/tools/testing/selftests/kvm/lib/memstress.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -40,6 +40,16 @@ static bool all_vcpu_threads_running;
 
 static struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 
+/*
+ * When writing to guest memory, write the opcode for the `ret` instruction so
+ * that subsequent iteractions can exercise instruction fetch by calling the
+ * memory.
+ *
+ * NOTE: Non-x86 architectures would to use different values here to support
+ * execute.
+ */
+#define RETURN_OPCODE 0xC3
+
 /*
  * Continuously write to the first 8 bytes of each page in the
  * specified region.
@@ -75,8 +85,10 @@ void memstress_guest_code(uint32_t vcpu_idx)
 
 			addr = gva + (page * args->guest_page_size);
 
-			if (__guest_random_bool(&rand_state, args->write_percent))
-				*(uint64_t *)addr = 0x0123456789ABCDEF;
+			if (args->execute)
+				((void (*)(void)) addr)();
+			else if (__guest_random_bool(&rand_state, args->write_percent))
+				*(uint64_t *)addr = RETURN_OPCODE;
 			else
 				READ_ONCE(*(uint64_t *)addr);
 		}
@@ -259,6 +271,15 @@ void __weak memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_v
 	exit(KSFT_SKIP);
 }
 
+void memstress_set_execute(struct kvm_vm *vm, bool execute)
+{
+#ifndef __x86_64__
+	TEST_FAIL("Execute not supported on thhis architecture; see RETURN_OPCODE.");
+#endif
+	memstress_args.execute = execute;
+	sync_global_to_guest(vm, memstress_args);
+}
+
 static void *vcpu_thread_main(void *data)
 {
 	struct vcpu_thread *vcpu = data;
-- 
2.50.0.rc2.692.g299adb8693-goog


