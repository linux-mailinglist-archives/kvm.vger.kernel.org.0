Return-Path: <kvm+bounces-46213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F0DC8AB4307
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:29:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 94D947B5E00
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:16:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFBE72BE0FA;
	Mon, 12 May 2025 18:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PSKjvYR5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8922BDC20
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073125; cv=none; b=Prgd3OIBLMXwqKgVwABJPzINg6ksv9M2zqzLAJQWQVeLIB1RCUNEXlvDeRj5I/eDobPdGtjtePVOw6G9zqDay3WuW3tEdlol5KwKtc3vb0j2HU9Jrgc67I9Sg6L7RYv/DkTwEEaGyv22gJq6c81RL+D2Xjzc4nFsF8NTcIgY7zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073125; c=relaxed/simple;
	bh=pMMYQTIcsIuYa43a/dtojulRIx2OQ5zPmiSoL+5xV5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDhiJEqYNrF5AmOaXTHKprUwo6dl8LlMCX2EQ5DxTAXO8H1t+LSesIxDFj36iRmXYs+yKHLI3bNR7v67MCn12mdoiZHC7IitznOLDLI8S2upsKhWd/faxBAYKpdbfNpWysk6HhkDB5+guUf4Bbg7Z53xrFggPEgnhofAtcmjB/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PSKjvYR5; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7423fb98cb1so2982882b3a.3
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073123; x=1747677923; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IIdA4T0anNoDoCvg3AtaMVguafAAS4gjefvUsXl2qzE=;
        b=PSKjvYR5I+qy1+V0fDANc6eingI1gzNoWgcOGArVDLw7cCh8iPXhJF/eeZdWbB5a5T
         oBoVxxQBZd6I/eTcPd8r9jO9+qd/iik6AlKomvYJsOeuttTjsvDrNysvBXtreSbTgdBF
         H2To+oqMhhxATXWD3udlv9mBUnVi8SrqXDYXSrxkX73D4cWJfB+gY1kou69Zw6tAsUrE
         y+kxGcpVCtNkpS677GCxy+6ELSYeWCN3VX/BxWht+eRM1DlZhRzH8SBlEVrfE6QfJ3wz
         w0plja+36nCqdMepREaIKWME+RWfCQJt51q9jqB/K/aXL3pTu12TbfBRXNeMiwmu8MHn
         yyxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073123; x=1747677923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IIdA4T0anNoDoCvg3AtaMVguafAAS4gjefvUsXl2qzE=;
        b=fekNk2fpcH2bycvN9ZJLB9nqav85JdLsu7vDhw6YE6AEFhlE8hiOsRD3vOC1AyIUsj
         P38o2Rf0SzVWgblNd+4La7C7cXtCJyHeUk96AAfadsqb1o5inAYUHZx9LIytQYxYKaFh
         a1KTOWm4+edjK6Acy0o3XRI7U6pw2707rL0OvjMb00LYNGHO06ppLPLgEfhnlLp0oQtQ
         Le/PUTLJBbAvAzeeLrOeuq7F6cm37wXEpf5/tOsHQIDUO0tWsNWx8U0MKLdgcDgY++sU
         VSEQ5IFvTGpLPoW8jdjiAmyaum1S3OGgBsWGd2GhlMWbRkiUkcDEthd6hBLacJeOF3WK
         gi0g==
X-Forwarded-Encrypted: i=1; AJvYcCWRStMfOZAock/m+5xM4pA4ROhUIC8GDxCY9fTxFfz4URxEfLTTqtpw0Wk5h0hLeHBGRrI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvQHjtJFoXtZSdFEKmURfMMsJGTWfr5brvYeU7GbAoHVJS8jI0
	vS8+SQ4WEKXPfJw0+92eyYKBalUOny9GMKmdjgME/um2WCZi7VP0yEKlrR9KyUM=
X-Gm-Gg: ASbGncvKb4ksb2EWVh6zQtAr1E6/SnFKLbpZbZjK30YIs5lq808yknH1UFlKcGQU4N5
	KINfrPxQH01SCOFINcvklAV4piiotUA9pyi7nuFZTLftCCHxKFPYDG3h5oY3cjdYj7DxDcz96Z7
	WB6knW1+6catYzlGSo3FykpRLTuBHWmJzHxJOuYtevkHlm2sggY5wLXTvU6YuY8+LVN8LO5rMTw
	MExbFE5JPSDZmUSrxFZ0F/hUI96lQIO4B3V1l9Cf+eF50aEU0wMKOf0u+/SFoSk8q0bDqvdEe3K
	/fi5DkQmiAD5Z/WvkaUV5veeyIj2vV4wgEtHMSEiYPbFDZSGOBU=
X-Google-Smtp-Source: AGHT+IE4KyY2sjUciM2QtMe6xqm8Ao/CMZro9JcL3u4sz8QtHZGkRvfqtH/L0/tgDzL1c2LWymKJtw==
X-Received: by 2002:a17:902:e88d:b0:226:38ff:1d6a with SMTP id d9443c01a7336-22fc8b1b1d6mr194043645ad.7.1747073122675;
        Mon, 12 May 2025 11:05:22 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:22 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	anjo@rev.ng,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v8 12/48] tcg: add vaddr type for helpers
Date: Mon, 12 May 2025 11:04:26 -0700
Message-ID: <20250512180502.2395029-13-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
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


