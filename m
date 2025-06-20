Return-Path: <kvm+bounces-50007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 03EABAE114C
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 04:51:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F00511BC1433
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 02:51:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8262B1E7C16;
	Fri, 20 Jun 2025 02:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LRZbz5Eb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BFA137923;
	Fri, 20 Jun 2025 02:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750387807; cv=none; b=a6yl2rwpQfB68WoyGB3dF8P1gFBLjbxNd3/H5TlVgutmPkjla/WHYAEcp6UGZZG6bvTFRUj7La7+ASRJuv+Wn3uzycIEqYEYG6xqstAaS7LmBmgFgKoO8y6slDZzOY2qjA/oNf4a5/ZaeUM4Pi32ThX/mCvsg79IhakaBQk8VA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750387807; c=relaxed/simple;
	bh=ZUEaBNdA8Lm5/HmaCro4bOIyTqXr2dVXogleY25ibLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kb1icdg+b2xk2YkQtBxscZu+AfVZSniGyyox2O/j1bBp15aTdZCtf1KUgxoP1j3yGEO0c9zp0KG6EoTYupwp29/lQtSjsqhRep8E/TfRGuHC6G8deWIRaw4WCkLdOuopf1Buxnb7EJHk2v9C62L+apSHYpAApvbdGXOBa0Hewbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LRZbz5Eb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7EAC4CEF1;
	Fri, 20 Jun 2025 02:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750387805;
	bh=ZUEaBNdA8Lm5/HmaCro4bOIyTqXr2dVXogleY25ibLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LRZbz5EbCeC7e088SP07B+UomuNsEYpTA6mmPktnFMPgd5kXKx++tqicojyekhQNd
	 Ac8I9+qBDuL4pdA0Y77VR4i/CFk2teNF1xFluFyXp2rFgRMqftm5UsI3htiZgmqImA
	 FCd0kA3ZhfawJtAW2Gl3++5CI/9nrfw4+ylnIHkU+iqC2XZ0yFpZ9i3Ub7Y/p7RsF0
	 /YJ71NZDLLGJ3CIT7Tlm18CNxjqAunuTcYVFUs7sNWiS3HyfYsfYzh1uailMcmPny8
	 PZ59Gw2/kgpTMmw4hpcyKB0ZS0E8E+rXbMNyELu0OXpzI+gNQ8p6ixjocxsAdaBve1
	 xPSv56bj5ENEQ==
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
	Mario Limonciello <mario.limonciello@amd.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Bjorn Helgaas <helgaas@kernel.org>
Subject: [PATCH v3 2/7] vfio/pci: Use pci_is_display()
Date: Thu, 19 Jun 2025 21:49:38 -0500
Message-ID: <20250620024943.3415685-3-superm1@kernel.org>
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

The inline pci_is_display() helper does the same thing.  Use it.

Acked-by: Alex Williamson <alex.williamson@redhat.com>
Reviewed-by: Daniel Dadap <ddadap@nvidia.com>
Reviewed-by: Simona Vetter <simona.vetter@ffwll.ch>
Suggested-by: Bjorn Helgaas <helgaas@kernel.org>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/vfio/pci/vfio_pci_igd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
index ef490a4545f48..988b6919c2c31 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/vfio_pci_igd.c
@@ -437,8 +437,7 @@ static int vfio_pci_igd_cfg_init(struct vfio_pci_core_device *vdev)
 
 bool vfio_pci_is_intel_display(struct pci_dev *pdev)
 {
-	return (pdev->vendor == PCI_VENDOR_ID_INTEL) &&
-	       ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY);
+	return (pdev->vendor == PCI_VENDOR_ID_INTEL) && pci_is_display(pdev);
 }
 
 int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
-- 
2.43.0


