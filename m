Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D33A73A5C4
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 18:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbjFVQLn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 12:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjFVQLl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 12:11:41 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D241FDF
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 09:11:15 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f9b627c1b8so40677465e9.1
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 09:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687450262; x=1690042262;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RRWIGoCMHA30ya/gVErc/hGu4D1zlFhqqYQ3R4zE/Yc=;
        b=t745U20cpkP9y09qTnHT58ACbcd3dw2pT0XOALfU1Ir9cOGrJC0tQQGMi14LHQqH5g
         +xN5iBHjW9n+QXm28fWr9Njb7qWILXh0XWDBRqFfu2YucBT5SwObebrG/GaQlCwELZwt
         DHOfkhf/41MTmSH3goxTxSbaxIpaNwDsJO/1v7YU2KfXKoTDKU99Aucn6p3FVE5QZabF
         W5J2Osfq7F7e/jQ8jW11xKumOyh2OAqf2lWvTWFVINll7FW5xTDmmX7gZ3z8/ay9JBbI
         IYobKh9J0ufzicNgz3Xvyz0Vj59VLsF6FkRFQjVU69hk/lED8ZDxatLaPp3ZFSNJDqds
         EijQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687450262; x=1690042262;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RRWIGoCMHA30ya/gVErc/hGu4D1zlFhqqYQ3R4zE/Yc=;
        b=UDfSgEwkczRoXABBo0A3BWA8Ktt8ijuMYFYYuXEVtcfVdb26aLzMwmF7ENPJ+nIgHm
         Q2vX5lqHdlHa+T9i4FS1ETUbDD3WBTNdCm0fNw2KxQko05OMAwBqePnW4Kpq+MU+giEQ
         mN6SBjDCMn/yvP7J9BlYBykHcAMwFOCjJzeLo+KubJKE/B8FpbONIfSYRXwu0Fm1XCK+
         tCyaAaJFCeG8zUF+xoFcmQFrW5hSEIpByzQI4sVcf4OV+0lMDvThatflrNyJARMiqUH4
         kxfi7/Q2vvsVpGEXXJKfvhkIqD1K4yqrDrpQ4vQ6sOi7hVhw/KeBsBu/O8ZYt+RgUdkR
         mj1g==
X-Gm-Message-State: AC+VfDyAEEmrDJm2FCKik6DV+fyj0h4aLZGFCCkHUUZm9xl95W/X3j/n
        Nj8zKzDqD6ZQQJXf2ZSzvSDMMQ==
X-Google-Smtp-Source: ACHHUZ4IIj48058+XZUHFsrbL5xoZOXXaxhGZj98oO1seM+C5zqlcC7U/H84cpkd7gOVxjdKivvkiw==
X-Received: by 2002:a05:600c:22c6:b0:3f9:b17a:cb61 with SMTP id 6-20020a05600c22c600b003f9b17acb61mr9888330wmg.13.1687450262084;
        Thu, 22 Jun 2023 09:11:02 -0700 (PDT)
Received: from localhost.localdomain (230.red-88-28-3.dynamicip.rima-tde.net. [88.28.3.230])
        by smtp.gmail.com with ESMTPSA id o10-20020a1c750a000000b003f604793989sm5662700wmc.18.2023.06.22.09.10.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 22 Jun 2023 09:11:01 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Reinoud Zandijk <reinoud@netbsd.org>, qemu-arm@nongnu.org,
        kvm@vger.kernel.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Roman Bolshakov <rbolshakov@ddn.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Alexander Graf <agraf@csgraf.de>,
        Richard Henderson <richard.henderson@linaro.org>,
        xen-devel@lists.xenproject.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Cameron Esfahani <dirty@apple.com>
Subject: [PATCH v2 15/16] accel: Rename 'cpu_state' -> 'cpu'
Date:   Thu, 22 Jun 2023 18:08:22 +0200
Message-Id: <20230622160823.71851-16-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230622160823.71851-1-philmd@linaro.org>
References: <20230622160823.71851-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Most of the codebase uses 'CPUState *cpu' or 'CPUState *cs'.
While 'cpu_state' is kind of explicit, it makes the code
harder to review. Simply rename as 'cpu' like the rest.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/hvf/x86hvf.h |  12 +-
 target/i386/hvf/x86hvf.c | 356 +++++++++++++++++++--------------------
 2 files changed, 184 insertions(+), 184 deletions(-)

diff --git a/target/i386/hvf/x86hvf.h b/target/i386/hvf/x86hvf.h
index db6003d6bd..6527eb90d4 100644
--- a/target/i386/hvf/x86hvf.h
+++ b/target/i386/hvf/x86hvf.h
@@ -20,15 +20,15 @@
 #include "cpu.h"
 #include "x86_descr.h"
 
-int hvf_process_events(CPUState *);
-bool hvf_inject_interrupts(CPUState *);
+int hvf_process_events(CPUState *cpu);
+bool hvf_inject_interrupts(CPUState *cpu);
 void hvf_set_segment(struct CPUState *cpu, struct vmx_segment *vmx_seg,
                      SegmentCache *qseg, bool is_tr);
 void hvf_get_segment(SegmentCache *qseg, struct vmx_segment *vmx_seg);
-void hvf_put_xsave(CPUState *cpu_state);
-void hvf_put_msrs(CPUState *cpu_state);
-void hvf_get_xsave(CPUState *cpu_state);
-void hvf_get_msrs(CPUState *cpu_state);
+void hvf_put_xsave(CPUState *cpu);
+void hvf_put_msrs(CPUState *cpu);
+void hvf_get_xsave(CPUState *cpu);
+void hvf_get_msrs(CPUState *cpu);
 void vmx_clear_int_window_exiting(CPUState *cpu);
 void vmx_update_tpr(CPUState *cpu);
 #endif
diff --git a/target/i386/hvf/x86hvf.c b/target/i386/hvf/x86hvf.c
index 69d4fb8cf5..dfa500b81d 100644
--- a/target/i386/hvf/x86hvf.c
+++ b/target/i386/hvf/x86hvf.c
@@ -70,255 +70,255 @@ void hvf_get_segment(SegmentCache *qseg, struct vmx_segment *vmx_seg)
                   (((vmx_seg->ar >> 15) & 1) << DESC_G_SHIFT);
 }
 
-void hvf_put_xsave(CPUState *cpu_state)
+void hvf_put_xsave(CPUState *cpu)
 {
-    void *xsave = X86_CPU(cpu_state)->env.xsave_buf;
-    uint32_t xsave_len = X86_CPU(cpu_state)->env.xsave_buf_len;
+    void *xsave = X86_CPU(cpu)->env.xsave_buf;
+    uint32_t xsave_len = X86_CPU(cpu)->env.xsave_buf_len;
 
-    x86_cpu_xsave_all_areas(X86_CPU(cpu_state), xsave, xsave_len);
+    x86_cpu_xsave_all_areas(X86_CPU(cpu), xsave, xsave_len);
 
-    if (hv_vcpu_write_fpstate(cpu_state->hvf->fd, xsave, xsave_len)) {
+    if (hv_vcpu_write_fpstate(cpu->hvf->fd, xsave, xsave_len)) {
         abort();
     }
 }
 
-static void hvf_put_segments(CPUState *cpu_state)
+static void hvf_put_segments(CPUState *cpu)
 {
-    CPUX86State *env = &X86_CPU(cpu_state)->env;
+    CPUX86State *env = &X86_CPU(cpu)->env;
     struct vmx_segment seg;
     
-    wvmcs(cpu_state->hvf->fd, VMCS_GUEST_IDTR_LIMIT, env->idt.limit);
-    wvmcs(cpu_state->hvf->fd, VMCS_GUEST_IDTR_BASE, env->idt.base);
+    wvmcs(cpu->hvf->fd, VMCS_GUEST_IDTR_LIMIT, env->idt.limit);
+    wvmcs(cpu->hvf->fd, VMCS_GUEST_IDTR_BASE, env->idt.base);
 
-    wvmcs(cpu_state->hvf->fd, VMCS_GUEST_GDTR_LIMIT, env->gdt.limit);
-    wvmcs(cpu_state->hvf->fd, VMCS_GUEST_GDTR_BASE, env->gdt.base);
+    wvmcs(cpu->hvf->fd, VMCS_GUEST_GDTR_LIMIT, env->gdt.limit);
+    wvmcs(cpu->hvf->fd, VMCS_GUEST_GDTR_BASE, env->gdt.base);
 
-    /* wvmcs(cpu_state->hvf->fd, VMCS_GUEST_CR2, env->cr[2]); */
-    wvmcs(cpu_state->hvf->fd, VMCS_GUEST_CR3, env->cr[3]);
-    vmx_update_tpr(cpu_state);
-    wvmcs(cpu_state->hvf->fd, VMCS_GUEST_IA32_EFER, env->efer);
+    /* wvmcs(cpu->hvf->fd, VMCS_GUEST_CR2, env->cr[2]); */
+    wvmcs(cpu->hvf->fd, VMCS_GUEST_CR3, env->cr[3]);
+    vmx_update_tpr(cpu);
+    wvmcs(cpu->hvf->fd, VMCS_GUEST_IA32_EFER, env->efer);
 
-    macvm_set_cr4(cpu_state->hvf->fd, env->cr[4]);
-    macvm_set_cr0(cpu_state->hvf->fd, env->cr[0]);
+    macvm_set_cr4(cpu->hvf->fd, env->cr[4]);
+    macvm_set_cr0(cpu->hvf->fd, env->cr[0]);
 
-    hvf_set_segment(cpu_state, &seg, &env->segs[R_CS], false);
-    vmx_write_segment_descriptor(cpu_state, &seg, R_CS);
+    hvf_set_segment(cpu, &seg, &env->segs[R_CS], false);
+    vmx_write_segment_descriptor(cpu, &seg, R_CS);
     
-    hvf_set_segment(cpu_state, &seg, &env->segs[R_DS], false);
-    vmx_write_segment_descriptor(cpu_state, &seg, R_DS);
+    hvf_set_segment(cpu, &seg, &env->segs[R_DS], false);
+    vmx_write_segment_descriptor(cpu, &seg, R_DS);
 
-    hvf_set_segment(cpu_state, &seg, &env->segs[R_ES], false);
-    vmx_write_segment_descriptor(cpu_state, &seg, R_ES);
+    hvf_set_segment(cpu, &seg, &env->segs[R_ES], false);
+    vmx_write_segment_descriptor(cpu, &seg, R_ES);
 
-    hvf_set_segment(cpu_state, &seg, &env->segs[R_SS], false);
-    vmx_write_segment_descriptor(cpu_state, &seg, R_SS);
+    hvf_set_segment(cpu, &seg, &env->segs[R_SS], false);
+    vmx_write_segment_descriptor(cpu, &seg, R_SS);
 
-    hvf_set_segment(cpu_state, &seg, &env->segs[R_FS], false);
-    vmx_write_segment_descriptor(cpu_state, &seg, R_FS);
+    hvf_set_segment(cpu, &seg, &env->segs[R_FS], false);
+    vmx_write_segment_descriptor(cpu, &seg, R_FS);
 
-    hvf_set_segment(cpu_state, &seg, &env->segs[R_GS], false);
-    vmx_write_segment_descriptor(cpu_state, &seg, R_GS);
+    hvf_set_segment(cpu, &seg, &env->segs[R_GS], false);
+    vmx_write_segment_descriptor(cpu, &seg, R_GS);
 
-    hvf_set_segment(cpu_state, &seg, &env->tr, true);
-    vmx_write_segment_descriptor(cpu_state, &seg, R_TR);
+    hvf_set_segment(cpu, &seg, &env->tr, true);
+    vmx_write_segment_descriptor(cpu, &seg, R_TR);
 
-    hvf_set_segment(cpu_state, &seg, &env->ldt, false);
-    vmx_write_segment_descriptor(cpu_state, &seg, R_LDTR);
+    hvf_set_segment(cpu, &seg, &env->ldt, false);
+    vmx_write_segment_descriptor(cpu, &seg, R_LDTR);
 }
     
-void hvf_put_msrs(CPUState *cpu_state)
+void hvf_put_msrs(CPUState *cpu)
 {
-    CPUX86State *env = &X86_CPU(cpu_state)->env;
+    CPUX86State *env = &X86_CPU(cpu)->env;
 
-    hv_vcpu_write_msr(cpu_state->hvf->fd, MSR_IA32_SYSENTER_CS,
+    hv_vcpu_write_msr(cpu->hvf->fd, MSR_IA32_SYSENTER_CS,
                       env->sysenter_cs);
-    hv_vcpu_write_msr(cpu_state->hvf->fd, MSR_IA32_SYSENTER_ESP,
+    hv_vcpu_write_msr(cpu->hvf->fd, MSR_IA32_SYSENTER_ESP,
                       env->sysenter_esp);
-    hv_vcpu_write_msr(cpu_state->hvf->fd, MSR_IA32_SYSENTER_EIP,
+    hv_vcpu_write_msr(cpu->hvf->fd, MSR_IA32_SYSENTER_EIP,
                       env->sysenter_eip);
 
-    hv_vcpu_write_msr(cpu_state->hvf->fd, MSR_STAR, env->star);
+    hv_vcpu_write_msr(cpu->hvf->fd, MSR_STAR, env->star);
 
 #ifdef TARGET_X86_64
-    hv_vcpu_write_msr(cpu_state->hvf->fd, MSR_CSTAR, env->cstar);
-    hv_vcpu_write_msr(cpu_state->hvf->fd, MSR_KERNELGSBASE, env->kernelgsbase);
-    hv_vcpu_write_msr(cpu_state->hvf->fd, MSR_FMASK, env->fmask);
-    hv_vcpu_write_msr(cpu_state->hvf->fd, MSR_LSTAR, env->lstar);
+    hv_vcpu_write_msr(cpu->hvf->fd, MSR_CSTAR, env->cstar);
+    hv_vcpu_write_msr(cpu->hvf->fd, MSR_KERNELGSBASE, env->kernelgsbase);
+    hv_vcpu_write_msr(cpu->hvf->fd, MSR_FMASK, env->fmask);
+    hv_vcpu_write_msr(cpu->hvf->fd, MSR_LSTAR, env->lstar);
 #endif
 
-    hv_vcpu_write_msr(cpu_state->hvf->fd, MSR_GSBASE, env->segs[R_GS].base);
-    hv_vcpu_write_msr(cpu_state->hvf->fd, MSR_FSBASE, env->segs[R_FS].base);
+    hv_vcpu_write_msr(cpu->hvf->fd, MSR_GSBASE, env->segs[R_GS].base);
+    hv_vcpu_write_msr(cpu->hvf->fd, MSR_FSBASE, env->segs[R_FS].base);
 }
 
 
-void hvf_get_xsave(CPUState *cpu_state)
+void hvf_get_xsave(CPUState *cpu)
 {
-    void *xsave = X86_CPU(cpu_state)->env.xsave_buf;
-    uint32_t xsave_len = X86_CPU(cpu_state)->env.xsave_buf_len;
+    void *xsave = X86_CPU(cpu)->env.xsave_buf;
+    uint32_t xsave_len = X86_CPU(cpu)->env.xsave_buf_len;
 
-    if (hv_vcpu_read_fpstate(cpu_state->hvf->fd, xsave, xsave_len)) {
+    if (hv_vcpu_read_fpstate(cpu->hvf->fd, xsave, xsave_len)) {
         abort();
     }
 
-    x86_cpu_xrstor_all_areas(X86_CPU(cpu_state), xsave, xsave_len);
+    x86_cpu_xrstor_all_areas(X86_CPU(cpu), xsave, xsave_len);
 }
 
-static void hvf_get_segments(CPUState *cpu_state)
+static void hvf_get_segments(CPUState *cpu)
 {
-    CPUX86State *env = &X86_CPU(cpu_state)->env;
+    CPUX86State *env = &X86_CPU(cpu)->env;
 
     struct vmx_segment seg;
 
     env->interrupt_injected = -1;
 
-    vmx_read_segment_descriptor(cpu_state, &seg, R_CS);
+    vmx_read_segment_descriptor(cpu, &seg, R_CS);
     hvf_get_segment(&env->segs[R_CS], &seg);
     
-    vmx_read_segment_descriptor(cpu_state, &seg, R_DS);
+    vmx_read_segment_descriptor(cpu, &seg, R_DS);
     hvf_get_segment(&env->segs[R_DS], &seg);
 
-    vmx_read_segment_descriptor(cpu_state, &seg, R_ES);
+    vmx_read_segment_descriptor(cpu, &seg, R_ES);
     hvf_get_segment(&env->segs[R_ES], &seg);
 
-    vmx_read_segment_descriptor(cpu_state, &seg, R_FS);
+    vmx_read_segment_descriptor(cpu, &seg, R_FS);
     hvf_get_segment(&env->segs[R_FS], &seg);
 
-    vmx_read_segment_descriptor(cpu_state, &seg, R_GS);
+    vmx_read_segment_descriptor(cpu, &seg, R_GS);
     hvf_get_segment(&env->segs[R_GS], &seg);
 
-    vmx_read_segment_descriptor(cpu_state, &seg, R_SS);
+    vmx_read_segment_descriptor(cpu, &seg, R_SS);
     hvf_get_segment(&env->segs[R_SS], &seg);
 
-    vmx_read_segment_descriptor(cpu_state, &seg, R_TR);
+    vmx_read_segment_descriptor(cpu, &seg, R_TR);
     hvf_get_segment(&env->tr, &seg);
 
-    vmx_read_segment_descriptor(cpu_state, &seg, R_LDTR);
+    vmx_read_segment_descriptor(cpu, &seg, R_LDTR);
     hvf_get_segment(&env->ldt, &seg);
 
-    env->idt.limit = rvmcs(cpu_state->hvf->fd, VMCS_GUEST_IDTR_LIMIT);
-    env->idt.base = rvmcs(cpu_state->hvf->fd, VMCS_GUEST_IDTR_BASE);
-    env->gdt.limit = rvmcs(cpu_state->hvf->fd, VMCS_GUEST_GDTR_LIMIT);
-    env->gdt.base = rvmcs(cpu_state->hvf->fd, VMCS_GUEST_GDTR_BASE);
+    env->idt.limit = rvmcs(cpu->hvf->fd, VMCS_GUEST_IDTR_LIMIT);
+    env->idt.base = rvmcs(cpu->hvf->fd, VMCS_GUEST_IDTR_BASE);
+    env->gdt.limit = rvmcs(cpu->hvf->fd, VMCS_GUEST_GDTR_LIMIT);
+    env->gdt.base = rvmcs(cpu->hvf->fd, VMCS_GUEST_GDTR_BASE);
 
-    env->cr[0] = rvmcs(cpu_state->hvf->fd, VMCS_GUEST_CR0);
+    env->cr[0] = rvmcs(cpu->hvf->fd, VMCS_GUEST_CR0);
     env->cr[2] = 0;
-    env->cr[3] = rvmcs(cpu_state->hvf->fd, VMCS_GUEST_CR3);
-    env->cr[4] = rvmcs(cpu_state->hvf->fd, VMCS_GUEST_CR4);
+    env->cr[3] = rvmcs(cpu->hvf->fd, VMCS_GUEST_CR3);
+    env->cr[4] = rvmcs(cpu->hvf->fd, VMCS_GUEST_CR4);
     
-    env->efer = rvmcs(cpu_state->hvf->fd, VMCS_GUEST_IA32_EFER);
+    env->efer = rvmcs(cpu->hvf->fd, VMCS_GUEST_IA32_EFER);
 }
 
-void hvf_get_msrs(CPUState *cpu_state)
+void hvf_get_msrs(CPUState *cpu)
 {
-    CPUX86State *env = &X86_CPU(cpu_state)->env;
+    CPUX86State *env = &X86_CPU(cpu)->env;
     uint64_t tmp;
     
-    hv_vcpu_read_msr(cpu_state->hvf->fd, MSR_IA32_SYSENTER_CS, &tmp);
+    hv_vcpu_read_msr(cpu->hvf->fd, MSR_IA32_SYSENTER_CS, &tmp);
     env->sysenter_cs = tmp;
     
-    hv_vcpu_read_msr(cpu_state->hvf->fd, MSR_IA32_SYSENTER_ESP, &tmp);
+    hv_vcpu_read_msr(cpu->hvf->fd, MSR_IA32_SYSENTER_ESP, &tmp);
     env->sysenter_esp = tmp;
 
-    hv_vcpu_read_msr(cpu_state->hvf->fd, MSR_IA32_SYSENTER_EIP, &tmp);
+    hv_vcpu_read_msr(cpu->hvf->fd, MSR_IA32_SYSENTER_EIP, &tmp);
     env->sysenter_eip = tmp;
 
-    hv_vcpu_read_msr(cpu_state->hvf->fd, MSR_STAR, &env->star);
+    hv_vcpu_read_msr(cpu->hvf->fd, MSR_STAR, &env->star);
 
 #ifdef TARGET_X86_64
-    hv_vcpu_read_msr(cpu_state->hvf->fd, MSR_CSTAR, &env->cstar);
-    hv_vcpu_read_msr(cpu_state->hvf->fd, MSR_KERNELGSBASE, &env->kernelgsbase);
-    hv_vcpu_read_msr(cpu_state->hvf->fd, MSR_FMASK, &env->fmask);
-    hv_vcpu_read_msr(cpu_state->hvf->fd, MSR_LSTAR, &env->lstar);
+    hv_vcpu_read_msr(cpu->hvf->fd, MSR_CSTAR, &env->cstar);
+    hv_vcpu_read_msr(cpu->hvf->fd, MSR_KERNELGSBASE, &env->kernelgsbase);
+    hv_vcpu_read_msr(cpu->hvf->fd, MSR_FMASK, &env->fmask);
+    hv_vcpu_read_msr(cpu->hvf->fd, MSR_LSTAR, &env->lstar);
 #endif
 
-    hv_vcpu_read_msr(cpu_state->hvf->fd, MSR_IA32_APICBASE, &tmp);
+    hv_vcpu_read_msr(cpu->hvf->fd, MSR_IA32_APICBASE, &tmp);
     
-    env->tsc = rdtscp() + rvmcs(cpu_state->hvf->fd, VMCS_TSC_OFFSET);
+    env->tsc = rdtscp() + rvmcs(cpu->hvf->fd, VMCS_TSC_OFFSET);
 }
 
-int hvf_put_registers(CPUState *cpu_state)
+int hvf_put_registers(CPUState *cpu)
 {
-    X86CPU *x86cpu = X86_CPU(cpu_state);
+    X86CPU *x86cpu = X86_CPU(cpu);
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
+    wreg(cpu->hvf->fd, HV_X86_RAX, env->regs[R_EAX]);
+    wreg(cpu->hvf->fd, HV_X86_RBX, env->regs[R_EBX]);
+    wreg(cpu->hvf->fd, HV_X86_RCX, env->regs[R_ECX]);
+    wreg(cpu->hvf->fd, HV_X86_RDX, env->regs[R_EDX]);
+    wreg(cpu->hvf->fd, HV_X86_RBP, env->regs[R_EBP]);
+    wreg(cpu->hvf->fd, HV_X86_RSP, env->regs[R_ESP]);
+    wreg(cpu->hvf->fd, HV_X86_RSI, env->regs[R_ESI]);
+    wreg(cpu->hvf->fd, HV_X86_RDI, env->regs[R_EDI]);
+    wreg(cpu->hvf->fd, HV_X86_R8, env->regs[8]);
+    wreg(cpu->hvf->fd, HV_X86_R9, env->regs[9]);
+    wreg(cpu->hvf->fd, HV_X86_R10, env->regs[10]);
+    wreg(cpu->hvf->fd, HV_X86_R11, env->regs[11]);
+    wreg(cpu->hvf->fd, HV_X86_R12, env->regs[12]);
+    wreg(cpu->hvf->fd, HV_X86_R13, env->regs[13]);
+    wreg(cpu->hvf->fd, HV_X86_R14, env->regs[14]);
+    wreg(cpu->hvf->fd, HV_X86_R15, env->regs[15]);
+    wreg(cpu->hvf->fd, HV_X86_RFLAGS, env->eflags);
+    wreg(cpu->hvf->fd, HV_X86_RIP, env->eip);
    
-    wreg(cpu_state->hvf->fd, HV_X86_XCR0, env->xcr0);
+    wreg(cpu->hvf->fd, HV_X86_XCR0, env->xcr0);
     
-    hvf_put_xsave(cpu_state);
+    hvf_put_xsave(cpu);
     
-    hvf_put_segments(cpu_state);
+    hvf_put_segments(cpu);
     
-    hvf_put_msrs(cpu_state);
+    hvf_put_msrs(cpu);
     
-    wreg(cpu_state->hvf->fd, HV_X86_DR0, env->dr[0]);
-    wreg(cpu_state->hvf->fd, HV_X86_DR1, env->dr[1]);
-    wreg(cpu_state->hvf->fd, HV_X86_DR2, env->dr[2]);
-    wreg(cpu_state->hvf->fd, HV_X86_DR3, env->dr[3]);
-    wreg(cpu_state->hvf->fd, HV_X86_DR4, env->dr[4]);
-    wreg(cpu_state->hvf->fd, HV_X86_DR5, env->dr[5]);
-    wreg(cpu_state->hvf->fd, HV_X86_DR6, env->dr[6]);
-    wreg(cpu_state->hvf->fd, HV_X86_DR7, env->dr[7]);
+    wreg(cpu->hvf->fd, HV_X86_DR0, env->dr[0]);
+    wreg(cpu->hvf->fd, HV_X86_DR1, env->dr[1]);
+    wreg(cpu->hvf->fd, HV_X86_DR2, env->dr[2]);
+    wreg(cpu->hvf->fd, HV_X86_DR3, env->dr[3]);
+    wreg(cpu->hvf->fd, HV_X86_DR4, env->dr[4]);
+    wreg(cpu->hvf->fd, HV_X86_DR5, env->dr[5]);
+    wreg(cpu->hvf->fd, HV_X86_DR6, env->dr[6]);
+    wreg(cpu->hvf->fd, HV_X86_DR7, env->dr[7]);
     
     return 0;
 }
 
-int hvf_get_registers(CPUState *cpu_state)
+int hvf_get_registers(CPUState *cpu)
 {
-    X86CPU *x86cpu = X86_CPU(cpu_state);
+    X86CPU *x86cpu = X86_CPU(cpu);
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
+    env->regs[R_EAX] = rreg(cpu->hvf->fd, HV_X86_RAX);
+    env->regs[R_EBX] = rreg(cpu->hvf->fd, HV_X86_RBX);
+    env->regs[R_ECX] = rreg(cpu->hvf->fd, HV_X86_RCX);
+    env->regs[R_EDX] = rreg(cpu->hvf->fd, HV_X86_RDX);
+    env->regs[R_EBP] = rreg(cpu->hvf->fd, HV_X86_RBP);
+    env->regs[R_ESP] = rreg(cpu->hvf->fd, HV_X86_RSP);
+    env->regs[R_ESI] = rreg(cpu->hvf->fd, HV_X86_RSI);
+    env->regs[R_EDI] = rreg(cpu->hvf->fd, HV_X86_RDI);
+    env->regs[8] = rreg(cpu->hvf->fd, HV_X86_R8);
+    env->regs[9] = rreg(cpu->hvf->fd, HV_X86_R9);
+    env->regs[10] = rreg(cpu->hvf->fd, HV_X86_R10);
+    env->regs[11] = rreg(cpu->hvf->fd, HV_X86_R11);
+    env->regs[12] = rreg(cpu->hvf->fd, HV_X86_R12);
+    env->regs[13] = rreg(cpu->hvf->fd, HV_X86_R13);
+    env->regs[14] = rreg(cpu->hvf->fd, HV_X86_R14);
+    env->regs[15] = rreg(cpu->hvf->fd, HV_X86_R15);
     
-    env->eflags = rreg(cpu_state->hvf->fd, HV_X86_RFLAGS);
-    env->eip = rreg(cpu_state->hvf->fd, HV_X86_RIP);
+    env->eflags = rreg(cpu->hvf->fd, HV_X86_RFLAGS);
+    env->eip = rreg(cpu->hvf->fd, HV_X86_RIP);
    
-    hvf_get_xsave(cpu_state);
-    env->xcr0 = rreg(cpu_state->hvf->fd, HV_X86_XCR0);
+    hvf_get_xsave(cpu);
+    env->xcr0 = rreg(cpu->hvf->fd, HV_X86_XCR0);
     
-    hvf_get_segments(cpu_state);
-    hvf_get_msrs(cpu_state);
+    hvf_get_segments(cpu);
+    hvf_get_msrs(cpu);
     
-    env->dr[0] = rreg(cpu_state->hvf->fd, HV_X86_DR0);
-    env->dr[1] = rreg(cpu_state->hvf->fd, HV_X86_DR1);
-    env->dr[2] = rreg(cpu_state->hvf->fd, HV_X86_DR2);
-    env->dr[3] = rreg(cpu_state->hvf->fd, HV_X86_DR3);
-    env->dr[4] = rreg(cpu_state->hvf->fd, HV_X86_DR4);
-    env->dr[5] = rreg(cpu_state->hvf->fd, HV_X86_DR5);
-    env->dr[6] = rreg(cpu_state->hvf->fd, HV_X86_DR6);
-    env->dr[7] = rreg(cpu_state->hvf->fd, HV_X86_DR7);
+    env->dr[0] = rreg(cpu->hvf->fd, HV_X86_DR0);
+    env->dr[1] = rreg(cpu->hvf->fd, HV_X86_DR1);
+    env->dr[2] = rreg(cpu->hvf->fd, HV_X86_DR2);
+    env->dr[3] = rreg(cpu->hvf->fd, HV_X86_DR3);
+    env->dr[4] = rreg(cpu->hvf->fd, HV_X86_DR4);
+    env->dr[5] = rreg(cpu->hvf->fd, HV_X86_DR5);
+    env->dr[6] = rreg(cpu->hvf->fd, HV_X86_DR6);
+    env->dr[7] = rreg(cpu->hvf->fd, HV_X86_DR7);
     
     x86_update_hflags(env);
     return 0;
@@ -340,9 +340,9 @@ void vmx_clear_int_window_exiting(CPUState *cpu)
              ~VMCS_PRI_PROC_BASED_CTLS_INT_WINDOW_EXITING);
 }
 
-bool hvf_inject_interrupts(CPUState *cpu_state)
+bool hvf_inject_interrupts(CPUState *cpu)
 {
-    X86CPU *x86cpu = X86_CPU(cpu_state);
+    X86CPU *x86cpu = X86_CPU(cpu);
     CPUX86State *env = &x86cpu->env;
 
     uint8_t vector;
@@ -372,89 +372,89 @@ bool hvf_inject_interrupts(CPUState *cpu_state)
     uint64_t info = 0;
     if (have_event) {
         info = vector | intr_type | VMCS_INTR_VALID;
-        uint64_t reason = rvmcs(cpu_state->hvf->fd, VMCS_EXIT_REASON);
+        uint64_t reason = rvmcs(cpu->hvf->fd, VMCS_EXIT_REASON);
         if (env->nmi_injected && reason != EXIT_REASON_TASK_SWITCH) {
-            vmx_clear_nmi_blocking(cpu_state);
+            vmx_clear_nmi_blocking(cpu);
         }
 
         if (!(env->hflags2 & HF2_NMI_MASK) || intr_type != VMCS_INTR_T_NMI) {
             info &= ~(1 << 12); /* clear undefined bit */
             if (intr_type == VMCS_INTR_T_SWINTR ||
                 intr_type == VMCS_INTR_T_SWEXCEPTION) {
-                wvmcs(cpu_state->hvf->fd, VMCS_ENTRY_INST_LENGTH, env->ins_len);
+                wvmcs(cpu->hvf->fd, VMCS_ENTRY_INST_LENGTH, env->ins_len);
             }
             
             if (env->has_error_code) {
-                wvmcs(cpu_state->hvf->fd, VMCS_ENTRY_EXCEPTION_ERROR,
+                wvmcs(cpu->hvf->fd, VMCS_ENTRY_EXCEPTION_ERROR,
                       env->error_code);
                 /* Indicate that VMCS_ENTRY_EXCEPTION_ERROR is valid */
                 info |= VMCS_INTR_DEL_ERRCODE;
             }
             /*printf("reinject  %lx err %d\n", info, err);*/
-            wvmcs(cpu_state->hvf->fd, VMCS_ENTRY_INTR_INFO, info);
+            wvmcs(cpu->hvf->fd, VMCS_ENTRY_INTR_INFO, info);
         };
     }
 
-    if (cpu_state->interrupt_request & CPU_INTERRUPT_NMI) {
+    if (cpu->interrupt_request & CPU_INTERRUPT_NMI) {
         if (!(env->hflags2 & HF2_NMI_MASK) && !(info & VMCS_INTR_VALID)) {
-            cpu_state->interrupt_request &= ~CPU_INTERRUPT_NMI;
+            cpu->interrupt_request &= ~CPU_INTERRUPT_NMI;
             info = VMCS_INTR_VALID | VMCS_INTR_T_NMI | EXCP02_NMI;
-            wvmcs(cpu_state->hvf->fd, VMCS_ENTRY_INTR_INFO, info);
+            wvmcs(cpu->hvf->fd, VMCS_ENTRY_INTR_INFO, info);
         } else {
-            vmx_set_nmi_window_exiting(cpu_state);
+            vmx_set_nmi_window_exiting(cpu);
         }
     }
 
     if (!(env->hflags & HF_INHIBIT_IRQ_MASK) &&
-        (cpu_state->interrupt_request & CPU_INTERRUPT_HARD) &&
+        (cpu->interrupt_request & CPU_INTERRUPT_HARD) &&
         (env->eflags & IF_MASK) && !(info & VMCS_INTR_VALID)) {
         int line = cpu_get_pic_interrupt(&x86cpu->env);
-        cpu_state->interrupt_request &= ~CPU_INTERRUPT_HARD;
+        cpu->interrupt_request &= ~CPU_INTERRUPT_HARD;
         if (line >= 0) {
-            wvmcs(cpu_state->hvf->fd, VMCS_ENTRY_INTR_INFO, line |
+            wvmcs(cpu->hvf->fd, VMCS_ENTRY_INTR_INFO, line |
                   VMCS_INTR_VALID | VMCS_INTR_T_HWINTR);
         }
     }
-    if (cpu_state->interrupt_request & CPU_INTERRUPT_HARD) {
-        vmx_set_int_window_exiting(cpu_state);
+    if (cpu->interrupt_request & CPU_INTERRUPT_HARD) {
+        vmx_set_int_window_exiting(cpu);
     }
-    return (cpu_state->interrupt_request
+    return (cpu->interrupt_request
             & (CPU_INTERRUPT_INIT | CPU_INTERRUPT_TPR));
 }
 
-int hvf_process_events(CPUState *cpu_state)
+int hvf_process_events(CPUState *cpu)
 {
-    X86CPU *cpu = X86_CPU(cpu_state);
+    X86CPU *cpu = X86_CPU(cpu);
     CPUX86State *env = &cpu->env;
 
-    if (!cpu_state->vcpu_dirty) {
+    if (!cpu->vcpu_dirty) {
         /* light weight sync for CPU_INTERRUPT_HARD and IF_MASK */
-        env->eflags = rreg(cpu_state->hvf->fd, HV_X86_RFLAGS);
+        env->eflags = rreg(cpu->hvf->fd, HV_X86_RFLAGS);
     }
 
-    if (cpu_state->interrupt_request & CPU_INTERRUPT_INIT) {
-        cpu_synchronize_state(cpu_state);
+    if (cpu->interrupt_request & CPU_INTERRUPT_INIT) {
+        cpu_synchronize_state(cpu);
         do_cpu_init(cpu);
     }
 
-    if (cpu_state->interrupt_request & CPU_INTERRUPT_POLL) {
-        cpu_state->interrupt_request &= ~CPU_INTERRUPT_POLL;
+    if (cpu->interrupt_request & CPU_INTERRUPT_POLL) {
+        cpu->interrupt_request &= ~CPU_INTERRUPT_POLL;
         apic_poll_irq(cpu->apic_state);
     }
-    if (((cpu_state->interrupt_request & CPU_INTERRUPT_HARD) &&
+    if (((cpu->interrupt_request & CPU_INTERRUPT_HARD) &&
         (env->eflags & IF_MASK)) ||
-        (cpu_state->interrupt_request & CPU_INTERRUPT_NMI)) {
-        cpu_state->halted = 0;
+        (cpu->interrupt_request & CPU_INTERRUPT_NMI)) {
+        cpu->halted = 0;
     }
-    if (cpu_state->interrupt_request & CPU_INTERRUPT_SIPI) {
-        cpu_synchronize_state(cpu_state);
+    if (cpu->interrupt_request & CPU_INTERRUPT_SIPI) {
+        cpu_synchronize_state(cpu);
         do_cpu_sipi(cpu);
     }
-    if (cpu_state->interrupt_request & CPU_INTERRUPT_TPR) {
-        cpu_state->interrupt_request &= ~CPU_INTERRUPT_TPR;
-        cpu_synchronize_state(cpu_state);
+    if (cpu->interrupt_request & CPU_INTERRUPT_TPR) {
+        cpu->interrupt_request &= ~CPU_INTERRUPT_TPR;
+        cpu_synchronize_state(cpu);
         apic_handle_tpr_access_report(cpu->apic_state, env->eip,
                                       env->tpr_access_type);
     }
-    return cpu_state->halted;
+    return cpu->halted;
 }
-- 
2.38.1

