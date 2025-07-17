Return-Path: <kvm+bounces-52785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DDDF3B09370
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 19:40:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D05BC5A0A00
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 17:40:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51273303DDA;
	Thu, 17 Jul 2025 17:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pGMGKGQY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F11302CC0;
	Thu, 17 Jul 2025 17:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752773920; cv=none; b=Ram9W0jNcre+yLKi7fHiQbOPqdp0hPs7Apr5NFnGfTI50G3lpDG6+hJFrHgOrxTHbVWSW5yqLfqwvoVTmgRnOgS85UDtHFD+BAhO1pFQd8p7UnFORJzrFT8VzbBbqw6FXVtOkIKxHLx2jPxbhT9Khzhdl57svw8+YDwX7c2rPxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752773920; c=relaxed/simple;
	bh=hely8rCeQBZS770H5X6E0gNUH0kghs8qNa/SePVXMhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+YOPXASjHj1xtEo4a4aDK+0RTqdmhaoufD6GhrYSrGzT/LW5FiyI84xUyv6w/Bas7HMYC/wDf3xaXp5L3ghw0qIcafb5IbMXZKGVuJC9/GOpmIySVmXdIGC2ODcCRPCVxp9fGFfdoZy2i/DuSBOCFOrPbSfJz2Z3phSK3dJXQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pGMGKGQY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08764C4CEF0;
	Thu, 17 Jul 2025 17:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752773920;
	bh=hely8rCeQBZS770H5X6E0gNUH0kghs8qNa/SePVXMhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pGMGKGQYGrUumqvvHttytPFTFdVXTNijxNxv+hDUKfw5yo7oS3Rj2EuUijDYd91Sg
	 7dreKqpz3ufzBQhWwdUPdYO4yHenJvSL7Lm0wknc13dNVnnu+KB4F+nQBv9P1KBE3c
	 dfCg+EVdP2OZfRSAOVR5L9FGVcU2ucUB8TBbsEuF6KwygO+l94AZV0eSIonZnThJjj
	 eV4Z60CjWCoivwYWICbC5RlRLlNT3aJLKI1hUBGClo60dUSurA9Mt1MQvrtTMSfy8m
	 DphycGSKXmirJCOek9kTeo90lxrh2ByUKpDxrtdEJZ8kwutfCis+b7/9kvgZfXk8/p
	 3iIft+2canwnQ==
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
Subject: [PATCH v9 7/9] PCI/VGA: Replace vga_is_firmware_default() with a screen info check
Date: Thu, 17 Jul 2025 12:38:10 -0500
Message-ID: <20250717173812.3633478-8-superm1@kernel.org>
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


