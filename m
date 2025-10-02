Return-Path: <kvm+bounces-59404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 61053BB3518
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 10:49:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8FFF619C2979
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 08:46:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB39130EF86;
	Thu,  2 Oct 2025 08:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YPJ93sjV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D55301022
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 08:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759394538; cv=none; b=l+xcaS87l8WlDjG9B8L8G3MMTobhKiQVE2a+DC/6476hh/Vcx+QhZgy5nTSy0fNzVXPtPvibfvR9Deys9KNOkQLy4RkgxPP3s7TnhDjIEaFVbeUkbpBz3HbBhjyLM0C3/KGlT8fvQ+Uj1fNzqAUf1TjNmNHPL6fNG+aCy68EAlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759394538; c=relaxed/simple;
	bh=0m8cDCBTCEJ2WumLwshzfz69W/LBFFK5VGeDtQeHmx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NB3DPWUaqOXaDAQe9vnDWXh+w8CnBXN8+vcRnGVIKTmeCg/MXNz/XLIHFgtzdtv9wWvurSrMevuut9zotsAiV9tf2BOsWLvkV5Hy4GEPkYqpSxEcy4hkqgkjPUo7cDnO1zFw05DHxKGwmaBB7D2RfI43h4f/khDBgTnO+7kVfxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YPJ93sjV; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-46e61ebddd6so6841105e9.0
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 01:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759394534; x=1759999334; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HWUjqrhoII9IYKgjMFDNsLi+Cgv2QEPokr0XBtkHqiA=;
        b=YPJ93sjVy99Lh00OxW5q+4DlJuJYf19v+YvD9qVklZil8d4cZhIIFd6vXIttzSY3uA
         wHGTxP8idYSXRwY5+h7PBOH9uTX1hlTt2ykk/f9mhQP5WBbna0EU5biUHKCUKq/NAvtU
         7T1IjVwrtHJJJ+Z7h0OI708h/mkva3tkU0lrW4mr7ooUUGpF6F3kwif79QczjmKHwqxJ
         acFRtwqJwjkAJaGZrZsKAdGefqtshITmZqLtWMNzKQzmD7WC59HiI39XvKBn8neATCHx
         aWTuUobWX8tnWRX+++kDXwRr8whcbBaU4+3guRYXmdgAKcX+utgEBYbIK4+4Tzxv2Cyk
         0i8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759394534; x=1759999334;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HWUjqrhoII9IYKgjMFDNsLi+Cgv2QEPokr0XBtkHqiA=;
        b=XOvWbt2dMdz8qiiLnRFSP3KkjJiDZ8iEEWcaxf+NlfHiCfnPbaele+6Gm1ctusfUvO
         0ORYNvk2RHxBxqXGYYxQTOLOqBkebvlZFaUMKWCsERgKZjrEqucS5xT2TZDBFLwaWf0s
         Pq0zOQP7ipIF8JNiAaQiopn6ysufVSM+wxTrsT0t77v7V5dnJHMt8O7Tbrk7EsAYCQoU
         fGq7vCOW8EnPpzKKN+GEHDQR6pBugJYojrbqpgOxzl4Pn3di60pFRjD7uMLgPMZV1W0P
         YSlVPY8+QmvyzRKn93F4ElAn1jHAjbHDV8TQZrtj7aSQWsPK0DXqVjNEiHrCreZrNgN1
         hFqA==
X-Forwarded-Encrypted: i=1; AJvYcCXoQpjr3pMU330A6piPwO3CYT/9RY26J60Kl9kS2Byyt1miRY+Ho6JWoHAHSGgIV9pU3xM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5V8CX9q8vJZ8po8WjUYBmf6pv6NYGg3/e/vwqh6JUWaffZ1ob
	Yx1G97TxA/nf8K5TrMgu7PVcrhdxwh+7+bZO2dILAgL3mNG4N/lGRrembVJTiJnPN9aqrM8leNS
	Od9bq0OkI0A==
X-Gm-Gg: ASbGncsnZMkCNja5FaT5qOxNdI1RB4z3kKlGaoF+C5TaM3mfJTkD7DLDeS4kt9mxUtS
	HvJ0TFcZJHKpIjAZrBw1QuKCOSeJ2w58kQs7WAGVLjJ1vo2kVEBa4us7yWr4oUB2+OC39CjIQHw
	2XdKRVjGUZmvvyT1CmTkmUTCMnGPX6mlPr1Readq7D8fOvaKC3UIidF56KsqReZKavB3q0gkrRJ
	lFJzhGv+T0dbyUqzf45C0Ll1tbkYKcq9TSBrErh1G3iVng7kJrJLIn4/geD2mvITvcJ5WOm7jOR
	WkHObtxglfUtd+kTFZ4m7ciIUBonZ6BliqlgnaEuZCMGW9Eht88XTZivFnTkhLhaujvM1bis+sW
	wmLFJ7f7oomFSK+NxRRI4M8wjuPAPCcw80t/UEhI+daCDEnTEvSwA3NTAyP7fcuM+MPwmWljKG7
	h1j8yWz4uFUE2rV1brpFYD7MMSbGq8Pg==
X-Google-Smtp-Source: AGHT+IGTHDHXIrJOhOoypYRjJsVDikLhcyRvRa/vBA1Wlz/iaLsadlO4HdF+yc3FSV0R35r+UTvjog==
X-Received: by 2002:a05:6000:2586:b0:3e4:d981:e312 with SMTP id ffacd0b85a97d-42557817210mr5123294f8f.62.1759394534260;
        Thu, 02 Oct 2025 01:42:14 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8e960asm2619549f8f.37.2025.10.02.01.42.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 02 Oct 2025 01:42:13 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Thomas Huth <thuth@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v4 02/17] system/memory: Factor address_space_is_io() out
Date: Thu,  2 Oct 2025 10:41:47 +0200
Message-ID: <20251002084203.63899-3-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251002084203.63899-1-philmd@linaro.org>
References: <20251002084203.63899-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Factor address_space_is_io() out of cpu_physical_memory_is_io().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/memory.h |  9 +++++++++
 system/physmem.c        | 21 ++++++++++++---------
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/include/system/memory.h b/include/system/memory.h
index aa85fc27a10..1b2b0e5ce1e 100644
--- a/include/system/memory.h
+++ b/include/system/memory.h
@@ -3029,6 +3029,15 @@ static inline MemoryRegion *address_space_translate(AddressSpace *as,
 bool address_space_access_valid(AddressSpace *as, hwaddr addr, hwaddr len,
                                 bool is_write, MemTxAttrs attrs);
 
+/**
+ * address_space_is_io: check whether an guest physical addresses
+ *                      whithin an address space is I/O memory.
+ *
+ * @as: #AddressSpace to be accessed
+ * @addr: address within that address space
+ */
+bool address_space_is_io(AddressSpace *as, hwaddr addr);
+
 /* address_space_map: map a physical memory region into a host virtual address
  *
  * May map a subset of the requested range, given by and returned in @plen.
diff --git a/system/physmem.c b/system/physmem.c
index 225ab817883..c2829ab407a 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -3358,6 +3358,17 @@ bool address_space_access_valid(AddressSpace *as, hwaddr addr,
     return flatview_access_valid(fv, addr, len, is_write, attrs);
 }
 
+bool address_space_is_io(AddressSpace *as, hwaddr addr)
+{
+    MemoryRegion *mr;
+
+    RCU_READ_LOCK_GUARD();
+    mr = address_space_translate(as, addr, &addr, NULL, false,
+                                 MEMTXATTRS_UNSPECIFIED);
+
+    return !(memory_region_is_ram(mr) || memory_region_is_romd(mr));
+}
+
 static hwaddr
 flatview_extend_translation(FlatView *fv, hwaddr addr,
                             hwaddr target_len,
@@ -3754,15 +3765,7 @@ int cpu_memory_rw_debug(CPUState *cpu, vaddr addr,
 
 bool cpu_physical_memory_is_io(hwaddr phys_addr)
 {
-    MemoryRegion*mr;
-    hwaddr l = 1;
-
-    RCU_READ_LOCK_GUARD();
-    mr = address_space_translate(&address_space_memory,
-                                 phys_addr, &phys_addr, &l, false,
-                                 MEMTXATTRS_UNSPECIFIED);
-
-    return !(memory_region_is_ram(mr) || memory_region_is_romd(mr));
+    return address_space_is_io(&address_space_memory, phys_addr);
 }
 
 int qemu_ram_foreach_block(RAMBlockIterFunc func, void *opaque)
-- 
2.51.0


