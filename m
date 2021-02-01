Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1DE330ACA6
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 17:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbhBAQaq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 11:30:46 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:9219 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbhBAQaA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 11:30:00 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60182c5f0000>; Mon, 01 Feb 2021 08:29:19 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 16:29:19 +0000
Received: from r-nvmx02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Mon, 1 Feb 2021 16:29:14 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <jgg@nvidia.com>, <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alex.williamson@redhat.com>
CC:     <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <gmataev@nvidia.com>, <cjia@nvidia.com>,
        <mjrosato@linux.ibm.com>, <yishaih@nvidia.com>, <aik@ozlabs.ru>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 9/9] vfio/pci: use powernv naming instead of nvlink2
Date:   Mon, 1 Feb 2021 16:28:28 +0000
Message-ID: <20210201162828.5938-10-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210201162828.5938-1-mgurtovoy@nvidia.com>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612196959; bh=PL1cT4xPs7B2FwQiAAgPtb8jyvIT3V5js+sZPZ7/YqY=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        b=ioPzzw7TcLGQRKsZk2j6fICeqWPpvmpQ/gWmI26PxtwbcGs/fOkqPENi/namLDsHh
         CwmWnngw30922ZaTa15Cq8rNM1MHSUG15F9OZYtcsq0+tLRorCFUrm4sNHK+Rqcj+m
         ZZvd+l6zQQzU3zE1K0RCUBx21w+BpVy3+puzC70/iKljoRLLr3Fg2FJGRvd5bUimVa
         2SDIM6af7wCATlJi5QyrmGfXLtV3rIDQEOtzVnuKqj21t/JRjX4Uo9YDXyIx6i6Cv9
         dq+0rOU2MZtWji6xMHFE/VmAE26LM6gtwY3NZrXzzU16kt5pWISrZ1f1lUjmCRIbGh
         98CPxDoqpicRA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch doesn't change any logic but only align to the concept of
vfio_pci_core extensions. Extensions that are related to a platform
and not to a specific vendor of PCI devices should be part of the
core driver. Extensions that are specific for PCI device vendor should go
to a dedicated vendor vfio-pci driver.

For now, powernv extensions will include only nvlink2.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/vfio/pci/Kconfig                                    | 6 ++++--
 drivers/vfio/pci/Makefile                                   | 2 +-
 drivers/vfio/pci/vfio_pci_core.c                            | 4 ++--
 drivers/vfio/pci/{vfio_pci_nvlink2.c =3D> vfio_pci_powernv.c} | 0
 drivers/vfio/pci/vfio_pci_private.h                         | 2 +-
 5 files changed, 8 insertions(+), 6 deletions(-)
 rename drivers/vfio/pci/{vfio_pci_nvlink2.c =3D> vfio_pci_powernv.c} (100%=
)

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index c98f2df01a60..fe0264b3d02f 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -47,11 +47,13 @@ config VFIO_PCI_X86
=20
 	  To enable Intel X86 extensions for vfio-pci-core, say Y.
=20
-config VFIO_PCI_NVLINK2
+config VFIO_PCI_POWERNV
 	def_bool y
 	depends on VFIO_PCI_CORE && PPC_POWERNV
 	help
-	  VFIO PCI support for P9 Witherspoon machine with NVIDIA V100 GPUs
+	  VFIO PCI extensions for IBM PowerNV (Non-Virtualized) platform
+
+	  To enable POWERNV extensions for vfio-pci-core, say Y.
=20
 config VFIO_PCI_S390
 	bool "VFIO PCI extensions for S390 platform"
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index d8ccb70e015a..442b7c78de4c 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -6,7 +6,7 @@ obj-$(CONFIG_MLX5_VFIO_PCI) +=3D mlx5-vfio-pci.o
=20
 vfio-pci-core-y :=3D vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio=
_pci_config.o
 vfio-pci-core-$(CONFIG_VFIO_PCI_X86) +=3D vfio_pci_x86.o
-vfio-pci-core-$(CONFIG_VFIO_PCI_NVLINK2) +=3D vfio_pci_nvlink2.o
+vfio-pci-core-$(CONFIG_VFIO_PCI_POWERNV) +=3D vfio_pci_powernv.o
 vfio-pci-core-$(CONFIG_VFIO_PCI_ZDEV) +=3D vfio_pci_s390.o
=20
 vfio-pci-y :=3D vfio_pci.o
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_c=
ore.c
index e0e258c37fb5..90cc728fffc7 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -337,7 +337,7 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev=
)
 	}
=20
 	if (pdev->vendor =3D=3D PCI_VENDOR_ID_NVIDIA &&
-	    IS_ENABLED(CONFIG_VFIO_PCI_NVLINK2)) {
+	    IS_ENABLED(CONFIG_VFIO_PCI_POWERNV)) {
 		ret =3D vfio_pci_nvdia_v100_nvlink2_init(vdev);
 		if (ret && ret !=3D -ENODEV) {
 			pci_warn(pdev, "Failed to setup NVIDIA NV2 RAM region\n");
@@ -346,7 +346,7 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev=
)
 	}
=20
 	if (pdev->vendor =3D=3D PCI_VENDOR_ID_IBM &&
-	    IS_ENABLED(CONFIG_VFIO_PCI_NVLINK2)) {
+	    IS_ENABLED(CONFIG_VFIO_PCI_POWERNV)) {
 		ret =3D vfio_pci_ibm_npu2_init(vdev);
 		if (ret && ret !=3D -ENODEV) {
 			pci_warn(pdev, "Failed to setup NVIDIA NV2 ATSD region\n");
diff --git a/drivers/vfio/pci/vfio_pci_nvlink2.c b/drivers/vfio/pci/vfio_pc=
i_powernv.c
similarity index 100%
rename from drivers/vfio/pci/vfio_pci_nvlink2.c
rename to drivers/vfio/pci/vfio_pci_powernv.c
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pc=
i_private.h
index efc688525784..dc6a9191a704 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -173,7 +173,7 @@ static inline int vfio_pci_igd_init(struct vfio_pci_dev=
ice *vdev)
 	return -ENODEV;
 }
 #endif
-#ifdef CONFIG_VFIO_PCI_NVLINK2
+#ifdef CONFIG_VFIO_PCI_POWERNV
 extern int vfio_pci_nvdia_v100_nvlink2_init(struct vfio_pci_device *vdev);
 extern int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vdev);
 #else
--=20
2.25.4

