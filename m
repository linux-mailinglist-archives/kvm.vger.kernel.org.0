Return-Path: <kvm+bounces-59334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5114DBB1493
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 18:46:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04EA12A2057
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 16:46:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21EFE2C029B;
	Wed,  1 Oct 2025 16:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kPhRvUDK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900A6299AAF
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 16:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759337131; cv=none; b=WicgSo7q2LZuM3Q2kW28BemQKwQDFL2kt5pBGJjqcfYHxpTMY75Ps8aS4HJypPY0BEkMDpld9T2MlGCqcW073RVNYqAL2bMmIaX3Mi6ipFM9k7tLtcX2itUGUyO1m0gzrQhqQG+4Y9qE6KtoYI3BR+oeKujGy5M1SqpyVkx6Mg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759337131; c=relaxed/simple;
	bh=xehy+/JTTedrlPJoRZSJE92yDecmlnv5Vpc68jLWdxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TuQbXServZ5mydULwTN02EIuf2MRj/6IF0kVViWjPOGD67OGbRGBa5pPQVCxlvW0eVW7QYJ7JLL+lUsh4OmfMZ6MZ2j0J+u/MKsG5qBk4f5+2gbizKtjEO6cddBcBsPkBtANy3aD+sSbNzsLBPwLAzBA+ecjPAbSQWhuE6A6OGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kPhRvUDK; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-46e2e6a708fso203135e9.0
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 09:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759337128; x=1759941928; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VL++psIcTnezWEV7BWLGf1XEHbU+wiOL+n3sKTSCz9o=;
        b=kPhRvUDKLTmvG223Ggz0ftkLB9NuXfq3G6Z0DHbyw97EAdDk7aHl6Y7qdB7dLJaXx8
         V8PUsYFue6j0DZu8wG+hg2Mdwf1BedEOKB3V/DbvviW3niqGhVUm05s46zvx8/Ox5T1X
         UyR7ENZZx/fkfdZ/4ouVqCQCPXnR4jjy+0IKUjoMeSC/hH1DVTQwe8sC/ShJe2E3fYcp
         771SUtiRlKF6+hBjn6x4+eTfNOBo456gKqJzH0IWMvh3S7AjyNhs/Sweegg052+BeM3E
         v5Fc/4Cj3ySb1Q/XgQZPC5t/20cVottXR+eTZsrOHj85mms6lossXFhq8DIj3osLiree
         HdpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759337128; x=1759941928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VL++psIcTnezWEV7BWLGf1XEHbU+wiOL+n3sKTSCz9o=;
        b=jOFH7WIwfFih8FAtpznoIrNK0uFkob63OGlc6RVrovr1W4Q9wSGo6FosupahKBWP0x
         crLoHLQ+O25PGfgsHZb+thPcPvEoMoHKKxnn/krlQbyNqdjrsM9+h67zRtr9bZpzxWvJ
         cu35neyI8y6CBGFJpBLI2Ik8TRnhy5Fi3K4sEHBHAlYHwGc+VmE8QGSaknVwRcukOgxk
         N4O7CQ7lRrAu4t384TENY+h7LhDyTSIEE/xuomK1E0s2aV6oov0UD2JnOUuioi/xcvlt
         UngnYfsausZVwTT1t2ADBBHlKiVD3G77WSDgHKJQ4hpkONnH5XSUdEIySf09A3FfFhid
         uP6w==
X-Forwarded-Encrypted: i=1; AJvYcCVb+C1P48r9VGYtbnixrEtGtbQmnZjQBkLjwoHIoO54tp6qrW/LOKIeWXLgGBq1Yy1J8/k=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKiP24LFTnAYuREeTwD3oGYOWrg7rrZiDBK3jV4VKRC8eMjeaJ
	Ncd32QUwfuTiZotODNJKAPnBKmhxaCWaVA1oHWue9DVjojOqcu0mwGCkT53BFpANWKU=
X-Gm-Gg: ASbGncuKXu0We/NxgZDEf7oSBEn7crJtTNnIHaWnQXbNdY3kWIQXVehQGvR2mB91tW2
	C9Twr7qRiV6zEdeBSkdjejjpuiacRbrUeMAlH+ecv3J2wnVbHV2J/OxmtSTqPgtPU3H32RBruBg
	cIHvVroiLwXnT1lzK60fbfwdzDjQVjL8iPzawHTklVozCX6kfmQbJxdVfQzWJ1475Od+V21c4Si
	DPt6/R2m/8Aa2w0xKiM3WfMMf+VMEYfuRAcH6uyI9RjszEXsvscYtdERjtCV9tLDgmQ1JQrbMWD
	3BBOUkUpEmD+3vWFiSfzsrIPhuJJEYToF/Jyteq+QGTUUcooEKdrwsdhbrkzP3UL3v5JA7Mq80b
	cKvScVCIFPDoC66RyYea/RWAWH8cn4LlgC7BQHxJaV/2YJoUl1mTiBcz1+OhGlRQH2r/GqNPdvO
	FmRJp72c9SfluBwRXNqkom
X-Google-Smtp-Source: AGHT+IFDyHiEUjdTZfjcMgExdvmeutiDgwZCl97ycLZmqQrXlnCt5GjUjQ4J6/vZMMHCXF6n4mwPYQ==
X-Received: by 2002:a05:600c:4e92:b0:46e:506b:20c9 with SMTP id 5b1f17b1804b1-46e61219739mr38231995e9.12.1759337127788;
        Wed, 01 Oct 2025 09:45:27 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e619b9c88sm46228355e9.22.2025.10.01.09.45.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 09:45:27 -0700 (PDT)
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
Subject: [PATCH v2 6/6] system/ramblock: Move RAMBlock helpers out of "system/ram_addr.h"
Date: Wed,  1 Oct 2025 18:44:56 +0200
Message-ID: <20251001164456.3230-7-philmd@linaro.org>
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

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/ram_addr.h | 11 -----------
 include/system/ramblock.h | 11 +++++++++++
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
index 53c0c8c3856..6b528338efc 100644
--- a/include/system/ram_addr.h
+++ b/include/system/ram_addr.h
@@ -80,17 +80,6 @@ static inline bool clear_bmap_test_and_clear(RAMBlock *rb, uint64_t page)
     return bitmap_test_and_clear(rb->clear_bmap, page >> shift, 1);
 }
 
-static inline bool offset_in_ramblock(RAMBlock *b, ram_addr_t offset)
-{
-    return (b && b->host && offset < b->used_length) ? true : false;
-}
-
-static inline void *ramblock_ptr(RAMBlock *block, ram_addr_t offset)
-{
-    assert(offset_in_ramblock(block, offset));
-    return (char *)block->host + offset;
-}
-
 static inline unsigned long int ramblock_recv_bitmap_offset(void *host_addr,
                                                             RAMBlock *rb)
 {
diff --git a/include/system/ramblock.h b/include/system/ramblock.h
index 85cceff6bce..76694fe1b5b 100644
--- a/include/system/ramblock.h
+++ b/include/system/ramblock.h
@@ -119,4 +119,15 @@ int ram_block_attributes_state_change(RamBlockAttributes *attr, uint64_t offset,
  */
 bool ram_block_is_pmem(RAMBlock *rb);
 
+static inline bool offset_in_ramblock(RAMBlock *b, ram_addr_t offset)
+{
+    return b && b->host && (offset < b->used_length);
+}
+
+static inline void *ramblock_ptr(RAMBlock *block, ram_addr_t offset)
+{
+    assert(offset_in_ramblock(block, offset));
+    return (char *)block->host + offset;
+}
+
 #endif
-- 
2.51.0


