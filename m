Return-Path: <kvm+bounces-40548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CA219A58B54
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 05:59:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D3670167B62
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 04:59:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 531B51C5D7B;
	Mon, 10 Mar 2025 04:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mQFG2H5v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99DB1C1F02
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 04:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741582734; cv=none; b=GPrRJK6NoKZ+0eY3VZL2tZjYKazlaYxHZysPNG3HiEBOsILIHxfyLnD8niusW1BJg8VIeQuWx4oAOc2s33jf3fC/94m6Q+APuM8smUPjFET6uUIOueNVTJf0BbWxSswr/PcQG80pqEVQUcXzo0rMP12Tu1hscWfwm27YB3Q4CQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741582734; c=relaxed/simple;
	bh=o6CNIlf+fgBJTyg+UOitU2imqEFZyMkcskpxXQcwyD0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CT6cDCbATiHhqyCYFl7YA22moOxAEGf9ZyruWC7BhgeJTDSfZhpvdQ5h61s+BqseP3H0iIVr/F5LKO2bJEcS/gsi2vVfyEYTcGf6pmCX9kkLwpO4O761aMWWdyQQSLQrpeFJa7LnxitNNu11bOK5MLpnpSNhpBh+/EIZy/+y3Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mQFG2H5v; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-22337bc9ac3so70486445ad.1
        for <kvm@vger.kernel.org>; Sun, 09 Mar 2025 21:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741582732; x=1742187532; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2OIqebmv6TCVHIjcnbRR2ASx6yOnmt3f1dkycngreo0=;
        b=mQFG2H5vDXikEoiX20qrclrU6jfHDzjtxDQU/xod95BZGvbEqW1jXnCly2ZNoU1Omt
         cGcFs5bPQ6nUqv6G0TxS6wkzDtp3I/zbJVjaBGa5HUu+309gd69R8eODaz+6XxC0h+c+
         BPbFsVbCaBMLxazvB0Ur4wnyCC4ek4QqaSidsU79kRvgcz3J+/+OgRhBG1P54EEtaEah
         xjHScelHtkgB/D/1nFdbvWq73WmzcXOVmCjcRKoJF0oP8RpnbHfbhwURem3rzVjXFMI2
         fvax6odTxjT51rpNEyOS60GeoPl3py4Pw5yrFDay6Rr2s1uaI7f8vNU3WvI0/1O2CViA
         aY1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741582732; x=1742187532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2OIqebmv6TCVHIjcnbRR2ASx6yOnmt3f1dkycngreo0=;
        b=PIzSjmoZrSPSYocpfEPfZO5kSWw7cfROA3q4bUvEh82NLg/SlmQRn7D0NvklLPwws2
         a8cDV68BhlcZe+9hTgc2XuX5mrrTb4Zbs0IWc0RTXuYTbeHR7H+TUHSmc6hgZZ2iKwVh
         eM4xNQMDjPcsKoOKK/pifzN9wwEtdPBDN1NED+k1PqVqGnlcOJVSDxr5cv1y/aNnQpPc
         E4h2Vyl7Ne6jbc+YEGcHnJCsPZbKTivenpQ2h+9IC4lMGxCE9CB5fpScWdrJDuOVvECt
         802RnRL4e3WsUELquuGAAPTlcPnvIhoMOk4FDuBj+rqosXtwXuraYZEYjh7/pjCfAQYL
         F5hg==
X-Forwarded-Encrypted: i=1; AJvYcCX1GaBYADaCv2lWWtORr014vVVq6d9hfNslZ4gzmv5V2hmx4NyTG/e0VPrPTj7Jpix8XE8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNUxH0WF8Nw9A7anZS6qbaMzJ5iZAaEWCAuzyO14RZsuGcyXyR
	VP9y2LEICVNImWLbFqJpiWH58izqIOWXMN0ZXZmnwVa+HHdqx7BlqtN0l1idhtk=
X-Gm-Gg: ASbGncsV91UNyeds+jIrG0FunXF237IVF9DxYWlJOxFMYauTe3Qmj8nv6KZuXkOxdQy
	zu3CRhaO0NGhmaRJLtN7lvH3TVE1JmoHZjBvtUqeK8UmOX++RrzWdu50qpH8bKbbPj8o3fKKhhC
	fCxxkKkrLy4pDYMWtARLV3ZxuPUZ0fVWOw3/x1gUBUn33mVLYnnPEMheG9R/+4VBx2FvjL29f+w
	pbLJqZMx679xEc1Y2FqY5JTowO+AFXQp4Rw/IaT1C8JmdhVDC4tkxYZRqG7NYn8g7OVEkM2QZjF
	N/ub6ND0JDEr95h9ddCJdZhaQmtHCo3BItGEnjobQG55
X-Google-Smtp-Source: AGHT+IFiauNE3phtYbHOElNurEea3KFBOmPJM6YIEsLLcuetadtqaCJcJRoQf8PU7u5dj3ax/cwksA==
X-Received: by 2002:a05:6a00:17a7:b0:736:47a5:e268 with SMTP id d2e1a72fcca58-736aa9bc787mr17756988b3a.1.1741582732211;
        Sun, 09 Mar 2025 21:58:52 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736d2ae318csm1708308b3a.53.2025.03.09.21.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Mar 2025 21:58:51 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	alex.bennee@linaro.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	kvm@vger.kernel.org,
	Peter Xu <peterx@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	manos.pitsidianakis@linaro.org,
	qemu-riscv@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	xen-devel@lists.xenproject.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 02/16] exec/memory_ldst_phys: extract memory_ldst_phys declarations from cpu-all.h
Date: Sun,  9 Mar 2025 21:58:28 -0700
Message-Id: <20250310045842.2650784-3-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250310045842.2650784-1-pierrick.bouvier@linaro.org>
References: <20250310045842.2650784-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

They are now accessible through exec/memory.h instead, and we make sure
all variants are available for common or target dependent code.

To allow this, we need to implement address_space_st{*}_cached, simply
forwarding the calls to _cached_slow variants.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/cpu-all.h              | 15 ------------
 include/exec/memory.h               | 36 +++++++++++++++++++++++++++++
 include/exec/memory_ldst_phys.h.inc |  5 +---
 3 files changed, 37 insertions(+), 19 deletions(-)

diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index 17ea82518a0..1c2e18f492b 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -75,21 +75,6 @@ static inline void stl_phys_notdirty(AddressSpace *as, hwaddr addr, uint32_t val
                                MEMTXATTRS_UNSPECIFIED, NULL);
 }
 
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
 #endif
 
 /* page related stuff */
diff --git a/include/exec/memory.h b/include/exec/memory.h
index 78c4e0aec8d..7c20f36a312 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -2798,6 +2798,42 @@ static inline void address_space_stb_cached(MemoryRegionCache *cache,
     }
 }
 
+static inline uint16_t address_space_lduw_cached(MemoryRegionCache *cache,
+    hwaddr addr, MemTxAttrs attrs, MemTxResult *result)
+{
+    return address_space_lduw_cached_slow(cache, addr, attrs, result);
+}
+
+static inline void address_space_stw_cached(MemoryRegionCache *cache,
+    hwaddr addr, uint16_t val, MemTxAttrs attrs, MemTxResult *result)
+{
+    address_space_stw_cached_slow(cache, addr, val, attrs, result);
+}
+
+static inline uint32_t address_space_ldl_cached(MemoryRegionCache *cache,
+    hwaddr addr, MemTxAttrs attrs, MemTxResult *result)
+{
+    return address_space_ldl_cached_slow(cache, addr, attrs, result);
+}
+
+static inline void address_space_stl_cached(MemoryRegionCache *cache,
+    hwaddr addr, uint32_t val, MemTxAttrs attrs, MemTxResult *result)
+{
+    address_space_stl_cached_slow(cache, addr, val, attrs, result);
+}
+
+static inline uint64_t address_space_ldq_cached(MemoryRegionCache *cache,
+    hwaddr addr, MemTxAttrs attrs, MemTxResult *result)
+{
+    return address_space_ldq_cached_slow(cache, addr, attrs, result);
+}
+
+static inline void address_space_stq_cached(MemoryRegionCache *cache,
+    hwaddr addr, uint64_t val, MemTxAttrs attrs, MemTxResult *result)
+{
+    address_space_stq_cached_slow(cache, addr, val, attrs, result);
+}
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


