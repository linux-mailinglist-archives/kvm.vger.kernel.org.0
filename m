Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16E46A8966
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 20:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbjCBTOr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 14:14:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjCBTO2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 14:14:28 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07942449A
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 11:14:26 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id l1so116770wry.12
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 11:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kebJRJ/Zd0hMxCtlzPa2wrDMn74tVWfVULcszCFYnrs=;
        b=RHVfSsXSeOsHZgpUTWIlzcqkeEi3+plFRd6crMtuBIX/nPCnvRLS3NA5NERG9MQxDC
         kLTG8utGQ9QSoL2omBP8n8BU69T6lQnPcQAHEn4BfU0784JW5LZ1h3B/dirN0aG0LOUn
         ZGuJyeqfT+u4C5dfFRXEEKN0qyFtD0m/K16wJcdae9PY/dxrQVHb/bAtbVMCjXBYzZ6a
         2f3Lhn2hfn6G34LFcDwxVJRnPPNxvjCjk3iEtZ7Rqa49kWFOzBjrZgCZQN1SA7vNIxE2
         gY29OoR0T8jS/mYtLH59BH3VlNYg8yS9ILRxnl1jUabfs29WHqXloX8fEb9uGXXNKavg
         6ARQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kebJRJ/Zd0hMxCtlzPa2wrDMn74tVWfVULcszCFYnrs=;
        b=f0XS5tgvH9STTX2DZuTCbb09v4MBZcu3JKmXDZ6iJHFl3RBTNJEdf+bUURWCFa93BC
         1PWeqzmZ58P3U8dzjvTdtit9b+NnBKZyxbjEMH5Pd/Nlehc9HSm2REHaqWxXIiZl0q+W
         gGyHiNFAsMkylmnmxqcIUnp7ygWPv9VigsUYbuceg+BSk/GtTEZ7Nr4DEaaIa14gsIUo
         eKNohcmHbRsWFZY1aGwKKu7XV4KK8M92se5sZun6CRmehm4fAEV84nu7LOzsJGTcKQzL
         GjriOHkAvnuZQEvPTHSMXXBsRSgNsZVnKXGy5SytzuxshHJKo0AtnM5BMYlRcB9OzzUr
         r8lA==
X-Gm-Message-State: AO0yUKVfg6S2zLdg2qGkR83lfd7oy/OmuFLrhNZtocXfws51m5fhf31p
        kQhx9LNGPMU4PFh1BiF7hLAuQw==
X-Google-Smtp-Source: AK7set+D/4mTEhIX+7Jk/ThTEoGUCRN5R/1wUY3+La0dBKWoMtb+xw5AxRlJ8TNMrqyA30xvhuE2qg==
X-Received: by 2002:a05:6000:10cc:b0:2c7:e60:abe8 with SMTP id b12-20020a05600010cc00b002c70e60abe8mr2230369wrx.9.1677784465139;
        Thu, 02 Mar 2023 11:14:25 -0800 (PST)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id b5-20020a05600c150500b003e91b9a92c9sm384899wmg.24.2023.03.02.11.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 11:14:24 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 234561FFC7;
        Thu,  2 Mar 2023 19:08:49 +0000 (GMT)
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
Subject: [PATCH v4 19/26] gdbstub: don't use target_ulong while handling registers
Date:   Thu,  2 Mar 2023 19:08:39 +0000
Message-Id: <20230302190846.2593720-20-alex.bennee@linaro.org>
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

This is a hangover from the original code. addr is misleading as it is
only really a register id. While len will never exceed
MAX_PACKET_LENGTH I've used size_t as that is what strlen returns.

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

---
v3
  - fix commit message
  - use unsigned for regid
v4
  - revert unsigned change
---
 gdbstub/gdbstub.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/gdbstub/gdbstub.c b/gdbstub/gdbstub.c
index b8aead03bd..f1504af44f 100644
--- a/gdbstub/gdbstub.c
+++ b/gdbstub/gdbstub.c
@@ -1193,7 +1193,8 @@ static void handle_read_mem(GArray *params, void *user_ctx)
 
 static void handle_write_all_regs(GArray *params, void *user_ctx)
 {
-    target_ulong addr, len;
+    int reg_id;
+    size_t len;
     uint8_t *registers;
     int reg_size;
 
@@ -1205,9 +1206,10 @@ static void handle_write_all_regs(GArray *params, void *user_ctx)
     len = strlen(get_param(params, 0)->data) / 2;
     gdb_hextomem(gdbserver_state.mem_buf, get_param(params, 0)->data, len);
     registers = gdbserver_state.mem_buf->data;
-    for (addr = 0; addr < gdbserver_state.g_cpu->gdb_num_g_regs && len > 0;
-         addr++) {
-        reg_size = gdb_write_register(gdbserver_state.g_cpu, registers, addr);
+    for (reg_id = 0;
+         reg_id < gdbserver_state.g_cpu->gdb_num_g_regs && len > 0;
+         reg_id++) {
+        reg_size = gdb_write_register(gdbserver_state.g_cpu, registers, reg_id);
         len -= reg_size;
         registers += reg_size;
     }
@@ -1216,15 +1218,16 @@ static void handle_write_all_regs(GArray *params, void *user_ctx)
 
 static void handle_read_all_regs(GArray *params, void *user_ctx)
 {
-    target_ulong addr, len;
+    int reg_id;
+    size_t len;
 
     cpu_synchronize_state(gdbserver_state.g_cpu);
     g_byte_array_set_size(gdbserver_state.mem_buf, 0);
     len = 0;
-    for (addr = 0; addr < gdbserver_state.g_cpu->gdb_num_g_regs; addr++) {
+    for (reg_id = 0; reg_id < gdbserver_state.g_cpu->gdb_num_g_regs; reg_id++) {
         len += gdb_read_register(gdbserver_state.g_cpu,
                                  gdbserver_state.mem_buf,
-                                 addr);
+                                 reg_id);
     }
     g_assert(len == gdbserver_state.mem_buf->len);
 
-- 
2.39.2

