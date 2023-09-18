Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D317A4F8A
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjIRQpj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjIRQpT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:45:19 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A89861A5
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:10:28 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2bffdf50212so24780581fa.1
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695053426; x=1695658226; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZP1Jq5UriapAIWJmFwmSYSQUUVqpdEGdHuUn9UNvH2c=;
        b=Sa7jQTAmeO+PCW88D6d6oLjctD7vUw7AriFjDWuIQLw2tL8klrZMWxtovvNkVG5KSV
         8URESMwCvnjb0r/13BUyWd86GNmYdYWxDvEPtx9V8QavBXUiVIEp2QvFwyTehw2GJGkh
         v/MFdm1XFoqlvacjQP/WphM8BARvQ8Hgxka00Q9K4RgzrrfARLqv63m3wkqnW9dydWuQ
         N3DRUfY2SttjzDGxZtlQvOkY3/tuHHTgd2tSOgtLzi469lggws4pj6Aabz9eX6xaqei0
         r3BImaVFwafAerHc/N3QQ6JgnKJwrX4aedNSbs+YVwqKKaayRnyXFT+quAuO3zpsksOl
         62Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695053426; x=1695658226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZP1Jq5UriapAIWJmFwmSYSQUUVqpdEGdHuUn9UNvH2c=;
        b=NLnq4bk1cdopce/5zCrmA8Dykd3+brV5964efdEw9N9KKbKxTjmwU3lQ3eMlzXKxGs
         TUDZePYCLaA6Aqe9iMhReBcN8YrapfepObEcqgnYhmJB0lhpbIlolYIgZJUTq8PJutYy
         c/lpCb2xS0ZOb8VHZzTEcriT6fMsnpFfGYZYnmWFA7rNEq3qSS76I3R9cbCwoDgDoxFs
         1l4lpdSsWUaLBTn1931qsQSA17MzmPS2kbr6hsNrNi98R4FuoTOCRYMbz9EENu8SMm0E
         /VPpPkp48Tt4ybx2SLKipTWPEAuQn7S1ZkV9uc7u+PLcbpyfMEMNGMhOJNlh/e+TBF8u
         L2Cw==
X-Gm-Message-State: AOJu0YxvIsoOnWX3lw66dOBjn8JYoKqNZrqew5IcGCqKc5aHpfGiju84
        oEii+Gjv7kUajg3Y4X76W5939FgsDW6Sv9jOKVDNJyrC
X-Google-Smtp-Source: AGHT+IHqyjalPcNFI3j/eC2mJhJCqyXLJDQU80ViEPpsSEn13nBGjwNzQvCpQXl9ahmUuhJ660k6zA==
X-Received: by 2002:a05:6512:31cd:b0:503:1722:bf3a with SMTP id j13-20020a05651231cd00b005031722bf3amr3370635lfe.1.1695053069418;
        Mon, 18 Sep 2023 09:04:29 -0700 (PDT)
Received: from localhost.localdomain (static-212-193-78-212.thenetworkfactory.nl. [212.78.193.212])
        by smtp.gmail.com with ESMTPSA id ec31-20020a0564020d5f00b00530a9488623sm4149603edb.46.2023.09.18.09.04.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 18 Sep 2023 09:04:28 -0700 (PDT)
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
Subject: [PATCH 17/22] target/i386: Extract verify_accel_features() from cpu_realize()
Date:   Mon, 18 Sep 2023 18:02:50 +0200
Message-ID: <20230918160257.30127-18-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230918160257.30127-1-philmd@linaro.org>
References: <20230918160257.30127-1-philmd@linaro.org>
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

When looking at the x86_cpu_realizefn() method, most of the
code run before the cpu_exec_realizefn() call checks whether
the requested CPU features are compatible with the requested
accelerator. Extract this code to a dedicated handler matching
our recently added CPUClass::verify_accel_features() handler.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/cpu.c | 62 +++++++++++++++++++++++++++--------------------
 1 file changed, 36 insertions(+), 26 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index d79797d963..2884733397 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7208,26 +7208,19 @@ static void x86_cpu_hyperv_realize(X86CPU *cpu)
     cpu->hyperv_limits[2] = 0;
 }
 
-static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
+/*
+ * note: the call to the framework needs to happen after feature expansion,
+ * but before the checks/modifications to ucode_rev, mwait, phys_bits.
+ * These may be set by the accel-specific code,
+ * and the results are subsequently checked / assumed in x86_cpu_realizefn().
+ */
+static bool x86_cpu_verify_accel_features(CPUState *cs, Error **errp)
 {
-    CPUState *cs = CPU(dev);
-    X86CPU *cpu = X86_CPU(dev);
-    X86CPUClass *xcc = X86_CPU_GET_CLASS(dev);
+    X86CPU *cpu = X86_CPU(cs);
     CPUX86State *env = &cpu->env;
     Error *local_err = NULL;
-    static bool ht_warned;
     unsigned requested_lbr_fmt;
 
-    /* Use pc-relative instructions in system-mode */
-#ifndef CONFIG_USER_ONLY
-    cs->tcg_cflags |= CF_PCREL;
-#endif
-
-    if (cpu->apic_id == UNASSIGNED_APIC_ID) {
-        error_setg(errp, "apic-id property was not initialized properly");
-        return;
-    }
-
     /*
      * Process Hyper-V enlightenments.
      * Note: this currently has to happen before the expansion of CPU features.
@@ -7236,7 +7229,7 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
 
     x86_cpu_expand_features(cpu, &local_err);
     if (local_err) {
-        goto out;
+        return false;
     }
 
     /*
@@ -7246,7 +7239,7 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
     if (cpu->lbr_fmt != ~PERF_CAP_LBR_FMT) {
         if ((cpu->lbr_fmt & PERF_CAP_LBR_FMT) != cpu->lbr_fmt) {
             error_setg(errp, "invalid lbr-fmt");
-            return;
+            return false;
         }
         env->features[FEAT_PERF_CAPABILITIES] &= ~PERF_CAP_LBR_FMT;
         env->features[FEAT_PERF_CAPABILITIES] |= cpu->lbr_fmt;
@@ -7265,13 +7258,13 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
 
         if (!cpu->enable_pmu) {
             error_setg(errp, "vPMU: LBR is unsupported without pmu=on");
-            return;
+            return false;
         }
         if (requested_lbr_fmt != host_lbr_fmt) {
             error_setg(errp, "vPMU: the lbr-fmt value (0x%x) does not match "
                         "the host value (0x%x).",
                         requested_lbr_fmt, host_lbr_fmt);
-            return;
+            return false;
         }
     }
 
@@ -7282,7 +7275,7 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
                    accel_uses_host_cpuid() ?
                        "Host doesn't support requested features" :
                        "TCG doesn't support requested features");
-        goto out;
+        return false;
     }
 
     /* On AMD CPUs, some CPUID[8000_0001].EDX bits must match the bits on
@@ -7296,12 +7289,28 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
 
     x86_cpu_set_sgxlepubkeyhash(env);
 
-    /*
-     * note: the call to the framework needs to happen after feature expansion,
-     * but before the checks/modifications to ucode_rev, mwait, phys_bits.
-     * These may be set by the accel-specific code,
-     * and the results are subsequently checked / assumed in this function.
-     */
+    return true;
+}
+
+static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
+{
+    CPUState *cs = CPU(dev);
+    X86CPU *cpu = X86_CPU(dev);
+    X86CPUClass *xcc = X86_CPU_GET_CLASS(dev);
+    CPUX86State *env = &cpu->env;
+    Error *local_err = NULL;
+    static bool ht_warned;
+
+    /* Use pc-relative instructions in system-mode */
+#ifndef CONFIG_USER_ONLY
+    cs->tcg_cflags |= CF_PCREL;
+#endif
+
+    if (cpu->apic_id == UNASSIGNED_APIC_ID) {
+        error_setg(errp, "apic-id property was not initialized properly");
+        return;
+    }
+
     cpu_exec_realizefn(cs, &local_err);
     if (local_err != NULL) {
         error_propagate(errp, local_err);
@@ -7950,6 +7959,7 @@ static void x86_cpu_common_class_init(ObjectClass *oc, void *data)
 
     cc->class_by_name = x86_cpu_class_by_name;
     cc->parse_features = x86_cpu_parse_featurestr;
+    cc->verify_accel_features = x86_cpu_verify_accel_features;
     cc->has_work = x86_cpu_has_work;
     cc->dump_state = x86_cpu_dump_state;
     cc->set_pc = x86_cpu_set_pc;
-- 
2.41.0

