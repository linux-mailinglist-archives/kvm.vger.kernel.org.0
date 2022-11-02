Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57BC1615D34
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 08:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiKBH6M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 03:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiKBH6H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 03:58:07 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79DD25282
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 00:58:06 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id z26so2562700pff.1
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 00:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Sl5X5/0riDRJIk3jT87SVDndCc8tqsVtJw8Nt/QvqsE=;
        b=pBcGKLKtTTBuKW9WCmuwB02SFHL4lAyC5Dr0O2+UAy0wW36NVBCsqO9/yhpV6T0MuN
         MwXHGSgQDIEI2tvdkE1cDVB1WrB5L4wSCibqCF2FxM5Pmsws6ms3FHCEvXx0mBHm5vmQ
         n95V6xwJi4cUF99P4okm3N7CvvauoKVTpsadCr5rIbWU6Nt44pdJfTDUmjExOIMBOIz1
         uVbXUtALUSY90g92orqLLsE9h2+tcPNlqYqPLMYDM20X7nCsADNk+kG02KzpE/7zYgy+
         xDrdjwlpWUvepwEBack3v5rxG8L0TmxhbBvVwbWWJ6qmP+EOEBJy9FlnWBCbOXeKbDO1
         Tl+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sl5X5/0riDRJIk3jT87SVDndCc8tqsVtJw8Nt/QvqsE=;
        b=a2AvTWOVEYsqVn+p/bsoYAhYECOKR9nAqWUhpzRTXMRmUJZ8FPS/HPeKF5Py60driO
         NUc9GSPYhNGfKs4wYHmHjRpoOCWwR1tU3aaPKJbmRgZxnj+K4O5nbiGwKny+hQ6CqEDh
         gKWUbmT4CZsqCbjZeT0M6sa3uh2K3jjAJunfG6e/lfcRhg2G/fd4exadq1jcjlKHca3J
         BrZXgaTULKQ4t4QgmTbvO0UzsJ8RRWMu+zR/eyrfut16EB2Ct/0gN3jbImOMPODmthhq
         l3drb7debCook9AJC0BX8qENtzgE5eiyZICfa3SLSsJu8IO2j+0vBPlhUEhWOoYDi9CK
         QZrw==
X-Gm-Message-State: ACrzQf2jzt84HYIDZLMYgbQcPWYr5EcmkgOHwKadq1tfNBY0VDGQScLt
        /Gp2OjNlBnsgJGFOJV1D4qgoLo3b7eU8XODC
X-Google-Smtp-Source: AMsMyM5K9NuIbSAAwfcr8e0S8nQZGCrazpzmdZwEV0F0//2AxZAkNsFXuCwZyNoy0Njvdw+tppWjcA==
X-Received: by 2002:a05:6a00:4c16:b0:56d:2634:c28e with SMTP id ea22-20020a056a004c1600b0056d2634c28emr20930029pfb.8.1667375886155;
        Wed, 02 Nov 2022 00:58:06 -0700 (PDT)
Received: from centos83-dev.mshome.net ([39.156.73.13])
        by smtp.gmail.com with ESMTPSA id z20-20020aa79f94000000b0056246403534sm7838717pfr.88.2022.11.02.00.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 00:58:05 -0700 (PDT)
From:   hbuxiaofei <hbuxiaofei@gmail.com>
To:     will@kernel.org
Cc:     kvm@vger.kernel.org, hbuxiaofei <hbuxiaofei@gmail.com>
Subject: [PATCH] hw/i8042: Fix value uninitialized in kbd_io()
Date:   Wed,  2 Nov 2022 15:57:55 +0800
Message-Id: <20221102075755.68804-1-hbuxiaofei@gmail.com>
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

