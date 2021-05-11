Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F02037AD39
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 19:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbhEKRmR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 13:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbhEKRmR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 13:42:17 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C416C06174A
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 10:41:09 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id b25so30948502eju.5
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 10:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QcFKWwsZQjmPduID1brcOmkZRMBIxn7KkXSMhmWfN84=;
        b=bnraoL6UQxTGs4ccEMEF6UJp8+3or2YhhuY9sJ66zaHkd+NSFHpVnfIm+YKpgHYp47
         3bRuYeZqAo4y6moDMtHfbd4voPJE0BgJlZmV6qxjEkBeT2gsw0EUCTixHOobrkIAcJdH
         beuoI1/oneZB8ZNK6w2wGnkDbrMTeJj0oBWDabaQ3JjH55ZkTRy35cq4tMEftXcicJ/A
         W2Xuuzj/lSJ+Usst8riFY4snpfv+rdpamWKfnQsJ9XkUtyPRVDymjp1ws7Y4HIt+fkAz
         YXwFrGM4GtWNUXE7fRq8GQrXzLtt/tAv22E0vDz26eBJB7P5xno79MHxejqfGms73+Cm
         bC7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=QcFKWwsZQjmPduID1brcOmkZRMBIxn7KkXSMhmWfN84=;
        b=bNIx6QIb1fc24xWv12n5Nlj18RlsouC9JpKrywUCYl2FE6l57Uzf0PtYijpePUqR2f
         HIhQ5KJ/kKGPlV2MMgvhNLFQQyeb/MStBkYxYCEk9WAf3Jjz7VHSo7kY/DX4vlnAU5Yg
         lP3Xryo/cr9AO0LRqDvI5Pf6QVXR3crWN/7jMGSxiMMHagGCk7GU2VwzvKD5OOG7j9Un
         DyGSWBvX7/ezuH2h8UsbiwPL3ilm2ge4GJ6UYLC3NLDtbr3pwEAoF1pxBltldQbtZyuM
         oN40Kc0f9KRIFCf6AY85RSWzDYnYQdydf7skdTMULahQyrWH/Ro3Z1xDoBnfGBQVH5RL
         skUw==
X-Gm-Message-State: AOAM533e3EHnTH3x19gpusfMvH+IupYTbcjPhWwTKp1vdueAcyf/9H76
        txe6QsoySOSlimZs6JGKowJbyfOsoPI=
X-Google-Smtp-Source: ABdhPJyov//rnOwePuVhx2EJdtjgAHk2hf/dp+DSDTXoeSvudhZW0deiDLdm45SWhAeQSowrdo2WWA==
X-Received: by 2002:a17:906:3544:: with SMTP id s4mr33548521eja.73.1620754868231;
        Tue, 11 May 2021 10:41:08 -0700 (PDT)
Received: from avogadro.redhat.com ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v23sm15239073eda.8.2021.05.11.10.41.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 10:41:07 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvm-unit-tests 1/2] libcflat: clean up and complete long division routines
Date:   Tue, 11 May 2021 19:41:05 +0200
Message-Id: <20210511174106.703235-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210511174106.703235-1-pbonzini@redhat.com>
References: <20210511174106.703235-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Avoid possible uninitialized variables on machines where
division by zero does not trap.  Add __divmoddi4, and
do not use 64-bit math unnecessarily in __moddi3 and __divdi3.

Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 lib/ldiv32.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/lib/ldiv32.c b/lib/ldiv32.c
index 96f4b35..c39fccd 100644
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
@@ -35,9 +39,27 @@ uint64_t __udivmoddi4(uint64_t num, uint64_t den, uint64_t *p_rem)
 	return quot;
 }
 
+int64_t __divmoddi4(int64_t num, int64_t den, int64_t *p_rem)
+{
+	int32_t nmask = num < 0 ? -1 : 0;
+	int32_t qmask = (num ^ den) < 0 ? -1 : 0;
+	uint64_t quot;
+
+	/* Compute absolute values and do an unsigned division.  */
+	num = (num + nmask) ^ nmask;
+	if (den < 0)
+		den = -den;
+
+	/* Copy sign of num^den into quotient, sign of num into remainder.  */
+	quot = (__divmoddi4(num, den, p_rem) + qmask) ^ qmask;
+	if (p_rem)
+		*p_rem = (*p_rem + nmask) ^ nmask;
+	return quot;
+}
+
 int64_t __moddi3(int64_t num, int64_t den)
 {
-	uint64_t mask = num < 0 ? -1 : 0;
+	int32_t mask = num < 0 ? -1 : 0;
 
 	/* Compute absolute values and do an unsigned division.  */
 	num = (num + mask) ^ mask;
@@ -50,7 +72,7 @@ int64_t __moddi3(int64_t num, int64_t den)
 
 int64_t __divdi3(int64_t num, int64_t den)
 {
-	uint64_t mask = (num ^ den) < 0 ? -1 : 0;
+	int32_t mask = (num ^ den) < 0 ? -1 : 0;
 
 	/* Compute absolute values and do an unsigned division.  */
 	if (num < 0)
-- 
2.31.1


