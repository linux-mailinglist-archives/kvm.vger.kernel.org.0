Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC45EC471
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 15:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfKAOOU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 10:14:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58508 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbfKAOOT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 10:14:19 -0400
Received: from [91.217.168.176] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <cascardo@canonical.com>)
        id 1iQXgv-00060W-R9
        for kvm@vger.kernel.org; Fri, 01 Nov 2019 14:14:17 +0000
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] x86/tscdeadline_delay: test busy-wait loop in host
Date:   Fri,  1 Nov 2019 11:14:08 -0300
Message-Id: <20191101141408.17838-1-cascardo@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the tsc deadline is used, the host might use a busy wait loop, which
might sleep for up to the TSC offset/adjust, which is set when the guest
sets the TSC MSR.

Linux commit b606f189c7 ("KVM: LAPIC: cap __delay at lapic_timer_advance_ns")
fixes the issue and this test check for its regression.

On a kernel without that fix, the test fails with:
FAIL: delta: 4296500469

On a kernel with the fix, the max_delta is usually reported as very low
compared to that one:
max delta: 12423150

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 x86/Makefile.x86_64     |   1 +
 x86/tscdeadline_delay.c | 105 ++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg       |   4 ++
 3 files changed, 110 insertions(+)
 create mode 100644 x86/tscdeadline_delay.c

diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index 010102b600f9..ac0e4858a29c 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -17,6 +17,7 @@ tests += $(TEST_DIR)/syscall.flat
 tests += $(TEST_DIR)/svm.flat
 tests += $(TEST_DIR)/vmx.flat
 tests += $(TEST_DIR)/tscdeadline_latency.flat
+tests += $(TEST_DIR)/tscdeadline_delay.flat
 tests += $(TEST_DIR)/intel-iommu.flat
 tests += $(TEST_DIR)/vmware_backdoors.flat
 tests += $(TEST_DIR)/rdpru.flat
diff --git a/x86/tscdeadline_delay.c b/x86/tscdeadline_delay.c
new file mode 100644
index 000000000000..01498da2d0ce
--- /dev/null
+++ b/x86/tscdeadline_delay.c
@@ -0,0 +1,105 @@
+/* Test regression for bug fixed by linux commit b606f189c7 */
+
+#include "libcflat.h"
+#include "apic.h"
+#include "vm.h"
+#include "smp.h"
+#include "desc.h"
+#include "isr.h"
+#include "msr.h"
+
+static u64 expire;
+
+static void test_lapic_existence(void)
+{
+    u32 lvr;
+
+    lvr = apic_read(APIC_LVR);
+    printf("apic version: %x\n", lvr);
+    report("apic existence", (u16)lvr == 0x14);
+}
+
+#define TSC_DEADLINE_TIMER_VECTOR 0xef
+
+static u64 expire;
+static u64 delta;
+
+static void tsc_deadline_timer_isr(isr_regs_t *regs)
+{
+    apic_write(APIC_EOI, 0);
+}
+
+static void start_tsc_deadline_timer(void)
+{
+    u64 tsc;
+
+    handle_irq(TSC_DEADLINE_TIMER_VECTOR, tsc_deadline_timer_isr);
+    irq_enable();
+
+    wrmsr(MSR_IA32_TSC, delta + 1);
+    tsc = rdmsr(MSR_IA32_TSC);
+    expire = tsc + delta;
+    wrmsr(MSR_IA32_TSCDEADLINE, expire);
+    asm volatile ("nop");
+    wrmsr(MSR_IA32_TSC, 1);
+    asm volatile ("nop");
+}
+
+static int enable_tsc_deadline_timer(void)
+{
+    uint32_t lvtt;
+
+    if (cpuid(1).c & (1 << 24)) {
+        lvtt = APIC_LVT_TIMER_TSCDEADLINE | TSC_DEADLINE_TIMER_VECTOR;
+        apic_write(APIC_LVTT, lvtt);
+        start_tsc_deadline_timer();
+        return 1;
+    } else {
+        return 0;
+    }
+}
+
+static void test_tsc_deadline_timer(void)
+{
+    if (enable_tsc_deadline_timer()) {
+        printf("tsc deadline timer enabled\n");
+    } else {
+        printf("tsc deadline timer not detected, aborting\n");
+        abort();
+    }
+}
+
+int main(int argc, char **argv)
+{
+    u64 now;
+    u64 then;
+    u64 max_delta = 0;
+
+    setup_vm();
+    smp_init();
+
+    test_lapic_existence();
+
+    mask_pic_interrupts();
+
+    delta = 1UL << 32;
+
+    test_tsc_deadline_timer();
+    irq_enable();
+
+    now = rdtsc();
+    do {
+        then = now;
+        now = rdtsc();
+        if (now - then > (delta / 2)) {
+            report("delta: %lu\n", false, now - then);
+        }
+        if (now - then > max_delta) {
+            max_delta = now - then;
+        }
+    } while (now < expire + delta);
+
+    printf("max delta: %lu\n", max_delta);
+
+    return report_summary();
+}
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 5ecb9bba535b..b26202d32240 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -186,6 +186,10 @@ extra_params = -cpu kvm64,+rdtscp
 file = tsc_adjust.flat
 extra_params = -cpu host
 
+[tscdeadline_delay]
+file = tscdeadline_delay.flat
+extra_params = -cpu host,+tsc-deadline
+
 [xsave]
 file = xsave.flat
 arch = x86_64
-- 
2.20.1

