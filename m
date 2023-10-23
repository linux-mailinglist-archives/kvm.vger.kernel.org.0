Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 088077D35E1
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 13:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234233AbjJWLza (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 07:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234201AbjJWLz2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 07:55:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F89F5;
        Mon, 23 Oct 2023 04:55:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99BDC433C9;
        Mon, 23 Oct 2023 11:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698062126;
        bh=QmL2n3u+Alr84E1Gw8kq6qtlkqPDghDn12S47YzShJE=;
        h=From:To:Cc:Subject:Date:From;
        b=CboYAmM/OqCQ2/1wE5prPGQSgk1mT+KLZqUT8Mq34t97GOdYLJBKWwiqL6ZFgIpuv
         c2sEkI6AZb3dRseyfKz5CAx9ka4jRO232X3z7KJEW3/ZU/02hLm71i8QhvUSu/lBJE
         N8StwgXNHY4krOFbwILM6Ow7uwqGPmrX3ctPzEZeS2QzFZNaC+Ih6KeojzlpDQ4L0x
         RW1GZ3oQ4CKPF8pM4brt/WpoHNDzNeSzy26WBYM5ZJP6iSw4Jno/d9GB0WWS63PSen
         Psz5ulowqnUQFZimJRiy64G6+g0xsBcVinXwAsBdwlQpXYK2PArlB6fmSfc4jRGcSF
         gerq9C04NDoqg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Kevin Tian <kevin.tian@intel.com>,
        Joao Martins <joao.m.martins@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Brett Creeley <brett.creeley@amd.com>,
        Shixiong Ou <oushixiong@kylinos.cn>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] vfio: mlx5, pds: add IOMMU_SUPPORT dependency
Date:   Mon, 23 Oct 2023 13:55:03 +0200
Message-Id: <20231023115520.3530120-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Selecting IOMMUFD_DRIVER is not allowed if IOMMUs themselves are not supported:

WARNING: unmet direct dependencies detected for IOMMUFD_DRIVER
  Depends on [n]: IOMMU_SUPPORT [=n]
  Selected by [m]:
  - MLX5_VFIO_PCI [=m] && VFIO [=y] && PCI [=y] && MMU [=y] && MLX5_CORE [=y]

There is no actual build failure, only the warning.

Make the 'select' conditional using the same logic that we have for
INTEL_IOMMU and AMD_IOMMU.

Fixes: 33f6339534287 ("vfio: Move iova_bitmap into iommufd")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/vfio/pci/mlx5/Kconfig | 2 +-
 drivers/vfio/pci/pds/Kconfig  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/Kconfig b/drivers/vfio/pci/mlx5/Kconfig
index c3ced56b77876..c23815c486a75 100644
--- a/drivers/vfio/pci/mlx5/Kconfig
+++ b/drivers/vfio/pci/mlx5/Kconfig
@@ -3,7 +3,7 @@ config MLX5_VFIO_PCI
 	tristate "VFIO support for MLX5 PCI devices"
 	depends on MLX5_CORE
 	select VFIO_PCI_CORE
-	select IOMMUFD_DRIVER
+	select IOMMUFD_DRIVER if IOMMUFD
 	help
 	  This provides migration support for MLX5 devices using the VFIO
 	  framework.
diff --git a/drivers/vfio/pci/pds/Kconfig b/drivers/vfio/pci/pds/Kconfig
index fec9b167c7b9a..6091e11f0e521 100644
--- a/drivers/vfio/pci/pds/Kconfig
+++ b/drivers/vfio/pci/pds/Kconfig
@@ -5,7 +5,7 @@ config PDS_VFIO_PCI
 	tristate "VFIO support for PDS PCI devices"
 	depends on PDS_CORE && PCI_IOV
 	select VFIO_PCI_CORE
-	select IOMMUFD_DRIVER
+	select IOMMUFD_DRIVER if IOMMUFD
 	help
 	  This provides generic PCI support for PDS devices using the VFIO
 	  framework.
-- 
2.39.2

