Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 909FF6D7991
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 12:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237624AbjDEKUE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 06:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237147AbjDEKUC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 06:20:02 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD14527F
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 03:19:50 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id h17so35625616wrt.8
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 03:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680689989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jksVpkvUC0Cd0t39UFdIwyYip+p/HLpViupo0kEzavo=;
        b=M14p41XBeC2pDOXONWRmVPh/g0bgtOaeo2kq2u+TWuJbxjfFyLRtQYnT6xjEliAwSd
         Gmn7vgNMSmnVxfuYpWs2aBjugNVuv4EcJIwJLGMmyZg0QDYfH3i/sc7Kh/q/3WK7qsdn
         F60Wv7glyCGVMo3BOtpHfdZkvOyzxwN+gH3+Hex9JK/WUrdLUi4yf74vk34hUq78UiYb
         AORBP6ycIQAo33OBYSJhlzh69AqqlN5KQ4LDwsQpdYmaxHN8h7YoC/jYUnRSJ6PAS/Fc
         moP7c9mQFfmYCYIySXHMkSb6ncs0eKD1DYTa0llVPqgHxXnFQBGyNcDmOUOFGwExmveQ
         mqGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680689989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jksVpkvUC0Cd0t39UFdIwyYip+p/HLpViupo0kEzavo=;
        b=7hpwoaV0x0OsnbH9/Egi1hxZKiJDBEoPCSCIdh6f4I+UPPr6aLyoP03tLMqAW/aD73
         M5qNSurimQ5mpnoT17T5/1NB7tQieMsBcytjn/sS6/Etjgl/DF+dy01ktUbU1TB7ctyW
         6QBCN8ixDfobbsjhtvGqt+8eRe4K/VfZvr6iEweCmgzmXwfbzUgb6Hk7jE63kxRvqk3j
         iA/At4kV8PXCvu0wJ8k3GgFl5lIoQaj7nwqicW4nT62QmHPVIUnu2RzBP18DOQKSqTtH
         tV6/j+MaFNNWnVJzk+TGbwd3NkKQw0hPU+zQ8zUQ/oiAy0w+HeIuRYkR5/WdskovwLLJ
         6f4g==
X-Gm-Message-State: AAQBX9dwfiSxhs6whuY0zGVz6/4us4gHbboVVLjp28Mia0VD6IS6LM0e
        0CNiiArnSqeYf1N0tLUP+yvqQQ==
X-Google-Smtp-Source: AKy350ab1egrbimBmhajh9GEqufBtAURJQuxG6H/Hs7JpaNOdz6mu7HJAmIyOPKcGGllVT4MOOnVWA==
X-Received: by 2002:adf:df85:0:b0:2ce:a85f:1313 with SMTP id z5-20020adfdf85000000b002cea85f1313mr3358628wrl.35.1680689989199;
        Wed, 05 Apr 2023 03:19:49 -0700 (PDT)
Received: from localhost.localdomain (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id o7-20020adfe807000000b002e4cd2ec5c7sm14692347wrm.86.2023.04.05.03.19.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Apr 2023 03:19:48 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>
Subject: [PATCH 13/14] accel: Inline WHPX get_whpx_vcpu()
Date:   Wed,  5 Apr 2023 12:18:10 +0200
Message-Id: <20230405101811.76663-14-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230405101811.76663-1-philmd@linaro.org>
References: <20230405101811.76663-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No need for this helper to access the CPUState::accel field.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/whpx/whpx-all.c | 29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index 2372c4227a..2cca6bc004 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -256,15 +256,6 @@ static bool whpx_has_xsave(void)
     return whpx_xsave_cap.XsaveSupport;
 }
 
-/*
- * VP support
- */
-
-static struct AccelvCPUState *get_whpx_vcpu(CPUState *cpu)
-{
-    return (struct AccelvCPUState *)cpu->accel;
-}
-
 static WHV_X64_SEGMENT_REGISTER whpx_seg_q2h(const SegmentCache *qs, int v86,
                                              int r86)
 {
@@ -390,7 +381,7 @@ static uint64_t whpx_cr8_to_apic_tpr(uint64_t cr8)
 static void whpx_set_registers(CPUState *cpu, int level)
 {
     struct whpx_state *whpx = &whpx_global;
-    struct AccelvCPUState *vcpu = get_whpx_vcpu(cpu);
+    struct AccelvCPUState *vcpu = cpu->accel;
     CPUX86State *env = cpu->env_ptr;
     X86CPU *x86_cpu = X86_CPU(cpu);
     struct whpx_register_set vcxt;
@@ -609,7 +600,7 @@ static void whpx_get_xcrs(CPUState *cpu)
 static void whpx_get_registers(CPUState *cpu)
 {
     struct whpx_state *whpx = &whpx_global;
-    struct AccelvCPUState *vcpu = get_whpx_vcpu(cpu);
+    struct AccelvCPUState *vcpu = cpu->accel;
     CPUX86State *env = cpu->env_ptr;
     X86CPU *x86_cpu = X86_CPU(cpu);
     struct whpx_register_set vcxt;
@@ -892,7 +883,7 @@ static const WHV_EMULATOR_CALLBACKS whpx_emu_callbacks = {
 static int whpx_handle_mmio(CPUState *cpu, WHV_MEMORY_ACCESS_CONTEXT *ctx)
 {
     HRESULT hr;
-    struct AccelvCPUState *vcpu = get_whpx_vcpu(cpu);
+    struct AccelvCPUState *vcpu = cpu->accel;
     WHV_EMULATOR_STATUS emu_status;
 
     hr = whp_dispatch.WHvEmulatorTryMmioEmulation(
@@ -917,7 +908,7 @@ static int whpx_handle_portio(CPUState *cpu,
                               WHV_X64_IO_PORT_ACCESS_CONTEXT *ctx)
 {
     HRESULT hr;
-    struct AccelvCPUState *vcpu = get_whpx_vcpu(cpu);
+    struct AccelvCPUState *vcpu = cpu->accel;
     WHV_EMULATOR_STATUS emu_status;
 
     hr = whp_dispatch.WHvEmulatorTryIoEmulation(
@@ -1417,7 +1408,7 @@ static vaddr whpx_vcpu_get_pc(CPUState *cpu, bool exit_context_valid)
          * of QEMU, nor this port by calling WHvSetVirtualProcessorRegisters().
          * This is the most common case.
          */
-        struct AccelvCPUState *vcpu = get_whpx_vcpu(cpu);
+        struct AccelvCPUState *vcpu = cpu->accel;
         return vcpu->exit_ctx.VpContext.Rip;
     } else {
         /*
@@ -1468,7 +1459,7 @@ static void whpx_vcpu_pre_run(CPUState *cpu)
 {
     HRESULT hr;
     struct whpx_state *whpx = &whpx_global;
-    struct AccelvCPUState *vcpu = get_whpx_vcpu(cpu);
+    struct AccelvCPUState *vcpu = cpu->accel;
     CPUX86State *env = cpu->env_ptr;
     X86CPU *x86_cpu = X86_CPU(cpu);
     int irq;
@@ -1590,7 +1581,7 @@ static void whpx_vcpu_pre_run(CPUState *cpu)
 
 static void whpx_vcpu_post_run(CPUState *cpu)
 {
-    struct AccelvCPUState *vcpu = get_whpx_vcpu(cpu);
+    struct AccelvCPUState *vcpu = cpu->accel;
     CPUX86State *env = cpu->env_ptr;
     X86CPU *x86_cpu = X86_CPU(cpu);
 
@@ -1617,7 +1608,7 @@ static void whpx_vcpu_process_async_events(CPUState *cpu)
 {
     CPUX86State *env = cpu->env_ptr;
     X86CPU *x86_cpu = X86_CPU(cpu);
-    struct AccelvCPUState *vcpu = get_whpx_vcpu(cpu);
+    struct AccelvCPUState *vcpu = cpu->accel;
 
     if ((cpu->interrupt_request & CPU_INTERRUPT_INIT) &&
         !(env->hflags & HF_SMM_MASK)) {
@@ -1656,7 +1647,7 @@ static int whpx_vcpu_run(CPUState *cpu)
 {
     HRESULT hr;
     struct whpx_state *whpx = &whpx_global;
-    struct AccelvCPUState *vcpu = get_whpx_vcpu(cpu);
+    struct AccelvCPUState *vcpu = cpu->accel;
     struct whpx_breakpoint *stepped_over_bp = NULL;
     WhpxStepMode exclusive_step_mode = WHPX_STEP_NONE;
     int ret;
@@ -2296,7 +2287,7 @@ int whpx_vcpu_exec(CPUState *cpu)
 void whpx_destroy_vcpu(CPUState *cpu)
 {
     struct whpx_state *whpx = &whpx_global;
-    struct AccelvCPUState *vcpu = get_whpx_vcpu(cpu);
+    struct AccelvCPUState *vcpu = cpu->accel;
 
     whp_dispatch.WHvDeleteVirtualProcessor(whpx->partition, cpu->cpu_index);
     whp_dispatch.WHvEmulatorDestroyEmulator(vcpu->emulator);
-- 
2.38.1

