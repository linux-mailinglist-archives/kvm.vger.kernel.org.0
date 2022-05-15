Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE6015279F2
	for <lists+kvm@lfdr.de>; Sun, 15 May 2022 22:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238671AbiEOUhz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 May 2022 16:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238718AbiEOUhv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 May 2022 16:37:51 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E82312AC2
        for <kvm@vger.kernel.org>; Sun, 15 May 2022 13:37:35 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id i27so25164975ejd.9
        for <kvm@vger.kernel.org>; Sun, 15 May 2022 13:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YWOWGVom/+FrvO7n7nm9/vSiGuFW7jv9JhmdO42SkKs=;
        b=bnyyLGs93LPW7PYu8GtH0m/sFvL1hwSab7WrtkU7pEi48HPngUapVQc96Zxh7SVJDr
         1Iw2v9rtTj3GvjhZ0j1jJsd6gjlFd27DTE7zjxnWOrj4CpsrLA0ryhkI/fddXW0fDL0O
         qVDTUtxSI+8mmMLPW7KWagACc2WinRsd/ax21r4XdmtlVoDmEWJCRsxUwqqvSC2v/vld
         bD+EpmJQbtn1/VcoipywucC3tDNGS0YaXKd1zmerbt1TKqJ/7q+F1lq66HCP3pAXNrBh
         SeKR5AQNzjd2EtYDch6mFthcNhmZeGAopoFB5GoGwWdDu+guZe+9dbcHXy880fcypWMv
         cOnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YWOWGVom/+FrvO7n7nm9/vSiGuFW7jv9JhmdO42SkKs=;
        b=G6YM3jVAz4IUGxMtbyxQcMCyppe95d2tzYRNk9g03wFAUNURfVsQ6Kx60EVksVmcQx
         qERK3Jdf+hXAWIyIdBqvPTPrlZzwXu37KEWEiIqyTRl2D4hX/iH1KwSdKA7jUCZd387Q
         TFJUkICkc8W2/ivA1XkVKmR2bvSbFHBQXiBJvFlUT+BG8G1lrUl8IA5sz8a37+2WS5za
         MdGnjDKHesvbFR4jhxUXu6PAv4EUwbOx9wBdf51X8BQq50cYzduijKYN0lsVwI9hg+WK
         RfGuxMxJkuYjF4VkJ8EP+Q3ojdCKsAqEuiK9xu8TQEjDjCSDuih3dT3cQcwA2GXDOADH
         UDrQ==
X-Gm-Message-State: AOAM531zeQJ/bzmJmii0WroFcnkUWqWNbmVs+C8iE4NzoiJB2NkXrMy8
        zTXlLK496hYRZUcQ+Fi23PXNnZ5Sl6A=
X-Google-Smtp-Source: ABdhPJziL6XDqPQKcMAX4vOC4lRzHRX2dasTlgKoDTFdnzA+c2jCDoVpEz12it00HQDloM4+OR4c1g==
X-Received: by 2002:a17:907:1c92:b0:6fa:51d2:4005 with SMTP id nb18-20020a1709071c9200b006fa51d24005mr12670759ejc.307.1652647053547;
        Sun, 15 May 2022 13:37:33 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id p6-20020aa7c886000000b0042ab0500495sm786471eds.36.2022.05.15.13.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 May 2022 13:37:33 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org, x86@kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] x86/uaccess: Improve __try_cmpxchg64_user_asm for x86_32
Date:   Sun, 15 May 2022 22:37:13 +0200
Message-Id: <20220515203713.635980-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.35.1
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

Improve __try_cmpxcgh64_user_asm for !CONFIG_CC_HAS_ASM_GOTO_TIED_OUTPUT
by relaxing the output register constraint from "c" to "q" constraint,
which allows the compiler to choose between %ecx or %ebx register.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/uaccess.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 35f222aa66bf..9fae2a1cc267 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -448,7 +448,7 @@ do {									\
 
 #ifdef CONFIG_X86_32
 /*
- * Unlike the normal CMPXCHG, hardcode ECX for both success/fail and error.
+ * Unlike the normal CMPXCHG, use output GPR for both success/fail and error.
  * There are only six GPRs available and four (EAX, EBX, ECX, and EDX) are
  * hardcoded by CMPXCHG8B, leaving only ESI and EDI.  If the compiler uses
  * both ESI and EDI for the memory operand, compilation will fail if the error
@@ -461,11 +461,12 @@ do {									\
 	__typeof__(*(_ptr)) __new = (_new);				\
 	asm volatile("\n"						\
 		     "1: " LOCK_PREFIX "cmpxchg8b %[ptr]\n"		\
-		     "mov $0, %%ecx\n\t"				\
-		     "setz %%cl\n"					\
+		     "mov $0, %[result]\n\t"				\
+		     "setz %b[result]\n"				\
 		     "2:\n"						\
-		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_EFAULT_REG, %%ecx) \
-		     : [result]"=c" (__result),				\
+		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_EFAULT_REG,	\
+					   %[result])			\
+		     : [result] "=q" (__result),			\
 		       "+A" (__old),					\
 		       [ptr] "+m" (*_ptr)				\
 		     : "b" ((u32)__new),				\
-- 
2.35.1

