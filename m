Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8EE727956
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 09:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233896AbjFHH6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 03:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbjFHH6p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 03:58:45 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2921FFE
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 00:58:44 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id d75a77b69052e-3f9b7345fb1so2196491cf.1
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 00:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686211123; x=1688803123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SitJ5tO3augZ5mGlwD1goyJVO5IvzDnfv+6964OUjXo=;
        b=lNu60NmQZamk4+o0ec1N8PDbIGk1O/S0oEK57aE+ctpAh/O4qp9WLIIAdIQezdTgiX
         o6Ls+eydA+EeRXl+0aMSt1v+rqlPrA4aCmvJCFpRCfxDUrDregweOKFfrf62EWjCQLRs
         KKC0mzeezLCu6YITWUrFJ8z1FtnFoDlD1YBMpcs4CPor/h7tmcv9pdFBaeBjjMiSi0Rl
         aphn9UhaCaPyGeR/eRaBtJCXXSHlJ+fxFeiH0x9P7TJyBFpLQXgd/wOBW285NCBPkvq7
         HA8ljJisYJhKve38fjWMDfgUeSelgPK8HaO3XjJSQcZdAHXUcbOxLKHqyzRNFQI2ozb1
         CMZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686211123; x=1688803123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SitJ5tO3augZ5mGlwD1goyJVO5IvzDnfv+6964OUjXo=;
        b=MB3RvaN8U4nuy2ksjom2OP5x3w8CI8wns62oWDJQ+9TZRF19RlcD/8wYKPpCdQOOSN
         giJxOTXIWFYhmKhVNYNemDK+nu8UHh6XFcq558dU7EBtgDojkaqecdq6bibtzIwV0TNn
         a0JI2DzE3Gde7esg2UVuYkkbC6QYPYMWm3xbYKQH9k4D6p5DPdrqG+YtcU9xwKrzECx5
         7DZw01Q3LmCQKTG2/Y+Hp2i0ll+RaUwmbdK227LKhzcHV11G7IzOva8UNiHhe0JKD4CQ
         cOLSEc2W69q7MJ1gh8nTuWGV52VD//ktNcDcBGrL++QsgfvQC1RDrp/U9zGsY3+LWwlm
         2iLw==
X-Gm-Message-State: AC+VfDynAldpR0BJbQehQjxh7f01M+4q+vKJfJrOI+ducvoexbQLT+sJ
        HB6XIzZQlcx/k1GCWJUCtUduC4/jYqI=
X-Google-Smtp-Source: ACHHUZ6ARW2uj8qdrOXuVbPRfj5ufKNurBN5yT1b4EYZi7j6hSHx+3k87AvpqLrJ8GzmkkyHtnbS6Q==
X-Received: by 2002:ac8:7d4e:0:b0:3f9:c159:2656 with SMTP id h14-20020ac87d4e000000b003f9c1592656mr5131373qtb.66.1686211122855;
        Thu, 08 Jun 2023 00:58:42 -0700 (PDT)
Received: from wheely.local0.net ([1.146.34.117])
        by smtp.gmail.com with ESMTPSA id 17-20020a630011000000b00542d7720a6fsm673182pga.88.2023.06.08.00.58.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 00:58:42 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests v4 02/12] powerpc: Add some checking to exception handler install
Date:   Thu,  8 Jun 2023 17:58:16 +1000
Message-Id: <20230608075826.86217-3-npiggin@gmail.com>
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

Check to ensure exception handlers are not being overwritten or
invalid exception numbers are used.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
Since v3:
- Simplified code as suggested by Thomas.

 lib/powerpc/processor.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/lib/powerpc/processor.c b/lib/powerpc/processor.c
index 05b4b04f..0550e4fc 100644
--- a/lib/powerpc/processor.c
+++ b/lib/powerpc/processor.c
@@ -19,12 +19,16 @@ static struct {
 void handle_exception(int trap, void (*func)(struct pt_regs *, void *),
 		      void * data)
 {
+	assert(!(trap & ~0xf00));
+
 	trap >>= 8;
 
-	if (trap < 16) {
-		handlers[trap].func = func;
-		handlers[trap].data = data;
+	if (func && handlers[trap].func) {
+		printf("exception handler installed twice %#x\n", trap);
+		abort();
 	}
+	handlers[trap].func = func;
+	handlers[trap].data = data;
 }
 
 void do_handle_exception(struct pt_regs *regs)
-- 
2.40.1

