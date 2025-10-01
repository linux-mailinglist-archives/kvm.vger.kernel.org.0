Return-Path: <kvm+bounces-59333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EF163BB148F
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 18:46:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA6EE3BFBB7
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 16:46:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BE002BE7BB;
	Wed,  1 Oct 2025 16:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="F6WpJe+w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E011EBA19
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 16:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759337126; cv=none; b=LdzL9jWkToiuWw5vCeJnh1hySCWjNUIgPFlTBOhPU3DEiqmLsMxxP9H3a1rThQW7J0uLynSSxwCWNGJJ09t7Y38kDqipg4iKT8S/appmSq6PWDnUL0E8wxQ1qGcXrrMWAMxfkzg4s89PM/OcJKVxr3in/7OTnStg+Pew3Q93M00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759337126; c=relaxed/simple;
	bh=CpdfdfTWojFxrHzSbDZCPxvq4pnaNJU4aesgsXRb10k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UK3Vbw+LEf4Zp5Omru4vgPzLTTwlxRCOrGnZs3Ho/iGVGgy+sINXCIITVDibtmgZka64pg7YW0BI74DQ/RFzY4p4pxjiXNIbhwjxWJoAmoUqWkaZFrvsQDphujctT8dMBjEJT4Wh6bZ3iOxRCs4JDjX5NrY+X3CE9ptLzVFankU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=F6WpJe+w; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-46e2e363118so195325e9.0
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 09:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759337123; x=1759941923; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EoqOsJi+ckKEV7B3nJVRJEwDGiQ2IoFBy8rhaUoDJkE=;
        b=F6WpJe+wuCErehuCZ/LPK6knadCvLEIqh5+bbkK8tlJeLTpoqc95rZxqx4jl9utJ6m
         YfUTpb0CTMpY9MUc/9rxQv47GFC+ZEJ6M5kIjYqrKQOC7sMwkBKM8Qr0djsM4bSfklFU
         FOxMuZU9v2c+BpOEsd+yojSfNNUwrYwsa3qhEkDkGACRAkHt2NvKgRJJ/1uFclO9vmXq
         YNBSn6uO8VzqRkbbThPN1XXYl05LpW4bVTDolo4c6tdiM7x/zRHbgFz2MVAGxhY7aWmn
         5f8L652lRSMe6/1DM54UGbRBGVCZ7EXpxjd1A9wAHwxxBb1I+5hHWb6UY6cUf3y8S7bC
         OUOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759337123; x=1759941923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EoqOsJi+ckKEV7B3nJVRJEwDGiQ2IoFBy8rhaUoDJkE=;
        b=cYjKOz0TEIVGbxiPhZYoanDetVv+MpCIsfOS+DeYpteD7Z7AlMbbH4H2L9+i3ZG2QG
         N/MDQI3IUZvQ99qGndFaghzIKhl7PqE1wsojqaSh6SuXotBYU1B7RABFH6amCH/YnhP9
         ItaKQtLrUaL9OPqIIjt1IKuDxQHRVh3JxwP257dw0LNgPv/MSEIRbNxBkUMIdiumbop5
         PUORHJ1Si61WSmJdu6c5WitvYQg+NDlAgZvnppn8DyAQTUpwd41MAJj/kPSvbxGHa5jW
         dd0cOLTMghRIr18MHnFPTznoqGidckHGcb5cEtxGD5IbDmaVVuQ2CQWP1kqBNStQ0x/V
         Smkw==
X-Forwarded-Encrypted: i=1; AJvYcCXm7rrwxvv0pqR7pw2WKsOEivM3M5hjaoJLVRL4F0/hQjRgHemh3s5wX/X3QIAyWDKczK8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxWcGQkznuFO0G9Tq5Yx2WGfxv16xnPfud4+z6BMPzTYqhBOes
	PWf8fuRb22YKRxJj8963/0xoudFVWChZMFbb/tWBcZ3aJbqK/xESiwC5xXMWSxakJMQ=
X-Gm-Gg: ASbGncsbxdrMG3kct73KmMZ/gsCVugOBEZH1fVcDR8o2b4UgsgFf7GDUYgDQMPFVhMq
	jeM8hO8vdVn7fTkfB3uCT6ETeVUo2rm8lbWrSOJtHdOKnFlgPrHJGXsQM4u5dJhrrPnsLfwzR10
	PEJ0R32Pkb8W09tYNMXYjzRbqV/Kp6MzGL6kmiBXB0FH+i+WZhu5AC2GtgbLZTXpmOTSJ+QaNxi
	FwYDVOf3vj5djGMDCRR8lBv1z/0wKhWALRZlJuLG7D7GdzS7OuYUk/f34t0YHbDSyL66rovvspH
	Em5L/hgFPmNfcttDHI+tb9FIqig2IjSvdLwj54blaza4UFfYgRjbRNfR959lHsDsmM66mrXQa1s
	O5W+DAO4E2tvcS4zLCJOEIFzuzT5TmCpYn5SBVxnH6vu+JOxjzLLLcNsRmNG8CtcN6K+n43Sq+f
	oqjFAMp7KJP6/pfsCl87L8
X-Google-Smtp-Source: AGHT+IGowKGxiVqBsAQg7gWD80SiXziNmOE2dMHVl566mX2Ha6bMcqT5kUvsyzlNkaxRS8yyhh3OPQ==
X-Received: by 2002:a05:600c:c4a4:b0:46d:996b:826f with SMTP id 5b1f17b1804b1-46e612dcfd0mr38835315e9.25.1759337122918;
        Wed, 01 Oct 2025 09:45:22 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e619a837esm44006115e9.14.2025.10.01.09.45.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 09:45:22 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Peter Xu <peterx@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 5/6] system/ramblock: Use ram_addr_t in ram_block_discard_range()
Date: Wed,  1 Oct 2025 18:44:55 +0200
Message-ID: <20251001164456.3230-6-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251001164456.3230-1-philmd@linaro.org>
References: <20251001164456.3230-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Rename @start as @offset, since it express an offset within a RAMBlock.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/ramblock.h |  3 ++-
 system/physmem.c          | 20 ++++++++++----------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/include/system/ramblock.h b/include/system/ramblock.h
index 839d8a070c1..85cceff6bce 100644
--- a/include/system/ramblock.h
+++ b/include/system/ramblock.h
@@ -103,7 +103,8 @@ struct RamBlockAttributes {
     QLIST_HEAD(, RamDiscardListener) rdl_list;
 };
 
-int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length);
+/* @offset: the offset within the RAMBlock */
+int ram_block_discard_range(RAMBlock *rb, uint64_t offset, size_t length);
 /* @offset: the offset within the RAMBlock */
 int ram_block_discard_guest_memfd_range(RAMBlock *rb, uint64_t offset,
                                         size_t length);
diff --git a/system/physmem.c b/system/physmem.c
index 2bfddb3db52..1a74e48157b 100644
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
+int ram_block_discard_range(RAMBlock *rb, uint64_t offset, size_t length)
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
@@ -3867,11 +3867,11 @@ int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
             }
 
             ret = fallocate(rb->fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
-                            start + rb->fd_offset, length);
+                            offset + rb->fd_offset, length);
             if (ret) {
                 ret = -errno;
                 error_report("%s: Failed to fallocate %s:%" PRIx64 "+%" PRIx64
-                             " +%zx (%d)", __func__, rb->idstr, start,
+                             " +%zx (%d)", __func__, rb->idstr, offset,
                              rb->fd_offset, length, ret);
                 goto err;
             }
@@ -3879,7 +3879,7 @@ int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
             ret = -ENOSYS;
             error_report("%s: fallocate not available/file"
                          "%s:%" PRIx64 "+%" PRIx64 " +%zx (%d)", __func__,
-                         rb->idstr, start, rb->fd_offset, length, ret);
+                         rb->idstr, offset, rb->fd_offset, length, ret);
             goto err;
 #endif
         }
@@ -3899,13 +3899,13 @@ int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
                 ret = -errno;
                 error_report("%s: Failed to discard range "
                              "%s:%" PRIx64 " +%zx (%d)",
-                             __func__, rb->idstr, start, length, ret);
+                             __func__, rb->idstr, offset, length, ret);
                 goto err;
             }
 #else
             ret = -ENOSYS;
             error_report("%s: MADVISE not available %s:%" PRIx64 " +%zx (%d)",
-                         __func__, rb->idstr, start, length, ret);
+                         __func__, rb->idstr, offset, length, ret);
             goto err;
 #endif
         }
@@ -3913,7 +3913,7 @@ int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
                                       need_madvise, need_fallocate, ret);
     } else {
         error_report("%s: Overrun block '%s' (%" PRIu64 "/%zx/" RAM_ADDR_FMT")",
-                     __func__, rb->idstr, start, length, rb->max_length);
+                     __func__, rb->idstr, offset, length, rb->max_length);
     }
 
 err:
-- 
2.51.0


