Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2CB21C5CE8
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 18:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgEEQFR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 12:05:17 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45486 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727857AbgEEQFQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 12:05:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588694716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=1P0XjrMx5eDbaL/X8oZDAXirrwhtoaVOjEod/dPnNfY=;
        b=CI+NFQ2l/zJKVkd2DsiX7u1UFdSmuCdGfqtmXS2nIAukGz5Tnk/vPMIa1DK+5XI1IIlJs7
        V7tLWc8eCyKu3ExSODPGdFPdLI46tWrQe8zC0DlqY4WtezIPrCuTPJ22AuSesyW6DIm0Vt
        y4zukZCtrdvKzg3HqJZrta7RbqjQqyg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-XAMvVEqzMvK6tBHc4aA89w-1; Tue, 05 May 2020 12:05:14 -0400
X-MC-Unique: XAMvVEqzMvK6tBHc4aA89w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C39780183C
        for <kvm@vger.kernel.org>; Tue,  5 May 2020 16:05:13 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4581662482;
        Tue,  5 May 2020 16:05:13 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Cathy Avery <cavery@redhat.com>
Subject: [PATCH kvm-unit-tests] KVM: VMX: add test for NMI delivery during HLT
Date:   Tue,  5 May 2020 12:05:12 -0400
Message-Id: <20200505160512.22845-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Cathy Avery <cavery@redhat.com>

Signed-off-by: Cathy Avery <cavery@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/vmx_tests.c | 120 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 120 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 0909adb..aa94a34 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -1803,6 +1803,124 @@ static int interrupt_exit_handler(union exit_reason exit_reason)
 	return VMX_TEST_VMEXIT;
 }
 
+
+static volatile int nmi_fired;
+
+#define NMI_DELAY 100000000ULL
+
+static void nmi_isr(isr_regs_t *regs)
+{
+	nmi_fired = true;
+}
+
+static int nmi_hlt_init(struct vmcs *vmcs)
+{
+	msr_bmp_init();
+	handle_irq(NMI_VECTOR, nmi_isr);
+	vmcs_write(PIN_CONTROLS,
+		   vmcs_read(PIN_CONTROLS) & ~PIN_NMI);
+	vmcs_write(PIN_CONTROLS,
+		   vmcs_read(PIN_CONTROLS) & ~PIN_VIRT_NMI);
+	return VMX_TEST_START;
+}
+
+static void nmi_message_thread(void *data)
+{
+    while (vmx_get_test_stage() != 1)
+        pause();
+
+    delay(NMI_DELAY);
+    apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, id_map[0]);
+
+    while (vmx_get_test_stage() != 2)
+        pause();
+
+    delay(NMI_DELAY);
+    apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, id_map[0]);
+}
+
+static void nmi_hlt_main(void)
+{
+    long long start;
+
+    if (cpu_count() < 2) {
+        report_skip(__func__);
+        vmx_set_test_stage(-1);
+        return;
+    }
+
+    vmx_set_test_stage(0);
+    on_cpu_async(1, nmi_message_thread, NULL);
+    start = rdtsc();
+    vmx_set_test_stage(1);
+    asm volatile ("hlt");
+    report((rdtsc() - start > NMI_DELAY) && nmi_fired,
+            "direct NMI + hlt");
+    if (!nmi_fired)
+        vmx_set_test_stage(-1);
+    nmi_fired = false;
+
+    vmcall();
+
+    start = rdtsc();
+    vmx_set_test_stage(2);
+    asm volatile ("hlt");
+    report((rdtsc() - start > NMI_DELAY) && !nmi_fired,
+            "intercepted NMI + hlt");
+    if (nmi_fired) {
+        report(!nmi_fired, "intercepted NMI was dispatched");
+        vmx_set_test_stage(-1);
+        return;
+    }
+    vmx_set_test_stage(3);
+}
+
+static int nmi_hlt_exit_handler(union exit_reason exit_reason)
+{
+    u64 guest_rip = vmcs_read(GUEST_RIP);
+    u32 insn_len = vmcs_read(EXI_INST_LEN);
+
+    switch (vmx_get_test_stage()) {
+    case 1:
+        if (exit_reason.basic != VMX_VMCALL) {
+            report(false, "VMEXIT not due to vmcall. Exit reason 0x%x",
+                   exit_reason.full);
+            print_vmexit_info(exit_reason);
+            return VMX_TEST_VMEXIT;
+        }
+
+        vmcs_write(PIN_CONTROLS,
+               vmcs_read(PIN_CONTROLS) | PIN_NMI);
+        vmcs_write(PIN_CONTROLS,
+               vmcs_read(PIN_CONTROLS) | PIN_VIRT_NMI);
+        vmcs_write(GUEST_RIP, guest_rip + insn_len);
+        break;
+
+    case 2:
+        if (exit_reason.basic != VMX_EXC_NMI) {
+            report(false, "VMEXIT not due to NMI intercept. Exit reason 0x%x",
+                   exit_reason.full);
+            print_vmexit_info(exit_reason);
+            return VMX_TEST_VMEXIT;
+        }
+        report(true, "NMI intercept while running guest");
+        vmcs_write(GUEST_ACTV_STATE, ACTV_ACTIVE);
+        break;
+
+    case 3:
+        break;
+
+    default:
+        return VMX_TEST_VMEXIT;
+    }
+
+    if (vmx_get_test_stage() == 3)
+        return VMX_TEST_VMEXIT;
+
+    return VMX_TEST_RESUME;
+}
+
+
 static int dbgctls_init(struct vmcs *vmcs)
 {
 	u64 dr7 = 0x402;
@@ -9813,6 +9931,8 @@ struct vmx_test vmx_tests[] = {
 	{ "VPID", vpid_init, vpid_main, vpid_exit_handler, NULL, {0} },
 	{ "interrupt", interrupt_init, interrupt_main,
 		interrupt_exit_handler, NULL, {0} },
+	{ "nmi_hlt", nmi_hlt_init, nmi_hlt_main,
+		nmi_hlt_exit_handler, NULL, {0} },
 	{ "debug controls", dbgctls_init, dbgctls_main, dbgctls_exit_handler,
 		NULL, {0} },
 	{ "MSR switch", msr_switch_init, msr_switch_main,
-- 
2.18.2

