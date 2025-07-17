Return-Path: <kvm+bounces-52780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D342EB09362
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 19:39:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7BC617DF0E
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 17:39:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 852EF2FF491;
	Thu, 17 Jul 2025 17:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CFUWkWfg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5A72FF471;
	Thu, 17 Jul 2025 17:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752773907; cv=none; b=VW6YZCYW0nVSFPoZLuCUBSYQIPhaBYyeMuMcYuwMkKi2fv2rudpr8K+HuhE02wIs/MdW6UcimJnWvxT7wGrsgKWfaTgXKTLZkEHE6PXMMVS/AQsW3fqwvet1LEZQFCXWSF8nEWOMJ1b9umqlhOYqWk6rTDxWK8EDS3lMux68iSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752773907; c=relaxed/simple;
	bh=ZUEaBNdA8Lm5/HmaCro4bOIyTqXr2dVXogleY25ibLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6FfYmZvWb4htQ62N4oEAFzBtllsqhDjk/XRABkgj+X7hhSe3vUk4sYnbEpc+ZxY3jZayrvX4S7lUxBsy+BX7Ju4hpQuc5tGGx+7dEnKtQ1foVsLntC2/vTxqIfKXM/jKNBb/JrpihJG43dCcb+3dqepWxm5hYzActPvImRcgFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CFUWkWfg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8D8C4CEED;
	Thu, 17 Jul 2025 17:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752773907;
	bh=ZUEaBNdA8Lm5/HmaCro4bOIyTqXr2dVXogleY25ibLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CFUWkWfgMNlxap9CCDH8BbOALN7ZNEohNzab1yM3QtbK6WQKZgyDBrFjeF3kj5Ia6
	 5KhlGGwnRGFhBr48XWVqCAsIwLgTfjjnl1v+LJTECvu6RqauOzPDUQbNJawP6K/16O
	 rzluCKDuczfM+OmHkUMkd17ViUR+pY7prykb3sJYCPB7JnkscfuzDtx3jlAoEjvUvX
	 68wFB2+h3Nyy73cj+jV+GQqu+Tq9H+a9xwnxm1P6eJpBNJ6q/HzaUxmVemL54fBX0A
	 pIbXRdp6GEEZigXHrgQ3X27k4c7yQjAAelScjoA4Un5ivB0jaIkXBwsLOMw52pzerL
	 FZNwSVokRZ+Dw==
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
	Simona Vetter <simona.vetter@ffwll.ch>,
	Bjorn Helgaas <helgaas@kernel.org>
Subject: [PATCH v9 2/9] vfio/pci: Use pci_is_display()
Date: Thu, 17 Jul 2025 12:38:05 -0500
Message-ID: <20250717173812.3633478-3-superm1@kernel.org>
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


