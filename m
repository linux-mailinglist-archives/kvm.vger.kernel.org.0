Return-Path: <kvm+bounces-52787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D9AFB09375
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 19:41:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A455A47958
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 17:40:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62844303DEB;
	Thu, 17 Jul 2025 17:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dAGkJJp+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D197306DB2;
	Thu, 17 Jul 2025 17:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752773925; cv=none; b=bgJYToGfYzRKSBDOn8eo+SwhAOE5wkizVxx3fYPWPHdcoIqG6eaVE6jrQAexMehZR8SWd8I+u06vq6gZGYMebGiBz6U2gWNmhIZ4odsdTT5+7Utz/FnsNsXwAFn6yz9TVkVE3mxnPP5wjsB3bVOwo1hXa3FM9JmfK9MU+MKRjXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752773925; c=relaxed/simple;
	bh=yq7W2WVUEaHr/X54PhBR9VeOykW/0gdmiDQSQN/06X0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2FJvqctypWgBdvBgs+bTvgcW1Sr8qZYyNjDMC6VCjbZMwFYAv2ttQyatpMCTmYDEPRVkNAeYx2ERgDjw5z4XmQdjbdmbbGzOhnR93/PXXCBl6EbDMinAZXeL124bs5ZaLUYw66zFUyka7fFXaM96+KDO3uZy1e7ZNymynOOG48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dAGkJJp+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08585C4CEF0;
	Thu, 17 Jul 2025 17:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752773925;
	bh=yq7W2WVUEaHr/X54PhBR9VeOykW/0gdmiDQSQN/06X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dAGkJJp+T/ru/NLo6QkFBo22cb2FjYo5QdxsSrlo4Sc4SlkcOLVB9ipQtFDTNJErp
	 xrvoRco2SoaFcFCZ5Bec+6y6wbYL2yuByBS4xVuh7eOj34W+YCqi2DWWBf8yL4D11v
	 3nDN3rRUkLFenr5bqI5YqpRFEz4mLRlurN8X0YPF5rtDPAWIMSooFJp4efPAQ+xGUu
	 xXSwH7EHHXauWHLeRUUfDV5SEHAl/KmNdJOeoJwdVXERgvqmJDf7sTPzKc7hhkuQ5x
	 0IieWFdbBFiWfzAB+P700iDEzeW/WgrB9xKWQ+Iv2LInkZo2MqAiClmGW6Px4vUx8o
	 U7PciLz33cHEw==
From: Mario Limonciello <superm1@kernel.org>
To: David Airlie <airlied@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Cc: Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Simona Vetter <simona@ffwll.ch>,
	Lukas Wunner <lukas@wunner.de>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Woodhouse <dwmw2@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	dri-devel@lists.freedesktop.org (open list:DRM DRIVERS),
	linux-kernel@vger.kernel.org (open list),
	iommu@lists.linux.dev (open list:INTEL IOMMU (VT-d)),
	linux-pci@vger.kernel.org (open list:PCI SUBSYSTEM),
	kvm@vger.kernel.org (open list:VFIO DRIVER),
	linux-sound@vger.kernel.org (open list:SOUND),
	Daniel Dadap <ddadap@nvidia.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH v9 9/9] PCI: Add a new 'boot_display' attribute
Date: Thu, 17 Jul 2025 12:38:12 -0500
Message-ID: <20250717173812.3633478-10-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250717173812.3633478-1-superm1@kernel.org>
References: <20250717173812.3633478-1-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

On systems with multiple GPUs there can be uncertainty which GPU is the
primary one used to drive the display at bootup. In some desktop
environments this can lead to increased power consumption because
secondary GPUs may be used for rendering and never go to a low power
state. In order to disambiguate this add a new sysfs attribute
'boot_display' that uses the output of video_is_primary_device() to
populate whether a PCI device was used for driving the display.

Link: https://gitlab.freedesktop.org/xorg/lib/libpciaccess/-/issues/23
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
v8:
 * Add bug link
 * Update commit message text
 * Update boot_display description text
v7:
 * fix lkp failure
 * Add tag
v6:
 * Only show for the device that is boot display
 * Only create after PCI device sysfs files are initialized to ensure
   that resources are ready.
v4:
 * new patch
---
 Documentation/ABI/testing/sysfs-bus-pci |  9 +++++
 drivers/pci/pci-sysfs.c                 | 46 +++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index 69f952fffec72..a2c74d4ebeadd 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -612,3 +612,12 @@ Description:
 
 		  # ls doe_features
 		  0001:01        0001:02        doe_discovery
+
+What:		/sys/bus/pci/devices/.../boot_display
+Date:		October 2025
+Contact:	Linux PCI developers <linux-pci@vger.kernel.org>
+Description:
+		This file indicates that displays connected to the device were
+		used to display the boot sequence.  If a display connected to
+		the device was used to display the boot sequence the file will
+		be present and contain "1".
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 268c69daa4d57..6b1a0ae254d3a 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -30,6 +30,7 @@
 #include <linux/msi.h>
 #include <linux/of.h>
 #include <linux/aperture.h>
+#include <asm/video.h>
 #include "pci.h"
 
 #ifndef ARCH_PCI_DEV_GROUPS
@@ -679,6 +680,13 @@ const struct attribute_group *pcibus_groups[] = {
 	NULL,
 };
 
+static ssize_t boot_display_show(struct device *dev, struct device_attribute *attr,
+				 char *buf)
+{
+	return sysfs_emit(buf, "1\n");
+}
+static DEVICE_ATTR_RO(boot_display);
+
 static ssize_t boot_vga_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
@@ -1051,6 +1059,37 @@ void pci_remove_legacy_files(struct pci_bus *b)
 }
 #endif /* HAVE_PCI_LEGACY */
 
+/**
+ * pci_create_boot_display_file - create a file in sysfs for @dev
+ * @pdev: dev in question
+ *
+ * Creates a file `boot_display` in sysfs for the PCI device @pdev
+ * if it is the boot display device.
+ */
+static int pci_create_boot_display_file(struct pci_dev *pdev)
+{
+#ifdef CONFIG_VIDEO
+	if (video_is_primary_device(&pdev->dev))
+		return sysfs_create_file(&pdev->dev.kobj, &dev_attr_boot_display.attr);
+#endif
+	return 0;
+}
+
+/**
+ * pci_remove_boot_display_file - remove the boot display file for @dev
+ * @pdev: dev in question
+ *
+ * Removes the file `boot_display` in sysfs for the PCI device @pdev
+ * if it is the boot display device.
+ */
+static void pci_remove_boot_display_file(struct pci_dev *pdev)
+{
+#ifdef CONFIG_VIDEO
+	if (video_is_primary_device(&pdev->dev))
+		sysfs_remove_file(&pdev->dev.kobj, &dev_attr_boot_display.attr);
+#endif
+}
+
 #if defined(HAVE_PCI_MMAP) || defined(ARCH_GENERIC_PCI_MMAP_RESOURCE)
 /**
  * pci_mmap_resource - map a PCI resource into user memory space
@@ -1654,9 +1693,15 @@ static const struct attribute_group pci_dev_resource_resize_group = {
 
 int __must_check pci_create_sysfs_dev_files(struct pci_dev *pdev)
 {
+	int retval;
+
 	if (!sysfs_initialized)
 		return -EACCES;
 
+	retval = pci_create_boot_display_file(pdev);
+	if (retval)
+		return retval;
+
 	return pci_create_resource_files(pdev);
 }
 
@@ -1671,6 +1716,7 @@ void pci_remove_sysfs_dev_files(struct pci_dev *pdev)
 	if (!sysfs_initialized)
 		return;
 
+	pci_remove_boot_display_file(pdev);
 	pci_remove_resource_files(pdev);
 }
 
-- 
2.43.0


