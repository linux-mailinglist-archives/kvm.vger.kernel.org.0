Return-Path: <kvm+bounces-59361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09A28BB16A2
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 19:56:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B15DA1C6878
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 17:56:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A29A27E07A;
	Wed,  1 Oct 2025 17:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qXrvaaFB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A0029B8C0
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 17:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759341392; cv=none; b=cy9Lxffj4Vr3k7VQfi3VRYh2lcQzkUuABuAFfPRv8i8y2N/13BDH3CvNqyQSuFfalCCOalHPTsLNuHaO70BtxDBXnVerz2ixQeqZ72ErTMJjr8lqI04u1Ilo1y8H7H45359OGkfLqGv5cmZ42rNy5vh1VagSMfOVpu0jky8qzeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759341392; c=relaxed/simple;
	bh=TvCWyy/tfuXagOfUMaJoHSdLRF97cOza1rrSoZaV5v4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h9mev+7zxasXsFGdLWcPVNY9MCDy+z0ZP8Iwgi3X/voyylsimWEXPnvXDbiYR/tR+pJCJ+xTfsB88JbBvuc6JCQnT1hYCCdYXT2+B2t2+ObGja0zQ1yyIWdNKsyJ38b4IBq7+a9mgN5jzEhGHTnFKGwtp92E9oOhsG7qtpBAFxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qXrvaaFB; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-42420c7de22so65344f8f.1
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 10:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759341389; x=1759946189; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oUtiRAnaxKSP60r/7sUloA0VCWrW5xNC9QAgYTiLe7A=;
        b=qXrvaaFB0jve5nUKIFtECbug+ZW5CUhUx546H0vIsgJplPh2JRFu1ih/ZW1P6KABPT
         8/0wJl/Uzymrguvl6bcW2vPclVN4bL8hnYhbjPJMYQMiWaFIKZjFg0mDCHS16V490Udy
         u+v/BRtr1KWkHhgzF/nzDxaB/xj412jkm2/LMc2NAmreegpyVMDTEEawkE3joTFd1ZQR
         2SkXKEuqnnjsqU8/5IVY+u6oGmyYD4ReIp48Dpi1fkDnRsRH2fh1qBWxx2dgdUbPinhq
         uFPv2DyZ8TWVcatgpHaTSxkExthiE3d5NihEW+zr4hsdakuvEFRE6FJFYEBZUPNNN1x0
         zqrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759341389; x=1759946189;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oUtiRAnaxKSP60r/7sUloA0VCWrW5xNC9QAgYTiLe7A=;
        b=h3m8fxAzXJObgZXbT5QZj6JojfSYZI515uEJ+HvTa/NCr4R06KmQVBnBwwCJV1FDJt
         CnXbeHRamlKkVuA9zF7pEEEByvncS7edvgOZmBw/pxIyvIIDtl9RMi5xdsqvzgI69W7f
         o6oF4XTFDZ8HWVjoVosYD52lu5aqRULFMLs5puKcdgnLQcRNuRD8+ACLrJCFXXiqr4oB
         0IC+sFTzL/mlcOLTbGLzNwFXfIxV8qFkvIgQEmKpRQ5L08R98XRw6o6akdjuZuCVgEl4
         5RjnrrQnDbv0FjKN8MtmlffYusuqAJspZjT9GBqk2KAWd3UwFN/XmKxIelTpVa+FGAFs
         HXjw==
X-Forwarded-Encrypted: i=1; AJvYcCVYIKiUtJEqMQEY8efIjIrt//r0LUztw2YEEYe4BnA8JEejSAPwnkJigrZrVSyaM+R7DS4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIf94nmp51RG9f2MPAI/lE49hhCCnq7S3hBx03eHkG34AqjY7I
	1sieVegvm1AVKRXzJC1FC4Or+ORvM9caW1i16jvB+pJInI6ygCZZMiFOncd2y1gJDeY=
X-Gm-Gg: ASbGncsRnz1MGTLth5X+ST+0+WjRxqp4D9clfskIG3H8V2/5lSNwZkCKjzLohXxELS/
	r1IyM36vKkV1kVrQ0uFPlyZfaRdjvc538p63TSq2WosF9T1VztjCyx9Csr8Wnbyq+5hnFhivz9o
	CXKBp3rs6bCtxe55h15Ix+qTmVQwzehby5Pge/QLfRoCHbFKbOaKBJvYiVLCteUYzPgn4pfJGgc
	GL+Kzik2tLVyUqHEEilXJuZjqSMZYFsPfOjGIdo2fB74nsxuCSvciWS0sSJQ4MwYp47UJ4+UZgF
	lidUbcOcJV+0bkCDIzuItY6SzTB4pV+3EUIe28rD6s/eCuQqsJ8RyfQvp1XaG2PmV1SJTU0l8Sl
	h18ooXz5OlQf7XBdrEMAIeJvRSQanyETIIazAkXs5UefUQwd2ONHvLilGHG/N4tWk8Q6coVS2Z/
	qEych+FiwZZFRtfzt9MihW2KVaDg==
X-Google-Smtp-Source: AGHT+IF0ungF9viXC6MKUWoQtqH2uObDCFonrlzlTjU4n+Y3xL+pmh4m+aKa0XRbNR5Tcqmh1HV/fg==
X-Received: by 2002:a5d:588b:0:b0:3e7:610b:85f6 with SMTP id ffacd0b85a97d-42557824eecmr3638647f8f.39.1759341388635;
        Wed, 01 Oct 2025 10:56:28 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e61a265f6sm48392605e9.20.2025.10.01.10.56.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 10:56:28 -0700 (PDT)
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
Subject: [PATCH v2 18/18] system/physmem: Extract API out of 'system/ram_addr.h' header
Date: Wed,  1 Oct 2025 19:54:47 +0200
Message-ID: <20251001175448.18933-19-philmd@linaro.org>
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

Very few files use the Physical Memory API. Declare its
methods in their own header: "system/physmem.h".

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 MAINTAINERS                 |  1 +
 include/system/physmem.h    | 54 +++++++++++++++++++++++++++++++++++++
 include/system/ram_addr.h   | 40 ---------------------------
 accel/kvm/kvm-all.c         |  2 +-
 accel/tcg/cputlb.c          |  1 +
 hw/vfio/container-legacy.c  |  2 +-
 hw/vfio/container.c         |  1 +
 hw/vfio/listener.c          |  1 -
 migration/ram.c             |  1 +
 system/memory.c             |  1 +
 system/physmem.c            |  1 +
 target/arm/tcg/mte_helper.c |  2 +-
 12 files changed, 63 insertions(+), 44 deletions(-)
 create mode 100644 include/system/physmem.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 406cef88f0c..9632eb7b440 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3213,6 +3213,7 @@ S: Supported
 F: include/system/ioport.h
 F: include/exec/memop.h
 F: include/system/memory.h
+F: include/system/physmem.h
 F: include/system/ram_addr.h
 F: include/system/ramblock.h
 F: include/system/memory_mapping.h
diff --git a/include/system/physmem.h b/include/system/physmem.h
new file mode 100644
index 00000000000..879f6eae38b
--- /dev/null
+++ b/include/system/physmem.h
@@ -0,0 +1,54 @@
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
+uint8_t physical_memory_range_includes_clean(ram_addr_t start,
+                                             ram_addr_t length,
+                                             uint8_t mask);
+
+void physical_memory_set_dirty_flag(ram_addr_t addr, unsigned client);
+
+void physical_memory_set_dirty_range(ram_addr_t start, ram_addr_t length,
+                                     uint8_t mask);
+
+/*
+ * Contrary to physical_memory_sync_dirty_bitmap() this function returns
+ * the number of dirty pages in @bitmap passed as argument. On the other hand,
+ * physical_memory_sync_dirty_bitmap() returns newly dirtied pages that
+ * weren't set in the global migration bitmap.
+ */
+uint64_t physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
+                                            ram_addr_t start,
+                                            ram_addr_t pages);
+
+void physical_memory_dirty_bits_cleared(ram_addr_t start, ram_addr_t length);
+
+bool physical_memory_test_and_clear_dirty(ram_addr_t start,
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
index 3894a84fb9c..683485980ce 100644
--- a/include/system/ram_addr.h
+++ b/include/system/ram_addr.h
@@ -19,7 +19,6 @@
 #ifndef SYSTEM_RAM_ADDR_H
 #define SYSTEM_RAM_ADDR_H
 
-#include "exec/ramlist.h"
 #include "system/ramblock.h"
 #include "exec/target_page.h"
 #include "exec/hwaddr.h"
@@ -133,43 +132,4 @@ static inline void qemu_ram_block_writeback(RAMBlock *block)
     qemu_ram_msync(block, 0, block->used_length);
 }
 
-#define DIRTY_CLIENTS_ALL     ((1 << DIRTY_MEMORY_NUM) - 1)
-#define DIRTY_CLIENTS_NOCODE  (DIRTY_CLIENTS_ALL & ~(1 << DIRTY_MEMORY_CODE))
-
-bool physical_memory_get_dirty_flag(ram_addr_t addr, unsigned client);
-
-bool physical_memory_is_clean(ram_addr_t addr);
-
-uint8_t physical_memory_range_includes_clean(ram_addr_t start,
-                                                 ram_addr_t length,
-                                                 uint8_t mask);
-
-void physical_memory_set_dirty_flag(ram_addr_t addr, unsigned client);
-
-void physical_memory_set_dirty_range(ram_addr_t start, ram_addr_t length,
-                                         uint8_t mask);
-
-/*
- * Contrary to physical_memory_sync_dirty_bitmap() this function returns
- * the number of dirty pages in @bitmap passed as argument. On the other hand,
- * physical_memory_sync_dirty_bitmap() returns newly dirtied pages that
- * weren't set in the global migration bitmap.
- */
-uint64_t physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
-                                                ram_addr_t start,
-                                                ram_addr_t pages);
-
-void physical_memory_dirty_bits_cleared(ram_addr_t start, ram_addr_t length);
-
-bool physical_memory_test_and_clear_dirty(ram_addr_t start,
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
index a721235dea6..7214d41cb5d 100644
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
index d09591c0600..12122dda685 100644
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
index 1a075da2bdd..ec3d8027e86 100644
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


