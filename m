Return-Path: <kvm+bounces-45307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6075DAA83FC
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:30:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8394179FB2
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:30:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F71C199949;
	Sun,  4 May 2025 05:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Br63t4t/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34578195808
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336574; cv=none; b=G3e7xuwoHgyihs9mM9fi78rua2xYB6oW3RPjXnQlwUdlKCPRkxe82ZUlYwXJUcJRqotBcKuGqCFgaQjpFWvaCq+3fbl47X0g2aGCGr6DMUHS93u02TeXA/lYFyJaxpKTJAORFYylnz3ba53605PSLFFfO/SMJnT1ARdgwfl68ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336574; c=relaxed/simple;
	bh=rs8DCDWqUJLFmfNX+sHhTL/c9KQe5i1aY9c1LOJj3mM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/WZ/zHkXYxuWZZJnpJM7i5SXx3I1prRwr4U+1qXzAYMkj026DLdqw3CThqIJJYmKKh+xErz9yoRDz8/It5CM7gvqF8eR2Mt6jyEpxs4Qzoi70AXMJOFEALoeJeiz8yyeLQdbkLnwYYHzTnvhH+Xdnc/QsAipy6UQ3sB7zjxAw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Br63t4t/; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-73712952e1cso3370862b3a.1
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336572; x=1746941372; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z2AIxKY+FMiPJgej6tAa266T+4QbSc+CiL7TGNxQcGc=;
        b=Br63t4t/a0Uf3Mo3efknL8wy2jAv3rC8IF/jgsd4op6BAisns8sqWDWkyGpuGLUzFN
         fYN2ovzL/lz7WYYGFVIwO+Kylqk9ibs77GrzDafgpkf4XQzpFRVeut2JJhJTeYD0Voz6
         XnlHPvekn5oX6I08g4J61XBgJ+K6lhMKC98kb4+oS8PiuITi6uE1axAh+7zthPezaFcY
         fj97q7xOzB+ZriZueYXyDhdzoO5mepw1RpKlpzHSsUUuvjLAEN62LUzfvKd4vB7bnSgt
         TLLuEJcD/Q4K7VkUeGCAUDCi3/tdKFhjrhTRdtXxgZfzJwuvN81oSzx7zoV38U30Wq5y
         8AEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336572; x=1746941372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z2AIxKY+FMiPJgej6tAa266T+4QbSc+CiL7TGNxQcGc=;
        b=wGiNNv5gr+2TNoHgimKUeokx4cEAW65HKKe6ml+B3ZvYwPScFmULVoWWYbY3aZN45N
         5dGKgBmcm0+HEkexjGCM4y5PBHM0LjltYHCrFq59lK1fGLlrQeMrejKerrZw4h2RCvDk
         k2RQ58FdXeq5fGM+Az48yZVfgABGzq2K3SIpC4UXQBYsU3dQqc9iyiEtAvBTlbAysCnL
         JOE4ksp0eB0htUl0DwCEKdFELixp5y+mn0UHQWbXrFRdneGPxXpTzI3tTjPRiBagEjQp
         n/uRESuKA5kyRymzEmRRLz/rsMhoMjrqfzf6Dgg/IprhXEEt1eIrznKop9GgXBWxtOOW
         JifQ==
X-Forwarded-Encrypted: i=1; AJvYcCUFiCsOPdZ7c+Ts4e24yIMfhMh8tQWGYMCbxk4/6hJcx0N8H+0eOXFXzKRvR8lHidSrRrQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5ODY0kwpEk1JnKvJodVbC9Jo7/k9c1z5N/UFxPs1rJFK7IHY2
	mB/3vz0kgcZhdD+Ow/bgFVEUmIUDOdnQ197UKZ9x7gD1lU6KxFagGWcc9hZRxEI=
X-Gm-Gg: ASbGncslmSRNaJKUti7J+kYiCNQX/O43iNoijDt51tNNgImucDLI/I+XmM+qTERkFa4
	h+vi67WbeZzDNDaXiMxU/GYogne6wl2Mk65O1YJRxINXrzTFWh/UVyNibu8tEBI2suBdkzjVgPE
	fan+hWaajG7GYaXwIv2ygOGdN0bS/IgzO5ZrDOV7OAmhTcNRJUrDVDEmi2k5ra77Ljx8S01Afgh
	MkGW12KRNeRe9JCu85zSUs0IbuDnnMyTm2FyVpWIKg6vCjdaJ3vTeZSs4OW49CWeRCY+c34MDc9
	b++jtcW1NdAY7+/CHWMJD9OGZx24qmD3WY+nRcFj9Fw3mrKD7cg=
X-Google-Smtp-Source: AGHT+IEU6HbixXtpyc/R49r3cZVRH0CTjPwr5pxfq2u4SUp++XWmysJGYYMZORx1y251tL8QRfDM8w==
X-Received: by 2002:a05:6a21:6d8e:b0:1f5:97c3:41b9 with SMTP id adf61e73a8af0-20e9620551emr3117470637.5.1746336572592;
        Sat, 03 May 2025 22:29:32 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:32 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 14/40] tcg: add vaddr type for helpers
Date: Sat,  3 May 2025 22:28:48 -0700
Message-ID: <20250504052914.3525365-15-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
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
 include/tcg/tcg.h              | 17 +++++++++++++++++
 include/exec/helper-head.h.inc | 11 +++++++++++
 tcg/tcg.c                      |  6 ++++++
 4 files changed, 35 insertions(+)

diff --git a/include/tcg/tcg-op-common.h b/include/tcg/tcg-op-common.h
index b439bdb385a..7d7375eef44 100644
--- a/include/tcg/tcg-op-common.h
+++ b/include/tcg/tcg-op-common.h
@@ -14,6 +14,7 @@
 
 TCGv_i32 tcg_constant_i32(int32_t val);
 TCGv_i64 tcg_constant_i64(int64_t val);
+TCGv_vaddr tcg_constant_vaddr(vaddr val);
 TCGv_vec tcg_constant_vec(TCGType type, unsigned vece, int64_t val);
 TCGv_vec tcg_constant_vec_matching(TCGv_vec match, unsigned vece, int64_t val);
 
diff --git a/include/tcg/tcg.h b/include/tcg/tcg.h
index aa300a2f8ba..0eb033aa7d1 100644
--- a/include/tcg/tcg.h
+++ b/include/tcg/tcg.h
@@ -188,6 +188,7 @@ typedef tcg_target_ulong TCGArg;
     * TCGv_i64  : 64 bit integer type
     * TCGv_i128 : 128 bit integer type
     * TCGv_ptr  : a host pointer type
+    * TCGv_vaddr: an integer type large enough to hold a target pointer type
     * TCGv_vec  : a host vector type; the exact size is not exposed
                   to the CPU front-end code.
     * TCGv      : an integer type the same size as target_ulong
@@ -214,6 +215,7 @@ typedef struct TCGv_i64_d *TCGv_i64;
 typedef struct TCGv_i128_d *TCGv_i128;
 typedef struct TCGv_ptr_d *TCGv_ptr;
 typedef struct TCGv_vec_d *TCGv_vec;
+typedef struct TCGv_vaddr_d *TCGv_vaddr;
 typedef TCGv_ptr TCGv_env;
 
 /* call flags */
@@ -526,6 +528,11 @@ static inline TCGTemp *tcgv_ptr_temp(TCGv_ptr v)
     return tcgv_i32_temp((TCGv_i32)v);
 }
 
+static inline TCGTemp *tcgv_vaddr_temp(TCGv_vaddr v)
+{
+    return tcgv_i32_temp((TCGv_i32)v);
+}
+
 static inline TCGTemp *tcgv_vec_temp(TCGv_vec v)
 {
     return tcgv_i32_temp((TCGv_i32)v);
@@ -551,6 +558,11 @@ static inline TCGArg tcgv_ptr_arg(TCGv_ptr v)
     return temp_arg(tcgv_ptr_temp(v));
 }
 
+static inline TCGArg tcgv_vaddr_arg(TCGv_vaddr v)
+{
+    return temp_arg(tcgv_vaddr_temp(v));
+}
+
 static inline TCGArg tcgv_vec_arg(TCGv_vec v)
 {
     return temp_arg(tcgv_vec_temp(v));
@@ -572,6 +584,11 @@ static inline TCGv_i128 temp_tcgv_i128(TCGTemp *t)
     return (TCGv_i128)temp_tcgv_i32(t);
 }
 
+static inline TCGv_vaddr temp_tcgv_vaddr(TCGTemp *t)
+{
+    return (TCGv_vaddr)temp_tcgv_i32(t);
+}
+
 static inline TCGv_ptr temp_tcgv_ptr(TCGTemp *t)
 {
     return (TCGv_ptr)temp_tcgv_i32(t);
diff --git a/include/exec/helper-head.h.inc b/include/exec/helper-head.h.inc
index bce5db06ef3..b15256ce14d 100644
--- a/include/exec/helper-head.h.inc
+++ b/include/exec/helper-head.h.inc
@@ -21,6 +21,7 @@
 #define dh_alias_f32 i32
 #define dh_alias_f64 i64
 #define dh_alias_ptr ptr
+#define dh_alias_vaddr vaddr
 #define dh_alias_cptr ptr
 #define dh_alias_env ptr
 #define dh_alias_fpst ptr
@@ -37,6 +38,7 @@
 #define dh_ctype_f16 uint32_t
 #define dh_ctype_f32 float32
 #define dh_ctype_f64 float64
+#define dh_ctype_vaddr uintptr_t
 #define dh_ctype_ptr void *
 #define dh_ctype_cptr const void *
 #define dh_ctype_env CPUArchState *
@@ -91,6 +93,15 @@
 #define dh_typecode_i64 4
 #define dh_typecode_s64 5
 #define dh_typecode_ptr 6
+
+#if __SIZEOF_POINTER__ == 4
+# define dh_typecode_vaddr dh_typecode_i32
+#elif __SIZEOF_POINTER__ == 8
+# define dh_typecode_vaddr dh_typecode_i64
+#else
+# error "sizeof pointer is different from {4,8}"
+#endif
+
 #define dh_typecode_i128 7
 #define dh_typecode_int dh_typecode_s32
 #define dh_typecode_f16 dh_typecode_i32
diff --git a/tcg/tcg.c b/tcg/tcg.c
index c4e866e9c34..e86576120c0 100644
--- a/tcg/tcg.c
+++ b/tcg/tcg.c
@@ -2368,6 +2368,12 @@ TCGv_i64 tcg_constant_i64(int64_t val)
     return temp_tcgv_i64(tcg_constant_internal(TCG_TYPE_I64, val));
 }
 
+TCGv_vaddr tcg_constant_vaddr(vaddr val)
+{
+    TCGType type = __SIZEOF_POINTER__ == 8 ? TCG_TYPE_I64 : TCG_TYPE_I32;
+    return temp_tcgv_vaddr(tcg_constant_internal(type, val));
+}
+
 TCGv_ptr tcg_constant_ptr_int(intptr_t val)
 {
     return temp_tcgv_ptr(tcg_constant_internal(TCG_TYPE_PTR, val));
-- 
2.47.2


