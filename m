Return-Path: <kvm+bounces-40952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BDE6AA5FC03
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 17:39:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 230091890DD8
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 16:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 181A9269D1B;
	Thu, 13 Mar 2025 16:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wubVLqxm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7F313BAF1
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 16:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741883957; cv=none; b=fRfnxrRyKwBln2E4gRgGzQZ90TghrQAAgCAqVCQMwb1LIG5waGKNZZwkEMpYH5pMl1/Qj9fwpM3CfqvBqk0jT8FFXVxCtu6pPfXMpwc88Tcvg+6tBevgxtRQf9hAI9x2/lMAC9My1dWM0xyFeyPNa7zj1UcF7uQXIPW4AvgZdIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741883957; c=relaxed/simple;
	bh=oqW9tTQslkYwWgYQ4FVxpgiaLvEuigwHwZLhfUQTCic=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YxM0zXNA3x1oC56cAXKE66pGp7RQEWptj4/S+t2rwuYp/EjFcOGXXMHUpT4n/iEHPS52GBf4LdW/i5Ck5xAtRdhZ1hHU2b6pufo5QsoUro034oxDejNk0gvxjE5HKayB3ohGmVBe/UjM1jfpHYMvqEMELK6E7pP5lhGf/u6UUIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wubVLqxm; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2ff784dc055so2103108a91.1
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 09:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741883955; x=1742488755; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fcP4MFj0H7Fu3AxOxTbJlPG2KgbdJwiBtz5sSPdKZDU=;
        b=wubVLqxmw+Ii6tdF0/hGLSOO2Wkz51VOuRLY0K8t6Nb5lc3vJINaKLKbegVMokXG7/
         4h+Zc53kQUslKv/jUGxxsEem93+pVbhDNg42aSrv+NA7z92SspUlX8qsB/5f2g3aPVr0
         GWndOdEmr90pPMfGZcvNRXBWESJo/9l/jv/212/HI2qeUH58hctz2Ehanmrvawf32/3e
         GgcD0WenAwqBS6kMSbTZeJajUFFJnqY8rrPzKz7KZWG+ACsTczPLdmQrKk43InAr/u0+
         aHElB/ch2BSaUA7DSCaPkV1J78JmV1RGNRPVZ12rxFWbyojTm9fYQ1aHNkzZYMXoghO4
         XTyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741883955; x=1742488755;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fcP4MFj0H7Fu3AxOxTbJlPG2KgbdJwiBtz5sSPdKZDU=;
        b=Q4/CBDHEJosZBSUWcPASqbZ4/f9CBt0rHsggG/fH+D1+TZOjf4J76fXRB+SkF8Q0Tl
         WbTawbsiquak5B/CYjzvi3CSD0W0wLW9wvRZqMnaFBWEnOYZEe1whFeBvGTSzbGRGxKL
         nSiDWZDhxGoYx+eb0RUv/ZZrrzbpAzi4nvXUULU+H0y9d8vstESXbasSExAZhsqQ8c5Y
         vgoMoUX/4/H07jjWBTWWtyEuNKdmEt8LzaLSjylyrM5UEeqFTRhteDilUrP455WPGCRz
         rPMBIFkjf4E+hhKPa8H2dCnN2Xwsiy0JK66KqZZF3y00czQ1ydM68pypVPhXdxYCIqAL
         vIXg==
X-Forwarded-Encrypted: i=1; AJvYcCV3hp/iIEsgDVpi6vJWrYtAjVi/j7OBlEv5HOgfVsibp+GB405d8l+JjAfMV3M22Um/4RA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHV0rldISTdCYJ/OfwYjX7pGS5v2dbx8hReusaU9zIBjmNyvJC
	3bwsiawC9FInAcapdAqx7xSK8yJAFiflYLI7auN0O2TCk9/Z2OXLafnAcZSV3fbhhX0NEy6AJ1z
	wXT8=
X-Gm-Gg: ASbGncu59GTvf5VP8SpD9tmSXtxh6B6TfoFclpflVgdZH4rfDAjw6kTxVkixOlgOIMF
	kWg9Y7vcrxS/+BIhCKfkzNusGOWz8XWvEufKH0Ray6QEtYKtPSRo1Ww5YiQV4hx/whE+Lu3NzXI
	5QYNCC5W0SXIWdhSdOklczulwtCYSQi2Np3jJVBYeEV0h3n0EjKVMHteXPmpD0GH8F8XoO1WYCI
	dz7vaxi+GPnFQ5BXl12i+QqAJubax0A84VYQdarWZ+VgD7MRrcDTDbN6VPKv/B7arQqO2Ozh27F
	PRkLDrrpojl2guO2Rl+JAcuG3iGgC6jrM4ucshnUSTHn
X-Google-Smtp-Source: AGHT+IHnwSLAPNKXU3gMx+5tsTTteDKv4SHyK4UxOMNd4PXKbxpy7VaCfSFX9w53V0ZmsOD5PjeQ6g==
X-Received: by 2002:a17:90b:2f4c:b0:2f9:bcd8:da33 with SMTP id 98e67ed59e1d1-300ff10d6d1mr14553930a91.21.1741883954948;
        Thu, 13 Mar 2025 09:39:14 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30119265938sm4020084a91.39.2025.03.13.09.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 09:39:14 -0700 (PDT)
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
Subject: [PATCH v4 03/17] exec/memory_ldst: extract memory_ldst declarations from cpu-all.h
Date: Thu, 13 Mar 2025 09:38:49 -0700
Message-Id: <20250313163903.1738581-4-pierrick.bouvier@linaro.org>
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

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/cpu-all.h         | 12 ------------
 include/exec/memory_ldst.h.inc |  4 ----
 2 files changed, 16 deletions(-)

diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index e56c064d46f..0e8205818a4 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -44,18 +44,6 @@
 
 #include "exec/hwaddr.h"
 
-#define SUFFIX
-#define ARG1         as
-#define ARG1_DECL    AddressSpace *as
-#define TARGET_ENDIANNESS
-#include "exec/memory_ldst.h.inc"
-
-#define SUFFIX       _cached_slow
-#define ARG1         cache
-#define ARG1_DECL    MemoryRegionCache *cache
-#define TARGET_ENDIANNESS
-#include "exec/memory_ldst.h.inc"
-
 static inline void stl_phys_notdirty(AddressSpace *as, hwaddr addr, uint32_t val)
 {
     address_space_stl_notdirty(as, addr, val,
diff --git a/include/exec/memory_ldst.h.inc b/include/exec/memory_ldst.h.inc
index 92ad74e9560..7270235c600 100644
--- a/include/exec/memory_ldst.h.inc
+++ b/include/exec/memory_ldst.h.inc
@@ -19,7 +19,6 @@
  * License along with this library; if not, see <http://www.gnu.org/licenses/>.
  */
 
-#ifdef TARGET_ENDIANNESS
 uint16_t glue(address_space_lduw, SUFFIX)(ARG1_DECL,
     hwaddr addr, MemTxAttrs attrs, MemTxResult *result);
 uint32_t glue(address_space_ldl, SUFFIX)(ARG1_DECL,
@@ -34,7 +33,6 @@ void glue(address_space_stl, SUFFIX)(ARG1_DECL,
     hwaddr addr, uint32_t val, MemTxAttrs attrs, MemTxResult *result);
 void glue(address_space_stq, SUFFIX)(ARG1_DECL,
     hwaddr addr, uint64_t val, MemTxAttrs attrs, MemTxResult *result);
-#else
 uint8_t glue(address_space_ldub, SUFFIX)(ARG1_DECL,
     hwaddr addr, MemTxAttrs attrs, MemTxResult *result);
 uint16_t glue(address_space_lduw_le, SUFFIX)(ARG1_DECL,
@@ -63,9 +61,7 @@ void glue(address_space_stq_le, SUFFIX)(ARG1_DECL,
     hwaddr addr, uint64_t val, MemTxAttrs attrs, MemTxResult *result);
 void glue(address_space_stq_be, SUFFIX)(ARG1_DECL,
     hwaddr addr, uint64_t val, MemTxAttrs attrs, MemTxResult *result);
-#endif
 
 #undef ARG1_DECL
 #undef ARG1
 #undef SUFFIX
-#undef TARGET_ENDIANNESS
-- 
2.39.5


