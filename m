Return-Path: <kvm+bounces-23719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 52D1B94D44B
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 18:13:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA5B71F2126B
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 16:13:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0857F1990D3;
	Fri,  9 Aug 2024 16:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DzLn74dv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CD819D071
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 16:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723219786; cv=none; b=EetaEi5ayarMEFgGgbqrJRPKQyJCkiHxA2ZAgW3h4GQHD1oQkfEOTi2cgbIEEZAGww788D3aBl4WGI+fz3KUc76Qq5wtd7XGKSHk65XYq0izXThNleEWCYhYFjECzzd4U9fAH6qIYpCzusvuYQWdHy35S7XmoKKqnNzTVU9bosM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723219786; c=relaxed/simple;
	bh=F3zrw7GW4L3DDhmifn0KqTitiZnPFDtSbk8TCndoYpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBbOTnIVqlGRNAdZml5aAhgw9HcURyIXPeibvwTOR6wGRnxI5Xshq/tJxNm89R6Ibm1USIxuxpOTjWkq/6wWktmOIj8tQBT7Ub7HmsKga4KGBTmFS1b3C+S4i1LGgBeAfETqhrFb7hz6JrVi0YAc/egjanA4uZ1qPkWNp4aDdyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DzLn74dv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723219783;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kaY3EfeA+k09YWgS+MfGM8qkjlv58srLyvVau/9jXnU=;
	b=DzLn74dvuR9SXv0dLM+3DF359zb3zRK69RemrXXjuSh0+28EwxbG9tvOE4GEnCgDRVdz8P
	SbLOjlpJkDt03IOafLHUxYl4wDgIhSI7eN875jUGHJJiGl3+Q/KMImDOXSgf99fJ7KJ8Do
	tsu9XwqlhrWWB3r/fbadlNaPut/YmsY=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-352-ml8DzDuIMm667dfu79W5xA-1; Fri, 09 Aug 2024 12:09:41 -0400
X-MC-Unique: ml8DzDuIMm667dfu79W5xA-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-44fea369811so4530231cf.0
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 09:09:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723219780; x=1723824580;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kaY3EfeA+k09YWgS+MfGM8qkjlv58srLyvVau/9jXnU=;
        b=Butxo7gH07NpbVfD0J6Ww3y4PZUpXZQxPv5SYWC73PzbVbuJCRrcTCJfsjfA9UMOqN
         IgLoAU27xbCORv6Gjsn8BVNsIPv+bir29Uz9Mw7MT7PTWbaY98yPTxrJrFSJkgBdv4g9
         4zZFvX5qH25W9v8AW6u4d1b/6RKeMdDO3wNqXy7tK7MCzNwuzyMYffOegMFerkTtGSnp
         Fd6Nrppz2WB2oHOpk1bifvlnzOu8UClhohhkqyhk+2OhO7/5eOi0jOJBokfH5NSXDtEu
         9+GSmBW5+lGiCtlJMAsBzUQdEMuL/6LU51sURHID7+Sk9DAhSyrOy1Ft314T4BmLLoa0
         rQjQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJ+kQcBwYTLQwCd4upu0alZIxtvTA93tahDzLTKBWPratCvhKS1U0978dgzpO5ti9/Cwot3a8iurOl4TDUZlowRcRM
X-Gm-Message-State: AOJu0YzJEQI1yaSP24w+4o6pUmp+3QOoTeveRPE0LFi9L8DBHuQHQ9il
	JMPHKhdUzYLcfmQacJ17zDvvzqEJT6VTU9x/xEd8NxQacjf08k7Wr+8+ChuK0P/NebF3RvAlUjr
	RC0PS+lppjb4IXzAOpbIpN07xZiC3um3/d+0fVM2U3LPNY4eQPw==
X-Received: by 2002:ac8:5912:0:b0:450:efd:723 with SMTP id d75a77b69052e-453125552fbmr13163141cf.4.1723219780554;
        Fri, 09 Aug 2024 09:09:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFtbIkutydCKQHHfrahTRflQkyMYGSh3zYrObmthmw14T659Ni251Xo72HIqIFQZU+hooLp2A==
X-Received: by 2002:ac8:5912:0:b0:450:efd:723 with SMTP id d75a77b69052e-453125552fbmr13162951cf.4.1723219780083;
        Fri, 09 Aug 2024 09:09:40 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-451c870016csm22526741cf.19.2024.08.09.09.09.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 09:09:39 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	peterx@redhat.com,
	Will Deacon <will@kernel.org>,
	Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	linux-s390@vger.kernel.org
Subject: [PATCH 11/19] s390/pci_mmio: Use follow_pfnmap API
Date: Fri,  9 Aug 2024 12:09:01 -0400
Message-ID: <20240809160909.1023470-12-peterx@redhat.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240809160909.1023470-1-peterx@redhat.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
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


