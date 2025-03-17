Return-Path: <kvm+bounces-41291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E2EC1A65CC1
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 19:35:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 016111726DB
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:34:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B37F31E5207;
	Mon, 17 Mar 2025 18:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qnpnP9HG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D3C1DFE12
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 18:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742236471; cv=none; b=fAjNnffrtc5EQqurBkwxvuMlMsnwpuBsTh2pGvhtzQ8vUaQcTXjI7fyDJ8IzcJz6H2HlbVoXZ6T0U6b/UOcmJIBUrnlA5tndfEWb7qcYn9ZRRLivnN1uyDrMMkVEMyeVX+y15P0OHI9DbrbN/Mxx5yxArBBLSHnIyBo/I6aU+Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742236471; c=relaxed/simple;
	bh=tsr8Vu0yCbhmYRJ+c2Olh9gVNG1abA5bAWFfRS2LzZg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e/D+nusie9f0PsQpawHMYfdI8Dk7GqQWf3y0DLUVq+W3vmZgyfjdsOAoZzfcS17OOTu9gFauUaX1QHChx61X0NIBrgCHatOq/eC61Fj2ErPY8Jgf1zLsEXty1h7QGQhcm0LQiMHCasYxIZD8LPZgpGQa2mPS4j5Sb4YNg5NvKK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qnpnP9HG; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-224191d92e4so91697365ad.3
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 11:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742236469; x=1742841269; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G6OuFeXnonCJBRRaCKlE2hD3nLeAbwsquVgoLJADjfc=;
        b=qnpnP9HG5D8CRLyaU+c1BehTn72kdkzpA1SpbBj8xImnxw/v11F+P5vb2vdQ/Yutz9
         bz+pU2jUgkKr+9BSjmgv8oeW7wwkIp5VctmMjiJxpJ0fwjufHW2Hps7+30+RPckl8OG7
         hu92VgoAwGqxAY4bcjz2kkkvOAMiAZeZwBPYA7rWNU78jwnmT+jve1MrjNZCEO5fWPkE
         nnYZz1H78T9IYGrfPRGSBOrAG6ouFLu2wEnEgPE+9ORTRkwWhHGjwk/R6SKo9T6WwGty
         TVAL3mfU2zaJwtd8S2sWE3EYQlC4LKv7t/zGPT7LgBdNey/zphCYa+GnQP+5kAhQfYgL
         ZZWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742236469; x=1742841269;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G6OuFeXnonCJBRRaCKlE2hD3nLeAbwsquVgoLJADjfc=;
        b=FiVvTxY3J7cvqXhWIg/ds+KhQZuwz1zixsPldOcJpGEU1iBNOJKwBYT7iRKkT4cKUw
         QcR5biHO4bd4/xna/eZ2AQU6AD64gJBIf1CTMzjshXHqDz1euQzuTMyTwvYtTw4v/J9R
         uHbr0fXcBaKUem82TsRqRYvzUvprA03e2qAc+5DUFXSx1bYS5kgX/kJEQiMXEDfi9K9B
         qyS/JgSYHIh6vLVYBS7ogeC8ysfdjJ6BxnNZbMV7wDVtYzy1ry6Ui4xg7n46reCM46XW
         LlW8utmNx5mfwjrveEr7ndN0Q2R0QBznuxV223wtipA+PFTLcOav3iqrzJYWi28pgU0G
         Kj8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVS+LlNPe/kpATXGsTqBJaOfACtqb723WSWorTcAT0rErt+eAbkNNnmKRSmyH3Pw1WvnKQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1VIx4p9vSmqJ0Kl433wqoEQbQ35Hb113/RToTFDU3Qk3FzieA
	nIfFF3KGOg26q1NGmM28elH6FGCzbdRJsPnKvKMvVQsPJxV6Bn7dCT0gFt1AnGo=
X-Gm-Gg: ASbGnctKlBZbTthfJ1TWYlI/8Mvj/bLnrOb8Jl8VknOlSLFdrLUnhepPWw1fJVo+xhx
	LAvvPwUJpxq6RLR/r+hGKMQtlrlH6Uivyr0nzawzscsylpbTUPr5XlcFMM8JFia8qeo++7TM8yp
	Ch6KR7aLilreLWciPSxdME7mVLI8C6BxCu2YEQFCxUis0KCGEjO5boA/1HTVSNCj/q3fA7f9MDh
	b+9HHayexmRNQQg57cI05t3iIc5Gz4oQiqsX2RJEcE68DJRzFhIXOGmUj7i/AVeehEmxZCYQ14N
	m/4tyiUG9l18Ory65geWgngGHPgvRoJz934Kq9hRxnbo
X-Google-Smtp-Source: AGHT+IEuktxGhHzx6xs3EGzvKgpAVns4GkbvMlee+9okZ79gnYJTq9xN+P/LP5FdgPO0zhqsq/U9Fw==
X-Received: by 2002:a05:6a00:1916:b0:736:51ab:7aed with SMTP id d2e1a72fcca58-7372240f242mr14927867b3a.16.1742236469458;
        Mon, 17 Mar 2025 11:34:29 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711695a2esm8188770b3a.144.2025.03.17.11.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 11:34:29 -0700 (PDT)
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
Subject: [PATCH v6 04/18] exec/memory_ldst_phys: extract memory_ldst_phys declarations from cpu-all.h
Date: Mon, 17 Mar 2025 11:34:03 -0700
Message-Id: <20250317183417.285700-5-pierrick.bouvier@linaro.org>
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


