Return-Path: <kvm+bounces-51791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 704F4AFCF9F
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 17:48:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 273DB1BC7ECF
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 15:49:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A46A2E11D7;
	Tue,  8 Jul 2025 15:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="d2HOgvdF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C272DEA67
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 15:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751989697; cv=none; b=NHl2slUknbLbb9j2EBkSXZsoBjn2cMQ5DBhLKxP9f8jx99eV8lif+34yVUhPspeAwpQRW7lp7k+9ThS45DESX4yze11ffTE4WR9vYeIRPWtjol+BIzPyRYh41WLuW+TvB2m2wHd27k5Btze2mfW+zZiQvt71lB2Wd0Eku5RAPQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751989697; c=relaxed/simple;
	bh=SuJWuCF7OAV/GlOZ9B+iIodl+kxg17EuYp8KipNEP/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bBpg/cWI6PAMPSy3cisaOEpdAj6L2FKO77SAvtXNktPTfX28WpW30Vg9Yl8STudBF9ZgvIa7/kLJgozpheGXAD9nUCMTdMHGq/bt6wv+NfI6aTgR4RczRkDP8tjH+7ZhHgfFsPNoTJp+OKhvErzTArj4z3pnOCb6p62lIsybGDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=d2HOgvdF; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-700fee04941so43698656d6.1
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 08:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1751989693; x=1752594493; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jdccv8r6kG2HcBolVBSqhEyDLxi/NJUpMCqQXxW/BNg=;
        b=d2HOgvdFsWXRkzzKjPKPUmPlhg7XbUEM87uf2k4wojLdmDICOjVrSXku8OQ0+OrYpI
         1AAYOUomyHAp1Y6lBhtLsnQ61luept/IjX9WvrMPUlnlKr3EUiQVpj086PRPJhjGg6H4
         E1iCEl1hE4HjhwPjrPlouke3W9rjxYgYIH+qjCjoryPy5Vi1SggA8zqBL/ScyJcJ5QhE
         vP4UuHmreWGZcvjwZRXVr/cH96TjdUgz48Be46+Fsj36r6lj6D4WhTeRTKjnSOdbX91X
         MxNMkXr8+Ohj9quagL5H0uJBC/fAWKfR8pZeKgKRQ0ygpCSg3kCDCTXrirvYLQAIPzRg
         JFvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751989693; x=1752594493;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jdccv8r6kG2HcBolVBSqhEyDLxi/NJUpMCqQXxW/BNg=;
        b=kQqBSEmM8pP3mDmF1GXVi+tt9prL4EYvTVGiUrCMhKeZywrjUdfUwzuAtxug0labYK
         vX7nTeokxyKqxm0VX1hKHN7/3B/LkE0rB3ZUbVUx8c11tJgLGr1TihpVs4kdR4gQVDN8
         /1nUCpoZpQq3fhpbv5MChY01cbl0KB4uU8XMnEmuZ4WPSZEqDRngbMKkScMVebcGz8BJ
         HbXXmKdTonRhCa2mHS/OetyNVtTSXMuPpDyoou5Kxy4tELez5OJKckQrJ7dc3WuKzefM
         kXZofRxS4Mp4A5LPRnTAus1H52lGpU0VeeWPqeN0kvkF+cN4/SnDIM4kb2H1uCz4vi0C
         3S6w==
X-Gm-Message-State: AOJu0YxOZzKLsWem9ASqqi6YOlUBDwZqdHExy/CilfSxx7XeNr4iuhek
	PJ3FjHpWp5qABkHmezTzzb9ZaHZdqbNJ38w12GOsfkcsUMKHJYSKi1FTVVOBxP9HeSuc78AxW2n
	yYAgH
X-Gm-Gg: ASbGncvuopowvFecvao5tgYFXnoS7eYBEBK2WARZwV9W7bW8iuR8cZZG3RUGGSYJYpB
	/EUcWtoAkroASi2Wcn4TKLool2oXQjNPzGD8MY5zai7idQCmrhYK4bxh0bwu1FHgp6R5hJiiKR8
	G/KDUvwhqqH9BfG0YLzQzvR4VLGsXsLxdjzQmLmGISDNEPvQYB9BW5m40zEAyEbm/c5arte+Hog
	JCpHAdW6MFvc9pkzLO4IVmb65G5UsuiZWNv2tuDNSDP7ngAAYaBXJbJl1KKOPessJNqhGdgfhxm
	8ftpoK0Wf/eXH8kEeAcmUYmze1XaECDu+4U6rCa5URCrUlTJC11De6yuTPgJVrzMQHHSxVS/Px0
	AUhcO7ySMw5SjTTUCNKZOgJXjQSs5PAlnw84oeOHABfVn+KZDsIU=
X-Google-Smtp-Source: AGHT+IE10mwZp93cedil7BBoyf7eRyBi7gEfNMAHy9LlTfGe5O2WZp+UKFVlKh4/QpyDqG/ZjLpyWQ==
X-Received: by 2002:ad4:5ba3:0:b0:6f8:d223:3c32 with SMTP id 6a1803df08f44-7047d96feaamr62114746d6.10.1751989692807;
        Tue, 08 Jul 2025 08:48:12 -0700 (PDT)
Received: from jesse-lt.ba.rivosinc.com (pool-108-26-215-125.bstnma.fios.verizon.net. [108.26.215.125])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-702c4d5ab9csm78453346d6.87.2025.07.08.08.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jul 2025 08:48:12 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH v2 1/2] lib: Add STR_IS_Y and STR_IS_N for checking env vars
Date: Tue,  8 Jul 2025 08:48:10 -0700
Message-ID: <20250708154811.1888319-1-jesse@rivosinc.com>
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
is used in a few places add a macro for it and it's 'n' counterpart.

Add GET_CONFIG_OR_ENV for CONFIG values which can be overridden by
the environment.

Signed-off-by: Jesse Taube <jesse@rivosinc.com>
---
 lib/argv.h        | 13 +++++++++++++
 lib/errata.h      |  7 ++++---
 riscv/sbi-tests.h |  3 ++-
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/lib/argv.h b/lib/argv.h
index 0fa77725..ecbb40d7 100644
--- a/lib/argv.h
+++ b/lib/argv.h
@@ -14,4 +14,17 @@ extern void setup_args_progname(const char *args);
 extern void setup_env(char *env, int size);
 extern void add_setup_arg(const char *arg);
 
+#define STR_IS_Y(s) (s && (*s == '1' || *s == 'y' || *s == 'Y'))
+#define STR_IS_N(s) (s && (*s == '0' || *s == 'n' || *s == 'N'))
+
+/*
+ * Get the boolean value of CONFIG_{name}
+ * which can be overridden by the {name}
+ * variable in the environment if present.
+ */
+#define GET_CONFIG_OR_ENV(name) ({		\
+	const char *s = getenv(#name);		\
+	s ? STR_IS_Y(s) : CONFIG_##name;	\
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


