Return-Path: <kvm+bounces-52779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 81B9CB0935F
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 19:39:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5AACE7B8589
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 17:37:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D26E32FEE37;
	Thu, 17 Jul 2025 17:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MqPopQVr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB37B2FEE0A;
	Thu, 17 Jul 2025 17:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752773905; cv=none; b=Oit4KCtYb/b6vFBSyo4IbO6aUF9M4c2GOo52nqSvRbwfdVWdAYH1AiyRT5ZnHHT/z4Cie0tJh4PcgCzjIspbCvlVGKU7zvkl0HsoB3pq3zMefeD1JNMAZXDX6+wjVwTiLvt7it2GbtLmCAeS3tvICIniyt85N17PdQtUSSROcSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752773905; c=relaxed/simple;
	bh=cHj3h7hBxwKQAm75Z7A1SPHl3XQrv92gk4AeXACN+L4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pOZLSBOLXJnOrW2JyAmTe/JLp0kf1IriJiCEW/IVM3FmbHOYysFJDO+xfsdFMu9IaY9ix3FXmEGf2jZHcya9uQi0NpAZrP7ynkUdbZ6qSi8oG/rvy3pRVJaGlkrBeUptLezezlt9eCyEyyn//cjRkbkAynp5tnxqz2xUJUBt+4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MqPopQVr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F35C4CEF0;
	Thu, 17 Jul 2025 17:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752773904;
	bh=cHj3h7hBxwKQAm75Z7A1SPHl3XQrv92gk4AeXACN+L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MqPopQVrVeeNhmUHNU9q1gFwPPBy3S8G4cqfCt2/qWCddAkWLCU5ctEj+5LKEabxF
	 7jnFn9yJ7HvQCx+6+N9t2U9D/4QxAu6bUAxd6tR6t+iATbUlqZOAzi/jp00s4N1iQB
	 4cyITolFpE5AXqXP/mekzeBZfSPSIzfRDApWkGvjQmjtg5v1+MBUyCIr2CBaSvPTcg
	 F6iHw6gCsk5Z5Z1fbMPSNu4s8eJQqdc/16KbVOr60mbniCD5I8DDonG4mtjRZ7Jsbp
	 TMZAGlGCJqd9pn/qNGC3+8EFr4JdM8La3mTyR35BRVehFZmSEgc6Pd9c22LdD9X2EC
	 8RlHAXSL+Esaw==
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
Subject: [PATCH v9 1/9] PCI: Add helper for checking if a PCI device is a display controller
Date: Thu, 17 Jul 2025 12:38:04 -0500
Message-ID: <20250717173812.3633478-2-superm1@kernel.org>
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


