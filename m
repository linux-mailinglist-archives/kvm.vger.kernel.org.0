Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4C838C40F
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 11:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbhEUJ4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 05:56:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59373 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237315AbhEUJzJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 May 2021 05:55:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621590824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uk0eg8g+uEn9wgGYVSIKljiWuWugPPWj2ZW7U6Mtrz8=;
        b=iLvxeDhS2bMC5nanRFwJ7AYE/R5fyfbbWyDUEKOImV2Zg/JyV0C+FkDanRLwFe3j/roQrx
        lEldtapVKZbBIJXs1Ad/n7yEtwFNlggwipycuY9zgEZC+rT5GH+pgoX1KETNAuJvmEfw8m
        Pwb8KyDiB7w9jAZcAeXR/mg1BXvAQ7s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-58J1MFkIN-GygRmuQL6EKw-1; Fri, 21 May 2021 05:53:41 -0400
X-MC-Unique: 58J1MFkIN-GygRmuQL6EKw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EDAB3107ACCD;
        Fri, 21 May 2021 09:53:39 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B2F656A047;
        Fri, 21 May 2021 09:53:37 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 30/30] KVM: selftests: Introduce hyperv_features test
Date:   Fri, 21 May 2021 11:52:04 +0200
Message-Id: <20210521095204.2161214-31-vkuznets@redhat.com>
In-Reply-To: <20210521095204.2161214-1-vkuznets@redhat.com>
References: <20210521095204.2161214-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The initial implementation of the test only tests that access to Hyper-V
MSRs and hypercalls is in compliance with guest visible CPUID feature bits.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/hyperv.h     | 166 +++++
 .../selftests/kvm/x86_64/hyperv_features.c    | 649 ++++++++++++++++++
 4 files changed, 817 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/hyperv_features.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index bd83158e0e0b..7f72a7e9fa64 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -13,6 +13,7 @@
 /x86_64/kvm_pv_test
 /x86_64/hyperv_clock
 /x86_64/hyperv_cpuid
+/x86_64/hyperv_features
 /x86_64/mmio_warning_test
 /x86_64/platform_info_test
 /x86_64/set_boot_cpu_id
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index e439d027939d..f06c9e7ffa44 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -44,6 +44,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
 TEST_GEN_PROGS_x86_64 += x86_64/get_cpuid_test
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_clock
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
+TEST_GEN_PROGS_x86_64 += x86_64/hyperv_features
 TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
 TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
 TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
index 443c6572512b..412eaee7884a 100644
--- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
+++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
@@ -9,11 +9,177 @@
 #ifndef SELFTEST_KVM_HYPERV_H
 #define SELFTEST_KVM_HYPERV_H
 
+#define HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS	0x40000000
+#define HYPERV_CPUID_INTERFACE			0x40000001
+#define HYPERV_CPUID_VERSION			0x40000002
+#define HYPERV_CPUID_FEATURES			0x40000003
+#define HYPERV_CPUID_ENLIGHTMENT_INFO		0x40000004
+#define HYPERV_CPUID_IMPLEMENT_LIMITS		0x40000005
+#define HYPERV_CPUID_CPU_MANAGEMENT_FEATURES	0x40000007
+#define HYPERV_CPUID_NESTED_FEATURES		0x4000000A
+#define HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS	0x40000080
+#define HYPERV_CPUID_SYNDBG_INTERFACE			0x40000081
+#define HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES	0x40000082
+
 #define HV_X64_MSR_GUEST_OS_ID			0x40000000
+#define HV_X64_MSR_HYPERCALL			0x40000001
+#define HV_X64_MSR_VP_INDEX			0x40000002
+#define HV_X64_MSR_RESET			0x40000003
+#define HV_X64_MSR_VP_RUNTIME			0x40000010
 #define HV_X64_MSR_TIME_REF_COUNT		0x40000020
 #define HV_X64_MSR_REFERENCE_TSC		0x40000021
 #define HV_X64_MSR_TSC_FREQUENCY		0x40000022
+#define HV_X64_MSR_APIC_FREQUENCY		0x40000023
+#define HV_X64_MSR_EOI				0x40000070
+#define HV_X64_MSR_ICR				0x40000071
+#define HV_X64_MSR_TPR				0x40000072
+#define HV_X64_MSR_VP_ASSIST_PAGE		0x40000073
+#define HV_X64_MSR_SCONTROL			0x40000080
+#define HV_X64_MSR_SVERSION			0x40000081
+#define HV_X64_MSR_SIEFP			0x40000082
+#define HV_X64_MSR_SIMP				0x40000083
+#define HV_X64_MSR_EOM				0x40000084
+#define HV_X64_MSR_SINT0			0x40000090
+#define HV_X64_MSR_SINT1			0x40000091
+#define HV_X64_MSR_SINT2			0x40000092
+#define HV_X64_MSR_SINT3			0x40000093
+#define HV_X64_MSR_SINT4			0x40000094
+#define HV_X64_MSR_SINT5			0x40000095
+#define HV_X64_MSR_SINT6			0x40000096
+#define HV_X64_MSR_SINT7			0x40000097
+#define HV_X64_MSR_SINT8			0x40000098
+#define HV_X64_MSR_SINT9			0x40000099
+#define HV_X64_MSR_SINT10			0x4000009A
+#define HV_X64_MSR_SINT11			0x4000009B
+#define HV_X64_MSR_SINT12			0x4000009C
+#define HV_X64_MSR_SINT13			0x4000009D
+#define HV_X64_MSR_SINT14			0x4000009E
+#define HV_X64_MSR_SINT15			0x4000009F
+#define HV_X64_MSR_STIMER0_CONFIG		0x400000B0
+#define HV_X64_MSR_STIMER0_COUNT		0x400000B1
+#define HV_X64_MSR_STIMER1_CONFIG		0x400000B2
+#define HV_X64_MSR_STIMER1_COUNT		0x400000B3
+#define HV_X64_MSR_STIMER2_CONFIG		0x400000B4
+#define HV_X64_MSR_STIMER2_COUNT		0x400000B5
+#define HV_X64_MSR_STIMER3_CONFIG		0x400000B6
+#define HV_X64_MSR_STIMER3_COUNT		0x400000B7
+#define HV_X64_MSR_GUEST_IDLE			0x400000F0
+#define HV_X64_MSR_CRASH_P0			0x40000100
+#define HV_X64_MSR_CRASH_P1			0x40000101
+#define HV_X64_MSR_CRASH_P2			0x40000102
+#define HV_X64_MSR_CRASH_P3			0x40000103
+#define HV_X64_MSR_CRASH_P4			0x40000104
+#define HV_X64_MSR_CRASH_CTL			0x40000105
 #define HV_X64_MSR_REENLIGHTENMENT_CONTROL	0x40000106
 #define HV_X64_MSR_TSC_EMULATION_CONTROL	0x40000107
+#define HV_X64_MSR_TSC_EMULATION_STATUS		0x40000108
+#define HV_X64_MSR_TSC_INVARIANT_CONTROL	0x40000118
+
+#define HV_X64_MSR_SYNDBG_CONTROL		0x400000F1
+#define HV_X64_MSR_SYNDBG_STATUS		0x400000F2
+#define HV_X64_MSR_SYNDBG_SEND_BUFFER		0x400000F3
+#define HV_X64_MSR_SYNDBG_RECV_BUFFER		0x400000F4
+#define HV_X64_MSR_SYNDBG_PENDING_BUFFER	0x400000F5
+#define HV_X64_MSR_SYNDBG_OPTIONS		0x400000FF
+
+/* HYPERV_CPUID_FEATURES.EAX */
+#define HV_MSR_VP_RUNTIME_AVAILABLE		BIT(0)
+#define HV_MSR_TIME_REF_COUNT_AVAILABLE		BIT(1)
+#define HV_MSR_SYNIC_AVAILABLE			BIT(2)
+#define HV_MSR_SYNTIMER_AVAILABLE		BIT(3)
+#define HV_MSR_APIC_ACCESS_AVAILABLE		BIT(4)
+#define HV_MSR_HYPERCALL_AVAILABLE		BIT(5)
+#define HV_MSR_VP_INDEX_AVAILABLE		BIT(6)
+#define HV_MSR_RESET_AVAILABLE			BIT(7)
+#define HV_MSR_STAT_PAGES_AVAILABLE		BIT(8)
+#define HV_MSR_REFERENCE_TSC_AVAILABLE		BIT(9)
+#define HV_MSR_GUEST_IDLE_AVAILABLE		BIT(10)
+#define HV_ACCESS_FREQUENCY_MSRS		BIT(11)
+#define HV_ACCESS_REENLIGHTENMENT		BIT(13)
+#define HV_ACCESS_TSC_INVARIANT			BIT(15)
+
+/* HYPERV_CPUID_FEATURES.EBX */
+#define HV_CREATE_PARTITIONS			BIT(0)
+#define HV_ACCESS_PARTITION_ID			BIT(1)
+#define HV_ACCESS_MEMORY_POOL			BIT(2)
+#define HV_ADJUST_MESSAGE_BUFFERS		BIT(3)
+#define HV_POST_MESSAGES			BIT(4)
+#define HV_SIGNAL_EVENTS			BIT(5)
+#define HV_CREATE_PORT				BIT(6)
+#define HV_CONNECT_PORT				BIT(7)
+#define HV_ACCESS_STATS				BIT(8)
+#define HV_DEBUGGING				BIT(11)
+#define HV_CPU_MANAGEMENT			BIT(12)
+#define HV_ISOLATION				BIT(22)
+
+/* HYPERV_CPUID_FEATURES.EDX */
+#define HV_X64_MWAIT_AVAILABLE				BIT(0)
+#define HV_X64_GUEST_DEBUGGING_AVAILABLE		BIT(1)
+#define HV_X64_PERF_MONITOR_AVAILABLE			BIT(2)
+#define HV_X64_CPU_DYNAMIC_PARTITIONING_AVAILABLE	BIT(3)
+#define HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE		BIT(4)
+#define HV_X64_GUEST_IDLE_STATE_AVAILABLE		BIT(5)
+#define HV_FEATURE_FREQUENCY_MSRS_AVAILABLE		BIT(8)
+#define HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE		BIT(10)
+#define HV_FEATURE_DEBUG_MSRS_AVAILABLE			BIT(11)
+#define HV_STIMER_DIRECT_MODE_AVAILABLE			BIT(19)
+
+/* HYPERV_CPUID_ENLIGHTMENT_INFO.EAX */
+#define HV_X64_AS_SWITCH_RECOMMENDED			BIT(0)
+#define HV_X64_LOCAL_TLB_FLUSH_RECOMMENDED		BIT(1)
+#define HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED		BIT(2)
+#define HV_X64_APIC_ACCESS_RECOMMENDED			BIT(3)
+#define HV_X64_SYSTEM_RESET_RECOMMENDED			BIT(4)
+#define HV_X64_RELAXED_TIMING_RECOMMENDED		BIT(5)
+#define HV_DEPRECATING_AEOI_RECOMMENDED			BIT(9)
+#define HV_X64_CLUSTER_IPI_RECOMMENDED			BIT(10)
+#define HV_X64_EX_PROCESSOR_MASKS_RECOMMENDED		BIT(11)
+#define HV_X64_ENLIGHTENED_VMCS_RECOMMENDED		BIT(14)
+
+/* HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX */
+#define HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING	BIT(1)
+
+/* Hypercalls */
+#define HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE	0x0002
+#define HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST	0x0003
+#define HVCALL_NOTIFY_LONG_SPIN_WAIT		0x0008
+#define HVCALL_SEND_IPI				0x000b
+#define HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX	0x0013
+#define HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX	0x0014
+#define HVCALL_SEND_IPI_EX			0x0015
+#define HVCALL_GET_PARTITION_ID			0x0046
+#define HVCALL_DEPOSIT_MEMORY			0x0048
+#define HVCALL_CREATE_VP			0x004e
+#define HVCALL_GET_VP_REGISTERS			0x0050
+#define HVCALL_SET_VP_REGISTERS			0x0051
+#define HVCALL_POST_MESSAGE			0x005c
+#define HVCALL_SIGNAL_EVENT			0x005d
+#define HVCALL_POST_DEBUG_DATA			0x0069
+#define HVCALL_RETRIEVE_DEBUG_DATA		0x006a
+#define HVCALL_RESET_DEBUG_SESSION		0x006b
+#define HVCALL_ADD_LOGICAL_PROCESSOR		0x0076
+#define HVCALL_MAP_DEVICE_INTERRUPT		0x007c
+#define HVCALL_UNMAP_DEVICE_INTERRUPT		0x007d
+#define HVCALL_RETARGET_INTERRUPT		0x007e
+#define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE 0x00af
+#define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST 0x00b0
+
+#define HV_FLUSH_ALL_PROCESSORS			BIT(0)
+#define HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES	BIT(1)
+#define HV_FLUSH_NON_GLOBAL_MAPPINGS_ONLY	BIT(2)
+#define HV_FLUSH_USE_EXTENDED_RANGE_FORMAT	BIT(3)
+
+/* hypercall status code */
+#define HV_STATUS_SUCCESS			0
+#define HV_STATUS_INVALID_HYPERCALL_CODE	2
+#define HV_STATUS_INVALID_HYPERCALL_INPUT	3
+#define HV_STATUS_INVALID_ALIGNMENT		4
+#define HV_STATUS_INVALID_PARAMETER		5
+#define HV_STATUS_ACCESS_DENIED			6
+#define HV_STATUS_OPERATION_DENIED		8
+#define HV_STATUS_INSUFFICIENT_MEMORY		11
+#define HV_STATUS_INVALID_PORT_ID		17
+#define HV_STATUS_INVALID_CONNECTION_ID		18
+#define HV_STATUS_INSUFFICIENT_BUFFERS		19
 
 #endif /* !SELFTEST_KVM_HYPERV_H */
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
new file mode 100644
index 000000000000..9947ef63dfa1
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -0,0 +1,649 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2021, Red Hat, Inc.
+ *
+ * Tests for Hyper-V features enablement
+ */
+#include <asm/kvm_para.h>
+#include <linux/kvm_para.h>
+#include <stdint.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "hyperv.h"
+
+#define VCPU_ID 0
+#define LINUX_OS_ID ((u64)0x8100 << 48)
+
+extern unsigned char rdmsr_start;
+extern unsigned char rdmsr_end;
+
+static u64 do_rdmsr(u32 idx)
+{
+	u32 lo, hi;
+
+	asm volatile("rdmsr_start: rdmsr;"
+		     "rdmsr_end:"
+		     : "=a"(lo), "=c"(hi)
+		     : "c"(idx));
+
+	return (((u64) hi) << 32) | lo;
+}
+
+extern unsigned char wrmsr_start;
+extern unsigned char wrmsr_end;
+
+static void do_wrmsr(u32 idx, u64 val)
+{
+	u32 lo, hi;
+
+	lo = val;
+	hi = val >> 32;
+
+	asm volatile("wrmsr_start: wrmsr;"
+		     "wrmsr_end:"
+		     : : "a"(lo), "c"(idx), "d"(hi));
+}
+
+static int nr_gp;
+
+static inline u64 hypercall(u64 control, vm_vaddr_t input_address,
+			    vm_vaddr_t output_address)
+{
+	u64 hv_status;
+
+	asm volatile("mov %3, %%r8\n"
+		     "vmcall"
+		     : "=a" (hv_status),
+		       "+c" (control), "+d" (input_address)
+		     :  "r" (output_address)
+		     : "cc", "memory", "r8", "r9", "r10", "r11");
+
+	return hv_status;
+}
+
+static void guest_gp_handler(struct ex_regs *regs)
+{
+	unsigned char *rip = (unsigned char *)regs->rip;
+	bool r, w;
+
+	r = rip == &rdmsr_start;
+	w = rip == &wrmsr_start;
+	GUEST_ASSERT(r || w);
+
+	nr_gp++;
+
+	if (r)
+		regs->rip = (uint64_t)&rdmsr_end;
+	else
+		regs->rip = (uint64_t)&wrmsr_end;
+}
+
+struct msr_data {
+	uint32_t idx;
+	bool available;
+	bool write;
+	u64 write_val;
+};
+
+struct hcall_data {
+	uint64_t control;
+	uint64_t expect;
+};
+
+static void guest_msr(struct msr_data *msr)
+{
+	int i = 0;
+
+	while (msr->idx) {
+		WRITE_ONCE(nr_gp, 0);
+		if (!msr->write)
+			do_rdmsr(msr->idx);
+		else
+			do_wrmsr(msr->idx, msr->write_val);
+
+		if (msr->available)
+			GUEST_ASSERT(READ_ONCE(nr_gp) == 0);
+		else
+			GUEST_ASSERT(READ_ONCE(nr_gp) == 1);
+
+		GUEST_SYNC(i++);
+	}
+
+	GUEST_DONE();
+}
+
+static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
+{
+	int i = 0;
+
+	wrmsr(HV_X64_MSR_GUEST_OS_ID, LINUX_OS_ID);
+	wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
+
+	while (hcall->control) {
+		GUEST_ASSERT(hypercall(hcall->control, pgs_gpa,
+				       pgs_gpa + 4096) == hcall->expect);
+		GUEST_SYNC(i++);
+	}
+
+	GUEST_DONE();
+}
+
+static void hv_set_cpuid(struct kvm_vm *vm, struct kvm_cpuid2 *cpuid,
+			 struct kvm_cpuid_entry2 *feat,
+			 struct kvm_cpuid_entry2 *recomm,
+			 struct kvm_cpuid_entry2 *dbg)
+{
+	TEST_ASSERT(set_cpuid(cpuid, feat),
+		    "failed to set KVM_CPUID_FEATURES leaf");
+	TEST_ASSERT(set_cpuid(cpuid, recomm),
+		    "failed to set HYPERV_CPUID_ENLIGHTMENT_INFO leaf");
+	TEST_ASSERT(set_cpuid(cpuid, dbg),
+		    "failed to set HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES leaf");
+	vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+}
+
+static void guest_test_msrs_access(struct kvm_vm *vm, struct msr_data *msr,
+				   struct kvm_cpuid2 *best)
+{
+	struct kvm_run *run;
+	struct ucall uc;
+	int stage = 0, r;
+	struct kvm_cpuid_entry2 feat = {
+		.function = HYPERV_CPUID_FEATURES
+	};
+	struct kvm_cpuid_entry2 recomm = {
+		.function = HYPERV_CPUID_ENLIGHTMENT_INFO
+	};
+	struct kvm_cpuid_entry2 dbg = {
+		.function = HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES
+	};
+	struct kvm_enable_cap cap = {0};
+
+	run = vcpu_state(vm, VCPU_ID);
+
+	while (true) {
+		switch (stage) {
+		case 0:
+			/*
+			 * Only available when Hyper-V identification is set
+			 */
+			msr->idx = HV_X64_MSR_GUEST_OS_ID;
+			msr->write = 0;
+			msr->available = 0;
+			break;
+		case 1:
+			msr->idx = HV_X64_MSR_HYPERCALL;
+			msr->write = 0;
+			msr->available = 0;
+			break;
+		case 2:
+			feat.eax |= HV_MSR_HYPERCALL_AVAILABLE;
+			/*
+			 * HV_X64_MSR_GUEST_OS_ID has to be written first to make
+			 * HV_X64_MSR_HYPERCALL available.
+			 */
+			msr->idx = HV_X64_MSR_GUEST_OS_ID;
+			msr->write = 1;
+			msr->write_val = LINUX_OS_ID;
+			msr->available = 1;
+			break;
+		case 3:
+			msr->idx = HV_X64_MSR_GUEST_OS_ID;
+			msr->write = 0;
+			msr->available = 1;
+			break;
+		case 4:
+			msr->idx = HV_X64_MSR_HYPERCALL;
+			msr->write = 0;
+			msr->available = 1;
+			break;
+
+		case 5:
+			msr->idx = HV_X64_MSR_VP_RUNTIME;
+			msr->write = 0;
+			msr->available = 0;
+			break;
+		case 6:
+			feat.eax |= HV_MSR_VP_RUNTIME_AVAILABLE;
+			msr->write = 0;
+			msr->available = 1;
+			break;
+		case 7:
+			/* Read only */
+			msr->write = 1;
+			msr->write_val = 1;
+			msr->available = 0;
+			break;
+
+		case 8:
+			msr->idx = HV_X64_MSR_TIME_REF_COUNT;
+			msr->write = 0;
+			msr->available = 0;
+			break;
+		case 9:
+			feat.eax |= HV_MSR_TIME_REF_COUNT_AVAILABLE;
+			msr->write = 0;
+			msr->available = 1;
+			break;
+		case 10:
+			/* Read only */
+			msr->write = 1;
+			msr->write_val = 1;
+			msr->available = 0;
+			break;
+
+		case 11:
+			msr->idx = HV_X64_MSR_VP_INDEX;
+			msr->write = 0;
+			msr->available = 0;
+			break;
+		case 12:
+			feat.eax |= HV_MSR_VP_INDEX_AVAILABLE;
+			msr->write = 0;
+			msr->available = 1;
+			break;
+		case 13:
+			/* Read only */
+			msr->write = 1;
+			msr->write_val = 1;
+			msr->available = 0;
+			break;
+
+		case 14:
+			msr->idx = HV_X64_MSR_RESET;
+			msr->write = 0;
+			msr->available = 0;
+			break;
+		case 15:
+			feat.eax |= HV_MSR_RESET_AVAILABLE;
+			msr->write = 0;
+			msr->available = 1;
+			break;
+		case 16:
+			msr->write = 1;
+			msr->write_val = 0;
+			msr->available = 1;
+			break;
+
+		case 17:
+			msr->idx = HV_X64_MSR_REFERENCE_TSC;
+			msr->write = 0;
+			msr->available = 0;
+			break;
+		case 18:
+			feat.eax |= HV_MSR_REFERENCE_TSC_AVAILABLE;
+			msr->write = 0;
+			msr->available = 1;
+			break;
+		case 19:
+			msr->write = 1;
+			msr->write_val = 0;
+			msr->available = 1;
+			break;
+
+		case 20:
+			msr->idx = HV_X64_MSR_EOM;
+			msr->write = 0;
+			msr->available = 0;
+			break;
+		case 21:
+			/*
+			 * Remains unavailable even with KVM_CAP_HYPERV_SYNIC2
+			 * capability enabled and guest visible CPUID bit unset.
+			 */
+			cap.cap = KVM_CAP_HYPERV_SYNIC2;
+			vcpu_enable_cap(vm, VCPU_ID, &cap);
+			break;
+		case 22:
+			feat.eax |= HV_MSR_SYNIC_AVAILABLE;
+			msr->write = 0;
+			msr->available = 1;
+			break;
+		case 23:
+			msr->write = 1;
+			msr->write_val = 0;
+			msr->available = 1;
+			break;
+
+		case 24:
+			msr->idx = HV_X64_MSR_STIMER0_CONFIG;
+			msr->write = 0;
+			msr->available = 0;
+			break;
+		case 25:
+			feat.eax |= HV_MSR_SYNTIMER_AVAILABLE;
+			msr->write = 0;
+			msr->available = 1;
+			break;
+		case 26:
+			msr->write = 1;
+			msr->write_val = 0;
+			msr->available = 1;
+			break;
+		case 27:
+			/* Direct mode test */
+			msr->write = 1;
+			msr->write_val = 1 << 12;
+			msr->available = 0;
+			break;
+		case 28:
+			feat.edx |= HV_STIMER_DIRECT_MODE_AVAILABLE;
+			msr->available = 1;
+			break;
+
+		case 29:
+			msr->idx = HV_X64_MSR_EOI;
+			msr->write = 0;
+			msr->available = 0;
+			break;
+		case 30:
+			feat.eax |= HV_MSR_APIC_ACCESS_AVAILABLE;
+			msr->write = 1;
+			msr->write_val = 1;
+			msr->available = 1;
+			break;
+
+		case 31:
+			msr->idx = HV_X64_MSR_TSC_FREQUENCY;
+			msr->write = 0;
+			msr->available = 0;
+			break;
+		case 32:
+			feat.eax |= HV_ACCESS_FREQUENCY_MSRS;
+			msr->write = 0;
+			msr->available = 1;
+			break;
+		case 33:
+			/* Read only */
+			msr->write = 1;
+			msr->write_val = 1;
+			msr->available = 0;
+			break;
+
+		case 34:
+			msr->idx = HV_X64_MSR_REENLIGHTENMENT_CONTROL;
+			msr->write = 0;
+			msr->available = 0;
+			break;
+		case 35:
+			feat.eax |= HV_ACCESS_REENLIGHTENMENT;
+			msr->write = 0;
+			msr->available = 1;
+			break;
+		case 36:
+			msr->write = 1;
+			msr->write_val = 1;
+			msr->available = 1;
+			break;
+		case 37:
+			/* Can only write '0' */
+			msr->idx = HV_X64_MSR_TSC_EMULATION_STATUS;
+			msr->write = 1;
+			msr->write_val = 1;
+			msr->available = 0;
+			break;
+
+		case 38:
+			msr->idx = HV_X64_MSR_CRASH_P0;
+			msr->write = 0;
+			msr->available = 0;
+			break;
+		case 39:
+			feat.edx |= HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE;
+			msr->write = 0;
+			msr->available = 1;
+			break;
+		case 40:
+			msr->write = 1;
+			msr->write_val = 1;
+			msr->available = 1;
+			break;
+
+		case 41:
+			msr->idx = HV_X64_MSR_SYNDBG_STATUS;
+			msr->write = 0;
+			msr->available = 0;
+			break;
+		case 42:
+			feat.edx |= HV_FEATURE_DEBUG_MSRS_AVAILABLE;
+			dbg.eax |= HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING;
+			msr->write = 0;
+			msr->available = 1;
+			break;
+		case 43:
+			msr->write = 1;
+			msr->write_val = 0;
+			msr->available = 1;
+			break;
+
+		case 44:
+			/* END */
+			msr->idx = 0;
+			break;
+		}
+
+		hv_set_cpuid(vm, best, &feat, &recomm, &dbg);
+
+		if (msr->idx)
+			pr_debug("Stage %d: testing msr: 0x%x for %s\n", stage,
+				 msr->idx, msr->write ? "write" : "read");
+		else
+			pr_debug("Stage %d: finish\n", stage);
+
+		r = _vcpu_run(vm, VCPU_ID);
+		TEST_ASSERT(!r, "vcpu_run failed: %d\n", r);
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+			    "unexpected exit reason: %u (%s)",
+			    run->exit_reason, exit_reason_str(run->exit_reason));
+
+		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		case UCALL_SYNC:
+			TEST_ASSERT(uc.args[1] == stage,
+				    "Unexpected stage: %ld (%d expected)\n",
+				    uc.args[1], stage);
+			break;
+		case UCALL_ABORT:
+			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
+				  __FILE__, uc.args[1]);
+			return;
+		case UCALL_DONE:
+			return;
+		}
+
+		stage++;
+	}
+}
+
+static void guest_test_hcalls_access(struct kvm_vm *vm, struct hcall_data *hcall,
+				     void *input, void *output, struct kvm_cpuid2 *best)
+{
+	struct kvm_run *run;
+	struct ucall uc;
+	int stage = 0, r;
+	struct kvm_cpuid_entry2 feat = {
+		.function = HYPERV_CPUID_FEATURES,
+		.eax = HV_MSR_HYPERCALL_AVAILABLE
+	};
+	struct kvm_cpuid_entry2 recomm = {
+		.function = HYPERV_CPUID_ENLIGHTMENT_INFO
+	};
+	struct kvm_cpuid_entry2 dbg = {
+		.function = HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES
+	};
+
+	run = vcpu_state(vm, VCPU_ID);
+
+	while (true) {
+		switch (stage) {
+		case 0:
+			hcall->control = 0xdeadbeef;
+			hcall->expect = HV_STATUS_INVALID_HYPERCALL_CODE;
+			break;
+
+		case 1:
+			hcall->control = HVCALL_POST_MESSAGE;
+			hcall->expect = HV_STATUS_ACCESS_DENIED;
+			break;
+		case 2:
+			feat.ebx |= HV_POST_MESSAGES;
+			hcall->expect = HV_STATUS_INVALID_HYPERCALL_INPUT;
+			break;
+
+		case 3:
+			hcall->control = HVCALL_SIGNAL_EVENT;
+			hcall->expect = HV_STATUS_ACCESS_DENIED;
+			break;
+		case 4:
+			feat.ebx |= HV_SIGNAL_EVENTS;
+			hcall->expect = HV_STATUS_INVALID_HYPERCALL_INPUT;
+			break;
+
+		case 5:
+			hcall->control = HVCALL_RESET_DEBUG_SESSION;
+			hcall->expect = HV_STATUS_INVALID_HYPERCALL_CODE;
+			break;
+		case 6:
+			dbg.eax |= HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING;
+			hcall->expect = HV_STATUS_ACCESS_DENIED;
+			break;
+		case 7:
+			feat.ebx |= HV_DEBUGGING;
+			hcall->expect = HV_STATUS_OPERATION_DENIED;
+			break;
+
+		case 8:
+			hcall->control = HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE;
+			hcall->expect = HV_STATUS_ACCESS_DENIED;
+			break;
+		case 9:
+			recomm.eax |= HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED;
+			hcall->expect = HV_STATUS_SUCCESS;
+			break;
+		case 10:
+			hcall->control = HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX;
+			hcall->expect = HV_STATUS_ACCESS_DENIED;
+			break;
+		case 11:
+			recomm.eax |= HV_X64_EX_PROCESSOR_MASKS_RECOMMENDED;
+			hcall->expect = HV_STATUS_SUCCESS;
+			break;
+
+		case 12:
+			hcall->control = HVCALL_SEND_IPI;
+			hcall->expect = HV_STATUS_ACCESS_DENIED;
+			break;
+		case 13:
+			recomm.eax |= HV_X64_CLUSTER_IPI_RECOMMENDED;
+			hcall->expect = HV_STATUS_INVALID_HYPERCALL_INPUT;
+			break;
+		case 14:
+			/* Nothing in 'sparse banks' -> success */
+			hcall->control = HVCALL_SEND_IPI_EX;
+			hcall->expect = HV_STATUS_SUCCESS;
+			break;
+
+		case 15:
+			hcall->control = HVCALL_NOTIFY_LONG_SPIN_WAIT;
+			hcall->expect = HV_STATUS_ACCESS_DENIED;
+			break;
+		case 16:
+			recomm.ebx = 0xfff;
+			hcall->expect = HV_STATUS_SUCCESS;
+			break;
+
+		case 17:
+			/* END */
+			hcall->control = 0;
+			break;
+		}
+
+		hv_set_cpuid(vm, best, &feat, &recomm, &dbg);
+
+		if (hcall->control)
+			pr_debug("Stage %d: testing hcall: 0x%lx\n", stage,
+				 hcall->control);
+		else
+			pr_debug("Stage %d: finish\n", stage);
+
+		r = _vcpu_run(vm, VCPU_ID);
+		TEST_ASSERT(!r, "vcpu_run failed: %d\n", r);
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+			    "unexpected exit reason: %u (%s)",
+			    run->exit_reason, exit_reason_str(run->exit_reason));
+
+		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		case UCALL_SYNC:
+			TEST_ASSERT(uc.args[1] == stage,
+				    "Unexpected stage: %ld (%d expected)\n",
+				    uc.args[1], stage);
+			break;
+		case UCALL_ABORT:
+			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
+				  __FILE__, uc.args[1]);
+			return;
+		case UCALL_DONE:
+			return;
+		}
+
+		stage++;
+	}
+}
+
+int main(void)
+{
+	struct kvm_cpuid2 *best;
+	struct kvm_vm *vm;
+	vm_vaddr_t msr_gva, hcall_page, hcall_params;
+	struct kvm_enable_cap cap = {
+		.cap = KVM_CAP_HYPERV_ENFORCE_CPUID,
+		.args = {1}
+	};
+
+	/* Test MSRs */
+	vm = vm_create_default(VCPU_ID, 0, guest_msr);
+
+	msr_gva = vm_vaddr_alloc(vm, getpagesize(), 0x10000, 0, 0);
+	memset(addr_gva2hva(vm, msr_gva), 0x0, getpagesize());
+	vcpu_args_set(vm, VCPU_ID, 1, msr_gva);
+	vcpu_enable_cap(vm, VCPU_ID, &cap);
+
+	vcpu_set_hv_cpuid(vm, VCPU_ID);
+
+	best = kvm_get_supported_hv_cpuid();
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vm, VCPU_ID);
+	vm_handle_exception(vm, GP_VECTOR, guest_gp_handler);
+
+	pr_info("Testing access to Hyper-V specific MSRs\n");
+	guest_test_msrs_access(vm, addr_gva2hva(vm, msr_gva),
+			       best);
+	kvm_vm_free(vm);
+
+	/* Test hypercalls */
+	vm = vm_create_default(VCPU_ID, 0, guest_hcall);
+
+	/* Hypercall input/output */
+	hcall_page = vm_vaddr_alloc(vm, 2 * getpagesize(), 0x10000, 0, 0);
+	memset(addr_gva2hva(vm, hcall_page), 0x0, 2 * getpagesize());
+
+	hcall_params = vm_vaddr_alloc(vm, getpagesize(), 0x20000, 0, 0);
+	memset(addr_gva2hva(vm, hcall_page), 0x0, getpagesize());
+
+	vcpu_args_set(vm, VCPU_ID, 2, addr_gva2gpa(vm, hcall_page), hcall_params);
+	vcpu_enable_cap(vm, VCPU_ID, &cap);
+
+	vcpu_set_hv_cpuid(vm, VCPU_ID);
+
+	best = kvm_get_supported_hv_cpuid();
+
+	pr_info("Testing access to Hyper-V hypercalls\n");
+	guest_test_hcalls_access(vm, addr_gva2hva(vm, hcall_params),
+				 addr_gva2hva(vm, hcall_page),
+				 addr_gva2hva(vm, hcall_page) + getpagesize(),
+				 best);
+
+	kvm_vm_free(vm);
+}
-- 
2.31.1

