Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4556364FB47
	for <lists+kvm@lfdr.de>; Sat, 17 Dec 2022 18:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiLQRbJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Dec 2022 12:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiLQRaw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Dec 2022 12:30:52 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E7C1092
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 09:30:45 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id n20so13069768ejh.0
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 09:30:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8puYA5pXfRf+1sAx/YhGhz4X/7vHxWP4eF1HMLfQ/pg=;
        b=exXqxUszEBEoTGnuE1nd4LT88IeFXPT86bDiG9ZqD1yNPkFGGVPkoDU75QBcVVyYva
         S0Fo7LY7cQJtBqByYf+yVCTe35Bx4Uyo79EoyC+4iD54P1038ef8JO7Rs267HNejhhXP
         /czn1U0cLol3HJYLgXe6NdFdRMEy5Rz9XAGmFu3tLHI78M6yIiAIn4VLpsvueywVNJNW
         2si+QCNBzZTrISaQ9uIootdxT9bfJLCtHFcstVSIECNmoChLBA4ww6kIzCz+24N9pvb4
         sMhl7wvLsGQr6Ls8ZvcDgcyNot3t5wq6T/E+qGygVYYTyCG/QQqjvxi6YGlzdmvt28Gr
         6iVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8puYA5pXfRf+1sAx/YhGhz4X/7vHxWP4eF1HMLfQ/pg=;
        b=rJOFz9XjUYmbxzO096bynNtqM0rMRs5uJd8zVzV4zpB5Sy8HM4lQnMNfOIdOTmEuZD
         OSZRC7Gwqas1pwivE3Y/v/i0reeO0bCZDZTUhsl3X1xWlx13v8IFkQfo/+7nP2hbZgRd
         ST5Knxg8rXyWYRhixr5MyvsdWDQAyufemnZW349puZSQXfUSgNC4+wt5M3mWPg82maA3
         UnVNd5gtSxII+YKJFeF88/QTru7tJ8LmLBjONKGiLGO5UP2idkWgqnPPzkyCfWnFTFuC
         ZrHhrNiha59e+lVUpS1cIKNqHN6yjmF5sN+hZW44/r5t5ZLapw5U1gP3fiWU1upnUbGr
         RaJA==
X-Gm-Message-State: ANoB5plTkI29ZyJ45/LeU3dFnRkqIpAFvyshf3Pw0cTzWXKYxn1FHTVL
        fTw1sAVKKUPgPsX2z95XMsDB+Q==
X-Google-Smtp-Source: AA0mqf7qOSUm9byNo3AcaD4j13UwfpNbVjXC2y+rsu/sw5WEXY/TNHXAP/pWodGj4/dOGhI//EoEdg==
X-Received: by 2002:a17:907:1719:b0:7c0:f9ef:23a2 with SMTP id le25-20020a170907171900b007c0f9ef23a2mr51716123ejc.30.1671298243563;
        Sat, 17 Dec 2022 09:30:43 -0800 (PST)
Received: from localhost.localdomain ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id a2-20020a170906274200b007bb86679a32sm2198820ejd.217.2022.12.17.09.30.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 17 Dec 2022 09:30:43 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Max Filippov <jcmvbkbc@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Bin Meng <bin.meng@windriver.com>, kvm@vger.kernel.org,
        qemu-ppc@nongnu.org, Greg Kurz <groug@kaod.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Bernhard Beschow <shentey@gmail.com>, qemu-riscv@nongnu.org,
        Song Gao <gaosong@loongson.cn>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Laurent Vivier <laurent@vivier.eu>,
        Alistair Francis <alistair.francis@wdc.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 9/9] target/xtensa/cpu: Include missing "memory.h" header
Date:   Sat, 17 Dec 2022 18:29:07 +0100
Message-Id: <20221217172907.8364-10-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221217172907.8364-1-philmd@linaro.org>
References: <20221217172907.8364-1-philmd@linaro.org>
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

Under system emulation, xtensa_cpu_initfn() calls
memory_region_init_io(), itself declared in "exec/memory.h".

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/xtensa/cpu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/target/xtensa/cpu.c b/target/xtensa/cpu.c
index 09923301c4..879710f8d1 100644
--- a/target/xtensa/cpu.c
+++ b/target/xtensa/cpu.c
@@ -35,6 +35,9 @@
 #include "qemu/module.h"
 #include "migration/vmstate.h"
 #include "hw/qdev-clock.h"
+#ifndef CONFIG_USER_ONLY
+#include "exec/memory.h"
+#endif
 
 
 static void xtensa_cpu_set_pc(CPUState *cs, vaddr value)
-- 
2.38.1

