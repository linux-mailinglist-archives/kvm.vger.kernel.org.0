Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A48427AD6D
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 14:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgI1MB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 08:01:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54269 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726573AbgI1MB6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 08:01:58 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601294516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y/UdGjPAJGJ2h0qtFm/U1BLa9fpLOzOU5/j4J/i16Gw=;
        b=ObUw6BD9XBHWmg3xTYPoxRxWHOpXpASxUAP4/Rr71o00RRJiX+Avv7hokzSv4BRZpblNH5
        kZjnGIilRTELWRaz2Bp5G2V4EEgjKDEoonQxNICfoqfvq0/JQDYt/YkrFpyk4GoyWz0wen
        dMPWEv+h31Hkn8NZjWnGxFggcUl3Pr4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-ku4Z5P0GOqCmhDkqN4pCtw-1; Mon, 28 Sep 2020 08:01:47 -0400
X-MC-Unique: ku4Z5P0GOqCmhDkqN4pCtw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4FBC81021D28;
        Mon, 28 Sep 2020 12:01:46 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECAD12C31E;
        Mon, 28 Sep 2020 12:01:45 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com
Subject: [PATCH] KVM: x86: do not attempt TSC synchronization on guest writes
Date:   Mon, 28 Sep 2020 08:01:45 -0400
Message-Id: <20200928120145.2447718-2-pbonzini@redhat.com>
In-Reply-To: <20200928120145.2447718-1-pbonzini@redhat.com>
References: <20200928120145.2447718-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM special-cases writes to MSR_IA32_TSC so that all CPUs have
the same base for the TSC.  This logic is complicated, and we
do not want it to have any effect once the VM is started.

In particular, if any guest started to synchronize its TSCs
with writes to MSR_IA32_TSC rather than MSR_IA32_TSC_ADJUST,
the additional effect of kvm_write_tsc code would be uncharted
territory.

Therefore, this patch makes writes to MSR_IA32_TSC behave
essentially the same as writes to MSR_IA32_TSC_ADJUST when
they come from the guest.  A new selftest (which passes
both before and after the patch) checks the current semantics
of writes to MSR_IA32_TSC and MSR_IA32_TSC_ADJUST originating
from both the host and the guest.

Upcoming work to remove the special side effects
of host-initiated writes to MSR_IA32_TSC and MSR_IA32_TSC_ADJUST
will be able to build onto this test, adjusting the host side
to use the new APIs and achieve the same effect.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c                            |  30 ++--
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/tsc_msrs_test.c      | 168 ++++++++++++++++++
 3 files changed, 179 insertions(+), 20 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 411f6103532b..c4015a43cc8a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2107,12 +2107,6 @@ static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu)
 #endif
 }
 
-static void update_ia32_tsc_adjust_msr(struct kvm_vcpu *vcpu, s64 offset)
-{
-	u64 curr_offset = vcpu->arch.l1_tsc_offset;
-	vcpu->arch.ia32_tsc_adjust_msr += offset - curr_offset;
-}
-
 /*
  * Multiply tsc by a fixed point number represented by ratio.
  *
@@ -2174,14 +2168,13 @@ static inline bool kvm_check_tsc_unstable(void)
 	return check_tsc_unstable();
 }
 
-void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr)
+static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 {
 	struct kvm *kvm = vcpu->kvm;
 	u64 offset, ns, elapsed;
 	unsigned long flags;
 	bool matched;
 	bool already_matched;
-	u64 data = msr->data;
 	bool synchronizing = false;
 
 	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
@@ -2190,7 +2183,7 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	elapsed = ns - kvm->arch.last_tsc_nsec;
 
 	if (vcpu->arch.virtual_tsc_khz) {
-		if (data == 0 && msr->host_initiated) {
+		if (data == 0) {
 			/*
 			 * detection of vcpu initialization -- need to sync
 			 * with other vCPUs. This particularly helps to keep
@@ -2260,9 +2253,6 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	vcpu->arch.this_tsc_nsec = kvm->arch.cur_tsc_nsec;
 	vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
 
-	if (!msr->host_initiated && guest_cpuid_has(vcpu, X86_FEATURE_TSC_ADJUST))
-		update_ia32_tsc_adjust_msr(vcpu, offset);
-
 	kvm_vcpu_write_tsc_offset(vcpu, offset);
 	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 
@@ -2277,8 +2267,6 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	spin_unlock(&kvm->arch.pvclock_gtod_sync_lock);
 }
 
-EXPORT_SYMBOL_GPL(kvm_write_tsc);
-
 static inline void adjust_tsc_offset_guest(struct kvm_vcpu *vcpu,
 					   s64 adjustment)
 {
@@ -3073,7 +3061,13 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.msr_ia32_power_ctl = data;
 		break;
 	case MSR_IA32_TSC:
-		kvm_write_tsc(vcpu, msr_info);
+		if (msr_info->host_initiated) {
+			kvm_synchronize_tsc(vcpu, data);
+		} else {
+			u64 adj = kvm_compute_tsc_offset(vcpu, data) - vcpu->arch.l1_tsc_offset;
+			adjust_tsc_offset_guest(vcpu, adj);
+			vcpu->arch.ia32_tsc_adjust_msr += adj;
+		}
 		break;
 	case MSR_IA32_XSS:
 		if (!msr_info->host_initiated &&
@@ -9839,7 +9833,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 {
-	struct msr_data msr;
 	struct kvm *kvm = vcpu->kvm;
 
 	kvm_hv_vcpu_postcreate(vcpu);
@@ -9847,10 +9840,7 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 	if (mutex_lock_killable(&vcpu->mutex))
 		return;
 	vcpu_load(vcpu);
-	msr.data = 0x0;
-	msr.index = MSR_IA32_TSC;
-	msr.host_initiated = true;
-	kvm_write_tsc(vcpu, &msr);
+	kvm_synchronize_tsc(vcpu, 0);
 	vcpu_put(vcpu);
 
 	/* poll control enabled by default */
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 80d5c348354c..7ebe71fbca53 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -55,6 +55,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
 TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
 TEST_GEN_PROGS_x86_64 += x86_64/debug_regs
+TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
 TEST_GEN_PROGS_x86_64 += x86_64/user_msr_test
 TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
diff --git a/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c b/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
new file mode 100644
index 000000000000..f8e761149daa
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
@@ -0,0 +1,168 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Tests for MSR_IA32_TSC and MSR_IA32_TSC_ADJUST.
+ *
+ * Copyright (C) 2020, Red Hat, Inc.
+ */
+#include <stdio.h>
+#include <string.h>
+#include "kvm_util.h"
+#include "processor.h"
+
+#define VCPU_ID 0
+
+#define UNITY                  (1ull << 30)
+#define HOST_ADJUST            (UNITY * 64)
+#define GUEST_STEP             (UNITY * 4)
+#define ROUND(x)               ((x + UNITY / 2) & -UNITY)
+#define rounded_rdmsr(x)       ROUND(rdmsr(x))
+#define rounded_host_rdmsr(x)  ROUND(vcpu_get_msr(vm, 0, x))
+
+#define GUEST_ASSERT_EQ(a, b) do {				\
+	__typeof(a) _a = (a);					\
+	__typeof(b) _b = (b);					\
+	if (_a != _b)						\
+                ucall(UCALL_ABORT, 4,				\
+                        "Failed guest assert: "			\
+                        #a " == " #b, __LINE__, _a, _b);	\
+  } while(0)
+
+static void guest_code(void)
+{
+	u64 val = 0;
+
+	GUEST_ASSERT_EQ(rounded_rdmsr(MSR_IA32_TSC), val);
+	GUEST_ASSERT_EQ(rounded_rdmsr(MSR_IA32_TSC_ADJUST), val);
+
+	/* Guest: writes to MSR_IA32_TSC affect both MSRs.  */
+	val = 1ull * GUEST_STEP;
+	wrmsr(MSR_IA32_TSC, val);
+	GUEST_ASSERT_EQ(rounded_rdmsr(MSR_IA32_TSC), val);
+	GUEST_ASSERT_EQ(rounded_rdmsr(MSR_IA32_TSC_ADJUST), val);
+
+	/* Guest: writes to MSR_IA32_TSC_ADJUST affect both MSRs.  */
+	GUEST_SYNC(2);
+	val = 2ull * GUEST_STEP;
+	wrmsr(MSR_IA32_TSC_ADJUST, val);
+	GUEST_ASSERT_EQ(rounded_rdmsr(MSR_IA32_TSC), val);
+	GUEST_ASSERT_EQ(rounded_rdmsr(MSR_IA32_TSC_ADJUST), val);
+
+	/* Host: setting the TSC offset.  */
+	GUEST_SYNC(3);
+	GUEST_ASSERT_EQ(rounded_rdmsr(MSR_IA32_TSC), HOST_ADJUST + val);
+	GUEST_ASSERT_EQ(rounded_rdmsr(MSR_IA32_TSC_ADJUST), val);
+
+	/*
+	 * Guest: writes to MSR_IA32_TSC_ADJUST do not destroy the
+	 * host-side offset and affect both MSRs.
+	 */
+	GUEST_SYNC(4);
+	val = 3ull * GUEST_STEP;
+	wrmsr(MSR_IA32_TSC_ADJUST, val);
+	GUEST_ASSERT_EQ(rounded_rdmsr(MSR_IA32_TSC), HOST_ADJUST + val);
+	GUEST_ASSERT_EQ(rounded_rdmsr(MSR_IA32_TSC_ADJUST), val);
+
+	/*
+	 * Guest: writes to MSR_IA32_TSC affect both MSRs, so the host-side
+	 * offset is now visible in MSR_IA32_TSC_ADJUST.
+	 */
+	GUEST_SYNC(5);
+	val = 4ull * GUEST_STEP;
+	wrmsr(MSR_IA32_TSC, val);
+	GUEST_ASSERT_EQ(rounded_rdmsr(MSR_IA32_TSC), val);
+	GUEST_ASSERT_EQ(rounded_rdmsr(MSR_IA32_TSC_ADJUST), val - HOST_ADJUST);
+
+	GUEST_DONE();
+}
+
+static void run_vcpu(struct kvm_vm *vm, uint32_t vcpuid, int stage)
+{
+	struct ucall uc;
+
+	vcpu_args_set(vm, vcpuid, 1, vcpuid);
+
+	vcpu_ioctl(vm, vcpuid, KVM_RUN, NULL);
+
+	switch (get_ucall(vm, vcpuid, &uc)) {
+	case UCALL_SYNC:
+		TEST_ASSERT(!strcmp((const char *)uc.args[0], "hello") &&
+                            uc.args[1] == stage + 1, "Stage %d: Unexpected register values vmexit, got %lx",
+                            stage + 1, (ulong)uc.args[1]);
+		return;
+	case UCALL_DONE:
+		return;
+	case UCALL_ABORT:
+		TEST_ASSERT(false, "%s at %s:%ld\n" \
+			    "\tvalues: %#lx, %#lx", (const char *)uc.args[0],
+			    __FILE__, uc.args[1], uc.args[2], uc.args[3]);
+	default:
+		TEST_ASSERT(false, "Unexpected exit: %s",
+			    exit_reason_str(vcpu_state(vm, vcpuid)->exit_reason));
+	}
+}
+
+int main(void)
+{
+	struct kvm_vm *vm;
+	uint64_t val;
+
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+
+	val = 0;
+	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), val);
+	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC_ADJUST), val);
+
+	/* Guest: writes to MSR_IA32_TSC affect both MSRs.  */
+	run_vcpu(vm, VCPU_ID, 1);
+	val = 1ull * GUEST_STEP;
+	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), val);
+	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC_ADJUST), val);
+
+	/* Guest: writes to MSR_IA32_TSC_ADJUST affect both MSRs.  */
+	run_vcpu(vm, VCPU_ID, 2);
+	val = 2ull * GUEST_STEP;
+	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), val);
+	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC_ADJUST), val);
+
+	/*
+	 * Host: writes to MSR_IA32_TSC set the host-side offset
+	 * and therefore do not change MSR_IA32_TSC_ADJUST.
+	 */
+	vcpu_set_msr(vm, 0, MSR_IA32_TSC, HOST_ADJUST + val);
+	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), HOST_ADJUST + val);
+	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC_ADJUST), val);
+	run_vcpu(vm, VCPU_ID, 3);
+
+	/* Host: writes to MSR_IA32_TSC_ADJUST do not modify the TSC.  */
+	vcpu_set_msr(vm, 0, MSR_IA32_TSC_ADJUST, UNITY * 123456);
+	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), HOST_ADJUST + val);
+	ASSERT_EQ(vcpu_get_msr(vm, 0, MSR_IA32_TSC_ADJUST), UNITY * 123456);
+
+	/* Restore previous value.  */
+	vcpu_set_msr(vm, 0, MSR_IA32_TSC_ADJUST, val);
+	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), HOST_ADJUST + val);
+	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC_ADJUST), val);
+
+	/*
+	 * Guest: writes to MSR_IA32_TSC_ADJUST do not destroy the
+	 * host-side offset and affect both MSRs.
+	 */
+	run_vcpu(vm, VCPU_ID, 4);
+	val = 3ull * GUEST_STEP;
+	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), HOST_ADJUST + val);
+	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC_ADJUST), val);
+
+	/*
+	 * Guest: writes to MSR_IA32_TSC affect both MSRs, so the host-side
+	 * offset is now visible in MSR_IA32_TSC_ADJUST.
+	 */
+	run_vcpu(vm, VCPU_ID, 5);
+	val = 4ull * GUEST_STEP;
+	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), val);
+	ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC_ADJUST), val - HOST_ADJUST);
+
+	kvm_vm_free(vm);
+
+	return 0;
+}
-- 
2.26.2

