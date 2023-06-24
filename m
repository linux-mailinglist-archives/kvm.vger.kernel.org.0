Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAE5773CC34
	for <lists+kvm@lfdr.de>; Sat, 24 Jun 2023 19:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbjFXRn3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Jun 2023 13:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233194AbjFXRnZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Jun 2023 13:43:25 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5361FD7
        for <kvm@vger.kernel.org>; Sat, 24 Jun 2023 10:43:18 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f9189228bcso17661255e9.3
        for <kvm@vger.kernel.org>; Sat, 24 Jun 2023 10:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687628597; x=1690220597;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cbsgyJj8b56jpRAu2aJb3zjkuNeKq4dUo/g8B8wkaF0=;
        b=XOyq/hOpaM8SFEeLc2i/ZJNmFV8x6n66YcKZE2GZIGtdj5zxHMC6g2SOgudJ4+fZ8h
         nZbhJ/kN1HwORDYtYdsoPyEYbVf23TRKqu5FYSP2ZazSRUBKekkGRd4kdk/awn5igQ1b
         zRbp90njgUwVUvHLjJjw1VUI0PSgwJx2yKIq6pzmwo0CZ0h41Is+JoQ2NFOjUSKN7ddg
         2GEubtihnZjS3H6yCF/eDUnSwwvtRfp9CMO8gnycmk2HCWoaHaTwjTKz2lKM5XQW5Ijt
         Cp/V+iKSJYRw6t+f3yeVYB1hJkUg77nYhVIA3BADg2m1Rh/JyQG9mvHJtmL//kiubREW
         5pNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687628597; x=1690220597;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cbsgyJj8b56jpRAu2aJb3zjkuNeKq4dUo/g8B8wkaF0=;
        b=HBXdaS+LB/zChSFIvXnxVixkQLGwhKr/s2t4byR0vbsETKsVsZSTTs2uUehyYNmgPO
         +zBI8/jLcb9yO5s+FP7VXUgAmRKBih4LL66ohBOUuDPPZj9usvDI5Bpms/G0O3yt6WhN
         feAN2j5gEBrmoADcdxpLzcB+VXlm+cjt7yiNpNv3ggpeIDyWlm9shqFv52THGzubRaK1
         ZbOWrbDpqcODZ+vzgACM50XltUC7s9Kkdj+gIaj+o0fbrvQvDtPAqNiIYYSBOax4pyiG
         eTnqqnjphZix37/vHmAgTG6mvO/2NLhtSr66NILu2+ErFf6mZiL5rThJ1mL5utjZoF01
         JIfg==
X-Gm-Message-State: AC+VfDyT+mXS83KPYTdIDcb1LSC3z+OycCMTgOB+MnbGTGUNVBq32xU/
        PKwt2Ob5UJ3E7hhsIwotEviCFA==
X-Google-Smtp-Source: ACHHUZ5H7hPQWwMqXf2hx68EQXiiQZxhhcXxw3MPT5pLhxKkCEnfSo/f+IE4+5mJ6cAP66+MRBOCFw==
X-Received: by 2002:a05:600c:3797:b0:3fa:838a:1dcf with SMTP id o23-20020a05600c379700b003fa838a1dcfmr1426420wmr.6.1687628597127;
        Sat, 24 Jun 2023 10:43:17 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.217.150])
        by smtp.gmail.com with ESMTPSA id p9-20020a05600c204900b003f93c450657sm2686567wmg.38.2023.06.24.10.43.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 24 Jun 2023 10:43:16 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Roman Bolshakov <rbolshakov@ddn.com>, qemu-arm@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Alexander Graf <agraf@csgraf.de>,
        xen-devel@lists.xenproject.org,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Paul Durrant <paul@xen.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Cameron Esfahani <dirty@apple.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 15/16] accel: Rename 'cpu_state' -> 'cs'
Date:   Sat, 24 Jun 2023 19:41:20 +0200
Message-Id: <20230624174121.11508-16-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230624174121.11508-1-philmd@linaro.org>
References: <20230624174121.11508-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Most of the codebase uses 'CPUState *cpu' or 'CPUState *cs'.
While 'cpu_state' is kind of explicit, it makes the code
harder to review. Simply rename as 'cs'.

Acked-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/hvf/x86hvf.h |  18 +-
 target/i386/hvf/x86hvf.c | 372 +++++++++++++++++++--------------------
 2 files changed, 195 insertions(+), 195 deletions(-)

diff --git a/target/i386/hvf/x86hvf.h b/target/i386/hvf/x86hvf.h
index db6003d6bd..423a89b6ad 100644
--- a/target/i386/hvf/x86hvf.h
+++ b/target/i386/hvf/x86hvf.h
@@ -20,15 +20,15 @@
 #include "cpu.h"
 #include "x86_descr.h"
 
-int hvf_process_events(CPUState *);
-bool hvf_inject_interrupts(CPUState *);
-void hvf_set_segment(struct CPUState *cpu, struct vmx_segment *vmx_seg,
+int hvf_process_events(CPUState *cs);
+bool hvf_inject_interrupts(CPUState *cs);
+void hvf_set_segment(CPUState *cs, struct vmx_segment *vmx_seg,
                      SegmentCache *qseg, bool is_tr);
 void hvf_get_segment(SegmentCache *qseg, struct vmx_segment *vmx_seg);
-void hvf_put_xsave(CPUState *cpu_state);
-void hvf_put_msrs(CPUState *cpu_state);
-void hvf_get_xsave(CPUState *cpu_state);
-void hvf_get_msrs(CPUState *cpu_state);
-void vmx_clear_int_window_exiting(CPUState *cpu);
-void vmx_update_tpr(CPUState *cpu);
+void hvf_put_xsave(CPUState *cs);
+void hvf_put_msrs(CPUState *cs);
+void hvf_get_xsave(CPUState *cs);
+void hvf_get_msrs(CPUState *cs);
+void vmx_clear_int_window_exiting(CPUState *cs);
+void vmx_update_tpr(CPUState *cs);
 #endif
diff --git a/target/i386/hvf/x86hvf.c b/target/i386/hvf/x86hvf.c
index 69d4fb8cf5..92dfd26a01 100644
--- a/target/i386/hvf/x86hvf.c
+++ b/target/i386/hvf/x86hvf.c
@@ -32,14 +32,14 @@
 #include <Hypervisor/hv.h>
 #include <Hypervisor/hv_vmx.h>
 
-void hvf_set_segment(struct CPUState *cpu, struct vmx_segment *vmx_seg,
+void hvf_set_segment(CPUState *cs, struct vmx_segment *vmx_seg,
                      SegmentCache *qseg, bool is_tr)
 {
     vmx_seg->sel = qseg->selector;
     vmx_seg->base = qseg->base;
     vmx_seg->limit = qseg->limit;
 
-    if (!qseg->selector && !x86_is_real(cpu) && !is_tr) {
+    if (!qseg->selector && !x86_is_real(cs) && !is_tr) {
         /* the TR register is usable after processor reset despite
          * having a null selector */
         vmx_seg->ar = 1 << 16;
@@ -70,279 +70,279 @@ void hvf_get_segment(SegmentCache *qseg, struct vmx_segment *vmx_seg)
                   (((vmx_seg->ar >> 15) & 1) << DESC_G_SHIFT);
 }
 
-void hvf_put_xsave(CPUState *cpu_state)
+void hvf_put_xsave(CPUState *cs)
 {
-    void *xsave = X86_CPU(cpu_state)->env.xsave_buf;
-    uint32_t xsave_len = X86_CPU(cpu_state)->env.xsave_buf_len;
+    void *xsave = X86_CPU(cs)->env.xsave_buf;
+    uint32_t xsave_len = X86_CPU(cs)->env.xsave_buf_len;
 
-    x86_cpu_xsave_all_areas(X86_CPU(cpu_state), xsave, xsave_len);
+    x86_cpu_xsave_all_areas(X86_CPU(cs), xsave, xsave_len);
 
-    if (hv_vcpu_write_fpstate(cpu_state->hvf->fd, xsave, xsave_len)) {
+    if (hv_vcpu_write_fpstate(cs->hvf->fd, xsave, xsave_len)) {
         abort();
     }
 }
 
-static void hvf_put_segments(CPUState *cpu_state)
+static void hvf_put_segments(CPUState *cs)
 {
-    CPUX86State *env = &X86_CPU(cpu_state)->env;
+    CPUX86State *env = &X86_CPU(cs)->env;
     struct vmx_segment seg;
     
-    wvmcs(cpu_state->hvf->fd, VMCS_GUEST_IDTR_LIMIT, env->idt.limit);
-    wvmcs(cpu_state->hvf->fd, VMCS_GUEST_IDTR_BASE, env->idt.base);
+    wvmcs(cs->hvf->fd, VMCS_GUEST_IDTR_LIMIT, env->idt.limit);
+    wvmcs(cs->hvf->fd, VMCS_GUEST_IDTR_BASE, env->idt.base);
 
-    wvmcs(cpu_state->hvf->fd, VMCS_GUEST_GDTR_LIMIT, env->gdt.limit);
-    wvmcs(cpu_state->hvf->fd, VMCS_GUEST_GDTR_BASE, env->gdt.base);
+    wvmcs(cs->hvf->fd, VMCS_GUEST_GDTR_LIMIT, env->gdt.limit);
+    wvmcs(cs->hvf->fd, VMCS_GUEST_GDTR_BASE, env->gdt.base);
 
-    /* wvmcs(cpu_state->hvf->fd, VMCS_GUEST_CR2, env->cr[2]); */
-    wvmcs(cpu_state->hvf->fd, VMCS_GUEST_CR3, env->cr[3]);
-    vmx_update_tpr(cpu_state);
-    wvmcs(cpu_state->hvf->fd, VMCS_GUEST_IA32_EFER, env->efer);
+    /* wvmcs(cs->hvf->fd, VMCS_GUEST_CR2, env->cr[2]); */
+    wvmcs(cs->hvf->fd, VMCS_GUEST_CR3, env->cr[3]);
+    vmx_update_tpr(cs);
+    wvmcs(cs->hvf->fd, VMCS_GUEST_IA32_EFER, env->efer);
 
-    macvm_set_cr4(cpu_state->hvf->fd, env->cr[4]);
-    macvm_set_cr0(cpu_state->hvf->fd, env->cr[0]);
+    macvm_set_cr4(cs->hvf->fd, env->cr[4]);
+    macvm_set_cr0(cs->hvf->fd, env->cr[0]);
 
-    hvf_set_segment(cpu_state, &seg, &env->segs[R_CS], false);
-    vmx_write_segment_descriptor(cpu_state, &seg, R_CS);
+    hvf_set_segment(cs, &seg, &env->segs[R_CS], false);
+    vmx_write_segment_descriptor(cs, &seg, R_CS);
     
-    hvf_set_segment(cpu_state, &seg, &env->segs[R_DS], false);
-    vmx_write_segment_descriptor(cpu_state, &seg, R_DS);
+    hvf_set_segment(cs, &seg, &env->segs[R_DS], false);
+    vmx_write_segment_descriptor(cs, &seg, R_DS);
 
-    hvf_set_segment(cpu_state, &seg, &env->segs[R_ES], false);
-    vmx_write_segment_descriptor(cpu_state, &seg, R_ES);
+    hvf_set_segment(cs, &seg, &env->segs[R_ES], false);
+    vmx_write_segment_descriptor(cs, &seg, R_ES);
 
-    hvf_set_segment(cpu_state, &seg, &env->segs[R_SS], false);
-    vmx_write_segment_descriptor(cpu_state, &seg, R_SS);
+    hvf_set_segment(cs, &seg, &env->segs[R_SS], false);
+    vmx_write_segment_descriptor(cs, &seg, R_SS);
 
-    hvf_set_segment(cpu_state, &seg, &env->segs[R_FS], false);
-    vmx_write_segment_descriptor(cpu_state, &seg, R_FS);
+    hvf_set_segment(cs, &seg, &env->segs[R_FS], false);
+    vmx_write_segment_descriptor(cs, &seg, R_FS);
 
-    hvf_set_segment(cpu_state, &seg, &env->segs[R_GS], false);
-    vmx_write_segment_descriptor(cpu_state, &seg, R_GS);
+    hvf_set_segment(cs, &seg, &env->segs[R_GS], false);
+    vmx_write_segment_descriptor(cs, &seg, R_GS);
 
-    hvf_set_segment(cpu_state, &seg, &env->tr, true);
-    vmx_write_segment_descriptor(cpu_state, &seg, R_TR);
+    hvf_set_segment(cs, &seg, &env->tr, true);
+    vmx_write_segment_descriptor(cs, &seg, R_TR);
 
-    hvf_set_segment(cpu_state, &seg, &env->ldt, false);
-    vmx_write_segment_descriptor(cpu_state, &seg, R_LDTR);
+    hvf_set_segment(cs, &seg, &env->ldt, false);
+    vmx_write_segment_descriptor(cs, &seg, R_LDTR);
 }
     
-void hvf_put_msrs(CPUState *cpu_state)
+void hvf_put_msrs(CPUState *cs)
 {
-    CPUX86State *env = &X86_CPU(cpu_state)->env;
+    CPUX86State *env = &X86_CPU(cs)->env;
 
-    hv_vcpu_write_msr(cpu_state->hvf->fd, MSR_IA32_SYSENTER_CS,
+    hv_vcpu_write_msr(cs->hvf->fd, MSR_IA32_SYSENTER_CS,
                       env->sysenter_cs);
-    hv_vcpu_write_msr(cpu_state->hvf->fd, MSR_IA32_SYSENTER_ESP,
+    hv_vcpu_write_msr(cs->hvf->fd, MSR_IA32_SYSENTER_ESP,
                       env->sysenter_esp);
-    hv_vcpu_write_msr(cpu_state->hvf->fd, MSR_IA32_SYSENTER_EIP,
+    hv_vcpu_write_msr(cs->hvf->fd, MSR_IA32_SYSENTER_EIP,
                       env->sysenter_eip);
 
-    hv_vcpu_write_msr(cpu_state->hvf->fd, MSR_STAR, env->star);
+    hv_vcpu_write_msr(cs->hvf->fd, MSR_STAR, env->star);
 
 #ifdef TARGET_X86_64
-    hv_vcpu_write_msr(cpu_state->hvf->fd, MSR_CSTAR, env->cstar);
-    hv_vcpu_write_msr(cpu_state->hvf->fd, MSR_KERNELGSBASE, env->kernelgsbase);
-    hv_vcpu_write_msr(cpu_state->hvf->fd, MSR_FMASK, env->fmask);
-    hv_vcpu_write_msr(cpu_state->hvf->fd, MSR_LSTAR, env->lstar);
+    hv_vcpu_write_msr(cs->hvf->fd, MSR_CSTAR, env->cstar);
+    hv_vcpu_write_msr(cs->hvf->fd, MSR_KERNELGSBASE, env->kernelgsbase);
+    hv_vcpu_write_msr(cs->hvf->fd, MSR_FMASK, env->fmask);
+    hv_vcpu_write_msr(cs->hvf->fd, MSR_LSTAR, env->lstar);
 #endif
 
-    hv_vcpu_write_msr(cpu_state->hvf->fd, MSR_GSBASE, env->segs[R_GS].base);
-    hv_vcpu_write_msr(cpu_state->hvf->fd, MSR_FSBASE, env->segs[R_FS].base);
+    hv_vcpu_write_msr(cs->hvf->fd, MSR_GSBASE, env->segs[R_GS].base);
+    hv_vcpu_write_msr(cs->hvf->fd, MSR_FSBASE, env->segs[R_FS].base);
 }
 
 
-void hvf_get_xsave(CPUState *cpu_state)
+void hvf_get_xsave(CPUState *cs)
 {
-    void *xsave = X86_CPU(cpu_state)->env.xsave_buf;
-    uint32_t xsave_len = X86_CPU(cpu_state)->env.xsave_buf_len;
+    void *xsave = X86_CPU(cs)->env.xsave_buf;
+    uint32_t xsave_len = X86_CPU(cs)->env.xsave_buf_len;
 
-    if (hv_vcpu_read_fpstate(cpu_state->hvf->fd, xsave, xsave_len)) {
+    if (hv_vcpu_read_fpstate(cs->hvf->fd, xsave, xsave_len)) {
         abort();
     }
 
-    x86_cpu_xrstor_all_areas(X86_CPU(cpu_state), xsave, xsave_len);
+    x86_cpu_xrstor_all_areas(X86_CPU(cs), xsave, xsave_len);
 }
 
-static void hvf_get_segments(CPUState *cpu_state)
+static void hvf_get_segments(CPUState *cs)
 {
-    CPUX86State *env = &X86_CPU(cpu_state)->env;
+    CPUX86State *env = &X86_CPU(cs)->env;
 
     struct vmx_segment seg;
 
     env->interrupt_injected = -1;
 
-    vmx_read_segment_descriptor(cpu_state, &seg, R_CS);
+    vmx_read_segment_descriptor(cs, &seg, R_CS);
     hvf_get_segment(&env->segs[R_CS], &seg);
     
-    vmx_read_segment_descriptor(cpu_state, &seg, R_DS);
+    vmx_read_segment_descriptor(cs, &seg, R_DS);
     hvf_get_segment(&env->segs[R_DS], &seg);
 
-    vmx_read_segment_descriptor(cpu_state, &seg, R_ES);
+    vmx_read_segment_descriptor(cs, &seg, R_ES);
     hvf_get_segment(&env->segs[R_ES], &seg);
 
-    vmx_read_segment_descriptor(cpu_state, &seg, R_FS);
+    vmx_read_segment_descriptor(cs, &seg, R_FS);
     hvf_get_segment(&env->segs[R_FS], &seg);
 
-    vmx_read_segment_descriptor(cpu_state, &seg, R_GS);
+    vmx_read_segment_descriptor(cs, &seg, R_GS);
     hvf_get_segment(&env->segs[R_GS], &seg);
 
-    vmx_read_segment_descriptor(cpu_state, &seg, R_SS);
+    vmx_read_segment_descriptor(cs, &seg, R_SS);
     hvf_get_segment(&env->segs[R_SS], &seg);
 
-    vmx_read_segment_descriptor(cpu_state, &seg, R_TR);
+    vmx_read_segment_descriptor(cs, &seg, R_TR);
     hvf_get_segment(&env->tr, &seg);
 
-    vmx_read_segment_descriptor(cpu_state, &seg, R_LDTR);
+    vmx_read_segment_descriptor(cs, &seg, R_LDTR);
     hvf_get_segment(&env->ldt, &seg);
 
-    env->idt.limit = rvmcs(cpu_state->hvf->fd, VMCS_GUEST_IDTR_LIMIT);
-    env->idt.base = rvmcs(cpu_state->hvf->fd, VMCS_GUEST_IDTR_BASE);
-    env->gdt.limit = rvmcs(cpu_state->hvf->fd, VMCS_GUEST_GDTR_LIMIT);
-    env->gdt.base = rvmcs(cpu_state->hvf->fd, VMCS_GUEST_GDTR_BASE);
+    env->idt.limit = rvmcs(cs->hvf->fd, VMCS_GUEST_IDTR_LIMIT);
+    env->idt.base = rvmcs(cs->hvf->fd, VMCS_GUEST_IDTR_BASE);
+    env->gdt.limit = rvmcs(cs->hvf->fd, VMCS_GUEST_GDTR_LIMIT);
+    env->gdt.base = rvmcs(cs->hvf->fd, VMCS_GUEST_GDTR_BASE);
 
-    env->cr[0] = rvmcs(cpu_state->hvf->fd, VMCS_GUEST_CR0);
+    env->cr[0] = rvmcs(cs->hvf->fd, VMCS_GUEST_CR0);
     env->cr[2] = 0;
-    env->cr[3] = rvmcs(cpu_state->hvf->fd, VMCS_GUEST_CR3);
-    env->cr[4] = rvmcs(cpu_state->hvf->fd, VMCS_GUEST_CR4);
+    env->cr[3] = rvmcs(cs->hvf->fd, VMCS_GUEST_CR3);
+    env->cr[4] = rvmcs(cs->hvf->fd, VMCS_GUEST_CR4);
     
-    env->efer = rvmcs(cpu_state->hvf->fd, VMCS_GUEST_IA32_EFER);
+    env->efer = rvmcs(cs->hvf->fd, VMCS_GUEST_IA32_EFER);
 }
 
-void hvf_get_msrs(CPUState *cpu_state)
+void hvf_get_msrs(CPUState *cs)
 {
-    CPUX86State *env = &X86_CPU(cpu_state)->env;
+    CPUX86State *env = &X86_CPU(cs)->env;
     uint64_t tmp;
     
-    hv_vcpu_read_msr(cpu_state->hvf->fd, MSR_IA32_SYSENTER_CS, &tmp);
+    hv_vcpu_read_msr(cs->hvf->fd, MSR_IA32_SYSENTER_CS, &tmp);
     env->sysenter_cs = tmp;
     
-    hv_vcpu_read_msr(cpu_state->hvf->fd, MSR_IA32_SYSENTER_ESP, &tmp);
+    hv_vcpu_read_msr(cs->hvf->fd, MSR_IA32_SYSENTER_ESP, &tmp);
     env->sysenter_esp = tmp;
 
-    hv_vcpu_read_msr(cpu_state->hvf->fd, MSR_IA32_SYSENTER_EIP, &tmp);
+    hv_vcpu_read_msr(cs->hvf->fd, MSR_IA32_SYSENTER_EIP, &tmp);
     env->sysenter_eip = tmp;
 
-    hv_vcpu_read_msr(cpu_state->hvf->fd, MSR_STAR, &env->star);
+    hv_vcpu_read_msr(cs->hvf->fd, MSR_STAR, &env->star);
 
 #ifdef TARGET_X86_64
-    hv_vcpu_read_msr(cpu_state->hvf->fd, MSR_CSTAR, &env->cstar);
-    hv_vcpu_read_msr(cpu_state->hvf->fd, MSR_KERNELGSBASE, &env->kernelgsbase);
-    hv_vcpu_read_msr(cpu_state->hvf->fd, MSR_FMASK, &env->fmask);
-    hv_vcpu_read_msr(cpu_state->hvf->fd, MSR_LSTAR, &env->lstar);
+    hv_vcpu_read_msr(cs->hvf->fd, MSR_CSTAR, &env->cstar);
+    hv_vcpu_read_msr(cs->hvf->fd, MSR_KERNELGSBASE, &env->kernelgsbase);
+    hv_vcpu_read_msr(cs->hvf->fd, MSR_FMASK, &env->fmask);
+    hv_vcpu_read_msr(cs->hvf->fd, MSR_LSTAR, &env->lstar);
 #endif
 
-    hv_vcpu_read_msr(cpu_state->hvf->fd, MSR_IA32_APICBASE, &tmp);
+    hv_vcpu_read_msr(cs->hvf->fd, MSR_IA32_APICBASE, &tmp);
     
-    env->tsc = rdtscp() + rvmcs(cpu_state->hvf->fd, VMCS_TSC_OFFSET);
+    env->tsc = rdtscp() + rvmcs(cs->hvf->fd, VMCS_TSC_OFFSET);
 }
 
-int hvf_put_registers(CPUState *cpu_state)
+int hvf_put_registers(CPUState *cs)
 {
-    X86CPU *x86cpu = X86_CPU(cpu_state);
+    X86CPU *x86cpu = X86_CPU(cs);
     CPUX86State *env = &x86cpu->env;
 
-    wreg(cpu_state->hvf->fd, HV_X86_RAX, env->regs[R_EAX]);
-    wreg(cpu_state->hvf->fd, HV_X86_RBX, env->regs[R_EBX]);
-    wreg(cpu_state->hvf->fd, HV_X86_RCX, env->regs[R_ECX]);
-    wreg(cpu_state->hvf->fd, HV_X86_RDX, env->regs[R_EDX]);
-    wreg(cpu_state->hvf->fd, HV_X86_RBP, env->regs[R_EBP]);
-    wreg(cpu_state->hvf->fd, HV_X86_RSP, env->regs[R_ESP]);
-    wreg(cpu_state->hvf->fd, HV_X86_RSI, env->regs[R_ESI]);
-    wreg(cpu_state->hvf->fd, HV_X86_RDI, env->regs[R_EDI]);
-    wreg(cpu_state->hvf->fd, HV_X86_R8, env->regs[8]);
-    wreg(cpu_state->hvf->fd, HV_X86_R9, env->regs[9]);
-    wreg(cpu_state->hvf->fd, HV_X86_R10, env->regs[10]);
-    wreg(cpu_state->hvf->fd, HV_X86_R11, env->regs[11]);
-    wreg(cpu_state->hvf->fd, HV_X86_R12, env->regs[12]);
-    wreg(cpu_state->hvf->fd, HV_X86_R13, env->regs[13]);
-    wreg(cpu_state->hvf->fd, HV_X86_R14, env->regs[14]);
-    wreg(cpu_state->hvf->fd, HV_X86_R15, env->regs[15]);
-    wreg(cpu_state->hvf->fd, HV_X86_RFLAGS, env->eflags);
-    wreg(cpu_state->hvf->fd, HV_X86_RIP, env->eip);
+    wreg(cs->hvf->fd, HV_X86_RAX, env->regs[R_EAX]);
+    wreg(cs->hvf->fd, HV_X86_RBX, env->regs[R_EBX]);
+    wreg(cs->hvf->fd, HV_X86_RCX, env->regs[R_ECX]);
+    wreg(cs->hvf->fd, HV_X86_RDX, env->regs[R_EDX]);
+    wreg(cs->hvf->fd, HV_X86_RBP, env->regs[R_EBP]);
+    wreg(cs->hvf->fd, HV_X86_RSP, env->regs[R_ESP]);
+    wreg(cs->hvf->fd, HV_X86_RSI, env->regs[R_ESI]);
+    wreg(cs->hvf->fd, HV_X86_RDI, env->regs[R_EDI]);
+    wreg(cs->hvf->fd, HV_X86_R8, env->regs[8]);
+    wreg(cs->hvf->fd, HV_X86_R9, env->regs[9]);
+    wreg(cs->hvf->fd, HV_X86_R10, env->regs[10]);
+    wreg(cs->hvf->fd, HV_X86_R11, env->regs[11]);
+    wreg(cs->hvf->fd, HV_X86_R12, env->regs[12]);
+    wreg(cs->hvf->fd, HV_X86_R13, env->regs[13]);
+    wreg(cs->hvf->fd, HV_X86_R14, env->regs[14]);
+    wreg(cs->hvf->fd, HV_X86_R15, env->regs[15]);
+    wreg(cs->hvf->fd, HV_X86_RFLAGS, env->eflags);
+    wreg(cs->hvf->fd, HV_X86_RIP, env->eip);
    
-    wreg(cpu_state->hvf->fd, HV_X86_XCR0, env->xcr0);
+    wreg(cs->hvf->fd, HV_X86_XCR0, env->xcr0);
     
-    hvf_put_xsave(cpu_state);
+    hvf_put_xsave(cs);
     
-    hvf_put_segments(cpu_state);
+    hvf_put_segments(cs);
     
-    hvf_put_msrs(cpu_state);
+    hvf_put_msrs(cs);
     
-    wreg(cpu_state->hvf->fd, HV_X86_DR0, env->dr[0]);
-    wreg(cpu_state->hvf->fd, HV_X86_DR1, env->dr[1]);
-    wreg(cpu_state->hvf->fd, HV_X86_DR2, env->dr[2]);
-    wreg(cpu_state->hvf->fd, HV_X86_DR3, env->dr[3]);
-    wreg(cpu_state->hvf->fd, HV_X86_DR4, env->dr[4]);
-    wreg(cpu_state->hvf->fd, HV_X86_DR5, env->dr[5]);
-    wreg(cpu_state->hvf->fd, HV_X86_DR6, env->dr[6]);
-    wreg(cpu_state->hvf->fd, HV_X86_DR7, env->dr[7]);
+    wreg(cs->hvf->fd, HV_X86_DR0, env->dr[0]);
+    wreg(cs->hvf->fd, HV_X86_DR1, env->dr[1]);
+    wreg(cs->hvf->fd, HV_X86_DR2, env->dr[2]);
+    wreg(cs->hvf->fd, HV_X86_DR3, env->dr[3]);
+    wreg(cs->hvf->fd, HV_X86_DR4, env->dr[4]);
+    wreg(cs->hvf->fd, HV_X86_DR5, env->dr[5]);
+    wreg(cs->hvf->fd, HV_X86_DR6, env->dr[6]);
+    wreg(cs->hvf->fd, HV_X86_DR7, env->dr[7]);
     
     return 0;
 }
 
-int hvf_get_registers(CPUState *cpu_state)
+int hvf_get_registers(CPUState *cs)
 {
-    X86CPU *x86cpu = X86_CPU(cpu_state);
+    X86CPU *x86cpu = X86_CPU(cs);
     CPUX86State *env = &x86cpu->env;
 
-    env->regs[R_EAX] = rreg(cpu_state->hvf->fd, HV_X86_RAX);
-    env->regs[R_EBX] = rreg(cpu_state->hvf->fd, HV_X86_RBX);
-    env->regs[R_ECX] = rreg(cpu_state->hvf->fd, HV_X86_RCX);
-    env->regs[R_EDX] = rreg(cpu_state->hvf->fd, HV_X86_RDX);
-    env->regs[R_EBP] = rreg(cpu_state->hvf->fd, HV_X86_RBP);
-    env->regs[R_ESP] = rreg(cpu_state->hvf->fd, HV_X86_RSP);
-    env->regs[R_ESI] = rreg(cpu_state->hvf->fd, HV_X86_RSI);
-    env->regs[R_EDI] = rreg(cpu_state->hvf->fd, HV_X86_RDI);
-    env->regs[8] = rreg(cpu_state->hvf->fd, HV_X86_R8);
-    env->regs[9] = rreg(cpu_state->hvf->fd, HV_X86_R9);
-    env->regs[10] = rreg(cpu_state->hvf->fd, HV_X86_R10);
-    env->regs[11] = rreg(cpu_state->hvf->fd, HV_X86_R11);
-    env->regs[12] = rreg(cpu_state->hvf->fd, HV_X86_R12);
-    env->regs[13] = rreg(cpu_state->hvf->fd, HV_X86_R13);
-    env->regs[14] = rreg(cpu_state->hvf->fd, HV_X86_R14);
-    env->regs[15] = rreg(cpu_state->hvf->fd, HV_X86_R15);
+    env->regs[R_EAX] = rreg(cs->hvf->fd, HV_X86_RAX);
+    env->regs[R_EBX] = rreg(cs->hvf->fd, HV_X86_RBX);
+    env->regs[R_ECX] = rreg(cs->hvf->fd, HV_X86_RCX);
+    env->regs[R_EDX] = rreg(cs->hvf->fd, HV_X86_RDX);
+    env->regs[R_EBP] = rreg(cs->hvf->fd, HV_X86_RBP);
+    env->regs[R_ESP] = rreg(cs->hvf->fd, HV_X86_RSP);
+    env->regs[R_ESI] = rreg(cs->hvf->fd, HV_X86_RSI);
+    env->regs[R_EDI] = rreg(cs->hvf->fd, HV_X86_RDI);
+    env->regs[8] = rreg(cs->hvf->fd, HV_X86_R8);
+    env->regs[9] = rreg(cs->hvf->fd, HV_X86_R9);
+    env->regs[10] = rreg(cs->hvf->fd, HV_X86_R10);
+    env->regs[11] = rreg(cs->hvf->fd, HV_X86_R11);
+    env->regs[12] = rreg(cs->hvf->fd, HV_X86_R12);
+    env->regs[13] = rreg(cs->hvf->fd, HV_X86_R13);
+    env->regs[14] = rreg(cs->hvf->fd, HV_X86_R14);
+    env->regs[15] = rreg(cs->hvf->fd, HV_X86_R15);
     
-    env->eflags = rreg(cpu_state->hvf->fd, HV_X86_RFLAGS);
-    env->eip = rreg(cpu_state->hvf->fd, HV_X86_RIP);
+    env->eflags = rreg(cs->hvf->fd, HV_X86_RFLAGS);
+    env->eip = rreg(cs->hvf->fd, HV_X86_RIP);
    
-    hvf_get_xsave(cpu_state);
-    env->xcr0 = rreg(cpu_state->hvf->fd, HV_X86_XCR0);
+    hvf_get_xsave(cs);
+    env->xcr0 = rreg(cs->hvf->fd, HV_X86_XCR0);
     
-    hvf_get_segments(cpu_state);
-    hvf_get_msrs(cpu_state);
+    hvf_get_segments(cs);
+    hvf_get_msrs(cs);
     
-    env->dr[0] = rreg(cpu_state->hvf->fd, HV_X86_DR0);
-    env->dr[1] = rreg(cpu_state->hvf->fd, HV_X86_DR1);
-    env->dr[2] = rreg(cpu_state->hvf->fd, HV_X86_DR2);
-    env->dr[3] = rreg(cpu_state->hvf->fd, HV_X86_DR3);
-    env->dr[4] = rreg(cpu_state->hvf->fd, HV_X86_DR4);
-    env->dr[5] = rreg(cpu_state->hvf->fd, HV_X86_DR5);
-    env->dr[6] = rreg(cpu_state->hvf->fd, HV_X86_DR6);
-    env->dr[7] = rreg(cpu_state->hvf->fd, HV_X86_DR7);
+    env->dr[0] = rreg(cs->hvf->fd, HV_X86_DR0);
+    env->dr[1] = rreg(cs->hvf->fd, HV_X86_DR1);
+    env->dr[2] = rreg(cs->hvf->fd, HV_X86_DR2);
+    env->dr[3] = rreg(cs->hvf->fd, HV_X86_DR3);
+    env->dr[4] = rreg(cs->hvf->fd, HV_X86_DR4);
+    env->dr[5] = rreg(cs->hvf->fd, HV_X86_DR5);
+    env->dr[6] = rreg(cs->hvf->fd, HV_X86_DR6);
+    env->dr[7] = rreg(cs->hvf->fd, HV_X86_DR7);
     
     x86_update_hflags(env);
     return 0;
 }
 
-static void vmx_set_int_window_exiting(CPUState *cpu)
+static void vmx_set_int_window_exiting(CPUState *cs)
 {
      uint64_t val;
-     val = rvmcs(cpu->hvf->fd, VMCS_PRI_PROC_BASED_CTLS);
-     wvmcs(cpu->hvf->fd, VMCS_PRI_PROC_BASED_CTLS, val |
+     val = rvmcs(cs->hvf->fd, VMCS_PRI_PROC_BASED_CTLS);
+     wvmcs(cs->hvf->fd, VMCS_PRI_PROC_BASED_CTLS, val |
              VMCS_PRI_PROC_BASED_CTLS_INT_WINDOW_EXITING);
 }
 
-void vmx_clear_int_window_exiting(CPUState *cpu)
+void vmx_clear_int_window_exiting(CPUState *cs)
 {
      uint64_t val;
-     val = rvmcs(cpu->hvf->fd, VMCS_PRI_PROC_BASED_CTLS);
-     wvmcs(cpu->hvf->fd, VMCS_PRI_PROC_BASED_CTLS, val &
+     val = rvmcs(cs->hvf->fd, VMCS_PRI_PROC_BASED_CTLS);
+     wvmcs(cs->hvf->fd, VMCS_PRI_PROC_BASED_CTLS, val &
              ~VMCS_PRI_PROC_BASED_CTLS_INT_WINDOW_EXITING);
 }
 
-bool hvf_inject_interrupts(CPUState *cpu_state)
+bool hvf_inject_interrupts(CPUState *cs)
 {
-    X86CPU *x86cpu = X86_CPU(cpu_state);
+    X86CPU *x86cpu = X86_CPU(cs);
     CPUX86State *env = &x86cpu->env;
 
     uint8_t vector;
@@ -372,89 +372,89 @@ bool hvf_inject_interrupts(CPUState *cpu_state)
     uint64_t info = 0;
     if (have_event) {
         info = vector | intr_type | VMCS_INTR_VALID;
-        uint64_t reason = rvmcs(cpu_state->hvf->fd, VMCS_EXIT_REASON);
+        uint64_t reason = rvmcs(cs->hvf->fd, VMCS_EXIT_REASON);
         if (env->nmi_injected && reason != EXIT_REASON_TASK_SWITCH) {
-            vmx_clear_nmi_blocking(cpu_state);
+            vmx_clear_nmi_blocking(cs);
         }
 
         if (!(env->hflags2 & HF2_NMI_MASK) || intr_type != VMCS_INTR_T_NMI) {
             info &= ~(1 << 12); /* clear undefined bit */
             if (intr_type == VMCS_INTR_T_SWINTR ||
                 intr_type == VMCS_INTR_T_SWEXCEPTION) {
-                wvmcs(cpu_state->hvf->fd, VMCS_ENTRY_INST_LENGTH, env->ins_len);
+                wvmcs(cs->hvf->fd, VMCS_ENTRY_INST_LENGTH, env->ins_len);
             }
             
             if (env->has_error_code) {
-                wvmcs(cpu_state->hvf->fd, VMCS_ENTRY_EXCEPTION_ERROR,
+                wvmcs(cs->hvf->fd, VMCS_ENTRY_EXCEPTION_ERROR,
                       env->error_code);
                 /* Indicate that VMCS_ENTRY_EXCEPTION_ERROR is valid */
                 info |= VMCS_INTR_DEL_ERRCODE;
             }
             /*printf("reinject  %lx err %d\n", info, err);*/
-            wvmcs(cpu_state->hvf->fd, VMCS_ENTRY_INTR_INFO, info);
+            wvmcs(cs->hvf->fd, VMCS_ENTRY_INTR_INFO, info);
         };
     }
 
-    if (cpu_state->interrupt_request & CPU_INTERRUPT_NMI) {
+    if (cs->interrupt_request & CPU_INTERRUPT_NMI) {
         if (!(env->hflags2 & HF2_NMI_MASK) && !(info & VMCS_INTR_VALID)) {
-            cpu_state->interrupt_request &= ~CPU_INTERRUPT_NMI;
+            cs->interrupt_request &= ~CPU_INTERRUPT_NMI;
             info = VMCS_INTR_VALID | VMCS_INTR_T_NMI | EXCP02_NMI;
-            wvmcs(cpu_state->hvf->fd, VMCS_ENTRY_INTR_INFO, info);
+            wvmcs(cs->hvf->fd, VMCS_ENTRY_INTR_INFO, info);
         } else {
-            vmx_set_nmi_window_exiting(cpu_state);
+            vmx_set_nmi_window_exiting(cs);
         }
     }
 
     if (!(env->hflags & HF_INHIBIT_IRQ_MASK) &&
-        (cpu_state->interrupt_request & CPU_INTERRUPT_HARD) &&
+        (cs->interrupt_request & CPU_INTERRUPT_HARD) &&
         (env->eflags & IF_MASK) && !(info & VMCS_INTR_VALID)) {
         int line = cpu_get_pic_interrupt(&x86cpu->env);
-        cpu_state->interrupt_request &= ~CPU_INTERRUPT_HARD;
+        cs->interrupt_request &= ~CPU_INTERRUPT_HARD;
         if (line >= 0) {
-            wvmcs(cpu_state->hvf->fd, VMCS_ENTRY_INTR_INFO, line |
+            wvmcs(cs->hvf->fd, VMCS_ENTRY_INTR_INFO, line |
                   VMCS_INTR_VALID | VMCS_INTR_T_HWINTR);
         }
     }
-    if (cpu_state->interrupt_request & CPU_INTERRUPT_HARD) {
-        vmx_set_int_window_exiting(cpu_state);
+    if (cs->interrupt_request & CPU_INTERRUPT_HARD) {
+        vmx_set_int_window_exiting(cs);
     }
-    return (cpu_state->interrupt_request
+    return (cs->interrupt_request
             & (CPU_INTERRUPT_INIT | CPU_INTERRUPT_TPR));
 }
 
-int hvf_process_events(CPUState *cpu_state)
+int hvf_process_events(CPUState *cs)
 {
-    X86CPU *cpu = X86_CPU(cpu_state);
+    X86CPU *cpu = X86_CPU(cs);
     CPUX86State *env = &cpu->env;
 
-    if (!cpu_state->vcpu_dirty) {
+    if (!cs->vcpu_dirty) {
         /* light weight sync for CPU_INTERRUPT_HARD and IF_MASK */
-        env->eflags = rreg(cpu_state->hvf->fd, HV_X86_RFLAGS);
+        env->eflags = rreg(cs->hvf->fd, HV_X86_RFLAGS);
     }
 
-    if (cpu_state->interrupt_request & CPU_INTERRUPT_INIT) {
-        cpu_synchronize_state(cpu_state);
+    if (cs->interrupt_request & CPU_INTERRUPT_INIT) {
+        cpu_synchronize_state(cs);
         do_cpu_init(cpu);
     }
 
-    if (cpu_state->interrupt_request & CPU_INTERRUPT_POLL) {
-        cpu_state->interrupt_request &= ~CPU_INTERRUPT_POLL;
+    if (cs->interrupt_request & CPU_INTERRUPT_POLL) {
+        cs->interrupt_request &= ~CPU_INTERRUPT_POLL;
         apic_poll_irq(cpu->apic_state);
     }
-    if (((cpu_state->interrupt_request & CPU_INTERRUPT_HARD) &&
+    if (((cs->interrupt_request & CPU_INTERRUPT_HARD) &&
         (env->eflags & IF_MASK)) ||
-        (cpu_state->interrupt_request & CPU_INTERRUPT_NMI)) {
-        cpu_state->halted = 0;
+        (cs->interrupt_request & CPU_INTERRUPT_NMI)) {
+        cs->halted = 0;
     }
-    if (cpu_state->interrupt_request & CPU_INTERRUPT_SIPI) {
-        cpu_synchronize_state(cpu_state);
+    if (cs->interrupt_request & CPU_INTERRUPT_SIPI) {
+        cpu_synchronize_state(cs);
         do_cpu_sipi(cpu);
     }
-    if (cpu_state->interrupt_request & CPU_INTERRUPT_TPR) {
-        cpu_state->interrupt_request &= ~CPU_INTERRUPT_TPR;
-        cpu_synchronize_state(cpu_state);
+    if (cs->interrupt_request & CPU_INTERRUPT_TPR) {
+        cs->interrupt_request &= ~CPU_INTERRUPT_TPR;
+        cpu_synchronize_state(cs);
         apic_handle_tpr_access_report(cpu->apic_state, env->eip,
                                       env->tpr_access_type);
     }
-    return cpu_state->halted;
+    return cs->halted;
 }
-- 
2.38.1

