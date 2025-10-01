Return-Path: <kvm+bounces-59256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 826B5BAF958
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:22:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3290F1C24E2
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:22:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A4B6280024;
	Wed,  1 Oct 2025 08:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="j//Qn29I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4A2279782
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 08:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759306968; cv=none; b=FhHUp8lGE8BDn5oGzvlg7i0uFN3MO4FwGojrYaQRUahAB967LcXqeuwxSaZYUxWPQuEfuux3vWNE78bbfZ3azfVqBlpJsCVm/hQTU4z48X1VS+kgnCrQGOSpkJbypEh67/h4x7PLzdRo0Iccd92mxirJxRDcv0ZmTtdSSaHEq8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759306968; c=relaxed/simple;
	bh=mJ1uumcbxHTWx6g6dC8sI1FPSpAmNrApoevRDwRItwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BVHNXaCC8YZXVzauLui6fFx2un7wiZ61VGg9o3D383v46EDKhPShXxL0lGKCYQ8rYrY20woGZa7Tc4O1H9MXy+X5qk4SZOHgOQwMaB6RHVCVaU7cG901I0Lj1cN4dbbM02F+kE4jogI04ZHSMuaP4NdJb3ZDvVC76rRfJXBWHCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=j//Qn29I; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-46e4f2696bdso47095605e9.0
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 01:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759306965; x=1759911765; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ar/YH35Ozey5kVfE4PeoBGaZy8MaPZNMvHfkarTLI30=;
        b=j//Qn29ILtkGa4KaOEYDl4xscSTWhMmKzIsuCbCZx9H0vNmTJRX2j3M69diRnVtdj/
         xaljdHtQxco/TKgX78/hvt6b3G5dUU0e1aa3xv8gZj/NvjxWsmXqLX3ISamz4JybTNaO
         maCXkUabNcN1fHStYvnibopPiPJHWj+1ogBPp3ILQ/pNklVfTxFtNi9HgQgQYYCiYAdm
         eEMKxWEk6Vfg8HTPx0gRWV8/Nem/B6KbcJm0a0PNZd8iUf+AyU91C0HdjQDH5zsQwEws
         ApJFgOV0DM4Q2Svd3orseWWza1G5T96fYaEaOtn/dEsP+Gx8hqSKtM87pgvTRRtuypSZ
         VYng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759306965; x=1759911765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ar/YH35Ozey5kVfE4PeoBGaZy8MaPZNMvHfkarTLI30=;
        b=Z2w4WctOwxklvlgyMMmZb1jEVmtBMRPiyE6HCSVr2EIgz3q3kF2mj/ABnFXsNxeINg
         KSQgfXUdDI4SwPF+r2K/WeOZTbgVED+LolZj2C3KCZHhzzmfH4/auGQitl6Nzg7W9lbm
         sxcL5ybrWPCj3DxHge6MyyZ7Qh7z/rQ9MHurGvyNYCZA2U/7pclu7dzwx9YKLnt1vaI2
         Eqn28HIspidiLuCrp7xeUuvFz47mjwjMGfN+vrDt72BaWX/xJp7GEjK6SdQuZSNQGSXt
         0QZH22HRmmTnEEFeK/TD9NwVFkIW9+UsxI/BSM+aJEQL4FbyoRxzrN3v05QwM4A4HfN8
         wNzA==
X-Forwarded-Encrypted: i=1; AJvYcCVdVe6LoXk3RbPnbuGU+ehM1lCGpGbQoMJtuOQyfBKcJvJE6Lef/4JpEG7jVTXHKU/ERsI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyQj1shh0cL5mGTSbDmUpesCQejlpOgKR9201VAZjnMkU/haXb
	Bx7urG/+GRB35bZx1u5suwfagwzT9pPWaorN17tEJCVY+ugGqt/7vwJIATfox+zfqE4=
X-Gm-Gg: ASbGncs6RmUPC7hQAPpJPpdRZOrHDR+JsgdjROEIusdpNvYZnzT/xoirybRPkYYd3C0
	/QjFVH6aajL+g0naQvRknJcwVhSwwU5tZBKdBWKUGDLmT4KnaY+o8vwmnmp4bWOW1YJ8ztc8cpP
	o+W4AmM0obokPNVpcwlRhgAHhluv1bWkcu/cU7T2syry/Tu+IL/OxJFRIz8Aoart+zVxAd/Wbqg
	99hE9LRmkLI7LSGvcvSD5R3fSidOOch3cJnVmPhLIby+GUBnzJgb+00K2agIcPAKVhhl9rGl1mv
	+H7mepN49HIXCwD7cJdKDRyLchZ54ZT9A9Y5RxeBq6v9f0zg9rcCoGuNppUkfb1TNFXE9y8wMrn
	5wWq+LavaTLOPS3W5TZQLllXJRGcHGwfQtWwneQcQZlSIWhch+qJNsLx+wvo6xEoEw6ywCE2kBt
	FCInRXRPrwSMr3pxDpiPHF
X-Google-Smtp-Source: AGHT+IGN+bWrg5qo2djMQfrLkRUz4RRvn5SYFKJUC7nTMlaMtjSHo8h3I9oI8EbvaN2VVWqyt7ac8Q==
X-Received: by 2002:a05:600c:154e:b0:46e:49fd:5e30 with SMTP id 5b1f17b1804b1-46e61201fd8mr25182005e9.6.1759306964804;
        Wed, 01 Oct 2025 01:22:44 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e619c3ac3sm28907875e9.9.2025.10.01.01.22.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 01:22:44 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	qemu-arm@nongnu.org,
	Jagannathan Raman <jag.raman@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	kvm@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	qemu-ppc@nongnu.org,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Fabiano Rosas <farosas@suse.de>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-s390x@nongnu.org,
	Peter Xu <peterx@redhat.com>
Subject: [PATCH 14/25] system/physmem: Un-inline cpu_physical_memory_range_includes_clean()
Date: Wed,  1 Oct 2025 10:21:14 +0200
Message-ID: <20251001082127.65741-15-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251001082127.65741-1-philmd@linaro.org>
References: <20251001082127.65741-1-philmd@linaro.org>
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
---
 include/system/ram_addr.h | 62 ++-------------------------------------
 system/physmem.c          | 60 +++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 59 deletions(-)

diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
index e06cc4d0c52..809169b9903 100644
--- a/include/system/ram_addr.h
+++ b/include/system/ram_addr.h
@@ -142,69 +142,13 @@ static inline void qemu_ram_block_writeback(RAMBlock *block)
 #define DIRTY_CLIENTS_ALL     ((1 << DIRTY_MEMORY_NUM) - 1)
 #define DIRTY_CLIENTS_NOCODE  (DIRTY_CLIENTS_ALL & ~(1 << DIRTY_MEMORY_CODE))
 
-static inline bool cpu_physical_memory_all_dirty(ram_addr_t addr,
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
-    end = TARGET_PAGE_ALIGN(addr + length) >> TARGET_PAGE_BITS;
-    page = addr >> TARGET_PAGE_BITS;
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
 
-static inline uint8_t cpu_physical_memory_range_includes_clean(ram_addr_t addr,
-                                                               ram_addr_t length,
-                                                               uint8_t mask)
-{
-    uint8_t ret = 0;
-
-    if (mask & (1 << DIRTY_MEMORY_VGA) &&
-        !cpu_physical_memory_all_dirty(addr, length, DIRTY_MEMORY_VGA)) {
-        ret |= (1 << DIRTY_MEMORY_VGA);
-    }
-    if (mask & (1 << DIRTY_MEMORY_CODE) &&
-        !cpu_physical_memory_all_dirty(addr, length, DIRTY_MEMORY_CODE)) {
-        ret |= (1 << DIRTY_MEMORY_CODE);
-    }
-    if (mask & (1 << DIRTY_MEMORY_MIGRATION) &&
-        !cpu_physical_memory_all_dirty(addr, length, DIRTY_MEMORY_MIGRATION)) {
-        ret |= (1 << DIRTY_MEMORY_MIGRATION);
-    }
-    return ret;
-}
+uint8_t cpu_physical_memory_range_includes_clean(ram_addr_t addr,
+                                                 ram_addr_t length,
+                                                 uint8_t mask);
 
 static inline void cpu_physical_memory_set_dirty_flag(ram_addr_t addr,
                                                       unsigned client)
diff --git a/system/physmem.c b/system/physmem.c
index b27519c3075..11b08570b62 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -955,6 +955,66 @@ bool cpu_physical_memory_is_clean(ram_addr_t addr)
     return !(vga && code && migration);
 }
 
+static bool physical_memory_all_dirty(ram_addr_t addr, ram_addr_t length,
+                                      unsigned client)
+{
+    DirtyMemoryBlocks *blocks;
+    unsigned long end, page;
+    unsigned long idx, offset, base;
+    bool dirty = true;
+
+    assert(client < DIRTY_MEMORY_NUM);
+
+    end = TARGET_PAGE_ALIGN(addr + length) >> TARGET_PAGE_BITS;
+    page = addr >> TARGET_PAGE_BITS;
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
+uint8_t cpu_physical_memory_range_includes_clean(ram_addr_t addr,
+                                                 ram_addr_t length,
+                                                 uint8_t mask)
+{
+    uint8_t ret = 0;
+
+    if (mask & (1 << DIRTY_MEMORY_VGA) &&
+        !physical_memory_all_dirty(addr, length, DIRTY_MEMORY_VGA)) {
+        ret |= (1 << DIRTY_MEMORY_VGA);
+    }
+    if (mask & (1 << DIRTY_MEMORY_CODE) &&
+        !physical_memory_all_dirty(addr, length, DIRTY_MEMORY_CODE)) {
+        ret |= (1 << DIRTY_MEMORY_CODE);
+    }
+    if (mask & (1 << DIRTY_MEMORY_MIGRATION) &&
+        !physical_memory_all_dirty(addr, length, DIRTY_MEMORY_MIGRATION)) {
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


