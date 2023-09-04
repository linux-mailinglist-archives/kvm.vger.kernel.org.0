Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65C8A791750
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 14:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352854AbjIDMn7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 08:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350864AbjIDMn6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 08:43:58 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD78CD4
        for <kvm@vger.kernel.org>; Mon,  4 Sep 2023 05:43:52 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-52e297c7c39so1270571a12.2
        for <kvm@vger.kernel.org>; Mon, 04 Sep 2023 05:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693831431; x=1694436231; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SdbPeRb3rqucMV4G8DmJatCRkQTtO6zKzLYWXw0g6yM=;
        b=NKVUbO/Qvv7VF4HCE9AkPGvIpqppN1Lb7pn6sLpr2I7a+BXSA9m/XgqdhlHYW47jSP
         2/RAYazx1fnIjcW9raSDp/zcTtn3qmle3E3k4IWOUMfeEWZTpB7l0P6Cq1J4RMQMrKoH
         OZ5dyyBRDQNDDpg/js82OTR7XvvMk50wt4IqBrDbyPXz8KxxwL7SiWUjjQTx1z5dJRcq
         6A8h389evNHpbTqctpCTnhz9AWSpygo7Fx+EmEYp2LyQD11jlTzvqsHCAtkC9HeZRsnW
         R0pkpdaopmOw+EZz/hY23gQ4PzYDjkiW28e4/o9GVr3l9BwCZJLx7o7TjImGFti6kTCJ
         Vs1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693831431; x=1694436231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SdbPeRb3rqucMV4G8DmJatCRkQTtO6zKzLYWXw0g6yM=;
        b=bBuUsyWJFpMUOrGbXJphZr/dUvjgSrWia34tS8aqYdSM5j9A+bbFQPHqldl3KTBH3O
         uNZupYtkdWrPy8M2PgS0mk6I0zoH3uAJP5+GXwq0T4qU+Rx9FsVCTg5icz2sDaUYBSed
         iV12iTjSvyHHxk0cnVG4a8efw0m+BU89cmZHSfa/S5jP7Op+Bl2KNI48FG6sYbzdAsZ3
         AaQpbtQrIBxQdSAQzNzjzr9PLBExK2x20vRdGx2eoqrwzar1caA3vA+KyBTE6s0Yu2Td
         CkCXHcAVnvfrsmNilQ3qZQ6rDaFbvLWbibO3PnrXJZEP7g6Urkn8z2aD06I1iPGr50xi
         LaUA==
X-Gm-Message-State: AOJu0YyuLdN/nqTRlK1SxYr85lXo0z8Qr1uSyaeKC7tC5XErUo2qZ5VO
        wn1SR1fk8ZrDMe3ijVJxrHn7rg==
X-Google-Smtp-Source: AGHT+IEsBFqUtTTs6WqvZHff9CgEl9Cr75zp000xY/akplngwM5ibOARO4pqK/3xRP1h2a6+OrAUVw==
X-Received: by 2002:a17:906:cc5b:b0:99d:fd65:dbb2 with SMTP id mm27-20020a170906cc5b00b0099dfd65dbb2mr7528978ejb.33.1693831431480;
        Mon, 04 Sep 2023 05:43:51 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.209.227])
        by smtp.gmail.com with ESMTPSA id y8-20020a170906914800b00992f2befcbcsm6120980ejw.180.2023.09.04.05.43.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 04 Sep 2023 05:43:51 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 04/13] target/i386/helper: Restrict KVM declarations to system emulation
Date:   Mon,  4 Sep 2023 14:43:15 +0200
Message-ID: <20230904124325.79040-5-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230904124325.79040-1-philmd@linaro.org>
References: <20230904124325.79040-1-philmd@linaro.org>
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

User emulation doesn't need any KVM declarations.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/helper.c b/target/i386/helper.c
index 89aa696c6d..2070dd0dda 100644
--- a/target/i386/helper.c
+++ b/target/i386/helper.c
@@ -22,10 +22,10 @@
 #include "cpu.h"
 #include "exec/exec-all.h"
 #include "sysemu/runstate.h"
-#include "kvm/kvm_i386.h"
 #ifndef CONFIG_USER_ONLY
 #include "sysemu/hw_accel.h"
 #include "monitor/monitor.h"
+#include "kvm/kvm_i386.h"
 #endif
 #include "qemu/log.h"
 #ifdef CONFIG_TCG
-- 
2.41.0

