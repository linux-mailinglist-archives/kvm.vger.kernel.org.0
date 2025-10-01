Return-Path: <kvm+bounces-59354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 129D1BB168D
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 19:56:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E17D57A77AE
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 17:54:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5D70286889;
	Wed,  1 Oct 2025 17:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sf7NKxEM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F8825C70D
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 17:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759341353; cv=none; b=UMq9nnRVcD7vKqVKe1pZm6hy5GRJE2sFcEBVadhEhZtgm4fd32cEUcv3pvXAnqZULZqnMm4VsD40agWE6M3pfDuQ2g1DcpOafafG+V9kyRJ3hqPkXQkUNucwjy2fHA8ZifGEGbc6Epk7AhXwBFecW0x/1S16/HIZi136c3SeAJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759341353; c=relaxed/simple;
	bh=j46kwa25XAsamTIrV6WZBCtVoCI8fF76ozPJ3sXX2oE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M1tL4noq8jIvUEzuvXT5iivHp54VrfZUIQK6DngtE0TqRp0+Ap1GOkHGdgPJ1FseL/XXBGXu56eFgFC7Bk0l6IjeYfAGR8Om/zmaettLkMhBX4+nb2ijP9m/Qqb3OhF5XfaXUK1tMzUOVISRgDKMOWnpEp4FlxVxN/3D6Pv2lOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sf7NKxEM; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-46e4ad36541so1148595e9.0
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 10:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759341350; x=1759946150; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JlX52AqMxcJ9LNLdVjn3foYDM5SyvBDKXm2bxWrANs8=;
        b=sf7NKxEMQo2wLzF8CvzbNk2k5HoXzuRoDnr0Z8iIWNoSoz5yttlS5zMmP6j/S5pXET
         cQQZSv6gHXsjZoPgrcj4awEy2ldqlew48E1LP7rKQmQ/CaWpKL4hCXBhM0TCbl+iH5i9
         Wl/SVZ+FIyU8PAMAI1eT0ugT+HC/zBd0XSRaQfIg90u6NHr9/Rd2MJ33ssefYzzKqYN0
         KgkDhuLPp5mdH5f3DNriUfwF1uJA+1+kw3IbFxvBc2ESWVV9alB7pVmT466StC5WKc9K
         EoWTeiD2ifpWCvo0nav8JYfKSVmfqtR4Vm92yMYVXmha2z0+Ljr/ifMtsLS7Majd+a/e
         GBrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759341350; x=1759946150;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JlX52AqMxcJ9LNLdVjn3foYDM5SyvBDKXm2bxWrANs8=;
        b=oM3gFKIYS3EtVzRBSd6eXe9e41HJCrQgIJsSuw/YfkayYO7RSb427TkEpHyLBsmPhT
         WVbEmAS4nkgiciy+n99Y81pmeBNqzcg+qrIffTa2H+F203SG2Uk52eRUeI9VBNNVDWBA
         6DBOY6NjFTZBJCmugmZyIBDykbnsVO+07mySHtfXUJwRCJbAO2hUO/lTA6UWuTqrEOjX
         jdSiCYFaMwzqPJzIjyvEH4cUPqFSso5wXiorHnnaKYKyQ4gdd1LiQvE8jwhQMOjqpH0B
         GU01iHYAuOwmBfCH0VGxyIbDCtf82qhNulCuso5dNxMAmJ5BfqHh86gxvPBmk9Li/IA+
         hgZA==
X-Forwarded-Encrypted: i=1; AJvYcCXijTWvA2BYUZUB6SPQuqbvFNFL1CD8uJgCqhdr22AiBgsmUJQbhJ+yV6ES+A/PU880qT4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3idA5Nm8S1170oIlEmFisUc3Scc1ZDYrDvGfzJbm/yiIi6wWI
	UqSAfpQlCMn3ccgamECTmZqJ/LaupTpkHhH/b5M0NcBGTYgZtEl8iljqCJj1v1Of5K82FF9G53O
	/LBRudZSm4g==
X-Gm-Gg: ASbGncvrNsTBWJyNsUgzeIT1dxwWY73xFVR7uwMkntFtvZIPIDvRGOiH2h37Rd6QwWV
	ImARGM29P01T3zWbjPNa1YvqSTgKS3HsvATMRAW5JE9FbiVHxZ7OCQQNB/tg9WBdv1ijdppIAJk
	sZhiWYwGeZcBz6VKpPvD5Ph6UWOTRrFR4V2ESq49MlDZ9ftwdIe1yI36c+P/gAe80qwOkNiJ+wA
	owsGRVTbwvbWkdd3fY16LkQcnXkEUHWxxaiwQoRfWK//wq1gXDtnPB3WY0Jg/ngMKam+buKeZxt
	zO3WilFc4sF4JBFq+yub6EYfaRv9bP6xyI1n6KNNOExw7sUvkEav7Uq0XOSFA4SpNg3wstdoc/y
	SZIHrF+ETkSU7oqdfjGl0CAsBQYYP+ZGw11e5N/5LlxLPTlDtX9yGsFlGvEpcrAPHIsH/4EF102
	I9YmDiMYyE4U8kOvgE7ez7iGiwew==
X-Google-Smtp-Source: AGHT+IEdMJXNlprZNiwoJA4l58HVFC1XaFPZuELKIVRciAk0YuvIQOgBQYES04V4KQYXxWUhzUUTsw==
X-Received: by 2002:a05:600c:4e87:b0:46e:32a5:bd8d with SMTP id 5b1f17b1804b1-46e6126af28mr38459905e9.3.1759341350307;
        Wed, 01 Oct 2025 10:55:50 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e674b6591sm20288105e9.4.2025.10.01.10.55.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 10:55:49 -0700 (PDT)
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
Subject: [PATCH v2 11/18] system/physmem: Un-inline cpu_physical_memory_set_dirty_range()
Date: Wed,  1 Oct 2025 19:54:40 +0200
Message-ID: <20251001175448.18933-12-philmd@linaro.org>
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

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/ram_addr.h | 53 ++-------------------------------------
 system/physmem.c          | 51 +++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 51 deletions(-)

diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
index 81d26eb1492..ca5ae842442 100644
--- a/include/system/ram_addr.h
+++ b/include/system/ram_addr.h
@@ -152,57 +152,8 @@ uint8_t cpu_physical_memory_range_includes_clean(ram_addr_t start,
 
 void cpu_physical_memory_set_dirty_flag(ram_addr_t addr, unsigned client);
 
-static inline void cpu_physical_memory_set_dirty_range(ram_addr_t start,
-                                                       ram_addr_t length,
-                                                       uint8_t mask)
-{
-    DirtyMemoryBlocks *blocks[DIRTY_MEMORY_NUM];
-    unsigned long end, page;
-    unsigned long idx, offset, base;
-    int i;
-
-    if (!mask && !xen_enabled()) {
-        return;
-    }
-
-    end = TARGET_PAGE_ALIGN(start + length) >> TARGET_PAGE_BITS;
-    page = start >> TARGET_PAGE_BITS;
-
-    WITH_RCU_READ_LOCK_GUARD() {
-        for (i = 0; i < DIRTY_MEMORY_NUM; i++) {
-            blocks[i] = qatomic_rcu_read(&ram_list.dirty_memory[i]);
-        }
-
-        idx = page / DIRTY_MEMORY_BLOCK_SIZE;
-        offset = page % DIRTY_MEMORY_BLOCK_SIZE;
-        base = page - offset;
-        while (page < end) {
-            unsigned long next = MIN(end, base + DIRTY_MEMORY_BLOCK_SIZE);
-
-            if (likely(mask & (1 << DIRTY_MEMORY_MIGRATION))) {
-                bitmap_set_atomic(blocks[DIRTY_MEMORY_MIGRATION]->blocks[idx],
-                                  offset, next - page);
-            }
-            if (unlikely(mask & (1 << DIRTY_MEMORY_VGA))) {
-                bitmap_set_atomic(blocks[DIRTY_MEMORY_VGA]->blocks[idx],
-                                  offset, next - page);
-            }
-            if (unlikely(mask & (1 << DIRTY_MEMORY_CODE))) {
-                bitmap_set_atomic(blocks[DIRTY_MEMORY_CODE]->blocks[idx],
-                                  offset, next - page);
-            }
-
-            page = next;
-            idx++;
-            offset = 0;
-            base += DIRTY_MEMORY_BLOCK_SIZE;
-        }
-    }
-
-    if (xen_enabled()) {
-        xen_hvm_modified_memory(start, length);
-    }
-}
+void cpu_physical_memory_set_dirty_range(ram_addr_t start, ram_addr_t length,
+                                         uint8_t mask);
 
 #if !defined(_WIN32)
 
diff --git a/system/physmem.c b/system/physmem.c
index 96d23630a12..8e6c6dddc3c 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -1032,6 +1032,57 @@ void cpu_physical_memory_set_dirty_flag(ram_addr_t addr, unsigned client)
     set_bit_atomic(offset, blocks->blocks[idx]);
 }
 
+void cpu_physical_memory_set_dirty_range(ram_addr_t start, ram_addr_t length,
+                                         uint8_t mask)
+{
+    DirtyMemoryBlocks *blocks[DIRTY_MEMORY_NUM];
+    unsigned long end, page;
+    unsigned long idx, offset, base;
+    int i;
+
+    if (!mask && !xen_enabled()) {
+        return;
+    }
+
+    end = TARGET_PAGE_ALIGN(start + length) >> TARGET_PAGE_BITS;
+    page = start >> TARGET_PAGE_BITS;
+
+    WITH_RCU_READ_LOCK_GUARD() {
+        for (i = 0; i < DIRTY_MEMORY_NUM; i++) {
+            blocks[i] = qatomic_rcu_read(&ram_list.dirty_memory[i]);
+        }
+
+        idx = page / DIRTY_MEMORY_BLOCK_SIZE;
+        offset = page % DIRTY_MEMORY_BLOCK_SIZE;
+        base = page - offset;
+        while (page < end) {
+            unsigned long next = MIN(end, base + DIRTY_MEMORY_BLOCK_SIZE);
+
+            if (likely(mask & (1 << DIRTY_MEMORY_MIGRATION))) {
+                bitmap_set_atomic(blocks[DIRTY_MEMORY_MIGRATION]->blocks[idx],
+                                  offset, next - page);
+            }
+            if (unlikely(mask & (1 << DIRTY_MEMORY_VGA))) {
+                bitmap_set_atomic(blocks[DIRTY_MEMORY_VGA]->blocks[idx],
+                                  offset, next - page);
+            }
+            if (unlikely(mask & (1 << DIRTY_MEMORY_CODE))) {
+                bitmap_set_atomic(blocks[DIRTY_MEMORY_CODE]->blocks[idx],
+                                  offset, next - page);
+            }
+
+            page = next;
+            idx++;
+            offset = 0;
+            base += DIRTY_MEMORY_BLOCK_SIZE;
+        }
+    }
+
+    if (xen_enabled()) {
+        xen_hvm_modified_memory(start, length);
+    }
+}
+
 /* Note: start and end must be within the same ram block.  */
 bool cpu_physical_memory_test_and_clear_dirty(ram_addr_t start,
                                               ram_addr_t length,
-- 
2.51.0


