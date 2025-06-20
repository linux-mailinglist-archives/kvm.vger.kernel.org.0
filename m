Return-Path: <kvm+bounces-50008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 40BEEAE114B
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 04:50:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8549A3BFD4C
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 02:50:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B0411C5D7B;
	Fri, 20 Jun 2025 02:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PGBUm2o7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193951BEF77;
	Fri, 20 Jun 2025 02:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750387808; cv=none; b=USL6+VePthOVAj+sS5Ly/6EW0jNX+tsnP/63EiaitXZdgjWHLXghhOBNGFouN5fTcSywwI6D+JgXUzSRsxwCgkZ01xkQyo8tvvYLgWgmEo3Idgn9xttrnYR6Pxa9Wuda0YKfC9CAYdPN5ZbTgLKijDXnLQFbxtJFGPXQb9TabpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750387808; c=relaxed/simple;
	bh=LQvOsrvAxtIF9zfBp3smdp/HiFPvr9jOTvuEZPP26Xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibyg/OaDdrrPV10LTHkH9vXY3iJJYQie0xtaf2RfGhEqMhLx0Ih59JYPgIfCP1+ZhnX2fzb40Aa0TndD+mKDZT3v5/Difk37Ot/RMKVYHXRFq87j3RhawZmXSZhJbtdVHUGWC5TWYnHzPZSsXIGBUJvZEPYsRTf+iMTu+DcZmoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PGBUm2o7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457AEC4CEED;
	Fri, 20 Jun 2025 02:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750387807;
	bh=LQvOsrvAxtIF9zfBp3smdp/HiFPvr9jOTvuEZPP26Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PGBUm2o7UvmWDftzQ+LVu6cMrhulZSKHNUe84Dbu27J14PKOOuuTNyjzs13xz+Apf
	 F30BNj1fZTKmiklG5XIaUVFcyOcuwlrIMp8RgH/hTdVCR33IM+ZCztDH/XFeol9X3N
	 P9oUARiymvmBxQuQLmX000HfLX/sfOm01TzSi1WN6UbYsfYZmrecDo80OORpi1n+Tm
	 KmYcN3eAfn+51ulB91oDr1ZrUp1tKVM04gJvwCHBAPgwSk2HA1oST+iVjoiMBCEmGz
	 i87RO7bbzQFdCVMFfkB7WXjfrrykrKbUPbTrt3tLXDCYXaHIuXaksnsUAluIwRfKK5
	 /6f7JSBTKbPAw==
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
Subject: [PATCH v3 3/7] vga_switcheroo: Use pci_is_display()
Date: Thu, 19 Jun 2025 21:49:39 -0500
Message-ID: <20250620024943.3415685-4-superm1@kernel.org>
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
 drivers/gpu/vga/vga_switcheroo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/vga/vga_switcheroo.c b/drivers/gpu/vga/vga_switcheroo.c
index 18f2c92beff8e..68e45a26e85f7 100644
--- a/drivers/gpu/vga/vga_switcheroo.c
+++ b/drivers/gpu/vga/vga_switcheroo.c
@@ -437,7 +437,7 @@ find_active_client(struct list_head *head)
  */
 bool vga_switcheroo_client_probe_defer(struct pci_dev *pdev)
 {
-	if ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY) {
+	if (pci_is_display(pdev)) {
 		/*
 		 * apple-gmux is needed on pre-retina MacBook Pro
 		 * to probe the panel if pdev is the inactive GPU.
-- 
2.43.0


