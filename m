Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C36B730AC99
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 17:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbhBAQ3j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 11:29:39 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:19037 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbhBAQ3b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 11:29:31 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60182c410000>; Mon, 01 Feb 2021 08:28:49 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 16:28:49 +0000
Received: from r-nvmx02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Mon, 1 Feb 2021 16:28:44 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <jgg@nvidia.com>, <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alex.williamson@redhat.com>
CC:     <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <gmataev@nvidia.com>, <cjia@nvidia.com>,
        <mjrosato@linux.ibm.com>, <yishaih@nvidia.com>, <aik@ozlabs.ru>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 3/9] vfio-pci-core: export vfio_pci_register_dev_region function
Date:   Mon, 1 Feb 2021 16:28:22 +0000
Message-ID: <20210201162828.5938-4-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210201162828.5938-1-mgurtovoy@nvidia.com>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612196929; bh=MsBQORf9GSTrqO3R+rTgHR9iItZnKZhD2Sx4Nb3QTPw=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        b=bqt9NZBE+pa0IIL3QiDkGSLC4uzrAW+eVQRJIbXX5QY3I/AROxgYSJpSGE3sYg+Sh
         UQpHcpMC6ga8WwkLRsptp+mcaQ5rsafxKbBy40iUpWpMuxCZXjBFvgfGkSEuP+01sP
         N791WslNPwxkVSPJpfeuz+mXzDmIG4VYog+p7xszPd838eZrKWyynpEGX5VPAkMt5v
         0P7Y72cKpQNJejITSzN6ppORUrpgJTHDzmmzaEutjigCyoOt82g+2tyWzhve0jdR/J
         ww9hNVB/0zf8TX9LxADuJNN4EmRJIQPTXVOlXLWByqkMpAzH8/wtGoCgWem8r2BcMj
         EZZMTQFJt9gWw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This function will be used to allow vendor drivers to register regions
to be used and accessed by the core subsystem driver. This way, the core
will use the region ops that are vendor specific and managed by the
vendor vfio-pci driver.

Next step that can be made is to move the logic of igd and nvlink to a
dedicated module instead of managing their functionality in the core
driver.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c    | 12 +++++-----
 drivers/vfio/pci/vfio_pci_core.h    | 28 ++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_igd.c     | 16 ++++++++------
 drivers/vfio/pci/vfio_pci_nvlink2.c | 25 +++++++++++----------
 drivers/vfio/pci/vfio_pci_private.h | 34 +++++------------------------
 5 files changed, 64 insertions(+), 51 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_c=
ore.c
index d5bf01132c23..a0a91331f575 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -395,7 +395,7 @@ static void vfio_pci_disable(struct vfio_pci_device *vd=
ev)
 	vdev->virq_disabled =3D false;
=20
 	for (i =3D 0; i < vdev->num_regions; i++)
-		vdev->region[i].ops->release(vdev, &vdev->region[i]);
+		vdev->region[i].ops->release(&vdev->vpdev, &vdev->region[i]);
=20
 	vdev->num_regions =3D 0;
 	kfree(vdev->region);
@@ -716,11 +716,12 @@ static int msix_mmappable_cap(struct vfio_pci_device =
*vdev,
 	return vfio_info_add_capability(caps, &header, sizeof(header));
 }
=20
-int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
+int vfio_pci_register_dev_region(struct vfio_pci_core_device *vpdev,
 				 unsigned int type, unsigned int subtype,
 				 const struct vfio_pci_regops *ops,
 				 size_t size, u32 flags, void *data)
 {
+	struct vfio_pci_device *vdev =3D vpdev_to_vdev(vpdev);
 	struct vfio_pci_region *region;
=20
 	region =3D krealloc(vdev->region,
@@ -741,6 +742,7 @@ int vfio_pci_register_dev_region(struct vfio_pci_device=
 *vdev,
=20
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_register_dev_region);
=20
 struct vfio_devices {
 	struct vfio_device **devices;
@@ -928,7 +930,7 @@ static long vfio_pci_core_ioctl(void *device_data, unsi=
gned int cmd,
 				return ret;
=20
 			if (vdev->region[i].ops->add_capability) {
-				ret =3D vdev->region[i].ops->add_capability(vdev,
+				ret =3D vdev->region[i].ops->add_capability(&vdev->vpdev,
 						&vdev->region[i], &caps);
 				if (ret)
 					return ret;
@@ -1379,7 +1381,7 @@ static ssize_t vfio_pci_rw(struct vfio_pci_device *vd=
ev, char __user *buf,
 		return vfio_pci_vga_rw(vdev, buf, count, ppos, iswrite);
 	default:
 		index -=3D VFIO_PCI_NUM_REGIONS;
-		return vdev->region[index].ops->rw(vdev, buf,
+		return vdev->region[index].ops->rw(&vdev->vpdev, buf,
 						   count, ppos, iswrite);
 	}
=20
@@ -1622,7 +1624,7 @@ static int vfio_pci_core_mmap(void *device_data, stru=
ct vm_area_struct *vma)
=20
 		if (region && region->ops && region->ops->mmap &&
 		    (region->flags & VFIO_REGION_INFO_FLAG_MMAP))
-			return region->ops->mmap(vdev, region, vma);
+			return region->ops->mmap(&vdev->vpdev, region, vma);
 		return -EINVAL;
 	}
 	if (index >=3D VFIO_PCI_ROM_REGION_INDEX)
diff --git a/drivers/vfio/pci/vfio_pci_core.h b/drivers/vfio/pci/vfio_pci_c=
ore.h
index 9833935af735..0b227ee3f377 100644
--- a/drivers/vfio/pci/vfio_pci_core.h
+++ b/drivers/vfio/pci/vfio_pci_core.h
@@ -15,6 +15,7 @@
 #define VFIO_PCI_CORE_H
=20
 struct vfio_pci_device_ops;
+struct vfio_pci_region;
=20
 struct vfio_pci_core_device {
 	struct pci_dev				*pdev;
@@ -22,6 +23,29 @@ struct vfio_pci_core_device {
 	void					*dd_data;
 };
=20
+struct vfio_pci_regops {
+	size_t	(*rw)(struct vfio_pci_core_device *vpdev, char __user *buf,
+		      size_t count, loff_t *ppos, bool iswrite);
+	void	(*release)(struct vfio_pci_core_device *vpdev,
+			   struct vfio_pci_region *region);
+	int	(*mmap)(struct vfio_pci_core_device *vpdev,
+			struct vfio_pci_region *region,
+			struct vm_area_struct *vma);
+	int	(*add_capability)(struct vfio_pci_core_device *vpdev,
+				  struct vfio_pci_region *region,
+				  struct vfio_info_cap *caps);
+};
+
+struct vfio_pci_region {
+	u32				type;
+	u32				subtype;
+	const struct vfio_pci_regops	*ops;
+	void				*data;
+	size_t				size;
+	u32				flags;
+};
+
+
 /**
  * struct vfio_pci_device_ops - VFIO PCI device callbacks
  *
@@ -41,5 +65,9 @@ void vfio_destroy_pci_device(struct pci_dev *pdev);
 int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn);
 pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
 		pci_channel_state_t state);
+int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
+		unsigned int type, unsigned int subtype,
+		const struct vfio_pci_regops *ops,
+		size_t size, u32 flags, void *data);
=20
 #endif /* VFIO_PCI_CORE_H */
diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_ig=
d.c
index 0cab3c2d35f6..0a9e0edbb0ac 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/vfio_pci_igd.c
@@ -21,9 +21,10 @@
 #define OPREGION_SIZE		(8 * 1024)
 #define OPREGION_PCI_ADDR	0xfc
=20
-static size_t vfio_pci_igd_rw(struct vfio_pci_device *vdev, char __user *b=
uf,
+static size_t vfio_pci_igd_rw(struct vfio_pci_core_device *vpdev, char __u=
ser *buf,
 			      size_t count, loff_t *ppos, bool iswrite)
 {
+	struct vfio_pci_device *vdev =3D vpdev_to_vdev(vpdev);
 	unsigned int i =3D VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS=
;
 	void *base =3D vdev->region[i].data;
 	loff_t pos =3D *ppos & VFIO_PCI_OFFSET_MASK;
@@ -41,7 +42,7 @@ static size_t vfio_pci_igd_rw(struct vfio_pci_device *vde=
v, char __user *buf,
 	return count;
 }
=20
-static void vfio_pci_igd_release(struct vfio_pci_device *vdev,
+static void vfio_pci_igd_release(struct vfio_pci_core_device *vpdev,
 				 struct vfio_pci_region *region)
 {
 	memunmap(region->data);
@@ -90,7 +91,7 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_dev=
ice *vdev)
 			return -ENOMEM;
 	}
=20
-	ret =3D vfio_pci_register_dev_region(vdev,
+	ret =3D vfio_pci_register_dev_region(&vdev->vpdev,
 		PCI_VENDOR_ID_INTEL | VFIO_REGION_TYPE_PCI_VENDOR_TYPE,
 		VFIO_REGION_SUBTYPE_INTEL_IGD_OPREGION,
 		&vfio_pci_igd_regops, size, VFIO_REGION_INFO_FLAG_READ, base);
@@ -107,10 +108,11 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci=
_device *vdev)
 	return ret;
 }
=20
-static size_t vfio_pci_igd_cfg_rw(struct vfio_pci_device *vdev,
+static size_t vfio_pci_igd_cfg_rw(struct vfio_pci_core_device *vpdev,
 				  char __user *buf, size_t count, loff_t *ppos,
 				  bool iswrite)
 {
+	struct vfio_pci_device *vdev =3D vpdev_to_vdev(vpdev);
 	unsigned int i =3D VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS=
;
 	struct pci_dev *pdev =3D vdev->region[i].data;
 	loff_t pos =3D *ppos & VFIO_PCI_OFFSET_MASK;
@@ -200,7 +202,7 @@ static size_t vfio_pci_igd_cfg_rw(struct vfio_pci_devic=
e *vdev,
 	return count;
 }
=20
-static void vfio_pci_igd_cfg_release(struct vfio_pci_device *vdev,
+static void vfio_pci_igd_cfg_release(struct vfio_pci_core_device *vpdev,
 				     struct vfio_pci_region *region)
 {
 	struct pci_dev *pdev =3D region->data;
@@ -228,7 +230,7 @@ static int vfio_pci_igd_cfg_init(struct vfio_pci_device=
 *vdev)
 		return -EINVAL;
 	}
=20
-	ret =3D vfio_pci_register_dev_region(vdev,
+	ret =3D vfio_pci_register_dev_region(&vdev->vpdev,
 		PCI_VENDOR_ID_INTEL | VFIO_REGION_TYPE_PCI_VENDOR_TYPE,
 		VFIO_REGION_SUBTYPE_INTEL_IGD_HOST_CFG,
 		&vfio_pci_igd_cfg_regops, host_bridge->cfg_size,
@@ -248,7 +250,7 @@ static int vfio_pci_igd_cfg_init(struct vfio_pci_device=
 *vdev)
 		return -EINVAL;
 	}
=20
-	ret =3D vfio_pci_register_dev_region(vdev,
+	ret =3D vfio_pci_register_dev_region(&vdev->vpdev,
 		PCI_VENDOR_ID_INTEL | VFIO_REGION_TYPE_PCI_VENDOR_TYPE,
 		VFIO_REGION_SUBTYPE_INTEL_IGD_LPC_CFG,
 		&vfio_pci_igd_cfg_regops, lpc_bridge->cfg_size,
diff --git a/drivers/vfio/pci/vfio_pci_nvlink2.c b/drivers/vfio/pci/vfio_pc=
i_nvlink2.c
index 80f0de332338..a682e2bc9175 100644
--- a/drivers/vfio/pci/vfio_pci_nvlink2.c
+++ b/drivers/vfio/pci/vfio_pci_nvlink2.c
@@ -39,9 +39,10 @@ struct vfio_pci_nvgpu_data {
 	struct notifier_block group_notifier;
 };
=20
-static size_t vfio_pci_nvgpu_rw(struct vfio_pci_device *vdev,
+static size_t vfio_pci_nvgpu_rw(struct vfio_pci_core_device *vpdev,
 		char __user *buf, size_t count, loff_t *ppos, bool iswrite)
 {
+	struct vfio_pci_device *vdev =3D vpdev_to_vdev(vpdev);
 	unsigned int i =3D VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS=
;
 	struct vfio_pci_nvgpu_data *data =3D vdev->region[i].data;
 	loff_t pos =3D *ppos & VFIO_PCI_OFFSET_MASK;
@@ -89,7 +90,7 @@ static size_t vfio_pci_nvgpu_rw(struct vfio_pci_device *v=
dev,
 	return count;
 }
=20
-static void vfio_pci_nvgpu_release(struct vfio_pci_device *vdev,
+static void vfio_pci_nvgpu_release(struct vfio_pci_core_device *vpdev,
 		struct vfio_pci_region *region)
 {
 	struct vfio_pci_nvgpu_data *data =3D region->data;
@@ -136,7 +137,7 @@ static const struct vm_operations_struct vfio_pci_nvgpu=
_mmap_vmops =3D {
 	.fault =3D vfio_pci_nvgpu_mmap_fault,
 };
=20
-static int vfio_pci_nvgpu_mmap(struct vfio_pci_device *vdev,
+static int vfio_pci_nvgpu_mmap(struct vfio_pci_core_device *vpdev,
 		struct vfio_pci_region *region, struct vm_area_struct *vma)
 {
 	int ret;
@@ -165,13 +166,13 @@ static int vfio_pci_nvgpu_mmap(struct vfio_pci_device=
 *vdev,
 	ret =3D (int) mm_iommu_newdev(data->mm, data->useraddr,
 			vma_pages(vma), data->gpu_hpa, &data->mem);
=20
-	trace_vfio_pci_nvgpu_mmap(vdev->vpdev.pdev, data->gpu_hpa, data->useraddr=
,
+	trace_vfio_pci_nvgpu_mmap(vpdev->pdev, data->gpu_hpa, data->useraddr,
 			vma->vm_end - vma->vm_start, ret);
=20
 	return ret;
 }
=20
-static int vfio_pci_nvgpu_add_capability(struct vfio_pci_device *vdev,
+static int vfio_pci_nvgpu_add_capability(struct vfio_pci_core_device *vpde=
v,
 		struct vfio_pci_region *region, struct vfio_info_cap *caps)
 {
 	struct vfio_pci_nvgpu_data *data =3D region->data;
@@ -275,7 +276,7 @@ int vfio_pci_nvdia_v100_nvlink2_init(struct vfio_pci_de=
vice *vdev)
 	vfio_unregister_notifier(&data->gpdev->dev, VFIO_GROUP_NOTIFY,
 			&data->group_notifier);
=20
-	ret =3D vfio_pci_register_dev_region(vdev,
+	ret =3D vfio_pci_register_dev_region(&vdev->vpdev,
 			PCI_VENDOR_ID_NVIDIA | VFIO_REGION_TYPE_PCI_VENDOR_TYPE,
 			VFIO_REGION_SUBTYPE_NVIDIA_NVLINK2_RAM,
 			&vfio_pci_nvgpu_regops,
@@ -304,9 +305,10 @@ struct vfio_pci_npu2_data {
 	unsigned int link_speed; /* The link speed from DT's ibm,nvlink-speed */
 };
=20
-static size_t vfio_pci_npu2_rw(struct vfio_pci_device *vdev,
+static size_t vfio_pci_npu2_rw(struct vfio_pci_core_device *vpdev,
 		char __user *buf, size_t count, loff_t *ppos, bool iswrite)
 {
+	struct vfio_pci_device *vdev =3D vpdev_to_vdev(vpdev);
 	unsigned int i =3D VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS=
;
 	struct vfio_pci_npu2_data *data =3D vdev->region[i].data;
 	loff_t pos =3D *ppos & VFIO_PCI_OFFSET_MASK;
@@ -328,9 +330,10 @@ static size_t vfio_pci_npu2_rw(struct vfio_pci_device =
*vdev,
 	return count;
 }
=20
-static int vfio_pci_npu2_mmap(struct vfio_pci_device *vdev,
+static int vfio_pci_npu2_mmap(struct vfio_pci_core_device *vpdev,
 		struct vfio_pci_region *region, struct vm_area_struct *vma)
 {
+	struct vfio_pci_device *vdev =3D vpdev_to_vdev(vpdev);
 	int ret;
 	struct vfio_pci_npu2_data *data =3D region->data;
 	unsigned long req_len =3D vma->vm_end - vma->vm_start;
@@ -349,7 +352,7 @@ static int vfio_pci_npu2_mmap(struct vfio_pci_device *v=
dev,
 	return ret;
 }
=20
-static void vfio_pci_npu2_release(struct vfio_pci_device *vdev,
+static void vfio_pci_npu2_release(struct vfio_pci_core_device *vpdev,
 		struct vfio_pci_region *region)
 {
 	struct vfio_pci_npu2_data *data =3D region->data;
@@ -358,7 +361,7 @@ static void vfio_pci_npu2_release(struct vfio_pci_devic=
e *vdev,
 	kfree(data);
 }
=20
-static int vfio_pci_npu2_add_capability(struct vfio_pci_device *vdev,
+static int vfio_pci_npu2_add_capability(struct vfio_pci_core_device *vpdev=
,
 		struct vfio_pci_region *region, struct vfio_info_cap *caps)
 {
 	struct vfio_pci_npu2_data *data =3D region->data;
@@ -466,7 +469,7 @@ int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vdev=
)
 	 * belong to VFIO regions and normally there will be ATSD register
 	 * assigned to the NVLink bridge.
 	 */
-	ret =3D vfio_pci_register_dev_region(vdev,
+	ret =3D vfio_pci_register_dev_region(&vdev->vpdev,
 			PCI_VENDOR_ID_IBM |
 			VFIO_REGION_TYPE_PCI_VENDOR_TYPE,
 			VFIO_REGION_SUBTYPE_IBM_NVLINK2_ATSD,
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pc=
i_private.h
index 82de00508377..1c3bb809b5c0 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -55,29 +55,6 @@ struct vfio_pci_irq_ctx {
 };
=20
 struct vfio_pci_device;
-struct vfio_pci_region;
-
-struct vfio_pci_regops {
-	size_t	(*rw)(struct vfio_pci_device *vdev, char __user *buf,
-		      size_t count, loff_t *ppos, bool iswrite);
-	void	(*release)(struct vfio_pci_device *vdev,
-			   struct vfio_pci_region *region);
-	int	(*mmap)(struct vfio_pci_device *vdev,
-			struct vfio_pci_region *region,
-			struct vm_area_struct *vma);
-	int	(*add_capability)(struct vfio_pci_device *vdev,
-				  struct vfio_pci_region *region,
-				  struct vfio_info_cap *caps);
-};
-
-struct vfio_pci_region {
-	u32				type;
-	u32				subtype;
-	const struct vfio_pci_regops	*ops;
-	void				*data;
-	size_t				size;
-	u32				flags;
-};
=20
 struct vfio_pci_dummy_resource {
 	struct resource		resource;
@@ -178,11 +155,6 @@ extern void vfio_pci_uninit_perm_bits(void);
 extern int vfio_config_init(struct vfio_pci_device *vdev);
 extern void vfio_config_free(struct vfio_pci_device *vdev);
=20
-extern int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
-					unsigned int type, unsigned int subtype,
-					const struct vfio_pci_regops *ops,
-					size_t size, u32 flags, void *data);
-
 extern int vfio_pci_set_power_state(struct vfio_pci_device *vdev,
 				    pci_power_t state);
=20
@@ -227,4 +199,10 @@ static inline int vfio_pci_info_zdev_add_caps(struct v=
fio_pci_device *vdev,
 }
 #endif
=20
+static inline struct vfio_pci_device*
+vpdev_to_vdev(struct vfio_pci_core_device *vpdev)
+{
+	return container_of(vpdev, struct vfio_pci_device, vpdev);
+}
+
 #endif /* VFIO_PCI_PRIVATE_H */
--=20
2.25.4

