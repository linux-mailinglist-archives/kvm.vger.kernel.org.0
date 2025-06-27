Return-Path: <kvm+bounces-50945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36370AEADFA
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 06:34:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 570E21783CA
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 04:34:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70BAB21A458;
	Fri, 27 Jun 2025 04:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TyBp7Exh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA8F1DE2D7;
	Fri, 27 Jun 2025 04:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750998698; cv=none; b=fhRJc5H24s2nricNm5HKMnjAQNL9gi1etZ1+MwpmUK0wCS39p/Pq9fhiMRICrr5DY3C15FeAAwS9t2+Y1Cn+P5Bjewifd6MwhX11PHU1T0FB+jUR8ZSzRTYif+Z6y3DQg4wWlqlQtsHlM03CB4jPoaTxasQXbayxoyben2D4Iwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750998698; c=relaxed/simple;
	bh=wM5TClw82+g+f6tTVZpsOWcLA2SCBE+v6qAmnJL26dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E71NNGVVYD4wFnP0OCiGv9gADJDygJPl1z024DtlhrEx+9XYbIxUO/ShB8ld7Irg/IVccYrtpxxkBVPGTWLnFR56jGtvwuOV1LEzabZtRCPNZsfpISzigrkArFc3n7Ws2u1H88H2zzVSNkhaVGkz5xmsfljZeqUYOT0+Z58iqeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TyBp7Exh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC04C4CEEB;
	Fri, 27 Jun 2025 04:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750998698;
	bh=wM5TClw82+g+f6tTVZpsOWcLA2SCBE+v6qAmnJL26dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TyBp7Exh1zUlLHHkHOA8PkAI5rInJOVDVZwtpuqi67FZ4fdGvEHRo6GMm5D1DlpKy
	 d1EeX3yqogTDFj0B0IYKcsxtuZDBpT8Gx5h8KaZV6k4GFtPjEmn3D+Gv80L4uS92H7
	 oQ3KJAPnROQReELH/VMeLqO7/fZOxgrwjBYcQ8Ckd/viHQzGw3bURRXjezKAVDmwqY
	 SBKQBOujgECCL6MiHhRwja7T/GkmdLA4NHAm677pKzhmZXZ7+CK0DGfyToQ21grjMX
	 pKXGUt0f4do2wBJQ5YgznQPO1zOVTqaajqY/66jnb6HG3y8StmRxs0ckNlQY+Rn85g
	 TBj6z0uy0uHcQ==
From: Mario Limonciello <superm1@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>,
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
Subject: [PATCH v6 9/9] PCI: Add a new 'boot_display' attribute
Date: Thu, 26 Jun 2025 23:31:08 -0500
Message-ID: <20250627043108.3141206-10-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250627043108.3141206-1-superm1@kernel.org>
References: <20250627043108.3141206-1-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

On systems with multiple GPUs there can be uncertainty which GPU is the
primary one used to drive the display at bootup. In order to disambiguate
this add a new sysfs attribute 'boot_display' that uses the output of
video_is_primary_device() to populate whether a PCI device was used for
driving the display.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
v6:
 * Only show for the device that is boot display
 * Only create after PCI device sysfs files are initialized to ensure
   that resources are ready.
v4:
 * new patch
---
 Documentation/ABI/testing/sysfs-bus-pci |  8 +++++
 drivers/pci/pci-sysfs.c                 | 46 +++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index 69f952fffec72..8b455b1a58852 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -612,3 +612,11 @@ Description:
 
 		  # ls doe_features
 		  0001:01        0001:02        doe_discovery
+
+What:		/sys/bus/pci/devices/.../boot_display
+Date:		October 2025
+Contact:	Linux PCI developers <linux-pci@vger.kernel.org>
+Description:
+		This file indicates the device was used as a boot
+		display. If the device was used as the boot display, the file
+		will be present and contain "1".
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 268c69daa4d57..cc766461de1da 100644
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
@@ -1246,6 +1254,37 @@ static int pci_create_attr(struct pci_dev *pdev, int num, int write_combine)
 	return 0;
 }
 
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
 /**
  * pci_create_resource_files - create resource files in sysfs for @dev
  * @pdev: dev in question
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


