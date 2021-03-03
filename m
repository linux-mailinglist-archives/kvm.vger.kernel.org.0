Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5494832C72B
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358769AbhCDAbI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:31:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44348 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1386549AbhCCS3d (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 13:29:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614796084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ghbrUZ4fIl9iFqhQfoGEU/zQLVSUujkFo/gkjqoyoig=;
        b=PzDXHV8EJ3o1uXuio++Xtu6CAWyxRCSR+gTNqp/KBog2WbpjXCD9MYsq3MOlP7/ds5VLiZ
        Rh52R4yj6P1sCQumTz4Je6iqa5v8sAZlkirMAnN1Pz6/UgLnM5RBkulMp37lZGsRw8df/b
        mm88Sk7PIxsoes5SukU2Rw+3IHXmA74=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-0quRWlF4M_O_rvjkg9c9nw-1; Wed, 03 Mar 2021 13:24:33 -0500
X-MC-Unique: 0quRWlF4M_O_rvjkg9c9nw-1
Received: by mail-wm1-f72.google.com with SMTP id f9so3406063wml.0
        for <kvm@vger.kernel.org>; Wed, 03 Mar 2021 10:24:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ghbrUZ4fIl9iFqhQfoGEU/zQLVSUujkFo/gkjqoyoig=;
        b=goOGHO4xlGNpDy8LPFxP75uyiWwsK5MgYDfFQs1TSzgrVM5/IRJvJ0ocWzG/73Ltw7
         tsOMPU+/+AkaK3nOnyR7Oi1wuZyjJT58xuJ/q7+mMFGzOxog2CJi0RHbZM+h9CvFQTIu
         1KpE6ATKqgcBum8KIaOmHf+peU6xVRm68dxCYwtwRa9ByxcCeIOafMoauM0mnEw4RJ/r
         vDsCj0CQFcdA11KQzy/3gPhKpq/8snAOCi8NJWR8G2O1zOL/BrNoKW88HM/BDwGSMmlc
         Tf0rrFmYDwI0N6Xa46iqg+C5mV2thzPa7tn8V8BbUsbx3+XBo0/9Qoe0CljTjwPtIZxf
         jbxA==
X-Gm-Message-State: AOAM531/gGD/TwKykZY7j+tmBHhqg2iKCo/ee1p0JPYS532Vsx+ugkuG
        G9+eqRj31CljFkS170zdFlS5NC/kX6gNvd2gR/kb6IZXJMb0dKVQQ9cqmQnNVeHHY9cphPRZjBR
        C4ZDDQTPmVKVk
X-Received: by 2002:a1c:4e07:: with SMTP id g7mr270829wmh.29.1614795870137;
        Wed, 03 Mar 2021 10:24:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxy5yGsVkSbOtOt430gsXEGatm965cb95l6wAPlETjCXm0O71i55yGVkWF1cWjLgsw0RKx7+g==
X-Received: by 2002:a1c:4e07:: with SMTP id g7mr270785wmh.29.1614795869699;
        Wed, 03 Mar 2021 10:24:29 -0800 (PST)
Received: from x1w.redhat.com (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id p6sm19168637wru.2.2021.03.03.10.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 10:24:29 -0800 (PST)
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
Subject: [RFC PATCH 19/19] accel/hvf: Move the 'hvf_fd' field to AccelvCPUState
Date:   Wed,  3 Mar 2021 19:22:19 +0100
Message-Id: <20210303182219.1631042-20-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210303182219.1631042-1-philmd@redhat.com>
References: <20210303182219.1631042-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the 'hvf_fd' field from CPUState to AccelvCPUState,
and declare it with its correct type: hv_vcpuid_t.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/hw/core/cpu.h       |  1 -
 target/i386/hvf/hvf-i386.h  |  1 +
 target/i386/hvf/vmx.h       | 28 +++++++++--------
 target/i386/hvf/hvf.c       | 23 +++++++-------
 target/i386/hvf/x86.c       | 28 ++++++++---------
 target/i386/hvf/x86_descr.c | 17 +++++-----
 target/i386/hvf/x86_emu.c   | 62 ++++++++++++++++++-------------------
 target/i386/hvf/x86_mmu.c   |  4 +--
 target/i386/hvf/x86_task.c  | 14 +++++----
 target/i386/hvf/x86hvf.c    | 32 ++++++++++---------
 10 files changed, 110 insertions(+), 100 deletions(-)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 3268f1393f1..69a456415c0 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -415,7 +415,6 @@ struct CPUState {
 
     /* Accelerator-specific fields. */
     struct AccelvCPUState *accel_vcpu;
-    int hvf_fd;
     /* shared by kvm, hax and hvf */
     bool vcpu_dirty;
 
diff --git a/target/i386/hvf/hvf-i386.h b/target/i386/hvf/hvf-i386.h
index 1f12eb647a0..e17f9f42c0e 100644
--- a/target/i386/hvf/hvf-i386.h
+++ b/target/i386/hvf/hvf-i386.h
@@ -52,6 +52,7 @@ struct HVFState {
 extern HVFState *hvf_state;
 
 struct AccelvCPUState {
+    hv_vcpuid_t hvf_fd;
 };
 
 void hvf_set_phys_mem(MemoryRegionSection *, bool);
diff --git a/target/i386/hvf/vmx.h b/target/i386/hvf/vmx.h
index 24c4cdf0be0..bed94856268 100644
--- a/target/i386/hvf/vmx.h
+++ b/target/i386/hvf/vmx.h
@@ -179,15 +179,15 @@ static inline void macvm_set_rip(CPUState *cpu, uint64_t rip)
     uint64_t val;
 
     /* BUG, should take considering overlap.. */
-    wreg(cpu->hvf_fd, HV_X86_RIP, rip);
+    wreg(cpu->accel_vcpu->hvf_fd, HV_X86_RIP, rip);
     env->eip = rip;
 
     /* after moving forward in rip, we need to clean INTERRUPTABILITY */
-   val = rvmcs(cpu->hvf_fd, VMCS_GUEST_INTERRUPTIBILITY);
+   val = rvmcs(cpu->accel_vcpu->hvf_fd, VMCS_GUEST_INTERRUPTIBILITY);
    if (val & (VMCS_INTERRUPTIBILITY_STI_BLOCKING |
                VMCS_INTERRUPTIBILITY_MOVSS_BLOCKING)) {
         env->hflags &= ~HF_INHIBIT_IRQ_MASK;
-        wvmcs(cpu->hvf_fd, VMCS_GUEST_INTERRUPTIBILITY,
+        wvmcs(cpu->accel_vcpu->hvf_fd, VMCS_GUEST_INTERRUPTIBILITY,
                val & ~(VMCS_INTERRUPTIBILITY_STI_BLOCKING |
                VMCS_INTERRUPTIBILITY_MOVSS_BLOCKING));
    }
@@ -199,9 +199,10 @@ static inline void vmx_clear_nmi_blocking(CPUState *cpu)
     CPUX86State *env = &x86_cpu->env;
 
     env->hflags2 &= ~HF2_NMI_MASK;
-    uint32_t gi = (uint32_t) rvmcs(cpu->hvf_fd, VMCS_GUEST_INTERRUPTIBILITY);
+    uint32_t gi = (uint32_t) rvmcs(cpu->accel_vcpu->hvf_fd,
+                                   VMCS_GUEST_INTERRUPTIBILITY);
     gi &= ~VMCS_INTERRUPTIBILITY_NMI_BLOCKING;
-    wvmcs(cpu->hvf_fd, VMCS_GUEST_INTERRUPTIBILITY, gi);
+    wvmcs(cpu->accel_vcpu->hvf_fd, VMCS_GUEST_INTERRUPTIBILITY, gi);
 }
 
 static inline void vmx_set_nmi_blocking(CPUState *cpu)
@@ -210,17 +211,18 @@ static inline void vmx_set_nmi_blocking(CPUState *cpu)
     CPUX86State *env = &x86_cpu->env;
 
     env->hflags2 |= HF2_NMI_MASK;
-    uint32_t gi = (uint32_t)rvmcs(cpu->hvf_fd, VMCS_GUEST_INTERRUPTIBILITY);
+    uint32_t gi = (uint32_t)rvmcs(cpu->accel_vcpu->hvf_fd,
+                                  VMCS_GUEST_INTERRUPTIBILITY);
     gi |= VMCS_INTERRUPTIBILITY_NMI_BLOCKING;
-    wvmcs(cpu->hvf_fd, VMCS_GUEST_INTERRUPTIBILITY, gi);
+    wvmcs(cpu->accel_vcpu->hvf_fd, VMCS_GUEST_INTERRUPTIBILITY, gi);
 }
 
 static inline void vmx_set_nmi_window_exiting(CPUState *cpu)
 {
     uint64_t val;
-    val = rvmcs(cpu->hvf_fd, VMCS_PRI_PROC_BASED_CTLS);
-    wvmcs(cpu->hvf_fd, VMCS_PRI_PROC_BASED_CTLS, val |
-          VMCS_PRI_PROC_BASED_CTLS_NMI_WINDOW_EXITING);
+    val = rvmcs(cpu->accel_vcpu->hvf_fd, VMCS_PRI_PROC_BASED_CTLS);
+    wvmcs(cpu->accel_vcpu->hvf_fd, VMCS_PRI_PROC_BASED_CTLS,
+          val | VMCS_PRI_PROC_BASED_CTLS_NMI_WINDOW_EXITING);
 
 }
 
@@ -228,9 +230,9 @@ static inline void vmx_clear_nmi_window_exiting(CPUState *cpu)
 {
 
     uint64_t val;
-    val = rvmcs(cpu->hvf_fd, VMCS_PRI_PROC_BASED_CTLS);
-    wvmcs(cpu->hvf_fd, VMCS_PRI_PROC_BASED_CTLS, val &
-          ~VMCS_PRI_PROC_BASED_CTLS_NMI_WINDOW_EXITING);
+    val = rvmcs(cpu->accel_vcpu->hvf_fd, VMCS_PRI_PROC_BASED_CTLS);
+    wvmcs(cpu->accel_vcpu->hvf_fd, VMCS_PRI_PROC_BASED_CTLS,
+          val & ~VMCS_PRI_PROC_BASED_CTLS_NMI_WINDOW_EXITING);
 }
 
 #endif
diff --git a/target/i386/hvf/hvf.c b/target/i386/hvf/hvf.c
index 342659f1e15..022975d093e 100644
--- a/target/i386/hvf/hvf.c
+++ b/target/i386/hvf/hvf.c
@@ -245,19 +245,19 @@ void vmx_update_tpr(CPUState *cpu)
     int tpr = cpu_get_apic_tpr(x86_cpu->apic_state) << 4;
     int irr = apic_get_highest_priority_irr(x86_cpu->apic_state);
 
-    wreg(cpu->hvf_fd, HV_X86_TPR, tpr);
+    wreg(cpu->accel_vcpu->hvf_fd, HV_X86_TPR, tpr);
     if (irr == -1) {
-        wvmcs(cpu->hvf_fd, VMCS_TPR_THRESHOLD, 0);
+        wvmcs(cpu->accel_vcpu->hvf_fd, VMCS_TPR_THRESHOLD, 0);
     } else {
-        wvmcs(cpu->hvf_fd, VMCS_TPR_THRESHOLD, (irr > tpr) ? tpr >> 4 :
-              irr >> 4);
+        wvmcs(cpu->accel_vcpu->hvf_fd, VMCS_TPR_THRESHOLD,
+              (irr > tpr) ? tpr >> 4 : irr >> 4);
     }
 }
 
 static void update_apic_tpr(CPUState *cpu)
 {
     X86CPU *x86_cpu = X86_CPU(cpu);
-    int tpr = rreg(cpu->hvf_fd, HV_X86_TPR) >> 4;
+    int tpr = rreg(cpu->accel_vcpu->hvf_fd, HV_X86_TPR) >> 4;
     cpu_set_apic_tpr(x86_cpu->apic_state, tpr);
 }
 
@@ -448,7 +448,7 @@ void hvf_vcpu_destroy(CPUState *cpu)
     X86CPU *x86_cpu = X86_CPU(cpu);
     CPUX86State *env = &x86_cpu->env;
 
-    hv_return_t ret = hv_vcpu_destroy((hv_vcpuid_t)cpu->hvf_fd);
+    hv_return_t ret = hv_vcpu_destroy(cpu->accel_vcpu->hvf_fd);
     g_free(env->hvf_mmio_buf);
     assert_hvf_ok(ret);
     g_free(cpu->accel_vcpu);
@@ -537,7 +537,7 @@ int hvf_init_vcpu(CPUState *cpu)
     r = hv_vcpu_create(&hvf_fd, HV_VCPU_DEFAULT);
     assert_hvf_ok(r);
     cpu->accel_vcpu = g_new(struct AccelvCPUState, 1);
-    cpu->hvf_fd = (int)hvf_fd
+    cpu->accel_vcpu->hvf_fd = hvf_fd
     cpu->vcpu_dirty = true;
 
     if (hv_vmx_read_capability(HV_VMX_CAP_PINBASED,
@@ -635,16 +635,17 @@ static void hvf_store_events(CPUState *cpu, uint32_t ins_len, uint64_t idtvec_in
         }
         if (idtvec_info & VMCS_IDT_VEC_ERRCODE_VALID) {
             env->has_error_code = true;
-            env->error_code = rvmcs(cpu->hvf_fd, VMCS_IDT_VECTORING_ERROR);
+            env->error_code = rvmcs(cpu->accel_vcpu->hvf_fd,
+                                    VMCS_IDT_VECTORING_ERROR);
         }
     }
-    if ((rvmcs(cpu->hvf_fd, VMCS_GUEST_INTERRUPTIBILITY) &
+    if ((rvmcs(cpu->accel_vcpu->hvf_fd, VMCS_GUEST_INTERRUPTIBILITY) &
         VMCS_INTERRUPTIBILITY_NMI_BLOCKING)) {
         env->hflags2 |= HF2_NMI_MASK;
     } else {
         env->hflags2 &= ~HF2_NMI_MASK;
     }
-    if (rvmcs(cpu->hvf_fd, VMCS_GUEST_INTERRUPTIBILITY) &
+    if (rvmcs(cpu->accel_vcpu->hvf_fd, VMCS_GUEST_INTERRUPTIBILITY) &
          (VMCS_INTERRUPTIBILITY_STI_BLOCKING |
          VMCS_INTERRUPTIBILITY_MOVSS_BLOCKING)) {
         env->hflags |= HF_INHIBIT_IRQ_MASK;
@@ -699,7 +700,7 @@ int hvf_vcpu_exec(CPUState *cpu)
 {
     X86CPU *x86_cpu = X86_CPU(cpu);
     CPUX86State *env = &x86_cpu->env;
-    hv_vcpuid_t hvf_fd = (hv_vcpuid_t)cpu_state->hvf_fd;
+    hv_vcpuid_t hvf_fd = cpu_state->accel_vcpu->hvf_fd;
     int ret = 0;
     uint64_t rip = 0;
 
diff --git a/target/i386/hvf/x86.c b/target/i386/hvf/x86.c
index cd045183a81..23fbdb91eb0 100644
--- a/target/i386/hvf/x86.c
+++ b/target/i386/hvf/x86.c
@@ -62,11 +62,11 @@ bool x86_read_segment_descriptor(struct CPUState *cpu,
     }
 
     if (GDT_SEL == sel.ti) {
-        base  = rvmcs(cpu->hvf_fd, VMCS_GUEST_GDTR_BASE);
-        limit = rvmcs(cpu->hvf_fd, VMCS_GUEST_GDTR_LIMIT);
+        base  = rvmcs(cpu->accel_vcpu->hvf_fd, VMCS_GUEST_GDTR_BASE);
+        limit = rvmcs(cpu->accel_vcpu->hvf_fd, VMCS_GUEST_GDTR_LIMIT);
     } else {
-        base  = rvmcs(cpu->hvf_fd, VMCS_GUEST_LDTR_BASE);
-        limit = rvmcs(cpu->hvf_fd, VMCS_GUEST_LDTR_LIMIT);
+        base  = rvmcs(cpu->accel_vcpu->hvf_fd, VMCS_GUEST_LDTR_BASE);
+        limit = rvmcs(cpu->accel_vcpu->hvf_fd, VMCS_GUEST_LDTR_LIMIT);
     }
 
     if (sel.index * 8 >= limit) {
@@ -85,11 +85,11 @@ bool x86_write_segment_descriptor(struct CPUState *cpu,
     uint32_t limit;
     
     if (GDT_SEL == sel.ti) {
-        base  = rvmcs(cpu->hvf_fd, VMCS_GUEST_GDTR_BASE);
-        limit = rvmcs(cpu->hvf_fd, VMCS_GUEST_GDTR_LIMIT);
+        base  = rvmcs(cpu->accel_vcpu->hvf_fd, VMCS_GUEST_GDTR_BASE);
+        limit = rvmcs(cpu->accel_vcpu->hvf_fd, VMCS_GUEST_GDTR_LIMIT);
     } else {
-        base  = rvmcs(cpu->hvf_fd, VMCS_GUEST_LDTR_BASE);
-        limit = rvmcs(cpu->hvf_fd, VMCS_GUEST_LDTR_LIMIT);
+        base  = rvmcs(cpu->accel_vcpu->hvf_fd, VMCS_GUEST_LDTR_BASE);
+        limit = rvmcs(cpu->accel_vcpu->hvf_fd, VMCS_GUEST_LDTR_LIMIT);
     }
     
     if (sel.index * 8 >= limit) {
@@ -103,8 +103,8 @@ bool x86_write_segment_descriptor(struct CPUState *cpu,
 bool x86_read_call_gate(struct CPUState *cpu, struct x86_call_gate *idt_desc,
                         int gate)
 {
-    target_ulong base  = rvmcs(cpu->hvf_fd, VMCS_GUEST_IDTR_BASE);
-    uint32_t limit = rvmcs(cpu->hvf_fd, VMCS_GUEST_IDTR_LIMIT);
+    target_ulong base  = rvmcs(cpu->accel_vcpu->hvf_fd, VMCS_GUEST_IDTR_BASE);
+    uint32_t limit = rvmcs(cpu->accel_vcpu->hvf_fd, VMCS_GUEST_IDTR_LIMIT);
 
     memset(idt_desc, 0, sizeof(*idt_desc));
     if (gate * 8 >= limit) {
@@ -118,7 +118,7 @@ bool x86_read_call_gate(struct CPUState *cpu, struct x86_call_gate *idt_desc,
 
 bool x86_is_protected(struct CPUState *cpu)
 {
-    uint64_t cr0 = rvmcs(cpu->hvf_fd, VMCS_GUEST_CR0);
+    uint64_t cr0 = rvmcs(cpu->accel_vcpu->hvf_fd, VMCS_GUEST_CR0);
     return cr0 & CR0_PE;
 }
 
@@ -136,7 +136,7 @@ bool x86_is_v8086(struct CPUState *cpu)
 
 bool x86_is_long_mode(struct CPUState *cpu)
 {
-    return rvmcs(cpu->hvf_fd, VMCS_GUEST_IA32_EFER) & MSR_EFER_LMA;
+    return rvmcs(cpu->accel_vcpu->hvf_fd, VMCS_GUEST_IA32_EFER) & MSR_EFER_LMA;
 }
 
 bool x86_is_long64_mode(struct CPUState *cpu)
@@ -149,13 +149,13 @@ bool x86_is_long64_mode(struct CPUState *cpu)
 
 bool x86_is_paging_mode(struct CPUState *cpu)
 {
-    uint64_t cr0 = rvmcs(cpu->hvf_fd, VMCS_GUEST_CR0);
+    uint64_t cr0 = rvmcs(cpu->accel_vcpu->hvf_fd, VMCS_GUEST_CR0);
     return cr0 & CR0_PG;
 }
 
 bool x86_is_pae_enabled(struct CPUState *cpu)
 {
-    uint64_t cr4 = rvmcs(cpu->hvf_fd, VMCS_GUEST_CR4);
+    uint64_t cr4 = rvmcs(cpu->accel_vcpu->hvf_fd, VMCS_GUEST_CR4);
     return cr4 & CR4_PAE;
 }
 
diff --git a/target/i386/hvf/x86_descr.c b/target/i386/hvf/x86_descr.c
index 1c6220baa0d..4f716cc5942 100644
--- a/target/i386/hvf/x86_descr.c
+++ b/target/i386/hvf/x86_descr.c
@@ -48,34 +48,37 @@ static const struct vmx_segment_field {
 
 uint32_t vmx_read_segment_limit(CPUState *cpu, X86Seg seg)
 {
-    return (uint32_t)rvmcs(cpu->hvf_fd, vmx_segment_fields[seg].limit);
+    return (uint32_t)rvmcs(cpu->accel_vcpu->hvf_fd,
+                           vmx_segment_fields[seg].limit);
 }
 
 uint32_t vmx_read_segment_ar(CPUState *cpu, X86Seg seg)
 {
-    return (uint32_t)rvmcs(cpu->hvf_fd, vmx_segment_fields[seg].ar_bytes);
+    return (uint32_t)rvmcs(cpu->accel_vcpu->hvf_fd,
+                           vmx_segment_fields[seg].ar_bytes);
 }
 
 uint64_t vmx_read_segment_base(CPUState *cpu, X86Seg seg)
 {
-    return rvmcs(cpu->hvf_fd, vmx_segment_fields[seg].base);
+    return rvmcs(cpu->accel_vcpu->hvf_fd, vmx_segment_fields[seg].base);
 }
 
 x68_segment_selector vmx_read_segment_selector(CPUState *cpu, X86Seg seg)
 {
     x68_segment_selector sel;
-    sel.sel = rvmcs(cpu->hvf_fd, vmx_segment_fields[seg].selector);
+    sel.sel = rvmcs(cpu->accel_vcpu->hvf_fd, vmx_segment_fields[seg].selector);
     return sel;
 }
 
 void vmx_write_segment_selector(struct CPUState *cpu, x68_segment_selector selector, X86Seg seg)
 {
-    wvmcs(cpu->hvf_fd, vmx_segment_fields[seg].selector, selector.sel);
+    wvmcs(cpu->accel_vcpu->hvf_fd, vmx_segment_fields[seg].selector,
+          selector.sel);
 }
 
 void vmx_read_segment_descriptor(struct CPUState *cpu, struct vmx_segment *desc, X86Seg seg)
 {
-    hv_vcpuid_t hvf_fd = (hv_vcpuid_t)cpu_state->hvf_fd;
+    hv_vcpuid_t hvf_fd = cpu_state->accel_vcpu->hvf_fd;
 
     desc->sel = rvmcs(hvf_fd, vmx_segment_fields[seg].selector);
     desc->base = rvmcs(hvf_fd, vmx_segment_fields[seg].base);
@@ -86,7 +89,7 @@ void vmx_read_segment_descriptor(struct CPUState *cpu, struct vmx_segment *desc,
 void vmx_write_segment_descriptor(CPUState *cpu, struct vmx_segment *desc, X86Seg seg)
 {
     const struct vmx_segment_field *sf = &vmx_segment_fields[seg];
-    hv_vcpuid_t hvf_fd = (hv_vcpuid_t)cpu_state->hvf_fd;
+    hv_vcpuid_t hvf_fd = cpu_state->accel_vcpu->hvf_fd;
 
     wvmcs(hvf_fd, sf->base, desc->base);
     wvmcs(hvf_fd, sf->limit, desc->limit);
diff --git a/target/i386/hvf/x86_emu.c b/target/i386/hvf/x86_emu.c
index e52c39ddb1f..dd7dee6f880 100644
--- a/target/i386/hvf/x86_emu.c
+++ b/target/i386/hvf/x86_emu.c
@@ -674,7 +674,7 @@ void simulate_rdmsr(struct CPUState *cpu)
 
     switch (msr) {
     case MSR_IA32_TSC:
-        val = rdtscp() + rvmcs(cpu->hvf_fd, VMCS_TSC_OFFSET);
+        val = rdtscp() + rvmcs(cpu->accel_vcpu->hvf_fd, VMCS_TSC_OFFSET);
         break;
     case MSR_IA32_APICBASE:
         val = cpu_get_apic_base(X86_CPU(cpu)->apic_state);
@@ -683,16 +683,16 @@ void simulate_rdmsr(struct CPUState *cpu)
         val = x86_cpu->ucode_rev;
         break;
     case MSR_EFER:
-        val = rvmcs(cpu->hvf_fd, VMCS_GUEST_IA32_EFER);
+        val = rvmcs(cpu->accel_vcpu->hvf_fd, VMCS_GUEST_IA32_EFER);
         break;
     case MSR_FSBASE:
-        val = rvmcs(cpu->hvf_fd, VMCS_GUEST_FS_BASE);
+        val = rvmcs(cpu->accel_vcpu->hvf_fd, VMCS_GUEST_FS_BASE);
         break;
     case MSR_GSBASE:
-        val = rvmcs(cpu->hvf_fd, VMCS_GUEST_GS_BASE);
+        val = rvmcs(cpu->accel_vcpu->hvf_fd, VMCS_GUEST_GS_BASE);
         break;
     case MSR_KERNELGSBASE:
-        val = rvmcs(cpu->hvf_fd, VMCS_HOST_FS_BASE);
+        val = rvmcs(cpu->accel_vcpu->hvf_fd, VMCS_HOST_FS_BASE);
         break;
     case MSR_STAR:
         abort();
@@ -780,13 +780,13 @@ void simulate_wrmsr(struct CPUState *cpu)
         cpu_set_apic_base(X86_CPU(cpu)->apic_state, data);
         break;
     case MSR_FSBASE:
-        wvmcs(cpu->hvf_fd, VMCS_GUEST_FS_BASE, data);
+        wvmcs(cpu->accel_vcpu->hvf_fd, VMCS_GUEST_FS_BASE, data);
         break;
     case MSR_GSBASE:
-        wvmcs(cpu->hvf_fd, VMCS_GUEST_GS_BASE, data);
+        wvmcs(cpu->accel_vcpu->hvf_fd, VMCS_GUEST_GS_BASE, data);
         break;
     case MSR_KERNELGSBASE:
-        wvmcs(cpu->hvf_fd, VMCS_HOST_FS_BASE, data);
+        wvmcs(cpu->accel_vcpu->hvf_fd, VMCS_HOST_FS_BASE, data);
         break;
     case MSR_STAR:
         abort();
@@ -799,9 +799,9 @@ void simulate_wrmsr(struct CPUState *cpu)
         break;
     case MSR_EFER:
         /*printf("new efer %llx\n", EFER(cpu));*/
-        wvmcs(cpu->hvf_fd, VMCS_GUEST_IA32_EFER, data);
+        wvmcs(cpu->accel_vcpu->hvf_fd, VMCS_GUEST_IA32_EFER, data);
         if (data & MSR_EFER_NXE) {
-            hv_vcpu_invalidate_tlb(cpu->hvf_fd);
+            hv_vcpu_invalidate_tlb(cpu->accel_vcpu->hvf_fd);
         }
         break;
     case MSR_MTRRphysBase(0):
@@ -1425,21 +1425,21 @@ void load_regs(struct CPUState *cpu)
     CPUX86State *env = &x86_cpu->env;
 
     int i = 0;
-    RRX(env, R_EAX) = rreg(cpu->hvf_fd, HV_X86_RAX);
-    RRX(env, R_EBX) = rreg(cpu->hvf_fd, HV_X86_RBX);
-    RRX(env, R_ECX) = rreg(cpu->hvf_fd, HV_X86_RCX);
-    RRX(env, R_EDX) = rreg(cpu->hvf_fd, HV_X86_RDX);
-    RRX(env, R_ESI) = rreg(cpu->hvf_fd, HV_X86_RSI);
-    RRX(env, R_EDI) = rreg(cpu->hvf_fd, HV_X86_RDI);
-    RRX(env, R_ESP) = rreg(cpu->hvf_fd, HV_X86_RSP);
-    RRX(env, R_EBP) = rreg(cpu->hvf_fd, HV_X86_RBP);
+    RRX(env, R_EAX) = rreg(cpu->accel_vcpu->hvf_fd, HV_X86_RAX);
+    RRX(env, R_EBX) = rreg(cpu->accel_vcpu->hvf_fd, HV_X86_RBX);
+    RRX(env, R_ECX) = rreg(cpu->accel_vcpu->hvf_fd, HV_X86_RCX);
+    RRX(env, R_EDX) = rreg(cpu->accel_vcpu->hvf_fd, HV_X86_RDX);
+    RRX(env, R_ESI) = rreg(cpu->accel_vcpu->hvf_fd, HV_X86_RSI);
+    RRX(env, R_EDI) = rreg(cpu->accel_vcpu->hvf_fd, HV_X86_RDI);
+    RRX(env, R_ESP) = rreg(cpu->accel_vcpu->hvf_fd, HV_X86_RSP);
+    RRX(env, R_EBP) = rreg(cpu->accel_vcpu->hvf_fd, HV_X86_RBP);
     for (i = 8; i < 16; i++) {
-        RRX(env, i) = rreg(cpu->hvf_fd, HV_X86_RAX + i);
+        RRX(env, i) = rreg(cpu->accel_vcpu->hvf_fd, HV_X86_RAX + i);
     }
 
-    env->eflags = rreg(cpu->hvf_fd, HV_X86_RFLAGS);
+    env->eflags = rreg(cpu->accel_vcpu->hvf_fd, HV_X86_RFLAGS);
     rflags_to_lflags(env);
-    env->eip = rreg(cpu->hvf_fd, HV_X86_RIP);
+    env->eip = rreg(cpu->accel_vcpu->hvf_fd, HV_X86_RIP);
 }
 
 void store_regs(struct CPUState *cpu)
@@ -1448,20 +1448,20 @@ void store_regs(struct CPUState *cpu)
     CPUX86State *env = &x86_cpu->env;
 
     int i = 0;
-    wreg(cpu->hvf_fd, HV_X86_RAX, RAX(env));
-    wreg(cpu->hvf_fd, HV_X86_RBX, RBX(env));
-    wreg(cpu->hvf_fd, HV_X86_RCX, RCX(env));
-    wreg(cpu->hvf_fd, HV_X86_RDX, RDX(env));
-    wreg(cpu->hvf_fd, HV_X86_RSI, RSI(env));
-    wreg(cpu->hvf_fd, HV_X86_RDI, RDI(env));
-    wreg(cpu->hvf_fd, HV_X86_RBP, RBP(env));
-    wreg(cpu->hvf_fd, HV_X86_RSP, RSP(env));
+    wreg(cpu->accel_vcpu->hvf_fd, HV_X86_RAX, RAX(env));
+    wreg(cpu->accel_vcpu->hvf_fd, HV_X86_RBX, RBX(env));
+    wreg(cpu->accel_vcpu->hvf_fd, HV_X86_RCX, RCX(env));
+    wreg(cpu->accel_vcpu->hvf_fd, HV_X86_RDX, RDX(env));
+    wreg(cpu->accel_vcpu->hvf_fd, HV_X86_RSI, RSI(env));
+    wreg(cpu->accel_vcpu->hvf_fd, HV_X86_RDI, RDI(env));
+    wreg(cpu->accel_vcpu->hvf_fd, HV_X86_RBP, RBP(env));
+    wreg(cpu->accel_vcpu->hvf_fd, HV_X86_RSP, RSP(env));
     for (i = 8; i < 16; i++) {
-        wreg(cpu->hvf_fd, HV_X86_RAX + i, RRX(env, i));
+        wreg(cpu->accel_vcpu->hvf_fd, HV_X86_RAX + i, RRX(env, i));
     }
 
     lflags_to_rflags(env);
-    wreg(cpu->hvf_fd, HV_X86_RFLAGS, env->eflags);
+    wreg(cpu->accel_vcpu->hvf_fd, HV_X86_RFLAGS, env->eflags);
     macvm_set_rip(cpu, env->eip);
 }
 
diff --git a/target/i386/hvf/x86_mmu.c b/target/i386/hvf/x86_mmu.c
index 882a6237eea..deb3608f2be 100644
--- a/target/i386/hvf/x86_mmu.c
+++ b/target/i386/hvf/x86_mmu.c
@@ -128,7 +128,7 @@ static bool test_pt_entry(struct CPUState *cpu, struct gpt_translation *pt,
         pt->err_code |= MMU_PAGE_PT;
     }
 
-    uint32_t cr0 = rvmcs(cpu->hvf_fd, VMCS_GUEST_CR0);
+    uint32_t cr0 = rvmcs(cpu->accel_vcpu->hvf_fd, VMCS_GUEST_CR0);
     /* check protection */
     if (cr0 & CR0_WP) {
         if (pt->write_access && !pte_write_access(pte)) {
@@ -173,7 +173,7 @@ static bool walk_gpt(struct CPUState *cpu, target_ulong addr, int err_code,
 {
     int top_level, level;
     bool is_large = false;
-    target_ulong cr3 = rvmcs(cpu->hvf_fd, VMCS_GUEST_CR3);
+    target_ulong cr3 = rvmcs(cpu->accel_vcpu->hvf_fd, VMCS_GUEST_CR3);
     uint64_t page_mask = pae ? PAE_PTE_PAGE_MASK : LEGACY_PTE_PAGE_MASK;
     
     memset(pt, 0, sizeof(*pt));
diff --git a/target/i386/hvf/x86_task.c b/target/i386/hvf/x86_task.c
index d66dfd76690..baa4c5ca87e 100644
--- a/target/i386/hvf/x86_task.c
+++ b/target/i386/hvf/x86_task.c
@@ -62,7 +62,7 @@ static void load_state_from_tss32(CPUState *cpu, struct x86_tss_segment32 *tss)
     X86CPU *x86_cpu = X86_CPU(cpu);
     CPUX86State *env = &x86_cpu->env;
 
-    wvmcs(cpu->hvf_fd, VMCS_GUEST_CR3, tss->cr3);
+    wvmcs(cpu->accel_vcpu->hvf_fd, VMCS_GUEST_CR3, tss->cr3);
 
     env->eip = tss->eip;
     env->eflags = tss->eflags | 2;
@@ -111,11 +111,12 @@ static int task_switch_32(CPUState *cpu, x68_segment_selector tss_sel, x68_segme
 
 void vmx_handle_task_switch(CPUState *cpu, x68_segment_selector tss_sel, int reason, bool gate_valid, uint8_t gate, uint64_t gate_type)
 {
-    uint64_t rip = rreg(cpu->hvf_fd, HV_X86_RIP);
+    uint64_t rip = rreg(cpu->accel_vcpu->hvf_fd, HV_X86_RIP);
     if (!gate_valid || (gate_type != VMCS_INTR_T_HWEXCEPTION &&
                         gate_type != VMCS_INTR_T_HWINTR &&
                         gate_type != VMCS_INTR_T_NMI)) {
-        int ins_len = rvmcs(cpu->hvf_fd, VMCS_EXIT_INSTRUCTION_LENGTH);
+        int ins_len = rvmcs(cpu->accel_vcpu->hvf_fd,
+                            VMCS_EXIT_INSTRUCTION_LENGTH);
         macvm_set_rip(cpu, rip + ins_len);
         return;
     }
@@ -174,12 +175,13 @@ void vmx_handle_task_switch(CPUState *cpu, x68_segment_selector tss_sel, int rea
         //ret = task_switch_16(cpu, tss_sel, old_tss_sel, old_tss_base, &next_tss_desc);
         VM_PANIC("task_switch_16");
 
-    macvm_set_cr0(cpu->hvf_fd, rvmcs(cpu->hvf_fd, VMCS_GUEST_CR0) | CR0_TS);
+    macvm_set_cr0(cpu->accel_vcpu->hvf_fd,
+                  rvmcs(cpu->accel_vcpu->hvf_fd, VMCS_GUEST_CR0) | CR0_TS);
     x86_segment_descriptor_to_vmx(cpu, tss_sel, &next_tss_desc, &vmx_seg);
     vmx_write_segment_descriptor(cpu, &vmx_seg, R_TR);
 
     store_regs(cpu);
 
-    hv_vcpu_invalidate_tlb(cpu->hvf_fd);
-    hv_vcpu_flush(cpu->hvf_fd);
+    hv_vcpu_invalidate_tlb(cpu->accel_vcpu->hvf_fd);
+    hv_vcpu_flush(cpu->accel_vcpu->hvf_fd);
 }
diff --git a/target/i386/hvf/x86hvf.c b/target/i386/hvf/x86hvf.c
index 2f291f2ad53..c68400b9729 100644
--- a/target/i386/hvf/x86hvf.c
+++ b/target/i386/hvf/x86hvf.c
@@ -81,7 +81,8 @@ void hvf_put_xsave(CPUState *cpu_state)
 
     x86_cpu_xsave_all_areas(X86_CPU(cpu_state), xsave);
 
-    if (hv_vcpu_write_fpstate(cpu_state->hvf_fd, (void*)xsave, 4096)) {
+    if (hv_vcpu_write_fpstate(cpu_state->accel_vcpu->hvf_fd,
+                              (void *)xsave, 4096)) {
         abort();
     }
 }
@@ -89,7 +90,7 @@ void hvf_put_xsave(CPUState *cpu_state)
 void hvf_put_segments(CPUState *cpu_state)
 {
     CPUX86State *env = &X86_CPU(cpu_state)->env;
-    hv_vcpuid_t hvf_fd = (hv_vcpuid_t)cpu_state->hvf_fd;
+    hv_vcpuid_t hvf_fd = cpu_state->accel_vcpu->hvf_fd;
     struct vmx_segment seg;
     
     wvmcs(hvf_fd, VMCS_GUEST_IDTR_LIMIT, env->idt.limit);
@@ -136,7 +137,7 @@ void hvf_put_segments(CPUState *cpu_state)
 void hvf_put_msrs(CPUState *cpu_state)
 {
     CPUX86State *env = &X86_CPU(cpu_state)->env;
-    hv_vcpuid_t hvf_fd = (hv_vcpuid_t)cpu_state->hvf_fd;
+    hv_vcpuid_t hvf_fd = cpu_state->accel_vcpu->hvf_fd;
 
     hv_vcpu_write_msr(hvf_fd, MSR_IA32_SYSENTER_CS, env->sysenter_cs);
     hv_vcpu_write_msr(hvf_fd, MSR_IA32_SYSENTER_ESP, env->sysenter_esp);
@@ -162,7 +163,8 @@ void hvf_get_xsave(CPUState *cpu_state)
 
     xsave = X86_CPU(cpu_state)->env.xsave_buf;
 
-    if (hv_vcpu_read_fpstate(cpu_state->hvf_fd, (void*)xsave, 4096)) {
+    if (hv_vcpu_read_fpstate(cpu_state->accel_vcpu->hvf_fd,
+                             (void *)xsave, 4096)) {
         abort();
     }
 
@@ -172,7 +174,7 @@ void hvf_get_xsave(CPUState *cpu_state)
 void hvf_get_segments(CPUState *cpu_state)
 {
     CPUX86State *env = &X86_CPU(cpu_state)->env;
-    hv_vcpuid_t hvf_fd = (hv_vcpuid_t)cpu_state->hvf_fd;
+    hv_vcpuid_t hvf_fd = cpu_state->accel_vcpu->hvf_fd;
     struct vmx_segment seg;
 
     env->interrupt_injected = -1;
@@ -217,7 +219,7 @@ void hvf_get_segments(CPUState *cpu_state)
 void hvf_get_msrs(CPUState *cpu_state)
 {
     CPUX86State *env = &X86_CPU(cpu_state)->env;
-    hv_vcpuid_t hvf_fd = (hv_vcpuid_t)cpu_state->hvf_fd;
+    hv_vcpuid_t hvf_fd = cpu_state->accel_vcpu->hvf_fd;
     uint64_t tmp;
     
     hv_vcpu_read_msr(hvf_fd, MSR_IA32_SYSENTER_CS, &tmp);
@@ -247,7 +249,7 @@ int hvf_put_registers(CPUState *cpu_state)
 {
     X86CPU *x86cpu = X86_CPU(cpu_state);
     CPUX86State *env = &x86cpu->env;
-    hv_vcpuid_t hvf_fd = (hv_vcpuid_t)cpu_state->hvf_fd;
+    hv_vcpuid_t hvf_fd = cpu_state->accel_vcpu->hvf_fd;
 
     wreg(hvf_fd, HV_X86_RAX, env->regs[R_EAX]);
     wreg(hvf_fd, HV_X86_RBX, env->regs[R_EBX]);
@@ -292,7 +294,7 @@ int hvf_get_registers(CPUState *cpu_state)
 {
     X86CPU *x86cpu = X86_CPU(cpu_state);
     CPUX86State *env = &x86cpu->env;
-    hv_vcpuid_t hvf_fd = (hv_vcpuid_t)cpu_state->hvf_fd;
+    hv_vcpuid_t hvf_fd = cpu_state->accel_vcpu->hvf_fd;
 
     env->regs[R_EAX] = rreg(hvf_fd, HV_X86_RAX);
     env->regs[R_EBX] = rreg(hvf_fd, HV_X86_RBX);
@@ -336,24 +338,24 @@ int hvf_get_registers(CPUState *cpu_state)
 static void vmx_set_int_window_exiting(CPUState *cpu)
 {
      uint64_t val;
-     val = rvmcs(cpu->hvf_fd, VMCS_PRI_PROC_BASED_CTLS);
-     wvmcs(cpu->hvf_fd, VMCS_PRI_PROC_BASED_CTLS, val |
+     val = rvmcs(cpu->accel_vcpu->hvf_fd, VMCS_PRI_PROC_BASED_CTLS);
+     wvmcs(cpu->accel_vcpu->hvf_fd, VMCS_PRI_PROC_BASED_CTLS, val |
              VMCS_PRI_PROC_BASED_CTLS_INT_WINDOW_EXITING);
 }
 
 void vmx_clear_int_window_exiting(CPUState *cpu)
 {
      uint64_t val;
-     val = rvmcs(cpu->hvf_fd, VMCS_PRI_PROC_BASED_CTLS);
-     wvmcs(cpu->hvf_fd, VMCS_PRI_PROC_BASED_CTLS, val &
-             ~VMCS_PRI_PROC_BASED_CTLS_INT_WINDOW_EXITING);
+     val = rvmcs(cpu->accel_vcpu->hvf_fd, VMCS_PRI_PROC_BASED_CTLS);
+     wvmcs(cpu->accel_vcpu->hvf_fd, VMCS_PRI_PROC_BASED_CTLS,\
+           val & ~VMCS_PRI_PROC_BASED_CTLS_INT_WINDOW_EXITING);
 }
 
 bool hvf_inject_interrupts(CPUState *cpu_state)
 {
     X86CPU *x86cpu = X86_CPU(cpu_state);
     CPUX86State *env = &x86cpu->env;
-    hv_vcpuid_t hvf_fd = (hv_vcpuid_t)cpu_state->hvf_fd;
+    hv_vcpuid_t hvf_fd = cpu_state->accel_vcpu->hvf_fd;
 
     uint8_t vector;
     uint64_t intr_type;
@@ -437,7 +439,7 @@ int hvf_process_events(CPUState *cpu_state)
     X86CPU *cpu = X86_CPU(cpu_state);
     CPUX86State *env = &cpu->env;
 
-    env->eflags = rreg(cpu_state->hvf_fd, HV_X86_RFLAGS);
+    env->eflags = rreg(cpu_state->accel_vcpu->hvf_fd, HV_X86_RFLAGS);
 
     if (cpu_state->interrupt_request & CPU_INTERRUPT_INIT) {
         hvf_cpu_synchronize_state(cpu_state);
-- 
2.26.2

