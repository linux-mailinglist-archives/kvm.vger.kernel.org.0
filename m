Return-Path: <kvm+bounces-59258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 853B3BAF95E
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:23:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6C0C57ABC12
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:21:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CFF7280309;
	Wed,  1 Oct 2025 08:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wfnuuNYd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B4C19DF4F
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 08:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759306979; cv=none; b=ZH0vtRnWyD/0kZ+v1OTbFBocoEVt1/MhU5++CXTVLrd/rzMTFm7LMUjtH4YZa38eoXgr7YqLiy2skr3NVB2/eDxmNZ6UkUBRBL+DutqX2NU2FCpTfn3Cv4nAmtXHBrf8RyXk1pG28ZoYglGRCwIBKl9VEFtLD7BIB6tHv+1LZus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759306979; c=relaxed/simple;
	bh=sURCVaXR9eE0jXvLUwEgOCbg9rjGL5816k35AjF770g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OBF+iNh4djNtBkf8uhE5wmLES4rfDDVUFkbNOqUB9HpUVxQek5tVihXtQEh+xIEi1uZTwtCP+AGx20yVtRQh9YAmMfBomte3BBky8Oi2olA28VFGOYBbd8catjfk0mKZGhUM8ekPSud3c1qsHRx3uuIqOG4Ug/g+HbNBF6ikAkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wfnuuNYd; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-46e3a50bc0fso48298485e9.3
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 01:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759306976; x=1759911776; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fn2TjoRESSlrNJjOER4d6gpZrt35+AGo12EpGqjkW1I=;
        b=wfnuuNYdajUInreCn9MiOUE79oTTRQI9UCZSXIjYzTjMkZZZdUlfo+5ZUWuobUIeCI
         nnpiZ6tlHjFp3zQ/aEpYnTw+kyKPvC/jiRBqwTwXH4O7Ho4XShzVacjk1ez5ZXAb10Ts
         yPlRNydsGYQazLiE0rOvRBB4xr2yHsf4XF7JTJTkBgO88W6Qd/KwaJQKRgJSdLNf/HHx
         EffdX27fvqlPTu2dVx51hzOkPy5Je/91a/rpJEjFcZkmXYAPXD5QSYcKCs7q/7hR1I7p
         e+xT+6i3cg1iMImU7lw0aoXyw/Wl+s9nqLAEUr8ebAB5CmYQgRd7dEBJei23GF7u6OFO
         1/gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759306976; x=1759911776;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fn2TjoRESSlrNJjOER4d6gpZrt35+AGo12EpGqjkW1I=;
        b=V/jAvJcUhXNdrEmUEKAZiGCo/fPA/JcPB4bRj6/cKvaWzuu9VC7wJQRtqQE+eCkhOv
         4jfqeBfuZibNrV/c+2BHz1ofrhXi5lQYZ+l3HafwKrROyjum01i2g/rVZQMbqBBCaKI/
         ttg1HcqfVvNLl1INh5KPsr1wYfWMU2JnE61cZozaAtBssNJP3Uay3OMyaUg8WHDXKH84
         nqsvWGXaVkTxkeHDfpPPRiLbbbd2PAtaSCmFVb5S6qj6OX1Ny4MYs880EjE731H2fbp3
         X7Wk5xE5l1Ek189LvcXsrm13Y5V3da9wNnzY0PKkwleBKLVQIITdJOGUI2vsMtKOto4C
         DM3g==
X-Forwarded-Encrypted: i=1; AJvYcCV4NsLaFxpMY0sEl3waISOSd1X8+uZCC6jEoFXF0HSREirepoX/eTQlEz1vEpOjZabjIpQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRGvtwf+qBzxGOaiQ6TA7qfHtp8CsqDQ2jPmXL7KLWlW1oul07
	ZFGhE+/Ps2m9QC8zok6N3NYtN3kwobYMgMDBbQLZQQaCU3dIeJRkz/NqO7IBRznI1hc=
X-Gm-Gg: ASbGncsaF3NcsBCatqDCIcCpX45IqdP9s12XRu4ruq3cC0LAhwRrksEnm7tweIKpArJ
	0HynfAbMUNvSwBIl4Sd1n30uXTNfnnUTf+K7gqOmpavROGHbmS1r0XUzd2YYECoIOtDAlBewHtG
	ksmdt9doY9ohxlJlris2Aq+WdyyA4crSTGn/OjQfOIkQtp4vbFuqmYQf9oQcoUqaHUctq/FGKrD
	YGyjUnvP78V5uQWNbqi6C9z0ABVbrUNeixAPzKzBhTd2RTtbwTeKCRpgGh7w7xlYYSLr2FfqiRB
	V940GV3hPhKBlA6/MJ35/osWK3dgVOcNJ1BxgPfNwVY42moVzz1Drcvosx73TvarpFgGmbUT/S4
	qvaLvBVsFDi5UvSOydh9zP5zF3mTDyQeM/h1cS1Xh3xlF/ZzY/rpGHfURFk/Rza4jWfc51ThafZ
	UPSan72w0l5inlvHOnogky
X-Google-Smtp-Source: AGHT+IGa971mXhZ9J5c8QC/V145CuXilY9sHAaHNYsxw+frSzKFCefeHYCbSr6kcPeg6FkecemzV3g==
X-Received: by 2002:a05:600c:8414:b0:46e:206a:78cc with SMTP id 5b1f17b1804b1-46e612c9042mr20995395e9.28.1759306975822;
        Wed, 01 Oct 2025 01:22:55 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e61a25dbcsm28397185e9.19.2025.10.01.01.22.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 01:22:55 -0700 (PDT)
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
Subject: [PATCH 16/25] system/physmem: Rename @start argument of physical_memory_*range()
Date: Wed,  1 Oct 2025 10:21:16 +0200
Message-ID: <20251001082127.65741-17-philmd@linaro.org>
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

Generally we want to clarify terminology and avoid confusions,
prefering @start with (exclusive) @end, and base @addr with
@length (for inclusive range).

Here as cpu_physical_memory_set_dirty_range() operates on a
range, rename @start as @addr.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/ram_addr.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
index 6ed17b455b4..84a8b5c003d 100644
--- a/include/system/ram_addr.h
+++ b/include/system/ram_addr.h
@@ -152,7 +152,7 @@ uint8_t cpu_physical_memory_range_includes_clean(ram_addr_t addr,
 
 void cpu_physical_memory_set_dirty_flag(ram_addr_t addr, unsigned client);
 
-static inline void cpu_physical_memory_set_dirty_range(ram_addr_t start,
+static inline void cpu_physical_memory_set_dirty_range(ram_addr_t addr,
                                                        ram_addr_t length,
                                                        uint8_t mask)
 {
@@ -165,8 +165,8 @@ static inline void cpu_physical_memory_set_dirty_range(ram_addr_t start,
         return;
     }
 
-    end = TARGET_PAGE_ALIGN(start + length) >> TARGET_PAGE_BITS;
-    page = start >> TARGET_PAGE_BITS;
+    end = TARGET_PAGE_ALIGN(addr + length) >> TARGET_PAGE_BITS;
+    page = addr >> TARGET_PAGE_BITS;
 
     WITH_RCU_READ_LOCK_GUARD() {
         for (i = 0; i < DIRTY_MEMORY_NUM; i++) {
@@ -200,7 +200,7 @@ static inline void cpu_physical_memory_set_dirty_range(ram_addr_t start,
     }
 
     if (xen_enabled()) {
-        xen_hvm_modified_memory(start, length);
+        xen_hvm_modified_memory(addr, length);
     }
 }
 
-- 
2.51.0


