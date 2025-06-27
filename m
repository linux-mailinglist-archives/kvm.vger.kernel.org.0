Return-Path: <kvm+bounces-50944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 352D0AEADF9
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 06:34:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2B094E2077
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 04:33:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6829A21767C;
	Fri, 27 Jun 2025 04:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mTfo0QUs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FFC1DDC04;
	Fri, 27 Jun 2025 04:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750998696; cv=none; b=pgCR0i8UpW6mhyTRxEj1UUrZ7qbb5OLHYv/kWBdVj0zeNu3Av7Xu9W3mqXOacFCkigmn/PNjR37lmcIK5J1Y08mV75Nq0hli7u+K24s5y3nsofqKZfFWWHRLGwc1ppRa8sdSfzPVnbvMcagGc9/+lnC8tiEkIVACHEd9+F+Vhf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750998696; c=relaxed/simple;
	bh=29HKhswcd8px+N2nYcp6Yih2LctL4W2GlFxn1lIVTTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MxDpjONrivSbQxapk6PL+w8ANEt4W8FXqlg02ND79jDLfr6jIt8/axjBr54wHs/wVnh2MLfvKecgKIRP759ZnkzoIP+ZXM/AmaiQCQWQaHTLQy6Jjq5ojdJtoLNWj/D9WTj6NAEBz2Nbb4GRhSgAs1TyOJ/9bzy0TBiDINxEaUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mTfo0QUs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89FBC4CEE3;
	Fri, 27 Jun 2025 04:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750998696;
	bh=29HKhswcd8px+N2nYcp6Yih2LctL4W2GlFxn1lIVTTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mTfo0QUsUHtoEmWXuaeJ6AdrJ28pBSLTo/6MN1G2cX6Yj3MKalD5rA9KtkRHZZfPd
	 iVDC29Ldy0VtPgjyf82w6kuvDmbIagIuLF3B8uuP5Ww7oE+vmptG2oR39XXXNq47oJ
	 VBkpa+N9F38nFGPbjLmkeBnosK6yokBTH0WHF2ZSB4VMWOs/O8/tZvmCl50OYqbdXv
	 M7yOE+paF/oeKoBS0tJ6mEc0IoxDDa8GXbJTWtrc+tQXeQMigGxU+JbYKFqxOEDJQZ
	 m+y80IBI3zy5ZYdAP+ouz02AHh21jE2KkY/sTsS2veJnsh+LJVnWZUnMmN/aa39vIe
	 QSvlIUkKfpK8w==
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
Subject: [PATCH v6 8/9] fbcon: Use screen info to find primary device
Date: Thu, 26 Jun 2025 23:31:07 -0500
Message-ID: <20250627043108.3141206-9-superm1@kernel.org>
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

On systems with non VGA GPUs fbcon can't find the primary GPU because
video_is_primary_device() only checks the VGA arbiter.

Add a screen info check to video_is_primary_device() so that callers
can get accurate data on such systems.

Suggested-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
v5:
 * Only change video-common.c
v4:
 * use helper
---
 arch/x86/video/video-common.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/video/video-common.c b/arch/x86/video/video-common.c
index 81fc97a2a837a..917568e4d7fb1 100644
--- a/arch/x86/video/video-common.c
+++ b/arch/x86/video/video-common.c
@@ -9,6 +9,7 @@
 
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/screen_info.h>
 #include <linux/vgaarb.h>
 
 #include <asm/video.h>
@@ -27,6 +28,7 @@ EXPORT_SYMBOL(pgprot_framebuffer);
 
 bool video_is_primary_device(struct device *dev)
 {
+	struct screen_info *si = &screen_info;
 	struct pci_dev *pdev;
 
 	if (!dev_is_pci(dev))
@@ -34,7 +36,16 @@ bool video_is_primary_device(struct device *dev)
 
 	pdev = to_pci_dev(dev);
 
-	return (pdev == vga_default_device());
+	if (!pci_is_display(pdev))
+		return false;
+
+	if (pdev == vga_default_device())
+		return true;
+
+	if (pdev == screen_info_pci_dev(si))
+		return true;
+
+	return false;
 }
 EXPORT_SYMBOL(video_is_primary_device);
 
-- 
2.43.0


