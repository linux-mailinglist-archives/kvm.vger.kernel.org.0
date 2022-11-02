Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7516F615D4D
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 09:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbiKBIFJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 04:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiKBIFI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 04:05:08 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17C727142
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 01:05:07 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id q9so627376pfg.5
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 01:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Sl5X5/0riDRJIk3jT87SVDndCc8tqsVtJw8Nt/QvqsE=;
        b=N/tUwcyYSxUYS2NhVcpK2ZyNpUKLiMy7kwnpOiHorxpPPr87CD9/eAhrjD/PmWWWyg
         KaPfGq5yZifqiGD1N3bnTQIdZPHesXxBz+3P/m4ptyupEGLm+8lrvJMZVBER1+NNHGRq
         bWLDUKpaikEV3wAUnWJAp3iBl8IHli50zGwAnZ+IwXz7jKS5D7bgBZsyQc41+2a9URPz
         xIG2ePOxkVgedZ8MQZZHRkKT83ydMvz5ubsIRxZTaM35/krLxXl1ftBoWoX7DKTYA7Ud
         d0h+BTe8oL9m8mK4Nc4Z/jLZNwgKlo64VEjYyQY6t+nr+xyacWgm0ox+q+Zxf8FNZyfu
         TQnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sl5X5/0riDRJIk3jT87SVDndCc8tqsVtJw8Nt/QvqsE=;
        b=Mn90xW2bd50IyNOKwGTjFf36qrHgYnk78MXiAyUORis3jh/nEM6fu1BhQHJ2SCSgzE
         CukHNCbqizuvLqkCyg/BYGdA5LLi5AypqKoVV+i+iXYjx6GOT3JYpbT9+JfF7XkxzuQF
         vvdLUBo7ozvEznSsuXIsjRQFJqEwcT2ozH496f65XFD1JwJ86rSPuRRBDEDgo0E4TNPc
         /Dv+Xxc69FMg0PyHXCNMIAbHkea+Yrg6tqNqOBGk1C0ZEfWVc4Nw5CP6XNG7Rjfj7iWq
         EAD0Ierg5KtRILgDR4SllGDrP0cOafLHYfT+VI45Y/Ts23l1GoLid3Jm5Iz621BA2+rE
         n21Q==
X-Gm-Message-State: ACrzQf0rGVGtX+cnZrhKyUE4XDQUPsoEAadQszjCWTsDpkiVtBB8bBPx
        RcXO+Hf0+RY1goUpO+oOYlA=
X-Google-Smtp-Source: AMsMyM5Lyusp8QsqeF5QnL+riomUh+0YBvaSPXwJTbi60+ngD9eeKQ8Bo6jHuM1Y5BlL4j4J9LG3hw==
X-Received: by 2002:a05:6a00:1c92:b0:56d:643e:e116 with SMTP id y18-20020a056a001c9200b0056d643ee116mr15676185pfw.15.1667376307174;
        Wed, 02 Nov 2022 01:05:07 -0700 (PDT)
Received: from centos83-dev.mshome.net ([39.156.73.13])
        by smtp.gmail.com with ESMTPSA id ev16-20020a17090aead000b0020b2082e0acsm865897pjb.0.2022.11.02.01.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 01:05:06 -0700 (PDT)
From:   hbuxiaofei <hbuxiaofei@gmail.com>
To:     will@kernel.org
Cc:     kvm@vger.kernel.org, hbuxiaofei <hbuxiaofei@gmail.com>
Subject: [PATCH kvmtool] hw/i8042: Fix value uninitialized in kbd_io()
Date:   Wed,  2 Nov 2022 16:05:01 +0800
Message-Id: <20221102080501.69274-1-hbuxiaofei@gmail.com>
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

