Return-Path: <kvm+bounces-59032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C9AFBAA4ED
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 20:33:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 520EF3A5EF5
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:33:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F55123C4ED;
	Mon, 29 Sep 2025 18:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="r6IEPTVN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0282253FF
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 18:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759170813; cv=none; b=QRgqJbHWwvtFYKPIxUk1LwyVSrFdY9rc71TVDimBqoxUIUg6Sny0BQzaTohVWZoD5LVBEjEEo4rHNaKAXBlVrvG9XBmDstc78/svpA2fs6LJSzgl/eGDbHZLHqWEmLu/eFr7fzmah+dNEEIQaUD4AuA/eiaG2ZXvJENXTzNaimc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759170813; c=relaxed/simple;
	bh=pSqOQBHX/VLpuIH2hKYRUcu7QDpi7xtEbK0IXRldxww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QXtvzg6huMPLIkV6MhkaFK8jrchHOUoCmzIfRbjXbz40YXdsbO7AV2DeLS+bJmfDyp6bKdtkd0zmL00y9yt7MbAWb/S6t5VgViMFqK5zRFB2aaNJ3xw199GpybaKLl2hWna+YA6I3rTzTeNEzTgd5Qe8nxi58LHOZ8D8QyuaZxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=r6IEPTVN; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-46e37d10ed2so48131635e9.2
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 11:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759170810; x=1759775610; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PEWvJYylRbkib8yXjJlQ3r1Fc9sZ+i1G3AKqr/Nn6n8=;
        b=r6IEPTVNpGbI4FXGpVstwc2dPNV9J4XIzOU9jNgIcPNvNRil/LoWx1qljJqaRCKGI6
         DCDf04xPcP7bTZh8BA/OENbLBq87n0JukhWUDZfpVIx+cbVPTCpr/HmAru5ewve9jjNW
         zmU+l8I7bpD+bte+lXV/ZIH4hx2gYPFO4Bczu/r6qgww/rQLtHbV6RiXnjIlcI0fw6UL
         l3RrxJj0Akfw2UrZNiaTNn+aRHX8OuAMVAUd0W1UF5RzXMJRQpEoa+eo3AhJ5io11hdA
         CAOo8nJUXMlh4d4voWaFJycSvkJuE8upBmt0MGgIGkg82sX9XugFew2vNrOXggu+iWOD
         1y+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759170810; x=1759775610;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PEWvJYylRbkib8yXjJlQ3r1Fc9sZ+i1G3AKqr/Nn6n8=;
        b=jezgcYfQq2bTrysAAsa9bz8ulv6ZHGDVW2EfyQaNAZxaz4sEa05DP6XC8MipcuVhWO
         pFr4qjvzQ5nNk2+r9F94v1k637TPegkpbgARjTvZcQ3lM0zaTKGwCc24vLkd+2wamQWH
         1OaDAL21bNMkjaOFWTwrmMf2J8BFF5JgaguqqkGM3L4pF37cD2cZJJZCxWL0s4AQxXW3
         kevatS++GyN8KnOxZj0cGwEks3WlfEfJuY9olKgk9/0Ce26Zl/QTrkmq/bRWKkLo0D3z
         UOrIpzaGXRrdjdV7UDuQFXCykn2xbVpCI33eowXn+MXKz2kjHBQNXM2XW9YSja24UsIA
         PAzw==
X-Forwarded-Encrypted: i=1; AJvYcCVC5lLmatOT1Ptkr4UTmKd74Lih/OnDSHvZ5zV9ukz0C5mXQFVezADI+g7CTImSTyZEwwE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0l4XtjyI4k//Q72My/8tlY4tSfMoQpqKr/A8UD1/wahC1gTiR
	BQ8E80cCMAyzTX8cB3QPf0kvMfilAUxiiLol9+k7Nc2UlKlaQeC5X9pUwoP+cFfeYJ0=
X-Gm-Gg: ASbGncsC/f597tnuLaHyaAG+/+fm6mBvqDlyQ9GGAobdjEXgMa76840Karh3NS/z6ZD
	EhCp2kldXSvc8eJJGI6CtoU9vg5wZFVFBIRTMHFZkLJ4/2VJ3adCm0DfzvGIG27rvUjmPqluA/R
	Zxqx8Zu+l7quih6dSvQw8khGNkHnV0cslbNhvwoJtUCEQxZ7aEeMYFTCvdoDSU8IlqLDO4eXVDV
	OKjNwjUCm+nNZAIW84tRVdBlRkMROmeXqTfPmSE1ZCNn4zXxb2UMV6UNrY93HxP5rUCp4MER/KN
	ph2CBSrsrHVsydpW3WSHg1L+cNwMutxpglJkqe1G8HfC0lRe3wrHfN1AWW7T0EyH8mh4uM7Hg7+
	Yg5F367oPE6haizuLG0kgCosOUPEBzrjdrn1w9y8O5qQfLUynP1v1Gc9b4TIdflKTB6SnvQyrYw
	dKEVJVawY=
X-Google-Smtp-Source: AGHT+IFlycBakp5EkJDN7dbxjK7i5JzbYULjjWcaNxhP9aXTBI6jbDWLO50skO4rhy6UhWAATwe2kg==
X-Received: by 2002:a05:600c:609b:b0:46e:4814:4b6f with SMTP id 5b1f17b1804b1-46e48144bbcmr82071665e9.2.1759170809908;
        Mon, 29 Sep 2025 11:33:29 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e42eee0b6sm125709405e9.10.2025.09.29.11.33.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 11:33:29 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: Peter Maydell <peter.maydell@linaro.org>,
	qemu-devel@nongnu.org
Cc: Stefano Stabellini <sstabellini@kernel.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	kvm@vger.kernel.org,
	Eric Farman <farman@linux.ibm.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	xen-devel@lists.xenproject.org,
	Paul Durrant <paul@xen.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Anthony PERARD <anthony@xenproject.org>,
	qemu-s390x@nongnu.org,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Peter Xu <peterx@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>
Subject: [PATCH 06/15] system/physmem: Pass address space argument to cpu_flush_icache_range()
Date: Mon, 29 Sep 2025 20:32:45 +0200
Message-ID: <20250929183254.85478-7-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250929183254.85478-1-philmd@linaro.org>
References: <20250929183254.85478-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Rename cpu_flush_icache_range() as address_space_flush_icache_range(),
passing an address space by argument. The single caller, rom_reset(),
already operates on an address space. Use it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/exec/cpu-common.h | 2 --
 include/system/memory.h   | 2 ++
 hw/core/loader.c          | 2 +-
 system/physmem.c          | 5 ++---
 4 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index a73463a7038..6c7d84aacb4 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -156,8 +156,6 @@ void cpu_physical_memory_unmap(void *buffer, hwaddr len,
  */
 void qemu_flush_coalesced_mmio_buffer(void);
 
-void cpu_flush_icache_range(hwaddr start, hwaddr len);
-
 typedef int (RAMBlockIterFunc)(RAMBlock *rb, void *opaque);
 
 int qemu_ram_foreach_block(RAMBlockIterFunc func, void *opaque);
diff --git a/include/system/memory.h b/include/system/memory.h
index 6cfa22d7a80..00203522ae4 100644
--- a/include/system/memory.h
+++ b/include/system/memory.h
@@ -2977,6 +2977,8 @@ void address_space_cache_invalidate(MemoryRegionCache *cache,
  */
 void address_space_cache_destroy(MemoryRegionCache *cache);
 
+void address_space_flush_icache_range(AddressSpace *as, hwaddr addr, hwaddr len);
+
 /* address_space_get_iotlb_entry: translate an address into an IOTLB
  * entry. Should be called from an RCU critical section.
  */
diff --git a/hw/core/loader.c b/hw/core/loader.c
index 524af6f14a0..477661a0255 100644
--- a/hw/core/loader.c
+++ b/hw/core/loader.c
@@ -1242,7 +1242,7 @@ static void rom_reset(void *unused)
          * that the instruction cache for that new region is clear, so that the
          * CPU definitely fetches its instructions from the just written data.
          */
-        cpu_flush_icache_range(rom->addr, rom->datasize);
+        address_space_flush_icache_range(rom->as, rom->addr, rom->datasize);
 
         trace_loader_write_rom(rom->name, rom->addr, rom->datasize, rom->isrom);
     }
diff --git a/system/physmem.c b/system/physmem.c
index fd2331c8d01..dc458cedc3f 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -3214,7 +3214,7 @@ MemTxResult address_space_write_rom(AddressSpace *as, hwaddr addr,
     return MEMTX_OK;
 }
 
-void cpu_flush_icache_range(hwaddr addr, hwaddr len)
+void address_space_flush_icache_range(AddressSpace *as, hwaddr addr, hwaddr len)
 {
     /*
      * This function should do the same thing as an icache flush that was
@@ -3229,8 +3229,7 @@ void cpu_flush_icache_range(hwaddr addr, hwaddr len)
     RCU_READ_LOCK_GUARD();
     while (len > 0) {
         hwaddr addr1, l = len;
-        MemoryRegion *mr = address_space_translate(&address_space_memory,
-                                                   addr, &addr1, &l, true,
+        MemoryRegion *mr = address_space_translate(as, addr, &addr1, &l, true,
                                                    MEMTXATTRS_UNSPECIFIED);
 
         if (!memory_region_supports_direct_access(mr)) {
-- 
2.51.0


