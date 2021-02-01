Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 554A830ACA5
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 17:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbhBAQai (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 11:30:38 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18360 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbhBAQaJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 11:30:09 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60182c5a0001>; Mon, 01 Feb 2021 08:29:14 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 16:29:14 +0000
Received: from r-nvmx02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Mon, 1 Feb 2021 16:29:09 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <jgg@nvidia.com>, <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alex.williamson@redhat.com>
CC:     <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <gmataev@nvidia.com>, <cjia@nvidia.com>,
        <mjrosato@linux.ibm.com>, <yishaih@nvidia.com>, <aik@ozlabs.ru>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
Date:   Mon, 1 Feb 2021 16:28:27 +0000
Message-ID: <20210201162828.5938-9-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210201162828.5938-1-mgurtovoy@nvidia.com>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612196954; bh=2dRPmnhvotzgAArbVVaHVwd/Yfn7abu3JLVRuSf7Ykg=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        b=kxSW8WVkgWdNJY7BlQL/l858Kkqt/Z27DYvgXvyNDTgCH4cfvbHszNA7S/PGmCetM
         x74O0YddE3zUPYQTaBYEhpT7nhGurrR1kWyrp3IZuaMwLmJjUwT8jKLKCwq87jYLpv
         KHxgoP1+ZcXyUGlWb+jqZgRE4z55iNo6+SR2jW4iE7ScOun3Gtx3nHtynLifcgzhnP
         Qgbl5SJE0aCYJ2dzlDF0aDDI9ILdBipxyDhnML8Ppwk/YppD3oyfY7cEcAsKwJ2it2
         AlMN4DRMahcN88sj9mpHJCxywxHWf38bxM1jgdGApJRTosh0hoTDBykIUtMyOWHaFI
         Mles0OYruf4Ww==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch doesn't change any logic but only align to the concept of
vfio_pci_core extensions. Extensions that are related to a platform
and not to a specific vendor of PCI devices should be part of the core
driver. Extensions that are specific for PCI device vendor should go
to a dedicated vendor vfio-pci driver.

For now, x86 extensions will include only igd.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/vfio/pci/Kconfig                            | 13 ++++++-------
 drivers/vfio/pci/Makefile                           |  2 +-
 drivers/vfio/pci/vfio_pci_core.c                    |  2 +-
 drivers/vfio/pci/vfio_pci_private.h                 |  2 +-
 drivers/vfio/pci/{vfio_pci_igd.c =3D> vfio_pci_x86.c} |  0
 5 files changed, 9 insertions(+), 10 deletions(-)
 rename drivers/vfio/pci/{vfio_pci_igd.c =3D> vfio_pci_x86.c} (100%)

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 6e6c976b9512..c98f2df01a60 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -36,17 +36,16 @@ config VFIO_PCI_INTX
 	depends on VFIO_PCI_CORE
 	def_bool y if !S390
=20
-config VFIO_PCI_IGD
-	bool "VFIO PCI extensions for Intel graphics (GVT-d)"
+config VFIO_PCI_X86
+	bool "VFIO PCI extensions for Intel X86 platform"
 	depends on VFIO_PCI_CORE && X86
 	default y
 	help
-	  Support for Intel IGD specific extensions to enable direct
-	  assignment to virtual machines.  This includes exposing an IGD
-	  specific firmware table and read-only copies of the host bridge
-	  and LPC bridge config space.
+	  Support for Intel X86 specific extensions for VFIO PCI devices.
+	  This includes exposing an IGD specific firmware table and
+	  read-only copies of the host bridge and LPC bridge config space.
=20
-	  To enable Intel IGD assignment through vfio-pci, say Y.
+	  To enable Intel X86 extensions for vfio-pci-core, say Y.
=20
 config VFIO_PCI_NVLINK2
 	def_bool y
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 90962a495eba..d8ccb70e015a 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -5,7 +5,7 @@ obj-$(CONFIG_VFIO_PCI) +=3D vfio-pci.o
 obj-$(CONFIG_MLX5_VFIO_PCI) +=3D mlx5-vfio-pci.o
=20
 vfio-pci-core-y :=3D vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio=
_pci_config.o
-vfio-pci-core-$(CONFIG_VFIO_PCI_IGD) +=3D vfio_pci_igd.o
+vfio-pci-core-$(CONFIG_VFIO_PCI_X86) +=3D vfio_pci_x86.o
 vfio-pci-core-$(CONFIG_VFIO_PCI_NVLINK2) +=3D vfio_pci_nvlink2.o
 vfio-pci-core-$(CONFIG_VFIO_PCI_ZDEV) +=3D vfio_pci_s390.o
=20
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_c=
ore.c
index c559027def2d..e0e258c37fb5 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -328,7 +328,7 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev=
)
=20
 	if (vfio_pci_is_vga(pdev) &&
 	    pdev->vendor =3D=3D PCI_VENDOR_ID_INTEL &&
-	    IS_ENABLED(CONFIG_VFIO_PCI_IGD)) {
+	    IS_ENABLED(CONFIG_VFIO_PCI_X86)) {
 		ret =3D vfio_pci_igd_init(vdev);
 		if (ret && ret !=3D -ENODEV) {
 			pci_warn(pdev, "Failed to setup Intel IGD regions\n");
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pc=
i_private.h
index 7c3c2cd575f8..efc688525784 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -165,7 +165,7 @@ extern u16 vfio_pci_memory_lock_and_enable(struct vfio_=
pci_device *vdev);
 extern void vfio_pci_memory_unlock_and_restore(struct vfio_pci_device *vde=
v,
 					       u16 cmd);
=20
-#ifdef CONFIG_VFIO_PCI_IGD
+#ifdef CONFIG_VFIO_PCI_X86
 extern int vfio_pci_igd_init(struct vfio_pci_device *vdev);
 #else
 static inline int vfio_pci_igd_init(struct vfio_pci_device *vdev)
diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_x8=
6.c
similarity index 100%
rename from drivers/vfio/pci/vfio_pci_igd.c
rename to drivers/vfio/pci/vfio_pci_x86.c
--=20
2.25.4

