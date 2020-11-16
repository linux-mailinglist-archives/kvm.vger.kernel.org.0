Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE9E2B420C
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 12:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729573AbgKPLCE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 06:02:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21673 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729566AbgKPLCD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 06:02:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605524522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ojTGOsjdIQDPmfIW+SwdVfCC29bdZrFVQWv6YQa2YfE=;
        b=OvqD22ek5dBGmdioA3LcfCcDBt41fjsYeNeOXWqnlGDbW1L67WGrUaZDlOZfxOyLyktHMJ
        dOYdKlwjg077PmCrAvEXwMWGstLk5sEvWYfwWg+GmR2kwPjfFZygYtCizghT30GuIaFVcJ
        uGK93b2BlkSJ1LjC0Iv1wYPxFRfa0ec=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-85-3E1Dc9auP4SXZeMCMymb2g-1; Mon, 16 Nov 2020 06:02:00 -0500
X-MC-Unique: 3E1Dc9auP4SXZeMCMymb2g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C15E7186DD23;
        Mon, 16 Nov 2020 11:01:57 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-230.ams2.redhat.com [10.36.113.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 435045C5AF;
        Mon, 16 Nov 2020 11:01:53 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        joro@8bytes.org, maz@kernel.org, robin.murphy@arm.com,
        alex.williamson@redhat.com
Cc:     jean-philippe@linaro.org, zhangfei.gao@linaro.org,
        zhangfei.gao@gmail.com, vivek.gautam@arm.com,
        shameerali.kolothum.thodi@huawei.com,
        jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com, tn@semihalf.com,
        nicoleotsuka@gmail.com, yuzenghui@huawei.com
Subject: [PATCH v11 10/13] vfio/pci: Register and allow DMA FAULT IRQ signaling
Date:   Mon, 16 Nov 2020 12:00:27 +0100
Message-Id: <20201116110030.32335-11-eric.auger@redhat.com>
In-Reply-To: <20201116110030.32335-1-eric.auger@redhat.com>
References: <20201116110030.32335-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Register the VFIO_IRQ_TYPE_NESTED/VFIO_IRQ_SUBTYPE_DMA_FAULT
IRQ that allows to signal a nested mode DMA fault.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v10 -> v11:
- the irq now is registered in vfio_pci_dma_fault_init()
  in case the domain is nested
---
 drivers/vfio/pci/vfio_pci.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 93e03a4a5f32..65a83fd0e8c0 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -397,6 +397,7 @@ int vfio_pci_iommu_dev_fault_handler(struct iommu_fault *fault, void *data)
 		(struct vfio_region_dma_fault *)vdev->fault_pages;
 	struct iommu_fault *new;
 	u32 head, tail, size;
+	int ext_irq_index;
 	int ret = -EINVAL;
 
 
@@ -422,7 +423,19 @@ int vfio_pci_iommu_dev_fault_handler(struct iommu_fault *fault, void *data)
 	ret = 0;
 unlock:
 	mutex_unlock(&vdev->fault_queue_lock);
-	return ret;
+	if (ret)
+		return ret;
+
+	ext_irq_index = vfio_pci_get_ext_irq_index(vdev, VFIO_IRQ_TYPE_NESTED,
+						   VFIO_IRQ_SUBTYPE_DMA_FAULT);
+	if (ext_irq_index < 0)
+		return -EINVAL;
+
+	mutex_lock(&vdev->igate);
+	if (vdev->ext_irqs[ext_irq_index].trigger)
+		eventfd_signal(vdev->ext_irqs[ext_irq_index].trigger, 1);
+	mutex_unlock(&vdev->igate);
+	return 0;
 }
 
 #define DMA_FAULT_RING_LENGTH 512
@@ -474,6 +487,12 @@ static int vfio_pci_dma_fault_init(struct vfio_pci_device *vdev)
 	if (ret) /* the dma fault region is freed in vfio_pci_disable() */
 		goto out;
 
+	ret = vfio_pci_register_irq(vdev, VFIO_IRQ_TYPE_NESTED,
+				    VFIO_IRQ_SUBTYPE_DMA_FAULT,
+				    VFIO_IRQ_INFO_EVENTFD);
+	if (ret) /* the fault handler is also freed in vfio_pci_disable() */
+		goto out;
+
 	return 0;
 out:
 	kfree(vdev->fault_pages);
-- 
2.21.3

