Return-Path: <kvm+bounces-59259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A360BAF961
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:23:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 146691C415B
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:23:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFC6A27F75F;
	Wed,  1 Oct 2025 08:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="X6YSWAYB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F238127B35D
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 08:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759306985; cv=none; b=LmSRvTP8LcNhqZDN/2ekBqnbLB4SBOGCTVnbO6JK2ZtnNj+N2i96+DV31zEUh9Hwe2V6Jhcy8nsn2rtkhYbTm/XSFRhzxuGOfiFKHtEdNmPavDvvxaBi07zq3zDhQFudgA9IWFeJg/eZBJskth34Ecgl9IKk1+GuUfraC7RMLb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759306985; c=relaxed/simple;
	bh=RxQ81+UpC5aP8wBRXLX4YjG5Y7ymsG4RUeCqmBKM5Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WoCvi+Gwz/efpTNiCErrlP0TsYszao8j536mCT78/21wnT1ASzY9y27EyayLn1tVYMKhDo6VTKnXmpDsO4UOCJbJjl2J6npxo/WLV3gLl9AZeTxcz0CzCMoKglxNXPxIyKttbuB0PDWWO1DmIEnV4Hni2UylHYuPxJNPU2XXfts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=X6YSWAYB; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-46e3a50bc0fso48299485e9.3
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 01:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759306981; x=1759911781; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HOqPvVAdOz/3hFjUsdAFf2tJOS39s9qPYq5sN81Yu4U=;
        b=X6YSWAYBa8KBkOIxKN68RZ/22vs6j/GvAGDKHcv5opxZqpUWnSRM0RUt8vgCmuLWld
         OKk0C7H7RP75r4DsqtCQoouQP22zffDlYB6uhZMfE3wJjCLzE6U47cge7hJof3+pip8z
         T17CDigZX+rA5Fq6+rUZc7/vdS21aCsjmuvQfnt6nz1QA5d6Zq+19OU9wts9VMYRqSnk
         wAOGX4chddTvWL3+RaY9Fm7u1yGFbGQ6DFqtn4KDNzmUv/9fDbY7fGpNIzx/qB0qLajc
         WAWPQzyuqPGDS9Hx8ibMOhT2ifDx0tZ5/Q5P3z6HTQanWXEUKWsd6u+BGybWnB979HmU
         1MsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759306981; x=1759911781;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HOqPvVAdOz/3hFjUsdAFf2tJOS39s9qPYq5sN81Yu4U=;
        b=f603S/GRy7479R0kUD2P8JPLUMk8XXne5CgSo6mhIeBCd/5zs9bL5EEJNCpESRLnYR
         XncmfzelBZ0vqHJunoxY6NRASGx+0yUhgyGhCz+cdPnSQpdU4yV61DeKBdPUnKNj5sim
         tatgKcE/s8E2L2esDipmbkuFzNjk7SOAKhgDSelYBLORx1D2nCAxBK5h5kbZtz2jQaVd
         vaCqtQbpLKamPZJZYzu0u/0FzSEr44oc+XRrCUpg+xmDfm1oP2dV2cocXc4qzRd03vJJ
         o5ElX3LxAy1yw8FhTcmsGoP0oht2tbMycoG6gAdavpZ9gG4JCdp1xR4IJ4ZCehWgEjST
         T+vQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpUXX+oxNiGt+wR3PEhZYC2QLrv5lL+5tvuBSSqmSZJxtaj+lV164Dco3MGJe6mvrZuWM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzruwckOxYv0EBa97Hf6dyw558GMMStFYmXFS2qR/6gBlYzP7Ml
	SY/QWPiDhLBkuv/14MOLC/1rEOUx3G8cnxcbOv5EY88kQhpWiOn46pnQY9DOYwT6ezE=
X-Gm-Gg: ASbGnct7HoMdsKCD5hapJ/RMeWJYwfRoJpaNWR0r0ho9TxRB9y4AWUF+wEh7mbCo9vf
	ZHg6lEC3NAaoNDkkHJ8SGmQIimHJt6tkWjNd0tSZDgGpsOqpC4mLWVXAtS6yiauBkuimWa8+kDQ
	5JtqEDfwVcoN18oWteh74UQ2WsCmTrK9REZ6ar7la1UPaz48gM+1dASUR24o6G1vbDqt0xuN+d3
	cRQ+7vVX6uUp+PKU2NG248sqnQ6WMMVs8bDk6mkH3JYv1XxEDSHo8PmLI66F9LL7OtN9msFUpyJ
	R60pO41V3kWcqsizgsMtf9VprQuMbQbfg7xb9Xx48IWPzwb2lRFllMYqUgrzfrWNZA6r3tnBAWf
	Q1kVTNpsLqRH5b78eerl/coOYQWIx42O2GCgZc6aYCZLyYGtAl4Tf+yqL/pbsyBTC6BxFkRowk9
	p0bvWirUWgIWL2hj5pKGFq
X-Google-Smtp-Source: AGHT+IEfJgBTWJXo/xTm4FeZN+2Or//riROV16Lac62nDF49jLqWqoeqFpWnxe66gIQZozq8Gvzg1w==
X-Received: by 2002:a05:600c:3b22:b0:46e:36fa:6b40 with SMTP id 5b1f17b1804b1-46e612baa03mr22761255e9.24.1759306981243;
        Wed, 01 Oct 2025 01:23:01 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e619b9c88sm28154505e9.22.2025.10.01.01.22.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 01:23:00 -0700 (PDT)
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
Subject: [PATCH 17/25] system/physmem: Un-inline cpu_physical_memory_set_dirty_range()
Date: Wed,  1 Oct 2025 10:21:17 +0200
Message-ID: <20251001082127.65741-18-philmd@linaro.org>
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

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/ram_addr.h | 53 ++-------------------------------------
 system/physmem.c          | 51 +++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 51 deletions(-)

diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
index 84a8b5c003d..6377dd19a2f 100644
--- a/include/system/ram_addr.h
+++ b/include/system/ram_addr.h
@@ -152,57 +152,8 @@ uint8_t cpu_physical_memory_range_includes_clean(ram_addr_t addr,
 
 void cpu_physical_memory_set_dirty_flag(ram_addr_t addr, unsigned client);
 
-static inline void cpu_physical_memory_set_dirty_range(ram_addr_t addr,
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
-    end = TARGET_PAGE_ALIGN(addr + length) >> TARGET_PAGE_BITS;
-    page = addr >> TARGET_PAGE_BITS;
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
-        xen_hvm_modified_memory(addr, length);
-    }
-}
+void cpu_physical_memory_set_dirty_range(ram_addr_t addr, ram_addr_t length,
+                                         uint8_t mask);
 
 #if !defined(_WIN32)
 
diff --git a/system/physmem.c b/system/physmem.c
index cb0efbeabb2..383aecb391f 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -1033,6 +1033,57 @@ void cpu_physical_memory_set_dirty_flag(ram_addr_t addr, unsigned client)
     set_bit_atomic(offset, blocks->blocks[idx]);
 }
 
+void cpu_physical_memory_set_dirty_range(ram_addr_t addr, ram_addr_t length,
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
+    end = TARGET_PAGE_ALIGN(addr + length) >> TARGET_PAGE_BITS;
+    page = addr >> TARGET_PAGE_BITS;
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
+        xen_hvm_modified_memory(addr, length);
+    }
+}
+
 /* Note: start and end must be within the same ram block.  */
 bool cpu_physical_memory_test_and_clear_dirty(ram_addr_t start,
                                               ram_addr_t length,
-- 
2.51.0


