Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B81416917
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 02:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243675AbhIXAxc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 20:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbhIXAxb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 20:53:31 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012A8C061574
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 17:51:59 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id m16-20020a25d410000000b005ab243aaaf4so1353025ybf.20
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 17:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=5zJLsaCyRuyfAgJHK0NO/2qjz/xHTuNLfww2cDY3wZc=;
        b=AWPrN28YZxlrkUw55d/+wP8wHc1VqClUupCBy+9GiM/x+Nmu3d463KD3yZPA+AGKS4
         KEos1TKD35+2xki4IPbD1gq20FK9NlyQl4F6OalOvpgmFucaVqqnEnO/Nc6+hSPFDmvO
         NGOn4pS9ecQpFOkPjHghU6LubyWQw9R21yZ7UvjqExL9vUupsKW+I7ebgGsgrC1ygG0A
         ZKBC5kSdiIhDyoyGY4nsXtF/Je4YlBbDwM6goAKKk3M02svEmXo1cyAVsMif84BriWvh
         p1SNaSB8qmz4z4YTdxUFt0oSK2gllk1TN5Ckcgv0YUJoLRNpozl7/OHgh3rOd8+Uu1j/
         /gIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=5zJLsaCyRuyfAgJHK0NO/2qjz/xHTuNLfww2cDY3wZc=;
        b=UtX2cC61UbHCQao9BAjHEutNc3u6n2NwjGYWChZ9YkqQZlefIJUj6wggZ+zifDWXZw
         5tKzF29r7rIe3GuzB/DKx/MJgBgs9HOkZyKiDnRQtgYrmJjehVzhI0v6JYofd+dm8KP9
         mjEzGtH7wqY1dTOU48JbcdCQ46KC1QFIpT/AY0tgE/AzsOk8El1/7K+nwGgKZg7oJ8b4
         YEeB9jncs93SW4pg0SJciRjYVrwhgzJgh3CPhjkdhTKTKG3Nl3e6G8i6kbdJTlc8LkGy
         5q86Prqf4KHM6rzwvYsjX8KLmN8KXj/2Qs6S89psvQ4ncGDWDkDnabOWCh6RGEm7bJdq
         zSvA==
X-Gm-Message-State: AOAM53269/LwZEQdtHUZBJYTtqT2oOIAkoLK2SD52jLDypbds9Elusu/
        NMd1+opL8YbMmLg7z84JI2KL06q/45WKOP1dJWE+OAopZi8JOFPq5j+oUzrcYToVaD+HC+O+y8S
        o2pU+2POPfA4GC/T8nazlp8smlBMo4pTuiTXQoyVivSmyJJUTyXIKIDjpUg==
X-Google-Smtp-Source: ABdhPJy81zEtbxA/0CCCI3JjgDOIIr45GMlPsH+JyDe1Jf+y5wmjpREvcKfTdvmwuyuZWx8UJvVAP8a0AF8=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:2e0f:: with SMTP id u15mr9845297ybu.133.1632444718119;
 Thu, 23 Sep 2021 17:51:58 -0700 (PDT)
Date:   Fri, 24 Sep 2021 00:51:47 +0000
Message-Id: <20210924005147.1122357-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH] selftests: KVM: Explicitly use movq to read xmm registers
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Compiling the KVM selftests with clang emits the following warning:

>> include/x86_64/processor.h:297:25: error: variable 'xmm0' is uninitialized when used here [-Werror,-Wuninitialized]
>>                return (unsigned long)xmm0;

where xmm0 is accessed via an uninitialized register variable.

Indeed, this is a misuse of register variables, which really should only
be used for specifying register constraints on variables passed to
inline assembly. Rather than attempting to read xmm registers via
register variables, just explicitly perform the movq from the desired
xmm register.

Fixes: 783e9e51266e ("kvm: selftests: add API testing infrastructure")
Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 34 +++++++++----------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 242ae8e09a65..eba8bd08293e 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -312,37 +312,37 @@ static inline void set_xmm(int n, unsigned long val)
 	}
 }
 
-typedef unsigned long v1di __attribute__ ((vector_size (8)));
+#define GET_XMM(__xmm)							\
+({									\
+	unsigned long __val;						\
+	asm volatile("movq %%"#__xmm", %0" : "=r"(__val) : : #__xmm);	\
+	__val;								\
+})
+
 static inline unsigned long get_xmm(int n)
 {
 	assert(n >= 0 && n <= 7);
 
-	register v1di xmm0 __asm__("%xmm0");
-	register v1di xmm1 __asm__("%xmm1");
-	register v1di xmm2 __asm__("%xmm2");
-	register v1di xmm3 __asm__("%xmm3");
-	register v1di xmm4 __asm__("%xmm4");
-	register v1di xmm5 __asm__("%xmm5");
-	register v1di xmm6 __asm__("%xmm6");
-	register v1di xmm7 __asm__("%xmm7");
 	switch (n) {
 	case 0:
-		return (unsigned long)xmm0;
+		return GET_XMM(xmm0);
 	case 1:
-		return (unsigned long)xmm1;
+		return GET_XMM(xmm1);
 	case 2:
-		return (unsigned long)xmm2;
+		return GET_XMM(xmm2);
 	case 3:
-		return (unsigned long)xmm3;
+		return GET_XMM(xmm3);
 	case 4:
-		return (unsigned long)xmm4;
+		return GET_XMM(xmm4);
 	case 5:
-		return (unsigned long)xmm5;
+		return GET_XMM(xmm5);
 	case 6:
-		return (unsigned long)xmm6;
+		return GET_XMM(xmm6);
 	case 7:
-		return (unsigned long)xmm7;
+		return GET_XMM(xmm7);
 	}
+
+	/* never reached */
 	return 0;
 }
 
-- 
2.33.0.685.g46640cef36-goog

