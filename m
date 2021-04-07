Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1A7356792
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 11:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349872AbhDGJDU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 05:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239586AbhDGJDU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 05:03:20 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04318C061765;
        Wed,  7 Apr 2021 01:53:21 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id z16so5127708pga.1;
        Wed, 07 Apr 2021 01:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sve316YA3/Gg6zITdKEIncJFk6WzcN83zIbDa7bKqHE=;
        b=nvSdZk20UnMflAwIy/wtlKUZTmfSYz+WG7PdFA0b+/U/HYBQBOTo2JBbErV8fJJ2TB
         3yWzh8ZeMDAlQwLvDCWDMGglwBMnmA7j1BB9OS69TCgCEHtWWxCPTmuEUN/03aPla/2f
         83fclaGinm4KDopyIX6sJHuzHdDemQ7zcrjgQ5IXJGkb9mWa6QQU6BljBbzHK3j692Nk
         OYoFtIC2AinOa2Mryj9NhMO2ILlX1xuxyNN64rASIVlHVR9M+XhWhO+buXxKgCtva/na
         Nph+jlK8oh6BWw7yApTMk7qI0lKglFgjmkTHzhMnyWXwIl5gyY8TZx4SclfDl6mAmGQp
         SYqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sve316YA3/Gg6zITdKEIncJFk6WzcN83zIbDa7bKqHE=;
        b=PgtBzSPkIZu7Oa+KZDL1xK6bl8Y5it4nSLKAbw1U3R2JnsjUCtvRjHchyP9vtgG+b9
         QTorjLAZtXHBG/cZK8x3Y/vU2OEoGuwzO0ElqU+/TcNyhzKjiI+N4h05B7OEDcaJ54xC
         tNPoZ6BW408GbcDdJvoUJ0X3zkGCI5GPn7hdPQSgFcz08zYeb5bVmMS2VtSgEHGotNhi
         lnH+Hz9vOR3RXDdyMCr1DCHrqBFYMoesELIjuoFRV3uPAEJMC9gIR5DfPhEPsDxM2YyF
         p4ORIIUjUrURrVQHCEPGhq99osj2XvfPuNyYN+PqM/9UPnNihQOXX+gMCv6EdkOq1J/p
         uEDg==
X-Gm-Message-State: AOAM5324G3YLG8ap09n0diKaOmagwPkly6lRf8yffq7MywZ7fAlAUmgY
        /6Zl3W552+6DOB6FFFjD3IsYUP0Dm8I=
X-Google-Smtp-Source: ABdhPJwJ6I47VptavpkA9zoDC97IJGd5yPmb+cyb63C7EaqA65ofmauukiC80Iim138P76Q4cbBwaw==
X-Received: by 2002:a63:f303:: with SMTP id l3mr2333092pgh.263.1617785600231;
        Wed, 07 Apr 2021 01:53:20 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id l18sm4555017pjq.33.2021.04.07.01.53.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Apr 2021 01:53:19 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] x86/kvm: Don't alloc __pv_cpu_mask when !CONFIG_SMP
Date:   Wed,  7 Apr 2021 16:53:08 +0800
Message-Id: <1617785588-18722-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Enable PV TLB shootdown when !CONFIG_SMP doesn't make sense. Let's move 
it inside CONFIG_SMP. In addition, we can avoid alloc __pv_cpu_mask when 
!CONFIG_SMP and get rid of 'alloc' variable in kvm_alloc_cpumask.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kernel/kvm.c | 79 +++++++++++++++++++++++++--------------------------
 1 file changed, 39 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 5e78e01..202e1f0 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -451,6 +451,11 @@ static void __init sev_map_percpu_data(void)
 	}
 }
 
+
+static DEFINE_PER_CPU(cpumask_var_t, __pv_cpu_mask);
+
+#ifdef CONFIG_SMP
+
 static bool pv_tlb_flush_supported(void)
 {
 	return (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
@@ -458,10 +463,6 @@ static bool pv_tlb_flush_supported(void)
 		kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
 }
 
-static DEFINE_PER_CPU(cpumask_var_t, __pv_cpu_mask);
-
-#ifdef CONFIG_SMP
-
 static bool pv_ipi_supported(void)
 {
 	return kvm_para_has_feature(KVM_FEATURE_PV_SEND_IPI);
@@ -574,6 +575,32 @@ static void kvm_smp_send_call_func_ipi(const struct cpumask *mask)
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
 static void __init kvm_smp_prepare_boot_cpu(void)
 {
 	/*
@@ -611,33 +638,16 @@ static int kvm_cpu_down_prepare(unsigned int cpu)
 	local_irq_enable();
 	return 0;
 }
-#endif
 
-static void kvm_flush_tlb_others(const struct cpumask *cpumask,
-			const struct flush_tlb_info *info)
-{
-	u8 state;
-	int cpu;
-	struct kvm_steal_time *src;
-	struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
+#else
 
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
+static bool pv_tlb_flush_supported(void) { return false; }
+static bool pv_ipi_supported(void) { return false; }
+static void kvm_flush_tlb_others(const struct cpumask *cpumask,
+			const struct flush_tlb_info *info) { }
+static void kvm_setup_pv_ipi(void) { }
 
-	native_flush_tlb_others(flushmask, info);
-}
+#endif
 
 static void __init kvm_guest_init(void)
 {
@@ -734,10 +744,8 @@ static uint32_t __init kvm_detect(void)
 
 static void __init kvm_apic_init(void)
 {
-#if defined(CONFIG_SMP)
 	if (pv_ipi_supported())
 		kvm_setup_pv_ipi();
-#endif
 }
 
 static bool __init kvm_msi_ext_dest_id(void)
@@ -797,20 +805,11 @@ arch_initcall(activate_jump_labels);
 static __init int kvm_alloc_cpumask(void)
 {
 	int cpu;
-	bool alloc = false;
 
 	if (!kvm_para_available() || nopv)
 		return 0;
 
-	if (pv_tlb_flush_supported())
-		alloc = true;
-
-#if defined(CONFIG_SMP)
-	if (pv_ipi_supported())
-		alloc = true;
-#endif
-
-	if (alloc)
+	if (pv_tlb_flush_supported() || pv_ipi_supported())
 		for_each_possible_cpu(cpu) {
 			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
 				GFP_KERNEL, cpu_to_node(cpu));
-- 
2.7.4

