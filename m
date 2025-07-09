Return-Path: <kvm+bounces-51933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A6C0FAFEAA1
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 15:47:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CB5337BB11E
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 13:45:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59EB118F2FC;
	Wed,  9 Jul 2025 13:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="yzeZPODo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E80B1E492
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 13:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752068832; cv=none; b=IaNybsH3YMyFeD4i77C+8H7CD2KESeDetUkRsb1mOBuLXnwKD3vZQ69FR1PTn5zwj+pUmT7LXvS5KDlpBGGqbbHV6F7OnqrSe1hJ72m/Fx9uXyROFFYKrBqAqQozxZ4K9JCtESvzVu96g9QMfTt7BluLNeXzhmBpTjJT1IYuNSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752068832; c=relaxed/simple;
	bh=hUx6IQ2FmJ3uo25F2LgfuwKeYhT/NpB72ybx3m4nraQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kY9o3yyfbiqohOK8v/2tK/bBF60DG5UNVl2xS+HHJbLxKjVo3kn/uw7gzkYKXWe0H083A8ckndUgT7V1Uoc63GuxN0eNYmioYQ05WvL2MLiduLU9jiMSoXjBriwQpXjLredtuwJDqMFT4HKjLaJGdK6Abv2A8Mdx0YxbGzHUhQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=yzeZPODo; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-7d098f7bd77so108146985a.0
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 06:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1752068829; x=1752673629; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=as6bKKqAeltmDz2NBbzQMBxQaUhQ849TT+d9T/+6Oes=;
        b=yzeZPODo6cHbvpjSLN9mQ+8zjnzvmpvjUVpGLSe6SBguKHc0Unfrz6E4p+itYZwrFQ
         gwCGB/fPPI7nEJYuT6/UTRbngi95Iioxbav+7nfyC71q9mfEzBioybujAkwFCi5qjCfl
         h9WXiPzayG7uU4fyux7iDXmC5B8xlzUGJUJj8gx/chryFYOXe73tvx7v3W1QjgUlbb7h
         owy+WNHUyJ21b+vRjykb1w96Riv+YthSDxz6bux1NkbNL/zaYlT7ZulW8LuDYrFlRbkz
         +pZumVbV7aL+BO5u1J4j/71PmBQY3sw+1pSFK7TL0E2MDrYnIARubtcNsbP23U78MonH
         TnUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752068829; x=1752673629;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=as6bKKqAeltmDz2NBbzQMBxQaUhQ849TT+d9T/+6Oes=;
        b=v3nHAVLuTRk6/lNr/5sQ2rZ0t50tdMusX16nS08870C9Ebwxx2+hni3+704jUSwCKI
         rKMxSs5AQNejoEMWAbrfVDfNUhvdVbX8bxVFSVaRlDD0UPN0W4yIIfhV+96rQtG45+UZ
         hVJ2viL2n2VI83PCE3JnG/JNdIPAttTORrdE6dM5W/udQ10Wvl5PsJ2U42c6nFnTi67w
         DoKGqBKu8y5So7WxRGWa7kcd0I+7KJRcnyZoKLt4TtgOpk1bczHpwL1IG+WKYLDqYLS0
         rUf0KNxrpQj1vpCD1XszWFGrkGF+LSXnBg1gQAn6oGMrUf8Qmhi3BdLRUJQCnQp8lYqz
         OhGA==
X-Gm-Message-State: AOJu0YwNrZY/BSEmwfNR1XJTPR9O5Fk0OEPcSC0KipBzuMS00W69ibuw
	jr1Mg3lu9lcaYw8wYfh475LK39qFbkN5gy6iJSCuptMcss6SGEftAwNV5cp4hvejA+eTbDXUX6y
	mzOSB
X-Gm-Gg: ASbGncvk17E1QO+bqy0E+/QiUlBHMidNpcyQEm4TJpH1cJIKz7VifqaxkbFMgzSuZAU
	+oHujVuft9UgMgdvn3+U8yhS+ottZd48kTzwhCFkdcvd1Hdic+cQIwDW86QQ6WMgp7DYfqLxQ0j
	leHOh57rRu+6nTEbqTzRhVGNxYokA2qwGP6KdOFjHaH7V5ckbN5TPuusLbEN3O4FwL6JiPcwZRq
	fmhUakhRXm4U6oX1gBv2Z5ysFQACeL7Errq8Wr1NT/mp//hkjHNQwmF25k5xlsP2NlgxWaY7kQ9
	XFsiPblOnjySI1sIy5NJVHVy4cNbOpfv5s/kP0uSneT+UlmHVm3SLYNqsvrR4dQGt4k+xw49kND
	Wb4f8+CtYDGD1tT34GLOBkVhjwfvxaL+IbcM9+Sd8W4ggiNBTaa0=
X-Google-Smtp-Source: AGHT+IFFOoPOK9HHuurYgBtAvAo/xFEpWH1qHEPx2DaCo05dCGJJDXDCvW7ag9Ftcb/+qbtODa7JSA==
X-Received: by 2002:a05:620a:488f:b0:7d4:5c68:cf77 with SMTP id af79cd13be357-7da1fcc4946mr1014588485a.19.1752068828837;
        Wed, 09 Jul 2025 06:47:08 -0700 (PDT)
Received: from jesse-lt.ba.rivosinc.com (pool-108-26-215-125.bstnma.fios.verizon.net. [108.26.215.125])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d5dbdb5088sm937846285a.25.2025.07.09.06.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jul 2025 06:47:08 -0700 (PDT)
From: Jesse Taube <jesse@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Jesse Taube <jesse@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	James Raphael Tiovalen <jamestiotio@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Cade Richard <cade.richard@gmail.com>
Subject: [kvm-unit-tests PATCH v3 1/2] lib: Add STR_IS_Y and STR_IS_N for checking env vars
Date: Wed,  9 Jul 2025 06:47:06 -0700
Message-ID: <20250709134707.1931882-1-jesse@rivosinc.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

the line:
(s && (*s == '1' || *s == 'y' || *s == 'Y'))
is used in a few places add a macro for it and its 'n' counterpart.

Add a copy of Linux's IS_ENABLED macro to be used in GET_ENV_OR_CONFIG.
Add GET_ENV_OR_CONFIG for CONFIG values which can be overridden by
the environment.

Signed-off-by: Jesse Taube <jesse@rivosinc.com>
---
V1 -> V2:
 - New commit
V2 -> V3:
 - Add IS_ENABLED so CONFIG_##name can be undefined
 - Change GET_ENV_OR_CONFIG to GET_CONFIG_OR_ENV
 - Fix it's to its
---
 lib/argv.h        | 38 ++++++++++++++++++++++++++++++++++++++
 lib/errata.h      |  7 ++++---
 riscv/sbi-tests.h |  3 ++-
 3 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/lib/argv.h b/lib/argv.h
index 0fa77725..111af078 100644
--- a/lib/argv.h
+++ b/lib/argv.h
@@ -14,4 +14,42 @@ extern void setup_args_progname(const char *args);
 extern void setup_env(char *env, int size);
 extern void add_setup_arg(const char *arg);
 
+/*
+ * Helper macros to use CONFIG_ options in C/CPP expressions. Note that
+ * these only work with boolean and tristate options.
+ */
+
+/*
+ * Getting something that works in C and CPP for an arg that may or may
+ * not be defined is tricky.  Here, if we have "#define CONFIG_BOOGER 1"
+ * we match on the placeholder define, insert the "0," for arg1 and generate
+ * the triplet (0, 1, 0).  Then the last step cherry picks the 2nd arg (a one).
+ * When CONFIG_BOOGER is not defined, we generate a (... 1, 0) pair, and when
+ * the last step cherry picks the 2nd arg, we get a zero.
+ */
+#define __ARG_PLACEHOLDER_1 0,
+#define __take_second_arg(__ignored, val, ...) val
+#define __is_defined(x)			___is_defined(x)
+#define ___is_defined(val)		____is_defined(__ARG_PLACEHOLDER_##val)
+#define ____is_defined(arg1_or_junk)	__take_second_arg(arg1_or_junk 1, 0)
+
+/*
+ * IS_ENABLED(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to '1', 0
+ * otherwise.
+ */
+#define IS_ENABLED(option) __is_defined(option)
+
+#define STR_IS_Y(s) (s && (*s == '1' || *s == 'y' || *s == 'Y'))
+#define STR_IS_N(s) (s && (*s == '0' || *s == 'n' || *s == 'N'))
+
+/*
+ * Get the boolean value of CONFIG_{name}
+ * which can be overridden by the {name}
+ * variable in the environment if present.
+ */
+#define GET_ENV_OR_CONFIG(name) ({				\
+	const char *genv_s = getenv(#name);			\
+	genv_s ? STR_IS_Y(genv_s) : IS_ENABLED(CONFIG_##name);	\
+})
+
 #endif
diff --git a/lib/errata.h b/lib/errata.h
index de8205d8..78007243 100644
--- a/lib/errata.h
+++ b/lib/errata.h
@@ -7,6 +7,7 @@
 #ifndef _ERRATA_H_
 #define _ERRATA_H_
 #include <libcflat.h>
+#include <argv.h>
 
 #include "config.h"
 
@@ -28,7 +29,7 @@ static inline bool errata_force(void)
 		return true;
 
 	s = getenv("ERRATA_FORCE");
-	return s && (*s == '1' || *s == 'y' || *s == 'Y');
+	return STR_IS_Y(s);
 }
 
 static inline bool errata(const char *erratum)
@@ -40,7 +41,7 @@ static inline bool errata(const char *erratum)
 
 	s = getenv(erratum);
 
-	return s && (*s == '1' || *s == 'y' || *s == 'Y');
+	return STR_IS_Y(s);
 }
 
 static inline bool errata_relaxed(const char *erratum)
@@ -52,7 +53,7 @@ static inline bool errata_relaxed(const char *erratum)
 
 	s = getenv(erratum);
 
-	return !(s && (*s == '0' || *s == 'n' || *s == 'N'));
+	return !STR_IS_N(s);
 }
 
 #endif
diff --git a/riscv/sbi-tests.h b/riscv/sbi-tests.h
index c1ebf016..4e051dca 100644
--- a/riscv/sbi-tests.h
+++ b/riscv/sbi-tests.h
@@ -37,6 +37,7 @@
 
 #ifndef __ASSEMBLER__
 #include <libcflat.h>
+#include <argv.h>
 #include <asm/sbi.h>
 
 #define __sbiret_report(kfail, ret, expected_error, expected_value,						\
@@ -94,7 +95,7 @@ static inline bool env_enabled(const char *env)
 {
 	char *s = getenv(env);
 
-	return s && (*s == '1' || *s == 'y' || *s == 'Y');
+	return STR_IS_Y(s);
 }
 
 void split_phys_addr(phys_addr_t paddr, unsigned long *hi, unsigned long *lo);
-- 
2.43.0


