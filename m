Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 495EA64FB41
	for <lists+kvm@lfdr.de>; Sat, 17 Dec 2022 18:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiLQRaD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Dec 2022 12:30:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbiLQR37 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Dec 2022 12:29:59 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F23B10FCE
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 09:29:58 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id qk9so12970789ejc.3
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 09:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Je6pglm7Ro/G6/Hw82+zaiN4Czg7YWpLl/0Q2PSll9w=;
        b=GtUaV+75kc/w2Jz9y6r/nJ0UXl5KQ9zRbxRmQxJApuJqSpXejlL04qdNyMDJZAF0Sd
         c7hb2VL3FVp+WZjsMksKpWTI8AtikUc68bY3ruW2CqV3ESSKydsEnZ2b+X2oRE/24DIz
         gGDdPT2WsiklD4zZ8h8pGe5pgiY7Z5/9RAbS4yWntEgX6RDhQ2aP3f6TqZ+rMFkqkOSF
         3ur44FGMR9tQImO0CndosOLQOONsdMZLCETwu92SLfn0xssvLS3NqWGM2nAyYzd6FMUB
         TP2YOxP3+O0lgxLz09QCXkpNxHcmbYOqYaKI08g9NOoXwW5oVWIZ1J3lkiIZ3ZtuBplq
         hAXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Je6pglm7Ro/G6/Hw82+zaiN4Czg7YWpLl/0Q2PSll9w=;
        b=OAJN/x8v/Mt5eukipMDNZQ5LSsIlKj9yt19tNMc+J8YFKNOKWF12FHoFI5wdppqf4T
         OeIozaA8t364flS/smvXyfq0A0mHB+dOtbwaUImi5ew5erU0JI18eCPX+mXCeWVRPJzN
         pgDTyQ1xPEecH82bWTaNu5jZgGripPMS1sw5BGBgl6QE4eoEKVmVSnlhE1RrhhtkTJQr
         cj5krp4GeI48CQG5qbYR4UqPwNbaaD4ZlYwz/tVeL40X3jnhzTqUXgRmNFH7dfEZXb4s
         BKJQGbRD4PQeE6KdvWvaHyBg3ryEqBZWWaPlUe4HjWTGsKA5sUsGBSGPzaXWHKaD42HV
         JIaw==
X-Gm-Message-State: ANoB5pmhnEEkTnpaq9qoxkAxAmyTncqLsHRgpFaSHz7ZqJL/BLJm8cUq
        wnIAJoz6ma9MCwzrDZGQcdoJJw==
X-Google-Smtp-Source: AA0mqf72Pm4NY4wNp46CZqXV4Nvqqb64mTPo5WGko4tfGBRcVj0ixpsUx8E+tmqvXqstRrhMA/coNw==
X-Received: by 2002:a17:906:9f1e:b0:7c0:7d35:e9db with SMTP id fy30-20020a1709069f1e00b007c07d35e9dbmr43794106ejc.15.1671298196789;
        Sat, 17 Dec 2022 09:29:56 -0800 (PST)
Received: from localhost.localdomain ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id t1-20020a170906a10100b007a1d4944d45sm2239662ejy.142.2022.12.17.09.29.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 17 Dec 2022 09:29:56 -0800 (PST)
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
Subject: [PATCH v2 5/9] target/ppc/kvm: Remove unused "sysbus.h" header
Date:   Sat, 17 Dec 2022 18:29:03 +0100
Message-Id: <20221217172907.8364-6-philmd@linaro.org>
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

Nothing requires SysBus declarations here.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/ppc/kvm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 7c25348b7b..78f6fc50cd 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -32,7 +32,6 @@
 #include "sysemu/device_tree.h"
 #include "mmu-hash64.h"
 
-#include "hw/sysbus.h"
 #include "hw/ppc/spapr.h"
 #include "hw/ppc/spapr_cpu_core.h"
 #include "hw/hw.h"
-- 
2.38.1

