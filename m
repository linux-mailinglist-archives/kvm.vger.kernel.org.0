Return-Path: <kvm+bounces-49746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EFDF2ADDB10
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 20:00:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 568B919417D5
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 18:00:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F834278753;
	Tue, 17 Jun 2025 17:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bMnXfgCK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618B1278143;
	Tue, 17 Jun 2025 17:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750183163; cv=none; b=ihhLgMlSps33jZZEwIBQLSxgGQxhoaocmGgPj9PlgAvnTTq93AmchLnpf7hrWC5J4KX1qsFKKj3pmJ6//9x2XGHyvy85oNhG8kwwZPN1nvas1TYI1+mUIcdv8iWJ/BuaKSRxKyAhCCFDVZX2gQJNRUEbBVDeywOphxoHAIbENsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750183163; c=relaxed/simple;
	bh=B2FqUgZDEIDRlLyoS0B3XrTjH48AtuNlz8x59tWs8Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R//iQ42RYRncF9zDi4bmUyWBATfxWXODPutzEDxOfM2R6R8AithkqPMRLvtUPwrlD7fnNMLOc0AcRTnFjud2HX8EVWP1m4dOO34ezIrfjtzXJCfunumMJlfsd2ezWIbyE3ovlpAiRQOniRhVScesDXihV6ifauEKSsXSoCE5/+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bMnXfgCK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23ADC4CEE7;
	Tue, 17 Jun 2025 17:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750183163;
	bh=B2FqUgZDEIDRlLyoS0B3XrTjH48AtuNlz8x59tWs8Po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bMnXfgCKWH7ZHJPyONokxGJ0RFN0/TbVOSyc/TMGOiOgz5VuUCzU65y7xACwEzMGi
	 Ioy1oZBgygLGt4yhtjO77Da9Zwkd9mEfdIVSJu9hNhu4beHBcC/0VZFtuyZ9wUV7OX
	 +F/q0gqEM8jJTZLnUsCYrPuD50ILPCRNt8D2NtEhD2rYemvdms1A2EjcIwr0p/l5US
	 UNSPekpvY9VaSb8tSP2V7mUnxHAcD8m1QBUObGoNMLEdNgR0hV/Hxy6evno3gUIt8Z
	 O7iofwWYsvsllYDU3wt/ZVOSANez/+k4kofEVBlKp95i0FBYrD8+rEQjL9TvGRxaAg
	 /rVNldiLppkXg==
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
	Bjorn Helgaas <helgaas@kernel.org>
Subject: [PATCH v2 2/6] vfio/pci: Use pci_is_display()
Date: Tue, 17 Jun 2025 12:59:06 -0500
Message-ID: <20250617175910.1640546-3-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250617175910.1640546-1-superm1@kernel.org>
References: <20250617175910.1640546-1-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

The inline pci_is_display() helper does the same thing.  Use it.

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


