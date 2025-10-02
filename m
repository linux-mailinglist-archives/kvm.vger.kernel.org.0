Return-Path: <kvm+bounces-59408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDB65BB3575
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 10:52:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 420D017E3A5
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 08:47:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 021BB312836;
	Thu,  2 Oct 2025 08:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NgoBq6/S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574062F0C61
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 08:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759394557; cv=none; b=vCd0ZwdW/xeBPd7lHP7UPd07NvGHouZJ6Bd0eVkXSd6WhbnjGw1iPnYkZj48KfsEIrkcMTMSc5l+o0HUcw+KIV/3J3clk9q0CBiFUXWbjCO5V65OF6v6A004Zt7XDQYglyNSys37BUPk+aO2TROpgL/F6BcHYrHW+8dy0eePM6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759394557; c=relaxed/simple;
	bh=K05PFhFXAqhs5DUNp0q79ztNGBOU/F2vj3Qb+uthGDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IBQgZKsBaa5cA8nCH88E7oI4XWk1MxRaKhfLXXRs5tfrAJsEV5IK2p5uV3cXOr5XGkxs1ZsisMdQqRgEXUBqFt9CcsSBFqCoUtUOPaYAj3ZLrjjZawFbzpkondn/RQxWQdyioYJLhfsmjHE5SVhS27O7l1rwgXhmQoG2adfm9Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NgoBq6/S; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-46e4f2696bdso8988915e9.0
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 01:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759394554; x=1759999354; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q36ac4tAhT01s84agsdvLvLQt0ctAJzIb51YlTVbcXM=;
        b=NgoBq6/STxPQN5vMrB8IASDpEuHUNZfEU6rhT0H+97BhZ0uHZdZww45FyGkUwgbtBH
         D/q6UBL263DZOAxpao04kfHYB5II3VSYjTAiypXvhO6NtkJEJLshrZ18cq8UYdLmROCr
         uu+rbVaP3kvSeFFEJiZbWibBQdfKatGGUUiW/k1L7WJyrBod5B68R/Hr5I6K4iRgaK3I
         L12kdoZGxMdthoUJy+Cdyhl+KMnLoREmCwVVbHOW7Un2p9eRtJ4ZV72inb7fpk30wF2L
         Uj+IRl/n7xhC8Svku+GUxIx+yQkBh3C/TncpqbnE487cAlMRhRX0cfRVHWrF798M3UjU
         Es/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759394554; x=1759999354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q36ac4tAhT01s84agsdvLvLQt0ctAJzIb51YlTVbcXM=;
        b=spJGEdh5Lt95s9ik3C3s5eYS6Z3f4pGIINYaE8cxkGjo6NNJ4704dQNSoc6vOUKK7F
         ULZMDIOZtr3YN47u04VxFyAtnjW3wUHrJKlRhNfcyVsDtNgYxqjZYewlLg9M6aSHnsEz
         jB+zko5WP/KXirt6sV7nrpbUKkBCJTCtOgBP5U61UPaAjgL23K0Xta/vOF72sRq9NHvl
         vMODQjuGyzwYwRcr5vIooHv/sO6qMn8jfjCHtdoNcQexqN01gO8sG65PfZ1hyzIkaQ2z
         Ip2pmjQLlV7HQLMiWPtn5QT72R2uDj9PCTfO2SzVKyDUDUeKmgQVGplaw20dfnhiEuwM
         V1bw==
X-Forwarded-Encrypted: i=1; AJvYcCXztGOmq9UVi6xweBPXE39hh8lQC6ZwYkTBt1aWUrmLjorQrXdU3C/dknoCN8cfF7/LA3c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz79YnMyzJnuwSrad68hYMThhGlRMnwM4sUddSNq6VYgeIy4usW
	YTGRdO0mFA3haVy1V51dF2iAdci5/JzongH54qiJTiSLSt693g7IkdRTTuiwtXMX3Ig=
X-Gm-Gg: ASbGncvOdiIOseSvDY/lLbPZtWsJAEVWPfcF83I1mlU0/HhOD9lSGcMvPcM56ZU7m2E
	58tid15Nt1nzfWj9xZfQgNQChacs/zx7WIh8xfRUXFgR/BXcTKaBrXUc4Rs+rb9NGD2gcNpmq4U
	MccWUFN0Lw1ZsxVYFWD5v4lPLr1QJFgfIRnyx31r+8Csb5trRWKGui0V1xIG73tGDHRzsmGx9X5
	QaiqZBq+Z/XibaJoa1Mqr0psXFdmLYkkeogjnrpBeV86RgRVUISEWElnTODgBliZU+0zX0y+Au3
	fdkzEsrcmOjx0RT1SCjtiKzHPUbxIg2eJ7fGtlOE+YdrbhAkSnAr5ml6DeDrO9TiwFeqSZ35mQS
	C7w/LhqA0bV5MdMRB8Ah8UbRww0rLcMR/c/+Jhka/tKKNft665MKZnAh54WKn9mAfCFPh9qmdgp
	LJJdpXH4+Op/FsdFybNoz4ovErWlaUqKiZY1tE13YP
X-Google-Smtp-Source: AGHT+IGvW2QY4XT4rE3gnCvd4C2svQ9D2UQ58ymAoAfIs0dUKEvFj1XA9d+49KzTkmba3O5b3qx94Q==
X-Received: by 2002:a05:600c:524f:b0:45b:8adf:cf2b with SMTP id 5b1f17b1804b1-46e61267b13mr46680795e9.21.1759394553640;
        Thu, 02 Oct 2025 01:42:33 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d869d50sm2773210f8f.0.2025.10.02.01.42.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 02 Oct 2025 01:42:33 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v4 06/17] system/physmem: Pass address space argument to cpu_flush_icache_range()
Date: Thu,  2 Oct 2025 10:41:51 +0200
Message-ID: <20251002084203.63899-7-philmd@linaro.org>
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
index 1b2b0e5ce1e..19c7ff393c4 100644
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
index 4745aaacd8f..29ac80af887 100644
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


