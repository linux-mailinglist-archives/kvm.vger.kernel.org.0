Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 922E252DAE5
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 19:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242366AbiESRHh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 13:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242359AbiESRHg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 13:07:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 793E19BAEF
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 10:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652980054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4vk3JATkLrhXmyxuAhZSZir3knBRE83n5EH3TQyAbx0=;
        b=fPpmthfR7Ne3zsOLJ6UqIWD0+wUKF1LbyD61rIq0vv7Ft65lcEBfF6hk8QFmZopkqaaCua
        whwmZXnzlosoZOYlucv8IB3dP9VD0o3i4cHy/38MgdxVp9TpEMsMZD752EsM6HUw9KyTJN
        jhB4Qff13uZIP5LbHUyT4a9Z8EwRA40=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-exZPy_t_NjWkTJCIXYXKmA-1; Thu, 19 May 2022 13:07:31 -0400
X-MC-Unique: exZPy_t_NjWkTJCIXYXKmA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE39B3810797;
        Thu, 19 May 2022 17:07:30 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.194.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B0EFE20239E1;
        Thu, 19 May 2022 17:07:29 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com, nikos.nikoleris@arm.com
Subject: [PATCH kvm-unit-tests 2/2] lib: Add ctype.h and collect is* functions
Date:   Thu, 19 May 2022 19:07:24 +0200
Message-Id: <20220519170724.580956-3-drjones@redhat.com>
In-Reply-To: <20220519170724.580956-1-drjones@redhat.com>
References: <20220519170724.580956-1-drjones@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/argv.c   |  7 ++-----
 lib/ctype.h  | 40 ++++++++++++++++++++++++++++++++++++++++
 lib/string.c |  6 +-----
 3 files changed, 43 insertions(+), 10 deletions(-)
 create mode 100644 lib/ctype.h

diff --git a/lib/argv.c b/lib/argv.c
index 0312d74011d3..951b176ae8b1 100644
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
@@ -92,7 +89,7 @@ static char *env_next(char *env)
 	if (!*env)
 		return env;
 
-	if (isalpha(*env)) {
+	if (isalpha(*env) || *env == '_') {
 		bool invalid = false;
 
 		p = env + 1;
diff --git a/lib/ctype.h b/lib/ctype.h
new file mode 100644
index 000000000000..ce787a60cdf3
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

