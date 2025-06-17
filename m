Return-Path: <kvm+bounces-49750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 29499ADDB1B
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 20:01:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 900564046A3
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 18:01:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45AB8277C80;
	Tue, 17 Jun 2025 17:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UwHew9lW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55950277814;
	Tue, 17 Jun 2025 17:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750183173; cv=none; b=FIq61bvh28UEoV5GzExsCTnsANKCAwby0Zj+gNUFfrp0kCHcBM/3XsNf5rXBklIH6fKt5UiGX0UKJAlF79bYrZR5lsEcX3Sa5O5i+Q5ztNwfCSLMPpBEvWh34Hn8gyfp7gsePxwK9ImxfSwFlkC0SrBPoW3LL5B0+/gadtF2ccY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750183173; c=relaxed/simple;
	bh=7syN+VGWAq1nVYbtNhebxuTb7b5k+6al9zHWrp5oKB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A2qEQLs67l0gTnl6VQcycgvERPSiSHy+mt3Rs5Zdm6hflGkAWEZY/etLma67pTvW9hYAwAU5jH7d1CpeuGK64vhhB7CaDK9UwNUy8+P7T+gCDqSLSKMB+kJDx3ETZ0AMlhkzXDmjJ+bmLl7Fvx9tHE0lAKWLP5mOoLJfD1PTAJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UwHew9lW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC524C4CEF1;
	Tue, 17 Jun 2025 17:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750183172;
	bh=7syN+VGWAq1nVYbtNhebxuTb7b5k+6al9zHWrp5oKB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UwHew9lWylxUDH4E7K0yq7jCjZRraVLumM+ZA1jiaOqySEHkDs1UdMIeO94w9HzIg
	 YvlFjXEIEHIO0sd4309vR5tVaHCTHkFBZ/K21VTSeiJbWNdry+vBV/w7sKPNTIvVwh
	 bzWVUTSxSLzn3d7Q+jTaz8W2Ix72tD3Xf/HVEVNRKp/rle8kjqxgl2DiLjhPMn4oMD
	 EFg0gO9Bz3PP1DKCN8QE5rc5Uh7rTJiVtfeKRvfjV3d1LoDX34xLFuwRZ9CHZ4qZLR
	 C3cAn1ZSTBaXOrGxe9ijkLM6omGEZWPwpJoWXkMTXLhroNpqq2bCMWFOvHsVxiuSe6
	 K1OUptgkmKoOA==
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
Subject: [PATCH v2 6/6] vgaarb: Look at all PCI display devices in VGA arbiter
Date: Tue, 17 Jun 2025 12:59:10 -0500
Message-ID: <20250617175910.1640546-7-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250617175910.1640546-1-superm1@kernel.org>
References: <20250617175910.1640546-1-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

On a mobile system with an AMD integrated GPU + NVIDIA discrete GPU the
AMD GPU is not being selected by some desktop environments for any
rendering tasks. This is because neither GPU is being treated as
"boot_vga" but that is what some environments use to select a GPU [1].

The VGA arbiter driver only looks at devices that report as PCI display
VGA class devices. Neither GPU on the system is a PCI display VGA class
device:

c5:00.0 3D controller: NVIDIA Corporation Device 2db9 (rev a1)
c6:00.0 Display controller: Advanced Micro Devices, Inc. [AMD/ATI] Device 150e (rev d1)

If the GPUs were looked at the vga_is_firmware_default() function actually
does do a good job at recognizing the case from the device used for the
firmware framebuffer.

Modify the VGA arbiter code and matching sysfs file entries to examine all
PCI display class devices. The existing logic stays the same.

This will cause all GPUs to gain a `boot_vga` file, but the correct device
(AMD GPU in this case) will now show `1` and the incorrect device shows `0`.
Userspace then picks the right device as well.

Link: https://github.com/robherring/libpciaccess/commit/b2838fb61c3542f107014b285cbda097acae1e12 [1]
Suggested-by: Daniel Dadap <ddadap@nvidia.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/pci/pci-sysfs.c | 2 +-
 drivers/pci/vgaarb.c    | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 268c69daa4d57..c314ee1b3f9ac 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1707,7 +1707,7 @@ static umode_t pci_dev_attrs_are_visible(struct kobject *kobj,
 	struct device *dev = kobj_to_dev(kobj);
 	struct pci_dev *pdev = to_pci_dev(dev);
 
-	if (a == &dev_attr_boot_vga.attr && pci_is_vga(pdev))
+	if (a == &dev_attr_boot_vga.attr && pci_is_display(pdev))
 		return a->mode;
 
 	return 0;
diff --git a/drivers/pci/vgaarb.c b/drivers/pci/vgaarb.c
index 78748e8d2dbae..63216e5787d73 100644
--- a/drivers/pci/vgaarb.c
+++ b/drivers/pci/vgaarb.c
@@ -1499,8 +1499,8 @@ static int pci_notify(struct notifier_block *nb, unsigned long action,
 
 	vgaarb_dbg(dev, "%s\n", __func__);
 
-	/* Only deal with VGA class devices */
-	if (!pci_is_vga(pdev))
+	/* Only deal with PCI display class devices */
+	if (!pci_is_display(pdev))
 		return 0;
 
 	/*
@@ -1546,12 +1546,12 @@ static int __init vga_arb_device_init(void)
 
 	bus_register_notifier(&pci_bus_type, &pci_notifier);
 
-	/* Add all VGA class PCI devices by default */
+	/* Add all PCI display class devices by default */
 	pdev = NULL;
 	while ((pdev =
 		pci_get_subsys(PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 			       PCI_ANY_ID, pdev)) != NULL) {
-		if (pci_is_vga(pdev))
+		if (pci_is_display(pdev))
 			vga_arbiter_add_pci_device(pdev);
 	}
 
-- 
2.43.0


