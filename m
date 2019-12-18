Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 509D0124F64
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 18:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbfLRRdK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 12:33:10 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37481 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbfLRRdK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 12:33:10 -0500
Received: by mail-wr1-f67.google.com with SMTP id w15so3209599wru.4
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2019 09:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5H1LnabRffeELO1OACrfjCbx1g2hP9mrXvmG6Zih1E8=;
        b=HWE0bK2g50SjgkayGbT22suu7Ebcza0C05oksNWz9YVd+PEhRn3Tjzz2o7wncEUq0n
         4QMOZ/aKZuFEg9XUVh+oEYAyMPg3KsY6L+0qSPHZ7T4K5z0ULoamF8s8V4aSa/yudMBY
         QUUDSxdW7P4IMXFBr10xKw1hcGw01lwtucaH38zOZ+Lt6XM9OyV1A2YpU9Ezln6G8Fgk
         Ijxw6zsB90Wu2mmgbc+sbY6iqDU8dOcEb8OICcTgnkewxF4EufKvPUb7RTe9DQT8cWsm
         dFw9HSPX1/p2mTIx6nCqratzjNxs+/HO9flb/Y9DUf7VmkSz2SNdBbYhcUJvOKRbNcFc
         je9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=5H1LnabRffeELO1OACrfjCbx1g2hP9mrXvmG6Zih1E8=;
        b=tlphhBfKXvbgVgXARjNl8+l9/JAWa2CHEdUPfsYu3ARJU/nVBdNcVRmRwFvX7r0dqH
         5K5POaiG8MlmMNJzXVGZ0vlh64XUSnc/4BpXW4mKhE+6/yYnRyyaIaHYVFvj36/ZTaY7
         Q/TcE5d4FoFs+Jj/i175t8wxYqzsXtTxUW8CVF5BCK0PItPqx2P8qJEUZ/712vMYDnSs
         org5vxVLG0HAMgHO3eP5ac87sUJmND/kt8zvKK6G02xKddbC6sEVcHQ48PkhA93XmM53
         o7IZLOWOgNQHK3xrAJSbQjd6jENwmolYkuS5eYjLLdTZpMmvznxfYX8IhrCjD91kNfID
         +GhQ==
X-Gm-Message-State: APjAAAXKO/7xRY1fQ7b7o6krvg9ND0grxM5tUcRClhSaVktTycsigTAH
        1ieKZHtMxk9s4hT3GdWXl2T/vxJr
X-Google-Smtp-Source: APXvYqxSrz78wE88ROaOoh8bNKTp7NJ5SyEMphWt3ZBo84VCD1H3ZM4XmjTbg9JhY4cwruC4qA/fSg==
X-Received: by 2002:adf:f78d:: with SMTP id q13mr4124961wrp.365.1576690386995;
        Wed, 18 Dec 2019 09:33:06 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id u22sm3411362wru.30.2019.12.18.09.33.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Dec 2019 09:33:06 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     cavery@redhat.com
Subject: [PATCH kvm-unit-tests 1/2] svm: introduce prepare_gif_clear callback
Date:   Wed, 18 Dec 2019 18:33:02 +0100
Message-Id: <1576690383-16170-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1576690383-16170-1-git-send-email-pbonzini@redhat.com>
References: <1576690383-16170-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Generalize the set_host_if flag that was added recently, by introducing
a new callback that is called with GIF=0 && IF=1.  This is useful to
inject events that will trigger right after VMRUN.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/svm.c | 124 ++++++++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 81 insertions(+), 43 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index 99b1d71..63fda65 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -192,6 +192,7 @@ struct test {
     const char *name;
     bool (*supported)(void);
     void (*prepare)(struct test *test);
+    void (*prepare_gif_clear)(struct test *test);
     void (*guest_func)(struct test *test);
     bool (*finished)(struct test *test);
     bool (*succeeded)(struct test *test);
@@ -266,31 +267,37 @@ static void test_run(struct test *test, struct vmcb *vmcb)
     vmcb->save.rsp = (ulong)(guest_stack + ARRAY_SIZE(guest_stack));
     regs.rdi = (ulong)test;
     do {
+        struct test *the_test = test;
+        u64 the_vmcb = vmcb_phys;
         tsc_start = rdtsc();
         asm volatile (
             "clgi;\n\t" // semi-colon needed for LLVM compatibility
-            "cmpb $0, set_host_if\n\t"
-            "jz 1f\n\t"
             "sti \n\t"
-            "1: \n\t"
+            "call *%c[PREPARE_GIF_CLEAR](%[test]) \n \t"
+            "mov %[vmcb_phys], %%rax \n\t"
             "vmload \n\t"
             "vmload %0\n\t"
             "mov regs+0x80, %%r15\n\t"  // rflags
-            "mov %%r15, 0x170(%0)\n\t"
+            "mov %%r15, 0x170(%%rax)\n\t"
             "mov regs, %%r15\n\t"       // rax
-            "mov %%r15, 0x1f8(%0)\n\t"
+            "mov %%r15, 0x1f8(%%rax)\n\t"
             LOAD_GPR_C
             "vmrun %0\n\t"
             SAVE_GPR_C
-            "mov 0x170(%0), %%r15\n\t"  // rflags
+            "mov 0x170(%%rax), %%r15\n\t"  // rflags
             "mov %%r15, regs+0x80\n\t"
-            "mov 0x1f8(%0), %%r15\n\t"  // rax
+            "mov 0x1f8(%%rax), %%r15\n\t"  // rax
             "mov %%r15, regs\n\t"
             "vmsave %0\n\t"
             "cli \n\t"
             "stgi"
-            : : "a"(vmcb_phys)
-            : "rbx", "rcx", "rdx", "rsi",
+            : // inputs clobbered by the guest:
+	      "+D" (the_test),            // first argument register
+	      "+b" (the_vmcb)             // callee save register!
+            : [test] "0" (the_test),
+	      [vmcb_phys] "1"(the_vmcb),
+	      [PREPARE_GIF_CLEAR] "i" (offsetof(struct test, prepare_gif_clear))
+            : "rax", "rcx", "rdx", "rsi",
               "r8", "r9", "r10", "r11" , "r12", "r13", "r14", "r15",
               "memory");
 	tsc_end = rdtsc();
@@ -316,6 +323,12 @@ static void default_prepare(struct test *test)
     vmcb_ident(test->vmcb);
 }
 
+static void default_prepare_gif_clear(struct test *test)
+{
+    if (!set_host_if)
+        asm("cli");
+}
+
 static bool default_finished(struct test *test)
 {
     return true; /* one vmexit */
@@ -1486,58 +1499,83 @@ static bool pending_event_check_vmask(struct test *test)
 }
 
 static struct test tests[] = {
-    { "null", default_supported, default_prepare, null_test,
+    { "null", default_supported, default_prepare,
+      default_prepare_gif_clear, null_test,
       default_finished, null_check },
-    { "vmrun", default_supported, default_prepare, test_vmrun,
+    { "vmrun", default_supported, default_prepare,
+      default_prepare_gif_clear, test_vmrun,
        default_finished, check_vmrun },
-    { "ioio", default_supported, prepare_ioio, test_ioio,
+    { "ioio", default_supported, prepare_ioio,
+       default_prepare_gif_clear, test_ioio,
        ioio_finished, check_ioio },
     { "vmrun intercept check", default_supported, prepare_no_vmrun_int,
-      null_test, default_finished, check_no_vmrun_int },
-    { "cr3 read intercept", default_supported, prepare_cr3_intercept,
+      default_prepare_gif_clear, null_test, default_finished,
+      check_no_vmrun_int },
+    { "cr3 read intercept", default_supported,
+      prepare_cr3_intercept, default_prepare_gif_clear,
       test_cr3_intercept, default_finished, check_cr3_intercept },
     { "cr3 read nointercept", default_supported, default_prepare,
-      test_cr3_intercept, default_finished, check_cr3_nointercept },
+      default_prepare_gif_clear, test_cr3_intercept, default_finished,
+      check_cr3_nointercept },
     { "cr3 read intercept emulate", smp_supported,
-      prepare_cr3_intercept_bypass, test_cr3_intercept_bypass,
-      default_finished, check_cr3_intercept },
+      prepare_cr3_intercept_bypass, default_prepare_gif_clear,
+      test_cr3_intercept_bypass, default_finished, check_cr3_intercept },
     { "dr intercept check", default_supported, prepare_dr_intercept,
-      test_dr_intercept, dr_intercept_finished, check_dr_intercept },
-    { "next_rip", next_rip_supported, prepare_next_rip, test_next_rip,
+      default_prepare_gif_clear, test_dr_intercept, dr_intercept_finished,
+      check_dr_intercept },
+    { "next_rip", next_rip_supported, prepare_next_rip,
+      default_prepare_gif_clear, test_next_rip,
       default_finished, check_next_rip },
     { "msr intercept check", default_supported, prepare_msr_intercept,
-       test_msr_intercept, msr_intercept_finished, check_msr_intercept },
-    { "mode_switch", default_supported, prepare_mode_switch, test_mode_switch,
+      default_prepare_gif_clear, test_msr_intercept,
+      msr_intercept_finished, check_msr_intercept },
+    { "mode_switch", default_supported, prepare_mode_switch,
+      default_prepare_gif_clear, test_mode_switch,
        mode_switch_finished, check_mode_switch },
-    { "asid_zero", default_supported, prepare_asid_zero, test_asid_zero,
+    { "asid_zero", default_supported, prepare_asid_zero,
+      default_prepare_gif_clear, test_asid_zero,
        default_finished, check_asid_zero },
-    { "sel_cr0_bug", default_supported, sel_cr0_bug_prepare, sel_cr0_bug_test,
+    { "sel_cr0_bug", default_supported, sel_cr0_bug_prepare,
+      default_prepare_gif_clear, sel_cr0_bug_test,
        sel_cr0_bug_finished, sel_cr0_bug_check },
-    { "npt_nx", npt_supported, npt_nx_prepare, null_test,
-	    default_finished, npt_nx_check },
-    { "npt_us", npt_supported, npt_us_prepare, npt_us_test,
-	    default_finished, npt_us_check },
-    { "npt_rsvd", npt_supported, npt_rsvd_prepare, null_test,
-	    default_finished, npt_rsvd_check },
-    { "npt_rw", npt_supported, npt_rw_prepare, npt_rw_test,
-	    default_finished, npt_rw_check },
-    { "npt_rsvd_pfwalk", npt_supported, npt_rsvd_pfwalk_prepare, null_test,
-	    default_finished, npt_rsvd_pfwalk_check },
-    { "npt_rw_pfwalk", npt_supported, npt_rw_pfwalk_prepare, null_test,
-	    default_finished, npt_rw_pfwalk_check },
-    { "npt_l1mmio", npt_supported, npt_l1mmio_prepare, npt_l1mmio_test,
-	    default_finished, npt_l1mmio_check },
-    { "npt_rw_l1mmio", npt_supported, npt_rw_l1mmio_prepare, npt_rw_l1mmio_test,
-	    default_finished, npt_rw_l1mmio_check },
-    { "tsc_adjust", default_supported, tsc_adjust_prepare, tsc_adjust_test,
-       default_finished, tsc_adjust_check },
-    { "latency_run_exit", default_supported, latency_prepare, latency_test,
+    { "npt_nx", npt_supported, npt_nx_prepare,
+      default_prepare_gif_clear, null_test,
+      default_finished, npt_nx_check },
+    { "npt_us", npt_supported, npt_us_prepare,
+      default_prepare_gif_clear, npt_us_test,
+      default_finished, npt_us_check },
+    { "npt_rsvd", npt_supported, npt_rsvd_prepare,
+      default_prepare_gif_clear, null_test,
+      default_finished, npt_rsvd_check },
+    { "npt_rw", npt_supported, npt_rw_prepare,
+      default_prepare_gif_clear, npt_rw_test,
+      default_finished, npt_rw_check },
+    { "npt_rsvd_pfwalk", npt_supported, npt_rsvd_pfwalk_prepare,
+      default_prepare_gif_clear, null_test,
+      default_finished, npt_rsvd_pfwalk_check },
+    { "npt_rw_pfwalk", npt_supported, npt_rw_pfwalk_prepare,
+      default_prepare_gif_clear, null_test,
+      default_finished, npt_rw_pfwalk_check },
+    { "npt_l1mmio", npt_supported, npt_l1mmio_prepare,
+      default_prepare_gif_clear, npt_l1mmio_test,
+      default_finished, npt_l1mmio_check },
+    { "npt_rw_l1mmio", npt_supported, npt_rw_l1mmio_prepare,
+      default_prepare_gif_clear, npt_rw_l1mmio_test,
+      default_finished, npt_rw_l1mmio_check },
+    { "tsc_adjust", default_supported, tsc_adjust_prepare,
+      default_prepare_gif_clear, tsc_adjust_test,
+      default_finished, tsc_adjust_check },
+    { "latency_run_exit", default_supported, latency_prepare,
+      default_prepare_gif_clear, latency_test,
       latency_finished, latency_check },
-    { "latency_svm_insn", default_supported, lat_svm_insn_prepare, null_test,
+    { "latency_svm_insn", default_supported, lat_svm_insn_prepare,
+      default_prepare_gif_clear, null_test,
       lat_svm_insn_finished, lat_svm_insn_check },
     { "pending_event", default_supported, pending_event_prepare,
+      default_prepare_gif_clear,
       pending_event_test, pending_event_finished, pending_event_check },
     { "pending_event_vmask", default_supported, pending_event_prepare_vmask,
+      default_prepare_gif_clear,
       pending_event_test_vmask, pending_event_finished_vmask,
       pending_event_check_vmask },
 };
-- 
1.8.3.1


