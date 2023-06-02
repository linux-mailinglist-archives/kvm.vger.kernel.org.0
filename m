Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 620A2720B01
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 23:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236470AbjFBVeh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 17:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236415AbjFBVef (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 17:34:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E481B5
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 14:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685741626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=09I8yhssl+ry4Rcz3+C+czmXSbbdhoU5mkqI7qxVrm8=;
        b=AWNrqx4AU5YKyJZg4YUIWN9dQYHQI+T8PlyE+UlwmnAe+ik5uBEQRHKnJDngjz+PT+TQNO
        JCwpOEAtZzrdOoAbpnjy/o9nZ8NlLpbILASAat1U5SF2Viv88R2dXFFEL7owj/hBWxapsn
        t4vFyJArYtmGwgvb1B9nF7+sEKIWOEI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-6QVj60ayMj2Fzt48K8jajg-1; Fri, 02 Jun 2023 17:33:45 -0400
X-MC-Unique: 6QVj60ayMj2Fzt48K8jajg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1F34E3806707;
        Fri,  2 Jun 2023 21:33:45 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.33.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4F7D48205E;
        Fri,  2 Jun 2023 21:33:44 +0000 (UTC)
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>, jgg@nvidia.com,
        clg@redhat.com, eric.auger@redhat.com
Subject: [PATCH 2/3] vfio/platform: Cleanup Kconfig
Date:   Fri,  2 Jun 2023 15:33:14 -0600
Message-Id: <20230602213315.2521442-3-alex.williamson@redhat.com>
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

Like vfio-pci, there's also a base module here where vfio-amba depends on
vfio-platform, when really it only needs vfio-platform-base.  Create a
sub-menu for platform drivers and a nested menu for reset drivers.  Cleanup
Makefile to make use of new CONFIG_VFIO_PLATFORM_BASE for building the
shared modules and traversing reset modules.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/Makefile          |  2 +-
 drivers/vfio/platform/Kconfig  | 17 ++++++++++++++---
 drivers/vfio/platform/Makefile |  9 +++------
 3 files changed, 18 insertions(+), 10 deletions(-)

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
index 331a5920f5ab..6d18faa66a2e 100644
--- a/drivers/vfio/platform/Kconfig
+++ b/drivers/vfio/platform/Kconfig
@@ -1,8 +1,14 @@
 # SPDX-License-Identifier: GPL-2.0-only
+menu "VFIO support for platform devices"
+
+config VFIO_PLATFORM_BASE
+	tristate
+
 config VFIO_PLATFORM
-	tristate "VFIO support for platform devices"
+	tristate "Generic VFIO support for any platform device"
 	depends on ARM || ARM64 || COMPILE_TEST
 	select VFIO_VIRQFD
+	select VFIO_PLATFORM_BASE
 	help
 	  Support for platform devices with VFIO. This is required to make
 	  use of platform devices present on the system using the VFIO
@@ -10,10 +16,11 @@ config VFIO_PLATFORM
 
 	  If you don't know what to do here, say N.
 
-if VFIO_PLATFORM
 config VFIO_AMBA
 	tristate "VFIO support for AMBA devices"
 	depends on ARM_AMBA || COMPILE_TEST
+	select VFIO_VIRQFD
+	select VFIO_PLATFORM_BASE
 	help
 	  Support for ARM AMBA devices with VFIO. This is required to make
 	  use of ARM AMBA devices present on the system using the VFIO
@@ -21,5 +28,9 @@ config VFIO_AMBA
 
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
-- 
2.39.2

