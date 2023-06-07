Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8243727054
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 23:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236084AbjFGVKZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 17:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236356AbjFGVKI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 17:10:08 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6325B92
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 14:10:07 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bb39316a68eso4355987276.0
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 14:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686172206; x=1688764206;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jkfrnrlT42d2fYT66skdjGu6Lu9lNrxEOk95LhfaH84=;
        b=IPB4blNRYY075PC7J0YBrdWL2lXspHuJXg9+Y01J6d0jV9pTFd5eKfxwgxjeJOeZG2
         mOUp6E4xGffP2L7TdeJ6bIVL7rS9EIme05JZjAm0C+byWnq8UzsT3+KYNJVkQv2HyHw5
         MPCzMLRCFA3Wjzb8cKcbRbKtlQlvf97ZD1/RrXwF9PbOShKL12J/mPBa/Pp6xTt5JZ7x
         N+EqMmkul7qprl9vPgMEzyRaEAgGuwqGWCwayY9ROO5TIKDuxDfjg2TKWDJJYCyAWlle
         CcAsHggz16EALp9Wwz1usU5KOuVOvfetLK17cIjp8JbVyJ06ro7chvUTin3vRyJLD02j
         ohMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686172206; x=1688764206;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jkfrnrlT42d2fYT66skdjGu6Lu9lNrxEOk95LhfaH84=;
        b=a8x4OEHGFGtp/9reh6FoXFpl9WEtSyzXXYwK0hS1vfHyt3RFVDmQsFpm9ywDMl/1n+
         BjJeZfIfWJdrhpR5xuX5d1c2n88VCLycZ4xxNgY6xIkiUrzM2uPOi/hldv7AS7Owt1D1
         QQyc0lvxpTPEn/jW5DjVd2iEF75fB+rPK0skLeGepZJNvKYT7ow+dlL0SzncFxg9W3cy
         0asb2RetzWUfGF3LNfw6mMQQF3iNoDU+WGMqHETDarCUJtf8pa+qFs5GKhgCXK0H54hL
         GCc/DIpHlD9nYCXUW29vD6qPQRd6ri2jWy2Ih4/JdKuUUcWIzMw3nQjXOrQEO8e6tAk2
         H5yw==
X-Gm-Message-State: AC+VfDyn5m1162LO+EdA/da2C4LwgK0PIlnunuafI0Am5lJh17hY2Xge
        iHipSNvXrDJKOaLaaQmkyxkJHcKRoWI=
X-Google-Smtp-Source: ACHHUZ4CynGRBgwVfY7TGpUU6m4gYebJ0k3GI6T9+hTPnX5SABJxER6A7Penk+qispTPswWJWKaHT7isabI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100c:b0:bad:14ac:f22e with SMTP id
 w12-20020a056902100c00b00bad14acf22emr2464416ybt.5.1686172206649; Wed, 07 Jun
 2023 14:10:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  7 Jun 2023 14:09:55 -0700
In-Reply-To: <20230607210959.1577847-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230607210959.1577847-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230607210959.1577847-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 2/6] lib: Expose a subset of VMX's assertion macros
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Expose VMX's TEST_EXPECT_EQ() macros so that they can be used outside of
x86's nested VMX tests, e.g. in x86's nested SVM tests.  Leave the "full"
assert macros in vmx.h, as gracfeully bailing from an arbitrary point in a
test requires additional infrastructure, e.g. to do setjmp() and longjmp().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/util.h | 31 +++++++++++++++++++++++++++++++
 x86/vmx.h  | 32 +++-----------------------------
 2 files changed, 34 insertions(+), 29 deletions(-)

diff --git a/lib/util.h b/lib/util.h
index 4c4b4413..f86af6d3 100644
--- a/lib/util.h
+++ b/lib/util.h
@@ -20,4 +20,35 @@
  */
 extern int parse_keyval(char *s, long *val);
 
+#define __TEST_EQ(a, b, a_str, b_str, assertion, do_abort, fmt, args...)		\
+do {											\
+	typeof(a) _a = a;								\
+	typeof(b) _b = b;								\
+	if (_a != _b) {									\
+		char _bin_a[BINSTR_SZ];							\
+		char _bin_b[BINSTR_SZ];							\
+		binstr(_a, _bin_a);							\
+		binstr(_b, _bin_b);							\
+		report_fail("%s:%d: %s failed: (%s) == (%s)\n"				\
+			    "\tLHS: %#018lx - %s - %lu\n"				\
+			    "\tRHS: %#018lx - %s - %lu%s" fmt,				\
+			    __FILE__, __LINE__,						\
+			    assertion ? "Assertion" : "Expectation", a_str, b_str,	\
+			    (unsigned long) _a, _bin_a, (unsigned long) _a,		\
+			    (unsigned long) _b, _bin_b, (unsigned long) _b,		\
+			    fmt[0] == '\0' ? "" : "\n", ## args);			\
+		dump_stack();								\
+		if (assertion)								\
+			do_abort();							\
+	}										\
+	report_passed();								\
+} while (0)
+
+/* FIXME: Extend VMX's assert/abort framework to SVM and other environs. */
+static inline void dummy_abort(void) {}
+
+#define TEST_EXPECT_EQ(a, b) __TEST_EQ(a, b, #a, #b, 0, dummy_abort, "")
+#define TEST_EXPECT_EQ_MSG(a, b, fmt, args...) \
+	__TEST_EQ(a, b, #a, #b, 0, dummy_abort fmt, ## args)
+
 #endif
diff --git a/x86/vmx.h b/x86/vmx.h
index 604c78f6..bc61a586 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -4,6 +4,7 @@
 #include "libcflat.h"
 #include "processor.h"
 #include "bitops.h"
+#include "util.h"
 #include "asm/page.h"
 #include "asm/io.h"
 
@@ -36,36 +37,9 @@ do {								\
 	report_passed();					\
 } while (0)
 
-#define __TEST_EQ(a, b, a_str, b_str, assertion, fmt, args...)	\
-do {								\
-	typeof(a) _a = a;					\
-	typeof(b) _b = b;					\
-	if (_a != _b) {						\
-		char _bin_a[BINSTR_SZ];				\
-		char _bin_b[BINSTR_SZ];				\
-		binstr(_a, _bin_a);				\
-		binstr(_b, _bin_b);				\
-		report_fail("%s:%d: %s failed: (%s) == (%s)\n"	\
-			    "\tLHS: %#018lx - %s - %lu\n"	\
-			    "\tRHS: %#018lx - %s - %lu%s" fmt,	\
-			    __FILE__, __LINE__,			\
-			    assertion ? "Assertion" : "Expectation", a_str, b_str,	\
-			    (unsigned long) _a, _bin_a, (unsigned long) _a,		\
-			    (unsigned long) _b, _bin_b, (unsigned long) _b,		\
-			    fmt[0] == '\0' ? "" : "\n", ## args);			\
-		dump_stack();					\
-		if (assertion)					\
-			__abort_test();				\
-	}							\
-	report_passed();					\
-} while (0)
-
-#define TEST_ASSERT_EQ(a, b) __TEST_EQ(a, b, #a, #b, 1, "")
+#define TEST_ASSERT_EQ(a, b) __TEST_EQ(a, b, #a, #b, 1, __abort_test, "")
 #define TEST_ASSERT_EQ_MSG(a, b, fmt, args...) \
-	__TEST_EQ(a, b, #a, #b, 1, fmt, ## args)
-#define TEST_EXPECT_EQ(a, b) __TEST_EQ(a, b, #a, #b, 0, "")
-#define TEST_EXPECT_EQ_MSG(a, b, fmt, args...) \
-	__TEST_EQ(a, b, #a, #b, 0, fmt, ## args)
+	__TEST_EQ(a, b, #a, #b, 1, __abort_test, fmt, ## args)
 
 struct vmcs_hdr {
 	u32 revision_id:31;
-- 
2.41.0.162.gfafddb0af9-goog

