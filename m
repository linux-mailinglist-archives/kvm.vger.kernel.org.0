Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17EF71DBB24
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 19:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbgETRV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 13:21:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22003 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726566AbgETRV6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 13:21:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589995316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=GrU586De/Nyh6CPscmLHHw6/pFNd1WB/w3lruPEutEo=;
        b=L1H4mMz0IRtq42kZDT5jiff5uhDnXHNyIZUgevlxFAzFlV95/SbUzaeA0allIlpdtl4yXc
        /3+XxJ9WcSLHpkkw9s3d3EHym70GcS/Ergq9Fs/zWXkilqm33LzeqckZiGTLzfCfD/aw1v
        K+N1LTfAnIPBdH/JhdgI/rn/ES2Ir5Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-zJQ68WUoPrqXKaPLFHEXyQ-1; Wed, 20 May 2020 13:21:54 -0400
X-MC-Unique: zJQ68WUoPrqXKaPLFHEXyQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 060261009795;
        Wed, 20 May 2020 17:21:47 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 33D568E602;
        Wed, 20 May 2020 17:21:46 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 00/24] KVM: nSVM: event fixes and migration support
Date:   Wed, 20 May 2020 13:21:21 -0400
Message-Id: <20200520172145.23284-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Large parts of this series were posted before (patches 1, 3-4-5 and
6-7-8-12-13-14).  This is basically what I'd like to get into 5.8 as
far as nested SVM is concerned; the fix for exception vmexits is related
to migration support, because it gets rid of the exit_required flag
and therefore consolidates the SVM migration format.

There are a couple more bugfixes (2 and 21), the latter of which actually
affects VMX as well.

The SVM migration data consists of:

- the GIF state

- the guest mode and nested-run-pending flags

- the host state from before VMRUN

- the nested VMCB control state

The last two items are conveniently packaged in VMCB format.  Compared
to the previous prototype, HF_HIF_MASK is removed since it is part of
"the host state from before VMRUN".

The patch has been tested with the QEMU changes after my signature,
where it also fixes system_reset while x86/svm.flat runs.

Paolo

Paolo Bonzini (24):
  KVM: nSVM: fix condition for filtering async PF
  KVM: nSVM: leave ASID aside in copy_vmcb_control_area
  KVM: nSVM: inject exceptions via svm_check_nested_events
  KVM: nSVM: remove exit_required
  KVM: nSVM: correctly inject INIT vmexits
  KVM: nSVM: move map argument out of enter_svm_guest_mode
  KVM: nSVM: extract load_nested_vmcb_control
  KVM: nSVM: extract preparation of VMCB for nested run
  KVM: nSVM: clean up tsc_offset update
  KVM: nSVM: pass vmcb_control_area to copy_vmcb_control_area
  KVM: nSVM: remove trailing padding for struct vmcb_control_area
  KVM: nSVM: save all control fields in svm->nested
  KVM: nSVM: do not reload pause filter fields from VMCB
  KVM: nSVM: remove HF_VINTR_MASK
  KVM: nSVM: remove HF_HIF_MASK
  KVM: nSVM: split nested_vmcb_check_controls
  KVM: nSVM: do all MMU switch work in init/uninit functions
  KVM: nSVM: leave guest mode when clearing EFER.SVME
  KVM: nSVM: extract svm_set_gif
  KVM: MMU: pass arbitrary CR0/CR4/EFER to kvm_init_shadow_mmu
  KVM: x86: always update CR3 in VMCB
  uaccess: add memzero_user
  selftests: kvm: add a SVM version of state-test
  KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE

 arch/x86/include/asm/kvm_host.h               |   2 -
 arch/x86/include/asm/svm.h                    |   9 +-
 arch/x86/include/uapi/asm/kvm.h               |  17 +-
 arch/x86/kvm/cpuid.h                          |   5 +
 arch/x86/kvm/irq.c                            |   1 +
 arch/x86/kvm/mmu.h                            |   2 +-
 arch/x86/kvm/mmu/mmu.c                        |  14 +-
 arch/x86/kvm/svm/nested.c                     | 525 +++++++++++-------
 arch/x86/kvm/svm/svm.c                        | 107 ++--
 arch/x86/kvm/svm/svm.h                        |  32 +-
 arch/x86/kvm/vmx/nested.c                     |   5 -
 arch/x86/kvm/vmx/vmx.c                        |   5 +-
 arch/x86/kvm/x86.c                            |   3 +-
 include/linux/uaccess.h                       |   1 +
 lib/usercopy.c                                |  63 +++
 .../testing/selftests/kvm/x86_64/state_test.c |  65 ++-
 16 files changed, 549 insertions(+), 307 deletions(-)

-- 
2.18.2


diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
index 3f3f780c8c..c4a8c10e2d 100644
--- a/linux-headers/asm-x86/kvm.h
+++ b/linux-headers/asm-x86/kvm.h
@@ -385,18 +385,22 @@ struct kvm_sync_regs {
 #define KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT (1 << 4)
 
 #define KVM_STATE_NESTED_FORMAT_VMX	0
-#define KVM_STATE_NESTED_FORMAT_SVM	1	/* unused */
+#define KVM_STATE_NESTED_FORMAT_SVM	1
 
 #define KVM_STATE_NESTED_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
 #define KVM_STATE_NESTED_EVMCS		0x00000004
 #define KVM_STATE_NESTED_MTF_PENDING	0x00000008
+#define KVM_STATE_NESTED_GIF_SET	0x00000100
 
 #define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_SMM_VMXON	0x00000002
 
 #define KVM_STATE_NESTED_VMX_VMCS_SIZE	0x1000
 
+#define KVM_STATE_NESTED_SVM_VMCB_SIZE	0x1000
+
+
 struct kvm_vmx_nested_state_data {
 	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
 	__u8 shadow_vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
@@ -411,6 +415,15 @@ struct kvm_vmx_nested_state_hdr {
 	} smm;
 };
 
+struct kvm_svm_nested_state_data {
+	/* Save area only used if KVM_STATE_NESTED_RUN_PENDING.  */
+	__u8 vmcb12[KVM_STATE_NESTED_SVM_VMCB_SIZE];
+};
+
+struct kvm_svm_nested_state_hdr {
+	__u64 vmcb_pa;
+};
+
 /* for KVM_CAP_NESTED_STATE */
 struct kvm_nested_state {
 	__u16 flags;
@@ -419,6 +432,7 @@ struct kvm_nested_state {
 
 	union {
 		struct kvm_vmx_nested_state_hdr vmx;
+		struct kvm_svm_nested_state_hdr svm;
 
 		/* Pad the header to 128 bytes.  */
 		__u8 pad[120];
@@ -431,6 +445,7 @@ struct kvm_nested_state {
 	 */
 	union {
 		struct kvm_vmx_nested_state_data vmx[0];
+		struct kvm_svm_nested_state_data svm[0];
 	} data;
 };
 
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 9804495a46..f4ff71da0b 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -1017,6 +1017,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_VCPU_RESETS 179
 #define KVM_CAP_S390_PROTECTED 180
 #define KVM_CAP_PPC_SECURE_GUEST 181
+#define KVM_CAP_HALT_POLL 182
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index e818fc712a..9627f88ebf 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2103,6 +2103,11 @@ static inline bool cpu_has_vmx(CPUX86State *env)
     return env->features[FEAT_1_ECX] & CPUID_EXT_VMX;
 }
 
+static inline bool cpu_has_svm(CPUX86State *env)
+{
+    return env->features[FEAT_8000_0001_ECX] & CPUID_EXT3_SVM;
+}
+
 /*
  * In order for a vCPU to enter VMX operation it must have CR4.VMXE set.
  * Since it was set, CR4.VMXE must remain set as long as vCPU is in
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 9c256ab159..6833400191 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5939,6 +5939,7 @@ static void x86_cpu_reset(DeviceState *dev)
     /* init to reset state */
 
     env->hflags2 |= HF2_GIF_MASK;
+    env->hflags &= ~HF_GUEST_MASK;
 
     cpu_x86_update_cr0(env, 0x60000010);
     env->a20_mask = ~0x0;
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 4901c6dd74..599a34b49d 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -1834,16 +1834,18 @@ int kvm_arch_init_vcpu(CPUState *cs)
     if (max_nested_state_len > 0) {
         assert(max_nested_state_len >= offsetof(struct kvm_nested_state, data));
 
-        if (cpu_has_vmx(env)) {
+        if (cpu_has_vmx(env) || cpu_has_svm(env)) {
             struct kvm_vmx_nested_state_hdr *vmx_hdr;
 
             env->nested_state = g_malloc0(max_nested_state_len);
             env->nested_state->size = max_nested_state_len;
             env->nested_state->format = KVM_STATE_NESTED_FORMAT_VMX;
 
-            vmx_hdr = &env->nested_state->hdr.vmx;
-            vmx_hdr->vmxon_pa = -1ull;
-            vmx_hdr->vmcs12_pa = -1ull;
+            if (cpu_has_vmx(env)) {
+                    vmx_hdr = &env->nested_state->hdr.vmx;
+                    vmx_hdr->vmxon_pa = -1ull;
+                    vmx_hdr->vmcs12_pa = -1ull;
+            }
         }
     }
 
@@ -3847,6 +3849,20 @@ static int kvm_put_nested_state(X86CPU *cpu)
         return 0;
     }
 
+    /*
+     * Copy flags that are affected by reset from env->hflags and env->hflags2.
+     */
+    if (env->hflags & HF_GUEST_MASK) {
+        env->nested_state->flags |= KVM_STATE_NESTED_GUEST_MODE;
+    } else {
+        env->nested_state->flags &= ~KVM_STATE_NESTED_GUEST_MODE;
+    }
+    if (env->hflags2 & HF2_GIF_MASK) {
+        env->nested_state->flags |= KVM_STATE_NESTED_GIF_SET;
+    } else {
+        env->nested_state->flags &= ~KVM_STATE_NESTED_GIF_SET;
+    }
+
     assert(env->nested_state->size <= max_nested_state_len);
     return kvm_vcpu_ioctl(CPU(cpu), KVM_SET_NESTED_STATE, env->nested_state);
 }
@@ -3875,11 +3891,19 @@ static int kvm_get_nested_state(X86CPU *cpu)
         return ret;
     }
 
+    /*
+     * Copy flags that are affected by reset to env->hflags and env->hflags2.
+     */
     if (env->nested_state->flags & KVM_STATE_NESTED_GUEST_MODE) {
         env->hflags |= HF_GUEST_MASK;
     } else {
         env->hflags &= ~HF_GUEST_MASK;
     }
+    if (env->nested_state->flags & KVM_STATE_NESTED_GIF_SET) {
+        env->hflags2 |= HF2_GIF_MASK;
+    } else {
+        env->hflags2 &= ~HF2_GIF_MASK;
+    }
 
     return ret;
 }
@@ -3891,6 +3915,12 @@ int kvm_arch_put_registers(CPUState *cpu, int level)
 
     assert(cpu_is_stopped(cpu) || qemu_cpu_is_self(cpu));
 
+    /* must be before kvm_put_nested_state so that EFER.SVME is set */
+    ret = kvm_put_sregs(x86_cpu);
+    if (ret < 0) {
+        return ret;
+    }
+
     if (level >= KVM_PUT_RESET_STATE) {
         ret = kvm_put_nested_state(x86_cpu);
         if (ret < 0) {
@@ -3924,10 +3954,6 @@ int kvm_arch_put_registers(CPUState *cpu, int level)
     if (ret < 0) {
         return ret;
     }
-    ret = kvm_put_sregs(x86_cpu);
-    if (ret < 0) {
-        return ret;
-    }
     /* must be before kvm_put_msrs */
     ret = kvm_inject_mce_oldstyle(x86_cpu);
     if (ret < 0) {
diff --git a/target/i386/machine.c b/target/i386/machine.c
index 0c96531a56..8684a247c1 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -1071,13 +1071,40 @@ static const VMStateDescription vmstate_vmx_nested_state = {
     }
 };
 
+static bool svm_nested_state_needed(void *opaque)
+{
+    struct kvm_nested_state *nested_state = opaque;
+
+    /*
+     * HF2_GIF_MASK is relevant for non-guest mode but it is already
+     * serialized via hflags2.
+     */
+    return (nested_state->format == KVM_STATE_NESTED_FORMAT_SVM &&
+            nested_state->size > offsetof(struct kvm_nested_state, data));
+}
+
+static const VMStateDescription vmstate_svm_nested_state = {
+    .name = "cpu/kvm_nested_state/svm",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = svm_nested_state_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_U64(hdr.svm.vmcb_pa, struct kvm_nested_state),
+        VMSTATE_UINT8_ARRAY(data.svm[0].vmcb12,
+                            struct kvm_nested_state,
+                            KVM_STATE_NESTED_SVM_VMCB_SIZE),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
 static bool nested_state_needed(void *opaque)
 {
     X86CPU *cpu = opaque;
     CPUX86State *env = &cpu->env;
 
     return (env->nested_state &&
-            vmx_nested_state_needed(env->nested_state));
+            (vmx_nested_state_needed(env->nested_state) ||
+             svm_nested_state_needed(env->nested_state)));
 }
 
 static int nested_state_post_load(void *opaque, int version_id)
@@ -1139,6 +1166,7 @@ static const VMStateDescription vmstate_kvm_nested_state = {
     },
     .subsections = (const VMStateDescription*[]) {
         &vmstate_vmx_nested_state,
+        &vmstate_svm_nested_state,
         NULL
     }
 };



