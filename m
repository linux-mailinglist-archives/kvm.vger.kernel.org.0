Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADCC164FB3D
	for <lists+kvm@lfdr.de>; Sat, 17 Dec 2022 18:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbiLQR33 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Dec 2022 12:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLQR30 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Dec 2022 12:29:26 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE27110B71
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 09:29:25 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id m18so12949770eji.5
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 09:29:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rhg804KZ0j3EDv2yEyvkNjHpleyZtJnZbPJM5lHyuH8=;
        b=Wf4354pc/8cn9IPaI2w98r6AGC3aq63l7EE3po+2OcUGgXc/1lnQZv4+ZR239vYh3u
         yAXOI+dRf2qVwoVClMlLpvaHOhsQxZKLwlDo5dcecP+9P+OItccCwlA8lUbP/lN7vqiS
         cEoVg0qUO/D9eCmDZuh2nAX5Y2NZwgnDNyUMXNfP7t940M/QA1Sy8v0KiAlYE9eJcnWV
         soWHhz0iortDLEiUnnTWc8/QtjVGgS5zAVwXmbSr/TCl9PfrkeDU4dtQ0Xce09Xh51+K
         vKMGD0O/LdoSYsQb9V5K+HLmGYoYpimaVcKxEBPXPgWZo8a6WQSyWZ6fwes5gf3RYFEF
         XLVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rhg804KZ0j3EDv2yEyvkNjHpleyZtJnZbPJM5lHyuH8=;
        b=fyGRlXbLh544FHsdwKf7earhaTbYIF9W7zhI13OxWlbYNMz/plHGp/EUkNShhyjATL
         G4W7xUr6BVreVV4gbOupsab7kJr/0nFcod+fsCJECI5htNCdSum3QFXTKLQcWNEu/b4A
         IS3RJjFGHdFJrwNHj94o7j6r6O/rbOiTlcxlbRetU59Kd3X0aJVVndC+HTpTJEuq7/gk
         T+QgsgGNLZxdZWVXLs5Zd2/Z4bRXXUJjYSm3slanUnUMLuy9v7R0FPs3gFxu7OhO1V9D
         K1lgpwr1jTgNoiygCGOVqKqITvUC0MMajo/4t/pU4QTTN98y8eZBTLtysbiKvne0Sgvi
         14Fg==
X-Gm-Message-State: ANoB5pkL5ovaFS9ZqXe8ymBV1r8BYu3SvGIzofqsCwbE+5SpXxyLoWTX
        c4dFwKQ0GFDP11ZvMEemjjIb+w==
X-Google-Smtp-Source: AA0mqf7VIbBfexhuryH1yv6q6S6xFabt++RaCuZEwZtGbg/SMlf2Ithtj56FIQ3BUDdIrzua0XbR/A==
X-Received: by 2002:a17:906:fb02:b0:78d:f454:386d with SMTP id lz2-20020a170906fb0200b0078df454386dmr31919910ejb.42.1671298164333;
        Sat, 17 Dec 2022 09:29:24 -0800 (PST)
Received: from localhost.localdomain ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id k3-20020a170906a38300b00788c622fa2csm2173136ejz.135.2022.12.17.09.29.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 17 Dec 2022 09:29:23 -0800 (PST)
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
Subject: [PATCH v2 1/9] target/alpha: Remove obsolete STATUS document
Date:   Sat, 17 Dec 2022 18:28:59 +0100
Message-Id: <20221217172907.8364-2-philmd@linaro.org>
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

Likely out of sync: last update is from 2008
(commit d1412eb240), 12 years ago.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/alpha/STATUS | 28 ----------------------------
 1 file changed, 28 deletions(-)
 delete mode 100644 target/alpha/STATUS

diff --git a/target/alpha/STATUS b/target/alpha/STATUS
deleted file mode 100644
index 6c9744569e..0000000000
--- a/target/alpha/STATUS
+++ /dev/null
@@ -1,28 +0,0 @@
-(to be completed)
-
-Alpha emulation structure:
-cpu.h           : CPU definitions globally exported
-exec.h          : CPU definitions used only for translated code execution
-helper.c        : helpers that can be called either by the translated code
-                  or the QEMU core, including the exception handler.
-op_helper.c     : helpers that can be called only from TCG
-helper.h        : TCG helpers prototypes
-translate.c     : Alpha instructions to micro-operations translator
-
-Code translator status:
-The Alpha CPU instruction emulation should be quite complete with the
-limitation that the VAX floating-point load and stores are not tested.
-The 4 MMU modes are implemented.
-
-Linux user mode emulation status:
-a few programs start to run. Most crash at a certain point, dereferencing a
-NULL pointer. It seems that the UNIQUE register is not initialized properly.
-It may appear that old executables, not relying on TLS support, run but
-this is to be proved...
-
-Full system emulation status:
-* Alpha PALCode emulation is in a very early stage and is not sufficient
-  to run any real OS. The alpha-softmmu target is not enabled for now.
-* no hardware platform description is implemented
-* there might be problems in the Alpha PALCode dedicated instructions
-  that would prevent to use a native PALCode image.
-- 
2.38.1

