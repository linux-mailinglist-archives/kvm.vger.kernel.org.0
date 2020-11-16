Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A712B438C
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 13:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730037AbgKPMUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 07:20:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51119 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727027AbgKPMUL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 07:20:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605529209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z3dB1A4F6jUu+x55cPcjLWyvFz87Voio+XJYc/I6Kjk=;
        b=giuJQ3leB0dY5oxYOUzYxJHn6y43Zqz7zA4d1b0yYCGifRCOsdo7XiwsHWJAzskAiW9tIh
        ExVP7nElN1HWuNUAOR5lKMGuI4PnAno/H1chqZ4XpPzJ5+PiwmgD0jkU7k+qwWwwuLcfba
        C+5zVAnnPU+3UnaTSX8ghVMElP0tvM8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-41P5yTMKOv6nYmMnsGj0gg-1; Mon, 16 Nov 2020 07:20:07 -0500
X-MC-Unique: 41P5yTMKOv6nYmMnsGj0gg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75F7064144;
        Mon, 16 Nov 2020 12:20:06 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A3C2B60BF1;
        Mon, 16 Nov 2020 12:19:56 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
Subject: [PATCH v3 3/4] KVM: selftests: Use vm_create_with_vcpus in create_vm
Date:   Mon, 16 Nov 2020 13:19:41 +0100
Message-Id: <20201116121942.55031-4-drjones@redhat.com>
In-Reply-To: <20201116121942.55031-1-drjones@redhat.com>
References: <20201116121942.55031-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/demand_paging_test.c        |  2 +-
 .../selftests/kvm/dirty_log_perf_test.c       |  2 -
 .../testing/selftests/kvm/include/kvm_util.h  |  8 ++++
 .../selftests/kvm/include/perf_test_util.h    | 47 +++++--------------
 tools/testing/selftests/kvm/lib/kvm_util.c    |  9 +---
 5 files changed, 21 insertions(+), 47 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 946161a9ce2d..b0c41de32e9b 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -7,7 +7,7 @@
  * Copyright (C) 2019, Google, Inc.
  */
 
-#define _GNU_SOURCE /* for program_invocation_name and pipe2 */
+#define _GNU_SOURCE /* for pipe2 */
 
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 506741eb5d7f..36bea75a8d6f 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -8,8 +8,6 @@
  * Copyright (C) 2020, Google, Inc.
  */
 
-#define _GNU_SOURCE /* for program_invocation_name */
-
 #include <stdio.h>
 #include <stdlib.h>
 #include <time.h>
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index dfa9d369e8fc..149766ecd68b 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -70,6 +70,14 @@ enum vm_guest_mode {
 #define vm_guest_mode_string(m) vm_guest_mode_string[m]
 extern const char * const vm_guest_mode_string[];
 
+struct vm_guest_mode_params {
+	unsigned int pa_bits;
+	unsigned int va_bits;
+	unsigned int page_size;
+	unsigned int page_shift;
+};
+extern const struct vm_guest_mode_params vm_guest_mode_params[];
+
 enum vm_mem_backing_src_type {
 	VM_MEM_SRC_ANONYMOUS,
 	VM_MEM_SRC_ANONYMOUS_THP,
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index 239421e4f6b8..cd4c258f458d 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -13,9 +13,6 @@
 
 #define MAX_VCPUS 512
 
-#define PAGE_SHIFT_4K  12
-#define PTES_PER_4K_PT 512
-
 #define TEST_MEM_SLOT_INDEX		1
 
 /* Default guest test virtual memory offset */
@@ -94,41 +91,26 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, int vcpus,
 				uint64_t vcpu_memory_bytes)
 {
 	struct kvm_vm *vm;
-	uint64_t pages = DEFAULT_GUEST_PHY_PAGES;
 	uint64_t guest_num_pages;
 
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
-	pages += ((2 * vcpus * vcpu_memory_bytes) >> PAGE_SHIFT_4K) /
-		 PTES_PER_4K_PT;
-	pages = vm_adjust_num_guest_pages(mode, pages);
-
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
-	vm = vm_create(mode, pages, O_RDWR);
-	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
-#ifdef __x86_64__
-	vm_create_irqchip(vm);
-#endif
-
-	perf_test_args.vm = vm;
-	perf_test_args.guest_page_size = vm_get_page_size(vm);
 	perf_test_args.host_page_size = getpagesize();
+	perf_test_args.guest_page_size = vm_guest_mode_params[mode].page_size;
 
+	guest_num_pages = vm_adjust_num_guest_pages(mode,
+				(vcpus * vcpu_memory_bytes) / perf_test_args.guest_page_size);
+
+	TEST_ASSERT(vcpu_memory_bytes % perf_test_args.host_page_size == 0,
+		    "Guest memory size is not host page size aligned.");
 	TEST_ASSERT(vcpu_memory_bytes % perf_test_args.guest_page_size == 0,
 		    "Guest memory size is not guest page size aligned.");
 
-	guest_num_pages = (vcpus * vcpu_memory_bytes) /
-			  perf_test_args.guest_page_size;
-	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
+	vm = vm_create_with_vcpus(mode, vcpus,
+				  (vcpus * vcpu_memory_bytes) / perf_test_args.guest_page_size,
+				  0, guest_code, NULL);
+
+	perf_test_args.vm = vm;
 
 	/*
 	 * If there should be more memory in the guest test region than there
@@ -140,18 +122,13 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, int vcpus,
 		    guest_num_pages, vm_get_max_gfn(vm), vcpus,
 		    vcpu_memory_bytes);
 
-	TEST_ASSERT(vcpu_memory_bytes % perf_test_args.host_page_size == 0,
-		    "Guest memory size is not host page size aligned.");
-
 	guest_test_phys_mem = (vm_get_max_gfn(vm) - guest_num_pages) *
 			      perf_test_args.guest_page_size;
 	guest_test_phys_mem &= ~(perf_test_args.host_page_size - 1);
-
 #ifdef __s390x__
 	/* Align to 1M (segment size) */
 	guest_test_phys_mem &= ~((1 << 20) - 1);
 #endif
-
 	pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_mem);
 
 	/* Add an extra memory slot for testing */
@@ -177,8 +154,6 @@ static void add_vcpus(struct kvm_vm *vm, int vcpus, uint64_t vcpu_memory_bytes)
 	for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++) {
 		vcpu_args = &perf_test_args.vcpu_args[vcpu_id];
 
-		vm_vcpu_add_default(vm, vcpu_id, guest_code);
-
 		vcpu_args->vcpu_id = vcpu_id;
 		vcpu_args->gva = guest_test_virt_mem +
 				 (vcpu_id * vcpu_memory_bytes);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index b2c426adb87f..14fcadb778b5 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -153,14 +153,7 @@ const char * const vm_guest_mode_string[] = {
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

