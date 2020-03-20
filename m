Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8876D18D43B
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 17:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgCTQU6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 12:20:58 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:59842 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727499AbgCTQU4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 12:20:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584721254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gsn88KCOy4TFjSN8wEnmeeh/A4dC91vCp+i38ZmovTM=;
        b=UPNNJ7xYieTMfoUjT1V5B+iBUNFu6L6DRkkTjbLoaVuHPKpTzLQ1+NVmuxV5JamC8Ypt3g
        u/X9Ee7B5cx82nByItdQg2+RPhj7BrGa0i3vNumvnwiLYQ46xrd+1z3IJPDvfD2Vs7vlDV
        k49/4Iwf8tY9d5D3qD3Z9/UD2/kfPgY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137-TT3b5ESxPzi-BiGqNel9bA-1; Fri, 20 Mar 2020 12:20:50 -0400
X-MC-Unique: TT3b5ESxPzi-BiGqNel9bA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52D8918A6EC0;
        Fri, 20 Mar 2020 16:20:48 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F00860BFB;
        Fri, 20 Mar 2020 16:20:37 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, jean-philippe.brucker@arm.com,
        will.deacon@arm.com, robin.murphy@arm.com
Cc:     marc.zyngier@arm.com, peter.maydell@linaro.org,
        zhangfei.gao@gmail.com
Subject: [PATCH v10 09/11] vfio/pci: Add framework for custom interrupt indices
Date:   Fri, 20 Mar 2020 17:19:09 +0100
Message-Id: <20200320161911.27494-10-eric.auger@redhat.com>
In-Reply-To: <20200320161911.27494-1-eric.auger@redhat.com>
References: <20200320161911.27494-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement IRQ capability chain infrastructure. All interrupt
indexes beyond VFIO_PCI_NUM_IRQS are handled as extended
interrupts. They are registered with a specific type/subtype
and supported flags.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c         | 100 +++++++++++++++++++++++-----
 drivers/vfio/pci/vfio_pci_intrs.c   |  62 +++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h |  14 ++++
 3 files changed, 158 insertions(+), 18 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 3c99f6f3825b..ca13067e4718 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -543,6 +543,14 @@ static void vfio_pci_disable(struct vfio_pci_device =
*vdev)
 				VFIO_IRQ_SET_ACTION_TRIGGER,
 				vdev->irq_type, 0, 0, NULL);
=20
+	for (i =3D 0; i < vdev->num_ext_irqs; i++)
+		vfio_pci_set_irqs_ioctl(vdev, VFIO_IRQ_SET_DATA_NONE |
+					VFIO_IRQ_SET_ACTION_TRIGGER,
+					VFIO_PCI_NUM_IRQS + i, 0, 0, NULL);
+	vdev->num_ext_irqs =3D 0;
+	kfree(vdev->ext_irqs);
+	vdev->ext_irqs =3D NULL;
+
 	/* Device closed, don't need mutex here */
 	list_for_each_entry_safe(ioeventfd, ioeventfd_tmp,
 				 &vdev->ioeventfds_list, next) {
@@ -709,6 +717,9 @@ static int vfio_pci_get_irq_count(struct vfio_pci_dev=
ice *vdev, int irq_type)
 			return 1;
 	} else if (irq_type =3D=3D VFIO_PCI_REQ_IRQ_INDEX) {
 		return 1;
+	} else if (irq_type >=3D VFIO_PCI_NUM_IRQS &&
+		   irq_type < VFIO_PCI_NUM_IRQS + vdev->num_ext_irqs) {
+		return 1;
 	}
=20
 	return 0;
@@ -878,7 +889,7 @@ static long vfio_pci_ioctl(void *device_data,
 			info.flags |=3D VFIO_DEVICE_FLAGS_RESET;
=20
 		info.num_regions =3D VFIO_PCI_NUM_REGIONS + vdev->num_regions;
-		info.num_irqs =3D VFIO_PCI_NUM_IRQS;
+		info.num_irqs =3D VFIO_PCI_NUM_IRQS + vdev->num_ext_irqs;
=20
 		return copy_to_user((void __user *)arg, &info, minsz) ?
 			-EFAULT : 0;
@@ -1033,36 +1044,88 @@ static long vfio_pci_ioctl(void *device_data,
=20
 	} else if (cmd =3D=3D VFIO_DEVICE_GET_IRQ_INFO) {
 		struct vfio_irq_info info;
+		struct vfio_info_cap caps =3D { .buf =3D NULL, .size =3D 0 };
+		unsigned long capsz;
=20
 		minsz =3D offsetofend(struct vfio_irq_info, count);
=20
+		/* For backward compatibility, cannot require this */
+		capsz =3D offsetofend(struct vfio_irq_info, cap_offset);
+
 		if (copy_from_user(&info, (void __user *)arg, minsz))
 			return -EFAULT;
=20
-		if (info.argsz < minsz || info.index >=3D VFIO_PCI_NUM_IRQS)
+		if (info.argsz < minsz ||
+			info.index >=3D VFIO_PCI_NUM_IRQS + vdev->num_ext_irqs)
 			return -EINVAL;
=20
-		switch (info.index) {
-		case VFIO_PCI_INTX_IRQ_INDEX ... VFIO_PCI_MSIX_IRQ_INDEX:
-		case VFIO_PCI_REQ_IRQ_INDEX:
-			break;
-		case VFIO_PCI_ERR_IRQ_INDEX:
-			if (pci_is_pcie(vdev->pdev))
-				break;
-		/* fall through */
-		default:
-			return -EINVAL;
-		}
+		if (info.argsz >=3D capsz)
+			minsz =3D capsz;
=20
 		info.flags =3D VFIO_IRQ_INFO_EVENTFD;
=20
-		info.count =3D vfio_pci_get_irq_count(vdev, info.index);
-
-		if (info.index =3D=3D VFIO_PCI_INTX_IRQ_INDEX)
+		switch (info.index) {
+		case VFIO_PCI_INTX_IRQ_INDEX:
 			info.flags |=3D (VFIO_IRQ_INFO_MASKABLE |
 				       VFIO_IRQ_INFO_AUTOMASKED);
-		else
+			break;
+		case VFIO_PCI_MSI_IRQ_INDEX ... VFIO_PCI_MSIX_IRQ_INDEX:
+		case VFIO_PCI_REQ_IRQ_INDEX:
 			info.flags |=3D VFIO_IRQ_INFO_NORESIZE;
+			break;
+		case VFIO_PCI_ERR_IRQ_INDEX:
+			info.flags |=3D VFIO_IRQ_INFO_NORESIZE;
+			if (!pci_is_pcie(vdev->pdev))
+				return -EINVAL;
+			break;
+		/* fall through */
+		default:
+		{
+			struct vfio_irq_info_cap_type cap_type =3D {
+				.header.id =3D VFIO_IRQ_INFO_CAP_TYPE,
+				.header.version =3D 1 };
+			int ret, i;
+
+			if (info.index >=3D VFIO_PCI_NUM_IRQS +
+						vdev->num_ext_irqs)
+				return -EINVAL;
+			info.index =3D array_index_nospec(info.index,
+							VFIO_PCI_NUM_IRQS +
+							vdev->num_ext_irqs);
+			i =3D info.index - VFIO_PCI_NUM_IRQS;
+
+			info.flags =3D vdev->ext_irqs[i].flags;
+			cap_type.type =3D vdev->ext_irqs[i].type;
+			cap_type.subtype =3D vdev->ext_irqs[i].subtype;
+
+			ret =3D vfio_info_add_capability(&caps,
+					&cap_type.header,
+					sizeof(cap_type));
+			if (ret)
+				return ret;
+		}
+		}
+
+		info.count =3D vfio_pci_get_irq_count(vdev, info.index);
+
+		if (caps.size) {
+			info.flags |=3D VFIO_IRQ_INFO_FLAG_CAPS;
+			if (info.argsz < sizeof(info) + caps.size) {
+				info.argsz =3D sizeof(info) + caps.size;
+				info.cap_offset =3D 0;
+			} else {
+				vfio_info_cap_shift(&caps, sizeof(info));
+				if (copy_to_user((void __user *)arg +
+						  sizeof(info), caps.buf,
+						  caps.size)) {
+					kfree(caps.buf);
+					return -EFAULT;
+				}
+				info.cap_offset =3D sizeof(info);
+			}
+
+			kfree(caps.buf);
+		}
=20
 		return copy_to_user((void __user *)arg, &info, minsz) ?
 			-EFAULT : 0;
@@ -1081,7 +1144,8 @@ static long vfio_pci_ioctl(void *device_data,
 		max =3D vfio_pci_get_irq_count(vdev, hdr.index);
=20
 		ret =3D vfio_set_irqs_validate_and_prepare(&hdr, max,
-						 VFIO_PCI_NUM_IRQS, &data_size);
+				VFIO_PCI_NUM_IRQS + vdev->num_ext_irqs,
+				&data_size);
 		if (ret)
 			return ret;
=20
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pc=
i_intrs.c
index 2056f3f85f59..f15e2cd7ae64 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -19,6 +19,7 @@
 #include <linux/vfio.h>
 #include <linux/wait.h>
 #include <linux/slab.h>
+#include <linux/nospec.h>
=20
 #include "vfio_pci_private.h"
=20
@@ -619,6 +620,24 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_=
device *vdev,
 					       count, flags, data);
 }
=20
+static int vfio_pci_set_ext_irq_trigger(struct vfio_pci_device *vdev,
+					unsigned int index, unsigned int start,
+					unsigned int count, uint32_t flags,
+					void *data)
+{
+	int i;
+
+	if (start !=3D 0 || count > 1)
+		return -EINVAL;
+
+	index =3D array_index_nospec(index,
+				   VFIO_PCI_NUM_IRQS + vdev->num_ext_irqs);
+	i =3D index - VFIO_PCI_NUM_IRQS;
+
+	return vfio_pci_set_ctx_trigger_single(&vdev->ext_irqs[i].trigger,
+					       count, flags, data);
+}
+
 int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev, uint32_t flags=
,
 			    unsigned index, unsigned start, unsigned count,
 			    void *data)
@@ -668,6 +687,13 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *=
vdev, uint32_t flags,
 			break;
 		}
 		break;
+	default:
+		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
+		case VFIO_IRQ_SET_ACTION_TRIGGER:
+			func =3D vfio_pci_set_ext_irq_trigger;
+			break;
+		}
+		break;
 	}
=20
 	if (!func)
@@ -675,3 +701,39 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *=
vdev, uint32_t flags,
=20
 	return func(vdev, index, start, count, flags, data);
 }
+
+int vfio_pci_get_ext_irq_index(struct vfio_pci_device *vdev,
+			       unsigned int type, unsigned int subtype)
+{
+	int i;
+
+	for (i =3D 0; i <  vdev->num_ext_irqs; i++) {
+		if (vdev->ext_irqs[i].type =3D=3D type &&
+		    vdev->ext_irqs[i].subtype =3D=3D subtype) {
+			return i;
+		}
+	}
+	return -EINVAL;
+}
+
+int vfio_pci_register_irq(struct vfio_pci_device *vdev,
+			  unsigned int type, unsigned int subtype,
+			  u32 flags)
+{
+	struct vfio_ext_irq *ext_irqs;
+
+	ext_irqs =3D krealloc(vdev->ext_irqs,
+			    (vdev->num_ext_irqs + 1) * sizeof(*ext_irqs),
+			    GFP_KERNEL);
+	if (!ext_irqs)
+		return -ENOMEM;
+
+	vdev->ext_irqs =3D ext_irqs;
+
+	vdev->ext_irqs[vdev->num_ext_irqs].type =3D type;
+	vdev->ext_irqs[vdev->num_ext_irqs].subtype =3D subtype;
+	vdev->ext_irqs[vdev->num_ext_irqs].flags =3D flags;
+	vdev->ext_irqs[vdev->num_ext_irqs].trigger =3D NULL;
+	vdev->num_ext_irqs++;
+	return 0;
+}
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_=
pci_private.h
index a392f50e3a99..e296a45c136e 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -73,6 +73,13 @@ struct vfio_pci_region {
 	u32				flags;
 };
=20
+struct vfio_ext_irq {
+	u32				type;
+	u32				subtype;
+	u32				flags;
+	struct eventfd_ctx		*trigger;
+};
+
 struct vfio_pci_dummy_resource {
 	struct resource		resource;
 	int			index;
@@ -96,6 +103,8 @@ struct vfio_pci_device {
 	struct vfio_pci_irq_ctx	*ctx;
 	int			num_ctx;
 	int			irq_type;
+	struct vfio_ext_irq	*ext_irqs;
+	int			num_ext_irqs;
 	int			num_regions;
 	struct vfio_pci_region	*region;
 	u8			msi_qmax;
@@ -134,6 +143,11 @@ struct vfio_pci_device {
=20
 extern void vfio_pci_intx_mask(struct vfio_pci_device *vdev);
 extern void vfio_pci_intx_unmask(struct vfio_pci_device *vdev);
+extern int vfio_pci_register_irq(struct vfio_pci_device *vdev,
+				 unsigned int type, unsigned int subtype,
+				 u32 flags);
+extern int vfio_pci_get_ext_irq_index(struct vfio_pci_device *vdev,
+				      unsigned int type, unsigned int subtype);
=20
 extern int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev,
 				   uint32_t flags, unsigned index,
--=20
2.20.1

