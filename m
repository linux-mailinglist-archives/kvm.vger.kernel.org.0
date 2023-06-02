Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81DAA720B00
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 23:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236437AbjFBVeg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 17:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234676AbjFBVee (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 17:34:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E79E1B6
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 14:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685741629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C4a1N6kPI4SeLMI0qIC1LUfKxMNOfKPHdSZpONInoYw=;
        b=YhvTd7covzdNKqkiqmREueYJ7pBKrWx7H6G1g6vYeYLYS6eKmQs+ZIoLS1GaT4Jb1TsmmD
        9wETPFTEePXQ2dpsAhT2u5hb+1NaVDFPDbF9jk0yQHf4EQV3jTpJKjuynsb3h3+6Q4YrQV
        A4WnmHlbViDjPBmyZsCqlwlU7tU939g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-384-Hz4OoDpkO7qzeavY0OQI-w-1; Fri, 02 Jun 2023 17:33:43 -0400
X-MC-Unique: Hz4OoDpkO7qzeavY0OQI-w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 280233806707;
        Fri,  2 Jun 2023 21:33:43 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.33.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8C3CA492B00;
        Fri,  2 Jun 2023 21:33:42 +0000 (UTC)
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>, jgg@nvidia.com,
        clg@redhat.com, liulongfang@huawei.com,
        shameerali.kolothum.thodi@huawei.com, yishaih@nvidia.com,
        kevin.tian@intel.com
Subject: [PATCH 1/3] vfio/pci: Cleanup Kconfig
Date:   Fri,  2 Jun 2023 15:33:13 -0600
Message-Id: <20230602213315.2521442-2-alex.williamson@redhat.com>
In-Reply-To: <20230602213315.2521442-1-alex.williamson@redhat.com>
References: <20230602213315.2521442-1-alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It should be possible to select vfio-pci variant drivers without building
vfio-pci itself, which implies each variant driver should select
vfio-pci-core.

Fix the top level vfio Makefile to traverse pci based on vfio-pci-core
rather than vfio-pci.

Mark MMAP and INTX options depending on vfio-pci-core to cleanup resulting
config if core is not enabled.

Push all PCI related vfio options to a sub-menu and make descriptions
consistent.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/Makefile              | 2 +-
 drivers/vfio/pci/Kconfig           | 8 ++++++--
 drivers/vfio/pci/hisilicon/Kconfig | 4 ++--
 drivers/vfio/pci/mlx5/Kconfig      | 2 +-
 4 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index 70e7dcb302ef..151e816b2ff9 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -10,7 +10,7 @@ vfio-$(CONFIG_VFIO_VIRQFD) += virqfd.o
 
 obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
 obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
-obj-$(CONFIG_VFIO_PCI) += pci/
+obj-$(CONFIG_VFIO_PCI_CORE) += pci/
 obj-$(CONFIG_VFIO_PLATFORM) += platform/
 obj-$(CONFIG_VFIO_MDEV) += mdev/
 obj-$(CONFIG_VFIO_FSL_MC) += fsl-mc/
diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index f9d0c908e738..86bb7835cf3c 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
-if PCI && MMU
+menu "VFIO support for PCI devices"
+	depends on PCI && MMU
+
 config VFIO_PCI_CORE
 	tristate
 	select VFIO_VIRQFD
@@ -7,9 +9,11 @@ config VFIO_PCI_CORE
 
 config VFIO_PCI_MMAP
 	def_bool y if !S390
+	depends on VFIO_PCI_CORE
 
 config VFIO_PCI_INTX
 	def_bool y if !S390
+	depends on VFIO_PCI_CORE
 
 config VFIO_PCI
 	tristate "Generic VFIO support for any PCI device"
@@ -59,4 +63,4 @@ source "drivers/vfio/pci/mlx5/Kconfig"
 
 source "drivers/vfio/pci/hisilicon/Kconfig"
 
-endif
+endmenu
diff --git a/drivers/vfio/pci/hisilicon/Kconfig b/drivers/vfio/pci/hisilicon/Kconfig
index 5daa0f45d2f9..cbf1c32f6ebf 100644
--- a/drivers/vfio/pci/hisilicon/Kconfig
+++ b/drivers/vfio/pci/hisilicon/Kconfig
@@ -1,13 +1,13 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config HISI_ACC_VFIO_PCI
-	tristate "VFIO PCI support for HiSilicon ACC devices"
+	tristate "VFIO support for HiSilicon ACC PCI devices"
 	depends on ARM64 || (COMPILE_TEST && 64BIT)
-	depends on VFIO_PCI_CORE
 	depends on PCI_MSI
 	depends on CRYPTO_DEV_HISI_QM
 	depends on CRYPTO_DEV_HISI_HPRE
 	depends on CRYPTO_DEV_HISI_SEC2
 	depends on CRYPTO_DEV_HISI_ZIP
+	select VFIO_PCI_CORE
 	help
 	  This provides generic PCI support for HiSilicon ACC devices
 	  using the VFIO framework.
diff --git a/drivers/vfio/pci/mlx5/Kconfig b/drivers/vfio/pci/mlx5/Kconfig
index 29ba9c504a75..7088edc4fb28 100644
--- a/drivers/vfio/pci/mlx5/Kconfig
+++ b/drivers/vfio/pci/mlx5/Kconfig
@@ -2,7 +2,7 @@
 config MLX5_VFIO_PCI
 	tristate "VFIO support for MLX5 PCI devices"
 	depends on MLX5_CORE
-	depends on VFIO_PCI_CORE
+	select VFIO_PCI_CORE
 	help
 	  This provides migration support for MLX5 devices using the VFIO
 	  framework.
-- 
2.39.2

