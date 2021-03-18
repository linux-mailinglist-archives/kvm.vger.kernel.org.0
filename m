Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5334340767
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 15:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhCROJ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 10:09:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24039 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229508AbhCROJ5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 10:09:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616076596;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pY0xcNeTrDs8NsXlybCgwemqXFaEX7fNOmfqBZpc+lc=;
        b=hRDuUS88QcXr7Dv2WaR5cm37u5CD4cifDYXN17GLN+Nqzc7MKyKLrNoCIDj+mETCo2aar8
        KLmhLVXRgnKzot/YvcjK5pLZJ6cWr6ha28c1VuOLo/8v9wD5P0dW35R4gBOvlrVYMi8+Gc
        YSMq7psU9z0R5FMU1hnrK7gExklMY1w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-4dM5sSTyO4yLdcH1HsjFvQ-1; Thu, 18 Mar 2021 10:09:55 -0400
X-MC-Unique: 4dM5sSTyO4yLdcH1HsjFvQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28B9687A840;
        Thu, 18 Mar 2021 14:09:53 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E45A2C01F;
        Thu, 18 Mar 2021 14:09:50 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v2 6/4] selftests: kvm: Add basic Hyper-V clocksources tests
Date:   Thu, 18 Mar 2021 15:09:49 +0100
Message-Id: <20210318140949.1065740-1-vkuznets@redhat.com>
In-Reply-To: <20210316143736.964151-1-vkuznets@redhat.com>
References: <20210316143736.964151-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a new selftest for Hyper-V clocksources (MSR-based reference TSC
and TSC page). As a starting point, test the following:
1) Reference TSC is 1Ghz clock.
2) Reference TSC and TSC page give the same reading.
3) TSC page gets updated upon KVM_SET_CLOCK call.
4) TSC page does not get updated when guest opted for reenlightenment.
5) Disabled TSC page doesn't get updated.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/hyperv_clock.c       | 233 ++++++++++++++++++
 3 files changed, 235 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/hyperv_clock.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 32b87cc77c8e..22be05c55f13 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -9,6 +9,7 @@
 /x86_64/evmcs_test
 /x86_64/get_cpuid_test
 /x86_64/kvm_pv_test
+/x86_64/hyperv_clock
 /x86_64/hyperv_cpuid
 /x86_64/mmio_warning_test
 /x86_64/platform_info_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index a6d61f451f88..c3672e9087d3 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -41,6 +41,7 @@ LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_ha
 TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
 TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
 TEST_GEN_PROGS_x86_64 += x86_64/get_cpuid_test
+TEST_GEN_PROGS_x86_64 += x86_64/hyperv_clock
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
 TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
 TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
new file mode 100644
index 000000000000..39d6491d8458
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
@@ -0,0 +1,233 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2021, Red Hat, Inc.
+ *
+ * Tests for Hyper-V clocksources
+ */
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+struct ms_hyperv_tsc_page {
+	volatile u32 tsc_sequence;
+	u32 reserved1;
+	volatile u64 tsc_scale;
+	volatile s64 tsc_offset;
+} __packed;
+
+#define HV_X64_MSR_GUEST_OS_ID			0x40000000
+#define HV_X64_MSR_TIME_REF_COUNT		0x40000020
+#define HV_X64_MSR_REFERENCE_TSC		0x40000021
+#define HV_X64_MSR_TSC_FREQUENCY		0x40000022
+#define HV_X64_MSR_REENLIGHTENMENT_CONTROL	0x40000106
+#define HV_X64_MSR_TSC_EMULATION_CONTROL	0x40000107
+
+/* Simplified mul_u64_u64_shr() */
+static inline u64 mul_u64_u64_shr64(u64 a, u64 b)
+{
+	union {
+		u64 ll;
+		struct {
+			u32 low, high;
+		} l;
+	} rm, rn, rh, a0, b0;
+	u64 c;
+
+	a0.ll = a;
+	b0.ll = b;
+
+	rm.ll = (u64)a0.l.low * b0.l.high;
+	rn.ll = (u64)a0.l.high * b0.l.low;
+	rh.ll = (u64)a0.l.high * b0.l.high;
+
+	rh.l.low = c = rm.l.high + rn.l.high + rh.l.low;
+	rh.l.high = (c >> 32) + rh.l.high;
+
+	return rh.ll;
+}
+
+static inline void nop_loop(void)
+{
+	int i;
+
+	for (i = 0; i < 1000000; i++)
+		asm volatile("nop");
+}
+
+static inline void check_tsc_msr_rdtsc(void)
+{
+	u64 tsc_freq, r1, r2, t1, t2;
+	s64 delta_ns;
+
+	tsc_freq = rdmsr(HV_X64_MSR_TSC_FREQUENCY);
+	GUEST_ASSERT(tsc_freq > 0);
+
+	/* First, check MSR-based clocksource */
+	r1 = rdtsc();
+	t1 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
+	nop_loop();
+	r2 = rdtsc();
+	t2 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
+
+	GUEST_ASSERT(t2 > t1);
+
+	/* HV_X64_MSR_TIME_REF_COUNT is in 100ns */
+	delta_ns = ((t2 - t1) * 100) - ((r2 - r1) * 1000000000 / tsc_freq);
+	if (delta_ns < 0)
+		delta_ns = -delta_ns;
+
+	/* 1% tolerance */
+	GUEST_ASSERT(delta_ns * 100 < (t2 - t1) * 100);
+}
+
+static inline void check_tsc_msr_tsc_page(struct ms_hyperv_tsc_page *tsc_page)
+{
+	u64 r1, r2, t1, t2;
+	s64 delta_ns;
+
+	/* Compare TSC page clocksource with HV_X64_MSR_TIME_REF_COUNT */
+	t1 = mul_u64_u64_shr64(rdtsc(), tsc_page->tsc_scale) + tsc_page->tsc_offset;
+	r1 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
+	nop_loop();
+	t2 = mul_u64_u64_shr64(rdtsc(), tsc_page->tsc_scale) + tsc_page->tsc_offset;
+	r2 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
+
+	delta_ns = ((r2 - r1) - (t2 - t1)) * 100;
+	if (delta_ns < 0)
+		delta_ns = -delta_ns;
+
+	/* 1% tolerance */
+	GUEST_ASSERT(delta_ns * 100 < (t2 - t1) * 100);
+}
+
+static void guest_main(struct ms_hyperv_tsc_page *tsc_page, vm_paddr_t tsc_page_gpa)
+{
+	u64 tsc_scale, tsc_offset;
+
+	/* Set Guest OS id to enable Hyper-V emulation */
+	GUEST_SYNC(1);
+	wrmsr(HV_X64_MSR_GUEST_OS_ID, (u64)0x8100 << 48);
+	GUEST_SYNC(2);
+
+	check_tsc_msr_rdtsc();
+
+	GUEST_SYNC(3);
+
+	/* Set up TSC page is disabled state, check that it's clean */
+	wrmsr(HV_X64_MSR_REFERENCE_TSC, tsc_page_gpa);
+	GUEST_ASSERT(tsc_page->tsc_sequence == 0);
+	GUEST_ASSERT(tsc_page->tsc_scale == 0);
+	GUEST_ASSERT(tsc_page->tsc_offset == 0);
+
+	GUEST_SYNC(4);
+
+	/* Set up TSC page is enabled state */
+	wrmsr(HV_X64_MSR_REFERENCE_TSC, tsc_page_gpa | 0x1);
+	GUEST_ASSERT(tsc_page->tsc_sequence != 0);
+
+	GUEST_SYNC(5);
+
+	check_tsc_msr_tsc_page(tsc_page);
+
+	GUEST_SYNC(6);
+
+	tsc_offset = tsc_page->tsc_offset;
+	/* Call KVM_SET_CLOCK from userspace, check that TSC page was updated */
+	GUEST_SYNC(7);
+	GUEST_ASSERT(tsc_page->tsc_offset != tsc_offset);
+
+	nop_loop();
+
+	/*
+	 * Enable Re-enlightenment and check that TSC page stays constant across
+	 * KVM_SET_CLOCK.
+	 */
+	wrmsr(HV_X64_MSR_REENLIGHTENMENT_CONTROL, 0x1 << 16 | 0xff);
+	wrmsr(HV_X64_MSR_TSC_EMULATION_CONTROL, 0x1);
+	tsc_offset = tsc_page->tsc_offset;
+	tsc_scale = tsc_page->tsc_scale;
+	GUEST_SYNC(8);
+	GUEST_ASSERT(tsc_page->tsc_offset == tsc_offset);
+	GUEST_ASSERT(tsc_page->tsc_scale == tsc_scale);
+
+	GUEST_SYNC(9);
+
+	check_tsc_msr_tsc_page(tsc_page);
+
+	/*
+	 * Disable re-enlightenment and TSC page, check that KVM doesn't update
+	 * it anymore.
+	 */
+	wrmsr(HV_X64_MSR_REENLIGHTENMENT_CONTROL, 0);
+	wrmsr(HV_X64_MSR_TSC_EMULATION_CONTROL, 0);
+	wrmsr(HV_X64_MSR_REFERENCE_TSC, 0);
+	memset(tsc_page, 0, sizeof(*tsc_page));
+
+	GUEST_SYNC(10);
+	GUEST_ASSERT(tsc_page->tsc_sequence == 0);
+	GUEST_ASSERT(tsc_page->tsc_offset == 0);
+	GUEST_ASSERT(tsc_page->tsc_scale == 0);
+
+	GUEST_DONE();
+}
+
+#define VCPU_ID 0
+
+int main(void)
+{
+	struct kvm_vm *vm;
+	struct kvm_run *run;
+	struct ucall uc;
+	vm_vaddr_t tsc_page_gva;
+	int stage;
+
+	vm = vm_create_default(VCPU_ID, 0, guest_main);
+	run = vcpu_state(vm, VCPU_ID);
+
+	vcpu_set_hv_cpuid(vm, VCPU_ID);
+
+	tsc_page_gva = vm_vaddr_alloc(vm, getpagesize(), 0x10000, 0, 0);
+	memset(addr_gpa2hva(vm, tsc_page_gva), 0x0, getpagesize());
+	TEST_ASSERT((addr_gva2gpa(vm, tsc_page_gva) & (getpagesize() - 1)) == 0,
+		"TSC page has to be page aligned\n");
+	vcpu_args_set(vm, VCPU_ID, 2, tsc_page_gva, addr_gva2gpa(vm, tsc_page_gva));
+
+	for (stage = 1;; stage++) {
+		_vcpu_run(vm, VCPU_ID);
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+			    "Stage %d: unexpected exit reason: %u (%s),\n",
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
+			/* Keep in sync with guest_main() */
+			TEST_ASSERT(stage == 11, "Testing ended prematurely, stage %d\n",
+				    stage);
+			goto out;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+
+		TEST_ASSERT(!strcmp((const char *)uc.args[0], "hello") &&
+			    uc.args[1] == stage,
+			    "Stage %d: Unexpected register values vmexit, got %lx",
+			    stage, (ulong)uc.args[1]);
+
+		/* Reset kvmclock triggering TSC page update */
+		if (stage == 7 || stage == 8 || stage == 10) {
+			struct kvm_clock_data clock = {0};
+
+			vm_ioctl(vm, KVM_SET_CLOCK, &clock);
+		}
+	}
+
+out:
+	kvm_vm_free(vm);
+}
-- 
2.30.2

