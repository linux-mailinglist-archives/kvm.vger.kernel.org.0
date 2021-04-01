Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF53035196F
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235951AbhDARxf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:53:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54843 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236708AbhDARrJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:47:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xgaCLmzhVP8BWkI8VaMq4SbWTSTLRgyQeKwSSE2Q0Jw=;
        b=FqmuWT/nrIdQhSWhecJlUVVehMn9Z+A/B5gFwXITuhPGmM8EzVzNx2JhDiOs3aUn1icfCq
        0hxpeX3RmWjOG18puoLFQ4K2Up1JiOz7bTJKMjhyFb3ZsRg9z88pxaXTRCI8J1fSTgBroe
        xWewW/cPERWfQ6uWgEiR4XomPrCv1+A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-tq8aRKXoPX24TlKSLyD0VA-1; Thu, 01 Apr 2021 10:46:16 -0400
X-MC-Unique: tq8aRKXoPX24TlKSLyD0VA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 942F910055C3;
        Thu,  1 Apr 2021 14:45:54 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F9595C649;
        Thu,  1 Apr 2021 14:45:52 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 2/2] KVM: use KVM_{GET|SET}_SREGS2 when supported by kvm.
Date:   Thu,  1 Apr 2021 17:45:45 +0300
Message-Id: <20210401144545.1031704-3-mlevitsk@redhat.com>
In-Reply-To: <20210401144545.1031704-1-mlevitsk@redhat.com>
References: <20210401144545.1031704-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows qemu to make PDPTRs be part of the migration
stream and thus not reload them after a migration which
is against X86 spec.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 accel/kvm/kvm-all.c   |   4 ++
 include/sysemu/kvm.h  |   4 ++
 target/i386/cpu.h     |   1 +
 target/i386/kvm/kvm.c | 101 +++++++++++++++++++++++++++++++++++++++++-
 target/i386/machine.c |  33 ++++++++++++++
 5 files changed, 141 insertions(+), 2 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index b6d9f92f15..082b791b01 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -142,6 +142,7 @@ bool kvm_msi_via_irqfd_allowed;
 bool kvm_gsi_routing_allowed;
 bool kvm_gsi_direct_mapping;
 bool kvm_allowed;
+bool kvm_sregs2;
 bool kvm_readonly_mem_allowed;
 bool kvm_vm_attributes_allowed;
 bool kvm_direct_msi_allowed;
@@ -2186,6 +2187,9 @@ static int kvm_init(MachineState *ms)
     kvm_ioeventfd_any_length_allowed =
         (kvm_check_extension(s, KVM_CAP_IOEVENTFD_ANY_LENGTH) > 0);
 
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
index 570f916878..4595d47409 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1422,6 +1422,7 @@ typedef struct CPUX86State {
     SegmentCache idt; /* only base and limit are used */
 
     target_ulong cr[5]; /* NOTE: cr1 is unused */
+    uint64_t pdptrs[4];
     int32_t a20_mask;
 
     BNDReg bnd_regs[4];
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 7fe9f52710..71769f82ae 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2514,6 +2514,59 @@ static int kvm_put_sregs(X86CPU *cpu)
     return kvm_vcpu_ioctl(CPU(cpu), KVM_SET_SREGS, &sregs);
 }
 
+static int kvm_put_sregs2(X86CPU *cpu)
+{
+    CPUX86State *env = &cpu->env;
+    struct kvm_sregs2 sregs;
+    int i;
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
+    for (i = 0; i < 4; i++) {
+        sregs.pdptrs[i] = env->pdptrs[i];
+    }
+
+    sregs.flags = 0;
+    sregs.padding = 0;
+
+    return kvm_vcpu_ioctl(CPU(cpu), KVM_SET_SREGS2, &sregs);
+}
+
+
 static void kvm_msr_buf_reset(X86CPU *cpu)
 {
     memset(cpu->kvm_msr_buf, 0, MSR_BUF_SIZE);
@@ -3175,6 +3228,49 @@ static int kvm_get_sregs(X86CPU *cpu)
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
+    for (i = 0; i < 4; i++) {
+        env->pdptrs[i] = sregs.pdptrs[i];
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
@@ -4000,7 +4096,8 @@ int kvm_arch_put_registers(CPUState *cpu, int level)
     assert(cpu_is_stopped(cpu) || qemu_cpu_is_self(cpu));
 
     /* must be before kvm_put_nested_state so that EFER.SVME is set */
-    ret = kvm_put_sregs(x86_cpu);
+    ret = kvm_supports_sregs2() ? kvm_put_sregs2(x86_cpu) :
+                                  kvm_put_sregs(x86_cpu);
     if (ret < 0) {
         return ret;
     }
@@ -4105,7 +4202,7 @@ int kvm_arch_get_registers(CPUState *cs)
     if (ret < 0) {
         goto out;
     }
-    ret = kvm_get_sregs(cpu);
+    ret = kvm_supports_sregs2() ? kvm_get_sregs2(cpu) : kvm_get_sregs(cpu);
     if (ret < 0) {
         goto out;
     }
diff --git a/target/i386/machine.c b/target/i386/machine.c
index 137604ddb8..c145a1cfb7 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -1396,6 +1396,38 @@ static const VMStateDescription vmstate_msr_tsx_ctrl = {
     }
 };
 
+static bool pdptrs_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+    CPUX86State *env = &cpu->env;
+
+    if (!kvm_supports_sregs2()) {
+        return false;
+    }
+
+    if (!(env->cr[0] & CR0_PG_MASK)) {
+        return false;
+    }
+
+    if (env->efer & MSR_EFER_LMA) {
+        return false;
+    }
+
+    return env->cr[4] & CR4_PAE_MASK;
+}
+
+static const VMStateDescription vmstate_pdptrs = {
+    .name = "cpu/pdptrs",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = pdptrs_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT64_ARRAY(env.pdptrs, X86CPU, 4),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
+
 VMStateDescription vmstate_x86_cpu = {
     .name = "cpu",
     .version_id = 12,
@@ -1531,6 +1563,7 @@ VMStateDescription vmstate_x86_cpu = {
         &vmstate_nested_state,
 #endif
         &vmstate_msr_tsx_ctrl,
+        &vmstate_pdptrs,
         NULL
     }
 };
-- 
2.26.2

