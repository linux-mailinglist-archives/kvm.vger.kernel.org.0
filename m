Return-Path: <kvm+bounces-52782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F8A8B09366
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 19:39:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0933A473A3
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 17:39:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C09BB302059;
	Thu, 17 Jul 2025 17:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p+DaYnpi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76FB30115E;
	Thu, 17 Jul 2025 17:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752773913; cv=none; b=AqT6IBXMT2xiw4m0FJQQo9IsULyez3gmG7Ozn4LJZkhPK1+2IApJOB6TZ5d8mxI5wvup3v0v23mez6LNsCA1zC38IkEHroD77WFeXGviBnT92fVgF+nI7xJMnaitP3qw+hzmVQbN1yxsq2KnOeMADqBM0M9N+yooopghw4CJJBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752773913; c=relaxed/simple;
	bh=wZDfgswU2/pwcpS3H3uILO4jDTDnQH15cewPVoii5Es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hjomrt+jBcE+yGGbC+Ec4rDhkwfYmEzGFK5nrd7LArJuK3x/o/N+0AbatRP5bIZrQ9/vKBOlCmi38bagGi93XJcCUyphipJljivVXRx+1v6cktMKUYpazFNv0/xWjdtxLmAd/SwVVO4uyQzYLSP5wcjjMbSguXtOddthABJbI94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p+DaYnpi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2486EC4CEF5;
	Thu, 17 Jul 2025 17:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752773912;
	bh=wZDfgswU2/pwcpS3H3uILO4jDTDnQH15cewPVoii5Es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p+DaYnpi70Lt2MtzM8YaWKYHHUBdCgnvhTTgtm73exhs9Mn3b+6hmFITHqv0+ZvJi
	 pDnPOnggRnvlkChq/yGWc4+gjU5E2tZvdNha1pu3NB10GgCwnMUiSWJvsy3WUuXtEc
	 8orPRtp/q8m0JzErTQp3pi6guOkUUSDZ9mwa0G/pk6FOvUVW7bnYk+Eo1OauHBvmZx
	 gVkL+J98IF7V2tyMLOJTHLgcEgR6gMsqvosTrLBYhCRwtsGain0t+7SCkbYl9UDiL4
	 HhNZ+NvxXnVt8PyA9oiZPkMwujUocLNZ/83t2J2iYnbB54hAcAi6xpLRDFhlJQj622
	 XNowdQjx0pbnA==
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
Subject: [PATCH v9 4/9] iommu/vt-d: Use pci_is_display()
Date: Thu, 17 Jul 2025 12:38:07 -0500
Message-ID: <20250717173812.3633478-5-superm1@kernel.org>
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
index 148b944143b81..cad9ed1016cfc 100644
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


