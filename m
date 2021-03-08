Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5103E331999
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 22:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbhCHVst (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 16:48:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32899 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229471AbhCHVs2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 16:48:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615240107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mnL7xLU8VAUfu1s0cNPH4G0MS7CPcOoMJVc60snGgA0=;
        b=KxpyG6BGi9xo0t651oj1UosfXGmNS5a6c7dtsTl4baJeuHUFoVs1omSYyE0NKpaY9R1RKO
        AXG/dyleIM7ezd3dPw/AdnUOUbS2faWmiTwEfSk8gEvtAFiPOqgWi4B8hQmr4RVCn9wLNM
        aBje9uMbRrEhsm7fkH237BxbzWNimDw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-I2zFBCQvPoKp9ZvePbcsRg-1; Mon, 08 Mar 2021 16:48:26 -0500
X-MC-Unique: I2zFBCQvPoKp9ZvePbcsRg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2F251084D68;
        Mon,  8 Mar 2021 21:48:24 +0000 (UTC)
Received: from gimli.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D09ED3A47;
        Mon,  8 Mar 2021 21:48:16 +0000 (UTC)
Subject: [PATCH v1 06/14] vfio: Add vma to pfn callback
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Date:   Mon, 08 Mar 2021 14:48:16 -0700
Message-ID: <161524009646.3480.6519905534709638083.stgit@gimli.home>
In-Reply-To: <161523878883.3480.12103845207889888280.stgit@gimli.home>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
User-Agent: StGit/0.21-2-g8ef5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new vfio_device_ops callback to allow the bus driver to
translate a vma mapping of a vfio device fd to a pfn.  Plumb through
vfio-core.  Implemented for vfio-pci.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c |    1 +
 drivers/vfio/vfio.c         |   16 ++++++++++++++++
 include/linux/vfio.h        |    3 +++
 3 files changed, 20 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 415b5109da9b..585895970e9c 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1756,6 +1756,7 @@ static const struct vfio_device_ops vfio_pci_ops = {
 	.mmap		= vfio_pci_mmap,
 	.request	= vfio_pci_request,
 	.match		= vfio_pci_match,
+	.vma_to_pfn	= vfio_pci_bar_vma_to_pfn,
 };
 
 static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev);
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 3a3e85a0dc3e..c47895539a1a 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -944,6 +944,22 @@ struct vfio_device *vfio_device_get_from_vma(struct vm_area_struct *vma)
 }
 EXPORT_SYMBOL_GPL(vfio_device_get_from_vma);
 
+int vfio_vma_to_pfn(struct vm_area_struct *vma, unsigned long *pfn)
+{
+	struct vfio_device *device;
+
+	if (!vma->vm_file || vma->vm_file->f_op != &vfio_device_fops)
+		return -EINVAL;
+
+	device = vma->vm_file->private_data;
+
+	if (unlikely(!device->ops->vma_to_pfn))
+		return -EINVAL;
+
+	return device->ops->vma_to_pfn(vma, pfn);
+}
+EXPORT_SYMBOL_GPL(vfio_vma_to_pfn);
+
 static struct vfio_device *vfio_device_get_from_name(struct vfio_group *group,
 						     char *buf)
 {
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 660b8adf90a6..dbd90d0ba713 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -29,6 +29,7 @@
  * @match: Optional device name match callback (return: 0 for no-match, >0 for
  *         match, -errno for abort (ex. match with insufficient or incorrect
  *         additional args)
+ * @vma_to_pfn: Optional pfn from vma lookup against vma mapping device fd
  */
 struct vfio_device_ops {
 	char	*name;
@@ -43,6 +44,7 @@ struct vfio_device_ops {
 	int	(*mmap)(void *device_data, struct vm_area_struct *vma);
 	void	(*request)(void *device_data, unsigned int count);
 	int	(*match)(void *device_data, char *buf);
+	int	(*vma_to_pfn)(struct vm_area_struct *vma, unsigned long *pfn);
 };
 
 extern struct iommu_group *vfio_iommu_group_get(struct device *dev);
@@ -59,6 +61,7 @@ extern void *vfio_device_data(struct vfio_device *device);
 extern void vfio_device_unmap_mapping_range(struct vfio_device *device,
 					    loff_t start, loff_t len);
 extern struct vfio_device *vfio_device_get_from_vma(struct vm_area_struct *vma);
+extern int vfio_vma_to_pfn(struct vm_area_struct *vma, unsigned long *pfn);
 
 /* events for the backend driver notify callback */
 enum vfio_iommu_notify_type {

