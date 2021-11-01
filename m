Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8C8441BAD
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 14:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbhKAN00 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 09:26:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39430 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231284AbhKAN0Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 09:26:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635773032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YrDHr1GfYhqx6nbamyiITvnEWXK/taDrSkGlwrCriqY=;
        b=CImRpgfKsARC2OnXuCacf2TWRH2IhUFDZilMFgEtAJLSnatrSHjloQLCYgDs3Odza001z2
        +q6RN6rSEMQzuKvLU5m8zeOZlnnCXm07Kp5ai9fY3yPxgEwlAzFAOfMwjHKsjs/0ETpTJI
        g+eGHL6VEpGtILbojfQjrYN9ChD2epY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-vRCGCm8PMY2FQnZWD9XcJw-1; Mon, 01 Nov 2021 09:23:49 -0400
X-MC-Unique: vRCGCm8PMY2FQnZWD9XcJw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 387B7100B3B6;
        Mon,  1 Nov 2021 13:23:48 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 190D360C0F;
        Mon,  1 Nov 2021 13:23:45 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 3/3] KVM: SVM: add migration support for nested TSC scaling
Date:   Mon,  1 Nov 2021 15:23:00 +0200
Message-Id: <20211101132300.192584-4-mlevitsk@redhat.com>
In-Reply-To: <20211101132300.192584-1-mlevitsk@redhat.com>
References: <20211101132300.192584-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
index 598d451dcf..53a23ca006 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5928,6 +5928,11 @@ static void x86_cpu_reset(DeviceState *dev)
     }
 
     x86_cpu_set_sgxlepubkeyhash(env);
+
+    if (env->features[FEAT_SVM] & CPUID_SVM_TSCSCALE) {
+        env->amd_tsc_scale_msr =  MSR_AMD64_TSC_RATIO_DEFAULT;
+    }
+
 #endif
 }
 
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 8c39e787f9..9911d7c871 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -499,6 +499,9 @@ typedef enum X86Seg {
 #define MSR_GSBASE                      0xc0000101
 #define MSR_KERNELGSBASE                0xc0000102
 #define MSR_TSC_AUX                     0xc0000103
+#define MSR_AMD64_TSC_RATIO             0xc0000104
+
+#define MSR_AMD64_TSC_RATIO_DEFAULT     0x100000000ULL
 
 #define MSR_VM_HSAVE_PA                 0xc0010117
 
@@ -1539,6 +1542,7 @@ typedef struct CPUX86State {
     uint32_t tsx_ctrl;
 
     uint64_t spec_ctrl;
+    uint64_t amd_tsc_scale_msr;
     uint64_t virt_ssbd;
 
     /* End of state preserved by INIT (dummy marker).  */
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 13be6995a8..e2dad8e168 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -105,6 +105,7 @@ static bool has_msr_hv_reenlightenment;
 static bool has_msr_xss;
 static bool has_msr_umwait;
 static bool has_msr_spec_ctrl;
+static bool has_tsc_scale_msr;
 static bool has_msr_tsx_ctrl;
 static bool has_msr_virt_ssbd;
 static bool has_msr_smi_count;
@@ -2216,6 +2217,9 @@ static int kvm_get_supported_msrs(KVMState *s)
             case MSR_IA32_SPEC_CTRL:
                 has_msr_spec_ctrl = true;
                 break;
+            case MSR_AMD64_TSC_RATIO:
+                has_tsc_scale_msr = true;
+                break;
             case MSR_IA32_TSX_CTRL:
                 has_msr_tsx_ctrl = true;
                 break;
@@ -3027,6 +3031,10 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
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
@@ -3479,6 +3487,10 @@ static int kvm_get_msrs(X86CPU *cpu)
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
@@ -3890,6 +3902,9 @@ static int kvm_get_msrs(X86CPU *cpu)
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
index 14dd5ed79c..5dea1ef30d 100644
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
@@ -1586,6 +1608,7 @@ const VMStateDescription vmstate_x86_cpu = {
         &vmstate_pkru,
         &vmstate_pkrs,
         &vmstate_spec_ctrl,
+        &amd_tsc_scale_msr_ctrl,
         &vmstate_mcg_ext_ctl,
         &vmstate_msr_intel_pt,
         &vmstate_msr_virt_ssbd,
-- 
2.26.3

