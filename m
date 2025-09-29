Return-Path: <kvm+bounces-58995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F5F0BA9D5F
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 17:46:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E51671C3B68
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 15:46:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08FF030B506;
	Mon, 29 Sep 2025 15:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AUTHIvcf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3663030C0F6
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 15:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759160759; cv=none; b=VTHdhZwN5ZG06X9TkzT+9xmuhLAO9V5Xkxis9DLRRR6dNq5scQqBcQMu0tHP4Xa4b2kGo368xPWtXo4OOmeoINDr2zZfhqAYXV6mRNZ1NHO6LT1Pew7yY1YBg8lsryG5HdhPo4CNMelnuIfvvpO89OYUtgBo3/htQ5EiPx4FmzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759160759; c=relaxed/simple;
	bh=FCOeAOPvC/r5i6Vi9ZY21XprdewOPfZk7m7VixVms6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NS41QScHWVlMqTMadToOjMxjszTnO4ouNT2brrWOVdjW0h0rDr0P21pdinSWZGmuGgAUrvSftHPquXDypYASjOfworXYVDSD4ESuNVuUG02GiH0HdE4FiCGBJaE4pul0ueSSMXC7konTOXU4tmgst6dRhLGUShB081iyfufRjls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AUTHIvcf; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-46e4f2696bdso21878585e9.0
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 08:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759160755; x=1759765555; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=txLBq2hBcl/jIiqR1VpYD85vDq9mb0UsYkys8wX8u/M=;
        b=AUTHIvcf49xFYrOlTqCEMo5OG7YKNbY0aVzl16J5KNM+rXQ/fqiOI+04VrY4Ub9pKm
         V/8vK3RJ+8ZIR/5YQWf+CFfIFc2KDUC9fqARumxOyWAKpgmSlQwfAI3D4K+ou6tBsNBo
         nsPbHmXyfSjw7+3ZjAD2OgragFIhH1QkqEIbmHHGhsnizVc44oHcRxFuqdr/46r5n4m6
         aK0NVo28SAm7uoGP+yHh5hFBMmHJMn2jcezIhzyTns++yAaeqaf6JYTgUJOCMmYSefUl
         KOiF8My0hvaOfZA5aKR3AoOk+1rmX7RnmTH1vC5Tc1ACEQkePwW8xiUScTgGxFnvUBD4
         syow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759160755; x=1759765555;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=txLBq2hBcl/jIiqR1VpYD85vDq9mb0UsYkys8wX8u/M=;
        b=T+NRZYv9l6GNvl5+GJuA2h2p7IAzkLvbydWDI77APJZVmFWWydK5cptaxLhz626lOz
         JOK9QhZEyfMnzr2CIDkDuVMSX3ibsd37M4dd0wpiT/QnSyINAiG7f0eRts59cagLm3q0
         mX/MoIXTKYYjyJV51PEoak5K1lFFZYpmFz/uAm4qHT4cHTRaJuHF9nSUE+RXfSpNFzMU
         F01X7vFC5L2hLpB6k5MDNYQgGe4IZLIZli/cJwWn456gHBi9O7gZc5EMOgQkx2bu0OrT
         h1kRkwEdDJG6fZdUOV4qgaKl4Gbu4X3wpAer6H4UJTP0qzJgVgRowa3mNs2fDYLben5g
         FemQ==
X-Forwarded-Encrypted: i=1; AJvYcCXSjrQkNFjEbhhO1c4Br8MsEK9050BzhDgrp5gjPGF5zX55yl0VohsJC8CbFuZaBVdaWoE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yydhe+0beDjxJmIuSp2YoLa8Hvc0LefEXathosrc5xXpKV5gOB1
	GeUlD5tsinH6dQROxsPJxRhtGeI4thIQwbP3xNBo/lKtcvqfiEfysG49k9bEytF8jQU=
X-Gm-Gg: ASbGncvR+EBBylXNm6/aw+2s16wSPo633rYNNeuo1jhq++geRMxoVPqgGS/cD13jdrR
	kRkDUO/RKf6wTg2HcitgVBABYwoVHZEsP+IlNDoKYN9xjSbBh1rqu8kCVClsc0aNvMP+CNN07pa
	HWVkahG3jI1e6kJgU4zl4LNTi3MkycNr56AhI46g3O8c5dCPYAD4glIBvDfCIVCLcadySSH3/NH
	enaHolXdYX6DmNP9wGQLTugJe+PAQ1p9NNyqKVN0DlQXp0QIcmQko3Ij/HSvWKZYKR5jixhaIiH
	MSeBG/1QG8pm0k+jHRbLWoHevlT8NtiUB40TW8pG5fKIkMJBqpNLRPHhjZnFTqmHANOOuWrihcE
	VotSULV4k5ER+xVEO85sNIFTU54KKIg7ZaEmedAt0tARIiwer7UH7FrypYxwxUYqWX56Lf9wWf8
	KFjOkQrWk=
X-Google-Smtp-Source: AGHT+IGTzp+BirKcRPCXo+kANtj3p1s1iIIjZmLqbDvTsgjpRSs7dA5CM6VwfzYsQdra8DfpYPvayw==
X-Received: by 2002:a05:6000:268a:b0:3e9:b7a5:5dc9 with SMTP id ffacd0b85a97d-40e479258cfmr15786461f8f.23.1759160755369;
        Mon, 29 Sep 2025 08:45:55 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb72facf9sm19283036f8f.13.2025.09.29.08.45.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 08:45:54 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Fabiano Rosas <farosas@suse.de>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Peter Xu <peterx@redhat.com>
Subject: [PATCH 5/6] system/ramblock: Use ram_addr_t in ram_block_discard_range()
Date: Mon, 29 Sep 2025 17:45:28 +0200
Message-ID: <20250929154529.72504-6-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250929154529.72504-1-philmd@linaro.org>
References: <20250929154529.72504-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Rename @start as @offset. Since it express an offset within a
RAMBlock, use the ram_addr_t type to make emphasis on the QEMU
intermediate address space represented.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/ramblock.h |  3 ++-
 system/physmem.c          | 33 ++++++++++++++++++---------------
 2 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/include/system/ramblock.h b/include/system/ramblock.h
index 897c5333eaf..57c00e42ca6 100644
--- a/include/system/ramblock.h
+++ b/include/system/ramblock.h
@@ -103,7 +103,8 @@ struct RamBlockAttributes {
     QLIST_HEAD(, RamDiscardListener) rdl_list;
 };
 
-int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length);
+/* @offset: the offset within the RAMBlock */
+int ram_block_discard_range(RAMBlock *rb, ram_addr_t offset, size_t length);
 /* @offset: the offset within the RAMBlock */
 int ram_block_discard_guest_memfd_range(RAMBlock *rb, ram_addr_t offset,
                                         size_t length);
diff --git a/system/physmem.c b/system/physmem.c
index e2721b1902a..bb744f0758e 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -3797,18 +3797,18 @@ int qemu_ram_foreach_block(RAMBlockIterFunc func, void *opaque)
 }
 
 /*
- * Unmap pages of memory from start to start+length such that
+ * Unmap pages of memory from offset to offset+length such that
  * they a) read as 0, b) Trigger whatever fault mechanism
  * the OS provides for postcopy.
  * The pages must be unmapped by the end of the function.
  * Returns: 0 on success, none-0 on failure
  *
  */
-int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
+int ram_block_discard_range(RAMBlock *rb, ram_addr_t offset, size_t length)
 {
     int ret = -1;
 
-    uint8_t *host_startaddr = rb->host + start;
+    uint8_t *host_startaddr = rb->host + offset;
 
     if (!QEMU_PTR_IS_ALIGNED(host_startaddr, rb->page_size)) {
         error_report("%s: Unaligned start address: %p",
@@ -3816,7 +3816,7 @@ int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
         goto err;
     }
 
-    if ((start + length) <= rb->max_length) {
+    if ((offset + length) <= rb->max_length) {
         bool need_madvise, need_fallocate;
         if (!QEMU_IS_ALIGNED(length, rb->page_size)) {
             error_report("%s: Unaligned length: %zx", __func__, length);
@@ -3867,19 +3867,20 @@ int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
             }
 
             ret = fallocate(rb->fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
-                            start + rb->fd_offset, length);
+                            offset + rb->fd_offset, length);
             if (ret) {
                 ret = -errno;
-                error_report("%s: Failed to fallocate %s:%" PRIx64 "+%" PRIx64
-                             " +%zx (%d)", __func__, rb->idstr, start,
+                error_report("%s: Failed to fallocate %s:"
+                             RAM_ADDR_FMT "+%" PRIx64 " +%zx (%d)",
+                             __func__, rb->idstr, offset,
                              rb->fd_offset, length, ret);
                 goto err;
             }
 #else
             ret = -ENOSYS;
             error_report("%s: fallocate not available/file"
-                         "%s:%" PRIx64 "+%" PRIx64 " +%zx (%d)", __func__,
-                         rb->idstr, start, rb->fd_offset, length, ret);
+                         "%s:" RAM_ADDR_FMT "+%" PRIx64 " +%zx (%d)", __func__,
+                         rb->idstr, offset, rb->fd_offset, length, ret);
             goto err;
 #endif
         }
@@ -3898,22 +3899,24 @@ int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
             if (ret) {
                 ret = -errno;
                 error_report("%s: Failed to discard range "
-                             "%s:%" PRIx64 " +%zx (%d)",
-                             __func__, rb->idstr, start, length, ret);
+                             "%s:" RAM_ADDR_FMT " +%zx (%d)",
+                             __func__, rb->idstr, offset, length, ret);
                 goto err;
             }
 #else
             ret = -ENOSYS;
-            error_report("%s: MADVISE not available %s:%" PRIx64 " +%zx (%d)",
-                         __func__, rb->idstr, start, length, ret);
+            error_report("%s: MADVISE not available %s:"
+                         RAM_ADDR_FMT " +%zx (%d)",
+                         __func__, rb->idstr, offset, length, ret);
             goto err;
 #endif
         }
         trace_ram_block_discard_range(rb->idstr, host_startaddr, length,
                                       need_madvise, need_fallocate, ret);
     } else {
-        error_report("%s: Overrun block '%s' (%" PRIu64 "/%zx/" RAM_ADDR_FMT")",
-                     __func__, rb->idstr, start, length, rb->max_length);
+        error_report("%s: Overrun block '%s' "
+                     "(" RAM_ADDR_FMT "/%zx/" RAM_ADDR_FMT")",
+                     __func__, rb->idstr, offset, length, rb->max_length);
     }
 
 err:
-- 
2.51.0


