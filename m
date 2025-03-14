Return-Path: <kvm+bounces-41091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FC39A617BE
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 18:32:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4029A16761E
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 17:32:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B829A20485F;
	Fri, 14 Mar 2025 17:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="s59pAnqg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644DC2046AA
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 17:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741973512; cv=none; b=oz+4/SlQ5CQ+3DqybmguNIovlnKvRVK4zojauD58GkgdYlv5gmOa9AAM6A26Ak9LlxnHtjpkMy17MyKb5KX3c1rvO8ApEBMIZIDcvdjqkFmqRYvp14aG7GsbIt6gADnE/ZzL4XVbvejCfAKkzfUdRjtXHeFU0jCcIn7Tq5T0OKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741973512; c=relaxed/simple;
	bh=tsr8Vu0yCbhmYRJ+c2Olh9gVNG1abA5bAWFfRS2LzZg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HQH+uSaT5AIL3mxLPEJ2zuDNTfUhfFGHawS4WdWf50LnI761pc9ZNSs695iHC1MBMe9193biKG32ORQbdm2k+Ydx/vw0WOM8vxISPnlx06+O/e8B+6yH+SBU8lgCZ8SbJf5gK0V1PT7i0dg/E7JjRhmaFzy4rl+frW3bsSHrGzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=s59pAnqg; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-22548a28d0cso69285805ad.3
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 10:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741973509; x=1742578309; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G6OuFeXnonCJBRRaCKlE2hD3nLeAbwsquVgoLJADjfc=;
        b=s59pAnqgbzUa1qiojfCBzGS6z9p9S/tV6snWiJQNBI8birBMgDgvPVnjopwZueNn1U
         wle3socYmIJUvDe1R881JwtlebhC8JMJCFopYi3zRCsof0LV1/gYpG4siYZuxmQVrmdG
         NzLiXSUaiCh9NAmeBYK9LFwPbFdkLwZM8PyD9su/WcZxWPU5acyhhZYSDeUus2fP4EUx
         669TYoW7BbRK0sn7K2ip3eXuKgV0LuvZmwDaT77tZBiD1hwKktEIri5qxdZmiGma7yT+
         k4n+qt8ajV3vIcYxLymOa9iB8vf0uwP1q04l27pPFDBU9Qi+ipW/7L6k39XfKtTyPTT8
         nzuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741973509; x=1742578309;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G6OuFeXnonCJBRRaCKlE2hD3nLeAbwsquVgoLJADjfc=;
        b=MbWSiACd3XzLJNsNnrlp/uCth+dXXhSsslQHqTqqbcBdZJZMfj110FEQHnzt6YY50E
         hhLm8w0dE9DWF8ZJ6rlJP7m29xR6k4zAksUq8b8g0zJYX9lC4tF59uArJqTs3WDdGpU9
         TbryiYnvXr2UD0rccGHLksV++h6fg0PFJFAKz6tqtQikWzbk+NwF0hm/qpRyFk1isiYv
         5zrM5otPy/atYmn+ItXsw747NQZB7trRQmx6L8AYWHkzyEkH2b22mwcdMyQ3LnbWMknK
         zTKT/8Tw/3QfyXu+4kXzkCjrVc4LiY4p9c/g1CU9Z0vdsQM38MRmMeZwD2GIXH9oDZ+q
         ckFA==
X-Forwarded-Encrypted: i=1; AJvYcCUgMgna0gSbcdNNBPmz8gNfB3pxg6WEvuwQU+DkWy/l8cIijxUkrvcX3KiZoVOXoLOfThg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMr7DZkRLplQ9p9rqBZGY52AdQkQuG2gQAOyko9ti5zXOX807k
	Yclen8N29Xp8/qCcZqENFcweLLWtNJdWjWANvf5WD38yOXnx7NVzSx+m4n2rTKM=
X-Gm-Gg: ASbGncsszfLrmxrutJdniMHXwxPQV/aLAHkeycv9V85Dda2oL6J84W2GjYpvKvv7nxV
	F1kMrymXHA/NM600OLdP4XoRFQaNVSpBKolMEij6+nac5sxx/TcEYUyMQ5jWBg8aIDAqBCX2/wf
	QiIeAuwIyklYg8v5ahP/+gNlIcUM+g92eP4jYgs9YvOGh6fDLVWAkD5z4XcduAy+qKByRTuhLZh
	mZKAQJu4ik0VXEI9rJ6oC9BJBaMhNPQ0H7tFpX4ot85ycxcrkYVATqhs3j6DM/KTpSUBl0mmC3J
	CfJ8xf6c6s5+gdS8fOlYYGiexytj5OKCNWUEx447K10G
X-Google-Smtp-Source: AGHT+IFQBeqqn3ezA5En8rRFWwDRdkhHWJ51dC4tNWFcY4zpXwmWJXk93HseKx7PQbRLNq1zxfYk9w==
X-Received: by 2002:a05:6a21:1519:b0:1f5:8a1d:3905 with SMTP id adf61e73a8af0-1f5c10f7d60mr6252806637.7.1741973509576;
        Fri, 14 Mar 2025 10:31:49 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af56e9cd03bsm2990529a12.8.2025.03.14.10.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 10:31:49 -0700 (PDT)
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
Subject: [PATCH v5 04/17] exec/memory_ldst_phys: extract memory_ldst_phys declarations from cpu-all.h
Date: Fri, 14 Mar 2025 10:31:26 -0700
Message-Id: <20250314173139.2122904-5-pierrick.bouvier@linaro.org>
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

They are now accessible through exec/memory.h instead, and we make sure
all variants are available for common or target dependent code.

Move stl_phys_notdirty function as well.
Cached endianness agnostic version rely on st/ld*_p, which is available
through tswap.h.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
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
index d09af58c971..da21e9150b5 100644
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


