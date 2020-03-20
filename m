Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67BE318D426
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 17:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbgCTQUV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 12:20:21 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:58973 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727695AbgCTQUU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 12:20:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584721218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VAZW6cFIVig3OQ6U+hazCtWFrY3hJC4RyMbwC1s1758=;
        b=ZJC0i4yjIAQasJIDHaqsnrPkGzy6VWQvhsxWDzlM2Xl36fFYj8K1OinU7n4EM9qLVbpjkb
        IuD0a8yL2Agbashn7jXs5np3ySNwr5hMXkppSagyrFyYU0z5STRYkcJJIJEvN/yclJwhs4
        So1jp2JfVVL4A/N2lcvgillqpUyuFUs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-ei1HOvX7N6KVKGzeiOefbA-1; Fri, 20 Mar 2020 12:20:14 -0400
X-MC-Unique: ei1HOvX7N6KVKGzeiOefbA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A0F88C8EE1;
        Fri, 20 Mar 2020 16:20:12 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 757FA60BFB;
        Fri, 20 Mar 2020 16:19:55 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, jean-philippe.brucker@arm.com,
        will.deacon@arm.com, robin.murphy@arm.com
Cc:     marc.zyngier@arm.com, peter.maydell@linaro.org,
        zhangfei.gao@gmail.com
Subject: [PATCH v10 05/11] vfio/pci: Register an iommu fault handler
Date:   Fri, 20 Mar 2020 17:19:05 +0100
Message-Id: <20200320161911.27494-6-eric.auger@redhat.com>
In-Reply-To: <20200320161911.27494-1-eric.auger@redhat.com>
References: <20200320161911.27494-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Register an IOMMU fault handler which records faults in
the DMA FAULT region ring buffer. In a subsequent patch, we
will add the signaling of a specific eventfd to allow the
userspace to be notified whenever a new fault as shown up.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v8 -> v9:
- handler now takes an iommu_fault handle
- eventfd signaling moved to a subsequent patch
- check the fault type and return an error if !=3D UNRECOV
- still the fault handler registration can fail. We need to
  reach an agreement about how to deal with the situation

v3 -> v4:
- move iommu_unregister_device_fault_handler to vfio_pci_release
---
 drivers/vfio/pci/vfio_pci.c | 42 +++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 586b89debed5..69595c240baf 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -27,6 +27,7 @@
 #include <linux/vfio.h>
 #include <linux/vgaarb.h>
 #include <linux/nospec.h>
+#include <linux/circ_buf.h>
=20
 #include "vfio_pci_private.h"
=20
@@ -283,6 +284,38 @@ static const struct vfio_pci_regops vfio_pci_dma_fau=
lt_regops =3D {
 	.add_capability =3D vfio_pci_dma_fault_add_capability,
 };
=20
+int vfio_pci_iommu_dev_fault_handler(struct iommu_fault *fault, void *da=
ta)
+{
+	struct vfio_pci_device *vdev =3D (struct vfio_pci_device *)data;
+	struct vfio_region_dma_fault *reg =3D
+		(struct vfio_region_dma_fault *)vdev->fault_pages;
+	struct iommu_fault *new =3D
+		(struct iommu_fault *)(vdev->fault_pages + reg->offset +
+			reg->head * reg->entry_size);
+	int head, tail, size;
+	int ret =3D 0;
+
+	if (fault->type !=3D IOMMU_FAULT_DMA_UNRECOV)
+		return -ENOENT;
+
+	mutex_lock(&vdev->fault_queue_lock);
+
+	head =3D reg->head;
+	tail =3D reg->tail;
+	size =3D reg->nb_entries;
+
+	if (CIRC_SPACE(head, tail, size) < 1) {
+		ret =3D -ENOSPC;
+		goto unlock;
+	}
+
+	*new =3D *fault;
+	reg->head =3D (head + 1) % size;
+unlock:
+	mutex_unlock(&vdev->fault_queue_lock);
+	return ret;
+}
+
 #define DMA_FAULT_RING_LENGTH 512
=20
 static int vfio_pci_init_dma_fault_region(struct vfio_pci_device *vdev)
@@ -317,6 +350,13 @@ static int vfio_pci_init_dma_fault_region(struct vfi=
o_pci_device *vdev)
 	header->entry_size =3D sizeof(struct iommu_fault);
 	header->nb_entries =3D DMA_FAULT_RING_LENGTH;
 	header->offset =3D sizeof(struct vfio_region_dma_fault);
+
+	ret =3D iommu_register_device_fault_handler(&vdev->pdev->dev,
+					vfio_pci_iommu_dev_fault_handler,
+					vdev);
+	if (ret)
+		goto out;
+
 	return 0;
 out:
 	kfree(vdev->fault_pages);
@@ -542,6 +582,8 @@ static void vfio_pci_release(void *device_data)
 	if (!(--vdev->refcnt)) {
 		vfio_spapr_pci_eeh_release(vdev->pdev);
 		vfio_pci_disable(vdev);
+		/* TODO: Failure problematics */
+		iommu_unregister_device_fault_handler(&vdev->pdev->dev);
 	}
=20
 	mutex_unlock(&vdev->reflck->lock);
--=20
2.20.1

