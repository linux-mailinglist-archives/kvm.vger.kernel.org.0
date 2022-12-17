Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5A3064FB3F
	for <lists+kvm@lfdr.de>; Sat, 17 Dec 2022 18:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiLQR3q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Dec 2022 12:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiLQR3l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Dec 2022 12:29:41 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A872410FC2
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 09:29:40 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id jo4so4014781ejb.7
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 09:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ZSUdi6MPqmLHvEe0ND7y8PBSQThNukontDiEvm1T8g=;
        b=ynZZBnIu3uHw8ZjTU+ptvD8NAEOs31tgcoL65oO/ziaJtUsIIDjislHra910JvDW+s
         3Or/QGT2iRJABqQ+5+Lrq0uvI7J5EmBBjec5B0ed4Dh4mmgt3G/SQkQcZhv+5ouILmAZ
         IDw4kv8HHlsCPdNam3qvGEzM1xTo6BZIf6vaBMAbESxTVvwNCUdLku4YUNpJoGoD1M5R
         ptjCRFtTW4fJImCc/odk5Ip3i/zWhGOlwMeNHGUDMDN+0HCYLfqxSom/O7ApsYSBQlqR
         2sm3kZXXr/4Mlg7YVNIzT00WyYQfV7oU2ViR7ezs7WfMjFZ68mYw8Hr/vo7zEjLhWFLG
         M20g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6ZSUdi6MPqmLHvEe0ND7y8PBSQThNukontDiEvm1T8g=;
        b=MEXUEQFhF/OeGPICmGJ65RI0brdsmnHR694dQvbhlVD3Y4rBujuP7LXYkFvRNgmKXJ
         sqTooxwdoZAP4wGYdez964G03JJ6Jz2Ras1HBGPaP6wak3gVP1R+au8uA+XqUs0/YiHh
         LgOusYQ/CASl3DM9iXx/hBDfCPEDHE9V9AU2vKhF8+opUu53q59KUrogYqvgtu5FnBWY
         6jHrKqy2eF7/DckJ7qhuBQQvOXnKGYHASgpda98LtCLOwjRF09H4B+nTmECAgmQ0G+mm
         o3F7A08jb6S96NMCgYCh+Xu6q4po5yDkVPAhQsglmWYuG3z5mbP8V3ymget+/WSbW8QE
         9Owg==
X-Gm-Message-State: ANoB5plY9rySGiB1VSm7KxSVPZJxS+7TDgWxAavOcMFcoPiQ0SJNB+PO
        3XPYd7VuBhBBXxS8vUq1dsIhhg==
X-Google-Smtp-Source: AMrXdXvq5oxwBsxndznqbCK8B0fVpBp4xftm2X6MLOx+v8Vfc00Bci5+pJJyScz+r5MkI7euEneKAg==
X-Received: by 2002:a17:907:98eb:b0:7c4:fc02:46a3 with SMTP id ke11-20020a17090798eb00b007c4fc0246a3mr12442428ejc.30.1671298180297;
        Sat, 17 Dec 2022 09:29:40 -0800 (PST)
Received: from localhost.localdomain ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id da6-20020a056402176600b0046c7c3755a7sm2203849edb.17.2022.12.17.09.29.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 17 Dec 2022 09:29:39 -0800 (PST)
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
Subject: [PATCH v2 3/9] target/loongarch/cpu: Restrict "memory.h" header to sysemu
Date:   Sat, 17 Dec 2022 18:29:01 +0100
Message-Id: <20221217172907.8364-4-philmd@linaro.org>
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

Missed in 0093b9a5ee ("target/loongarch: Adjust functions
and structure to support user-mode") while cleaning commit
f84a2aacf5 ("target/loongarch: Add LoongArch IOCSR instruction").

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/loongarch/cpu.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/target/loongarch/cpu.h b/target/loongarch/cpu.h
index c8612f5466..2f17ac6b47 100644
--- a/target/loongarch/cpu.h
+++ b/target/loongarch/cpu.h
@@ -12,7 +12,9 @@
 #include "fpu/softfloat-types.h"
 #include "hw/registerfields.h"
 #include "qemu/timer.h"
+#ifndef CONFIG_USER_ONLY
 #include "exec/memory.h"
+#endif
 #include "cpu-csr.h"
 
 #define IOCSRF_TEMP             0
-- 
2.38.1

