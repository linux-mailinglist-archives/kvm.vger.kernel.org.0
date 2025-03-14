Return-Path: <kvm+bounces-41089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DAAE2A617B4
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 18:32:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C9C316D71D
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 17:32:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AB2F2046AC;
	Fri, 14 Mar 2025 17:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kg+IpBsa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF422036FC
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 17:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741973509; cv=none; b=BLb+7Y2dfOSXZYYDp4WEfqhmO1O0gcvN8PRxdEr14f/6yfzaIEDX+s3irNNZqn5tqJuik8ayt6OSjBglQ86ffTWgp8uhnu0SqJ8fKqzVCXiF/evr+3+TZPyRybQwtmHClaSi1wK2QasrvkSuNaYGL67ym/RFeZMzQ2REPM8bRv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741973509; c=relaxed/simple;
	bh=6cdUkgilZ/OtUG5CSqfjwssNSd31+3Bqv7Sh94x+Hkw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HXojEI3CCIg3CJyAP7N6OyNpSmIuxaKAWOsI2HvedSbHF0tqv/xjGJapm8901Q7YEJVuGi10Vhd0CppvubPYcaHxaRpZ+HZvzgvXmW2bbkc6gwitNpSdF0R1EWHyqh6364HqX+/gQF58x14SBFbysGnYwd9DjPeURd46uQiVfSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kg+IpBsa; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-225e3002dffso12996965ad.1
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 10:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741973507; x=1742578307; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fjQjYNlvDIsMbe7+veFF5h4s6vvln32m8yANkT1fS5Y=;
        b=kg+IpBsaHDKr03OktMXVQzoGeKaEed1TtX5QuUdV1jHFonKVmyJgERNogkU4u2TivI
         uf+tVYNh0c0ifxemwvQGKPWtVwRdm4TZFB/3+NRB7/BHF5kE6NmNP75jnhK6tTP6tqU2
         iX8UU8MCOKwQOj/ua9jbHP8glLOpngS2rYNycl+sHmgwz+kQaggJz5Y6ter2oY5Y3c2N
         qIpHzuUzpurRmrNy9+Z3xRABz5BFyMJV3wuWrdKJrStBkhA2k9RMMyBNGHl+zklVaAb8
         8z0iqOvdaDhfxOcwLy8ZV+yIwmZiR1o/Yb+3OQnfzImcSWokqcd5kMzLxxmkKCqsMlQS
         TAAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741973507; x=1742578307;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fjQjYNlvDIsMbe7+veFF5h4s6vvln32m8yANkT1fS5Y=;
        b=N+uWRyMighbEfNYsCf/wHYAAJJu+YEI+6iaG+skHCVteOitRxfB2evJfOexVp9Cpds
         lOCWNObzEwBJPT97fkjAcCoWVUODX1CnJBjxTZoW+9iqoz9PhqtgObIelCCaW8BSnElO
         inLaIGcfrC50BYECP727rg4mjfOS+DW+BOxvFAjKkVfCArgHaYb7RKuakZmpY7B5G7v0
         esGSiZkuRyh4/ENjekv3+tuvxi05jtzjfE9zAfy1TwLEdNs4wavAAKoQLfqhECoG7+Wv
         673W23vF7WWGnJdZKwknrRhrw29doqLf5Oc0cG8qIQNXIj8GXBJTx1/MWB2Lfm4wBvke
         /0NA==
X-Forwarded-Encrypted: i=1; AJvYcCWhMnUIPRD0/aac9rp86oRg9/toX7N9nqDx6IkVAwKfySfq3Eich/F+zChXT4qM/Gv2dxc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy51S4D/PZO0k6g/clPaTzYROankw+mY2s4nvmZLhJBXrAxrZdB
	oJ67okKzOr1LoE4Ar6J2tlt2QPu4iPa+Eq6kUPz6icZdy3fOk2xkcyoHD82xhak=
X-Gm-Gg: ASbGncuAVE+rNJMBhOrIPwF83PEFc6swxi2X3cyGsoyzwp+dhh/9X1WUxFMCerI2Uyt
	oX5fShAeaTlcR5tnqcLEyM0Lzpw92Jwo1LbpUEVwvv9ytylwzB6V0BruJVT5gXg76rOfD/uwPgk
	K94zqgyGIry9twuVXf8FxPcae+llo2REc5LApKsb/YMasA2sxl90x4k+Zl8lflyi98htwyF2kHe
	jrpEZ+KVA+Xh585i1STWKMlWNZtCI0hudQvb0zRYXXpjJFPzSVXNNxB08sJWBvhXX0GDMKIninX
	Yr3/xAQ9dPkYWOfq4OnikGCJfMELV/p5kgKeDyDWQzrW
X-Google-Smtp-Source: AGHT+IG98FFUYfg0sUj6szpvN+iBBsyjmwTHoAxx0itmB7R9pQNc8XnfcIaBUehzGw+xAOY05im+Eg==
X-Received: by 2002:a05:6a20:c106:b0:1f3:47e2:80b3 with SMTP id adf61e73a8af0-1f5c11c3cd2mr3981620637.20.1741973507092;
        Fri, 14 Mar 2025 10:31:47 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af56e9cd03bsm2990529a12.8.2025.03.14.10.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 10:31:46 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Paul Durrant <paul@xen.org>,
	Peter Xu <peterx@redhat.com>,
	alex.bennee@linaro.org,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-riscv@nongnu.org,
	manos.pitsidianakis@linaro.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anthony PERARD <anthony@xenproject.org>,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 02/17] exec/tswap: implement {ld,st}.*_p as functions instead of macros
Date: Fri, 14 Mar 2025 10:31:24 -0700
Message-Id: <20250314173139.2122904-3-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
References: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Defining functions allows to use them from common code, by not depending
on TARGET_BIG_ENDIAN.
Remove previous macros from exec/cpu-all.h.
By moving them out of cpu-all.h, we'll be able to break dependency on
cpu.h for memory related functions coming in next commits.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/cpu-all.h | 25 ---------------
 include/exec/tswap.h   | 70 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 25 deletions(-)

diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index 8cd6c00cf89..e56c064d46f 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -38,31 +38,6 @@
 #define BSWAP_NEEDED
 #endif
 
-/* Target-endianness CPU memory access functions. These fit into the
- * {ld,st}{type}{sign}{size}{endian}_p naming scheme described in bswap.h.
- */
-#if TARGET_BIG_ENDIAN
-#define lduw_p(p) lduw_be_p(p)
-#define ldsw_p(p) ldsw_be_p(p)
-#define ldl_p(p) ldl_be_p(p)
-#define ldq_p(p) ldq_be_p(p)
-#define stw_p(p, v) stw_be_p(p, v)
-#define stl_p(p, v) stl_be_p(p, v)
-#define stq_p(p, v) stq_be_p(p, v)
-#define ldn_p(p, sz) ldn_be_p(p, sz)
-#define stn_p(p, sz, v) stn_be_p(p, sz, v)
-#else
-#define lduw_p(p) lduw_le_p(p)
-#define ldsw_p(p) ldsw_le_p(p)
-#define ldl_p(p) ldl_le_p(p)
-#define ldq_p(p) ldq_le_p(p)
-#define stw_p(p, v) stw_le_p(p, v)
-#define stl_p(p, v) stl_le_p(p, v)
-#define stq_p(p, v) stq_le_p(p, v)
-#define ldn_p(p, sz) ldn_le_p(p, sz)
-#define stn_p(p, sz, v) stn_le_p(p, sz, v)
-#endif
-
 /* MMU memory access macros */
 
 #if !defined(CONFIG_USER_ONLY)
diff --git a/include/exec/tswap.h b/include/exec/tswap.h
index 2683da0adb7..84060a49994 100644
--- a/include/exec/tswap.h
+++ b/include/exec/tswap.h
@@ -80,4 +80,74 @@ static inline void tswap64s(uint64_t *s)
     }
 }
 
+/* Return ld{word}_{le,be}_p following target endianness. */
+#define LOAD_IMPL(word, args...)                    \
+do {                                                \
+    if (target_words_bigendian()) {                 \
+        return glue(glue(ld, word), _be_p)(args);   \
+    } else {                                        \
+        return glue(glue(ld, word), _le_p)(args);   \
+    }                                               \
+} while (0)
+
+static inline int lduw_p(const void *ptr)
+{
+    LOAD_IMPL(uw, ptr);
+}
+
+static inline int ldsw_p(const void *ptr)
+{
+    LOAD_IMPL(sw, ptr);
+}
+
+static inline int ldl_p(const void *ptr)
+{
+    LOAD_IMPL(l, ptr);
+}
+
+static inline uint64_t ldq_p(const void *ptr)
+{
+    LOAD_IMPL(q, ptr);
+}
+
+static inline uint64_t ldn_p(const void *ptr, int sz)
+{
+    LOAD_IMPL(n, ptr, sz);
+}
+
+#undef LOAD_IMPL
+
+/* Call st{word}_{le,be}_p following target endianness. */
+#define STORE_IMPL(word, args...)           \
+do {                                        \
+    if (target_words_bigendian()) {         \
+        glue(glue(st, word), _be_p)(args);  \
+    } else {                                \
+        glue(glue(st, word), _le_p)(args);  \
+    }                                       \
+} while (0)
+
+
+static inline void stw_p(void *ptr, uint16_t v)
+{
+    STORE_IMPL(w, ptr, v);
+}
+
+static inline void stl_p(void *ptr, uint32_t v)
+{
+    STORE_IMPL(l, ptr, v);
+}
+
+static inline void stq_p(void *ptr, uint64_t v)
+{
+    STORE_IMPL(q, ptr, v);
+}
+
+static inline void stn_p(void *ptr, int sz, uint64_t v)
+{
+    STORE_IMPL(n, ptr, sz, v);
+}
+
+#undef STORE_IMPL
+
 #endif  /* TSWAP_H */
-- 
2.39.5


