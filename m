Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED4540B3C0
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 17:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbhINPxq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 11:53:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26643 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234625AbhINPxp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 11:53:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631634747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y17xwD7gh8Gphu0rWKx/gyFu05AIn99CsfbWQxLhpNI=;
        b=Ea9NYNC02+WsxK6ONhgtlGObFLAaT/qUwhJjJ3uCtzZb5AvqfDjkFze/LmDW7T/32guWM6
        Q9HPsT6CcppL09tv4/cn5sOIqX8/S2GS+xsQV1mT0TqL6TfTpAiZ0jVZR6vNvuST0gVzJl
        OGEgAHZ/OEstUoi6lgNY4iNrWOXJbx8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-X96rCYLYPiylqr_pjJBQWQ-1; Tue, 14 Sep 2021 11:52:26 -0400
X-MC-Unique: X96rCYLYPiylqr_pjJBQWQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D7BD835DE3;
        Tue, 14 Sep 2021 15:52:25 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2AFF95D9D3;
        Tue, 14 Sep 2021 15:52:22 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        kvm@vger.kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 3/3] KVM: SVM: add migration support for nested TSC scaling
Date:   Tue, 14 Sep 2021 18:52:14 +0300
Message-Id: <20210914155214.105415-4-mlevitsk@redhat.com>
In-Reply-To: <20210914155214.105415-1-mlevitsk@redhat.com>
References: <20210914155214.105415-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 target/i386/cpu.c     |  5 +++++
 target/i386/cpu.h     |  4 ++++
 target/i386/kvm/kvm.c | 15 +++++++++++++++
 target/i386/machine.c | 23 +++++++++++++++++++++++
 4 files changed, 47 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 6b029f1bdf..0870b53509 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5770,6 +5770,11 @@ static void x86_cpu_reset(DeviceState *dev)
     if (kvm_enabled()) {
         kvm_arch_reset_vcpu(cpu);
     }
+
+    if (env->features[FEAT_SVM] & CPUID_SVM_TSCSCALE) {
+        env->amd_tsc_scale_msr =  MSR_AMD64_TSC_RATIO_DEFAULT;
+    }
+
 #endif
 }
 
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 9adae12426..b9e1a3b7db 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -491,6 +491,9 @@ typedef enum X86Seg {
 #define MSR_GSBASE                      0xc0000101
 #define MSR_KERNELGSBASE                0xc0000102
 #define MSR_TSC_AUX                     0xc0000103
+#define MSR_AMD64_TSC_RATIO             0xc0000104
+
+#define MSR_AMD64_TSC_RATIO_DEFAULT     0x100000000ULL
 
 #define MSR_VM_HSAVE_PA                 0xc0010117
 
@@ -1522,6 +1525,7 @@ typedef struct CPUX86State {
     uint32_t tsx_ctrl;
 
     uint64_t spec_ctrl;
+    uint64_t amd_tsc_scale_msr;
     uint64_t virt_ssbd;
 
     /* End of state preserved by INIT (dummy marker).  */
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 841b3b98f7..bd53a55148 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -106,6 +106,7 @@ static bool has_msr_hv_reenlightenment;
 static bool has_msr_xss;
 static bool has_msr_umwait;
 static bool has_msr_spec_ctrl;
+static bool has_tsc_scale_msr;
 static bool has_msr_tsx_ctrl;
 static bool has_msr_virt_ssbd;
 static bool has_msr_smi_count;
@@ -2157,6 +2158,9 @@ static int kvm_get_supported_msrs(KVMState *s)
             case MSR_IA32_SPEC_CTRL:
                 has_msr_spec_ctrl = true;
                 break;
+            case MSR_AMD64_TSC_RATIO:
+                has_tsc_scale_msr = true;
+                break;
             case MSR_IA32_TSX_CTRL:
                 has_msr_tsx_ctrl = true;
                 break;
@@ -2968,6 +2972,10 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
     if (has_msr_spec_ctrl) {
         kvm_msr_entry_add(cpu, MSR_IA32_SPEC_CTRL, env->spec_ctrl);
     }
+    if (has_tsc_scale_msr) {
+        kvm_msr_entry_add(cpu, MSR_AMD64_TSC_RATIO, env->amd_tsc_scale_msr);
+    }
+
     if (has_msr_tsx_ctrl) {
         kvm_msr_entry_add(cpu, MSR_IA32_TSX_CTRL, env->tsx_ctrl);
     }
@@ -3409,6 +3417,10 @@ static int kvm_get_msrs(X86CPU *cpu)
     if (has_msr_spec_ctrl) {
         kvm_msr_entry_add(cpu, MSR_IA32_SPEC_CTRL, 0);
     }
+    if (has_tsc_scale_msr) {
+        kvm_msr_entry_add(cpu, MSR_AMD64_TSC_RATIO, 0);
+    }
+
     if (has_msr_tsx_ctrl) {
         kvm_msr_entry_add(cpu, MSR_IA32_TSX_CTRL, 0);
     }
@@ -3813,6 +3825,9 @@ static int kvm_get_msrs(X86CPU *cpu)
         case MSR_IA32_SPEC_CTRL:
             env->spec_ctrl = msrs[i].data;
             break;
+        case MSR_AMD64_TSC_RATIO:
+            env->amd_tsc_scale_msr = msrs[i].data;
+            break;
         case MSR_IA32_TSX_CTRL:
             env->tsx_ctrl = msrs[i].data;
             break;
diff --git a/target/i386/machine.c b/target/i386/machine.c
index 154666e7c0..39c8faf0ce 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -1280,6 +1280,28 @@ static const VMStateDescription vmstate_spec_ctrl = {
     }
 };
 
+
+static bool amd_tsc_scale_msr_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+    CPUX86State *env = &cpu->env;
+
+    return env->amd_tsc_scale_msr &&
+           env->amd_tsc_scale_msr != MSR_AMD64_TSC_RATIO_DEFAULT;
+}
+
+static const VMStateDescription amd_tsc_scale_msr_ctrl = {
+    .name = "cpu/amd_tsc_scale_msr",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = amd_tsc_scale_msr_needed,
+    .fields = (VMStateField[]){
+        VMSTATE_UINT64(env.amd_tsc_scale_msr, X86CPU),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
+
 static bool intel_pt_enable_needed(void *opaque)
 {
     X86CPU *cpu = opaque;
@@ -1568,6 +1590,7 @@ const VMStateDescription vmstate_x86_cpu = {
         &vmstate_pkru,
         &vmstate_pkrs,
         &vmstate_spec_ctrl,
+        &amd_tsc_scale_msr_ctrl,
         &vmstate_mcg_ext_ctl,
         &vmstate_msr_intel_pt,
         &vmstate_msr_virt_ssbd,
-- 
2.26.3

