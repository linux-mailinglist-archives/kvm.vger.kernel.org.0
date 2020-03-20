Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 245EA18D43E
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 17:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbgCTQVG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 12:21:06 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:39750 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727770AbgCTQVF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 12:21:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584721264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7/L+s/k/xsB4f4cvLzAisRvkibfj9jdOS8fZjMHEbC4=;
        b=aal8Wp4ppAHUkmY9sHrj/nYC7goGqqePPnxnBGfzHkfzM673ROg3X2qLWv696Yp0xzHFsO
        1/0Kn1MSWpfwu/5GXxIQLiNo9rky9NfAoIzhLodgiYTk1jm+6zkkBZj6B6lhUo2V8Jfj7m
        mQdvIeAJEM/mkiDDV41LiuEd16MUYqY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-1vByIYMSNDSfArOtpiTuOQ-1; Fri, 20 Mar 2020 12:21:01 -0400
X-MC-Unique: 1vByIYMSNDSfArOtpiTuOQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2DEF3DB31;
        Fri, 20 Mar 2020 16:20:59 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A9C3660BFB;
        Fri, 20 Mar 2020 16:20:48 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, jean-philippe.brucker@arm.com,
        will.deacon@arm.com, robin.murphy@arm.com
Cc:     marc.zyngier@arm.com, peter.maydell@linaro.org,
        zhangfei.gao@gmail.com
Subject: [PATCH v10 10/11] vfio/pci: Register and allow DMA FAULT IRQ signaling
Date:   Fri, 20 Mar 2020 17:19:10 +0100
Message-Id: <20200320161911.27494-11-eric.auger@redhat.com>
In-Reply-To: <20200320161911.27494-1-eric.auger@redhat.com>
References: <20200320161911.27494-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Register the VFIO_IRQ_TYPE_NESTED/VFIO_IRQ_SUBTYPE_DMA_FAULT
IRQ that allows to signal a nested mode DMA fault.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index ca13067e4718..70e3a31da9f0 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -346,7 +346,7 @@ int vfio_pci_iommu_dev_fault_handler(struct iommu_fau=
lt *fault, void *data)
 	struct iommu_fault *new =3D
 		(struct iommu_fault *)(vdev->fault_pages + reg->offset +
 			reg->head * reg->entry_size);
-	int head, tail, size;
+	int head, tail, size, ext_irq_index;
 	int ret =3D 0;
=20
 	if (fault->type !=3D IOMMU_FAULT_DMA_UNRECOV)
@@ -367,7 +367,19 @@ int vfio_pci_iommu_dev_fault_handler(struct iommu_fa=
ult *fault, void *data)
 	reg->head =3D (head + 1) % size;
 unlock:
 	mutex_unlock(&vdev->fault_queue_lock);
-	return ret;
+	if (ret)
+		return ret;
+
+	ext_irq_index =3D vfio_pci_get_ext_irq_index(vdev, VFIO_IRQ_TYPE_NESTED=
,
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
=20
 #define DMA_FAULT_RING_LENGTH 512
@@ -520,6 +532,12 @@ static int vfio_pci_enable(struct vfio_pci_device *v=
dev)
 	if (ret)
 		goto disable_exit;
=20
+	ret =3D vfio_pci_register_irq(vdev, VFIO_IRQ_TYPE_NESTED,
+				    VFIO_IRQ_SUBTYPE_DMA_FAULT,
+				    VFIO_IRQ_INFO_EVENTFD);
+	if (ret)
+		goto disable_exit;
+
 	vfio_pci_probe_mmaps(vdev);
=20
 	return 0;
--=20
2.20.1

