Return-Path: <kvm+bounces-20337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ED4A2913B1E
	for <lists+kvm@lfdr.de>; Sun, 23 Jun 2024 15:49:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A62131F21A61
	for <lists+kvm@lfdr.de>; Sun, 23 Jun 2024 13:49:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C2CA18A954;
	Sun, 23 Jun 2024 13:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y08whOsm"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC42181D0E;
	Sun, 23 Jun 2024 13:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719150282; cv=none; b=AHHu9OAwuQt/32I+n6/p0qxPG/ptUrrbdF5wQfvVMIaM73ByI3Ejm+41mlzNqRm1zrm13u8S2abgQd254sr/pFzbhEW0QkNhEF4qGBUTyqDIXW6PoAPOg8SoeT5hTbZgNEXoO/wx2bybSCUtMmlpLixsNrCsHbICijKBjJK/Ty0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719150282; c=relaxed/simple;
	bh=FhkXUSWTBbbwG5f8YbvesGJIvquKOnAw8mEO1OeSpzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J8gtIe06WLEhBB9fBCCwGE/tGi9l62srE3ZXYsKrG6Xuv/gE9PngTHCFH9jdXr4fMsbma4siMhKtRAUYiK0dmpQAc4Sm2SaNnBS4+3mT2sz+4FZbYEWnhmOp+S7XNuHIOVLV3aiCNc8uPEh1DGXD6cpC9Sk5suciPpScUe1KsMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y08whOsm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68E8C32781;
	Sun, 23 Jun 2024 13:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719150282;
	bh=FhkXUSWTBbbwG5f8YbvesGJIvquKOnAw8mEO1OeSpzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y08whOsmaYxNwV+IT+yvUjeGSie0RWMkje7zMLg54zt7FRxFxk5VbM6KGdUaIK7Vb
	 wZD1Y0xfAIiPV8vjeTYEeUyQE5rrY5SpPFkNnCwP+7aV//qcoKa5S7Yji3evHrWu1D
	 2oSsMXeeAmGrdpdxYiPOYrX8TwPGZEEPS/6fDJcoXpqyypqy8jTmM5QhGBiSOiabzC
	 UjZ3dqDcf3JXRyClq5kWAYTWY6qVtm9QvyNMzdCnQuFBo9oTKDjLIQSOc13ZnXcKnB
	 XJobDNR5rwcNC6nVn1nuLX/Jgiisw6SZb52fYFPQS5kLZYGTP7vYTOw8VR9ze3m/Od
	 fMiah0igDd0fQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	jgg@ziepe.ca,
	yi.l.liu@intel.com,
	kevin.tian@intel.com,
	eric.auger@redhat.com,
	brauner@kernel.org,
	ankita@nvidia.com,
	stefanha@redhat.com,
	kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.9 20/21] vfio/pci: Insert full vma on mmap'd MMIO fault
Date: Sun, 23 Jun 2024 09:43:53 -0400
Message-ID: <20240623134405.809025-20-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240623134405.809025-1-sashal@kernel.org>
References: <20240623134405.809025-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.9.6
Content-Transfer-Encoding: 8bit

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit d71a989cf5d961989c273093cdff2550acdde314 ]

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
Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
Link: https://lore.kernel.org/r/20240607035213.2054226-1-alex.williamson@redhat.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_core.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 2baf4dfac3f43..9eaf10a8f134b 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1639,6 +1639,7 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 	struct vm_area_struct *vma = vmf->vma;
 	struct vfio_pci_core_device *vdev = vma->vm_private_data;
 	unsigned long pfn, pgoff = vmf->pgoff - vma->vm_pgoff;
+	unsigned long addr = vma->vm_start;
 	vm_fault_t ret = VM_FAULT_SIGBUS;
 
 	pfn = vma_to_pfn(vma);
@@ -1646,11 +1647,25 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
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
2.43.0


