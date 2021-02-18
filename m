Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2C131E9E9
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 13:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhBRMb7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 07:31:59 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15528 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231816AbhBRKpl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Feb 2021 05:45:41 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602e45170000>; Thu, 18 Feb 2021 02:44:39 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 18 Feb
 2021 10:44:38 +0000
Received: from r-nvmx02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 18 Feb 2021 10:44:36 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <alex.williamson@redhat.com>, <mjrosato@linux.ibm.com>
CC:     <oren@nvidia.com>, <jgg@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 1/1] vfio/pci: remove CONFIG_VFIO_PCI_ZDEV from Kconfig
Date:   Thu, 18 Feb 2021 10:44:35 +0000
Message-ID: <20210218104435.464773-1-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613645079; bh=z2phGOCqsGlG23NkwT0WdBZvXJFqLh5AY6/Xzsk4+mQ=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type;
        b=QmUdS800XC58UxFQBISKN5DXtpgXL2KZskaZrwhwa5FWPs/3w0V8VNK83jlDHd6Ix
         tSgwftDYaFyKwAenbPcOfSQzFjE2b5cSrAq5ye80jsD9QE7Z65CpMr/dbF5cmg5oPI
         nJQl9viRFxLdI7DAFYuN4sTfo62rD8Bq/2tZ3Ws39GE1KSETuCGrH9vUNIBeCOHO3s
         kmRCQt4QWivpitelyTIrVEdnpxwss6ToGcemx9DmBlleuHU/E9YIv3BxCSmvGjfXOe
         RbthU7aq2idf8DXND5OZRT3umVQ6/GrwzGmcH4RCHhEfomGlAQRzZdQ9KHLyOp/UgK
         ZndGZnQdw0zcg==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In case we're running on s390 system always expose the capabilities for
configuration of zPCI devices. In case we're running on different
platform, continue as usual.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/vfio/pci/Kconfig            | 12 ------------
 drivers/vfio/pci/Makefile           |  2 +-
 drivers/vfio/pci/vfio_pci.c         | 12 +++++-------
 drivers/vfio/pci/vfio_pci_private.h |  2 +-
 4 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 40a223381ab6..ac3c1dd3edef 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -45,15 +45,3 @@ config VFIO_PCI_NVLINK2
 	depends on VFIO_PCI && PPC_POWERNV
 	help
 	  VFIO PCI support for P9 Witherspoon machine with NVIDIA V100 GPUs
-
-config VFIO_PCI_ZDEV
-	bool "VFIO PCI ZPCI device CLP support"
-	depends on VFIO_PCI && S390
-	default y
-	help
-	  Enabling this option exposes VFIO capabilities containing hardware
-	  configuration for zPCI devices. This enables userspace (e.g. QEMU)
-	  to supply proper configuration values instead of hard-coded defaults
-	  for zPCI devices passed through via VFIO on s390.
-
-	  Say Y here.
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 781e0809d6ee..eff97a7cd9f1 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -3,6 +3,6 @@
 vfio-pci-y :=3D vfio_pci.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_confi=
g.o
 vfio-pci-$(CONFIG_VFIO_PCI_IGD) +=3D vfio_pci_igd.o
 vfio-pci-$(CONFIG_VFIO_PCI_NVLINK2) +=3D vfio_pci_nvlink2.o
-vfio-pci-$(CONFIG_VFIO_PCI_ZDEV) +=3D vfio_pci_zdev.o
+vfio-pci-$(CONFIG_S390) +=3D vfio_pci_zdev.o
=20
 obj-$(CONFIG_VFIO_PCI) +=3D vfio-pci.o
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 706de3ef94bb..65e7e6b44578 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -807,6 +807,7 @@ static long vfio_pci_ioctl(void *device_data,
 		struct vfio_device_info info;
 		struct vfio_info_cap caps =3D { .buf =3D NULL, .size =3D 0 };
 		unsigned long capsz;
+		int ret;
=20
 		minsz =3D offsetofend(struct vfio_device_info, num_irqs);
=20
@@ -832,13 +833,10 @@ static long vfio_pci_ioctl(void *device_data,
 		info.num_regions =3D VFIO_PCI_NUM_REGIONS + vdev->num_regions;
 		info.num_irqs =3D VFIO_PCI_NUM_IRQS;
=20
-		if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV)) {
-			int ret =3D vfio_pci_info_zdev_add_caps(vdev, &caps);
-
-			if (ret && ret !=3D -ENODEV) {
-				pci_warn(vdev->pdev, "Failed to setup zPCI info capabilities\n");
-				return ret;
-			}
+		ret =3D vfio_pci_info_zdev_add_caps(vdev, &caps);
+		if (ret && ret !=3D -ENODEV) {
+			pci_warn(vdev->pdev, "Failed to setup zPCI info capabilities\n");
+			return ret;
 		}
=20
 		if (caps.size) {
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pc=
i_private.h
index 5c90e560c5c7..9cd1882a05af 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -214,7 +214,7 @@ static inline int vfio_pci_ibm_npu2_init(struct vfio_pc=
i_device *vdev)
 }
 #endif
=20
-#ifdef CONFIG_VFIO_PCI_ZDEV
+#ifdef CONFIG_S390
 extern int vfio_pci_info_zdev_add_caps(struct vfio_pci_device *vdev,
 				       struct vfio_info_cap *caps);
 #else
--=20
2.25.4

