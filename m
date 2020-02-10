Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62A2D156FA6
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 07:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbgBJGjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 01:39:11 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:42750 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgBJGjL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 01:39:11 -0500
Received: by mail-ot1-f68.google.com with SMTP id 66so5244190otd.9;
        Sun, 09 Feb 2020 22:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=HlsjcWP9mUkL0ZSkAPaWKXT3aO8hLJuD8G7R6rOrkyo=;
        b=DgaeFq+u997sASMaYeP69Cfm3FrtMU5HvAXKfwLQv2kd4NSHBGEsiylOn3nWsAKX6/
         v/YruLjveEu+JFC5cPxCiHKZHhNr9or+BMP6TrMsSy9el69bBlfmWj0R4YeQdL6G/Ng5
         KE9QCKR6l2tgmIi3/wof+1Zmhdh/OXU4ctsO5HCplwR9OPCLL4+fL8R8qOmFNe3dMFgb
         nE1LB+WyYnFXd96gdNIiatiQGPldn3tJE7ozzb6w5l9xzzADvshy1zNPXEKT7GIsUiZH
         HficcbrdUpOEDAtqCwfhZmFyeQXELuKLp0Y2yEx2cVVRH5xQGj9SLvvNehR3kyFCAH6P
         8MIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=HlsjcWP9mUkL0ZSkAPaWKXT3aO8hLJuD8G7R6rOrkyo=;
        b=BkBnxVme5SUNhH1l9eYag3zUYRqnmwwOgPyaNDT5yY0QKbLHeaS58hN3ebezNTTQ++
         uAd7s4ET3MGEqfhG036+tqKAyphjuwmDzzKx7FW1B/LwA+qv6/RzpVte8IbMhBf96Qe3
         d5r/UIuV5gYAVsBr6/+Qpzis6tW0Z0nipPaz6KryE7SQ3K6l4qRMT06v6FQaQ4ULqnI7
         jwqBQXQYHD2evnjTUF9q5NoqXFYgaaElXGBS48JM8F46jVn0U1Ojj7Kj6CosxhVKPjqc
         0KJtvrV9xFelgVonDTbfxTHxppdmrA+UJZroIPYApjQgMovrsl5RuzS7KqUEEvxHiR9M
         7PvQ==
X-Gm-Message-State: APjAAAXLlLO9Kh9Unf2a+WkgRt86OAet0+X+r6vwGyrJWp/RXrsY6vPO
        x87rXgy0HGGcBPEBdzQxSqPP3JAZ4oVEPKRFlWFx4ic1eYPp/g==
X-Google-Smtp-Source: APXvYqzPo25A9j9ckAWsBjnev3+3TQTWLXQQtFc33/AoSq2bgjPdrjBd9Wtyam+cPp8vkJf3sQE36TRwavSyrCwFtzY=
X-Received: by 2002:a9d:7ccd:: with SMTP id r13mr19722otn.56.1581316750332;
 Sun, 09 Feb 2020 22:39:10 -0800 (PST)
MIME-Version: 1.0
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 10 Feb 2020 14:38:59 +0800
Message-ID: <CANRm+CxGOeGQ0vV9ueBgjUDvkzH29EQWLe4GQGDvOhm3idM6NQ@mail.gmail.com>
Subject: [PATCH v2 2/2] KVM: Pre-allocate 1 cpumask variable per cpu for both
 pv tlb and pv ipis
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Nick Desaulniers Reported:

  When building with:
  $ make CC=clang arch/x86/ CFLAGS=-Wframe-larger-than=1000
  The following warning is observed:
  arch/x86/kernel/kvm.c:494:13: warning: stack frame size of 1064 bytes in
  function 'kvm_send_ipi_mask_allbutself' [-Wframe-larger-than=]
  static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int
  vector)
              ^
  Debugging with:
  https://github.com/ClangBuiltLinux/frame-larger-than
  via:
  $ python3 frame_larger_than.py arch/x86/kernel/kvm.o \
    kvm_send_ipi_mask_allbutself
  points to the stack allocated `struct cpumask newmask` in
  `kvm_send_ipi_mask_allbutself`. The size of a `struct cpumask` is
  potentially large, as it's CONFIG_NR_CPUS divided by BITS_PER_LONG for
  the target architecture. CONFIG_NR_CPUS for X86_64 can be as high as
  8192, making a single instance of a `struct cpumask` 1024 B.

This patch fixes it by pre-allocate 1 cpumask variable per cpu and use it for
both pv tlb and pv ipis..

Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * remove '!alloc' check
 * use new pv check helpers

 arch/x86/kernel/kvm.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 76ea8c4..377b224 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -432,6 +432,8 @@ static bool pv_tlb_flush_supported(void)
         kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
 }

+static DEFINE_PER_CPU(cpumask_var_t, __pv_cpu_mask);
+
 #ifdef CONFIG_SMP

 static bool pv_ipi_supported(void)
@@ -510,12 +512,12 @@ static void kvm_send_ipi_mask(const struct
cpumask *mask, int vector)
 static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask,
int vector)
 {
     unsigned int this_cpu = smp_processor_id();
-    struct cpumask new_mask;
+    struct cpumask *new_mask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
     const struct cpumask *local_mask;

-    cpumask_copy(&new_mask, mask);
-    cpumask_clear_cpu(this_cpu, &new_mask);
-    local_mask = &new_mask;
+    cpumask_copy(new_mask, mask);
+    cpumask_clear_cpu(this_cpu, new_mask);
+    local_mask = new_mask;
     __send_ipi_mask(local_mask, vector);
 }

@@ -595,7 +597,6 @@ static void __init kvm_apf_trap_init(void)
     update_intr_gate(X86_TRAP_PF, async_page_fault);
 }

-static DEFINE_PER_CPU(cpumask_var_t, __pv_tlb_mask);

 static void kvm_flush_tlb_others(const struct cpumask *cpumask,
             const struct flush_tlb_info *info)
@@ -603,7 +604,7 @@ static void kvm_flush_tlb_others(const struct
cpumask *cpumask,
     u8 state;
     int cpu;
     struct kvm_steal_time *src;
-    struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_tlb_mask);
+    struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);

     cpumask_copy(flushmask, cpumask);
     /*
@@ -642,6 +643,7 @@ static void __init kvm_guest_init(void)
     if (pv_tlb_flush_supported()) {
         pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
         pv_ops.mmu.tlb_remove_table = tlb_remove_table;
+        pr_info("KVM setup pv remote TLB flush\n");
     }

     if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
@@ -748,24 +750,31 @@ static __init int activate_jump_labels(void)
 }
 arch_initcall(activate_jump_labels);

-static __init int kvm_setup_pv_tlb_flush(void)
+static __init int kvm_alloc_cpumask(void)
 {
     int cpu;
+    bool alloc = false;

     if (!kvm_para_available() || nopv)
         return 0;

-    if (pv_tlb_flush_supported()) {
+    if (pv_tlb_flush_supported())
+        alloc = true;
+
+#if defined(CONFIG_SMP)
+    if (pv_ipi_supported())
+        alloc = true;
+#endif
+
+    if (alloc)
         for_each_possible_cpu(cpu) {
-            zalloc_cpumask_var_node(per_cpu_ptr(&__pv_tlb_mask, cpu),
+            zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
                 GFP_KERNEL, cpu_to_node(cpu));
         }
-        pr_info("KVM setup pv remote TLB flush\n");
-    }

     return 0;
 }
-arch_initcall(kvm_setup_pv_tlb_flush);
+arch_initcall(kvm_alloc_cpumask);

 #ifdef CONFIG_PARAVIRT_SPINLOCKS

--
2.7.4
