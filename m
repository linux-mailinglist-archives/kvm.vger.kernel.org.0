Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90CAF55E63D
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 18:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbiF1QZF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 12:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbiF1QYM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 12:24:12 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D447D38DA7;
        Tue, 28 Jun 2022 09:16:32 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id m184so7661726wme.1;
        Tue, 28 Jun 2022 09:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GSvX+YS7FmXVa1XX+xmMWMx85Hm2iml0w72INcLJyxI=;
        b=kURz42U56nMTklnKwim8e0DW1w6XUO3/7ME4sC4E7X4wf8o4MsW9Th88aiDRnXi4D8
         tPCAjjxa1D82neRAV4cjX4fXaG6zxGNivuMZqbaTihHxN+ZJKktBUuJziEktGRSfID38
         eZOqaOdrH+1aUJ1elrpL0LIhvfkprzkhrHCuYawkXtimAzUvwydgPJdT996LA4MdhdXr
         24OQzcOwArGTTu2ply5Z/zav7fLM1zexMzue1kjnLnPHMmpOedRQ/3lK4jwQwZORHv60
         q75FyIsdSgj0Pvl+AL3YvO9Xv+iW+NsFQEEGOrJmdr7tccPO+vgPY7+48dbBhMPWTN94
         9cnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GSvX+YS7FmXVa1XX+xmMWMx85Hm2iml0w72INcLJyxI=;
        b=ujci/FQXL/Wvb6JBLW5hLyP6P+pDZ04G4m5FT2H+NIMznz+5+0LU0BhrKDVUAqrekj
         1eR2OS5TyuAcz5hGGnp7VKDnTl3/iGziX4B3pld3Sjohw2X5M4hspadAZyIAskTHl+ap
         kES0MzZEM+6qLzEtw24RT9XsNxQiIfZW5ARjNTAlT9AD8z75wrk0iz2tKMEdTRBzRYE0
         3DxSEubQXtp70P6kZ6WgAvr728oGgjEK8QWOiHXYXOBrHtO44LGRCVk7o5yjPSrMhawC
         bAGpwHQZcRF7wsslPmDhIFp0ldqJer9qYYrbX9vAaksjTboNLoKirUpGEAaA7OC2HOlJ
         FyzA==
X-Gm-Message-State: AJIora/XYz0WlOf9v5uOWTQRh0ypUYBtzvm+6PeMK2RHb2yicdm8Z7sP
        ik2YsGVzmvf16EYAEYy090I=
X-Google-Smtp-Source: AGRyM1tBskFmWe+zboNn6r3qQNFMbi8hWb6S+THu7JB4qMCZFhaT6BPdcBG+cDkQS2l4qL8aEkclyw==
X-Received: by 2002:a05:600c:510f:b0:3a0:5836:3ddb with SMTP id o15-20020a05600c510f00b003a058363ddbmr400534wms.123.1656432991281;
        Tue, 28 Jun 2022 09:16:31 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id bn24-20020a056000061800b0020fe35aec4bsm13720604wrb.70.2022.06.28.09.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 09:16:30 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH RESEND] x86/uaccess: Improve __try_cmpxchg64_user_asm for x86_32
Date:   Tue, 28 Jun 2022 18:16:12 +0200
Message-Id: <20220628161612.7993-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.35.3
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
Cc: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/uaccess.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 913e593a3b45..b0583c1da14f 100644
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
2.35.3

