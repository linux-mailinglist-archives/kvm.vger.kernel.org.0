Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158842AF095
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 13:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgKKM10 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 07:27:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28031 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726594AbgKKM1Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Nov 2020 07:27:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605097641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ffA97EzGB5rRuABrmS6/BfUuoLJg5JkQY1klvb1120s=;
        b=iDAvCf3CkKK1NwOrlUvyJi0H23k4A4QwJOM+JaqwQGnn2VHcxRoAJCCWfVp03rJUYWSoIZ
        TkX2MWJlqBooayaMX3h73je8uRZem3fslTMgjum0FYrhbFEFCU9CgJ7wYoF4fqAboJYGf4
        OQzCQLZD4rSS7Poxt1P5l32U8qiLOC4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-AzdslHXcOhG_dg7wVgT9Mg-1; Wed, 11 Nov 2020 07:27:19 -0500
X-MC-Unique: AzdslHXcOhG_dg7wVgT9Mg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C9C1805EF7;
        Wed, 11 Nov 2020 12:27:18 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 624325DA6A;
        Wed, 11 Nov 2020 12:27:11 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
Subject: [PATCH v2 10/11] KVM: selftests: x86: Set supported CPUIDs on default VM
Date:   Wed, 11 Nov 2020 13:26:35 +0100
Message-Id: <20201111122636.73346-11-drjones@redhat.com>
In-Reply-To: <20201111122636.73346-1-drjones@redhat.com>
References: <20201111122636.73346-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Almost all tests do this anyway and the ones that don't don't
appear to care. Only vmx_set_nested_state_test assumes that
a feature (VMX) is disabled until later setting the supported
CPUIDs. It's better to disable that explicitly anyway.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c  |  3 ---
 tools/testing/selftests/kvm/lib/kvm_util.c    | 11 ++++++++--
 .../selftests/kvm/lib/perf_test_util.c        |  4 ----
 .../selftests/kvm/set_memory_region_test.c    |  2 --
 .../kvm/x86_64/cr4_cpuid_sync_test.c          |  1 -
 .../testing/selftests/kvm/x86_64/debug_regs.c |  1 -
 .../testing/selftests/kvm/x86_64/evmcs_test.c |  2 --
 tools/testing/selftests/kvm/x86_64/smm_test.c |  2 --
 .../testing/selftests/kvm/x86_64/state_test.c |  1 -
 .../selftests/kvm/x86_64/svm_vmcall_test.c    |  1 -
 .../selftests/kvm/x86_64/tsc_msrs_test.c      |  1 -
 .../selftests/kvm/x86_64/user_msr_test.c      |  1 -
 .../kvm/x86_64/vmx_apic_access_test.c         |  1 -
 .../kvm/x86_64/vmx_close_while_nested_test.c  |  1 -
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c |  1 -
 .../kvm/x86_64/vmx_preemption_timer_test.c    |  1 -
 .../kvm/x86_64/vmx_set_nested_state_test.c    | 21 +++++++++++++++++++
 .../kvm/x86_64/vmx_tsc_adjust_test.c          |  1 -
 18 files changed, 30 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 2e0dcd453ef0..0d81b8551c51 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -424,9 +424,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	/* Cache the HVA pointer of the region */
 	host_test_mem = addr_gpa2hva(vm, (vm_paddr_t)guest_test_phys_mem);
 
-#ifdef __x86_64__
-	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
-#endif
 	ucall_init(vm, NULL);
 
 	/* Export the shared variables to the guest */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index ff4a0310c420..f81c8d2a25f4 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -294,8 +294,15 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
 	vm_create_irqchip(vm);
 #endif
 
-	for (i = 0; i < nr_vcpus; ++i)
-		vm_vcpu_add_default(vm, vcpuids ? vcpuids[i] : i, guest_code);
+	for (i = 0; i < nr_vcpus; ++i) {
+		uint32_t vcpuid = vcpuids ? vcpuids[i] : i;
+
+		vm_vcpu_add_default(vm, vcpuid, guest_code);
+
+#ifdef __x86_64__
+		vcpu_set_cpuid(vm, vcpuid, kvm_get_supported_cpuid());
+#endif
+	}
 
 	return vm;
 }
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 63329f1e6398..700863ea7863 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -121,10 +121,6 @@ void perf_test_add_vcpus(struct kvm_vm *vm, int vcpus, uint64_t vcpu_memory_byte
 	for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++) {
 		vcpu_args = &perf_test_args.vcpu_args[vcpu_id];
 
-#ifdef __x86_64__
-		vcpu_set_cpuid(vm, vcpu_id, kvm_get_supported_cpuid());
-#endif
-
 		vcpu_args->vcpu_id = vcpu_id;
 		vcpu_args->gva = guest_test_virt_mem +
 				 (vcpu_id * vcpu_memory_bytes);
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index b3ece55a2da6..5fa5823661da 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -121,8 +121,6 @@ static struct kvm_vm *spawn_vm(pthread_t *vcpu_thread, void *guest_code)
 
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
 
-	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
-
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_THP,
 				    MEM_REGION_GPA, MEM_REGION_SLOT,
 				    MEM_REGION_SIZE / getpagesize(), 0);
diff --git a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
index 140e91901582..f40fd097cb35 100644
--- a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
@@ -81,7 +81,6 @@ int main(int argc, char *argv[])
 
 	/* Create VM */
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
-	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 	run = vcpu_state(vm, VCPU_ID);
 
 	while (1) {
diff --git a/tools/testing/selftests/kvm/x86_64/debug_regs.c b/tools/testing/selftests/kvm/x86_64/debug_regs.c
index 2fc6b3af81a1..6097a8283377 100644
--- a/tools/testing/selftests/kvm/x86_64/debug_regs.c
+++ b/tools/testing/selftests/kvm/x86_64/debug_regs.c
@@ -85,7 +85,6 @@ int main(void)
 	}
 
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
-	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 	run = vcpu_state(vm, VCPU_ID);
 
 	/* Test software BPs - int3 */
diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index 757928199f19..37b8a78f6b74 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -92,8 +92,6 @@ int main(int argc, char *argv[])
 	/* Create VM */
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
 
-	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
-
 	if (!nested_vmx_supported() ||
 	    !kvm_check_cap(KVM_CAP_NESTED_STATE) ||
 	    !kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
index ae39a220609f..613c42c5a9b8 100644
--- a/tools/testing/selftests/kvm/x86_64/smm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
@@ -102,8 +102,6 @@ int main(int argc, char *argv[])
 	/* Create VM */
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
 
-	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
-
 	run = vcpu_state(vm, VCPU_ID);
 
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, SMRAM_GPA,
diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
index f6c8b9042f8a..32854c1462ad 100644
--- a/tools/testing/selftests/kvm/x86_64/state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/state_test.c
@@ -165,7 +165,6 @@ int main(int argc, char *argv[])
 
 	/* Create VM */
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
-	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 	run = vcpu_state(vm, VCPU_ID);
 
 	vcpu_regs_get(vm, VCPU_ID, &regs1);
diff --git a/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c b/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
index 0e1adb4e3199..be2ca157485b 100644
--- a/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
+++ b/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
@@ -44,7 +44,6 @@ int main(int argc, char *argv[])
 	nested_svm_check_supported();
 
 	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
-	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 
 	vcpu_alloc_svm(vm, &svm_gva);
 	vcpu_args_set(vm, VCPU_ID, 1, svm_gva);
diff --git a/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c b/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
index f8e761149daa..e357d8e222d4 100644
--- a/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
@@ -107,7 +107,6 @@ int main(void)
 	uint64_t val;
 
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
-	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 
 	val = 0;
 	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), val);
diff --git a/tools/testing/selftests/kvm/x86_64/user_msr_test.c b/tools/testing/selftests/kvm/x86_64/user_msr_test.c
index cbe1b08890ff..013766547084 100644
--- a/tools/testing/selftests/kvm/x86_64/user_msr_test.c
+++ b/tools/testing/selftests/kvm/x86_64/user_msr_test.c
@@ -205,7 +205,6 @@ int main(int argc, char *argv[])
 
 	/* Create VM */
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
-	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 	run = vcpu_state(vm, VCPU_ID);
 
 	rc = kvm_check_cap(KVM_CAP_X86_USER_SPACE_MSR);
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c b/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c
index 1f65342d6cb7..d14888b34adb 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c
@@ -87,7 +87,6 @@ int main(int argc, char *argv[])
 	nested_vmx_check_supported();
 
 	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
-	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 
 	kvm_get_cpu_address_width(&paddr_width, &vaddr_width);
 	high_gpa = (1ul << paddr_width) - getpagesize();
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c b/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
index fe40ade06a49..2835a17f1b7a 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
@@ -57,7 +57,6 @@ int main(int argc, char *argv[])
 	nested_vmx_check_supported();
 
 	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
-	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 
 	/* Allocate VMX pages and shared descriptors (vmx_pages). */
 	vcpu_alloc_vmx(vm, &vmx_pages_gva);
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
index e894a638a155..537de1068554 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
@@ -82,7 +82,6 @@ int main(int argc, char *argv[])
 
 	/* Create VM */
 	vm = vm_create_default(VCPU_ID, 0, l1_guest_code);
-	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 	vmx = vcpu_alloc_vmx(vm, &vmx_pages_gva);
 	vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
 	run = vcpu_state(vm, VCPU_ID);
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
index a7737af1224f..150c98263273 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
@@ -171,7 +171,6 @@ int main(int argc, char *argv[])
 
 	/* Create VM */
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
-	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 	run = vcpu_state(vm, VCPU_ID);
 
 	vcpu_regs_get(vm, VCPU_ID, &regs1);
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
index d59f3eb67c8f..8438690b97e3 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
@@ -244,6 +244,22 @@ void test_vmx_nested_state(struct kvm_vm *vm)
 	free(state);
 }
 
+void disable_vmx(struct kvm_vm *vm)
+{
+	struct kvm_cpuid2 *cpuid = kvm_get_supported_cpuid();
+	int i;
+
+	for (i = 0; i < cpuid->nent; ++i)
+		if (cpuid->entries[i].function == 1 &&
+		    cpuid->entries[i].index == 0)
+			break;
+	TEST_ASSERT(i != cpuid->nent, "CPUID function 1 not found");
+
+	cpuid->entries[i].ecx &= ~CPUID_VMX;
+
+	vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+}
+
 int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
@@ -264,6 +280,11 @@ int main(int argc, char *argv[])
 
 	vm = vm_create_default(VCPU_ID, 0, 0);
 
+	/*
+	 * First run tests with VMX disabled to check error handling.
+	 */
+	disable_vmx(vm);
+
 	/* Passing a NULL kvm_nested_state causes a EFAULT. */
 	test_nested_state_expect_efault(vm, NULL);
 
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c b/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
index fbe8417cbc2c..7e33a350b053 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
@@ -132,7 +132,6 @@ int main(int argc, char *argv[])
 	nested_vmx_check_supported();
 
 	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
-	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 
 	/* Allocate VMX pages and shared descriptors (vmx_pages). */
 	vcpu_alloc_vmx(vm, &vmx_pages_gva);
-- 
2.26.2

