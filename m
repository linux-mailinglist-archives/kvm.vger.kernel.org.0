Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED5023DC129
	for <lists+kvm@lfdr.de>; Sat, 31 Jul 2021 00:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbhG3Wha (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 18:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233532AbhG3Wh3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 18:37:29 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C3EC061765
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 15:37:23 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id v9-20020a17090a7c09b02901778a2a8fd6so3616951pjf.3
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 15:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2aoVz7znREQKWV9lVbXQeoyZokiTowDuQPpHDCPdpA4=;
        b=mfd2dcSY+xxaFitbUK4muN+w6fmLX7dohJ22U9MPcdGpwcjshJlA0DIWffHCm0y6bB
         3zhmnGby+5xCDwEPVOBey2NBI1StJ0574Crc6pQc1Y2Cq/e/YCtwSb9c880VWmftET1e
         R+rapN1N0CL2WuUHE/6xOKeRMi9vIpASLmwIsRZOz/LNgUSFmfHdxRLDPBODVZO0rFzV
         1NPu7IbfMm8O/BeMYwN0KoOpWCHZNgteWrhCIRd9hX0eAThFua8ly5K9w+lFW/m/N9u3
         mWQg6gOOnSWlr+E6OMnibs9KxXScUCuhn0NZEmcsgIt0A6yur5lrX5cmrtwvSnRfKORI
         0Bgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2aoVz7znREQKWV9lVbXQeoyZokiTowDuQPpHDCPdpA4=;
        b=tnNnSAxB0zMiBcZK8hZ0MTipZbrZb7JohbJ9XVtRZlMRsU0xuoFwba2gs/IeWBs3L/
         JiPuu2Dvgox5n7nTrmVCQG6XLJtHi+MXcfTLn7n8GhSMzr0yWhMIROSZa0BZRtv/efbX
         mypHqzLOW9ykcORDZuZiSqHuc/4U0jQEQ7vWdGalW6KgbrwEE7NrO1IzniesSWaoeK7U
         IACaniJ55Ac561mDDyXuTAkZzEboRvdHDk6uksYph+96kDnt0B98H9YpCW2k+yQ6ZzMg
         JEJe7cTYLXOTm6bUG3ywd/lLtHn3oq7XncnEW+C9HF4Vwofx9L/2sivzv+h6dl77diAj
         4zYA==
X-Gm-Message-State: AOAM532WtSm5RBvyvysXVB+rAT3ExC2g2zMpT9yglEeIWRA/Udv151ZI
        RXor9TNE8EZHnCHF54PAcFvCSDg/UCFhHf0RORI+T3lqz2FSJi0Cbu/RCEYwdSKVefrukoMacwG
        cf8xxKy8KD9aOp0tWM31LmdkmKYxilBv9MDbweZ8JX6hxAj4PEvrPkvJNovSqTjo=
X-Google-Smtp-Source: ABdhPJyZdW12btC6KWIPiwDEZZ2cNu6fj4nIlKhVG0AwtGlj/lfNiJvKiDHlfeYxcJS6sTtvF1z7g7IjRcOTzQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:bc82:b029:12b:a074:1fae with SMTP
 id bb2-20020a170902bc82b029012ba0741faemr2755861plb.29.1627684643279; Fri, 30
 Jul 2021 15:37:23 -0700 (PDT)
Date:   Fri, 30 Jul 2021 22:37:07 +0000
In-Reply-To: <20210730223707.4083785-1-dmatlack@google.com>
Message-Id: <20210730223707.4083785-7-dmatlack@google.com>
Mime-Version: 1.0
References: <20210730223707.4083785-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH 6/6] KVM: selftests: Support multiple slots in dirty_log_perf_test
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a new option to dirty_log_perf_test: -x number_of_slots. This
causes the test to attempt to split the region of memory into the given
number of slots. If the region cannot be evenly divided, the test will
fail.

This allows testing with more than one slot and therefore measure how
performance scales with the number of memslots.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/kvm/access_tracking_perf_test.c |  2 +-
 .../selftests/kvm/demand_paging_test.c        |  2 +-
 .../selftests/kvm/dirty_log_perf_test.c       | 76 ++++++++++++++++---
 .../selftests/kvm/include/perf_test_util.h    |  2 +-
 .../selftests/kvm/lib/perf_test_util.c        | 20 +++--
 .../kvm/memslot_modification_stress_test.c    |  2 +-
 6 files changed, 84 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index e2baa187a21e..3e23b2105f4b 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -333,7 +333,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	pthread_t *vcpu_threads;
 	int vcpus = params->vcpus;
 
-	vm = perf_test_create_vm(mode, vcpus, params->vcpu_memory_bytes,
+	vm = perf_test_create_vm(mode, vcpus, params->vcpu_memory_bytes, 1,
 				 params->backing_src);
 
 	perf_test_setup_vcpus(vm, vcpus, params->vcpu_memory_bytes,
diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index b74704305835..61266a729d88 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -293,7 +293,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	int vcpu_id;
 	int r;
 
-	vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size,
+	vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
 				 p->src_type);
 
 	perf_test_args.wr_fract = 1;
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 80cbd3a748c0..034458dd89a2 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -94,8 +94,59 @@ struct test_params {
 	int wr_fract;
 	bool partition_vcpu_memory_access;
 	enum vm_mem_backing_src_type backing_src;
+	int slots;
 };
 
+static void toggle_dirty_logging(struct kvm_vm *vm, int slots, bool enable)
+{
+	int i;
+
+	for (i = 0; i < slots; i++) {
+		int slot = PERF_TEST_MEM_SLOT_INDEX + i;
+		int flags = enable ? KVM_MEM_LOG_DIRTY_PAGES : 0;
+
+		vm_mem_region_set_flags(vm, slot, flags);
+	}
+}
+
+static inline void enable_dirty_logging(struct kvm_vm *vm, int slots)
+{
+	toggle_dirty_logging(vm, slots, true);
+}
+
+static inline void disable_dirty_logging(struct kvm_vm *vm, int slots)
+{
+	toggle_dirty_logging(vm, slots, false);
+}
+
+static void get_dirty_log(struct kvm_vm *vm, int slots, unsigned long *bitmap,
+			  uint64_t nr_pages)
+{
+	uint64_t slot_pages = nr_pages / slots;
+	int i;
+
+	for (i = 0; i < slots; i++) {
+		int slot = PERF_TEST_MEM_SLOT_INDEX + i;
+		unsigned long *slot_bitmap = bitmap + i * slot_pages;
+
+		kvm_vm_get_dirty_log(vm, slot, slot_bitmap);
+	}
+}
+
+static void clear_dirty_log(struct kvm_vm *vm, int slots, unsigned long *bitmap,
+			    uint64_t nr_pages)
+{
+	uint64_t slot_pages = nr_pages / slots;
+	int i;
+
+	for (i = 0; i < slots; i++) {
+		int slot = PERF_TEST_MEM_SLOT_INDEX + i;
+		unsigned long *slot_bitmap = bitmap + i * slot_pages;
+
+		kvm_vm_clear_dirty_log(vm, slot, slot_bitmap, 0, slot_pages);
+	}
+}
+
 static void run_test(enum vm_guest_mode mode, void *arg)
 {
 	struct test_params *p = arg;
@@ -114,7 +165,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct timespec clear_dirty_log_total = (struct timespec){0};
 
 	vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size,
-				 p->backing_src);
+				 p->slots, p->backing_src);
 
 	perf_test_args.wr_fract = p->wr_fract;
 
@@ -163,8 +214,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	/* Enable dirty logging */
 	clock_gettime(CLOCK_MONOTONIC, &start);
-	vm_mem_region_set_flags(vm, PERF_TEST_MEM_SLOT_INDEX,
-				KVM_MEM_LOG_DIRTY_PAGES);
+	enable_dirty_logging(vm, p->slots);
 	ts_diff = timespec_elapsed(start);
 	pr_info("Enabling dirty logging time: %ld.%.9lds\n\n",
 		ts_diff.tv_sec, ts_diff.tv_nsec);
@@ -190,8 +240,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 			iteration, ts_diff.tv_sec, ts_diff.tv_nsec);
 
 		clock_gettime(CLOCK_MONOTONIC, &start);
-		kvm_vm_get_dirty_log(vm, PERF_TEST_MEM_SLOT_INDEX, bmap);
-
+		get_dirty_log(vm, p->slots, bmap, host_num_pages);
 		ts_diff = timespec_elapsed(start);
 		get_dirty_log_total = timespec_add(get_dirty_log_total,
 						   ts_diff);
@@ -200,9 +249,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 		if (dirty_log_manual_caps) {
 			clock_gettime(CLOCK_MONOTONIC, &start);
-			kvm_vm_clear_dirty_log(vm, PERF_TEST_MEM_SLOT_INDEX, bmap, 0,
-					       host_num_pages);
-
+			clear_dirty_log(vm, p->slots, bmap, host_num_pages);
 			ts_diff = timespec_elapsed(start);
 			clear_dirty_log_total = timespec_add(clear_dirty_log_total,
 							     ts_diff);
@@ -213,7 +260,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	/* Disable dirty logging */
 	clock_gettime(CLOCK_MONOTONIC, &start);
-	vm_mem_region_set_flags(vm, PERF_TEST_MEM_SLOT_INDEX, 0);
+	disable_dirty_logging(vm, p->slots);
 	ts_diff = timespec_elapsed(start);
 	pr_info("Disabling dirty logging time: %ld.%.9lds\n",
 		ts_diff.tv_sec, ts_diff.tv_nsec);
@@ -244,7 +291,8 @@ static void help(char *name)
 {
 	puts("");
 	printf("usage: %s [-h] [-i iterations] [-p offset] "
-	       "[-m mode] [-b vcpu bytes] [-v vcpus] [-o] [-s mem type]\n", name);
+	       "[-m mode] [-b vcpu bytes] [-v vcpus] [-o] [-s mem type]"
+	       "[-x memslots]\n", name);
 	puts("");
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
 	       TEST_HOST_LOOP_N);
@@ -263,6 +311,8 @@ static void help(char *name)
 	       "     them into a separate region of memory for each vCPU.\n");
 	printf(" -s: specify the type of memory that should be used to\n"
 	       "     back the guest data region.\n\n");
+	printf(" -x: Split the memory region into this number of memslots.\n"
+	       "     (default: 1)");
 	backing_src_help();
 	puts("");
 	exit(0);
@@ -276,6 +326,7 @@ int main(int argc, char *argv[])
 		.wr_fract = 1,
 		.partition_vcpu_memory_access = true,
 		.backing_src = VM_MEM_SRC_ANONYMOUS,
+		.slots = 1,
 	};
 	int opt;
 
@@ -286,7 +337,7 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "hi:p:m:b:f:v:os:")) != -1) {
+	while ((opt = getopt(argc, argv, "hi:p:m:b:f:v:os:x:")) != -1) {
 		switch (opt) {
 		case 'i':
 			p.iterations = atoi(optarg);
@@ -316,6 +367,9 @@ int main(int argc, char *argv[])
 		case 's':
 			p.backing_src = parse_backing_src_type(optarg);
 			break;
+		case 'x':
+			p.slots = atoi(optarg);
+			break;
 		case 'h':
 		default:
 			help(argv[0]);
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index 005f2143adeb..df9f1a3a3ffb 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -44,7 +44,7 @@ extern struct perf_test_args perf_test_args;
 extern uint64_t guest_test_phys_mem;
 
 struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
-				   uint64_t vcpu_memory_bytes,
+				   uint64_t vcpu_memory_bytes, int slots,
 				   enum vm_mem_backing_src_type backing_src);
 void perf_test_destroy_vm(struct kvm_vm *vm);
 void perf_test_setup_vcpus(struct kvm_vm *vm, int vcpus,
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index b488f4aefea8..aebb223d34a7 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -50,11 +50,12 @@ static void guest_code(uint32_t vcpu_id)
 }
 
 struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
-				   uint64_t vcpu_memory_bytes,
+				   uint64_t vcpu_memory_bytes, int slots,
 				   enum vm_mem_backing_src_type backing_src)
 {
 	struct kvm_vm *vm;
 	uint64_t guest_num_pages;
+	int i;
 
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
@@ -68,6 +69,9 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 		    "Guest memory size is not host page size aligned.");
 	TEST_ASSERT(vcpu_memory_bytes % perf_test_args.guest_page_size == 0,
 		    "Guest memory size is not guest page size aligned.");
+	TEST_ASSERT(guest_num_pages % slots == 0,
+		    "Guest memory cannot be evenly divided into %d slots.",
+		    slots);
 
 	vm = vm_create_with_vcpus(mode, vcpus, DEFAULT_GUEST_PHY_PAGES,
 				  (vcpus * vcpu_memory_bytes) / perf_test_args.guest_page_size,
@@ -95,10 +99,16 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 #endif
 	pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_mem);
 
-	/* Add an extra memory slot for testing */
-	vm_userspace_mem_region_add(vm, backing_src, guest_test_phys_mem,
-				    PERF_TEST_MEM_SLOT_INDEX,
-				    guest_num_pages, 0);
+	/* Add extra memory slots for testing */
+	for (i = 0; i < slots; i++) {
+		uint64_t region_pages = guest_num_pages / slots;
+		vm_paddr_t region_start = guest_test_phys_mem +
+			region_pages * perf_test_args.guest_page_size * i;
+
+		vm_userspace_mem_region_add(vm, backing_src, region_start,
+					    PERF_TEST_MEM_SLOT_INDEX + i,
+					    region_pages, 0);
+	}
 
 	/* Do mapping for the demand paging memory slot */
 	virt_map(vm, guest_test_virt_mem, guest_test_phys_mem, guest_num_pages);
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 98351ba0933c..8a9c6ccce3ca 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -105,7 +105,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct kvm_vm *vm;
 	int vcpu_id;
 
-	vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size,
+	vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
 				 VM_MEM_SRC_ANONYMOUS);
 
 	perf_test_args.wr_fract = 1;
-- 
2.32.0.554.ge1b32706d8-goog

