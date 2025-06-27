Return-Path: <kvm+bounces-50938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D984FAEADE4
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 06:32:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F1F2F1C2165B
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 04:32:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFB711E572F;
	Fri, 27 Jun 2025 04:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QUvTTjCG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA56D1E0DBA;
	Fri, 27 Jun 2025 04:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750998681; cv=none; b=buxkp6C2KdomiNk7z6O2ORoligi8vUe6OEyYNAjQeK2ezrC2F93pQR4/8Uey3KVjaGjcarSvVo9x4c4OziwelXCkDfTLbmwWE2zVt8bRi2tqJ2Jy6KDcesjZte5vYJvdK2SIXrj6yJfOrhrrDz7nu1U+bmVdzpQzXgzlu2DXO7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750998681; c=relaxed/simple;
	bh=ZUEaBNdA8Lm5/HmaCro4bOIyTqXr2dVXogleY25ibLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lpf9IgPzxCbZt/1QZ7ObBqWRH0CnbFmplLUZ79j51AiQ3B56qL3eIWzHm+dVCKlhGCIrBitONtyAcrYeIVxrq4xeIA0tXpULdLAQP8XhBIhCOLS5Q5tqXhyH0VvTEOY2l029rn1EJ+lv09BlG87CKRZXMET3B2qkR1JTQpUm0PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QUvTTjCG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09FAC4CEE3;
	Fri, 27 Jun 2025 04:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750998680;
	bh=ZUEaBNdA8Lm5/HmaCro4bOIyTqXr2dVXogleY25ibLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUvTTjCGiyKuGvLJSfWCMsHnpmiYAIrCP9VPpBdOEJNMty1Vo7M0suxGFn+C9eUrl
	 eGT4h3W/xn6pvlXv56LLXbRhk35cGzZcP46f2bqWmTRJBv6xT1VwhMCn8F2eO6fp7I
	 thdIttX2sj70vGxc2SAo/CSPuVkUCm0j+lRmnkhiFzhOpNR+XBnGK9LbXe24KuqaAB
	 iOLKcADTy4ULjQCAEqY9n3ODjezJucL7biN+SC9dSw7hdoNj5lm/AOLpteFsvNGUro
	 yUYgtXFlVJdkZgx7WzyR6HUy1y1mggEwCVXaoZUYxjLWk7WcV+7XiRosdDW1o3FdHm
	 wi16/qarUSQIg==
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
Subject: [PATCH v6 2/9] vfio/pci: Use pci_is_display()
Date: Thu, 26 Jun 2025 23:31:01 -0500
Message-ID: <20250627043108.3141206-3-superm1@kernel.org>
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


