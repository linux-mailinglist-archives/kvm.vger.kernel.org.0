Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEFB72795C
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 09:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbjFHH7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 03:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234006AbjFHH7S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 03:59:18 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5024A269F
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 00:59:08 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 46e09a7af769-6b2a4655352so201563a34.3
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 00:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686211147; x=1688803147;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uayp+LjPjVw28FmG8NCFIt7N1/ju2Hgrf901o8nifAs=;
        b=f2jBjOikHHJKWKIHBtgDcgtOAtCTwvKxNizDU6nwK2BrOOpcNpnHkdbScCO6urRxHp
         5OL88CeufnS1p/uO/asma+p0nxd02cr7+DQKBfyKm0mXfWJsuRvZPi7EAGnmT8HRqruh
         5uw5tDz+y9RM83rdHsG5POz3Ds8ilE4yO3MMNJPXLsaJZRqlkq7kXC6YrT7X3xHYqRZc
         tpfYovv3SPYiaPvlUEgDOSoaoZqQ6ZuXjiHarRQZByrndFLYYVkQIodsSEW6RSY4rAEs
         xYsod/hpM5B5Qkzsg9SoCOhajjF/+m0q4gsoGfRu44/uRmaMYUqKrxlsPDASLYN+teE1
         T55A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686211147; x=1688803147;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uayp+LjPjVw28FmG8NCFIt7N1/ju2Hgrf901o8nifAs=;
        b=Q0IhPH6jKuTeocGS51WjaG9sbkcHW6LXF5zbZEUjBuxkV1pRf+bDz9r1JcsO8PiP0U
         ogfx6MliF5RPSLPolqI/AfCIPdrQktUqftIYj/n9m4FNjnhcj6byGt57Vv/6A8hcppI+
         M+Qq4pUqjvpOl3pN0d5huyIpfuEFMWiAV4ljm165YBbfmVn1/kR3ycg0FxFcaE/TQFC2
         SHFopPNJh4JYDCDH8Owfwa/v/olxk7lii963hoqI4FIA++EWAdmsGSGMFD88mXuuHUYw
         Pp8B/AG0Iuj0tIcPGVBBpadgyYM0ctgaC2Tl1lwqzT4neaJQwTejKNUPmuPMuHYozIyC
         yQQg==
X-Gm-Message-State: AC+VfDwKy0yoFK1Faw4h6p6v3NJIgjF9f/9pewulTfqNGjNU/WhS+m5+
        kuz+IOaPYTbBxvuSE4/xlGqMxx1DdGU=
X-Google-Smtp-Source: ACHHUZ7cuvnV+T5mXGgUQWUCXG47Rhgq0xybAWQQXnWpZGzyJulsvyxaE7r0Rk/rAS2on5HmSA3Aag==
X-Received: by 2002:a05:6359:a90:b0:129:c27d:9f1f with SMTP id em16-20020a0563590a9000b00129c27d9f1fmr3491649rwb.5.1686211147081;
        Thu, 08 Jun 2023 00:59:07 -0700 (PDT)
Received: from wheely.local0.net ([1.146.34.117])
        by smtp.gmail.com with ESMTPSA id 17-20020a630011000000b00542d7720a6fsm673182pga.88.2023.06.08.00.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 00:59:06 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests v4 08/12] powerpc: Expand exception handler vector granularity
Date:   Thu,  8 Jun 2023 17:58:22 +1000
Message-Id: <20230608075826.86217-9-npiggin@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230608075826.86217-1-npiggin@gmail.com>
References: <20230608075826.86217-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Exception handlers are currently indexed in units of 0x100, but
powerpc can have vectors that are aligned to as little as 0x20
bytes. Increase granularity of the handler functions before
adding support for those vectors.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
Since v3:
- Fix typo [Thomas]

 lib/powerpc/processor.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/lib/powerpc/processor.c b/lib/powerpc/processor.c
index aaf45b68..64d7ae01 100644
--- a/lib/powerpc/processor.c
+++ b/lib/powerpc/processor.c
@@ -16,19 +16,25 @@
 static struct {
 	void (*func)(struct pt_regs *, void *data);
 	void *data;
-} handlers[16];
+} handlers[128];
 
+/*
+ * Exception handlers span from 0x100 to 0x1000 and can have a granularity
+ * of 0x20 bytes in some cases. Indexing spans 0-0x1000 with 0x20 increments
+ * resulting in 128 slots.
+ */
 void handle_exception(int trap, void (*func)(struct pt_regs *, void *),
 		      void * data)
 {
-	assert(!(trap & ~0xf00));
+	assert(!(trap & ~0xfe0));
 
-	trap >>= 8;
+	trap >>= 5;
 
 	if (func && handlers[trap].func) {
 		printf("exception handler installed twice %#x\n", trap);
 		abort();
 	}
+
 	handlers[trap].func = func;
 	handlers[trap].data = data;
 }
@@ -37,9 +43,9 @@ void do_handle_exception(struct pt_regs *regs)
 {
 	unsigned char v;
 
-	v = regs->trap >> 8;
+	v = regs->trap >> 5;
 
-	if (v < 16 && handlers[v].func) {
+	if (v < 128 && handlers[v].func) {
 		handlers[v].func(regs, handlers[v].data);
 		return;
 	}
-- 
2.40.1

