Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDCE358E3A
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 22:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbhDHUVF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 16:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbhDHUVE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 16:21:04 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3ACBC061761
        for <kvm@vger.kernel.org>; Thu,  8 Apr 2021 13:20:52 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id bg21so1780115pjb.0
        for <kvm@vger.kernel.org>; Thu, 08 Apr 2021 13:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+BwzOFL5lZJ1FGuP98rvsXchG4WlBQd3WIhBk1RPIJY=;
        b=jBf+bdFmPAMz3XOJmPdTufROyDbFmZzNEKzk2zFfrcqCY3uaCcefQkfb7RgORtjKh0
         Ddp6Cqfw8iqFcVVoO+6KFVP+Je3ktAsUd8yNj1wMoXx2BNTbvpZZ/3X/H+7J0V/R7+gS
         nCFlMaSPpcKuDIFgcDDFsSZE3W+4oVq+dwV3c4L+OV96P5j6nUU+rslRiWoRpY/ItA0f
         9SpI1ai2VAJBXQVbHtNMWeZZX4ppnRLBN85uFDOjPiTyFpMIeMZkJ/cGHqFW6k1yGSmE
         HQyfq3hwMVl6frZA4XKqRB929IDxpP2vR32l1pnLRHmyFHfgCrbR36b+WJ5ySQkvHQ6s
         4N0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+BwzOFL5lZJ1FGuP98rvsXchG4WlBQd3WIhBk1RPIJY=;
        b=sIQxj8lPUhOP3tCqxCJxDGlaAXgHFFSTGhbTL0un1smpkG/omkWPN8F6sWKay11HxB
         duyy1alOh+bUlH5rO1QLdfdWYF2/4ul3kuwGlpWY8FnNB/EfcbmoOjq5vFYLBGmxgEff
         aBRq0KoMaKgf4vBBozsPc3y9MLKsSBkxUOrFwCqn/ufJLGfRZVEW527I5Ivrmhx16V3R
         M57bfrbGyZ6p2q+Y2wKtxBLvWF0STsU+/ODI3f8aOhpzgdalkIgpMQJxjVvcDBctx38Y
         5D8/ZzSRFVyx7gFi45JMbtzpGoHbTe7bJDpeVLsohkTqWrwI+twXExnNbFyBX/hs0nLF
         ycww==
X-Gm-Message-State: AOAM532DIMRemBaYTtpTAvkqg/8e+As/lY2NNoHjHNDhZw1ml1bIQaRb
        N3DqeWOm1J4yKJzOvM26VLJTxQ==
X-Google-Smtp-Source: ABdhPJxpU/pGaF/l4m40fY2EKYujQFWKD6Onhd8hB7Wc3FV/r18qSkghUk0WhjEKjiPMsDWqKNk5RQ==
X-Received: by 2002:a17:902:aa87:b029:e9:8d9e:6808 with SMTP id d7-20020a170902aa87b02900e98d9e6808mr4910982plr.34.1617913251965;
        Thu, 08 Apr 2021 13:20:51 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id fu11sm232272pjb.35.2021.04.08.13.20.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 13:20:51 -0700 (PDT)
Date:   Thu, 8 Apr 2021 20:20:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] x86/kvm: Don't alloc __pv_cpu_mask when !CONFIG_SMP
Message-ID: <YG9ln4d0tm4acVdG@google.com>
References: <1617785588-18722-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1617785588-18722-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 07, 2021, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Enable PV TLB shootdown when !CONFIG_SMP doesn't make sense. Let's move 
> it inside CONFIG_SMP. In addition, we can avoid alloc __pv_cpu_mask when 
> !CONFIG_SMP and get rid of 'alloc' variable in kvm_alloc_cpumask.

...

> +static bool pv_tlb_flush_supported(void) { return false; }
> +static bool pv_ipi_supported(void) { return false; }
> +static void kvm_flush_tlb_others(const struct cpumask *cpumask,
> +			const struct flush_tlb_info *info) { }
> +static void kvm_setup_pv_ipi(void) { }

If you shuffle things around a bit more, you can avoid these stubs, and hide the
definition of __pv_cpu_mask behind CONFIG_SMP, too.


diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 5e78e01ca3b4..13c6b1c7c01b 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -451,6 +451,8 @@ static void __init sev_map_percpu_data(void)
        }
 }

+#ifdef CONFIG_SMP
+
 static bool pv_tlb_flush_supported(void)
 {
        return (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
@@ -460,8 +462,6 @@ static bool pv_tlb_flush_supported(void)

 static DEFINE_PER_CPU(cpumask_var_t, __pv_cpu_mask);

-#ifdef CONFIG_SMP
-
 static bool pv_ipi_supported(void)
 {
        return kvm_para_has_feature(KVM_FEATURE_PV_SEND_IPI);
@@ -574,45 +574,6 @@ static void kvm_smp_send_call_func_ipi(const struct cpumask *mask)
        }
 }

-static void __init kvm_smp_prepare_boot_cpu(void)
-{
-       /*
-        * Map the per-cpu variables as decrypted before kvm_guest_cpu_init()
-        * shares the guest physical address with the hypervisor.
-        */
-       sev_map_percpu_data();
-
-       kvm_guest_cpu_init();
-       native_smp_prepare_boot_cpu();
-       kvm_spinlock_init();
-}
-
-static void kvm_guest_cpu_offline(void)
-{
-       kvm_disable_steal_time();
-       if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
-               wrmsrl(MSR_KVM_PV_EOI_EN, 0);
-       kvm_pv_disable_apf();
-       apf_task_wake_all();
-}
-
-static int kvm_cpu_online(unsigned int cpu)
-{
-       local_irq_disable();
-       kvm_guest_cpu_init();
-       local_irq_enable();
-       return 0;
-}
-
-static int kvm_cpu_down_prepare(unsigned int cpu)
-{
-       local_irq_disable();
-       kvm_guest_cpu_offline();
-       local_irq_enable();
-       return 0;
-}
-#endif
-
 static void kvm_flush_tlb_others(const struct cpumask *cpumask,
                        const struct flush_tlb_info *info)
 {
@@ -639,6 +600,63 @@ static void kvm_flush_tlb_others(const struct cpumask *cpumask,
        native_flush_tlb_others(flushmask, info);
 }

+static void __init kvm_smp_prepare_boot_cpu(void)
+{
+       /*
+        * Map the per-cpu variables as decrypted before kvm_guest_cpu_init()
+        * shares the guest physical address with the hypervisor.
+        */
+       sev_map_percpu_data();
+
+       kvm_guest_cpu_init();
+       native_smp_prepare_boot_cpu();
+       kvm_spinlock_init();
+}
+
+static void kvm_guest_cpu_offline(void)
+{
+       kvm_disable_steal_time();
+       if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
+               wrmsrl(MSR_KVM_PV_EOI_EN, 0);
+       kvm_pv_disable_apf();
+       apf_task_wake_all();
+}
+
+static int kvm_cpu_online(unsigned int cpu)
+{
+       local_irq_disable();
+       kvm_guest_cpu_init();
+       local_irq_enable();
+       return 0;
+}
+
+static int kvm_cpu_down_prepare(unsigned int cpu)
+{
+       local_irq_disable();
+       kvm_guest_cpu_offline();
+       local_irq_enable();
+       return 0;
+}
+
+static __init int kvm_alloc_cpumask(void)
+{
+       int cpu;
+
+       if (!kvm_para_available() || nopv)
+               return 0;
+
+       if (pv_tlb_flush_supported() || pv_ipi_supported())
+               for_each_possible_cpu(cpu) {
+                       zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
+                               GFP_KERNEL, cpu_to_node(cpu));
+               }
+
+       return 0;
+}
+arch_initcall(kvm_alloc_cpumask);
+
+#endif
+
 static void __init kvm_guest_init(void)
 {
        int i;
@@ -653,21 +671,21 @@ static void __init kvm_guest_init(void)
                pv_ops.time.steal_clock = kvm_steal_clock;
        }

+       if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
+               apic_set_eoi_write(kvm_guest_apic_eoi_write);
+
+       if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_INT) && kvmapf) {
+               static_branch_enable(&kvm_async_pf_enabled);
+               alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, asm_sysvec_kvm_asyncpf_interrupt);
+       }
+
+#ifdef CONFIG_SMP
        if (pv_tlb_flush_supported()) {
                pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
                pv_ops.mmu.tlb_remove_table = tlb_remove_table;
                pr_info("KVM setup pv remote TLB flush\n");
        }

-       if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
-               apic_set_eoi_write(kvm_guest_apic_eoi_write);
-
-       if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_INT) && kvmapf) {
-               static_branch_enable(&kvm_async_pf_enabled);
-               alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, asm_sysvec_kvm_asyncpf_interrupt);
-       }
-
-#ifdef CONFIG_SMP
        smp_ops.smp_prepare_boot_cpu = kvm_smp_prepare_boot_cpu;
        if (pv_sched_yield_supported()) {
                smp_ops.send_call_func_ipi = kvm_smp_send_call_func_ipi;
@@ -734,7 +752,7 @@ static uint32_t __init kvm_detect(void)

 static void __init kvm_apic_init(void)
 {
-#if defined(CONFIG_SMP)
+#ifdef CONFIG_SMP
        if (pv_ipi_supported())
                kvm_setup_pv_ipi();
 #endif
@@ -794,31 +812,6 @@ static __init int activate_jump_labels(void)
 }
 arch_initcall(activate_jump_labels);

-static __init int kvm_alloc_cpumask(void)
-{
-       int cpu;
-       bool alloc = false;
-
-       if (!kvm_para_available() || nopv)
-               return 0;
-
-       if (pv_tlb_flush_supported())
-               alloc = true;
-
-#if defined(CONFIG_SMP)
-       if (pv_ipi_supported())
-               alloc = true;
-#endif
-
-       if (alloc)
-               for_each_possible_cpu(cpu) {
-                       zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
-                               GFP_KERNEL, cpu_to_node(cpu));
-               }
-
-       return 0;
-}
-arch_initcall(kvm_alloc_cpumask);

 #ifdef CONFIG_PARAVIRT_SPINLOCKS


