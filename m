Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845E645D2C0
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 03:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350473AbhKYCDM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:03:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353033AbhKYCBJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:01:09 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D435C0619DD
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:36 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id h2-20020a632102000000b003210bade52bso1453668pgh.9
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=5vSVPBigmNIme2AkNVboa6ak5Pq0W7IDtNkaUSwN8Oc=;
        b=Nr2lWnaI/rOy6NvALh7DRRS2Hn66IhQ/9vpSjT5p4I/ZD54dxghJKWAGy1JVNa0bA6
         4OyjVYAZDQYgpmzKjGviMsoGJV//YkwLobiQD0drZAdAYUPNdpIzdBuji80TI2lKOupH
         TBUD9jBR2Lm9tGYl8lk/WBZulYQJHUScXj66QGP9SBBy3byEEIaGwZU66naJkJvpeyBZ
         nPJx+RLzAp2MMqu6ybtC87fzwyi3r0KkeM1Gz9e44ZBIbSgJSF6zTdFJL6maaMLZEDYr
         AnD1aE3MnRAyYhyLtvp6YtP/4In/8enh7qBroPwP9o4XfJsKrPnl/hy7HW+QkTcyoYDV
         WyYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=5vSVPBigmNIme2AkNVboa6ak5Pq0W7IDtNkaUSwN8Oc=;
        b=s/1nljjxbpSgTXrvOp8hjMiV9hkpLJ0eGizxs5qPHWvbWOf5YOzcd9V14f3w2o2Lmb
         dPclVgkWhEUna9+BU14hJRBWujkiI9xeJG1FfS1cxq4+PtaMN1+RoOvv4E5gEqkPAGy7
         5UxOvyxghSlwqHUpfbkhDNtsDud0X+Z5fNT/rfTvBWpjOWKwzbDM6nyQ3u1m+jIirRXH
         8ZlUTat91xxkV/sD1Ed0M2X3GvKJZmWCB+2mMFhOZGOqkmZhDqcfY2VBRglPEbMggHkj
         rUXBpJMel3us4TeIBiSDZT8dzXQJwNcMh8Rae/8YqKlt0EqWBXQ9jpiECSj5BPM+fjZ8
         arZg==
X-Gm-Message-State: AOAM5323dEC550ag+sOcUsUYmpte/u9QJaHTO0mmV5+3nPcXKRd/UC1r
        27f4LaLJjMQNCNGfBGYvoQd+SKi8GAI=
X-Google-Smtp-Source: ABdhPJz0rHqJiNdxP4CJ8bB0XdKQstiOrkmAd2OxRaYdk2TOPjO+pF931y2C9kjUE6DglgE29TbRuvvs1Zo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:93c4:0:b0:49f:a7f5:7f5a with SMTP id
 y4-20020aa793c4000000b0049fa7f57f5amr11169901pff.8.1637803775956; Wed, 24 Nov
 2021 17:29:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:40 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-23-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 22/39] nVMX: Hoist assert macros to the top of vmx.h
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move VMX's assert macros to the top of vmx.h so that they can be used in
inlined helpers.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx.h | 110 +++++++++++++++++++++++++++---------------------------
 1 file changed, 55 insertions(+), 55 deletions(-)

diff --git a/x86/vmx.h b/x86/vmx.h
index 472b28a..c1a8f6a 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -7,6 +7,61 @@
 #include "asm/page.h"
 #include "asm/io.h"
 
+void __abort_test(void);
+
+#define TEST_ASSERT(cond)					\
+do {								\
+	if (!(cond)) {						\
+		report_fail("%s:%d: Assertion failed: %s",	\
+			    __FILE__, __LINE__, #cond);		\
+		dump_stack();					\
+		__abort_test();					\
+	}							\
+	report_passed();					\
+} while (0)
+
+#define TEST_ASSERT_MSG(cond, fmt, args...)			\
+do {								\
+	if (!(cond)) {						\
+		report_fail("%s:%d: Assertion failed: %s\n" fmt,\
+			    __FILE__, __LINE__, #cond, ##args);	\
+		dump_stack();					\
+		__abort_test();					\
+	}							\
+	report_passed();					\
+} while (0)
+
+#define __TEST_EQ(a, b, a_str, b_str, assertion, fmt, args...)	\
+do {								\
+	typeof(a) _a = a;					\
+	typeof(b) _b = b;					\
+	if (_a != _b) {						\
+		char _bin_a[BINSTR_SZ];				\
+		char _bin_b[BINSTR_SZ];				\
+		binstr(_a, _bin_a);				\
+		binstr(_b, _bin_b);				\
+		report_fail("%s:%d: %s failed: (%s) == (%s)\n"	\
+			    "\tLHS: %#018lx - %s - %lu\n"	\
+			    "\tRHS: %#018lx - %s - %lu%s" fmt,	\
+			    __FILE__, __LINE__,			\
+			    assertion ? "Assertion" : "Expectation", a_str, b_str,	\
+			    (unsigned long) _a, _bin_a, (unsigned long) _a,		\
+			    (unsigned long) _b, _bin_b, (unsigned long) _b,		\
+			    fmt[0] == '\0' ? "" : "\n", ## args);			\
+		dump_stack();					\
+		if (assertion)					\
+			__abort_test();				\
+	}							\
+	report_passed();					\
+} while (0)
+
+#define TEST_ASSERT_EQ(a, b) __TEST_EQ(a, b, #a, #b, 1, "")
+#define TEST_ASSERT_EQ_MSG(a, b, fmt, args...) \
+	__TEST_EQ(a, b, #a, #b, 1, fmt, ## args)
+#define TEST_EXPECT_EQ(a, b) __TEST_EQ(a, b, #a, #b, 0, "")
+#define TEST_EXPECT_EQ_MSG(a, b, fmt, args...) \
+	__TEST_EQ(a, b, #a, #b, 0, fmt, ## args)
+
 struct vmcs_hdr {
 	u32 revision_id:31;
 	u32 shadow_vmcs:1;
@@ -926,59 +981,4 @@ void test_set_guest(test_guest_func func);
 void test_add_teardown(test_teardown_func func, void *data);
 void test_skip(const char *msg);
 
-void __abort_test(void);
-
-#define TEST_ASSERT(cond) \
-do { \
-	if (!(cond)) { \
-		report_fail("%s:%d: Assertion failed: %s", \
-			    __FILE__, __LINE__, #cond); \
-		dump_stack(); \
-		__abort_test(); \
-	} \
-	report_passed(); \
-} while (0)
-
-#define TEST_ASSERT_MSG(cond, fmt, args...) \
-do { \
-	if (!(cond)) { \
-		report_fail("%s:%d: Assertion failed: %s\n" fmt, \
-			    __FILE__, __LINE__, #cond, ##args); \
-		dump_stack(); \
-		__abort_test(); \
-	} \
-	report_passed(); \
-} while (0)
-
-#define __TEST_EQ(a, b, a_str, b_str, assertion, fmt, args...) \
-do { \
-	typeof(a) _a = a; \
-	typeof(b) _b = b; \
-	if (_a != _b) { \
-		char _bin_a[BINSTR_SZ]; \
-		char _bin_b[BINSTR_SZ]; \
-		binstr(_a, _bin_a); \
-		binstr(_b, _bin_b); \
-		report_fail("%s:%d: %s failed: (%s) == (%s)\n" \
-			    "\tLHS: %#018lx - %s - %lu\n" \
-			    "\tRHS: %#018lx - %s - %lu%s" fmt, \
-			    __FILE__, __LINE__, \
-			    assertion ? "Assertion" : "Expectation", a_str, b_str, \
-			    (unsigned long) _a, _bin_a, (unsigned long) _a, \
-			    (unsigned long) _b, _bin_b, (unsigned long) _b, \
-			    fmt[0] == '\0' ? "" : "\n", ## args); \
-		dump_stack(); \
-		if (assertion) \
-			__abort_test(); \
-	} \
-	report_passed(); \
-} while (0)
-
-#define TEST_ASSERT_EQ(a, b) __TEST_EQ(a, b, #a, #b, 1, "")
-#define TEST_ASSERT_EQ_MSG(a, b, fmt, args...) \
-	__TEST_EQ(a, b, #a, #b, 1, fmt, ## args)
-#define TEST_EXPECT_EQ(a, b) __TEST_EQ(a, b, #a, #b, 0, "")
-#define TEST_EXPECT_EQ_MSG(a, b, fmt, args...) \
-	__TEST_EQ(a, b, #a, #b, 0, fmt, ## args)
-
 #endif
-- 
2.34.0.rc2.393.gf8c9666880-goog

