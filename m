Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA51C6A675B
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 06:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjCAFey (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 00:34:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjCAFeu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 00:34:50 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57C832CDF
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 21:34:48 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-536c039f859so262085417b3.21
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 21:34:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677648888;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vuFdvY4jDZFH/7IewN0M02e7qpIZ5TbUelNV+nNNUX8=;
        b=Op3SxeqvDXwRWHPc9iCbYi7VSiR0ECKgf8hfGcboTmuZ7R3yoH3PULdCyoTRHkYfc6
         +SEZnXu86rmrL8WYLohTj5+7ks81G1iDP222ve+lZj4++aXxeHOtRjYGC9aY1e6RTAN0
         Vr6eLwVfn+Hoj7FKUaGi0ok5e5ymAsriWP36elWvNDqra40G5Y3vCzQ6Amdpk38eNrZq
         Qdc8IvXrKJMBg08jkcSflpI7jFbaK1sR8P7AVQqQWYVwGsegHJrs3XBtu7Oi/3I9GJlE
         NXjfWuRuKVYlweK/uyEd+De0BNfoz50o2yXZ5zRqtkeIDR5+BHx1m6fRLnw7S9rjzOfk
         +Lag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677648888;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vuFdvY4jDZFH/7IewN0M02e7qpIZ5TbUelNV+nNNUX8=;
        b=utR6yej5izqYeVTGawI05YNpXruIYMaRghqlFqN8eMaCp6ghETMBfQhix3ZGg7LjZZ
         z0EV3jc8H0sLrwWvvFA3NZS4KMCjbTmfhiMfv5f2dqpFFXSOMrATo1IRF5uzG10cx0Sr
         ClmpY8hEzhxP0OApjQ7Yx8Fy2lXNI26jiIrCB10Hx/xnsSfI+aLKwCY4l3cQRqRYk+oU
         eJIGhCkKT0pVlRFjmbkkO6IUqf3sSwtI0YI2dvE0fpZd2LDZfYWWYDs45cVYCfKCRABl
         VKLldLTD3BQl8qAnqRxTx/g+fSD5eMOG79v2InVIvw6KlwZCOHEZUSTnqq4AH5+dLCFm
         9FLA==
X-Gm-Message-State: AO0yUKVCOJovjaYiw1h8owEZnfojgvFaY7Kb2pIZIUYNEmG2eih8YvX5
        uY3a7Goevks99YpnPdUnFwDYb3D6mPgzn4/JIAFUH1v3iRCtoMFnE+4ky2zVclLKV7UY1uz2Fmq
        o8gD0Irx0AqAtTa3Cg2W0aALVKRinIYiLuWH8Laux9aWXnvxDxxEmmw6Q83jO5m6x+YYi
X-Google-Smtp-Source: AK7set+TBpJWgoq5oaWUnsK9cKAX2XQF2nlG/hEYwWQYJjguhkxPB2nO2w2bMDuQDn5R28HADgFqzYZk6zb0Zrn/
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a05:6902:4c2:b0:8ea:3d09:b125 with SMTP
 id v2-20020a05690204c200b008ea3d09b125mr2370302ybs.0.1677648887733; Tue, 28
 Feb 2023 21:34:47 -0800 (PST)
Date:   Wed,  1 Mar 2023 05:34:22 +0000
In-Reply-To: <20230301053425.3880773-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230301053425.3880773-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230301053425.3880773-6-aaronlewis@google.com>
Subject: [PATCH 5/8] KVM: selftests: Add vsprintf() to KVM selftests
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add string formatting support to the guest by adding a local version
of vsprintf with no dependencies on LIBC.

There were some minor fix-ups needed to get it compiling in selftests:
 - isdigit() was added as a local helper.
 - boot.h was switch for test_util.h.
 - printf and sprintf were removed.  Support for printing will go
   through the ucall framework.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../testing/selftests/kvm/include/test_util.h |  2 ++
 tools/testing/selftests/kvm/lib/printf.c      | 33 ++++---------------
 3 files changed, 9 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index cda631f10526..ce577b564616 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -23,6 +23,7 @@ LIBKVM += lib/guest_modes.c
 LIBKVM += lib/io.c
 LIBKVM += lib/kvm_util.c
 LIBKVM += lib/memstress.c
+LIBKVM += lib/printf.c
 LIBKVM += lib/rbtree.c
 LIBKVM += lib/sparsebit.c
 LIBKVM += lib/test_util.c
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index 80d6416f3012..261852598a4a 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -177,4 +177,6 @@ static inline uint32_t atoi_non_negative(const char *name, const char *num_str)
 	return num;
 }
 
+int vsprintf(char *buf, const char *fmt, va_list args);
+
 #endif /* SELFTEST_KVM_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/printf.c b/tools/testing/selftests/kvm/lib/printf.c
index 1237beeb9540..d356e55cbc28 100644
--- a/tools/testing/selftests/kvm/lib/printf.c
+++ b/tools/testing/selftests/kvm/lib/printf.c
@@ -13,7 +13,12 @@
  *
  */
 
-#include "boot.h"
+#include "test_util.h"
+
+int isdigit(int ch)
+{
+	return (ch >= '0') && (ch <= '9');
+}
 
 static int skip_atoi(const char **s)
 {
@@ -279,29 +284,3 @@ int vsprintf(char *buf, const char *fmt, va_list args)
 	*str = '\0';
 	return str - buf;
 }
-
-int sprintf(char *buf, const char *fmt, ...)
-{
-	va_list args;
-	int i;
-
-	va_start(args, fmt);
-	i = vsprintf(buf, fmt, args);
-	va_end(args);
-	return i;
-}
-
-int printf(const char *fmt, ...)
-{
-	char printf_buf[1024];
-	va_list args;
-	int printed;
-
-	va_start(args, fmt);
-	printed = vsprintf(printf_buf, fmt, args);
-	va_end(args);
-
-	puts(printf_buf);
-
-	return printed;
-}
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

