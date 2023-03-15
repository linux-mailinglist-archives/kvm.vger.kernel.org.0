Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53FAB6BBB27
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbjCORoE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbjCORnx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:43:53 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649505B5DF
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:43:47 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id j2so18045207wrh.9
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678902225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UVMGZ9W+Y+8un4w4HSts32m5VZ1Mq2mPxSxu1YHDmSY=;
        b=X/6TnPJT6tqTp8EMSaOU8VaZjDmCUXTULuB0vNEzfzgPxpnVgqWPTa6PXxP3yGbYx4
         Vc7nVRjfam/KU+VrTGF/gzOqSPOYnvq/AhcN2KyGjMktpgXD8da2wHwYpuKSavipbSoV
         S2ie8EDVfHIhao5VhCIflW2KM5UNrnSpdMJ7W+mej+yVQcOS7le/MwL6Fzs89gCVfrNL
         82LzZVGb67x7RwufXHGwizCn8VXBa6F5RdqRD3N6t4OtWZ3VDChYx2WMlk/kza4ooRHV
         vPz6ZGN9U8vdj+uAFLVoggn2+wKvFxFicMJOMtUhXlmvIfqMvHecMKxry0QaN2lNqoXl
         uwfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678902225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UVMGZ9W+Y+8un4w4HSts32m5VZ1Mq2mPxSxu1YHDmSY=;
        b=wdhMB5NBlBfrnc7OfPkSoeKNVCUWacXzEKUTSxiZXhArTGTKM3quBxrrQUgmCfr2+W
         6UwR0E1TtqoqPbB4hhPjlPGjVerSdf4uuC2JNSHnOayVL+wb8DD/YCNCp02je0WeyG/R
         4T2Qqhqqvrk+jyn6ev4atL3UnveDqFnBFq6NB7r/oXEgcwuAwPxT1myCcg1gbKd+Ekzn
         HB0mj3+YN11ljlQiZ4GDz2ilEZuco1jipEPYK4zh0o3fWfPVsg8z34Hd+qXuRz31XFqv
         LT1tbZNmEfqCcXPwRWW7/Ey5U81/kU5D/1ndtxEnkEPQzQ2fYhkydbPC5s9DfuvL+MFf
         4pLQ==
X-Gm-Message-State: AO0yUKVCfsAD7KbOEB3LSwP4PYRGLr32xxrJvQGkfVvBHVzuCL+gzPX5
        U24r7DwTNdpeHNd8kBxBGWup/A==
X-Google-Smtp-Source: AK7set+wMJs0I78AplJYwBwvoIo2BY5fZYSJFjnxECQvSxVToY0v82YBBubDO5mNzgeMF3+b4+92IA==
X-Received: by 2002:adf:ed04:0:b0:2cf:f061:4910 with SMTP id a4-20020adfed04000000b002cff0614910mr2554914wro.42.1678902225762;
        Wed, 15 Mar 2023 10:43:45 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id n4-20020a5d6b84000000b002cfe685bfd6sm5115143wrx.108.2023.03.15.10.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 10:43:45 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 8D4BF1FFC9;
        Wed, 15 Mar 2023 17:43:43 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Akihiko Odaki <akihiko.odaki@gmail.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        qemu-riscv@nongnu.org, Riku Voipio <riku.voipio@iki.fi>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Thomas Huth <thuth@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Hao Wu <wuhaotsh@google.com>, Cleber Rosa <crosa@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Jan Kiszka <jan.kiszka@web.de>,
        Aurelien Jarno <aurelien@aurel32.net>, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Alexandre Iooss <erdnaxe@crans.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>, qemu-ppc@nongnu.org,
        Juan Quintela <quintela@redhat.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Darren Kenny <darren.kenny@oracle.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Stafford Horne <shorne@gmail.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Thomas Huth <huth@tuxfamily.org>,
        Vijai Kumar K <vijai@behindbytes.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Song Gao <gaosong@loongson.cn>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Niek Linnenbank <nieklinnenbank@gmail.com>,
        Greg Kurz <groug@kaod.org>, Laurent Vivier <laurent@vivier.eu>,
        Qiuhao Li <Qiuhao.Li@outlook.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        Mahmoud Mandour <ma.mandourr@gmail.com>,
        Alexander Bulekov <alxndr@bu.edu>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, qemu-block@nongnu.org,
        Yanan Wang <wangyanan55@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>, qemu-s390x@nongnu.org,
        Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
        Bandan Das <bsd@redhat.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Tyrone Ting <kfting@nuvoton.com>,
        Kevin Wolf <kwolf@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Beraldo Leal <bleal@redhat.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Paul Durrant <paul@xen.org>, Bin Meng <bin.meng@windriver.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Hanna Reitz <hreitz@redhat.com>, Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v2 17/32] include/qemu/plugin: Inline qemu_plugin_disable_mem_helpers
Date:   Wed, 15 Mar 2023 17:43:16 +0000
Message-Id: <20230315174331.2959-18-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315174331.2959-1-alex.bennee@linaro.org>
References: <20230315174331.2959-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Richard Henderson <richard.henderson@linaro.org>

Now that we've broken the include loop with cpu.h,
we can bring this inline.

Signed-off-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Message-Id: <20230310195252.210956-8-richard.henderson@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/qemu/plugin.h |  6 +++++-
 plugins/core.c        | 11 -----------
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/include/qemu/plugin.h b/include/qemu/plugin.h
index 6bf4bce188..bc0781cab8 100644
--- a/include/qemu/plugin.h
+++ b/include/qemu/plugin.h
@@ -14,6 +14,7 @@
 #include "qemu/option.h"
 #include "qemu/plugin-event.h"
 #include "exec/memopidx.h"
+#include "hw/core/cpu.h"
 
 /*
  * Option parsing/processing.
@@ -204,7 +205,10 @@ void qemu_plugin_atexit_cb(void);
 
 void qemu_plugin_add_dyn_cb_arr(GArray *arr);
 
-void qemu_plugin_disable_mem_helpers(CPUState *cpu);
+static inline void qemu_plugin_disable_mem_helpers(CPUState *cpu)
+{
+    cpu->plugin_mem_cbs = NULL;
+}
 
 /**
  * qemu_plugin_user_exit(): clean-up callbacks before calling exit callbacks
diff --git a/plugins/core.c b/plugins/core.c
index 04632886b9..9912f2cfdb 100644
--- a/plugins/core.c
+++ b/plugins/core.c
@@ -553,17 +553,6 @@ void qemu_plugin_user_postfork(bool is_child)
     }
 }
 
-
-/*
- * Call this function after longjmp'ing to the main loop. It's possible that the
- * last instruction of a TB might have used helpers, and therefore the
- * "disable" instruction will never execute because it ended up as dead code.
- */
-void qemu_plugin_disable_mem_helpers(CPUState *cpu)
-{
-    cpu->plugin_mem_cbs = NULL;
-}
-
 static bool plugin_dyn_cb_arr_cmp(const void *ap, const void *bp)
 {
     return ap == bp;
-- 
2.39.2

