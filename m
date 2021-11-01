Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 022A0441BAB
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 14:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbhKAN0B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 09:26:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24198 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230417AbhKAN0A (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 09:26:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635773006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dm5k87LcK20EHhCJwrlp6p8Az0UItlpDWTMxYvYH+2E=;
        b=Pb9dL8Lnk4I44hR+9btWh/DTPsYhNY8ZmVp6/P97pnOpeWPzoKztHSgzmfFYkvrSXbmd5V
        LLGI1b4K2SLTOOwUBRs9lsrve/NGRcZHAh2D4Hw0TbcW/VGKmtJ9lGfkDAywqcXRBwwuDc
        WIronD9tF5wU8LQmBwJO3dcpQanDdlQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-0WrdraFcPIiA9T9aMTzVTw-1; Mon, 01 Nov 2021 09:23:25 -0400
X-MC-Unique: 0WrdraFcPIiA9T9aMTzVTw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32F5EDF8AB;
        Mon,  1 Nov 2021 13:23:24 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 614AB60FB8;
        Mon,  1 Nov 2021 13:23:15 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 1/3] KVM: use KVM_{GET|SET}_SREGS2 when supported.
Date:   Mon,  1 Nov 2021 15:22:58 +0200
Message-Id: <20211101132300.192584-2-mlevitsk@redhat.com>
In-Reply-To: <20211101132300.192584-1-mlevitsk@redhat.com>
References: <20211101132300.192584-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows to make PDPTRs part of the migration
stream and thus not reload them after migration which
is against X86 spec.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 accel/kvm/kvm-all.c   |   5 ++
 include/sysemu/kvm.h  |   4 ++
 target/i386/cpu.h     |   3 ++
 target/i386/kvm/kvm.c | 107 +++++++++++++++++++++++++++++++++++++++++-
 target/i386/machine.c |  29 ++++++++++++
 5 files changed, 146 insertions(+), 2 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index db8d83b137..5558786d3d 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -163,6 +163,7 @@ bool kvm_msi_via_irqfd_allowed;
 bool kvm_gsi_routing_allowed;
 bool kvm_gsi_direct_mapping;
 bool kvm_allowed;
+bool kvm_sregs2;
 bool kvm_readonly_mem_allowed;
 bool kvm_vm_attributes_allowed;
 bool kvm_direct_msi_allowed;
@@ -2557,6 +2558,10 @@ static int kvm_init(MachineState *ms)
     kvm_ioeventfd_any_length_allowed =
         (kvm_check_extension(s, KVM_CAP_IOEVENTFD_ANY_LENGTH) > 0);
 
+
+    kvm_sregs2 =
+        (kvm_check_extension(s, KVM_CAP_SREGS2) > 0);
+
     kvm_state = s;
 
     ret = kvm_arch_init(ms, s);
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index a1ab1ee12d..b3d4538c55 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -32,6 +32,7 @@
 #ifdef CONFIG_KVM_IS_POSSIBLE
 
 extern bool kvm_allowed;
+extern bool kvm_sregs2;
 extern bool kvm_kernel_irqchip;
 extern bool kvm_split_irqchip;
 extern bool kvm_async_interrupts_allowed;
@@ -139,6 +140,9 @@ extern bool kvm_msi_use_devid;
  */
 #define kvm_gsi_direct_mapping() (kvm_gsi_direct_mapping)
 
+
+#define kvm_supports_sregs2() (kvm_sregs2)
+
 /**
  * kvm_readonly_mem_enabled:
  *
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 3edaad7688..8c39e787f9 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1452,6 +1452,9 @@ typedef struct CPUX86State {
     SegmentCache idt; /* only base and limit are used */
 
     target_ulong cr[5]; /* NOTE: cr1 is unused */
+
+    bool pdptrs_valid;
+    uint64_t pdptrs[4];
     int32_t a20_mask;
 
     BNDReg bnd_regs[4];
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 0eb7a0340c..13be6995a8 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2646,6 +2646,61 @@ static int kvm_put_sregs(X86CPU *cpu)
     return kvm_vcpu_ioctl(CPU(cpu), KVM_SET_SREGS, &sregs);
 }
 
+static int kvm_put_sregs2(X86CPU *cpu)
+{
+    CPUX86State *env = &cpu->env;
+    struct kvm_sregs2 sregs;
+    int i;
+
+    sregs.flags = 0;
+
+    if ((env->eflags & VM_MASK)) {
+        set_v8086_seg(&sregs.cs, &env->segs[R_CS]);
+        set_v8086_seg(&sregs.ds, &env->segs[R_DS]);
+        set_v8086_seg(&sregs.es, &env->segs[R_ES]);
+        set_v8086_seg(&sregs.fs, &env->segs[R_FS]);
+        set_v8086_seg(&sregs.gs, &env->segs[R_GS]);
+        set_v8086_seg(&sregs.ss, &env->segs[R_SS]);
+    } else {
+        set_seg(&sregs.cs, &env->segs[R_CS]);
+        set_seg(&sregs.ds, &env->segs[R_DS]);
+        set_seg(&sregs.es, &env->segs[R_ES]);
+        set_seg(&sregs.fs, &env->segs[R_FS]);
+        set_seg(&sregs.gs, &env->segs[R_GS]);
+        set_seg(&sregs.ss, &env->segs[R_SS]);
+    }
+
+    set_seg(&sregs.tr, &env->tr);
+    set_seg(&sregs.ldt, &env->ldt);
+
+    sregs.idt.limit = env->idt.limit;
+    sregs.idt.base = env->idt.base;
+    memset(sregs.idt.padding, 0, sizeof sregs.idt.padding);
+    sregs.gdt.limit = env->gdt.limit;
+    sregs.gdt.base = env->gdt.base;
+    memset(sregs.gdt.padding, 0, sizeof sregs.gdt.padding);
+
+    sregs.cr0 = env->cr[0];
+    sregs.cr2 = env->cr[2];
+    sregs.cr3 = env->cr[3];
+    sregs.cr4 = env->cr[4];
+
+    sregs.cr8 = cpu_get_apic_tpr(cpu->apic_state);
+    sregs.apic_base = cpu_get_apic_base(cpu->apic_state);
+
+    sregs.efer = env->efer;
+
+    if (env->pdptrs_valid) {
+        for (i = 0; i < 4; i++) {
+            sregs.pdptrs[i] = env->pdptrs[i];
+        }
+        sregs.flags |= KVM_SREGS2_FLAGS_PDPTRS_VALID;
+    }
+
+    return kvm_vcpu_ioctl(CPU(cpu), KVM_SET_SREGS2, &sregs);
+}
+
+
 static void kvm_msr_buf_reset(X86CPU *cpu)
 {
     memset(cpu->kvm_msr_buf, 0, MSR_BUF_SIZE);
@@ -3322,6 +3377,53 @@ static int kvm_get_sregs(X86CPU *cpu)
     return 0;
 }
 
+static int kvm_get_sregs2(X86CPU *cpu)
+{
+    CPUX86State *env = &cpu->env;
+    struct kvm_sregs2 sregs;
+    int i, ret;
+
+    ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_SREGS2, &sregs);
+    if (ret < 0) {
+        return ret;
+    }
+
+    get_seg(&env->segs[R_CS], &sregs.cs);
+    get_seg(&env->segs[R_DS], &sregs.ds);
+    get_seg(&env->segs[R_ES], &sregs.es);
+    get_seg(&env->segs[R_FS], &sregs.fs);
+    get_seg(&env->segs[R_GS], &sregs.gs);
+    get_seg(&env->segs[R_SS], &sregs.ss);
+
+    get_seg(&env->tr, &sregs.tr);
+    get_seg(&env->ldt, &sregs.ldt);
+
+    env->idt.limit = sregs.idt.limit;
+    env->idt.base = sregs.idt.base;
+    env->gdt.limit = sregs.gdt.limit;
+    env->gdt.base = sregs.gdt.base;
+
+    env->cr[0] = sregs.cr0;
+    env->cr[2] = sregs.cr2;
+    env->cr[3] = sregs.cr3;
+    env->cr[4] = sregs.cr4;
+
+    env->efer = sregs.efer;
+
+    env->pdptrs_valid = sregs.flags & KVM_SREGS2_FLAGS_PDPTRS_VALID;
+
+    if (env->pdptrs_valid) {
+        for (i = 0; i < 4; i++) {
+            env->pdptrs[i] = sregs.pdptrs[i];
+        }
+    }
+
+    /* changes to apic base and cr8/tpr are read back via kvm_arch_post_run */
+    x86_update_hflags(env);
+
+    return 0;
+}
+
 static int kvm_get_msrs(X86CPU *cpu)
 {
     CPUX86State *env = &cpu->env;
@@ -4158,7 +4260,8 @@ int kvm_arch_put_registers(CPUState *cpu, int level)
     assert(cpu_is_stopped(cpu) || qemu_cpu_is_self(cpu));
 
     /* must be before kvm_put_nested_state so that EFER.SVME is set */
-    ret = kvm_put_sregs(x86_cpu);
+    ret = kvm_supports_sregs2() ? kvm_put_sregs2(x86_cpu) :
+                                  kvm_put_sregs(x86_cpu);
     if (ret < 0) {
         return ret;
     }
@@ -4263,7 +4366,7 @@ int kvm_arch_get_registers(CPUState *cs)
     if (ret < 0) {
         goto out;
     }
-    ret = kvm_get_sregs(cpu);
+    ret = kvm_supports_sregs2() ? kvm_get_sregs2(cpu) : kvm_get_sregs(cpu);
     if (ret < 0) {
         goto out;
     }
diff --git a/target/i386/machine.c b/target/i386/machine.c
index 4367931623..14dd5ed79c 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -1430,6 +1430,34 @@ static const VMStateDescription vmstate_msr_intel_sgx = {
     .needed = intel_sgx_msrs_needed,
     .fields = (VMStateField[]) {
         VMSTATE_UINT64_ARRAY(env.msr_ia32_sgxlepubkeyhash, X86CPU, 4),
+                VMSTATE_END_OF_LIST()
+            }
+        };
+
+static bool pdptrs_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+    CPUX86State *env = &cpu->env;
+    return env->pdptrs_valid;
+}
+
+static int pdptrs_post_load(void *opaque, int version_id)
+{
+    X86CPU *cpu = opaque;
+    CPUX86State *env = &cpu->env;
+    env->pdptrs_valid = true;
+    return 0;
+}
+
+
+static const VMStateDescription vmstate_pdptrs = {
+    .name = "cpu/pdptrs",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = pdptrs_needed,
+    .post_load = pdptrs_post_load,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT64_ARRAY(env.pdptrs, X86CPU, 4),
         VMSTATE_END_OF_LIST()
     }
 };
@@ -1571,6 +1599,7 @@ const VMStateDescription vmstate_x86_cpu = {
 #endif
         &vmstate_msr_tsx_ctrl,
         &vmstate_msr_intel_sgx,
+        &vmstate_pdptrs,
         NULL
     }
 };
-- 
2.26.3

