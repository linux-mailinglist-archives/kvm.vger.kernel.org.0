Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBAAB4C52A3
	for <lists+kvm@lfdr.de>; Sat, 26 Feb 2022 01:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiBZAS1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 19:18:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241576AbiBZAR4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 19:17:56 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547B72261DE
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:58 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id e18-20020aa78252000000b004df7a13daeaso3971591pfn.2
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=4glvYTec6CA1tuDy3vxBzyG1mlZFaJtlRRQjIc6IoPY=;
        b=Twv3kahbzIAS1tYSMTJWcj4ijW8tGV2GhRiX0mW0dWmRt2wph0Cdfq8VwHdr+X0akN
         B12+XKYO4iEoipIVwZeMclOROhqYSXPZEzYNG//MV4GPIdmKVHrkp1OZEa4J9qKLMQg5
         VDrlearuWGdX/pOL1eldQUl0aSlqMoaH8jh4+aECbUiyl4g579rVdIv3RWgknoPQg0EL
         BnL2RAh+eNMuQt9oAHSDbYWs3wknyX1z0Ux1f54nOQckVKQZ4j5TeQ6Mkrl4A/briWX1
         ZJadsR04afKwBj/XYtN6SKen2K5JleCca2FgroFZk9vlAiQDSiQ1EPb0cNIR5gtEOjGP
         EEVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=4glvYTec6CA1tuDy3vxBzyG1mlZFaJtlRRQjIc6IoPY=;
        b=G47l9o2geOl7E7gYJ7RjA9aWVhPzJ/8g20ASHjJSiHGoBWDwBOYaETZcl7qYiRhc6Y
         7CWmCk6XI5NUaCuSZrhp11z7Qu6u6YMWltJArm1ZoJvK9lNcdRzbFKyW1XbrOV56Yg+1
         RX9zQUzarlFnLxS/k8l94rm9OuC+sY47HjGdCjptnce35dXiDAcp7diETzsLMEqIlG4x
         UGRPK6URE5s6PJjHkIvMCxXIpW6m7l57rcFTFqUIApRdaRdgZ1ETY94Nmxy8IAFiut+V
         NsqP1tfgNZw+S9VkhFSkSlzZo8qcpX5/N/wg5gsu84P5TDvTYj0uofpuj3W4hsuhN31Q
         bYxQ==
X-Gm-Message-State: AOAM530XQsXi/3YwlCawbtpVQEpRXelOsTfhAgHMHhfFonhQSvHoBhbS
        aCECzeolNT1mWQ89EdAy6p0kUEudx4M=
X-Google-Smtp-Source: ABdhPJy5PD0psRtqptbNhjQl940FK4qZ4jRgORmJxcApmp+iaGtPQHg7HZow9kgaSdeLvzAPRkFCuuPAoEE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:7150:0:b0:372:e0e0:f1a4 with SMTP id
 b16-20020a637150000000b00372e0e0f1a4mr8100838pgn.507.1645834608396; Fri, 25
 Feb 2022 16:16:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 26 Feb 2022 00:15:46 +0000
In-Reply-To: <20220226001546.360188-1-seanjc@google.com>
Message-Id: <20220226001546.360188-29-seanjc@google.com>
Mime-Version: 1.0
References: <20220226001546.360188-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 28/28] KVM: selftests: Add test to populate a VM with the
 max possible guest mem
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a selftest that enables populating a VM with the maximum amount of
guest memory allowed by the underlying architecture.  Abuse KVM's
memslots by mapping a single host memory region into multiple memslots so
that the selftest doesn't require a system with terabytes of RAM.

Default to 512gb of guest memory, which isn't all that interesting, but
should work on all MMUs and doesn't take an exorbitant amount of memory
or time.  E.g. testing with ~64tb of guest memory takes the better part
of an hour, and requires 200gb of memory for KVM's page tables when using
4kb pages.

To inflicit maximum abuse on KVM' MMU, default to 4kb pages (or whatever
the not-hugepage size is) in the backing store (memfd).  Use memfd for
the host backing store to ensure that hugepages are guaranteed when
requested, and to give the user explicit control of the size of hugepage
being tested.

By default, spin up as many vCPUs as there are available to the selftest,
and distribute the work of dirtying each 4kb chunk of memory across all
vCPUs.  Dirtying guest memory forces KVM to populate its page tables, and
also forces KVM to write back accessed/dirty information to struct page
when the guest memory is freed.

On x86, perform two passes with a MMU context reset between each pass to
coerce KVM into dropping all references to the MMU root, e.g. to emulate
a vCPU dropping the last reference.  Perform both passes and all
rendezvous on all architectures in the hope that arm64 and s390x can gain
similar shenanigans in the future.

Measure and report the duration of each operation, which is helpful not
only to verify the test is working as intended, but also to easily
evaluate the performance differences different page sizes.

Provide command line options to limit the amount of guest memory, set the
size of each slot (i.e. of the host memory region), set the number of
vCPUs, and to enable usage of hugepages.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   3 +
 .../selftests/kvm/max_guest_memory_test.c     | 292 ++++++++++++++++++
 3 files changed, 296 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/max_guest_memory_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 052ddfe4b23a..9b67343dc4ab 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -58,6 +58,7 @@
 /hardware_disable_test
 /kvm_create_max_vcpus
 /kvm_page_table_test
+/max_guest_memory_test
 /memslot_modification_stress_test
 /memslot_perf_test
 /rseq_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index f7fa5655e535..c06b1f8bc649 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -93,6 +93,7 @@ TEST_GEN_PROGS_x86_64 += dirty_log_perf_test
 TEST_GEN_PROGS_x86_64 += hardware_disable_test
 TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
 TEST_GEN_PROGS_x86_64 += kvm_page_table_test
+TEST_GEN_PROGS_x86_64 += max_guest_memory_test
 TEST_GEN_PROGS_x86_64 += memslot_modification_stress_test
 TEST_GEN_PROGS_x86_64 += memslot_perf_test
 TEST_GEN_PROGS_x86_64 += rseq_test
@@ -112,6 +113,7 @@ TEST_GEN_PROGS_aarch64 += dirty_log_test
 TEST_GEN_PROGS_aarch64 += dirty_log_perf_test
 TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
 TEST_GEN_PROGS_aarch64 += kvm_page_table_test
+TEST_GEN_PROGS_aarch64 += max_guest_memory_test
 TEST_GEN_PROGS_aarch64 += memslot_modification_stress_test
 TEST_GEN_PROGS_aarch64 += memslot_perf_test
 TEST_GEN_PROGS_aarch64 += rseq_test
@@ -127,6 +129,7 @@ TEST_GEN_PROGS_s390x += demand_paging_test
 TEST_GEN_PROGS_s390x += dirty_log_test
 TEST_GEN_PROGS_s390x += kvm_create_max_vcpus
 TEST_GEN_PROGS_s390x += kvm_page_table_test
+TEST_GEN_PROGS_s390x += max_guest_memory_test
 TEST_GEN_PROGS_s390x += rseq_test
 TEST_GEN_PROGS_s390x += set_memory_region_test
 TEST_GEN_PROGS_s390x += kvm_binary_stats_test
diff --git a/tools/testing/selftests/kvm/max_guest_memory_test.c b/tools/testing/selftests/kvm/max_guest_memory_test.c
new file mode 100644
index 000000000000..360c88288295
--- /dev/null
+++ b/tools/testing/selftests/kvm/max_guest_memory_test.c
@@ -0,0 +1,292 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <pthread.h>
+#include <semaphore.h>
+#include <sys/types.h>
+#include <signal.h>
+#include <errno.h>
+#include <linux/bitmap.h>
+#include <linux/bitops.h>
+#include <linux/atomic.h>
+
+#include "kvm_util.h"
+#include "test_util.h"
+#include "guest_modes.h"
+#include "processor.h"
+
+static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
+{
+	uint64_t gpa;
+
+	for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
+		*((volatile uint64_t *)gpa) = gpa;
+
+	GUEST_DONE();
+}
+
+struct vcpu_info {
+	struct kvm_vm *vm;
+	uint32_t id;
+	uint64_t start_gpa;
+	uint64_t end_gpa;
+};
+
+static int nr_vcpus;
+static atomic_t rendezvous;
+
+static void rendezvous_with_boss(void)
+{
+	int orig = atomic_read(&rendezvous);
+
+	if (orig > 0) {
+		atomic_dec_and_test(&rendezvous);
+		while (atomic_read(&rendezvous) > 0)
+			cpu_relax();
+	} else {
+		atomic_inc(&rendezvous);
+		while (atomic_read(&rendezvous) < 0)
+			cpu_relax();
+	}
+}
+
+static void run_vcpu(struct kvm_vm *vm, uint32_t vcpu_id)
+{
+	vcpu_run(vm, vcpu_id);
+	ASSERT_EQ(get_ucall(vm, vcpu_id, NULL), UCALL_DONE);
+}
+
+static void *vcpu_worker(void *data)
+{
+	struct vcpu_info *vcpu = data;
+	struct kvm_vm *vm = vcpu->vm;
+	struct kvm_sregs sregs;
+	struct kvm_regs regs;
+
+	vcpu_args_set(vm, vcpu->id, 3, vcpu->start_gpa, vcpu->end_gpa,
+		      vm_get_page_size(vm));
+
+	/* Snapshot regs before the first run. */
+	vcpu_regs_get(vm, vcpu->id, &regs);
+	rendezvous_with_boss();
+
+	run_vcpu(vm, vcpu->id);
+	rendezvous_with_boss();
+	vcpu_regs_set(vm, vcpu->id, &regs);
+	vcpu_sregs_get(vm, vcpu->id, &sregs);
+#ifdef __x86_64__
+	/* Toggle CR0.WP to trigger a MMU context reset. */
+	sregs.cr0 ^= X86_CR0_WP;
+#endif
+	vcpu_sregs_set(vm, vcpu->id, &sregs);
+	rendezvous_with_boss();
+
+	run_vcpu(vm, vcpu->id);
+	rendezvous_with_boss();
+
+	return NULL;
+}
+
+static pthread_t *spawn_workers(struct kvm_vm *vm, uint64_t start_gpa,
+				uint64_t end_gpa)
+{
+	struct vcpu_info *info;
+	uint64_t gpa, nr_bytes;
+	pthread_t *threads;
+	int i;
+
+	threads = malloc(nr_vcpus * sizeof(*threads));
+	TEST_ASSERT(threads, "Failed to allocate vCPU threads");
+
+	info = malloc(nr_vcpus * sizeof(*info));
+	TEST_ASSERT(info, "Failed to allocate vCPU gpa ranges");
+
+	nr_bytes = ((end_gpa - start_gpa) / nr_vcpus) &
+			~((uint64_t)vm_get_page_size(vm) - 1);
+	TEST_ASSERT(nr_bytes, "C'mon, no way you have %d CPUs", nr_vcpus);
+
+	for (i = 0, gpa = start_gpa; i < nr_vcpus; i++, gpa += nr_bytes) {
+		info[i].vm = vm;
+		info[i].id = i;
+		info[i].start_gpa = gpa;
+		info[i].end_gpa = gpa + nr_bytes;
+		pthread_create(&threads[i], NULL, vcpu_worker, &info[i]);
+	}
+	return threads;
+}
+
+static void rendezvous_with_vcpus(struct timespec *time, const char *name)
+{
+	int i, rendezvoused;
+
+	pr_info("Waiting for vCPUs to finish %s...\n", name);
+
+	rendezvoused = atomic_read(&rendezvous);
+	for (i = 0; abs(rendezvoused) != 1; i++) {
+		usleep(100);
+		if (!(i & 0x3f))
+			pr_info("\r%d vCPUs haven't rendezvoused...",
+				abs(rendezvoused) - 1);
+		rendezvoused = atomic_read(&rendezvous);
+	}
+
+	clock_gettime(CLOCK_MONOTONIC, time);
+
+	/* Release the vCPUs after getting the time of the previous action. */
+	pr_info("\rAll vCPUs finished %s, releasing...\n", name);
+	if (rendezvoused > 0)
+		atomic_set(&rendezvous, -nr_vcpus - 1);
+	else
+		atomic_set(&rendezvous, nr_vcpus + 1);
+}
+
+static void calc_default_nr_vcpus(void)
+{
+	cpu_set_t possible_mask;
+	int r;
+
+	r = sched_getaffinity(0, sizeof(possible_mask), &possible_mask);
+	TEST_ASSERT(!r, "sched_getaffinity failed, errno = %d (%s)",
+		    errno, strerror(errno));
+
+	nr_vcpus = CPU_COUNT(&possible_mask);
+	TEST_ASSERT(nr_vcpus > 0, "Uh, no CPUs?");
+}
+
+int main(int argc, char *argv[])
+{
+	/*
+	 * Skip the first 4gb and slot0.  slot0 maps <1gb and is used to back
+	 * the guest's code, stack, and page tables.  Because selftests creates
+	 * an IRQCHIP, a.k.a. a local APIC, KVM creates an internal memslot
+	 * just below the 4gb boundary.  This test could create memory at
+	 * 1gb-3gb,but it's simpler to skip straight to 4gb.
+	 */
+	const uint64_t size_1gb = (1 << 30);
+	const uint64_t start_gpa = (4ull * size_1gb);
+	const int first_slot = 1;
+
+	struct timespec time_start, time_run1, time_reset, time_run2;
+	uint64_t max_gpa, gpa, slot_size, max_mem, i;
+	int max_slots, slot, opt, fd;
+	bool hugepages = false;
+	pthread_t *threads;
+	struct kvm_vm *vm;
+	void *mem;
+
+	/*
+	 * Default to 2gb so that maxing out systems with MAXPHADDR=46, which
+	 * are quite common for x86, requires changing only max_mem (KVM allows
+	 * 32k memslots, 32k * 2gb == ~64tb of guest memory).
+	 */
+	slot_size = 2 * size_1gb;
+
+	max_slots = kvm_check_cap(KVM_CAP_NR_MEMSLOTS);
+	TEST_ASSERT(max_slots > first_slot, "KVM is broken");
+
+	/* All KVM MMUs should be able to survive a 512gb guest. */
+	max_mem = 512 * size_1gb;
+
+	calc_default_nr_vcpus();
+
+	while ((opt = getopt(argc, argv, "c:h:m:s:u")) != -1) {
+		switch (opt) {
+		case 'c':
+			nr_vcpus = atoi(optarg);
+			TEST_ASSERT(nr_vcpus, "#DE");
+			break;
+		case 'm':
+			max_mem = atoi(optarg) * size_1gb;
+			TEST_ASSERT(max_mem, "#DE");
+			break;
+		case 's':
+			slot_size = atoi(optarg) * size_1gb;
+			TEST_ASSERT(slot_size, "#DE");
+			break;
+		case 'u':
+			hugepages = true;
+			break;
+		case 'h':
+		default:
+			printf("usage: %s [-c nr_vcpus] [-m max_mem_in_gb] [-s slot_size_in_gb] [-u [huge_page_size]]\n", argv[0]);
+			exit(1);
+		}
+	}
+
+	vm = vm_create_default_with_vcpus(nr_vcpus, 0, 0, guest_code, NULL);
+
+	max_gpa = vm_get_max_gfn(vm) << vm_get_page_shift(vm);
+	TEST_ASSERT(max_gpa > (4 * slot_size), "MAXPHYADDR <4gb ");
+
+	fd = kvm_memfd_alloc(slot_size, hugepages);
+	mem = mmap(NULL, slot_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap() failed");
+
+	TEST_ASSERT(!madvise(mem, slot_size, MADV_NOHUGEPAGE), "madvise() failed");
+
+	/* Pre-fault the memory to avoid taking mmap_sem on guest page faults. */
+	for (i = 0; i < slot_size; i += vm_get_page_size(vm))
+		((uint8_t *)mem)[i] = 0xaa;
+
+	gpa = 0;
+	for (slot = first_slot; slot < max_slots; slot++) {
+		gpa = start_gpa + ((slot - first_slot) * slot_size);
+		if (gpa + slot_size > max_gpa)
+			break;
+
+		if ((gpa - start_gpa) >= max_mem)
+			break;
+
+		vm_set_user_memory_region(vm, slot, 0, gpa, slot_size, mem);
+
+#ifdef __x86_64__
+		/* Identity map memory in the guest using 1gb pages. */
+		for (i = 0; i < slot_size; i += size_1gb)
+			__virt_pg_map(vm, gpa + i, gpa + i, X86_PAGE_SIZE_1G);
+#else
+		for (i = 0; i < slot_size; i += vm_get_page_size(vm))
+			virt_pg_map(vm, gpa + i, gpa + i);
+#endif
+	}
+
+	atomic_set(&rendezvous, nr_vcpus + 1);
+	threads = spawn_workers(vm, start_gpa, gpa);
+
+	pr_info("Running with %lugb of guest memory and %u vCPUs\n",
+		(gpa - start_gpa) / size_1gb, nr_vcpus);
+
+	rendezvous_with_vcpus(&time_start, "spawning");
+	rendezvous_with_vcpus(&time_run1, "run 1");
+	rendezvous_with_vcpus(&time_reset, "reset");
+	rendezvous_with_vcpus(&time_run2, "run 2");
+
+	time_run2  = timespec_sub(time_run2,   time_reset);
+	time_reset = timespec_sub(time_reset, time_run1);
+	time_run1  = timespec_sub(time_run1,   time_start);
+
+	pr_info("run1 = %ld.%.9lds, reset = %ld.%.9lds, run2 =  %ld.%.9lds\n",
+		time_run1.tv_sec, time_run1.tv_nsec,
+		time_reset.tv_sec, time_reset.tv_nsec,
+		time_run2.tv_sec, time_run2.tv_nsec);
+
+	/*
+	 * Delete even numbered slots (arbitrary) and unmap the first half of
+	 * the backing (also arbitrary) to verify KVM correctly drops all
+	 * references to the removed regions.
+	 */
+	for (slot = (slot - 1) & ~1ull; slot >= first_slot; slot -= 2)
+		vm_set_user_memory_region(vm, slot, 0, 0, 0, NULL);
+
+	munmap(mem, slot_size / 2);
+
+	/* Sanity check that the vCPUs actually ran. */
+	for (i = 0; i < nr_vcpus; i++)
+		pthread_join(threads[i], NULL);
+
+	/*
+	 * Deliberately exit without deleting the remaining memslots or closing
+	 * kvm_fd to test cleanup via mmu_notifier.release.
+	 */
+}
-- 
2.35.1.574.g5d30c73bfb-goog

