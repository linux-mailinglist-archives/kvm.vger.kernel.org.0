Return-Path: <kvm+bounces-59262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4299CBAF970
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:23:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A2DF3189C8D1
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:24:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 291E7280330;
	Wed,  1 Oct 2025 08:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kNFUlj+O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CEB27F75F
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 08:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759307002; cv=none; b=oyEVlGOAgIq9wR3IRXvX05atB1i8OIMKO7wgBD5lNeEj3aVEc91GFZcK3v/CXjw4FSj9rxW2UQq0ipvIcWbXH2PtRAmJ7HC2ik5QeK3VIds5THM0W2kB4vn1tWFLblWVvglqvhGzSX8N4PM6tj4o3DjTEQRFgC+gi3b0sNk+6Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759307002; c=relaxed/simple;
	bh=2MK4DKxEn1JLvthqYGt8vST7HO0z5rjxaTuJTj8EL+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZssPGTH6lu0jv4KbPr+f4L/5aQMPn4H4n/iQ7cpbZD/lfSB23dmF6wwIQCp//uujCIqku0p5fmZUd6QTz3YNrr/Id8UQFOSFQZSYN+JYs6t2nIIfKba3WX8f+1zbqMqE/YfWBiQqugt1uJAEgANd4zlS1b/ha9d4y/Lyf0UWjjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kNFUlj+O; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-46e61ebddd6so6485645e9.0
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 01:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759306998; x=1759911798; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VrNgTPyJzvEO8S5hoH74TrA1pNzqvoSoa2IFmkmTeGg=;
        b=kNFUlj+OmyE3RDUC9arb3jmmCpvaRLWcWmAo6QgCnU8dGCAyn7VEktZpFkl8QvDyUL
         eQ8GMxjw/EOmGLZWZNOFwq6u9182pI7kyeGypWlhO6nGEd0UtTnqIywf5pIqlWIjqmf1
         P3x276HfXFORlBB7LZ5UPrl5E6MY2fqsXE5YAIm5X2dkJPliq70ynH+eSu6tG9zAWQ+6
         dSMY4SN1nk0lDImru7oVTewj6Qs3j+nxN8vtudRwG48gMw/M2xpA8WmnVqDdiPMzrGzv
         8ZDnUUJSa3i3Agjz223Y+BDvomx9zOolNs1+TATqzYxjKyxd2zjtWP1Y+yfFB+E5ys//
         6aaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759306998; x=1759911798;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VrNgTPyJzvEO8S5hoH74TrA1pNzqvoSoa2IFmkmTeGg=;
        b=k4FMPq2WErMcwOOGkRyhtEEpHDeBMTVBkhLkHll08OraEla3wV57uNsfte5uwWpLVM
         YB422gG58koavbGNkY91r+TZWT7pNIHOaatYbiiRQbp52wyCg+vSDoQkfKk52tUWOOzv
         koH0Rle6bxlyfhgvO2sLGG7+nENrxy1GhumYGEXTVN1IZqYyIwO8ZaRXvUo4RML8OWrZ
         MUP0wby3C3asnBvx2rxmkioJPFaQWomiEd5rBdpWYzgF/5U5U2xzJG8VlGCIowKT/EPD
         IuTvtTP3eDZnkMN2mxoix0rCW5oQTLXSCpgKAYG0Fcmzxai7pmoYXsy/u4syvVG3kRpl
         pqXQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+aYx4SxTHEzxJmmBfGQ4IsIkLDrZT35nz8vr2YUUWHsRhtnHrOlO9gk0EbJomEt3U7Z8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCZHNn1Ysy3R8Y335HhAHac0+IVv0RisdOPWyZCZZcstbGYAL7
	0Xn4iSroB9p5j6YJZ+DfAKbrNcnP+dX/A7KAh39CSVz3eGdLPa9+3amCvhorYGhzya8=
X-Gm-Gg: ASbGncva+z/mQrrZFJDGcaQbO1RKsjrcHCF3FXSTA8yomwV+J9EpnZ/RiCYAA2EkFWm
	vxql9a5jEwQeMSPXLuoiz0ByP80iPdpN8ZRyLX3MMa3yp5nGUOlWC4cEHaVy8soAMwuUhLMGK7j
	0Yn2TB7FyEl6FZhW8VWbniEs71AR2OOnAasARhhjAogfEYOdyKDu9Ph8CthydqqdzSGKVdkZRhI
	UaTEjFHMR4NWIB1X+oEpWHTuqGTRi7QTf7vhBuvOj5rjOjs7DsJlB/uZLQqUmQT8hEo3iG5GSV0
	D9pLVmwTi9tNt3gplhf6hK9n2ROhhp8NGwUFyWAgc0LmnvShpXVqTDpvwBBAoNWJ9hY6U/NnCiA
	yew/6KftWbLJQOlgpQHAwJTHLCIKn2JxEcXHC7hn2OU9kVMPJhn+ryekLy8ntPVqPiC0EX5ykL/
	aMJREBrKivO2GehCARLbQH4kC8ocjM2bs=
X-Google-Smtp-Source: AGHT+IHmELa2DuEfVWDKNypuVulirBMMoxnOdm+AkbpdEdchyNTUzA1LDJJ69gO6XD2Qu34B2Kle9w==
X-Received: by 2002:a05:600c:a304:b0:46e:652e:168f with SMTP id 5b1f17b1804b1-46e652e1d0fmr6748725e9.6.1759306997734;
        Wed, 01 Oct 2025 01:23:17 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc88b0779sm25777665f8f.58.2025.10.01.01.23.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 01:23:17 -0700 (PDT)
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
Subject: [PATCH 20/25] system/physmem: Un-inline cpu_physical_memory_dirty_bits_cleared()
Date: Wed,  1 Oct 2025 10:21:20 +0200
Message-ID: <20251001082127.65741-21-philmd@linaro.org>
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
 include/system/ram_addr.h | 11 ++---------
 system/physmem.c          |  7 +++++++
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
index e65f479e266..7197913d761 100644
--- a/include/system/ram_addr.h
+++ b/include/system/ram_addr.h
@@ -19,8 +19,6 @@
 #ifndef SYSTEM_RAM_ADDR_H
 #define SYSTEM_RAM_ADDR_H
 
-#include "system/tcg.h"
-#include "exec/cputlb.h"
 #include "exec/ramlist.h"
 #include "system/ramblock.h"
 #include "system/memory.h"
@@ -166,13 +164,8 @@ uint64_t cpu_physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
                                                 ram_addr_t pages);
 #endif /* not _WIN32 */
 
-static inline void cpu_physical_memory_dirty_bits_cleared(ram_addr_t addr,
-                                                          ram_addr_t length)
-{
-    if (tcg_enabled()) {
-        tlb_reset_dirty_range_all(addr, length);
-    }
-}
+void cpu_physical_memory_dirty_bits_cleared(ram_addr_t addr, ram_addr_t length);
+
 bool cpu_physical_memory_test_and_clear_dirty(ram_addr_t start,
                                               ram_addr_t length,
                                               unsigned client);
diff --git a/system/physmem.c b/system/physmem.c
index e78ca410ebf..c475ce0a5db 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -902,6 +902,13 @@ void tlb_reset_dirty_range_all(ram_addr_t addr, ram_addr_t length)
     }
 }
 
+void cpu_physical_memory_dirty_bits_cleared(ram_addr_t addr, ram_addr_t length)
+{
+    if (tcg_enabled()) {
+        tlb_reset_dirty_range_all(addr, length);
+    }
+}
+
 static bool physical_memory_get_dirty(ram_addr_t addr, ram_addr_t length,
                                       unsigned client)
 {
-- 
2.51.0


