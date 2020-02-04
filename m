Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22CFA151438
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 03:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgBDCe6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 21:34:58 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:45912 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbgBDCe6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Feb 2020 21:34:58 -0500
Received: by mail-oi1-f193.google.com with SMTP id v19so16928196oic.12;
        Mon, 03 Feb 2020 18:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=UwqlvjZg+P79VPrIKOEjrbePHOK7IvreNa3/f6eQCOM=;
        b=o75bXAf6EcCc8NRROr5wamAH15QCJpnm3lCm/gPrIArOLHNbmg9obJ8XlT6HnSuBMW
         /NtTIj3PTMGlXtbAZJyf7Ik6IaWWqtE6+vkhk/D4qWrDpoERF+gYpA1+AUE/klTr2+Gl
         xNNAY8/JWTpHYzdEgPQ/EMBron58kp3tGYBiYUf6B3e9CeB8RqWb9btVSxE3xPda6jxj
         MsUTzqvJmnaDNGnMGzMDuLWinT4KtBbek2tNmZXoO6VUsCR6KMBKlYoxMT7tktCGkfL8
         f7Up591RJ7olppBt8mVJKnnYtCe3EQ0RwlCCRyBuy+t1Bq4eFulNPhB3kMB/bzgUoJnk
         e3Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=UwqlvjZg+P79VPrIKOEjrbePHOK7IvreNa3/f6eQCOM=;
        b=MvBlrsEoTJe+dMUkgYs/6Q1tC7YgGRVmlwVlegpDBt3y9yhgLNwk9wTtMPZgu7GtNk
         iBp8RaozBXAUzsweMrJF69B4TT6A6VkfkCe8ThhJ/NjdfmIgO2NktvQ8OJoaxzKybc3o
         GSlFS6Rvu6SCS3rrse5ysZmAmwZCP55tsmnN4pZjuTP9aqnihiU+k2TW7CPn8dmR/T+2
         nt5rBl2VpiXMDe8qUnCy7sAoZVjrHU3TORNtRCTDRZ2mAnzpXLqkpghDSQp/UP2+mQGI
         EE5EMAyqmVc7zN3+N/c7qacSNo1dyGZfe3LFsaKPzrfD+WDROYUPjZyHdSsAmRB/eDEC
         GhOA==
X-Gm-Message-State: APjAAAWDFYIuTYWJziIz+uCSNNyzE245Z+zCBQ9lt8h/ojHKpxz3Rtxu
        KWOmgYCi9LAoKaEmJHTlTKUhNlR9vDvRbQgUQsNMcO83sNKPjQ==
X-Google-Smtp-Source: APXvYqxSBol/GUwnr4C2zHlwCSaop2fNuJ2r/nOZROjoa36uLclaEGvQi1JSWOolBvI76ZXljm8ybrq3c2xi/nJcrwY=
X-Received: by 2002:aca:1913:: with SMTP id l19mr1673868oii.47.1580783697159;
 Mon, 03 Feb 2020 18:34:57 -0800 (PST)
MIME-Version: 1.0
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 4 Feb 2020 10:34:45 +0800
Message-ID: <CANRm+CwwYoSLeA3Squp-_fVZpmYmxEfqOB+DGoQN4Y_iMT347w@mail.gmail.com>
Subject: [PATCH] KVM: Pre-allocate 1 cpumask variable per cpu for both pv tlb
 and pv ipis
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
 arch/x86/kernel/kvm.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 81045aab..b1e8efa 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -425,6 +425,8 @@ static void __init sev_map_percpu_data(void)
     }
 }

+static DEFINE_PER_CPU(cpumask_var_t, __pv_cpu_mask);
+
 #ifdef CONFIG_SMP
 #define KVM_IPI_CLUSTER_SIZE    (2 * BITS_PER_LONG)

@@ -490,12 +492,12 @@ static void kvm_send_ipi_mask(const struct
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

@@ -575,7 +577,6 @@ static void __init kvm_apf_trap_init(void)
     update_intr_gate(X86_TRAP_PF, async_page_fault);
 }

-static DEFINE_PER_CPU(cpumask_var_t, __pv_tlb_mask);

 static void kvm_flush_tlb_others(const struct cpumask *cpumask,
             const struct flush_tlb_info *info)
@@ -583,7 +584,7 @@ static void kvm_flush_tlb_others(const struct
cpumask *cpumask,
     u8 state;
     int cpu;
     struct kvm_steal_time *src;
-    struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_tlb_mask);
+    struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);

     cpumask_copy(flushmask, cpumask);
     /*
@@ -624,6 +625,7 @@ static void __init kvm_guest_init(void)
         kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
         pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
         pv_ops.mmu.tlb_remove_table = tlb_remove_table;
+        pr_info("KVM setup pv remote TLB flush\n");
     }

     if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
@@ -732,23 +734,30 @@ static __init int activate_jump_labels(void)
 }
 arch_initcall(activate_jump_labels);

-static __init int kvm_setup_pv_tlb_flush(void)
+static __init int kvm_alloc_cpumask(void)
 {
     int cpu;
+    bool alloc = false;

     if (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
         !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
-        kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
+        kvm_para_has_feature(KVM_FEATURE_STEAL_TIME))
+        alloc = true;
+
+#if defined(CONFIG_SMP)
+    if (!alloc && kvm_para_has_feature(KVM_FEATURE_PV_SEND_IPI))
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
1.8.3.1
