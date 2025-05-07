Return-Path: <kvm+bounces-45779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A61A6AAEF73
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:45:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8C09C7BE7F7
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:43:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 019A5292095;
	Wed,  7 May 2025 23:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MOw7kL4e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988192918FD
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661377; cv=none; b=dyvktqTpI+UH0WZbAnN5Fsuzo5KGvt9ME4L432KbbV6diF/SO1hIU4lUZA5uxc/F75jGP8TYOjucl+ARoZrcbTf5qY+/qcoVeJNbKHA+OQtig5UF+YBzih0bZ3b/S/RfQpYsYyRLKi/hBsceYuUteJi90p+XvEm6NlfvA97gryc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661377; c=relaxed/simple;
	bh=pMMYQTIcsIuYa43a/dtojulRIx2OQ5zPmiSoL+5xV5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=milJkwYSKDjHDb//I7TSOUOfXPvVcjgf4vXOW4/XXOAUJ3V0Xjcj1yei5prrbMpp/3evRaX+uPHoO0LeUGXjI8dZBQc/Cjix/4l4JjCzqtjybA4wSyXzvXbDRCP4i0bV83DZHixcVym3SmJsc0DCUX//UufsjPzgf1DPfgQQl+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MOw7kL4e; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-30a8cbddca4so496489a91.3
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661375; x=1747266175; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IIdA4T0anNoDoCvg3AtaMVguafAAS4gjefvUsXl2qzE=;
        b=MOw7kL4eSKYU355oes32poaHlJ08OzvoSEPOGVTUET86WPK16bxQ74rbp11y2H2VAZ
         6xdJnqtvpaxJddStYEEK10x/Oo+Y18WjOb2dOgDxFVnKxEfHTi6SPsN5lsLAs0YxidN0
         wwmSdJ8IuTIpPIfA+XdkwfdoETKoUkaYgXkxQEmVPQDNHQrVEeiRG1GVXXFsWZ3Gaa85
         wJW/eCew7H9IWXgjc2fIvbk8mw3SbIJEIpvvnASxGAhq1vE3BoKlNjZH7vkns+lnz1k3
         wEvLDyvdBKZ0s8wliy+2+BT2Lbb5M//JBQxRqtipyAJhkqdm9Q6t7i023+l8gUEztSDU
         8j7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661375; x=1747266175;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IIdA4T0anNoDoCvg3AtaMVguafAAS4gjefvUsXl2qzE=;
        b=SaBScPIu5u5OfHCssC1dq4UvIXKHQe+opIIo1+BRFFPgBom4p8co+kDmcyktmfqWL5
         KUp16lnuxo0hwyMMqEvqEGisezUsTreVz+rMRFFATcWRqnzx49VyZZvpa4XB7QJwai+g
         QLVZ8SK1jJApxKzGcpcF3RhLEtFrryQDlwqMHEWU0hXDvpQKGuzQmxRYD/o+pzN0LdY+
         80ZSe70cY1r4KVBmUadguXgwH7daacDVjxWmC8x5FDQVgVr2ET2EArh8sLV+5RhHmESj
         lwuYG2XRUl26x5dHlAZGVzFX5GBZ0lU3xhPtg+2iQWzdGEYWPr0Q+XCg4vgXXBdM3zil
         1c8w==
X-Forwarded-Encrypted: i=1; AJvYcCUa6J0i97JuPIMf9GlaJu1X9TD0SOgNXrmJnYN0VjZhnDFjC229XMmmSxWVM6eUxihuBC8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVCE7+VEIROKvTSdIZkHEKAS7nq3v4sC10jFet7eKZafRnrS/l
	Bn0nJh++IKcPnQ0ASLC/4/x4id6fH9ClsfAOIxcBgh5DZbwlhYdTPNnhRnCBsvQ=
X-Gm-Gg: ASbGnctTU2jdZbe4bvacYQwNPI5AT+/gU+JyRXzA/zg8bANMRqwhV96sXap9KQE+suv
	6fuRq2pzA7PFUyM8MJn8At+pFchg3/5fc89ZJdiVk4+Vt6Hnju3Eg2RUIR6apMGajGC8LGo+TkD
	s1RWdIQFPxVmGirNks6EZuuFobAgFNPzra3WzpiI30eGi2/7QLq0mtf1Cp3PaLLW4/0yEUkRKDL
	Sm/hLdam3dOMqMbvtdCcz9K236ogWe5uyrqJjTa5jHFn3q3nKqa5ap6UrabJYkPZisYH1RxfaoG
	IDK05z6Xt0oP+8Qfs3gFKUMP/ZkpuhjmKsftHMK0
X-Google-Smtp-Source: AGHT+IE4SdOlTduCOg7Y2FOUnmos397XeU5l2GkAQ9tyD0x8ukmGUjgShIh0T8CHvCr2QiUOb/m4DQ==
X-Received: by 2002:a17:90b:1d03:b0:2ee:53b3:3f1c with SMTP id 98e67ed59e1d1-30b28ce2bd5mr1427945a91.5.1746661374817;
        Wed, 07 May 2025 16:42:54 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:42:54 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v7 13/49] tcg: add vaddr type for helpers
Date: Wed,  7 May 2025 16:42:04 -0700
Message-ID: <20250507234241.957746-14-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
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
index a8c00c72cc8..3fa5a7aed2c 100644
--- a/include/tcg/tcg.h
+++ b/include/tcg/tcg.h
@@ -189,6 +189,7 @@ typedef tcg_target_ulong TCGArg;
     * TCGv_i64  : 64 bit integer type
     * TCGv_i128 : 128 bit integer type
     * TCGv_ptr  : a host pointer type
+    * TCGv_vaddr: an integer type wide enough to hold a target pointer type
     * TCGv_vec  : a host vector type; the exact size is not exposed
                   to the CPU front-end code.
     * TCGv      : an integer type the same size as target_ulong
@@ -217,6 +218,14 @@ typedef struct TCGv_ptr_d *TCGv_ptr;
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
index 648333a9fb7..ae27a2607df 100644
--- a/tcg/tcg.c
+++ b/tcg/tcg.c
@@ -2367,6 +2367,11 @@ TCGv_i64 tcg_constant_i64(int64_t val)
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


