Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 880AF73A5C6
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 18:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbjFVQLw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 12:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbjFVQLt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 12:11:49 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B6E213D
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 09:11:22 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-3110a5f2832so869958f8f.1
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 09:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687450272; x=1690042272;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g0kqJburgdu472vwwAFuv1VsrJpQeVQ9WWi/MNQJgyg=;
        b=X/LSe7ET3HA/FOJED496ZQ/MgJIHK5ZLUDrP2zB7JeO3gyBSTFXPteFPewVPonYV+V
         Om+ZD18d+Hx1XMxnzVG1OhabMjsX5u8CFCaUb/n17VI05C/WoSMIieqc68KU18ZeFU9K
         vd0Id1ZbolFrjzJ3A6ff200qEyqn3Vwzi6daV+rnGdNtZscdHx7UcEPatG6BIT/IXw+F
         EfS+LxBr+xNpk+h+BeHSEBpjUUTtekUw1mudJ2lZvFmUiRDNCeiK+vQNVhLvbZ5DyqNw
         N6ib3vDrzXTzx9f3qpDyr7kA2/vi8DjN55ok10V6dh33sTzsRY9L8p0plrpYjC65oYrS
         NaRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687450272; x=1690042272;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g0kqJburgdu472vwwAFuv1VsrJpQeVQ9WWi/MNQJgyg=;
        b=DWnUx6GtDExBtWpa7+aN+ZksPHsab51fWEUD+43kM2oe4VNtAG2YNYqLqQPcOkwsqh
         k8Gg+xTTGWlr8UN//8YGpW+bpvdaCQtGMtidBlcDkUJBPJr0sb/X9FaYg5mxl6KppuF/
         gpkevId3hhW50cVd6USt3Vh4zGt0IMkSvHIni3S8C/IvCaKPkdZxYbZ127RKE/ZrVuA3
         y5zQArwvpivBGkRE3Sawco1uhXNOrba2VZWYHPb2wVWpGNMOQfWDAJ8chPo6im9gciHL
         vv2PMXkVyifBPNm0ShKVuRWGRK1UDndig2tnBWQf+mr8nN7TePf5qY2x8VTJsm6oB33Y
         vrzQ==
X-Gm-Message-State: AC+VfDyHWBf/V2fIwepU8tBUcY1TdpPXUfyIL7oEZtRi70bOywqYyJF+
        f18dok18QBrYMIwM9XFwDGXulQ==
X-Google-Smtp-Source: ACHHUZ4vOPPOLo7QmgVClajvoGsLDBUccKzS2E8fCJ2AC82Z4T83Vnb7AaojHy9ATpjMS6WULzLkyg==
X-Received: by 2002:a05:6000:12c8:b0:311:2888:9f95 with SMTP id l8-20020a05600012c800b0031128889f95mr16140447wrx.23.1687450272301;
        Thu, 22 Jun 2023 09:11:12 -0700 (PDT)
Received: from localhost.localdomain (230.red-88-28-3.dynamicip.rima-tde.net. [88.28.3.230])
        by smtp.gmail.com with ESMTPSA id b8-20020adff248000000b003063772a55bsm7391445wrp.61.2023.06.22.09.11.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 22 Jun 2023 09:11:11 -0700 (PDT)
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
Subject: [PATCH v2 16/16] accel: Rename HVF 'struct hvf_vcpu_state' -> AccelCPUState
Date:   Thu, 22 Jun 2023 18:08:23 +0200
Message-Id: <20230622160823.71851-17-philmd@linaro.org>
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

We want all accelerators to share the same opaque pointer in
CPUState.

Rename the 'hvf_vcpu_state' structure as 'AccelCPUState'.

Use the generic 'accel' field of CPUState instead of 'hvf'.

Replace g_malloc0() by g_new0() for readability.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
Not even built on x86!
---
 include/hw/core/cpu.h       |   4 -
 include/sysemu/hvf_int.h    |   2 +-
 target/i386/hvf/vmx.h       |  22 ++--
 accel/hvf/hvf-accel-ops.c   |  18 ++--
 target/arm/hvf/hvf.c        | 108 +++++++++----------
 target/i386/hvf/hvf.c       | 104 +++++++++---------
 target/i386/hvf/x86.c       |  28 ++---
 target/i386/hvf/x86_descr.c |  26 ++---
 target/i386/hvf/x86_emu.c   |  62 +++++------
 target/i386/hvf/x86_mmu.c   |   4 +-
 target/i386/hvf/x86_task.c  |  10 +-
 target/i386/hvf/x86hvf.c    | 208 ++++++++++++++++++------------------
 12 files changed, 296 insertions(+), 300 deletions(-)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 01388d5918..afde06e054 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -240,8 +240,6 @@ typedef struct SavedIOTLB {
 struct KVMState;
 struct kvm_run;
 
-struct hvf_vcpu_state;
-
 /* work queue */
 
 /* The union type allows passing of 64 bit target pointers on 32 bit
@@ -441,8 +439,6 @@ struct CPUState {
     /* Used for user-only emulation of prctl(PR_SET_UNALIGN). */
     bool prctl_unalign_sigbus;
 
-    struct hvf_vcpu_state *hvf;
-
     /* track IOMMUs whose translations we've cached in the TCG TLB */
     GArray *iommu_notifiers;
 };
diff --git a/include/sysemu/hvf_int.h b/include/sysemu/hvf_int.h
index 6ab119e49f..5237943952 100644
--- a/include/sysemu/hvf_int.h
+++ b/include/sysemu/hvf_int.h
@@ -49,7 +49,7 @@ struct HVFState {
 };
 extern HVFState *hvf_state;
 
-struct hvf_vcpu_state {
+struct AccelvCPUState {
     uint64_t fd;
     void *exit;
     bool vtimer_masked;
diff --git a/target/i386/hvf/vmx.h b/target/i386/hvf/vmx.h
index fcd9a95e5b..0fffcfa46c 100644
--- a/target/i386/hvf/vmx.h
+++ b/target/i386/hvf/vmx.h
@@ -180,15 +180,15 @@ static inline void macvm_set_rip(CPUState *cpu, uint64_t rip)
     uint64_t val;
 
     /* BUG, should take considering overlap.. */
-    wreg(cpu->hvf->fd, HV_X86_RIP, rip);
+    wreg(cpu->accel->fd, HV_X86_RIP, rip);
     env->eip = rip;
 
     /* after moving forward in rip, we need to clean INTERRUPTABILITY */
-   val = rvmcs(cpu->hvf->fd, VMCS_GUEST_INTERRUPTIBILITY);
+   val = rvmcs(cpu->accel->fd, VMCS_GUEST_INTERRUPTIBILITY);
    if (val & (VMCS_INTERRUPTIBILITY_STI_BLOCKING |
                VMCS_INTERRUPTIBILITY_MOVSS_BLOCKING)) {
         env->hflags &= ~HF_INHIBIT_IRQ_MASK;
-        wvmcs(cpu->hvf->fd, VMCS_GUEST_INTERRUPTIBILITY,
+        wvmcs(cpu->accel->fd, VMCS_GUEST_INTERRUPTIBILITY,
                val & ~(VMCS_INTERRUPTIBILITY_STI_BLOCKING |
                VMCS_INTERRUPTIBILITY_MOVSS_BLOCKING));
    }
@@ -200,9 +200,9 @@ static inline void vmx_clear_nmi_blocking(CPUState *cpu)
     CPUX86State *env = &x86_cpu->env;
 
     env->hflags2 &= ~HF2_NMI_MASK;
-    uint32_t gi = (uint32_t) rvmcs(cpu->hvf->fd, VMCS_GUEST_INTERRUPTIBILITY);
+    uint32_t gi = (uint32_t) rvmcs(cpu->accel->fd, VMCS_GUEST_INTERRUPTIBILITY);
     gi &= ~VMCS_INTERRUPTIBILITY_NMI_BLOCKING;
-    wvmcs(cpu->hvf->fd, VMCS_GUEST_INTERRUPTIBILITY, gi);
+    wvmcs(cpu->accel->fd, VMCS_GUEST_INTERRUPTIBILITY, gi);
 }
 
 static inline void vmx_set_nmi_blocking(CPUState *cpu)
@@ -211,16 +211,16 @@ static inline void vmx_set_nmi_blocking(CPUState *cpu)
     CPUX86State *env = &x86_cpu->env;
 
     env->hflags2 |= HF2_NMI_MASK;
-    uint32_t gi = (uint32_t)rvmcs(cpu->hvf->fd, VMCS_GUEST_INTERRUPTIBILITY);
+    uint32_t gi = (uint32_t)rvmcs(cpu->accel->fd, VMCS_GUEST_INTERRUPTIBILITY);
     gi |= VMCS_INTERRUPTIBILITY_NMI_BLOCKING;
-    wvmcs(cpu->hvf->fd, VMCS_GUEST_INTERRUPTIBILITY, gi);
+    wvmcs(cpu->accel->fd, VMCS_GUEST_INTERRUPTIBILITY, gi);
 }
 
 static inline void vmx_set_nmi_window_exiting(CPUState *cpu)
 {
     uint64_t val;
-    val = rvmcs(cpu->hvf->fd, VMCS_PRI_PROC_BASED_CTLS);
-    wvmcs(cpu->hvf->fd, VMCS_PRI_PROC_BASED_CTLS, val |
+    val = rvmcs(cpu->accel->fd, VMCS_PRI_PROC_BASED_CTLS);
+    wvmcs(cpu->accel->fd, VMCS_PRI_PROC_BASED_CTLS, val |
           VMCS_PRI_PROC_BASED_CTLS_NMI_WINDOW_EXITING);
 
 }
@@ -229,8 +229,8 @@ static inline void vmx_clear_nmi_window_exiting(CPUState *cpu)
 {
 
     uint64_t val;
-    val = rvmcs(cpu->hvf->fd, VMCS_PRI_PROC_BASED_CTLS);
-    wvmcs(cpu->hvf->fd, VMCS_PRI_PROC_BASED_CTLS, val &
+    val = rvmcs(cpu->accel->fd, VMCS_PRI_PROC_BASED_CTLS);
+    wvmcs(cpu->accel->fd, VMCS_PRI_PROC_BASED_CTLS, val &
           ~VMCS_PRI_PROC_BASED_CTLS_NMI_WINDOW_EXITING);
 }
 
diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
index 9c3da03c94..6b95933264 100644
--- a/accel/hvf/hvf-accel-ops.c
+++ b/accel/hvf/hvf-accel-ops.c
@@ -372,19 +372,19 @@ type_init(hvf_type_init);
 
 static void hvf_vcpu_destroy(CPUState *cpu)
 {
-    hv_return_t ret = hv_vcpu_destroy(cpu->hvf->fd);
+    hv_return_t ret = hv_vcpu_destroy(cpu->accel->fd);
     assert_hvf_ok(ret);
 
     hvf_arch_vcpu_destroy(cpu);
-    g_free(cpu->hvf);
-    cpu->hvf = NULL;
+    g_free(cpu->accel);
+    cpu->accel = NULL;
 }
 
 static int hvf_init_vcpu(CPUState *cpu)
 {
     int r;
 
-    cpu->hvf = g_malloc0(sizeof(*cpu->hvf));
+    cpu->accel = g_new0(struct AccelvCPUState, 1);
 
     /* init cpu signals */
     struct sigaction sigact;
@@ -393,18 +393,18 @@ static int hvf_init_vcpu(CPUState *cpu)
     sigact.sa_handler = dummy_signal;
     sigaction(SIG_IPI, &sigact, NULL);
 
-    pthread_sigmask(SIG_BLOCK, NULL, &cpu->hvf->unblock_ipi_mask);
-    sigdelset(&cpu->hvf->unblock_ipi_mask, SIG_IPI);
+    pthread_sigmask(SIG_BLOCK, NULL, &cpu->accel->unblock_ipi_mask);
+    sigdelset(&cpu->accel->unblock_ipi_mask, SIG_IPI);
 
 #ifdef __aarch64__
-    r = hv_vcpu_create(&cpu->hvf->fd, (hv_vcpu_exit_t **)&cpu->hvf->exit, NULL);
+    r = hv_vcpu_create(&cpu->accel->fd, (hv_vcpu_exit_t **)&cpu->accel->exit, NULL);
 #else
-    r = hv_vcpu_create((hv_vcpuid_t *)&cpu->hvf->fd, HV_VCPU_DEFAULT);
+    r = hv_vcpu_create((hv_vcpuid_t *)&cpu->accel->fd, HV_VCPU_DEFAULT);
 #endif
     cpu->vcpu_dirty = 1;
     assert_hvf_ok(r);
 
-    cpu->hvf->guest_debug_enabled = false;
+    cpu->accel->guest_debug_enabled = false;
 
     return hvf_arch_init_vcpu(cpu);
 }
diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index 8f72624586..8fce64bbf6 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -544,29 +544,29 @@ int hvf_get_registers(CPUState *cpu)
     int i;
 
     for (i = 0; i < ARRAY_SIZE(hvf_reg_match); i++) {
-        ret = hv_vcpu_get_reg(cpu->hvf->fd, hvf_reg_match[i].reg, &val);
+        ret = hv_vcpu_get_reg(cpu->accel->fd, hvf_reg_match[i].reg, &val);
         *(uint64_t *)((void *)env + hvf_reg_match[i].offset) = val;
         assert_hvf_ok(ret);
     }
 
     for (i = 0; i < ARRAY_SIZE(hvf_fpreg_match); i++) {
-        ret = hv_vcpu_get_simd_fp_reg(cpu->hvf->fd, hvf_fpreg_match[i].reg,
+        ret = hv_vcpu_get_simd_fp_reg(cpu->accel->fd, hvf_fpreg_match[i].reg,
                                       &fpval);
         memcpy((void *)env + hvf_fpreg_match[i].offset, &fpval, sizeof(fpval));
         assert_hvf_ok(ret);
     }
 
     val = 0;
-    ret = hv_vcpu_get_reg(cpu->hvf->fd, HV_REG_FPCR, &val);
+    ret = hv_vcpu_get_reg(cpu->accel->fd, HV_REG_FPCR, &val);
     assert_hvf_ok(ret);
     vfp_set_fpcr(env, val);
 
     val = 0;
-    ret = hv_vcpu_get_reg(cpu->hvf->fd, HV_REG_FPSR, &val);
+    ret = hv_vcpu_get_reg(cpu->accel->fd, HV_REG_FPSR, &val);
     assert_hvf_ok(ret);
     vfp_set_fpsr(env, val);
 
-    ret = hv_vcpu_get_reg(cpu->hvf->fd, HV_REG_CPSR, &val);
+    ret = hv_vcpu_get_reg(cpu->accel->fd, HV_REG_CPSR, &val);
     assert_hvf_ok(ret);
     pstate_write(env, val);
 
@@ -575,7 +575,7 @@ int hvf_get_registers(CPUState *cpu)
             continue;
         }
 
-        if (cpu->hvf->guest_debug_enabled) {
+        if (cpu->accel->guest_debug_enabled) {
             /* Handle debug registers */
             switch (hvf_sreg_match[i].reg) {
             case HV_SYS_REG_DBGBVR0_EL1:
@@ -661,7 +661,7 @@ int hvf_get_registers(CPUState *cpu)
             }
         }
 
-        ret = hv_vcpu_get_sys_reg(cpu->hvf->fd, hvf_sreg_match[i].reg, &val);
+        ret = hv_vcpu_get_sys_reg(cpu->accel->fd, hvf_sreg_match[i].reg, &val);
         assert_hvf_ok(ret);
 
         arm_cpu->cpreg_values[hvf_sreg_match[i].cp_idx] = val;
@@ -684,24 +684,24 @@ int hvf_put_registers(CPUState *cpu)
 
     for (i = 0; i < ARRAY_SIZE(hvf_reg_match); i++) {
         val = *(uint64_t *)((void *)env + hvf_reg_match[i].offset);
-        ret = hv_vcpu_set_reg(cpu->hvf->fd, hvf_reg_match[i].reg, val);
+        ret = hv_vcpu_set_reg(cpu->accel->fd, hvf_reg_match[i].reg, val);
         assert_hvf_ok(ret);
     }
 
     for (i = 0; i < ARRAY_SIZE(hvf_fpreg_match); i++) {
         memcpy(&fpval, (void *)env + hvf_fpreg_match[i].offset, sizeof(fpval));
-        ret = hv_vcpu_set_simd_fp_reg(cpu->hvf->fd, hvf_fpreg_match[i].reg,
+        ret = hv_vcpu_set_simd_fp_reg(cpu->accel->fd, hvf_fpreg_match[i].reg,
                                       fpval);
         assert_hvf_ok(ret);
     }
 
-    ret = hv_vcpu_set_reg(cpu->hvf->fd, HV_REG_FPCR, vfp_get_fpcr(env));
+    ret = hv_vcpu_set_reg(cpu->accel->fd, HV_REG_FPCR, vfp_get_fpcr(env));
     assert_hvf_ok(ret);
 
-    ret = hv_vcpu_set_reg(cpu->hvf->fd, HV_REG_FPSR, vfp_get_fpsr(env));
+    ret = hv_vcpu_set_reg(cpu->accel->fd, HV_REG_FPSR, vfp_get_fpsr(env));
     assert_hvf_ok(ret);
 
-    ret = hv_vcpu_set_reg(cpu->hvf->fd, HV_REG_CPSR, pstate_read(env));
+    ret = hv_vcpu_set_reg(cpu->accel->fd, HV_REG_CPSR, pstate_read(env));
     assert_hvf_ok(ret);
 
     aarch64_save_sp(env, arm_current_el(env));
@@ -712,7 +712,7 @@ int hvf_put_registers(CPUState *cpu)
             continue;
         }
 
-        if (cpu->hvf->guest_debug_enabled) {
+        if (cpu->accel->guest_debug_enabled) {
             /* Handle debug registers */
             switch (hvf_sreg_match[i].reg) {
             case HV_SYS_REG_DBGBVR0_EL1:
@@ -789,11 +789,11 @@ int hvf_put_registers(CPUState *cpu)
         }
 
         val = arm_cpu->cpreg_values[hvf_sreg_match[i].cp_idx];
-        ret = hv_vcpu_set_sys_reg(cpu->hvf->fd, hvf_sreg_match[i].reg, val);
+        ret = hv_vcpu_set_sys_reg(cpu->accel->fd, hvf_sreg_match[i].reg, val);
         assert_hvf_ok(ret);
     }
 
-    ret = hv_vcpu_set_vtimer_offset(cpu->hvf->fd, hvf_state->vtimer_offset);
+    ret = hv_vcpu_set_vtimer_offset(cpu->accel->fd, hvf_state->vtimer_offset);
     assert_hvf_ok(ret);
 
     return 0;
@@ -814,7 +814,7 @@ static void hvf_set_reg(CPUState *cpu, int rt, uint64_t val)
     flush_cpu_state(cpu);
 
     if (rt < 31) {
-        r = hv_vcpu_set_reg(cpu->hvf->fd, HV_REG_X0 + rt, val);
+        r = hv_vcpu_set_reg(cpu->accel->fd, HV_REG_X0 + rt, val);
         assert_hvf_ok(r);
     }
 }
@@ -827,7 +827,7 @@ static uint64_t hvf_get_reg(CPUState *cpu, int rt)
     flush_cpu_state(cpu);
 
     if (rt < 31) {
-        r = hv_vcpu_get_reg(cpu->hvf->fd, HV_REG_X0 + rt, &val);
+        r = hv_vcpu_get_reg(cpu->accel->fd, HV_REG_X0 + rt, &val);
         assert_hvf_ok(r);
     }
 
@@ -969,22 +969,22 @@ int hvf_arch_init_vcpu(CPUState *cpu)
     assert(write_cpustate_to_list(arm_cpu, false));
 
     /* Set CP_NO_RAW system registers on init */
-    ret = hv_vcpu_set_sys_reg(cpu->hvf->fd, HV_SYS_REG_MIDR_EL1,
+    ret = hv_vcpu_set_sys_reg(cpu->accel->fd, HV_SYS_REG_MIDR_EL1,
                               arm_cpu->midr);
     assert_hvf_ok(ret);
 
-    ret = hv_vcpu_set_sys_reg(cpu->hvf->fd, HV_SYS_REG_MPIDR_EL1,
+    ret = hv_vcpu_set_sys_reg(cpu->accel->fd, HV_SYS_REG_MPIDR_EL1,
                               arm_cpu->mp_affinity);
     assert_hvf_ok(ret);
 
-    ret = hv_vcpu_get_sys_reg(cpu->hvf->fd, HV_SYS_REG_ID_AA64PFR0_EL1, &pfr);
+    ret = hv_vcpu_get_sys_reg(cpu->accel->fd, HV_SYS_REG_ID_AA64PFR0_EL1, &pfr);
     assert_hvf_ok(ret);
     pfr |= env->gicv3state ? (1 << 24) : 0;
-    ret = hv_vcpu_set_sys_reg(cpu->hvf->fd, HV_SYS_REG_ID_AA64PFR0_EL1, pfr);
+    ret = hv_vcpu_set_sys_reg(cpu->accel->fd, HV_SYS_REG_ID_AA64PFR0_EL1, pfr);
     assert_hvf_ok(ret);
 
     /* We're limited to underlying hardware caps, override internal versions */
-    ret = hv_vcpu_get_sys_reg(cpu->hvf->fd, HV_SYS_REG_ID_AA64MMFR0_EL1,
+    ret = hv_vcpu_get_sys_reg(cpu->accel->fd, HV_SYS_REG_ID_AA64MMFR0_EL1,
                               &arm_cpu->isar.id_aa64mmfr0);
     assert_hvf_ok(ret);
 
@@ -994,7 +994,7 @@ int hvf_arch_init_vcpu(CPUState *cpu)
 void hvf_kick_vcpu_thread(CPUState *cpu)
 {
     cpus_kick_thread(cpu);
-    hv_vcpus_exit(&cpu->hvf->fd, 1);
+    hv_vcpus_exit(&cpu->accel->fd, 1);
 }
 
 static void hvf_raise_exception(CPUState *cpu, uint32_t excp,
@@ -1678,13 +1678,13 @@ static int hvf_inject_interrupts(CPUState *cpu)
 {
     if (cpu->interrupt_request & CPU_INTERRUPT_FIQ) {
         trace_hvf_inject_fiq();
-        hv_vcpu_set_pending_interrupt(cpu->hvf->fd, HV_INTERRUPT_TYPE_FIQ,
+        hv_vcpu_set_pending_interrupt(cpu->accel->fd, HV_INTERRUPT_TYPE_FIQ,
                                       true);
     }
 
     if (cpu->interrupt_request & CPU_INTERRUPT_HARD) {
         trace_hvf_inject_irq();
-        hv_vcpu_set_pending_interrupt(cpu->hvf->fd, HV_INTERRUPT_TYPE_IRQ,
+        hv_vcpu_set_pending_interrupt(cpu->accel->fd, HV_INTERRUPT_TYPE_IRQ,
                                       true);
     }
 
@@ -1718,7 +1718,7 @@ static void hvf_wait_for_ipi(CPUState *cpu, struct timespec *ts)
      */
     qatomic_set_mb(&cpu->thread_kicked, false);
     qemu_mutex_unlock_iothread();
-    pselect(0, 0, 0, 0, ts, &cpu->hvf->unblock_ipi_mask);
+    pselect(0, 0, 0, 0, ts, &cpu->accel->unblock_ipi_mask);
     qemu_mutex_lock_iothread();
 }
 
@@ -1739,7 +1739,7 @@ static void hvf_wfi(CPUState *cpu)
         return;
     }
 
-    r = hv_vcpu_get_sys_reg(cpu->hvf->fd, HV_SYS_REG_CNTV_CTL_EL0, &ctl);
+    r = hv_vcpu_get_sys_reg(cpu->accel->fd, HV_SYS_REG_CNTV_CTL_EL0, &ctl);
     assert_hvf_ok(r);
 
     if (!(ctl & 1) || (ctl & 2)) {
@@ -1748,7 +1748,7 @@ static void hvf_wfi(CPUState *cpu)
         return;
     }
 
-    r = hv_vcpu_get_sys_reg(cpu->hvf->fd, HV_SYS_REG_CNTV_CVAL_EL0, &cval);
+    r = hv_vcpu_get_sys_reg(cpu->accel->fd, HV_SYS_REG_CNTV_CVAL_EL0, &cval);
     assert_hvf_ok(r);
 
     ticks_to_sleep = cval - hvf_vtimer_val();
@@ -1781,12 +1781,12 @@ static void hvf_sync_vtimer(CPUState *cpu)
     uint64_t ctl;
     bool irq_state;
 
-    if (!cpu->hvf->vtimer_masked) {
+    if (!cpu->accel->vtimer_masked) {
         /* We will get notified on vtimer changes by hvf, nothing to do */
         return;
     }
 
-    r = hv_vcpu_get_sys_reg(cpu->hvf->fd, HV_SYS_REG_CNTV_CTL_EL0, &ctl);
+    r = hv_vcpu_get_sys_reg(cpu->accel->fd, HV_SYS_REG_CNTV_CTL_EL0, &ctl);
     assert_hvf_ok(r);
 
     irq_state = (ctl & (TMR_CTL_ENABLE | TMR_CTL_IMASK | TMR_CTL_ISTATUS)) ==
@@ -1795,8 +1795,8 @@ static void hvf_sync_vtimer(CPUState *cpu)
 
     if (!irq_state) {
         /* Timer no longer asserting, we can unmask it */
-        hv_vcpu_set_vtimer_mask(cpu->hvf->fd, false);
-        cpu->hvf->vtimer_masked = false;
+        hv_vcpu_set_vtimer_mask(cpu->accel->fd, false);
+        cpu->accel->vtimer_masked = false;
     }
 }
 
@@ -1805,7 +1805,7 @@ int hvf_vcpu_exec(CPUState *cpu)
     ARMCPU *arm_cpu = ARM_CPU(cpu);
     CPUARMState *env = &arm_cpu->env;
     int ret;
-    hv_vcpu_exit_t *hvf_exit = cpu->hvf->exit;
+    hv_vcpu_exit_t *hvf_exit = cpu->accel->exit;
     hv_return_t r;
     bool advance_pc = false;
 
@@ -1821,7 +1821,7 @@ int hvf_vcpu_exec(CPUState *cpu)
     flush_cpu_state(cpu);
 
     qemu_mutex_unlock_iothread();
-    assert_hvf_ok(hv_vcpu_run(cpu->hvf->fd));
+    assert_hvf_ok(hv_vcpu_run(cpu->accel->fd));
 
     /* handle VMEXIT */
     uint64_t exit_reason = hvf_exit->reason;
@@ -1836,7 +1836,7 @@ int hvf_vcpu_exec(CPUState *cpu)
         break;
     case HV_EXIT_REASON_VTIMER_ACTIVATED:
         qemu_set_irq(arm_cpu->gt_timer_outputs[GTIMER_VIRT], 1);
-        cpu->hvf->vtimer_masked = true;
+        cpu->accel->vtimer_masked = true;
         return 0;
     case HV_EXIT_REASON_CANCELED:
         /* we got kicked, no exit to process */
@@ -1990,10 +1990,10 @@ int hvf_vcpu_exec(CPUState *cpu)
 
         flush_cpu_state(cpu);
 
-        r = hv_vcpu_get_reg(cpu->hvf->fd, HV_REG_PC, &pc);
+        r = hv_vcpu_get_reg(cpu->accel->fd, HV_REG_PC, &pc);
         assert_hvf_ok(r);
         pc += 4;
-        r = hv_vcpu_set_reg(cpu->hvf->fd, HV_REG_PC, pc);
+        r = hv_vcpu_set_reg(cpu->accel->fd, HV_REG_PC, pc);
         assert_hvf_ok(r);
 
         /* Handle single-stepping over instructions which trigger a VM exit */
@@ -2113,29 +2113,29 @@ static void hvf_put_gdbstub_debug_registers(CPUState *cpu)
 
     for (i = 0; i < cur_hw_bps; i++) {
         HWBreakpoint *bp = get_hw_bp(i);
-        r = hv_vcpu_set_sys_reg(cpu->hvf->fd, dbgbcr_regs[i], bp->bcr);
+        r = hv_vcpu_set_sys_reg(cpu->accel->fd, dbgbcr_regs[i], bp->bcr);
         assert_hvf_ok(r);
-        r = hv_vcpu_set_sys_reg(cpu->hvf->fd, dbgbvr_regs[i], bp->bvr);
+        r = hv_vcpu_set_sys_reg(cpu->accel->fd, dbgbvr_regs[i], bp->bvr);
         assert_hvf_ok(r);
     }
     for (i = cur_hw_bps; i < max_hw_bps; i++) {
-        r = hv_vcpu_set_sys_reg(cpu->hvf->fd, dbgbcr_regs[i], 0);
+        r = hv_vcpu_set_sys_reg(cpu->accel->fd, dbgbcr_regs[i], 0);
         assert_hvf_ok(r);
-        r = hv_vcpu_set_sys_reg(cpu->hvf->fd, dbgbvr_regs[i], 0);
+        r = hv_vcpu_set_sys_reg(cpu->accel->fd, dbgbvr_regs[i], 0);
         assert_hvf_ok(r);
     }
 
     for (i = 0; i < cur_hw_wps; i++) {
         HWWatchpoint *wp = get_hw_wp(i);
-        r = hv_vcpu_set_sys_reg(cpu->hvf->fd, dbgwcr_regs[i], wp->wcr);
+        r = hv_vcpu_set_sys_reg(cpu->accel->fd, dbgwcr_regs[i], wp->wcr);
         assert_hvf_ok(r);
-        r = hv_vcpu_set_sys_reg(cpu->hvf->fd, dbgwvr_regs[i], wp->wvr);
+        r = hv_vcpu_set_sys_reg(cpu->accel->fd, dbgwvr_regs[i], wp->wvr);
         assert_hvf_ok(r);
     }
     for (i = cur_hw_wps; i < max_hw_wps; i++) {
-        r = hv_vcpu_set_sys_reg(cpu->hvf->fd, dbgwcr_regs[i], 0);
+        r = hv_vcpu_set_sys_reg(cpu->accel->fd, dbgwcr_regs[i], 0);
         assert_hvf_ok(r);
-        r = hv_vcpu_set_sys_reg(cpu->hvf->fd, dbgwvr_regs[i], 0);
+        r = hv_vcpu_set_sys_reg(cpu->accel->fd, dbgwvr_regs[i], 0);
         assert_hvf_ok(r);
     }
 }
@@ -2152,19 +2152,19 @@ static void hvf_put_guest_debug_registers(CPUState *cpu)
     int i;
 
     for (i = 0; i < max_hw_bps; i++) {
-        r = hv_vcpu_set_sys_reg(cpu->hvf->fd, dbgbcr_regs[i],
+        r = hv_vcpu_set_sys_reg(cpu->accel->fd, dbgbcr_regs[i],
                                 env->cp15.dbgbcr[i]);
         assert_hvf_ok(r);
-        r = hv_vcpu_set_sys_reg(cpu->hvf->fd, dbgbvr_regs[i],
+        r = hv_vcpu_set_sys_reg(cpu->accel->fd, dbgbvr_regs[i],
                                 env->cp15.dbgbvr[i]);
         assert_hvf_ok(r);
     }
 
     for (i = 0; i < max_hw_wps; i++) {
-        r = hv_vcpu_set_sys_reg(cpu->hvf->fd, dbgwcr_regs[i],
+        r = hv_vcpu_set_sys_reg(cpu->accel->fd, dbgwcr_regs[i],
                                 env->cp15.dbgwcr[i]);
         assert_hvf_ok(r);
-        r = hv_vcpu_set_sys_reg(cpu->hvf->fd, dbgwvr_regs[i],
+        r = hv_vcpu_set_sys_reg(cpu->accel->fd, dbgwvr_regs[i],
                                 env->cp15.dbgwvr[i]);
         assert_hvf_ok(r);
     }
@@ -2184,16 +2184,16 @@ static void hvf_arch_set_traps(void)
     /* Check whether guest debugging is enabled for at least one vCPU; if it
      * is, enable exiting the guest on all vCPUs */
     CPU_FOREACH(cpu) {
-        should_enable_traps |= cpu->hvf->guest_debug_enabled;
+        should_enable_traps |= cpu->accel->guest_debug_enabled;
     }
     CPU_FOREACH(cpu) {
         /* Set whether debug exceptions exit the guest */
-        r = hv_vcpu_set_trap_debug_exceptions(cpu->hvf->fd,
+        r = hv_vcpu_set_trap_debug_exceptions(cpu->accel->fd,
                                               should_enable_traps);
         assert_hvf_ok(r);
 
         /* Set whether accesses to debug registers exit the guest */
-        r = hv_vcpu_set_trap_debug_reg_accesses(cpu->hvf->fd,
+        r = hv_vcpu_set_trap_debug_reg_accesses(cpu->accel->fd,
                                                 should_enable_traps);
         assert_hvf_ok(r);
     }
@@ -2205,12 +2205,12 @@ void hvf_arch_update_guest_debug(CPUState *cpu)
     CPUARMState *env = &arm_cpu->env;
 
     /* Check whether guest debugging is enabled */
-    cpu->hvf->guest_debug_enabled = cpu->singlestep_enabled ||
+    cpu->accel->guest_debug_enabled = cpu->singlestep_enabled ||
                                     hvf_sw_breakpoints_active(cpu) ||
                                     hvf_arm_hw_debug_active(cpu);
 
     /* Update debug registers */
-    if (cpu->hvf->guest_debug_enabled) {
+    if (cpu->accel->guest_debug_enabled) {
         hvf_put_gdbstub_debug_registers(cpu);
     } else {
         hvf_put_guest_debug_registers(cpu);
diff --git a/target/i386/hvf/hvf.c b/target/i386/hvf/hvf.c
index f6775c942a..06ea5033c2 100644
--- a/target/i386/hvf/hvf.c
+++ b/target/i386/hvf/hvf.c
@@ -81,11 +81,11 @@ void vmx_update_tpr(CPUState *cpu)
     int tpr = cpu_get_apic_tpr(x86_cpu->apic_state) << 4;
     int irr = apic_get_highest_priority_irr(x86_cpu->apic_state);
 
-    wreg(cpu->hvf->fd, HV_X86_TPR, tpr);
+    wreg(cpu->accel->fd, HV_X86_TPR, tpr);
     if (irr == -1) {
-        wvmcs(cpu->hvf->fd, VMCS_TPR_THRESHOLD, 0);
+        wvmcs(cpu->accel->fd, VMCS_TPR_THRESHOLD, 0);
     } else {
-        wvmcs(cpu->hvf->fd, VMCS_TPR_THRESHOLD, (irr > tpr) ? tpr >> 4 :
+        wvmcs(cpu->accel->fd, VMCS_TPR_THRESHOLD, (irr > tpr) ? tpr >> 4 :
               irr >> 4);
     }
 }
@@ -93,7 +93,7 @@ void vmx_update_tpr(CPUState *cpu)
 static void update_apic_tpr(CPUState *cpu)
 {
     X86CPU *x86_cpu = X86_CPU(cpu);
-    int tpr = rreg(cpu->hvf->fd, HV_X86_TPR) >> 4;
+    int tpr = rreg(cpu->accel->fd, HV_X86_TPR) >> 4;
     cpu_set_apic_tpr(x86_cpu->apic_state, tpr);
 }
 
@@ -256,12 +256,12 @@ int hvf_arch_init_vcpu(CPUState *cpu)
     }
 
     /* set VMCS control fields */
-    wvmcs(cpu->hvf->fd, VMCS_PIN_BASED_CTLS,
+    wvmcs(cpu->accel->fd, VMCS_PIN_BASED_CTLS,
           cap2ctrl(hvf_state->hvf_caps->vmx_cap_pinbased,
                    VMCS_PIN_BASED_CTLS_EXTINT |
                    VMCS_PIN_BASED_CTLS_NMI |
                    VMCS_PIN_BASED_CTLS_VNMI));
-    wvmcs(cpu->hvf->fd, VMCS_PRI_PROC_BASED_CTLS,
+    wvmcs(cpu->accel->fd, VMCS_PRI_PROC_BASED_CTLS,
           cap2ctrl(hvf_state->hvf_caps->vmx_cap_procbased,
                    VMCS_PRI_PROC_BASED_CTLS_HLT |
                    VMCS_PRI_PROC_BASED_CTLS_MWAIT |
@@ -276,14 +276,14 @@ int hvf_arch_init_vcpu(CPUState *cpu)
         reqCap |= VMCS_PRI_PROC_BASED2_CTLS_RDTSCP;
     }
 
-    wvmcs(cpu->hvf->fd, VMCS_SEC_PROC_BASED_CTLS,
+    wvmcs(cpu->accel->fd, VMCS_SEC_PROC_BASED_CTLS,
           cap2ctrl(hvf_state->hvf_caps->vmx_cap_procbased2, reqCap));
 
-    wvmcs(cpu->hvf->fd, VMCS_ENTRY_CTLS, cap2ctrl(hvf_state->hvf_caps->vmx_cap_entry,
+    wvmcs(cpu->accel->fd, VMCS_ENTRY_CTLS, cap2ctrl(hvf_state->hvf_caps->vmx_cap_entry,
           0));
-    wvmcs(cpu->hvf->fd, VMCS_EXCEPTION_BITMAP, 0); /* Double fault */
+    wvmcs(cpu->accel->fd, VMCS_EXCEPTION_BITMAP, 0); /* Double fault */
 
-    wvmcs(cpu->hvf->fd, VMCS_TPR_THRESHOLD, 0);
+    wvmcs(cpu->accel->fd, VMCS_TPR_THRESHOLD, 0);
 
     x86cpu = X86_CPU(cpu);
     x86cpu->env.xsave_buf_len = 4096;
@@ -295,18 +295,18 @@ int hvf_arch_init_vcpu(CPUState *cpu)
      */
     assert(hvf_get_supported_cpuid(0xd, 0, R_ECX) <= x86cpu->env.xsave_buf_len);
 
-    hv_vcpu_enable_native_msr(cpu->hvf->fd, MSR_STAR, 1);
-    hv_vcpu_enable_native_msr(cpu->hvf->fd, MSR_LSTAR, 1);
-    hv_vcpu_enable_native_msr(cpu->hvf->fd, MSR_CSTAR, 1);
-    hv_vcpu_enable_native_msr(cpu->hvf->fd, MSR_FMASK, 1);
-    hv_vcpu_enable_native_msr(cpu->hvf->fd, MSR_FSBASE, 1);
-    hv_vcpu_enable_native_msr(cpu->hvf->fd, MSR_GSBASE, 1);
-    hv_vcpu_enable_native_msr(cpu->hvf->fd, MSR_KERNELGSBASE, 1);
-    hv_vcpu_enable_native_msr(cpu->hvf->fd, MSR_TSC_AUX, 1);
-    hv_vcpu_enable_native_msr(cpu->hvf->fd, MSR_IA32_TSC, 1);
-    hv_vcpu_enable_native_msr(cpu->hvf->fd, MSR_IA32_SYSENTER_CS, 1);
-    hv_vcpu_enable_native_msr(cpu->hvf->fd, MSR_IA32_SYSENTER_EIP, 1);
-    hv_vcpu_enable_native_msr(cpu->hvf->fd, MSR_IA32_SYSENTER_ESP, 1);
+    hv_vcpu_enable_native_msr(cpu->accel->fd, MSR_STAR, 1);
+    hv_vcpu_enable_native_msr(cpu->accel->fd, MSR_LSTAR, 1);
+    hv_vcpu_enable_native_msr(cpu->accel->fd, MSR_CSTAR, 1);
+    hv_vcpu_enable_native_msr(cpu->accel->fd, MSR_FMASK, 1);
+    hv_vcpu_enable_native_msr(cpu->accel->fd, MSR_FSBASE, 1);
+    hv_vcpu_enable_native_msr(cpu->accel->fd, MSR_GSBASE, 1);
+    hv_vcpu_enable_native_msr(cpu->accel->fd, MSR_KERNELGSBASE, 1);
+    hv_vcpu_enable_native_msr(cpu->accel->fd, MSR_TSC_AUX, 1);
+    hv_vcpu_enable_native_msr(cpu->accel->fd, MSR_IA32_TSC, 1);
+    hv_vcpu_enable_native_msr(cpu->accel->fd, MSR_IA32_SYSENTER_CS, 1);
+    hv_vcpu_enable_native_msr(cpu->accel->fd, MSR_IA32_SYSENTER_EIP, 1);
+    hv_vcpu_enable_native_msr(cpu->accel->fd, MSR_IA32_SYSENTER_ESP, 1);
 
     return 0;
 }
@@ -347,16 +347,16 @@ static void hvf_store_events(CPUState *cpu, uint32_t ins_len, uint64_t idtvec_in
         }
         if (idtvec_info & VMCS_IDT_VEC_ERRCODE_VALID) {
             env->has_error_code = true;
-            env->error_code = rvmcs(cpu->hvf->fd, VMCS_IDT_VECTORING_ERROR);
+            env->error_code = rvmcs(cpu->accel->fd, VMCS_IDT_VECTORING_ERROR);
         }
     }
-    if ((rvmcs(cpu->hvf->fd, VMCS_GUEST_INTERRUPTIBILITY) &
+    if ((rvmcs(cpu->accel->fd, VMCS_GUEST_INTERRUPTIBILITY) &
         VMCS_INTERRUPTIBILITY_NMI_BLOCKING)) {
         env->hflags2 |= HF2_NMI_MASK;
     } else {
         env->hflags2 &= ~HF2_NMI_MASK;
     }
-    if (rvmcs(cpu->hvf->fd, VMCS_GUEST_INTERRUPTIBILITY) &
+    if (rvmcs(cpu->accel->fd, VMCS_GUEST_INTERRUPTIBILITY) &
          (VMCS_INTERRUPTIBILITY_STI_BLOCKING |
          VMCS_INTERRUPTIBILITY_MOVSS_BLOCKING)) {
         env->hflags |= HF_INHIBIT_IRQ_MASK;
@@ -435,20 +435,20 @@ int hvf_vcpu_exec(CPUState *cpu)
             return EXCP_HLT;
         }
 
-        hv_return_t r  = hv_vcpu_run(cpu->hvf->fd);
+        hv_return_t r  = hv_vcpu_run(cpu->accel->fd);
         assert_hvf_ok(r);
 
         /* handle VMEXIT */
-        uint64_t exit_reason = rvmcs(cpu->hvf->fd, VMCS_EXIT_REASON);
-        uint64_t exit_qual = rvmcs(cpu->hvf->fd, VMCS_EXIT_QUALIFICATION);
-        uint32_t ins_len = (uint32_t)rvmcs(cpu->hvf->fd,
+        uint64_t exit_reason = rvmcs(cpu->accel->fd, VMCS_EXIT_REASON);
+        uint64_t exit_qual = rvmcs(cpu->accel->fd, VMCS_EXIT_QUALIFICATION);
+        uint32_t ins_len = (uint32_t)rvmcs(cpu->accel->fd,
                                            VMCS_EXIT_INSTRUCTION_LENGTH);
 
-        uint64_t idtvec_info = rvmcs(cpu->hvf->fd, VMCS_IDT_VECTORING_INFO);
+        uint64_t idtvec_info = rvmcs(cpu->accel->fd, VMCS_IDT_VECTORING_INFO);
 
         hvf_store_events(cpu, ins_len, idtvec_info);
-        rip = rreg(cpu->hvf->fd, HV_X86_RIP);
-        env->eflags = rreg(cpu->hvf->fd, HV_X86_RFLAGS);
+        rip = rreg(cpu->accel->fd, HV_X86_RIP);
+        env->eflags = rreg(cpu->accel->fd, HV_X86_RFLAGS);
 
         qemu_mutex_lock_iothread();
 
@@ -478,7 +478,7 @@ int hvf_vcpu_exec(CPUState *cpu)
         case EXIT_REASON_EPT_FAULT:
         {
             hvf_slot *slot;
-            uint64_t gpa = rvmcs(cpu->hvf->fd, VMCS_GUEST_PHYSICAL_ADDRESS);
+            uint64_t gpa = rvmcs(cpu->accel->fd, VMCS_GUEST_PHYSICAL_ADDRESS);
 
             if (((idtvec_info & VMCS_IDT_VEC_VALID) == 0) &&
                 ((exit_qual & EXIT_QUAL_NMIUDTI) != 0)) {
@@ -523,7 +523,7 @@ int hvf_vcpu_exec(CPUState *cpu)
                 store_regs(cpu);
                 break;
             } else if (!string && !in) {
-                RAX(env) = rreg(cpu->hvf->fd, HV_X86_RAX);
+                RAX(env) = rreg(cpu->accel->fd, HV_X86_RAX);
                 hvf_handle_io(env, port, &RAX(env), 1, size, 1);
                 macvm_set_rip(cpu, rip + ins_len);
                 break;
@@ -539,21 +539,21 @@ int hvf_vcpu_exec(CPUState *cpu)
             break;
         }
         case EXIT_REASON_CPUID: {
-            uint32_t rax = (uint32_t)rreg(cpu->hvf->fd, HV_X86_RAX);
-            uint32_t rbx = (uint32_t)rreg(cpu->hvf->fd, HV_X86_RBX);
-            uint32_t rcx = (uint32_t)rreg(cpu->hvf->fd, HV_X86_RCX);
-            uint32_t rdx = (uint32_t)rreg(cpu->hvf->fd, HV_X86_RDX);
+            uint32_t rax = (uint32_t)rreg(cpu->accel->fd, HV_X86_RAX);
+            uint32_t rbx = (uint32_t)rreg(cpu->accel->fd, HV_X86_RBX);
+            uint32_t rcx = (uint32_t)rreg(cpu->accel->fd, HV_X86_RCX);
+            uint32_t rdx = (uint32_t)rreg(cpu->accel->fd, HV_X86_RDX);
 
             if (rax == 1) {
                 /* CPUID1.ecx.OSXSAVE needs to know CR4 */
-                env->cr[4] = rvmcs(cpu->hvf->fd, VMCS_GUEST_CR4);
+                env->cr[4] = rvmcs(cpu->accel->fd, VMCS_GUEST_CR4);
             }
             hvf_cpu_x86_cpuid(env, rax, rcx, &rax, &rbx, &rcx, &rdx);
 
-            wreg(cpu->hvf->fd, HV_X86_RAX, rax);
-            wreg(cpu->hvf->fd, HV_X86_RBX, rbx);
-            wreg(cpu->hvf->fd, HV_X86_RCX, rcx);
-            wreg(cpu->hvf->fd, HV_X86_RDX, rdx);
+            wreg(cpu->accel->fd, HV_X86_RAX, rax);
+            wreg(cpu->accel->fd, HV_X86_RBX, rbx);
+            wreg(cpu->accel->fd, HV_X86_RCX, rcx);
+            wreg(cpu->accel->fd, HV_X86_RDX, rdx);
 
             macvm_set_rip(cpu, rip + ins_len);
             break;
@@ -561,16 +561,16 @@ int hvf_vcpu_exec(CPUState *cpu)
         case EXIT_REASON_XSETBV: {
             X86CPU *x86_cpu = X86_CPU(cpu);
             CPUX86State *env = &x86_cpu->env;
-            uint32_t eax = (uint32_t)rreg(cpu->hvf->fd, HV_X86_RAX);
-            uint32_t ecx = (uint32_t)rreg(cpu->hvf->fd, HV_X86_RCX);
-            uint32_t edx = (uint32_t)rreg(cpu->hvf->fd, HV_X86_RDX);
+            uint32_t eax = (uint32_t)rreg(cpu->accel->fd, HV_X86_RAX);
+            uint32_t ecx = (uint32_t)rreg(cpu->accel->fd, HV_X86_RCX);
+            uint32_t edx = (uint32_t)rreg(cpu->accel->fd, HV_X86_RDX);
 
             if (ecx) {
                 macvm_set_rip(cpu, rip + ins_len);
                 break;
             }
             env->xcr0 = ((uint64_t)edx << 32) | eax;
-            wreg(cpu->hvf->fd, HV_X86_XCR0, env->xcr0 | 1);
+            wreg(cpu->accel->fd, HV_X86_XCR0, env->xcr0 | 1);
             macvm_set_rip(cpu, rip + ins_len);
             break;
         }
@@ -609,11 +609,11 @@ int hvf_vcpu_exec(CPUState *cpu)
 
             switch (cr) {
             case 0x0: {
-                macvm_set_cr0(cpu->hvf->fd, RRX(env, reg));
+                macvm_set_cr0(cpu->accel->fd, RRX(env, reg));
                 break;
             }
             case 4: {
-                macvm_set_cr4(cpu->hvf->fd, RRX(env, reg));
+                macvm_set_cr4(cpu->accel->fd, RRX(env, reg));
                 break;
             }
             case 8: {
@@ -649,7 +649,7 @@ int hvf_vcpu_exec(CPUState *cpu)
             break;
         }
         case EXIT_REASON_TASK_SWITCH: {
-            uint64_t vinfo = rvmcs(cpu->hvf->fd, VMCS_IDT_VECTORING_INFO);
+            uint64_t vinfo = rvmcs(cpu->accel->fd, VMCS_IDT_VECTORING_INFO);
             x68_segment_selector sel = {.sel = exit_qual & 0xffff};
             vmx_handle_task_switch(cpu, sel, (exit_qual >> 30) & 0x3,
              vinfo & VMCS_INTR_VALID, vinfo & VECTORING_INFO_VECTOR_MASK, vinfo
@@ -662,8 +662,8 @@ int hvf_vcpu_exec(CPUState *cpu)
             break;
         }
         case EXIT_REASON_RDPMC:
-            wreg(cpu->hvf->fd, HV_X86_RAX, 0);
-            wreg(cpu->hvf->fd, HV_X86_RDX, 0);
+            wreg(cpu->accel->fd, HV_X86_RAX, 0);
+            wreg(cpu->accel->fd, HV_X86_RDX, 0);
             macvm_set_rip(cpu, rip + ins_len);
             break;
         case VMX_REASON_VMCALL:
diff --git a/target/i386/hvf/x86.c b/target/i386/hvf/x86.c
index d086584f26..8ceea6398e 100644
--- a/target/i386/hvf/x86.c
+++ b/target/i386/hvf/x86.c
@@ -61,11 +61,11 @@ bool x86_read_segment_descriptor(struct CPUState *cpu,
     }
 
     if (GDT_SEL == sel.ti) {
-        base  = rvmcs(cpu->hvf->fd, VMCS_GUEST_GDTR_BASE);
-        limit = rvmcs(cpu->hvf->fd, VMCS_GUEST_GDTR_LIMIT);
+        base  = rvmcs(cpu->accel->fd, VMCS_GUEST_GDTR_BASE);
+        limit = rvmcs(cpu->accel->fd, VMCS_GUEST_GDTR_LIMIT);
     } else {
-        base  = rvmcs(cpu->hvf->fd, VMCS_GUEST_LDTR_BASE);
-        limit = rvmcs(cpu->hvf->fd, VMCS_GUEST_LDTR_LIMIT);
+        base  = rvmcs(cpu->accel->fd, VMCS_GUEST_LDTR_BASE);
+        limit = rvmcs(cpu->accel->fd, VMCS_GUEST_LDTR_LIMIT);
     }
 
     if (sel.index * 8 >= limit) {
@@ -84,11 +84,11 @@ bool x86_write_segment_descriptor(struct CPUState *cpu,
     uint32_t limit;
     
     if (GDT_SEL == sel.ti) {
-        base  = rvmcs(cpu->hvf->fd, VMCS_GUEST_GDTR_BASE);
-        limit = rvmcs(cpu->hvf->fd, VMCS_GUEST_GDTR_LIMIT);
+        base  = rvmcs(cpu->accel->fd, VMCS_GUEST_GDTR_BASE);
+        limit = rvmcs(cpu->accel->fd, VMCS_GUEST_GDTR_LIMIT);
     } else {
-        base  = rvmcs(cpu->hvf->fd, VMCS_GUEST_LDTR_BASE);
-        limit = rvmcs(cpu->hvf->fd, VMCS_GUEST_LDTR_LIMIT);
+        base  = rvmcs(cpu->accel->fd, VMCS_GUEST_LDTR_BASE);
+        limit = rvmcs(cpu->accel->fd, VMCS_GUEST_LDTR_LIMIT);
     }
     
     if (sel.index * 8 >= limit) {
@@ -102,8 +102,8 @@ bool x86_write_segment_descriptor(struct CPUState *cpu,
 bool x86_read_call_gate(struct CPUState *cpu, struct x86_call_gate *idt_desc,
                         int gate)
 {
-    target_ulong base  = rvmcs(cpu->hvf->fd, VMCS_GUEST_IDTR_BASE);
-    uint32_t limit = rvmcs(cpu->hvf->fd, VMCS_GUEST_IDTR_LIMIT);
+    target_ulong base  = rvmcs(cpu->accel->fd, VMCS_GUEST_IDTR_BASE);
+    uint32_t limit = rvmcs(cpu->accel->fd, VMCS_GUEST_IDTR_LIMIT);
 
     memset(idt_desc, 0, sizeof(*idt_desc));
     if (gate * 8 >= limit) {
@@ -117,7 +117,7 @@ bool x86_read_call_gate(struct CPUState *cpu, struct x86_call_gate *idt_desc,
 
 bool x86_is_protected(struct CPUState *cpu)
 {
-    uint64_t cr0 = rvmcs(cpu->hvf->fd, VMCS_GUEST_CR0);
+    uint64_t cr0 = rvmcs(cpu->accel->fd, VMCS_GUEST_CR0);
     return cr0 & CR0_PE_MASK;
 }
 
@@ -135,7 +135,7 @@ bool x86_is_v8086(struct CPUState *cpu)
 
 bool x86_is_long_mode(struct CPUState *cpu)
 {
-    return rvmcs(cpu->hvf->fd, VMCS_GUEST_IA32_EFER) & MSR_EFER_LMA;
+    return rvmcs(cpu->accel->fd, VMCS_GUEST_IA32_EFER) & MSR_EFER_LMA;
 }
 
 bool x86_is_long64_mode(struct CPUState *cpu)
@@ -148,13 +148,13 @@ bool x86_is_long64_mode(struct CPUState *cpu)
 
 bool x86_is_paging_mode(struct CPUState *cpu)
 {
-    uint64_t cr0 = rvmcs(cpu->hvf->fd, VMCS_GUEST_CR0);
+    uint64_t cr0 = rvmcs(cpu->accel->fd, VMCS_GUEST_CR0);
     return cr0 & CR0_PG_MASK;
 }
 
 bool x86_is_pae_enabled(struct CPUState *cpu)
 {
-    uint64_t cr4 = rvmcs(cpu->hvf->fd, VMCS_GUEST_CR4);
+    uint64_t cr4 = rvmcs(cpu->accel->fd, VMCS_GUEST_CR4);
     return cr4 & CR4_PAE_MASK;
 }
 
diff --git a/target/i386/hvf/x86_descr.c b/target/i386/hvf/x86_descr.c
index a484942cfc..c2d2e9ee84 100644
--- a/target/i386/hvf/x86_descr.c
+++ b/target/i386/hvf/x86_descr.c
@@ -47,47 +47,47 @@ static const struct vmx_segment_field {
 
 uint32_t vmx_read_segment_limit(CPUState *cpu, X86Seg seg)
 {
-    return (uint32_t)rvmcs(cpu->hvf->fd, vmx_segment_fields[seg].limit);
+    return (uint32_t)rvmcs(cpu->accel->fd, vmx_segment_fields[seg].limit);
 }
 
 uint32_t vmx_read_segment_ar(CPUState *cpu, X86Seg seg)
 {
-    return (uint32_t)rvmcs(cpu->hvf->fd, vmx_segment_fields[seg].ar_bytes);
+    return (uint32_t)rvmcs(cpu->accel->fd, vmx_segment_fields[seg].ar_bytes);
 }
 
 uint64_t vmx_read_segment_base(CPUState *cpu, X86Seg seg)
 {
-    return rvmcs(cpu->hvf->fd, vmx_segment_fields[seg].base);
+    return rvmcs(cpu->accel->fd, vmx_segment_fields[seg].base);
 }
 
 x68_segment_selector vmx_read_segment_selector(CPUState *cpu, X86Seg seg)
 {
     x68_segment_selector sel;
-    sel.sel = rvmcs(cpu->hvf->fd, vmx_segment_fields[seg].selector);
+    sel.sel = rvmcs(cpu->accel->fd, vmx_segment_fields[seg].selector);
     return sel;
 }
 
 void vmx_write_segment_selector(struct CPUState *cpu, x68_segment_selector selector, X86Seg seg)
 {
-    wvmcs(cpu->hvf->fd, vmx_segment_fields[seg].selector, selector.sel);
+    wvmcs(cpu->accel->fd, vmx_segment_fields[seg].selector, selector.sel);
 }
 
 void vmx_read_segment_descriptor(struct CPUState *cpu, struct vmx_segment *desc, X86Seg seg)
 {
-    desc->sel = rvmcs(cpu->hvf->fd, vmx_segment_fields[seg].selector);
-    desc->base = rvmcs(cpu->hvf->fd, vmx_segment_fields[seg].base);
-    desc->limit = rvmcs(cpu->hvf->fd, vmx_segment_fields[seg].limit);
-    desc->ar = rvmcs(cpu->hvf->fd, vmx_segment_fields[seg].ar_bytes);
+    desc->sel = rvmcs(cpu->accel->fd, vmx_segment_fields[seg].selector);
+    desc->base = rvmcs(cpu->accel->fd, vmx_segment_fields[seg].base);
+    desc->limit = rvmcs(cpu->accel->fd, vmx_segment_fields[seg].limit);
+    desc->ar = rvmcs(cpu->accel->fd, vmx_segment_fields[seg].ar_bytes);
 }
 
 void vmx_write_segment_descriptor(CPUState *cpu, struct vmx_segment *desc, X86Seg seg)
 {
     const struct vmx_segment_field *sf = &vmx_segment_fields[seg];
 
-    wvmcs(cpu->hvf->fd, sf->base, desc->base);
-    wvmcs(cpu->hvf->fd, sf->limit, desc->limit);
-    wvmcs(cpu->hvf->fd, sf->selector, desc->sel);
-    wvmcs(cpu->hvf->fd, sf->ar_bytes, desc->ar);
+    wvmcs(cpu->accel->fd, sf->base, desc->base);
+    wvmcs(cpu->accel->fd, sf->limit, desc->limit);
+    wvmcs(cpu->accel->fd, sf->selector, desc->sel);
+    wvmcs(cpu->accel->fd, sf->ar_bytes, desc->ar);
 }
 
 void x86_segment_descriptor_to_vmx(struct CPUState *cpu, x68_segment_selector selector, struct x86_segment_descriptor *desc, struct vmx_segment *vmx_desc)
diff --git a/target/i386/hvf/x86_emu.c b/target/i386/hvf/x86_emu.c
index f5704f63e8..ccda568478 100644
--- a/target/i386/hvf/x86_emu.c
+++ b/target/i386/hvf/x86_emu.c
@@ -673,7 +673,7 @@ void simulate_rdmsr(struct CPUState *cpu)
 
     switch (msr) {
     case MSR_IA32_TSC:
-        val = rdtscp() + rvmcs(cpu->hvf->fd, VMCS_TSC_OFFSET);
+        val = rdtscp() + rvmcs(cpu->accel->fd, VMCS_TSC_OFFSET);
         break;
     case MSR_IA32_APICBASE:
         val = cpu_get_apic_base(X86_CPU(cpu)->apic_state);
@@ -682,16 +682,16 @@ void simulate_rdmsr(struct CPUState *cpu)
         val = x86_cpu->ucode_rev;
         break;
     case MSR_EFER:
-        val = rvmcs(cpu->hvf->fd, VMCS_GUEST_IA32_EFER);
+        val = rvmcs(cpu->accel->fd, VMCS_GUEST_IA32_EFER);
         break;
     case MSR_FSBASE:
-        val = rvmcs(cpu->hvf->fd, VMCS_GUEST_FS_BASE);
+        val = rvmcs(cpu->accel->fd, VMCS_GUEST_FS_BASE);
         break;
     case MSR_GSBASE:
-        val = rvmcs(cpu->hvf->fd, VMCS_GUEST_GS_BASE);
+        val = rvmcs(cpu->accel->fd, VMCS_GUEST_GS_BASE);
         break;
     case MSR_KERNELGSBASE:
-        val = rvmcs(cpu->hvf->fd, VMCS_HOST_FS_BASE);
+        val = rvmcs(cpu->accel->fd, VMCS_HOST_FS_BASE);
         break;
     case MSR_STAR:
         abort();
@@ -779,13 +779,13 @@ void simulate_wrmsr(struct CPUState *cpu)
         cpu_set_apic_base(X86_CPU(cpu)->apic_state, data);
         break;
     case MSR_FSBASE:
-        wvmcs(cpu->hvf->fd, VMCS_GUEST_FS_BASE, data);
+        wvmcs(cpu->accel->fd, VMCS_GUEST_FS_BASE, data);
         break;
     case MSR_GSBASE:
-        wvmcs(cpu->hvf->fd, VMCS_GUEST_GS_BASE, data);
+        wvmcs(cpu->accel->fd, VMCS_GUEST_GS_BASE, data);
         break;
     case MSR_KERNELGSBASE:
-        wvmcs(cpu->hvf->fd, VMCS_HOST_FS_BASE, data);
+        wvmcs(cpu->accel->fd, VMCS_HOST_FS_BASE, data);
         break;
     case MSR_STAR:
         abort();
@@ -798,9 +798,9 @@ void simulate_wrmsr(struct CPUState *cpu)
         break;
     case MSR_EFER:
         /*printf("new efer %llx\n", EFER(cpu));*/
-        wvmcs(cpu->hvf->fd, VMCS_GUEST_IA32_EFER, data);
+        wvmcs(cpu->accel->fd, VMCS_GUEST_IA32_EFER, data);
         if (data & MSR_EFER_NXE) {
-            hv_vcpu_invalidate_tlb(cpu->hvf->fd);
+            hv_vcpu_invalidate_tlb(cpu->accel->fd);
         }
         break;
     case MSR_MTRRphysBase(0):
@@ -1424,21 +1424,21 @@ void load_regs(struct CPUState *cpu)
     CPUX86State *env = &x86_cpu->env;
 
     int i = 0;
-    RRX(env, R_EAX) = rreg(cpu->hvf->fd, HV_X86_RAX);
-    RRX(env, R_EBX) = rreg(cpu->hvf->fd, HV_X86_RBX);
-    RRX(env, R_ECX) = rreg(cpu->hvf->fd, HV_X86_RCX);
-    RRX(env, R_EDX) = rreg(cpu->hvf->fd, HV_X86_RDX);
-    RRX(env, R_ESI) = rreg(cpu->hvf->fd, HV_X86_RSI);
-    RRX(env, R_EDI) = rreg(cpu->hvf->fd, HV_X86_RDI);
-    RRX(env, R_ESP) = rreg(cpu->hvf->fd, HV_X86_RSP);
-    RRX(env, R_EBP) = rreg(cpu->hvf->fd, HV_X86_RBP);
+    RRX(env, R_EAX) = rreg(cpu->accel->fd, HV_X86_RAX);
+    RRX(env, R_EBX) = rreg(cpu->accel->fd, HV_X86_RBX);
+    RRX(env, R_ECX) = rreg(cpu->accel->fd, HV_X86_RCX);
+    RRX(env, R_EDX) = rreg(cpu->accel->fd, HV_X86_RDX);
+    RRX(env, R_ESI) = rreg(cpu->accel->fd, HV_X86_RSI);
+    RRX(env, R_EDI) = rreg(cpu->accel->fd, HV_X86_RDI);
+    RRX(env, R_ESP) = rreg(cpu->accel->fd, HV_X86_RSP);
+    RRX(env, R_EBP) = rreg(cpu->accel->fd, HV_X86_RBP);
     for (i = 8; i < 16; i++) {
-        RRX(env, i) = rreg(cpu->hvf->fd, HV_X86_RAX + i);
+        RRX(env, i) = rreg(cpu->accel->fd, HV_X86_RAX + i);
     }
 
-    env->eflags = rreg(cpu->hvf->fd, HV_X86_RFLAGS);
+    env->eflags = rreg(cpu->accel->fd, HV_X86_RFLAGS);
     rflags_to_lflags(env);
-    env->eip = rreg(cpu->hvf->fd, HV_X86_RIP);
+    env->eip = rreg(cpu->accel->fd, HV_X86_RIP);
 }
 
 void store_regs(struct CPUState *cpu)
@@ -1447,20 +1447,20 @@ void store_regs(struct CPUState *cpu)
     CPUX86State *env = &x86_cpu->env;
 
     int i = 0;
-    wreg(cpu->hvf->fd, HV_X86_RAX, RAX(env));
-    wreg(cpu->hvf->fd, HV_X86_RBX, RBX(env));
-    wreg(cpu->hvf->fd, HV_X86_RCX, RCX(env));
-    wreg(cpu->hvf->fd, HV_X86_RDX, RDX(env));
-    wreg(cpu->hvf->fd, HV_X86_RSI, RSI(env));
-    wreg(cpu->hvf->fd, HV_X86_RDI, RDI(env));
-    wreg(cpu->hvf->fd, HV_X86_RBP, RBP(env));
-    wreg(cpu->hvf->fd, HV_X86_RSP, RSP(env));
+    wreg(cpu->accel->fd, HV_X86_RAX, RAX(env));
+    wreg(cpu->accel->fd, HV_X86_RBX, RBX(env));
+    wreg(cpu->accel->fd, HV_X86_RCX, RCX(env));
+    wreg(cpu->accel->fd, HV_X86_RDX, RDX(env));
+    wreg(cpu->accel->fd, HV_X86_RSI, RSI(env));
+    wreg(cpu->accel->fd, HV_X86_RDI, RDI(env));
+    wreg(cpu->accel->fd, HV_X86_RBP, RBP(env));
+    wreg(cpu->accel->fd, HV_X86_RSP, RSP(env));
     for (i = 8; i < 16; i++) {
-        wreg(cpu->hvf->fd, HV_X86_RAX + i, RRX(env, i));
+        wreg(cpu->accel->fd, HV_X86_RAX + i, RRX(env, i));
     }
 
     lflags_to_rflags(env);
-    wreg(cpu->hvf->fd, HV_X86_RFLAGS, env->eflags);
+    wreg(cpu->accel->fd, HV_X86_RFLAGS, env->eflags);
     macvm_set_rip(cpu, env->eip);
 }
 
diff --git a/target/i386/hvf/x86_mmu.c b/target/i386/hvf/x86_mmu.c
index 96d117567e..8cd08622a1 100644
--- a/target/i386/hvf/x86_mmu.c
+++ b/target/i386/hvf/x86_mmu.c
@@ -126,7 +126,7 @@ static bool test_pt_entry(struct CPUState *cpu, struct gpt_translation *pt,
         pt->err_code |= MMU_PAGE_PT;
     }
 
-    uint32_t cr0 = rvmcs(cpu->hvf->fd, VMCS_GUEST_CR0);
+    uint32_t cr0 = rvmcs(cpu->accel->fd, VMCS_GUEST_CR0);
     /* check protection */
     if (cr0 & CR0_WP_MASK) {
         if (pt->write_access && !pte_write_access(pte)) {
@@ -171,7 +171,7 @@ static bool walk_gpt(struct CPUState *cpu, target_ulong addr, int err_code,
 {
     int top_level, level;
     bool is_large = false;
-    target_ulong cr3 = rvmcs(cpu->hvf->fd, VMCS_GUEST_CR3);
+    target_ulong cr3 = rvmcs(cpu->accel->fd, VMCS_GUEST_CR3);
     uint64_t page_mask = pae ? PAE_PTE_PAGE_MASK : LEGACY_PTE_PAGE_MASK;
     
     memset(pt, 0, sizeof(*pt));
diff --git a/target/i386/hvf/x86_task.c b/target/i386/hvf/x86_task.c
index beaeec0687..f09bfbdda5 100644
--- a/target/i386/hvf/x86_task.c
+++ b/target/i386/hvf/x86_task.c
@@ -61,7 +61,7 @@ static void load_state_from_tss32(CPUState *cpu, struct x86_tss_segment32 *tss)
     X86CPU *x86_cpu = X86_CPU(cpu);
     CPUX86State *env = &x86_cpu->env;
 
-    wvmcs(cpu->hvf->fd, VMCS_GUEST_CR3, tss->cr3);
+    wvmcs(cpu->accel->fd, VMCS_GUEST_CR3, tss->cr3);
 
     env->eip = tss->eip;
     env->eflags = tss->eflags | 2;
@@ -110,11 +110,11 @@ static int task_switch_32(CPUState *cpu, x68_segment_selector tss_sel, x68_segme
 
 void vmx_handle_task_switch(CPUState *cpu, x68_segment_selector tss_sel, int reason, bool gate_valid, uint8_t gate, uint64_t gate_type)
 {
-    uint64_t rip = rreg(cpu->hvf->fd, HV_X86_RIP);
+    uint64_t rip = rreg(cpu->accel->fd, HV_X86_RIP);
     if (!gate_valid || (gate_type != VMCS_INTR_T_HWEXCEPTION &&
                         gate_type != VMCS_INTR_T_HWINTR &&
                         gate_type != VMCS_INTR_T_NMI)) {
-        int ins_len = rvmcs(cpu->hvf->fd, VMCS_EXIT_INSTRUCTION_LENGTH);
+        int ins_len = rvmcs(cpu->accel->fd, VMCS_EXIT_INSTRUCTION_LENGTH);
         macvm_set_rip(cpu, rip + ins_len);
         return;
     }
@@ -173,12 +173,12 @@ void vmx_handle_task_switch(CPUState *cpu, x68_segment_selector tss_sel, int rea
         //ret = task_switch_16(cpu, tss_sel, old_tss_sel, old_tss_base, &next_tss_desc);
         VM_PANIC("task_switch_16");
 
-    macvm_set_cr0(cpu->hvf->fd, rvmcs(cpu->hvf->fd, VMCS_GUEST_CR0) |
+    macvm_set_cr0(cpu->accel->fd, rvmcs(cpu->accel->fd, VMCS_GUEST_CR0) |
                                 CR0_TS_MASK);
     x86_segment_descriptor_to_vmx(cpu, tss_sel, &next_tss_desc, &vmx_seg);
     vmx_write_segment_descriptor(cpu, &vmx_seg, R_TR);
 
     store_regs(cpu);
 
-    hv_vcpu_invalidate_tlb(cpu->hvf->fd);
+    hv_vcpu_invalidate_tlb(cpu->accel->fd);
 }
diff --git a/target/i386/hvf/x86hvf.c b/target/i386/hvf/x86hvf.c
index dfa500b81d..852e3bbf71 100644
--- a/target/i386/hvf/x86hvf.c
+++ b/target/i386/hvf/x86hvf.c
@@ -77,7 +77,7 @@ void hvf_put_xsave(CPUState *cpu)
 
     x86_cpu_xsave_all_areas(X86_CPU(cpu), xsave, xsave_len);
 
-    if (hv_vcpu_write_fpstate(cpu->hvf->fd, xsave, xsave_len)) {
+    if (hv_vcpu_write_fpstate(cpu->accel->fd, xsave, xsave_len)) {
         abort();
     }
 }
@@ -87,19 +87,19 @@ static void hvf_put_segments(CPUState *cpu)
     CPUX86State *env = &X86_CPU(cpu)->env;
     struct vmx_segment seg;
     
-    wvmcs(cpu->hvf->fd, VMCS_GUEST_IDTR_LIMIT, env->idt.limit);
-    wvmcs(cpu->hvf->fd, VMCS_GUEST_IDTR_BASE, env->idt.base);
+    wvmcs(cpu->accel->fd, VMCS_GUEST_IDTR_LIMIT, env->idt.limit);
+    wvmcs(cpu->accel->fd, VMCS_GUEST_IDTR_BASE, env->idt.base);
 
-    wvmcs(cpu->hvf->fd, VMCS_GUEST_GDTR_LIMIT, env->gdt.limit);
-    wvmcs(cpu->hvf->fd, VMCS_GUEST_GDTR_BASE, env->gdt.base);
+    wvmcs(cpu->accel->fd, VMCS_GUEST_GDTR_LIMIT, env->gdt.limit);
+    wvmcs(cpu->accel->fd, VMCS_GUEST_GDTR_BASE, env->gdt.base);
 
-    /* wvmcs(cpu->hvf->fd, VMCS_GUEST_CR2, env->cr[2]); */
-    wvmcs(cpu->hvf->fd, VMCS_GUEST_CR3, env->cr[3]);
+    /* wvmcs(cpu->accel->fd, VMCS_GUEST_CR2, env->cr[2]); */
+    wvmcs(cpu->accel->fd, VMCS_GUEST_CR3, env->cr[3]);
     vmx_update_tpr(cpu);
-    wvmcs(cpu->hvf->fd, VMCS_GUEST_IA32_EFER, env->efer);
+    wvmcs(cpu->accel->fd, VMCS_GUEST_IA32_EFER, env->efer);
 
-    macvm_set_cr4(cpu->hvf->fd, env->cr[4]);
-    macvm_set_cr0(cpu->hvf->fd, env->cr[0]);
+    macvm_set_cr4(cpu->accel->fd, env->cr[4]);
+    macvm_set_cr0(cpu->accel->fd, env->cr[0]);
 
     hvf_set_segment(cpu, &seg, &env->segs[R_CS], false);
     vmx_write_segment_descriptor(cpu, &seg, R_CS);
@@ -130,24 +130,24 @@ void hvf_put_msrs(CPUState *cpu)
 {
     CPUX86State *env = &X86_CPU(cpu)->env;
 
-    hv_vcpu_write_msr(cpu->hvf->fd, MSR_IA32_SYSENTER_CS,
+    hv_vcpu_write_msr(cpu->accel->fd, MSR_IA32_SYSENTER_CS,
                       env->sysenter_cs);
-    hv_vcpu_write_msr(cpu->hvf->fd, MSR_IA32_SYSENTER_ESP,
+    hv_vcpu_write_msr(cpu->accel->fd, MSR_IA32_SYSENTER_ESP,
                       env->sysenter_esp);
-    hv_vcpu_write_msr(cpu->hvf->fd, MSR_IA32_SYSENTER_EIP,
+    hv_vcpu_write_msr(cpu->accel->fd, MSR_IA32_SYSENTER_EIP,
                       env->sysenter_eip);
 
-    hv_vcpu_write_msr(cpu->hvf->fd, MSR_STAR, env->star);
+    hv_vcpu_write_msr(cpu->accel->fd, MSR_STAR, env->star);
 
 #ifdef TARGET_X86_64
-    hv_vcpu_write_msr(cpu->hvf->fd, MSR_CSTAR, env->cstar);
-    hv_vcpu_write_msr(cpu->hvf->fd, MSR_KERNELGSBASE, env->kernelgsbase);
-    hv_vcpu_write_msr(cpu->hvf->fd, MSR_FMASK, env->fmask);
-    hv_vcpu_write_msr(cpu->hvf->fd, MSR_LSTAR, env->lstar);
+    hv_vcpu_write_msr(cpu->accel->fd, MSR_CSTAR, env->cstar);
+    hv_vcpu_write_msr(cpu->accel->fd, MSR_KERNELGSBASE, env->kernelgsbase);
+    hv_vcpu_write_msr(cpu->accel->fd, MSR_FMASK, env->fmask);
+    hv_vcpu_write_msr(cpu->accel->fd, MSR_LSTAR, env->lstar);
 #endif
 
-    hv_vcpu_write_msr(cpu->hvf->fd, MSR_GSBASE, env->segs[R_GS].base);
-    hv_vcpu_write_msr(cpu->hvf->fd, MSR_FSBASE, env->segs[R_FS].base);
+    hv_vcpu_write_msr(cpu->accel->fd, MSR_GSBASE, env->segs[R_GS].base);
+    hv_vcpu_write_msr(cpu->accel->fd, MSR_FSBASE, env->segs[R_FS].base);
 }
 
 
@@ -156,7 +156,7 @@ void hvf_get_xsave(CPUState *cpu)
     void *xsave = X86_CPU(cpu)->env.xsave_buf;
     uint32_t xsave_len = X86_CPU(cpu)->env.xsave_buf_len;
 
-    if (hv_vcpu_read_fpstate(cpu->hvf->fd, xsave, xsave_len)) {
+    if (hv_vcpu_read_fpstate(cpu->accel->fd, xsave, xsave_len)) {
         abort();
     }
 
@@ -195,17 +195,17 @@ static void hvf_get_segments(CPUState *cpu)
     vmx_read_segment_descriptor(cpu, &seg, R_LDTR);
     hvf_get_segment(&env->ldt, &seg);
 
-    env->idt.limit = rvmcs(cpu->hvf->fd, VMCS_GUEST_IDTR_LIMIT);
-    env->idt.base = rvmcs(cpu->hvf->fd, VMCS_GUEST_IDTR_BASE);
-    env->gdt.limit = rvmcs(cpu->hvf->fd, VMCS_GUEST_GDTR_LIMIT);
-    env->gdt.base = rvmcs(cpu->hvf->fd, VMCS_GUEST_GDTR_BASE);
+    env->idt.limit = rvmcs(cpu->accel->fd, VMCS_GUEST_IDTR_LIMIT);
+    env->idt.base = rvmcs(cpu->accel->fd, VMCS_GUEST_IDTR_BASE);
+    env->gdt.limit = rvmcs(cpu->accel->fd, VMCS_GUEST_GDTR_LIMIT);
+    env->gdt.base = rvmcs(cpu->accel->fd, VMCS_GUEST_GDTR_BASE);
 
-    env->cr[0] = rvmcs(cpu->hvf->fd, VMCS_GUEST_CR0);
+    env->cr[0] = rvmcs(cpu->accel->fd, VMCS_GUEST_CR0);
     env->cr[2] = 0;
-    env->cr[3] = rvmcs(cpu->hvf->fd, VMCS_GUEST_CR3);
-    env->cr[4] = rvmcs(cpu->hvf->fd, VMCS_GUEST_CR4);
+    env->cr[3] = rvmcs(cpu->accel->fd, VMCS_GUEST_CR3);
+    env->cr[4] = rvmcs(cpu->accel->fd, VMCS_GUEST_CR4);
     
-    env->efer = rvmcs(cpu->hvf->fd, VMCS_GUEST_IA32_EFER);
+    env->efer = rvmcs(cpu->accel->fd, VMCS_GUEST_IA32_EFER);
 }
 
 void hvf_get_msrs(CPUState *cpu)
@@ -213,27 +213,27 @@ void hvf_get_msrs(CPUState *cpu)
     CPUX86State *env = &X86_CPU(cpu)->env;
     uint64_t tmp;
     
-    hv_vcpu_read_msr(cpu->hvf->fd, MSR_IA32_SYSENTER_CS, &tmp);
+    hv_vcpu_read_msr(cpu->accel->fd, MSR_IA32_SYSENTER_CS, &tmp);
     env->sysenter_cs = tmp;
     
-    hv_vcpu_read_msr(cpu->hvf->fd, MSR_IA32_SYSENTER_ESP, &tmp);
+    hv_vcpu_read_msr(cpu->accel->fd, MSR_IA32_SYSENTER_ESP, &tmp);
     env->sysenter_esp = tmp;
 
-    hv_vcpu_read_msr(cpu->hvf->fd, MSR_IA32_SYSENTER_EIP, &tmp);
+    hv_vcpu_read_msr(cpu->accel->fd, MSR_IA32_SYSENTER_EIP, &tmp);
     env->sysenter_eip = tmp;
 
-    hv_vcpu_read_msr(cpu->hvf->fd, MSR_STAR, &env->star);
+    hv_vcpu_read_msr(cpu->accel->fd, MSR_STAR, &env->star);
 
 #ifdef TARGET_X86_64
-    hv_vcpu_read_msr(cpu->hvf->fd, MSR_CSTAR, &env->cstar);
-    hv_vcpu_read_msr(cpu->hvf->fd, MSR_KERNELGSBASE, &env->kernelgsbase);
-    hv_vcpu_read_msr(cpu->hvf->fd, MSR_FMASK, &env->fmask);
-    hv_vcpu_read_msr(cpu->hvf->fd, MSR_LSTAR, &env->lstar);
+    hv_vcpu_read_msr(cpu->accel->fd, MSR_CSTAR, &env->cstar);
+    hv_vcpu_read_msr(cpu->accel->fd, MSR_KERNELGSBASE, &env->kernelgsbase);
+    hv_vcpu_read_msr(cpu->accel->fd, MSR_FMASK, &env->fmask);
+    hv_vcpu_read_msr(cpu->accel->fd, MSR_LSTAR, &env->lstar);
 #endif
 
-    hv_vcpu_read_msr(cpu->hvf->fd, MSR_IA32_APICBASE, &tmp);
+    hv_vcpu_read_msr(cpu->accel->fd, MSR_IA32_APICBASE, &tmp);
     
-    env->tsc = rdtscp() + rvmcs(cpu->hvf->fd, VMCS_TSC_OFFSET);
+    env->tsc = rdtscp() + rvmcs(cpu->accel->fd, VMCS_TSC_OFFSET);
 }
 
 int hvf_put_registers(CPUState *cpu)
@@ -241,26 +241,26 @@ int hvf_put_registers(CPUState *cpu)
     X86CPU *x86cpu = X86_CPU(cpu);
     CPUX86State *env = &x86cpu->env;
 
-    wreg(cpu->hvf->fd, HV_X86_RAX, env->regs[R_EAX]);
-    wreg(cpu->hvf->fd, HV_X86_RBX, env->regs[R_EBX]);
-    wreg(cpu->hvf->fd, HV_X86_RCX, env->regs[R_ECX]);
-    wreg(cpu->hvf->fd, HV_X86_RDX, env->regs[R_EDX]);
-    wreg(cpu->hvf->fd, HV_X86_RBP, env->regs[R_EBP]);
-    wreg(cpu->hvf->fd, HV_X86_RSP, env->regs[R_ESP]);
-    wreg(cpu->hvf->fd, HV_X86_RSI, env->regs[R_ESI]);
-    wreg(cpu->hvf->fd, HV_X86_RDI, env->regs[R_EDI]);
-    wreg(cpu->hvf->fd, HV_X86_R8, env->regs[8]);
-    wreg(cpu->hvf->fd, HV_X86_R9, env->regs[9]);
-    wreg(cpu->hvf->fd, HV_X86_R10, env->regs[10]);
-    wreg(cpu->hvf->fd, HV_X86_R11, env->regs[11]);
-    wreg(cpu->hvf->fd, HV_X86_R12, env->regs[12]);
-    wreg(cpu->hvf->fd, HV_X86_R13, env->regs[13]);
-    wreg(cpu->hvf->fd, HV_X86_R14, env->regs[14]);
-    wreg(cpu->hvf->fd, HV_X86_R15, env->regs[15]);
-    wreg(cpu->hvf->fd, HV_X86_RFLAGS, env->eflags);
-    wreg(cpu->hvf->fd, HV_X86_RIP, env->eip);
+    wreg(cpu->accel->fd, HV_X86_RAX, env->regs[R_EAX]);
+    wreg(cpu->accel->fd, HV_X86_RBX, env->regs[R_EBX]);
+    wreg(cpu->accel->fd, HV_X86_RCX, env->regs[R_ECX]);
+    wreg(cpu->accel->fd, HV_X86_RDX, env->regs[R_EDX]);
+    wreg(cpu->accel->fd, HV_X86_RBP, env->regs[R_EBP]);
+    wreg(cpu->accel->fd, HV_X86_RSP, env->regs[R_ESP]);
+    wreg(cpu->accel->fd, HV_X86_RSI, env->regs[R_ESI]);
+    wreg(cpu->accel->fd, HV_X86_RDI, env->regs[R_EDI]);
+    wreg(cpu->accel->fd, HV_X86_R8, env->regs[8]);
+    wreg(cpu->accel->fd, HV_X86_R9, env->regs[9]);
+    wreg(cpu->accel->fd, HV_X86_R10, env->regs[10]);
+    wreg(cpu->accel->fd, HV_X86_R11, env->regs[11]);
+    wreg(cpu->accel->fd, HV_X86_R12, env->regs[12]);
+    wreg(cpu->accel->fd, HV_X86_R13, env->regs[13]);
+    wreg(cpu->accel->fd, HV_X86_R14, env->regs[14]);
+    wreg(cpu->accel->fd, HV_X86_R15, env->regs[15]);
+    wreg(cpu->accel->fd, HV_X86_RFLAGS, env->eflags);
+    wreg(cpu->accel->fd, HV_X86_RIP, env->eip);
    
-    wreg(cpu->hvf->fd, HV_X86_XCR0, env->xcr0);
+    wreg(cpu->accel->fd, HV_X86_XCR0, env->xcr0);
     
     hvf_put_xsave(cpu);
     
@@ -268,14 +268,14 @@ int hvf_put_registers(CPUState *cpu)
     
     hvf_put_msrs(cpu);
     
-    wreg(cpu->hvf->fd, HV_X86_DR0, env->dr[0]);
-    wreg(cpu->hvf->fd, HV_X86_DR1, env->dr[1]);
-    wreg(cpu->hvf->fd, HV_X86_DR2, env->dr[2]);
-    wreg(cpu->hvf->fd, HV_X86_DR3, env->dr[3]);
-    wreg(cpu->hvf->fd, HV_X86_DR4, env->dr[4]);
-    wreg(cpu->hvf->fd, HV_X86_DR5, env->dr[5]);
-    wreg(cpu->hvf->fd, HV_X86_DR6, env->dr[6]);
-    wreg(cpu->hvf->fd, HV_X86_DR7, env->dr[7]);
+    wreg(cpu->accel->fd, HV_X86_DR0, env->dr[0]);
+    wreg(cpu->accel->fd, HV_X86_DR1, env->dr[1]);
+    wreg(cpu->accel->fd, HV_X86_DR2, env->dr[2]);
+    wreg(cpu->accel->fd, HV_X86_DR3, env->dr[3]);
+    wreg(cpu->accel->fd, HV_X86_DR4, env->dr[4]);
+    wreg(cpu->accel->fd, HV_X86_DR5, env->dr[5]);
+    wreg(cpu->accel->fd, HV_X86_DR6, env->dr[6]);
+    wreg(cpu->accel->fd, HV_X86_DR7, env->dr[7]);
     
     return 0;
 }
@@ -285,40 +285,40 @@ int hvf_get_registers(CPUState *cpu)
     X86CPU *x86cpu = X86_CPU(cpu);
     CPUX86State *env = &x86cpu->env;
 
-    env->regs[R_EAX] = rreg(cpu->hvf->fd, HV_X86_RAX);
-    env->regs[R_EBX] = rreg(cpu->hvf->fd, HV_X86_RBX);
-    env->regs[R_ECX] = rreg(cpu->hvf->fd, HV_X86_RCX);
-    env->regs[R_EDX] = rreg(cpu->hvf->fd, HV_X86_RDX);
-    env->regs[R_EBP] = rreg(cpu->hvf->fd, HV_X86_RBP);
-    env->regs[R_ESP] = rreg(cpu->hvf->fd, HV_X86_RSP);
-    env->regs[R_ESI] = rreg(cpu->hvf->fd, HV_X86_RSI);
-    env->regs[R_EDI] = rreg(cpu->hvf->fd, HV_X86_RDI);
-    env->regs[8] = rreg(cpu->hvf->fd, HV_X86_R8);
-    env->regs[9] = rreg(cpu->hvf->fd, HV_X86_R9);
-    env->regs[10] = rreg(cpu->hvf->fd, HV_X86_R10);
-    env->regs[11] = rreg(cpu->hvf->fd, HV_X86_R11);
-    env->regs[12] = rreg(cpu->hvf->fd, HV_X86_R12);
-    env->regs[13] = rreg(cpu->hvf->fd, HV_X86_R13);
-    env->regs[14] = rreg(cpu->hvf->fd, HV_X86_R14);
-    env->regs[15] = rreg(cpu->hvf->fd, HV_X86_R15);
+    env->regs[R_EAX] = rreg(cpu->accel->fd, HV_X86_RAX);
+    env->regs[R_EBX] = rreg(cpu->accel->fd, HV_X86_RBX);
+    env->regs[R_ECX] = rreg(cpu->accel->fd, HV_X86_RCX);
+    env->regs[R_EDX] = rreg(cpu->accel->fd, HV_X86_RDX);
+    env->regs[R_EBP] = rreg(cpu->accel->fd, HV_X86_RBP);
+    env->regs[R_ESP] = rreg(cpu->accel->fd, HV_X86_RSP);
+    env->regs[R_ESI] = rreg(cpu->accel->fd, HV_X86_RSI);
+    env->regs[R_EDI] = rreg(cpu->accel->fd, HV_X86_RDI);
+    env->regs[8] = rreg(cpu->accel->fd, HV_X86_R8);
+    env->regs[9] = rreg(cpu->accel->fd, HV_X86_R9);
+    env->regs[10] = rreg(cpu->accel->fd, HV_X86_R10);
+    env->regs[11] = rreg(cpu->accel->fd, HV_X86_R11);
+    env->regs[12] = rreg(cpu->accel->fd, HV_X86_R12);
+    env->regs[13] = rreg(cpu->accel->fd, HV_X86_R13);
+    env->regs[14] = rreg(cpu->accel->fd, HV_X86_R14);
+    env->regs[15] = rreg(cpu->accel->fd, HV_X86_R15);
     
-    env->eflags = rreg(cpu->hvf->fd, HV_X86_RFLAGS);
-    env->eip = rreg(cpu->hvf->fd, HV_X86_RIP);
+    env->eflags = rreg(cpu->accel->fd, HV_X86_RFLAGS);
+    env->eip = rreg(cpu->accel->fd, HV_X86_RIP);
    
     hvf_get_xsave(cpu);
-    env->xcr0 = rreg(cpu->hvf->fd, HV_X86_XCR0);
+    env->xcr0 = rreg(cpu->accel->fd, HV_X86_XCR0);
     
     hvf_get_segments(cpu);
     hvf_get_msrs(cpu);
     
-    env->dr[0] = rreg(cpu->hvf->fd, HV_X86_DR0);
-    env->dr[1] = rreg(cpu->hvf->fd, HV_X86_DR1);
-    env->dr[2] = rreg(cpu->hvf->fd, HV_X86_DR2);
-    env->dr[3] = rreg(cpu->hvf->fd, HV_X86_DR3);
-    env->dr[4] = rreg(cpu->hvf->fd, HV_X86_DR4);
-    env->dr[5] = rreg(cpu->hvf->fd, HV_X86_DR5);
-    env->dr[6] = rreg(cpu->hvf->fd, HV_X86_DR6);
-    env->dr[7] = rreg(cpu->hvf->fd, HV_X86_DR7);
+    env->dr[0] = rreg(cpu->accel->fd, HV_X86_DR0);
+    env->dr[1] = rreg(cpu->accel->fd, HV_X86_DR1);
+    env->dr[2] = rreg(cpu->accel->fd, HV_X86_DR2);
+    env->dr[3] = rreg(cpu->accel->fd, HV_X86_DR3);
+    env->dr[4] = rreg(cpu->accel->fd, HV_X86_DR4);
+    env->dr[5] = rreg(cpu->accel->fd, HV_X86_DR5);
+    env->dr[6] = rreg(cpu->accel->fd, HV_X86_DR6);
+    env->dr[7] = rreg(cpu->accel->fd, HV_X86_DR7);
     
     x86_update_hflags(env);
     return 0;
@@ -327,16 +327,16 @@ int hvf_get_registers(CPUState *cpu)
 static void vmx_set_int_window_exiting(CPUState *cpu)
 {
      uint64_t val;
-     val = rvmcs(cpu->hvf->fd, VMCS_PRI_PROC_BASED_CTLS);
-     wvmcs(cpu->hvf->fd, VMCS_PRI_PROC_BASED_CTLS, val |
+     val = rvmcs(cpu->accel->fd, VMCS_PRI_PROC_BASED_CTLS);
+     wvmcs(cpu->accel->fd, VMCS_PRI_PROC_BASED_CTLS, val |
              VMCS_PRI_PROC_BASED_CTLS_INT_WINDOW_EXITING);
 }
 
 void vmx_clear_int_window_exiting(CPUState *cpu)
 {
      uint64_t val;
-     val = rvmcs(cpu->hvf->fd, VMCS_PRI_PROC_BASED_CTLS);
-     wvmcs(cpu->hvf->fd, VMCS_PRI_PROC_BASED_CTLS, val &
+     val = rvmcs(cpu->accel->fd, VMCS_PRI_PROC_BASED_CTLS);
+     wvmcs(cpu->accel->fd, VMCS_PRI_PROC_BASED_CTLS, val &
              ~VMCS_PRI_PROC_BASED_CTLS_INT_WINDOW_EXITING);
 }
 
@@ -372,7 +372,7 @@ bool hvf_inject_interrupts(CPUState *cpu)
     uint64_t info = 0;
     if (have_event) {
         info = vector | intr_type | VMCS_INTR_VALID;
-        uint64_t reason = rvmcs(cpu->hvf->fd, VMCS_EXIT_REASON);
+        uint64_t reason = rvmcs(cpu->accel->fd, VMCS_EXIT_REASON);
         if (env->nmi_injected && reason != EXIT_REASON_TASK_SWITCH) {
             vmx_clear_nmi_blocking(cpu);
         }
@@ -381,17 +381,17 @@ bool hvf_inject_interrupts(CPUState *cpu)
             info &= ~(1 << 12); /* clear undefined bit */
             if (intr_type == VMCS_INTR_T_SWINTR ||
                 intr_type == VMCS_INTR_T_SWEXCEPTION) {
-                wvmcs(cpu->hvf->fd, VMCS_ENTRY_INST_LENGTH, env->ins_len);
+                wvmcs(cpu->accel->fd, VMCS_ENTRY_INST_LENGTH, env->ins_len);
             }
             
             if (env->has_error_code) {
-                wvmcs(cpu->hvf->fd, VMCS_ENTRY_EXCEPTION_ERROR,
+                wvmcs(cpu->accel->fd, VMCS_ENTRY_EXCEPTION_ERROR,
                       env->error_code);
                 /* Indicate that VMCS_ENTRY_EXCEPTION_ERROR is valid */
                 info |= VMCS_INTR_DEL_ERRCODE;
             }
             /*printf("reinject  %lx err %d\n", info, err);*/
-            wvmcs(cpu->hvf->fd, VMCS_ENTRY_INTR_INFO, info);
+            wvmcs(cpu->accel->fd, VMCS_ENTRY_INTR_INFO, info);
         };
     }
 
@@ -399,7 +399,7 @@ bool hvf_inject_interrupts(CPUState *cpu)
         if (!(env->hflags2 & HF2_NMI_MASK) && !(info & VMCS_INTR_VALID)) {
             cpu->interrupt_request &= ~CPU_INTERRUPT_NMI;
             info = VMCS_INTR_VALID | VMCS_INTR_T_NMI | EXCP02_NMI;
-            wvmcs(cpu->hvf->fd, VMCS_ENTRY_INTR_INFO, info);
+            wvmcs(cpu->accel->fd, VMCS_ENTRY_INTR_INFO, info);
         } else {
             vmx_set_nmi_window_exiting(cpu);
         }
@@ -411,7 +411,7 @@ bool hvf_inject_interrupts(CPUState *cpu)
         int line = cpu_get_pic_interrupt(&x86cpu->env);
         cpu->interrupt_request &= ~CPU_INTERRUPT_HARD;
         if (line >= 0) {
-            wvmcs(cpu->hvf->fd, VMCS_ENTRY_INTR_INFO, line |
+            wvmcs(cpu->accel->fd, VMCS_ENTRY_INTR_INFO, line |
                   VMCS_INTR_VALID | VMCS_INTR_T_HWINTR);
         }
     }
@@ -429,7 +429,7 @@ int hvf_process_events(CPUState *cpu)
 
     if (!cpu->vcpu_dirty) {
         /* light weight sync for CPU_INTERRUPT_HARD and IF_MASK */
-        env->eflags = rreg(cpu->hvf->fd, HV_X86_RFLAGS);
+        env->eflags = rreg(cpu->accel->fd, HV_X86_RFLAGS);
     }
 
     if (cpu->interrupt_request & CPU_INTERRUPT_INIT) {
-- 
2.38.1

