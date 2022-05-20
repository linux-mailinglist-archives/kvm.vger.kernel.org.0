Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3C752ED08
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 15:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349769AbiETNYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 09:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349729AbiETNYW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 09:24:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4EDC914A246
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 06:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653053059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0n8Km5qwGblBje4LgPiwmYschJacvJ2NWC8xCL4T6yM=;
        b=T7lj50yO+skCjcC3q7+K7wX19CjqcBxjti+qxNmQa7PEKPSIv2VQy5owhGaOy8t2z3p1HA
        PU01V1ivEsavvgPeFkJYFqDcZq165DH2CPvOosfCLP69hJ/uMgRxm1cBXhEWFxSZajeHEd
        xm2IQbNor6uccZuy/EIVCEu3yUT5PnE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-410-cAWYTcefPHqmehaMkUtNvA-1; Fri, 20 May 2022 09:24:10 -0400
X-MC-Unique: cAWYTcefPHqmehaMkUtNvA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5FC1485A5BB;
        Fri, 20 May 2022 13:24:10 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.194.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 106CA40D2820;
        Fri, 20 May 2022 13:24:08 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com, nikos.nikoleris@arm.com
Subject: [PATCH kvm-unit-tests v2 2/2] lib: Add ctype.h and collect is* functions
Date:   Fri, 20 May 2022 15:24:04 +0200
Message-Id: <20220520132404.700626-3-drjones@redhat.com>
In-Reply-To: <20220520132404.700626-1-drjones@redhat.com>
References: <20220520132404.700626-1-drjones@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We've been slowly adding ctype functions to different files without
even exporting them. Let's change that.

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/argv.c   |  9 +++------
 lib/ctype.h  | 40 ++++++++++++++++++++++++++++++++++++++++
 lib/string.c |  6 +-----
 3 files changed, 44 insertions(+), 11 deletions(-)
 create mode 100644 lib/ctype.h

diff --git a/lib/argv.c b/lib/argv.c
index 0312d74011d3..9ffa673ef3a1 100644
--- a/lib/argv.c
+++ b/lib/argv.c
@@ -6,6 +6,7 @@
  */
 
 #include "libcflat.h"
+#include "ctype.h"
 #include "argv.h"
 #include "auxinfo.h"
 
@@ -19,10 +20,6 @@ char **environ = __environ;
 static char args_copy[1000];
 static char *copy_ptr = args_copy;
 
-#define isblank(c) ((c) == ' ' || (c) == '\t')
-#define isalpha(c) (((c) >= 'A' && (c) <= 'Z') || ((c) >= 'a' && (c) <= 'z') || (c) == '_')
-#define isalnum(c) (isalpha(c) || ((c) >= '0' && (c) <= '9'))
-
 static const char *skip_blanks(const char *p)
 {
 	while (isblank(*p))
@@ -92,12 +89,12 @@ static char *env_next(char *env)
 	if (!*env)
 		return env;
 
-	if (isalpha(*env)) {
+	if (isalpha(*env) || *env == '_') {
 		bool invalid = false;
 
 		p = env + 1;
 		while (*p && *p != '=' && *p != '\n') {
-			if (!isalnum(*p))
+			if (!(isalnum(*p) || *p == '_'))
 				invalid = true;
 			++p;
 		}
diff --git a/lib/ctype.h b/lib/ctype.h
new file mode 100644
index 000000000000..0b43d626478a
--- /dev/null
+++ b/lib/ctype.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _CTYPE_H_
+#define _CTYPE_H_
+
+static inline int isblank(int c)
+{
+	return c == ' ' || c == '\t';
+}
+
+static inline int islower(int c)
+{
+	return c >= 'a' && c <= 'z';
+}
+
+static inline int isupper(int c)
+{
+	return c >= 'A' && c <= 'Z';
+}
+
+static inline int isalpha(int c)
+{
+	return isupper(c) || islower(c);
+}
+
+static inline int isdigit(int c)
+{
+	return c >= '0' && c <= '9';
+}
+
+static inline int isalnum(int c)
+{
+	return isalpha(c) || isdigit(c);
+}
+
+static inline int isspace(int c)
+{
+        return c == ' ' || c == '\t' || c == '\r' || c == '\n' || c == '\v' || c == '\f';
+}
+
+#endif /* _CTYPE_H_ */
diff --git a/lib/string.c b/lib/string.c
index a3a8f3b1ce0b..6d8a6380db92 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -6,6 +6,7 @@
  */
 
 #include "libcflat.h"
+#include "ctype.h"
 #include "stdlib.h"
 #include "linux/compiler.h"
 
@@ -163,11 +164,6 @@ void *memchr(const void *s, int c, size_t n)
 	return NULL;
 }
 
-static int isspace(int c)
-{
-	return c == ' ' || c == '\t' || c == '\r' || c == '\n' || c == '\v' || c == '\f';
-}
-
 static unsigned long long __strtoll(const char *nptr, char **endptr,
 				    int base, bool is_signed, bool is_longlong)
 {
-- 
2.34.3

