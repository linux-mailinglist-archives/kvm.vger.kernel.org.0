Return-Path: <kvm+bounces-59359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B68FBB169C
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 19:56:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 114DE188BD99
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 17:56:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BBD82D3A8A;
	Wed,  1 Oct 2025 17:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WzeqVY7Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56779286889
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 17:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759341381; cv=none; b=rCKGin+IYuIezm95rN5LjycSb1x/Zf+X8WXRibwtUV3xYP7HdjsZoRBiTSU4An+agd3cmweor8ZIHtn/n0B3Ka0DizIxme1EBcvEipzu0JYZ/S0MtEi9qA/2PYptV8mXwIFA4t6QDi4eWf6N4hw6mWAPYj9JOHh/8QGwjxgrBS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759341381; c=relaxed/simple;
	bh=Wd1AVUiYDBFhTsWtsh6lDNtLdDcvy/kJMs/o8XQw5XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fHpw3OWJRHzYjBvJ02s1q0yXrJj8rkjqfBOwKJgUg6vTotTiInEHyqrWFF3sy6PQoThJFv+iooPTpcePXiOmSdP1ql0+UKB8Ws474x610tF+UImMnvDQvM5hrMRlEV9jaNg+9yItFoMsF7AwL0vnsVlTfC3wP7rvkDXN90pWjeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WzeqVY7Z; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-46e6674caa5so438605e9.0
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 10:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759341378; x=1759946178; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ar/b+bK1CSPAd2CXY5znM+31a+2uIsWNME5ALfig9VE=;
        b=WzeqVY7ZkfbNsIh5wl3ZhRY9ob4kMtiHnG/c27i4SCa6kCqhT6UFYNfpzBrxsGXwmG
         Bwgg7vzLjhz0BrLzsZHb38N6+jTAVAq91zRB5YlHNcvnmRPF1ek6CFcWBHdKCFU6FS/p
         AIVjWmVA/aqsNKlEce2F/i9B0c55he0VsiinfI9NKL7zyjxGDMUUE+eangpGklzJ/Qlu
         DRAwUR1mzQ2f5kG6HWq8bJyCIk5RnmGgEJm7xz4YF5L7g5vZEu+CmwcN1ZKibOLc5mMl
         Vki1dW4QMJn4zkapyG6U6WT2KFNbE+3J/VRa9kT2yZGy27cHerZNMNizJTK5GkXv6Wbq
         neXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759341378; x=1759946178;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ar/b+bK1CSPAd2CXY5znM+31a+2uIsWNME5ALfig9VE=;
        b=RZQMZa2ZgErKXEzU6xT0k81FPO+tBDtsvTM5jN3HSzhHv1siHxusY7R6xa6AM1Qf42
         qKFl1IapHf6lOp6VYS5IHojkY+ckHJ42XqCODDq1oUUMc5DTxhK28+DC1mLpN5rARIFX
         oz4MUZz+Xz3JFy7kPv4YTrrXWV0Tl/6ioCu9L/7lDLUaTbSUlHS3pLjLZQrmMGczj6Ru
         O7J4knMNUpcko6/raeGMUQMuu5cYSgszKDeIt6PNyQLKDSJimk9zf0oEnSTvxNxscT37
         kVm185OxzzA0XORIIabwQ/vb12hJzRhpyYfahLRDiH4od84UofvY+5b8TucmaZA9Uadp
         P6vQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2LKjnBdVhScvDBtoP4M4BlMzXENapIChMEjmxghbGWD8TxWH/HLPCbP3VNYRn+pAkJcw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5DioJp6UUy02l1YdVjD2Tex9C1oSYhmlF586viZWVE1FGzQfZ
	9/qadPg2cNMIN3zGSwmB7KZg0kdg/q9TO2lzGFNvG86S0xkuKhdHta/5xI/Ma+7nVSw=
X-Gm-Gg: ASbGncsThiAZLbwLXV/u3v48/IE/wsT8RwIaUqXKWaPaGRjlGVpzTuSxWukGhz0H0wy
	ynR2yflVLQfjUiylnu2xEoZk9pId4viWzkYdzYx5W/jOsgEYX5UVmmll9gzYNKJBTZbqU6xSzVV
	ArUklauzVCy49sfsvuxX2zCnhvSg88o/IDBqp0Fux1UgY7P8EKmrVztWq43RwWRjZB6+O8g375H
	esEBDyjQizLgpHinxLxox1d+e0Curxbx0z5GUV6cQm6dOTatYhl/aPlY2PpXnJW+XadAh//bQiH
	CYyu30sLirs6KVF5Ls13MQtrrHBhxki1pZgemSDum0LxpS7eI9Pt1viui/RW2DgzcJeL4rEijOW
	niE31vbUGSkJ63TE2fLM/+y4f6eA1aPDGa9GLjLMmKKdFCOiKLfivKErJNxbxrj5EzTbkdIe77u
	wy6m3T805jseo4+cWIV7kUam5+fQ==
X-Google-Smtp-Source: AGHT+IERukjStncMk1gDcNpcolRRiTogPxU99MO+79Bne2LwCSx50cvJQBnkGCm97vg0ybGvoBoNUw==
X-Received: by 2002:a05:600c:c3c1:b0:46d:c045:d2bd with SMTP id 5b1f17b1804b1-46e68bbaf6dmr2559775e9.8.1759341377590;
        Wed, 01 Oct 2025 10:56:17 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f4b71sm88706f8f.57.2025.10.01.10.56.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 10:56:17 -0700 (PDT)
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
Subject: [PATCH v2 16/18] system/physmem: Reduce cpu_physical_memory_sync_dirty_bitmap() scope
Date: Wed,  1 Oct 2025 19:54:45 +0200
Message-ID: <20251001175448.18933-17-philmd@linaro.org>
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

cpu_physical_memory_sync_dirty_bitmap() is now only called within
system/physmem.c, by ramblock_sync_dirty_bitmap(). Reduce its scope
by making it internal to this file. Since it doesn't involve any CPU,
remove the 'cpu_' prefix.
Remove the now unneeded "qemu/rcu.h" and "system/memory.h" headers.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/ram_addr.h | 79 ---------------------------------------
 migration/ram.c           | 77 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 76 insertions(+), 80 deletions(-)

diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
index cafd258580e..d2d088bbea6 100644
--- a/include/system/ram_addr.h
+++ b/include/system/ram_addr.h
@@ -21,10 +21,7 @@
 
 #include "exec/ramlist.h"
 #include "system/ramblock.h"
-#include "system/memory.h"
 #include "exec/target_page.h"
-#include "qemu/rcu.h"
-
 #include "exec/hwaddr.h"
 
 extern uint64_t total_dirty_pages;
@@ -175,80 +172,4 @@ bool cpu_physical_memory_snapshot_get_dirty(DirtyBitmapSnapshot *snap,
                                             ram_addr_t start,
                                             ram_addr_t length);
 
-/* Called with RCU critical section */
-static inline
-uint64_t cpu_physical_memory_sync_dirty_bitmap(RAMBlock *rb,
-                                               ram_addr_t start,
-                                               ram_addr_t length)
-{
-    ram_addr_t addr;
-    unsigned long word = BIT_WORD((start + rb->offset) >> TARGET_PAGE_BITS);
-    uint64_t num_dirty = 0;
-    unsigned long *dest = rb->bmap;
-
-    /* start address and length is aligned at the start of a word? */
-    if (((word * BITS_PER_LONG) << TARGET_PAGE_BITS) ==
-         (start + rb->offset) &&
-        !(length & ((BITS_PER_LONG << TARGET_PAGE_BITS) - 1))) {
-        int k;
-        int nr = BITS_TO_LONGS(length >> TARGET_PAGE_BITS);
-        unsigned long * const *src;
-        unsigned long idx = (word * BITS_PER_LONG) / DIRTY_MEMORY_BLOCK_SIZE;
-        unsigned long offset = BIT_WORD((word * BITS_PER_LONG) %
-                                        DIRTY_MEMORY_BLOCK_SIZE);
-        unsigned long page = BIT_WORD(start >> TARGET_PAGE_BITS);
-
-        src = qatomic_rcu_read(
-                &ram_list.dirty_memory[DIRTY_MEMORY_MIGRATION])->blocks;
-
-        for (k = page; k < page + nr; k++) {
-            if (src[idx][offset]) {
-                unsigned long bits = qatomic_xchg(&src[idx][offset], 0);
-                unsigned long new_dirty;
-                new_dirty = ~dest[k];
-                dest[k] |= bits;
-                new_dirty &= bits;
-                num_dirty += ctpopl(new_dirty);
-            }
-
-            if (++offset >= BITS_TO_LONGS(DIRTY_MEMORY_BLOCK_SIZE)) {
-                offset = 0;
-                idx++;
-            }
-        }
-        if (num_dirty) {
-            cpu_physical_memory_dirty_bits_cleared(start, length);
-        }
-
-        if (rb->clear_bmap) {
-            /*
-             * Postpone the dirty bitmap clear to the point before we
-             * really send the pages, also we will split the clear
-             * dirty procedure into smaller chunks.
-             */
-            clear_bmap_set(rb, start >> TARGET_PAGE_BITS,
-                           length >> TARGET_PAGE_BITS);
-        } else {
-            /* Slow path - still do that in a huge chunk */
-            memory_region_clear_dirty_bitmap(rb->mr, start, length);
-        }
-    } else {
-        ram_addr_t offset = rb->offset;
-
-        for (addr = 0; addr < length; addr += TARGET_PAGE_SIZE) {
-            if (cpu_physical_memory_test_and_clear_dirty(
-                        start + addr + offset,
-                        TARGET_PAGE_SIZE,
-                        DIRTY_MEMORY_MIGRATION)) {
-                long k = (start + addr) >> TARGET_PAGE_BITS;
-                if (!test_and_set_bit(k, dest)) {
-                    num_dirty++;
-                }
-            }
-        }
-    }
-
-    return num_dirty;
-}
-
 #endif
diff --git a/migration/ram.c b/migration/ram.c
index 91e65be83d8..52bdfec91d9 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -935,11 +935,86 @@ bool ramblock_page_is_discarded(RAMBlock *rb, ram_addr_t start)
     return false;
 }
 
+/* Called with RCU critical section */
+static uint64_t physical_memory_sync_dirty_bitmap(RAMBlock *rb,
+                                                  ram_addr_t start,
+                                                  ram_addr_t length)
+{
+    ram_addr_t addr;
+    unsigned long word = BIT_WORD((start + rb->offset) >> TARGET_PAGE_BITS);
+    uint64_t num_dirty = 0;
+    unsigned long *dest = rb->bmap;
+
+    /* start address and length is aligned at the start of a word? */
+    if (((word * BITS_PER_LONG) << TARGET_PAGE_BITS) ==
+         (start + rb->offset) &&
+        !(length & ((BITS_PER_LONG << TARGET_PAGE_BITS) - 1))) {
+        int k;
+        int nr = BITS_TO_LONGS(length >> TARGET_PAGE_BITS);
+        unsigned long * const *src;
+        unsigned long idx = (word * BITS_PER_LONG) / DIRTY_MEMORY_BLOCK_SIZE;
+        unsigned long offset = BIT_WORD((word * BITS_PER_LONG) %
+                                        DIRTY_MEMORY_BLOCK_SIZE);
+        unsigned long page = BIT_WORD(start >> TARGET_PAGE_BITS);
+
+        src = qatomic_rcu_read(
+                &ram_list.dirty_memory[DIRTY_MEMORY_MIGRATION])->blocks;
+
+        for (k = page; k < page + nr; k++) {
+            if (src[idx][offset]) {
+                unsigned long bits = qatomic_xchg(&src[idx][offset], 0);
+                unsigned long new_dirty;
+                new_dirty = ~dest[k];
+                dest[k] |= bits;
+                new_dirty &= bits;
+                num_dirty += ctpopl(new_dirty);
+            }
+
+            if (++offset >= BITS_TO_LONGS(DIRTY_MEMORY_BLOCK_SIZE)) {
+                offset = 0;
+                idx++;
+            }
+        }
+        if (num_dirty) {
+            cpu_physical_memory_dirty_bits_cleared(start, length);
+        }
+
+        if (rb->clear_bmap) {
+            /*
+             * Postpone the dirty bitmap clear to the point before we
+             * really send the pages, also we will split the clear
+             * dirty procedure into smaller chunks.
+             */
+            clear_bmap_set(rb, start >> TARGET_PAGE_BITS,
+                           length >> TARGET_PAGE_BITS);
+        } else {
+            /* Slow path - still do that in a huge chunk */
+            memory_region_clear_dirty_bitmap(rb->mr, start, length);
+        }
+    } else {
+        ram_addr_t offset = rb->offset;
+
+        for (addr = 0; addr < length; addr += TARGET_PAGE_SIZE) {
+            if (cpu_physical_memory_test_and_clear_dirty(
+                        start + addr + offset,
+                        TARGET_PAGE_SIZE,
+                        DIRTY_MEMORY_MIGRATION)) {
+                long k = (start + addr) >> TARGET_PAGE_BITS;
+                if (!test_and_set_bit(k, dest)) {
+                    num_dirty++;
+                }
+            }
+        }
+    }
+
+    return num_dirty;
+}
+
 /* Called with RCU critical section */
 static void ramblock_sync_dirty_bitmap(RAMState *rs, RAMBlock *rb)
 {
     uint64_t new_dirty_pages =
-        cpu_physical_memory_sync_dirty_bitmap(rb, 0, rb->used_length);
+        physical_memory_sync_dirty_bitmap(rb, 0, rb->used_length);
 
     rs->migration_dirty_pages += new_dirty_pages;
     rs->num_dirty_pages_period += new_dirty_pages;
-- 
2.51.0


