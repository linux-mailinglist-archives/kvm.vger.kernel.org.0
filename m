Return-Path: <kvm+bounces-41103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F2B21A617CE
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 18:33:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B5D97188405C
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 17:33:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7C36205AB5;
	Fri, 14 Mar 2025 17:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="L89ZKHTy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606E2205AA1
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 17:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741973525; cv=none; b=FB11lrHA/WkUAF5h96STwB26Y8uNRAmyp08s/upNvSmgCo5kUidQQuhulZ8J6h6qfP3Pub5d8CkGvPvocDyP5LUXmEINoVAFE4UcT313IDbEa8degu/gkgUuzdgJcwmjGxFKmjzIwh0zxJ/bxplH8d8XkmiG+tJ9pPGm7L1ZIFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741973525; c=relaxed/simple;
	bh=IelyUoYuqLIAw6DPSyagCvFpNJxQiv+t0JYUBox7DYg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jQYlbv2oT6s1JhVCzWOY6c0pcAgJTA8qO+wKtpJp8CcCjxAfzZCcQhLslmZqWqMReHkx4QwWMPA2Bv48rMpsxszx0OqVD56p1Kro7NHHEnez4mtVkcQh5js4VQsgitlMKVZilq/X4yZ3Oe6NjND6GyL11HEdrBPOHY3n9J+5Img=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=L89ZKHTy; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-225df540edcso18254585ad.0
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 10:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741973524; x=1742578324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EBRugwqnxw4q7Phz2P050i5IjB6Zbf1WGwdoEilqtkY=;
        b=L89ZKHTyQ+xy41cUL5BiN5R8Z7udAInqmSm8iqqpc8WhaUQsi8hAn+IKrZS3OkGhRY
         wJBO7bXrRDSgGe2yqDz5oHYP/IZFmu4C74095ml3n9C5AOYjD4G9nxzYNKTkJ3AYZwXH
         S/EvY1TSuT5sdNAtntzlWuhQdylO9U4+TOwNQpK9AgFqghLw7TGYJvJS3YlI34hVNp0H
         5xHMNto0yYmq2Y/M6WPWVsIC7b9dbzR6VZUVlLlK4KLWTC+Y4f+cBVWKT0qqq3Wmh4hC
         Py6FrI92rd88hfpsYJ3IUPRfgnrlVwticpXg+c1WZ3gAJ09RQVRZPDaYRmmoxeKXsWyh
         29cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741973524; x=1742578324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EBRugwqnxw4q7Phz2P050i5IjB6Zbf1WGwdoEilqtkY=;
        b=V/IN5eal/48xc0UwnL97G7ajFJM0KtGXf7NTshK39RATRVH4dLIFZrw9mi+rKiRTbV
         pIxwi3rNZVnrDs/xOtWbnU559b1z9tkJuWnAODGNucsWnGsC/5ZCZ3GsuxQQ0MS3crLD
         kp5duooyx7+FRRXI0KDSQ9L0Pa+OgAS7n35eccCR48qMq57SOlVNv37gkhTa1UuwZVDs
         4c6By7HK9eGx2//Xt2CNv2FlzY05bM+pkt0cKdkhamDKQ8b//ZZDJ+ax9JCTzB/V2fUF
         QFZFREc1nV1aQrJmU8IPZJkWPUtRzcImceuOVH/pe2nYK0vdOQceGkiyMoiDOMlPJnax
         5ofQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQLhmlqbabJfz4KefYE+zXhqe95u4OSsqVqOHRG53g7Op+05LUTT/CJ77mHkdU9NKDPyk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqWoVd3QUdnr+ERjDjlLRz9mMeCxClqNdotrQTbPkmGdtpvNr1
	dSYLIgG+UEVZHwi/vHZOz5KYB3mmOVejZTzg1+5xWJbq2KG6NVqW1CAq2Q0okxw=
X-Gm-Gg: ASbGncuuzJGV/Sp2M3/RWHGkB+qE79yz8KKz8CFHPF9DT/I5t1HPpNQxx5b4KBL8wz2
	egrJZr5zex6CkjBYGHY0PYHWgEdO8nyneAVdRPXRIGGJ+tVP0pQ7cG/EQ58gIyDHpbiEJXWD/wE
	YsuLKPhkJIiwVD3fXlMwh8SBCtEFgGhQJhyn0tKBU0NvigP+YbH9Is4ADNsfJE/zzxWjI9F6xvX
	kHKLVPNZ+aoJzS0eb3RLMf+2Fnwn4CL9x8auKBYegzeJZImBzmLfw+zcEqTMcV8I32D1aUfuYBI
	sjofytQOWRR9J/0T78Co5KNzY++oJ0k3oC8vwQNKjiHfeivipa6c1Q8=
X-Google-Smtp-Source: AGHT+IFTScYSX7clzsDQUywbpsrF2iPQsXcqATUvOkRpCep5DuIqTnkqpSfhY4o7FVAe26d7sGjRdg==
X-Received: by 2002:a05:6a21:1583:b0:1e1:a449:ff71 with SMTP id adf61e73a8af0-1f5c279ef94mr4638551637.1.1741973523678;
        Fri, 14 Mar 2025 10:32:03 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af56e9cd03bsm2990529a12.8.2025.03.14.10.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 10:32:03 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Paul Durrant <paul@xen.org>,
	Peter Xu <peterx@redhat.com>,
	alex.bennee@linaro.org,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-riscv@nongnu.org,
	manos.pitsidianakis@linaro.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anthony PERARD <anthony@xenproject.org>,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 16/17] system/memory: make compilation unit common
Date: Fri, 14 Mar 2025 10:31:38 -0700
Message-Id: <20250314173139.2122904-17-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
References: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 system/memory.c    | 17 +++++------------
 system/meson.build |  2 +-
 2 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/system/memory.c b/system/memory.c
index 4c829793a0a..eddd21a6cdb 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -353,15 +353,6 @@ static void flatview_simplify(FlatView *view)
     }
 }
 
-static bool memory_region_big_endian(MemoryRegion *mr)
-{
-#if TARGET_BIG_ENDIAN
-    return mr->ops->endianness != DEVICE_LITTLE_ENDIAN;
-#else
-    return mr->ops->endianness == DEVICE_BIG_ENDIAN;
-#endif
-}
-
 static void adjust_endianness(MemoryRegion *mr, uint64_t *data, MemOp op)
 {
     if ((op & MO_BSWAP) != devend_memop(mr->ops->endianness)) {
@@ -563,7 +554,7 @@ static MemTxResult access_with_adjusted_size(hwaddr addr,
     /* FIXME: support unaligned access? */
     access_size = MAX(MIN(size, access_size_max), access_size_min);
     access_mask = MAKE_64BIT_MASK(0, access_size * 8);
-    if (memory_region_big_endian(mr)) {
+    if (devend_big_endian(mr->ops->endianness)) {
         for (i = 0; i < size; i += access_size) {
             r |= access_fn(mr, addr + i, value, access_size,
                         (size - access_size - i) * 8, access_mask, attrs);
@@ -2584,7 +2575,8 @@ void memory_region_add_eventfd(MemoryRegion *mr,
     unsigned i;
 
     if (size) {
-        adjust_endianness(mr, &mrfd.data, size_memop(size) | MO_TE);
+        MemOp mop = (target_words_bigendian() ? MO_BE : MO_LE) | size_memop(size);
+        adjust_endianness(mr, &mrfd.data, mop);
     }
     memory_region_transaction_begin();
     for (i = 0; i < mr->ioeventfd_nb; ++i) {
@@ -2619,7 +2611,8 @@ void memory_region_del_eventfd(MemoryRegion *mr,
     unsigned i;
 
     if (size) {
-        adjust_endianness(mr, &mrfd.data, size_memop(size) | MO_TE);
+        MemOp mop = (target_words_bigendian() ? MO_BE : MO_LE) | size_memop(size);
+        adjust_endianness(mr, &mrfd.data, mop);
     }
     memory_region_transaction_begin();
     for (i = 0; i < mr->ioeventfd_nb; ++i) {
diff --git a/system/meson.build b/system/meson.build
index bd82ef132e7..4f44b78df31 100644
--- a/system/meson.build
+++ b/system/meson.build
@@ -2,7 +2,6 @@ specific_ss.add(when: 'CONFIG_SYSTEM_ONLY', if_true: [files(
   'arch_init.c',
   'ioport.c',
   'globals-target.c',
-  'memory.c',
 )])
 
 system_ss.add(files(
@@ -15,6 +14,7 @@ system_ss.add(files(
   'dma-helpers.c',
   'globals.c',
   'memory_mapping.c',
+  'memory.c',
   'physmem.c',
   'qdev-monitor.c',
   'qtest.c',
-- 
2.39.5


