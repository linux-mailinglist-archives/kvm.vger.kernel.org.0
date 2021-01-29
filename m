Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98285308A69
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 17:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhA2Qhh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 11:37:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60529 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231758AbhA2Qgc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Jan 2021 11:36:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611938104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=d4EkjZHv3aQhO7MDtkrDXoF3N3i9BK5sLlGFVxdQjkQ=;
        b=Y0VAHAbb8aPQwFGqoN0VZkepisg8Wx5ajCpW9bHlzrt5+NgyO/bEMZjynIBdHizuI1CMY2
        D0XweAsvKwlO0tzaM8J+M/reF48SwIeTDgV9FZy53H8r+WvmasGs6YT7u89wr2UnsrUugW
        jgua/sxP06s2UaHxPKQBI6ksKk7iO9U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-q9_cCUFnPlSr4sRE8dQp_w-1; Fri, 29 Jan 2021 11:18:26 -0500
X-MC-Unique: q9_cCUFnPlSr4sRE8dQp_w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B31784A5E4;
        Fri, 29 Jan 2021 16:18:25 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.151])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10CF55C290;
        Fri, 29 Jan 2021 16:18:22 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Roth <michael.roth@amd.com>
Subject: [PATCH] selftest: kvm: x86: test KVM_GET_CPUID2 and guest visible CPUIDs against KVM_GET_SUPPORTED_CPUID
Date:   Fri, 29 Jan 2021 17:18:21 +0100
Message-Id: <20210129161821.74635-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 181f494888d5 ("KVM: x86: fix CPUID entries returned by
KVM_GET_CPUID2 ioctl") revealed that we're not testing KVM_GET_CPUID2
ioctl at all. Add a test for it and also check that from inside the guest
visible CPUIDs are equal to it's output.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/.gitignore        |   5 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/processor.h  |  14 ++
 .../selftests/kvm/lib/x86_64/processor.c      |  42 +++++
 .../selftests/kvm/x86_64/get_cpuid_test.c     | 175 ++++++++++++++++++
 5 files changed, 237 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/get_cpuid_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index ce8f4ad39684..3194df487404 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -7,6 +7,7 @@
 /x86_64/cr4_cpuid_sync_test
 /x86_64/debug_regs
 /x86_64/evmcs_test
+/x86_64/get_cpuid_test
 /x86_64/kvm_pv_test
 /x86_64/hyperv_cpuid
 /x86_64/mmio_warning_test
@@ -17,6 +18,7 @@
 /x86_64/svm_vmcall_test
 /x86_64/sync_regs_test
 /x86_64/tsc_msrs_test
+/x86_64/user_msr_test
 /x86_64/userspace_msr_exit_test
 /x86_64/vmx_apic_access_test
 /x86_64/vmx_close_while_nested_test
@@ -24,8 +26,11 @@
 /x86_64/vmx_preemption_timer_test
 /x86_64/vmx_set_nested_state_test
 /x86_64/vmx_tsc_adjust_test
+/x86_64/xen_shinfo_test
+/x86_64/xen_vmcall_test
 /x86_64/xss_msr_test
 /demand_paging_test
+/clear_dirty_log_test
 /dirty_log_test
 /dirty_log_perf_test
 /kvm_create_max_vcpus
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index fe41c6a0fa67..b4743fd0d37b 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -40,6 +40,7 @@ LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_ha
 
 TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
 TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
+TEST_GEN_PROGS_x86_64 += x86_64/get_cpuid_test
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
 TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
 TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 90cd5984751b..c8ab021a3b6e 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -263,6 +263,19 @@ static inline void outl(uint16_t port, uint32_t value)
 	__asm__ __volatile__("outl %%eax, %%dx" : : "d"(port), "a"(value));
 }
 
+static inline void cpuid(uint32_t *eax, uint32_t *ebx,
+			 uint32_t *ecx, uint32_t *edx)
+{
+	/* ecx is often an input as well as an output. */
+	asm volatile("cpuid"
+	    : "=a" (*eax),
+	      "=b" (*ebx),
+	      "=c" (*ecx),
+	      "=d" (*edx)
+	    : "0" (*eax), "2" (*ecx)
+	    : "memory");
+}
+
 #define SET_XMM(__var, __xmm) \
 	asm volatile("movq %0, %%"#__xmm : : "r"(__var) : #__xmm)
 
@@ -340,6 +353,7 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid,
 struct kvm_msr_list *kvm_get_msr_index_list(void);
 
 struct kvm_cpuid2 *kvm_get_supported_cpuid(void);
+struct kvm_cpuid2 *vcpu_get_cpuid(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_set_cpuid(struct kvm_vm *vm, uint32_t vcpuid,
 		    struct kvm_cpuid2 *cpuid);
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 95e1a757c629..7a4dea86fad0 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -669,6 +669,48 @@ struct kvm_cpuid2 *kvm_get_supported_cpuid(void)
 	return cpuid;
 }
 
+/*
+ * VM VCPU CPUID Set
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   vcpuid - VCPU id
+ *
+ * Output Args: None
+ *
+ * Return: KVM CPUID (KVM_GET_CPUID2)
+ *
+ * Set the VCPU's CPUID.
+ */
+struct kvm_cpuid2 *vcpu_get_cpuid(struct kvm_vm *vm, uint32_t vcpuid)
+{
+	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
+	struct kvm_cpuid2 *cpuid;
+	int rc, max_ent;
+
+	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
+
+	cpuid = allocate_kvm_cpuid2();
+	max_ent = cpuid->nent;
+
+	for (cpuid->nent = 1; cpuid->nent <= max_ent; cpuid->nent++) {
+		rc = ioctl(vcpu->fd, KVM_GET_CPUID2, cpuid);
+		if (!rc)
+			break;
+
+		TEST_ASSERT(rc == -1 && errno == E2BIG,
+			    "KVM_GET_CPUID2 should either succeed or give E2BIG: %d %d",
+			    rc, errno);
+	}
+
+	TEST_ASSERT(rc == 0, "KVM_GET_CPUID2 failed, rc: %i errno: %i",
+		    rc, errno);
+
+	return cpuid;
+}
+
+
+
 /*
  * Locate a cpuid entry.
  *
diff --git a/tools/testing/selftests/kvm/x86_64/get_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/get_cpuid_test.c
new file mode 100644
index 000000000000..9b78e8889638
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/get_cpuid_test.c
@@ -0,0 +1,175 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2021, Red Hat Inc.
+ *
+ * Generic tests for KVM CPUID set/get ioctls
+ */
+#include <asm/kvm_para.h>
+#include <linux/kvm_para.h>
+#include <stdint.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+#define VCPU_ID 0
+
+/* CPUIDs known to differ */
+struct {
+	u32 function;
+	u32 index;
+} mangled_cpuids[] = {
+	{.function = 0xd, .index = 0},
+};
+
+static void test_guest_cpuids(struct kvm_cpuid2 *guest_cpuid)
+{
+	int i;
+	u32 eax, ebx, ecx, edx;
+
+	for (i = 0; i < guest_cpuid->nent; i++) {
+		eax = guest_cpuid->entries[i].function;
+		ecx = guest_cpuid->entries[i].index;
+
+		cpuid(&eax, &ebx, &ecx, &edx);
+
+		GUEST_ASSERT(eax == guest_cpuid->entries[i].eax &&
+			     ebx == guest_cpuid->entries[i].ebx &&
+			     ecx == guest_cpuid->entries[i].ecx &&
+			     edx == guest_cpuid->entries[i].edx);
+	}
+
+}
+
+static void test_cpuid_40000000(struct kvm_cpuid2 *guest_cpuid)
+{
+	u32 eax = 0x40000000, ebx, ecx = 0, edx;
+
+	cpuid(&eax, &ebx, &ecx, &edx);
+
+	GUEST_ASSERT(eax == 0x40000001);
+}
+
+static void guest_main(struct kvm_cpuid2 *guest_cpuid)
+{
+	GUEST_SYNC(1);
+
+	test_guest_cpuids(guest_cpuid);
+
+	GUEST_SYNC(2);
+
+	test_cpuid_40000000(guest_cpuid);
+
+	GUEST_DONE();
+}
+
+static bool is_cpuid_mangled(struct kvm_cpuid_entry2 *entrie)
+{
+	int i;
+
+	for (i = 0; i < sizeof(mangled_cpuids); i++) {
+		if (mangled_cpuids[i].function == entrie->function &&
+		    mangled_cpuids[i].index == entrie->index)
+			return true;
+	}
+
+	return false;
+}
+
+static void check_cpuid(struct kvm_cpuid2 *cpuid, struct kvm_cpuid_entry2 *entrie)
+{
+	int i;
+
+	for (i = 0; i < cpuid->nent; i++) {
+		if (cpuid->entries[i].function == entrie->function &&
+		    cpuid->entries[i].index == entrie->index) {
+			if (is_cpuid_mangled(entrie))
+				return;
+
+			TEST_ASSERT(cpuid->entries[i].eax == entrie->eax &&
+				    cpuid->entries[i].ebx == entrie->ebx &&
+				    cpuid->entries[i].ecx == entrie->ecx &&
+				    cpuid->entries[i].edx == entrie->edx,
+				    "CPUID 0x%x.%x differ: 0x%x:0x%x:0x%x:0x%x vs 0x%x:0x%x:0x%x:0x%x",
+				    entrie->function, entrie->index,
+				    cpuid->entries[i].eax, cpuid->entries[i].ebx,
+				    cpuid->entries[i].ecx, cpuid->entries[i].edx,
+				    entrie->eax, entrie->ebx, entrie->ecx, entrie->edx);
+			return;
+		}
+	}
+
+	TEST_ASSERT(false, "CPUID 0x%x.%x not found", entrie->function, entrie->index);
+}
+
+static void compare_cpuids(struct kvm_cpuid2 *cpuid1, struct kvm_cpuid2 *cpuid2)
+{
+	int i;
+
+	for (i = 0; i < cpuid1->nent; i++)
+		check_cpuid(cpuid2, &cpuid1->entries[i]);
+
+	for (i = 0; i < cpuid2->nent; i++)
+		check_cpuid(cpuid1, &cpuid2->entries[i]);
+}
+
+static void run_vcpu(struct kvm_vm *vm, uint32_t vcpuid, int stage)
+{
+	struct ucall uc;
+
+	_vcpu_run(vm, vcpuid);
+
+	switch (get_ucall(vm, vcpuid, &uc)) {
+	case UCALL_SYNC:
+		TEST_ASSERT(!strcmp((const char *)uc.args[0], "hello") &&
+			    uc.args[1] == stage + 1,
+			    "Stage %d: Unexpected register values vmexit, got %lx",
+			    stage + 1, (ulong)uc.args[1]);
+		return;
+	case UCALL_DONE:
+		return;
+	case UCALL_ABORT:
+		TEST_ASSERT(false, "%s at %s:%ld\n\tvalues: %#lx, %#lx", (const char *)uc.args[0],
+			    __FILE__, uc.args[1], uc.args[2], uc.args[3]);
+	default:
+		TEST_ASSERT(false, "Unexpected exit: %s",
+			    exit_reason_str(vcpu_state(vm, vcpuid)->exit_reason));
+	}
+}
+
+struct kvm_cpuid2 *vcpu_alloc_cpuid(struct kvm_vm *vm, vm_vaddr_t *p_gva, struct kvm_cpuid2 *cpuid)
+{
+	int size = sizeof(*cpuid) + cpuid->nent * sizeof(cpuid->entries[0]);
+	vm_vaddr_t gva = vm_vaddr_alloc(vm, size,
+					getpagesize(), 0, 0);
+	struct kvm_cpuid2 *guest_cpuids = addr_gva2hva(vm, gva);
+
+	memcpy(guest_cpuids, cpuid, size);
+
+	*p_gva = gva;
+	return guest_cpuids;
+}
+
+int main(void)
+{
+	struct kvm_cpuid2 *supp_cpuid, *cpuid2;
+	vm_vaddr_t cpuid_gva;
+	struct kvm_vm *vm;
+	int stage;
+
+	vm = vm_create_default(VCPU_ID, 0, guest_main);
+
+	supp_cpuid = kvm_get_supported_cpuid();
+	cpuid2 = vcpu_get_cpuid(vm, VCPU_ID);
+
+	compare_cpuids(supp_cpuid, cpuid2);
+
+	vcpu_alloc_cpuid(vm, &cpuid_gva, cpuid2);
+
+	vcpu_args_set(vm, VCPU_ID, 1, cpuid_gva);
+
+	for (stage = 0; stage < 3; stage++)
+		run_vcpu(vm, VCPU_ID, stage);
+
+	kvm_vm_free(vm);
+}
-- 
2.29.2

