Return-Path: <kvm+bounces-52781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CDE47B09367
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 19:39:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2AC6A1C47CA5
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 17:39:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDC1530114A;
	Thu, 17 Jul 2025 17:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ickK1lBa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056A030112B;
	Thu, 17 Jul 2025 17:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752773910; cv=none; b=hhPZH5TaEow+cvwS83jHTRcZqAfVv4t7Nb3UlKqES9KHoZ/wAreY6Qtfz9mxPVKh2UMFApYRVJ7pxFhh/tPdMnpygl79PRY4jSgVbhiBi7fhtElX10cMPDhn9x8KtaRgEXKCi7oCbowA4ydlfWkCp7JhoDYhojABcXd4mUN9Pds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752773910; c=relaxed/simple;
	bh=LQvOsrvAxtIF9zfBp3smdp/HiFPvr9jOTvuEZPP26Xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9a1JVLLqYQJRdFI5nFDBk+IJzD+AVVsWjjkQH+f1/n7YK2LAJU4DoLIts6TaHISMcAfIX4Mp1heOiUS7kzcNt1rfHLo20zaFiLyaZ1heh0+U7+/qwQeAP1A9/crvxlhaPaxlhzkNH9MEkFi2uOaaqWM/tMXI6lzM+PRy4tfGv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ickK1lBa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CB2C4CEE3;
	Thu, 17 Jul 2025 17:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752773909;
	bh=LQvOsrvAxtIF9zfBp3smdp/HiFPvr9jOTvuEZPP26Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ickK1lBad5bTYIvdilgPat1k8N9oKeb1NbYjhSUVYnAOFktqRVsV3Eqsxs009WcrI
	 VD+qqU7PTnzjhRMkjHGZlC5ppIFXjV5LgDW6VbDpHRxlWy4gIEmOlwqyAlphwci7JG
	 vol3NQ40MQLvFkWY73Jqp154KlYGzLUXdDdjdTwke35qzGbHXsGCnXpQElwsnjj+zq
	 GWrDM0AcpRdrMq/teioONtW7MtVyDKmXgin+U/n+QY2iksKI2nZR65Hka+i60UFp6h
	 CPjhDj4lI9RrjxtZMbaHluswv5aMPn/SYxkSyDi7tSHWPzaD0ChurH2gNk0X2jO77r
	 lzPJ7LL1lD6Zg==
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
Subject: [PATCH v9 3/9] vga_switcheroo: Use pci_is_display()
Date: Thu, 17 Jul 2025 12:38:06 -0500
Message-ID: <20250717173812.3633478-4-superm1@kernel.org>
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


