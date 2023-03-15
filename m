Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5145A6BBB26
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjCORoB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbjCORnx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:43:53 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6564685A45
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:43:47 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id m18-20020a05600c3b1200b003ed2a3d635eso1817518wms.4
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678902226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tRC8fgG8iCpSOIjOKosXJGOasPWQrMaIPqKcrWrmcng=;
        b=VQbrP+MTqADomaAy83LQX3Sb8C/F2JGpTQDwlL7fwIeSng+kOD3KCMgWkKwyr1SetB
         RzNji2xn+BRaa9A1+47nZlrZNoq8A4lph97gVOleHHn5L5yNM/8DA6aE1xRH0vXZzQ6w
         YGs9mb4pBs+XPv8996ljoHmxW1bzIEsUyqX1N1Dq+Q3ZMcsku4oeSHUP0H8fr3iaUh1d
         +jOW5R1ACfT4GPaLhNR8Hds5JdNPPDK61e5sL5cp5fpAO4pAkQ1MfkvuK1aBBIT+MOUT
         5K8emUAH8v9z4AMYV544ZQchOuJqkcH/Ai2PokRZDFw1BTo11a2Y68uIIfIHE8F/Ndv0
         NXmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678902226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tRC8fgG8iCpSOIjOKosXJGOasPWQrMaIPqKcrWrmcng=;
        b=VAEK9hAjgsKpPoxMSaOouCwFI4htdLPuO46LG/7OXTdytek6mJ5dSP8LtcufFtZMW3
         U+pYciQTUO62m1qITwfS1GSLgP6YkXYc9+EE+IZoamKgJ03cZfCzrwvbjfBv4VTpE44o
         KFf7XhkJnyTeWwfOJHwG3wG075sZub0TC2CF8AHuvBPpC1avukDWw90AbCjClKkNNYQZ
         RG+ubaul25cwOdv84Zwo8CqYlrnmL4jSXmCkiIJLAhUkKZ8ETZnnQY6tLn26H78JUzr0
         V7XFQXWhcwN6UA/YxrHashX3tgiMJc6T51V7Mc3lSRuDA9tFcWVs63eZHju/n7DAyPXx
         +iKg==
X-Gm-Message-State: AO0yUKVHlDj7+FquLwQZ57MVfd9kwgAa94xmj8vSVZvMaEWXq5Lh+BFl
        r+pg7WL1BUv8Qc62TEskAz38/w==
X-Google-Smtp-Source: AK7set/meUh/5KgFTBvT2GG7lQLaA45vQRG5bfumoEJyiqV4RwJt6ZIG1omC0BVQ9oeoqIR4Fi2g4Q==
X-Received: by 2002:a05:600c:354e:b0:3ed:377b:19cc with SMTP id i14-20020a05600c354e00b003ed377b19ccmr1767245wmq.0.1678902225812;
        Wed, 15 Mar 2023 10:43:45 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id n7-20020a05600c294700b003ebf9e36cd6sm2539979wmd.26.2023.03.15.10.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 10:43:45 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 6D4C51FFC8;
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
Subject: [PATCH v2 16/32] include/qemu: Split out plugin-event.h
Date:   Wed, 15 Mar 2023 17:43:15 +0000
Message-Id: <20230315174331.2959-17-alex.bennee@linaro.org>
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

The usage in hw/core/cpu.h only requires QEMU_PLUGIN_EV_MAX.

Signed-off-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Message-Id: <20230310195252.210956-7-richard.henderson@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/hw/core/cpu.h       |  2 +-
 include/qemu/plugin-event.h | 26 ++++++++++++++++++++++++++
 include/qemu/plugin.h       | 17 +----------------
 3 files changed, 28 insertions(+), 17 deletions(-)
 create mode 100644 include/qemu/plugin-event.h

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 75689bff02..821e937020 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -30,7 +30,7 @@
 #include "qemu/rcu_queue.h"
 #include "qemu/queue.h"
 #include "qemu/thread.h"
-#include "qemu/plugin.h"
+#include "qemu/plugin-event.h"
 #include "qom/object.h"
 
 typedef int (*WriteCoreDumpFunction)(const void *buf, size_t size,
diff --git a/include/qemu/plugin-event.h b/include/qemu/plugin-event.h
new file mode 100644
index 0000000000..7056d8427b
--- /dev/null
+++ b/include/qemu/plugin-event.h
@@ -0,0 +1,26 @@
+/*
+ * Copyright (C) 2017, Emilio G. Cota <cota@braap.org>
+ *
+ * License: GNU GPL, version 2 or later.
+ *   See the COPYING file in the top-level directory.
+ */
+#ifndef QEMU_PLUGIN_EVENT_H
+#define QEMU_PLUGIN_EVENT_H
+
+/*
+ * Events that plugins can subscribe to.
+ */
+enum qemu_plugin_event {
+    QEMU_PLUGIN_EV_VCPU_INIT,
+    QEMU_PLUGIN_EV_VCPU_EXIT,
+    QEMU_PLUGIN_EV_VCPU_TB_TRANS,
+    QEMU_PLUGIN_EV_VCPU_IDLE,
+    QEMU_PLUGIN_EV_VCPU_RESUME,
+    QEMU_PLUGIN_EV_VCPU_SYSCALL,
+    QEMU_PLUGIN_EV_VCPU_SYSCALL_RET,
+    QEMU_PLUGIN_EV_FLUSH,
+    QEMU_PLUGIN_EV_ATEXIT,
+    QEMU_PLUGIN_EV_MAX, /* total number of plugin events we support */
+};
+
+#endif /* QEMU_PLUGIN_EVENT_H */
diff --git a/include/qemu/plugin.h b/include/qemu/plugin.h
index e0ebedef84..6bf4bce188 100644
--- a/include/qemu/plugin.h
+++ b/include/qemu/plugin.h
@@ -12,24 +12,9 @@
 #include "qemu/error-report.h"
 #include "qemu/queue.h"
 #include "qemu/option.h"
+#include "qemu/plugin-event.h"
 #include "exec/memopidx.h"
 
-/*
- * Events that plugins can subscribe to.
- */
-enum qemu_plugin_event {
-    QEMU_PLUGIN_EV_VCPU_INIT,
-    QEMU_PLUGIN_EV_VCPU_EXIT,
-    QEMU_PLUGIN_EV_VCPU_TB_TRANS,
-    QEMU_PLUGIN_EV_VCPU_IDLE,
-    QEMU_PLUGIN_EV_VCPU_RESUME,
-    QEMU_PLUGIN_EV_VCPU_SYSCALL,
-    QEMU_PLUGIN_EV_VCPU_SYSCALL_RET,
-    QEMU_PLUGIN_EV_FLUSH,
-    QEMU_PLUGIN_EV_ATEXIT,
-    QEMU_PLUGIN_EV_MAX, /* total number of plugin events we support */
-};
-
 /*
  * Option parsing/processing.
  * Note that we can load an arbitrary number of plugins.
-- 
2.39.2

