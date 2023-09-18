Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 058227A4F4F
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbjIRQjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjIRQjC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:39:02 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BA9E4F
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:11:10 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-404fbfac998so21530715e9.3
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695053465; x=1695658265; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TI3/KBb/+3Te5uOTKkyhQWXS4VS0D1UFt2aGwQADGyc=;
        b=Qo/8g+flRNZNIVirRtb6FFYTVQGozTZ9+tAhytzm1akqjf0soVvDCpHViqWq9ErTvA
         5akN8Vn4myXmtdjSxl6TnztbcHifyYCVXILaCqKuqFcBZS/VKdIe7VuQBnm/bgKIvM0P
         GdnTiXKfE38JgKeteG6CnJ0nXbo+guBghyLzfNEjk5CpcPaefyuSMNLqrsefH5OD38Dq
         6iCO0yrKgnLVps/7hqeMDwVkKP9oJ71g7LMKkmD51vbvxS7oMrduxWrGRFLqRcf4u3TT
         RPMxn8DFScEkoXuYEF4kkKMGHD06wWfl2OuFwqlF0L2zo86xROxhuwRc1IQwJXSiJx7+
         Pmpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695053465; x=1695658265;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TI3/KBb/+3Te5uOTKkyhQWXS4VS0D1UFt2aGwQADGyc=;
        b=fmCVWW/V3fPkTuw+Ehj7CJIphdLrYfkFd+Kz7fSYWn2e9EMoN75YEVc6yuQY58Mrod
         NTOPNgmkiUWU/o9cKfdvHrjbc+QNYH61yGOEdaWbnOZR/M/YPNs0GldByMass/w6PbMh
         7L5E2fiaeinjhL+K8MbR6y1iud49bW23LWaswiXLX8Hi0GmVXDbr0Y+GxGW8PDkiD7cS
         JNyksHNbaorpBIw4HU9KEPMBwqatZwbM2Ncxi/cJnAvZtOYF6VexmEoTkns7SRdrfQNK
         OP+Ntuz/97wW0k/uJDOACi0AGqawhaKenUD6iOKtXjSwVt2VL7qASYvKpMsnh0gnxT2m
         rnAQ==
X-Gm-Message-State: AOJu0Yxd9+O7iX+CQ/oqmzjNaQpLAH5mBhAKq0eDgyTdoesYXMcSp263
        dOn1hFj5gh1AgzpXyccsl2sPJ9u2gMWnjmkMgSktCJgV
X-Google-Smtp-Source: AGHT+IE8tHvaLGMz9Bg2ooXF3ZqMqPFeliYGvN3VlPRFdqErpxTJBqw3FnvE/+Bds7Ty0U2MCoDi/A==
X-Received: by 2002:ac2:4887:0:b0:503:56f:c655 with SMTP id x7-20020ac24887000000b00503056fc655mr4625310lfc.57.1695053096666;
        Mon, 18 Sep 2023 09:04:56 -0700 (PDT)
Received: from localhost.localdomain (static-212-193-78-212.thenetworkfactory.nl. [212.78.193.212])
        by smtp.gmail.com with ESMTPSA id fd14-20020a056402388e00b005307e75d24dsm5026981edb.17.2023.09.18.09.04.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 18 Sep 2023 09:04:56 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Laurent Vivier <laurent@vivier.eu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Peter Xu <peterx@redhat.com>, Anton Johansson <anjo@rev.ng>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        Marek Vasut <marex@denx.de>,
        David Gibson <david@gibson.dropbear.id.au>,
        Brian Cain <bcain@quicinc.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        "Edgar E . Iglesias" <edgar.iglesias@gmail.com>,
        Claudio Fontana <cfontana@suse.de>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-ppc@nongnu.org,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Alistair Francis <alistair.francis@wdc.com>,
        Alessandro Di Federico <ale@rev.ng>,
        Song Gao <gaosong@loongson.cn>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Chris Wulff <crwulff@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        Fabiano Rosas <farosas@suse.de>, qemu-s390x@nongnu.org,
        Yanan Wang <wangyanan55@huawei.com>,
        Luc Michel <luc@lmichel.fr>, Weiwei Li <liweiwei@iscas.ac.cn>,
        Bin Meng <bin.meng@windriver.com>,
        Stafford Horne <shorne@gmail.com>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        qemu-arm@nongnu.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Bernhard Beschow <shentey@gmail.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        qemu-riscv@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Greg Kurz <groug@kaod.org>, Michael Rolnik <mrolnik@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Markus Armbruster <armbru@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH 22/22] exec/cpu: Call cpu_exec_realizefn() once in cpu_common_realize()
Date:   Mon, 18 Sep 2023 18:02:55 +0200
Message-ID: <20230918160257.30127-23-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230918160257.30127-1-philmd@linaro.org>
References: <20230918160257.30127-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

cpu_exec_realizefn() is called in each ${target}_cpu_realize(),
before calling their parent_realize(), which is simply
cpu_common_realizefn(). Directly call it there instead.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/core/cpu-common.c      |  4 ++++
 target/alpha/cpu.c        |  8 --------
 target/arm/cpu.c          |  6 ------
 target/avr/cpu.c          |  7 -------
 target/cris/cpu.c         |  7 -------
 target/hexagon/cpu.c      |  7 -------
 target/hppa/cpu.c         | 15 ++-------------
 target/i386/cpu.c         |  6 ------
 target/i386/kvm/kvm-cpu.c |  4 ++--
 target/loongarch/cpu.c    |  7 -------
 target/m68k/cpu.c         |  7 -------
 target/microblaze/cpu.c   |  7 -------
 target/mips/cpu.c         |  7 -------
 target/nios2/cpu.c        |  7 -------
 target/openrisc/cpu.c     |  7 -------
 target/ppc/cpu_init.c     |  5 -----
 target/riscv/cpu.c        |  6 ------
 target/rx/cpu.c           |  7 -------
 target/s390x/cpu.c        |  5 -----
 target/sh4/cpu.c          |  7 -------
 target/sparc/cpu.c        |  8 --------
 target/tricore/cpu.c      |  7 -------
 target/xtensa/cpu.c       |  7 -------
 23 files changed, 8 insertions(+), 150 deletions(-)

diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
index 35c0cc4dad..8901c482a0 100644
--- a/hw/core/cpu-common.c
+++ b/hw/core/cpu-common.c
@@ -204,6 +204,10 @@ static void cpu_common_realizefn(DeviceState *dev, Error **errp)
         }
     }
 
+    if (!cpu_exec_realizefn(cpu, errp)) {
+        return;
+    }
+
     /* Create CPU address space and vCPU thread */
     qemu_init_vcpu(cpu);
 
diff --git a/target/alpha/cpu.c b/target/alpha/cpu.c
index eb78318bb8..85834c4d61 100644
--- a/target/alpha/cpu.c
+++ b/target/alpha/cpu.c
@@ -72,15 +72,7 @@ static void alpha_cpu_disas_set_info(CPUState *cpu, disassemble_info *info)
 
 static void alpha_cpu_realizefn(DeviceState *dev, Error **errp)
 {
-    CPUState *cs = CPU(dev);
     AlphaCPUClass *acc = ALPHA_CPU_GET_CLASS(dev);
-    Error *local_err = NULL;
-
-    cpu_exec_realizefn(cs, &local_err);
-    if (local_err != NULL) {
-        error_propagate(errp, local_err);
-        return;
-    }
 
     acc->parent_realize(dev, errp);
 }
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index a551383fd3..d8eaa186cd 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1756,12 +1756,6 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
     int pagebits;
     Error *local_err = NULL;
 
-    cpu_exec_realizefn(cs, &local_err);
-    if (local_err != NULL) {
-        error_propagate(errp, local_err);
-        return;
-    }
-
 #ifndef CONFIG_USER_ONLY
     {
         uint64_t scale;
diff --git a/target/avr/cpu.c b/target/avr/cpu.c
index d3460b3960..e512ad46d3 100644
--- a/target/avr/cpu.c
+++ b/target/avr/cpu.c
@@ -112,13 +112,6 @@ static void avr_cpu_realizefn(DeviceState *dev, Error **errp)
 {
     CPUState *cs = CPU(dev);
     AVRCPUClass *mcc = AVR_CPU_GET_CLASS(dev);
-    Error *local_err = NULL;
-
-    cpu_exec_realizefn(cs, &local_err);
-    if (local_err != NULL) {
-        error_propagate(errp, local_err);
-        return;
-    }
 
     mcc->parent_realize(dev, errp);
     cpu_reset(cs);
diff --git a/target/cris/cpu.c b/target/cris/cpu.c
index 671693a362..9fb69ecda4 100644
--- a/target/cris/cpu.c
+++ b/target/cris/cpu.c
@@ -144,13 +144,6 @@ static void cris_cpu_realizefn(DeviceState *dev, Error **errp)
 {
     CPUState *cs = CPU(dev);
     CRISCPUClass *ccc = CRIS_CPU_GET_CLASS(dev);
-    Error *local_err = NULL;
-
-    cpu_exec_realizefn(cs, &local_err);
-    if (local_err != NULL) {
-        error_propagate(errp, local_err);
-        return;
-    }
 
     ccc->parent_realize(dev, errp);
     cpu_reset(cs);
diff --git a/target/hexagon/cpu.c b/target/hexagon/cpu.c
index 5b9bb3fe83..17785e2921 100644
--- a/target/hexagon/cpu.c
+++ b/target/hexagon/cpu.c
@@ -332,13 +332,6 @@ static void hexagon_cpu_realize(DeviceState *dev, Error **errp)
 {
     CPUState *cs = CPU(dev);
     HexagonCPUClass *mcc = HEXAGON_CPU_GET_CLASS(dev);
-    Error *local_err = NULL;
-
-    cpu_exec_realizefn(cs, &local_err);
-    if (local_err != NULL) {
-        error_propagate(errp, local_err);
-        return;
-    }
 
     gdb_register_coprocessor(cs, hexagon_hvx_gdb_read_register,
                              hexagon_hvx_gdb_write_register,
diff --git a/target/hppa/cpu.c b/target/hppa/cpu.c
index b0d106b6c7..a87028b275 100644
--- a/target/hppa/cpu.c
+++ b/target/hppa/cpu.c
@@ -121,22 +121,11 @@ void hppa_cpu_do_unaligned_access(CPUState *cs, vaddr addr,
 
 static void hppa_cpu_realizefn(DeviceState *dev, Error **errp)
 {
-    CPUState *cs = CPU(dev);
     HPPACPUClass *acc = HPPA_CPU_GET_CLASS(dev);
-    Error *local_err = NULL;
-
-    cpu_exec_realizefn(cs, &local_err);
-    if (local_err != NULL) {
-        error_propagate(errp, local_err);
-        return;
-    }
 
 #ifndef CONFIG_USER_ONLY
-    {
-        HPPACPU *cpu = HPPA_CPU(cs);
-        cpu->alarm_timer = timer_new_ns(QEMU_CLOCK_VIRTUAL,
-                                        hppa_cpu_alarm_timer, cpu);
-    }
+    cpu->alarm_timer = timer_new_ns(QEMU_CLOCK_VIRTUAL,
+                                    hppa_cpu_alarm_timer, HPPA_CPU(dev));
 #endif
 
     acc->parent_realize(dev, errp);
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 2884733397..c170e2976b 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7311,12 +7311,6 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
         return;
     }
 
-    cpu_exec_realizefn(cs, &local_err);
-    if (local_err != NULL) {
-        error_propagate(errp, local_err);
-        return;
-    }
-
     if (xcc->host_cpuid_required && !accel_uses_host_cpuid()) {
         g_autofree char *name = x86_cpu_class_get_model_name(xcc);
         error_setg(&local_err, "CPU model '%s' requires KVM or HVF", name);
diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
index 1fe62ce176..0f52649779 100644
--- a/target/i386/kvm/kvm-cpu.c
+++ b/target/i386/kvm/kvm-cpu.c
@@ -34,10 +34,10 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
      *
      * x86_cpu_realize():
      *  -> x86_cpu_expand_features()
-     *  -> cpu_exec_realizefn():
+     *  -> cpu_common_realizefn()
+     *      -> cpu_exec_realizefn():
      *            -> accel_cpu_realizefn()
      *               kvm_cpu_realizefn() -> host_cpu_realizefn()
-     *  -> cpu_common_realizefn()
      *  -> check/update ucode_rev, phys_bits, mwait
      */
     if (cpu->max_features) {
diff --git a/target/loongarch/cpu.c b/target/loongarch/cpu.c
index dc0ac39833..d61dcaebca 100644
--- a/target/loongarch/cpu.c
+++ b/target/loongarch/cpu.c
@@ -555,13 +555,6 @@ static void loongarch_cpu_realizefn(DeviceState *dev, Error **errp)
 {
     CPUState *cs = CPU(dev);
     LoongArchCPUClass *lacc = LOONGARCH_CPU_GET_CLASS(dev);
-    Error *local_err = NULL;
-
-    cpu_exec_realizefn(cs, &local_err);
-    if (local_err != NULL) {
-        error_propagate(errp, local_err);
-        return;
-    }
 
     loongarch_cpu_register_gdb_regs_for_features(cs);
 
diff --git a/target/m68k/cpu.c b/target/m68k/cpu.c
index 3da316bc30..c6740e0e78 100644
--- a/target/m68k/cpu.c
+++ b/target/m68k/cpu.c
@@ -309,16 +309,9 @@ static void m68k_cpu_realizefn(DeviceState *dev, Error **errp)
     CPUState *cs = CPU(dev);
     M68kCPU *cpu = M68K_CPU(dev);
     M68kCPUClass *mcc = M68K_CPU_GET_CLASS(dev);
-    Error *local_err = NULL;
 
     register_m68k_insns(&cpu->env);
 
-    cpu_exec_realizefn(cs, &local_err);
-    if (local_err != NULL) {
-        error_propagate(errp, local_err);
-        return;
-    }
-
     m68k_cpu_init_gdb(cpu);
 
     mcc->parent_realize(dev, errp);
diff --git a/target/microblaze/cpu.c b/target/microblaze/cpu.c
index 1f19a6e07d..5194911ad4 100644
--- a/target/microblaze/cpu.c
+++ b/target/microblaze/cpu.c
@@ -207,13 +207,6 @@ static void mb_cpu_realizefn(DeviceState *dev, Error **errp)
     uint8_t version_code = 0;
     const char *version;
     int i = 0;
-    Error *local_err = NULL;
-
-    cpu_exec_realizefn(cs, &local_err);
-    if (local_err != NULL) {
-        error_propagate(errp, local_err);
-        return;
-    }
 
     if (cpu->cfg.addr_size < 32 || cpu->cfg.addr_size > 64) {
         error_setg(errp, "addr-size %d is out of range (32 - 64)",
diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index 7c81e6c356..4f15dcea44 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -462,13 +462,6 @@ static void mips_cpu_realizefn(DeviceState *dev, Error **errp)
     MIPSCPU *cpu = MIPS_CPU(dev);
     CPUMIPSState *env = &cpu->env;
     MIPSCPUClass *mcc = MIPS_CPU_GET_CLASS(dev);
-    Error *local_err = NULL;
-
-    cpu_exec_realizefn(cs, &local_err);
-    if (local_err != NULL) {
-        error_propagate(errp, local_err);
-        return;
-    }
 
     env->exception_base = (int32_t)0xBFC00000;
 
diff --git a/target/nios2/cpu.c b/target/nios2/cpu.c
index f500ca7ba2..fc753bb1be 100644
--- a/target/nios2/cpu.c
+++ b/target/nios2/cpu.c
@@ -199,13 +199,6 @@ static void nios2_cpu_realizefn(DeviceState *dev, Error **errp)
     CPUState *cs = CPU(dev);
     Nios2CPU *cpu = NIOS2_CPU(cs);
     Nios2CPUClass *ncc = NIOS2_CPU_GET_CLASS(dev);
-    Error *local_err = NULL;
-
-    cpu_exec_realizefn(cs, &local_err);
-    if (local_err != NULL) {
-        error_propagate(errp, local_err);
-        return;
-    }
 
     realize_cr_status(cs);
 
diff --git a/target/openrisc/cpu.c b/target/openrisc/cpu.c
index e4ec95ca7f..438146c681 100644
--- a/target/openrisc/cpu.c
+++ b/target/openrisc/cpu.c
@@ -133,13 +133,6 @@ static void openrisc_cpu_realizefn(DeviceState *dev, Error **errp)
 {
     CPUState *cs = CPU(dev);
     OpenRISCCPUClass *occ = OPENRISC_CPU_GET_CLASS(dev);
-    Error *local_err = NULL;
-
-    cpu_exec_realizefn(cs, &local_err);
-    if (local_err != NULL) {
-        error_propagate(errp, local_err);
-        return;
-    }
 
     occ->parent_realize(dev, errp);
     cpu_reset(cs);
diff --git a/target/ppc/cpu_init.c b/target/ppc/cpu_init.c
index 24d4e8fa7e..99087ee57c 100644
--- a/target/ppc/cpu_init.c
+++ b/target/ppc/cpu_init.c
@@ -6809,11 +6809,6 @@ static void ppc_cpu_realize(DeviceState *dev, Error **errp)
     PowerPCCPUClass *pcc = POWERPC_CPU_GET_CLASS(cpu);
     Error *local_err = NULL;
 
-    cpu_exec_realizefn(cs, &local_err);
-    if (local_err != NULL) {
-        error_propagate(errp, local_err);
-        return;
-    }
     if (cpu->vcpu_id == UNASSIGNED_CPU_INDEX) {
         cpu->vcpu_id = cs->cpu_index;
     }
diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
index 4f7ae55359..62be6d88fc 100644
--- a/target/riscv/cpu.c
+++ b/target/riscv/cpu.c
@@ -1503,12 +1503,6 @@ static void riscv_cpu_realize(DeviceState *dev, Error **errp)
     RISCVCPUClass *mcc = RISCV_CPU_GET_CLASS(dev);
     Error *local_err = NULL;
 
-    cpu_exec_realizefn(cs, &local_err);
-    if (local_err != NULL) {
-        error_propagate(errp, local_err);
-        return;
-    }
-
     if (tcg_enabled()) {
         riscv_cpu_realize_tcg(dev, &local_err);
         if (local_err != NULL) {
diff --git a/target/rx/cpu.c b/target/rx/cpu.c
index 089df61790..db951ff988 100644
--- a/target/rx/cpu.c
+++ b/target/rx/cpu.c
@@ -129,13 +129,6 @@ static void rx_cpu_realize(DeviceState *dev, Error **errp)
 {
     CPUState *cs = CPU(dev);
     RXCPUClass *rcc = RX_CPU_GET_CLASS(dev);
-    Error *local_err = NULL;
-
-    cpu_exec_realizefn(cs, &local_err);
-    if (local_err != NULL) {
-        error_propagate(errp, local_err);
-        return;
-    }
 
     rcc->parent_realize(dev, errp);
     cpu_reset(cs);
diff --git a/target/s390x/cpu.c b/target/s390x/cpu.c
index 983dbfe563..e305928651 100644
--- a/target/s390x/cpu.c
+++ b/target/s390x/cpu.c
@@ -231,11 +231,6 @@ static void s390_cpu_realizefn(DeviceState *dev, Error **errp)
     S390CPUClass *scc = S390_CPU_GET_CLASS(dev);
     Error *err = NULL;
 
-    cpu_exec_realizefn(cs, &err);
-    if (err != NULL) {
-        goto out;
-    }
-
 #if !defined(CONFIG_USER_ONLY)
     qemu_register_reset(s390_cpu_machine_reset_cb, S390_CPU(dev));
 #endif
diff --git a/target/sh4/cpu.c b/target/sh4/cpu.c
index e6690daf9a..a3fc034ea5 100644
--- a/target/sh4/cpu.c
+++ b/target/sh4/cpu.c
@@ -220,13 +220,6 @@ static void superh_cpu_realizefn(DeviceState *dev, Error **errp)
 {
     CPUState *cs = CPU(dev);
     SuperHCPUClass *scc = SUPERH_CPU_GET_CLASS(dev);
-    Error *local_err = NULL;
-
-    cpu_exec_realizefn(cs, &local_err);
-    if (local_err != NULL) {
-        error_propagate(errp, local_err);
-        return;
-    }
 
     scc->parent_realize(dev, errp);
     cpu_reset(cs);
diff --git a/target/sparc/cpu.c b/target/sparc/cpu.c
index 88157fcd33..f0b2187f3b 100644
--- a/target/sparc/cpu.c
+++ b/target/sparc/cpu.c
@@ -750,18 +750,10 @@ static ObjectClass *sparc_cpu_class_by_name(const char *cpu_model)
 
 static void sparc_cpu_realizefn(DeviceState *dev, Error **errp)
 {
-    CPUState *cs = CPU(dev);
     SPARCCPUClass *scc = SPARC_CPU_GET_CLASS(dev);
-    Error *local_err = NULL;
     SPARCCPU *cpu = SPARC_CPU(dev);
     CPUSPARCState *env = &cpu->env;
 
-    cpu_exec_realizefn(cs, &local_err);
-    if (local_err != NULL) {
-        error_propagate(errp, local_err);
-        return;
-    }
-
 #if defined(CONFIG_USER_ONLY)
     if ((env->def.features & CPU_FEATURE_FLOAT)) {
         env->def.features |= CPU_FEATURE_FLOAT128;
diff --git a/target/tricore/cpu.c b/target/tricore/cpu.c
index 0142cf556d..5319a6841e 100644
--- a/target/tricore/cpu.c
+++ b/target/tricore/cpu.c
@@ -95,13 +95,6 @@ static void tricore_cpu_realizefn(DeviceState *dev, Error **errp)
     TriCoreCPU *cpu = TRICORE_CPU(dev);
     TriCoreCPUClass *tcc = TRICORE_CPU_GET_CLASS(dev);
     CPUTriCoreState *env = &cpu->env;
-    Error *local_err = NULL;
-
-    cpu_exec_realizefn(cs, &local_err);
-    if (local_err != NULL) {
-        error_propagate(errp, local_err);
-        return;
-    }
 
     /* Some features automatically imply others */
     if (tricore_has_feature(env, TRICORE_FEATURE_162)) {
diff --git a/target/xtensa/cpu.c b/target/xtensa/cpu.c
index bbfd2d42a8..c7bdd0980a 100644
--- a/target/xtensa/cpu.c
+++ b/target/xtensa/cpu.c
@@ -160,13 +160,6 @@ static void xtensa_cpu_realizefn(DeviceState *dev, Error **errp)
 {
     CPUState *cs = CPU(dev);
     XtensaCPUClass *xcc = XTENSA_CPU_GET_CLASS(dev);
-    Error *local_err = NULL;
-
-    cpu_exec_realizefn(cs, &local_err);
-    if (local_err != NULL) {
-        error_propagate(errp, local_err);
-        return;
-    }
 
     cs->gdb_num_regs = xcc->config->gdb_regmap.num_regs;
 
-- 
2.41.0

