Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE246A894E
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 20:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjCBTOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 14:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbjCBTO1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 14:14:27 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E824419683
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 11:14:25 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id t25-20020a1c7719000000b003eb052cc5ccso2515840wmi.4
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 11:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hPckY1i9/afyDgbEgGvXK1gW63TVchEE6fBLm/0KY9U=;
        b=N+KnOEUBoGC/1nIkicXd5l1SOjqX1TKqBCd6X9BCF5PvOmhg8hQQsf76J1FgTBhn9i
         0YfaCyhmP9+XTknmV7jzdRVtD7aXqXBldUOx3tmOqNq6Kj1EB1FZIWYX2NtebKYBJp/7
         hDqQbdh/SlPVDDDhXLBnBQGjxYj9/b3QQzDN7iK4UYsC22Z9p6/2QSITDfKxGf01j2s+
         E32z5Oh4HVVnWgYaneyGfz9g+y5zCUMAME5WuQncSPioHTjSWOlDksbPJLzGamRlU5eU
         uBZTqryWMS8kpnj3QoGRWIpldwfax64K6UIrncN9dpWIPMLqtPGzVk/aFFE8ASANDfWu
         m8Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hPckY1i9/afyDgbEgGvXK1gW63TVchEE6fBLm/0KY9U=;
        b=DCIwrKCAkcgPtmZ4YW/3oRz2dfM0IiJVETov5zqVRvTdo4Msiau6c/g3l+rYiUf8W4
         GFmSVqwYKM0q0dk5Qx7o1bhjQwxvGe5X3adPdhB2GWzvgey6ece37TGpL3iO/92fwu0e
         CU+bJ8cZZ+kFTNsuVz18Q4tnEbLgCeByS2bExD6MXmP8+/pbhqlSYrmUK9aJg6iikWpi
         OIghdiIyLBho62KIS/ZUDwZCj1VsEg86w8dX4Rcfr+5hoGHLgCJlcZMyaEll0qCg4/wh
         8lkRA7dLFWRPAUjCoW5gl9TWBRXgEbLqz5PpJX3vJcJBEvvbfOyn8WIhaSQd/LUBGlQ9
         g/Pg==
X-Gm-Message-State: AO0yUKV/VitFV+IC/i97ZqPdsORc79gRqBqud+JrKylqraBd9OGtimYO
        yYNHXuttwpHOhGRQJzZcLlNVJw==
X-Google-Smtp-Source: AK7set8MqFU/5jaVdDxnuYT+ajqtzMLG6tlGmGnhwj4AEnBYGZcS65UNRIQAw/eVtS3SNjKVhJy8YQ==
X-Received: by 2002:a05:600c:310c:b0:3eb:395b:8b62 with SMTP id g12-20020a05600c310c00b003eb395b8b62mr9248096wmo.39.1677784464419;
        Thu, 02 Mar 2023 11:14:24 -0800 (PST)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id f2-20020a5d50c2000000b002c704271b05sm144559wrt.66.2023.03.02.11.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 11:14:23 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 86ABC1FFC3;
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
Subject: [PATCH v4 14/26] gdbstub: specialise handle_query_attached
Date:   Thu,  2 Mar 2023 19:08:34 +0000
Message-Id: <20230302190846.2593720-15-alex.bennee@linaro.org>
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

In both user and softmmu cases we are just replying with a constant.

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

---
v3
  - remove allusions to possible linker optimisations
---
 gdbstub/internals.h |  4 +++-
 gdbstub/gdbstub.c   | 15 ++-------------
 gdbstub/softmmu.c   |  5 +++++
 gdbstub/user.c      |  5 +++++
 4 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/gdbstub/internals.h b/gdbstub/internals.h
index 6534e373cb..20caacd744 100644
--- a/gdbstub/internals.h
+++ b/gdbstub/internals.h
@@ -154,7 +154,7 @@ int gdb_continue_partial(char *newstates);
 void gdb_put_buffer(const uint8_t *buf, int len);
 
 /*
- * Command handlers - either softmmu or user only
+ * Command handlers - either specialised or softmmu or user only
  */
 void gdb_init_gdbserver_state(void);
 
@@ -183,6 +183,8 @@ void gdb_handle_query_rcmd(GArray *params, void *user_ctx); /* softmmu */
 void gdb_handle_query_offsets(GArray *params, void *user_ctx); /* user */
 void gdb_handle_query_xfer_auxv(GArray *params, void *user_ctx); /*user */
 
+void gdb_handle_query_attached(GArray *params, void *user_ctx); /* both */
+
 /*
  * Break/Watch point support - there is an implementation for softmmu
  * and user mode.
diff --git a/gdbstub/gdbstub.c b/gdbstub/gdbstub.c
index 0476ee7039..52d1769f57 100644
--- a/gdbstub/gdbstub.c
+++ b/gdbstub/gdbstub.c
@@ -46,12 +46,6 @@
 
 #include "internals.h"
 
-#ifdef CONFIG_USER_ONLY
-#define GDB_ATTACHED "0"
-#else
-#define GDB_ATTACHED "1"
-#endif
-
 #ifndef CONFIG_USER_ONLY
 static int phy_memory_mode;
 #endif
@@ -1673,11 +1667,6 @@ static void handle_query_xfer_features(GArray *params, void *user_ctx)
                       gdbserver_state.str_buf->len, true);
 }
 
-static void handle_query_attached(GArray *params, void *user_ctx)
-{
-    gdb_put_packet(GDB_ATTACHED);
-}
-
 static void handle_query_qemu_supported(GArray *params, void *user_ctx)
 {
     g_string_printf(gdbserver_state.str_buf, "sstepbits;sstep");
@@ -1787,12 +1776,12 @@ static const GdbCmdParseEntry gdb_gen_query_table[] = {
     },
 #endif
     {
-        .handler = handle_query_attached,
+        .handler = gdb_handle_query_attached,
         .cmd = "Attached:",
         .cmd_startswith = 1
     },
     {
-        .handler = handle_query_attached,
+        .handler = gdb_handle_query_attached,
         .cmd = "Attached",
     },
     {
diff --git a/gdbstub/softmmu.c b/gdbstub/softmmu.c
index 04e75449a2..7c180b779a 100644
--- a/gdbstub/softmmu.c
+++ b/gdbstub/softmmu.c
@@ -446,6 +446,11 @@ void gdb_handle_query_rcmd(GArray *params, void *user_ctx)
  * Execution state helpers
  */
 
+void gdb_handle_query_attached(GArray *params, void *user_ctx)
+{
+    gdb_put_packet("1");
+}
+
 void gdb_continue(void)
 {
     if (!runstate_needs_reset()) {
diff --git a/gdbstub/user.c b/gdbstub/user.c
index 0c8cd028b1..c0fd83b373 100644
--- a/gdbstub/user.c
+++ b/gdbstub/user.c
@@ -345,6 +345,11 @@ void gdbserver_fork(CPUState *cpu)
  * Execution state helpers
  */
 
+void gdb_handle_query_attached(GArray *params, void *user_ctx)
+{
+    gdb_put_packet("0");
+}
+
 void gdb_continue(void)
 {
     gdbserver_user_state.running_state = 1;
-- 
2.39.2

