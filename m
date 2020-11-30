Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA55C2C85BF
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 14:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgK3Nkc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 08:40:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51636 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726827AbgK3Nkc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 08:40:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606743544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qVdHxkntzGO9QMXR9mKR8JkaFo2idIgLEfwDs2MnucI=;
        b=bsl565qZcWt9XTheOMNn5p//uwZsQuX3TOJCm0Dj2opPDpfz2cog+YnPLx5QvDbt89XfFz
        ymTdPvYg8KSbxzWX+DN/D0/zeW8coRTVCvKYlzuMj7PUgv7BITLyFUUx2s52vwpW9h5iD8
        +of8ejYXtTjKCBu1eZs5vVS1MqLhEAc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-cXAaBnGcOO-eToQXPV_IMQ-1; Mon, 30 Nov 2020 08:39:02 -0500
X-MC-Unique: cXAaBnGcOO-eToQXPV_IMQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79A541009476;
        Mon, 30 Nov 2020 13:39:01 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1601760867;
        Mon, 30 Nov 2020 13:38:57 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 2/2] Implement support for precise TSC migration
Date:   Mon, 30 Nov 2020 15:38:45 +0200
Message-Id: <20201130133845.233552-3-mlevitsk@redhat.com>
In-Reply-To: <20201130133845.233552-1-mlevitsk@redhat.com>
References: <20201130133845.233552-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently to enable it, you need to set x-precise-tsc=on
for each vcpu.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 target/i386/cpu.c     |   1 +
 target/i386/cpu.h     |   4 ++
 target/i386/kvm.c     | 141 ++++++++++++++++++++++++++++++++++--------
 target/i386/machine.c |  20 ++++++
 4 files changed, 139 insertions(+), 27 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 5a8c96072e..3c82864930 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7231,6 +7231,7 @@ static Property x86_cpu_properties[] = {
                      false),
     DEFINE_PROP_BOOL("x-intel-pt-auto-level", X86CPU, intel_pt_auto_level,
                      true),
+    DEFINE_PROP_BOOL("x-precise-tsc", X86CPU, precise_tsc, false),
     DEFINE_PROP_END_OF_LIST()
 };
 
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 88e8586f8f..fd355057b8 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1460,6 +1460,7 @@ typedef struct CPUX86State {
     uint64_t tsc_adjust;
     uint64_t tsc_deadline;
     uint64_t tsc_aux;
+    uint64_t tsc_ns_timestamp;
 
     uint64_t xcr0;
 
@@ -1743,6 +1744,9 @@ struct X86CPU {
     /* Number of physical address bits supported */
     uint32_t phys_bits;
 
+    /* Use KVM_GET_TSC_PRECISE/KVM_SET_TSC_PRECISE to access IA32_TSC */
+    bool precise_tsc;
+
     /* in order to simplify APIC support, we leave this pointer to the
        user */
     struct DeviceState *apic_state;
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index a2934dda02..f0488aa6cc 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -121,6 +121,7 @@ static int has_xsave;
 static int has_xcrs;
 static int has_pit_state2;
 static int has_exception_payload;
+static int has_precise_tsc;
 
 static bool has_msr_mcg_ext_ctl;
 
@@ -196,31 +197,109 @@ static int kvm_get_tsc(CPUState *cs)
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
+    if (cpu->precise_tsc) {
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
+        if (tsc_state.flags & KVM_TSC_STATE_TSC_ADJUST_VALID) {
+            env->tsc_adjust = tsc_state.tsc_adjust;
+        }
+        env->tsc_ns_timestamp = tsc_state.nsec;
+
+    } else {
+        struct {
+            struct kvm_msrs info;
+            struct kvm_msr_entry entries[2];
+        } msr_data = {};
+
+        memset(&msr_data, 0, sizeof(msr_data));
+        msr_data.info.nmsrs = 1;
+        msr_data.entries[0].index = MSR_IA32_TSC;
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
+
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
+    if (cpu->precise_tsc) {
+        struct kvm_tsc_state tsc_state;
+
+        memset(&tsc_state, 0, sizeof(tsc_state));
+
+        tsc_state.tsc = env->tsc;
+        tsc_state.nsec = env->tsc_ns_timestamp;
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
+        } msr_data = {};
+
+        memset(&msr_data, 0, sizeof(msr_data));
+        msr_data.info.nmsrs = 1;
+        msr_data.entries[0].index = MSR_IA32_TSC;
+        msr_data.entries[0].data = env->tsc;
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
@@ -1780,6 +1859,13 @@ int kvm_arch_init_vcpu(CPUState *cs)
         }
     }
 
+    if (cpu->precise_tsc) {
+        if (!kvm_check_extension(cs->kvm_state, KVM_CAP_PRECISE_TSC)) {
+            error_report("kvm: Precise TSC is not supported by the host's KVM");
+            return -ENOTSUP;
+        }
+    }
+
     if (cpu->vmware_cpuid_freq
         /* Guests depend on 0x40000000 to detect this feature, so only expose
          * it if KVM exposes leaf 0x40000000. (Conflicts with Hyper-V) */
@@ -2196,6 +2282,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         int disable_exits = kvm_check_extension(s, KVM_CAP_X86_DISABLE_EXITS);
         int ret;
 
+
+
 /* Work around for kernel header with a typo. TODO: fix header and drop. */
 #if defined(KVM_X86_DISABLE_EXITS_HTL) && !defined(KVM_X86_DISABLE_EXITS_HLT)
 #define KVM_X86_DISABLE_EXITS_HLT KVM_X86_DISABLE_EXITS_HTL
@@ -2215,6 +2303,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
+    has_precise_tsc = kvm_check_extension(s, KVM_CAP_PRECISE_TSC);
+
     return 0;
 }
 
@@ -2756,9 +2846,6 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
     if (has_msr_tsc_aux) {
         kvm_msr_entry_add(cpu, MSR_TSC_AUX, env->tsc_aux);
     }
-    if (has_msr_tsc_adjust) {
-        kvm_msr_entry_add(cpu, MSR_TSC_ADJUST, env->tsc_adjust);
-    }
     if (has_msr_misc_enable) {
         kvm_msr_entry_add(cpu, MSR_IA32_MISC_ENABLE,
                           env->msr_ia32_misc_enable);
@@ -2802,7 +2889,6 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
      * for normal writeback. Limit them to reset or full state updates.
      */
     if (level >= KVM_PUT_RESET_STATE) {
-        kvm_msr_entry_add(cpu, MSR_IA32_TSC, env->tsc);
         kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME, env->system_time_msr);
         kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK, env->wall_clock_msr);
         if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_ASYNC_PF_INT)) {
@@ -3142,9 +3228,6 @@ static int kvm_get_msrs(X86CPU *cpu)
     if (has_msr_tsc_aux) {
         kvm_msr_entry_add(cpu, MSR_TSC_AUX, 0);
     }
-    if (has_msr_tsc_adjust) {
-        kvm_msr_entry_add(cpu, MSR_TSC_ADJUST, 0);
-    }
     if (has_msr_tsc_deadline) {
         kvm_msr_entry_add(cpu, MSR_IA32_TSCDEADLINE, 0);
     }
@@ -3178,10 +3261,6 @@ static int kvm_get_msrs(X86CPU *cpu)
     if (has_msr_virt_ssbd) {
         kvm_msr_entry_add(cpu, MSR_VIRT_SSBD, 0);
     }
-    if (!env->tsc_valid) {
-        kvm_msr_entry_add(cpu, MSR_IA32_TSC, 0);
-        env->tsc_valid = !runstate_is_running();
-    }
 
 #ifdef TARGET_X86_64
     if (lm_capable_kernel) {
@@ -3385,9 +3464,6 @@ static int kvm_get_msrs(X86CPU *cpu)
         case MSR_TSC_AUX:
             env->tsc_aux = msrs[i].data;
             break;
-        case MSR_TSC_ADJUST:
-            env->tsc_adjust = msrs[i].data;
-            break;
         case MSR_IA32_TSCDEADLINE:
             env->tsc_deadline = msrs[i].data;
             break;
@@ -3995,6 +4071,11 @@ int kvm_arch_put_registers(CPUState *cpu, int level)
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
@@ -4064,6 +4145,12 @@ int kvm_arch_get_registers(CPUState *cs)
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
index 233e46bb70..4f4296a3e4 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -1359,6 +1359,25 @@ static const VMStateDescription vmstate_msr_tsx_ctrl = {
     }
 };
 
+
+static bool tsc_info_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+    return cpu->precise_tsc;
+}
+
+static const VMStateDescription vmstate_tsc_info = {
+    .name = "cpu/tsc_nsec_info",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = tsc_info_needed,
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
@@ -1493,6 +1512,7 @@ VMStateDescription vmstate_x86_cpu = {
 #endif
 #ifdef CONFIG_KVM
         &vmstate_nested_state,
+        &vmstate_tsc_info,
 #endif
         &vmstate_msr_tsx_ctrl,
         NULL
-- 
2.26.2

