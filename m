Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3BFE64F38D
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 22:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiLPVze (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 16:55:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiLPVzc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 16:55:32 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7A35F405
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 13:55:31 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id gh17so9233798ejb.6
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 13:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xssmHoWXJ6SK5gCkViO69Q35oM9uqfLm45e7wmSAEiQ=;
        b=OpENGvV9zNK1kW2Y7ktPT/UEMrwhPfBX9OCoT6BvQzow6Z8RdawcCPkv1jvvW5UZNN
         BkJLBj2jT5SzemHxcvMn5J0HBpDDJw/3EstPP2YSFB65vnD729EA3ms0Ldpw13TdUYSq
         ApjgAWsRedsCev6ZI3O3XLVMI029rL/+Sn3bY83RmMuBsNMCkT0xTE8tAVBSwR6dbjd0
         H+8RBAE1UCkHKwZGjrlsH1rgpGDJIpwefc/J+tYBcuHKjOgTFE+MO+69ye9fcnaTsQH7
         DJsocgUOkRXsyoILarEzNMbhawurjJ9oJZOiv3jTOU/igoYaYIYIWwj5kTMMXS1kMDM5
         D5Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xssmHoWXJ6SK5gCkViO69Q35oM9uqfLm45e7wmSAEiQ=;
        b=ZIbiJEEi5yHyaCC7rDQM2gAjYiKwgHlQiSUXuqH//DN88Pl/Yfjff88n50KQ8XH8tN
         91hbwplBRpE7ljtASw5pEOV40rv0H1dADCf0lkPvcOIRDdCy7E7TAbI8hOYrj7m+CjDZ
         76vpWd45Dt80jaOMeTPLqZbV4FntcwhySWL7aGHmztKmniv//HaCdw/cLzgliGu4+cHQ
         hfqPDv4lqTP6UeK4Gjptc/30PQq0dNt8aUbcNyPwYJQNEPEAvoxUq602kX+HZZLxJN4d
         5ooAnLkrJGotIAbXyz7rgMGID7oApYK94aEKTFtjes2Uo0oDV7eQtkdiTSmTAp2CJ21D
         ZVlg==
X-Gm-Message-State: ANoB5pnM6VQmd4Utu9R3pjopy4FX2pNoHvm8iv/+V4XulubiqzEbEo+D
        DG/Grbbgy1PhioEcQdClBiUt3A==
X-Google-Smtp-Source: AA0mqf6xT41BcyZh02Z2thOeHZOU9KTDZSfsSUSOjRb6fHLKc0deeuEgfS6otC9br60FYAiYkf59nQ==
X-Received: by 2002:a17:906:4c4b:b0:7c1:1ada:5e1e with SMTP id d11-20020a1709064c4b00b007c11ada5e1emr28189213ejw.26.1671227729771;
        Fri, 16 Dec 2022 13:55:29 -0800 (PST)
Received: from localhost.localdomain ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id r20-20020a1709064d1400b007c0cd272a06sm1276141eju.225.2022.12.16.13.55.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 16 Dec 2022 13:55:29 -0800 (PST)
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
Subject: [PATCH v3 1/5] dump: Include missing "cpu.h" header for tswap32/tswap64() declarations
Date:   Fri, 16 Dec 2022 22:55:15 +0100
Message-Id: <20221216215519.5522-2-philmd@linaro.org>
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

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 dump/dump.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/dump/dump.c b/dump/dump.c
index 279b07f09b..c62dc94213 100644
--- a/dump/dump.c
+++ b/dump/dump.c
@@ -29,6 +29,7 @@
 #include "qemu/main-loop.h"
 #include "hw/misc/vmcoreinfo.h"
 #include "migration/blocker.h"
+#include "cpu.h"
 
 #ifdef TARGET_X86_64
 #include "win_dump.h"
-- 
2.38.1

