Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4494A6A894B
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 20:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjCBTOc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 14:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjCBTOZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 14:14:25 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C0218A97
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 11:14:24 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id v16so204623wrn.0
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 11:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YcZgLPXFzYH2nM8OnzRIJ6/+BMVfARgO12rPV6+9lRs=;
        b=QzmCqvhlvk0aSavqacO0/dbwBYIrpOnDWKfHPjglM3nZPnwTkDUNiPrSCHTI+vSfgL
         5LgDxF+o7tbZif9BqKFfpb/Zd/fmnhFZChfNczilC6UyGel6TGGvc+AXC6TYdi4V7Nr3
         pPRrXGmg4sEOeQRnKOybFPrS1Fw3fle//Xy9Nv3zqqGr5rQgUf67lYzYK7B6yQobNnBQ
         MDV1W7qjaHHeAmUshnT/HmFkHkaJpiKntlSt/T7FRJGrgWgoAhrhGCZc9PYlvikvqYJa
         EV7lwTP6we8kPx9lgbQ3f7s2fXlqLs2HdOqnREJwAVeoF1tm9FazNAQm/L4+gALNgwQX
         xBsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YcZgLPXFzYH2nM8OnzRIJ6/+BMVfARgO12rPV6+9lRs=;
        b=mJiddCkV+gVzBgW1kyLxlNR+OAyWHAf5eQ3mB55+phrxDAUK643mtKPN2f0ube3YMd
         ptdSOwGhl/zfr3NhLrtqjnJQoCmql3eLbcn+YEC2zkzCdAy3Kyi1fEvOByy3HMWCDt9N
         GMWYv+7kiruXPHBCNTvyXoJwIMX0ei7Q37Bhe/AD2X/256Ib3HKVgv264MBNdDIYyzw5
         yTHPPZrmVy0G5QrOhTfdjZsO7+DsfBzGyjXgYArlPxbfqOfr/a0ridxRsA8VMUC2tkbQ
         JxGcKwO5Ui35DP+inIo7V1Q7MVm2PBdsJLNqfP3MMQBOuEslmzPISYN5wik05a7czAmv
         vu1w==
X-Gm-Message-State: AO0yUKXD2rLjmcRQyq/ZSMaa2OhjbXvT1slATjouALBYJXCwKvU83CLf
        Tw/1LyhiAU5z4KlmL/Hxm4zJZg==
X-Google-Smtp-Source: AK7set86ttx/YLHxKGDawdGkfm27cwOBEpZMwOgL/GzSnybahDI+T9cbXgLqCuamXVrR5GFU8UePjw==
X-Received: by 2002:adf:eed1:0:b0:2c5:4c9f:cf3b with SMTP id a17-20020adfeed1000000b002c54c9fcf3bmr2297414wrp.7.1677784462865;
        Thu, 02 Mar 2023 11:14:22 -0800 (PST)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id k8-20020a5d66c8000000b002c573a6216fsm162582wrw.37.2023.03.02.11.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 11:14:21 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id A73881FFC4;
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
Subject: [PATCH v4 15/26] gdbstub: specialise target_memory_rw_debug
Date:   Thu,  2 Mar 2023 19:08:35 +0000
Message-Id: <20230302190846.2593720-16-alex.bennee@linaro.org>
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

The two implementations are different enough to encourage having a
specialisation and we can move some of the softmmu only stuff out of
gdbstub.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 gdbstub/internals.h | 19 ++++++++++++
 gdbstub/gdbstub.c   | 73 +++++++--------------------------------------
 gdbstub/softmmu.c   | 51 +++++++++++++++++++++++++++++++
 gdbstub/user.c      | 15 ++++++++++
 4 files changed, 96 insertions(+), 62 deletions(-)

diff --git a/gdbstub/internals.h b/gdbstub/internals.h
index 20caacd744..d8c0292d99 100644
--- a/gdbstub/internals.h
+++ b/gdbstub/internals.h
@@ -185,6 +185,10 @@ void gdb_handle_query_xfer_auxv(GArray *params, void *user_ctx); /*user */
 
 void gdb_handle_query_attached(GArray *params, void *user_ctx); /* both */
 
+/* softmmu only */
+void gdb_handle_query_qemu_phy_mem_mode(GArray *params, void *user_ctx);
+void gdb_handle_set_qemu_phy_mem_mode(GArray *params, void *user_ctx);
+
 /*
  * Break/Watch point support - there is an implementation for softmmu
  * and user mode.
@@ -194,4 +198,19 @@ int gdb_breakpoint_insert(CPUState *cs, int type, vaddr addr, vaddr len);
 int gdb_breakpoint_remove(CPUState *cs, int type, vaddr addr, vaddr len);
 void gdb_breakpoint_remove_all(CPUState *cs);
 
+/**
+ * gdb_target_memory_rw_debug() - handle debug access to memory
+ * @cs: CPUState
+ * @addr: nominal address, could be an entire physical address
+ * @buf: data
+ * @len: length of access
+ * @is_write: is it a write operation
+ *
+ * This function is specialised depending on the mode we are running
+ * in. For softmmu guests we can switch the interpretation of the
+ * address to a physical address.
+ */
+int gdb_target_memory_rw_debug(CPUState *cs, hwaddr addr,
+                               uint8_t *buf, int len, bool is_write);
+
 #endif /* GDBSTUB_INTERNALS_H */
diff --git a/gdbstub/gdbstub.c b/gdbstub/gdbstub.c
index 52d1769f57..ed38ab0aaa 100644
--- a/gdbstub/gdbstub.c
+++ b/gdbstub/gdbstub.c
@@ -46,33 +46,6 @@
 
 #include "internals.h"
 
-#ifndef CONFIG_USER_ONLY
-static int phy_memory_mode;
-#endif
-
-static inline int target_memory_rw_debug(CPUState *cpu, target_ulong addr,
-                                         uint8_t *buf, int len, bool is_write)
-{
-    CPUClass *cc;
-
-#ifndef CONFIG_USER_ONLY
-    if (phy_memory_mode) {
-        if (is_write) {
-            cpu_physical_memory_write(addr, buf, len);
-        } else {
-            cpu_physical_memory_read(addr, buf, len);
-        }
-        return 0;
-    }
-#endif
-
-    cc = CPU_GET_CLASS(cpu);
-    if (cc->memory_rw_debug) {
-        return cc->memory_rw_debug(cpu, addr, buf, len, is_write);
-    }
-    return cpu_memory_rw_debug(cpu, addr, buf, len, is_write);
-}
-
 typedef struct GDBRegisterState {
     int base_reg;
     int num_regs;
@@ -1195,11 +1168,11 @@ static void handle_write_mem(GArray *params, void *user_ctx)
     }
 
     gdb_hextomem(gdbserver_state.mem_buf, get_param(params, 2)->data,
-             get_param(params, 1)->val_ull);
-    if (target_memory_rw_debug(gdbserver_state.g_cpu,
-                               get_param(params, 0)->val_ull,
-                               gdbserver_state.mem_buf->data,
-                               gdbserver_state.mem_buf->len, true)) {
+                 get_param(params, 1)->val_ull);
+    if (gdb_target_memory_rw_debug(gdbserver_state.g_cpu,
+                                   get_param(params, 0)->val_ull,
+                                   gdbserver_state.mem_buf->data,
+                                   gdbserver_state.mem_buf->len, true)) {
         gdb_put_packet("E14");
         return;
     }
@@ -1223,10 +1196,10 @@ static void handle_read_mem(GArray *params, void *user_ctx)
     g_byte_array_set_size(gdbserver_state.mem_buf,
                           get_param(params, 1)->val_ull);
 
-    if (target_memory_rw_debug(gdbserver_state.g_cpu,
-                               get_param(params, 0)->val_ull,
-                               gdbserver_state.mem_buf->data,
-                               gdbserver_state.mem_buf->len, false)) {
+    if (gdb_target_memory_rw_debug(gdbserver_state.g_cpu,
+                                   get_param(params, 0)->val_ull,
+                                   gdbserver_state.mem_buf->data,
+                                   gdbserver_state.mem_buf->len, false)) {
         gdb_put_packet("E14");
         return;
     }
@@ -1676,30 +1649,6 @@ static void handle_query_qemu_supported(GArray *params, void *user_ctx)
     gdb_put_strbuf();
 }
 
-#ifndef CONFIG_USER_ONLY
-static void handle_query_qemu_phy_mem_mode(GArray *params,
-                                           void *user_ctx)
-{
-    g_string_printf(gdbserver_state.str_buf, "%d", phy_memory_mode);
-    gdb_put_strbuf();
-}
-
-static void handle_set_qemu_phy_mem_mode(GArray *params, void *user_ctx)
-{
-    if (!params->len) {
-        gdb_put_packet("E22");
-        return;
-    }
-
-    if (!get_param(params, 0)->val_ul) {
-        phy_memory_mode = 0;
-    } else {
-        phy_memory_mode = 1;
-    }
-    gdb_put_packet("OK");
-}
-#endif
-
 static const GdbCmdParseEntry gdb_gen_query_set_common_table[] = {
     /* Order is important if has same prefix */
     {
@@ -1790,7 +1739,7 @@ static const GdbCmdParseEntry gdb_gen_query_table[] = {
     },
 #ifndef CONFIG_USER_ONLY
     {
-        .handler = handle_query_qemu_phy_mem_mode,
+        .handler = gdb_handle_query_qemu_phy_mem_mode,
         .cmd = "qemu.PhyMemMode",
     },
 #endif
@@ -1806,7 +1755,7 @@ static const GdbCmdParseEntry gdb_gen_set_table[] = {
     },
 #ifndef CONFIG_USER_ONLY
     {
-        .handler = handle_set_qemu_phy_mem_mode,
+        .handler = gdb_handle_set_qemu_phy_mem_mode,
         .cmd = "qemu.PhyMemMode:",
         .cmd_startswith = 1,
         .schema = "l0"
diff --git a/gdbstub/softmmu.c b/gdbstub/softmmu.c
index 7c180b779a..ab2d182654 100644
--- a/gdbstub/softmmu.c
+++ b/gdbstub/softmmu.c
@@ -413,9 +413,60 @@ void gdb_exit(int code)
     qemu_chr_fe_deinit(&gdbserver_system_state.chr, true);
 }
 
+/*
+ * Memory access
+ */
+static int phy_memory_mode;
+
+int gdb_target_memory_rw_debug(CPUState *cpu, hwaddr addr,
+                               uint8_t *buf, int len, bool is_write)
+{
+    CPUClass *cc;
+
+    if (phy_memory_mode) {
+        if (is_write) {
+            cpu_physical_memory_write(addr, buf, len);
+        } else {
+            cpu_physical_memory_read(addr, buf, len);
+        }
+        return 0;
+    }
+
+    cc = CPU_GET_CLASS(cpu);
+    if (cc->memory_rw_debug) {
+        return cc->memory_rw_debug(cpu, addr, buf, len, is_write);
+    }
+
+    return cpu_memory_rw_debug(cpu, addr, buf, len, is_write);
+}
+
+
 /*
  * Softmmu specific command helpers
  */
+
+void gdb_handle_query_qemu_phy_mem_mode(GArray *params,
+                                        void *user_ctx)
+{
+    g_string_printf(gdbserver_state.str_buf, "%d", phy_memory_mode);
+    gdb_put_strbuf();
+}
+
+void gdb_handle_set_qemu_phy_mem_mode(GArray *params, void *user_ctx)
+{
+    if (!params->len) {
+        gdb_put_packet("E22");
+        return;
+    }
+
+    if (!get_param(params, 0)->val_ul) {
+        phy_memory_mode = 0;
+    } else {
+        phy_memory_mode = 1;
+    }
+    gdb_put_packet("OK");
+}
+
 void gdb_handle_query_rcmd(GArray *params, void *user_ctx)
 {
     const guint8 zero = 0;
diff --git a/gdbstub/user.c b/gdbstub/user.c
index c0fd83b373..92663d971c 100644
--- a/gdbstub/user.c
+++ b/gdbstub/user.c
@@ -378,6 +378,21 @@ int gdb_continue_partial(char *newstates)
     return res;
 }
 
+/*
+ * Memory access helpers
+ */
+int gdb_target_memory_rw_debug(CPUState *cpu, hwaddr addr,
+                               uint8_t *buf, int len, bool is_write)
+{
+    CPUClass *cc;
+
+    cc = CPU_GET_CLASS(cpu);
+    if (cc->memory_rw_debug) {
+        return cc->memory_rw_debug(cpu, addr, buf, len, is_write);
+    }
+    return cpu_memory_rw_debug(cpu, addr, buf, len, is_write);
+}
+
 /*
  * Break/Watch point helpers
  */
-- 
2.39.2

