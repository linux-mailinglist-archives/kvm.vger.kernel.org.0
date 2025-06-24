Return-Path: <kvm+bounces-50564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 357A9AE70D8
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 22:33:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC9BE3B9FC1
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 20:32:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3E352EE97D;
	Tue, 24 Jun 2025 20:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="givKAtwJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90472EF9BC;
	Tue, 24 Jun 2025 20:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750797058; cv=none; b=s33WnWqV7t5QxGNdiexImwuKn41L1WNWw918PizB8E7uVvjYqV2Rd0ShvaRnEwGGNnE0oLY8mezqAga3c9ZaKTeA9GBiGhT8w1t1YEzVrchGvOzQpZmfDoNDvmC4X6Aef5fll3W8eHaZw5wFHn+g81AQAEggtOQQi40boQ70Emg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750797058; c=relaxed/simple;
	bh=0JY3xV5HErzsQVOruBIRg0clSTUDvYlikV8MoSsd/64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XipXM9/PG34jRkOqmCXOXaWXhI0NafnwYj2KkZK4DYocaA9KpVdufI52GKnJC2Xf3/6sVOMpAJKgH1HmYh7nUjqMvnAWD0XyTekb25krOHllKet95eWdi2ccl9208HjjOp5rL6dcjExa5anh+K+m+g7St8ZZ+UuKzCBgMJcElq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=givKAtwJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54879C4CEF0;
	Tue, 24 Jun 2025 20:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750797058;
	bh=0JY3xV5HErzsQVOruBIRg0clSTUDvYlikV8MoSsd/64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=givKAtwJjKiz/1i1gMN2tiFA2z4ebAavmWzFWKoQqKZRb/nCLYsGwM50LYrcSDsCy
	 lKBB8RxO3uAHeTx+l4YQELuEGGM6F6u5CR7Ym52YA5VOHhTdhtm1OGsxW+OdcAw2LV
	 mtvdCbyGS0CIcfr4Kzhi7zwL2/JDwgXBK92B1qx5Wa6B1vbSi747OHKr4nXy2Qyrsj
	 cWE0ksHtEpd200bae1ZAOAqxLyZEK+1Ci/Xub09bvBqmyaQIBVnxLEu97DSa9BkE1L
	 wYXqurE8GuWSB7JBe4PnxAkvFag4usy+P64++Z6+CG7skva+Vw/ofadMMwlGsF18OG
	 iFcIZpYK/mOBQ==
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
Subject: [PATCH v5 4/9] iommu/vt-d: Use pci_is_display()
Date: Tue, 24 Jun 2025 15:30:37 -0500
Message-ID: <20250624203042.1102346-5-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250624203042.1102346-1-superm1@kernel.org>
References: <20250624203042.1102346-1-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

The inline pci_is_display() helper does the same thing.  Use it.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
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


