Return-Path: <kvm+bounces-51627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B0FEAFA5EF
	for <lists+kvm@lfdr.de>; Sun,  6 Jul 2025 16:40:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BBD0F189B8C1
	for <lists+kvm@lfdr.de>; Sun,  6 Jul 2025 14:40:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35D8C28B7D4;
	Sun,  6 Jul 2025 14:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N0ZgnBp9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F77E28AAFE;
	Sun,  6 Jul 2025 14:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751812602; cv=none; b=ps9t8qI9Vcx3gLe+cMk+ukSGN1w7DNA/4wh3OuGL3cbB0thcubLx162mA+KPoASuzWG6sVbjoYYgODk47w4a5w9+ujaM8Cn6bDHQ3i9LI6RgGm/WwFrP97jgyKMQBAt+r69F9YSZfKEsZ/XJsodlr5tI+a/C7TJPM/jtfV0dWS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751812602; c=relaxed/simple;
	bh=hely8rCeQBZS770H5X6E0gNUH0kghs8qNa/SePVXMhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8OivHlijofE3jEa8wpSSnh1V1TmTSZD0Mghb0hftlMU7lWNdGwOQinTehysvzrPBgVvKlMUOcvx8g7kYu924vn5+3quxE4F2Xl1zPFq5CQDBb5N+mSboBS07Ar5qz8s0ta+CMzJbh+lFmdUf4qSeOyl1iEhTQ03r3WMN3OXkcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N0ZgnBp9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE09FC4CEF5;
	Sun,  6 Jul 2025 14:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751812602;
	bh=hely8rCeQBZS770H5X6E0gNUH0kghs8qNa/SePVXMhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N0ZgnBp9YJ0UPchsvkNm4Jl8YLOp3FgQq3vRwPImT8zZTiwUzKbkm61vMgG44uuUp
	 Bw6wcv+tkgc0SMhw+205GtPxxKjIixNrNNH1pZDki24F8mHiQFO7K/8AXbqBhb0YMy
	 RR3Xsa8FB4MFQe6wKLrCzaH5u9Pnb40v0E6IdAQSO6IEnrrKVva31tS3ETN3R9eXkj
	 VISu+08ZhhW5aPP7k12X0jDcTu4dgf6CuOwWx8qBwsuMAT7SfPCY1MHth0X886q7q/
	 T4c+3Ee8KmK2VfytHViGO2UxV2hYD2bQgmBULGo6JGYpTK0gTCiM/ShN4NPkmlTgRZ
	 CmglaNfB+AmmA==
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
Subject: [PATCH v7 7/9] PCI/VGA: Replace vga_is_firmware_default() with a screen info check
Date: Sun,  6 Jul 2025 09:36:11 -0500
Message-ID: <20250706143613.1972252-8-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250706143613.1972252-1-superm1@kernel.org>
References: <20250706143613.1972252-1-superm1@kernel.org>
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

Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Suggested-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
v6:
 * fix lkp robot error
v5:
 * split from next patch
---
 drivers/pci/vgaarb.c | 31 +++++--------------------------
 1 file changed, 5 insertions(+), 26 deletions(-)

diff --git a/drivers/pci/vgaarb.c b/drivers/pci/vgaarb.c
index 78748e8d2dbae..b58f94ee48916 100644
--- a/drivers/pci/vgaarb.c
+++ b/drivers/pci/vgaarb.c
@@ -556,34 +556,13 @@ EXPORT_SYMBOL(vga_put);
 
 static bool vga_is_firmware_default(struct pci_dev *pdev)
 {
-#if defined(CONFIG_X86)
-	u64 base = screen_info.lfb_base;
-	u64 size = screen_info.lfb_size;
-	struct resource *r;
-	u64 limit;
+#ifdef CONFIG_SCREEN_INFO
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
+	return pdev == screen_info_pci_dev(si);
+#else
 	return false;
+#endif
 }
 
 static bool vga_arb_integrated_gpu(struct device *dev)
-- 
2.43.0


