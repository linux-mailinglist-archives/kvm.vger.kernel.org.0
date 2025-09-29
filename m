Return-Path: <kvm+bounces-58994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AD0B6BA9D62
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 17:46:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7B333B2E53
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 15:45:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 013D530ACFB;
	Mon, 29 Sep 2025 15:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hrrMySJj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517D72FBE1E
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 15:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759160754; cv=none; b=RwynOlqW0/n71ywFep78n5eCgs53A2ng+TPgbi1lIxLI7tyBqnh/t3WDAgOPUr+s7qPUQQF9TAhUprrwbNpEGVCYfDBntpbWXaN/zZziwixY7sThNWt3zJzbYsLYfk5pYu/WnZKn+lNBOyhNTUjYU5kN8IsBxcC2gsjuoyvPFcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759160754; c=relaxed/simple;
	bh=gOSqfETftSrkfy+wiiVmCvNRS7HVyosI49GKjhJ3OjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PpxScdKHcyq1CYQrE1+bRBg+YYG3F7d8Rfzft+Vor9NgBhDOhuWaFQ84hvX3ExmizapC7D62CLlAKNivY+mijNpeEgkmFKt2dSNkluUXYYdIT9rzHiT0PKGptf/WC99Ttzq+Fl8RepwO6uDtc26WN0XEb6eNRg7tYOTebWbxpZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hrrMySJj; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-46e326e4e99so25156075e9.1
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 08:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759160750; x=1759765550; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=skSiBrYgmNb3KW5VmEKPkKDMJ6jv8aZ6s7jfJf5MQP4=;
        b=hrrMySJjN8Q2gGzaQ61bF2hISg+66m0SENl8gaZGKwdoZK9tJK43CU4mZYzX4F1a3D
         D1DUzhvgKxcImqvIt81Z/0J+5bFSlmrp8y1Unxx+Jw+VsIYojcWr09oeeMo5GqeVYfa2
         eo8/smncikCZOdpttn+YnBPxSJrmkPVowKPARmz65869ukaigjv9LVqB8/tD+jayjTyF
         TlhFMpq38afLxLUThg+h7QL2eQJyDknhPWMBgXMkQC4q9liqQNw85QWsuL1AEO4LY51k
         Kts8WrdxE3W8azNr6tzuBA24DBs+GrWYIX6w8QrGjPf/ghHRD8AIiAVTsQ/6r+OrIaPc
         MBoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759160750; x=1759765550;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=skSiBrYgmNb3KW5VmEKPkKDMJ6jv8aZ6s7jfJf5MQP4=;
        b=skVC/Qm5r0e+OV1ve5uF1yMyixdwaXBDamIBuWCosqI7Iiu8RDYHauZiPEur2cZoS3
         zkBfCeFCnKZfeZVrrpNJ8zfxIh4Ns7u/bQoBkH6VUraCF/sHShcb185DpehrT04a/1Ui
         zbP2tVJDOOteI0rAkOw2gMG+NeGi+UTV1tvdiBmQYEO1XK125KUBBGgQlFjrOypJvYH1
         2mZtdyCWGM8Kq+bV0sLDxmpmQLhUnMdEL5yUKLmfWL5e2Oayed33ZSKCKGJcRWaLHlY5
         jlizxEDj4ByUPaJ3AqTuN2BI1+h3LfbZ7haRHfKnxe95pF7a7PmGd9OPjLgcqIyORs12
         itDA==
X-Forwarded-Encrypted: i=1; AJvYcCVpckDCfR8gFluPA6To0VrnqdU32mlE6FvITgn2lKevozt0oXRtPPzRbCQKu4EYWbBQ+lk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/UTfSD0afva1PD6nxrMmTLgdQTvOebzFF8Ssw1QprHi6fMBx8
	1Gj1Od6QJQ6adWeGUcDeSq05FzxK98Bny+yV+z/jYID9zozFsrTJFx3wwNrwbxD79ZY=
X-Gm-Gg: ASbGncugDu21XDTOGYF+ZHxlk8+DsObqEtjBBHmkpVPv6M85FugbAVfG9yDmR6dADKY
	SYzpwq5NE2InRoKZCSEBcKCRYL4fPrW1wRQ+MYlU3tTNwyOWX3hhblXLfhgVetvxZSgrwf5o/Dx
	aXxUtlNMvkhq1MR6SK9yiwBpfC1sIf/LBY1kCHK7l0VY6Hxf0sRatG4QbzpWhyaITUfZ1bVRc0J
	s7NhZ+/YtR1Ub6YleLJkhpz057HGG0Ot/SCr9QGGi6eKlw+6lYD3D9s7cn7kv8mGcYAUOuRHbWA
	en0BwNt0WGB5hD5d6J4CZPeBGA7rkj4IzmdK/546qGBaDey6rftt3QeojHe1CKPXeQP/0RzAxQB
	6QblmDbS7dRMlZsaXm/Il8lFDaKqPWK3VI9UKfE2UigzBF4VSueYkwibEt8oES2iCeZbDtHUUH4
	GM0TJVc5o=
X-Google-Smtp-Source: AGHT+IGsNO4ME1VQ2l5Lp9gwMoIxExUWy6pxs/+HaIF3NAnkZSji+lWI9Q/AGB1Bpc3JW6TXnXKfoQ==
X-Received: by 2002:a05:600d:112:b0:46d:38c4:1ac9 with SMTP id 5b1f17b1804b1-46e58aac96bmr8112745e9.2.1759160750552;
        Mon, 29 Sep 2025 08:45:50 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2ab31bdesm229147985e9.11.2025.09.29.08.45.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 08:45:50 -0700 (PDT)
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
Subject: [PATCH 4/6] system/ramblock: Use ram_addr_t in ram_block_discard_guest_memfd_range
Date: Mon, 29 Sep 2025 17:45:27 +0200
Message-ID: <20250929154529.72504-5-philmd@linaro.org>
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
 system/physmem.c          | 12 ++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/system/ramblock.h b/include/system/ramblock.h
index e69af20b810..897c5333eaf 100644
--- a/include/system/ramblock.h
+++ b/include/system/ramblock.h
@@ -104,7 +104,8 @@ struct RamBlockAttributes {
 };
 
 int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length);
-int ram_block_discard_guest_memfd_range(RAMBlock *rb, uint64_t start,
+/* @offset: the offset within the RAMBlock */
+int ram_block_discard_guest_memfd_range(RAMBlock *rb, ram_addr_t offset,
                                         size_t length);
 
 RamBlockAttributes *ram_block_attributes_create(RAMBlock *ram_block);
diff --git a/system/physmem.c b/system/physmem.c
index 3766fae0aba..e2721b1902a 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -3920,7 +3920,7 @@ err:
     return ret;
 }
 
-int ram_block_discard_guest_memfd_range(RAMBlock *rb, uint64_t start,
+int ram_block_discard_guest_memfd_range(RAMBlock *rb, ram_addr_t offset,
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
-        error_report("%s: Failed to fallocate %s:%" PRIx64 " +%zx (%d)",
-                     __func__, rb->idstr, start, length, ret);
+        error_report("%s: Failed to fallocate %s:" RAM_ADDR_FMT " +%zx (%d)",
+                     __func__, rb->idstr, offset, length, ret);
     }
 #else
     ret = -ENOSYS;
-    error_report("%s: fallocate not available %s:%" PRIx64 " +%zx (%d)",
-                 __func__, rb->idstr, start, length, ret);
+    error_report("%s: fallocate not available %s:" RAM_ADDR_FMT " +%zx (%d)",
+                 __func__, rb->idstr, offset, length, ret);
 #endif
 
     return ret;
-- 
2.51.0


