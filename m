Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405EC2A6F9A
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 22:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbgKDVYr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 16:24:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43842 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732126AbgKDVYq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 16:24:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604525083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3et7Kp8MongYf/Tw2BBGQsS3n9IujWeRpyRIfJVL2XU=;
        b=Q8CPdHS6/j5x8Whvd4C7xe2qG1n9nl85Gh158hYZ1kbbzlHXI0u+md1cdA3wUhY8JO5u/d
        Ao5rHpj8r8TbCdsu7Az+wx/oZM71+baeOyNNv1RgD8fXq8+B0W1o/6fzWI2lBEAoMM7NBi
        CHKKz1ZaIY8oYAOtbzYbgPdz3mITZuM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-iaOopPJbNeqavyS6rJgsoA-1; Wed, 04 Nov 2020 16:24:42 -0500
X-MC-Unique: iaOopPJbNeqavyS6rJgsoA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 115EA57241;
        Wed,  4 Nov 2020 21:24:41 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3818B10013C4;
        Wed,  4 Nov 2020 21:24:39 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
Subject: [PATCH 11/11] KVM: selftests: Remove create_vm
Date:   Wed,  4 Nov 2020 22:23:57 +0100
Message-Id: <20201104212357.171559-12-drjones@redhat.com>
In-Reply-To: <20201104212357.171559-1-drjones@redhat.com>
References: <20201104212357.171559-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove create_vm() from demand_paging_test and dirty_log_test by
replacing it with vm_create_with_vcpus(). We also make
vm_guest_mode_params[] global allowing us to clean up some
page calculations and remove redundant asserts.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/demand_paging_test.c        | 70 ++++---------------
 tools/testing/selftests/kvm/dirty_log_test.c  | 62 ++++------------
 .../testing/selftests/kvm/include/kvm_util.h  |  9 +++
 tools/testing/selftests/kvm/lib/kvm_util.c    |  9 +--
 4 files changed, 37 insertions(+), 113 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 693e2c810f15..49a4ee8ca78a 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -7,7 +7,7 @@
  * Copyright (C) 2019, Google, Inc.
  */
 
-#define _GNU_SOURCE /* for program_invocation_name */
+#define _GNU_SOURCE /* for pipe2 */
 
 #include <stdio.h>
 #include <stdlib.h>
@@ -145,39 +145,6 @@ static void *vcpu_worker(void *data)
 	return NULL;
 }
 
-#define PAGE_SHIFT_4K  12
-#define PTES_PER_4K_PT 512
-
-static struct kvm_vm *create_vm(enum vm_guest_mode mode, int vcpus,
-				uint64_t guest_percpu_mem_size)
-{
-	struct kvm_vm *vm;
-	uint64_t pages = DEFAULT_GUEST_PHY_PAGES;
-
-	/* Account for a few pages per-vCPU for stacks */
-	pages += DEFAULT_STACK_PGS * vcpus;
-
-	/*
-	 * Reserve twice the ammount of memory needed to map the test region and
-	 * the page table / stacks region, at 4k, for page tables. Do the
-	 * calculation with 4K page size: the smallest of all archs. (e.g., 64K
-	 * page size guest will need even less memory for page tables).
-	 */
-	pages += (2 * pages) / PTES_PER_4K_PT;
-	pages += ((2 * vcpus * guest_percpu_mem_size) >> PAGE_SHIFT_4K) /
-		 PTES_PER_4K_PT;
-	pages = vm_adjust_num_guest_pages(mode, pages);
-
-	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
-
-	vm = vm_create(mode, pages, O_RDWR);
-	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
-#ifdef __x86_64__
-	vm_create_irqchip(vm);
-#endif
-	return vm;
-}
-
 static int handle_uffd_page_request(int uffd, uint64_t addr)
 {
 	pid_t tid;
@@ -368,43 +335,32 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct timespec start, end, ts_diff;
 	int *pipefds = NULL;
 	struct kvm_vm *vm;
+	uint64_t guest_percpu_pages;
 	uint64_t guest_num_pages;
 	int vcpu_id;
 	int r;
 
-	vm = create_vm(mode, nr_vcpus, guest_percpu_mem_size);
+	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
-	guest_page_size = vm_get_page_size(vm);
+	host_page_size = getpagesize();
+	guest_page_size = vm_guest_mode_params[mode].page_size;
 
-	TEST_ASSERT(guest_percpu_mem_size % guest_page_size == 0,
-		    "Guest memory size is not guest page size aligned.");
+	guest_percpu_pages = vm_calc_num_guest_pages(mode, guest_percpu_mem_size);
 
-	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) / guest_page_size;
-	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
+	TEST_ASSERT(guest_percpu_pages == guest_percpu_mem_size / guest_page_size,
+		    "Guest memory size is not aligned for guest pages size %ld, try %ld",
+		    guest_page_size, guest_percpu_pages * guest_page_size);
 
-	/*
-	 * If there should be more memory in the guest test region than there
-	 * can be pages in the guest, it will definitely cause problems.
-	 */
-	TEST_ASSERT(guest_num_pages < vm_get_max_gfn(vm),
-		    "Requested more guest memory than address space allows.\n"
-		    "    guest pages: %lx max gfn: %x vcpus: %d wss: %lx]\n",
-		    guest_num_pages, vm_get_max_gfn(vm), nr_vcpus,
-		    guest_percpu_mem_size);
+	guest_num_pages = nr_vcpus * guest_percpu_pages;
 
-	host_page_size = getpagesize();
-	TEST_ASSERT(guest_percpu_mem_size % host_page_size == 0,
-		    "Guest memory size is not host page size aligned.");
+	vm = vm_create_with_vcpus(mode, nr_vcpus, 0, guest_num_pages, guest_code, NULL);
 
-	guest_test_phys_mem = (vm_get_max_gfn(vm) - guest_num_pages) *
-			      guest_page_size;
+	guest_test_phys_mem = (vm_get_max_gfn(vm) - guest_num_pages) * guest_page_size;
 	guest_test_phys_mem &= ~(host_page_size - 1);
-
 #ifdef __s390x__
 	/* Align to 1M (segment size) */
 	guest_test_phys_mem &= ~((1 << 20) - 1);
 #endif
-
 	pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_mem);
 
 	/* Add an extra memory slot for testing demand paging */
@@ -442,8 +398,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		vm_paddr_t vcpu_gpa;
 		void *vcpu_hva;
 
-		vm_vcpu_add_default(vm, vcpu_id, guest_code);
-
 		vcpu_gpa = guest_test_phys_mem + (vcpu_id * guest_percpu_mem_size);
 		PER_VCPU_DEBUG("Added VCPU %d with test mem gpa [%lx, %lx)\n",
 			       vcpu_id, vcpu_gpa, vcpu_gpa + guest_percpu_mem_size);
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index f2710c6a60bf..4e7121ee160e 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -5,8 +5,6 @@
  * Copyright (C) 2018, Red Hat, Inc.
  */
 
-#define _GNU_SOURCE /* for program_invocation_name */
-
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
@@ -20,8 +18,6 @@
 #include "kvm_util.h"
 #include "processor.h"
 
-#define VCPU_ID				1
-
 /* The memory slot index to track dirty pages */
 #define TEST_MEM_SLOT_INDEX		1
 
@@ -181,9 +177,9 @@ static void clear_log_collect_dirty_pages(struct kvm_vm *vm, int slot,
 
 static void default_after_vcpu_run(struct kvm_vm *vm)
 {
-	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+	struct kvm_run *run = vcpu_state(vm, 0);
 
-	TEST_ASSERT(get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC,
+	TEST_ASSERT(get_ucall(vm, 0, NULL) == UCALL_SYNC,
 		    "Invalid guest sync status: exit_reason=%s\n",
 		    exit_reason_str(run->exit_reason));
 }
@@ -290,7 +286,7 @@ static void *vcpu_worker(void *data)
 		generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
 		pages_count += TEST_PAGES_PER_LOOP;
 		/* Let the guest dirty the random pages */
-		ret = _vcpu_run(vm, VCPU_ID);
+		ret = _vcpu_run(vm, 0);
 		TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
 		log_mode_after_vcpu_run(vm);
 	}
@@ -367,26 +363,7 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 	}
 }
 
-static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
-				uint64_t extra_mem_pages, void *guest_code)
-{
-	struct kvm_vm *vm;
-	uint64_t extra_pg_pages = extra_mem_pages / 512 * 2;
-
-	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
-
-	vm = vm_create(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages, O_RDWR);
-	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
-#ifdef __x86_64__
-	vm_create_irqchip(vm);
-#endif
-	log_mode_create_vm_done(vm);
-	vm_vcpu_add_default(vm, vcpuid, guest_code);
-	return vm;
-}
-
 #define DIRTY_MEM_BITS 30 /* 1G */
-#define PAGE_SHIFT_4K  12
 
 struct test_params {
 	unsigned long iterations;
@@ -407,43 +384,34 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		return;
 	}
 
-	/*
-	 * We reserve page table for 2 times of extra dirty mem which
-	 * will definitely cover the original (1G+) test range.  Here
-	 * we do the calculation with 4K page size which is the
-	 * smallest so the page number will be enough for all archs
-	 * (e.g., 64K page size guest will need even less memory for
-	 * page tables).
-	 */
-	vm = create_vm(mode, VCPU_ID,
-		       2ul << (DIRTY_MEM_BITS - PAGE_SHIFT_4K),
-		       guest_code);
+	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
+
+	host_page_size = getpagesize();
+	guest_page_size = vm_guest_mode_params[mode].page_size;
 
-	guest_page_size = vm_get_page_size(vm);
 	/*
 	 * A little more than 1G of guest page sized pages.  Cover the
 	 * case where the size is not aligned to 64 pages.
 	 */
-	guest_num_pages = (1ul << (DIRTY_MEM_BITS -
-				   vm_get_page_shift(vm))) + 3;
-	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
+	guest_num_pages = vm_adjust_num_guest_pages(mode,
+		(1ul << (DIRTY_MEM_BITS - vm_guest_mode_params[mode].page_shift)) + 3);
 
-	host_page_size = getpagesize();
 	host_num_pages = vm_num_host_pages(mode, guest_num_pages);
 
+	vm = vm_create_with_vcpus(mode, 1, guest_num_pages, 0, guest_code, NULL);
+
+	log_mode_create_vm_done(vm);
+
 	if (!p->phys_offset) {
-		guest_test_phys_mem = (vm_get_max_gfn(vm) -
-				       guest_num_pages) * guest_page_size;
+		guest_test_phys_mem = (vm_get_max_gfn(vm) - guest_num_pages) * guest_page_size;
 		guest_test_phys_mem &= ~(host_page_size - 1);
 	} else {
 		guest_test_phys_mem = p->phys_offset;
 	}
-
 #ifdef __s390x__
 	/* Align to 1M (segment size) */
 	guest_test_phys_mem &= ~((1 << 20) - 1);
 #endif
-
 	pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_mem);
 
 	bmap = bitmap_alloc(host_num_pages);
@@ -463,7 +431,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	host_test_mem = addr_gpa2hva(vm, (vm_paddr_t)guest_test_phys_mem);
 
 #ifdef __x86_64__
-	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+	vcpu_set_cpuid(vm, 0, kvm_get_supported_cpuid());
 #endif
 	ucall_init(vm, NULL);
 
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 0d652de57e6e..7ee4f7a85ef7 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -55,6 +55,15 @@ enum vm_guest_mode {
 #define vm_guest_mode_string(m) vm_guest_mode_string[m]
 extern const char * const vm_guest_mode_string[];
 
+struct vm_guest_mode_params {
+	unsigned int pa_bits;
+	unsigned int va_bits;
+	unsigned int page_size;
+	unsigned int page_shift;
+};
+
+extern const struct vm_guest_mode_params vm_guest_mode_params[];
+
 enum vm_mem_backing_src_type {
 	VM_MEM_SRC_ANONYMOUS,
 	VM_MEM_SRC_ANONYMOUS_THP,
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index e56ed247b71e..0660f583b683 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -115,14 +115,7 @@ const char * const vm_guest_mode_string[] = {
 _Static_assert(sizeof(vm_guest_mode_string)/sizeof(char *) == NUM_VM_MODES,
 	       "Missing new mode strings?");
 
-struct vm_guest_mode_params {
-	unsigned int pa_bits;
-	unsigned int va_bits;
-	unsigned int page_size;
-	unsigned int page_shift;
-};
-
-static const struct vm_guest_mode_params vm_guest_mode_params[] = {
+const struct vm_guest_mode_params vm_guest_mode_params[] = {
 	{ 52, 48,  0x1000, 12 },
 	{ 52, 48, 0x10000, 16 },
 	{ 48, 48,  0x1000, 12 },
-- 
2.26.2

