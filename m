Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 596D953E2DE
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 10:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbiFFIjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 04:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbiFFIiU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 04:38:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4F91E3193B
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 01:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654504696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QE5pmMQh/qdd7pww8s8lKL+IxDdk9jxMj58QpCmQwsQ=;
        b=F0Zs/AIM1Kqeqe2yUmt1eGJDGQuH4NkIVMN4hglb7uuctTX4NuOCzNZhixcBGJjvve9eQP
        gz8ZyvDvk5Gp+4EWjfmAqCJC3W7/CjnKIzhZfmRb7/cHRFlnAWj0LRj9JHT9BcUTRj8xMc
        JJcX42iED7z2mYZduPgxDXAXrulH1Xw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-418-X3oHywdEPNq-mHptzYsH7Q-1; Mon, 06 Jun 2022 04:38:11 -0400
X-MC-Unique: X3oHywdEPNq-mHptzYsH7Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4662D185A7A4;
        Mon,  6 Jun 2022 08:38:11 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.193.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32BD71121314;
        Mon,  6 Jun 2022 08:38:09 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 31/38] KVM: selftests: Hyper-V PV TLB flush selftest
Date:   Mon,  6 Jun 2022 10:36:48 +0200
Message-Id: <20220606083655.2014609-32-vkuznets@redhat.com>
In-Reply-To: <20220606083655.2014609-1-vkuznets@redhat.com>
References: <20220606083655.2014609-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a selftest for Hyper-V PV TLB flush hypercalls
(HvFlushVirtualAddressSpace/HvFlushVirtualAddressSpaceEx,
HvFlushVirtualAddressList/HvFlushVirtualAddressListEx).

The test creates one 'sender' vCPU and two 'worker' vCPU which do busy
loop reading from a certain GVA checking the observed value. Sender
vCPU drops to the host to swap the data page with another page filled
with a different value. The expectation for workers is also
altered. Without TLB flush on worker vCPUs, they may continue to
observe old value. To guard against accidental TLB flushes for worker
vCPUs the test is repeated 100 times.

Hyper-V TLB flush hypercalls are tested in both 'normal' and 'XMM
fast' modes.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/hyperv.h     |   1 +
 .../selftests/kvm/x86_64/hyperv_tlb_flush.c   | 660 ++++++++++++++++++
 4 files changed, 663 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 19a8454e3760..7f086656f3e0 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -26,6 +26,7 @@
 /x86_64/hyperv_features
 /x86_64/hyperv_ipi
 /x86_64/hyperv_svm_test
+/x86_64/hyperv_tlb_flush
 /x86_64/max_vcpuid_cap_test
 /x86_64/mmio_warning_test
 /x86_64/mmu_role_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index cf433073fb64..1e61ccc0da4d 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -54,6 +54,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_features
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_ipi
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_svm_test
+TEST_GEN_PROGS_x86_64 += x86_64/hyperv_tlb_flush
 TEST_GEN_PROGS_x86_64 += x86_64/kvm_clock_test
 TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
 TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
index 1b467626be58..c302027fa6d5 100644
--- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
+++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
@@ -187,6 +187,7 @@
 /* hypercall options */
 #define HV_HYPERCALL_FAST_BIT		BIT(16)
 #define HV_HYPERCALL_VARHEAD_OFFSET	17
+#define HV_HYPERCALL_REP_COMP_OFFSET	32
 
 static inline u64 hyperv_hypercall(u64 control, vm_vaddr_t input_address,
 			   vm_vaddr_t output_address)
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c b/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c
new file mode 100644
index 000000000000..d23e40d3b480
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c
@@ -0,0 +1,660 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Hyper-V HvFlushVirtualAddress{List,Space}{,Ex} tests
+ *
+ * Copyright (C) 2022, Red Hat, Inc.
+ *
+ */
+
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <pthread.h>
+#include <inttypes.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "hyperv.h"
+#include "test_util.h"
+#include "vmx.h"
+
+#define SENDER_VCPU_ID   1
+#define WORKER_VCPU_ID_1 2
+#define WORKER_VCPU_ID_2 65
+
+#define NTRY 100
+#define NTEST_PAGES 2
+
+struct thread_params {
+	struct kvm_vm *vm;
+	uint32_t vcpu_id;
+};
+
+struct hv_vpset {
+	u64 format;
+	u64 valid_bank_mask;
+	u64 bank_contents[];
+};
+
+enum HV_GENERIC_SET_FORMAT {
+	HV_GENERIC_SET_SPARSE_4K,
+	HV_GENERIC_SET_ALL,
+};
+
+#define HV_FLUSH_ALL_PROCESSORS			BIT(0)
+#define HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES	BIT(1)
+#define HV_FLUSH_NON_GLOBAL_MAPPINGS_ONLY	BIT(2)
+#define HV_FLUSH_USE_EXTENDED_RANGE_FORMAT	BIT(3)
+
+/* HvFlushVirtualAddressSpace, HvFlushVirtualAddressList hypercalls */
+struct hv_tlb_flush {
+	u64 address_space;
+	u64 flags;
+	u64 processor_mask;
+	u64 gva_list[];
+} __packed;
+
+/* HvFlushVirtualAddressSpaceEx, HvFlushVirtualAddressListEx hypercalls */
+struct hv_tlb_flush_ex {
+	u64 address_space;
+	u64 flags;
+	struct hv_vpset hv_vp_set;
+	u64 gva_list[];
+} __packed;
+
+/*
+ * Pass the following info to 'workers' and 'sender'
+ * - Hypercall page's GVA
+ * - Hypercall page's GPA
+ * - Test pages GVA
+ * - GVAs of the test pages' PTEs
+ */
+struct test_data {
+	vm_vaddr_t hcall_gva;
+	vm_paddr_t hcall_gpa;
+	vm_vaddr_t test_pages;
+	vm_vaddr_t test_pages_pte[NTEST_PAGES];
+};
+
+/* 'Worker' vCPU code checking the contents of the test page */
+static void worker_guest_code(vm_vaddr_t test_data)
+{
+	struct test_data *data = (struct test_data *)test_data;
+	u32 vcpu_id = rdmsr(HV_X64_MSR_VP_INDEX);
+	unsigned char chr_exp1, chr_exp2, chr_cur;
+
+	x2apic_enable();
+	wrmsr(HV_X64_MSR_GUEST_OS_ID, HYPERV_LINUX_OS_ID);
+
+	for (;;) {
+		/* Read the expected char, then check what's in the test pages and then
+		 * check the expectation again to make sure it wasn't updated in the meantime.
+		 */
+		chr_exp1 = READ_ONCE(*(unsigned char *)
+				     (data->test_pages + PAGE_SIZE * NTEST_PAGES + vcpu_id));
+		asm volatile("lfence");
+		chr_cur = *(unsigned char *)data->test_pages;
+		asm volatile("lfence");
+		chr_exp2 = READ_ONCE(*(unsigned char *)
+				     (data->test_pages + PAGE_SIZE * NTEST_PAGES + vcpu_id));
+		if (chr_exp1 && chr_exp1 == chr_exp2)
+			GUEST_ASSERT(chr_cur == chr_exp1);
+		asm volatile("nop");
+	}
+}
+
+/*
+ * Write per-CPU info indicating what each 'worker' CPU is supposed to see in
+ * test page. '0' means don't check.
+ */
+static void set_expected_char(void *addr, unsigned char chr, int vcpu_id)
+{
+	asm volatile("mfence");
+	*(unsigned char *)(addr + NTEST_PAGES * PAGE_SIZE + vcpu_id) = chr;
+}
+
+/* Update PTEs swapping two test pages */
+static void swap_two_test_pages(vm_paddr_t pte_gva1, vm_paddr_t pte_gva2)
+{
+	uint64_t pte[2];
+
+	pte[0] = *(uint64_t *)pte_gva1;
+	pte[1] = *(uint64_t *)pte_gva2;
+
+	*(uint64_t *)pte_gva1 = pte[1];
+	*(uint64_t *)pte_gva2 = pte[0];
+}
+
+/* Delay */
+static inline void rep_nop(void)
+{
+	int i;
+
+	for (i = 0; i < 1000000; i++)
+		asm volatile("nop");
+}
+
+/*
+ * Prepare to test: 'disable' workers by setting the expectation to '0',
+ * clear hypercall input page and then swap two test pages.
+ */
+static inline void prepare_to_test(struct test_data *data)
+{
+	/* Clear hypercall input page */
+	memset((void *)data->hcall_gva, 0, PAGE_SIZE);
+
+	/* 'Disable' workers */
+	set_expected_char((void *)data->test_pages, 0x0, WORKER_VCPU_ID_1);
+	set_expected_char((void *)data->test_pages, 0x0, WORKER_VCPU_ID_2);
+
+	/* Make sure workers have enough time to notice */
+	asm volatile("mfence");
+	rep_nop();
+
+	/* Swap test page mappings */
+	swap_two_test_pages(data->test_pages_pte[0], data->test_pages_pte[1]);
+}
+
+/*
+ * Finalize the test: check hypercall resule set the expected char for
+ * 'worker' CPUs and give them some time to test.
+ */
+static inline void post_test(struct test_data *data, u64 res,
+			     char exp_char1, char exp_char2)
+{
+	/* Check hypercall return code */
+	GUEST_ASSERT((res & 0xffff) == 0);
+
+	/* Set the expectation for workers, '0' means don't test */
+	set_expected_char((void *)data->test_pages, exp_char1, WORKER_VCPU_ID_1);
+	set_expected_char((void *)data->test_pages, exp_char2, WORKER_VCPU_ID_2);
+
+	/* Make sure workers have enough time to test */
+	asm volatile("mfence");
+	rep_nop();
+}
+
+/* Main vCPU doing the test */
+static void sender_guest_code(vm_vaddr_t test_data)
+{
+	struct test_data *data = (struct test_data *)test_data;
+	struct hv_tlb_flush *flush = (struct hv_tlb_flush *)data->hcall_gva;
+	struct hv_tlb_flush_ex *flush_ex = (struct hv_tlb_flush_ex *)data->hcall_gva;
+	vm_paddr_t hcall_gpa = data->hcall_gpa;
+	u64 res;
+	int i, stage = 1;
+
+	wrmsr(HV_X64_MSR_GUEST_OS_ID, HYPERV_LINUX_OS_ID);
+	wrmsr(HV_X64_MSR_HYPERCALL, data->hcall_gpa);
+
+	/* "Slow" hypercalls */
+
+	GUEST_SYNC(stage++);
+
+	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE for WORKER_VCPU_ID_1 */
+	for (i = 0; i < NTRY; i++) {
+		prepare_to_test(data);
+		flush->flags = HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES;
+		flush->processor_mask = BIT(WORKER_VCPU_ID_1);
+		res = hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE, hcall_gpa,
+				       hcall_gpa + PAGE_SIZE);
+		post_test(data, res, i % 2 ? 0x1 : 0x2, 0x0);
+	}
+
+	GUEST_SYNC(stage++);
+
+	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST for WORKER_VCPU_ID_1 */
+	for (i = 0; i < NTRY; i++) {
+		prepare_to_test(data);
+		flush->flags = HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES;
+		flush->processor_mask = BIT(WORKER_VCPU_ID_1);
+		flush->gva_list[0] = (u64)data->test_pages;
+		res = hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST |
+				       (1UL << HV_HYPERCALL_REP_COMP_OFFSET),
+				       hcall_gpa, hcall_gpa + PAGE_SIZE);
+		post_test(data, res, i % 2 ? 0x1 : 0x2, 0x0);
+	}
+
+	GUEST_SYNC(stage++);
+
+	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE for HV_FLUSH_ALL_PROCESSORS */
+	for (i = 0; i < NTRY; i++) {
+		prepare_to_test(data);
+		flush->flags = HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES | HV_FLUSH_ALL_PROCESSORS;
+		flush->processor_mask = 0;
+		res = hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE, hcall_gpa,
+				       hcall_gpa + PAGE_SIZE);
+		post_test(data, res, i % 2 ? 0x1 : 0x2, i % 2 ? 0x1 : 0x2);
+	}
+
+	GUEST_SYNC(stage++);
+
+	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST for HV_FLUSH_ALL_PROCESSORS */
+	for (i = 0; i < NTRY; i++) {
+		prepare_to_test(data);
+		flush->flags = HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES | HV_FLUSH_ALL_PROCESSORS;
+		flush->gva_list[0] = (u64)data->test_pages;
+		res = hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST |
+				       (1UL << HV_HYPERCALL_REP_COMP_OFFSET),
+				       hcall_gpa, hcall_gpa + PAGE_SIZE);
+		post_test(data, res, i % 2 ? 0x1 : 0x2, i % 2 ? 0x1 : 0x2);
+	}
+
+	GUEST_SYNC(stage++);
+
+	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX for WORKER_VCPU_ID_2 */
+	for (i = 0; i < NTRY; i++) {
+		prepare_to_test(data);
+		flush_ex->flags = HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES;
+		flush_ex->hv_vp_set.format = HV_GENERIC_SET_SPARSE_4K;
+		flush_ex->hv_vp_set.valid_bank_mask = BIT_ULL(WORKER_VCPU_ID_2 / 64);
+		flush_ex->hv_vp_set.bank_contents[0] = BIT_ULL(WORKER_VCPU_ID_2 % 64);
+		res = hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX |
+				       (1 << HV_HYPERCALL_VARHEAD_OFFSET),
+				       hcall_gpa, hcall_gpa + PAGE_SIZE);
+		post_test(data, res, 0x0, i % 2 ? 0x1 : 0x2);
+	}
+
+	GUEST_SYNC(stage++);
+
+	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX for WORKER_VCPU_ID_2 */
+	for (i = 0; i < NTRY; i++) {
+		prepare_to_test(data);
+		flush_ex->flags = HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES;
+		flush_ex->hv_vp_set.format = HV_GENERIC_SET_SPARSE_4K;
+		flush_ex->hv_vp_set.valid_bank_mask = BIT_ULL(WORKER_VCPU_ID_2 / 64);
+		flush_ex->hv_vp_set.bank_contents[0] = BIT_ULL(WORKER_VCPU_ID_2 % 64);
+		/* bank_contents and gva_list occupy the same space, thus [1] */
+		flush_ex->gva_list[1] = (u64)data->test_pages;
+		res = hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX |
+				       (1 << HV_HYPERCALL_VARHEAD_OFFSET) |
+				       (1UL << HV_HYPERCALL_REP_COMP_OFFSET),
+				       hcall_gpa, hcall_gpa + PAGE_SIZE);
+		post_test(data, res, 0x0, i % 2 ? 0x1 : 0x2);
+	}
+
+	GUEST_SYNC(stage++);
+
+	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX for both vCPUs */
+	for (i = 0; i < NTRY; i++) {
+		prepare_to_test(data);
+		flush_ex->flags = HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES;
+		flush_ex->hv_vp_set.format = HV_GENERIC_SET_SPARSE_4K;
+		flush_ex->hv_vp_set.valid_bank_mask = BIT_ULL(WORKER_VCPU_ID_2 / 64) |
+			BIT_ULL(WORKER_VCPU_ID_1 / 64);
+		flush_ex->hv_vp_set.bank_contents[0] = BIT_ULL(WORKER_VCPU_ID_1 % 64);
+		flush_ex->hv_vp_set.bank_contents[1] = BIT_ULL(WORKER_VCPU_ID_2 % 64);
+		res = hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX |
+				       (2 << HV_HYPERCALL_VARHEAD_OFFSET),
+				       hcall_gpa, hcall_gpa + PAGE_SIZE);
+		post_test(data, res, i % 2 ? 0x1 : 0x2, i % 2 ? 0x1 : 0x2);
+	}
+
+	GUEST_SYNC(stage++);
+
+	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX for both vCPUs */
+	for (i = 0; i < NTRY; i++) {
+		prepare_to_test(data);
+		flush_ex->flags = HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES;
+		flush_ex->hv_vp_set.format = HV_GENERIC_SET_SPARSE_4K;
+		flush_ex->hv_vp_set.valid_bank_mask = BIT_ULL(WORKER_VCPU_ID_1 / 64) |
+			BIT_ULL(WORKER_VCPU_ID_2 / 64);
+		flush_ex->hv_vp_set.bank_contents[0] = BIT_ULL(WORKER_VCPU_ID_1 % 64);
+		flush_ex->hv_vp_set.bank_contents[1] = BIT_ULL(WORKER_VCPU_ID_2 % 64);
+		/* bank_contents and gva_list occupy the same space, thus [2] */
+		flush_ex->gva_list[2] = (u64)data->test_pages;
+		res = hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX |
+				       (2 << HV_HYPERCALL_VARHEAD_OFFSET) |
+				       (1UL << HV_HYPERCALL_REP_COMP_OFFSET),
+				       hcall_gpa, hcall_gpa + PAGE_SIZE);
+		post_test(data, res, i % 2 ? 0x1 : 0x2, i % 2 ? 0x1 : 0x2);
+	}
+
+	GUEST_SYNC(stage++);
+
+	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX for HV_GENERIC_SET_ALL */
+	for (i = 0; i < NTRY; i++) {
+		prepare_to_test(data);
+		flush_ex->flags = HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES;
+		flush_ex->hv_vp_set.format = HV_GENERIC_SET_ALL;
+		res = hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX,
+				       hcall_gpa, hcall_gpa + PAGE_SIZE);
+		post_test(data, res, i % 2 ? 0x1 : 0x2, i % 2 ? 0x1 : 0x2);
+	}
+
+	GUEST_SYNC(stage++);
+
+	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX for HV_GENERIC_SET_ALL */
+	for (i = 0; i < NTRY; i++) {
+		prepare_to_test(data);
+		flush_ex->flags = HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES;
+		flush_ex->hv_vp_set.format = HV_GENERIC_SET_ALL;
+		flush_ex->gva_list[0] = (u64)data->test_pages;
+		res = hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX |
+				       (1UL << HV_HYPERCALL_REP_COMP_OFFSET),
+				       hcall_gpa, hcall_gpa + PAGE_SIZE);
+		post_test(data, res, i % 2 ? 0x1 : 0x2, i % 2 ? 0x1 : 0x2);
+	}
+
+	/* "Fast" hypercalls */
+
+	GUEST_SYNC(stage++);
+
+	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE for WORKER_VCPU_ID_1 */
+	for (i = 0; i < NTRY; i++) {
+		prepare_to_test(data);
+		flush->processor_mask = BIT(WORKER_VCPU_ID_1);
+		hyperv_write_xmm_input(&flush->processor_mask, 1);
+		res = hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE |
+				       HV_HYPERCALL_FAST_BIT, 0x0,
+				       HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES);
+		post_test(data, res, i % 2 ? 0x1 : 0x2, 0x0);
+	}
+
+	GUEST_SYNC(stage++);
+
+	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST for WORKER_VCPU_ID_1 */
+	for (i = 0; i < NTRY; i++) {
+		prepare_to_test(data);
+		flush->processor_mask = BIT(WORKER_VCPU_ID_1);
+		flush->gva_list[0] = (u64)data->test_pages;
+		hyperv_write_xmm_input(&flush->processor_mask, 1);
+		res = hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST |
+				       HV_HYPERCALL_FAST_BIT |
+				       (1UL << HV_HYPERCALL_REP_COMP_OFFSET),
+				       0x0, HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES);
+		post_test(data, res, i % 2 ? 0x1 : 0x2, 0x0);
+	}
+
+	GUEST_SYNC(stage++);
+
+	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE for HV_FLUSH_ALL_PROCESSORS */
+	for (i = 0; i < NTRY; i++) {
+		prepare_to_test(data);
+		hyperv_write_xmm_input(&flush->processor_mask, 1);
+		res = hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE |
+				       HV_HYPERCALL_FAST_BIT, 0x0,
+				       HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES |
+				       HV_FLUSH_ALL_PROCESSORS);
+		post_test(data, res, i % 2 ? 0x1 : 0x2, i % 2 ? 0x1 : 0x2);
+	}
+
+	GUEST_SYNC(stage++);
+
+	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST for HV_FLUSH_ALL_PROCESSORS */
+	for (i = 0; i < NTRY; i++) {
+		prepare_to_test(data);
+		flush->gva_list[0] = (u64)data->test_pages;
+		hyperv_write_xmm_input(&flush->processor_mask, 1);
+		res = hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST |
+				       HV_HYPERCALL_FAST_BIT |
+				       (1UL << HV_HYPERCALL_REP_COMP_OFFSET), 0x0,
+				       HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES |
+				       HV_FLUSH_ALL_PROCESSORS);
+		post_test(data, res, i % 2 ? 0x1 : 0x2, i % 2 ? 0x1 : 0x2);
+	}
+
+	GUEST_SYNC(stage++);
+
+	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX for WORKER_VCPU_ID_2 */
+	for (i = 0; i < NTRY; i++) {
+		prepare_to_test(data);
+		flush_ex->hv_vp_set.format = HV_GENERIC_SET_SPARSE_4K;
+		flush_ex->hv_vp_set.valid_bank_mask = BIT_ULL(WORKER_VCPU_ID_2 / 64);
+		flush_ex->hv_vp_set.bank_contents[0] = BIT_ULL(WORKER_VCPU_ID_2 % 64);
+		hyperv_write_xmm_input(&flush_ex->hv_vp_set, 2);
+		res = hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX |
+				       HV_HYPERCALL_FAST_BIT |
+				       (1 << HV_HYPERCALL_VARHEAD_OFFSET),
+				       0x0, HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES);
+		post_test(data, res, 0x0, i % 2 ? 0x1 : 0x2);
+	}
+
+	GUEST_SYNC(stage++);
+
+	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX for WORKER_VCPU_ID_2 */
+	for (i = 0; i < NTRY; i++) {
+		prepare_to_test(data);
+		flush_ex->hv_vp_set.format = HV_GENERIC_SET_SPARSE_4K;
+		flush_ex->hv_vp_set.valid_bank_mask = BIT_ULL(WORKER_VCPU_ID_2 / 64);
+		flush_ex->hv_vp_set.bank_contents[0] = BIT_ULL(WORKER_VCPU_ID_2 % 64);
+		/* bank_contents and gva_list occupy the same space, thus [1] */
+		flush_ex->gva_list[1] = (u64)data->test_pages;
+		hyperv_write_xmm_input(&flush_ex->hv_vp_set, 2);
+		res = hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX |
+				       HV_HYPERCALL_FAST_BIT |
+				       (1 << HV_HYPERCALL_VARHEAD_OFFSET) |
+				       (1UL << HV_HYPERCALL_REP_COMP_OFFSET),
+				       0x0, HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES);
+		post_test(data, res, 0x0, i % 2 ? 0x1 : 0x2);
+	}
+
+	GUEST_SYNC(stage++);
+
+	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX for both vCPUs */
+	for (i = 0; i < NTRY; i++) {
+		prepare_to_test(data);
+		flush_ex->hv_vp_set.format = HV_GENERIC_SET_SPARSE_4K;
+		flush_ex->hv_vp_set.valid_bank_mask = BIT_ULL(WORKER_VCPU_ID_2 / 64) |
+			BIT_ULL(WORKER_VCPU_ID_1 / 64);
+		flush_ex->hv_vp_set.bank_contents[0] = BIT_ULL(WORKER_VCPU_ID_1 % 64);
+		flush_ex->hv_vp_set.bank_contents[1] = BIT_ULL(WORKER_VCPU_ID_2 % 64);
+		hyperv_write_xmm_input(&flush_ex->hv_vp_set, 2);
+		res = hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX |
+				       HV_HYPERCALL_FAST_BIT |
+				       (2 << HV_HYPERCALL_VARHEAD_OFFSET),
+				       0x0, HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES);
+		post_test(data, res, i % 2 ? 0x1 : 0x2, i % 2 ? 0x1 : 0x2);
+	}
+
+	GUEST_SYNC(stage++);
+
+	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX for both vCPUs */
+	for (i = 0; i < NTRY; i++) {
+		prepare_to_test(data);
+		flush_ex->hv_vp_set.format = HV_GENERIC_SET_SPARSE_4K;
+		flush_ex->hv_vp_set.valid_bank_mask = BIT_ULL(WORKER_VCPU_ID_1 / 64) |
+			BIT_ULL(WORKER_VCPU_ID_2 / 64);
+		flush_ex->hv_vp_set.bank_contents[0] = BIT_ULL(WORKER_VCPU_ID_1 % 64);
+		flush_ex->hv_vp_set.bank_contents[1] = BIT_ULL(WORKER_VCPU_ID_2 % 64);
+		/* bank_contents and gva_list occupy the same space, thus [2] */
+		flush_ex->gva_list[2] = (u64)data->test_pages;
+		hyperv_write_xmm_input(&flush_ex->hv_vp_set, 3);
+		res = hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX |
+				       HV_HYPERCALL_FAST_BIT |
+				       (2 << HV_HYPERCALL_VARHEAD_OFFSET) |
+				       (1UL << HV_HYPERCALL_REP_COMP_OFFSET),
+				       0x0, HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES);
+		post_test(data, res, i % 2 ? 0x1 : 0x2, i % 2 ? 0x1 : 0x2);
+	}
+
+	GUEST_SYNC(stage++);
+
+	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX for HV_GENERIC_SET_ALL */
+	for (i = 0; i < NTRY; i++) {
+		prepare_to_test(data);
+		flush_ex->flags = HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES;
+		flush_ex->hv_vp_set.format = HV_GENERIC_SET_ALL;
+		hyperv_write_xmm_input(&flush_ex->hv_vp_set, 2);
+		res = hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX |
+				       HV_HYPERCALL_FAST_BIT,
+				       0x0, HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES);
+		post_test(data, res, i % 2 ? 0x1 : 0x2, i % 2 ? 0x1 : 0x2);
+	}
+
+	GUEST_SYNC(stage++);
+
+	/* HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX for HV_GENERIC_SET_ALL */
+	for (i = 0; i < NTRY; i++) {
+		prepare_to_test(data);
+		flush_ex->flags = HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES;
+		flush_ex->hv_vp_set.format = HV_GENERIC_SET_ALL;
+		flush_ex->gva_list[0] = (u64)data->test_pages;
+		hyperv_write_xmm_input(&flush_ex->hv_vp_set, 2);
+		res = hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX |
+				       HV_HYPERCALL_FAST_BIT |
+				       (1UL << HV_HYPERCALL_REP_COMP_OFFSET),
+				       0x0, HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES);
+		post_test(data, res, i % 2 ? 0x1 : 0x2, i % 2 ? 0x1 : 0x2);
+	}
+
+	GUEST_DONE();
+}
+
+static void *vcpu_thread(void *arg)
+{
+	struct thread_params *params = (struct thread_params *)arg;
+	struct ucall uc;
+	int old;
+	int r;
+	unsigned int exit_reason;
+
+	r = pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, &old);
+	TEST_ASSERT(r == 0,
+		    "pthread_setcanceltype failed on vcpu_id=%u with errno=%d",
+		    params->vcpu_id, r);
+
+	vcpu_run(params->vm, params->vcpu_id);
+	exit_reason = vcpu_state(params->vm, params->vcpu_id)->exit_reason;
+
+	TEST_ASSERT(exit_reason == KVM_EXIT_IO,
+		    "vCPU %u exited with unexpected exit reason %u-%s, expected KVM_EXIT_IO",
+		    params->vcpu_id, exit_reason, exit_reason_str(exit_reason));
+
+	if (get_ucall(params->vm, params->vcpu_id, &uc) == UCALL_ABORT) {
+		TEST_ASSERT(false,
+			    "vCPU %u exited with error: %s.\n",
+			    params->vcpu_id, (const char *)uc.args[0]);
+	}
+
+	return NULL;
+}
+
+static void cancel_join_vcpu_thread(pthread_t thread, uint32_t vcpu_id)
+{
+	void *retval;
+	int r;
+
+	r = pthread_cancel(thread);
+	TEST_ASSERT(r == 0,
+		    "pthread_cancel on vcpu_id=%d failed with errno=%d",
+		    vcpu_id, r);
+
+	r = pthread_join(thread, &retval);
+	TEST_ASSERT(r == 0,
+		    "pthread_join on vcpu_id=%d failed with errno=%d",
+		    vcpu_id, r);
+	TEST_ASSERT(retval == PTHREAD_CANCELED,
+		    "expected retval=%p, got %p", PTHREAD_CANCELED,
+		    retval);
+}
+
+int main(int argc, char *argv[])
+{
+	pthread_t threads[2];
+	struct thread_params params[2];
+	struct kvm_vm *vm;
+	struct kvm_run *run;
+	vm_vaddr_t test_data_page, gva;
+	vm_paddr_t gpa;
+	uint64_t *pte;
+	struct test_data *data;
+	struct ucall uc;
+	int stage = 1, r, i;
+
+	vm = vm_create_default(SENDER_VCPU_ID, 0, sender_guest_code);
+	params[0].vm = vm;
+	params[1].vm = vm;
+
+	/* Test data page */
+	test_data_page = vm_vaddr_alloc_page(vm);
+	data = (struct test_data *)addr_gva2hva(vm, test_data_page);
+
+	/* Hypercall input/output */
+	data->hcall_gva = vm_vaddr_alloc_pages(vm, 2);
+	data->hcall_gpa = addr_gva2gpa(vm, data->hcall_gva);
+	memset(addr_gva2hva(vm, data->hcall_gva), 0x0, 2 * PAGE_SIZE);
+
+	/*
+	 * Test pages: the first one is filled with '0x1's, the second with '0x2's
+	 * and the test will swap their mappings. The third page keeps the indication
+	 * about the current state of mappings.
+	 */
+	data->test_pages = vm_vaddr_alloc_pages(vm, NTEST_PAGES + 1);
+	for (i = 0; i < NTEST_PAGES; i++)
+		memset(addr_gva2hva(vm, data->test_pages + PAGE_SIZE * i),
+		       (char)(i + 1), PAGE_SIZE);
+	set_expected_char(addr_gva2hva(vm, data->test_pages), 0x0, WORKER_VCPU_ID_1);
+	set_expected_char(addr_gva2hva(vm, data->test_pages), 0x0, WORKER_VCPU_ID_2);
+
+	/*
+	 * Get PTE pointers for test pages and map them inside the guest.
+	 * Use separate page for each PTE for simplicity.
+	 */
+	gva = vm_vaddr_unused_gap(vm, NTEST_PAGES * PAGE_SIZE, KVM_UTIL_MIN_VADDR);
+	for (i = 0; i < NTEST_PAGES; i++) {
+		pte = _vm_get_page_table_entry(vm, SENDER_VCPU_ID,
+					       data->test_pages + i * PAGE_SIZE);
+		gpa = addr_hva2gpa(vm, pte);
+		__virt_pg_map(vm, gva + PAGE_SIZE * i, gpa & PAGE_MASK, X86_PAGE_SIZE_4K);
+		data->test_pages_pte[i] = gva + (gpa & ~PAGE_MASK);
+	}
+
+	/*
+	 * Sender vCPU which performs the test: swaps test pages, sets expectation
+	 * for 'workers' and issues TLB flush hypercalls.
+	 */
+	vcpu_args_set(vm, SENDER_VCPU_ID, 1, test_data_page);
+	vcpu_set_hv_cpuid(vm, SENDER_VCPU_ID);
+
+	/* Create worker vCPUs which check the contents of the test pages */
+	vm_vcpu_add_default(vm, WORKER_VCPU_ID_1, worker_guest_code);
+	vcpu_args_set(vm, WORKER_VCPU_ID_1, 1, test_data_page);
+	vcpu_set_msr(vm, WORKER_VCPU_ID_1, HV_X64_MSR_VP_INDEX, WORKER_VCPU_ID_1);
+	vcpu_set_hv_cpuid(vm, WORKER_VCPU_ID_1);
+
+	vm_vcpu_add_default(vm, WORKER_VCPU_ID_2, worker_guest_code);
+	vcpu_args_set(vm, WORKER_VCPU_ID_2, 1, test_data_page);
+	vcpu_set_msr(vm, WORKER_VCPU_ID_2, HV_X64_MSR_VP_INDEX, WORKER_VCPU_ID_2);
+	vcpu_set_hv_cpuid(vm, WORKER_VCPU_ID_2);
+
+	params[0].vcpu_id = WORKER_VCPU_ID_1;
+	r = pthread_create(&threads[0], NULL, vcpu_thread, &params[0]);
+	TEST_ASSERT(r == 0,
+		    "pthread_create failed errno=%d", errno);
+
+	params[1].vcpu_id = WORKER_VCPU_ID_2;
+	r = pthread_create(&threads[1], NULL, vcpu_thread, &params[1]);
+	TEST_ASSERT(r == 0,
+		    "pthread_create failed errno=%d", errno);
+
+	run = vcpu_state(vm, SENDER_VCPU_ID);
+
+	while (true) {
+		r = _vcpu_run(vm, SENDER_VCPU_ID);
+		TEST_ASSERT(!r, "vcpu_run failed: %d\n", r);
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+			    "unexpected exit reason: %u (%s)",
+			    run->exit_reason, exit_reason_str(run->exit_reason));
+
+		switch (get_ucall(vm, SENDER_VCPU_ID, &uc)) {
+		case UCALL_SYNC:
+			TEST_ASSERT(uc.args[1] == stage,
+				    "Unexpected stage: %ld (%d expected)\n",
+				    uc.args[1], stage);
+			break;
+		case UCALL_ABORT:
+			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
+				  __FILE__, uc.args[1]);
+			return 1;
+		case UCALL_DONE:
+			return 0;
+		}
+
+		stage++;
+	}
+
+	cancel_join_vcpu_thread(threads[0], WORKER_VCPU_ID_1);
+	cancel_join_vcpu_thread(threads[1], WORKER_VCPU_ID_2);
+	kvm_vm_free(vm);
+
+	return 0;
+}
-- 
2.35.3

