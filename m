Return-Path: <kvm+bounces-40954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F849A5FC06
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 17:39:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7500B16AA78
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 16:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC9C826138E;
	Thu, 13 Mar 2025 16:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="U2weaT4o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3C2269AF4
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 16:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741883960; cv=none; b=RJSOATOM1YLTvr62Fz2Gk86AzHcjHMRyEAu1VnMjbCVW6W0PjQbVmQtD7dgxF5E52bkczhFoufbrx+1Lw3NvzFaPQUFt+NegAdMWwaTZTM+D7W5mMcnl9qPqm5iWOiMYZLHSZQCi3LC9gGXEkeME673fbo22//tyUCch0Os61LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741883960; c=relaxed/simple;
	bh=tsr8Vu0yCbhmYRJ+c2Olh9gVNG1abA5bAWFfRS2LzZg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QQxZfH3sNV/sY5fM7LUtwSb7r7OfgxG1h2P4H7AVy0L7ik8oGCAWT64kKlhzEc1wYwXWWEIaTFJOSWd75wVDvJdqMdpPve1iZP/LT1o7OpxbacBWa4n1Vv2z5x99ajDdFgaiIU8CTXy/iF7z7Y1y7cMKJm2AX27UUiaQkMxr1Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=U2weaT4o; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-225a28a511eso22552205ad.1
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 09:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741883956; x=1742488756; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G6OuFeXnonCJBRRaCKlE2hD3nLeAbwsquVgoLJADjfc=;
        b=U2weaT4o4iDFLUN9w3sJRfwWf9mtSgOCa7OGr4cna3WcXv9dVaVcJ9k8pU0MeH7Spx
         WXC6nekq373y/pPRT/7a49RD8CRCgKlB0DBy289Lt2shvU0CgCnu5+PB5tFcfqv5blRr
         D977u6D0PJoh3CrjVgVbV0WqySco6Jnb5vXzrxb4wh3L1lUX3DlaFyf93JxOZrbpGle8
         mLLRIVbgJw0Rk5nWS4boqy65rSU8pbYyluhM6Cb8f7W1XeJBehKNe4rsEOfJlSuj79jg
         ebY4Kn6Fz9rFN6bGUVbd2DxBw5RGDPa6lcNfksqPwvx0T/8Wz+xCFBthSF+ioLYeIaMS
         0aZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741883956; x=1742488756;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G6OuFeXnonCJBRRaCKlE2hD3nLeAbwsquVgoLJADjfc=;
        b=P7bAN88FHA7eS0LRnIJcklHrQYRMmfl+M8p+e0gTfQsSDPrpIqKxLmJh35Z85SId0Z
         re3HYiCe2j5Fp4pbC5utupjWwSLjtk18mhNCWMuLlBbAiVJuhTPaaidYlL62A0TOsEJ8
         d5QVgTPDZc2CxterKEYNWPQPswOJ1GbSSSbredea0pRiJKOsSP5FoxyRJ7mubfgkgOw/
         hOvD+WhEN5QgnbccNGsPW0fM/zfwfU/NBJgl0PxKaU0cKXfC4USOKv4ZdBtLE8/nCGFa
         1D9vfWTxA8o80RD1CYKRGBvHI0XSepjDtWvfl413eqGLe5HVnBlBTJXIg1kEL+MpuHUs
         +gNQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6bbAoytpWoQHa+28LKy5+DbENhj8+kxzFwUC8GLt7nKmLENKsH/sLByYg9rDwUNR0m/s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8ajM5ZrHwNtyHVvYReD9IBfHLGZ/JCxihM2mlAW/lxa6HxGMg
	g9mhN12p/ObC3mD4E5ydMo4p/U0lyVCbf0gRpdIwQxVnDoVGeFOp4TnSmXmgvqY=
X-Gm-Gg: ASbGncsrdSnPJVfwTnnsSD5U+InklXhPvX6IDJTt1JQngusYas34+7zaAni37HGLmIB
	jl1LkVbmK5nxUKKeTG/I7CVneVMfM0mGeWmJEW7emBYYa9hjyJn0QnMTMd8pbHw9oquXCPhGyUm
	N1SaqGEh/24CpS50BZ+C3YbR+czwVI9x6zVaqRxup0DgnISVGHaeK4uBETwd+NSSDMYBDfdXV00
	p/x1onHthJPq+22rd13f2smEPvN7+10j64td58b9QJ1F+LgW3+nGeQYKs583ohq4vKgbFowzxE8
	IurJmboCRT/JjmX1k96rk1x++tnzebf14IKXdbgriWq6
X-Google-Smtp-Source: AGHT+IFAP0qoR6ylfmeu0A0f1WgQyrtvhvjwp1bL3Fn8cTt6DHZC87LNZvbpID5iZRw0pqfiPur+Vg==
X-Received: by 2002:a17:90b:5688:b0:2ee:e113:815d with SMTP id 98e67ed59e1d1-3014e842f8emr264471a91.8.1741883956066;
        Thu, 13 Mar 2025 09:39:16 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30119265938sm4020084a91.39.2025.03.13.09.39.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 09:39:15 -0700 (PDT)
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
Subject: [PATCH v4 04/17] exec/memory_ldst_phys: extract memory_ldst_phys declarations from cpu-all.h
Date: Thu, 13 Mar 2025 09:38:50 -0700
Message-Id: <20250313163903.1738581-5-pierrick.bouvier@linaro.org>
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


