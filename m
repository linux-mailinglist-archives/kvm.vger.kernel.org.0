Return-Path: <kvm+bounces-40456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BB10A5742F
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:57:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58C79172B34
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 21:57:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 459A9256C93;
	Fri,  7 Mar 2025 21:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oyNxu/ZJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C953D257AC1
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 21:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741384600; cv=none; b=FA4wJImZ/TVESRyvEIfAGR4hb44ZBUGHcD61bEq5oF21AGplWsm8jvpWNNUl8u+HI/nZtNHvcuPVGmX5zjzg3kP5oEiL519+Ntn+9QbGnTVtnnGYsGOVT3/i3Sz3SGPTrSl327Zfg+Do01KDpzu8fKrLJgu4+uyq2u1L58A53J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741384600; c=relaxed/simple;
	bh=zp4c5q93rtLl5JHXbK/T+hj4e4a57opk8mw9PvBNMqs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ToZQ424BfcS1A08/H0jwwiDU+pzSJE1dJITGoScVWW+2eE2TDU1V5g+DYjxFb2ihFHuUKEOcqzWI/SkRkkwuYERXv4zJ4iJROcbddj/HEjRom3oV0wd6m7kZbDsbuG5plk+QS+vrlpk2gJCijMFM6Z1Tuay6B7Pn6bWx1jqnxCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oyNxu/ZJ; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-223959039f4so49592225ad.3
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 13:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741384598; x=1741989398; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sfg9fp/d1PdwCXS3veKjw2zFmzOBBZVU57mmT0JR/f0=;
        b=oyNxu/ZJzq0x7cRym8oG4Q6Dai6KLq94mWjFFVi6oG6/JBvKejOUNtNS9Whlh4ZQhv
         QMRf+YzIca5ML7xU+V+s6qjSziVd4FaR39ALTIQqjxbZn5ONAQpvsmvfahz9fl2SJJl3
         qrUozm4Vgaq6TtiGU2hpzzTfaf7D/SggDpTtPwj7m2Ys8QvW0Nflshwr1IEQiiLUf5aA
         kpFt/Ywux2RdLvSU/qLM5v1kiV29D47d5FBdgRziuHdAvSA2pVLP/QdOuxTVY6icL/eJ
         +SezVwLG/FWByOixRw92alEjC8X9olw0m4YWI9rc0/o/2lDSxzvFHqJMb7HAO3/nHM04
         5EIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741384598; x=1741989398;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sfg9fp/d1PdwCXS3veKjw2zFmzOBBZVU57mmT0JR/f0=;
        b=abwRlYH3XzmNFFOCulPwrMjbmXAWcN1PBCI6BGJZ9swzk89X2t92FO53lLKazuoyE5
         RVhBh4oilEDU0fq4yh0k9KNvE2NW6a8fPfddS9Cxwyu4G8YboQXs37VblIw7JxT/vIEq
         sQjrS+TEhl5bBpbEMmRqPHCoKW4tHRcHAy9K6CkVJmIpMXBv4XLawKzII7XfAhs3aw2s
         nHcmgMpSRU5C2m+lRVqDX79gTUqwISQxFUQ90vAZxNF7TW/mSW+ZGy8p/8LOfvMgAu5P
         KynG1Ey4VJgYJx64tyzJERqm3r8A2cu0vBYhc0H/WdFuu+A6MAYzysCy9CHgVp1kb/uS
         z8vw==
X-Forwarded-Encrypted: i=1; AJvYcCX58CBh2ZSj0ZNz1QCMQZ2fEIQ7Pjjfn8bqeByJHF+qzhx5hj4z1zhCkWr5nURbmgk0Rck=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/0k5tnwHh11j8Zn04IQlyosz3ZwX8+Zw8DVpU+dYXmWEuQjgx
	7ZI3jpKwnPK15HRqNZ/GEaGXCiwyVqSRe6X8c6Ss+wSWX+/PGSBSVD73sX5ApcLI7T+R6MVZPRU
	l
X-Gm-Gg: ASbGnct1lSL6GSAL5+nMNx6AjUm07OAY6yGOcLDwGtEJz4Y6iDQ+Y6TrlF9bPZ04yKu
	mL6gXqxeZ0dcJq7ZUXcPdBKl5FPFd8vsIip5EFpHRaCOiRe3fJoQ45zysPSW5kmCE7ztnDKj5F5
	MzqHPQZsKI5y6IAnE8834alr5djIVzrel8m8c7wUwDzZCCB36hBeRUfSZnfkVglp2Ez9XmMQQ8V
	WbXsgUgngI5iQYrjtz/ZZpxZo6JmmyaI3ImQ1tdAPudTBEb+hS+yYArF1UD5U90EIOtu/JTzTB0
	6t3yNyH/pV5Ls6iIfGXgw6QcC6nhWWdCiP5cqOcP5MJv
X-Google-Smtp-Source: AGHT+IGX5pfQXW7bvmwqA+NptD1rpRnsLsnmq6044IHwx1QKIiIQW9IhEs7zgPLZDe/E6y36RfvBrw==
X-Received: by 2002:a05:6a00:1817:b0:736:3979:369e with SMTP id d2e1a72fcca58-736aa9f1fcdmr6571296b3a.9.1741384596537;
        Fri, 07 Mar 2025 13:56:36 -0800 (PST)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736ac9247dcsm2000927b3a.125.2025.03.07.13.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 13:56:36 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: philmd@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	pierrick.bouvier@linaro.org,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	richard.henderson@linaro.org,
	manos.pitsidianakis@linaro.org
Subject: [PATCH v4 3/7] hw/hyperv/vmbus: common compilation unit
Date: Fri,  7 Mar 2025 13:56:19 -0800
Message-Id: <20250307215623.524987-4-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250307215623.524987-1-pierrick.bouvier@linaro.org>
References: <20250307215623.524987-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace TARGET_PAGE.* by runtime calls.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/hyperv/vmbus.c     | 50 +++++++++++++++++++++----------------------
 hw/hyperv/meson.build |  2 +-
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/hw/hyperv/vmbus.c b/hw/hyperv/vmbus.c
index 12a7dc43128..109ac319caf 100644
--- a/hw/hyperv/vmbus.c
+++ b/hw/hyperv/vmbus.c
@@ -18,7 +18,7 @@
 #include "hw/hyperv/vmbus.h"
 #include "hw/hyperv/vmbus-bridge.h"
 #include "hw/sysbus.h"
-#include "cpu.h"
+#include "exec/target_page.h"
 #include "trace.h"
 
 enum {
@@ -309,7 +309,7 @@ void vmbus_put_gpadl(VMBusGpadl *gpadl)
 
 uint32_t vmbus_gpadl_len(VMBusGpadl *gpadl)
 {
-    return gpadl->num_gfns * TARGET_PAGE_SIZE;
+    return gpadl->num_gfns * qemu_target_page_size();
 }
 
 static void gpadl_iter_init(GpadlIter *iter, VMBusGpadl *gpadl,
@@ -323,14 +323,14 @@ static void gpadl_iter_init(GpadlIter *iter, VMBusGpadl *gpadl,
 
 static inline void gpadl_iter_cache_unmap(GpadlIter *iter)
 {
-    uint32_t map_start_in_page = (uintptr_t)iter->map & ~TARGET_PAGE_MASK;
-    uint32_t io_end_in_page = ((iter->last_off - 1) & ~TARGET_PAGE_MASK) + 1;
+    uint32_t map_start_in_page = (uintptr_t)iter->map & ~qemu_target_page_mask();
+    uint32_t io_end_in_page = ((iter->last_off - 1) & ~qemu_target_page_mask()) + 1;
 
     /* mapping is only done to do non-zero amount of i/o */
     assert(iter->last_off > 0);
     assert(map_start_in_page < io_end_in_page);
 
-    dma_memory_unmap(iter->as, iter->map, TARGET_PAGE_SIZE - map_start_in_page,
+    dma_memory_unmap(iter->as, iter->map, qemu_target_page_size() - map_start_in_page,
                      iter->dir, io_end_in_page - map_start_in_page);
 }
 
@@ -348,17 +348,17 @@ static ssize_t gpadl_iter_io(GpadlIter *iter, void *buf, uint32_t len)
     assert(iter->active);
 
     while (len) {
-        uint32_t off_in_page = iter->off & ~TARGET_PAGE_MASK;
-        uint32_t pgleft = TARGET_PAGE_SIZE - off_in_page;
+        uint32_t off_in_page = iter->off & ~qemu_target_page_mask();
+        uint32_t pgleft = qemu_target_page_size() - off_in_page;
         uint32_t cplen = MIN(pgleft, len);
         void *p;
 
         /* try to reuse the cached mapping */
         if (iter->map) {
             uint32_t map_start_in_page =
-                (uintptr_t)iter->map & ~TARGET_PAGE_MASK;
-            uint32_t off_base = iter->off & ~TARGET_PAGE_MASK;
-            uint32_t mapped_base = (iter->last_off - 1) & ~TARGET_PAGE_MASK;
+                (uintptr_t)iter->map & ~qemu_target_page_mask();
+            uint32_t off_base = iter->off & ~qemu_target_page_mask();
+            uint32_t mapped_base = (iter->last_off - 1) & ~qemu_target_page_mask();
             if (off_base != mapped_base || off_in_page < map_start_in_page) {
                 gpadl_iter_cache_unmap(iter);
                 iter->map = NULL;
@@ -368,10 +368,10 @@ static ssize_t gpadl_iter_io(GpadlIter *iter, void *buf, uint32_t len)
         if (!iter->map) {
             dma_addr_t maddr;
             dma_addr_t mlen = pgleft;
-            uint32_t idx = iter->off >> TARGET_PAGE_BITS;
+            uint32_t idx = iter->off >> qemu_target_page_bits();
             assert(idx < iter->gpadl->num_gfns);
 
-            maddr = (iter->gpadl->gfns[idx] << TARGET_PAGE_BITS) | off_in_page;
+            maddr = (iter->gpadl->gfns[idx] << qemu_target_page_bits()) | off_in_page;
 
             iter->map = dma_memory_map(iter->as, maddr, &mlen, iter->dir,
                                        MEMTXATTRS_UNSPECIFIED);
@@ -382,7 +382,7 @@ static ssize_t gpadl_iter_io(GpadlIter *iter, void *buf, uint32_t len)
             }
         }
 
-        p = (void *)(uintptr_t)(((uintptr_t)iter->map & TARGET_PAGE_MASK) |
+        p = (void *)(uintptr_t)(((uintptr_t)iter->map & qemu_target_page_mask()) |
                 off_in_page);
         if (iter->dir == DMA_DIRECTION_FROM_DEVICE) {
             memcpy(p, buf, cplen);
@@ -591,9 +591,9 @@ static void ringbuf_init_common(VMBusRingBufCommon *ringbuf, VMBusGpadl *gpadl,
                                 uint32_t begin, uint32_t end)
 {
     ringbuf->as = as;
-    ringbuf->rb_addr = gpadl->gfns[begin] << TARGET_PAGE_BITS;
-    ringbuf->base = (begin + 1) << TARGET_PAGE_BITS;
-    ringbuf->len = (end - begin - 1) << TARGET_PAGE_BITS;
+    ringbuf->rb_addr = gpadl->gfns[begin] << qemu_target_page_bits();
+    ringbuf->base = (begin + 1) << qemu_target_page_bits();
+    ringbuf->len = (end - begin - 1) << qemu_target_page_bits();
     gpadl_iter_init(&ringbuf->iter, gpadl, as, dir);
 }
 
@@ -734,7 +734,7 @@ static int vmbus_channel_notify_guest(VMBusChannel *chan)
     unsigned long *int_map, mask;
     unsigned idx;
     hwaddr addr = chan->vmbus->int_page_gpa;
-    hwaddr len = TARGET_PAGE_SIZE / 2, dirty = 0;
+    hwaddr len = qemu_target_page_size() / 2, dirty = 0;
 
     trace_vmbus_channel_notify_guest(chan->id);
 
@@ -743,7 +743,7 @@ static int vmbus_channel_notify_guest(VMBusChannel *chan)
     }
 
     int_map = cpu_physical_memory_map(addr, &len, 1);
-    if (len != TARGET_PAGE_SIZE / 2) {
+    if (len != qemu_target_page_size() / 2) {
         res = -ENXIO;
         goto unmap;
     }
@@ -1038,14 +1038,14 @@ static int sgl_from_gpa_ranges(QEMUSGList *sgl, VMBusDevice *dev,
         }
         len -= sizeof(range);
 
-        if (range.byte_offset & TARGET_PAGE_MASK) {
+        if (range.byte_offset & qemu_target_page_mask()) {
             goto eio;
         }
 
         for (; range.byte_count; range.byte_offset = 0) {
             uint64_t paddr;
             uint32_t plen = MIN(range.byte_count,
-                                TARGET_PAGE_SIZE - range.byte_offset);
+                                qemu_target_page_size() - range.byte_offset);
 
             if (len < sizeof(uint64_t)) {
                 goto eio;
@@ -1055,7 +1055,7 @@ static int sgl_from_gpa_ranges(QEMUSGList *sgl, VMBusDevice *dev,
                 goto err;
             }
             len -= sizeof(uint64_t);
-            paddr <<= TARGET_PAGE_BITS;
+            paddr <<= qemu_target_page_bits();
             paddr |= range.byte_offset;
             range.byte_count -= plen;
 
@@ -1804,7 +1804,7 @@ static void handle_gpadl_header(VMBus *vmbus, vmbus_message_gpadl_header *msg,
      * anything else and simplify things greatly.
      */
     if (msg->rangecount != 1 || msg->range[0].byte_offset ||
-        (msg->range[0].byte_count != (num_gfns << TARGET_PAGE_BITS))) {
+        (msg->range[0].byte_count != (num_gfns << qemu_target_page_bits()))) {
         return;
     }
 
@@ -2240,10 +2240,10 @@ static void vmbus_signal_event(EventNotifier *e)
         return;
     }
 
-    addr = vmbus->int_page_gpa + TARGET_PAGE_SIZE / 2;
-    len = TARGET_PAGE_SIZE / 2;
+    addr = vmbus->int_page_gpa + qemu_target_page_size() / 2;
+    len = qemu_target_page_size() / 2;
     int_map = cpu_physical_memory_map(addr, &len, 1);
-    if (len != TARGET_PAGE_SIZE / 2) {
+    if (len != qemu_target_page_size() / 2) {
         goto unmap;
     }
 
diff --git a/hw/hyperv/meson.build b/hw/hyperv/meson.build
index f4aa0a5ada9..c855fdcf04c 100644
--- a/hw/hyperv/meson.build
+++ b/hw/hyperv/meson.build
@@ -1,6 +1,6 @@
 specific_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'))
 specific_ss.add(when: 'CONFIG_HYPERV_TESTDEV', if_true: files('hyperv_testdev.c'))
-specific_ss.add(when: 'CONFIG_VMBUS', if_true: files('vmbus.c'))
+system_ss.add(when: 'CONFIG_VMBUS', if_true: files('vmbus.c'))
 specific_ss.add(when: 'CONFIG_SYNDBG', if_true: files('syndbg.c'))
 specific_ss.add(when: 'CONFIG_HV_BALLOON', if_true: files('hv-balloon.c', 'hv-balloon-page_range_tree.c', 'hv-balloon-our_range_memslots.c'))
 system_ss.add(when: 'CONFIG_HV_BALLOON', if_false: files('hv-balloon-stub.c'))
-- 
2.39.5


