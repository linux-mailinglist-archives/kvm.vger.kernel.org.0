Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0801502A6
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 09:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbgBCIcF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 03:32:05 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:41410 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbgBCIcF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Feb 2020 03:32:05 -0500
Received: by mail-oi1-f194.google.com with SMTP id i1so13931481oie.8;
        Mon, 03 Feb 2020 00:32:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vgFT7KCLvNSNXKaIMj+AMJeeoDZdmCntNB9bIaSyhR8=;
        b=haYQFwferv5+ZHvfqKEEV/YUXLdSYxjZlN0P4WdvN1Okw1asRKqpj1d86PDYFJ0bNa
         xbKaXhElGXZr/ely1gzZrQrCPFVTjVuXzwzXhE/ijyl7iQ3LoLSiswWk38Q253tqBw0q
         1nw/VQSBppW6Lk0PvkCsBqDNGWtWJEcmhb1puBaNLNh9vBH58UgOLbDbbnoKpofIKRJj
         xFnaM4t2BEeo3hEnz+THrNEobj8VkLSIs7bjRb1vExJYwtzyJwskDSjlgvULeWME5Iji
         PYA4PfHdddbpHlCPtScYnFwV9mMQqUaPVWeQZt0ezObLlBgGIrTaE2+qmR9/nWgEykGc
         BkIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vgFT7KCLvNSNXKaIMj+AMJeeoDZdmCntNB9bIaSyhR8=;
        b=EOl0CDIIY2/7YIbcHUNkN5gnaBypwjCyFGvU86Uu46s6wkgGmj519FbjWDL+DS2q40
         3Ca7h3uqEJEZ2ruWWBtw09wSrJh/Gn4U4faF294EiFqWaWK/xdIHgAZBic5aw9tOvGTA
         vhf4Z5FSB0PNVPg64ki8I6FII0s98+zLfLr4wBhUAjXn8zMSw6MmLxBu/jACPdV3Px/b
         qeaAL0dSSMq3x14QpFkLQMT8lTrx1+gyJAlAkkQ9ZKmTNObYT8nL1cDHX948f7rjr0Ra
         C4OHxwB8Gz7r47QU3mZ9NDKrjuhcyQn/3Q1wfNkgVZAQoSI8sDV/qW35fz/GRnEJtnXx
         m9fg==
X-Gm-Message-State: APjAAAWrohb13bDmGVSO7xheuxlJuHxF7nURN9vpGywJmY9MvrOuIRkb
        9fmM4zD6LN+yW/I4illpths/vCwcEPdSyFQ3mEQ=
X-Google-Smtp-Source: APXvYqyqbOZhNxcsolX/qhng0QvUrm1rXnOtQGEwvMXjjoc299vee2VDlGRGcQcpGnKEBBQUOUw1WCNoUuIu5xhQjIE=
X-Received: by 2002:aca:44d7:: with SMTP id r206mr5716393oia.33.1580718724066;
 Mon, 03 Feb 2020 00:32:04 -0800 (PST)
MIME-Version: 1.0
References: <20200127071602.11460-1-nick.desaulniers@gmail.com>
In-Reply-To: <20200127071602.11460-1-nick.desaulniers@gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 3 Feb 2020 16:31:52 +0800
Message-ID: <CANRm+CwK0Cg45mktda9Yz9fsjPCvtuB8O+fma5L3tV725ki1qw@mail.gmail.com>
Subject: Re: [PATCH] dynamically allocate struct cpumask
To:     Nick Desaulniers <nick.desaulniers@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Nick,
On Mon, 27 Jan 2020 at 15:16, Nick Desaulniers
<nick.desaulniers@gmail.com> wrote:
>
> This helps avoid avoid a potentially large stack allocation.
>
> When building with:
> $ make CC=clang arch/x86/ CFLAGS=-Wframe-larger-than=1000
> The following warning is observed:
> arch/x86/kernel/kvm.c:494:13: warning: stack frame size of 1064 bytes in
> function 'kvm_send_ipi_mask_allbutself' [-Wframe-larger-than=]
> static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int
> vector)
>             ^
> Debugging with:
> https://github.com/ClangBuiltLinux/frame-larger-than
> via:
> $ python3 frame_larger_than.py arch/x86/kernel/kvm.o \
>   kvm_send_ipi_mask_allbutself
> points to the stack allocated `struct cpumask newmask` in
> `kvm_send_ipi_mask_allbutself`. The size of a `struct cpumask` is
> potentially large, as it's CONFIG_NR_CPUS divided by BITS_PER_LONG for
> the target architecture. CONFIG_NR_CPUS for X86_64 can be as high as
> 8192, making a single instance of a `struct cpumask` 1024 B.

Could you help test the below untested patch?

From 867753e2fa27906f15df7902ba1bce7f9cef6ebe Mon Sep 17 00:00:00 2001
From: Wanpeng Li <wanpengli@tencent.com>
Date: Mon, 3 Feb 2020 16:26:35 +0800
Subject: [PATCH] KVM: Pre-allocate 1 cpumask variable per cpu for both
pv tlb and pv ipis

Reported-by: Nick Desaulniers <nick.desaulniers@gmail.com>
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
