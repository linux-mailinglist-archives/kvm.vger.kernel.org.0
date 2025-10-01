Return-Path: <kvm+bounces-59260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 68F26BAF964
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:23:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C8ABF189AE12
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:23:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6229327FB2B;
	Wed,  1 Oct 2025 08:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="T17mLyqC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD4627A465
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 08:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759306990; cv=none; b=U2EhcPo9ZV3K7Nc0GbjR6dVwGqX5NsgooafROkNO/j7Y8pFFmuCVuru7yQ3tC9/FPpKCypSCIQ9G+Upwmj/yIHbfs0BZaA3aujVQgMj1TI5cR/wkvPeDH+7qj9LHvg4DG3jt1UH+GYnfT4bupM7GLtkm5zVXMO8uVzggMB0DXT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759306990; c=relaxed/simple;
	bh=S+4sv3lbk5ML+nkO3JgPq5Qb7C04I588DQbrsV0E0YU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dzzd55i2pvpKfXEiauVcmW4nUVxcFJv17kfmwKO90amlF/eFFEehO1cemnTZEpp9D6Qyt7nFzV8YiW7Giy79cRTzyZd0as2EaOL+kNq/nlkvDqA0b980YNUh2h7a0tEhjZGhNz03oe4t+pJa9sBGqNlineIAE1y8ZFP4Cgd827Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=T17mLyqC; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-46e6674caa5so984255e9.0
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 01:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759306987; x=1759911787; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YB31f3SnOrBT6zoXspLyOSupGu2zupb4dG+i3+hnw94=;
        b=T17mLyqCkuFDMtu/aMYlLmIviGuUin+OrpV6qyarXZxCCUmKOxBLELR/9WUMiwjRew
         zKrh9aW+kg0UQ8o2wXwu64E4yaNbki5Mvbw/OX68Pz9XPtF7Tmwypk1j3pZgbrGuzYqR
         oR952VxaCaTOGogbw34GMwz/twFNMSTKZgr6+2MTT+rrkb0i1nMIldIqEpQITZsm8vEO
         nB8Tp2bE13TbNXy5QbkPql/pcSxBCLOGldJ/ZxVNuh2viQYEQ2bOjiHX7Aa4peFLkRUM
         hG1Dq+O+3oiVbl5UZF/kjtAJReqVNpRpmBN68apn84girsKli7DD1DloeLowYrKdidr8
         H5Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759306987; x=1759911787;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YB31f3SnOrBT6zoXspLyOSupGu2zupb4dG+i3+hnw94=;
        b=eOrXdM3ceyxnum965eqpwH4YFQ7rkY/8VRCz7i4eL1J03Ia3h3DtV+7DhjOAU7yA9+
         efv9ojpO86tcGNct/nhA06zuQ44ELGwK1DICbQVJ78QMRM3J+nk1Q+xFoy+D57LSTuUR
         uL4LXPtt7hm0LMODWR51LnZGz9rwyqlqI0micLlYE28e0ppspDxs8OVoobOs11sGPWWh
         474ox+WzM/v/wHsh+8v7tApbY46k9hiMG8i8hphTNYOQnK0eMFnosODbQicbeLzBfV6D
         9FO/MYaVJBihR9/SQLIf6wkad2jUr4UkBUMjoMQWlb98IF8DqGCMarII9IGz8QhxnpGQ
         VVOg==
X-Forwarded-Encrypted: i=1; AJvYcCUFkxq9sd+UafVbNf01ebJvcpSJkUzE7SKbZmoymSrHBGz9DXJAnva03SL7E0Z/PN5uxYk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy06hGzhEWbJu3nWQFxkny380AH9h6GlMM0ehB4h8LrcnoSEZOp
	XiBC4oBd0P7T0zPRyATMov4S2LuT12qQo4fw4dyu+gxSslKV+oCOldgPMx5gFOxtSc0=
X-Gm-Gg: ASbGncvz7w89wR5WJRN6+C4DI8Yr379UIRP3e2G1oGpIyrg/EKmhshVVvbbfkLp8ZQS
	n73qxQdl7S9siA2jTiFSLyUCuPc8VpKPzWh5kwid+1/aCQo5FO6Av0Vn0FzL27i3UeA53V83WT5
	Bp/ew5ScqsjEfQdVEFvbqu5wTSseM3wsjOC4G1HpiNC77sMM+/bimQhe2mRxceZX3drtMCJAyJc
	liuKmbAUGGkHhXVdowgHxVuFUoHdyge12aBUT6pjeYUM72gC1cmh72D+xLHZwMEdmVlbfvkSAkz
	ahh1sVtYzc7MSYLYbySwmvdfoaz331aHrNJknWRjNxRhtNK4r/YhsPhLIqwH1RAWwn5tT+506Ot
	1kDEL0EODOya/e32I4Y+4CMfZn+XqwK17A5PBeWVWQxfQ5q2KW5PaORdbtoqRMr9b9FKU99W6d6
	ETwBDw2yFNNY14PS+2x3i8
X-Google-Smtp-Source: AGHT+IGA97ouW7V3aI0vwlChFMcdiXoAwJP/OMRCztYRqvbyZTrDJjFM6Ab9EV4QJLzzmgUJhI7sUA==
X-Received: by 2002:a05:600c:a407:b0:46e:28cc:e56f with SMTP id 5b1f17b1804b1-46e58abdf61mr62230685e9.6.1759306986862;
        Wed, 01 Oct 2025 01:23:06 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e5b5f3015sm32174185e9.1.2025.10.01.01.23.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 01:23:06 -0700 (PDT)
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
Subject: [PATCH 18/25] system/physmem: Un-inline cpu_physical_memory_set_dirty_lebitmap()
Date: Wed,  1 Oct 2025 10:21:18 +0200
Message-ID: <20251001082127.65741-19-philmd@linaro.org>
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

Remove the now unneeded "system/xen.h" header.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/ram_addr.h | 103 +------------------------------------
 system/physmem.c          | 105 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 106 insertions(+), 102 deletions(-)

diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
index 6377dd19a2f..4c227fee412 100644
--- a/include/system/ram_addr.h
+++ b/include/system/ram_addr.h
@@ -19,7 +19,6 @@
 #ifndef SYSTEM_RAM_ADDR_H
 #define SYSTEM_RAM_ADDR_H
 
-#include "system/xen.h"
 #include "system/tcg.h"
 #include "exec/cputlb.h"
 #include "exec/ramlist.h"
@@ -156,115 +155,15 @@ void cpu_physical_memory_set_dirty_range(ram_addr_t addr, ram_addr_t length,
                                          uint8_t mask);
 
 #if !defined(_WIN32)
-
 /*
  * Contrary to cpu_physical_memory_sync_dirty_bitmap() this function returns
  * the number of dirty pages in @bitmap passed as argument. On the other hand,
  * cpu_physical_memory_sync_dirty_bitmap() returns newly dirtied pages that
  * weren't set in the global migration bitmap.
  */
-static inline
 uint64_t cpu_physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
                                                 ram_addr_t start,
-                                                ram_addr_t pages)
-{
-    unsigned long i, j;
-    unsigned long page_number, c, nbits;
-    hwaddr addr;
-    ram_addr_t ram_addr;
-    uint64_t num_dirty = 0;
-    unsigned long len = (pages + HOST_LONG_BITS - 1) / HOST_LONG_BITS;
-    unsigned long hpratio = qemu_real_host_page_size() / TARGET_PAGE_SIZE;
-    unsigned long page = BIT_WORD(start >> TARGET_PAGE_BITS);
-
-    /* start address is aligned at the start of a word? */
-    if ((((page * BITS_PER_LONG) << TARGET_PAGE_BITS) == start) &&
-        (hpratio == 1)) {
-        unsigned long **blocks[DIRTY_MEMORY_NUM];
-        unsigned long idx;
-        unsigned long offset;
-        long k;
-        long nr = BITS_TO_LONGS(pages);
-
-        idx = (start >> TARGET_PAGE_BITS) / DIRTY_MEMORY_BLOCK_SIZE;
-        offset = BIT_WORD((start >> TARGET_PAGE_BITS) %
-                          DIRTY_MEMORY_BLOCK_SIZE);
-
-        WITH_RCU_READ_LOCK_GUARD() {
-            for (i = 0; i < DIRTY_MEMORY_NUM; i++) {
-                blocks[i] =
-                    qatomic_rcu_read(&ram_list.dirty_memory[i])->blocks;
-            }
-
-            for (k = 0; k < nr; k++) {
-                if (bitmap[k]) {
-                    unsigned long temp = leul_to_cpu(bitmap[k]);
-
-                    nbits = ctpopl(temp);
-                    qatomic_or(&blocks[DIRTY_MEMORY_VGA][idx][offset], temp);
-
-                    if (global_dirty_tracking) {
-                        qatomic_or(
-                                &blocks[DIRTY_MEMORY_MIGRATION][idx][offset],
-                                temp);
-                        if (unlikely(
-                            global_dirty_tracking & GLOBAL_DIRTY_DIRTY_RATE)) {
-                            total_dirty_pages += nbits;
-                        }
-                    }
-
-                    num_dirty += nbits;
-
-                    if (tcg_enabled()) {
-                        qatomic_or(&blocks[DIRTY_MEMORY_CODE][idx][offset],
-                                   temp);
-                    }
-                }
-
-                if (++offset >= BITS_TO_LONGS(DIRTY_MEMORY_BLOCK_SIZE)) {
-                    offset = 0;
-                    idx++;
-                }
-            }
-        }
-
-        if (xen_enabled()) {
-            xen_hvm_modified_memory(start, pages << TARGET_PAGE_BITS);
-        }
-    } else {
-        uint8_t clients = tcg_enabled() ? DIRTY_CLIENTS_ALL : DIRTY_CLIENTS_NOCODE;
-
-        if (!global_dirty_tracking) {
-            clients &= ~(1 << DIRTY_MEMORY_MIGRATION);
-        }
-
-        /*
-         * bitmap-traveling is faster than memory-traveling (for addr...)
-         * especially when most of the memory is not dirty.
-         */
-        for (i = 0; i < len; i++) {
-            if (bitmap[i] != 0) {
-                c = leul_to_cpu(bitmap[i]);
-                nbits = ctpopl(c);
-                if (unlikely(global_dirty_tracking & GLOBAL_DIRTY_DIRTY_RATE)) {
-                    total_dirty_pages += nbits;
-                }
-                num_dirty += nbits;
-                do {
-                    j = ctzl(c);
-                    c &= ~(1ul << j);
-                    page_number = (i * HOST_LONG_BITS + j) * hpratio;
-                    addr = page_number * TARGET_PAGE_SIZE;
-                    ram_addr = start + addr;
-                    cpu_physical_memory_set_dirty_range(ram_addr,
-                                       TARGET_PAGE_SIZE * hpratio, clients);
-                } while (c != 0);
-            }
-        }
-    }
-
-    return num_dirty;
-}
+                                                ram_addr_t pages);
 #endif /* not _WIN32 */
 
 static inline void cpu_physical_memory_dirty_bits_cleared(ram_addr_t start,
diff --git a/system/physmem.c b/system/physmem.c
index 383aecb391f..e78ca410ebf 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -1208,6 +1208,111 @@ bool cpu_physical_memory_snapshot_get_dirty(DirtyBitmapSnapshot *snap,
     return false;
 }
 
+#if !defined(_WIN32)
+uint64_t cpu_physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
+                                                ram_addr_t start,
+                                                ram_addr_t pages)
+{
+    unsigned long i, j;
+    unsigned long page_number, c, nbits;
+    hwaddr addr;
+    ram_addr_t ram_addr;
+    uint64_t num_dirty = 0;
+    unsigned long len = (pages + HOST_LONG_BITS - 1) / HOST_LONG_BITS;
+    unsigned long hpratio = qemu_real_host_page_size() / TARGET_PAGE_SIZE;
+    unsigned long page = BIT_WORD(start >> TARGET_PAGE_BITS);
+
+    /* start address is aligned at the start of a word? */
+    if ((((page * BITS_PER_LONG) << TARGET_PAGE_BITS) == start) &&
+        (hpratio == 1)) {
+        unsigned long **blocks[DIRTY_MEMORY_NUM];
+        unsigned long idx;
+        unsigned long offset;
+        long k;
+        long nr = BITS_TO_LONGS(pages);
+
+        idx = (start >> TARGET_PAGE_BITS) / DIRTY_MEMORY_BLOCK_SIZE;
+        offset = BIT_WORD((start >> TARGET_PAGE_BITS) %
+                          DIRTY_MEMORY_BLOCK_SIZE);
+
+        WITH_RCU_READ_LOCK_GUARD() {
+            for (i = 0; i < DIRTY_MEMORY_NUM; i++) {
+                blocks[i] =
+                    qatomic_rcu_read(&ram_list.dirty_memory[i])->blocks;
+            }
+
+            for (k = 0; k < nr; k++) {
+                if (bitmap[k]) {
+                    unsigned long temp = leul_to_cpu(bitmap[k]);
+
+                    nbits = ctpopl(temp);
+                    qatomic_or(&blocks[DIRTY_MEMORY_VGA][idx][offset], temp);
+
+                    if (global_dirty_tracking) {
+                        qatomic_or(
+                                &blocks[DIRTY_MEMORY_MIGRATION][idx][offset],
+                                temp);
+                        if (unlikely(
+                            global_dirty_tracking & GLOBAL_DIRTY_DIRTY_RATE)) {
+                            total_dirty_pages += nbits;
+                        }
+                    }
+
+                    num_dirty += nbits;
+
+                    if (tcg_enabled()) {
+                        qatomic_or(&blocks[DIRTY_MEMORY_CODE][idx][offset],
+                                   temp);
+                    }
+                }
+
+                if (++offset >= BITS_TO_LONGS(DIRTY_MEMORY_BLOCK_SIZE)) {
+                    offset = 0;
+                    idx++;
+                }
+            }
+        }
+
+        if (xen_enabled()) {
+            xen_hvm_modified_memory(start, pages << TARGET_PAGE_BITS);
+        }
+    } else {
+        uint8_t clients = tcg_enabled() ? DIRTY_CLIENTS_ALL
+                                        : DIRTY_CLIENTS_NOCODE;
+
+        if (!global_dirty_tracking) {
+            clients &= ~(1 << DIRTY_MEMORY_MIGRATION);
+        }
+
+        /*
+         * bitmap-traveling is faster than memory-traveling (for addr...)
+         * especially when most of the memory is not dirty.
+         */
+        for (i = 0; i < len; i++) {
+            if (bitmap[i] != 0) {
+                c = leul_to_cpu(bitmap[i]);
+                nbits = ctpopl(c);
+                if (unlikely(global_dirty_tracking & GLOBAL_DIRTY_DIRTY_RATE)) {
+                    total_dirty_pages += nbits;
+                }
+                num_dirty += nbits;
+                do {
+                    j = ctzl(c);
+                    c &= ~(1ul << j);
+                    page_number = (i * HOST_LONG_BITS + j) * hpratio;
+                    addr = page_number * TARGET_PAGE_SIZE;
+                    ram_addr = start + addr;
+                    cpu_physical_memory_set_dirty_range(ram_addr,
+                                       TARGET_PAGE_SIZE * hpratio, clients);
+                } while (c != 0);
+            }
+        }
+    }
+
+    return num_dirty;
+}
+#endif /* not _WIN32 */
+
 static int subpage_register(subpage_t *mmio, uint32_t start, uint32_t end,
                             uint16_t section);
 static subpage_t *subpage_init(FlatView *fv, hwaddr base);
-- 
2.51.0


