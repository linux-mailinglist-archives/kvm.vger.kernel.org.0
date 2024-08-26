Return-Path: <kvm+bounces-25091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C956095FADB
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 22:47:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4833D1F23F2C
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 20:47:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F89C19AD8B;
	Mon, 26 Aug 2024 20:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CEepY3px"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A75E19AD70
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 20:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724705063; cv=none; b=R1dcVDTKh8oBiB5KALP2ctKf8PRk9Zw7Ao9ECuC3AwCPyykZlPNSsdg6KhGVBlMX/5H+yvC6V9T5wSjHSfLf5KIV/lR7mma3or9mrZNhLoig8Uv4t7+l+2cWjJOHCG/aLgBHwGEH7HFOAQGwAuAjY80Ke4PD33Th2zOBiGeQb2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724705063; c=relaxed/simple;
	bh=F3zrw7GW4L3DDhmifn0KqTitiZnPFDtSbk8TCndoYpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKKWG2XhbTqF1y1NozHH3RSa5K2VksDuDSoruIUG+qCCaR4tRubwOC1R4wFfnFtlXJxz4vuEnlr+XtjzppcwJGcuvkVwFJYlWyayaG+5kScQtKZSh/DKend8fRdCykGWRWDMZwOWL2xtaIHTgP5gv+QQZIgAShNHvMfrI/n1Y/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CEepY3px; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724705061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kaY3EfeA+k09YWgS+MfGM8qkjlv58srLyvVau/9jXnU=;
	b=CEepY3pxevilkMXy6m+MxhWH0JyC8nmTA/XhdMqGH/2HlbICCUCsx3wz7L8oYUtDoN7ZmX
	WSmiJbH3wx9P2OwWeBA9Jehz4kKiyaTWg19O2JaiUhERxxq06l8szczNhJip6oCwmXdrYp
	2SyxlT9JDzvecjG7BJa/cX6ZkUChiA4=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-522-LmGor_ZEO-WoBfIOuuKR6A-1; Mon, 26 Aug 2024 16:44:19 -0400
X-MC-Unique: LmGor_ZEO-WoBfIOuuKR6A-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-270475308abso7796439fac.0
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 13:44:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724705059; x=1725309859;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kaY3EfeA+k09YWgS+MfGM8qkjlv58srLyvVau/9jXnU=;
        b=LNOXd2g2Vj2EdWntGDx9shZ/2NKAMJErLgf6TUthOiL70QflD4XraK4NIwulyZPKX8
         0bxDzfbmWGSl6Q2QdhHt1hHQSyTDyLuUwilFKXXBKIAVSxt8ouTFOyRzquioqgP/5YBc
         jSJ0gIWrC/PmqKrtna6GjZqKXUDQ9jCgoB+HNoy4rtAjqzBIs1olhPu5fQdal6V8YQl2
         OkpGweQpV6aDaOIx+sqmfYPiDfYPw8RkT4KoHhSMxM2yOrs39EIdJ7dFPSPelSRgzu4Q
         61CLzpQFU4hatm9ZA/nVmyREAQKdEM5ksX5RjcbRzC2Df5wrg/gzvEsRIzAzFZB1K3WG
         F46A==
X-Forwarded-Encrypted: i=1; AJvYcCXijHdFlLdCn7w4Hozh5m7WmA4Te2MUBeDfGa7d3l/5974HZSlkl7FH0/SME01YUwgJCoM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKsbdnmq2/c8GIzjHHuNbCiYJdNVRLh6epXNydtTwXcSt8gfju
	TmjoN+0wBIfc5p5fXDJelgDwL+mXXcwfWICe4iGi+s6d3XivTDkJr7n8B0bR6ldofuCHGtBo5jQ
	MB9W0IT3sGwefddeT1p2Sv8zgJCUN7gqG78p8uygdS3ZG8LFG2w==
X-Received: by 2002:a05:6358:7201:b0:1ac:f3df:3bde with SMTP id e5c5f4694b2df-1b5ebf3abdcmr117738655d.5.1724705058975;
        Mon, 26 Aug 2024 13:44:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHztBftH8jfc2wrFWJQjc0BC5uJ0IwQWlV9Rpv0YGeitSfcFoHRh3KGrU0k5GaslF87BwNh3Q==
X-Received: by 2002:a05:6358:7201:b0:1ac:f3df:3bde with SMTP id e5c5f4694b2df-1b5ebf3abdcmr117734755d.5.1724705058531;
        Mon, 26 Aug 2024 13:44:18 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a67f3fd6c1sm491055185a.121.2024.08.26.13.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 13:44:18 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Gavin Shan <gshan@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alistair Popple <apopple@nvidia.com>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	peterx@redhat.com,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	Zi Yan <ziy@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	David Hildenbrand <david@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Will Deacon <will@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	linux-s390@vger.kernel.org
Subject: [PATCH v2 11/19] s390/pci_mmio: Use follow_pfnmap API
Date: Mon, 26 Aug 2024 16:43:45 -0400
Message-ID: <20240826204353.2228736-12-peterx@redhat.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240826204353.2228736-1-peterx@redhat.com>
References: <20240826204353.2228736-1-peterx@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the new API that can understand huge pfn mappings.

Cc: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: linux-s390@vger.kernel.org
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/s390/pci/pci_mmio.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
index 5398729bfe1b..de5c0b389a3e 100644
--- a/arch/s390/pci/pci_mmio.c
+++ b/arch/s390/pci/pci_mmio.c
@@ -118,12 +118,11 @@ static inline int __memcpy_toio_inuser(void __iomem *dst,
 SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, mmio_addr,
 		const void __user *, user_buffer, size_t, length)
 {
+	struct follow_pfnmap_args args = { };
 	u8 local_buf[64];
 	void __iomem *io_addr;
 	void *buf;
 	struct vm_area_struct *vma;
-	pte_t *ptep;
-	spinlock_t *ptl;
 	long ret;
 
 	if (!zpci_is_enabled())
@@ -169,11 +168,13 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, mmio_addr,
 	if (!(vma->vm_flags & VM_WRITE))
 		goto out_unlock_mmap;
 
-	ret = follow_pte(vma, mmio_addr, &ptep, &ptl);
+	args.address = mmio_addr;
+	args.vma = vma;
+	ret = follow_pfnmap_start(&args);
 	if (ret)
 		goto out_unlock_mmap;
 
-	io_addr = (void __iomem *)((pte_pfn(*ptep) << PAGE_SHIFT) |
+	io_addr = (void __iomem *)((args.pfn << PAGE_SHIFT) |
 			(mmio_addr & ~PAGE_MASK));
 
 	if ((unsigned long) io_addr < ZPCI_IOMAP_ADDR_BASE)
@@ -181,7 +182,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, mmio_addr,
 
 	ret = zpci_memcpy_toio(io_addr, buf, length);
 out_unlock_pt:
-	pte_unmap_unlock(ptep, ptl);
+	follow_pfnmap_end(&args);
 out_unlock_mmap:
 	mmap_read_unlock(current->mm);
 out_free:
@@ -260,12 +261,11 @@ static inline int __memcpy_fromio_inuser(void __user *dst,
 SYSCALL_DEFINE3(s390_pci_mmio_read, unsigned long, mmio_addr,
 		void __user *, user_buffer, size_t, length)
 {
+	struct follow_pfnmap_args args = { };
 	u8 local_buf[64];
 	void __iomem *io_addr;
 	void *buf;
 	struct vm_area_struct *vma;
-	pte_t *ptep;
-	spinlock_t *ptl;
 	long ret;
 
 	if (!zpci_is_enabled())
@@ -308,11 +308,13 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsigned long, mmio_addr,
 	if (!(vma->vm_flags & VM_WRITE))
 		goto out_unlock_mmap;
 
-	ret = follow_pte(vma, mmio_addr, &ptep, &ptl);
+	args.vma = vma;
+	args.address = mmio_addr;
+	ret = follow_pfnmap_start(&args);
 	if (ret)
 		goto out_unlock_mmap;
 
-	io_addr = (void __iomem *)((pte_pfn(*ptep) << PAGE_SHIFT) |
+	io_addr = (void __iomem *)((args.pfn << PAGE_SHIFT) |
 			(mmio_addr & ~PAGE_MASK));
 
 	if ((unsigned long) io_addr < ZPCI_IOMAP_ADDR_BASE) {
@@ -322,7 +324,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsigned long, mmio_addr,
 	ret = zpci_memcpy_fromio(buf, io_addr, length);
 
 out_unlock_pt:
-	pte_unmap_unlock(ptep, ptl);
+	follow_pfnmap_end(&args);
 out_unlock_mmap:
 	mmap_read_unlock(current->mm);
 
-- 
2.45.0


