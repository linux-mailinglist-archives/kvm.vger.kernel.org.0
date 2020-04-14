Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E051A6FF0
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 02:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgDNAKc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 20:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727878AbgDNAKb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Apr 2020 20:10:31 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACE7C0A3BDC
        for <kvm@vger.kernel.org>; Mon, 13 Apr 2020 17:10:31 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id i128so1908086pfc.4
        for <kvm@vger.kernel.org>; Mon, 13 Apr 2020 17:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=YRE0bl+MbOZJemQI6/3rM1uBjjYWT+ZjbHxoUQ9wtoQ=;
        b=Dxqwa6hO3h2eMm0jA1G2oQJUpnCnCahrkI6Ohz7isGPExDLuwqXl4Qbt2nov2HzIio
         Pgh+u05iOAzol3TPtEsyKN59KeO6weSaIT0RQmiepTS79N6Qxp/CmXJU+1/mDxtQoMNZ
         8+hvBluchnkRkiBH3tdpoMrGHOg45+QInV2QXElQDLpiq860HePTu/kIihECKGpeNSLq
         PfWtAoavfZR4u9H5rRw3U7lVsPoKUHe83788sF8OfrwSJ2RkItNQgj5jOawBDk2j3WYN
         TNPzk59tEJ8QVY/MLePa/dheKw8Nd7vrBI1kLtrwcAymc8d7gGAppLjFbO/iEFLECcEq
         0gPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=YRE0bl+MbOZJemQI6/3rM1uBjjYWT+ZjbHxoUQ9wtoQ=;
        b=bldqcfAby/TwcFs+kldBc5mGYgg88Hxxbiu/AVoVG2/+kw1yKPp5tqdsj6ftac8+kx
         kFasignQUptzdhJYllbL7ulo2v9Wq1DIL4JtA6v/2UaGctR0kpBWbY3TsRtI2oxuWFVa
         wmt6B0QBXMn6PQJ62kT3QEzYy8iWe5DKgLZ1jPK9SXTMAoiZswtDeBdDezQZPHT8S+xr
         kr+UDHW/8uEqooBKU4PdoJSd2x9/q1o2uCFrppjn9+0ze45kM/btxlou3U6Ic0HE+bUk
         P3vriV5354yRxV89y74HYZKkDHopq513qa9kH48MgZhB8sWirCIO3SObGZ0dQT/vrCGq
         ZTOw==
X-Gm-Message-State: AGi0PubmSBUmN9wQ5FbAZg7nVwRy4nvOG6L0XheHLsMxgNKHNovn9rQO
        6M6Whp2wdg+Fl390u1GVrc5eLelq+jqi2VmXX6rWNIgNcuH38Qwqh6ocZmHQ2caicemd89gy7XE
        2Zi0rtyONTdJzE+aNDFAy6q/CkhLAFjpze2vvYcpomvg8gmRlapLKj8vTxtwR66w=
X-Google-Smtp-Source: APiQypIDqlhIhVNgUbLZcXUU/8Q+TWQqbZIrN4XOzNxTArCp/mwyWyTlRLEQ1TYSQ2+eeTztkiWuDxFDI/mHsQ==
X-Received: by 2002:a17:90a:46cf:: with SMTP id x15mr24370313pjg.77.1586823030511;
 Mon, 13 Apr 2020 17:10:30 -0700 (PDT)
Date:   Mon, 13 Apr 2020 17:10:25 -0700
Message-Id: <20200414001026.50051-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.0.110.g2183baf09c-goog
Subject: [kvm-unit-tests PATCH 1/2] x86: nVMX: Add some corner-case
 VMX-preemption timer tests
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Verify that both injected events and debug traps that result from
pending debug exceptions take precedence over a "VMX-preemption timer
expired" VM-exit resulting from a zero-valued VMX-preemption timer.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 x86/vmx_tests.c | 120 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 120 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 1f97fe3..fccb27f 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -8319,6 +8319,125 @@ static void vmx_store_tsc_test(void)
 	       msr_entry.value, low, high);
 }
 
+static void vmx_preemption_timer_zero_test_db_handler(struct ex_regs *regs)
+{
+}
+
+static void vmx_preemption_timer_zero_test_guest(void)
+{
+	while (vmx_get_test_stage() < 3)
+		vmcall();
+}
+
+static void vmx_preemption_timer_zero_activate_preemption_timer(void)
+{
+	vmcs_set_bits(PIN_CONTROLS, PIN_PREEMPT);
+	vmcs_write(PREEMPT_TIMER_VALUE, 0);
+}
+
+static void vmx_preemption_timer_zero_advance_past_vmcall(void)
+{
+	vmcs_clear_bits(PIN_CONTROLS, PIN_PREEMPT);
+	enter_guest();
+	skip_exit_vmcall();
+}
+
+static void vmx_preemption_timer_zero_inject_db(bool intercept_db)
+{
+	vmx_preemption_timer_zero_activate_preemption_timer();
+	vmcs_write(ENT_INTR_INFO, INTR_INFO_VALID_MASK |
+		   INTR_TYPE_HARD_EXCEPTION | DB_VECTOR);
+	vmcs_write(EXC_BITMAP, intercept_db ? 1 << DB_VECTOR : 0);
+	enter_guest();
+}
+
+static void vmx_preemption_timer_zero_set_pending_dbg(u32 exception_bitmap)
+{
+	vmx_preemption_timer_zero_activate_preemption_timer();
+	vmcs_write(GUEST_PENDING_DEBUG, BIT(12) | DR_TRAP1);
+	vmcs_write(EXC_BITMAP, exception_bitmap);
+	enter_guest();
+}
+
+static void vmx_preemption_timer_zero_expect_preempt_at_rip(u64 expected_rip)
+{
+	u32 reason = (u32)vmcs_read(EXI_REASON);
+	u64 guest_rip = vmcs_read(GUEST_RIP);
+
+	report(reason == VMX_PREEMPT && guest_rip == expected_rip,
+	       "Exit reason is 0x%x (expected 0x%x) and guest RIP is %lx (0x%lx expected).",
+	       reason, VMX_PREEMPT, guest_rip, expected_rip);
+}
+
+/*
+ * This test ensures that when the VMX preemption timer is zero at
+ * VM-entry, a VM-exit occurs after any event injection and after any
+ * pending debug exceptions are raised, but before execution of any
+ * guest instructions.
+ */
+static void vmx_preemption_timer_zero_test(void)
+{
+	u64 db_fault_address = (u64)get_idt_addr(&boot_idt[DB_VECTOR]);
+	handler old_db;
+	u32 reason;
+
+	if (!(ctrl_pin_rev.clr & PIN_PREEMPT)) {
+		report_skip("'Activate VMX-preemption timer' not supported");
+		return;
+	}
+
+	/*
+	 * Install a custom #DB handler that doesn't abort.
+	 */
+	old_db = handle_exception(DB_VECTOR,
+				  vmx_preemption_timer_zero_test_db_handler);
+
+	test_set_guest(vmx_preemption_timer_zero_test_guest);
+
+	/*
+	 * VMX-preemption timer should fire after event injection.
+	 */
+	vmx_set_test_stage(0);
+	vmx_preemption_timer_zero_inject_db(0);
+	vmx_preemption_timer_zero_expect_preempt_at_rip(db_fault_address);
+	vmx_preemption_timer_zero_advance_past_vmcall();
+
+	/*
+	 * VMX-preemption timer should fire after event injection.
+	 * Exception bitmap is irrelevant, since you can't intercept
+	 * an event that you injected.
+	 */
+	vmx_set_test_stage(1);
+	vmx_preemption_timer_zero_inject_db(1 << DB_VECTOR);
+	vmx_preemption_timer_zero_expect_preempt_at_rip(db_fault_address);
+	vmx_preemption_timer_zero_advance_past_vmcall();
+
+	/*
+	 * VMX-preemption timer should fire after pending debug exceptions
+	 * have delivered a #DB trap.
+	 */
+	vmx_set_test_stage(2);
+	vmx_preemption_timer_zero_set_pending_dbg(0);
+	vmx_preemption_timer_zero_expect_preempt_at_rip(db_fault_address);
+	vmx_preemption_timer_zero_advance_past_vmcall();
+
+	/*
+	 * VMX-preemption timer would fire after pending debug exceptions
+	 * have delivered a #DB trap, but in this case, the #DB trap is
+	 * intercepted.
+	 */
+	vmx_set_test_stage(3);
+	vmx_preemption_timer_zero_set_pending_dbg(1 << DB_VECTOR);
+	reason = (u32)vmcs_read(EXI_REASON);
+	report(reason == VMX_EXC_NMI, "Exit reason is 0x%x (expected 0x%x)",
+	       reason, VMX_EXC_NMI);
+
+	vmcs_clear_bits(PIN_CONTROLS, PIN_PREEMPT);
+	enter_guest();
+
+	handle_exception(DB_VECTOR, old_db);
+}
+
 static void vmx_db_test_guest(void)
 {
 	/*
@@ -9623,6 +9742,7 @@ struct vmx_test vmx_tests[] = {
 	TEST(vmx_pending_event_test),
 	TEST(vmx_pending_event_hlt_test),
 	TEST(vmx_store_tsc_test),
+	TEST(vmx_preemption_timer_zero_test),
 	/* EPT access tests. */
 	TEST(ept_access_test_not_present),
 	TEST(ept_access_test_read_only),
-- 
2.26.0.110.g2183baf09c-goog

