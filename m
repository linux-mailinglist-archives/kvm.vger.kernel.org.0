Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1734264FB3E
	for <lists+kvm@lfdr.de>; Sat, 17 Dec 2022 18:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiLQR3g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Dec 2022 12:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiLQR3e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Dec 2022 12:29:34 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8EFF10B6F
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 09:29:32 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id m18so12950222eji.5
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 09:29:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GdJpVnm+gFNOeX+qvDUbYIefgKH38zq9W4n0ljJdfLo=;
        b=fXMKAdasNRudqC/+wHt0wHLOntPFsm3uaGXpR+hb5haWkI0s1NTuJgtD+gjno9cqOK
         U5jwk75xoFPZn9s0tPD9Phfjp52CumJG3TNzkT+dqaV/XbNE/Palzd/unmtaejUNzO7F
         dMbc4XogpIYjZBzkxmFGN0+0NAmn/IeuZD2Y0FKZ5VRIxFwqya4P+v3h/buVEqy2LSdl
         iji0KyUrDtwEVwHRnOshPTxeHPqUttht3rK3uLMMNk8nETAiw3fzcNvUM04kEx9HMo1X
         fv9EpFCSP4ULOfRq1UqrGqAP5zmT707TPUQizQKL+EHznCrIw1sFG16HYboyGFAQMWzP
         4ONw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GdJpVnm+gFNOeX+qvDUbYIefgKH38zq9W4n0ljJdfLo=;
        b=7rVvsoh5nqEoQRVwYHmQyqGkGEIx0V08lsgo9y8edac2msa1Rq4SutVpePR5cZaKVQ
         NgQpYfUJCAzJh161Hflit5/bvWtaAi9/hiF6UiPe0YbaEhuPMySL0daNm2VW3Fw61p6S
         omkRUiCx7IXE++AMVgkC07rMAUQkNN7Vd32Y1rwmxqvEpA/1RwyC7KrQUyK5/oHYE5vR
         CIHg+pVJcBSqgNxJKdIQkJpmnqSQJGSfA6qq9QmgxsrLsb4UnYyLlAw5NH7Hxpr5+aAW
         5XrTTq7xy5BQjI+tg1HcFh7RV8ydD1Y5Zve8OGjcbxMryu91J7DBnks8sZcEFkp7Eeot
         jimA==
X-Gm-Message-State: ANoB5plfg+WrWaz+J6sJg06RTMs9ZJUjjvyVlF4EM2mtWt5IwS6EGqLG
        bgsabqABLfycpkvpwGhQdkslWA==
X-Google-Smtp-Source: AA0mqf5lrqx5SyTOy9VltHp07f5MXVPkuVZFX6LMndnW00UHYwOqtqjNcCDnXOet/VQTL4RhPmS6KQ==
X-Received: by 2002:a17:906:2582:b0:78d:f459:716c with SMTP id m2-20020a170906258200b0078df459716cmr44793306ejb.23.1671298172208;
        Sat, 17 Dec 2022 09:29:32 -0800 (PST)
Received: from localhost.localdomain ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id fx9-20020a170906b74900b007c1675d2626sm2210331ejb.96.2022.12.17.09.29.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 17 Dec 2022 09:29:31 -0800 (PST)
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
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 2/9] target/loongarch/cpu: Remove unused "sysbus.h" header
Date:   Sat, 17 Dec 2022 18:29:00 +0100
Message-Id: <20221217172907.8364-3-philmd@linaro.org>
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

From: Bernhard Beschow <shentey@gmail.com>

The cpu is used in both user and system emulation context while
sysbus.h is system-only. Remove it since it's not needed anyway.

Signed-off-by: Bernhard Beschow <shentey@gmail.com>
Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/loongarch/cpu.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/target/loongarch/cpu.h b/target/loongarch/cpu.h
index e15c633b0b..c8612f5466 100644
--- a/target/loongarch/cpu.h
+++ b/target/loongarch/cpu.h
@@ -13,7 +13,6 @@
 #include "hw/registerfields.h"
 #include "qemu/timer.h"
 #include "exec/memory.h"
-#include "hw/sysbus.h"
 #include "cpu-csr.h"
 
 #define IOCSRF_TEMP             0
-- 
2.38.1

