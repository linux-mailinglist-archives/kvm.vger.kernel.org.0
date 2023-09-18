Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2B2A7A4F11
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbjIRQdv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjIRQd2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:33:28 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A9C7DAD
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:12:26 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 2adb3069b0e04-50307acd445so3036189e87.0
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695053544; x=1695658344; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DBZjR8eqTRO2FcjHJbn6UW72+cRDsZ12eh5J24aMJRM=;
        b=haspA+XP0LsiyjV075ImbvGI2G6QezOcMkCNOOeBt3WgQGvpfzlghwViDOuEfD1g/L
         VypNe2MQ3ZOKuaZfW0d/SK88QT3ZezVn2bPUU/l1htDeV6nEOWnT6pQYouKit6ggZpyd
         9MswgzN9xRk5cqHlHZ83tQbsCuFPmWf7ENOWNQCIMfB4NODYaIvDRbFBksLB1OxwJ37Y
         +gUC2xw/fDh92xE2H6eFhGL+t+4EXfJo3DOxr/xczW1rEe2tODkniwQPVOloHzhdmjhg
         AoWPZn+dCdMvp5BftXaXaizxRndr7aZOHqLtzRkJomxl0Jxuba07UK+ufWEbtXDLMmbL
         gPtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695053544; x=1695658344;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DBZjR8eqTRO2FcjHJbn6UW72+cRDsZ12eh5J24aMJRM=;
        b=HrsF1ZLIfP631hOTJZ1Z9isyl/bfCE8I2zLwHR7Nt7e3XB1aYXU8cpaTvKgY+vbJ2Z
         RNg3RnvVUngZhiBkwP8T1SOKfDI/wcWZZxMFBPDn9xnYl9fzvIcawjlXdD70EtNKWga7
         qRqNQGWqvi62z28UVWudJM8sXS55YTdpe+nAiutzgsb9FePAAvC+gXVJQ/OqeKQTc5Qa
         jRJ1Gszcvsaly3Lp5W7IhfuV9OtcPDriXA9ryGpkKFh/nql0pxiC2EV4Fub/aWQVAL6d
         GhE9DF4Plezh9OjkOPRchsDg5FwacclXsCtbaUY3AqND2Iqy3x3w6mTllk+wdF9+Eois
         I/tQ==
X-Gm-Message-State: AOJu0YwdjpJDv5B12UsqQii6ogHz5qnhxH5B7ENgK602bJR0+hhh1OfK
        UlaJyu4axvdMxygpvPCwQC4PRYtBEWTfWMRUFNEHZ6wr
X-Google-Smtp-Source: AGHT+IFSQh3aSy8WNfVsJ8gBPwr/UHTrTRJ5GVnUXxcFo9z61kuLhRihhFERCd0BfPS6IwLRcpPE5w==
X-Received: by 2002:a17:906:209b:b0:9a9:fa50:1fa8 with SMTP id 27-20020a170906209b00b009a9fa501fa8mr8796931ejq.40.1695053042868;
        Mon, 18 Sep 2023 09:04:02 -0700 (PDT)
Received: from localhost.localdomain (static-212-193-78-212.thenetworkfactory.nl. [212.78.193.212])
        by smtp.gmail.com with ESMTPSA id z15-20020a170906240f00b0099bd1ce18fesm6723198eja.10.2023.09.18.09.04.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 18 Sep 2023 09:04:02 -0700 (PDT)
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
Subject: [PATCH 12/22] target/mips: Create clock *after* accelerator vCPU is realized
Date:   Mon, 18 Sep 2023 18:02:45 +0200
Message-ID: <20230918160257.30127-13-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230918160257.30127-1-philmd@linaro.org>
References: <20230918160257.30127-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Architecture specific hardware doesn't have a particular dependency
on the accelerator vCPU (created with cpu_exec_realizefn), and can
be initialized *after* the vCPU is realized. Doing so allows further
generic API simplification (in few commits).

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/mips/cpu.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index 0aea69aaf9..7c81e6c356 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -464,20 +464,6 @@ static void mips_cpu_realizefn(DeviceState *dev, Error **errp)
     MIPSCPUClass *mcc = MIPS_CPU_GET_CLASS(dev);
     Error *local_err = NULL;
 
-    if (!clock_get(cpu->clock)) {
-#ifndef CONFIG_USER_ONLY
-        if (!qtest_enabled()) {
-            g_autofree char *cpu_freq_str = freq_to_str(CPU_FREQ_HZ_DEFAULT);
-
-            warn_report("CPU input clock is not connected to any output clock, "
-                        "using default frequency of %s.", cpu_freq_str);
-        }
-#endif
-        /* Initialize the frequency in case the clock remains unconnected. */
-        clock_set_hz(cpu->clock, CPU_FREQ_HZ_DEFAULT);
-    }
-    mips_cp0_period_set(cpu);
-
     cpu_exec_realizefn(cs, &local_err);
     if (local_err != NULL) {
         error_propagate(errp, local_err);
@@ -492,6 +478,20 @@ static void mips_cpu_realizefn(DeviceState *dev, Error **errp)
     fpu_init(env, env->cpu_model);
     mvp_init(env);
 
+    if (!clock_get(cpu->clock)) {
+#ifndef CONFIG_USER_ONLY
+        if (!qtest_enabled()) {
+            g_autofree char *cpu_freq_str = freq_to_str(CPU_FREQ_HZ_DEFAULT);
+
+            warn_report("CPU input clock is not connected to any output clock, "
+                        "using default frequency of %s.", cpu_freq_str);
+        }
+#endif
+        /* Initialize the frequency in case the clock remains unconnected. */
+        clock_set_hz(cpu->clock, CPU_FREQ_HZ_DEFAULT);
+    }
+    mips_cp0_period_set(cpu);
+
     mcc->parent_realize(dev, errp);
     cpu_reset(cs);
 }
-- 
2.41.0

