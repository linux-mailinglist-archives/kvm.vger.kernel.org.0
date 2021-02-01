Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD71030ACA8
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 17:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhBAQax (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 11:30:53 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18311 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbhBAQ3z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 11:29:55 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60182c550002>; Mon, 01 Feb 2021 08:29:09 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 16:29:09 +0000
Received: from r-nvmx02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Mon, 1 Feb 2021 16:29:04 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <jgg@nvidia.com>, <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alex.williamson@redhat.com>
CC:     <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <gmataev@nvidia.com>, <cjia@nvidia.com>,
        <mjrosato@linux.ibm.com>, <yishaih@nvidia.com>, <aik@ozlabs.ru>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 7/9] vfio/pci: use s390 naming instead of zdev
Date:   Mon, 1 Feb 2021 16:28:26 +0000
Message-ID: <20210201162828.5938-8-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210201162828.5938-1-mgurtovoy@nvidia.com>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612196949; bh=rifAYHXBwiwEl9FjqeiiZbK9EnZkNXIYScLhP0slTOE=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        b=pZv7smOho3rRM0zx/qat0NhbadgSX3+1YZmRKR5FDohUoq9gQCmlrjZOYaN7RKD86
         OUhNgfUt1bgjILMvK/tZpW2WgHTfb0OVIdlwSrsPGK/TIFbwPMQjav3si/LSGbyNQP
         sArFS3yxg4nJbSAvm9hocRQUyZJlARHiPf3sKfC3syJLYYYh0YFnChnhb6bRle9vGC
         kW/tB+9L+/MIH4BfaIkH4LtrrjiU7GI2xmRoQdHfg/bDWLqdk2Ns411NZtblVv9hW+
         FOH1gr9/j8neeMGYdz0TagphHMPpYPNdwapRBo31JKR5gG8+ZzhxRuToYOj1fFSmnA
         qOwKretB8jx0A==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch doesn't change any logic but only the concept of
vfio_pci_core extensions. Extensions that are related to a platform and
not to a specific vendor of PCI devices should be part of the core
driver. Extensions that are specific for PCI device vendor should go to
a dedicated vendor vfio-pci driver.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/vfio/pci/Kconfig                              | 4 ++--
 drivers/vfio/pci/Makefile                             | 2 +-
 drivers/vfio/pci/vfio_pci_core.c                      | 2 +-
 drivers/vfio/pci/vfio_pci_private.h                   | 2 +-
 drivers/vfio/pci/{vfio_pci_zdev.c =3D> vfio_pci_s390.c} | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)
 rename drivers/vfio/pci/{vfio_pci_zdev.c =3D> vfio_pci_s390.c} (98%)

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index dcb164d7d641..6e6c976b9512 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -54,8 +54,8 @@ config VFIO_PCI_NVLINK2
 	help
 	  VFIO PCI support for P9 Witherspoon machine with NVIDIA V100 GPUs
=20
-config VFIO_PCI_ZDEV
-	bool "VFIO PCI ZPCI device CLP support"
+config VFIO_PCI_S390
+	bool "VFIO PCI extensions for S390 platform"
 	depends on VFIO_PCI_CORE && S390
 	default y
 	help
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 9f67edca31c5..90962a495eba 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -7,7 +7,7 @@ obj-$(CONFIG_MLX5_VFIO_PCI) +=3D mlx5-vfio-pci.o
 vfio-pci-core-y :=3D vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio=
_pci_config.o
 vfio-pci-core-$(CONFIG_VFIO_PCI_IGD) +=3D vfio_pci_igd.o
 vfio-pci-core-$(CONFIG_VFIO_PCI_NVLINK2) +=3D vfio_pci_nvlink2.o
-vfio-pci-core-$(CONFIG_VFIO_PCI_ZDEV) +=3D vfio_pci_zdev.o
+vfio-pci-core-$(CONFIG_VFIO_PCI_ZDEV) +=3D vfio_pci_s390.o
=20
 vfio-pci-y :=3D vfio_pci.o
=20
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_c=
ore.c
index a0a91331f575..c559027def2d 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -785,7 +785,7 @@ static long vfio_pci_core_ioctl(void *device_data, unsi=
gned int cmd,
 		info.num_regions =3D VFIO_PCI_NUM_REGIONS + vdev->num_regions;
 		info.num_irqs =3D VFIO_PCI_NUM_IRQS;
=20
-		if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV)) {
+		if (IS_ENABLED(CONFIG_VFIO_PCI_S390)) {
 			int ret =3D vfio_pci_info_zdev_add_caps(vdev, &caps);
=20
 			if (ret && ret !=3D -ENODEV) {
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pc=
i_private.h
index 1c3bb809b5c0..7c3c2cd575f8 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -188,7 +188,7 @@ static inline int vfio_pci_ibm_npu2_init(struct vfio_pc=
i_device *vdev)
 }
 #endif
=20
-#ifdef CONFIG_VFIO_PCI_ZDEV
+#ifdef CONFIG_VFIO_PCI_S390
 extern int vfio_pci_info_zdev_add_caps(struct vfio_pci_device *vdev,
 				       struct vfio_info_cap *caps);
 #else
diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_s=
390.c
similarity index 98%
rename from drivers/vfio/pci/vfio_pci_zdev.c
rename to drivers/vfio/pci/vfio_pci_s390.c
index e9ef4239ef7a..b6421a7f767f 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_s390.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * VFIO ZPCI devices support
+ * VFIO PCI support for S390 platform (a.k.a ZPCI devices)
  *
  * Copyright (C) IBM Corp. 2020.  All rights reserved.
  *	Author(s): Pierre Morel <pmorel@linux.ibm.com>
--=20
2.25.4

