Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6DF56A8929
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 20:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjCBTJb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 14:09:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbjCBTJN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 14:09:13 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6458C35264
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 11:08:55 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id l1so103079wry.12
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 11:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MqZnXo7hFBLHq1osD92qYOTfq2ZgDdz/ouY2s2JD3s4=;
        b=fOR2byWfCCcJXjXfwKA46URGir/fGPkWaGXjvyaUgzbeHfEdk+5+rMh8/ZWbZSyatP
         0ODUvIcB0kpuSPwdT3VpN7Y/ItmmWXOXCM5GYBnwogvyhtzfBfT2ic/U2IM2PdcKBh7z
         FpZX2SmOXyLbWDtzIvURSf4W6ozOFlGlY/kSvWiM6O55YwbaV3bUmgz2ELDtEF7+potP
         OoOfd0ldZcJX+A3T6bBMS+IiGWAdhZiESkj/pAan4toAgMNH0Ef53jFKN6q/JGeNehmg
         JYwd3xCpfUEcOtPXnEGJSkg9XyrjsnyXjhEpvqMhUYswkJU7P1n80aZDHT+ssIlZcFXl
         OPLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MqZnXo7hFBLHq1osD92qYOTfq2ZgDdz/ouY2s2JD3s4=;
        b=VJvm1ZaLBtNtDkdccKMSY3OqvNbyGl3zZLI0b1LIUrDviYidZuwN/ZWCVDxUiY40LU
         4AH547JbQP/Ag7FEinQSNUQU6mfeeup/wBucPwuET6wrB3LMnUv6BEZPQrB2Ns3qujcl
         Edbk8XsSU/d2dMoNPcETxx61NOXA8LvYBO+mh+s5DbQE1PVgHhpMelX9YY/1Qs9Hxd3n
         UvUhWXhiYhgsirO2aQkXemQlTbZAs087q/v+A+4ymY1iejyPM+IMRAQDSffmkRwWkb3c
         WevQdd1zgQdGo2pPFxjwuBzbSUnqyO+NSfBNcKRybD2fm4oicfOZW/RZqHrByAiHTSbs
         0JDw==
X-Gm-Message-State: AO0yUKWkhXcKpAaxQxfzD3x4MQRqi37s0keMZDRRNQC9NJFU5nvg7Pms
        Umb6TDjJ1VMglgiJ0VwvL9/CFA==
X-Google-Smtp-Source: AK7set/GbLEkr34A33zpv5kh6AkqolZvhydftjLJJ27qgEGaUEAiZ0H0oRqb4S9ufCLxgSPqV3tmtg==
X-Received: by 2002:a05:6000:c8:b0:2c3:e0a0:93f with SMTP id q8-20020a05600000c800b002c3e0a0093fmr8547360wrx.8.1677784133847;
        Thu, 02 Mar 2023 11:08:53 -0800 (PST)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a12-20020a056000100c00b002c55ec7f661sm190603wrx.5.2023.03.02.11.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 11:08:53 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id A063E1FFD0;
        Thu,  2 Mar 2023 19:08:50 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Weiwei Li <liweiwei@iscas.ac.cn>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Laurent Vivier <laurent@vivier.eu>,
        nicolas.eder@lauterbach.com, Ilya Leoshkevich <iii@linux.ibm.com>,
        kvm@vger.kernel.org,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        qemu-s390x@nongnu.org, Stafford Horne <shorne@gmail.com>,
        Bin Meng <bin.meng@windriver.com>, Marek Vasut <marex@denx.de>,
        Greg Kurz <groug@kaod.org>, Song Gao <gaosong@loongson.cn>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Chris Wulff <crwulff@gmail.com>, qemu-riscv@nongnu.org,
        Michael Rolnik <mrolnik@gmail.com>, qemu-arm@nongnu.org,
        Cleber Rosa <crosa@redhat.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Alexandre Iooss <erdnaxe@crans.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        mads@ynddal.dk, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        qemu-ppc@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        John Snow <jsnow@redhat.com>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mahmoud Mandour <ma.mandourr@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Yanan Wang <wangyanan55@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Taylor Simpson <tsimpson@quicinc.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Mads Ynddal <m.ynddal@samsung.com>
Subject: [PATCH v4 26/26] gdbstub: move update guest debug to accel ops
Date:   Thu,  2 Mar 2023 19:08:46 +0000
Message-Id: <20230302190846.2593720-27-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230302190846.2593720-1-alex.bennee@linaro.org>
References: <20230302190846.2593720-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mads Ynddal <m.ynddal@samsung.com>

Continuing the refactor of a48e7d9e52 (gdbstub: move guest debug support
check to ops) by removing hardcoded kvm_enabled() from generic cpu.c
code, and replace it with a property of AccelOpsClass.

Signed-off-by: Mads Ynddal <m.ynddal@samsung.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Message-Id: <20230207131721.49233-1-mads@ynddal.dk>
[AJB: add ifdef around update_guest_debug_ops, fix brace]
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/sysemu/accel-ops.h |  1 +
 accel/kvm/kvm-accel-ops.c  |  8 ++++++++
 cpu.c                      | 11 ++++++++---
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/sysemu/accel-ops.h b/include/sysemu/accel-ops.h
index 30690c71bd..3c1fab4b1e 100644
--- a/include/sysemu/accel-ops.h
+++ b/include/sysemu/accel-ops.h
@@ -48,6 +48,7 @@ struct AccelOpsClass {
 
     /* gdbstub hooks */
     bool (*supports_guest_debug)(void);
+    int (*update_guest_debug)(CPUState *cpu);
     int (*insert_breakpoint)(CPUState *cpu, int type, vaddr addr, vaddr len);
     int (*remove_breakpoint)(CPUState *cpu, int type, vaddr addr, vaddr len);
     void (*remove_all_breakpoints)(CPUState *cpu);
diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index fbf4fe3497..457eafa380 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -86,6 +86,13 @@ static bool kvm_cpus_are_resettable(void)
     return !kvm_enabled() || kvm_cpu_check_are_resettable();
 }
 
+#ifdef KVM_CAP_SET_GUEST_DEBUG
+static int kvm_update_guest_debug_ops(CPUState *cpu)
+{
+    return kvm_update_guest_debug(cpu, 0);
+}
+#endif
+
 static void kvm_accel_ops_class_init(ObjectClass *oc, void *data)
 {
     AccelOpsClass *ops = ACCEL_OPS_CLASS(oc);
@@ -99,6 +106,7 @@ static void kvm_accel_ops_class_init(ObjectClass *oc, void *data)
     ops->synchronize_pre_loadvm = kvm_cpu_synchronize_pre_loadvm;
 
 #ifdef KVM_CAP_SET_GUEST_DEBUG
+    ops->update_guest_debug = kvm_update_guest_debug_ops;
     ops->supports_guest_debug = kvm_supports_guest_debug;
     ops->insert_breakpoint = kvm_insert_breakpoint;
     ops->remove_breakpoint = kvm_remove_breakpoint;
diff --git a/cpu.c b/cpu.c
index e6abc6c76c..567b23af46 100644
--- a/cpu.c
+++ b/cpu.c
@@ -31,8 +31,8 @@
 #include "hw/core/sysemu-cpu-ops.h"
 #include "exec/address-spaces.h"
 #endif
+#include "sysemu/cpus.h"
 #include "sysemu/tcg.h"
-#include "sysemu/kvm.h"
 #include "exec/replay-core.h"
 #include "exec/cpu-common.h"
 #include "exec/exec-all.h"
@@ -326,9 +326,14 @@ void cpu_single_step(CPUState *cpu, int enabled)
 {
     if (cpu->singlestep_enabled != enabled) {
         cpu->singlestep_enabled = enabled;
-        if (kvm_enabled()) {
-            kvm_update_guest_debug(cpu, 0);
+
+#if !defined(CONFIG_USER_ONLY)
+        const AccelOpsClass *ops = cpus_get_accel();
+        if (ops->update_guest_debug) {
+            ops->update_guest_debug(cpu);
         }
+#endif
+
         trace_breakpoint_singlestep(cpu->cpu_index, enabled);
     }
 }
-- 
2.39.2

