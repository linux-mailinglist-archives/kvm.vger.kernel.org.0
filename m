Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5CA6D82EE
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 18:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238892AbjDEQFm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 12:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238622AbjDEQFh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 12:05:37 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2405FFC
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 09:05:34 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id e18so36717854wra.9
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 09:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680710733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TXAiv5gPJGzakn6yAF3UQ469jIKkZR4r/iuFrCC5frw=;
        b=MK0k+l7i0JL0N5tdLRQup0z/tS+z9fsal4eicREogGdlwNf9QVbabnZfiviIAYfHBf
         JA3Z4LTUT/MZ/596XiLixMfrIvzM7ysklzUO4TTvJDt47/2W4D9/CzYhb/QcW2qM2DGh
         lV8PnFchupvt62JB8kdIM3YEQBVwi8Y5uTliYYgPdnvE4XiaGrBARmupflOVkRocZ/k8
         F0CNMkRh//wn/9/AGrldf70UiFQf2BIvuEBy7QwNDJ6vwKQhDdHoszOmXwaWZsR7hKME
         u0GX0l3gc0dvqJ6SgJT7MSeNx+4HHimdvMSdJ5XvGckOBpinv7ZG0pcUGyBpL8WdzMFG
         KJHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680710733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TXAiv5gPJGzakn6yAF3UQ469jIKkZR4r/iuFrCC5frw=;
        b=sNqEZwyo8xxkyalxG0QUr7nHkG6P/EcQnsr1PHUELVEft0xMFKiaim9S2yKR7klJMW
         1tFZKCnX3ouo4iFWH0p2ED/8+6pGAgcyXqYXe8HscqMO4LZVUJZDZlAIv+0GzNkuKdXn
         YKjKcAopKrHwlorBGNd5vuW+sBrtHG4k1hj9ywqy/6IXCM7X76zO0SYdaOqCt3uILrlz
         t435Pu76gj34jIzVPAu6TpvaQ+pnGvWRfjuenfrvJByV55Qb/eyeiiMaTxQeHW2QRrJX
         LwlXdfthqFvM0o8+Qd+4dLrGCoLv67YJsLiEhTeezOu3J4T8sm9NLuE8GRZbbSyb9x4g
         2Nbg==
X-Gm-Message-State: AAQBX9fuVvsvIHI6V//MJ8a+vykV/cb4ZXr+8I6LR/HTLAsXzIkTwDMJ
        C/ve9NFkuGpcIDMg6+92DXiORg==
X-Google-Smtp-Source: AKy350aJfFZROd28tOYQVpVfLU5O7PA/1sFGTeMRr0g366fxZBdFDsolmijBgmnNZ+HUOQGRU0ODxQ==
X-Received: by 2002:a5d:52c7:0:b0:2ce:a9e9:4905 with SMTP id r7-20020a5d52c7000000b002cea9e94905mr4246512wrv.34.1680710732675;
        Wed, 05 Apr 2023 09:05:32 -0700 (PDT)
Received: from localhost.localdomain (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id m19-20020a7bce13000000b003ee1acdb036sm2606127wmc.17.2023.04.05.09.05.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Apr 2023 09:05:32 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     qemu-s390x@nongnu.org, qemu-riscv@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH 06/10] target/arm: Reduce QMP header pressure by not including 'kvm_arm.h'
Date:   Wed,  5 Apr 2023 18:04:50 +0200
Message-Id: <20230405160454.97436-7-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230405160454.97436-1-philmd@linaro.org>
References: <20230405160454.97436-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We only need "sysemu/kvm.h" for kvm_enabled() and "cpu.h"
for the QOM type definitions (TYPE_ARM_CPU). Avoid including
the heavy "kvm_arm.h" header.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/arm-qmp-cmds.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
index c8fa524002..91eb450565 100644
--- a/target/arm/arm-qmp-cmds.c
+++ b/target/arm/arm-qmp-cmds.c
@@ -22,7 +22,7 @@
 
 #include "qemu/osdep.h"
 #include "hw/boards.h"
-#include "kvm_arm.h"
+#include "sysemu/kvm.h"
 #include "qapi/error.h"
 #include "qapi/visitor.h"
 #include "qapi/qobject-input-visitor.h"
@@ -31,6 +31,7 @@
 #include "qapi/qmp/qerror.h"
 #include "qapi/qmp/qdict.h"
 #include "qom/qom-qobject.h"
+#include "target/arm/cpu.h"
 
 static GICCapability *gic_cap_new(int version)
 {
-- 
2.38.1

