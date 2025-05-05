Return-Path: <kvm+bounces-45535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 97DD5AAB7E0
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 08:21:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3BFD51C25E0C
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 06:15:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9019334AA66;
	Tue,  6 May 2025 00:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Z4yQuwhN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D774E3B11D4
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487235; cv=none; b=uQXseUHI3xJJ0kHXCOCHU7+4VJOW4y9vwYCje2vFkEi8zn6INEGrkvDA7ndGrc8NNBURSkarxmGQz1NaEoQDkw1BqEheb9chRZlxRmB/FxIVgGaFYOwlSs4EudLDKxkM02pM0KgyqnCGOKb71Xy67LOei7KRPoqkGpykjCQ7ODc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487235; c=relaxed/simple;
	bh=nfgQHsANJaqiWQ/p28+3+T/DVhjqNc/k03HzGUSITCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ix+jCZvV3GS48wwVwGUpjAQy91uKSayPgibNhbGxo/qXqFNMW34vAtrkGjjVFZdRJ4BT8noW/FtP1cev2KZMZAtyTa3aPI8gbzd7MZmBydxzAXTvkYNyquCP0JieVo4JzZH5MURPM5EhBMo7R79XK37fJUlUp3jJ7eZhb0gQRhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Z4yQuwhN; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-22d95f0dda4so72236365ad.2
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487233; x=1747092033; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cDb7EHZEjLo7h3rZVcHObRDfwFiVArFxWp0gbUWTYQ0=;
        b=Z4yQuwhNpKDduvq/9VTXzOcRsX4f6QUI/Kp68gnKMrrOGNcsb1ankj4Q0PEMt5JITG
         4br30KN0cnHrH8Bm0l8W6ZJrLXIIzNG+GE8aZsCW3fzCbx84bC7p4R8xTPKMYCKpBNB5
         lh4tQVkXpVVEmzi7wTkvBgrl4NV8PT/1/mF+sISlatzUM//HRB5L5XKngamSjt0gg1JX
         h3cCQ550CSKOKYT5Rner2yFlTx3VBj/DbvcIERFRNsb/LJgmBMBpPWTwx1LHDXYhd3Df
         kIUUw0xo8DWizu7JMtbVBnOPGI4NtBYfJ3bqASjzeVxNqz7ZVlnPg++7t5zvWIeT/aE3
         gfTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487233; x=1747092033;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cDb7EHZEjLo7h3rZVcHObRDfwFiVArFxWp0gbUWTYQ0=;
        b=M3S22xJF8CEL7xafw8cAgv5UlvhVDu12hBVyNmKx+cnwBjXMWxlcBxqxpsVFv8Culn
         BVpoMwzy7xw2p6d/aJBI68z/7OuzH9N0LJO3UVw9g3Wk+QE5ybQSs9VMDL49jonBgeux
         1ZFK10aTAYH51KVyf0YuErHjk1sXNIgcgYWijTqCkDK+cIl9pZm4m0SihoRr0OVkts0/
         CNNCUeRqzVaEawtX4CjIzzNz37DGEKS3xTpKrGS5DiXfEqPjrFs875z4fDUNtfQYsSIs
         ztBPf5ZDOPXQxlARMzJ25vZMLjpdsxz8mVcZkfjVtRdBH8jZHcZfGn7GUNuMnXCMQYy1
         UZNA==
X-Forwarded-Encrypted: i=1; AJvYcCXZhCW4p1nBd2ionszr87FRp0m+fGAdKi6vt8Ss++cf0A8DGV9+D4OnbBBHRxOn223JmGQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiemBrFnntOhHYqkN65UEPP6xk0lX6S75p6jS3kyF3g5H+Euvj
	lAR7A6Q2Fn75nAUpod8Ma3PGMSp7FpAZvoCGcHwIFkwtALm7tRKuHxIu0haY/Nc=
X-Gm-Gg: ASbGnct+T8SJ72I2OhAl0Ib/A2MraT1Tzb+Q/wJGL8a1FJQTRInHW0pitGq/7+1Ok5n
	ViizpQmWDp6pAqyizqfWkMq/3Lk8OTXgxczXPj6+zo9y4BBWgzcANR/aHdNYWRQTQkOAprdn7oP
	fWn5Xelwhj1AaBds0uUpMdxanXJU7yJO/I/q2M0jgWSXcXFz+A1iIUwcQuAgrZ2L2z6O75/lJCe
	eHgKGPG1KN2qQTYFpmapdNRqebwd+y273FvzHiaJASfi5H/jlt5Qdzi6dNr++Yi9/Tf+TE7EsF0
	4c0Z/mbVpwUIkVVc86NsATSAVJl2yst1fL6VbJmW
X-Google-Smtp-Source: AGHT+IFJti35iYUgKEkKZhhVTmuhbgWlpB1h6Ppe2ETgmh9NoEZMHMZ762NC6rp3ineO7ZWC8L/XPw==
X-Received: by 2002:a17:903:3c68:b0:223:635d:3e38 with SMTP id d9443c01a7336-22e35fdf7edmr13552305ad.15.1746487233076;
        Mon, 05 May 2025 16:20:33 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:32 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: richard.henderson@linaro.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 14/50] tcg: add vaddr type for helpers
Date: Mon,  5 May 2025 16:19:39 -0700
Message-ID: <20250505232015.130990-15-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Defined as an alias of i32/i64 depending on host pointer size.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
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


