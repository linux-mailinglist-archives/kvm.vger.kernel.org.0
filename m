Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D2852AB7D
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 21:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351442AbiEQTFr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 15:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352516AbiEQTFo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 15:05:44 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64896E8
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 12:05:42 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id p18-20020aa78612000000b0050d1c170018so8107803pfn.15
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 12:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GHdmigCWoJn3h4Ms4W+5m3/D0YUe4bVjbE0mjuDmz4c=;
        b=LBJ5sDo39urAAyFbQznRrEIDfZqGo9Dc1xuE9faD1aR1ha6Xf2o2146NiI8CeYtU+R
         29U2uKKZ95LgRHdAnv7qz9eTHNKUVP1jsGWZ3Bo2gFkYzv2JhbpfKGw8srmzZjvEYw0e
         wx9EvArrvIwCPEtkAyh9FFkwCGSQUq2qRGQN3HJRzGmyin/BlRai+cZDoJv+r6VN2o3m
         j9RgPYYsOhNxeQVMTU/iZff7D92wfjHrQTJEFBnHqhqb+KWVT/0ZNIL9jyjnT/EEaraY
         5CwZRuAe2mpIVe0hiUDFbGCv1INpF0HQX/IUTjyie/vRgenvqpYL6kKN3EWQgaIV5Nhl
         I8aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GHdmigCWoJn3h4Ms4W+5m3/D0YUe4bVjbE0mjuDmz4c=;
        b=Xyp9tdRkcz2gRDslBhCUQcyeTRTTW7XKeSisdeLi7x0EzdnlT6QdnH9inNTVcKa0H3
         7en2I97YWcpbykDzhyfcdxWldtwjNxuWTNc+BrHwVahhdz5/02aO1I94DfTD19lOdGeO
         kN6q/apdu0x9VAILa3nmcvqO6Bae4R6ETpkGu+OK94NN2PGLDjy8PaLs/hL15J57KKyu
         ljqoXMF8UzcbXb2HW2HvRIJ+IHXy3dfe9fTCM/zW2UsEh/yn9rO2r3RNUjnCZ42GVD8+
         VjLgDGxazk74Zm8wm9WOD7a+3dBUpxhePHW2jCuT6Weso64F6x+kbde3lRD/lRg2xMzp
         xn+w==
X-Gm-Message-State: AOAM5309efIq3JTgD4ei1t7QXYpoBdyU2SXuMVnkr7RsZAGKF6DVJ6G8
        vX1NjuzCG15eiTE6zfrVfdgqRtLt3aegDw==
X-Google-Smtp-Source: ABdhPJw/FK+Fd3N51diYnp8p8PGn0SqQOGLLFv/Egk451j9l/GMqByWbwhBhSoKvj/dox+aNmy1zNXT9E3Ejvg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a65:5bcc:0:b0:3c5:fff8:a6a6 with SMTP id
 o12-20020a655bcc000000b003c5fff8a6a6mr20979273pgr.48.1652814341850; Tue, 17
 May 2022 12:05:41 -0700 (PDT)
Date:   Tue, 17 May 2022 19:05:24 +0000
In-Reply-To: <20220517190524.2202762-1-dmatlack@google.com>
Message-Id: <20220517190524.2202762-11-dmatlack@google.com>
Mime-Version: 1.0
References: <20220517190524.2202762-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v2 10/10] KVM: selftests: Add option to run
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
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../selftests/kvm/dirty_log_perf_test.c       | 10 +-
 .../selftests/kvm/include/perf_test_util.h    |  7 ++
 .../selftests/kvm/include/x86_64/vmx.h        |  3 +
 .../selftests/kvm/lib/perf_test_util.c        | 29 +++++-
 .../selftests/kvm/lib/x86_64/perf_test_util.c | 98 +++++++++++++++++++
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  | 13 +++
 7 files changed, 154 insertions(+), 7 deletions(-)
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
index a86f953d8d36..b6c1770ab831 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -34,6 +34,9 @@ struct perf_test_args {
 	uint64_t guest_page_size;
 	int wr_fract;
 
+	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
+	bool nested;
+
 	struct perf_test_vcpu_args vcpu_args[KVM_MAX_VCPUS];
 };
 
@@ -49,5 +52,9 @@ void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract);
 
 void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
 void perf_test_join_vcpu_threads(int vcpus);
+void perf_test_guest_code(uint32_t vcpu_id);
+
+uint64_t perf_test_nested_pages(int nr_vcpus);
+void perf_test_setup_nested(struct kvm_vm *vm, int nr_vcpus);
 
 #endif /* SELFTEST_KVM_PERF_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index 3b1794baa97c..17d712503a36 100644
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
@@ -615,6 +617,7 @@ void nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 		 uint64_t nested_paddr, uint64_t paddr, uint64_t size);
 void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
 			uint32_t memslot);
+void nested_map_all_1g(struct vmx_pages *vmx, struct kvm_vm *vm);
 void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
 		  uint32_t eptp_memslot);
 void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 722df3a28791..530be01706d5 100644
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
 
@@ -178,6 +185,9 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 
 	perf_test_setup_vcpus(vm, vcpus, vcpu_memory_bytes, partition_vcpu_memory_access);
 
+	if (pta->nested)
+		perf_test_setup_nested(vm, vcpus);
+
 	ucall_init(vm, NULL);
 
 	/* Export the shared variables to the guest. */
@@ -198,6 +208,17 @@ void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract)
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
index 000000000000..472e7d5a182b
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/x86_64/perf_test_util.c
@@ -0,0 +1,98 @@
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
+	 * 513 page tables to identity-map the L2 with 1G pages, plus a few
+	 * pages per-vCPU for data structures such as the VMCS.
+	 */
+	return 513 + 10 * nr_vcpus;
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
+			prepare_eptp(vmx, vm, 0);
+			/*
+			 * Identity map L2 with 1G pages so that KVM can shadow
+			 * the EPT12 with huge pages.
+			 */
+			nested_map_all_1g(vmx, vm);
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
index 5bf169179455..9858e56370cb 100644
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
@@ -547,6 +552,14 @@ void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
 	}
 }
 
+/* Identity map the entire guest physical address space with 1GiB Pages. */
+void nested_map_all_1g(struct vmx_pages *vmx, struct kvm_vm *vm)
+{
+	uint64_t gpa_size = (vm->max_gfn + 1) << vm->page_shift;
+
+	__nested_map(vmx, vm, 0, 0, gpa_size, PG_LEVEL_1G);
+}
+
 void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
 		  uint32_t eptp_memslot)
 {
-- 
2.36.0.550.gb090851708-goog

