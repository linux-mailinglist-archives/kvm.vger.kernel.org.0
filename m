Return-Path: <kvm+bounces-45361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EC16BAA8ABC
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:53:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B36301891D9F
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:53:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEFFC1B87F0;
	Mon,  5 May 2025 01:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AZB7nNjB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783AD199E84
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409963; cv=none; b=gc0ZueIEa/sGteMEFwXPQ6g+YWJcRgVExnQUAFoeRv8PByo6WP5zvVJDQn31y+BFCSG9tegsTwMD3bfy4JoLArIxxhb+nmQa2eeacThj0CC2qP/GeJld4aZuDBU5oFQAHi3Dp/WbbB2NWvs1XXJnSB29dj8KaX/B9ZFAZeGcS74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409963; c=relaxed/simple;
	bh=LVteA2hO8l9wkPkl5G5rDyw+eENLf7RdXDZ7OVirD4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WWP9YXEP7mYXDIDflCyhycA9Hbxi5R+gZb65M4Le57Yc6eByIs5DB819yrSlWFMFQv88VOGJNBuTxNOH23bD8jBk28Ra/SRGlzqWjecY41WtW36anVXoXxW7T3n9WoM7Mmza5B1s7y/7yJb9Zp98FEtjwtvXvKYqzrWHnIqfzTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AZB7nNjB; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-74068f95d9fso1023983b3a.0
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409961; x=1747014761; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u3pVmvmULoy6BBYUkUdwM0L9kebw+2O/lrIQahS04Iw=;
        b=AZB7nNjBKtZ0J44PQeI2dl2C2E76p4FungRbNp84LL6uSm8gDzrqmXCOHV+TlN82i6
         FuKHLvRZe74/WQS31a5c5vhu4kUb18Pt/P1UjgY/aqDXOZKxxGfTlMkI+KCqFZiFVOnH
         3akNEZ3YID36AQSIYjtSmMXaFA5RGbH0W9qqFMn+SpA8PgLjgiKhvlHzBT080O5LnNRj
         RVj9ENqjf/tGhj5IOnoZ/SE+oasaR7IU6NXhtFnGgqtpXOJl+P9s8om9NZdZ5SOKNfL2
         1Vjqqqx8/3l7pDrhM2bVuOWdF/FTYAggZXSevz+7tfPVJZLFKo3lPXJX5VzAGuatcVRq
         MqCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409961; x=1747014761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u3pVmvmULoy6BBYUkUdwM0L9kebw+2O/lrIQahS04Iw=;
        b=qNnEPj2k0mZ6SnlIxogB7xsY3DwZ/D1EbD21wlg+IZFxnPW4/germDjPtlbttLMBQ9
         WBaKfI7YnA98JepHhy7NaKfAIMHUN8ysvNtGAR/R3sJuRp7B2CWIPpp2ZlYgFu+AfVXs
         uAZx/u48YwGR2pd7i0DRRs27QiXzo3AwP8wBiqVgy7PMWY+TwEc5CWuhofAp9VTtg+2r
         VFkmwTz90M1Pm1fyl0yBPqPOFHQ7lmS/HELlBNS276ecPK0fSWXgBUaCQwq2nbfHWmCw
         4hk44lqoBxy48rufRltFBpFcvKzbY/3CuIa0eJNOu8W5jLMsOxaDOxzoh0ZvS5EirEzZ
         O04A==
X-Forwarded-Encrypted: i=1; AJvYcCXRAvGVZkrOVCqEb2+J/ja86GVuc8yVkhEEpuBjPLV+OtnT2QwFIdMaOapb1BBaKKtp6QQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJmmZUAI+EOAPNL5o8olry/ylBSdWw1Ly/gmDbOWL8czd3r4qg
	tmwpFgZbGa5MSu3nm8iTuxXQpgW2QOC2IsrRVGFAsrFHsUrdcMGL3wY7/Ja/DTo=
X-Gm-Gg: ASbGncugng1K9wTU8H+j6L7ALjDbaomqTXczTCBp7UthL8lbOLkAbIudFiJmb8g0jhi
	yyaM2v8DkupvKSnQHoMNlObccyCK0232VYlpurdu5ZsaN5AGWdsH8LirDOlfqsRsoxQP4vJiszk
	OMsiY5rapIBL+cNc+KQ6tvoCgOeqqu8Q4GdqTOJmERCoFbahytaQf1i8vSqtBLKbLTzxPdbtsv8
	xuAGaXq6tiTwJ4b1pxNgYIaFKWI5DfFxZROK5/7E2A02GSEsPmtHAbX4tOms66MNZBC22oVNcaA
	LXKO0mQnbb/xrCAHU8ZpiNS8MYdk2uy8Fmv2LPud
X-Google-Smtp-Source: AGHT+IHMzdomMMzlq4KGCLymz5PTggicrRz+TP8w/tfk7qhqTrOD0GKRynUQbqlHnDL/LsXEtE08DA==
X-Received: by 2002:a05:6a21:9991:b0:1f5:79c4:5da2 with SMTP id adf61e73a8af0-20e979c9149mr8579279637.31.1746409960824;
        Sun, 04 May 2025 18:52:40 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:40 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 14/48] tcg: add vaddr type for helpers
Date: Sun,  4 May 2025 18:51:49 -0700
Message-ID: <20250505015223.3895275-15-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Defined as an alias of i32/i64 depending on host pointer size.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/tcg/tcg-op-common.h    |  1 +
 include/tcg/tcg.h              | 14 ++++++++++++++
 include/exec/helper-head.h.inc | 11 +++++++++++
 tcg/tcg.c                      |  5 +++++
 4 files changed, 31 insertions(+)

diff --git a/include/tcg/tcg-op-common.h b/include/tcg/tcg-op-common.h
index b439bdb385a..e1071adebf2 100644
--- a/include/tcg/tcg-op-common.h
+++ b/include/tcg/tcg-op-common.h
@@ -14,6 +14,7 @@
 
 TCGv_i32 tcg_constant_i32(int32_t val);
 TCGv_i64 tcg_constant_i64(int64_t val);
+TCGv_vaddr tcg_constant_vaddr(uintptr_t val);
 TCGv_vec tcg_constant_vec(TCGType type, unsigned vece, int64_t val);
 TCGv_vec tcg_constant_vec_matching(TCGv_vec match, unsigned vece, int64_t val);
 
diff --git a/include/tcg/tcg.h b/include/tcg/tcg.h
index aa300a2f8ba..72bfd3485aa 100644
--- a/include/tcg/tcg.h
+++ b/include/tcg/tcg.h
@@ -188,6 +188,7 @@ typedef tcg_target_ulong TCGArg;
     * TCGv_i64  : 64 bit integer type
     * TCGv_i128 : 128 bit integer type
     * TCGv_ptr  : a host pointer type
+    * TCGv_vaddr: an integer type wide enough to hold a target pointer type
     * TCGv_vec  : a host vector type; the exact size is not exposed
                   to the CPU front-end code.
     * TCGv      : an integer type the same size as target_ulong
@@ -216,6 +217,14 @@ typedef struct TCGv_ptr_d *TCGv_ptr;
 typedef struct TCGv_vec_d *TCGv_vec;
 typedef TCGv_ptr TCGv_env;
 
+#if __SIZEOF_POINTER__ == 4
+typedef TCGv_i32 TCGv_vaddr;
+#elif __SIZEOF_POINTER__ == 8
+typedef TCGv_i64 TCGv_vaddr;
+#else
+# error "sizeof pointer is different from {4,8}"
+#endif /* __SIZEOF_POINTER__ */
+
 /* call flags */
 /* Helper does not read globals (either directly or through an exception). It
    implies TCG_CALL_NO_WRITE_GLOBALS. */
@@ -577,6 +586,11 @@ static inline TCGv_ptr temp_tcgv_ptr(TCGTemp *t)
     return (TCGv_ptr)temp_tcgv_i32(t);
 }
 
+static inline TCGv_vaddr temp_tcgv_vaddr(TCGTemp *t)
+{
+    return (TCGv_vaddr)temp_tcgv_i32(t);
+}
+
 static inline TCGv_vec temp_tcgv_vec(TCGTemp *t)
 {
     return (TCGv_vec)temp_tcgv_i32(t);
diff --git a/include/exec/helper-head.h.inc b/include/exec/helper-head.h.inc
index bce5db06ef3..5b248fd7138 100644
--- a/include/exec/helper-head.h.inc
+++ b/include/exec/helper-head.h.inc
@@ -58,6 +58,17 @@
 # define dh_ctype_tl target_ulong
 #endif /* COMPILING_PER_TARGET */
 
+#if __SIZEOF_POINTER__ == 4
+# define dh_alias_vaddr i32
+# define dh_typecode_vaddr dh_typecode_i32
+#elif __SIZEOF_POINTER__ == 8
+# define dh_alias_vaddr i64
+# define dh_typecode_vaddr dh_typecode_i64
+#else
+# error "sizeof pointer is different from {4,8}"
+#endif /* __SIZEOF_POINTER__ */
+# define dh_ctype_vaddr uintptr_t
+
 /* We can't use glue() here because it falls foul of C preprocessor
    recursive expansion rules.  */
 #define dh_retvar_decl0_void void
diff --git a/tcg/tcg.c b/tcg/tcg.c
index c4e866e9c34..51ec8e04bdc 100644
--- a/tcg/tcg.c
+++ b/tcg/tcg.c
@@ -2368,6 +2368,11 @@ TCGv_i64 tcg_constant_i64(int64_t val)
     return temp_tcgv_i64(tcg_constant_internal(TCG_TYPE_I64, val));
 }
 
+TCGv_vaddr tcg_constant_vaddr(uintptr_t val)
+{
+    return temp_tcgv_vaddr(tcg_constant_internal(TCG_TYPE_PTR, val));
+}
+
 TCGv_ptr tcg_constant_ptr_int(intptr_t val)
 {
     return temp_tcgv_ptr(tcg_constant_internal(TCG_TYPE_PTR, val));
-- 
2.47.2


