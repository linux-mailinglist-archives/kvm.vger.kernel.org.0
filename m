Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68AD1CB912
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 22:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgEHUjn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 16:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726883AbgEHUjm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 May 2020 16:39:42 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8477EC061A0C
        for <kvm@vger.kernel.org>; Fri,  8 May 2020 13:39:42 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id n22so3294541qtp.15
        for <kvm@vger.kernel.org>; Fri, 08 May 2020 13:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=VL335T+eqD2/ZBcv6CJbEsGdKB/CUVQDdXI0UV5ucn0=;
        b=aRYoiHzxy6SVHTf7dDLxOnfbIxX8CO74SxEIwvJ6BY9+nTaQlpEWRGz/yfIL4xRnbT
         87CD82MCbLu5MgtNhv1PLFFyyvax94xb6HNuWwWBa0J/dQkth5BrYgENlLmoVQ+UI3Uk
         QqMhlVxF8Fgy3LH1zYls+t5VzFD2faKLBjqwyw6KmRWWJqQB4CBs80XZjc8cPvPzeyj1
         TpRhbDGZbN3Gz53Ltk3aG7gSzkEuXs4QGkZFP8GzYBb7NkOqBYDqu4jrWrj2iTVvXdaI
         LQBP+NBEtysKiKBSgOkmnGwVi9SvRYo63D63Okg8fRD1X3IkSSuoRLCh7g48Bem7ozXy
         XH4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=VL335T+eqD2/ZBcv6CJbEsGdKB/CUVQDdXI0UV5ucn0=;
        b=p69rK7fO94EqRYE1PcH9W9qNBHA4bctt8ANM34l/1kMWTVvQ0+/jeOX4xNY2ZdR5tN
         CxlZmNmhvmeBLH10e016C46hXUUUYfow0i+ElT46H5dQ6kCg3cGUuFeoz5NQj35dI4ME
         GF67u66uuvjwEO0UerxukefhxQUycAW3giPy3AUrNBXHIR9NryQ92wYiuceDQNIFpad3
         7laf6zK+jjQYo39u85L6DZIIV3/ocUdeiQAZuIa1HEZtkk8IuTv2EsW8lellGArZhoMB
         gCD2MFfGB6xhQBuXOZ8T8oST6Rs8o5OGfKMWC6g4gd56CnebNUj3lBkeOhOonyP/Ab4o
         3lZQ==
X-Gm-Message-State: AGi0PuZmWdb0mY3aWBlPqfQE5ztBKgFD9p+6alJBMGb7cP1WQPhNYyTX
        CWfffpH4lMmiqsNfmUYVoLvM6vHs09ruL2tDh1Lb3Ds+Bs33KRPEXmzSkLQ7wR1dvwEiKqE4eT0
        YJW7i/5r4zIdG7p/ZJNnGyvGnHSJoK2bilD+CV8G7JW0JLxAT76Pu5raveklOzuI=
X-Google-Smtp-Source: APiQypJQ4vTDQ09rua+3iAAyxw11ZthdaLMY8rdnELWJS6FXrGVYbS2Dwx0z5W1PuCQVo7M18ulRDxcAXnZVXA==
X-Received: by 2002:a05:6214:8e9:: with SMTP id dr9mr4758232qvb.84.1588970381555;
 Fri, 08 May 2020 13:39:41 -0700 (PDT)
Date:   Fri,  8 May 2020 13:39:38 -0700
Message-Id: <20200508203938.88508-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.645.ge9eca65c58-goog
Subject: [kvm-unit-tests PATCH] x86: VMX: Add a VMX-preemption timer
 expiration test
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the VMX-preemption timer is activated, code executing in VMX
non-root operation should never be able to record a TSC value beyond
the deadline imposed by adding the scaled VMX-preemption timer value
to the first TSC value observed by the guest after VM-entry.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 lib/x86/processor.h | 23 +++++++++++++
 x86/vmx.h           | 21 ++++++++++++
 x86/vmx_tests.c     | 81 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 125 insertions(+)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 804673b..cf3acf6 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -479,6 +479,29 @@ static inline unsigned long long rdtsc(void)
 	return r;
 }
 
+/*
+ * Per the advice in the SDM, volume 2, the sequence "mfence; lfence"
+ * executed immediately before rdtsc ensures that rdtsc will be
+ * executed only after all previous instructions have executed and all
+ * previous loads and stores are globally visible. In addition, the
+ * lfence immediately after rdtsc ensures that rdtsc will be executed
+ * prior to the execution of any subsequent instruction.
+ */
+static inline unsigned long long fenced_rdtsc(void)
+{
+	unsigned long long tsc;
+
+#ifdef __x86_64__
+	unsigned int eax, edx;
+
+	asm volatile ("mfence; lfence; rdtsc; lfence" : "=a"(eax), "=d"(edx));
+	tsc = eax | ((unsigned long long)edx << 32);
+#else
+	asm volatile ("mfence; lfence; rdtsc; lfence" : "=A"(tsc));
+#endif
+	return tsc;
+}
+
 static inline unsigned long long rdtscp(u32 *aux)
 {
        long long r;
diff --git a/x86/vmx.h b/x86/vmx.h
index 08b354d..71fdaa0 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -118,6 +118,27 @@ union vmx_ctrl_msr {
 	};
 };
 
+union vmx_misc {
+	u64 val;
+	struct {
+		u32 pt_bit:5,
+		    stores_lma:1,
+		    act_hlt:1,
+		    act_shutdown:1,
+		    act_wfsipi:1,
+		    :5,
+		    vmx_pt:1,
+		    smm_smbase:1,
+		    cr3_targets:9,
+		    msr_list_size:3,
+		    smm_mon_ctl:1,
+		    vmwrite_any:1,
+		    inject_len0:1,
+		    :1;
+		u32 mseg_revision;
+	};
+};
+
 union vmx_ept_vpid {
 	u64 val;
 	struct {
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 0909adb..991c317 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -8555,6 +8555,86 @@ static void vmx_preemption_timer_tf_test(void)
 	handle_exception(DB_VECTOR, old_db);
 }
 
+#define VMX_PREEMPTION_TIMER_EXPIRY_CYCLES 1000000
+
+static u64 vmx_preemption_timer_expiry_start;
+static u64 vmx_preemption_timer_expiry_finish;
+
+static void vmx_preemption_timer_expiry_test_guest(void)
+{
+	vmcall();
+	vmx_preemption_timer_expiry_start = fenced_rdtsc();
+
+	while (vmx_get_test_stage() == 0)
+		vmx_preemption_timer_expiry_finish = fenced_rdtsc();
+}
+
+/*
+ * Test that the VMX-preemption timer is not excessively delayed.
+ *
+ * Per the SDM, volume 3, VM-entry starts the VMX-preemption timer
+ * with the unsigned value in the VMX-preemption timer-value field,
+ * and the VMX-preemption timer counts down by 1 every time bit X in
+ * the TSC changes due to a TSC increment (where X is
+ * IA32_VMX_MISC[4:0]). If the timer counts down to zero in any state
+ * other than the wait-for-SIPI state, the logical processor
+ * transitions to the C0 C-state and causes a VM-exit.
+ *
+ * The guest code above reads the starting TSC after VM-entry. At this
+ * point, the VMX-preemption timer has already been activated. Next,
+ * the guest code reads the current TSC in a loop, storing the value
+ * read to memory.
+ *
+ * If the RDTSC in the loop reads a value past the VMX-preemption
+ * timer deadline, then the VMX-preemption timer VM-exit must be
+ * delivered before the next instruction retires. Even if a higher
+ * priority SMI is delivered first, the VMX-preemption timer VM-exit
+ * must be delivered before the next instruction retires. Hence, a TSC
+ * value past the VMX-preemption timer deadline might be read, but it
+ * cannot be stored. If a TSC value past the deadline *is* stored,
+ * then the architectural specification has been violated.
+ */
+static void vmx_preemption_timer_expiry_test(void)
+{
+	u32 preemption_timer_value;
+	union vmx_misc misc;
+	u64 tsc_deadline;
+	u32 reason;
+
+	if (!(ctrl_pin_rev.clr & PIN_PREEMPT)) {
+		report_skip("'Activate VMX-preemption timer' not supported");
+		return;
+	}
+
+	test_set_guest(vmx_preemption_timer_expiry_test_guest);
+
+	enter_guest();
+	skip_exit_vmcall();
+
+	misc.val = rdmsr(MSR_IA32_VMX_MISC);
+	preemption_timer_value =
+		VMX_PREEMPTION_TIMER_EXPIRY_CYCLES >> misc.pt_bit;
+
+	vmcs_set_bits(PIN_CONTROLS, PIN_PREEMPT);
+	vmcs_write(PREEMPT_TIMER_VALUE, preemption_timer_value);
+	vmx_set_test_stage(0);
+
+	enter_guest();
+	reason = (u32)vmcs_read(EXI_REASON);
+	TEST_ASSERT(reason == VMX_PREEMPT);
+
+	vmcs_clear_bits(PIN_CONTROLS, PIN_PREEMPT);
+	vmx_set_test_stage(1);
+	enter_guest();
+
+	tsc_deadline = ((vmx_preemption_timer_expiry_start >> misc.pt_bit) <<
+			misc.pt_bit) + (preemption_timer_value << misc.pt_bit);
+
+	report(vmx_preemption_timer_expiry_finish < tsc_deadline,
+	       "Last stored guest TSC (%lu) < TSC deadline (%lu)",
+	       vmx_preemption_timer_expiry_finish, tsc_deadline);
+}
+
 static void vmx_db_test_guest(void)
 {
 	/*
@@ -9861,6 +9941,7 @@ struct vmx_test vmx_tests[] = {
 	TEST(vmx_store_tsc_test),
 	TEST(vmx_preemption_timer_zero_test),
 	TEST(vmx_preemption_timer_tf_test),
+	TEST(vmx_preemption_timer_expiry_test),
 	/* EPT access tests. */
 	TEST(ept_access_test_not_present),
 	TEST(ept_access_test_read_only),
-- 
2.26.2.526.g744177e7f7-goog

