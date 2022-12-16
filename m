Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCED64F38E
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 22:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiLPVzt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 16:55:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiLPVzq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 16:55:46 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5EA381
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 13:55:38 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id r26so5428504edc.10
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 13:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nvZo37ZGtVvWlqFUnT7DRRxDMf6Z0v34B1J4o3P2gxo=;
        b=QS0A4bcmsLrLzAvLNYrOY5w8cZdoY1wwxif6xMojgWQOAiFtUT0tyaroPGfboOpQ2M
         9tTkUTUiUIvNuaxXdEl79rqJPjrVybuh5vKsJrfjDWzWk/3saSRlFFqHnJp4MAJrOX8y
         /ORKMsnJ9Xbrv0tjAgP7a65XJR0xgndOa8Hc12o+v4ZHAsJNmSGQKK7pMY9zrikKGhy5
         gMx3W4y4qmn8yUBQJfvGteoFvNMU+DJXU2QDEOefmTnGQfb+v6778f+oNfaGDVbVBkAu
         zRV6hWtnAaMFaCOXfSpnNctLyz2SDDScekUo/i5qbeEyy7GQ0s4N1/3cDFH5OVYtr3FL
         y2Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nvZo37ZGtVvWlqFUnT7DRRxDMf6Z0v34B1J4o3P2gxo=;
        b=XWYYBlfRLZq1MrD2sb46JEwSt8X6OcYffxlSNFvT0FTtqfsMvGflP2xi0ZSDzJeRdh
         o3fd8sKgJunJ9DOGWCc/hOoyYxVduyrLK3eZ9fZWbtU5YMGbgDTLiCNLDv1fIuYqmmR1
         tVCziSS1Aq+YDfxXAel/maUQmkWfFkoCQ8E2xEFR2MXywFqfPmGQVu0K66IHUHwqKAUn
         2rBVF52Kziefp1wzPpbQS6aKtAW+exhckJKf0CSzeuWZOVku+qlob8klthh7LEAJXnzS
         VEZejJHhUIiZ9BxhTM5yqEEusAOZlUm4DRw5pPeublVSMCT1A0XmL3UHsgKrkyr9hv9D
         XPqQ==
X-Gm-Message-State: ANoB5plQvbnTIKxv47JKKdPH2C87egdpivzSozr95uZe34iEOmm+bMNb
        7mRfmwjM+ygc3hteeBsPIFDuZQ==
X-Google-Smtp-Source: AA0mqf5kfpZN4t4L2lET0LgUlbZyIuAzHNhhqhUt6pU5qluuvLw/vvtion/rV3n/7E9moXZb6GvBmA==
X-Received: by 2002:a05:6402:2989:b0:467:4df0:7185 with SMTP id eq9-20020a056402298900b004674df07185mr27588064edb.4.1671227736819;
        Fri, 16 Dec 2022 13:55:36 -0800 (PST)
Received: from localhost.localdomain ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id cq21-20020a056402221500b004678b543163sm1338647edb.0.2022.12.16.13.55.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 16 Dec 2022 13:55:36 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Greg Kurz <groug@kaod.org>, qemu-ppc@nongnu.org,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, Laurent Vivier <laurent@vivier.eu>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Marek Vasut <marex@denx.de>, Bin Meng <bin.meng@windriver.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        qemu-riscv@nongnu.org, kvm@vger.kernel.org,
        Stafford Horne <shorne@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Chris Wulff <crwulff@gmail.com>
Subject: [PATCH v3 2/5] cputlb: Restrict SavedIOTLB to system emulation
Date:   Fri, 16 Dec 2022 22:55:16 +0100
Message-Id: <20221216215519.5522-3-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221216215519.5522-1-philmd@linaro.org>
References: <20221216215519.5522-1-philmd@linaro.org>
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

Commit 2f3a57ee47 ("cputlb: ensure we save the IOTLB data in
case of reset") added the SavedIOTLB structure -- which is
system emulation specific -- in the generic CPUState structure.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/core/cpu.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 8830546121..bc3229ae13 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -222,7 +222,7 @@ struct CPUWatchpoint {
     QTAILQ_ENTRY(CPUWatchpoint) entry;
 };
 
-#ifdef CONFIG_PLUGIN
+#if defined(CONFIG_PLUGIN) && !defined(CONFIG_USER_ONLY)
 /*
  * For plugins we sometime need to save the resolved iotlb data before
  * the memory regions get moved around  by io_writex.
@@ -406,9 +406,11 @@ struct CPUState {
 
 #ifdef CONFIG_PLUGIN
     GArray *plugin_mem_cbs;
+#if !defined(CONFIG_USER_ONLY)
     /* saved iotlb data from io_writex */
     SavedIOTLB saved_iotlb;
-#endif
+#endif /* !CONFIG_USER_ONLY */
+#endif /* CONFIG_PLUGIN */
 
     /* TODO Move common fields from CPUArchState here. */
     int cpu_index;
-- 
2.38.1

