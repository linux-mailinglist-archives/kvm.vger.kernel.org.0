Return-Path: <kvm+bounces-59384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AAF11BB26F0
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 05:28:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 616DD426FA0
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 03:28:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25208257827;
	Thu,  2 Oct 2025 03:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tStJG4H0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DECD1F237A
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 03:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759375720; cv=none; b=Rs8awFPvvUKqH8ZHB7owL2RE7R4KpXQYST/CQUo7MZ9pRsK4IEWeeYyQXb3rH4JV4KGckyb+D84ZhSVIvsCxVOkQainO+k4DZUlgs5hyrgA9ywoLffxI8dguaoo3LK4j6SEa7f7aLPk2s/UFtSwkDzEoDmJE7N8trX7J6edXpz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759375720; c=relaxed/simple;
	bh=safrK6vgwnXnI88auigUyKNILBlc3obGTfQqAq95EzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PF4gty61Rg0hiy1fFekucqVedWQMaweA1fDdacVOHzoEldfD9Ms2HdPy3hy3zKkZRnBUfW8Zwo9aJCvuhwEDQK3clhXCha4co+xABq5biK4cWKHnAoTqvLCGAZl6ZCQiArdtoTxVVHAcbuddJMTJMJGPi4e5i7L5udTIHFczsTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tStJG4H0; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-46e384dfde0so5022355e9.2
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 20:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759375717; x=1759980517; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F1+X2oMvazjHxrIb2bLCkH4C3BOYEho7EWsrbywbDVQ=;
        b=tStJG4H0O/Z+PiS1xvJJULu07UF+Grt+ctaw+sHJ9aqjJAPDu7uHCp+MhgcauNPBlP
         8JHq/bjyPVba6KRx4ZnDDU4kQtirV/4ziKonqrwc0SezHJ40Wx61mzsItqYkCc6QOom9
         3JpFJDT6xXA09N1QCHyy6TuJOgCBKb8xn51Gy1O9cSXiO+wQPVL81wR3Ihed3xc3JHtc
         A6p6dl9WtMrI1OtGTbojBrFn95ia7qHKUkkd0acfWXE/at/0YYfAKdMA2nanKpNfgu0/
         pMJx4SwR4FR4galVuGb+o72LhGEFLu03ZuMnCQJywyQTOCZM8yiMICJ9QJIlWYw5oBjK
         oOTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759375717; x=1759980517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F1+X2oMvazjHxrIb2bLCkH4C3BOYEho7EWsrbywbDVQ=;
        b=wUhvURnvaY5Au15SPDZsWMGicDsVGrZX0yRzj0aMo9SDSG9JEa8cZYIQte/HfzE4Rc
         lxImHmYUyrSdAq7X3pLxTMoKFJDTLiFLx1td/RrLmVtegrjHHlNFs0ytwHs2BIUG+uSu
         W+OImAVPprYx/UZNVzPqgwdo0wbXE994cbf1DJE94yXN6hbTHhUXiC8RC6Tx+BETE4B7
         9tYFuRIEkReb4BZlnEeCiXtaPA7Rb4aLEiZkgiLfm4vwIOI5uVEq+zQaNEqUrcqXx94A
         Kgg8arvPcRTAxhiuRD8deuOD/uR/nB7QjItgE2p/j4RkUdog4E3qZ2jP9J3ibzTzx4SK
         2gbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWUKcBjgMHDTwmXvAjSG4YJ3MF1mv1OrrAi8IMMEwlP4cylvrDEDer4vDqw5VFbGumNTJc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeBglSodjKueQW5EB3YmKK+nay1geOWmjpqTjKWUkUeIMnu+ug
	ryac8lJJcrXWv5xYpw4kunOGtwcAVL7aMc7U0o3d8WbN9oN4fenD6hP+kA9AX98NVfk=
X-Gm-Gg: ASbGncuHucbO18gmVEJjZUC8ZWU0QPMjTf6ccvlznd/cPBbj1mYqwe6Dq+CaNtPQCn7
	ZStVIPnubJ1hTbvy1wHPLESyCrlY43fPqnNFfGCIQlNI1vCLAoSUbdY+AijVqgIu9i7yA6dzVsJ
	ffS5TNDYzXH1ff/cHCgueaMFtqoY5SVhbMQsketrAVU2MiGq/twxcgiuSehrPXnFUo54zWNXAH2
	gUhXml7FvYYprb1ecjikOWZ/2GuK6J5ddcNDo19iQBBWOCYZXIFZBJKugwFeNARWfJpXHJWgE0c
	N7+amTqJMAV5fBaVeBt4mDD3Q1n1ec9e+WyJeqanieWrXX1wB6YHfYBrNsbRidPC3xL3q9y2jqg
	GXihT3v6dbOBMvRnLpUcuxosJlt//TBe9xm55Wl8SHCVGfUYdVrSX92CVbAC1UTa+KBYImBh4Kf
	I8X3EKk6m4vxhbLEVZ5cc7vYYHzXYiRw==
X-Google-Smtp-Source: AGHT+IE/AVOVePpbh0V8yDK4JSymMcusLo1d0mmVuJJMEk6+ac5d1uzn4XJ8733wdbLt2qpqBFX8SA==
X-Received: by 2002:a05:600c:1f86:b0:45f:28d2:bd38 with SMTP id 5b1f17b1804b1-46e612bef22mr40680515e9.18.1759375716629;
        Wed, 01 Oct 2025 20:28:36 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e61a029a0sm61512175e9.13.2025.10.01.20.28.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 20:28:36 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: David Hildenbrand <david@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Fabiano Rosas <farosas@suse.de>
Subject: [PATCH v3 4/5] system/ramblock: Rename @start -> @offset in ram_block_discard_range()
Date: Thu,  2 Oct 2025 05:28:11 +0200
Message-ID: <20251002032812.26069-5-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251002032812.26069-1-philmd@linaro.org>
References: <20251002032812.26069-1-philmd@linaro.org>
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
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/ramblock.h |  6 ++++--
 system/physmem.c          | 28 ++++++++++++++--------------
 2 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/include/system/ramblock.h b/include/system/ramblock.h
index 530c5a2e4c2..85cceff6bce 100644
--- a/include/system/ramblock.h
+++ b/include/system/ramblock.h
@@ -103,8 +103,10 @@ struct RamBlockAttributes {
     QLIST_HEAD(, RamDiscardListener) rdl_list;
 };
 
-int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length);
-int ram_block_discard_guest_memfd_range(RAMBlock *rb, uint64_t start,
+/* @offset: the offset within the RAMBlock */
+int ram_block_discard_range(RAMBlock *rb, uint64_t offset, size_t length);
+/* @offset: the offset within the RAMBlock */
+int ram_block_discard_guest_memfd_range(RAMBlock *rb, uint64_t offset,
                                         size_t length);
 
 RamBlockAttributes *ram_block_attributes_create(RAMBlock *ram_block);
diff --git a/system/physmem.c b/system/physmem.c
index 3766fae0aba..1a74e48157b 100644
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
@@ -3913,14 +3913,14 @@ int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
                                       need_madvise, need_fallocate, ret);
     } else {
         error_report("%s: Overrun block '%s' (%" PRIu64 "/%zx/" RAM_ADDR_FMT")",
-                     __func__, rb->idstr, start, length, rb->max_length);
+                     __func__, rb->idstr, offset, length, rb->max_length);
     }
 
 err:
     return ret;
 }
 
-int ram_block_discard_guest_memfd_range(RAMBlock *rb, uint64_t start,
+int ram_block_discard_guest_memfd_range(RAMBlock *rb, uint64_t offset,
                                         size_t length)
 {
     int ret = -1;
@@ -3928,17 +3928,17 @@ int ram_block_discard_guest_memfd_range(RAMBlock *rb, uint64_t start,
 #ifdef CONFIG_FALLOCATE_PUNCH_HOLE
     /* ignore fd_offset with guest_memfd */
     ret = fallocate(rb->guest_memfd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
-                    start, length);
+                    offset, length);
 
     if (ret) {
         ret = -errno;
         error_report("%s: Failed to fallocate %s:%" PRIx64 " +%zx (%d)",
-                     __func__, rb->idstr, start, length, ret);
+                     __func__, rb->idstr, offset, length, ret);
     }
 #else
     ret = -ENOSYS;
     error_report("%s: fallocate not available %s:%" PRIx64 " +%zx (%d)",
-                 __func__, rb->idstr, start, length, ret);
+                 __func__, rb->idstr, offset, length, ret);
 #endif
 
     return ret;
-- 
2.51.0


