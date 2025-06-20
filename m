Return-Path: <kvm+bounces-50006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E4B8AE1146
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 04:50:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62DCD3BFE49
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 02:50:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB1CE1DE891;
	Fri, 20 Jun 2025 02:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S5eMEaVx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBFB1B5EB5;
	Fri, 20 Jun 2025 02:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750387802; cv=none; b=Wqk4px1bY3E26qzLHZKSNvjzAitX9N08GZPQbrDvqfhm6+uEV8IaihM2nRjmdr3/pZizqfibY2x03YyT+C5M0K5i1qNskg5waOHngZOzL5tW2AOJDKvzmlgu/3YpAjrcitfgcS3imyfPqk2cNIRsSTR1irgxHlB8fnbpzWr/f5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750387802; c=relaxed/simple;
	bh=dwUS0NNQBo6ioFvBv9MvL8ShjmESObZeByXZvWYMJKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKdDK3tdSMb46GtuYsD8h8eE9dk8Je5XD216ovp9Go0lAkGs0m605npjrCJjBnkojca/x/XegwUj6CMhNVR7cmBFGjhqXBihI42vrMzxkSlq5Is+x6El1Ltk2qk96cu4LL5x9C9ijqD4p9w1sLLOcqzscLcuWrhY07XkXx2ZOLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S5eMEaVx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 171DFC4CEF0;
	Fri, 20 Jun 2025 02:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750387802;
	bh=dwUS0NNQBo6ioFvBv9MvL8ShjmESObZeByXZvWYMJKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S5eMEaVxgF6txdm4vtGRsHjfa187clMuzbb7RyDkJvhG9ytlzIHxdMPQMDvaCRMyF
	 k3kbmtGJIx/Dw3x6wNYXGQtjOVfa0MJEfjJfKGYLMXpO9sevsDhCzLmWcN5VR09BO7
	 Hw5Bq/N+1TUPCaohwxvPbT+cB7D7YvWHCgOnQ1IawQt4WkoqfyLbOnKG2gtRMtr4O1
	 1xSDfo4Zqyges6lQDtyHHvqhVJI3mDnZbOmZ+KNMWWjvHmagR3l2sggLK7VOD9RJVZ
	 wlA+Ed4ApaqraFxNxpt7ldfKtefWB02TbNb5lh1ldFHWlsoJpZzQm4WYzVXuALKKwp
	 VmaGadYzYXC1g==
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
	Simona Vetter <simona.vetter@ffwll.ch>
Subject: [PATCH v3 1/7] PCI: Add helper for checking if a PCI device is a display controller
Date: Thu, 19 Jun 2025 21:49:37 -0500
Message-ID: <20250620024943.3415685-2-superm1@kernel.org>
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

Several places in the kernel do class shifting to match whether a
PCI device is display class.  Introduce a helper for those places to
use.

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


