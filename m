Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7AB152F56A
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 23:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353814AbiETV5x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 17:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353801AbiETV5t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 17:57:49 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CBC1A04BA
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 14:57:44 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id d12-20020a17090a628c00b001dcd2efca39so5280035pjj.2
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 14:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MemxomWyn3xFxsnJwUeubmFMBZbsEx+Q3Mj2FuHfdHM=;
        b=jIg4wQejIfsFzDii3julo8lQtz8/QfW2kBREynDCm0BR4iBLizMo5nn+goraWdAnTY
         NejYrb2NgjTC/K4fmkVsn9yTrSt8uFPNc+i3PbrRIx4ysDCpSKON40SKZk9SEUYApBIj
         wfam421KboPFvlXkDSYkUizjznNkoUO3e2/yJJlCTU/RUGWkd5cT+Lqu1PnHYXvOxOvC
         rHmgnCw6Bu1AGJO3BuGyYRlyVIkqS1wJFgTlTwXRF9k6MSLiuhXpfT439E3OYVd1BtuI
         wK6GlqPsNtb4r+4ic+DQv+/s5wX/E0PW32XhxkClG3ekBomxHkPtWJcejVo5hUMxfjie
         s4Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MemxomWyn3xFxsnJwUeubmFMBZbsEx+Q3Mj2FuHfdHM=;
        b=I9BbViirds24IFbvmSXRY4OE94Wj6gF+VWP6bA/UoHOv6O9JwzfXZ52jbQqcr1FD01
         7z2e5GH9Bw7ZAoYK48chwXOYolN+N55VCelCMrCQyM3wxOFu9a9n3+XbtjHXVt0Ac/mM
         gaTU67mKTMbDl/8fhkgN0dOBT3ljmay3Q1mp2h3aV4DPg/o87GTkepi8e0ZcUJA5t3w3
         9EbQzVZ9Zy9TWwUMmYJ387nQgTso5cZMK2CQXFMPcxMVt/goNWrJj6nldl2IkBmHx2OY
         egHE5UtnsK+6bpAFq2EyeEZ8xMOCcz1ww8Hhx7/uEdsaL7/XREh1H2cSjs6FPHLndCud
         JGFg==
X-Gm-Message-State: AOAM533YZ1qIA6x6/Z3opckYGAPSr+KR7HTDKgnceMIb1fW2mSAt90M8
        vfJKnKdiBZeHjI4P6A/AQzFPNQKTYSQihw==
X-Google-Smtp-Source: ABdhPJzOQzBi5jNUe4g4dzg8hffGCwHOodxSEdbGTNWeLXZKGJYvqasmJnMSeGuhZ1BV+xKcz0jWwctK4Lfjew==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:f605:b0:14d:9e11:c864 with SMTP
 id n5-20020a170902f60500b0014d9e11c864mr11705635plg.54.1653083864355; Fri, 20
 May 2022 14:57:44 -0700 (PDT)
Date:   Fri, 20 May 2022 21:57:23 +0000
In-Reply-To: <20220520215723.3270205-1-dmatlack@google.com>
Message-Id: <20220520215723.3270205-11-dmatlack@google.com>
Mime-Version: 1.0
References: <20220520215723.3270205-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v3 10/10] KVM: selftests: Add option to run
 dirty_log_perf_test vCPUs in L2
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>, Peter Xu <peterx@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        David Matlack <dmatlack@google.com>
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

Add an option to dirty_log_perf_test that configures the vCPUs to run in
L2 instead of L1. This makes it possible to benchmark the dirty logging
performance of nested virtualization, which is particularly interesting
because KVM must shadow L1's EPT/NPT tables.

For now this support only works on x86_64 CPUs with VMX. Otherwise
passing -n results in the test being skipped.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/dirty_log_perf_test.c       |  10 +-
 .../selftests/kvm/include/perf_test_util.h    |   9 ++
 .../selftests/kvm/include/x86_64/processor.h  |   4 +
 .../selftests/kvm/include/x86_64/vmx.h        |   4 +
 .../selftests/kvm/lib/perf_test_util.c        |  35 +++++-
 .../selftests/kvm/lib/x86_64/perf_test_util.c | 112 ++++++++++++++++++
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |  15 +++
 8 files changed, 182 insertions(+), 8 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/perf_test_util.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 83b9ffa456ea..42cb904f6e54 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -49,6 +49,7 @@ LIBKVM += lib/test_util.c
 
 LIBKVM_x86_64 += lib/x86_64/apic.c
 LIBKVM_x86_64 += lib/x86_64/handlers.S
+LIBKVM_x86_64 += lib/x86_64/perf_test_util.c
 LIBKVM_x86_64 += lib/x86_64/processor.c
 LIBKVM_x86_64 += lib/x86_64/svm.c
 LIBKVM_x86_64 += lib/x86_64/ucall.c
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 7b47ae4f952e..d60a34cdfaee 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -336,8 +336,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 static void help(char *name)
 {
 	puts("");
-	printf("usage: %s [-h] [-i iterations] [-p offset] [-g]"
-	       "[-m mode] [-b vcpu bytes] [-v vcpus] [-o] [-s mem type]"
+	printf("usage: %s [-h] [-i iterations] [-p offset] [-g] "
+	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-s mem type]"
 	       "[-x memslots]\n", name);
 	puts("");
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
@@ -351,6 +351,7 @@ static void help(char *name)
 	printf(" -p: specify guest physical test memory offset\n"
 	       "     Warning: a low offset can conflict with the loaded test code.\n");
 	guest_modes_help();
+	printf(" -n: Run the vCPUs in nested mode (L2)\n");
 	printf(" -b: specify the size of the memory region which should be\n"
 	       "     dirtied by each vCPU. e.g. 10M or 3G.\n"
 	       "     (default: 1G)\n");
@@ -387,7 +388,7 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "ghi:p:m:b:f:v:os:x:")) != -1) {
+	while ((opt = getopt(argc, argv, "ghi:p:m:nb:f:v:os:x:")) != -1) {
 		switch (opt) {
 		case 'g':
 			dirty_log_manual_caps = 0;
@@ -401,6 +402,9 @@ int main(int argc, char *argv[])
 		case 'm':
 			guest_modes_cmdline(optarg);
 			break;
+		case 'n':
+			perf_test_args.nested = true;
+			break;
 		case 'b':
 			guest_percpu_mem_size = parse_size(optarg);
 			break;
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index a86f953d8d36..d822cb670f1c 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -30,10 +30,15 @@ struct perf_test_vcpu_args {
 
 struct perf_test_args {
 	struct kvm_vm *vm;
+	/* The starting address and size of the guest test region. */
 	uint64_t gpa;
+	uint64_t size;
 	uint64_t guest_page_size;
 	int wr_fract;
 
+	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
+	bool nested;
+
 	struct perf_test_vcpu_args vcpu_args[KVM_MAX_VCPUS];
 };
 
@@ -49,5 +54,9 @@ void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract);
 
 void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
 void perf_test_join_vcpu_threads(int vcpus);
+void perf_test_guest_code(uint32_t vcpu_id);
+
+uint64_t perf_test_nested_pages(int nr_vcpus);
+void perf_test_setup_nested(struct kvm_vm *vm, int nr_vcpus);
 
 #endif /* SELFTEST_KVM_PERF_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 04f1d540bcb2..2aaea757432a 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -477,6 +477,10 @@ enum pg_level {
 #define PG_LEVEL_SHIFT(_level) ((_level - 1) * 9 + 12)
 #define PG_LEVEL_SIZE(_level) (1ull << PG_LEVEL_SHIFT(_level))
 
+#define PG_SIZE_4K PG_LEVEL_SIZE(PG_LEVEL_4K)
+#define PG_SIZE_2M PG_LEVEL_SIZE(PG_LEVEL_2M)
+#define PG_SIZE_1G PG_LEVEL_SIZE(PG_LEVEL_1G)
+
 void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level);
 
 /*
diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index 3b1794baa97c..cc3604f8f1d3 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -96,6 +96,7 @@
 #define VMX_MISC_PREEMPTION_TIMER_RATE_MASK	0x0000001f
 #define VMX_MISC_SAVE_EFER_LMA			0x00000020
 
+#define VMX_EPT_VPID_CAP_1G_PAGES		0x00020000
 #define VMX_EPT_VPID_CAP_AD_BITS		0x00200000
 
 #define EXIT_REASON_FAILED_VMENTRY	0x80000000
@@ -608,6 +609,7 @@ bool load_vmcs(struct vmx_pages *vmx);
 
 bool nested_vmx_supported(void);
 void nested_vmx_check_supported(void);
+bool ept_1g_pages_supported(void);
 
 void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 		   uint64_t nested_paddr, uint64_t paddr);
@@ -615,6 +617,8 @@ void nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 		 uint64_t nested_paddr, uint64_t paddr, uint64_t size);
 void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
 			uint32_t memslot);
+void nested_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
+			    uint64_t addr, uint64_t size);
 void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
 		  uint32_t eptp_memslot);
 void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 722df3a28791..b2ff2cee2e51 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -40,7 +40,7 @@ static bool all_vcpu_threads_running;
  * Continuously write to the first 8 bytes of each page in the
  * specified region.
  */
-static void guest_code(uint32_t vcpu_id)
+void perf_test_guest_code(uint32_t vcpu_id)
 {
 	struct perf_test_args *pta = &perf_test_args;
 	struct perf_test_vcpu_args *vcpu_args = &pta->vcpu_args[vcpu_id];
@@ -108,7 +108,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 {
 	struct perf_test_args *pta = &perf_test_args;
 	struct kvm_vm *vm;
-	uint64_t guest_num_pages;
+	uint64_t guest_num_pages, slot0_pages = DEFAULT_GUEST_PHY_PAGES;
 	uint64_t backing_src_pagesz = get_backing_src_pagesz(backing_src);
 	int i;
 
@@ -134,13 +134,20 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 		    "Guest memory cannot be evenly divided into %d slots.",
 		    slots);
 
+	/*
+	 * If using nested, allocate extra pages for the nested page tables and
+	 * in-memory data structures.
+	 */
+	if (pta->nested)
+		slot0_pages += perf_test_nested_pages(vcpus);
+
 	/*
 	 * Pass guest_num_pages to populate the page tables for test memory.
 	 * The memory is also added to memslot 0, but that's a benign side
 	 * effect as KVM allows aliasing HVAs in meslots.
 	 */
-	vm = vm_create_with_vcpus(mode, vcpus, DEFAULT_GUEST_PHY_PAGES,
-				  guest_num_pages, 0, guest_code, NULL);
+	vm = vm_create_with_vcpus(mode, vcpus, slot0_pages, guest_num_pages, 0,
+				  perf_test_guest_code, NULL);
 
 	pta->vm = vm;
 
@@ -161,7 +168,9 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 	/* Align to 1M (segment size) */
 	pta->gpa = align_down(pta->gpa, 1 << 20);
 #endif
-	pr_info("guest physical test memory offset: 0x%lx\n", pta->gpa);
+	pta->size = guest_num_pages * pta->guest_page_size;
+	pr_info("guest physical test memory: [0x%lx, 0x%lx)\n",
+		pta->gpa, pta->gpa + pta->size);
 
 	/* Add extra memory slots for testing */
 	for (i = 0; i < slots; i++) {
@@ -178,6 +187,11 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 
 	perf_test_setup_vcpus(vm, vcpus, vcpu_memory_bytes, partition_vcpu_memory_access);
 
+	if (pta->nested) {
+		pr_info("Configuring vCPUs to run in L2 (nested).\n");
+		perf_test_setup_nested(vm, vcpus);
+	}
+
 	ucall_init(vm, NULL);
 
 	/* Export the shared variables to the guest. */
@@ -198,6 +212,17 @@ void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract)
 	sync_global_to_guest(vm, perf_test_args);
 }
 
+uint64_t __weak perf_test_nested_pages(int nr_vcpus)
+{
+	return 0;
+}
+
+void __weak perf_test_setup_nested(struct kvm_vm *vm, int nr_vcpus)
+{
+	pr_info("%s() not support on this architecture, skipping.\n", __func__);
+	exit(KSFT_SKIP);
+}
+
 static void *vcpu_thread_main(void *data)
 {
 	struct vcpu_thread *vcpu = data;
diff --git a/tools/testing/selftests/kvm/lib/x86_64/perf_test_util.c b/tools/testing/selftests/kvm/lib/x86_64/perf_test_util.c
new file mode 100644
index 000000000000..e258524435a0
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/x86_64/perf_test_util.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * x86_64-specific extensions to perf_test_util.c.
+ *
+ * Copyright (C) 2022, Google, Inc.
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <linux/bitmap.h>
+#include <linux/bitops.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "perf_test_util.h"
+#include "../kvm_util_internal.h"
+#include "processor.h"
+#include "vmx.h"
+
+void perf_test_l2_guest_code(uint64_t vcpu_id)
+{
+	perf_test_guest_code(vcpu_id);
+	vmcall();
+}
+
+extern char perf_test_l2_guest_entry[];
+__asm__(
+"perf_test_l2_guest_entry:"
+"	mov (%rsp), %rdi;"
+"	call perf_test_l2_guest_code;"
+"	ud2;"
+);
+
+static void perf_test_l1_guest_code(struct vmx_pages *vmx, uint64_t vcpu_id)
+{
+#define L2_GUEST_STACK_SIZE 64
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	unsigned long *rsp;
+
+	GUEST_ASSERT(vmx->vmcs_gpa);
+	GUEST_ASSERT(prepare_for_vmx_operation(vmx));
+	GUEST_ASSERT(load_vmcs(vmx));
+	GUEST_ASSERT(ept_1g_pages_supported());
+
+	rsp = &l2_guest_stack[L2_GUEST_STACK_SIZE - 1];
+	*rsp = vcpu_id;
+	prepare_vmcs(vmx, perf_test_l2_guest_entry, rsp);
+
+	GUEST_ASSERT(!vmlaunch());
+	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
+	GUEST_DONE();
+}
+
+uint64_t perf_test_nested_pages(int nr_vcpus)
+{
+	/*
+	 * 513 page tables is enough to identity-map 256 TiB of L2 with 1G
+	 * pages and 4-level paging, plus a few pages per-vCPU for data
+	 * structures such as the VMCS.
+	 */
+	return 513 + 10 * nr_vcpus;
+}
+
+void perf_test_setup_ept(struct vmx_pages *vmx, struct kvm_vm *vm)
+{
+	uint64_t start, end;
+
+	prepare_eptp(vmx, vm, 0);
+
+	/*
+	 * Identity map the first 4G and the test region with 1G pages so that
+	 * KVM can shadow the EPT12 with the maximum huge page size supported
+	 * by the backing source.
+	 */
+	nested_identity_map_1g(vmx, vm, 0, 0x100000000ULL);
+
+	start = align_down(perf_test_args.gpa, PG_SIZE_1G);
+	end = align_up(perf_test_args.gpa + perf_test_args.size, PG_SIZE_1G);
+	nested_identity_map_1g(vmx, vm, start, end - start);
+}
+
+void perf_test_setup_nested(struct kvm_vm *vm, int nr_vcpus)
+{
+	struct vmx_pages *vmx, *vmx0 = NULL;
+	struct kvm_regs regs;
+	vm_vaddr_t vmx_gva;
+	int vcpu_id;
+
+	nested_vmx_check_supported();
+
+	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
+		vmx = vcpu_alloc_vmx(vm, &vmx_gva);
+
+		if (vcpu_id == 0) {
+			perf_test_setup_ept(vmx, vm);
+			vmx0 = vmx;
+		} else {
+			/* Share the same EPT table across all vCPUs. */
+			vmx->eptp = vmx0->eptp;
+			vmx->eptp_hva = vmx0->eptp_hva;
+			vmx->eptp_gpa = vmx0->eptp_gpa;
+		}
+
+		/*
+		 * Override the vCPU to run perf_test_l1_guest_code() which will
+		 * bounce it into L2 before calling perf_test_guest_code().
+		 */
+		vcpu_regs_get(vm, vcpu_id, &regs);
+		regs.rip = (unsigned long) perf_test_l1_guest_code;
+		vcpu_regs_set(vm, vcpu_id, &regs);
+		vcpu_args_set(vm, vcpu_id, 2, vmx_gva, vcpu_id);
+	}
+}
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index 5bf169179455..b77a01d0a271 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -203,6 +203,11 @@ static bool ept_vpid_cap_supported(uint64_t mask)
 	return rdmsr(MSR_IA32_VMX_EPT_VPID_CAP) & mask;
 }
 
+bool ept_1g_pages_supported(void)
+{
+	return ept_vpid_cap_supported(VMX_EPT_VPID_CAP_1G_PAGES);
+}
+
 /*
  * Initialize the control fields to the most basic settings possible.
  */
@@ -439,6 +444,9 @@ void __nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
 		    "unknown or unsupported guest mode, mode: 0x%x", vm->mode);
 
+	TEST_ASSERT((nested_paddr >> 48) == 0,
+		    "Nested physical address 0x%lx requires 5-level paging",
+		    nested_paddr);
 	TEST_ASSERT((nested_paddr % page_size) == 0,
 		    "Nested physical address not on page boundary,\n"
 		    "  nested_paddr: 0x%lx page_size: 0x%lx",
@@ -547,6 +555,13 @@ void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
 	}
 }
 
+/* Identity map a region with 1GiB Pages. */
+void nested_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
+			    uint64_t addr, uint64_t size)
+{
+	__nested_map(vmx, vm, addr, addr, size, PG_LEVEL_1G);
+}
+
 void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
 		  uint32_t eptp_memslot)
 {
-- 
2.36.1.124.g0e6072fb45-goog

