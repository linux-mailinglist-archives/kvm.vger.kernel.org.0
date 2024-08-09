Return-Path: <kvm+bounces-23727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CA26C94D45D
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 18:16:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4AD591F22CF4
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 16:16:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 785F919F48B;
	Fri,  9 Aug 2024 16:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cyAa6GFL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CBF19EECF
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 16:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723219801; cv=none; b=eCY6X0B2ZMduqmztL7CeYOiaE/OEukSZTBNJa6ApbsZlLghrSwDQ+fqUjTAQd17pi9PNCDNMHZOZIKE88UMs0tS2X1xYlsI6NagfuhOGMjejmykp97UoP9/iqXQNT8USRbjMAmq4cdoEznHOPw75oLZopdHcr1wrHtrwqv7i2Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723219801; c=relaxed/simple;
	bh=Dmoew7i8XEW+gHBA0zJyGyEzte9fLwrtktcen/8enVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HxsWBysv+A6vEkQGmibBKDCgpGHEC61Uu7buTi1+qZXM4jqL+fXonBS2YfqoIGWszEAFWeiEFbY3jZT+r7Oydt0qaf+nF+Ou4ZGrDjVmD+ax5q7BawiyUJ0W8pz2C/JxxUvJK96opCLpFPdvVF3lVU0cx/0E/REJnWO1zsQ+JnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cyAa6GFL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723219799;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9MPOki3YF/wyEgBnejzItxwjIF1moGifGifGb5OwzY4=;
	b=cyAa6GFLGHtlzcmKnPcY4J3slYxrQLW16267/YAdLhGoMkxswEZlf/p8HEA+JSDpmJeHeX
	QWaENn6DKc6zsqqZjThCWeb9xuC1e6GfmvLiq/X5UjOaztJZdUm3IAHfSCtHvIuq5DRI+L
	ZRHzC3pEr6KmjX6OEJmyU8Tj8JDxPTw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-367-AN3ttUz2OrSLrByOfQ0bMQ-1; Fri, 09 Aug 2024 12:09:58 -0400
X-MC-Unique: AN3ttUz2OrSLrByOfQ0bMQ-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7a1e1828321so6887885a.1
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 09:09:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723219797; x=1723824597;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9MPOki3YF/wyEgBnejzItxwjIF1moGifGifGb5OwzY4=;
        b=PilIKMhYCWj3C+B9YfccGYm1iG9F0UAd4bK0i7HaDuhnHoJTiZEOpqWB1/OjImLvfa
         BSR+Sj7f607ypVm60rrUoi4RMO0SGXuF4nj/dXLwjYqAEDcmju0N3TLFL9ypF/uWhjnN
         +f+7sNUMGMB4/3wvhKVjg+X56socZGPHMrewnfIl+XdDWfbrdTQ9n7D5MkI4RoWj8vof
         nXfF08KFh3/yhrV4t42ofGs89dZfmIcd7fCushJa6fIzZFQJ/NTHa8a2uvmOGXFOxKwj
         UvwBRV/Ns4t96yEa7NsdBpaMPAEUzUfJlKzhqu0Evfazw0Pzy6JQWWCmZ4QJsBCrarvs
         szAg==
X-Forwarded-Encrypted: i=1; AJvYcCVp3X+/4MRnikYBzplanpacqJHxWCbaRcV7EnJQXq8cPoRL/U+jzrxnpcaEkRkM6o+psXNxpEIa607gtz8DFVVJAMuW
X-Gm-Message-State: AOJu0YyFf5Se5q3VaiZMBGkQUS+amptnw60UN0lco4mFiueFHgqMb1JW
	GplBvOoZVTI/dbjK03O3jcmTyjJdVBniwBHI6qM6rw+k8id7RXPoOmJ5RDxURhN/XgwNVah3yvF
	E54suH9x6q1lLA73SOXmi8JHR+1TuBluKvAvBSV9Ys1qgKKNyKA==
X-Received: by 2002:a05:622a:1b8d:b0:446:58f5:e6ff with SMTP id d75a77b69052e-4531251d52cmr13544951cf.2.1723219797251;
        Fri, 09 Aug 2024 09:09:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJY3GNDsLRixrwL3Yd/1vgrL/iS2SbMHaD3fo6KrtERFLLt1PJ4ncszNtj/1mVMrjvOJRHSw==
X-Received: by 2002:a05:622a:1b8d:b0:446:58f5:e6ff with SMTP id d75a77b69052e-4531251d52cmr13544641cf.2.1723219796830;
        Fri, 09 Aug 2024 09:09:56 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-451c870016csm22526741cf.19.2024.08.09.09.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 09:09:56 -0700 (PDT)
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
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 19/19] vfio/pci: Implement huge_fault support
Date: Fri,  9 Aug 2024 12:09:09 -0400
Message-ID: <20240809160909.1023470-20-peterx@redhat.com>
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

From: Alex Williamson <alex.williamson@redhat.com>

With the addition of pfnmap support in vmf_insert_pfn_{pmd,pud}() we
can take advantage of PMD and PUD faults to PCI BAR mmaps and create
more efficient mappings.  PCI BARs are always a power of two and will
typically get at least PMD alignment without userspace even trying.
Userspace alignment for PUD mappings is also not too difficult.

Consolidate faults through a single handler with a new wrapper for
standard single page faults.  The pre-faulting behavior of commit
d71a989cf5d9 ("vfio/pci: Insert full vma on mmap'd MMIO fault") is
removed in this refactoring since huge_fault will cover the bulk of
the faults and results in more efficient page table usage.  We also
want to avoid that pre-faulted single page mappings preempt huge page
mappings.

Cc: kvm@vger.kernel.org
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 60 +++++++++++++++++++++++---------
 1 file changed, 43 insertions(+), 17 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index ba0ce0075b2f..2d7478e9a62d 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -20,6 +20,7 @@
 #include <linux/mutex.h>
 #include <linux/notifier.h>
 #include <linux/pci.h>
+#include <linux/pfn_t.h>
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 #include <linux/types.h>
@@ -1657,14 +1658,20 @@ static unsigned long vma_to_pfn(struct vm_area_struct *vma)
 	return (pci_resource_start(vdev->pdev, index) >> PAGE_SHIFT) + pgoff;
 }
 
-static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
+static vm_fault_t vfio_pci_mmap_huge_fault(struct vm_fault *vmf,
+					   unsigned int order)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct vfio_pci_core_device *vdev = vma->vm_private_data;
 	unsigned long pfn, pgoff = vmf->pgoff - vma->vm_pgoff;
-	unsigned long addr = vma->vm_start;
 	vm_fault_t ret = VM_FAULT_SIGBUS;
 
+	if (order && (vmf->address & ((PAGE_SIZE << order) - 1) ||
+		      vmf->address + (PAGE_SIZE << order) > vma->vm_end)) {
+		ret = VM_FAULT_FALLBACK;
+		goto out;
+	}
+
 	pfn = vma_to_pfn(vma);
 
 	down_read(&vdev->memory_lock);
@@ -1672,30 +1679,49 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
 		goto out_unlock;
 
-	ret = vmf_insert_pfn(vma, vmf->address, pfn + pgoff);
-	if (ret & VM_FAULT_ERROR)
-		goto out_unlock;
-
-	/*
-	 * Pre-fault the remainder of the vma, abort further insertions and
-	 * supress error if fault is encountered during pre-fault.
-	 */
-	for (; addr < vma->vm_end; addr += PAGE_SIZE, pfn++) {
-		if (addr == vmf->address)
-			continue;
-
-		if (vmf_insert_pfn(vma, addr, pfn) & VM_FAULT_ERROR)
-			break;
+	switch (order) {
+	case 0:
+		ret = vmf_insert_pfn(vma, vmf->address, pfn + pgoff);
+		break;
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
+	case PMD_ORDER:
+		ret = vmf_insert_pfn_pmd(vmf, __pfn_to_pfn_t(pfn + pgoff,
+							     PFN_DEV), false);
+		break;
+#endif
+#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
+	case PUD_ORDER:
+		ret = vmf_insert_pfn_pud(vmf, __pfn_to_pfn_t(pfn + pgoff,
+							     PFN_DEV), false);
+		break;
+#endif
+	default:
+		ret = VM_FAULT_FALLBACK;
 	}
 
 out_unlock:
 	up_read(&vdev->memory_lock);
+out:
+	dev_dbg_ratelimited(&vdev->pdev->dev,
+			   "%s(,order = %d) BAR %ld page offset 0x%lx: 0x%x\n",
+			    __func__, order,
+			    vma->vm_pgoff >>
+				(VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT),
+			    pgoff, (unsigned int)ret);
 
 	return ret;
 }
 
+static vm_fault_t vfio_pci_mmap_page_fault(struct vm_fault *vmf)
+{
+	return vfio_pci_mmap_huge_fault(vmf, 0);
+}
+
 static const struct vm_operations_struct vfio_pci_mmap_ops = {
-	.fault = vfio_pci_mmap_fault,
+	.fault = vfio_pci_mmap_page_fault,
+#ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
+	.huge_fault = vfio_pci_mmap_huge_fault,
+#endif
 };
 
 int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma)
-- 
2.45.0


