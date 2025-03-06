Return-Path: <kvm+bounces-40217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96845A542EB
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 07:41:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 772973AEB08
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 06:41:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40A071A01B9;
	Thu,  6 Mar 2025 06:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jxu/em3H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22CB1A3166
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 06:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741243291; cv=none; b=OezlWkpGHtAdhbEhhWUctbJKuG6QKax8WOzL8Tugm2ic5djwQRk5IaXELdHXHwZBvBbhItKsrYMOSZ6Zpouqhl1d/87PtCRjrXTVrfqxYse5SWhdSeMkJByKRsh+6F6l/GlUcCKFeWkVIUFq86kGn/2XQJjPl9Ms/jJsBNMR6oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741243291; c=relaxed/simple;
	bh=N9IiMExxiXgXPoqm4k5CCKl5YvodRMWS+HiDAjO9yyI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Pj4pWaWLZva7mBUcpCAU8DX8F1NI+JXm7Z2bdE8GizPieA3txxxzMGi5DQJctbgKSI6Km3iXPOwteNYw2wVqYFBtNqVBVs7TmPkH7XPln8ML+EeMr6OJtWgMfYXiog/c4EbOlieSvPsWVv88/3G0klrDFK5D1DxUsqcLaLLISTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jxu/em3H; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-223378e2b0dso3622075ad.0
        for <kvm@vger.kernel.org>; Wed, 05 Mar 2025 22:41:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741243289; x=1741848089; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a4g6UCTPF7xt6XmRoqdLfJpuJ3HLau+yVZ65YGfmCxA=;
        b=jxu/em3H5oEWQMcqZIA2daXgmxWdK5vNw5rDk9W08UY4sluL1aMqpzy+apyNwC5v0t
         sBo/ws0LF4znZghNoo5mMQbGjUwatW8Xw7RnyBzPYZfGVf4VbWWZcuBt3vV/Ymd9EyP7
         pzK8l4DnkmjVVJ+D1K2Zfzgj5BDYBIQiB8FB9J0J56iC7Iis8BXS8jZjHRo+4UueD1b1
         ZR7kgImbB+4qgqeyIzSGGA/0LacLNTmWBtooDHsDVBg410ON+iVaoNx3EYzx9u3WgXpj
         4cE+RvgxSrXXcr7OFgNg/EgxiUW3RPhk+Hs7hZKfSUXCZfL9cX7ilrQ3YW7CA0cdC6ne
         pSwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741243289; x=1741848089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a4g6UCTPF7xt6XmRoqdLfJpuJ3HLau+yVZ65YGfmCxA=;
        b=mw8DV2AFnfxUwN0uNX9Aec5OtknNz1A8Bx0EzbLfZVuLalXVofVZC0FuUtr7gjgRqH
         rJ9/lch+U1fOVxNcfgwSPcb3SM/1AgT09XG+46FxU76Bs/wuYETpO7jsYIS82lydU76L
         mSdswJDe5qEiexwZIXTAZMLWR9kD4tc9xT6veL8rHADuLUJen+eRjAcSr79YEh7vkk0R
         KUVChdjH8UBEPswV/F0KSI6rIqNgl1SVbnz2bCs5mi43YdoWGnDM1/sCWnWGabzd4c4E
         jzi22gMkefD/aFnhZyqBRSoREbaLAOBhx3j+uF92pbRHGeCLBH7WYAHEiKE4oMQn5WXz
         wC1g==
X-Gm-Message-State: AOJu0YwdfFjzpmGELUmk6T5OGVCDTxlQGLWDD6tYgyO6aBCxZ4+iqJtL
	MhBjzV7uKFKB0swO2birJR6pguJNAmI+J2WVuX+NUSeiVLF7FoXeZsUhroP3EnamQt9eroIstJ9
	Y
X-Gm-Gg: ASbGncuQxSalOpS0PyR6+e+YpjH8a14IfaIrs+ZIFV+ckqEuZCLPs75tpjaBBo2pMwh
	Z4h1SzIwE1uxIQnTcJXXxKNKc/gwyWNRCmSmc/BbUR78SZrY4+mecCqhe56rSR8m9FYErbCIkGD
	S7KCVPvWcmVd2NxWpysgiePe5e4MBFG4XDVvsdQHuIm2f3GcML5yXl8uM3QPsuPVk8+GPtn7h85
	rqXzQ2NhrzARr2R2J3CMnWgL91MRXA8OV49GQqSGdoMepj9sQQAH/wGeNUj9kzY6NHHQGMMxCQI
	fKPRwmOmq1e5CwW4umRLkqGcna9ZgR7IQrua7MXSshFg
X-Google-Smtp-Source: AGHT+IGfAiV2y2sV/+twWgPqy3JAP1CBHCKmg3Dbm9uDmHILN+zHI1fLgqUtIpvFbzvqC1JioNGrKw==
X-Received: by 2002:a17:903:3ba5:b0:21f:ba77:c45e with SMTP id d9443c01a7336-223f1d81964mr88722495ad.45.1741243288953;
        Wed, 05 Mar 2025 22:41:28 -0800 (PST)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22410a91cffsm4769355ad.174.2025.03.05.22.41.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 22:41:28 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	philmd@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	pierrick.bouvier@linaro.org,
	manos.pitsidianakis@linaro.org,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	richard.henderson@linaro.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	alex.bennee@linaro.org
Subject: [PATCH 3/7] hw/hyperv/vmbus: common compilation unit
Date: Wed,  5 Mar 2025 22:41:14 -0800
Message-Id: <20250306064118.3879213-4-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250306064118.3879213-1-pierrick.bouvier@linaro.org>
References: <20250306064118.3879213-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace TARGET_PAGE.* by runtime calls.

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


