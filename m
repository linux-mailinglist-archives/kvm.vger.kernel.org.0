Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92DA158CC56
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 18:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242993AbiHHQrS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 12:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238062AbiHHQrP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 12:47:15 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83FE5101DA
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 09:47:14 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id m123-20020a253f81000000b0066ff6484995so7861338yba.22
        for <kvm@vger.kernel.org>; Mon, 08 Aug 2022 09:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=Wn8v/P3tNnUb1MG28HGMCGnZxpGFZ1P+4PmpRvu3+60=;
        b=nEjeczVtpBrIS8I7dvglwCKBL3jZZuyVv++eMwJIvOOqwhcZxTJdeMhM/XcD9IRDAo
         pdOIAWUZukkegFAnzq+MzGi3l3ZBRQMjSbQbqqAaVeAVuQO1CJ5UX7jM3zZ5lTP5IqSI
         l1lD7vCWzpthvO6DRJ1/A3ACLdZDPjoMiJwjYeHnHoehihsxDFyqg8+VhKQG+pLcZ8p3
         cX+XS0v/SH8KszBCIjUjFub6eQjB3gA3KVYkXKmOS14mnLjI/aQ47a6oOBmLifCwTN/T
         yikkdyrLpCVEbHlLlp6P2AVWUAxKmnOXpHm1ZOeSqIrOPBvhZmLhCSwYd6F1TlE0a4bP
         e+TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=Wn8v/P3tNnUb1MG28HGMCGnZxpGFZ1P+4PmpRvu3+60=;
        b=JUeokvDNU9N0pMgANR5MTPcGtvftVRyyrwRAb7nyqhzz0aRBLhGFepeBSRReb/Ox+d
         3/oR8Yg/ZMpmTAZ6vLiRQbxMoj+kuVpuUQoZHk9/3V/ptV+vaBnyZ2f8xg/8JZib0LtO
         72dUjBhQmpTWlyM4kWNkCBiH9JPKc3JC3fkB3KgL7iXtomGqbVevEI+9tup+ghqeN36y
         DX9cnIIne/5p88fIH7P/MbFatm5RjHGYJGglo9GMy0sg51qfHNSgFB+bL6C86lRFzf7m
         X8llysEI0QHhSj/vPqsZMhCoxiH+X4n2N56pYGbfY1fZCEkPRX+loYgtqr1vlh8+GXTo
         AGXg==
X-Gm-Message-State: ACgBeo2CTomf93pwqVpjv9BfJjoj0ebwjdggfPoyIETPN1lpFksbDC2Q
        UP+QGfG+tS/f3tASHfLnprIpY1uJoEM=
X-Google-Smtp-Source: AA6agR4d8J2XfNVnEOLARXCnMSVeMaBmq3jgzKctSOAH7bM53Umltsl8HImAaVa7keFu9YsPtZCxONfvQH0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:a20e:0:b0:322:a052:471e with SMTP id
 w14-20020a81a20e000000b00322a052471emr19210670ywg.183.1659977233843; Mon, 08
 Aug 2022 09:47:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon,  8 Aug 2022 16:47:02 +0000
In-Reply-To: <20220808164707.537067-1-seanjc@google.com>
Message-Id: <20220808164707.537067-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220808164707.537067-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [kvm-unit-tests PATCH v3 2/7] x86: Dedup 32-bit vs. 64-bit ASM_TRY()
 by stealing kernel's __ASM_SEL()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Steal the kernel's __ASM_SEL() implementation and use it to consolidate
ASM_TRY().  The only difference between the 32-bit and 64-bit versions is
the size of the address stored in the table.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/desc.h | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 2a285eb..10ba8cb 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -3,6 +3,18 @@
 
 #include <setjmp.h>
 
+#ifdef __ASSEMBLY__
+#define __ASM_FORM(x, ...)	x,## __VA_ARGS__
+#else
+#define __ASM_FORM(x, ...)	" " xstr(x,##__VA_ARGS__) " "
+#endif
+
+#ifndef __x86_64__
+#define __ASM_SEL(a,b)		__ASM_FORM(a)
+#else
+#define __ASM_SEL(a,b)		__ASM_FORM(b)
+#endif
+
 void setup_idt(void);
 void load_idt(void);
 void setup_alt_stack(void);
@@ -80,21 +92,12 @@ typedef struct  __attribute__((packed)) {
 	u16 iomap_base;
 } tss64_t;
 
-#ifdef __x86_64
-#define ASM_TRY(catch)			\
-	"movl $0, %%gs:4 \n\t"		\
-	".pushsection .data.ex \n\t"	\
-	".quad 1111f, " catch "\n\t"	\
-	".popsection \n\t"		\
+#define ASM_TRY(catch)						\
+	"movl $0, %%gs:4 \n\t"					\
+	".pushsection .data.ex \n\t"				\
+	__ASM_SEL(.long, .quad) " 1111f,  " catch "\n\t"	\
+	".popsection \n\t"					\
 	"1111:"
-#else
-#define ASM_TRY(catch)			\
-	"movl $0, %%gs:4 \n\t"		\
-	".pushsection .data.ex \n\t"	\
-	".long 1111f, " catch "\n\t"	\
-	".popsection \n\t"		\
-	"1111:"
-#endif
 
 /*
  * selector     32-bit                        64-bit
-- 
2.37.1.559.g78731f0fdb-goog

