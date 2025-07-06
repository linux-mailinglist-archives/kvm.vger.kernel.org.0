Return-Path: <kvm+bounces-51621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 939F1AFA5DD
	for <lists+kvm@lfdr.de>; Sun,  6 Jul 2025 16:37:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F303617AD4A
	for <lists+kvm@lfdr.de>; Sun,  6 Jul 2025 14:37:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 803E328851B;
	Sun,  6 Jul 2025 14:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JNYFRdFb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960C42882CC;
	Sun,  6 Jul 2025 14:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751812587; cv=none; b=c7GJu2795mJSXWjmCG2dk5HS7coLA7T59BdZzHTkOnxGM1yUgLDRTnE9r5xyEK90haeMCdpT3kY7UjShZD4IU6FTxlkjzTM7NcPzZL9KehlcDit93BX1PCBwkIS4PV9yuHZalQIISXlwfxD83wuXkUkVGOBVZ84nI6hmoycqXlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751812587; c=relaxed/simple;
	bh=cHj3h7hBxwKQAm75Z7A1SPHl3XQrv92gk4AeXACN+L4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwZf4qBxt9BFk3W+paExURrVwrLmZ4y8+o4lB+5yrNuUtq9X2ZotrkVK+nq5r+U3ZYvLioaTHrwngD/fMbsmoNb93EVPxE7zWZBaDrgYTImnsB4o1V/iNnE4jTzJdCzNwkk/4RBrzY4AVcpMDF0lbgZbJ0EpK+pnDicxSpMjV6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JNYFRdFb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EB7C4CEF2;
	Sun,  6 Jul 2025 14:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751812587;
	bh=cHj3h7hBxwKQAm75Z7A1SPHl3XQrv92gk4AeXACN+L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JNYFRdFbZLPlrxrLcJpa0aqDgcQ2fSj3DmHsG6nlCya2qlDPB0nVCccXOIv+rWPCR
	 zPZGAa2GXCgT8tEYhhjI3KkLSloAvV19s0VtCTVDVjtts1FZvlsWPexJZvPBCQcIGQ
	 GT1tAVBxqXVCGe8sVTkc9KMFlxTT1mvqW98oRt8W/CaprbdSlmXmEcJOpNP+APRabu
	 0e1bIbzSO4UrRDT+G8M2yl5SOjUwfFanW4wSJD0iMN7kcR7yPSx8Kg5N2dSi8HBpwk
	 FYQwPRP0tHqvCdOWiAX5R8v+DAzY32KUlzW2lkJV8d0O4cfupVoIX/8HRWx0tuVH20
	 4arc047AOc2Dw==
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
	Mario Limonciello <mario.limonciello@amd.com>,
	Simona Vetter <simona.vetter@ffwll.ch>
Subject: [PATCH v7 1/9] PCI: Add helper for checking if a PCI device is a display controller
Date: Sun,  6 Jul 2025 09:36:05 -0500
Message-ID: <20250706143613.1972252-2-superm1@kernel.org>
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

Several places in the kernel do class shifting to match whether a
PCI device is display class.  Introduce a helper for those places to
use.

Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Daniel Dadap <ddadap@nvidia.com>
Reviewed-by: Simona Vetter <simona.vetter@ffwll.ch>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 include/linux/pci.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 05e68f35f3923..e77754e43c629 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -744,6 +744,21 @@ static inline bool pci_is_vga(struct pci_dev *pdev)
 	return false;
 }
 
+/**
+ * pci_is_display - Check if a PCI device is a display controller
+ * @pdev: Pointer to the PCI device structure
+ *
+ * This function determines whether the given PCI device corresponds
+ * to a display controller. Display controllers are typically used
+ * for graphical output and are identified based on their class code.
+ *
+ * Return: true if the PCI device is a display controller, false otherwise.
+ */
+static inline bool pci_is_display(struct pci_dev *pdev)
+{
+	return (pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY;
+}
+
 #define for_each_pci_bridge(dev, bus)				\
 	list_for_each_entry(dev, &bus->devices, bus_list)	\
 		if (!pci_is_bridge(dev)) {} else
-- 
2.43.0


