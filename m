Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FA83593B3
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 06:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhDIESy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 00:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhDIESy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 00:18:54 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783E3C061760;
        Thu,  8 Apr 2021 21:18:42 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id i4so2259215pjk.1;
        Thu, 08 Apr 2021 21:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Gd+gXcz6Jd6OEHUz9h21bPRreafNfkInMEF4YPsbOpk=;
        b=tefdWYpWO2XnAMMkeY/iwlwssVIS8QxEFUzgz5cgjuzgTa71RZuaRnkw6Ut8ArDbyt
         vDNQsQgqr3DIjUSZO6EfCN7beVAnJVrK9U+hlpT6YjmgOcs84zwx0bdl64ZbUg/9Dc7o
         Z733MXUGKLVBoLTrLPzWC5ZcJaPAw3fjuEdR7MrVOMS6t3oDGNH5vu9kcntpfYSZAFph
         RA/3iUXqQse83yjjcQ684JF+a0fhcRKpF7zMTgtUIqVQSobgttedo1xpusc1zPgXbfNA
         VBD4ecS7hAqyFryS25kHF0+mN8gbWKf9m4KtgMEZRXkrV+xr8ndqzxA/NYMfEuNbrLyh
         cWnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Gd+gXcz6Jd6OEHUz9h21bPRreafNfkInMEF4YPsbOpk=;
        b=Mb2s8ABvf6IUYFbVa5uq/3+rjIcsA2+1Jl79Go+6MrH6641uBdbjK/IwAXLd+xA83v
         nG1HLhEudgQEuXdrlWb0UUgYY+TTwUzfZcOdmx+o/y0FOvKQqfWf5GxYv1yRWh7t7gIu
         RjPwT3GBBUSbgcXFabDb3K5K2HWo2FeJGmY5JwJdbwNnJOlLwxa1VrYtzDp/SZLqNVYw
         Q5asMZejogj9RDJLVYQ48Zo3E3uDEI97uzQ9Zw+qG/qYumyfCoqIcTflF7pN/Gj04CNK
         kZoPxNLM0gB3fjPbBy91St3eVdTRKCW6x36Lgo9o4Imsp1o/grlq6zzJ9NKEMFoYbHed
         uzAg==
X-Gm-Message-State: AOAM531NDu+g+X63yWv3eq38AmOYyQYoSVXm9oP7TDD6Ia5InH8NbVf/
        xUcVEA18tanPK3CSG8QooYWA97qXjuo=
X-Google-Smtp-Source: ABdhPJyYC5We5GOGs227qlbjCUawiRAdPZfMPTKKs2CTtjRaW/csMkfeTbEps/Ol1v0ogr1/E98Fpg==
X-Received: by 2002:a17:90a:5889:: with SMTP id j9mr12376248pji.69.1617941921712;
        Thu, 08 Apr 2021 21:18:41 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id gw24sm765553pjb.42.2021.04.08.21.18.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Apr 2021 21:18:41 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 1/3] x86/kvm: Don't bother __pv_cpu_mask when !CONFIG_SMP
Date:   Fri,  9 Apr 2021 12:18:29 +0800
Message-Id: <1617941911-5338-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Enable PV TLB shootdown when !CONFIG_SMP doesn't make sense. Let's 
move it inside CONFIG_SMP. In addition, we can avoid define and 
alloc __pv_cpu_mask when !CONFIG_SMP and get rid of 'alloc' variable 
in kvm_alloc_cpumask.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * shuffle things around a bit more

 arch/x86/kernel/kvm.c | 118 +++++++++++++++++++++++---------------------------
 1 file changed, 55 insertions(+), 63 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 5e78e01..224a7a1 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -451,6 +451,10 @@ static void __init sev_map_percpu_data(void)
 	}
 }
 
+#ifdef CONFIG_SMP
+
+static DEFINE_PER_CPU(cpumask_var_t, __pv_cpu_mask);
+
 static bool pv_tlb_flush_supported(void)
 {
 	return (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
@@ -458,10 +462,6 @@ static bool pv_tlb_flush_supported(void)
 		kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
 }
 
-static DEFINE_PER_CPU(cpumask_var_t, __pv_cpu_mask);
-
-#ifdef CONFIG_SMP
-
 static bool pv_ipi_supported(void)
 {
 	return kvm_para_has_feature(KVM_FEATURE_PV_SEND_IPI);
@@ -574,6 +574,49 @@ static void kvm_smp_send_call_func_ipi(const struct cpumask *mask)
 	}
 }
 
+static void kvm_flush_tlb_others(const struct cpumask *cpumask,
+			const struct flush_tlb_info *info)
+{
+	u8 state;
+	int cpu;
+	struct kvm_steal_time *src;
+	struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
+
+	cpumask_copy(flushmask, cpumask);
+	/*
+	 * We have to call flush only on online vCPUs. And
+	 * queue flush_on_enter for pre-empted vCPUs
+	 */
+	for_each_cpu(cpu, flushmask) {
+		src = &per_cpu(steal_time, cpu);
+		state = READ_ONCE(src->preempted);
+		if ((state & KVM_VCPU_PREEMPTED)) {
+			if (try_cmpxchg(&src->preempted, &state,
+					state | KVM_VCPU_FLUSH_TLB))
+				__cpumask_clear_cpu(cpu, flushmask);
+		}
+	}
+
+	native_flush_tlb_others(flushmask, info);
+}
+
+static __init int kvm_alloc_cpumask(void)
+{
+	int cpu;
+
+	if (!kvm_para_available() || nopv)
+		return 0;
+
+	if (pv_tlb_flush_supported() || pv_ipi_supported())
+		for_each_possible_cpu(cpu) {
+			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
+				GFP_KERNEL, cpu_to_node(cpu));
+		}
+
+	return 0;
+}
+arch_initcall(kvm_alloc_cpumask);
+
 static void __init kvm_smp_prepare_boot_cpu(void)
 {
 	/*
@@ -611,33 +654,8 @@ static int kvm_cpu_down_prepare(unsigned int cpu)
 	local_irq_enable();
 	return 0;
 }
-#endif
-
-static void kvm_flush_tlb_others(const struct cpumask *cpumask,
-			const struct flush_tlb_info *info)
-{
-	u8 state;
-	int cpu;
-	struct kvm_steal_time *src;
-	struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
-
-	cpumask_copy(flushmask, cpumask);
-	/*
-	 * We have to call flush only on online vCPUs. And
-	 * queue flush_on_enter for pre-empted vCPUs
-	 */
-	for_each_cpu(cpu, flushmask) {
-		src = &per_cpu(steal_time, cpu);
-		state = READ_ONCE(src->preempted);
-		if ((state & KVM_VCPU_PREEMPTED)) {
-			if (try_cmpxchg(&src->preempted, &state,
-					state | KVM_VCPU_FLUSH_TLB))
-				__cpumask_clear_cpu(cpu, flushmask);
-		}
-	}
 
-	native_flush_tlb_others(flushmask, info);
-}
+#endif
 
 static void __init kvm_guest_init(void)
 {
@@ -653,12 +671,6 @@ static void __init kvm_guest_init(void)
 		pv_ops.time.steal_clock = kvm_steal_clock;
 	}
 
-	if (pv_tlb_flush_supported()) {
-		pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
-		pv_ops.mmu.tlb_remove_table = tlb_remove_table;
-		pr_info("KVM setup pv remote TLB flush\n");
-	}
-
 	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
 		apic_set_eoi_write(kvm_guest_apic_eoi_write);
 
@@ -668,6 +680,12 @@ static void __init kvm_guest_init(void)
 	}
 
 #ifdef CONFIG_SMP
+	if (pv_tlb_flush_supported()) {
+		pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
+		pv_ops.mmu.tlb_remove_table = tlb_remove_table;
+		pr_info("KVM setup pv remote TLB flush\n");
+	}
+
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
@@ -794,32 +812,6 @@ static __init int activate_jump_labels(void)
 }
 arch_initcall(activate_jump_labels);
 
-static __init int kvm_alloc_cpumask(void)
-{
-	int cpu;
-	bool alloc = false;
-
-	if (!kvm_para_available() || nopv)
-		return 0;
-
-	if (pv_tlb_flush_supported())
-		alloc = true;
-
-#if defined(CONFIG_SMP)
-	if (pv_ipi_supported())
-		alloc = true;
-#endif
-
-	if (alloc)
-		for_each_possible_cpu(cpu) {
-			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
-				GFP_KERNEL, cpu_to_node(cpu));
-		}
-
-	return 0;
-}
-arch_initcall(kvm_alloc_cpumask);
-
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
 
 /* Kick a cpu by its apicid. Used to wake up a halted vcpu */
-- 
2.7.4

