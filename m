Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496DA6CA45F
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 14:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbjC0Mpp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 08:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbjC0Mpn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 08:45:43 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378D14200
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 05:45:43 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id l7so7540651pjg.5
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 05:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679921142;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/7HUQqjeCU9xxuess/BilVQvbPRHx3dfJR9GG39px60=;
        b=UOf308ory3UnOGfi0PppTTQd7l5iXDJJXOaxA6/53htATAsUcWi/We6wwXVeHhDadl
         KR/XXgSVvCNdsEarceCq6hKlDXUjc7G9tfM+vJwi/rCfFx24jmfUK/ZtHA6uNMniaUsv
         /goXX4MzK+JVFCPD9SdTSSYPzyb5MFPzgameZzb8EWG7BCHFNJ4Im917gz4iDZrDZECG
         PH1EPumyz1rGjxgDmnj5n37JeFxGm/5ayABe+bU5v6RReWvOIqfYLDSguYSeAu06P/cC
         dgNkntx+cOn6Hh/eZXt/6HpfRFzOOe+XjcGOXOeHpu4JJtQKkK1vNZjYcKXbO5LGswok
         3uxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679921142;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/7HUQqjeCU9xxuess/BilVQvbPRHx3dfJR9GG39px60=;
        b=JfmEVYnTzFCd2X89zdxcvDh92hCGZJ7sKICzOrUmSb/3RrSemelHmMJQ/ZKvhDW6xD
         vGdV1Qit/7LZZCjei2KFBcY6YM2Yrtm0ah5CVq3Rn2rfPFlHGL6kO51rwDAy7up9S5AN
         nRxmqBvX6ob442SvQ0JKhuYZvqkHXntIiLf9gLj/nbfzKDOzuGaqWFSirTxq48X22RrC
         yCUJVKzvww58vlLcWU6f+VroQH+AnBon21MH2L6PGDWDE+HD0y8sU4qkqa4Zl1MfEP+T
         mdqP+PRl3gkUNPP8MQj1I6X2HH2KGAZTRDpWkhtlZ6fRLaUyDHvE576AfHE919Onul3I
         eY7A==
X-Gm-Message-State: AAQBX9eq7HfcL3WTo0i3bn8lcsg0G6yGZAoHI8IU69E6CY/V1J4cLNUF
        WDg1g6Z1dyMJtGH5utP5K1I0gnI7mJM=
X-Google-Smtp-Source: AKy350ZlpykYBDTbMnh8Zc7cbnq84TrAxlt+o7ve/mqys3lx8wvRjCBSVzF465oCXKa02Ccfxeu3JA==
X-Received: by 2002:a17:902:e5c8:b0:19f:8bbf:9c56 with SMTP id u8-20020a170902e5c800b0019f8bbf9c56mr13752162plf.3.1679921142323;
        Mon, 27 Mar 2023 05:45:42 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com ([203.221.180.225])
        by smtp.gmail.com with ESMTPSA id ay6-20020a1709028b8600b0019a997bca5csm19053965plb.121.2023.03.27.05.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 05:45:41 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests v3 03/13] powerpc: Add some checking to exception handler install
Date:   Mon, 27 Mar 2023 22:45:10 +1000
Message-Id: <20230327124520.2707537-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230327124520.2707537-1-npiggin@gmail.com>
References: <20230327124520.2707537-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check to ensure exception handlers are not being overwritten or
invalid exception numbers are used.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
Since v2:
- New patch

 lib/powerpc/processor.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/lib/powerpc/processor.c b/lib/powerpc/processor.c
index ec85b9d..70391aa 100644
--- a/lib/powerpc/processor.c
+++ b/lib/powerpc/processor.c
@@ -19,11 +19,23 @@ static struct {
 void handle_exception(int trap, void (*func)(struct pt_regs *, void *),
 		      void * data)
 {
+	if (trap & 0xff) {
+		printf("invalid exception handler %#x\n", trap);
+		abort();
+	}
+
 	trap >>= 8;
 
 	if (trap < 16) {
+		if (func && handlers[trap].func) {
+			printf("exception handler installed twice %#x\n", trap);
+			abort();
+		}
 		handlers[trap].func = func;
 		handlers[trap].data = data;
+	} else {
+		printf("invalid exception handler %#x\n", trap);
+		abort();
 	}
 }
 
-- 
2.37.2

