Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A573E1A09
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 19:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237497AbhHERIM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 13:08:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37849 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237222AbhHERIM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Aug 2021 13:08:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628183277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZTN5INyjQiEkVh8c4VlLRN4VK58ndKszKj5XfQVOIPI=;
        b=ZSkHPZdH0ggCUbTOS9C63FlZtPJAb7283hrdGB0wLwhzoWGInHsXDnGNZ7qAFhUiQQEAE5
        ceQqiTTkIWeWGFGk1bAgd1QMN9jyTV5L3ZVeuGOMoREdwi90uifl4/FAnVPRautCHpcUM5
        dOy67ATAa2W8bzXxfUQKfNfVu9L3qaU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-wMPjUAs7Pw6ZMBTrS-DkpQ-1; Thu, 05 Aug 2021 13:07:56 -0400
X-MC-Unique: wMPjUAs7Pw6ZMBTrS-DkpQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6419D107ACF5;
        Thu,  5 Aug 2021 17:07:55 +0000 (UTC)
Received: from [172.30.41.16] (ovpn-113-77.phx2.redhat.com [10.3.113.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97EC13CC7;
        Thu,  5 Aug 2021 17:07:47 +0000 (UTC)
Subject: [PATCH 4/7] vfio,vfio-pci: Add vma to pfn callback
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Date:   Thu, 05 Aug 2021 11:07:47 -0600
Message-ID: <162818326742.1511194.1366505678218237973.stgit@omen>
In-Reply-To: <162818167535.1511194.6614962507750594786.stgit@omen>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
User-Agent: StGit/1.0-8-g6af9-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new vfio_device_ops callback to allow the vfio device driver to
translate a vma mapping of a vfio device fd to a pfn.  Implementation
limited to vfio-pci here for the purpose of supporting the reverse of
unmap_mapping_range(), but expected to be implemented for all vfio
device drivers supporting DMA mapping of device memory mmaps.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c |    9 ++++++---
 drivers/vfio/vfio.c         |   18 ++++++++++++++++--
 include/linux/vfio.h        |    6 ++++++
 3 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index c526edbf1173..7a9f67cfc0a2 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1440,10 +1440,12 @@ void vfio_pci_memory_unlock_and_restore(struct vfio_pci_device *vdev, u16 cmd)
 	up_write(&vdev->memory_lock);
 }
 
-static int vfio_pci_bar_vma_to_pfn(struct vm_area_struct *vma,
+static int vfio_pci_bar_vma_to_pfn(struct vfio_device *core_vdev,
+				   struct vm_area_struct *vma,
 				   unsigned long *pfn)
 {
-	struct vfio_pci_device *vdev = vma->vm_private_data;
+	struct vfio_pci_device *vdev =
+			container_of(core_vdev, struct vfio_pci_device, vdev);
 	struct pci_dev *pdev = vdev->pdev;
 	int index;
 	u64 pgoff;
@@ -1469,7 +1471,7 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 	unsigned long vaddr, pfn;
 	vm_fault_t ret = VM_FAULT_SIGBUS;
 
-	if (vfio_pci_bar_vma_to_pfn(vma, &pfn))
+	if (vfio_pci_bar_vma_to_pfn(&vdev->vdev, vma, &pfn))
 		return ret;
 
 	down_read(&vdev->memory_lock);
@@ -1742,6 +1744,7 @@ static const struct vfio_device_ops vfio_pci_ops = {
 	.mmap		= vfio_pci_mmap,
 	.request	= vfio_pci_request,
 	.match		= vfio_pci_match,
+	.vma_to_pfn	= vfio_pci_bar_vma_to_pfn,
 };
 
 static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev);
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 1e4fc69fee7d..42ca93be152a 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -875,6 +875,22 @@ struct vfio_device *vfio_device_get_from_dev(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(vfio_device_get_from_dev);
 
+static const struct file_operations vfio_device_fops;
+
+int vfio_device_vma_to_pfn(struct vfio_device *device,
+			   struct vm_area_struct *vma, unsigned long *pfn)
+{
+	if (WARN_ON(!vma->vm_file || vma->vm_file->f_op != &vfio_device_fops ||
+		    vma->vm_file->private_data != device))
+		return -EINVAL;
+
+	if (unlikely(!device->ops->vma_to_pfn))
+		return -EPERM;
+
+	return device->ops->vma_to_pfn(device, vma, pfn);
+}
+EXPORT_SYMBOL_GPL(vfio_device_vma_to_pfn);
+
 static struct vfio_device *vfio_device_get_from_name(struct vfio_group *group,
 						     char *buf)
 {
@@ -1407,8 +1423,6 @@ static int vfio_group_add_container_user(struct vfio_group *group)
 	return 0;
 }
 
-static const struct file_operations vfio_device_fops;
-
 static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 {
 	struct vfio_device *device;
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 712813703e5a..5f07ebe0f85d 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -41,6 +41,7 @@ struct vfio_device {
  * @match: Optional device name match callback (return: 0 for no-match, >0 for
  *         match, -errno for abort (ex. match with insufficient or incorrect
  *         additional args)
+ * @vma_to_pfn: Optional pfn from vma lookup against vma mapping device fd
  */
 struct vfio_device_ops {
 	char	*name;
@@ -55,6 +56,8 @@ struct vfio_device_ops {
 	int	(*mmap)(struct vfio_device *vdev, struct vm_area_struct *vma);
 	void	(*request)(struct vfio_device *vdev, unsigned int count);
 	int	(*match)(struct vfio_device *vdev, char *buf);
+	int	(*vma_to_pfn)(struct vfio_device *vdev,
+			      struct vm_area_struct *vma, unsigned long *pfn);
 };
 
 extern struct iommu_group *vfio_iommu_group_get(struct device *dev);
@@ -68,6 +71,9 @@ extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
 extern void vfio_device_put(struct vfio_device *device);
 extern void vfio_device_unmap_mapping_range(struct vfio_device *device,
 					    loff_t start, loff_t len);
+extern int vfio_device_vma_to_pfn(struct vfio_device *device,
+				  struct vm_area_struct *vma,
+				  unsigned long *pfn);
 
 /* events for the backend driver notify callback */
 enum vfio_iommu_notify_type {


