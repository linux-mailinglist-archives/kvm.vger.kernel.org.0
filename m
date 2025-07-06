Return-Path: <kvm+bounces-51623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 59CB5AFA5E3
	for <lists+kvm@lfdr.de>; Sun,  6 Jul 2025 16:38:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F58A3AE624
	for <lists+kvm@lfdr.de>; Sun,  6 Jul 2025 14:37:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 580A0288CBE;
	Sun,  6 Jul 2025 14:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rFvLJZHc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD18288C3A;
	Sun,  6 Jul 2025 14:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751812592; cv=none; b=brQZyad2p0bs0IQiiFKE8a7YU75GTgrE5AS0IpYOGi0CAr2oHtT1LIjQ4hIqGrT/aBb9vS/Gd9KHT7qpGPxmd3wGuGreC8dVYRWxwYyUyopECcN8jcnS1YZ1JuHUb8AEJ17RTmOBg7S2/6TxeBruLL3WDTmqvIIKo3/tU5+5ngs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751812592; c=relaxed/simple;
	bh=LQvOsrvAxtIF9zfBp3smdp/HiFPvr9jOTvuEZPP26Xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+N16brjGx5iSO8nhSRSkCR7NNanrmqR8z3uyyLhi9ZvCxzi44X1CnJmnfBT6IuLtgUsNvUzfizfZ1m0PbgCBoH1lVF51xc6ku8dE1jOKopWIvbmCmnk+7pYAfC9ueMBmQ/kiISclmawEBgkTZZNPQ9ZiaBwQdCAs1sYqLoBkFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rFvLJZHc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C696C116B1;
	Sun,  6 Jul 2025 14:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751812592;
	bh=LQvOsrvAxtIF9zfBp3smdp/HiFPvr9jOTvuEZPP26Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rFvLJZHcU29O0N3LGnbtxWxip20YjNqI8oyhqdO0sYhjqsj7lTGgiv+R5o3LI5UUc
	 +179CqJfuBWah9qpMn9Wi8YeSrbVF/6LhBghNhADHlnV54hWbDAtxYYTaE5wOyYJcx
	 dXgb6DlCZYOdwY0H7GyH6S4dLae8azwQfDaFswhN8Vu2kEc/h+thqGkp4gPGCJhLnd
	 zjJ7RXzw87ONI8D9EUG3NVe3sdAgPbEZs1EK26TLBNCe5AX7qr1eRICotXm9MCDs5J
	 AmgC4HsP8/KDVxz1TrBTc7vsOpD9dkFaPl6MGczb2lZqBoCAiViGtL33hMIr2oC9BH
	 JxljwFndWfVlQ==
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
Subject: [PATCH v7 3/9] vga_switcheroo: Use pci_is_display()
Date: Sun,  6 Jul 2025 09:36:07 -0500
Message-ID: <20250706143613.1972252-4-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250706143613.1972252-1-superm1@kernel.org>
References: <20250706143613.1972252-1-superm1@kernel.org>
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


