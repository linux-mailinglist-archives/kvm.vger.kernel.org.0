Return-Path: <kvm+bounces-40965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 357B9A5FC13
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 17:40:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 12EFD7AA3C0
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 16:39:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8DB526AA9D;
	Thu, 13 Mar 2025 16:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZQgN7qkB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6D1269CEC
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 16:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741883972; cv=none; b=NzTzUX21YCN45Briu7w9F0jCny0R4RyNgMZavhUQXUFruL9p6dnvvy1G55OaG6rjedTn4P0OvAfwVWF18CJ/mYq6kK3gkBczJ7/92Tnv19Qf6zjYv2I4u9ZUOi+mWRhVsaLPQMn5Tcio5ZbxEcL5LfBjOXBLSMkAhBRysSpor8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741883972; c=relaxed/simple;
	bh=IelyUoYuqLIAw6DPSyagCvFpNJxQiv+t0JYUBox7DYg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BdOR5BPIEb2UuKaoDpSu5biyo5Dc91TQIP11aOWfqRKfWoRODlSxAowvk8AU5XtcxI4TIsxoV7zkuG68RC+dLhLyr/IVWna0Rj1dh5ldrtLZds/sEcgQgAbHyDF+9wZTfZpZyUn6oV+HsPPNkjk0TBpWCME8HoCjeCFTpyN3nZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZQgN7qkB; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2fa8ada6662so2710517a91.1
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 09:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741883970; x=1742488770; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EBRugwqnxw4q7Phz2P050i5IjB6Zbf1WGwdoEilqtkY=;
        b=ZQgN7qkBNveXhew6OqeHTJFnVzPFK7LSestl0RvM+WaNhZQlna67G4Z4LcwdVg029Y
         c2JMBGsmWJM6rsCGTzVUC9z/1kXjx7mBHytIVzasBwNN2VBLNe9SWHnwlb3vsTLYz9h6
         ARoKhjNzQk8jgaoGHNcAMsdHovQeHAsAM1m42ybTkv5nvK9jFJXN2Fvaf7AwEiEFjzSO
         cVzxhvIJ8vNCzndvL06+C6QPxebGGHhMRJkAHM+UV+CVaabDMlgfC3u3OxTKALgDl9sS
         soMx1A/25+SCayeMdWPEVOj/H7IuPfWE5c8lkLbYkTaFqdOzcN1xVZA+LCagc+QLY3Py
         FEew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741883970; x=1742488770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EBRugwqnxw4q7Phz2P050i5IjB6Zbf1WGwdoEilqtkY=;
        b=ZhmtVDHc892CcvBLdcxGzUzNf1/Kpv5kvt26XPjcFN8Ocw89BCOnM0/neADCl/WwZv
         bctvHBhs4R98QSwRuMnJkjqygJdY83wwwN8bZg/AOvUS22T/KK1sXVHRLFTy5LQwA97q
         VXCmyvl8Qq8OY9CJfOhuIRaqNbIgNz66wvUNXU++M/QcwihhqYtUx9ZVHcaLmWN4A6v6
         Pqo3a/bFoJr9FlkWZ8NX3zBsl4G8PkMD1DSzyrhx82Nna3K9FaYYFn7xPHCikgLT96g0
         qEOmHgIlmAwmszPzHw2XXhi9T7JdtjCXRCW11yRxVDDTWpD0TDNVZ6Me5Xw3F7FMXLDv
         cj2g==
X-Forwarded-Encrypted: i=1; AJvYcCU5o+1ry0sNxGK4U2BMRlB+shMy2gqiHuLIWMDKsgA7SPcfCt++Q2+zsT9Z17MxzdpqRPI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxgg9ldARVmx9nKr6M5SNXkoKj8PZ2KxKM3ktXJIK0orQB5IdFi
	iDFKj+UjOguTOBMm2WzkfFRLwiKv5RVChtJwByJa+xEUlBayXL89BR6HberVAjg=
X-Gm-Gg: ASbGnctZDijRlkhKV3m8elgPxxqo+ML5jkzu6fw1B2lCFULlw4uZLBTDpLCbuNA3vgE
	rwaRFaumHsZuEY92f0uIeSYlGpSsG8HZN5265rEv7d3SDUK31cUUVl7MO7302mtZnReVMX/BQcP
	h1x8Z1xIwzxwLFhFrlfGpbHyuXST+9v0zPSKKHilfofsqd1dF6M0L4VNXDLr3NdmjCxfJqB51uY
	HsaIyBiQH3qg3YbHuPyOCWBaOCX/BbfwmICKJBNCyMgSfV3KFi6LdhRjoa817c4CZv/OVbMv1zO
	FO+khPPNd6ntDAafUPHIbFZ8gE/1jDqCkcLUijvEi7Y5
X-Google-Smtp-Source: AGHT+IHRyNfs/2JPL1rq+dZtoKg0Gk6ovyIhkaylwgSPQTAI/HYpqKgruBLvp53+c1fVanolW+jjbw==
X-Received: by 2002:a17:90b:51d1:b0:2fe:a614:5cf7 with SMTP id 98e67ed59e1d1-3014e815c62mr251908a91.3.1741883969872;
        Thu, 13 Mar 2025 09:39:29 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30119265938sm4020084a91.39.2025.03.13.09.39.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 09:39:29 -0700 (PDT)
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
Subject: [PATCH v4 16/17] system/memory: make compilation unit common
Date: Thu, 13 Mar 2025 09:39:02 -0700
Message-Id: <20250313163903.1738581-17-pierrick.bouvier@linaro.org>
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

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 system/memory.c    | 17 +++++------------
 system/meson.build |  2 +-
 2 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/system/memory.c b/system/memory.c
index 4c829793a0a..eddd21a6cdb 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -353,15 +353,6 @@ static void flatview_simplify(FlatView *view)
     }
 }
 
-static bool memory_region_big_endian(MemoryRegion *mr)
-{
-#if TARGET_BIG_ENDIAN
-    return mr->ops->endianness != DEVICE_LITTLE_ENDIAN;
-#else
-    return mr->ops->endianness == DEVICE_BIG_ENDIAN;
-#endif
-}
-
 static void adjust_endianness(MemoryRegion *mr, uint64_t *data, MemOp op)
 {
     if ((op & MO_BSWAP) != devend_memop(mr->ops->endianness)) {
@@ -563,7 +554,7 @@ static MemTxResult access_with_adjusted_size(hwaddr addr,
     /* FIXME: support unaligned access? */
     access_size = MAX(MIN(size, access_size_max), access_size_min);
     access_mask = MAKE_64BIT_MASK(0, access_size * 8);
-    if (memory_region_big_endian(mr)) {
+    if (devend_big_endian(mr->ops->endianness)) {
         for (i = 0; i < size; i += access_size) {
             r |= access_fn(mr, addr + i, value, access_size,
                         (size - access_size - i) * 8, access_mask, attrs);
@@ -2584,7 +2575,8 @@ void memory_region_add_eventfd(MemoryRegion *mr,
     unsigned i;
 
     if (size) {
-        adjust_endianness(mr, &mrfd.data, size_memop(size) | MO_TE);
+        MemOp mop = (target_words_bigendian() ? MO_BE : MO_LE) | size_memop(size);
+        adjust_endianness(mr, &mrfd.data, mop);
     }
     memory_region_transaction_begin();
     for (i = 0; i < mr->ioeventfd_nb; ++i) {
@@ -2619,7 +2611,8 @@ void memory_region_del_eventfd(MemoryRegion *mr,
     unsigned i;
 
     if (size) {
-        adjust_endianness(mr, &mrfd.data, size_memop(size) | MO_TE);
+        MemOp mop = (target_words_bigendian() ? MO_BE : MO_LE) | size_memop(size);
+        adjust_endianness(mr, &mrfd.data, mop);
     }
     memory_region_transaction_begin();
     for (i = 0; i < mr->ioeventfd_nb; ++i) {
diff --git a/system/meson.build b/system/meson.build
index bd82ef132e7..4f44b78df31 100644
--- a/system/meson.build
+++ b/system/meson.build
@@ -2,7 +2,6 @@ specific_ss.add(when: 'CONFIG_SYSTEM_ONLY', if_true: [files(
   'arch_init.c',
   'ioport.c',
   'globals-target.c',
-  'memory.c',
 )])
 
 system_ss.add(files(
@@ -15,6 +14,7 @@ system_ss.add(files(
   'dma-helpers.c',
   'globals.c',
   'memory_mapping.c',
+  'memory.c',
   'physmem.c',
   'qdev-monitor.c',
   'qtest.c',
-- 
2.39.5


