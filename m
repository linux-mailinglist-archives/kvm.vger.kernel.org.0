Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4496932C708
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235014AbhCDAaz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:30:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29009 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1382837AbhCCS2o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 13:28:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614796037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EXx5h3VcKt3jyYHreeQ9XypRywwHhdUIoUdDoXKimZQ=;
        b=h75AFIpP4MmyZetvKBBh+cvEgvwX/4APZBLmS6abKOTig++DudwcgvyuVFVqNSdx17Fi0P
        Ld31fFQNIAS5E8sLXvUuafFF9bGN/8lhcd60Ws0tIH5PhlD/S6Oy+cvQHogmAJF3gjRPVW
        GF0ic01ROCHHj6PGu+hc3d611vVp+oA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-J6QrLJthPFGZ492b9nw2xQ-1; Wed, 03 Mar 2021 13:23:45 -0500
X-MC-Unique: J6QrLJthPFGZ492b9nw2xQ-1
Received: by mail-wm1-f72.google.com with SMTP id b62so3394562wmc.5
        for <kvm@vger.kernel.org>; Wed, 03 Mar 2021 10:23:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EXx5h3VcKt3jyYHreeQ9XypRywwHhdUIoUdDoXKimZQ=;
        b=QpWIRLS962w7NWkngnJSOKtVuKLETXuVoMpyDTROvfG9HuH5OF4iool8aiKnNgSPpb
         KkW5v0+h98IqFjJyYYJ1RWAqB4+DJpovkP0nSNA5XvCPEMcnBUvsMPe+cPqGlD6eRPWE
         XKxJP+BaYOUS9fo35woo53w42ErJ0hLREL+fsIvDDXUItfJAWdfPJ2dfOBxSjhFm1EyH
         VkIWs56zAHugGVkaU76QhBPYTx1Tfsg4dQbDDYuD/WmIyRz7zhCuFr1hQGbycYY7w7wa
         clJXVev24fnbVGq1l5qIrDgF4eQspXqoq2TAX5M/iApj33PZoOLV9/2837Jb0Y35/sXJ
         nB0w==
X-Gm-Message-State: AOAM5316YpIEAfwcLeWtn/WFpK0w8Ca91tdopByy3ajznWaaoB5hV7GM
        AKB+gtelQBWNReLRwPE7wTle942V84nPpiakw3zuJTrRIjjrDHW/OQkMZkqqHiu/tFEiQdkojvP
        ctOFnsRWZdZGc
X-Received: by 2002:a5d:4e8d:: with SMTP id e13mr11323854wru.251.1614795824489;
        Wed, 03 Mar 2021 10:23:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz5L+10FIf3QeWzSQV6AYajM/q7zSMfTeBTooczz/vv8P1higtN4db/j7T3frNNlnlTxAINCg==
X-Received: by 2002:a5d:4e8d:: with SMTP id e13mr11323824wru.251.1614795824304;
        Wed, 03 Mar 2021 10:23:44 -0800 (PST)
Received: from x1w.redhat.com (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id s11sm6902297wme.22.2021.03.03.10.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 10:23:43 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, Wenchao Wang <wenchao.wang@intel.com>,
        Thomas Huth <thuth@redhat.com>,
        Cameron Esfahani <dirty@apple.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Greg Kurz <groug@kaod.org>, qemu-arm@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Colin Xu <colin.xu@intel.com>,
        Claudio Fontana <cfontana@suse.de>, qemu-ppc@nongnu.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org, haxm-team@intel.com,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [RFC PATCH 12/19] accel/kvm: Use kvm_vcpu_state() when possible
Date:   Wed,  3 Mar 2021 19:22:12 +0100
Message-Id: <20210303182219.1631042-13-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210303182219.1631042-1-philmd@redhat.com>
References: <20210303182219.1631042-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation to move the kvm_state field out of CPUState in few
commits, replace the CPUState->kvm_state dereference by a call to
kvm_vcpu_state().

Patch created mechanically using:

  $ sed -i 's/cpu->kvm_state/kvm_vcpu_state(cpu)/' \
        -i 's/cs->kvm_state/kvm_vcpu_state(cs)/' \
        -i 's/c->kvm_state/kvm_vcpu_state(c)/' $(git grep -l kvm_state)

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 accel/kvm/kvm-all.c   | 10 +++++-----
 target/arm/kvm.c      |  2 +-
 target/arm/kvm64.c    | 12 ++++++------
 target/i386/kvm/kvm.c | 34 +++++++++++++++++-----------------
 target/ppc/kvm.c      | 16 ++++++++--------
 5 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index b787d590a9a..8259e89bbaf 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2760,7 +2760,7 @@ struct kvm_sw_breakpoint *kvm_find_sw_breakpoint(CPUState *cpu,
 {
     struct kvm_sw_breakpoint *bp;
 
-    QTAILQ_FOREACH(bp, &cpu->kvm_state->kvm_sw_breakpoints, entry) {
+    QTAILQ_FOREACH(bp, &kvm_vcpu_state(cpu)->kvm_sw_breakpoints, entry) {
         if (bp->pc == pc) {
             return bp;
         }
@@ -2770,7 +2770,7 @@ struct kvm_sw_breakpoint *kvm_find_sw_breakpoint(CPUState *cpu,
 
 int kvm_sw_breakpoints_active(CPUState *cpu)
 {
-    return !QTAILQ_EMPTY(&cpu->kvm_state->kvm_sw_breakpoints);
+    return !QTAILQ_EMPTY(&kvm_vcpu_state(cpu)->kvm_sw_breakpoints);
 }
 
 struct kvm_set_guest_debug_data {
@@ -2825,7 +2825,7 @@ int kvm_insert_breakpoint(CPUState *cpu, target_ulong addr,
             return err;
         }
 
-        QTAILQ_INSERT_HEAD(&cpu->kvm_state->kvm_sw_breakpoints, bp, entry);
+        QTAILQ_INSERT_HEAD(&kvm_vcpu_state(cpu)->kvm_sw_breakpoints, bp, entry);
     } else {
         err = kvm_arch_insert_hw_breakpoint(addr, len, type);
         if (err) {
@@ -2864,7 +2864,7 @@ int kvm_remove_breakpoint(CPUState *cpu, target_ulong addr,
             return err;
         }
 
-        QTAILQ_REMOVE(&cpu->kvm_state->kvm_sw_breakpoints, bp, entry);
+        QTAILQ_REMOVE(&kvm_vcpu_state(cpu)->kvm_sw_breakpoints, bp, entry);
         g_free(bp);
     } else {
         err = kvm_arch_remove_hw_breakpoint(addr, len, type);
@@ -2885,7 +2885,7 @@ int kvm_remove_breakpoint(CPUState *cpu, target_ulong addr,
 void kvm_remove_all_breakpoints(CPUState *cpu)
 {
     struct kvm_sw_breakpoint *bp, *next;
-    KVMState *s = cpu->kvm_state;
+    KVMState *s = kvm_vcpu_state(cpu);
     CPUState *tmpcpu;
 
     QTAILQ_FOREACH_SAFE(bp, &s->kvm_sw_breakpoints, entry, next) {
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 00e124c8123..ed7c4e4815c 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -61,7 +61,7 @@ int kvm_arm_vcpu_finalize(CPUState *cs, int feature)
 
 void kvm_arm_init_serror_injection(CPUState *cs)
 {
-    cap_has_inject_serror_esr = kvm_check_extension(cs->kvm_state,
+    cap_has_inject_serror_esr = kvm_check_extension(kvm_vcpu_state(cs),
                                     KVM_CAP_ARM_INJECT_SERROR_ESR);
 }
 
diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
index dff85f6db94..c15df0cb1b7 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -85,14 +85,14 @@ GArray *hw_breakpoints, *hw_watchpoints;
  */
 static void kvm_arm_init_debug(CPUState *cs)
 {
-    have_guest_debug = kvm_check_extension(cs->kvm_state,
+    have_guest_debug = kvm_check_extension(kvm_vcpu_state(cs),
                                            KVM_CAP_SET_GUEST_DEBUG);
 
-    max_hw_wps = kvm_check_extension(cs->kvm_state, KVM_CAP_GUEST_DEBUG_HW_WPS);
+    max_hw_wps = kvm_check_extension(kvm_vcpu_state(cs), KVM_CAP_GUEST_DEBUG_HW_WPS);
     hw_watchpoints = g_array_sized_new(true, true,
                                        sizeof(HWWatchpoint), max_hw_wps);
 
-    max_hw_bps = kvm_check_extension(cs->kvm_state, KVM_CAP_GUEST_DEBUG_HW_BPS);
+    max_hw_bps = kvm_check_extension(kvm_vcpu_state(cs), KVM_CAP_GUEST_DEBUG_HW_BPS);
     hw_breakpoints = g_array_sized_new(true, true,
                                        sizeof(HWBreakpoint), max_hw_bps);
     return;
@@ -837,14 +837,14 @@ int kvm_arch_init_vcpu(CPUState *cs)
     if (cs->start_powered_off) {
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_POWER_OFF;
     }
-    if (kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
+    if (kvm_check_extension(kvm_vcpu_state(cs), KVM_CAP_ARM_PSCI_0_2)) {
         cpu->psci_version = 2;
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_PSCI_0_2;
     }
     if (!arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_EL1_32BIT;
     }
-    if (!kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PMU_V3)) {
+    if (!kvm_check_extension(kvm_vcpu_state(cs), KVM_CAP_ARM_PMU_V3)) {
         cpu->has_pmu = false;
     }
     if (cpu->has_pmu) {
@@ -1411,7 +1411,7 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
             object_property_get_bool(obj, "ras", NULL)) {
         ram_addr = qemu_ram_addr_from_host(addr);
         if (ram_addr != RAM_ADDR_INVALID &&
-            kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
+            kvm_physical_memory_addr_from_host(kvm_vcpu_state(c), addr, &paddr)) {
             kvm_hwpoison_page_add(ram_addr);
             /*
              * If this is a BUS_MCEERR_AR, we know we have been called
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 0b5755e42b8..b2facf4f7c1 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -583,7 +583,7 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
     if ((env->mcg_cap & MCG_SER_P) && addr) {
         ram_addr = qemu_ram_addr_from_host(addr);
         if (ram_addr != RAM_ADDR_INVALID &&
-            kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
+            kvm_physical_memory_addr_from_host(kvm_vcpu_state(c), addr, &paddr)) {
             kvm_hwpoison_page_add(ram_addr);
             kvm_mce_inject(cpu, paddr, code);
 
@@ -715,7 +715,7 @@ unsigned long kvm_arch_vcpu_id(CPUState *cs)
 static bool hyperv_enabled(X86CPU *cpu)
 {
     CPUState *cs = CPU(cpu);
-    return kvm_check_extension(cs->kvm_state, KVM_CAP_HYPERV) > 0 &&
+    return kvm_check_extension(kvm_vcpu_state(cs), KVM_CAP_HYPERV) > 0 &&
         ((cpu->hyperv_spinlock_attempts != HYPERV_SPINLOCK_NEVER_NOTIFY) ||
          cpu->hyperv_features || cpu->hyperv_passthrough);
 }
@@ -747,13 +747,13 @@ static int kvm_arch_set_tsc_khz(CPUState *cs)
         return 0;
     }
 
-    cur_freq = kvm_check_extension(cs->kvm_state, KVM_CAP_GET_TSC_KHZ) ?
+    cur_freq = kvm_check_extension(kvm_vcpu_state(cs), KVM_CAP_GET_TSC_KHZ) ?
                kvm_vcpu_ioctl(cs, KVM_GET_TSC_KHZ) : -ENOTSUP;
 
     /*
      * If TSC scaling is supported, attempt to set TSC frequency.
      */
-    if (kvm_check_extension(cs->kvm_state, KVM_CAP_TSC_CONTROL)) {
+    if (kvm_check_extension(kvm_vcpu_state(cs), KVM_CAP_TSC_CONTROL)) {
         set_ioctl = true;
     }
 
@@ -773,9 +773,9 @@ static int kvm_arch_set_tsc_khz(CPUState *cs)
         /* When KVM_SET_TSC_KHZ fails, it's an error only if the current
          * TSC frequency doesn't match the one we want.
          */
-        cur_freq = kvm_check_extension(cs->kvm_state, KVM_CAP_GET_TSC_KHZ) ?
-                   kvm_vcpu_ioctl(cs, KVM_GET_TSC_KHZ) :
-                   -ENOTSUP;
+        cur_freq = kvm_check_extension(kvm_vcpu_state(cs), KVM_CAP_GET_TSC_KHZ)
+                   ? kvm_vcpu_ioctl(cs, KVM_GET_TSC_KHZ)
+                   : -ENOTSUP;
         if (cur_freq <= 0 || cur_freq != env->tsc_khz) {
             warn_report("TSC frequency mismatch between "
                         "VM (%" PRId64 " kHz) and host (%d kHz), "
@@ -994,7 +994,7 @@ static struct kvm_cpuid2 *get_supported_hv_cpuid_legacy(CPUState *cs)
     entry_recomm->function = HV_CPUID_ENLIGHTMENT_INFO;
     entry_recomm->ebx = cpu->hyperv_spinlock_attempts;
 
-    if (kvm_check_extension(cs->kvm_state, KVM_CAP_HYPERV) > 0) {
+    if (kvm_check_extension(kvm_vcpu_state(cs), KVM_CAP_HYPERV) > 0) {
         entry_feat->eax |= HV_HYPERCALL_AVAILABLE;
         entry_feat->eax |= HV_APIC_ACCESS_AVAILABLE;
         entry_feat->edx |= HV_CPU_DYNAMIC_PARTITIONING_AVAILABLE;
@@ -1002,7 +1002,7 @@ static struct kvm_cpuid2 *get_supported_hv_cpuid_legacy(CPUState *cs)
         entry_recomm->eax |= HV_APIC_ACCESS_RECOMMENDED;
     }
 
-    if (kvm_check_extension(cs->kvm_state, KVM_CAP_HYPERV_TIME) > 0) {
+    if (kvm_check_extension(kvm_vcpu_state(cs), KVM_CAP_HYPERV_TIME) > 0) {
         entry_feat->eax |= HV_TIME_REF_COUNT_AVAILABLE;
         entry_feat->eax |= HV_REFERENCE_TSC_AVAILABLE;
     }
@@ -1036,7 +1036,7 @@ static struct kvm_cpuid2 *get_supported_hv_cpuid_legacy(CPUState *cs)
         unsigned int cap = cpu->hyperv_synic_kvm_only ?
             KVM_CAP_HYPERV_SYNIC : KVM_CAP_HYPERV_SYNIC2;
 
-        if (kvm_check_extension(cs->kvm_state, cap) > 0) {
+        if (kvm_check_extension(kvm_vcpu_state(cs), cap) > 0) {
             entry_feat->eax |= HV_SYNIC_AVAILABLE;
         }
     }
@@ -1045,18 +1045,18 @@ static struct kvm_cpuid2 *get_supported_hv_cpuid_legacy(CPUState *cs)
         entry_feat->eax |= HV_SYNTIMERS_AVAILABLE;
     }
 
-    if (kvm_check_extension(cs->kvm_state,
+    if (kvm_check_extension(kvm_vcpu_state(cs),
                             KVM_CAP_HYPERV_TLBFLUSH) > 0) {
         entry_recomm->eax |= HV_REMOTE_TLB_FLUSH_RECOMMENDED;
         entry_recomm->eax |= HV_EX_PROCESSOR_MASKS_RECOMMENDED;
     }
 
-    if (kvm_check_extension(cs->kvm_state,
+    if (kvm_check_extension(kvm_vcpu_state(cs),
                             KVM_CAP_HYPERV_ENLIGHTENED_VMCS) > 0) {
         entry_recomm->eax |= HV_ENLIGHTENED_VMCS_RECOMMENDED;
     }
 
-    if (kvm_check_extension(cs->kvm_state,
+    if (kvm_check_extension(kvm_vcpu_state(cs),
                             KVM_CAP_HYPERV_SEND_IPI) > 0) {
         entry_recomm->eax |= HV_CLUSTER_IPI_RECOMMENDED;
         entry_recomm->eax |= HV_EX_PROCESSOR_MASKS_RECOMMENDED;
@@ -1200,7 +1200,7 @@ static int hyperv_handle_properties(CPUState *cs,
         }
     }
 
-    if (kvm_check_extension(cs->kvm_state, KVM_CAP_HYPERV_CPUID) > 0) {
+    if (kvm_check_extension(kvm_vcpu_state(cs), KVM_CAP_HYPERV_CPUID) > 0) {
         cpuid = get_supported_hv_cpuid(cs);
     } else {
         cpuid = get_supported_hv_cpuid_legacy(cs);
@@ -1504,7 +1504,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
      * so that vcpu's TSC frequency can be migrated later via this field.
      */
     if (!env->tsc_khz) {
-        r = kvm_check_extension(cs->kvm_state, KVM_CAP_GET_TSC_KHZ) ?
+        r = kvm_check_extension(kvm_vcpu_state(cs), KVM_CAP_GET_TSC_KHZ) ?
             kvm_vcpu_ioctl(cs, KVM_GET_TSC_KHZ) :
             -ENOTSUP;
         if (r > 0) {
@@ -1746,12 +1746,12 @@ int kvm_arch_init_vcpu(CPUState *cs)
     if (((env->cpuid_version >> 8)&0xF) >= 6
         && (env->features[FEAT_1_EDX] & (CPUID_MCE | CPUID_MCA)) ==
            (CPUID_MCE | CPUID_MCA)
-        && kvm_check_extension(cs->kvm_state, KVM_CAP_MCE) > 0) {
+        && kvm_check_extension(kvm_vcpu_state(cs), KVM_CAP_MCE) > 0) {
         uint64_t mcg_cap, unsupported_caps;
         int banks;
         int ret;
 
-        ret = kvm_get_mce_cap_supported(cs->kvm_state, &mcg_cap, &banks);
+        ret = kvm_get_mce_cap_supported(kvm_vcpu_state(cs), &mcg_cap, &banks);
         if (ret < 0) {
             fprintf(stderr, "kvm_get_mce_cap_supported: %s", strerror(-ret));
             return ret;
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 298c1f882c6..d9a8f019a74 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -205,7 +205,7 @@ static int kvm_booke206_tlb_init(PowerPCCPU *cpu)
     int ret, i;
 
     if (!kvm_enabled() ||
-        !kvm_check_extension(cs->kvm_state, KVM_CAP_SW_TLB)) {
+        !kvm_check_extension(kvm_vcpu_state(cs), KVM_CAP_SW_TLB)) {
         return 0;
     }
 
@@ -303,7 +303,7 @@ target_ulong kvmppc_configure_v3_mmu(PowerPCCPU *cpu,
         flags |= KVM_PPC_MMUV3_GTSE;
     }
     cfg.flags = flags;
-    ret = kvm_vm_ioctl(cs->kvm_state, KVM_PPC_CONFIGURE_V3_MMU, &cfg);
+    ret = kvm_vm_ioctl(kvm_vcpu_state(cs), KVM_PPC_CONFIGURE_V3_MMU, &cfg);
     switch (ret) {
     case 0:
         return H_SUCCESS;
@@ -483,7 +483,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
         ret = kvm_booke206_tlb_init(cpu);
         break;
     case POWERPC_MMU_2_07:
-        if (!cap_htm && !kvmppc_is_pr(cs->kvm_state)) {
+        if (!cap_htm && !kvmppc_is_pr(kvm_vcpu_state(cs))) {
             /*
              * KVM-HV has transactional memory on POWER8 also without
              * the KVM_CAP_PPC_HTM extension, so enable it here
@@ -1947,8 +1947,8 @@ static int kvmppc_get_pvinfo(CPUPPCState *env, struct kvm_ppc_pvinfo *pvinfo)
 {
     CPUState *cs = env_cpu(env);
 
-    if (kvm_vm_check_extension(cs->kvm_state, KVM_CAP_PPC_GET_PVINFO) &&
-        !kvm_vm_ioctl(cs->kvm_state, KVM_PPC_GET_PVINFO, pvinfo)) {
+    if (kvm_vm_check_extension(kvm_vcpu_state(cs), KVM_CAP_PPC_GET_PVINFO) &&
+        !kvm_vm_ioctl(kvm_vcpu_state(cs), KVM_PPC_GET_PVINFO, pvinfo)) {
         return 0;
     }
 
@@ -2864,7 +2864,7 @@ int kvmppc_resize_hpt_prepare(PowerPCCPU *cpu, target_ulong flags, int shift)
         return -ENOSYS;
     }
 
-    return kvm_vm_ioctl(cs->kvm_state, KVM_PPC_RESIZE_HPT_PREPARE, &rhpt);
+    return kvm_vm_ioctl(kvm_vcpu_state(cs), KVM_PPC_RESIZE_HPT_PREPARE, &rhpt);
 }
 
 int kvmppc_resize_hpt_commit(PowerPCCPU *cpu, target_ulong flags, int shift)
@@ -2879,7 +2879,7 @@ int kvmppc_resize_hpt_commit(PowerPCCPU *cpu, target_ulong flags, int shift)
         return -ENOSYS;
     }
 
-    return kvm_vm_ioctl(cs->kvm_state, KVM_PPC_RESIZE_HPT_COMMIT, &rhpt);
+    return kvm_vm_ioctl(kvm_vcpu_state(cs), KVM_PPC_RESIZE_HPT_COMMIT, &rhpt);
 }
 
 /*
@@ -2909,7 +2909,7 @@ bool kvmppc_pvr_workaround_required(PowerPCCPU *cpu)
         return false;
     }
 
-    return !kvmppc_is_pr(cs->kvm_state);
+    return !kvmppc_is_pr(kvm_vcpu_state(cs));
 }
 
 void kvmppc_set_reg_ppc_online(PowerPCCPU *cpu, unsigned int online)
-- 
2.26.2

