Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A846615D42
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 09:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiKBIAx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 04:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKBIAv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 04:00:51 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2EC319F
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 01:00:47 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id b29so15672674pfp.13
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 01:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Sl5X5/0riDRJIk3jT87SVDndCc8tqsVtJw8Nt/QvqsE=;
        b=mS/9bqPBsCBrDwSiczwgIVQz1/uy9nPaumebZ/Dk+m6FOjMSY9SYbVF20RiDJiiHJb
         ypzh2CEveWi3EJkwEu2lmXES+SgLDXgdT/ZcDNOUkXVQT5f+rdyNfuqi4Dkn5oanKh0z
         L2t3KO7fzaUSageL2craiKI+khXz8aFd3S6pNTWgyQG16WkMH1w5j86mR8pLJek/zMnT
         tj0EVyUUvKK7yKwZ6fgU+HZ8P8IkX/Ze17xyLclVGfAbqYLlzbwunw+iY3J0F7II/rJO
         1adeoa/On9wvi0ynTN3kmW+DBnbzs/JkMs5ansehQxFT/ORT+93q9LujD7UpwRB3E9Do
         gZcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sl5X5/0riDRJIk3jT87SVDndCc8tqsVtJw8Nt/QvqsE=;
        b=btsdq+jO9AxSszV0aDVJquQ308IygyTbfR+kYqFgCVxiL5a2yzq6aavPjW1djGxImJ
         DJCnfB/XENDN0a2wWIZWBDjsUTr6XtPB/Ms+b13FtNkgEHlgO3+A3W11H4DnU4zkfr+D
         SycL7r3EaKZ4RwNvX8BKnzayRzDeYmHKJA1FqP6AmlXcGSNFdzLRQrmUoho9Qn9ZBylS
         Tom/15mEZskKe/g76sLNk70Mysc1afOf/pp2UJszQ/0KxNO+IYmdu1QBwGjMlH4WWze2
         RoG63h4TIXohqI8syDPC10qF33qgsnKNfQKqrPn+6vB1ZBxJI0zn7yPCImdmgppIugdZ
         fVvw==
X-Gm-Message-State: ACrzQf0FHEcrgVWFAk6y9wBG2u3ox40DbWcHGTTKqCulFMoegQiEvcI3
        IU6zrdI02X7Ky5MLf1oNfQA=
X-Google-Smtp-Source: AMsMyM4PTX44bJxUvqhN2efmuS/1eqMh04zy+EgTMQP3nkgVnL7TDeOvfZxDcRe3nfd4xAjBkCW4UA==
X-Received: by 2002:a63:da43:0:b0:46f:9193:466b with SMTP id l3-20020a63da43000000b0046f9193466bmr18082191pgj.419.1667376047270;
        Wed, 02 Nov 2022 01:00:47 -0700 (PDT)
Received: from centos83-dev.mshome.net ([39.156.73.13])
        by smtp.gmail.com with ESMTPSA id c28-20020aa7953c000000b005624e2e0508sm7762114pfp.207.2022.11.02.01.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 01:00:46 -0700 (PDT)
From:   hbuxiaofei <hbuxiaofei@gmail.com>
To:     will@kernel.org
Cc:     kvm@vger.kernel.org, hbuxiaofei <hbuxiaofei@gmail.com>
Subject: [PATCH kvmtool] hw/i8042: Fix value uninitialized in kbd_io()
Date:   Wed,  2 Nov 2022 16:00:40 +0800
Message-Id: <20221102080040.69038-1-hbuxiaofei@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  GCC Version:
    gcc (GCC) 8.4.1 20200928 (Red Hat 8.4.1-1)

  hw/i8042.c: In function ‘kbd_io’:
  hw/i8042.c:153:19: error: ‘value’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
     state.write_cmd = val;
     ~~~~~~~~~~~~~~~~^~~~~
  hw/i8042.c:298:5: note: ‘value’ was declared here
    u8 value;
       ^~~~~
  cc1: all warnings being treated as errors
  make: *** [Makefile:508: hw/i8042.o] Error 1

Signed-off-by: hbuxiaofei <hbuxiaofei@gmail.com>
---
 hw/i8042.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/i8042.c b/hw/i8042.c
index 20be36c..6e4b559 100644
--- a/hw/i8042.c
+++ b/hw/i8042.c
@@ -295,7 +295,7 @@ static void kbd_reset(void)
 static void kbd_io(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
 		   u8 is_write, void *ptr)
 {
-	u8 value;
+	u8 value = 0;
 
 	if (is_write)
 		value = ioport__read8(data);
-- 
2.27.0

