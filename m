Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4109633BB1
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 01:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbfFCXEe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 19:04:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40614 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbfFCXEe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 19:04:34 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C5E363082231;
        Mon,  3 Jun 2019 23:04:33 +0000 (UTC)
Received: from amt.cnet (ovpn-112-8.gru2.redhat.com [10.97.112.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 387775B684;
        Mon,  3 Jun 2019 23:04:33 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id D200B10515C;
        Mon,  3 Jun 2019 20:04:10 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x53N48jP008254;
        Mon, 3 Jun 2019 20:04:08 -0300
Date:   Mon, 3 Jun 2019 20:04:08 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: [patch QEMU] kvm: i386: halt poll control MSR support
Message-ID: <20190603230408.GA7938@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Mon, 03 Jun 2019 23:04:33 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

(CC'ing qemu devel)

Add support for halt poll control MSR: save/restore, migration
and new feature name.

The purpose of this MSR is to allow the guest to disable
host halt poll.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

diff --git a/include/standard-headers/asm-x86/kvm_para.h b/include/standard-headers/asm-x86/kvm_para.h
index 35cd8d6..e171514 100644
--- a/include/standard-headers/asm-x86/kvm_para.h
+++ b/include/standard-headers/asm-x86/kvm_para.h
@@ -29,6 +29,7 @@
 #define KVM_FEATURE_PV_TLB_FLUSH	9
 #define KVM_FEATURE_ASYNC_PF_VMEXIT	10
 #define KVM_FEATURE_PV_SEND_IPI	11
+#define KVM_FEATURE_POLL_CONTROL	12
 
 #define KVM_HINTS_REALTIME      0
 
@@ -47,6 +48,7 @@
 #define MSR_KVM_ASYNC_PF_EN 0x4b564d02
 #define MSR_KVM_STEAL_TIME  0x4b564d03
 #define MSR_KVM_PV_EOI_EN      0x4b564d04
+#define MSR_KVM_POLL_CONTROL	0x4b564d05
 
 struct kvm_steal_time {
 	uint64_t steal;
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index c1ab86d..1ca6944 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -903,7 +903,7 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             "kvmclock", "kvm-nopiodelay", "kvm-mmu", "kvmclock",
             "kvm-asyncpf", "kvm-steal-time", "kvm-pv-eoi", "kvm-pv-unhalt",
             NULL, "kvm-pv-tlb-flush", NULL, "kvm-pv-ipi",
-            NULL, NULL, NULL, NULL,
+            "kvm-poll-control", NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
             "kvmclock-stable-bit", NULL, NULL, NULL,
@@ -3001,6 +3001,7 @@ static PropValue kvm_default_props[] = {
     { "kvm-asyncpf", "on" },
     { "kvm-steal-time", "on" },
     { "kvm-pv-eoi", "on" },
+    { "kvm-poll-control", "on" },
     { "kvmclock-stable-bit", "on" },
     { "x2apic", "on" },
     { "acpi", "off" },
@@ -5660,6 +5661,8 @@ static void x86_cpu_initfn(Object *obj)
     object_property_add_alias(obj, "kvm_steal_time", obj, "kvm-steal-time", &error_abort);
     object_property_add_alias(obj, "kvm_pv_eoi", obj, "kvm-pv-eoi", &error_abort);
     object_property_add_alias(obj, "kvm_pv_unhalt", obj, "kvm-pv-unhalt", &error_abort);
+    object_property_add_alias(obj, "kvm_poll_control", obj, "kvm-poll-control",
+                              &error_abort);
     object_property_add_alias(obj, "svm_lock", obj, "svm-lock", &error_abort);
     object_property_add_alias(obj, "nrip_save", obj, "nrip-save", &error_abort);
     object_property_add_alias(obj, "tsc_scale", obj, "tsc-scale", &error_abort);
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index bd06523..21ed2f8 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1241,6 +1241,7 @@ typedef struct CPUX86State {
     uint64_t steal_time_msr;
     uint64_t async_pf_en_msr;
     uint64_t pv_eoi_en_msr;
+    uint64_t poll_control_msr;
 
     /* Partition-wide HV MSRs, will be updated only on the first vcpu */
     uint64_t msr_hv_hypercall;
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 3b29ce5..a5e9cdf 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -1369,6 +1369,8 @@ void kvm_arch_reset_vcpu(X86CPU *cpu)
 
         hyperv_x86_synic_reset(cpu);
     }
+    /* enabled by default */
+    env->poll_control_msr = 1;
 }
 
 void kvm_arch_do_init_vcpu(X86CPU *cpu)
@@ -2059,6 +2061,11 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
         if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_STEAL_TIME)) {
             kvm_msr_entry_add(cpu, MSR_KVM_STEAL_TIME, env->steal_time_msr);
         }
+
+        if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_POLL_CONTROL)) {
+            kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, env->poll_control_msr);
+        }
+
         if (has_architectural_pmu_version > 0) {
             if (has_architectural_pmu_version > 1) {
                 /* Stop the counter.  */
@@ -2443,6 +2450,9 @@ static int kvm_get_msrs(X86CPU *cpu)
     if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_STEAL_TIME)) {
         kvm_msr_entry_add(cpu, MSR_KVM_STEAL_TIME, 0);
     }
+    if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_POLL_CONTROL)) {
+        kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, 1);
+    }
     if (has_architectural_pmu_version > 0) {
         if (has_architectural_pmu_version > 1) {
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
@@ -2677,6 +2687,10 @@ static int kvm_get_msrs(X86CPU *cpu)
         case MSR_KVM_STEAL_TIME:
             env->steal_time_msr = msrs[i].data;
             break;
+        case MSR_KVM_POLL_CONTROL: {
+            env->poll_control_msr = msrs[i].data;
+            break;
+        }
         case MSR_CORE_PERF_FIXED_CTR_CTRL:
             env->msr_fixed_ctr_ctrl = msrs[i].data;
             break;
diff --git a/target/i386/machine.c b/target/i386/machine.c
index 225b5d4..1c23e5e 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -323,6 +323,14 @@ static bool steal_time_msr_needed(void *opaque)
     return cpu->env.steal_time_msr != 0;
 }
 
+/* Poll control MSR enabled by default */
+static bool poll_control_msr_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+
+    return cpu->env.poll_control_msr != 1;
+}
+
 static const VMStateDescription vmstate_steal_time_msr = {
     .name = "cpu/steal_time_msr",
     .version_id = 1,
@@ -356,6 +364,17 @@ static const VMStateDescription vmstate_pv_eoi_msr = {
     }
 };
 
+static const VMStateDescription vmstate_poll_control_msr = {
+    .name = "cpu/poll_control_msr",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = poll_control_msr_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT64(env.poll_control_msr, X86CPU),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
 static bool fpop_ip_dp_needed(void *opaque)
 {
     X86CPU *cpu = opaque;
@@ -1062,6 +1081,7 @@ VMStateDescription vmstate_x86_cpu = {
         &vmstate_async_pf_msr,
         &vmstate_pv_eoi_msr,
         &vmstate_steal_time_msr,
+        &vmstate_poll_control_msr,
         &vmstate_fpop_ip_dp,
         &vmstate_msr_tsc_adjust,
         &vmstate_msr_tscdeadline,
