Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C27B06D798E
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 12:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237633AbjDEKTz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 06:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237843AbjDEKTs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 06:19:48 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574A859E3
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 03:19:35 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id o32so20566469wms.1
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 03:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680689975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=reJpuebcoI5BKEfS88SjCkcplXXPmguVbMU9Olmibx0=;
        b=Q2+dqv8HKpPQKTf9cQJSeqsGPGkeqsXxu8v+C2JYWo/wkdpZHobUDc9N35z1UbQyXo
         9C6lndVpWvjoGdquQUathNsJoiIiN7nJn3kgNVvT5T7tc01blota5eXmXHc1hE2a/9ew
         2Wf7CCzhPcSAgNhjaTij8S5PpdLVkajwG2fdrCTckKDaeIUqcPO5ZI4SEhoPCSlpK/xc
         jQRVVytzUEGa2Ydc7bSMmlI+Bj89/EomAs72KzqL8mlaSY0qlyPq25y3stucFF3G2pSS
         /sRRUshA2hioO50En8HSMUOtDGPuoJV66S46OhB8lo7qSEotmJH2F75Zpnda8gdb6yr0
         tHhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680689975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=reJpuebcoI5BKEfS88SjCkcplXXPmguVbMU9Olmibx0=;
        b=vXMFKVGoUh9LiN5tQ5aX0Xjngnybu/vctSbkWcEi3FDkd/dHCtZsTS5hAz2TYgtZXH
         YkcWcsotzSC4LZWgYb9Ix2R9frUL93uaWkIjC4YzpXCSjoaxgvvyf5O0h3avni2gDD9C
         78GUFyVcgUWmS5rDQXXlWGNSOJdm97V54CDreoHHpAZgxMUXTYVyLx+6SXZVm7I/RTl+
         l9lRxmukhrPX0deTN70dlMCq7bR/yuhlhOH2YCIuI+HIabWRCtalMyH2f8kfkC9pMgKt
         4cDmtNtTDQ0Xqk0tJN3i2JC+c26TdCwitz+BVVIFEc/GbGPEUiZaS5y/9+vDlbb3khn2
         0NGg==
X-Gm-Message-State: AAQBX9fK7zxrPq1bZ+Tzs6Kna+no5HEub/e8Ct+tH8A0yr/7vr8ASJ9F
        7CUK/j8TQK3g3I2wHTR+yZr5r5ljPDA0WwdEgyM=
X-Google-Smtp-Source: AKy350ZAz7PsFWbSoWRxQBkCoHp/n/DjoRXVF/1COGNHcX9m4lAa529X6M54U1ZwDgyYhrM/EeN7Fw==
X-Received: by 2002:a1c:7717:0:b0:3f0:48f4:8454 with SMTP id t23-20020a1c7717000000b003f048f48454mr4350332wmi.27.1680689974915;
        Wed, 05 Apr 2023 03:19:34 -0700 (PDT)
Received: from localhost.localdomain (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id d21-20020a1c7315000000b003ed1f6878a5sm1770353wmb.5.2023.04.05.03.19.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Apr 2023 03:19:34 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Reinoud Zandijk <reinoud@netbsd.org>
Subject: [PATCH 11/14] accel: Inline NVMM get_qemu_vcpu()
Date:   Wed,  5 Apr 2023 12:18:08 +0200
Message-Id: <20230405101811.76663-12-philmd@linaro.org>
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
 target/i386/nvmm/nvmm-all.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/target/i386/nvmm/nvmm-all.c b/target/i386/nvmm/nvmm-all.c
index 97a7225598..1c0168d83c 100644
--- a/target/i386/nvmm/nvmm-all.c
+++ b/target/i386/nvmm/nvmm-all.c
@@ -49,12 +49,6 @@ struct qemu_machine {
 static bool nvmm_allowed;
 static struct qemu_machine qemu_mach;
 
-static struct AccelvCPUState *
-get_qemu_vcpu(CPUState *cpu)
-{
-    return cpu->accel;
-}
-
 static struct nvmm_machine *
 get_nvmm_mach(void)
 {
@@ -86,7 +80,7 @@ nvmm_set_registers(CPUState *cpu)
 {
     CPUX86State *env = cpu->env_ptr;
     struct nvmm_machine *mach = get_nvmm_mach();
-    struct AccelvCPUState *qcpu = get_qemu_vcpu(cpu);
+    struct AccelvCPUState *qcpu = cpu->accel;
     struct nvmm_vcpu *vcpu = &qcpu->vcpu;
     struct nvmm_x64_state *state = vcpu->state;
     uint64_t bitmap;
@@ -223,7 +217,7 @@ nvmm_get_registers(CPUState *cpu)
 {
     CPUX86State *env = cpu->env_ptr;
     struct nvmm_machine *mach = get_nvmm_mach();
-    struct AccelvCPUState *qcpu = get_qemu_vcpu(cpu);
+    struct AccelvCPUState *qcpu = cpu->accel;
     struct nvmm_vcpu *vcpu = &qcpu->vcpu;
     X86CPU *x86_cpu = X86_CPU(cpu);
     struct nvmm_x64_state *state = vcpu->state;
@@ -347,7 +341,7 @@ static bool
 nvmm_can_take_int(CPUState *cpu)
 {
     CPUX86State *env = cpu->env_ptr;
-    struct AccelvCPUState *qcpu = get_qemu_vcpu(cpu);
+    struct AccelvCPUState *qcpu = cpu->accel;
     struct nvmm_vcpu *vcpu = &qcpu->vcpu;
     struct nvmm_machine *mach = get_nvmm_mach();
 
@@ -372,7 +366,7 @@ nvmm_can_take_int(CPUState *cpu)
 static bool
 nvmm_can_take_nmi(CPUState *cpu)
 {
-    struct AccelvCPUState *qcpu = get_qemu_vcpu(cpu);
+    struct AccelvCPUState *qcpu = cpu->accel;
 
     /*
      * Contrary to INTs, NMIs always schedule an exit when they are
@@ -395,7 +389,7 @@ nvmm_vcpu_pre_run(CPUState *cpu)
 {
     CPUX86State *env = cpu->env_ptr;
     struct nvmm_machine *mach = get_nvmm_mach();
-    struct AccelvCPUState *qcpu = get_qemu_vcpu(cpu);
+    struct AccelvCPUState *qcpu = cpu->accel;
     struct nvmm_vcpu *vcpu = &qcpu->vcpu;
     X86CPU *x86_cpu = X86_CPU(cpu);
     struct nvmm_x64_state *state = vcpu->state;
@@ -478,7 +472,7 @@ nvmm_vcpu_pre_run(CPUState *cpu)
 static void
 nvmm_vcpu_post_run(CPUState *cpu, struct nvmm_vcpu_exit *exit)
 {
-    struct AccelvCPUState *qcpu = get_qemu_vcpu(cpu);
+    struct AccelvCPUState *qcpu = cpu->accel;
     CPUX86State *env = cpu->env_ptr;
     X86CPU *x86_cpu = X86_CPU(cpu);
     uint64_t tpr;
@@ -565,7 +559,7 @@ static int
 nvmm_handle_rdmsr(struct nvmm_machine *mach, CPUState *cpu,
     struct nvmm_vcpu_exit *exit)
 {
-    struct AccelvCPUState *qcpu = get_qemu_vcpu(cpu);
+    struct AccelvCPUState *qcpu = cpu->accel;
     struct nvmm_vcpu *vcpu = &qcpu->vcpu;
     X86CPU *x86_cpu = X86_CPU(cpu);
     struct nvmm_x64_state *state = vcpu->state;
@@ -610,7 +604,7 @@ static int
 nvmm_handle_wrmsr(struct nvmm_machine *mach, CPUState *cpu,
     struct nvmm_vcpu_exit *exit)
 {
-    struct AccelvCPUState *qcpu = get_qemu_vcpu(cpu);
+    struct AccelvCPUState *qcpu = cpu->accel;
     struct nvmm_vcpu *vcpu = &qcpu->vcpu;
     X86CPU *x86_cpu = X86_CPU(cpu);
     struct nvmm_x64_state *state = vcpu->state;
@@ -686,7 +680,7 @@ nvmm_vcpu_loop(CPUState *cpu)
 {
     CPUX86State *env = cpu->env_ptr;
     struct nvmm_machine *mach = get_nvmm_mach();
-    struct AccelvCPUState *qcpu = get_qemu_vcpu(cpu);
+    struct AccelvCPUState *qcpu = cpu->accel;
     struct nvmm_vcpu *vcpu = &qcpu->vcpu;
     X86CPU *x86_cpu = X86_CPU(cpu);
     struct nvmm_vcpu_exit *exit = vcpu->exit;
@@ -892,7 +886,7 @@ static void
 nvmm_ipi_signal(int sigcpu)
 {
     if (current_cpu) {
-        struct AccelvCPUState *qcpu = get_qemu_vcpu(current_cpu);
+        struct AccelvCPUState *qcpu = current_cpu->accel;
 #if NVMM_USER_VERSION >= 2
         struct nvmm_vcpu *vcpu = &qcpu->vcpu;
         nvmm_vcpu_stop(vcpu);
@@ -1027,7 +1021,7 @@ void
 nvmm_destroy_vcpu(CPUState *cpu)
 {
     struct nvmm_machine *mach = get_nvmm_mach();
-    struct AccelvCPUState *qcpu = get_qemu_vcpu(cpu);
+    struct AccelvCPUState *qcpu = cpu->accel;
 
     nvmm_vcpu_destroy(mach, &qcpu->vcpu);
     g_free(cpu->accel);
-- 
2.38.1

