Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB696A894D
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 20:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjCBTOg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 14:14:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjCBTO0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 14:14:26 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2536018169
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 11:14:25 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id t15so140525wrz.7
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 11:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OkchIjEfD+60EpcbCT5XhulXGtH6Nh+X+dtOXOoAXwo=;
        b=ZA0YRhSKo0mKNsXz/40NcIJ0lx+r74+ySfJ0wptw+mc/NHg3LXJwLe4oaSogxLLvVT
         MXaHUbDMuxCP6fJGdN38Fu8rlaUvahqRlx2skoLOTRMdw8X/f/aca7JRT9Rx+4z0nzYS
         k5WaUGckPkD+ZLTewsmx3JKjlbTiM7+ZII8UCzvNcYO1sKmlss9ilWL424WKSssCIJUB
         ke35tRnrzFvWs3bfo9a3ubqRZfNorhdc412Rc52usg1Bo8O7YFCj+aDf5elShp6qi6ns
         Hm+TnfopORY7xXsyOj9rxGCTOGGkWXiZ+4kyNRsOqWktKGBiVyas2NduA6sg9DHdhZQp
         3ScA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OkchIjEfD+60EpcbCT5XhulXGtH6Nh+X+dtOXOoAXwo=;
        b=4ey4YTZilBe2vGxBzKSAro148aZCIJ05PtyFuAZvUF45/ru++1x11Rrc9zBTJh58r4
         uZrziLjQAUAxhvB4CK4wcxbyESYQRf8GZi89o8rfKjvtMZ4goLMuDrX8rJSE68KB3pxL
         tYshwN+Ino3Glga33UA4rSbMGNI+312f8cjYCJvV+HTuJ3vshSQLluCm+Hlrkn0cdJqI
         RJFizgu4YLrqkSDJ1lqQ9ZIPH4wWo7+rLeJMheYWSXGkSqf82zDjoAixfoqGTDJVrmDc
         2TwLmbhSGDIDmnFV6Fn3VMsFbF1fij1ZCf6WSnd4iRGsUzGzci+3xYWpdhsAd2rqpvFh
         BKgw==
X-Gm-Message-State: AO0yUKVfswuqhcA9s0vX/qhYM2kPvqrUZvAPw1wOm0DhxmtylbX3dLCU
        hTiHoqRXT8q9JloMB+YJ7oSK1Q==
X-Google-Smtp-Source: AK7set+rHHp+XuBPHtP8FDC0egngoTGIIwBolsTa9jbmzaAhXxpb+Ba6ajcNYTOiZ6Vf8U0Zm0yzzA==
X-Received: by 2002:a5d:5189:0:b0:2c3:be89:7c2b with SMTP id k9-20020a5d5189000000b002c3be897c2bmr2200483wrv.14.1677784463604;
        Thu, 02 Mar 2023 11:14:23 -0800 (PST)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id x9-20020a5d60c9000000b002c70d97af78sm141079wrt.85.2023.03.02.11.14.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 11:14:21 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id C5DF41FFC5;
        Thu,  2 Mar 2023 19:08:48 +0000 (GMT)
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
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v4 16/26] gdbstub: introduce gdb_get_max_cpus
Date:   Thu,  2 Mar 2023 19:08:36 +0000
Message-Id: <20230302190846.2593720-17-alex.bennee@linaro.org>
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

This is needed for handling vcont packets as the way of calculating
max cpus vhanges between user and softmmu mode.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

---
v3
  - rm out of date comment
---
 gdbstub/internals.h |  1 +
 gdbstub/gdbstub.c   | 11 +----------
 gdbstub/softmmu.c   |  9 +++++++++
 gdbstub/user.c      | 17 +++++++++++++++++
 4 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/gdbstub/internals.h b/gdbstub/internals.h
index d8c0292d99..26a6468a69 100644
--- a/gdbstub/internals.h
+++ b/gdbstub/internals.h
@@ -129,6 +129,7 @@ bool gdb_got_immediate_ack(void);
 CPUState *gdb_first_attached_cpu(void);
 void gdb_append_thread_id(CPUState *cpu, GString *buf);
 int gdb_get_cpu_index(CPUState *cpu);
+unsigned int gdb_get_max_cpus(void); /* both */
 
 void gdb_create_default_process(GDBState *s);
 
diff --git a/gdbstub/gdbstub.c b/gdbstub/gdbstub.c
index ed38ab0aaa..1b783100c2 100644
--- a/gdbstub/gdbstub.c
+++ b/gdbstub/gdbstub.c
@@ -624,16 +624,7 @@ static int gdb_handle_vcont(const char *p)
     GDBProcess *process;
     CPUState *cpu;
     GDBThreadIdKind kind;
-#ifdef CONFIG_USER_ONLY
-    int max_cpus = 1; /* global variable max_cpus exists only in system mode */
-
-    CPU_FOREACH(cpu) {
-        max_cpus = max_cpus <= cpu->cpu_index ? cpu->cpu_index + 1 : max_cpus;
-    }
-#else
-    MachineState *ms = MACHINE(qdev_get_machine());
-    unsigned int max_cpus = ms->smp.max_cpus;
-#endif
+    unsigned int max_cpus = gdb_get_max_cpus();
     /* uninitialised CPUs stay 0 */
     newstates = g_new0(char, max_cpus);
 
diff --git a/gdbstub/softmmu.c b/gdbstub/softmmu.c
index ab2d182654..3a5587d387 100644
--- a/gdbstub/softmmu.c
+++ b/gdbstub/softmmu.c
@@ -440,6 +440,15 @@ int gdb_target_memory_rw_debug(CPUState *cpu, hwaddr addr,
     return cpu_memory_rw_debug(cpu, addr, buf, len, is_write);
 }
 
+/*
+ * cpu helpers
+ */
+
+unsigned int gdb_get_max_cpus(void)
+{
+    MachineState *ms = MACHINE(qdev_get_machine());
+    return ms->smp.max_cpus;
+}
 
 /*
  * Softmmu specific command helpers
diff --git a/gdbstub/user.c b/gdbstub/user.c
index 92663d971c..e10988a62b 100644
--- a/gdbstub/user.c
+++ b/gdbstub/user.c
@@ -393,6 +393,23 @@ int gdb_target_memory_rw_debug(CPUState *cpu, hwaddr addr,
     return cpu_memory_rw_debug(cpu, addr, buf, len, is_write);
 }
 
+/*
+ * cpu helpers
+ */
+
+unsigned int gdb_get_max_cpus(void)
+{
+    CPUState *cpu;
+    unsigned int max_cpus = 1;
+
+    CPU_FOREACH(cpu) {
+        max_cpus = max_cpus <= cpu->cpu_index ? cpu->cpu_index + 1 : max_cpus;
+    }
+
+    return max_cpus;
+}
+
+
 /*
  * Break/Watch point helpers
  */
-- 
2.39.2

