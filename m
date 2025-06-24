Return-Path: <kvm+bounces-50567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A02CAE70E3
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 22:34:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1B355A5914
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 20:32:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C87C2F2732;
	Tue, 24 Jun 2025 20:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d2qJqA+v"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B992F19B9;
	Tue, 24 Jun 2025 20:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750797066; cv=none; b=kJPDwIRDdhYnwJTthullYhjJ+TvRY8SUjQjpTR+eI4Jc/hWIL38O9OYiQFkYG9q4qevTqfmaxIJ9rQMPvH+HOlaf6JFlbrnteEgt9acpuRM8i9Hhk/ECsM2lR05mN4KcIMps32bCvW42uBHL19dm63TI+2skzuubaavayyYPkOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750797066; c=relaxed/simple;
	bh=tNsaHP450SEY2mkWYa5laraTkeQQ7mGoQTMeknOCJe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DKE/fMa39LHPGhQtr8TDrSHkm7vp8iprPOuhbQ5YgZedRKPJC7G5sssLw7mLjfyY2J3nF3yF/FCQMNzz89sNQAxekFcTulWfJ7JPk5jpKmJkXCmLiLONML63lrb/iazexUkuRSEj9CY7RRG4A7XerS4FJlmIEZuAAM+zDrLT2v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d2qJqA+v; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F283BC4CEF3;
	Tue, 24 Jun 2025 20:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750797066;
	bh=tNsaHP450SEY2mkWYa5laraTkeQQ7mGoQTMeknOCJe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d2qJqA+vuJBzPZEmJdvOJPs0WGOEq13JW6wHMObIO6JjZjyzC59kYS0rMgQVz9xRc
	 PPmmC9MLNNHzvNtgOqZVSyOs8S7mFrn50qWMWq47E1Buka5RUhUI9lvEW4mBtVfbZJ
	 RgD1oz/27E8CiqVyZEGdQ0o9sDPc+L+siIN0WMEmIcwPWLyFuIB29YyRyIaRz6bcD0
	 R5gihxlSKaMTRXFcBgp9WMd4sNY6liomAd0asqw8rWCA2D+nZKfE37G7FPTw7Jqslh
	 qKlKYB6KP2zaaHRV3mcfKIxSNs13z0MmgPEdvVmfZiQ8asJqwD57WLXUI0+HT0MJHl
	 34tMP+nNE0+HQ==
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
Subject: [PATCH v5 7/9] PCI/VGA: Replace vga_is_firmware_default() with a screen info check
Date: Tue, 24 Jun 2025 15:30:40 -0500
Message-ID: <20250624203042.1102346-8-superm1@kernel.org>
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

vga_is_firmware_default() checks firmware resources to find the owner
framebuffer resources to find the firmware PCI device.  This is an
open coded implementation of screen_info_pci_dev().  Switch to using
screen_info_pci_dev() instead.

Suggested-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
v5:
 * split from next patch
---
 drivers/pci/vgaarb.c | 29 ++---------------------------
 1 file changed, 2 insertions(+), 27 deletions(-)

diff --git a/drivers/pci/vgaarb.c b/drivers/pci/vgaarb.c
index 78748e8d2dbae..c3457708c01e3 100644
--- a/drivers/pci/vgaarb.c
+++ b/drivers/pci/vgaarb.c
@@ -556,34 +556,9 @@ EXPORT_SYMBOL(vga_put);
 
 static bool vga_is_firmware_default(struct pci_dev *pdev)
 {
-#if defined(CONFIG_X86)
-	u64 base = screen_info.lfb_base;
-	u64 size = screen_info.lfb_size;
-	struct resource *r;
-	u64 limit;
+	struct screen_info *si = &screen_info;
 
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
+	return pdev == screen_info_pci_dev(si);
 }
 
 static bool vga_arb_integrated_gpu(struct device *dev)
-- 
2.43.0


