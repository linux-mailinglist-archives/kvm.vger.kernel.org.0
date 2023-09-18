Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D147A4E96
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbjIRQTr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbjIRQT2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:19:28 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40355CEC
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:10:56 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-403012f276dso50790725e9.0
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695053440; x=1695658240; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s5SThQE8VrEigaiBVVD1aPn+S9Eqq7fLgyN+q+7eopw=;
        b=Gh03zHCe7gK1jzIbBWZcdDMy6iDkfsp1t5W7J6Gy7qNIt3qF3uUbF3lMBLlBpdKkGI
         BazjU4mVcdms/RlcNVNh9AH8cWn6XF1Xnb5u4hJwNqeOqlckPBgngmH5zPyiBfD7OPm7
         KcWzyIyNTGtOXEK35xremOZUE0TwS3/ZAJBsITqpZixyAsdtjR7rVb8XzPbMXdk+1ej8
         QHoZ5Zqzgnk5A+rt2p8HVx6I6vdWL+sW7mjysclW2M3jWqcfQZuN7U3kT9YgAzihwjaG
         5E64Cs1lGb0G14XZNMdzYcG0dndM/L1eHjGXWABzwFADD+2aDjwG6kBjMc3+Dac6gQFK
         T4uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695053440; x=1695658240;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s5SThQE8VrEigaiBVVD1aPn+S9Eqq7fLgyN+q+7eopw=;
        b=ivdw3StIMHq3GrwIsjNExwoHcdPKtNOri/myhn0zyJROeUHiJlc6BeK4oukNSVFJnz
         OFU/fRvOO2dV32KiC7ihaNZxIUQb3snxFmDIrwNzUDuz5BvetYMoCs2h5+qvbo6S4y6K
         qkssxw3jA0/Em3bPwFG6Sy70uQ23PL1TTwU+aFd0AkgmuUsyV5KHgNvyZo0X/EjTCQtz
         rbrp+19VqFMVhpxHkgwM1DsnVi700YTEtBhDwFixDmjCQUhp5DJgrPCuqyWRI3bFSLzM
         Wh4vEZj4p3ohU9c6elZkdJzrNzdszlPjP81oHwq9ndoHOsslIoQPTInwSWvIt+S7moBz
         k2zw==
X-Gm-Message-State: AOJu0YzsiZnNC1cg9v5NYn4DHen4CRdMfCw/JGdOuDAI45BVYWSkqflX
        1WDq5tgsCjF5Wd3p7qD8HRou+MkNUCdmwytjhIjaDOWA
X-Google-Smtp-Source: AGHT+IFdhAv8NMQe3eDFfz6fXbmFXmpOAUlZ51p/ozjG+nSdvaZT7LZnHlxk4GI+z0N+RInhKW7YXQ==
X-Received: by 2002:a17:906:768f:b0:9ad:fb23:21cf with SMTP id o15-20020a170906768f00b009adfb2321cfmr4715553ejm.15.1695053064161;
        Mon, 18 Sep 2023 09:04:24 -0700 (PDT)
Received: from localhost.localdomain (static-212-193-78-212.thenetworkfactory.nl. [212.78.193.212])
        by smtp.gmail.com with ESMTPSA id c26-20020a170906341a00b00993470682e5sm6646928ejb.32.2023.09.18.09.04.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 18 Sep 2023 09:04:23 -0700 (PDT)
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
Subject: [PATCH 16/22] target/arm: Extract verify_accel_features() from cpu_realize()
Date:   Mon, 18 Sep 2023 18:02:49 +0200
Message-ID: <20230918160257.30127-17-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230918160257.30127-1-philmd@linaro.org>
References: <20230918160257.30127-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When looking at the arm_cpu_realizefn() method, most of the
code run before the cpu_exec_realizefn() call checks whether
the requested CPU features are compatible with the requested
accelerator. Extract this code to a dedicated handler matching
our recently added CPUClass::verify_accel_features() handler.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/cpu.c | 41 ++++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 46d3f70d63..a551383fd3 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1675,19 +1675,10 @@ void arm_cpu_finalize_features(ARMCPU *cpu, Error **errp)
     }
 }
 
-static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
+static bool arm_cpu_verify_accel_features(CPUState *cs, Error **errp)
 {
-    CPUState *cs = CPU(dev);
-    ARMCPU *cpu = ARM_CPU(dev);
-    ARMCPUClass *acc = ARM_CPU_GET_CLASS(dev);
+    ARMCPU *cpu = ARM_CPU(cs);
     CPUARMState *env = &cpu->env;
-    int pagebits;
-    Error *local_err = NULL;
-
-    /* Use pc-relative instructions in system-mode */
-#ifndef CONFIG_USER_ONLY
-    cs->tcg_cflags |= CF_PCREL;
-#endif
 
     /* If we needed to query the host kernel for the CPU features
      * then it's possible that might have failed in the initfn, but
@@ -1699,10 +1690,13 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
         } else {
             error_setg(errp, "Failed to retrieve host CPU features");
         }
-        return;
+        return false;
     }
 
 #ifndef CONFIG_USER_ONLY
+    /* Use pc-relative instructions in system-mode */
+    cs->tcg_cflags |= CF_PCREL;
+
     /* The NVIC and M-profile CPU are two halves of a single piece of
      * hardware; trying to use one without the other is a command line
      * error and will result in segfaults if not caught here.
@@ -1710,12 +1704,12 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
     if (arm_feature(env, ARM_FEATURE_M)) {
         if (!env->nvic) {
             error_setg(errp, "This board cannot be used with Cortex-M CPUs");
-            return;
+            return false;
         }
     } else {
         if (env->nvic) {
             error_setg(errp, "This board can only be used with Cortex-M CPUs");
-            return;
+            return false;
         }
     }
 
@@ -1733,23 +1727,35 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
             error_setg(errp,
                        "Cannot enable %s when using an M-profile guest CPU",
                        current_accel_name());
-            return;
+            return false;
         }
         if (cpu->has_el3) {
             error_setg(errp,
                        "Cannot enable %s when guest CPU has EL3 enabled",
                        current_accel_name());
-            return;
+            return false;
         }
         if (cpu->tag_memory) {
             error_setg(errp,
                        "Cannot enable %s when guest CPUs has MTE enabled",
                        current_accel_name());
-            return;
+            return false;
         }
     }
 #endif
 
+    return true;
+}
+
+static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
+{
+    CPUState *cs = CPU(dev);
+    ARMCPU *cpu = ARM_CPU(dev);
+    ARMCPUClass *acc = ARM_CPU_GET_CLASS(dev);
+    CPUARMState *env = &cpu->env;
+    int pagebits;
+    Error *local_err = NULL;
+
     cpu_exec_realizefn(cs, &local_err);
     if (local_err != NULL) {
         error_propagate(errp, local_err);
@@ -2383,6 +2389,7 @@ static void arm_cpu_class_init(ObjectClass *oc, void *data)
                                        &acc->parent_phases);
 
     cc->class_by_name = arm_cpu_class_by_name;
+    cc->verify_accel_features = arm_cpu_verify_accel_features;
     cc->has_work = arm_cpu_has_work;
     cc->dump_state = arm_cpu_dump_state;
     cc->set_pc = arm_cpu_set_pc;
-- 
2.41.0

