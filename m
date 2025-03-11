Return-Path: <kvm+bounces-40723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F39CA5B7BD
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 05:09:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 71421171D37
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 04:09:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD4621E9B1C;
	Tue, 11 Mar 2025 04:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x46E0Bve"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72AD11EB5DC
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 04:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741666142; cv=none; b=Ii0Kow46FlrBs73BO6F40Skr40U/Om/3Mdv8KWcMlr1wnQ3aH3XQy0hAo0UOotm7GTZqbsmwlnhN9LWfhlEIQiVF+JTtU42nzQ9lAjhADCZuCNnIZgy13SMATu3KgpSwxtf5Bp1S7svbiaifwfqBH6+h8ZvbRdXcPy9AtHngcEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741666142; c=relaxed/simple;
	bh=qQCAyHuPdZVDnIthvYxFsDITvp5nIhySPdbWtVszCSQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EjDViTfPjMS3EGGO1fggw4MPth1mtZZT1TkLmXdueUHNudU6UFvxUXnQU24e33aVwQ8w1XxtV3nZolgXqjTLh0Z1Y13+PzNyseFGcdR5rEXX0lMsyoQAZdzKUdo0sK0l5MTScr6gW2U9W5WepjWJHj7Xy1ktiexqpeZ2ltmJPuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=x46E0Bve; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-22435603572so52632775ad.1
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 21:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741666139; x=1742270939; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p9XKPWEC1FDWwfXw4amuYrHiaWnSduBZ0xkgSDXw7jg=;
        b=x46E0BvevzaRlV72Dnw1mbGDDjxoLdxYtsapxfF3xg/EmSyhzzlTQSvwsy/tnSJESt
         bNyOYGRbUGCO9qMiCtrkLVO8NJJTTZlqiUuhlo2OMHDhDeHE4Vw2LCIPRzmwkCm2Iq7s
         GH8JDVxCrdKR37L6kcj6cBNdiyAMGwCvzbgC1Wq4ohAfP3XsJliTFbfVdRUeHY8wrPWu
         vkW03VJ03hgFwWRJAny+DfA4J5EPQ2c7ImuJTTvPvlmMmt9uH7Z7zvYy5XxTSsjxT0J7
         DkIzV9OD0ssLr5W/Scfe19Ev/WhIuHdNUIvYBmkahBpxNs/N58+DJEOZP3F3zoMUuuwC
         Bo5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741666139; x=1742270939;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p9XKPWEC1FDWwfXw4amuYrHiaWnSduBZ0xkgSDXw7jg=;
        b=PVlfQc/mOO8BMU6hq30+mkqQLH3FE0DglST2R4qnBrNCU54unp3zRb0IpjeJuxVguT
         4ri1OebWNvkcK2z8WfqVyfaVyIsmRWw3d8H1I0Dvc4I4pD2JmfW2eMP4P6r3Mk2AejIY
         w0W30HuoywhTChVdLIES0S8jcCp0864jB/gj3lhErXIkjs8d7KGnBDs0EU6zO74nwAnR
         8++njsmsucEqKZEGTCZYRDsDVxlklhrvkchopIoQP0GH92DKhsdtDYbtf7F4LRAu02y+
         1eZ8fnoNlmS+bsKiyepyf03dunVTX3M9qzxDH7Z1ydE6tQawC/maF8/WJf9zLBPekODq
         VqKA==
X-Forwarded-Encrypted: i=1; AJvYcCWdVJlO/QMabktLbJKxSdhnFqLf50yDyyQ74H7p/MA6GyHM6///Vk45jgPISXrkQbNNn5M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8GPr2F3oVYK70MEVYWj5DYYavKcNmMce0mBSOSrn3JK0BB3pM
	juhAep9ErBJG+McbZ79vy18KFZiemwnBGOwvRc8Pvx2eyyxqlg5t2It9ZDdJbs4=
X-Gm-Gg: ASbGncuP3rBScXeKy2HK0IrW0MYR7V6ri3deSi8jv+2D5Hh2B0kdkilg6fIVzGs/vED
	8QGraLJePx4fQT0R1Y3ZVaowuqLZgjwXxNVhJGNBnHaa0Jz9uobGr+hh0MEKu0k2D7dtDmx+7Wp
	9nB+69r84ncVXuI9AWKdL9nWBHKPHwwAvPa6oQgHepxMkV3tGlHdBOh285G1l0V2dbBUvJeNbUS
	+5DMHiBOL5N0FFP7ypB610dbh/PwdjKmIdDNtOGOa88DpowEMbn57tU1mz6tbYT9zYf84M2cSHm
	K4PGbZkQMDk4ItcH0WI6YLLv5JtCL9llQSPDbUFEUppe
X-Google-Smtp-Source: AGHT+IFULxKXKLSRt6Qs0nLWBVqgQyDOkjRhSbU6XrRQVwLJue3Ph3bi7X9tYlurUTD8KJTtNJkwJQ==
X-Received: by 2002:a05:6a20:2d24:b0:1f5:7007:9eb7 with SMTP id adf61e73a8af0-1f57008366dmr14192716637.37.1741666139634;
        Mon, 10 Mar 2025 21:08:59 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af28c0339cesm7324454a12.46.2025.03.10.21.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 21:08:59 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	xen-devel@lists.xenproject.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	alex.bennee@linaro.org,
	qemu-riscv@nongnu.org,
	manos.pitsidianakis@linaro.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 02/16] exec/tswap: implement {ld,st}.*_p as functions instead of macros
Date: Mon, 10 Mar 2025 21:08:24 -0700
Message-Id: <20250311040838.3937136-3-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250311040838.3937136-1-pierrick.bouvier@linaro.org>
References: <20250311040838.3937136-1-pierrick.bouvier@linaro.org>
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


