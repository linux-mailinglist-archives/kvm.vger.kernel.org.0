Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2319D228E9B
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 05:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731997AbgGVD0x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 23:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731972AbgGVD0v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 23:26:51 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009D5C061794
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 20:26:50 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id a127so894381ybb.14
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 20:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kxNEfBM7ENNKZI53NI7iJ5F3jfNMKQEbzfAIc7w8mBE=;
        b=Epp9x2xFMhOwpxazu420dtxp/wIbWPV7l/Ho74AnNjLp2wNzPV5cnxeKmK/sdXz0Jf
         zKNMvZE7C3unUGJikcy9LZ47yx9tPnEQAzYONT0208VF0cXVkP2b36RXnSseCrT7/c9h
         xv0kgtDYgUfpKrLnCQN7l97kbUyC4mYBSKjMDzagyWicHw1EACXiDPlvO2B9h07Y+ehF
         tdgGVSX7fiY2PkF0yysohjtrey3B6/4XGktifohg62D/2COHZnWc5SloK8VdYtKlBS6q
         BphZjWhgqF4A3hwoga2fQapaBWDkayEBquI7G28hO/EfBPW8V1Ef66V/Lpqjhmo/3PXN
         mN9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kxNEfBM7ENNKZI53NI7iJ5F3jfNMKQEbzfAIc7w8mBE=;
        b=SBfghi0tlHMyekXL5SdASmeWfbVkSZqBO56jADlrsSHYUYBHnNy7sr0qsU16lU6faO
         Kh+bbCCDTu8RevF7hfChPf3YpZ4Xsogy7sCTqYBBIvetjcWip/AIOaSUaR3H3BBC1XcW
         oDCVl/7gXK4IozfvvCL7ZN9FVHVKbFAZrB2yEcmC7C+UscjtvAxuccriSvgumUnrpn2o
         3+S1y1Wo26yUNEsRYLf6TruUtRvTJJUyz1LoBLr/pQR2AMFODtFlPMfzczbFX55Qifrz
         QCgLgCarRV/NaW8zxb0GE4JR97RrMYehN05eB2jT4sYnCgMU1fGfAbbZzLWCMi/Trs1x
         ld3g==
X-Gm-Message-State: AOAM5306jznppZM6zjyNROFHoRtesze909PhXmHeDW5FpyqLfufGluus
        WnXY5rzpav2o+fjl8NO8BhhnGeLNuCmxRYaUfJ+cu9Q+RcdfPcYMIldNF0LbQoTDBfxDwo30YAu
        +pPF9UFd4f1pNSWlstj/s7b1Xdwp2RxB0/ng5jAoTvwBgW5WiPyf+nWUx1A==
X-Google-Smtp-Source: ABdhPJzImRusPe+EcyONzHsNvBQP9n2XAeChjBs5Tz6Gs/v3j43CPaP33OwLXlGdY2ofCPsU7dX93ZajxD8=
X-Received: by 2002:a25:d4d6:: with SMTP id m205mr47933625ybf.7.1595388410138;
 Tue, 21 Jul 2020 20:26:50 -0700 (PDT)
Date:   Wed, 22 Jul 2020 03:26:29 +0000
In-Reply-To: <20200722032629.3687068-1-oupton@google.com>
Message-Id: <20200722032629.3687068-6-oupton@google.com>
Mime-Version: 1.0
References: <20200722032629.3687068-1-oupton@google.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH v3 5/5] selftests: kvm: introduce tsc_offset_test
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Hornyack <peterhornyack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test the KVM_{GET,SET}_TSC_OFFSET ioctls. Ensure the following:
 - KVM_GET_TSC_OFFSET returns the value written by KVM_SET_TSC_OFFSET
 - The L1 TSC is appropriately adjusted based on the written value
 - Guest manipulation of the TSC results in a changed offset in
   KVM_GET_TSC_OFFSET
 - Modifying the TSC offset while in guest mode affects L2 guest
 - Modification in guest mode is also reflected in L1

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/test_util.h |   3 +
 .../selftests/kvm/include/x86_64/svm_util.h   |   5 +
 .../selftests/kvm/include/x86_64/vmx.h        |   9 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |   1 +
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |  11 +
 .../selftests/kvm/x86_64/tsc_offset_test.c    | 362 ++++++++++++++++++
 8 files changed, 393 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/tsc_offset_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 452787152748..f5608692b43a 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -11,6 +11,7 @@
 /x86_64/set_sregs_test
 /x86_64/smm_test
 /x86_64/state_test
+/x86_64/tsc_offset_test
 /x86_64/vmx_preemption_timer_test
 /x86_64/svm_vmcall_test
 /x86_64/sync_regs_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 4a166588d99f..03dfaa49c3c4 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -55,6 +55,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
 TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
 TEST_GEN_PROGS_x86_64 += x86_64/debug_regs
+TEST_GEN_PROGS_x86_64 += x86_64/tsc_offset_test
 TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index 5eb01bf51b86..cb6a76e2b39a 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -65,4 +65,7 @@ struct timespec timespec_add_ns(struct timespec ts, int64_t ns);
 struct timespec timespec_add(struct timespec ts1, struct timespec ts2);
 struct timespec timespec_sub(struct timespec ts1, struct timespec ts2);
 
+#define swap(a, b) \
+	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
+
 #endif /* SELFTEST_KVM_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
index 47a13aaee460..ef2791be3f6b 100644
--- a/tools/testing/selftests/kvm/include/x86_64/svm_util.h
+++ b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
@@ -43,4 +43,9 @@ static inline bool cpu_has_svm(void)
 	return r.c & CPUID_SVM;
 }
 
+static inline void vmmcall(void)
+{
+	__asm__ __volatile__("vmmcall");
+}
+
 #endif /* SELFTEST_KVM_SVM_UTILS_H */
diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index 16fa21ebb99c..d70bf4f350f8 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -602,6 +602,8 @@ struct vmx_pages *vcpu_alloc_vmx(struct kvm_vm *vm, vm_vaddr_t *p_vmx_gva);
 bool prepare_for_vmx_operation(struct vmx_pages *vmx);
 void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp);
 bool load_vmcs(struct vmx_pages *vmx);
+void generic_vmx_setup(struct vmx_pages *vmx, void *guest_rip,
+		       void *guest_rsp);
 
 bool nested_vmx_supported(void);
 void nested_vmx_check_supported(void);
@@ -616,4 +618,11 @@ void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
 void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
 		  uint32_t eptp_memslot);
 
+static inline bool cpu_has_vmx(void)
+{
+	struct cpuid r = raw_cpuid(1, 0);
+
+	return r.c & CPUID_VMX;
+}
+
 #endif /* SELFTEST_KVM_VMX_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 74776ee228f2..1b9bd2ed58c8 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -23,6 +23,7 @@
 static void *align(void *x, size_t size)
 {
 	size_t mask = size - 1;
+
 	TEST_ASSERT(size != 0 && !(size & (size - 1)),
 		    "size not a power of 2: %lu", size);
 	return (void *) (((size_t) x + mask) & ~mask);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index f1e00d43eea2..a5fb3bca0219 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -542,3 +542,14 @@ void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
 	vmx->eptp_hva = addr_gva2hva(vm, (uintptr_t)vmx->eptp);
 	vmx->eptp_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->eptp);
 }
+
+void generic_vmx_setup(struct vmx_pages *vmx_pages, void *guest_rip,
+		       void *guest_rsp)
+{
+	GUEST_ASSERT(vmx_pages && vmx_pages->vmcs_gpa);
+	GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
+	GUEST_ASSERT(load_vmcs(vmx_pages));
+	GUEST_ASSERT(vmptrstz() == vmx_pages->vmcs_gpa);
+	prepare_vmcs(vmx_pages, guest_rip, guest_rsp);
+}
+
diff --git a/tools/testing/selftests/kvm/x86_64/tsc_offset_test.c b/tools/testing/selftests/kvm/x86_64/tsc_offset_test.c
new file mode 100644
index 000000000000..7d39374e82c1
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/tsc_offset_test.c
@@ -0,0 +1,362 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * TSC offset test
+ *
+ * Copyright (C) 2020, Google, LLC.
+ *
+ * Test to ensure that userspace control of the TSC offset field behaves as
+ * expected for both non-nested and nested guests.
+ */
+#include "kvm_util.h"
+#include "processor.h"
+#include "svm_util.h"
+#include "test_util.h"
+#include "vmx.h"
+
+#include "kselftest.h"
+
+#define L1_TSC_WRITE_VALUE 0
+#define L2_GUEST_STACK_SIZE 64
+#define L1_TSC_OFFSET (1ul << 48)
+#define L2_TSC_OFFSET -L1_TSC_OFFSET
+#define VCPU_ID 1
+
+bool vmx;
+
+void set_tsc_offset(struct kvm_vm *vm, u32 vcpuid, u64 val)
+{
+	vcpu_ioctl(vm, vcpuid, KVM_SET_TSC_OFFSET, &val);
+}
+
+void get_tsc_offset(struct kvm_vm *vm, u32 vcpuid, u64 *out)
+{
+	vcpu_ioctl(vm, vcpuid, KVM_GET_TSC_OFFSET, out);
+}
+
+void get_clock(struct kvm_vm *vm, struct kvm_clock_data *out)
+{
+	vm_ioctl(vm, KVM_GET_CLOCK, out);
+}
+
+/*
+ * Test that reading the TSC offset returns the previously written value.
+ */
+void set_get_tsc_offset_test(struct kvm_vm *vm, u32 vcpuid)
+{
+	u64 val;
+
+	set_tsc_offset(vm, vcpuid, L1_TSC_OFFSET);
+	get_tsc_offset(vm, vcpuid, &val);
+	TEST_ASSERT(val == L1_TSC_OFFSET,
+		    "Expected %lu from GET_TSC_OFFSET but got %lu",
+		    L1_TSC_OFFSET, val);
+}
+
+void check_value_bounds(const char *name, int stage, u64 low, u64 high, u64 val)
+{
+	TEST_ASSERT(low <= val && val <= high,
+		    "Stage %d: expected %s value in the range [%lu, %lu] but got %lu",
+		    stage, name, low, high, val);
+
+	/* only reached if passed */
+	pr_info("Stage %d: %s: %lu, expected range: [%lu, %lu]\n", stage, name,
+		val, low, high);
+}
+
+void check_value_bounds_signed(const char *name, int stage, s64 low, s64 high,
+			       s64 val)
+{
+	TEST_ASSERT(low <= val && val <= high,
+		    "Stage %d: expected %s value in the range [%ld, %ld] but got %ld",
+		    stage, name, low, high, val);
+
+	/* only reached if passed */
+	pr_info("Stage %d: %s: %ld, expected range: [%ld, %ld]\n", stage, name,
+		val, low, high);
+}
+
+void check_value_bounds_overflow(const char *name, int stage, s64 low, s64 high,
+				 s64 val)
+{
+	TEST_ASSERT(val <= low || val >= high,
+		    "Stage %d: expected %s value outside the range [%ld, %ld] but got %ld",
+		    stage, name, low, high, val);
+
+	pr_info("Stage %d: %s: %ld, expected range: [-MAX, %ld], [%ld, MAX]\n",
+		stage, name, val, low, high);
+}
+
+void generic_vmcall(void)
+{
+	if (vmx)
+		vmcall();
+	else
+		vmmcall();
+}
+
+void l2_main(void)
+{
+	/* Allow userspace to manipulate the TSC offset */
+	GUEST_SYNC(3);
+	GUEST_SYNC_ARGS(4, rdtsc(), 0, 0, 0);
+	generic_vmcall();
+}
+
+void l0_nested_setup(struct kvm_vm *vm, u32 vcpuid)
+{
+	vm_vaddr_t nested_pages = 0;
+
+	if (vmx)
+		vcpu_alloc_vmx(vm, &nested_pages);
+	else
+		vcpu_alloc_svm(vm, &nested_pages);
+
+	vcpu_args_set(vm, VCPU_ID, 1, nested_pages);
+}
+
+void l1_nested_setup(void *nested_pages, void *guest_stack)
+{
+	if (vmx)
+		generic_vmx_setup(nested_pages, l2_main, guest_stack);
+	else
+		generic_svm_setup(nested_pages, l2_main, guest_stack);
+}
+
+void l1_set_tsc_offset(void *nested_pages, u64 offset)
+{
+	if (vmx) {
+		GUEST_ASSERT(!vmwrite(CPU_BASED_VM_EXEC_CONTROL,
+				      vmreadz(CPU_BASED_VM_EXEC_CONTROL) |
+				      CPU_BASED_USE_TSC_OFFSETTING));
+
+		GUEST_ASSERT(!vmwrite(TSC_OFFSET, offset));
+	} else {
+		struct svm_test_data *svm = nested_pages;
+
+		svm->vmcb->control.tsc_offset = offset;
+		/* Mark the TSC offset field as dirty */
+		svm->vmcb->control.clean &= ~1u;
+	}
+
+}
+
+void l1_enter_guest(void *nested_pages)
+{
+	if (vmx) {
+		/* We only enter L2 once, hence VMLAUNCH */
+		GUEST_ASSERT(!vmlaunch());
+	} else {
+		struct svm_test_data *svm = nested_pages;
+
+		run_guest(svm->vmcb, svm->vmcb_gpa);
+	}
+}
+
+void l1_assert_exit_vmcall(void *nested_pages)
+{
+	if (vmx) {
+		GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
+	} else {
+		struct svm_test_data *svm = nested_pages;
+
+		GUEST_ASSERT(svm->vmcb->control.exit_code == SVM_EXIT_VMMCALL);
+	}
+}
+
+void l1_main(void *nested_pages)
+{
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	bool nested;
+
+	/*
+	 * Guest doesn't share memory with userspace, determine VMX presence
+	 * inside guest.
+	 */
+	vmx = cpu_has_vmx();
+	nested = vmx || cpu_has_svm();
+
+	if (nested) {
+		l1_nested_setup(nested_pages,
+				&l2_guest_stack[L2_GUEST_STACK_SIZE]);
+		l1_set_tsc_offset(nested_pages, L2_TSC_OFFSET);
+	}
+
+	GUEST_SYNC_ARGS(1, rdtsc(), 0, 0, 0);
+
+	wrmsr(MSR_IA32_TSC, L1_TSC_WRITE_VALUE);
+	GUEST_SYNC(2);
+
+	if (!nested)
+		GUEST_DONE();
+
+	l1_enter_guest(nested_pages);
+	l1_assert_exit_vmcall(nested_pages);
+
+	GUEST_SYNC_ARGS(5, rdtsc(), 0, 0, 0);
+	GUEST_DONE();
+}
+
+int main(void)
+{
+	u64 start, stop, exp_low, exp_high;
+	struct kvm_clock_data clock_data;
+	struct kvm_run *run;
+	struct kvm_vm *vm;
+	struct ucall uc;
+	bool nested;
+	int stage;
+
+	if (!kvm_check_cap(KVM_CAP_TSC_OFFSET) ||
+	    !kvm_check_cap(KVM_CAP_ADJUST_CLOCK)) {
+		pr_info("will skip tsc offset tests\n");
+		return 0;
+	}
+
+	/*
+	 * Nested virtualization is not explicitly required for this test, but
+	 * gates the L2 tests.
+	 */
+	vmx = nested_vmx_supported();
+	nested = vmx || nested_svm_supported();
+
+	vm = vm_create_default(VCPU_ID, 0, (void *) l1_main);
+	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+	run = vcpu_state(vm, VCPU_ID);
+
+	if (nested)
+		l0_nested_setup(vm, VCPU_ID);
+
+	set_get_tsc_offset_test(vm, VCPU_ID);
+
+	for (stage = 1;; stage++) {
+		start = rdtsc();
+		_vcpu_run(vm, VCPU_ID);
+		stop = rdtsc();
+
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+			    "Stage %d: unexpected exit reason: %u (%s)\n",
+			    stage, run->exit_reason,
+			    exit_reason_str(run->exit_reason));
+
+		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		case UCALL_ABORT:
+			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
+				  __FILE__, uc.args[1]);
+			/* NOT REACHED */
+		case UCALL_SYNC:
+			break;
+		case UCALL_DONE:
+			goto stage6;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+
+		/*
+		 * Check that the guest's TSC value falls between expected
+		 * bounds, considering the written TSC offset.
+		 */
+		if (stage == 1) {
+			exp_low = start + L1_TSC_OFFSET;
+			exp_high = stop + L1_TSC_OFFSET;
+
+			check_value_bounds("L1 TSC", stage, exp_low, exp_high,
+					   uc.args[2]);
+
+			/*
+			 * KVM interprets writes to the TSC within a second of
+			 * elapsed time as an attempt to synchronize TSCs. In
+			 * order to get a TSC offset within expected bounds for
+			 * stage 2, we must sleep for a second to avoid such
+			 * handling of the TSC write.
+			 */
+			sleep(1);
+		/*
+		 * Check that guest writes to the TSC result in a TSC offset
+		 * value between the expected bounds, considering the original
+		 * TSC offset value.
+		 */
+		} else if (stage == 2) {
+			s64 tsc_offset, low, high;
+
+			low = L1_TSC_WRITE_VALUE - stop;
+			high = L1_TSC_WRITE_VALUE - start;
+
+			get_tsc_offset(vm, VCPU_ID, (u64 *) &tsc_offset);
+
+			/*
+			 * It is possible (though highly unlikely) that the
+			 * host's TSC crosses 2^63 ticks while we are running
+			 * the guest. In this case, the lower bound on the TSC
+			 * offset will have wrapped around into the positive
+			 * domain. In this case, we must instead assert that the
+			 * observed value exists outside of the range (high,
+			 * low).
+			 */
+			if (low > high) {
+				/*
+				 * Swap low and high such that the variable
+				 * names correctly imply their value.
+				 */
+				swap(low, high);
+				check_value_bounds_overflow("L1 TSC offset",
+							    stage, low, high,
+							    tsc_offset);
+			} else {
+				check_value_bounds_signed("L1 TSC offset",
+							  stage, low, high,
+							  tsc_offset);
+			}
+
+		/*
+		 * Write the TSC offset while in guest mode
+		 */
+		} else if (nested && stage == 3) {
+			set_tsc_offset(vm, VCPU_ID, L1_TSC_OFFSET);
+
+		/*
+		 * Check that the write to TSC offset affects L2's perception of
+		 * the TSC
+		 */
+		} else if (nested && stage == 4) {
+			exp_low = start + L1_TSC_OFFSET + L2_TSC_OFFSET;
+			exp_high = stop + L1_TSC_OFFSET + L2_TSC_OFFSET;
+
+			check_value_bounds("L2 TSC", stage, exp_low, exp_high,
+					   uc.args[2]);
+
+		/*
+		 * Check that the modified TSC offset is also observed in L1
+		 */
+		} else if (nested && stage == 5) {
+			exp_low = start + L1_TSC_OFFSET;
+			exp_high = stop + L1_TSC_OFFSET;
+
+			check_value_bounds("L1 TSC", stage, exp_low, exp_high,
+					   uc.args[2]);
+		} else {
+			TEST_FAIL("Unexpected stage %d\n", stage);
+		}
+	}
+
+	/*
+	 * Check that KVM sets the KVM_CLOCK_TSC_STABLE flag when vCPUs have an
+	 * equivalent TSC offset.
+	 */
+stage6:
+	vm_vcpu_add_default(vm, VCPU_ID + 1, NULL);
+	vcpu_set_cpuid(vm, VCPU_ID + 1, kvm_get_supported_cpuid());
+
+	set_tsc_offset(vm, VCPU_ID, L1_TSC_OFFSET),
+	set_tsc_offset(vm, VCPU_ID + 1, L1_TSC_OFFSET);
+	get_clock(vm, &clock_data);
+
+	TEST_ASSERT(clock_data.flags & KVM_CLOCK_TSC_STABLE,
+		    "Stage 6: expected KVM_CLOCK_TSC_STABLE (%#x) flag to be set but got %#x",
+		    KVM_CLOCK_TSC_STABLE, clock_data.flags);
+
+	pr_info("Stage 6: clock_data.flags = %#x, expected KVM_CLOCK_TSC_STABLE (%#x) flag\n",
+		clock_data.flags, KVM_CLOCK_TSC_STABLE);
+
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.28.0.rc0.142.g3c755180ce-goog

