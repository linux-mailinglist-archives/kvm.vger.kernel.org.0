Return-Path: <kvm+bounces-40724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDFD2A5B7BE
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 05:09:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C6123B0940
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 04:09:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0B751EDA18;
	Tue, 11 Mar 2025 04:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nhWFyd9b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAC61EB9F3
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 04:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741666143; cv=none; b=ab2aQkEE8QRdlfhPNjge/5X4r66BLE9cS3CcIxscLJyMMIQdel/osGklBv6j5rJuvMd2oJVi/eeEvYSAf+AUruzqBVnF+QTUcwyvd3SBhu5RcUWNqLhFyqolDCOa+95YsLT41P3QvG3NQldD4unelwewUwneLt35Xp8bpB+LHio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741666143; c=relaxed/simple;
	bh=/0PU/IUPkm50UvlUKhO8CtFr0MS+b9OlLgM4eWroEjI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rfoSvyfGvgBjbThgnYF4JGvEV62bbsbp442OZSBkHpgvjelHBhnnXRNkXR73GVuplw0CUOBmkyQl+gvgld5jZJcVkHodDsvsA7vKfHhsoF8gXfmlrDuKUFTe1wupuuNNMq50t5ZozI2xbrmWooaMPeUp6WpNwvS5x02cRBDLJ8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nhWFyd9b; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22355618fd9so91860445ad.3
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 21:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741666141; x=1742270941; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KTcsPgfp4qWHKI5IiGC/xRJnn7HmZtcbIn5ZIF7f/ys=;
        b=nhWFyd9b/JVkMKHKb9n9xYUBJ8SfMUmzdpcurIlpov/Cywxc+SR097KeB5yZqGz3GC
         o0gnzsixmCn9v4t/wacFI+fwbF22ZNxSy4lB84MRx5j5PVBwTQwIp8K8Vvbj5+EeQBOc
         7QYV65s2cPQ6A1HkABsBoE/k3kchgcFSavnSLU4QaaNEf45M3cUepc/Mm3FN8UUPMUcV
         2Wi0eBM9KfzbdbGqp9Xj7jwG3PeRiB78saISBcxsQNfgJfwhfixuj8TNIdveHEB83sDX
         djv136L4ilVEDHk5gCVrbzVjYNTeKx2m4z8EB7l2/+pQiyeQiJlUbwt5eBCy6k/p4RxV
         bEig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741666141; x=1742270941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KTcsPgfp4qWHKI5IiGC/xRJnn7HmZtcbIn5ZIF7f/ys=;
        b=jO04tKSvmlaS71X8m/79JcUR8Cxe/fYHn/URQC+ZHt1H8VuHYtLpMS3t0lym8ymplE
         9eQOeyDRXveJz2Cw2jnVDFFicIWisfRhQJ71/pYX67ydMPWffUofcr5YxLU6dqIoKfW6
         OcCcpVczXAlT3nq508sxa/m+VKct4ezC3dWVXiFN0ylKX79FCnDm46gGqLH/6g/sJvqR
         QltzsYkPEEJONdLfctEyIqpMjBvSfi+7uFE7jWSqEO6IEPIy/Rhormo4681ezed0gaeo
         w5c/J7gK/sMcQM4pSZfkWsjnAeItD8hSP78AGxhGjngaHrxKm2LRA/GYXp0HIJcDhOLK
         eGkg==
X-Forwarded-Encrypted: i=1; AJvYcCVSpZdp1+DVYrxlagD8Z4jr+3nQ0yM5SRSE36SKTSbtq8wEz8bb5G3Xf3BCqS6tQefnIpU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyaAFhvdiQu/sSIg/+XFvOyITKQ5KlOul6ZtE0UJKQJUeewkipB
	L/J9QBW893awhKYX2KkZUGVA7ZydJYuOm2zi5OQ1m3+NWoeTgFofMU+y0FB5xH19yjFBsglggVU
	QxEM=
X-Gm-Gg: ASbGncsc8vkucz2Av9540t+1Adm/VZrezSEOyLTMmzccex5gMH0ZmzN5VUGMEc/eTc9
	cLA68R/t7Y46snh1VUse10k0J7yrMtZrCA+sJY6C2y6oQ72FBg7asqZIQDsDz1Ff7+knqVl6iWP
	z1uw2aLDfqyD6mzZjOZiAfgI2n3Y7CwXG+0h/8GgvecUjFbgiiCJKRBS72Lz7NedD8MD6rX+zrR
	t7G6fZn4RIL9CF/0qalYlkxdZFj1ClkvHBhsPQfYlrcJNP+yn5jYwUgH48SxzmjL+9qwv45rrWO
	pncfdPwsVKWp2MENGjbmfbSuVbNtluyag+RRzwgOwoP/Jq1iFyWSZIk=
X-Google-Smtp-Source: AGHT+IFvmMV6FR9w9HRJlmca+n7Q/Lcb7qpOce3I31boqIZsCEXwR+2F1i3uigVa31tDctZYbS6W9g==
X-Received: by 2002:a05:6a21:6b18:b0:1ee:c7c8:ca4 with SMTP id adf61e73a8af0-1f58cbef8a4mr4223140637.36.1741666140734;
        Mon, 10 Mar 2025 21:09:00 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af28c0339cesm7324454a12.46.2025.03.10.21.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 21:09:00 -0700 (PDT)
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
Subject: [PATCH v2 03/16] exec/memory_ldst: extract memory_ldst declarations from cpu-all.h
Date: Mon, 10 Mar 2025 21:08:25 -0700
Message-Id: <20250311040838.3937136-4-pierrick.bouvier@linaro.org>
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


