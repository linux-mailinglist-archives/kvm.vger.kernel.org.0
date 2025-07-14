Return-Path: <kvm+bounces-52354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87034B0494F
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 23:22:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49DCA4A366D
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 21:22:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B451C278142;
	Mon, 14 Jul 2025 21:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KYuexU9T"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9788277037;
	Mon, 14 Jul 2025 21:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752528123; cv=none; b=RYr01LDrFS+JIEVgfALjpbPRzIJwlMDU/yEywD4qNt5pDBhfOR+6gG02HIzFRmdVJlP3HlkXPtj6AlCvptInqwZkzer+O7tludw9SyFWrK/BBOzCgA36ICS4j827r86RunUK+jIqJALUx5L7l30PNckU3zRb6k9fAK1ScMzZMLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752528123; c=relaxed/simple;
	bh=cHj3h7hBxwKQAm75Z7A1SPHl3XQrv92gk4AeXACN+L4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=km31hA8sAZwGjHz+g7XaDXrgqa7G+dVsBwHpbLb8bb+y5rSIenCHpPuL7cNX/xTNKigEQ31jCm0bCTZN1/L948Z0AsMesXTnRDpSJblvUZVb3TxONKMmxoowaj2riHd6lkPv3RROTeVaRIiXHp6SglFDnnbHmu6q7mtoqVzHDT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KYuexU9T; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16789C4CEF8;
	Mon, 14 Jul 2025 21:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752528123;
	bh=cHj3h7hBxwKQAm75Z7A1SPHl3XQrv92gk4AeXACN+L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KYuexU9Td6B5gShJK768qQbiuSChZZU2RTVK+UDwHjsx5HFa3ZNAZ9fhsxzkc3Xyz
	 EjabZ1lo6KsETDjaBR0pi/pIxH8A3tqrLMfBaglQkG7Yb8SzkcATNsNhVjd1CHHBR1
	 5VxbbrcgIgarU9YS6nUyCT2NR0kr9QPRL9jrYGy2s2+s09ER4+0sFRjMuPU9Luykrg
	 DmBErzHpGymCx+lfihO0NbL4AYl7C+jncR6bE81Dm3e/OAPqWF/PFuQNEVODwINvvW
	 46z8YrfI3dffe6yHI2EFnZz8hM8aXV5kJLnUOBgnCMHEmG2t6H94QHEWaCxCAOIsiV
	 LP5pNSxywu1hA==
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
Subject: [PATCH v8 1/9] PCI: Add helper for checking if a PCI device is a display controller
Date: Mon, 14 Jul 2025 16:21:38 -0500
Message-ID: <20250714212147.2248039-2-superm1@kernel.org>
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


