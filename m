Return-Path: <kvm+bounces-59351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAFCBBB1684
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 19:55:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A5C577AECC2
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 17:54:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A57FF2C08C8;
	Wed,  1 Oct 2025 17:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="af366j4P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022FA25E44D
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 17:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759341337; cv=none; b=Hm1+no2TXcKsepaoNpjdptJjM0mO9i37TLi2jFWT9ovYysWbogreOiCZmSCVWj2WYprPQvyDzYVX/cwjYZfWlA8VkWRVvvt8XT1lPucB9F0hDmh/ipLF7x5m1lAAjPc0Oax9oKU2ePkXGmDBiPRisyQmwtQLzTRC2J5hlCsE+0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759341337; c=relaxed/simple;
	bh=Yd7g7OKWshhtXSLZhXqScVWlm/kQaZ4rv5sFbfiRDFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XBOBpmky2BwC2e3rtuXudddpqyrCb/ZT/Pw07RmR3/mrt6EWrPmmhU2VrPk+GOpLZaPgDr4I40pCOU/QMJePRqBMYWWqTmuhaMQiCWYv8EZjwZ72uYqjuxD7qQ0FJVpLMLEOFo7qZqQnmzUrof+3dmGAGHxWs/EK7ZkA+EQV50s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=af366j4P; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3ece1102998so56965f8f.2
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 10:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759341334; x=1759946134; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pMnn9QxqznMIk/8u6GQ47WHewwt0Ozp5spYHpTtSw08=;
        b=af366j4P9bK62HYD3vcH4sODWdi2ROk1yXTaiaF8u6qq1WKpPfhM+cwE/lFCIGO1Vl
         j9QNNs7nIunXxD/ZgRACjONFTZbpbeGuE7UpWnZcGPKp8mkISip15mn/3cPOe+07yE8X
         4rHQVyUTVEuhIahqjaQt8+6qb3M6QJnpZ1IGZe2mfRgRGaxQP1reLWlDfluyZZMxNCsb
         FYMtza2uH66uh59LrkHhF03m6vnwI6BZ51EO2f+9MpM8WKIY5Ek9PoYUPQ+U4pnpeKCL
         jvNift3dLs3efi1FbLh5ZjxPTX2UWXbdPqN6sN6QrcL0bKatjGzH4WKkdOI44UToL6gN
         H8/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759341334; x=1759946134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pMnn9QxqznMIk/8u6GQ47WHewwt0Ozp5spYHpTtSw08=;
        b=HSQ33xfZ+mozBvrNYSVsZI4eS/ZVbnKd8Qwy6Cw+Yjtk81zyASJvissf76TW7HzTHj
         Z0sjfOOAZJvj5NNICdRqRnXygNDNz9J0iSBmwZr5oYEBrhd+6aeO5R2PPi4/4TZV+1yw
         kBKUPe5Ved/VmSHij7+KT0bpur/bNOowiMnCVv2LvM3Nl4kxN2PyFt29R+ziBaBsnkmp
         Xe9jo/bhfHR5INPvwRN4DcAHHH0O4XeSNfwfvDVIMSTXXw9jwdk4Rh4l0hlMOv3g+eFD
         o7eiWAimID3sY3KDqpGa0/BFMv3pWNkDth7NKcpfQQMz0+YhZFuyjw0tcspaXWlT4ETW
         Mjmw==
X-Forwarded-Encrypted: i=1; AJvYcCUqFcdaxYLVgm7PZWK3qgc04BRZLtSfWXryy9juCP2TvtStF7CFsogkowOtHfnjSikjRt0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzG+XmGWakMn0CLqoq3fIjV8mw1j74lruro4ytKYzAGJCQojIyn
	Bxo6jYElB1Sg09JjbOe1b+E+0Jg4xGZlAlBZ3Vp/lVpO9GkmI2JF3ggtbXmiZ1V893s=
X-Gm-Gg: ASbGnctBFwcUer4HbipvHOhF8B15QNtYWPZfoJLUZZB/zy6sAEZ5R743QYjQVyYKzv1
	nCT4SM9OstBEN4PdrOjbTLm2KdYlbtQA+xpiZDOEWB1s9p9DriXSsEatqZjVd0OjMkntYZozPDu
	LvRFqlXUQuMKosR7MpvCRfVV6OvasDwV9Wea2/l8IiCLSTXpJYJI46pVtHpo5fvRbyljhm4DrK/
	Yt4fohMHAcCuSGKMlVpKQMDJ8RV6ZwxYeZkDQowIxPzAsSH1GL9d48uQyWjuk08hkWJdC8PGSrf
	nU5LsFk3QXYiYYFtujbtWlOgwrETRS5rHD3iDFZbZidf+r22d/D7r7qbl/Qx0MFupz/yIdxUpbL
	8UyMvKRo3Z0Z0L52863EZ1O2zqz9OHIi+LflYSJHE7PiY+GDybTirVxGlpDUT3lcZA6QLTA1Jzl
	DSD/Ke5C1+63HrfE+jc5NvZMItrcC/0KG6zIpw
X-Google-Smtp-Source: AGHT+IH3Aw7dJFcRGHrlqU+4GY94BK4VCgtQs9LFky54IFrpPglI/IatQU7AKf0gdO60PkhxhKtrWw==
X-Received: by 2002:a05:6000:2901:b0:3ec:d740:a71b with SMTP id ffacd0b85a97d-4255780c039mr3284668f8f.31.1759341334253;
        Wed, 01 Oct 2025 10:55:34 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f0846sm79742f8f.45.2025.10.01.10.55.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 10:55:33 -0700 (PDT)
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
Subject: [PATCH v2 08/18] system/physmem: Un-inline cpu_physical_memory_is_clean()
Date: Wed,  1 Oct 2025 19:54:37 +0200
Message-ID: <20251001175448.18933-9-philmd@linaro.org>
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
 include/system/ram_addr.h | 9 +--------
 system/physmem.c          | 9 +++++++++
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
index f8a307d1a3d..cdf25c315be 100644
--- a/include/system/ram_addr.h
+++ b/include/system/ram_addr.h
@@ -183,14 +183,7 @@ static inline bool cpu_physical_memory_all_dirty(ram_addr_t start,
 
 bool cpu_physical_memory_get_dirty_flag(ram_addr_t addr, unsigned client);
 
-static inline bool cpu_physical_memory_is_clean(ram_addr_t addr)
-{
-    bool vga = cpu_physical_memory_get_dirty_flag(addr, DIRTY_MEMORY_VGA);
-    bool code = cpu_physical_memory_get_dirty_flag(addr, DIRTY_MEMORY_CODE);
-    bool migration =
-        cpu_physical_memory_get_dirty_flag(addr, DIRTY_MEMORY_MIGRATION);
-    return !(vga && code && migration);
-}
+bool cpu_physical_memory_is_clean(ram_addr_t addr);
 
 static inline uint8_t cpu_physical_memory_range_includes_clean(ram_addr_t start,
                                                                ram_addr_t length,
diff --git a/system/physmem.c b/system/physmem.c
index a8d201d7048..fb6a7378ff7 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -945,6 +945,15 @@ bool cpu_physical_memory_get_dirty_flag(ram_addr_t addr, unsigned client)
     return physical_memory_get_dirty(addr, 1, client);
 }
 
+bool cpu_physical_memory_is_clean(ram_addr_t addr)
+{
+    bool vga = cpu_physical_memory_get_dirty_flag(addr, DIRTY_MEMORY_VGA);
+    bool code = cpu_physical_memory_get_dirty_flag(addr, DIRTY_MEMORY_CODE);
+    bool migration =
+        cpu_physical_memory_get_dirty_flag(addr, DIRTY_MEMORY_MIGRATION);
+    return !(vga && code && migration);
+}
+
 /* Note: start and end must be within the same ram block.  */
 bool cpu_physical_memory_test_and_clear_dirty(ram_addr_t start,
                                               ram_addr_t length,
-- 
2.51.0


