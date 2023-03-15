Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7786BBB5D
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbjCORt4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbjCORtk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:49:40 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519E836FED
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:49:26 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id r29so10051047wra.13
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678902564;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0N/4PabBLqV/G25pJQsAZWNm7Ckm3Whh6Khx55ga6lY=;
        b=RDj1iHq8LoIMKN4MX+P7q9gwxajV2pOtRK3j6P8PFfd9B6NNnMSb9erc0MlIK5wQz6
         5fSTJQxdrk7jBmE0MQkxF+OazHIrjNnjwgzTw4mak1SdsouTcuziDx6x0CyeZBYJIM68
         2TMtV2y9zjZLQNMtVG3RvOfYJ/LGt7VaqRlMNbzfKmNSSNHgijPlF2bPv87hcMKdilgZ
         dLG+nKf8efYN9UTxcIGNJscM+FdZu0MUxoitLrJETBAJKEtZs1H1Y8JeMJnpDCy7zlmU
         1CX+Sy6U6HQgWqtcsvhHNj1W4hhfTgrtOuiQ4PzxxeV+QPYl+s6DvpI8uTbdP1NGDxw+
         HWqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678902564;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0N/4PabBLqV/G25pJQsAZWNm7Ckm3Whh6Khx55ga6lY=;
        b=x5ggktFCR4HdbA0cEb4vLED7wdXG18jfpcb6KJVPLPsf7t+8/pzEL++a/oHTLNgnFm
         EgZap7ejeqBNyvMbAMV+QsjGkAAYp3ZfkGhYIbBE9W7rAsXpezsDupkbVzjmx+GbZxKn
         AKiZ+uddAXQE8cP0SKTCKFedBxPpsC/z3Jo1MG2j5k0h8bXJCeLUK2hVRQeJVHbNlSOU
         zkoZn/lWQHe/XAeAw22IzHq4XxRnQ4351AzeogOF+a+26kcNdwPd4Df6TFXbidUiBXhm
         BUNKFDvQVIxn1GpcJPLU/alH8NWV6dfycizB/qHZ/thc4s1OJ7fRNTEoGMB2bosmCyNb
         qSnw==
X-Gm-Message-State: AO0yUKUuWW7Qn+wM9WZ5j0F4MYC0TAApgW89it04CkR/ggL7hBUFT8Y7
        NGll6jJx8s4c2S9aAIHIvhpKLw==
X-Google-Smtp-Source: AK7set/LRMnfaf8kbXGeWUfIr1WwkTxt3CTp4bsA7aLqlcW+5JmKeWtMswrYl/l+Dg/rQnFPdy2QmQ==
X-Received: by 2002:a5d:4e10:0:b0:2ce:a835:83d4 with SMTP id p16-20020a5d4e10000000b002cea83583d4mr2806297wrt.27.1678902564822;
        Wed, 15 Mar 2023 10:49:24 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id b10-20020a5d550a000000b002c706c754fesm5084618wrv.32.2023.03.15.10.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 10:49:22 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id B8E621FFC4;
        Wed, 15 Mar 2023 17:43:32 +0000 (GMT)
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
Subject: [PATCH v2 13/32] include/qemu/plugin: Remove QEMU_PLUGIN_ASSERT
Date:   Wed, 15 Mar 2023 17:43:12 +0000
Message-Id: <20230315174331.2959-14-alex.bennee@linaro.org>
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

This macro is no longer used.

Signed-off-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20230310195252.210956-4-richard.henderson@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/qemu/plugin.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/qemu/plugin.h b/include/qemu/plugin.h
index fb338ba576..e0ebedef84 100644
--- a/include/qemu/plugin.h
+++ b/include/qemu/plugin.h
@@ -59,8 +59,6 @@ get_plugin_meminfo_rw(qemu_plugin_meminfo_t i)
 #ifdef CONFIG_PLUGIN
 extern QemuOptsList qemu_plugin_opts;
 
-#define QEMU_PLUGIN_ASSERT(cond) g_assert(cond)
-
 static inline void qemu_plugin_add_opts(void)
 {
     qemu_add_opts(&qemu_plugin_opts);
@@ -252,8 +250,6 @@ void qemu_plugin_user_postfork(bool is_child);
 
 #else /* !CONFIG_PLUGIN */
 
-#define QEMU_PLUGIN_ASSERT(cond)
-
 static inline void qemu_plugin_add_opts(void)
 { }
 
-- 
2.39.2

