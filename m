Return-Path: <kvm+bounces-40789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 49BDAA5D01D
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 20:58:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D6449189F485
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 19:58:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 300C026461D;
	Tue, 11 Mar 2025 19:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="X+x8NZ4M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B7D2641F1
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 19:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741723095; cv=none; b=o6W4KrjnCT/VMxBdnTm8lN7Z7XbYJNdkOrHW5RKSRtyQnz3m0gqd+LfWTGwwXtZSWUe/byn3DjOu1XN/MJa0qwOKmcgLzmtvgmfZPQWAVkPhDVxkitSaeCTHYaMqXyBAUmX2DSM48dLcdwXTGsF1HwtNyqzYBxYDETyAak4jFuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741723095; c=relaxed/simple;
	bh=6cdUkgilZ/OtUG5CSqfjwssNSd31+3Bqv7Sh94x+Hkw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pvuEdoNqq0muHayAvva8qHnpsqjC4IUqAfO/zHycIZ70OJQlaLItjPYK3UJMyhJbLpJCYYz8XHfhsSaPJ58+sJbcqJXhMg+d2HZuM3b1sBKx3Qcz/kHlekNJ040mXwr/3i56Y3FLOY055uvdmt6soybWkoIgICZL9Pr4lDZAdFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=X+x8NZ4M; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-22337bc9ac3so114171205ad.1
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 12:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741723093; x=1742327893; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fjQjYNlvDIsMbe7+veFF5h4s6vvln32m8yANkT1fS5Y=;
        b=X+x8NZ4MfR+5e+6GZTL5b33Ee/t6GP2CGgT/Iw4mxnCmwu1Nl1zHZPPmVnpgxnBW22
         AZfeOx5AnHy/J61IHmvBWxrFejO+30sqEb/81Yx7wPXJ1XK+jBcp3LuqSN60sgoVeyAO
         tEPYUaGTPnoSGOpdkh2dXsDmLfDf25AAoM+d8k8lsyS/p30QHe8DUBQ9/TolHDnFqn2P
         C8ZS6zl7RcqXUZqOEDYt40NPaQrUMyG7+3NAIU2Y/t/RDKiTfWf9hbBCpwVvqGad2ObU
         Kr+q96iCxPnPOtnzeHRBdIsP9sZ3hInbbEpZ22WvJN5fYRiqFCgLLtdayxpt1l919ajT
         yX0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741723093; x=1742327893;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fjQjYNlvDIsMbe7+veFF5h4s6vvln32m8yANkT1fS5Y=;
        b=iUN/h6rw9kjkGVToXxFkz8DgEUYMqOQQ0cqFSrT9DuXUn30Rxmsh3ZkTyGQdFkp8i3
         pEU+MnZh4NZl4lPiFL5RJSvd85fSyaW4cupflF888B2uHn33yGaG4KBBm4qc7rzf4HQT
         CB9t5vCb+pFeBvxvg1S08OfJ/BIMKoJ1Dm1E8RqGD8pTt/yW8ek8nbzxbA+0olHGnOcJ
         IWEyZBs+VFVQma80PzIoGfnJKXxUlyb8SRXIQuM8jOc/mvzhVThV5PPdJZgHK8UHaDoI
         1guz1gO5ipyGobb7d65zuQ5/s/uEHZNsKfqqBlm4is+8Rpa3XXXFOiObnbXiG9RAVtFG
         BuXg==
X-Forwarded-Encrypted: i=1; AJvYcCUJWRnaZVJCBwvrhsmPA5SUopu6TpunOFnOTLsJ8ken8+ZL5UE7kPMQ1EoLveo8ihd2wa4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZvhjbvTfEJlX7I6teqLsI7Nq+y/XxRc+upyuyhWtzgEmzR3fO
	+0Lc7JO0uWtVl7LhlI++UNyJzKtODknYkIUTWZ2l00fRDxzCvy5Udc6nx0Ij/2I=
X-Gm-Gg: ASbGncvvywNwAUULcrx/vAWMtCHuBNp+0rwIjibsPzl/KO6yRh8bEdm8heMqcPCyxo2
	ZuzLdcEsOefHfJShusATk5OhOaOx2IhVOy/lpLA7RMB7AQzsv+uQPnLMykXUGKOVhPISzTRiLsx
	Ii+tW493I/37DfXgZb1ZLY9vbFiaEf4hXsuJLbx7NUdBEKZ4HHoVxN9bF/l9GOM1HN0kYtSH1dn
	CpuGg83hrngWVPrUdEMO8SQY2sJqhpCCFbz9mldYIuPaEFFFaU9B9e6QlR+GtKeDOIbqx9m5Ea+
	1L9WRS0FbaaIet65CXVvVoLt2iB6BVnDqLDTjOk5afFW
X-Google-Smtp-Source: AGHT+IF/o3Z1voLQASAUjPWBawCvXOSnOMhb8Nk2igLOMO9aCbEfuSVrBfikbaQLM80fsMV5kN5HDw==
X-Received: by 2002:aa7:8892:0:b0:736:a540:c9ad with SMTP id d2e1a72fcca58-736eb8a17b5mr7090307b3a.20.1741723093074;
        Tue, 11 Mar 2025 12:58:13 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736a6e5c13asm9646981b3a.157.2025.03.11.12.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 12:58:12 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: David Hildenbrand <david@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Anthony PERARD <anthony@xenproject.org>,
	xen-devel@lists.xenproject.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Weiwei Li <liwei1518@gmail.com>,
	kvm@vger.kernel.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paul Durrant <paul@xen.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	manos.pitsidianakis@linaro.org,
	Peter Xu <peterx@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	alex.bennee@linaro.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 02/17] exec/tswap: implement {ld,st}.*_p as functions instead of macros
Date: Tue, 11 Mar 2025 12:57:48 -0700
Message-Id: <20250311195803.4115788-3-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250311195803.4115788-1-pierrick.bouvier@linaro.org>
References: <20250311195803.4115788-1-pierrick.bouvier@linaro.org>
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


