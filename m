Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C19CB663C68
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 10:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbjAJJLI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 04:11:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238091AbjAJJKd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 04:10:33 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5894712A9D;
        Tue, 10 Jan 2023 01:10:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ilW/+oMS6xyhiJ7nlSWBvOeAci9rF+B8WNLBPFn+Q98=; b=kLeHrG0G/AVkShluVF92oCywvn
        IMwTJrRl8EfbWePjVS9R9lqysI8okcNiT69Pns+iEiKcma0CIS8fk6eExEbkFJVZO/Y00SseK4Rho
        ausAIpEd1nI8ier5zJZ45RTfSQE5Fhe16+6prazOcVI6rVMbW+3nYWE7Ncc2t10H1/wt6JJ1JAnCp
        wA3WR4lPyGZBkN0Y9dgSKNspa+jk+EqEtXd4lTwWSL0atyKi9SIY5Gh9P4KYzaxBq6TtB96zs2kqu
        ufrgpfKd+Wf9zsjKoXbj2bLQ9eKir9DXaKWbvSlYT4Q/uvOCAg+52h2aNVblGNfgHqMHghjmMLFt6
        9ECv/HsQ==;
Received: from [2001:4bb8:181:656b:cb3a:c552:3fcc:12a6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFAe9-0060bK-GZ; Tue, 10 Jan 2023 09:10:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: [PATCH 2/4] vfio-mdev: turn VFIO_MDEV into a selectable symbol
Date:   Tue, 10 Jan 2023 10:10:07 +0100
Message-Id: <20230110091009.474427-3-hch@lst.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230110091009.474427-1-hch@lst.de>
References: <20230110091009.474427-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VFIO_MDEV is just a library with helpers for the drivers.  Stop making
it a user choice and just select it by the drivers that use the helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/s390/vfio-ap.rst    | 1 -
 arch/s390/Kconfig                 | 6 ++++--
 arch/s390/configs/debug_defconfig | 1 -
 arch/s390/configs/defconfig       | 1 -
 drivers/gpu/drm/i915/Kconfig      | 2 +-
 drivers/vfio/mdev/Kconfig         | 8 +-------
 samples/Kconfig                   | 6 +++---
 7 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/Documentation/s390/vfio-ap.rst b/Documentation/s390/vfio-ap.rst
index 00f4a04f6d4c6a..d46e98c7c1ec6c 100644
--- a/Documentation/s390/vfio-ap.rst
+++ b/Documentation/s390/vfio-ap.rst
@@ -553,7 +553,6 @@ These are the steps:
    * ZCRYPT
    * S390_AP_IOMMU
    * VFIO
-   * VFIO_MDEV
    * KVM
 
    If using make menuconfig select the following to build the vfio_ap module::
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 318fce77601d35..60fddcdad495e6 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -705,7 +705,8 @@ config EADM_SCH
 config VFIO_CCW
 	def_tristate n
 	prompt "Support for VFIO-CCW subchannels"
-	depends on S390_CCW_IOMMU && VFIO_MDEV
+	depends on S390_CCW_IOMMU
+	select VFIO_MDEV
 	help
 	  This driver allows usage of I/O subchannels via VFIO-CCW.
 
@@ -715,7 +716,8 @@ config VFIO_CCW
 config VFIO_AP
 	def_tristate n
 	prompt "VFIO support for AP devices"
-	depends on S390_AP_IOMMU && VFIO_MDEV && KVM
+	depends on S390_AP_IOMMU && KVM
+	select VFIO_MDEV
 	depends on ZCRYPT
 	help
 	  This driver grants access to Adjunct Processor (AP) devices
diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
index 2a827002934bc6..e78fc3ba7d442a 100644
--- a/arch/s390/configs/debug_defconfig
+++ b/arch/s390/configs/debug_defconfig
@@ -596,7 +596,6 @@ CONFIG_SYNC_FILE=y
 CONFIG_VFIO=m
 CONFIG_VFIO_PCI=m
 CONFIG_MLX5_VFIO_PCI=m
-CONFIG_VFIO_MDEV=m
 CONFIG_VIRTIO_PCI=m
 CONFIG_VIRTIO_BALLOON=m
 CONFIG_VIRTIO_INPUT=y
diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
index fb780e80e4c8f7..f7eb2e527b6e65 100644
--- a/arch/s390/configs/defconfig
+++ b/arch/s390/configs/defconfig
@@ -585,7 +585,6 @@ CONFIG_SYNC_FILE=y
 CONFIG_VFIO=m
 CONFIG_VFIO_PCI=m
 CONFIG_MLX5_VFIO_PCI=m
-CONFIG_VFIO_MDEV=m
 CONFIG_VIRTIO_PCI=m
 CONFIG_VIRTIO_BALLOON=m
 CONFIG_VIRTIO_INPUT=y
diff --git a/drivers/gpu/drm/i915/Kconfig b/drivers/gpu/drm/i915/Kconfig
index 3efce05d7b57ca..d06da455253cdb 100644
--- a/drivers/gpu/drm/i915/Kconfig
+++ b/drivers/gpu/drm/i915/Kconfig
@@ -116,9 +116,9 @@ config DRM_I915_GVT_KVMGT
 	depends on X86
 	depends on 64BIT
 	depends on KVM
-	depends on VFIO_MDEV
 	select DRM_I915_GVT
 	select KVM_EXTERNAL_WRITE_TRACKING
+	select VFIO_MDEV
 
 	help
 	  Choose this option if you want to enable Intel GVT-g graphics
diff --git a/drivers/vfio/mdev/Kconfig b/drivers/vfio/mdev/Kconfig
index 646dbed44eb283..e5fb84e0796507 100644
--- a/drivers/vfio/mdev/Kconfig
+++ b/drivers/vfio/mdev/Kconfig
@@ -1,10 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
 config VFIO_MDEV
-	tristate "Mediated device driver framework"
-	default n
-	help
-	  Provides a framework to virtualize devices.
-	  See Documentation/driver-api/vfio-mediated-device.rst for more details.
-
-	  If you don't know what do here, say N.
+	tristate
diff --git a/samples/Kconfig b/samples/Kconfig
index f1b8d4ff123036..56b191d128d88f 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -185,14 +185,14 @@ config SAMPLE_UHID
 
 config SAMPLE_VFIO_MDEV_MTTY
 	tristate "Build VFIO mtty example mediated device sample code"
-	depends on VFIO_MDEV
+	select VFIO_MDEV
 	help
 	  Build a virtual tty sample driver for use as a VFIO
 	  mediated device
 
 config SAMPLE_VFIO_MDEV_MDPY
 	tristate "Build VFIO mdpy example mediated device sample code"
-	depends on VFIO_MDEV
+	select VFIO_MDEV
 	help
 	  Build a virtual display sample driver for use as a VFIO
 	  mediated device.  It is a simple framebuffer and supports
@@ -209,7 +209,7 @@ config SAMPLE_VFIO_MDEV_MDPY_FB
 
 config SAMPLE_VFIO_MDEV_MBOCHS
 	tristate "Build VFIO mdpy example mediated device sample code"
-	depends on VFIO_MDEV
+	select VFIO_MDEV
 	select DMA_SHARED_BUFFER
 	help
 	  Build a virtual display sample driver for use as a VFIO
-- 
2.35.1

