Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 906086A894C
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 20:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjCBTOd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 14:14:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbjCBTOZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 14:14:25 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E518518156
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 11:14:23 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id j19-20020a05600c191300b003eb3e1eb0caso2535639wmq.1
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 11:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kvMUUc5wEUJYWdA676z788wbTTrYmGmHmSy4eXEEE4E=;
        b=No0tJw9N+bb/4p6Vsb6qYzWqwgEsGf2ywyP5YYcxA4ht4YgrV8RALbz4Q2rLJItRC1
         ZnnIWD7acjmco+PLes60MWbG8kPlpWW6QpkK0DndOv4Ejb21sgl2ouenPEtc8IG0vZo7
         9JjbofdnGZZMPLcMmIlizC3ARNI9clEPQ2Xv5MYGKXJ+Ne4SOc1M0miivaS7NQ7o53p8
         bUMe46WJyHyUu3RtC0wRZPM5IDoX/3Ozb7TFM/RMxfQGTUQ8ea+jbHm1SaqX+A4X4WiM
         EmKUrVk2ZrEhOuafiu5bT6yvrzV1ogkGkapqioJTYdikH/LRZiUA9/n9LCUn3LY7ApnY
         Oh0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kvMUUc5wEUJYWdA676z788wbTTrYmGmHmSy4eXEEE4E=;
        b=Kzw15KyzQ9h4uAKSCdA5ETsMW8VbTgNvHPH/VviD9DGDwhAP8tFuHaaJxFosAiDLT3
         PdWZVfIIuUCs822nn3KQSVdq3ofvDHNip7wdtWSwK6DuMDcZ1uDViS+RN5HiuzhZHejr
         MNrYtnRy4kYPFYGmiSbQtSvlHrTCyzch1Oy+hr27RTRkokrBKBgbiyc0PjzBx0F18U0P
         /e/+3kjqFBxW6MrrEx7gNOHS99M8Pw/2DIVxt1l7gO+KOfgzGMWQ9rB1cUTKwaqqbTVB
         45rKRPxRxTRRxgSgI4559/qLfVqP/Go2vO2PtJZPQJAznMfgn9YkT9kuHNAZXMQcvm+G
         J7Fg==
X-Gm-Message-State: AO0yUKVjH1Gyy7ePi5iNJ7+oA7tBmAv8QLLiQDj7LJaqJjlxPZtE0Y8S
        kZk5akR3voDYcjjSz6OSGdOc9w==
X-Google-Smtp-Source: AK7set99x5f15zwPdc3lgmkc1Lm3RjN/nUIbueV8TnBeIymj/y6MSAhspthJMp+dsHxYBVPf4c6YJw==
X-Received: by 2002:a05:600c:181c:b0:3eb:2e1e:beae with SMTP id n28-20020a05600c181c00b003eb2e1ebeaemr8262271wmp.25.1677784462476;
        Thu, 02 Mar 2023 11:14:22 -0800 (PST)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id ip21-20020a05600ca69500b003eb596cbc54sm450210wmb.0.2023.03.02.11.14.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 11:14:21 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id E698E1FFC6;
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
Subject: [PATCH v4 17/26] gdbstub: specialise stub_can_reverse
Date:   Thu,  2 Mar 2023 19:08:37 +0000
Message-Id: <20230302190846.2593720-18-alex.bennee@linaro.org>
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

Currently we only support replay for softmmu mode so it is a constant
false for user-mode.

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

---
v3
  - rename gdb_stub_can_revers -> gdb_can_reverse
---
 gdbstub/internals.h |  1 +
 gdbstub/gdbstub.c   | 13 ++-----------
 gdbstub/softmmu.c   |  5 +++++
 gdbstub/user.c      |  5 +++++
 4 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/gdbstub/internals.h b/gdbstub/internals.h
index 26a6468a69..be0eef4850 100644
--- a/gdbstub/internals.h
+++ b/gdbstub/internals.h
@@ -130,6 +130,7 @@ CPUState *gdb_first_attached_cpu(void);
 void gdb_append_thread_id(CPUState *cpu, GString *buf);
 int gdb_get_cpu_index(CPUState *cpu);
 unsigned int gdb_get_max_cpus(void); /* both */
+bool gdb_can_reverse(void); /* softmmu, stub for user */
 
 void gdb_create_default_process(GDBState *s);
 
diff --git a/gdbstub/gdbstub.c b/gdbstub/gdbstub.c
index 1b783100c2..7301466ff5 100644
--- a/gdbstub/gdbstub.c
+++ b/gdbstub/gdbstub.c
@@ -113,15 +113,6 @@ int use_gdb_syscalls(void)
     return gdb_syscall_mode == GDB_SYS_ENABLED;
 }
 
-static bool stub_can_reverse(void)
-{
-#ifdef CONFIG_USER_ONLY
-    return false;
-#else
-    return replay_mode == REPLAY_MODE_PLAY;
-#endif
-}
-
 /* writes 2*len+1 bytes in buf */
 void gdb_memtohex(GString *buf, const uint8_t *mem, int len)
 {
@@ -1308,7 +1299,7 @@ static void handle_step(GArray *params, void *user_ctx)
 
 static void handle_backward(GArray *params, void *user_ctx)
 {
-    if (!stub_can_reverse()) {
+    if (!gdb_can_reverse()) {
         gdb_put_packet("E22");
     }
     if (params->len == 1) {
@@ -1559,7 +1550,7 @@ static void handle_query_supported(GArray *params, void *user_ctx)
         g_string_append(gdbserver_state.str_buf, ";qXfer:features:read+");
     }
 
-    if (stub_can_reverse()) {
+    if (gdb_can_reverse()) {
         g_string_append(gdbserver_state.str_buf,
             ";ReverseStep+;ReverseContinue+");
     }
diff --git a/gdbstub/softmmu.c b/gdbstub/softmmu.c
index 3a5587d387..d2863d0663 100644
--- a/gdbstub/softmmu.c
+++ b/gdbstub/softmmu.c
@@ -450,6 +450,11 @@ unsigned int gdb_get_max_cpus(void)
     return ms->smp.max_cpus;
 }
 
+bool gdb_can_reverse(void)
+{
+    return replay_mode == REPLAY_MODE_PLAY;
+}
+
 /*
  * Softmmu specific command helpers
  */
diff --git a/gdbstub/user.c b/gdbstub/user.c
index e10988a62b..3f6183e66a 100644
--- a/gdbstub/user.c
+++ b/gdbstub/user.c
@@ -409,6 +409,11 @@ unsigned int gdb_get_max_cpus(void)
     return max_cpus;
 }
 
+/* replay not supported for user-mode */
+bool gdb_can_reverse(void)
+{
+    return false;
+}
 
 /*
  * Break/Watch point helpers
-- 
2.39.2

