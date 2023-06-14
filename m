Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF982730895
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 21:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233830AbjFNTmG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 15:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbjFNTle (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 15:41:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB21E2690
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 12:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686771610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mk7rJkASAkTCuswNPOFSUiflcRtoSblatX8CpsmDyQo=;
        b=Zp7rIOPylQicCh+ZDrnqRZitwi4rA8X7nYQI/5zCIMYBrzOQ3m6k/BvzpnTOCOJ0yNBm76
        VDnWZcutkpSyw/KVoesJ9L7S3o0sDrMsokXtRjNQRMO4fGKqAZ7jAl8+tweCF8po6umnE2
        kfo/I1VgLq0w/qxio7u3hmaNkZl6HP8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-Ac8Dloi9N5OkJG22tK1xbg-1; Wed, 14 Jun 2023 15:40:05 -0400
X-MC-Unique: Ac8Dloi9N5OkJG22tK1xbg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 083483823A22;
        Wed, 14 Jun 2023 19:40:05 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.33.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F904492C1B;
        Wed, 14 Jun 2023 19:40:04 +0000 (UTC)
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>, jgg@nvidia.com,
        clg@redhat.com, eric.auger@redhat.com
Subject: [PATCH v3 2/3] vfio/platform: Cleanup Kconfig
Date:   Wed, 14 Jun 2023 13:39:47 -0600
Message-Id: <20230614193948.477036-3-alex.williamson@redhat.com>
In-Reply-To: <20230614193948.477036-1-alex.williamson@redhat.com>
References: <20230614193948.477036-1-alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Like vfio-pci, there's also a base module here where vfio-amba depends on
vfio-platform, when really it only needs vfio-platform-base.  Create a
sub-menu for platform drivers and a nested menu for reset drivers.  Cleanup
Makefile to make use of new CONFIG_VFIO_PLATFORM_BASE for building the
shared modules and traversing reset modules.

Reviewed-by: Cédric Le Goater <clg@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/Makefile               |  2 +-
 drivers/vfio/platform/Kconfig       | 18 ++++++++++++++----
 drivers/vfio/platform/Makefile      |  9 +++------
 drivers/vfio/platform/reset/Kconfig |  2 ++
 4 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index 151e816b2ff9..8da44aa1ea16 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -11,6 +11,6 @@ vfio-$(CONFIG_VFIO_VIRQFD) += virqfd.o
 obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
 obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
 obj-$(CONFIG_VFIO_PCI_CORE) += pci/
-obj-$(CONFIG_VFIO_PLATFORM) += platform/
+obj-$(CONFIG_VFIO_PLATFORM_BASE) += platform/
 obj-$(CONFIG_VFIO_MDEV) += mdev/
 obj-$(CONFIG_VFIO_FSL_MC) += fsl-mc/
diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
index 331a5920f5ab..88fcde51f024 100644
--- a/drivers/vfio/platform/Kconfig
+++ b/drivers/vfio/platform/Kconfig
@@ -1,8 +1,14 @@
 # SPDX-License-Identifier: GPL-2.0-only
-config VFIO_PLATFORM
-	tristate "VFIO support for platform devices"
+menu "VFIO support for platform devices"
 	depends on ARM || ARM64 || COMPILE_TEST
+
+config VFIO_PLATFORM_BASE
+	tristate
 	select VFIO_VIRQFD
+
+config VFIO_PLATFORM
+	tristate "Generic VFIO support for any platform device"
+	select VFIO_PLATFORM_BASE
 	help
 	  Support for platform devices with VFIO. This is required to make
 	  use of platform devices present on the system using the VFIO
@@ -10,10 +16,10 @@ config VFIO_PLATFORM
 
 	  If you don't know what to do here, say N.
 
-if VFIO_PLATFORM
 config VFIO_AMBA
 	tristate "VFIO support for AMBA devices"
 	depends on ARM_AMBA || COMPILE_TEST
+	select VFIO_PLATFORM_BASE
 	help
 	  Support for ARM AMBA devices with VFIO. This is required to make
 	  use of ARM AMBA devices present on the system using the VFIO
@@ -21,5 +27,9 @@ config VFIO_AMBA
 
 	  If you don't know what to do here, say N.
 
+menu "VFIO platform reset drivers"
+	depends on VFIO_PLATFORM_BASE
+
 source "drivers/vfio/platform/reset/Kconfig"
-endif
+endmenu
+endmenu
diff --git a/drivers/vfio/platform/Makefile b/drivers/vfio/platform/Makefile
index 3f3a24e7c4ef..ee4fb6a82ca8 100644
--- a/drivers/vfio/platform/Makefile
+++ b/drivers/vfio/platform/Makefile
@@ -1,13 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0
 vfio-platform-base-y := vfio_platform_common.o vfio_platform_irq.o
-vfio-platform-y := vfio_platform.o
+obj-$(CONFIG_VFIO_PLATFORM_BASE) += vfio-platform-base.o
+obj-$(CONFIG_VFIO_PLATFORM_BASE) += reset/
 
+vfio-platform-y := vfio_platform.o
 obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform.o
-obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform-base.o
-obj-$(CONFIG_VFIO_PLATFORM) += reset/
 
 vfio-amba-y := vfio_amba.o
-
 obj-$(CONFIG_VFIO_AMBA) += vfio-amba.o
-obj-$(CONFIG_VFIO_AMBA) += vfio-platform-base.o
-obj-$(CONFIG_VFIO_AMBA) += reset/
diff --git a/drivers/vfio/platform/reset/Kconfig b/drivers/vfio/platform/reset/Kconfig
index 12f5f3d80387..dcc08dc145a5 100644
--- a/drivers/vfio/platform/reset/Kconfig
+++ b/drivers/vfio/platform/reset/Kconfig
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
+if VFIO_PLATFORM
 config VFIO_PLATFORM_CALXEDAXGMAC_RESET
 	tristate "VFIO support for calxeda xgmac reset"
 	help
@@ -21,3 +22,4 @@ config VFIO_PLATFORM_BCMFLEXRM_RESET
 	  Enables the VFIO platform driver to handle reset for Broadcom FlexRM
 
 	  If you don't know what to do here, say N.
+endif
-- 
2.39.2

