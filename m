Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1920253395E
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 11:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239674AbiEYJGd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 05:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241833AbiEYJEy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 05:04:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8D4B5A204D
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 02:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653469357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rxefNA4YhOvCW59m8QedLmNjG+d/1Mk/U9nDfx5eCQI=;
        b=HrIngfi2ecnl2Mk5Kur+4YpLr8aOK6sKh7I6x8JyEr6qGDBkyNyh/oI2KBVwrLI5OE3YQy
        fb2u1tSYZn+V6i/p/xiEYvZZxsspwQLcRvkRi9u11b0maCBt5hzqo3o38658/C5oL8B9Oq
        C/f4Ps4uKugpSTou21LRClqt41z3D+0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-507-vIdP_prhMq2V2KZpfwc63g-1; Wed, 25 May 2022 05:02:31 -0400
X-MC-Unique: vIdP_prhMq2V2KZpfwc63g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E257C2999B51;
        Wed, 25 May 2022 09:02:30 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C45840CF8EF;
        Wed, 25 May 2022 09:02:29 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 26/37] KVM: selftests: Hyper-V PV IPI selftest
Date:   Wed, 25 May 2022 11:01:22 +0200
Message-Id: <20220525090133.1264239-27-vkuznets@redhat.com>
In-Reply-To: <20220525090133.1264239-1-vkuznets@redhat.com>
References: <20220525090133.1264239-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a selftest for Hyper-V PV IPI hypercalls
(HvCallSendSyntheticClusterIpi, HvCallSendSyntheticClusterIpiEx).

The test creates one 'sender' vCPU and two 'receiver' vCPU and then
issues various combinations of send IPI hypercalls in both 'normal'
and 'fast' (with XMM input where necessary) mode. Later, the test
checks whether IPIs were delivered to the expected destination vCPU[s].

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/hyperv.h     |  12 +
 .../testing/selftests/kvm/x86_64/hyperv_ipi.c | 352 ++++++++++++++++++
 4 files changed, 366 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/hyperv_ipi.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 4f48f9c2411d..103faed95771 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -23,6 +23,7 @@
 /x86_64/hyperv_clock
 /x86_64/hyperv_cpuid
 /x86_64/hyperv_features
+/x86_64/hyperv_ipi
 /x86_64/hyperv_svm_test
 /x86_64/max_vcpuid_cap_test
 /x86_64/mmio_warning_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 8c3db2f75315..d504b177b510 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -52,6 +52,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/fix_hypercall_test
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_clock
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_features
+TEST_GEN_PROGS_x86_64 += x86_64/hyperv_ipi
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_svm_test
 TEST_GEN_PROGS_x86_64 += x86_64/kvm_clock_test
 TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
index e0a1b4c2fbbc..1b467626be58 100644
--- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
+++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
@@ -9,6 +9,8 @@
 #ifndef SELFTEST_KVM_HYPERV_H
 #define SELFTEST_KVM_HYPERV_H
 
+#include "processor.h"
+
 #define HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS	0x40000000
 #define HYPERV_CPUID_INTERFACE			0x40000001
 #define HYPERV_CPUID_VERSION			0x40000002
@@ -184,6 +186,7 @@
 
 /* hypercall options */
 #define HV_HYPERCALL_FAST_BIT		BIT(16)
+#define HV_HYPERCALL_VARHEAD_OFFSET	17
 
 static inline u64 hyperv_hypercall(u64 control, vm_vaddr_t input_address,
 			   vm_vaddr_t output_address)
@@ -200,6 +203,15 @@ static inline u64 hyperv_hypercall(u64 control, vm_vaddr_t input_address,
 	return hv_status;
 }
 
+/* Write 'Fast' hypercall input 'data' to the first 'n_sse_regs' SSE regs */
+static inline void hyperv_write_xmm_input(void *data, int n_sse_regs)
+{
+	int i;
+
+	for (i = 0; i < n_sse_regs; i++)
+		write_sse_reg(i, (sse128_t *)(data + sizeof(sse128_t) * i));
+}
+
 /* Proper HV_X64_MSR_GUEST_OS_ID value */
 #define HYPERV_LINUX_OS_ID ((u64)0x8100 << 48)
 
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c b/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c
new file mode 100644
index 000000000000..a8e834be62bc
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c
@@ -0,0 +1,352 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Hyper-V HvCallSendSyntheticClusterIpi{,Ex} tests
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
+#include "hyperv.h"
+#include "test_util.h"
+#include "vmx.h"
+
+#define SENDER_VCPU_ID   1
+#define RECEIVER_VCPU_ID_1 2
+#define RECEIVER_VCPU_ID_2 65
+
+#define IPI_VECTOR	 0xfe
+
+static volatile uint64_t ipis_rcvd[RECEIVER_VCPU_ID_2 + 1];
+
+struct thread_params {
+	struct kvm_vm *vm;
+	uint32_t vcpu_id;
+};
+
+struct hv_vpset {
+	u64 format;
+	u64 valid_bank_mask;
+	u64 bank_contents[2];
+};
+
+enum HV_GENERIC_SET_FORMAT {
+	HV_GENERIC_SET_SPARSE_4K,
+	HV_GENERIC_SET_ALL,
+};
+
+/* HvCallSendSyntheticClusterIpi hypercall */
+struct hv_send_ipi {
+	u32 vector;
+	u32 reserved;
+	u64 cpu_mask;
+};
+
+/* HvCallSendSyntheticClusterIpiEx hypercall */
+struct hv_send_ipi_ex {
+	u32 vector;
+	u32 reserved;
+	struct hv_vpset vp_set;
+};
+
+static inline void hv_init(vm_vaddr_t pgs_gpa)
+{
+	wrmsr(HV_X64_MSR_GUEST_OS_ID, HYPERV_LINUX_OS_ID);
+	wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
+}
+
+static void receiver_code(void *hcall_page, vm_vaddr_t pgs_gpa)
+{
+	u32 vcpu_id;
+
+	x2apic_enable();
+	hv_init(pgs_gpa);
+
+	vcpu_id = rdmsr(HV_X64_MSR_VP_INDEX);
+
+	/* Signal sender vCPU we're ready */
+	ipis_rcvd[vcpu_id] = (u64)-1;
+
+	for (;;)
+		asm volatile("sti; hlt; cli");
+}
+
+static void guest_ipi_handler(struct ex_regs *regs)
+{
+	u32 vcpu_id = rdmsr(HV_X64_MSR_VP_INDEX);
+
+	ipis_rcvd[vcpu_id]++;
+	wrmsr(HV_X64_MSR_EOI, 1);
+}
+
+static inline void nop_loop(void)
+{
+	int i;
+
+	for (i = 0; i < 100000000; i++)
+		asm volatile("nop");
+}
+
+static void sender_guest_code(void *hcall_page, vm_vaddr_t pgs_gpa)
+{
+	struct hv_send_ipi *ipi = (struct hv_send_ipi *)hcall_page;
+	struct hv_send_ipi_ex *ipi_ex = (struct hv_send_ipi_ex *)hcall_page;
+	int stage = 1, ipis_expected[2] = {0};
+	u64 res;
+
+	hv_init(pgs_gpa);
+	GUEST_SYNC(stage++);
+
+	/* Wait for receiver vCPUs to come up */
+	while (!ipis_rcvd[RECEIVER_VCPU_ID_1] || !ipis_rcvd[RECEIVER_VCPU_ID_2])
+		nop_loop();
+	ipis_rcvd[RECEIVER_VCPU_ID_1] = ipis_rcvd[RECEIVER_VCPU_ID_2] = 0;
+
+	/* 'Slow' HvCallSendSyntheticClusterIpi to RECEIVER_VCPU_ID_1 */
+	ipi->vector = IPI_VECTOR;
+	ipi->cpu_mask = 1 << RECEIVER_VCPU_ID_1;
+	res = hyperv_hypercall(HVCALL_SEND_IPI, pgs_gpa, pgs_gpa + 4096);
+	GUEST_ASSERT((res & 0xffff) == 0);
+	nop_loop();
+	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_1] == ++ipis_expected[0]);
+	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_2] == ipis_expected[1]);
+	GUEST_SYNC(stage++);
+	/* 'Fast' HvCallSendSyntheticClusterIpi to RECEIVER_VCPU_ID_1 */
+	res = hyperv_hypercall(HVCALL_SEND_IPI | HV_HYPERCALL_FAST_BIT,
+			       IPI_VECTOR, 1 << RECEIVER_VCPU_ID_1);
+	GUEST_ASSERT((res & 0xffff) == 0);
+	nop_loop();
+	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_1] == ++ipis_expected[0]);
+	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_2] == ipis_expected[1]);
+	GUEST_SYNC(stage++);
+
+	/* 'Slow' HvCallSendSyntheticClusterIpiEx to RECEIVER_VCPU_ID_1 */
+	memset(hcall_page, 0, 4096);
+	ipi_ex->vector = IPI_VECTOR;
+	ipi_ex->vp_set.format = HV_GENERIC_SET_SPARSE_4K;
+	ipi_ex->vp_set.valid_bank_mask = 1 << 0;
+	ipi_ex->vp_set.bank_contents[0] = BIT(RECEIVER_VCPU_ID_1);
+	res = hyperv_hypercall(HVCALL_SEND_IPI_EX | (1 << HV_HYPERCALL_VARHEAD_OFFSET),
+			       pgs_gpa, pgs_gpa + 4096);
+	GUEST_ASSERT((res & 0xffff) == 0);
+	nop_loop();
+	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_1] == ++ipis_expected[0]);
+	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_2] == ipis_expected[1]);
+	GUEST_SYNC(stage++);
+	/* 'XMM Fast' HvCallSendSyntheticClusterIpiEx to RECEIVER_VCPU_ID_1 */
+	hyperv_write_xmm_input(&ipi_ex->vp_set.valid_bank_mask, 1);
+	res = hyperv_hypercall(HVCALL_SEND_IPI_EX | HV_HYPERCALL_FAST_BIT |
+			       (1 << HV_HYPERCALL_VARHEAD_OFFSET),
+			       IPI_VECTOR, HV_GENERIC_SET_SPARSE_4K);
+	GUEST_ASSERT((res & 0xffff) == 0);
+	nop_loop();
+	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_1] == ++ipis_expected[0]);
+	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_2] == ipis_expected[1]);
+	GUEST_SYNC(stage++);
+
+	/* 'Slow' HvCallSendSyntheticClusterIpiEx to RECEIVER_VCPU_ID_2 */
+	memset(hcall_page, 0, 4096);
+	ipi_ex->vector = IPI_VECTOR;
+	ipi_ex->vp_set.format = HV_GENERIC_SET_SPARSE_4K;
+	ipi_ex->vp_set.valid_bank_mask = 1 << 1;
+	ipi_ex->vp_set.bank_contents[0] = BIT(RECEIVER_VCPU_ID_2 - 64);
+	res = hyperv_hypercall(HVCALL_SEND_IPI_EX | (1 << HV_HYPERCALL_VARHEAD_OFFSET),
+			       pgs_gpa, pgs_gpa + 4096);
+	GUEST_ASSERT((res & 0xffff) == 0);
+	nop_loop();
+	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_1] == ipis_expected[0]);
+	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_2] == ++ipis_expected[1]);
+	GUEST_SYNC(stage++);
+	/* 'XMM Fast' HvCallSendSyntheticClusterIpiEx to RECEIVER_VCPU_ID_2 */
+	hyperv_write_xmm_input(&ipi_ex->vp_set.valid_bank_mask, 1);
+	res = hyperv_hypercall(HVCALL_SEND_IPI_EX | HV_HYPERCALL_FAST_BIT |
+			       (1 << HV_HYPERCALL_VARHEAD_OFFSET),
+			       IPI_VECTOR, HV_GENERIC_SET_SPARSE_4K);
+	GUEST_ASSERT((res & 0xffff) == 0);
+	nop_loop();
+	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_1] == ipis_expected[0]);
+	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_2] == ++ipis_expected[1]);
+	GUEST_SYNC(stage++);
+
+	/* 'Slow' HvCallSendSyntheticClusterIpiEx to both RECEIVER_VCPU_ID_{1,2} */
+	memset(hcall_page, 0, 4096);
+	ipi_ex->vector = IPI_VECTOR;
+	ipi_ex->vp_set.format = HV_GENERIC_SET_SPARSE_4K;
+	ipi_ex->vp_set.valid_bank_mask = 1 << 1 | 1;
+	ipi_ex->vp_set.bank_contents[0] = BIT(RECEIVER_VCPU_ID_1);
+	ipi_ex->vp_set.bank_contents[1] = BIT(RECEIVER_VCPU_ID_2 - 64);
+	res = hyperv_hypercall(HVCALL_SEND_IPI_EX | (2 << HV_HYPERCALL_VARHEAD_OFFSET),
+			       pgs_gpa, pgs_gpa + 4096);
+	GUEST_ASSERT((res & 0xffff) == 0);
+	nop_loop();
+	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_1] == ++ipis_expected[0]);
+	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_2] == ++ipis_expected[1]);
+	GUEST_SYNC(stage++);
+	/* 'XMM Fast' HvCallSendSyntheticClusterIpiEx to both RECEIVER_VCPU_ID_{1, 2} */
+	hyperv_write_xmm_input(&ipi_ex->vp_set.valid_bank_mask, 2);
+	res = hyperv_hypercall(HVCALL_SEND_IPI_EX | HV_HYPERCALL_FAST_BIT |
+			       (2 << HV_HYPERCALL_VARHEAD_OFFSET),
+			       IPI_VECTOR, HV_GENERIC_SET_SPARSE_4K);
+	GUEST_ASSERT((res & 0xffff) == 0);
+	nop_loop();
+	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_1] == ++ipis_expected[0]);
+	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_2] == ++ipis_expected[1]);
+	GUEST_SYNC(stage++);
+
+	/* 'Slow' HvCallSendSyntheticClusterIpiEx to HV_GENERIC_SET_ALL */
+	memset(hcall_page, 0, 4096);
+	ipi_ex->vector = IPI_VECTOR;
+	ipi_ex->vp_set.format = HV_GENERIC_SET_ALL;
+	res = hyperv_hypercall(HVCALL_SEND_IPI_EX, pgs_gpa, pgs_gpa + 4096);
+	GUEST_ASSERT((res & 0xffff) == 0);
+	nop_loop();
+	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_1] == ++ipis_expected[0]);
+	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_2] == ++ipis_expected[1]);
+	GUEST_SYNC(stage++);
+	/*
+	 * 'XMM Fast' HvCallSendSyntheticClusterIpiEx to HV_GENERIC_SET_ALL.
+	 * Nothing to write anything to XMM regs.
+	 */
+	res = hyperv_hypercall(HVCALL_SEND_IPI_EX | HV_HYPERCALL_FAST_BIT,
+			       IPI_VECTOR, HV_GENERIC_SET_ALL);
+	GUEST_ASSERT((res & 0xffff) == 0);
+	nop_loop();
+	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_1] == ++ipis_expected[0]);
+	GUEST_ASSERT(ipis_rcvd[RECEIVER_VCPU_ID_2] == ++ipis_expected[1]);
+	GUEST_SYNC(stage++);
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
+	int r;
+	pthread_t threads[2];
+	struct thread_params params[2];
+	struct kvm_vm *vm;
+	struct kvm_run *run;
+	vm_vaddr_t hcall_page;
+	struct ucall uc;
+	int stage = 1;
+
+	vm = vm_create_default(SENDER_VCPU_ID, 0, sender_guest_code);
+	params[0].vm = vm;
+	params[1].vm = vm;
+
+	/* Hypercall input/output */
+	hcall_page = vm_vaddr_alloc_pages(vm, 2);
+	memset(addr_gva2hva(vm, hcall_page), 0x0, 2 * getpagesize());
+
+	vm_init_descriptor_tables(vm);
+
+	vm_vcpu_add_default(vm, RECEIVER_VCPU_ID_1, receiver_code);
+	vcpu_init_descriptor_tables(vm, RECEIVER_VCPU_ID_1);
+	vcpu_args_set(vm, RECEIVER_VCPU_ID_1, 2, hcall_page, addr_gva2gpa(vm, hcall_page));
+	vcpu_set_msr(vm, RECEIVER_VCPU_ID_1, HV_X64_MSR_VP_INDEX, RECEIVER_VCPU_ID_1);
+	vcpu_set_hv_cpuid(vm, RECEIVER_VCPU_ID_1);
+
+	vm_vcpu_add_default(vm, RECEIVER_VCPU_ID_2, receiver_code);
+	vcpu_init_descriptor_tables(vm, RECEIVER_VCPU_ID_2);
+	vcpu_args_set(vm, RECEIVER_VCPU_ID_2, 2, hcall_page, addr_gva2gpa(vm, hcall_page));
+	vcpu_set_msr(vm, RECEIVER_VCPU_ID_2, HV_X64_MSR_VP_INDEX, RECEIVER_VCPU_ID_2);
+	vcpu_set_hv_cpuid(vm, RECEIVER_VCPU_ID_2);
+
+	vm_install_exception_handler(vm, IPI_VECTOR, guest_ipi_handler);
+
+	vcpu_args_set(vm, SENDER_VCPU_ID, 2, hcall_page, addr_gva2gpa(vm, hcall_page));
+	vcpu_set_hv_cpuid(vm, SENDER_VCPU_ID);
+
+	params[0].vcpu_id = RECEIVER_VCPU_ID_1;
+	r = pthread_create(&threads[0], NULL, vcpu_thread, &params[0]);
+	TEST_ASSERT(r == 0,
+		    "pthread_create halter failed errno=%d", errno);
+
+	params[1].vcpu_id = RECEIVER_VCPU_ID_2;
+	r = pthread_create(&threads[1], NULL, vcpu_thread, &params[1]);
+	TEST_ASSERT(r == 0,
+		    "pthread_create halter failed errno=%d", errno);
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
+	cancel_join_vcpu_thread(threads[0], RECEIVER_VCPU_ID_1);
+	cancel_join_vcpu_thread(threads[1], RECEIVER_VCPU_ID_2);
+	kvm_vm_free(vm);
+
+	return 0;
+}
-- 
2.35.3

