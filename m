Return-Path: <kvm+bounces-59352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4470CBB1687
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 19:55:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB4AA1C50FE
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 17:55:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D45BE2D29A9;
	Wed,  1 Oct 2025 17:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aYT/8rCm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4267334BA32
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 17:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759341343; cv=none; b=IaZAcni2huI5NF9aQfeAQi0ptXYbguT143i/qlCIbaEdEtpatv8D4rum3uV2oRnKpVSivVeaNEB7xVQxBeStKOyb8QbCSYow0RbLHLkb/EACpyuqmmk7KOsfUQ/0ShaY/a/jmHxhiN6knrVhKgdQZv5tv+ZZpX+sn+Y5fQsNcNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759341343; c=relaxed/simple;
	bh=t6zzSqZck4yKMoLXhb73T6doYVjpx+Pc9bYkkfoT4k0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a8Q/QbwsMkkGa3qGW70iWEmzVQEyWiNDIOSYuYnova+fbIRG1pk2ev5+8L3uH7/Ae0RFlnsT84hAcyJNDATnOzP6OZGyYVKJsK1jV0JhLfBQvkjTksK/7S4D1lp2lUDW0nzXQyfnRL+RvFbPX+fAFDAfIP0MEVdwjFPnT3B8Rp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aYT/8rCm; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-46e37d10ed2so787775e9.2
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 10:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759341340; x=1759946140; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d4FpKgP4EA24JaZyt14rp8t6FdQHApouicK9Mpxbqsc=;
        b=aYT/8rCmgjtmDSLJaCzuxCFmc+osjhOxtm1JTmxQ83xKGuPSgTOUsoVPtnniWd0e6r
         Ispwi/i/vfx9q+01jfuoBpzwAS74Ek5bKaxBYgmBzZUcdwzciPhHDM86CLm6q0e7D1mr
         J1gAv1nfEFOsgw1vC9OfYsUg6JgBbG6q7Re9UQyTM9+/Um/e/JqbOS67Xv1DEqzO3qL+
         8u0LHklRA0zPcE6EjTbHzoHjVEjudBre44ffTNAqQE8RooKo+I7pPaVf7aaCMMPcK+dn
         uobd1CjDuo7tOTXdd4MFwUNovYO1DIfF+kl6Wp15VC3o08IUQiLkJNp5p/YVm8HPfIkj
         DD4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759341340; x=1759946140;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d4FpKgP4EA24JaZyt14rp8t6FdQHApouicK9Mpxbqsc=;
        b=vXf9npZ44SggK0S1Dz8iV982VEdOT9+QrhbIMti2VGeb1CHs+M337qMw9IK4aMRP6i
         zigOV/CHgsCi1K11SgbDda6m16rC13Jbyiimex4Xul7Ka5+sJOUMChvvL9v76GposLd9
         wg/HTPap30Bm3xnlMrOQK/0KvhKKXEfIRKSeL2Y5BMV7kHKmBb9C5tTPT3K+gXwovHPs
         PLpfgq6JHc8hYZWk+wbEI/xmLcixM5orwmlgfBVqskBruubKWWHQ+RQgyoHUCR51GzqF
         CNjvAqXeaVCCd8xmmBCCn/GxUCo7X0Y9WcuTeuYuXEmk0AzcArMwogY8bDhSySpS510P
         a7tw==
X-Forwarded-Encrypted: i=1; AJvYcCXySF99ypAJgvC/kdnxvoLm/RdncIB2vCfanwgWdnqNrjVCwBjrjFhOKc10tWVmf9/IzGQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8sIXbIW85+ZjNtxydbdlpoIUJaB30oTrRZYpl7M8Ohseww8U+
	Ol4VG9q3OEleGDGmIblWhPhKDwgLse3xOS3V7tX42IX6re0vxTJ7JW7kjG9zZocp8/A=
X-Gm-Gg: ASbGncsGV1mIjTlb3EtfhhAvvectWqt5EWVeHPjXitLZ0rFUR2wZho1j1AeVKm4dMdD
	HZ67ZsdBQNRC+ScY4nFa20gut+0hDm3xMA1JLqzG0wLSjdNxhRau47TG1k1uoKDCGOphv62pOMG
	yfEtYXlAw6Z/4AkVrVGiWFehY5tNSqMC+iMONvf52odF81omT1zP0s05dYS5qkGZChMHB+XrqIt
	wJUBCUFicpOsu+NRSve6yufxdCog9uZO9eVlT910Wob0Tk7/+DDB8y6gTOw3m3t0E5DZ9X39+OI
	HT3zkVDfaQd1vFqhx3F0ZrqetAucMduw5wmybxEHll+WPS/X4xHb57bZoMrmggQn/xk/DUnv3DZ
	au1Ay67EwMFnVtpgaU1vVCW06QOMz5pEUJLzj1/LWdpTCT1R+iNLzOYPzZEWbTE3nEqLuCLz/ao
	rIsmXzzB6zH6XPspeOyWI8h+BW70nLk2DEiq3r
X-Google-Smtp-Source: AGHT+IF0xbC1IEd8QMB22IhbYKtfRZKDX/TCaConk1RKW1e7VjrGfmv9+PMY2JeZ2AZyw41zjVsNuw==
X-Received: by 2002:a05:600c:620d:b0:46d:996b:828c with SMTP id 5b1f17b1804b1-46e61218f70mr40496535e9.10.1759341339699;
        Wed, 01 Oct 2025 10:55:39 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e619b8507sm48708415e9.3.2025.10.01.10.55.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 10:55:39 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Jagannathan Raman <jag.raman@oracle.com>,
	qemu-ppc@nongnu.org,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	kvm@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Fabiano Rosas <farosas@suse.de>,
	Eric Farman <farman@linux.ibm.com>,
	qemu-arm@nongnu.org,
	qemu-s390x@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v2 09/18] system/physmem: Un-inline cpu_physical_memory_range_includes_clean()
Date: Wed,  1 Oct 2025 19:54:38 +0200
Message-ID: <20251001175448.18933-10-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251001175448.18933-1-philmd@linaro.org>
References: <20251001175448.18933-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Avoid maintaining large functions in header, rely on the
linker to optimize at linking time.

cpu_physical_memory_all_dirty() doesn't involve any CPU,
remove the 'cpu_' prefix.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/ram_addr.h | 62 ++-------------------------------------
 system/physmem.c          | 60 +++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 59 deletions(-)

diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
index cdf25c315be..2dcca260b2b 100644
--- a/include/system/ram_addr.h
+++ b/include/system/ram_addr.h
@@ -142,69 +142,13 @@ static inline void qemu_ram_block_writeback(RAMBlock *block)
 #define DIRTY_CLIENTS_ALL     ((1 << DIRTY_MEMORY_NUM) - 1)
 #define DIRTY_CLIENTS_NOCODE  (DIRTY_CLIENTS_ALL & ~(1 << DIRTY_MEMORY_CODE))
 
-static inline bool cpu_physical_memory_all_dirty(ram_addr_t start,
-                                                 ram_addr_t length,
-                                                 unsigned client)
-{
-    DirtyMemoryBlocks *blocks;
-    unsigned long end, page;
-    unsigned long idx, offset, base;
-    bool dirty = true;
-
-    assert(client < DIRTY_MEMORY_NUM);
-
-    end = TARGET_PAGE_ALIGN(start + length) >> TARGET_PAGE_BITS;
-    page = start >> TARGET_PAGE_BITS;
-
-    RCU_READ_LOCK_GUARD();
-
-    blocks = qatomic_rcu_read(&ram_list.dirty_memory[client]);
-
-    idx = page / DIRTY_MEMORY_BLOCK_SIZE;
-    offset = page % DIRTY_MEMORY_BLOCK_SIZE;
-    base = page - offset;
-    while (page < end) {
-        unsigned long next = MIN(end, base + DIRTY_MEMORY_BLOCK_SIZE);
-        unsigned long num = next - base;
-        unsigned long found = find_next_zero_bit(blocks->blocks[idx], num, offset);
-        if (found < num) {
-            dirty = false;
-            break;
-        }
-
-        page = next;
-        idx++;
-        offset = 0;
-        base += DIRTY_MEMORY_BLOCK_SIZE;
-    }
-
-    return dirty;
-}
-
 bool cpu_physical_memory_get_dirty_flag(ram_addr_t addr, unsigned client);
 
 bool cpu_physical_memory_is_clean(ram_addr_t addr);
 
-static inline uint8_t cpu_physical_memory_range_includes_clean(ram_addr_t start,
-                                                               ram_addr_t length,
-                                                               uint8_t mask)
-{
-    uint8_t ret = 0;
-
-    if (mask & (1 << DIRTY_MEMORY_VGA) &&
-        !cpu_physical_memory_all_dirty(start, length, DIRTY_MEMORY_VGA)) {
-        ret |= (1 << DIRTY_MEMORY_VGA);
-    }
-    if (mask & (1 << DIRTY_MEMORY_CODE) &&
-        !cpu_physical_memory_all_dirty(start, length, DIRTY_MEMORY_CODE)) {
-        ret |= (1 << DIRTY_MEMORY_CODE);
-    }
-    if (mask & (1 << DIRTY_MEMORY_MIGRATION) &&
-        !cpu_physical_memory_all_dirty(start, length, DIRTY_MEMORY_MIGRATION)) {
-        ret |= (1 << DIRTY_MEMORY_MIGRATION);
-    }
-    return ret;
-}
+uint8_t cpu_physical_memory_range_includes_clean(ram_addr_t start,
+                                                 ram_addr_t length,
+                                                 uint8_t mask);
 
 static inline void cpu_physical_memory_set_dirty_flag(ram_addr_t addr,
                                                       unsigned client)
diff --git a/system/physmem.c b/system/physmem.c
index fb6a7378ff7..2667f289044 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -954,6 +954,66 @@ bool cpu_physical_memory_is_clean(ram_addr_t addr)
     return !(vga && code && migration);
 }
 
+static bool physical_memory_all_dirty(ram_addr_t start, ram_addr_t length,
+                                      unsigned client)
+{
+    DirtyMemoryBlocks *blocks;
+    unsigned long end, page;
+    unsigned long idx, offset, base;
+    bool dirty = true;
+
+    assert(client < DIRTY_MEMORY_NUM);
+
+    end = TARGET_PAGE_ALIGN(start + length) >> TARGET_PAGE_BITS;
+    page = start >> TARGET_PAGE_BITS;
+
+    RCU_READ_LOCK_GUARD();
+
+    blocks = qatomic_rcu_read(&ram_list.dirty_memory[client]);
+
+    idx = page / DIRTY_MEMORY_BLOCK_SIZE;
+    offset = page % DIRTY_MEMORY_BLOCK_SIZE;
+    base = page - offset;
+    while (page < end) {
+        unsigned long next = MIN(end, base + DIRTY_MEMORY_BLOCK_SIZE);
+        unsigned long num = next - base;
+        unsigned long found = find_next_zero_bit(blocks->blocks[idx],
+                                                 num, offset);
+        if (found < num) {
+            dirty = false;
+            break;
+        }
+
+        page = next;
+        idx++;
+        offset = 0;
+        base += DIRTY_MEMORY_BLOCK_SIZE;
+    }
+
+    return dirty;
+}
+
+uint8_t cpu_physical_memory_range_includes_clean(ram_addr_t start,
+                                                 ram_addr_t length,
+                                                 uint8_t mask)
+{
+    uint8_t ret = 0;
+
+    if (mask & (1 << DIRTY_MEMORY_VGA) &&
+        !physical_memory_all_dirty(start, length, DIRTY_MEMORY_VGA)) {
+        ret |= (1 << DIRTY_MEMORY_VGA);
+    }
+    if (mask & (1 << DIRTY_MEMORY_CODE) &&
+        !physical_memory_all_dirty(start, length, DIRTY_MEMORY_CODE)) {
+        ret |= (1 << DIRTY_MEMORY_CODE);
+    }
+    if (mask & (1 << DIRTY_MEMORY_MIGRATION) &&
+        !physical_memory_all_dirty(start, length, DIRTY_MEMORY_MIGRATION)) {
+        ret |= (1 << DIRTY_MEMORY_MIGRATION);
+    }
+    return ret;
+}
+
 /* Note: start and end must be within the same ram block.  */
 bool cpu_physical_memory_test_and_clear_dirty(ram_addr_t start,
                                               ram_addr_t length,
-- 
2.51.0


