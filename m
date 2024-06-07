Return-Path: <kvm+bounces-19047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D4BEA8FFA48
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 05:52:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 615B52868BD
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 03:52:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23B5017C6C;
	Fri,  7 Jun 2024 03:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R3a1rCVf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790C9171A4
	for <kvm@vger.kernel.org>; Fri,  7 Jun 2024 03:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717732357; cv=none; b=KeSbp2ZdfwVjqBLtHrOegzjXgUhEf9Q8SjQb8TlL3RhrFHm8ca8cCdtFxNJ3S+TKPKorsT8D/2LEISrMhfCw9MXDtJgWKH1xnxN/leG8UxJFL9TB/wj5IdRebpG+htF3LKFjT6WyKuwD8Gzkhm7ZeK0DtpBQoOA5CcyLye2PA84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717732357; c=relaxed/simple;
	bh=lOz8gDnR+cuOtEHX+JNlgWjYczd1SwSgZ3xHjN3iNk4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S15ff60GYuISGBLUtIzUu5UHkAcRc/R4+POeT6r+ARIaB2wq0sMLJ+Q72Eds6QeMekUwtOzfSa9/uwjY3VKyoAI6/TaF/6eDsjmsDbAygKP289tCYgIhlw8GPRVIn4U2zfUoqCfBlfxrdxgnPiIImSivjYrg1RzypDMhev8tYtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R3a1rCVf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717732354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wYHK81ejM4GWfJWppOiQBD1bgtl22lcOLus+EEyzMwU=;
	b=R3a1rCVfr1BZy9AY3v/C2LATqO8gn+fij2+nzJnth8sDxIwkBJyz+ppqYaQImEMizUpZD0
	y9HWi0dQ/p4rnbQRz8Xfg7i0RCARza2ZtCSdwVGiOdF0TS/AdlT7wYJcg0c92f7I8yn44q
	27cPtUxYT2IJ4m0yzx1OcA2LhonfrTA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-313-WjEtZW42MQazar1iJTkQNA-1; Thu,
 06 Jun 2024 23:52:25 -0400
X-MC-Unique: WjEtZW42MQazar1iJTkQNA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9BFE43C00088;
	Fri,  7 Jun 2024 03:52:24 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.34.52])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8812B40C6CB7;
	Fri,  7 Jun 2024 03:52:23 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: kvm@vger.kernel.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
	ajones@ventanamicro.com,
	yan.y.zhao@intel.com,
	kevin.tian@intel.com,
	jgg@nvidia.com,
	peterx@redhat.com
Subject: [PATCH] vfio/pci: Insert full vma on mmap'd MMIO fault
Date: Thu,  6 Jun 2024 21:52:07 -0600
Message-ID: <20240607035213.2054226-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

In order to improve performance of typical scenarios we can try to insert
the entire vma on fault.  This accelerates typical cases, such as when
the MMIO region is DMA mapped by QEMU.  The vfio_iommu_type1 driver will
fault in the entire DMA mapped range through fixup_user_fault().

In synthetic testing, this improves the time required to walk a PCI BAR
mapping from userspace by roughly 1/3rd.

This is likely an interim solution until vmf_insert_pfn_{pmd,pud}() gain
support for pfnmaps.

Suggested-by: Yan Zhao <yan.y.zhao@intel.com>
Link: https://lore.kernel.org/all/Zl6XdUkt%2FzMMGOLF@yzhao56-desk.sh.intel.com/
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

I'm sending this as a follow-on patch to the v2 series[1] because this
is largely a performance optimization, and one that we may want to
revert when we can introduce huge_fault support.  In the meantime, I
can't argue with the 1/3rd performance improvement this provides to
reduce the overall impact of the series below.  Without objection I'd
therefore target this for v6.10 as well.  Thanks,

Alex

[1]https://lore.kernel.org/all/20240530045236.1005864-1-alex.williamson@redhat.com/

 drivers/vfio/pci/vfio_pci_core.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index db31c27bf78b..987c7921affa 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1662,6 +1662,7 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 	struct vm_area_struct *vma = vmf->vma;
 	struct vfio_pci_core_device *vdev = vma->vm_private_data;
 	unsigned long pfn, pgoff = vmf->pgoff - vma->vm_pgoff;
+	unsigned long addr = vma->vm_start;
 	vm_fault_t ret = VM_FAULT_SIGBUS;
 
 	pfn = vma_to_pfn(vma);
@@ -1669,11 +1670,25 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 	down_read(&vdev->memory_lock);
 
 	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
-		goto out_disabled;
+		goto out_unlock;
 
 	ret = vmf_insert_pfn(vma, vmf->address, pfn + pgoff);
+	if (ret & VM_FAULT_ERROR)
+		goto out_unlock;
 
-out_disabled:
+	/*
+	 * Pre-fault the remainder of the vma, abort further insertions and
+	 * supress error if fault is encountered during pre-fault.
+	 */
+	for (; addr < vma->vm_end; addr += PAGE_SIZE, pfn++) {
+		if (addr == vmf->address)
+			continue;
+
+		if (vmf_insert_pfn(vma, addr, pfn) & VM_FAULT_ERROR)
+			break;
+	}
+
+out_unlock:
 	up_read(&vdev->memory_lock);
 
 	return ret;
-- 
2.45.0


