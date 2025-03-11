Return-Path: <kvm+bounces-40725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C1E84A5B7C2
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 05:09:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 380B1188EC27
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 04:09:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 089031EDA2B;
	Tue, 11 Mar 2025 04:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nkGKB+iS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDB31E9B1A
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 04:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741666144; cv=none; b=pjIXBU2EL/K89BfTBLrGZBSXM4ilOkd/U6bb9Ib5BVXpltR2t3skVmZKFd3ezNRGQO0xwtDYDRCWLwQHx+TjsSBH/DQCmLvIwEVwmXhmGDfMP8NV1jN1+/CEJJ3zzypx/FXkldXyUjNl5xtQKHVzSm15FxCvqUFOkHufsg9Pm1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741666144; c=relaxed/simple;
	bh=U3j0YvfkdFqSCbjvb9lRIX3g2cJcj6pAwUG7lv+G/Is=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NepSpMFzdclCGiT2sybltzHN1Mt8MgsecyvNBGu0oGzGJR2sNmTVC4fINexXdZr/OlcQ5552Ko7ULUE/cEAY9qE6xS+3BkC7kOj7sKHttgONhdqSWw1ZXJnuxzfR2FBFDbCe8dcyKBSu+py+hRbcznxJLaO9EupkgBDe2ZwUvOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nkGKB+iS; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2ff087762bbso7395786a91.3
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 21:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741666142; x=1742270942; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GZg0/as8vJD+8Um7sy7JKxAjMVLEtPUz9ZnXYeX+5Ko=;
        b=nkGKB+iS8bQoxe5uS2fe/t32G5/+w2wtCRKXIhsfNRl/532wPQckVW4YmkYulLdlvq
         Gv/dy+JhWkFFiR9fA9qYWfvpX+VSCXV/F2FrCY5zMX2KVGXUy8zO4TvDm1slo8btrnAo
         tqBSCSRNppsGC8EN7kEFbfI3I5Qc+78l2H4Pyjry3gwn9rCzM/9yE6Xa8Ih1ZqWwV83K
         0G0vduUfuXVQHtZSbo5mLG+H/eqLQBzUM2NmpwuQIq6zN8U73dGNJKjZTbeiWdXulPzA
         1sI0B0ngfQtQTBSjcZMYkmON/e9CRJouMzQ71OEhqb5EinX2fFOszyF8i/16M6YHo04h
         L99g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741666142; x=1742270942;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GZg0/as8vJD+8Um7sy7JKxAjMVLEtPUz9ZnXYeX+5Ko=;
        b=pJorpA2k0xWuQlIC8E/MKoYosp42QyJtDZs76FTK1mY4iwZ/ybSFfKhz3Bdx19zvGf
         zmuXKFNtgJxnRtraJAtRXV92c5rEQKqGM94/rzJL/7EHBwVSvh+IpPeoO/NFgECoGw/F
         OsrF+fIAXhqTRZcEN7Aa5i6dfbrga/05DE2oZ2E5uFpj6snJwcKEQn/LAvpJKhMtT2bK
         KKfX/wY36i7bHLBJEOoCfBZxuHTXS1H/BknRysJl3T+zc0O+NSvsSxmjWjJzkDLlneAz
         NBNYd3YeHCLQvRMhE/6JX7ZZNm3FNkTjLzXL6QIjVgsg2e0k+PeA9h8/Tn/HhkD1jaT1
         ZXkA==
X-Forwarded-Encrypted: i=1; AJvYcCVoNy6MWekXCKHOxTCMcAhX8u01bB1AUTTeAYNWJBRjpTZTS4HHIjlOFwa2EjBcqGUMhEU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQVHxQhYJxSEEhkmARXxynkJsI2ihsv47RsGE9FKb33OCRRKbc
	WnEiWHtsQBf1/u+938fkCmWE+rI70POgAmtlmD62fxctJbfdsZ85e8yVHNpW3VQ=
X-Gm-Gg: ASbGncvFVLu3J+lO06X+7C1l8y8z8p1GKHfA1ldZpQV47M2TcBBHLHTCDWTiKfSFWKV
	IxA9vR1i2L3dZ1XuxdO33bwYCUgVISuZ8bOm0MnDCDJFJ8Vk718hqrOR3sZBfAsHSeFL09TquqU
	YsxWqU1sSdaLqotlRCXzwegeEexJY79iN6v0a7g4kclksmPnjIIgHW1ptXtzp4dZhdrgFrn/aSG
	r7H0ow09unl3WduOckn+6GizFCXHYAPJXWEolOIHwaMxrf3/Bd+OsJBt6eNoQUFdUKlbKi7C42I
	+3PQ2oZnR13bMcLHcD33/kyQb9RDZGTwVdiCw/oRSUhV
X-Google-Smtp-Source: AGHT+IEv6pfYhMlZcVFtUT8KTCc1zYGaqiUcLOn7dx2sPDPFPmpFWZtYBaUHHMwx5Ykg9mMF6L42zQ==
X-Received: by 2002:a05:6a21:7002:b0:1f5:7fcb:397d with SMTP id adf61e73a8af0-1f58cb1bea7mr3411754637.16.1741666141836;
        Mon, 10 Mar 2025 21:09:01 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af28c0339cesm7324454a12.46.2025.03.10.21.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 21:09:01 -0700 (PDT)
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
Subject: [PATCH v2 04/16] exec/memory_ldst_phys: extract memory_ldst_phys declarations from cpu-all.h
Date: Mon, 10 Mar 2025 21:08:26 -0700
Message-Id: <20250311040838.3937136-5-pierrick.bouvier@linaro.org>
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

They are now accessible through exec/memory.h instead, and we make sure
all variants are available for common or target dependent code.

Move stl_phys_notdirty function as well.
Cached endianness agnostic version rely on st/ld*_p, which is available
through tswap.h.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/cpu-all.h              | 29 -----------------------------
 include/exec/memory.h               | 10 ++++++++++
 include/exec/memory_ldst_phys.h.inc |  5 +----
 3 files changed, 11 insertions(+), 33 deletions(-)

diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index 0e8205818a4..902ca1f3c7b 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -38,35 +38,6 @@
 #define BSWAP_NEEDED
 #endif
 
-/* MMU memory access macros */
-
-#if !defined(CONFIG_USER_ONLY)
-
-#include "exec/hwaddr.h"
-
-static inline void stl_phys_notdirty(AddressSpace *as, hwaddr addr, uint32_t val)
-{
-    address_space_stl_notdirty(as, addr, val,
-                               MEMTXATTRS_UNSPECIFIED, NULL);
-}
-
-#define SUFFIX
-#define ARG1         as
-#define ARG1_DECL    AddressSpace *as
-#define TARGET_ENDIANNESS
-#include "exec/memory_ldst_phys.h.inc"
-
-/* Inline fast path for direct RAM access.  */
-#define ENDIANNESS
-#include "exec/memory_ldst_cached.h.inc"
-
-#define SUFFIX       _cached
-#define ARG1         cache
-#define ARG1_DECL    MemoryRegionCache *cache
-#define TARGET_ENDIANNESS
-#include "exec/memory_ldst_phys.h.inc"
-#endif
-
 /* page related stuff */
 #include "exec/cpu-defs.h"
 #include "exec/target_page.h"
diff --git a/include/exec/memory.h b/include/exec/memory.h
index 78c4e0aec8d..ff3a06e6ced 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -21,6 +21,7 @@
 #include "exec/memattrs.h"
 #include "exec/memop.h"
 #include "exec/ramlist.h"
+#include "exec/tswap.h"
 #include "qemu/bswap.h"
 #include "qemu/queue.h"
 #include "qemu/int128.h"
@@ -2732,6 +2733,12 @@ MemTxResult address_space_write_rom(AddressSpace *as, hwaddr addr,
 #define ARG1_DECL    AddressSpace *as
 #include "exec/memory_ldst.h.inc"
 
+static inline void stl_phys_notdirty(AddressSpace *as, hwaddr addr, uint32_t val)
+{
+    address_space_stl_notdirty(as, addr, val,
+                               MEMTXATTRS_UNSPECIFIED, NULL);
+}
+
 #define SUFFIX
 #define ARG1         as
 #define ARG1_DECL    AddressSpace *as
@@ -2798,6 +2805,9 @@ static inline void address_space_stb_cached(MemoryRegionCache *cache,
     }
 }
 
+#define ENDIANNESS
+#include "exec/memory_ldst_cached.h.inc"
+
 #define ENDIANNESS   _le
 #include "exec/memory_ldst_cached.h.inc"
 
diff --git a/include/exec/memory_ldst_phys.h.inc b/include/exec/memory_ldst_phys.h.inc
index ecd678610d1..db67de75251 100644
--- a/include/exec/memory_ldst_phys.h.inc
+++ b/include/exec/memory_ldst_phys.h.inc
@@ -19,7 +19,6 @@
  * License along with this library; if not, see <http://www.gnu.org/licenses/>.
  */
 
-#ifdef TARGET_ENDIANNESS
 static inline uint16_t glue(lduw_phys, SUFFIX)(ARG1_DECL, hwaddr addr)
 {
     return glue(address_space_lduw, SUFFIX)(ARG1, addr,
@@ -55,7 +54,7 @@ static inline void glue(stq_phys, SUFFIX)(ARG1_DECL, hwaddr addr, uint64_t val)
     glue(address_space_stq, SUFFIX)(ARG1, addr, val,
                                     MEMTXATTRS_UNSPECIFIED, NULL);
 }
-#else
+
 static inline uint8_t glue(ldub_phys, SUFFIX)(ARG1_DECL, hwaddr addr)
 {
     return glue(address_space_ldub, SUFFIX)(ARG1, addr,
@@ -139,9 +138,7 @@ static inline void glue(stq_be_phys, SUFFIX)(ARG1_DECL, hwaddr addr, uint64_t va
     glue(address_space_stq_be, SUFFIX)(ARG1, addr, val,
                                        MEMTXATTRS_UNSPECIFIED, NULL);
 }
-#endif
 
 #undef ARG1_DECL
 #undef ARG1
 #undef SUFFIX
-#undef TARGET_ENDIANNESS
-- 
2.39.5


