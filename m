Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 362386BE96A
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 13:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbjCQMhx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 08:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjCQMhs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 08:37:48 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BC8763E5
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 05:37:06 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id bc12so4535913plb.0
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 05:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679056611;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/AACUrmAMGo0o1wCmGEVGbVl+4mMC8WBmeWeWuWQJ0Y=;
        b=mjFfOlZ8F96WpI3hvzMSdK12GHigb25umCbjPjzvfP9aFho4vWtGzUTLajEtXv5mwq
         yYCQRQHwr9TsxEMboiy9jv8SEsK+t7kRIZRfNX+qLDJP7AmjarKLC9AsknNFKVI3yFZb
         FbEjI7XgwZWSsnHqQkEZaKmvS4S7mwJNmQf3lmnDt7ccorG7PDyg7820+spFZs7sEcWO
         dUsgHOWTMDNuSiXIWQR3dSeTctH23E2B+BKdMOVqJRvGMVVHUeXBZ8wugma8/dE0bL80
         z4XoaE58R2UXdeHrTd6XdO9SZQ3xEHQeta3aULQux26cKJoB5+vl59txr6rxVFgB9Pqq
         3XhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679056611;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/AACUrmAMGo0o1wCmGEVGbVl+4mMC8WBmeWeWuWQJ0Y=;
        b=HD6WI3jGfCEBXZJtU4wbV6Hm7dpXTYGExXQJz/Pj2HtqRRPrr5uV2wFR9IFUDli9p+
         wkOA9Ydk8AyqtgM/3eV1kfjTpZ3jLfLa+T2PecYdC1KyU02pAjvnMfgSZohoi9s6uv6y
         MJx/jkQr6YCavTW6cg29Vh3nFeVR6q8l55HO2y1mtmn3dLXo3gMnAU47LmRObyqgo8Ee
         Ky7W1nvnChCxeSGagdOJ2MeOEOCsg6KuU5wjhrB14WTCQUOkcZ+2XrdbLXn5lenZLHy1
         6uwHZYBL1mAabzh9NDlxFL1J9LYNIGy4TH14Zl09OhG8zTXkFqT/nVdVCKBqxTxE2T0P
         B7vQ==
X-Gm-Message-State: AO0yUKUXF56BdGpZxCkFlBaLe/hHF7gz0DsD/ExEQZJj/wpJ/Z6A1lZV
        sg6CNpZNUYyd1/t2+ewmWYRCbkrJ6/o=
X-Google-Smtp-Source: AK7set+sRU0UVPfRE2oFtxnsyr487NYkwsRVS7PImembOt069bz92S4sX2mu13ois20T94SlQ5ZbRw==
X-Received: by 2002:a17:903:186:b0:19e:6d83:8277 with SMTP id z6-20020a170903018600b0019e6d838277mr8450576plg.51.1679056611528;
        Fri, 17 Mar 2023 05:36:51 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (121-44-69-75.tpgi.com.au. [121.44.69.75])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902b28400b001a19d4592e1sm1430990plr.282.2023.03.17.05.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 05:36:51 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH 5/7] powerpc: Indirect SPR accessor functions
Date:   Fri, 17 Mar 2023 22:36:12 +1000
Message-Id: <20230317123614.3687163-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230317123614.3687163-1-npiggin@gmail.com>
References: <20230317123614.3687163-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make overly-clever SPR accessor functions that allow a non-constant
SPR number to be specified. This will be used to restructure test
in the next change.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/sprs.c | 63 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 54 insertions(+), 9 deletions(-)

diff --git a/powerpc/sprs.c b/powerpc/sprs.c
index 45f77a5..b633ea8 100644
--- a/powerpc/sprs.c
+++ b/powerpc/sprs.c
@@ -28,21 +28,66 @@
 #include <asm/processor.h>
 #include <asm/barrier.h>
 
-#define mfspr(nr) ({ \
-	uint64_t ret; \
-	asm volatile("mfspr %0,%1" : "=r"(ret) : "i"(nr)); \
-	ret; \
-})
+/* "Indirect" mfspr/mtspr which accept a non-constant spr number */
+static uint64_t mfspr(unsigned spr)
+{
+	uint64_t tmp;
+	uint64_t ret;
+
+	asm volatile(
+"	bcl	20, 31, 1f		\n"
+"1:	mflr	%0			\n"
+"	addi	%0, %0, (2f-1b)		\n"
+"	add	%0, %0, %2		\n"
+"	mtctr	%0			\n"
+"	bctr				\n"
+"2:					\n"
+".LSPR=0				\n"
+".rept 1024				\n"
+"	mfspr	%1, .LSPR		\n"
+"	b	3f			\n"
+"	.LSPR=.LSPR+1			\n"
+".endr					\n"
+"3:					\n"
+	: "=&r"(tmp),
+	  "=r"(ret)
+	: "r"(spr*8) /* 8 bytes per 'mfspr ; b' block */
+	: "lr", "ctr");
+
+	return ret;
+}
 
-#define mtspr(nr, val) \
-	asm volatile("mtspr %0,%1" : : "i"(nr), "r"(val))
+static void mtspr(unsigned spr, uint64_t val)
+{
+	uint64_t tmp;
+
+	asm volatile(
+"	bcl	20, 31, 1f		\n"
+"1:	mflr	%0			\n"
+"	addi	%0, %0, (2f-1b)		\n"
+"	add	%0, %0, %2		\n"
+"	mtctr	%0			\n"
+"	bctr				\n"
+"2:					\n"
+".LSPR=0				\n"
+".rept 1024				\n"
+"	mtspr	.LSPR, %1		\n"
+"	b	3f			\n"
+"	.LSPR=.LSPR+1			\n"
+".endr					\n"
+"3:					\n"
+	: "=&r"(tmp)
+	: "r"(val),
+	  "r"(spr*8) /* 8 bytes per 'mfspr ; b' block */
+	: "lr", "ctr", "xer");
+}
 
 uint64_t before[1024], after[1024];
 
 /* Common SPRs for all PowerPC CPUs */
 static void set_sprs_common(uint64_t val)
 {
-	mtspr(9, val);		/* CTR */
+	// mtspr(9, val);	/* CTR */ /* Used by mfspr/mtspr */
 	// mtspr(273, val);	/* SPRG1 */  /* Used by our exception handler */
 	mtspr(274, val);	/* SPRG2 */
 	mtspr(275, val);	/* SPRG3 */
@@ -156,7 +201,7 @@ static void set_sprs(uint64_t val)
 
 static void get_sprs_common(uint64_t *v)
 {
-	v[9] = mfspr(9);	/* CTR */
+	v[9] = mfspr(9);	/* CTR */ /* Used by mfspr/mtspr */
 	// v[273] = mfspr(273);	/* SPRG1 */ /* Used by our exception handler */
 	v[274] = mfspr(274);	/* SPRG2 */
 	v[275] = mfspr(275);	/* SPRG3 */
-- 
2.37.2

