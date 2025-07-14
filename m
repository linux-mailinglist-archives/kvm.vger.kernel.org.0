Return-Path: <kvm+bounces-52361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 92B3DB04968
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 23:24:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C3AE4A700B
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 21:24:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44629277C87;
	Mon, 14 Jul 2025 21:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IvZs3O44"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603A6276058;
	Mon, 14 Jul 2025 21:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752528141; cv=none; b=FvsPDvXoWpLNBPsGeBdpGd9gDUn/lOpiY/QVUHY+wChMf338gAsIphLBFjgpqr5A6A1b/ydoLlzjvEoptRWEjWOWJ4/AI3zfBLneRPpw8g8RtTGtBvDu3/dokuL8rY7e2PMh3Lx8vK679g552jc/oha/7bKQOGiPl0YLY0M5kgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752528141; c=relaxed/simple;
	bh=qH+nP7l6aO/IuqqbAQWnlb+L+ux6ugVAwetscoen+88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G36V+oS1HTW1Z3ixPpZS8jDdCtLbrkyrqdquBjTBjtsGkbuBZV4DrczpePIPraB54O7pk2Dxt8OB6Ct6oIuGFvdZgJ337IBrC2plwNovPwC5x5IMs7Q5i2e8kUqOa5rB3gceFuGNQyniFubmX2tHx/5oGZRnxaqSXjwlXduj5wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IvZs3O44; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135E8C4CEF6;
	Mon, 14 Jul 2025 21:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752528141;
	bh=qH+nP7l6aO/IuqqbAQWnlb+L+ux6ugVAwetscoen+88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IvZs3O44p7tmoIZb3GY57LVIsVIBKAI4pBVbYywJ/+QIuBtDhGRmvlAU1KRtuZIOS
	 RvcR3dN21vYvxsi8I60Jx76yVakJsvYSm5UmVEgjVU5d0zia0Vby3Lzzyhi01HlCYF
	 pnvJU9RM9H5FHyhsSvhKijPD5n/twfH7FegQAh2B/BVjI0hCteMoq5V/lWTYrrV1pQ
	 qmT8InPp6HSWfkMCXjIopbDaWMYzyeAXqj1+eYGQXYFjpQx7IHNlQ9hu7mfOTFNjrY
	 0nqOYUbph1gBRxdf9Kf9VgqYIGab2lN9CDoHUPInw8Vz5etkLdzj3A4GgIl6G3NbpP
	 RKPG+7FSf71PQ==
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
Subject: [PATCH v8 8/9] fbcon: Use screen info to find primary device
Date: Mon, 14 Jul 2025 16:21:45 -0500
Message-ID: <20250714212147.2248039-9-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250714212147.2248039-1-superm1@kernel.org>
References: <20250714212147.2248039-1-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

On systems with non VGA GPUs fbcon can't find the primary GPU because
video_is_primary_device() only checks the VGA arbiter.

Add a screen info check to video_is_primary_device() so that callers
can get accurate data on such systems.

Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Suggested-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
v8:
 * add guards for the non CONFIG_SCREEN_INFO case
v5:
 * Only change video-common.c
v4:
 * use helper
---
 arch/x86/video/video-common.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/video/video-common.c b/arch/x86/video/video-common.c
index 81fc97a2a837a..4bbfffec4b640 100644
--- a/arch/x86/video/video-common.c
+++ b/arch/x86/video/video-common.c
@@ -9,6 +9,7 @@
 
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/screen_info.h>
 #include <linux/vgaarb.h>
 
 #include <asm/video.h>
@@ -27,6 +28,9 @@ EXPORT_SYMBOL(pgprot_framebuffer);
 
 bool video_is_primary_device(struct device *dev)
 {
+#ifdef CONFIG_SCREEN_INFO
+	struct screen_info *si = &screen_info;
+#endif
 	struct pci_dev *pdev;
 
 	if (!dev_is_pci(dev))
@@ -34,7 +38,18 @@ bool video_is_primary_device(struct device *dev)
 
 	pdev = to_pci_dev(dev);
 
-	return (pdev == vga_default_device());
+	if (!pci_is_display(pdev))
+		return false;
+
+	if (pdev == vga_default_device())
+		return true;
+
+#ifdef CONFIG_SCREEN_INFO
+	if (pdev == screen_info_pci_dev(si))
+		return true;
+#endif
+
+	return false;
 }
 EXPORT_SYMBOL(video_is_primary_device);
 
-- 
2.43.0


