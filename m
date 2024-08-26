Return-Path: <kvm+bounces-25099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1892395FAEC
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 22:49:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09B421C22259
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 20:49:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 911611A2577;
	Mon, 26 Aug 2024 20:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FhySGljM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498A31A0B16
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 20:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724705079; cv=none; b=W5zAbWsvkIn62ZdbxbOhP7Y93b90HThhMyKoBesSp5ZYMdxxXx+Sd/smDtpfGd//UqhOUVkoPGtWWusCw+oPLi7DshZTYHqA9J/lDqKf/3Qt7UsswsqYYkq31k/+UAaU1tucgxlmZu8ncbVGhF1Zzu9XTL7AGj/oKsp4kk5zF/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724705079; c=relaxed/simple;
	bh=Dmoew7i8XEW+gHBA0zJyGyEzte9fLwrtktcen/8enVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=siQWQxqAAidqgmIoQVZj4PlgMjqPqD5ILXB+SRDBw/8DebIzBPGNuftx6MbjnaB/vlvjtSrQdN1c4v9tUFnq7m8srwuz7W1idHRP1mKKnj7hs5G4UFg3pGpW+iCRVGknG8RYpjWxyHFDAkxyfwk64Z5LgJv1GeGGjD5TTL62X7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FhySGljM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724705077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9MPOki3YF/wyEgBnejzItxwjIF1moGifGifGb5OwzY4=;
	b=FhySGljMbpHAB9+fOXckwB3PHKcnCG4nxvJpUlFUCVLdYAj/nbkeYKgNMqPIEpnfvUoNb9
	dH7JrygPjxonljj4/QaAFCfZbclT/wN7GDnyG3JBM6s9TgUfmHPPoX4LUJSoOs0TrhEIBg
	9R71iuO6fqzROWWEB1IGt67NCtMuvuM=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-214-E_U0CEgeM8WhKhO0OFpY-w-1; Mon, 26 Aug 2024 16:44:35 -0400
X-MC-Unique: E_U0CEgeM8WhKhO0OFpY-w-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7a1dc1e5662so663447185a.2
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 13:44:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724705075; x=1725309875;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9MPOki3YF/wyEgBnejzItxwjIF1moGifGifGb5OwzY4=;
        b=GGxrv98hA0zVxL6T7a56iwxcydkJ+HQSSjLaUuJBKY+lnhLbWasJ+fjtu/RESeXqmL
         azAxG4YK5H3/VIH47O1ZmrqFgsPm1o75tff3PCkeY0BxfW7BNtXUSNyCat6NUFDg9GIv
         6lGT/9AxzfV6ub4eD/M4VfZRyqhNd6hbPMC+yC11cXFk8B84p6K/pypp2uqECxgZg0Xp
         M9GUiCNMfqvF4vWoJfaFg1HqTGwwJXhOOu44JaN4GxNlyb3zlFlk0S2tEVrVS1Oh3YF2
         Y4VpgHnnIn2NwMwwJ2ji7E4lkZeifP/6//GgrEraRopqX4YUc2eGQ1GRVrxkozw/e/0/
         6ZHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVo25Aq14vqQuLOV5j72nH3vq6aIIlmm0nSMva8glPfkm/BW06ypKaGjTILv+WRevw6wu4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzpO2GbQLx+XrFdybGqHzdz3xbxGX9ZWW++TQl9T+rSUP5V6Qm3
	i8H0IkaXk8dp+FuBXmTUKjx7tZy/BCFk+Lz4lhSV/GZKYOhfdh6qMf3feEKXKiXMEFF0nJVsLFW
	NqkaiAwhaSt6AWknCA9V6ueJ4dwbKKRQSt1RU6pdOsDobzL6jLQ==
X-Received: by 2002:a05:620a:4007:b0:79f:595:f64a with SMTP id af79cd13be357-7a6897b7b14mr1477183485a.58.1724705074689;
        Mon, 26 Aug 2024 13:44:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHpx2qE8XXNwFA/VbcshgEEhM7utf/nDzzwdfyOyUpm1p8Kz8GxiojqL+PSarI5vXlPZn99hQ==
X-Received: by 2002:a05:620a:4007:b0:79f:595:f64a with SMTP id af79cd13be357-7a6897b7b14mr1477180385a.58.1724705074328;
        Mon, 26 Aug 2024 13:44:34 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a67f3fd6c1sm491055185a.121.2024.08.26.13.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 13:44:33 -0700 (PDT)
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
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2 19/19] vfio/pci: Implement huge_fault support
Date: Mon, 26 Aug 2024 16:43:53 -0400
Message-ID: <20240826204353.2228736-20-peterx@redhat.com>
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


