Return-Path: <kvm+bounces-59033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 29C10BAA4F3
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 20:33:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7EACB192247A
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:34:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C69ED23C4ED;
	Mon, 29 Sep 2025 18:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KNu44ptp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C1978F5D
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 18:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759170819; cv=none; b=Dvg1F3DyzTlBBuH83/KLT0uN2QtIBWwRSAvYyBuA90yfaT6+KwGCQ11NhfZea1ZOlQDFJ4/JD7vnex4Lh7BhBiBVeomaHGqBipfmc2IF9MXHEZ9g27Z1fXeqvLrlWKT9rUBBLFnOPVkX0xPGmmX60GsNp0pfn/LN8MYEYUmXLOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759170819; c=relaxed/simple;
	bh=tk1fcCe2uc8SQWNfNZeaf5rjjKf8QrHgGyefv91DT28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qwJzRKU6zddRRcY7s/gixlUGvD4cjNqs9Mhhz8CvTWExFgwjVxv35TFFjhCmgeG5V4un23hsbzdZq1SERCDAfC2z7eAwvuUEdh+ebcucBJ55DI5Rzx/R9qDz5mwgMBiB+QxLcKfrmOvnudUkJ7U1sDasoearYVslW5wItw9E33k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KNu44ptp; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-46e4c9083a0so17423895e9.0
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 11:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759170815; x=1759775615; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JRsfrHQBMjnrXhlxfeiXrXfyISPq/9LUWh417J9QSAY=;
        b=KNu44ptpJyYpCIUp6H37ZeyxngUfd6knkVtzZOrb2TenN/jby2021XYPmQuRFAV1rC
         3LM0DAbJPQpdUbKy/XgLcDv4BerEvwAY+lqioKe/AsEwuUQStOxeX7YrUmPdUqlnfIk8
         9lGZebo7UNvTzOMxjQMG30XiGzoAH/nrMSomjUDMC63ePo38uVb9NDfM8nSV1XS5Xppv
         59uTwqKQur5CKhRyJK/aoC7/qFFy/umv7lCXps+njGNCI6P8UqBA1RyRhwTJol9TyVew
         62Up439FwaTsdhITlAIxbakgSmUmIZVA57QHed+1SCEruh/ilwO0IlgrPUh5zckw/WPE
         rN1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759170815; x=1759775615;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JRsfrHQBMjnrXhlxfeiXrXfyISPq/9LUWh417J9QSAY=;
        b=fOUA3bKs69ew0aE7fASIV+NuQ7A4Rr+9/7RFK17sMOSNSrwOgA6p/417e0L6mfCy76
         OZJCtRrp3tAQ0SuZGoOWfMAvWdBStmCpshOd6H16ASGcUaaWI0tmvSRsHfv3VyqmZ9hE
         4p2bwOjv61tfovLU0xALRqXDMToHHfssBFuTpPdLboXUzJnU+g3bxVsXY6GDTiaixNlG
         YbCtQSvtwAa3BIcwNX/RGPhi1W2eoeIlm3oZbfKWHDrL6bgitDLhZ5Icd1gaoeZXSPpE
         nHp8Svd4d85GQX3G1JHfK9VB8aYQe/Y6w/o6qmyc2X/u+OR4rfUJ4bg3JmfrPSNpcgv2
         clwA==
X-Forwarded-Encrypted: i=1; AJvYcCWyzUjfLQhWX0ElzVQX0elPYAiCFqDOw/hpI3Lc6WVt/MAlx5G6tyYVNW35lYU46rqpIwg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzT2+mAvFBYmpfldTXJVna8zsPgDuVj4ASRrHp7X0w/GPRb//o
	xOCmm77Wkchmx6pRAAHP9DR9MI3r3SXB0CMfRVLa94hUN2GbVyaplDMBTvBrUivPuaI=
X-Gm-Gg: ASbGnctuWOLZTcVT3S6CaL3n8Rmfp9JywVuJfDgHOP0uPXCCvMelOsi1+HkOSlVQ86W
	LTNWDnSGcEBtGkipWXhGEEdLLNmjeazUZU10UNC7NjC2wVAkKXnJbDJzO3VKZtaoaQGgfFtwax4
	k3FUxowxt35+YNGFD9Jo154JaEAaDrJ2cUR9B+aZAS1tWiDFJGcKUt26AJQB64CAQM1gjmMfPO/
	TggAIgRyLfHmKLzTe2l11lg2PXtDCUpRYhjSVLntbFVh7RdhXy6lA14dsf2fTweVuA4FSTwnhhU
	Iv15onn03RDrQijCLTSBFjZ7ekwwZyeTmqKrsWlevFzjZS6Bh8gNGiu5NImvy4Q/6coaA2j44JZ
	/tnXAhIsykYBKoBVZv56/LQMpT9bd1WtpNsWCfGq8bTc8koD2emdk5BN19seM1xzaPt84UOHWqI
	29DYVGgAU=
X-Google-Smtp-Source: AGHT+IHnK2dcf5REXjP75RtjLmG0FRF3SPCN5/ScyVADUNX4W97Ctb9XEl/zwwWPFNLidNab3G3GOQ==
X-Received: by 2002:a05:600c:8285:b0:46d:c045:d2bd with SMTP id 5b1f17b1804b1-46e58ac80f9mr17543845e9.8.1759170815433;
        Mon, 29 Sep 2025 11:33:35 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2a996c03sm236802335e9.3.2025.09.29.11.33.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 11:33:34 -0700 (PDT)
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
Subject: [PATCH 07/15] target/s390x/mmu: Replace [cpu_physical_memory -> address_space]_rw()
Date: Mon, 29 Sep 2025 20:32:46 +0200
Message-ID: <20250929183254.85478-8-philmd@linaro.org>
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

When cpu_address_space_init() isn't called during vCPU creation,
its single address space is the global &address_space_memory.

As s390x boards don't call cpu_address_space_init(),
cpu_get_address_space(CPU(cpu), 0) returns &address_space_memory.

We can then replace cpu_physical_memory_rw() by the semantically
equivalent address_space_rw() call.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/s390x/mmu_helper.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/target/s390x/mmu_helper.c b/target/s390x/mmu_helper.c
index 00946e9c0fe..4e2f31dc763 100644
--- a/target/s390x/mmu_helper.c
+++ b/target/s390x/mmu_helper.c
@@ -23,6 +23,7 @@
 #include "kvm/kvm_s390x.h"
 #include "system/kvm.h"
 #include "system/tcg.h"
+#include "system/memory.h"
 #include "exec/page-protection.h"
 #include "exec/target_page.h"
 #include "hw/hw.h"
@@ -522,6 +523,7 @@ int s390_cpu_pv_mem_rw(S390CPU *cpu, unsigned int offset, void *hostbuf,
 int s390_cpu_virt_mem_rw(S390CPU *cpu, vaddr laddr, uint8_t ar, void *hostbuf,
                          int len, bool is_write)
 {
+    AddressSpace *as = cpu_get_address_space(CPU(cpu), 0);
     int currlen, nr_pages, i;
     target_ulong *pages;
     uint64_t tec;
@@ -545,8 +547,8 @@ int s390_cpu_virt_mem_rw(S390CPU *cpu, vaddr laddr, uint8_t ar, void *hostbuf,
         /* Copy data by stepping through the area page by page */
         for (i = 0; i < nr_pages; i++) {
             currlen = MIN(len, TARGET_PAGE_SIZE - (laddr % TARGET_PAGE_SIZE));
-            cpu_physical_memory_rw(pages[i] | (laddr & ~TARGET_PAGE_MASK),
-                                   hostbuf, currlen, is_write);
+            address_space_rw(as, pages[i] | (laddr & ~TARGET_PAGE_MASK),
+                             MEMTXATTRS_UNSPECIFIED, hostbuf, currlen, is_write);
             laddr += currlen;
             hostbuf += currlen;
             len -= currlen;
-- 
2.51.0


