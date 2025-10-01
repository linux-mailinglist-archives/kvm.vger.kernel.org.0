Return-Path: <kvm+bounces-59267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE4AEBAF979
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:24:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B9CD16A34F
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:24:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 083E1281508;
	Wed,  1 Oct 2025 08:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IwEgx72i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22ABA27B35D
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 08:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759307029; cv=none; b=Km+68lj7MxM7wb4jpCXgn6VXmcoj6wdnDiNamaE8XjUWrKspCvmfIrhVJeqNYImReGxDcda/qPRScqtFhBz8vkXCboIW2PsHIiV9Kn/4v3I1rdOPSlM1FFM9DUNXimF9VhqaYLBpskaJRL8RUuj2cmiX3MMZvolvXlVYbF2A0iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759307029; c=relaxed/simple;
	bh=tSUE0q7VlNw0pqfMVkzpiAwG3N6+xFjQQGGKa/qb+sA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rkg2k/KRXJIM6QAS7ZD16XVVug4qeYEWVEVdch8PKr5XrAm1vP/ehdSc+rbZ5K+soqH6TAu5DEv5kgK8vjiUsv13/UucNtQaIKyTnRr72iM/PO/MSY0mdx/7xQaGscAIUixDZk9jO061Wq7RivQghj8Vb1rwWEuN/kQYGNsKibg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IwEgx72i; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-46e3ea0445fso29434715e9.1
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 01:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759307025; x=1759911825; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UO9Z4GKWaIosFTRHzbHFaFZFTr7IEOVGgy8hYFFsW+g=;
        b=IwEgx72invFqD36GOjFJMFmeNSm2wPItU/JOio0WHHXRd/cCNF/cqTmteyrqT24ICa
         iIqvvzp2hJclQZKVAGkftOmKTIOOo8FgVXEsPrP7IFM+sjs7J3iy5xVQzKuz7A9nhwqT
         GvMiPLiZ++Mk1PZ6vYP6WMw/2BPUdXINAjp8YOHF3iNY2PO5tfpI+9gIlQ9gK8Ht2oIu
         sZm/i2kwfSiRXsETfCWZ8nanmg52l8J8yg66bzKaRhRHc3atb1NljYGkNWYfGPYrP7PY
         7H/OkZ77WQzuPrIq38sxdYz9vWRW8UpSaEO9+ESYct087pUOCMD3K3kM5ZWJgsF4wSo4
         fibQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759307025; x=1759911825;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UO9Z4GKWaIosFTRHzbHFaFZFTr7IEOVGgy8hYFFsW+g=;
        b=V4BKTAmz6AGgu6OF3srovQqnHLqwcXldFWnm618dTRy7ZtxLWGyIID2f5vKJpIwRDW
         T/VpUubGQaZ6rb1vtjsCO5/saPxRBIDDY1upD7BhRf3CNJI8FIlwnFnufReMLKlC3Mn8
         HNizUE3ibvqURsgRhSKxkPRZ02t0O4/4cqzzV0fOzI03vVcWJkDdAqEf3mr57v+qPAZ6
         22UBvmRD0s+LluykO3abYkabNHZ6lSm0Moa4M7KOiuuh2ac9p2Iknbb1HF3TJH2KwwK3
         /O8oZYU5H0ocYZHACqjxB0IiXef8kyZTI1KKVrdRaQzaDKXBwSMUoal5w1woCyGywzOk
         bMLA==
X-Forwarded-Encrypted: i=1; AJvYcCUQfnUXHZMVDL3lXL2SJlZVqQs++7LNLbl5zhX6NE+xwRHjnPAWko2L/eO8fekbEwYCt+g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy99GtYGcpKJdH7To7/F1zyHe3ZCnPqmjYxPO2R2Utf8sG9QhQY
	hdQiPqUZxguOgZ8DXzNJakK/jezUpNbHvcX7dT7+83hTDhrT08KWW4kgRbG2OzEzwakqvT3ARLS
	wjzYs1X2IAA==
X-Gm-Gg: ASbGncuw5T67rNj5qhx94qrwTayYeJMMDlvuIWtonTIwOcP6phAJ5Z1qjSvrLSARgUv
	DfG3YPf+bFbe1LotedBnlHaHX5Iub+cxOHL0IiLAk6uTySCoAKjUG7V+bNOhPguvdZ/9Er846Fz
	l6jQ1DIw1S9xq0sEeiTyX4zr2cN4EkEBJkq6SWxemnxsXKpZeIzJuNu2sC9r8dFxnq5wJ94bd3i
	E9CdafkFc18pBsMLp4gWlC6f8mQZiX/IOc1QR9mddQcUJtyaQVkx4PDRGofhPsJNFl6Tbi2zo4O
	6EugMya323IZu16anJjPURRMMOl+3rKAkqi7on11zmXXp71IQ7IR5AaQbQM/O9RPqaTDDz0P71Y
	JAL+SXtnxon2PM/RjfvBowj0po+B/WnGosoJimJbX0PTOj71R9FxXZfunHaUbckLqpL1CqdcV30
	oR7FqWePLwHP9SrhiALT7HCpdHm0l8JDI=
X-Google-Smtp-Source: AGHT+IFtxY40tW31NbHANJrw8uPERV9eGTJ6/FDL0Ox5O64nmtRj5TVEThXt88q9V8X5bv6p5WBmeg==
X-Received: by 2002:a05:600c:6216:b0:46e:44bf:210 with SMTP id 5b1f17b1804b1-46e61267be4mr20282665e9.22.1759307025338;
        Wed, 01 Oct 2025 01:23:45 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc7d3780asm26055291f8f.52.2025.10.01.01.23.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 01:23:44 -0700 (PDT)
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
Subject: [PATCH 25/25] system/physmem: Extract API out of 'system/ram_addr.h' header
Date: Wed,  1 Oct 2025 10:21:25 +0200
Message-ID: <20251001082127.65741-26-philmd@linaro.org>
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

Very few files use the Physical Memory API. Declare its
methods in their own header: "system/physmem.h".

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 MAINTAINERS                 |  1 +
 include/system/physmem.h    | 56 +++++++++++++++++++++++++++++++++++++
 include/system/ram_addr.h   | 42 ----------------------------
 accel/kvm/kvm-all.c         |  2 +-
 accel/tcg/cputlb.c          |  1 +
 hw/vfio/container-legacy.c  |  2 +-
 hw/vfio/container.c         |  1 +
 hw/vfio/listener.c          |  1 -
 migration/ram.c             |  1 +
 system/memory.c             |  1 +
 system/physmem.c            |  1 +
 target/arm/tcg/mte_helper.c |  2 +-
 12 files changed, 65 insertions(+), 46 deletions(-)
 create mode 100644 include/system/physmem.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 7d134a85e66..866b43434c7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3206,6 +3206,7 @@ S: Supported
 F: include/system/ioport.h
 F: include/exec/memop.h
 F: include/system/memory.h
+F: include/system/physmem.h
 F: include/system/ram_addr.h
 F: include/system/ramblock.h
 F: include/system/memory_mapping.h
diff --git a/include/system/physmem.h b/include/system/physmem.h
new file mode 100644
index 00000000000..7ae266729d2
--- /dev/null
+++ b/include/system/physmem.h
@@ -0,0 +1,56 @@
+/*
+ * QEMU physical memory interfaces (target independent).
+ *
+ *  Copyright (c) 2003 Fabrice Bellard
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+#ifndef QEMU_SYSTEM_PHYSMEM_H
+#define QEMU_SYSTEM_PHYSMEM_H
+
+#include "exec/hwaddr.h"
+#include "exec/ramlist.h"
+
+#define DIRTY_CLIENTS_ALL     ((1 << DIRTY_MEMORY_NUM) - 1)
+#define DIRTY_CLIENTS_NOCODE  (DIRTY_CLIENTS_ALL & ~(1 << DIRTY_MEMORY_CODE))
+
+bool physical_memory_get_dirty_flag(ram_addr_t addr, unsigned client);
+
+bool physical_memory_is_clean(ram_addr_t addr);
+
+uint8_t physical_memory_range_includes_clean(ram_addr_t addr,
+                                             ram_addr_t length,
+                                             uint8_t mask);
+
+void physical_memory_set_dirty_flag(ram_addr_t addr, unsigned client);
+
+void physical_memory_set_dirty_range(ram_addr_t addr, ram_addr_t length,
+                                     uint8_t mask);
+
+#if !defined(_WIN32)
+/*
+ * Contrary to physical_memory_sync_dirty_bitmap() this function returns
+ * the number of dirty pages in @bitmap passed as argument. On the other hand,
+ * physical_memory_sync_dirty_bitmap() returns newly dirtied pages that
+ * weren't set in the global migration bitmap.
+ */
+uint64_t physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
+                                            ram_addr_t start,
+                                            ram_addr_t pages);
+#endif /* not _WIN32 */
+
+void physical_memory_dirty_bits_cleared(ram_addr_t addr, ram_addr_t length);
+
+bool physical_memory_test_and_clear_dirty(ram_addr_t addr,
+                                          ram_addr_t length,
+                                          unsigned client);
+
+DirtyBitmapSnapshot *
+physical_memory_snapshot_and_clear_dirty(MemoryRegion *mr, hwaddr offset,
+                                         hwaddr length, unsigned client);
+
+bool physical_memory_snapshot_get_dirty(DirtyBitmapSnapshot *snap,
+                                        ram_addr_t start,
+                                        ram_addr_t length);
+
+#endif
diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
index 015f943603b..683485980ce 100644
--- a/include/system/ram_addr.h
+++ b/include/system/ram_addr.h
@@ -19,7 +19,6 @@
 #ifndef SYSTEM_RAM_ADDR_H
 #define SYSTEM_RAM_ADDR_H
 
-#include "exec/ramlist.h"
 #include "system/ramblock.h"
 #include "exec/target_page.h"
 #include "exec/hwaddr.h"
@@ -133,45 +132,4 @@ static inline void qemu_ram_block_writeback(RAMBlock *block)
     qemu_ram_msync(block, 0, block->used_length);
 }
 
-#define DIRTY_CLIENTS_ALL     ((1 << DIRTY_MEMORY_NUM) - 1)
-#define DIRTY_CLIENTS_NOCODE  (DIRTY_CLIENTS_ALL & ~(1 << DIRTY_MEMORY_CODE))
-
-bool physical_memory_get_dirty_flag(ram_addr_t addr, unsigned client);
-
-bool physical_memory_is_clean(ram_addr_t addr);
-
-uint8_t physical_memory_range_includes_clean(ram_addr_t addr,
-                                                 ram_addr_t length,
-                                                 uint8_t mask);
-
-void physical_memory_set_dirty_flag(ram_addr_t addr, unsigned client);
-
-void physical_memory_set_dirty_range(ram_addr_t addr, ram_addr_t length,
-                                         uint8_t mask);
-
-#if !defined(_WIN32)
-/*
- * Contrary to physical_memory_sync_dirty_bitmap() this function returns
- * the number of dirty pages in @bitmap passed as argument. On the other hand,
- * physical_memory_sync_dirty_bitmap() returns newly dirtied pages that
- * weren't set in the global migration bitmap.
- */
-uint64_t physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
-                                                ram_addr_t start,
-                                                ram_addr_t pages);
-#endif /* not _WIN32 */
-
-void physical_memory_dirty_bits_cleared(ram_addr_t addr, ram_addr_t length);
-
-bool physical_memory_test_and_clear_dirty(ram_addr_t addr,
-                                              ram_addr_t length,
-                                              unsigned client);
-
-DirtyBitmapSnapshot *physical_memory_snapshot_and_clear_dirty
-    (MemoryRegion *mr, hwaddr offset, hwaddr length, unsigned client);
-
-bool physical_memory_snapshot_get_dirty(DirtyBitmapSnapshot *snap,
-                                            ram_addr_t start,
-                                            ram_addr_t length);
-
 #endif
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index a7ece7db964..58802f7c3cc 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -32,13 +32,13 @@
 #include "system/runstate.h"
 #include "system/cpus.h"
 #include "system/accel-blocker.h"
+#include "system/physmem.h"
 #include "system/ramblock.h"
 #include "accel/accel-ops.h"
 #include "qemu/bswap.h"
 #include "exec/tswap.h"
 #include "exec/target_page.h"
 #include "system/memory.h"
-#include "system/ram_addr.h"
 #include "qemu/event_notifier.h"
 #include "qemu/main-loop.h"
 #include "trace.h"
diff --git a/accel/tcg/cputlb.c b/accel/tcg/cputlb.c
index 1f5dd023a0a..8e1ec7ab1af 100644
--- a/accel/tcg/cputlb.c
+++ b/accel/tcg/cputlb.c
@@ -25,6 +25,7 @@
 #include "accel/tcg/probe.h"
 #include "exec/page-protection.h"
 #include "system/memory.h"
+#include "system/physmem.h"
 #include "accel/tcg/cpu-ldst-common.h"
 #include "accel/tcg/cpu-mmu-index.h"
 #include "exec/cputlb.h"
diff --git a/hw/vfio/container-legacy.c b/hw/vfio/container-legacy.c
index eb9911eaeaf..755a407f3e7 100644
--- a/hw/vfio/container-legacy.c
+++ b/hw/vfio/container-legacy.c
@@ -25,7 +25,7 @@
 #include "hw/vfio/vfio-device.h"
 #include "system/address-spaces.h"
 #include "system/memory.h"
-#include "system/ram_addr.h"
+#include "system/physmem.h"
 #include "qemu/error-report.h"
 #include "qemu/range.h"
 #include "system/reset.h"
diff --git a/hw/vfio/container.c b/hw/vfio/container.c
index 3fb19a1c8ad..9ddec300e35 100644
--- a/hw/vfio/container.c
+++ b/hw/vfio/container.c
@@ -20,6 +20,7 @@
 #include "qemu/error-report.h"
 #include "hw/vfio/vfio-container.h"
 #include "hw/vfio/vfio-device.h" /* vfio_device_reset_handler */
+#include "system/physmem.h"
 #include "system/reset.h"
 #include "vfio-helpers.h"
 
diff --git a/hw/vfio/listener.c b/hw/vfio/listener.c
index b5cefc9395c..c6bb58f5209 100644
--- a/hw/vfio/listener.c
+++ b/hw/vfio/listener.c
@@ -30,7 +30,6 @@
 #include "hw/vfio/pci.h"
 #include "system/address-spaces.h"
 #include "system/memory.h"
-#include "system/ram_addr.h"
 #include "hw/hw.h"
 #include "qemu/error-report.h"
 #include "qemu/main-loop.h"
diff --git a/migration/ram.c b/migration/ram.c
index db745f2a028..21b8c78fa91 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -53,6 +53,7 @@
 #include "qemu/rcu_queue.h"
 #include "migration/colo.h"
 #include "system/cpu-throttle.h"
+#include "system/physmem.h"
 #include "system/ramblock.h"
 #include "savevm.h"
 #include "qemu/iov.h"
diff --git a/system/memory.c b/system/memory.c
index dd045da60c0..80656c69568 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -25,6 +25,7 @@
 #include "qemu/target-info.h"
 #include "qom/object.h"
 #include "trace.h"
+#include "system/physmem.h"
 #include "system/ram_addr.h"
 #include "system/kvm.h"
 #include "system/runstate.h"
diff --git a/system/physmem.c b/system/physmem.c
index 784c2810964..b245cd14d43 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -43,6 +43,7 @@
 #include "system/kvm.h"
 #include "system/tcg.h"
 #include "system/qtest.h"
+#include "system/physmem.h"
 #include "system/ramblock.h"
 #include "qemu/timer.h"
 #include "qemu/config-file.h"
diff --git a/target/arm/tcg/mte_helper.c b/target/arm/tcg/mte_helper.c
index 077ff4b2b2c..b96c953f809 100644
--- a/target/arm/tcg/mte_helper.c
+++ b/target/arm/tcg/mte_helper.c
@@ -27,7 +27,7 @@
 #include "user/cpu_loop.h"
 #include "user/page-protection.h"
 #else
-#include "system/ram_addr.h"
+#include "system/physmem.h"
 #endif
 #include "accel/tcg/cpu-ldst.h"
 #include "accel/tcg/probe.h"
-- 
2.51.0


