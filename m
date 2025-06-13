Return-Path: <kvm+bounces-49522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4D5BAD9638
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 22:25:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD916178BFC
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 20:25:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58FDF25D209;
	Fri, 13 Jun 2025 20:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lyRdPdwA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com [209.85.219.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0C225B305
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 20:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749846206; cv=none; b=DTPz9DWVPfi5v5QfNL1G7BK3CmIk2FHoAfVSJWcNlmaAdleuj34YV+W/mVKx9tZupZu9XeOfHGUpq1xFaNiegG9xoOUd7bLtfIRT0AIF5b7N0TJkOGEckEsLgyPYRWbQq3he7lvYdLASDxAWzPucITfoyRX8vaqe2LA4H3NUzTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749846206; c=relaxed/simple;
	bh=VER9ArbSHOwnBBBzloqqIylNJCaqitu4kwv4gydj20I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NMQ2Yxz2GSb+SjJtFs1D7WeUtjDCyjUES1Glef3lOXhV3DgN/bfn8SI7FREIS12tavaxImWsMJ5ZzpBF4x+fanmzpt8KN2dmBim+i1aQOjOgJCqu8ayDlcj+JF/Tn2LVwIpgMzrTf6t00iEdMNuyz2QKvTJfa1VdpO4Os0mk6jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lyRdPdwA; arc=none smtp.client-ip=209.85.219.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-qv1-f73.google.com with SMTP id 6a1803df08f44-6fafb2f0a33so33985146d6.0
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 13:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749846203; x=1750451003; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OFaJFELA+zenLb8Y22gAlioJyRz/eOniSI4TmKAA5To=;
        b=lyRdPdwAu9yTlC4G8XA5QLvnL+XUDF6v0xPz9HKNaF8RX7Bt6SdP0JTkTIPYd8la0R
         0jugoMsaTltxzprwOUJJhNcaw7i29lc+AdjoCtaQQHYv2iwM4QEcpTqA4Wau5MoaZ7dk
         lphum7O5X3url3MJ4buGyt5DvH5AqH6/ve8naDD78SJhGeOdseurr18Tij7lz2wYo2bs
         jNnlQlSsBlrfRk/p0baO9UQSdIxM4t9z6PPRuoT1DmLvCjg8ukyge2QReoePlJSSUazy
         QMPYtLKwd5c80PFJFLQg3J03jJIQ3MIPz2tc7iZX+Ku+ePiszBEZhqjRMVvlj/lzzwOf
         4EXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749846203; x=1750451003;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OFaJFELA+zenLb8Y22gAlioJyRz/eOniSI4TmKAA5To=;
        b=RQPuc4OR6sFg2EFvBiCbA//RFTOceajNU/Zs2mUemFLfdfkKj36ZqyWHIujZXzUA0T
         FM6WUKapNPDFibjyBflMFVeZuEBDGvH5cxU1UexxQ8OjWDfh3aeYNbs4vXyh+BeSqJIs
         WqanR6wxmonNcpKK2HKVVzG/lRp5yb7FxAGGW6HzRL1SnwQMUB2oaCGsxpp6KP5RDu4/
         9ttHPX/6MTAKRkgvt9z9t0Uhn4ZBxZ1jCX/cyT3hFAJBvE2yq8MngM0RYZ8e7A3ogE0E
         g3EujNjDwvmQCychZFhBj6yAbSaSdbeWh96rNRC5hXK4UYn9cgwUN6VmF7KyKrEsZtYO
         hkQw==
X-Forwarded-Encrypted: i=1; AJvYcCUI9ew5XR1MNQeY4mZuMWY/2VD+kbtyilXRDgZwH7l4Fak8Zz9olQegFI9PAwrrohAiz6U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwV4yefETMxNaoXeSkVnqBMm9L5R7lWRxgEjPt7YCk7/Lzx3xXf
	8MgESIV7icNMmW1osFGTC9pFGWcYq0788oLLTrlmIxoyVgQET/NPj8ZrjHYtRTNcXBW4fBIfaY5
	QkGENgsT2BAOhqLWJpTs5DA==
X-Google-Smtp-Source: AGHT+IGEHUiDm4lDXoBuTgKOdQu5vKdi/t6ue2qnZlGualobYksBIHMvyieKg485zbwec9gdzCbGijkjqn2gbGxH
X-Received: from qvri17.prod.google.com ([2002:a0c:edd1:0:b0:6fa:fc20:67])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6214:458f:b0:6ed:df6:cdcd with SMTP id 6a1803df08f44-6fb47774531mr12272756d6.21.1749846203466;
 Fri, 13 Jun 2025 13:23:23 -0700 (PDT)
Date: Fri, 13 Jun 2025 20:23:14 +0000
In-Reply-To: <20250613202315.2790592-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250613202315.2790592-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
Message-ID: <20250613202315.2790592-8-jthoughton@google.com>
Subject: [PATCH v4 7/7] KVM: selftests: Add an NX huge pages jitter test
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Vipin Sharma <vipinsh@google.com>, David Matlack <dmatlack@google.com>, 
	James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add a test that checks how much NX huge page recovery affects vCPUs that
are faulting on pages not undergoing NX huge page recovery. To do this,
this test uses a single vCPU to touch all of guest memory. After every
1G of guest memory, it will switch from writing to executing. Only the
writes are timed.

With this setup, while the guest is in the middle of reading a 1G
region, NX huge page recovery (provided it is set aggressive enough)
will start to recover huge pages in the previous 1G region.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../kvm/x86/nx_huge_pages_perf_test.c         | 223 ++++++++++++++++++
 2 files changed, 224 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/nx_huge_pages_perf_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 0dc435e944632..4b5be9f0bac5b 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -88,6 +88,7 @@ TEST_GEN_PROGS_x86 += x86/kvm_buslock_test
 TEST_GEN_PROGS_x86 += x86/monitor_mwait_test
 TEST_GEN_PROGS_x86 += x86/nested_emulation_test
 TEST_GEN_PROGS_x86 += x86/nested_exceptions_test
+TEST_GEN_PROGS_x86 += x86/nx_huge_pages_perf_test
 TEST_GEN_PROGS_x86 += x86/platform_info_test
 TEST_GEN_PROGS_x86 += x86/pmu_counters_test
 TEST_GEN_PROGS_x86 += x86/pmu_event_filter_test
diff --git a/tools/testing/selftests/kvm/x86/nx_huge_pages_perf_test.c b/tools/testing/selftests/kvm/x86/nx_huge_pages_perf_test.c
new file mode 100644
index 0000000000000..e33e913ec7dfa
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/nx_huge_pages_perf_test.c
@@ -0,0 +1,223 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * nx_huge_pages_perf_test
+ *
+ * Copyright (C) 2025, Google LLC.
+ *
+ * Performance test for NX hugepage recovery.
+ *
+ * This test checks for long faults on allocated pages when NX huge page
+ * recovery is taking place on pages mapped by the VM.
+ */
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <time.h>
+
+#include "test_util.h"
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "ucall_common.h"
+
+/* Default guest test virtual memory offset */
+#define DEFAULT_GUEST_TEST_MEM		0xc0000000
+
+/* Default size (2GB) of the memory for testing */
+#define DEFAULT_TEST_MEM_SIZE		(2 << 30)
+
+/*
+ * Guest virtual memory offset of the testing memory slot.
+ * Must not conflict with identity mapped test code.
+ */
+static uint64_t guest_test_virt_mem = DEFAULT_GUEST_TEST_MEM;
+
+static struct kvm_vcpu *vcpu;
+
+struct test_params {
+	enum vm_mem_backing_src_type backing_src;
+	uint64_t memory_bytes;
+};
+
+struct guest_args {
+	uint64_t guest_page_size;
+	uint64_t pages;
+};
+
+static struct guest_args guest_args;
+
+#define RETURN_OPCODE 0xC3
+
+static void guest_code(int vcpu_idx)
+{
+	struct guest_args *args = &guest_args;
+	uint64_t page_size = args->guest_page_size;
+	uint64_t max_cycles = 0UL;
+	volatile char *gva;
+	uint64_t page;
+
+
+	for (page = 0; page < args->pages; ++page) {
+		gva = (volatile char *)guest_test_virt_mem + page * page_size;
+
+		/*
+		 * To time the jitter on all faults on pages that are not
+		 * undergoing nx huge page recovery, only execute on every
+		 * other 1G region, and only time the non-executing pass.
+		 */
+		if (page & (1UL << 18)) {
+			uint64_t tsc1, tsc2;
+
+			tsc1 = rdtsc();
+			*gva = 0;
+			tsc2 = rdtsc();
+
+			if (tsc2 - tsc1 > max_cycles)
+				max_cycles = tsc2 - tsc1;
+		} else {
+			*gva = RETURN_OPCODE;
+			((void (*)(void)) gva)();
+		}
+	}
+
+	GUEST_SYNC1(max_cycles);
+}
+
+struct kvm_vm *create_vm(uint64_t memory_bytes,
+			 enum vm_mem_backing_src_type backing_src)
+{
+	uint64_t backing_src_pagesz = get_backing_src_pagesz(backing_src);
+	struct guest_args *args = &guest_args;
+	uint64_t guest_num_pages;
+	uint64_t region_end_gfn;
+	uint64_t gpa, size;
+	struct kvm_vm *vm;
+
+	args->guest_page_size = getpagesize();
+
+	guest_num_pages = vm_adjust_num_guest_pages(VM_MODE_DEFAULT,
+				memory_bytes / args->guest_page_size);
+
+	TEST_ASSERT(memory_bytes % getpagesize() == 0,
+		    "Guest memory size is not host page size aligned.");
+
+	vm = __vm_create_with_one_vcpu(&vcpu, guest_num_pages, guest_code);
+
+	/* Put the test region at the top guest physical memory. */
+	region_end_gfn = vm->max_gfn + 1;
+
+	/*
+	 * If there should be more memory in the guest test region than there
+	 * can be pages in the guest, it will definitely cause problems.
+	 */
+	TEST_ASSERT(guest_num_pages < region_end_gfn,
+		    "Requested more guest memory than address space allows.\n"
+		    "    guest pages: %" PRIx64 " max gfn: %" PRIx64
+		    " wss: %" PRIx64 "]",
+		    guest_num_pages, region_end_gfn - 1, memory_bytes);
+
+	gpa = (region_end_gfn - guest_num_pages - 1) * args->guest_page_size;
+	gpa = align_down(gpa, backing_src_pagesz);
+
+	size = guest_num_pages * args->guest_page_size;
+	pr_info("guest physical test memory: [0x%lx, 0x%lx)\n",
+		gpa, gpa + size);
+
+	/*
+	 * Pass in MAP_POPULATE, because we are trying to test how long
+	 * we have to wait for a pending NX huge page recovery to take.
+	 * We do not want to also wait for GUP itself.
+	 */
+	vm_mem_add(vm, backing_src, gpa, 1,
+		   guest_num_pages, 0, -1, 0, MAP_POPULATE);
+
+	virt_map(vm, guest_test_virt_mem, gpa, guest_num_pages);
+
+	args->pages = guest_num_pages;
+
+	/* Export the shared variables to the guest. */
+	sync_global_to_guest(vm, guest_args);
+
+	return vm;
+}
+
+static void run_vcpu(struct kvm_vcpu *vcpu)
+{
+	struct timespec ts_elapsed;
+	struct timespec ts_start;
+	struct ucall uc = {};
+	int ret;
+
+	clock_gettime(CLOCK_MONOTONIC, &ts_start);
+
+	ret = _vcpu_run(vcpu);
+
+	ts_elapsed = timespec_elapsed(ts_start);
+
+	TEST_ASSERT(ret == 0, "vcpu_run failed: %d", ret);
+
+	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_SYNC,
+		    "Invalid guest sync status: %" PRIu64, uc.cmd);
+
+	pr_info("Duration: %ld.%09lds\n",
+		ts_elapsed.tv_sec, ts_elapsed.tv_nsec);
+	pr_info("Max fault latency: %" PRIu64 " cycles\n", uc.args[0]);
+}
+
+static void run_test(struct test_params *params)
+{
+	/*
+	 * The fault + execute pattern in the guest relies on having more than
+	 * 1GiB to use.
+	 */
+	TEST_ASSERT(params->memory_bytes > PAGE_SIZE << 18,
+		    "Must use more than 1GiB of memory.");
+
+	create_vm(params->memory_bytes, params->backing_src);
+
+	pr_info("\n");
+
+	run_vcpu(vcpu);
+}
+
+static void help(char *name)
+{
+	puts("");
+	printf("usage: %s [-h] [-b bytes] [-s mem_type]\n",
+	       name);
+	puts("");
+	printf(" -h: Display this help message.");
+	printf(" -b: specify the size of the memory region which should be\n"
+	       "     dirtied by the guest. e.g. 2048M or 3G.\n"
+	       "     (default: 2G, must be greater than 1G)\n");
+	backing_src_help("-s");
+	puts("");
+	exit(0);
+}
+
+int main(int argc, char *argv[])
+{
+	struct test_params params = {
+		.backing_src = DEFAULT_VM_MEM_SRC,
+		.memory_bytes = DEFAULT_TEST_MEM_SIZE,
+	};
+	int opt;
+
+	while ((opt = getopt(argc, argv, "hb:s:")) != -1) {
+		switch (opt) {
+		case 'b':
+			params.memory_bytes = parse_size(optarg);
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
+	run_test(&params);
+}
-- 
2.50.0.rc2.692.g299adb8693-goog


