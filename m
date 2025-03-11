Return-Path: <kvm+bounces-40791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9627AA5D025
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 20:58:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C86EC16D9AE
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 19:58:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FC2D264A72;
	Tue, 11 Mar 2025 19:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HW7OQtM6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00444264A63
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 19:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741723098; cv=none; b=jAqz4w6Ufn/iQb8yI737pyyMngeFsn5xGZdlu6rdXLzyf52PhkJnBO9vlAldXXVZzGRcubxCetWjnY8ixBABmNwTktrYFlajmrpdxAuQ2MBMDpmGLFEZH4fwAhhhoAmbN/UPfT1iqRCgJksKF7bDeI2j6X/W4XbkBGNXQocSjmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741723098; c=relaxed/simple;
	bh=tsr8Vu0yCbhmYRJ+c2Olh9gVNG1abA5bAWFfRS2LzZg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V/W/M7CWPE5kXaIDHby4auPSW++6Gxso0uDtAH+M8h5WMo8wiS4g03LS5R2VtpauQumIe0mX1HXTP7/4lyPo3u5PnacpxIQvFdQUAwHgqAAd4eJ5PZJboA6k7SSuyPgp6omoFcZnipjZb/BtR15Is6DPVIFq60teQ7EScCdzVEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HW7OQtM6; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-223a7065ff8so18595885ad.0
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 12:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741723095; x=1742327895; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G6OuFeXnonCJBRRaCKlE2hD3nLeAbwsquVgoLJADjfc=;
        b=HW7OQtM6w+MuJr691icW/65/ZbAYVzKLsPZy53kCm5DuT2z8F7Slm6syd5AY9yr9QU
         8rptwNgYoJz2lreK6Vpij94XoebK1st4TKkEKWgt8yIVHlEnwuYktX0USr8jjX5XIsov
         D6lnT1MWWmCav6uuF6I5RB5rXFxTGKjkksKhmAJaJyW26NCNJ6KeVSZr1m4M+GRhImhQ
         THL/VdjONZVxKSQI7HRXCxCDmkajTDrjiFNWmiNM8B1GOBGosilW7tdzLH21Kz4t2B3t
         OHQYkJGvIRsQqE/ttvZ8JZvTbAPK1LDZPWUOSlNwzjDyk+gHpaAnf50K+X4qwirJly9r
         cdmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741723095; x=1742327895;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G6OuFeXnonCJBRRaCKlE2hD3nLeAbwsquVgoLJADjfc=;
        b=AHzRUfM7by9/IHvFvEeFJYRNRwA8MnTe/17U9s/m+m+01uKUBxNtyIeTUiewFV7nvT
         pdEmszUfBFtku6oftKRhmGEMwN16nnpO0gWIthlv/SrRvQtDwicRNVhMzTPoXnmV0OuP
         UKU6k5CnKl544NYLOfXc2lQu8gZ0boW3iKhhoohqAGXzN5h/AyuQ/oLSwww2GlBQvVzV
         s8lm+dMv0zMAADNOMh28hFNU/UZKJD/yJTTP0e0VPu3O9HIucVfybBoan64GqG+jkfVc
         f8mOmk8OUaBGw1m568jIfqVESjWOA9sxzF4uApd6IzAXW8zeyzmK/Oqi4U0rfkgJQSXm
         nbtg==
X-Forwarded-Encrypted: i=1; AJvYcCWuJaBmL9RWHsOY9rixoOmhO3FvPVlQiQDXFFQbpN52z9XE/5jY20LlKIyk7ecdpoi1wlU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaGzeT1vwty2NQoEO4M45xy0AKGsj9RmkhlzzzF3S8gLbW+qQp
	HTuskPRgBlBljDAfFnc/D+EjPXlQrUvFdb0jPcDRc4XdTo1xIdl4aIwkjlFwYrQ=
X-Gm-Gg: ASbGnctM/5EUFxVghm/fB8OfRwfBXrDzFKhc42wAdrtlAL33sttGzAx5Zxt7J8Rm6UI
	mQx5/Zq1NLu0qlrXVjNa2drXr0A45c+LxNxM7UaUHc+a+57ACa5DWvhYVnzYlyXcijR25C5eh7V
	zQHC4RB2e3Js49M1NHrEilz6QH9SymdHGYTYHIi72+s91nricaNBjAvAkYiq2pKsifLt9dnOVIN
	V2ATdj20NPb6VLY9/vpJGy5xWGrRZq3+cuIJh0pS57VvHD/ql724MAxQAZG9jlPPGveet1QX4Ra
	rmJ0oMJ3f5ONTnQeWjkbm1tBc3yUf+G3mFm/37qUH2aK
X-Google-Smtp-Source: AGHT+IGNWEO4mZBHpAmOvbPEdLBPlFyMCMG4ZRJsA2UNTnkEr6ujtHjiyajOo8ag/l99JEaYOKJfOg==
X-Received: by 2002:a05:6a00:190a:b0:736:31cf:2590 with SMTP id d2e1a72fcca58-736aaaad27fmr26132051b3a.16.1741723095319;
        Tue, 11 Mar 2025 12:58:15 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736a6e5c13asm9646981b3a.157.2025.03.11.12.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 12:58:14 -0700 (PDT)
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
Subject: [PATCH v3 04/17] exec/memory_ldst_phys: extract memory_ldst_phys declarations from cpu-all.h
Date: Tue, 11 Mar 2025 12:57:50 -0700
Message-Id: <20250311195803.4115788-5-pierrick.bouvier@linaro.org>
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


