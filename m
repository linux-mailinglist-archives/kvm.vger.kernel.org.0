Return-Path: <kvm+bounces-50009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A653AAE114D
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 04:51:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 504FE16A86F
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 02:51:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D0FA1BEF77;
	Fri, 20 Jun 2025 02:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E7DqYkxD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618681F4CB7;
	Fri, 20 Jun 2025 02:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750387810; cv=none; b=GjcoyDSMkia6J3S56upqdOP3YJJrIHzGzIeKQJn94DOuVLHrqHrZnjyJdufKS2WJmyVB+HOnGHhdmyOjJdeydQIdZT5dtilLeGNhZC8Xtlu+7Nx5pq3BRaaWyFLrWnm3y5VvVogNCKN07bKuWOb2e3q0PKgme30abAce/Bp+/H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750387810; c=relaxed/simple;
	bh=Ih+h2iwqvMjgBNiHK36GhUh+ba0wYl7IY7LdJr3tFyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhTEssFjLOx524VZVRpr95REmk1eoTDKg3RBFSOhMCnq5+K6ijV/t8jgUEoy/wGld7Asli+PeDPaGIiVnZTDbYh/miVNDS9WVEV8+L2QzphsUvXU9cnipv48MK6NfiCP2+T80bZiprpzycYVDh/DQwU38GmoQc81iqu4sJUmNIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E7DqYkxD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1C4C4CEF0;
	Fri, 20 Jun 2025 02:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750387810;
	bh=Ih+h2iwqvMjgBNiHK36GhUh+ba0wYl7IY7LdJr3tFyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E7DqYkxDp5yEsLNjurdGHq8o9w8fL2aUk0QqJVKB2CQTqimuHTJNZrZj/tw2n5Nem
	 OQxMwMeb1KzMDZhMXy9EnSddk7iUr8mvJFP2RYWpbuGV5l1mAXE2I5ZsC8mmI745Fc
	 qIJsw0Ouk0ylFiQtECSETcrX5jSzfxVCipEFI8hHlH5uBIA4O1++CWRb+xJQit63qY
	 TiY2J/ozFNd2uQJUrByLhXJ3jwD/+TfW7KhQOhHG0Yx5Mw/DXI75cTGN7VZphprAjg
	 rblzh1CiXjM2jq3ZmRxADm31/DXQIDNS4XlC68FMiGa5Y+jRdff7LlOJlFh7Tn5j3v
	 XEKeeFCtNbznA==
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
Subject: [PATCH v3 4/7] iommu/vt-d: Use pci_is_display()
Date: Thu, 19 Jun 2025 21:49:40 -0500
Message-ID: <20250620024943.3415685-5-superm1@kernel.org>
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


