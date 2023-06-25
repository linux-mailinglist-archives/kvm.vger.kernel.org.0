Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1860A73D529
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 01:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjFYXHy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Jun 2023 19:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjFYXHw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Jun 2023 19:07:52 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56EA111A
        for <kvm@vger.kernel.org>; Sun, 25 Jun 2023 16:07:51 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-1a998a2e7a6so2861151fac.1
        for <kvm@vger.kernel.org>; Sun, 25 Jun 2023 16:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687734470; x=1690326470;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h7oWc9wSs7s043FQcLimHSRTeXEF/XHk5/+kEWBjS/c=;
        b=pqvibM9Ffgkw4ZAQyk1xHojANTwVtiIS5hRfZMFg52S8Cg0wwSe9XF0waWvOzUZ3uH
         +A4MGphX3vZX6zIK150E+uNRBcxpaZhVJezkqQBi3N4ac9p3LUlbYV2B2Fxp+uvrp0lP
         BvKQh2YbpRUqVtN69W7HbsMqNvuuqffL3MWT0WeLNoKGbI7dgy00IjtQ1bHmggIPSKYU
         y6eEVr9b6qMWTKR2DBwoikf2tmbvBdxK/PVhIfyvfQJ0zJogEnZ6LvOto3tFlel6qsk3
         qRChWV7fbWA4uSBP7anYY924zkvKjQwNgjor+ykR3ndO6FBWl/LrW8PIuu3HnvDB9vSy
         5tJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687734470; x=1690326470;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h7oWc9wSs7s043FQcLimHSRTeXEF/XHk5/+kEWBjS/c=;
        b=ZwzMggjeIWRKJ5WmoPANC0dVK6Y3fazmCdlsC291jjQ3XrDcYQSH4SFok7ZHI8wbnP
         wJM/NcWaIwSYHgcFO8EPLLD0tF8Eg2TZqhJ4b3BuESlfeieFuRollani2px0eyhJONJI
         jOjpbSVCci+lIPW9hbjRdnLaKkw6EX2D8CZCjpW1khPeUJZx1ah1ABMM6q36hrIS7dGd
         PpTVPX/r05JBbPi0nb9YjQHAlpmEfSoruufKTwE2T+U47N0LlxqH+KX5o2mD4qFxLqrx
         3KD53NILil56QL6+gDJlVjJQj8/3gw/dRJf/DTyfrALYU1nQpZ+hXDF+4WM+X6mpfF/h
         r0Wg==
X-Gm-Message-State: AC+VfDzSCOXxWVf7oEjUaoeBaqMWul5NbLfp9zt36k5maDQrKaPIThOe
        pywYMU4mb9qaBr7MyhhXXo4=
X-Google-Smtp-Source: ACHHUZ5dqO0X8bwSvx9fSgWCyvTPMYV1XorM/j0fmfwzYYbEorfh1Fp3o54fEXtpwtHf66B12UfBkg==
X-Received: by 2002:a05:6808:285:b0:3a1:b638:9c2c with SMTP id z5-20020a056808028500b003a1b6389c2cmr7607809oic.55.1687734470386;
        Sun, 25 Jun 2023 16:07:50 -0700 (PDT)
Received: from sc9-mailhost1.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id x20-20020aa79194000000b006668f004420sm2716397pfa.148.2023.06.25.16.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jun 2023 16:07:49 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH v2 2/6] lib/stack: print base addresses on efi
Date:   Sun, 25 Jun 2023 23:07:12 +0000
Message-Id: <20230625230716.2922-3-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230625230716.2922-1-namit@vmware.com>
References: <20230625230716.2922-1-namit@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

Making sense from dumped stacks when running EFI tests is very hard due
to the relocation. Fix it by adjusting the address back to the original
address.

Introduce CONFIG_RELOC, which would be set on arm64 and on EFI configs.

Signed-off-by: Nadav Amit <namit@vmware.com>

---

v1->v2: Introduce CONFIG_RELOC to support ARM64 [Andrew]
---
 configure   |  3 +++
 lib/stack.c | 31 +++++++++++++++++++++++++++++--
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/configure b/configure
index b665f7d..8a3c8fe 100755
--- a/configure
+++ b/configure
@@ -416,6 +416,9 @@ EOF
 if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
     echo "TARGET=$target" >> config.mak
 fi
+if [ "$efi" = "y" ] || [ "$arch" = "arm64" ]; then
+    echo "CONFIG_RELOC=y" >> config.mak
+fi
 
 cat <<EOF > lib/config.h
 #ifndef _CONFIG_H_
diff --git a/lib/stack.c b/lib/stack.c
index bdb23fd..dd6bfa8 100644
--- a/lib/stack.c
+++ b/lib/stack.c
@@ -6,13 +6,38 @@
  */
 
 #include <libcflat.h>
+#include <stdbool.h>
 #include <stack.h>
 
 #define MAX_DEPTH 20
 
+#ifdef CONFIG_RELOC
+extern char _text, _etext;
+
+static bool base_address(const void *rebased_addr, unsigned long *addr)
+{
+	unsigned long ra = (unsigned long)rebased_addr;
+	unsigned long start = (unsigned long)&_text;
+	unsigned long end = (unsigned long)&_etext;
+
+	if (ra < start || ra >= end)
+		return false;
+
+	*addr = ra - start;
+	return true;
+}
+#else
+static bool base_address(const void *rebased_addr, unsigned long *addr)
+{
+	*addr = (unsigned long)rebased_addr;
+	return true;
+}
+#endif
+
 static void print_stack(const void **return_addrs, int depth,
 			bool top_is_return_address)
 {
+	unsigned long addr;
 	int i = 0;
 
 	printf("\tSTACK:");
@@ -20,12 +45,14 @@ static void print_stack(const void **return_addrs, int depth,
 	/* @addr indicates a non-return address, as expected by the stack
 	 * pretty printer script. */
 	if (depth > 0 && !top_is_return_address) {
-		printf(" @%lx", (unsigned long) return_addrs[0]);
+		if (base_address(return_addrs[0], &addr))
+			printf(" @%lx", addr);
 		i++;
 	}
 
 	for (; i < depth; i++) {
-		printf(" %lx", (unsigned long) return_addrs[i]);
+		if (base_address(return_addrs[i], &addr))
+			printf(" %lx", addr);
 	}
 	printf("\n");
 }
-- 
2.34.1

