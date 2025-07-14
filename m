Return-Path: <kvm+bounces-52355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 417B4B04954
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 23:22:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C7AC87A92E7
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 21:21:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 539CA265CD0;
	Mon, 14 Jul 2025 21:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QxInUYNt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ACD3242D67;
	Mon, 14 Jul 2025 21:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752528126; cv=none; b=N89yvHd2/pg6gmgnv84hLMCpAENRVeD5jStQgPffTbVYPV+k7Tk4n9d7ctvkVHmloEw1iMiH7u5HGefzTwFHfTqQh4EbZCvwd8UZsUpt9UNcbKChJSEVdWQUzrwyc+zJqSvzVk02g0b1KmMjMcJ2Ok4wfImKdAwCGTzZrzwiZeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752528126; c=relaxed/simple;
	bh=ZUEaBNdA8Lm5/HmaCro4bOIyTqXr2dVXogleY25ibLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jozI0rlfVAYJVUwlF8ef4+w44ZdoVS+L6qFKKD+fHmkVW2zIfMGHPv1DbalH94xv5UZu1ijiPSAq6J74TC93hFgniX2uZAi6EjoR+o7jCRyrrzAvAfr70XFJljF0qlr7kN1gtl8CKOOmA456Y93GuperJKb4t/MXw8kL+ND+YEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QxInUYNt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94314C4CEF9;
	Mon, 14 Jul 2025 21:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752528125;
	bh=ZUEaBNdA8Lm5/HmaCro4bOIyTqXr2dVXogleY25ibLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QxInUYNtOP3+leGGV3WIafPIhZhV4WyoQeb/CyFqCdXm0qfcS6DL0/2K46M/hs1wV
	 ual0zSWlZH3rn9H8sLsFUYXKWlyI8PGTeEDPEeU7zKfKXc0UyMYJeeybup9QKrE0Jn
	 p84jdP47vcHnp6Zsk254AEQmg4qST6nfzS0iL8lMUX2d3ZDNNXfzsqSj36ZM5qHuHz
	 pusFXZRyXZd5qIsvUEtZkD0UqDpzqVYS/BKK6FLzZLpwd2mqdRNipGWycVyD+vnMvL
	 rFLxc1zlvYrPhP6+/SiGeqaaafTTRhoFl9fh5SsYNC+UGjJ0i2DBanpg299+TkTUfx
	 /h5LiFtDh8sqw==
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
Subject: [PATCH v8 2/9] vfio/pci: Use pci_is_display()
Date: Mon, 14 Jul 2025 16:21:39 -0500
Message-ID: <20250714212147.2248039-3-superm1@kernel.org>
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


