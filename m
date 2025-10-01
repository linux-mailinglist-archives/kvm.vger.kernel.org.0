Return-Path: <kvm+bounces-59265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AA72BAF977
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:23:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 044261920ED4
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:24:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10109283FC2;
	Wed,  1 Oct 2025 08:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CcfPeKId"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2419C2820DA
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 08:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759307018; cv=none; b=UdqMkqACLEaYuzq8+znsqwqdntQGY6aHbSel9FRHvInnrznmwsqmGaHWJRbwfGdcqxOq073jIYSZje4HJCSc9OY5VVrBTDiTTpKkLh58exCt09MyPY4nIAMB9eFtfByoUoAHOcVm4ShkN6uwPPkKcDCw2p0lQJevePqo2kgai1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759307018; c=relaxed/simple;
	bh=yyHensNCTpgI+5It+Q5UYL/VQmsUPGo4d8KQq6xCkNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PmfiJYEm6INbtvKKVDoHF5t6GQOU8c+lX9iO8L9NnT9DCS9zkD/635sc2TDWjtDcBNY9kwBUZl/R4jqu0Z/TerHXANQZvSP8peju3zDRkx4f6OacvOEkP+6ZRSjYtWr3n6AT2z56phn/iV3ZOcWq+APBOX88V59bHisn5M/wx+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CcfPeKId; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-46e3a50bc0fso48305295e9.3
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 01:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759307014; x=1759911814; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZaIr6FH1wkvEsTTc63UU90krHzSjNDiVQPaADhPhLlM=;
        b=CcfPeKIdVh4a4Av5messrjfw7iIo7DuAR94eb80Gw2uER86/saL9fqNRCXfRDEayeN
         bMtJW785R8uyC/0aMHy/NpBxnIAWOMONf3YThCZsJqDkHaUUXQyVzoxJ1ZNS+/S2SHCb
         7dpX1oz0oV0aN+qfq6B9DTnCn3B676VDgkOusErfjID2Lot2xlpyKe41GJ7giDeXt4zS
         ZLgANI/RaXI+0L/bWifjvDTOxRddMvJtQ8uxcRS6jaMTs2KuKjs2KF8DUIEZqYOplGwW
         prAJu4G1jJHhXQiAfmeIGQdpHXO0rnh5KUtleqW6zlSJLK9abK1asYLB3oi7DZDEtiHw
         UjlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759307014; x=1759911814;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZaIr6FH1wkvEsTTc63UU90krHzSjNDiVQPaADhPhLlM=;
        b=n6NvH1phWOBpR0qO6vEx4i0IoM7X0eb2YOM6nWbpFkUgDI9+jzRNrsH+Ghp87JvekA
         +WIoGI4kZ/Q2mE2wKd81Cw7XDgKzDFQXM8ihkmd9jpeGyMHIG9COe3JJt9OftFPeRwDX
         zhn9QH4CWNXxaBRnGFqR7xP9Gs2Zg0dFh0Q07JUEDhEmy71smyh0CAsFbP6/XWNgB4VC
         ZoFxMTlA/gDdC+2nR9eIKP5PBFmY4Y6EiA6Owvp4g4++tY6czJRyo/qt1OKk7UIcHw9d
         TATvDNtVESH1pL5r9XLL54Nt6Fyr6AfAiQH3if5Yle+K5A4b+p0j02UeqlpWwieQGWbO
         VL7w==
X-Forwarded-Encrypted: i=1; AJvYcCXJMFIBf8Pg6HZkFbGO9o6SKAa1VEXXRikMIPUGIpOFq+lf4BvpxmtF0ZlKOI5f/zBeLr8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyt7U2E8zr47QEsOlVFb7cvHcYCR6aHsbMtCUhMG+D98XvEtEn5
	mcueXOsGXRzbqnVcv8Vh/2j/lPxVX/bMaeolnVBrbg+dzzrm1GEGTVX8eb0Ikh3BtUI=
X-Gm-Gg: ASbGnctuHTLe41CQ0GcFueVWrjcnLr1UgygHS7FRsA46uaNzx9lwOLvv8qJySgxflY0
	8FQXOEoae+EaieNrBcdA5IFj77RjDlMTnpAQmIbdfaBTDW0lhPpLE3ngIhkt62DxbhSx1ZhCVxq
	NIwhjISQGvn2GQRsIRvmmjJLMSCFivUnpVgRgNPh40wI2RrQJpNHkMw77a9BApl87f03EyA/Zlu
	uObyRtaVfWp53yWAL0K2SSGYredL5NFg9vUNm/mo2oyPNEVNl6zEQhDX6ozLWbyitWujlUCqJti
	/qf0UWVoYr5RGKPb/LOZKzColHy1dkbdAFyiyK7977Mwt1ybTc668U/Uo6aP4lMlQv/8LBmgbiU
	NizqxrGEOXlAsLQKm6z2CyKcBk8hprV0H2Ido6g9e0ICKk9dmeNzqo0BjrgfsNL1MzlIWVJWxuA
	SafZSFBrpqS+N4AB2wnGGU
X-Google-Smtp-Source: AGHT+IGHB98tVMlfkOs0dlElGAUP3aU+L+HmrJm4W0gtdrPotgwnKOReHREs6U+cd2rGbgJkY6IrKQ==
X-Received: by 2002:a05:600c:c4aa:b0:46d:d949:daba with SMTP id 5b1f17b1804b1-46e61262469mr24022125e9.4.1759307014182;
        Wed, 01 Oct 2025 01:23:34 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e5b622f37sm31576505e9.1.2025.10.01.01.23.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 01:23:33 -0700 (PDT)
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
Subject: [PATCH 23/25] system/physmem: Reduce cpu_physical_memory_sync_dirty_bitmap() scope
Date: Wed,  1 Oct 2025 10:21:23 +0200
Message-ID: <20251001082127.65741-24-philmd@linaro.org>
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

cpu_physical_memory_sync_dirty_bitmap() is now only called within
system/physmem.c, by ramblock_sync_dirty_bitmap(). Reduce its scope
by making it internal to this file. Since it doesn't involve any CPU,
remove the 'cpu_' prefix.
Remove the now unneeded "qemu/rcu.h" and "system/memory.h" headers.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/ram_addr.h | 79 ---------------------------------------
 migration/ram.c           | 78 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 77 insertions(+), 80 deletions(-)

diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
index c55e3849b0e..24dba1fba1c 100644
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
@@ -177,80 +174,4 @@ bool cpu_physical_memory_snapshot_get_dirty(DirtyBitmapSnapshot *snap,
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
index 91e65be83d8..e797c0710d3 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -935,11 +935,87 @@ bool ramblock_page_is_discarded(RAMBlock *rb, ram_addr_t start)
     return false;
 }
 
+/* Called with RCU critical section */
+static inline
+uint64_t physical_memory_sync_dirty_bitmap(RAMBlock *rb,
+                                           ram_addr_t start,
+                                           ram_addr_t length)
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


