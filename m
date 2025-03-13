Return-Path: <kvm+bounces-40951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CA8E4A5FBFB
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 17:39:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 041AB16B552
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 16:39:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED85D269B11;
	Thu, 13 Mar 2025 16:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Imo3RlEv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D4A267B77
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 16:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741883956; cv=none; b=hZjIWYAMaEYvNmZN1/vl6acvxUOFiiiAC0mkaE7+o7CNZWC5E0j4lHIS8372weRfrY5cMJJ1GvIJRsYEvBwTNTnQtnO+ihFQdIdv1r5oXghJp1iYs2B2+zpYNs4f4rJ3ugpwQLvi7OWv2jCPGuC3ACmryeGhFsxkgAx7RWAz+hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741883956; c=relaxed/simple;
	bh=6cdUkgilZ/OtUG5CSqfjwssNSd31+3Bqv7Sh94x+Hkw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N50JxW6Q7ViCrc8//7a55nIXqfnUgJEAimv33P3nMaZ/YVPv4KateorajsMhKhNGQFH4gT8dFGPWr7R4elc5YVSiCee+rSnnAdt/WpFnl5mkY0FtzWpsH6CCLJ3fOCtkePwi5ah8L7lYdmzvM6rGIImzmy0Jb8G6AS6j2+g18Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Imo3RlEv; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2ff799d99dcso2531903a91.1
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 09:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741883954; x=1742488754; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fjQjYNlvDIsMbe7+veFF5h4s6vvln32m8yANkT1fS5Y=;
        b=Imo3RlEvWW2EZsxLK1yCtl4FFB8XugCTJJ8qsUsF/PlQfR6RNjFdWqKmzi5M2ssbFE
         67iim9swz1yCc6hYLsYK+v58xhed6zOBSrcDkiA1oK6bLcYqc4dpu0xjA3cjXVKE4T16
         FCKI3ZboGyNouZ+Y5p3Id3NnQxnJ2v9ErwKF2tnwVngd9ss0xAIp66YgkX0B/dJus6vT
         vb/CMVa+4nJ7mzatTBoAOp7dnHruru06NDOntN3C966VrW2nntZJgL0XZek5y3ytunQR
         CJdAuQhZy0obNXSpd/x/krjQexnpOyMxxpgPEZ6sOFtfrnXtkWo548ZlGHAEALlx7DTg
         8Dgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741883954; x=1742488754;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fjQjYNlvDIsMbe7+veFF5h4s6vvln32m8yANkT1fS5Y=;
        b=fbGijQaFNC98uyj0zFW2EfQg6WNejS2b5e6mzI+bJK+Wv5yuH5Em5Bp281ugLolFxT
         8poTo0TtWBV8vbJMHDDrg2OTO+pGiHoZ126ESbowpcJFZbM/v2dO3zIwXHFM5APntVhg
         RMbrg5e8ghs/IQXE8h/LMYJmh1SAzXo2QNCwTtKyQdbzkRAzUBn/yTaBXIwbo+l8WYY1
         DIAH5kYGcet81jF3eThqMnQdo9aGQ07mjbLTjf5L2MZLoXMg0NE88Xk4YQSadCB9rpmW
         rI13pZp+Im7NhXilDtIqUjNKZ7viL79AFSWXNXOLu85u7aPpCoFSybmTKujgMBuM+YyR
         p5+Q==
X-Forwarded-Encrypted: i=1; AJvYcCW2+Owp6Ft3qySSp3/LxF3uEEirPhxGIQRrF82+qkixJdg6FELde1PQLFsVelHT37pgKrA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgfqC/lbFimyqXB3E89GBxDU5F15IgBnRKH6+VERSX81JuDDd5
	fheJ8gnMx1jYIIYu5kb4zY1rBpVX29nv55bJVkh9nzJAQZUgGgsCBJOGsd4IaD8=
X-Gm-Gg: ASbGncshmLqrVEoetmdIVAsPaljtvT7xrtObu7BZPJfuA8XfVhxmLqz1gG9hsTGjs3L
	gaqe/YWe+JbOxQftUtpKimuwXu4hMR7yMkBtK3o86khUJ3Dj76x8du/kIBCddrAYRq+yUsB23A6
	JaI7LYOFH0U2fnf947BZSbchyO9EeYs99gFi/qmRzXqpYeWLVM+JjSYmE8M4tDV7yNw2IrupJAi
	gTflz6TMkHwTjwSRJn7u1ifv4xYxwGzyrvLcxYdvU8SrgcnR2WSo3SeSjyDQw3q+meu8dY8+sYr
	WUHk85oR7H12EldsR+6s17y79U0YwNZNTu81GMPf0wew
X-Google-Smtp-Source: AGHT+IGAE0wRrFnOgUSptf/ZCGVy3gy2ROtBxgIz+VJH5KWtqtjx8oj2KP2h7DP6p39QjbuO2M6/IQ==
X-Received: by 2002:a17:90b:264c:b0:2fe:6942:3710 with SMTP id 98e67ed59e1d1-3014e821305mr250112a91.3.1741883953849;
        Thu, 13 Mar 2025 09:39:13 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30119265938sm4020084a91.39.2025.03.13.09.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 09:39:13 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	xen-devel@lists.xenproject.org,
	Peter Xu <peterx@redhat.com>,
	alex.bennee@linaro.org,
	manos.pitsidianakis@linaro.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-ppc@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Weiwei Li <liwei1518@gmail.com>,
	qemu-riscv@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 02/17] exec/tswap: implement {ld,st}.*_p as functions instead of macros
Date: Thu, 13 Mar 2025 09:38:48 -0700
Message-Id: <20250313163903.1738581-3-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250313163903.1738581-1-pierrick.bouvier@linaro.org>
References: <20250313163903.1738581-1-pierrick.bouvier@linaro.org>
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


