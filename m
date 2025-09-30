Return-Path: <kvm+bounces-59064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9445DBAB4C3
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 06:14:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA11A17199F
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 04:14:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC424248F7F;
	Tue, 30 Sep 2025 04:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gRFMWGRV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C31247284
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 04:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759205652; cv=none; b=J/P0yF1frmAwuzP5nEMY8UKKU38rlepBpeWW2ri/yHAmMVfHvG0Cn+KxYWcJ5b19cIIGSZn9GrWpNmtRSlP5djoTjCKotUGJPQTpw7GDdRlPgXFJE1JwFVEey4O/CAzMVSSXsvfJ1oHbmn71VT5tHT2672CWXpiGREfl9OJOl/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759205652; c=relaxed/simple;
	bh=giGQfDxTtujI1DL14yVQRSjbiqWAqC2i4+BZ2jOPuHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s7CotKytCJJWKCH3JIoX/zwggaP6/peyYUOqXDw3IujWUwMXLHSVhtps6PcwLppjjZVyOqgTBYdCtJtTdWZb8ADAyk1k1dyRoRpo1Kp8ZHSWBtrV2l5V++3xb9mN4EzjmnlNn7Dh3c2I20TdUETZm/9F7UWb9tkUKV8AJkxQUZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gRFMWGRV; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3ee130237a8so3873149f8f.0
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 21:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759205649; x=1759810449; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uk5+wyHN7CkT7HC+T4CiL8GLFFBvq7A2wJEeem4enV4=;
        b=gRFMWGRV679EnrEa97VOzdEROEYS/7ag1/y62hi2yQZKwt03udWmgCOL0EZyPkf1JX
         mNEAbp5te7+xGjG3szAqfNYflaOGvyCBXeK9GqDPbTRQr1dwiQrFH4HAx9CYWRlFp3db
         f5DiR87GUPhuPtK+Zw2DftgMf5HIgt2O07v+W1W+B2shNGMO8V/neKFzoRa9xaUZrtg7
         CJhuUjPBMk03hPT/GvKThoXRCCjwXgJULD1N11QQpvnNXraAwfmFoiW1N+vRgFur10jE
         hl0oroy7/vZZ/8PC2NTLiltySbAUpzvGMXYs+WbmkfrnLGS/bFZMbmbkDQ8gzmQyxjg9
         BKLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759205649; x=1759810449;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uk5+wyHN7CkT7HC+T4CiL8GLFFBvq7A2wJEeem4enV4=;
        b=LnNeOxzQxGO14cBm4x6vvEDVzj5JuphGe1pGCq9QyommXsxFobojxr5hN2YeAwgdT0
         jO7o5csV59h+rZGBADuScVyHHu/iq+l1JqjSJb++LIxLdf2h13kyk4mm2pUtbcLY3M5D
         Z32CYEhHDfdMYCdUowIZ2eUs111Y0DGpXIJcyvx2bptuV5vgLvQWbS03eMyLkoUlILqm
         NIJMny27I7G5n1IjhAcJhRf7BeMrY624EBb2re4gsz4xs+HR2WNQwDeAoMf6AHbwpDVB
         ygy8a0Sjys6QjDWR+FFF4y5SPIirHDjRkQVMdX9jMR1hnFfx1bzPrs8OtL8Ck1wErIoC
         O3sg==
X-Forwarded-Encrypted: i=1; AJvYcCVhf6C7fEWAftF3tmkzonWKsAGhzNebL5LgBHJqmfGcQ+fcneoTMANUWvT1ZQbZ7oWfEik=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjTIuEVuTxPSX2yFZA0nXR9qILS+YtsmusHlA/UiP/xAk72mf6
	tV6aNrstcgrHXQzEka5XAujGvSWRd/oT+O+k/P8YfLFLh4s5w8Vw5KF92ykxpCsJ+Ag=
X-Gm-Gg: ASbGnctWqH2fJvE/oIbstO3xdyZx76McA1P7E5dgVkG+0zGnzwSb3KPfzLclzuNj1DZ
	1lUpoQXd1oLe93tcQZau2aDexrJRnR6AZTtRE64Tvo3EkPmr4tgHIyv7C2vskHYd+Wn4CL919Yc
	/cpVwVerIGmXMv3irk67FN/GSFT/PjpfX4xa0zfUMX56VIQGC9QCdHuD4auA78NUqJnSW08vXaN
	aXkuU1PDBqMxIzjevJSxuMRkl+sjUv5TR9g4GWBgxNhDkppLMhsUgiIhLvdqrzcE3FAD7+4TE8I
	DvRctKWEsnFMVJqL01uS1IRbQN3y68VvPhVrF4Y8BCxkOY2nUFktjfaZXjTUSBBcb38+HQNZ7sS
	EIiGAUBoSs7jPJkiBD8np1PngzYvkozR9JrhaP32spJdeKFTVC/Pls7iYthgs/DLCj5fqUgBqEo
	2UaTsFFSdSOSRq6OW0NeDxG6/416o54EQ=
X-Google-Smtp-Source: AGHT+IHVwaY6Q4s0F84QmaOmJAx4BK9ueW3Bbg0HpiOJvzkr7RtDJkQ0plXWj1SaEJLGINz1Ov7KPQ==
X-Received: by 2002:a05:6000:3101:b0:3eb:5e99:cbbc with SMTP id ffacd0b85a97d-40e458a9394mr12531634f8f.9.1759205648705;
        Mon, 29 Sep 2025 21:14:08 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e5b69bc0bsm5141855e9.3.2025.09.29.21.14.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 21:14:08 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Jason Herne <jjherne@linux.ibm.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Stefano Garzarella <sgarzare@redhat.com>,
	xen-devel@lists.xenproject.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	Eric Farman <farman@linux.ibm.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	kvm@vger.kernel.org,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	qemu-s390x@nongnu.org,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v2 07/17] system/physmem: Pass address space argument to cpu_flush_icache_range()
Date: Tue, 30 Sep 2025 06:13:15 +0200
Message-ID: <20250930041326.6448-8-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930041326.6448-1-philmd@linaro.org>
References: <20250930041326.6448-1-philmd@linaro.org>
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
index 546c643961d..dfea90c4d6b 100644
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
index 573e5bb1adc..70b02675b93 100644
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


