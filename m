Return-Path: <kvm+bounces-50011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DABEAE1156
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 04:52:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A63D63AD9F1
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 02:51:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7761E1CEEB2;
	Fri, 20 Jun 2025 02:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aUQrUNUx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0271CDFCE;
	Fri, 20 Jun 2025 02:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750387815; cv=none; b=uIe/0lYmkPx22BTF+ZqJfVl04POcdMST81lyDOmoCtBfsuTYj+tBxl3wiPVT69FcR2kB4loOSm4d6xVL3C60vFsq60Vl6jOCXYwqWD3ZZef+3qA8VFFeQUbRCOG8380Yyf7LjEqrvvBWFSvhdf0yLFXZ1ynI7WBvlU25O53zRhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750387815; c=relaxed/simple;
	bh=3p28D7Y3qB/a1iedwXKmlAJI9k/uZvQfOe5/sAZS+Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O34szSdNcK261l6urcKKWExCLITlUPn6uc3rqs566cFad/eX9GCd/ghVuGbh5gRgyWMRzWYSgzEYuUPeY3zvSpnTClXNxvgW/AwdRYLu/PbTtM0uSi2McvHwES8gL4zXf+9CLZM1HoLgdkzDcgT7PbiMil4ru0OxwQa8DchODYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aUQrUNUx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2655BC4CEF2;
	Fri, 20 Jun 2025 02:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750387815;
	bh=3p28D7Y3qB/a1iedwXKmlAJI9k/uZvQfOe5/sAZS+Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aUQrUNUxvi8UFb1sY0dg90IN1qGuBcN8u3AViEPwz6aTI1p7Xdsv74Wja0UAGdmzt
	 MtJ6eayVuxOZgXimT15Sgii4QnReuEy/UEX/jjM5ph1k/y4dERJbdCv+PKOisK71ba
	 ujQvtnDs5wkQOROVnuUYhN0NWyYDgn5dkvHjz/O0wm0dvYVvHyLkz5mi1HK6xyroMY
	 pC5hY7ooqfYj1czzp1TSm6kpxKu/8WszuTrmG8cVqJ1+F7OJmy0pGA+RisJrFkDjTT
	 Ap9OKSFksFQECQRvRVJyfji3hX0gWJViLqGtYGVst2b7UABhqwADVKHSHiM4gOyvEM
	 0GsdauK6EkfKA==
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
Subject: [PATCH v3 6/7] PCI/VGA: Move check for firmware default out of VGA arbiter
Date: Thu, 19 Jun 2025 21:49:42 -0500
Message-ID: <20250620024943.3415685-7-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250620024943.3415685-1-superm1@kernel.org>
References: <20250620024943.3415685-1-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

The x86 specific check for whether a framebuffer belongs to a device
works for display devices as well as VGA devices.  Callers to
video_is_primary_device() can benefit from checking non-VGA display
devices.

Move the x86 specific check into x86 specific code, and adjust VGA
arbiter to call that code as well. This allows fbcon to find the
right PCI device on systems that don't have VGA devices.

Suggested-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 arch/x86/video/video-common.c | 28 +++++++++++++++++++++++++++
 drivers/pci/vgaarb.c          | 36 ++---------------------------------
 2 files changed, 30 insertions(+), 34 deletions(-)

diff --git a/arch/x86/video/video-common.c b/arch/x86/video/video-common.c
index 81fc97a2a837a..718116e35e450 100644
--- a/arch/x86/video/video-common.c
+++ b/arch/x86/video/video-common.c
@@ -9,6 +9,7 @@
 
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/screen_info.h>
 #include <linux/vgaarb.h>
 
 #include <asm/video.h>
@@ -27,13 +28,40 @@ EXPORT_SYMBOL(pgprot_framebuffer);
 
 bool video_is_primary_device(struct device *dev)
 {
+	u64 base = screen_info.lfb_base;
+	u64 size = screen_info.lfb_size;
 	struct pci_dev *pdev;
+	struct resource *r;
+	u64 limit;
 
 	if (!dev_is_pci(dev))
 		return false;
 
 	pdev = to_pci_dev(dev);
 
+	if (!pci_is_display(pdev))
+		return false;
+
+	/* Select the device owning the boot framebuffer if there is one */
+	if (screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE)
+		base |= (u64)screen_info.ext_lfb_base << 32;
+
+	limit = base + size;
+
+	/* Does firmware framebuffer belong to us? */
+	pci_dev_for_each_resource(pdev, r) {
+		if (resource_type(r) != IORESOURCE_MEM)
+			continue;
+
+		if (!r->start || !r->end)
+			continue;
+
+		if (base < r->start || limit >= r->end)
+			continue;
+
+		return true;
+	}
+
 	return (pdev == vga_default_device());
 }
 EXPORT_SYMBOL(video_is_primary_device);
diff --git a/drivers/pci/vgaarb.c b/drivers/pci/vgaarb.c
index 78748e8d2dbae..15ab58c70b016 100644
--- a/drivers/pci/vgaarb.c
+++ b/drivers/pci/vgaarb.c
@@ -26,12 +26,12 @@
 #include <linux/poll.h>
 #include <linux/miscdevice.h>
 #include <linux/slab.h>
-#include <linux/screen_info.h>
 #include <linux/vt.h>
 #include <linux/console.h>
 #include <linux/acpi.h>
 #include <linux/uaccess.h>
 #include <linux/vgaarb.h>
+#include <asm/video.h>
 
 static void vga_arbiter_notify_clients(void);
 
@@ -554,38 +554,6 @@ void vga_put(struct pci_dev *pdev, unsigned int rsrc)
 }
 EXPORT_SYMBOL(vga_put);
 
-static bool vga_is_firmware_default(struct pci_dev *pdev)
-{
-#if defined(CONFIG_X86)
-	u64 base = screen_info.lfb_base;
-	u64 size = screen_info.lfb_size;
-	struct resource *r;
-	u64 limit;
-
-	/* Select the device owning the boot framebuffer if there is one */
-
-	if (screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE)
-		base |= (u64)screen_info.ext_lfb_base << 32;
-
-	limit = base + size;
-
-	/* Does firmware framebuffer belong to us? */
-	pci_dev_for_each_resource(pdev, r) {
-		if (resource_type(r) != IORESOURCE_MEM)
-			continue;
-
-		if (!r->start || !r->end)
-			continue;
-
-		if (base < r->start || limit >= r->end)
-			continue;
-
-		return true;
-	}
-#endif
-	return false;
-}
-
 static bool vga_arb_integrated_gpu(struct device *dev)
 {
 #if defined(CONFIG_ACPI)
@@ -623,7 +591,7 @@ static bool vga_is_boot_device(struct vga_device *vgadev)
 	if (boot_vga && boot_vga->is_firmware_default)
 		return false;
 
-	if (vga_is_firmware_default(pdev)) {
+	if (video_is_primary_device(&pdev->dev)) {
 		vgadev->is_firmware_default = true;
 		return true;
 	}
-- 
2.43.0


