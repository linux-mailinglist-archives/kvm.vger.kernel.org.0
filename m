Return-Path: <kvm+bounces-49745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FAD0ADDB0C
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 19:59:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D1E0403EA2
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 17:59:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D48B5277CAB;
	Tue, 17 Jun 2025 17:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SMAx7yhu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38A927703C;
	Tue, 17 Jun 2025 17:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750183161; cv=none; b=SIufsVD4LKMhFyxuZKgnImowMb1we10VtFwMz2jhp60jqrGL2Tg1sQ1caCBFH55sDZAGI1LcBwlktzcDH42ynnoH0OEL+8nUduj2qxKjPbR9ORZPhCvpVd1PhIOGYp3HKHuT+MoSwt/48V07dIjHX3ZqCn++NEKaN+aV2Q0oNms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750183161; c=relaxed/simple;
	bh=guzSVFa4kwHai9EZMK8+P7TeBT5zm7vwCIz/+uGdD5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5gVOcIkLBnMAVe14zsR1/nXHy1wRoa4K1ZaGmM8S+VbTHzXudna+F30toXiac/M/y05JXrWgOPLVqJG3ZsU/Zyu0yZh0gH4mdx1q4G0rjbHNvXW8cKZ0Un01NKW0ThL/CZRpxGbRBKSDl5UTcHUqtyr0aVlvxXpL//bUs5Ng+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SMAx7yhu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19ADC4CEF2;
	Tue, 17 Jun 2025 17:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750183160;
	bh=guzSVFa4kwHai9EZMK8+P7TeBT5zm7vwCIz/+uGdD5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SMAx7yhuA28BYQvwArliGoV3yuWcx5cJN5pyKXWKNMXwxMZiLy8mnBJhPKqheazTl
	 WaTD1JZpn4HgNmXP6xrXDqTQ8T2aZOgVG/y15CbZVYG5PpMBdpGy4VocI20M+H8dO7
	 KFq5sMI7BkgJnwb2xyj8hKh5qAi1nGRLG5RpCouM6aJVvCZRUx2hymsiI9vO41Q8/N
	 DpXuoO0qRis9A38gAAqG40bazMRa5RvuzO8dVGUelKGlwsZHcP+fF2aTkdt8hswZPo
	 VXL0ibNhW+1WKJaqpnCxfk8E1JYsHUyWZ3zRgDMEQm43lQl80XCWfLGtaqUcvc9ZaU
	 /BHuTK+gUkGnQ==
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
Subject: [PATCH v2 1/6] PCI: Add helper for checking if a PCI device is a display controller
Date: Tue, 17 Jun 2025 12:59:05 -0500
Message-ID: <20250617175910.1640546-2-superm1@kernel.org>
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

Several places in the kernel do class shifting to match whether a
PCI device is display class.  Introduce a helper for those places to
use.

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


