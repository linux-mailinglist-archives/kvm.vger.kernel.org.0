Return-Path: <kvm+bounces-50404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C7B1AE4D17
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 20:50:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7FE5C7AB8EB
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 18:48:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E235C2D8764;
	Mon, 23 Jun 2025 18:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ARRQtSP8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005602D661D;
	Mon, 23 Jun 2025 18:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750704498; cv=none; b=ObhoSQkQlDzUrDJ/z6BZVQdKhlNBDGix4+mRb6AZreuZ4rxYTWmOQPy62vx8+gAQx9n18n/xikPAkiIRoZ4YpQQL92cknv1vOBbjmUc38QDxmlIqA4ba3uwd/eauJ5biK88j2/kuPNprrTkdQZGy93g6i5H71M9Wtqa6Lzfd+NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750704498; c=relaxed/simple;
	bh=Ih+h2iwqvMjgBNiHK36GhUh+ba0wYl7IY7LdJr3tFyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GBkTt5NjNVAw1p9qkgC5A6/HkyIKE9SE/HrWNfErv4igzE2s8wdgcPjh5dgHJuzAUH3d4cXv6fQtCK+2E1G2eTztotcwb/47GgVe0K+cCZf+zJePsXJJq5SJ7llfHFp2Rii+GmpS/mXV77CrOr+2ibI4DPbOyPOA5N97s+AMtHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ARRQtSP8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA65C4CEF2;
	Mon, 23 Jun 2025 18:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750704497;
	bh=Ih+h2iwqvMjgBNiHK36GhUh+ba0wYl7IY7LdJr3tFyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ARRQtSP8ZSmE90wy6kFOBo+Bb3ljCUXPzdD7jCO7dJQ56QBkmsLhD0yw8K8o8cxPA
	 b949RwyLjreR8NKA5csNISUkfGyTECdrZ01XZ4aA6gtIA4Ze5PVikx9RsYWNRCKVbE
	 NaDBwPGULrN/4miaU/g/dk2SEuOzX3QMzFubKhqZxs3KsUk8Hdv/QUokQ4qYzphjTt
	 mL2kuDgCBDvljcD4H7NZwUHYr6ooI2VgiCsZki+wi0bIPKU0X7h3iX/hWbV1VdLhbl
	 V0gjNkupGP7bigP/XzweE4xc/ETrnVKxR0tKz7RwF2WpUIQfBvVgWaT9ZCRW0RYc52
	 qT7E2dxT1MGaQ==
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
Subject: [PATCH v4 4/8] iommu/vt-d: Use pci_is_display()
Date: Mon, 23 Jun 2025 13:47:53 -0500
Message-ID: <20250623184757.3774786-5-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250623184757.3774786-1-superm1@kernel.org>
References: <20250623184757.3774786-1-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

The inline pci_is_display() helper does the same thing.  Use it.

Reviewed-by: Daniel Dadap <ddadap@nvidia.com>
Reviewed-by: Simona Vetter <simona.vetter@ffwll.ch>
Suggested-by: Bjorn Helgaas <helgaas@kernel.org>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/iommu/intel/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 7aa3932251b2f..17267cd476ce7 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -34,7 +34,7 @@
 #define ROOT_SIZE		VTD_PAGE_SIZE
 #define CONTEXT_SIZE		VTD_PAGE_SIZE
 
-#define IS_GFX_DEVICE(pdev) ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY)
+#define IS_GFX_DEVICE(pdev) pci_is_display(pdev)
 #define IS_USB_DEVICE(pdev) ((pdev->class >> 8) == PCI_CLASS_SERIAL_USB)
 #define IS_ISA_DEVICE(pdev) ((pdev->class >> 8) == PCI_CLASS_BRIDGE_ISA)
 #define IS_AZALIA(pdev) ((pdev)->vendor == 0x8086 && (pdev)->device == 0x3a3e)
-- 
2.43.0


