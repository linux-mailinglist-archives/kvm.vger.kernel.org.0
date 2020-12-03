Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954C12CDC3D
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 18:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387427AbgLCRRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 12:17:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33511 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726167AbgLCRRd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 12:17:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607015766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qQ12plZNbjdrqzCYsNpSa/yzgLRJWhC6MUBt7ifldOY=;
        b=fj1zRbHYSqEu4SiYHPcBksxEWxL4583jY9K5brJCdglolVHs9LCYVeA0dwVZLoq5lg4NPV
        gcV+c0Xwgax39IuCYUJ+HoacGI2e4od3X76b7foRJfigdcpKqDUVLBihHg7lrFgCtKnCoB
        U0PPcN1BQlWOwjRfsTe7/toDSxqWuoU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-KX64d0q7N-GyIsvSrvdwkA-1; Thu, 03 Dec 2020 12:16:03 -0500
X-MC-Unique: KX64d0q7N-GyIsvSrvdwkA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7785C107ACE4;
        Thu,  3 Dec 2020 17:16:02 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 12CBF5D6AC;
        Thu,  3 Dec 2020 17:15:58 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 2/2] Implement support for precise TSC migration
Date:   Thu,  3 Dec 2020 19:15:46 +0200
Message-Id: <20201203171546.372686-3-mlevitsk@redhat.com>
In-Reply-To: <20201203171546.372686-1-mlevitsk@redhat.com>
References: <20201203171546.372686-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To enable it, you need to set -accel kvm,x-precise-tsc=on,
and have a kernel that supports this feature.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 accel/kvm/kvm-all.c   |  28 +++++++++
 include/sysemu/kvm.h  |   1 +
 target/i386/cpu.h     |   1 +
 target/i386/kvm.c     | 140 +++++++++++++++++++++++++++++++++---------
 target/i386/machine.c |  19 ++++++
 5 files changed, 161 insertions(+), 28 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index baaa54249d..3829f2e7a3 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -104,6 +104,8 @@ struct KVMState
     OnOffAuto kernel_irqchip_split;
     bool sync_mmu;
     uint64_t manual_dirty_log_protect;
+    /* Use KVM_GET_TSC_PRECISE/KVM_SET_TSC_PRECISE to access IA32_TSC */
+    bool precise_tsc;
     /* The man page (and posix) say ioctl numbers are signed int, but
      * they're not.  Linux, glibc and *BSD all treat ioctl numbers as
      * unsigned, and treating them as signed here can break things */
@@ -3194,6 +3196,24 @@ bool kvm_kernel_irqchip_split(void)
     return kvm_state->kernel_irqchip_split == ON_OFF_AUTO_ON;
 }
 
+bool kvm_has_precise_tsc(void)
+{
+    return kvm_state && kvm_state->precise_tsc;
+}
+
+static void kvm_set_precise_tsc(Object *obj,
+                                bool value, Error **errp G_GNUC_UNUSED)
+{
+    KVMState *s = KVM_STATE(obj);
+    s->precise_tsc = value;
+}
+
+static bool kvm_get_precise_tsc(Object *obj, Error **errp G_GNUC_UNUSED)
+{
+    KVMState *s = KVM_STATE(obj);
+    return s->precise_tsc;
+}
+
 static void kvm_accel_instance_init(Object *obj)
 {
     KVMState *s = KVM_STATE(obj);
@@ -3222,6 +3242,14 @@ static void kvm_accel_class_init(ObjectClass *oc, void *data)
         NULL, NULL);
     object_class_property_set_description(oc, "kvm-shadow-mem",
         "KVM shadow MMU size");
+
+    object_class_property_add_bool(oc, "x-precise-tsc",
+                                   kvm_get_precise_tsc,
+                                   kvm_set_precise_tsc);
+
+    object_class_property_set_description(oc, "x-precise-tsc",
+                                          "Use precise tsc kvm API");
+
 }
 
 static const TypeInfo kvm_accel_type = {
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index bb5d5cf497..14eff2b1c9 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -519,6 +519,7 @@ void kvm_init_irq_routing(KVMState *s);
 bool kvm_kernel_irqchip_allowed(void);
 bool kvm_kernel_irqchip_required(void);
 bool kvm_kernel_irqchip_split(void);
+bool kvm_has_precise_tsc(void);
 
 /**
  * kvm_arch_irqchip_create:
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 88e8586f8f..d2230d9735 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1460,6 +1460,7 @@ typedef struct CPUX86State {
     uint64_t tsc_adjust;
     uint64_t tsc_deadline;
     uint64_t tsc_aux;
+    uint64_t tsc_ns_timestamp;
 
     uint64_t xcr0;
 
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index a2934dda02..4adb7d6246 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -121,7 +121,6 @@ static int has_xsave;
 static int has_xcrs;
 static int has_pit_state2;
 static int has_exception_payload;
-
 static bool has_msr_mcg_ext_ctl;
 
 static struct kvm_cpuid2 *cpuid_cache;
@@ -196,31 +195,112 @@ static int kvm_get_tsc(CPUState *cs)
 {
     X86CPU *cpu = X86_CPU(cs);
     CPUX86State *env = &cpu->env;
-    struct {
-        struct kvm_msrs info;
-        struct kvm_msr_entry entries[1];
-    } msr_data = {};
     int ret;
 
     if (env->tsc_valid) {
         return 0;
     }
 
-    memset(&msr_data, 0, sizeof(msr_data));
-    msr_data.info.nmsrs = 1;
-    msr_data.entries[0].index = MSR_IA32_TSC;
-    env->tsc_valid = !runstate_is_running();
+    if (kvm_has_precise_tsc()) {
+        struct kvm_tsc_state tsc_state;
 
-    ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_MSRS, &msr_data);
-    if (ret < 0) {
-        return ret;
+        ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_TSC_STATE, &tsc_state);
+        if (ret < 0) {
+            return ret;
+        }
+
+        env->tsc = tsc_state.tsc;
+
+        if (tsc_state.flags & KVM_TSC_STATE_TIMESTAMP_VALID) {
+            env->tsc_ns_timestamp = tsc_state.nsec;
+        }
+
+        if (tsc_state.flags & KVM_TSC_STATE_TSC_ADJUST_VALID) {
+            env->tsc_adjust = tsc_state.tsc_adjust;
+        }
+
+    } else {
+        struct {
+            struct kvm_msrs info;
+            struct kvm_msr_entry entries[2];
+        } msr_data = {
+            .info.nmsrs = 1,
+            .entries[0].index = MSR_IA32_TSC,
+        };
+
+        if (has_msr_tsc_adjust) {
+            msr_data.info.nmsrs++;
+            msr_data.entries[1].index = MSR_TSC_ADJUST;
+        }
+
+        ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_MSRS, &msr_data);
+        if (ret < 0) {
+            return ret;
+        }
+
+        assert(ret == msr_data.info.nmsrs);
+        env->tsc = msr_data.entries[0].data;
+        if (has_msr_tsc_adjust) {
+            env->tsc_adjust = msr_data.entries[1].data;
+        }
     }
 
-    assert(ret == 1);
-    env->tsc = msr_data.entries[0].data;
+    env->tsc_valid = !runstate_is_running();
     return 0;
 }
 
+static int kvm_set_tsc(CPUState *cs)
+{
+    int ret;
+    X86CPU *cpu = X86_CPU(cs);
+    CPUX86State *env = &cpu->env;
+
+    if (kvm_has_precise_tsc()) {
+        struct kvm_tsc_state tsc_state = {
+                .tsc = env->tsc,
+        };
+
+        if (env->tsc_ns_timestamp) {
+            tsc_state.nsec = env->tsc_ns_timestamp;
+            tsc_state.flags |= KVM_TSC_STATE_TIMESTAMP_VALID;
+        }
+
+        if (has_msr_tsc_adjust) {
+            tsc_state.tsc_adjust = env->tsc_adjust;
+            tsc_state.flags |= KVM_TSC_STATE_TSC_ADJUST_VALID;
+        }
+
+        ret = kvm_vcpu_ioctl(CPU(cpu), KVM_SET_TSC_STATE, &tsc_state);
+        if (ret < 0) {
+            return ret;
+        }
+
+    } else {
+        struct {
+            struct kvm_msrs info;
+            struct kvm_msr_entry entries[2];
+        } msr_data = {
+            .info.nmsrs = 1,
+            .entries[0].index = MSR_IA32_TSC,
+            .entries[0].data = env->tsc,
+        };
+
+        if (has_msr_tsc_adjust) {
+            msr_data.info.nmsrs++;
+            msr_data.entries[1].index = MSR_TSC_ADJUST;
+            msr_data.entries[1].data = env->tsc_adjust;
+        }
+
+        ret = kvm_vcpu_ioctl(CPU(cpu), KVM_SET_MSRS, &msr_data);
+        if (ret < 0) {
+            return ret;
+        }
+
+        assert(ret == msr_data.info.nmsrs);
+    }
+    return ret;
+}
+
 static inline void do_kvm_synchronize_tsc(CPUState *cpu, run_on_cpu_data arg)
 {
     kvm_get_tsc(cpu);
@@ -1780,6 +1860,13 @@ int kvm_arch_init_vcpu(CPUState *cs)
         }
     }
 
+    if (kvm_has_precise_tsc()) {
+        if (!kvm_check_extension(cs->kvm_state, KVM_CAP_PRECISE_TSC)) {
+            error_report("kvm: Precise TSC is not supported by the host's KVM");
+            return -ENOTSUP;
+        }
+    }
+
     if (cpu->vmware_cpuid_freq
         /* Guests depend on 0x40000000 to detect this feature, so only expose
          * it if KVM exposes leaf 0x40000000. (Conflicts with Hyper-V) */
@@ -2756,9 +2843,6 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
     if (has_msr_tsc_aux) {
         kvm_msr_entry_add(cpu, MSR_TSC_AUX, env->tsc_aux);
     }
-    if (has_msr_tsc_adjust) {
-        kvm_msr_entry_add(cpu, MSR_TSC_ADJUST, env->tsc_adjust);
-    }
     if (has_msr_misc_enable) {
         kvm_msr_entry_add(cpu, MSR_IA32_MISC_ENABLE,
                           env->msr_ia32_misc_enable);
@@ -2802,7 +2886,6 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
      * for normal writeback. Limit them to reset or full state updates.
      */
     if (level >= KVM_PUT_RESET_STATE) {
-        kvm_msr_entry_add(cpu, MSR_IA32_TSC, env->tsc);
         kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME, env->system_time_msr);
         kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK, env->wall_clock_msr);
         if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_ASYNC_PF_INT)) {
@@ -3142,9 +3225,6 @@ static int kvm_get_msrs(X86CPU *cpu)
     if (has_msr_tsc_aux) {
         kvm_msr_entry_add(cpu, MSR_TSC_AUX, 0);
     }
-    if (has_msr_tsc_adjust) {
-        kvm_msr_entry_add(cpu, MSR_TSC_ADJUST, 0);
-    }
     if (has_msr_tsc_deadline) {
         kvm_msr_entry_add(cpu, MSR_IA32_TSCDEADLINE, 0);
     }
@@ -3178,10 +3258,6 @@ static int kvm_get_msrs(X86CPU *cpu)
     if (has_msr_virt_ssbd) {
         kvm_msr_entry_add(cpu, MSR_VIRT_SSBD, 0);
     }
-    if (!env->tsc_valid) {
-        kvm_msr_entry_add(cpu, MSR_IA32_TSC, 0);
-        env->tsc_valid = !runstate_is_running();
-    }
 
 #ifdef TARGET_X86_64
     if (lm_capable_kernel) {
@@ -3385,9 +3461,6 @@ static int kvm_get_msrs(X86CPU *cpu)
         case MSR_TSC_AUX:
             env->tsc_aux = msrs[i].data;
             break;
-        case MSR_TSC_ADJUST:
-            env->tsc_adjust = msrs[i].data;
-            break;
         case MSR_IA32_TSCDEADLINE:
             env->tsc_deadline = msrs[i].data;
             break;
@@ -3995,6 +4068,11 @@ int kvm_arch_put_registers(CPUState *cpu, int level)
         if (ret < 0) {
             return ret;
         }
+
+        ret = kvm_set_tsc(cpu);
+        if (ret < 0) {
+            return ret;
+        }
     }
 
     ret = kvm_put_tscdeadline_msr(x86_cpu);
@@ -4064,6 +4142,12 @@ int kvm_arch_get_registers(CPUState *cs)
     if (ret < 0) {
         goto out;
     }
+
+    ret = kvm_get_tsc(cs);
+    if (ret < 0) {
+        goto out;
+    }
+
     ret = 0;
  out:
     cpu_sync_bndcs_hflags(&cpu->env);
diff --git a/target/i386/machine.c b/target/i386/machine.c
index 233e46bb70..59b1c9be2b 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -1359,6 +1359,24 @@ static const VMStateDescription vmstate_msr_tsx_ctrl = {
     }
 };
 
+
+static bool tsc_ns_timestamp_needed(void *opaque)
+{
+    return kvm_has_precise_tsc();
+}
+
+static const VMStateDescription vmstate_tsc_ns_timestamp = {
+    .name = "cpu/tsc_ns_timestamp",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = tsc_ns_timestamp_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT64(env.tsc_ns_timestamp, X86CPU),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
+
 VMStateDescription vmstate_x86_cpu = {
     .name = "cpu",
     .version_id = 12,
@@ -1493,6 +1511,7 @@ VMStateDescription vmstate_x86_cpu = {
 #endif
 #ifdef CONFIG_KVM
         &vmstate_nested_state,
+        &vmstate_tsc_ns_timestamp,
 #endif
         &vmstate_msr_tsx_ctrl,
         NULL
-- 
2.26.2

