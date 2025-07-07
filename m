Return-Path: <kvm+bounces-51712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A1142AFBE64
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 00:50:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E68695616EF
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 22:50:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF5772E92BC;
	Mon,  7 Jul 2025 22:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wq/iQLYx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBE92E8E03
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 22:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751928519; cv=none; b=Rjn9C/OC3WVWi/kCuiLHAsPek6MdIOTKqkXOW2ztRpfUE8WNTO+Xz6vVHKFZBXemDYN9Bn02vUTbY00LesJThzqz6q8jAs3Kyt0SykFgQOLyVN1d0iBoF7kKYOMEaL0evkjZamz5GLkN7346jDmnEXlsH2v2/y23tfgUVJkrvjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751928519; c=relaxed/simple;
	bh=+B1tzUeRnbjcRJrdTNGtKuA80J+Vd/hMm8gBBpvb0H8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SjR7oIqBuz0Ioc+lByyopasCMdksKnZspK4SOTeUHWkPmJgCcch8/CzRvugqKQqV1BZtp9IEOjSxwtUBHgyrYasBtQ5fZuKU57dWpII1IqsJJ94gqONv7x3iVhPHHwjdPREWW3VOWDqpIioMFVG3QF1g4tfi9me2PjPriVsGAG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wq/iQLYx; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3132c8437ffso5379249a91.1
        for <kvm@vger.kernel.org>; Mon, 07 Jul 2025 15:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751928517; x=1752533317; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rwbn8AkKKcNl/7mjlcPAAJ9HVPrgom/gFcHQx8uwU7o=;
        b=wq/iQLYx6YNSMa3posLyN0vz67FEF5eLNxwOhMtf/1iR/SgaLFxIjJr2pxLLoR66I8
         q8L7iwTuAZMjtacc8rSQMiFzDLDbBq+M/m7SzY8YXuSvgsiBTRngkYZPjkwDXPV6PC9h
         63xh4fE3sABZZL2VKL5V/lLi+yyRV0W+X1UtploivulQjbRJ0wLADypjp0/CHFwWbTBJ
         o0GeV0M0iRmGIo+HD0wzasPtU+1ZdCo9WyZ/jKaYbnGlIeuS3jX2DIzKRqNxiLCOIG1w
         204TmEqHgt/wQqTIXlzEaDqT7to+xQqhG1EsHFIvqwL1E90WOJKSFNbSZNnkjRKloDvP
         QbMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751928517; x=1752533317;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rwbn8AkKKcNl/7mjlcPAAJ9HVPrgom/gFcHQx8uwU7o=;
        b=eDSmen+LldkFXeTjSfC14UNThmCZfNPnKQmcobN5jWDpuJ1Um9S2HdMzf6U1uOMWIk
         QIJOK66NS1O3xEEy0hCnDUqmP795btRVhxKDwIR8eISVkhsuztMFT6MbEHTZVc9JJjiX
         fnGyRQr21TsIbccZ+soOdXX4qbNXVBgpkd6darwWr8W8+60hu7fLbeQk/oaIseB4zB9q
         ErqCeIzRATHDqaHPN6QLHcIgo2q+5/hG6IxiJ2iNT7JYls/cX4vfiQfRJU/4UpnaAXCW
         sCjDebsvMoh/D5vhMOA4Pehq6h5pTugvn6WZOV8lJJlc70bh8PTsnujVY3TuSGUiID4V
         3b8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVp1FRtt+hzOndQ9y/TlY3dTs068qsrl21cMYLHBo+ShMOypkK0797bWxaSb/cF2mgOyIk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNQfLFVzexCzqko8j1LMhCVlYAzbOhTNjNy6DrxQAV/UZC7d7l
	mxw9HiQ1bVZG2IEhPb3PqwlPw7pmLDoTiciVklRETjUrrpNiTjFq/2efQkB4Z8sJA04rkqhE91G
	iXho4QWFgXfijlwGhvJ2DoA==
X-Google-Smtp-Source: AGHT+IFxcSTgLeGyYaHVsYcNu0MgQB9pPS3S5NDxa7lwYcKq/ZVn+af7NlY69BJsaMTfNIQybdrsbm+PcQfF1m4U
X-Received: from pja12.prod.google.com ([2002:a17:90b:548c:b0:312:e266:f849])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3c50:b0:311:d28a:73ef with SMTP id 98e67ed59e1d1-31aac447bc9mr22346078a91.10.1751928516542;
 Mon, 07 Jul 2025 15:48:36 -0700 (PDT)
Date: Mon,  7 Jul 2025 22:47:20 +0000
In-Reply-To: <20250707224720.4016504-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250707224720.4016504-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250707224720.4016504-8-jthoughton@google.com>
Subject: [PATCH v5 7/7] KVM: selftests: Add an NX huge pages jitter test
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
2.50.0.727.gbf7dc18ff4-goog


