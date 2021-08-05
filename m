Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC0C3E1A13
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 19:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237969AbhHERIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 13:08:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40864 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237668AbhHERIt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Aug 2021 13:08:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628183314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cmH6Fr1v5dKikdp8IvedcWQSNzuiqYnvmJ72YO3MhX0=;
        b=WRnPZ/F7w78DiHvljCSCqMprxIXeH3zVuCCAGLdJMfOA78ydp7gvhW3DRFmt2Bc79HrnS3
        YrcYyuxP5jQcl5pKO5iv2l3cC24HI55EvPWCwpIZ7hHuLgwtyqH7pRLjzYyaBn3amqbfEa
        G0zG+EFZb7E4fnmtVdVG/z1F+50vDEA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129-xi5TlknyO4Kf0UWmzL52HQ-1; Thu, 05 Aug 2021 13:08:31 -0400
X-MC-Unique: xi5TlknyO4Kf0UWmzL52HQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A25793920;
        Thu,  5 Aug 2021 17:08:30 +0000 (UTC)
Received: from [172.30.41.16] (ovpn-113-77.phx2.redhat.com [10.3.113.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1691F19C87;
        Thu,  5 Aug 2021 17:08:22 +0000 (UTC)
Subject: [PATCH 7/7] vfio/pci: Remove map-on-fault behavior
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Date:   Thu, 05 Aug 2021 11:08:21 -0600
Message-ID: <162818330190.1511194.10498114924408843888.stgit@omen>
In-Reply-To: <162818167535.1511194.6614962507750594786.stgit@omen>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
User-Agent: StGit/1.0-8-g6af9-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With vfio_device_io_remap_mapping_range() we can repopulate vmas with
device mappings around manipulation of the device rather than waiting
for an access.  This allows us to go back to the more standard use
case of io_remap_pfn_range() for device memory while still preventing
access to device memory through mmaps when the device is disabled.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c         |   80 +++++++++++++++++------------------
 drivers/vfio/pci/vfio_pci_config.c  |    8 ++--
 drivers/vfio/pci/vfio_pci_private.h |    3 +
 3 files changed, 45 insertions(+), 46 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 7a9f67cfc0a2..196b8002447b 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -447,6 +447,7 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 		kfree(dummy_res);
 	}
 
+	vdev->zapped_bars = false;
 	vdev->needs_reset = true;
 
 	/*
@@ -1057,7 +1058,7 @@ static long vfio_pci_ioctl(struct vfio_device *core_vdev,
 
 		vfio_pci_zap_and_down_write_memory_lock(vdev);
 		ret = pci_try_reset_function(vdev->pdev);
-		up_write(&vdev->memory_lock);
+		vfio_pci_test_and_up_write_memory_lock(vdev);
 
 		return ret;
 
@@ -1256,7 +1257,7 @@ static long vfio_pci_ioctl(struct vfio_device *core_vdev,
 		for (i = 0; i < devs.cur_index; i++) {
 			struct vfio_pci_device *tmp = devs.devices[i];
 
-			up_write(&tmp->memory_lock);
+			vfio_pci_test_and_up_write_memory_lock(tmp);
 			vfio_device_put(&tmp->vdev);
 		}
 		kfree(devs.devices);
@@ -1413,6 +1414,14 @@ static void vfio_pci_zap_bars(struct vfio_pci_device *vdev)
 			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX),
 			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_ROM_REGION_INDEX) -
 			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX));
+
+	/*
+	 * Modified under memory_lock write semaphore.  Device handoff
+	 * with memory enabled, therefore any disable will zap and setup
+	 * a remap when re-enabled.  io_remap_pfn_range() is not forgiving
+	 * of duplicate mappings so we must track.
+	 */
+	vdev->zapped_bars = true;
 }
 
 void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_device *vdev)
@@ -1421,6 +1430,18 @@ void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_device *vdev)
 	vfio_pci_zap_bars(vdev);
 }
 
+void vfio_pci_test_and_up_write_memory_lock(struct vfio_pci_device *vdev)
+{
+	if (vdev->zapped_bars && __vfio_pci_memory_enabled(vdev)) {
+		WARN_ON(vfio_device_io_remap_mapping_range(&vdev->vdev,
+			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX),
+			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_ROM_REGION_INDEX) -
+			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX)));
+		vdev->zapped_bars = false;
+	}
+	up_write(&vdev->memory_lock);
+}
+
 u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_device *vdev)
 {
 	u16 cmd;
@@ -1464,39 +1485,6 @@ static int vfio_pci_bar_vma_to_pfn(struct vfio_device *core_vdev,
 	return 0;
 }
 
-static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
-{
-	struct vm_area_struct *vma = vmf->vma;
-	struct vfio_pci_device *vdev = vma->vm_private_data;
-	unsigned long vaddr, pfn;
-	vm_fault_t ret = VM_FAULT_SIGBUS;
-
-	if (vfio_pci_bar_vma_to_pfn(&vdev->vdev, vma, &pfn))
-		return ret;
-
-	down_read(&vdev->memory_lock);
-
-	if (__vfio_pci_memory_enabled(vdev)) {
-		for (vaddr = vma->vm_start;
-		     vaddr < vma->vm_end; vaddr += PAGE_SIZE, pfn++) {
-			ret = vmf_insert_pfn(vma, vaddr, pfn);
-			if (ret != VM_FAULT_NOPAGE) {
-				zap_vma_ptes(vma, vma->vm_start,
-					     vaddr - vma->vm_start);
-				break;
-			}
-		}
-	}
-
-	up_read(&vdev->memory_lock);
-
-	return ret;
-}
-
-static const struct vm_operations_struct vfio_pci_mmap_ops = {
-	.fault = vfio_pci_mmap_fault,
-};
-
 static int vfio_pci_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma)
 {
 	struct vfio_pci_device *vdev =
@@ -1504,6 +1492,7 @@ static int vfio_pci_mmap(struct vfio_device *core_vdev, struct vm_area_struct *v
 	struct pci_dev *pdev = vdev->pdev;
 	unsigned int index;
 	u64 phys_len, req_len, pgoff, req_start;
+	unsigned long pfn;
 	int ret;
 
 	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
@@ -1554,18 +1543,25 @@ static int vfio_pci_mmap(struct vfio_device *core_vdev, struct vm_area_struct *v
 		}
 	}
 
-	vma->vm_private_data = vdev;
+	ret = vfio_pci_bar_vma_to_pfn(core_vdev, vma, &pfn);
+	if (ret)
+		return ret;
+
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
 
+	down_read(&vdev->memory_lock);
 	/*
-	 * See remap_pfn_range(), called from vfio_pci_fault() but we can't
-	 * change vm_flags within the fault handler.  Set them now.
+	 * Only perform the mapping now if BAR is not in zapped state, VFs
+	 * always report memory enabled so relying on device enable state
+	 * could lead to duplicate remaps.
 	 */
-	vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
-	vma->vm_ops = &vfio_pci_mmap_ops;
+	if (!vdev->zapped_bars)
+		ret = io_remap_pfn_range(vma, vma->vm_start, pfn,
+					 vma->vm_end - vma->vm_start,
+					 vma->vm_page_prot);
+	up_read(&vdev->memory_lock);
 
-	return 0;
+	return ret;
 }
 
 static void vfio_pci_request(struct vfio_device *core_vdev, unsigned int count)
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 70e28efbc51f..4220057b253c 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -605,7 +605,7 @@ static int vfio_basic_config_write(struct vfio_pci_device *vdev, int pos,
 	count = vfio_default_config_write(vdev, pos, count, perm, offset, val);
 	if (count < 0) {
 		if (offset == PCI_COMMAND)
-			up_write(&vdev->memory_lock);
+			vfio_pci_test_and_up_write_memory_lock(vdev);
 		return count;
 	}
 
@@ -619,7 +619,7 @@ static int vfio_basic_config_write(struct vfio_pci_device *vdev, int pos,
 		*virt_cmd &= cpu_to_le16(~mask);
 		*virt_cmd |= cpu_to_le16(new_cmd & mask);
 
-		up_write(&vdev->memory_lock);
+		vfio_pci_test_and_up_write_memory_lock(vdev);
 	}
 
 	/* Emulate INTx disable */
@@ -860,7 +860,7 @@ static int vfio_exp_config_write(struct vfio_pci_device *vdev, int pos,
 		if (!ret && (cap & PCI_EXP_DEVCAP_FLR)) {
 			vfio_pci_zap_and_down_write_memory_lock(vdev);
 			pci_try_reset_function(vdev->pdev);
-			up_write(&vdev->memory_lock);
+			vfio_pci_test_and_up_write_memory_lock(vdev);
 		}
 	}
 
@@ -942,7 +942,7 @@ static int vfio_af_config_write(struct vfio_pci_device *vdev, int pos,
 		if (!ret && (cap & PCI_AF_CAP_FLR) && (cap & PCI_AF_CAP_TP)) {
 			vfio_pci_zap_and_down_write_memory_lock(vdev);
 			pci_try_reset_function(vdev->pdev);
-			up_write(&vdev->memory_lock);
+			vfio_pci_test_and_up_write_memory_lock(vdev);
 		}
 	}
 
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 0aa542fa1e26..9aedb78a4ae3 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -128,6 +128,7 @@ struct vfio_pci_device {
 	bool			needs_reset;
 	bool			nointx;
 	bool			needs_pm_restore;
+	bool			zapped_bars;
 	struct pci_saved_state	*pci_saved_state;
 	struct pci_saved_state	*pm_save;
 	struct vfio_pci_reflck	*reflck;
@@ -186,6 +187,8 @@ extern int vfio_pci_set_power_state(struct vfio_pci_device *vdev,
 extern bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev);
 extern void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_device
 						    *vdev);
+extern void vfio_pci_test_and_up_write_memory_lock(struct vfio_pci_device
+						   *vdev);
 extern u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_device *vdev);
 extern void vfio_pci_memory_unlock_and_restore(struct vfio_pci_device *vdev,
 					       u16 cmd);


