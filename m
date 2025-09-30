Return-Path: <kvm+bounces-59110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DBE68BABFF5
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:22:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 30EEF3C5EA3
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 08:22:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B8A02F3C34;
	Tue, 30 Sep 2025 08:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vIAw4JDw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A740A23BF9E
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 08:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759220530; cv=none; b=R4Fj+WXjM6vTaRxJAYhWflfT9DnNeNf0EZn2A6hF/yNiSLzpOL3ctja9yWYba4BP30VYPzkUGGE1WJNV5CL1P6VlXmqMOYPFfa/ujA+XmogOmMzKASipEUdIU04gYsyVgDUAjj2vEFWMXMNZ5EdwSJuY40YsNb8nf34RQYGG1Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759220530; c=relaxed/simple;
	bh=G3gJOonCNyr27uwdLswyzbBeO0+MQB9NtbZ2FzOJhtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lldKTcOmNbv1WcN3YIbcy8gfZj5M6tULYm6xzKsslb6/YKCsIi0xEn6TJpdPRaelv5roJDDnis/d+tHCGuO4WO8GUxeL9P9O8YLPVqhfPPSamhrKIEYNnjcV8tfyzO4Z1BwmBgCJRFs0MseA4m8JDLiIQwsfxtBgJ2Mxtd8fZKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vIAw4JDw; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3b9edf4cf6cso5136888f8f.3
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 01:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759220527; x=1759825327; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YkYmQo8nriy/yGfh4HWmKxNmJbyJBkEcEbiWP0BNxvs=;
        b=vIAw4JDwtxZRFSrtPrFnZuXmShqY1MNxKRArzgTy4VhZB28T6q3aBF6yBb9I+zbbUD
         HMj/hBPkLwrwJjrJ6JloMmgwlDzyOdkfCL05bH2X+VCzTRWbWz0RQSNNG1Z/YpkSNJ9t
         LvtdWKKKTgR7urFSy6OlOtiPP8i/MQAkj9dcsV5NQAeTWuxnDNrw2yCHiQ5FJpmLFdhh
         EsyZ+2zKnp0Jo6VxeF2Yz8k2STOS85Bq6foYABX9FLuK0ZWq4+BMI7+QmwwGGti3wvXm
         d7qnJp2XionXK+NcqbB6S7uHWAYTskZMU1OBLq2CJnIRrrbxDR71MuO/TwQ1odFZ9Yet
         s9Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759220527; x=1759825327;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YkYmQo8nriy/yGfh4HWmKxNmJbyJBkEcEbiWP0BNxvs=;
        b=Ll3cHjaJ07pAd0R0UhpZ7w1yo79uCtO9ItNnPNxG6XVeHiyzFbIocy7+o9McHBcZbC
         y+ueJz3P3HB3NhFFBGhqU15ON4IjeKyXSMt2SP6UMVzkTWR7950y/8iWyzkHL5wLCgTc
         VNBqeXlwijsfOjBjtr6RtZt7GLF/Ro6QZ4AT2OHdrAUFikX8kigfH+n0dLNn7DvVFbqH
         XcxkXHx1filSk4W0t/Q2jJWIZeOFFiTNGvJon2PXVJZAIgHx2tY5SALZkloBPfZ5XI+Z
         EoETULNMqznx4lTvTD+1IzMFuHJG3oRi9WiUoE6lq3pqH2zuGWp8RQJWRmurpDfMqic+
         igSQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIa9wc+MHcwSVI87tH9RniL+QwINcw34gD8cfax4Ur7OcplgmyPxluzYRFwfiMdJH3cXg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHPfWCVIkm1Myz1ijQ7iHYqK/PqfRLgQBdscVRYpLoZgfYtPwj
	A9gwDqAB7wapiNP3QZ43madqc7ve+qyoYjCAm3FXSNzVoG36O1kaBpPF+F66MMjuGQ4=
X-Gm-Gg: ASbGnct64rTksgflScQkeJo7fICg5sHLMUXEzHVFVKQARbOJ6TU8cK4jVJikU0ow7Te
	9tHc/Laatittj+LRdQptAMyLfBpWhGEZcyNTchNEg8IWCdYsy5NNaxQXP9Yorwy8naDWhk62ZYq
	Wd3FSx5zwTFMDkxjoOTZUUz6bYxozi9WNnnylv7MuSpkRqBRcgsi37qQrrK1uoFBBjaQ09Pc8yD
	RimQkU9kTHVVrmcscv2yh3WHY8EoKz7MHn4OO8YpnOgIg+Oh6f9PnBNngUYrhpS0q90gg18e8Ty
	rPjABEr1a4S9UMf6KHDlVImRexle4yTv992zveurkMxjigsxs3M66B0gcXNAMYjB6AhoeFifRNt
	49kklafoAYFWTfu0In+p6WqpwR52DkuQ9YWQXspfG6II+ddOTHWpRC9sJSanSavEBVPXXy7lGpE
	LjurTVOqVTXXI8A/l0AZV+2SRuVwhklfWFn+wsResPeg==
X-Google-Smtp-Source: AGHT+IHzRQHYpgb/DyIfYTEXGiArYWqeYdxWvyGmM8w8s+84+M4R5T3PN9QeVLlNgQQ0W4P8WfSxtg==
X-Received: by 2002:a05:6000:26c9:b0:3d2:9cbf:5b73 with SMTP id ffacd0b85a97d-40e46515110mr15910423f8f.6.1759220526791;
        Tue, 30 Sep 2025 01:22:06 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc6921bcfsm23056408f8f.43.2025.09.30.01.22.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 30 Sep 2025 01:22:06 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	kvm@vger.kernel.org,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	xen-devel@lists.xenproject.org,
	Stefano Garzarella <sgarzare@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	qemu-s390x@nongnu.org,
	Paul Durrant <paul@xen.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Jason Herne <jjherne@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v3 07/18] system/physmem: Pass address space argument to cpu_flush_icache_range()
Date: Tue, 30 Sep 2025 10:21:14 +0200
Message-ID: <20250930082126.28618-8-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930082126.28618-1-philmd@linaro.org>
References: <20250930082126.28618-1-philmd@linaro.org>
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
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
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
index dff8bd5bab7..e0c2962251a 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -3215,7 +3215,7 @@ MemTxResult address_space_write_rom(AddressSpace *as, hwaddr addr,
     return MEMTX_OK;
 }
 
-void cpu_flush_icache_range(hwaddr addr, hwaddr len)
+void address_space_flush_icache_range(AddressSpace *as, hwaddr addr, hwaddr len)
 {
     /*
      * This function should do the same thing as an icache flush that was
@@ -3230,8 +3230,7 @@ void cpu_flush_icache_range(hwaddr addr, hwaddr len)
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


