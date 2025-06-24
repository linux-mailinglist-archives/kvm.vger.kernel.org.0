Return-Path: <kvm+bounces-50569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 30F42AE70E8
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 22:34:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3EF525A8300
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 20:33:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47F112F3C06;
	Tue, 24 Jun 2025 20:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qQlK2FPj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F16E2F363F;
	Tue, 24 Jun 2025 20:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750797071; cv=none; b=XuPUwqXuD7EI6H2/jd4cvQC5Ej+/kc0eEkW/5XtDP8yum8b4cf6ifCHb4bTRicri3SHj/SEVrFnuuzueOZd6awFFWf0XAqLJ/LKgPuXag5z2TNaGqzUfwivgTMi1u936p6xtSbW2jxAe+hn0LRuv9VYatoRBAzmsMO7OZGWz2zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750797071; c=relaxed/simple;
	bh=wM2bSTdZ79jUE3zyr7FAmD4oLwJqwdJQwmMFYKhFlKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTHG6qKE8zelZUhnmnCjYcvYkCtIkwHk8AC87+8yk7L4l23Ph0dm7spD0GC8lgu+Luf+mli2uiiN88MTC/FVMVFaDVb6Aeft4R0mRXYrF0M4LlzTSU/ELd9S1hENArcuW9JdaOtJDzorYUtXnw05aat2j16JwcDr0lwQCBBUCcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qQlK2FPj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB08EC4CEE3;
	Tue, 24 Jun 2025 20:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750797070;
	bh=wM2bSTdZ79jUE3zyr7FAmD4oLwJqwdJQwmMFYKhFlKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qQlK2FPjVa6ekb+NmbvTShAdEs6MzKU4zYhV6yfdzNPUQLXXLV1OnJW1kBh5kJXP/
	 zbdgn+tkr3HNWm6RAcvKVAj9XF5rp6876WuiWyh490/VsfIW7O+iNgt6t1SyMPS35B
	 LyWqtvKiX6gskjCIZE2CC/zdBeef4dk38iPOrskonZcuaz/fg3MGEWveQ5nq7MQGR4
	 9p19VkWDUohGMsYCXFgmS9HZGZ99FNVd3UYs1AChTwwRnFuvdStEBw+tDuLBoRxEJJ
	 1g5g4zW51XZ3v4LMQS+ewcpSScNGWVlGl7XrlzCo6N4jEis8CfQvha8gpjruB0K78d
	 QaJ55g/sLrMrg==
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
Subject: [PATCH v5 9/9] PCI: Add a new 'boot_display' attribute
Date: Tue, 24 Jun 2025 15:30:42 -0500
Message-ID: <20250624203042.1102346-10-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250624203042.1102346-1-superm1@kernel.org>
References: <20250624203042.1102346-1-superm1@kernel.org>
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
v4:
 * new patch
---
 Documentation/ABI/testing/sysfs-bus-pci |  9 +++++++++
 drivers/pci/pci-sysfs.c                 | 14 ++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index 69f952fffec72..897cfc1b0de0f 100644
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
+		This file indicates whether the device was used as a boot
+		display. If the device was used as the boot display, the file
+		will contain "1". If the device is a display device but wasn't
+		used as a boot display, the file will contain "0".
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 268c69daa4d57..5bbf79b1b953d 100644
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
+	return sysfs_emit(buf, "%u\n", video_is_primary_device(dev));
+}
+static DEVICE_ATTR_RO(boot_display);
+
 static ssize_t boot_vga_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
@@ -1698,6 +1706,7 @@ late_initcall(pci_sysfs_init);
 
 static struct attribute *pci_dev_dev_attrs[] = {
 	&dev_attr_boot_vga.attr,
+	&dev_attr_boot_display.attr,
 	NULL,
 };
 
@@ -1710,6 +1719,11 @@ static umode_t pci_dev_attrs_are_visible(struct kobject *kobj,
 	if (a == &dev_attr_boot_vga.attr && pci_is_vga(pdev))
 		return a->mode;
 
+#ifdef CONFIG_VIDEO
+	if (a == &dev_attr_boot_display.attr && pci_is_display(pdev))
+		return a->mode;
+#endif
+
 	return 0;
 }
 
-- 
2.43.0


