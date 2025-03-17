Return-Path: <kvm+bounces-41289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D3552A65CBA
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 19:35:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 15A55188EB94
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:34:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45AF21DF97E;
	Mon, 17 Mar 2025 18:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Y6bhYaOz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33151BD03F
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 18:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742236469; cv=none; b=KEM3o6eP1V9fEarr7BI7qxMOrYI1XV0sijGsK8dL9nZK/X+GePoFq2I+2UnJwmx4OmcjMGrDnL/B03ZoRmyHU4dn8ZHZEsXBJdZGpG+8kE0kSMaa7CDtx4GcyEbcT5sWDRaWi7gkLns3JzoVBbpJUmwTNzMQth+7ZQgmYmsFG+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742236469; c=relaxed/simple;
	bh=6cdUkgilZ/OtUG5CSqfjwssNSd31+3Bqv7Sh94x+Hkw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lYU0iAyxzz3n/VL7Yf9hVeiU3vITtBL6qtTkGPo7HZ1/0aeOC6dMkhCH3usxHSYPhP7GzjI6NB2xbR0nXnbI0rTus0pycJLdbhZTNoft2mMeP4rlWzlCLHknAExQyMG5RFo5iuP4hxDyKpUwvudaL9hm71hQ2Lo35X7M4ctd2Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Y6bhYaOz; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-225477548e1so82724015ad.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 11:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742236467; x=1742841267; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fjQjYNlvDIsMbe7+veFF5h4s6vvln32m8yANkT1fS5Y=;
        b=Y6bhYaOzzduqDzx5tzfgkXDB3l2tcAaUJ3+Eb2CkCdRxNJ1O9WYb9VqfJlI7NdUdfq
         oZa8lSWRll+8dj0ev1XOLCxpaLkBRx6YckR9HJb1ofhxbm0Y4lP9kZLVYA++Qd6JuLF4
         gaixm0rbaNGPjmZMDt8n4uw04tY3M7gDaDwTPOkQQR21Ddtn544LFtLQljXVbScoD80q
         upY0b2wL+9HTZgUjMmc8cB4dRB+U8MZXQGRbXi4Iwgk3BKeCzDRDTqMiY56GxNVGzanC
         iRbZCHVpfXzZYjaked+mbYLEpDwU11o9k10uSCakOLGs1WkdApCmp/8NL5NJSLQKi/TH
         FdeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742236467; x=1742841267;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fjQjYNlvDIsMbe7+veFF5h4s6vvln32m8yANkT1fS5Y=;
        b=XIx1MKuiTc05LP6vMjWKLnFjHk+v+tWkkG4jbO1C8Sbcpbzu6j/IMZSxD30JYHuc64
         /5myHFOFmEM9z7MkkJlGyXyA1KxfBHAhAKelQgpkC/qTsbVCPkCe4ri6Keubdsyb2x8Z
         ptvhmDciQ/+kmr0zmz4/mnKxpDRvrEYzaCcyfIOTIUJPjYXE7z1GnA5uCOVWKYyPwjtV
         zN3fULp8kWylhz6Oj9Lfzc/2dBeeKK3rH2IupLRKFzUfS5Uwi9VZbfd3Kdabr4YjwNnt
         SrFkWffrCGrlzEsydA3tcYIT/kHgb4PaMrpdDp1z8hlqoW6IRxjHgLMT1NsQkXb96YLn
         1V4g==
X-Forwarded-Encrypted: i=1; AJvYcCVGUPKE0TMb0Jpa4cvSNMNuwkMNZBjfNBNsZuVlZ60+ve7VHikS9NGvgAJqgIWs7MGhxpc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzLRJ1M7NeqUIgdhR+tI8mgotUyUcqinZkhYH4KabPcEU4oDZn
	xKqEsjfr9P3yoZeGFa66wv7Kd3wd2/MGTtwIIxyQfVcKUJDE7tn4lE5EBS+G+Yk=
X-Gm-Gg: ASbGncsraArebyHjiycuaJtR6uGS8pAw3AzNf69R7D9yScdTh5VnnzVKelJAbrOKqjL
	sxF0br4+pN57tL9d7fTGkDyAkrNBkFX3MS6Gq0ivSYY9UvWN95rioXsIRXsAoaQ9bhmMMvjOgb5
	w1uBVx2jo/pz+AtSCz5FcvdBA8PWPWEdzBfactXKiC8pgrsx1iZpHd/uMwQ20ubSUVzAmEtTwXS
	UyIGquLIUH9piCEPG/XH71BbMRPSC/G7Ed5xNaYVJC7bQ2Khoad9XC/hpyxSpJDuh2/iSlxeBHm
	7BBn1SkYybK9Lj23JOS9zVBv7McveHGu9Ge6aWm/efdJ
X-Google-Smtp-Source: AGHT+IFi3tqJwrzQePDsXIvC4P2qzcui7bHazmhEI/k1ekPUyZPPBb0NOgqZr9PPYc71RHo1sxISkg==
X-Received: by 2002:a05:6a20:4e08:b0:1f5:902e:1e97 with SMTP id adf61e73a8af0-1f5c133476fmr13616359637.41.1742236467105;
        Mon, 17 Mar 2025 11:34:27 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711695a2esm8188770b3a.144.2025.03.17.11.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 11:34:26 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>,
	xen-devel@lists.xenproject.org,
	David Hildenbrand <david@redhat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	qemu-riscv@nongnu.org,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	alex.bennee@linaro.org,
	manos.pitsidianakis@linaro.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alistair Francis <alistair.francis@wdc.com>,
	qemu-ppc@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Weiwei Li <liwei1518@gmail.com>,
	kvm@vger.kernel.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Peter Xu <peterx@redhat.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Anthony PERARD <anthony@xenproject.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 02/18] exec/tswap: implement {ld,st}.*_p as functions instead of macros
Date: Mon, 17 Mar 2025 11:34:01 -0700
Message-Id: <20250317183417.285700-3-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250317183417.285700-1-pierrick.bouvier@linaro.org>
References: <20250317183417.285700-1-pierrick.bouvier@linaro.org>
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


