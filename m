Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3842A156F94
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 07:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbgBJGhm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 01:37:42 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:33227 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbgBJGhm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 01:37:42 -0500
Received: by mail-oi1-f195.google.com with SMTP id q81so8234585oig.0;
        Sun, 09 Feb 2020 22:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=sKP+BJ8wBjzEgCx/CYPr7X88CtkSZccKI/5Y02IAgCw=;
        b=Mxve/0KYXH5nHyM1kFSEhNJmYGTlousTYlbYqS1jOPMFF5Veo/9Y2Jz1JOPiMBxd9F
         OYJp9/qUWlj1VlP5SVdNPe3cDJp8BRmqXRUc+QirNj1+jVPKR/LaoO0FKG8JjiD+U8C2
         t/V0PS0BVV4yqtu836kFnbTc2GIylo8fX1pZijFgOvBNGt69qJjka+wCv4XH7ngpfNbA
         7qKphDgW2Ylk7KYUJxic314TvJcqfmzbmHImnajj6+LLQpl2XF7ceLHcpuCVjocUpF4x
         qgjSpPAbumAqrOU5NtK5x7k+FtzTzhUMguu9pukthdhin5KYXOcjaz9I4j09j36Svtyq
         uQqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=sKP+BJ8wBjzEgCx/CYPr7X88CtkSZccKI/5Y02IAgCw=;
        b=q4I+u0kM7VPW0F+4tpv66M4fq4iF0jK6Ydp/dtkfjRSpLWEWcc3TdfQ9kmolDqM1/D
         D97b/isQ41OQB2X5C5RorWNYAz3ySeURpy+XYhWwP487JQLIDpx2UwDyDpmoyj6rOkFB
         6j57CAzBvXEIYxhy+D2RyqfaKJbdZwmPaQVkPIXCBV4bsi9Wc7BgcQ+CcxtZ1iuqvFpl
         KedUnjmnEH+ytrSadgrZgKJaSJ0J6EeA1VXVq7A92oXR7AiYzakGAu/AHHRVYZ5CjPX2
         Mn5DQQckPwfmYzf3KAtw1KCOu8zxvoCnAZSh0fFgectpeGoSj9bmUDdLWPwScPIAflMp
         Am+w==
X-Gm-Message-State: APjAAAWNcM3DM1QK0hKfE9rHA7HoHI8x+EkTfWWxhRR92+d9vHnneGK0
        cEHat6utClocboYd7S5vPPpPCtw3HxOgSb/P6ud5mKYtyP/Xpw==
X-Google-Smtp-Source: APXvYqz1VjnaGereiNdTBdBdTbpaWc/Yme4gnjBca8gp58S465ODJyip6auKSicR/eGvEjwcpEpXy4CtvheHR9SeKG0=
X-Received: by 2002:aca:f305:: with SMTP id r5mr10049656oih.174.1581316661703;
 Sun, 09 Feb 2020 22:37:41 -0800 (PST)
MIME-Version: 1.0
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 10 Feb 2020 14:37:30 +0800
Message-ID: <CANRm+Cxd55Sqi4anpXD_Urmx8BV=R9ZDUwejChJHLBsZeGoWbw@mail.gmail.com>
Subject: [PATCH v2 1/2] KVM: Introduce pv check helpers
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

Introduce some pv check helpers for consistency.

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kernel/kvm.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index d817f25..76ea8c4 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -425,7 +425,27 @@ static void __init sev_map_percpu_data(void)
     }
 }

+static bool pv_tlb_flush_supported(void)
+{
+    return (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
+        !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
+        kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
+}
+
 #ifdef CONFIG_SMP
+
+static bool pv_ipi_supported(void)
+{
+    return kvm_para_has_feature(KVM_FEATURE_PV_SEND_IPI);
+}
+
+static bool pv_sched_yield_supported(void)
+{
+    return (kvm_para_has_feature(KVM_FEATURE_PV_SCHED_YIELD) &&
+        !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
+        kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
+}
+
 #define KVM_IPI_CLUSTER_SIZE    (2 * BITS_PER_LONG)

 static void __send_ipi_mask(const struct cpumask *mask, int vector)
@@ -619,9 +639,7 @@ static void __init kvm_guest_init(void)
         pv_ops.time.steal_clock = kvm_steal_clock;
     }

-    if (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
-        !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
-        kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
+    if (pv_tlb_flush_supported()) {
         pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
         pv_ops.mmu.tlb_remove_table = tlb_remove_table;
     }
@@ -632,9 +650,7 @@ static void __init kvm_guest_init(void)
 #ifdef CONFIG_SMP
     smp_ops.smp_prepare_cpus = kvm_smp_prepare_cpus;
     smp_ops.smp_prepare_boot_cpu = kvm_smp_prepare_boot_cpu;
-    if (kvm_para_has_feature(KVM_FEATURE_PV_SCHED_YIELD) &&
-        !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
-        kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
+    if (pv_sched_yield_supported()) {
         smp_ops.send_call_func_ipi = kvm_smp_send_call_func_ipi;
         pr_info("KVM setup pv sched yield\n");
     }
@@ -700,7 +716,7 @@ static uint32_t __init kvm_detect(void)
 static void __init kvm_apic_init(void)
 {
 #if defined(CONFIG_SMP)
-    if (kvm_para_has_feature(KVM_FEATURE_PV_SEND_IPI))
+    if (pv_ipi_supported())
         kvm_setup_pv_ipi();
 #endif
 }
@@ -739,9 +755,7 @@ static __init int kvm_setup_pv_tlb_flush(void)
     if (!kvm_para_available() || nopv)
         return 0;

-    if (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
-        !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
-        kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
+    if (pv_tlb_flush_supported()) {
         for_each_possible_cpu(cpu) {
             zalloc_cpumask_var_node(per_cpu_ptr(&__pv_tlb_mask, cpu),
                 GFP_KERNEL, cpu_to_node(cpu));
--
2.7.4
