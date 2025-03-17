Return-Path: <kvm+bounces-41290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2F5DA65CB5
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 19:34:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96A2C3BAD2D
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:34:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83C801E1E18;
	Mon, 17 Mar 2025 18:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YjgHXfST"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D4A1BC07B
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 18:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742236470; cv=none; b=CSdFYJOy3Pg+0rzA7rAkM0guakWA1FpGG+DePLd/yqVZu2TVhu7KovwHZGF2t/TMws8NHR9wyWDkez70pNJqQUpCv0IOonC7AoJJkwnaJ+wf768J/rtAwfMWvPDoX81BAqELiuxEDPdPFWxp5c2ih1uBQaFJyT3HzuJhLsMgdKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742236470; c=relaxed/simple;
	bh=oqW9tTQslkYwWgYQ4FVxpgiaLvEuigwHwZLhfUQTCic=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eK9RWPmfwx5eG+QP0buirf5uqmzkIlWCt0T/5YQlTGovX+GH/nJ6OryOnVV5G/1epZIuQ1vrElcq9IOswBsIZT4DvSAupHTKfdKOR1BGtPNnJ/BTGFL54uDJ51DnGHXv8WMa+xC8iX9Q2l8ABOHT/Fh6/V+YjRaZ2ILW+eeehy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YjgHXfST; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-224100e9a5cso92050595ad.2
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 11:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742236468; x=1742841268; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fcP4MFj0H7Fu3AxOxTbJlPG2KgbdJwiBtz5sSPdKZDU=;
        b=YjgHXfSTyUxscAxsSAvjk0VWUjPIoVkN6qUWq+e3Qylmc3VA2Z9wgtMBwKTL8jw5AX
         9WfBY5fiwEBeP3LM/6wCDrI/AEFUyY6Ig50ItJpc7GizWu52BJzo4zyh+si56PJupmjR
         EDKdCWHM+jTv63W8YXRuATB6yzCFQngjucQQ2K8nGWDZdNBoRieoIwwUmv4WnaSGRdLH
         MSKZ++yMxR8/nVMGCKR85fQ2d02WFubVg1UAGFUhD/dO2GvVl2nH8lOdvSG1alRQnRsY
         QB/4WUoSXcm03VcCR8i/DGoaqbxrH6jp0huTMDf0nAMCuxWjXVfKVJWuxVOwcDExSAQC
         HYDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742236468; x=1742841268;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fcP4MFj0H7Fu3AxOxTbJlPG2KgbdJwiBtz5sSPdKZDU=;
        b=Xfm9q988TAvJNtey+iMN3+zfOqdy22C6cx+JV+5aWyZoxWCBNlFf7/U/Dszjzp7JRE
         KhAbXbmRlUB8X2HcpKCJKkF66ArVPuifNhF0l/pYZwPBOct04fJTf8u8F7B6XSt0vZe+
         li9hfQ5tEJryUwCLKI5t7XtY2pWtqBVlAmOvkkS92Om0wHMPJ4VO05UH1G881lgwWM+8
         m93zamp2GLj7rSNWKUKOBOWpzrs77wSlpuvCuIkGHCggRDhJ6szUXhXyEzB+AsoztOU6
         DiWGpRVjEq8MrWVnVIZbvf7aI+wY6I8dl5Ao8X+6/hULeIci2hEdMdWZuMv6V9+H13pJ
         8oSg==
X-Forwarded-Encrypted: i=1; AJvYcCX455CwVijhom47xr8MPdnxTaxqS5nuozc3R9BBEEQ2URhHVsgRBlsa+3ikEywKudH+ejI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPrCWsk2FpGQ+arV4A+lY9oaj2YrxGKqEW+03HJpznbWRoNuOF
	KWg62LfWJ9UDg9skKtbrsSYkOCAVRgAzGDLezMdd4hKXOWd+z2TGme3edjPBaac=
X-Gm-Gg: ASbGncs8hb+M3nSqjVkFIATHDyke5IqhnePyV4oLrqga64dDcQFH8+YXtwo+VlTVLqd
	baImzULotw9Ndwss+aAhI1yJrsgyeZRHsX1JIY/22w7AIZ0FRje/kmUfuo+UOWQXWjjDJiHxU2I
	SGXmTPjsaScBczvRRGaLK8UWxhe2x+5zpQwTcyRNp6NM3tZESZoU7djjxMg/bnMOcSxjfMfnwok
	AyEEn2nLFYXYMbZwOCpS7rp3UjyyWRC5piVRoeZI3puiO3sGZSG8m7+5JC0C5mRIkXYPyrPZo+F
	RDtFpU8I+Ti1MjT915AIaC6IcX0gj/zJ3srgC1Tf4/0O
X-Google-Smtp-Source: AGHT+IHQDcKJsv+Vb17cz20O+u5FV4YlvIefcRPItg35hxavnuYTE6e3UlOmHk58oIUa6dLl2/Rvnw==
X-Received: by 2002:a05:6a00:13a6:b0:736:7175:f252 with SMTP id d2e1a72fcca58-7372239d970mr17183784b3a.14.1742236468325;
        Mon, 17 Mar 2025 11:34:28 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711695a2esm8188770b3a.144.2025.03.17.11.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 11:34:27 -0700 (PDT)
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
Subject: [PATCH v6 03/18] exec/memory_ldst: extract memory_ldst declarations from cpu-all.h
Date: Mon, 17 Mar 2025 11:34:02 -0700
Message-Id: <20250317183417.285700-4-pierrick.bouvier@linaro.org>
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


