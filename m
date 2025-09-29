Return-Path: <kvm+bounces-58996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EBFDBA9D6B
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 17:46:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A81283C18D9
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 15:46:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 704A330C344;
	Mon, 29 Sep 2025 15:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pGUU6PR3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0567C30C0FE
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 15:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759160765; cv=none; b=DeVToXh+d902eRVYVXW8kYZ65O6UJIBTh6WYY4qDPSTJpBDUjeO6xeZwvTxIxTA6RN7eeX4ePRMTpCIOR0iMaOL2w/t7Rxfj2p+G58Z8DbRaSvmv8twoDnHZhYTp5UHazv4/2h3OUKRtjU5B8EujHMLjMZUNXse6AIPO4D1XCBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759160765; c=relaxed/simple;
	bh=7tZBUUihdxD+1uF0U0Q3+LjKBFItiZvE4f7poewS4do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gB2gDMrVxOzrxpNnaKrBcO/ZwliB3KVN+4yNkUm4Zkzu4J2Ze/rrj5RIb6PwJyEt3YOGmS/o6Wjqy9CMnBVkSMV0kqkCIQ2vqQmBfi9L1B/T6NxYIIphGu8r+ZWNdbVf1zX5fwKma7WAgN5kB6mcfMKfA2h47J7rCCEytXbg32E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pGUU6PR3; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3ee15b5435bso2757411f8f.0
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 08:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759160760; x=1759765560; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mzk7TvYEUHOAeZyPbb/RaRgUKTr/BD06CzZU6YBZwkQ=;
        b=pGUU6PR3HQ59IMs3r/EtNPWuid8xR90Js7LfHHuNIlPatAIU2QinSerDgtqV9sd9AY
         xh4feLcw8ItVCdX7yWGkn6aYh/M7/J8wqBulAfGl/4jy6GlVsO51tWgZrW/hVteyOT/F
         pdxJMbhZ4WiPT3MfBTFEBeRQD5imLEqb2pFAT/LP4maF9JbuU6lScYPk16YeuL4gGYyE
         3xIzAJweTPktMcJnX/NvB0e7qg8pkI+mjHlG7rXJiELPuxtdypA3zctcYgZDv4s1B6mn
         KgRsnI3mVWBLeqqrc+8tySJXi+1qGQCwwLCpaE5CHnUXOn/UjctPr/1hQHnvkmZ2PMcL
         QRrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759160760; x=1759765560;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mzk7TvYEUHOAeZyPbb/RaRgUKTr/BD06CzZU6YBZwkQ=;
        b=hEpBvGMvKXJ68FSVAbbRqb/YEBZGy1H0CRzLWer8v/HmKCLIrmRVzQXRtRF6bGMuaG
         nWofOBbrfQ/sKV5fvtKRpW6lX9lH9stMa1XF5RboTsU3rCG5mcn5Ts+hhymGxm7vOH2e
         f+V/Qh72dI0ZoxYpumNIT/GSeg8ognC9JlarR+NS/ot8hP8aapfK3Q7ENdFL9aqDmNm0
         2oZG5pNwL5xdS5C0pmgrMfOPOgLBTeUKqz6MMOrbXVCF951nwaFVbp+Zwr7udKXFez+a
         m+TuZFmXl9/4bUMR9n014h3wgIxBByc9JMbeNcFnF2ugX6q9EVIPFyUE5bdUOjFMnuhw
         8oHA==
X-Forwarded-Encrypted: i=1; AJvYcCVbk7WQ1jsIfS0Bq83PjUGE4JhDHhxpQg1a2640uvb1dNfEpnY4ygWjAL+dZScKiIC+FFE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxILXchaLUng3FLEhboM/XS4Q7pEhhklqBSWdGLhkj+dFaqvDxG
	ywz5SOCJvzYVzSAACstfcsBDZp0/YJZfNhsMJedCz7ci1jtSTunzIschgwBHMSTw6Iw=
X-Gm-Gg: ASbGncsC6HK9RRZ6otdSXugS1b0nLvbmJHfapuXoMGBZ/6f4WIaEM1jtg9t1rBcRmh+
	m2IdBXj9CNawop5BqMEC5075rF6G3KXdjzhmE7k7zV1VnVcgCa5Vh8D91EIS29OTAi2a4SwYFIN
	aFeyjY5wF2AvgOHAlqkR2SGF82fn64SvzDuMNyO7pP0DKBd8fSP3jhq0ZMZ4s0+fo30BMKo1eU+
	+PuzL7YSCSwbVuh3w8+r8Umwi1B095gAzTFzd5/VtWgZIiuzE2k01QWEiDlTnPNliWnHoOdznoi
	BFx7A9p13NPlZDiRKDgFjCZtk4J3umwAHDGn6+Bttx2wN8s202tgMCYcCWDlDrnmDnqiRLWsk5+
	9ZqsY9XQk/E+B9WM5S40DKJRUbUEOu0Z4LLI2qYUKAwKrbqYL11PUJQ/JJBKa5BddM0ZJ/AnZAH
	xDWkswX70=
X-Google-Smtp-Source: AGHT+IH3YlclHUvzBeZmjHgHfu13/rjSq09wBftIgqk34vt3aorhDGFF6U+XwbRLbXnplvAK5b40Pg==
X-Received: by 2002:a5d:66ce:0:b0:40f:288e:9966 with SMTP id ffacd0b85a97d-40f288e9d15mr10386034f8f.51.1759160760285;
        Mon, 29 Sep 2025 08:46:00 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc5602df0sm18812064f8f.36.2025.09.29.08.45.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 08:45:59 -0700 (PDT)
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
Subject: [PATCH 6/6] system/ramblock: Move RAMBlock helpers out of "system/ram_addr.h"
Date: Mon, 29 Sep 2025 17:45:29 +0200
Message-ID: <20250929154529.72504-7-philmd@linaro.org>
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

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
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
index 57c00e42ca6..1b4092d6322 100644
--- a/include/system/ramblock.h
+++ b/include/system/ramblock.h
@@ -119,4 +119,15 @@ int ram_block_attributes_state_change(RamBlockAttributes *attr, uint64_t offset,
  */
 bool ram_block_is_pmem(RAMBlock *rb);
 
+static inline bool offset_in_ramblock(RAMBlock *b, ram_addr_t offset)
+{
+    return (b && b->host && offset < b->used_length) ? true : false;
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


