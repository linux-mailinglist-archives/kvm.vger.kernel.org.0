Return-Path: <kvm+bounces-51628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DB2F8AFA5F2
	for <lists+kvm@lfdr.de>; Sun,  6 Jul 2025 16:41:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE6D23AE5CD
	for <lists+kvm@lfdr.de>; Sun,  6 Jul 2025 14:40:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CABF28C031;
	Sun,  6 Jul 2025 14:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PpbWlYDR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA57230BC9;
	Sun,  6 Jul 2025 14:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751812604; cv=none; b=BKZHCPPCI7Uq6oNExfPQyCHxympLlEmiCSDXGTLjp6AsqjYnSCpOAxEHBzw7YfWJIbQIWXs2YGqy5OLvZbW3/mEJXaVnCwY5RD/jAzcv4/f3QLB1Pd5JqoXXSRiqlY/AukbxTHyu0joghkB18oZbU4fghys4/OFlJS/RNW/8H34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751812604; c=relaxed/simple;
	bh=qucJBD1l7cekJwkkW3sSPDQAFelB6SpfdgNHX+7KrGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0cxjz0iGzgAdWREOEspNTpjzombqbu1+vDoVBdyY6twTkwV2fYuhPP1CfP4qkzLf24Tn0xOlFxHRio2530q4rkYop/PNOPf2kBgr7D6Z7BS7OzaHVBXXqcdznmhAnCZYRy0RxrqeN84zhz6FN2OsbrYGIm/MqWA7vtUOHOT7s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PpbWlYDR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341F7C4CEEF;
	Sun,  6 Jul 2025 14:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751812604;
	bh=qucJBD1l7cekJwkkW3sSPDQAFelB6SpfdgNHX+7KrGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PpbWlYDRkCuGunmFT9sTtHbxSwd/gVVaMktE59Av5bQNJlpIpRWWnBMwON8LQkbBW
	 6gXenJkP+sbVWehgc9Qa4LZngn4VzayvaKyP4D/gf5ASSXZlb5Nr869RaVew8OnB/6
	 kE61VerYy9vnazyRtGJxRv8MDOupgCzJ6JB3k+P2jlvgUjPkMUX7fXh4EBt5sp4/pE
	 O9W0Z/s5Q9iKMr63iqMxPUUSFuSKz5F64qsgf9NdYhX1RBfEbnOplk9TaDJlRXdfRx
	 zuNEX/u0VqDtrmTAtzX598+shxngHQGeh+kFXhAikczUIzAiLs53PC4Fj2CNbZC1nW
	 i0MO8mX+JbXqg==
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
Subject: [PATCH v7 8/9] fbcon: Use screen info to find primary device
Date: Sun,  6 Jul 2025 09:36:12 -0500
Message-ID: <20250706143613.1972252-9-superm1@kernel.org>
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

On systems with non VGA GPUs fbcon can't find the primary GPU because
video_is_primary_device() only checks the VGA arbiter.

Add a screen info check to video_is_primary_device() so that callers
can get accurate data on such systems.

Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
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


