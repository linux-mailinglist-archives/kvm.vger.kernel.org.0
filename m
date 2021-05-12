Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E0837BB53
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 12:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhELKzy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 06:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbhELKzw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 06:55:52 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4216EC06175F
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 03:54:44 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id c22so6197893ejd.12
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 03:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XWgAsOmnprNK2skeWGppDbTh40fKVhmJp00QypGoM2k=;
        b=MraJAz0HI7UmqDdHOLpC69mGNLqWbEVwA0L7nKwLIS/+vXQlFGpS2+92ERofya2IO3
         32ygsxDvJRJ+Dorery3U1PUb/sNOAZIqqVSzL4j/zpGgYH4MvufElz0geWAgJ/tvmz/V
         w9ePMTRtH//TRbZ7p+mW+qZcwAiL4OwzlCVjP7WKCNKPotuM7N3L3ymwh0xjZpf8eYGQ
         Mu247fjQyAzRA686m7FAnO6YyShacqnPAFDRFelh58xMNwlAvK5CibBOLzqcnByOV1MU
         YLI4I8bKgUpteXkBOkF6jV2mLEhnYedata+o7IQADh63tzE02YvHWzxRYgWVekzsjFYL
         Ppgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=XWgAsOmnprNK2skeWGppDbTh40fKVhmJp00QypGoM2k=;
        b=CTbl8HJBUilaN/+jdiKx6Hee/e/3+pKsI6qAmw0etzesI/dq3IaJg9nHZQy/j63HTZ
         3Op5YomXgWsnUR6EzAgRfCyL/J7jTm40LVwNx7/3X9jG2++RiZxXxVKY0CBrPrilnJjm
         +CBRO7oumeqUJblZHG3iBm5WB1M+31I9FJ+uZk9N7M7QpRBhPL5c7Af5I4NNzNjLNDLv
         JtgK3pU1pw+8Eh1sxmNeXS6ZCtDNVn+soU4ZvMCAJABCzglnHPAx3u+dpVHFQ88T6jnP
         8U91zjTDFoKwm+UrToOV9+Jv+CuG2BPXR4+XXC6bh3L7IpcSOonmz+gYPtaI0NCZDcMb
         S8Kw==
X-Gm-Message-State: AOAM532qaQAKebKdXsrHJLaMZK8HpC1v3mIzRzdHUwwfLSqg4Y7UtYFv
        /4nt4II2QfgTyWzlAf8Ke2EdtzKd8AI=
X-Google-Smtp-Source: ABdhPJzigDhlUEFhg9q6amk4thrZa+of/18EGmVGYFbGF3OGaz8W5MPMklCYns/17wJN3V0j1ZleeA==
X-Received: by 2002:a17:906:1f54:: with SMTP id d20mr18427747ejk.94.1620816883017;
        Wed, 12 May 2021 03:54:43 -0700 (PDT)
Received: from avogadro.lan ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b19sm16829624edd.66.2021.05.12.03.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 03:54:42 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v2 kvm-unit-tests 1/2] libcflat: clean up and complete long division routines
Date:   Wed, 12 May 2021 12:54:39 +0200
Message-Id: <20210512105440.748153-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512105440.748153-1-pbonzini@redhat.com>
References: <20210512105440.748153-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Avoid possible uninitialized variables on machines where
division by zero does not trap.  Add __divmoddi4, and
use it in __moddi3 and __divdi3.

Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 lib/ldiv32.c | 40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/lib/ldiv32.c b/lib/ldiv32.c
index 96f4b35..897a4b9 100644
--- a/lib/ldiv32.c
+++ b/lib/ldiv32.c
@@ -1,6 +1,7 @@
 #include <stdint.h>
 
 extern uint64_t __udivmoddi4(uint64_t num, uint64_t den, uint64_t *p_rem);
+extern int64_t __divmoddi4(int64_t num, int64_t den, int64_t *p_rem);
 extern int64_t __moddi3(int64_t num, int64_t den);
 extern int64_t __divdi3(int64_t num, int64_t den);
 extern uint64_t __udivdi3(uint64_t num, uint64_t den);
@@ -11,8 +12,11 @@ uint64_t __udivmoddi4(uint64_t num, uint64_t den, uint64_t *p_rem)
 	uint64_t quot = 0;
 
 	/* Trigger a division by zero at run time (trick taken from iPXE).  */
-	if (den == 0)
+	if (den == 0) {
+		if (p_rem)
+			*p_rem = 0;
 		return 1/((unsigned)den);
+	}
 
 	if (num >= den) {
 		/* Align den to num to avoid wasting time on leftmost zero bits.  */
@@ -35,31 +39,35 @@ uint64_t __udivmoddi4(uint64_t num, uint64_t den, uint64_t *p_rem)
 	return quot;
 }
 
-int64_t __moddi3(int64_t num, int64_t den)
+int64_t __divmoddi4(int64_t num, int64_t den, int64_t *p_rem)
 {
-	uint64_t mask = num < 0 ? -1 : 0;
+	int32_t nmask = num < 0 ? -1 : 0;
+	int32_t qmask = (num ^ den) < 0 ? -1 : 0;
+	uint64_t quot;
 
 	/* Compute absolute values and do an unsigned division.  */
-	num = (num + mask) ^ mask;
+	num = (num + nmask) ^ nmask;
 	if (den < 0)
 		den = -den;
 
-	/* Copy sign of num into result.  */
-	return (__umoddi3(num, den) + mask) ^ mask;
+	/* Copy sign of num^den into quotient, sign of num into remainder.  */
+	quot = (__udivmoddi4(num, den, (uint64_t *)p_rem) + qmask) ^ qmask;
+	if (p_rem)
+		*p_rem = (*p_rem + nmask) ^ nmask;
+	return quot;
 }
 
-int64_t __divdi3(int64_t num, int64_t den)
+int64_t __moddi3(int64_t num, int64_t den)
 {
-	uint64_t mask = (num ^ den) < 0 ? -1 : 0;
-
-	/* Compute absolute values and do an unsigned division.  */
-	if (num < 0)
-		num = -num;
-	if (den < 0)
-		den = -den;
+	int64_t rem;
+	__divmoddi4(num, den, &rem);
+	return rem;
+}
 
-	/* Copy sign of num^den into result.  */
-	return (__udivdi3(num, den) + mask) ^ mask;
+int64_t __divdi3(int64_t num, int64_t den)
+{
+	int64_t rem;
+	return __divmoddi4(num, den, &rem);
 }
 
 uint64_t __udivdi3(uint64_t num, uint64_t den)
-- 
2.31.1


