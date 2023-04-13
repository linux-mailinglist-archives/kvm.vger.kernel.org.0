Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 782226E145F
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 20:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjDMSnN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 14:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjDMSnD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 14:43:03 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325CD8A74
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:41 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id q6so3696556wrc.3
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1681411359; x=1684003359;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RlFO6VQHbvsrhkxBXUqkpVJD2i9H4aa/y980IKqKnx0=;
        b=vh9vH0MzKGfpsWxpzzx0UjXKALj9f9ReWwFcZ5M8wJvAgsM4OzHJ6wxQL+kfvjx4eB
         Is0DPWPrAmGlRp5GMj+6o46KOzZ/ynfevTzLzhzJcmRRsJbsFkajjM/rXb62z7tZPoVZ
         7BdxQr92bkaIQApdOwIF7ptAiodQ5uz/VgAcvBCwDntUxQrxguzu6aNheM9CwwGdRwYt
         dE1htxvjnovHc4pbAXt0EL5Weebv8jIHLmgBRPHSkToPuWiFbyCBhAe6vpd1kWvy0LW2
         RhFZgAgavGbtTix6WwFZH1p47XZWobqmOOG5xtiPwzhN9Vul4irAZlX2JdX8nGZ7oAOQ
         EDdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681411359; x=1684003359;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RlFO6VQHbvsrhkxBXUqkpVJD2i9H4aa/y980IKqKnx0=;
        b=MdsPrCygZgaZKfPvUMqhO/jdlR6ybk6eDcIcHQwHgleDGg3s+ybV0PvXHuWDXqwzua
         fQ0LlasYv3ZLbGidM6OokGBmv8TtBnV+hkeeZwIksVLpx1odoE+hloM9y4s5xaDB/nfj
         OXCGCo4J7CqRdXdVE0vAex1nsvqLbKB9SQ4jEA+NozgVo+j2ciXF+xBHFslAhtYCC6XH
         Sv8GiHle393di4JspwjN8tGjyR1ZPdlI3Zkwik00yTQ7mv4uHMWULjw5gw1XMFSc4+tW
         KR4qk51lUdQ9DPPBFpBusUVQtNcQEe0Ag6lv4JM8PQyGznXk1RmYT5rqgk/l+ylEe3ba
         PYmQ==
X-Gm-Message-State: AAQBX9cYGJPshljlNYhEnth0XFkrqiTvAIk5/MnLGxA5E0mU+stYpEJt
        MnSgEKGpzO4XPPeCH76r9EUZjA==
X-Google-Smtp-Source: AKy350Yv7exdByGADAB1ejtZMi+3XVQKEx0GhI5EwCdtbUgv7qGwXXsM5NNWs4F5HHK6Doh//Htqeg==
X-Received: by 2002:a5d:6a89:0:b0:2ef:b051:95c5 with SMTP id s9-20020a5d6a89000000b002efb05195c5mr2148177wru.60.1681411359680;
        Thu, 13 Apr 2023 11:42:39 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af154800ce0bb7f104d5fcf7.dip0.t-ipconnect.de. [2003:f6:af15:4800:ce0b:b7f1:4d5:fcf7])
        by smtp.gmail.com with ESMTPSA id x15-20020a5d6b4f000000b002c8476dde7asm1812652wrw.114.2023.04.13.11.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 11:42:39 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc:     Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 05/16] x86/access: Use 'bool' type as defined via libcflat.h
Date:   Thu, 13 Apr 2023 20:42:08 +0200
Message-Id: <20230413184219.36404-6-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230413184219.36404-1-minipli@grsecurity.net>
References: <20230413184219.36404-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the unneeded definitions of 'true' and 'false' and make use of the
common 'bool' type instead of using the pre-C99 / post-C23 definitions.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 x86/access.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 70d81bf02d9d..f90a72d6e951 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -5,10 +5,7 @@
 #include "x86/vm.h"
 #include "access.h"
 
-#define true 1
-#define false 0
-
-static _Bool verbose = false;
+static bool verbose = false;
 
 typedef unsigned long pt_element_t;
 static int invalid_mask;
@@ -406,7 +403,7 @@ static int ac_test_bump_one(ac_test_t *at)
 
 #define F(x)  ((flags & x##_MASK) != 0)
 
-static _Bool ac_test_legal(ac_test_t *at)
+static bool ac_test_legal(ac_test_t *at)
 {
 	int flags = at->flags;
 	unsigned reserved;
@@ -738,7 +735,7 @@ static void dump_mapping(ac_test_t *at)
 	walk_va(at, F(AC_PDE_PSE) ? 2 : 1, virt, __dump_pte, false);
 }
 
-static void ac_test_check(ac_test_t *at, _Bool *success_ret, _Bool cond,
+static void ac_test_check(ac_test_t *at, bool *success_ret, bool cond,
 			  const char *fmt, ...)
 {
 	va_list ap;
@@ -780,7 +777,7 @@ static int ac_test_do_access(ac_test_t *at)
 	unsigned e;
 	static unsigned char user_stack[4096];
 	unsigned long rsp;
-	_Bool success = true;
+	bool success = true;
 	int flags = at->flags;
 
 	++unique;
-- 
2.39.2

