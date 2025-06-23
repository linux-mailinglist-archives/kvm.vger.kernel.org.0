Return-Path: <kvm+bounces-50403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 229F2AE4D13
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 20:50:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C96B57AB508
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 18:48:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 767862D6613;
	Mon, 23 Jun 2025 18:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JS75Q9Mf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816B42D543A;
	Mon, 23 Jun 2025 18:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750704496; cv=none; b=Nn2ec3krCp3CQco1WSqRtXVHMosOdviM0PS75tbZvN26BfXpkXcS3jx/We8piEDPugL7bNLJXWoEhFgo2ObYsfx/6ACazHGl+weU+QfDWxz92GkOoYihKQyc4cBM5Z1KCt8azfu4ttXokwG+lLghG1hrOdMWG61cFG9qFoyrddY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750704496; c=relaxed/simple;
	bh=LQvOsrvAxtIF9zfBp3smdp/HiFPvr9jOTvuEZPP26Xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jn2gvYLVtcLpzQRAKbfGPO8ZsEK0XtjR+6ACBf09rhdpGJngdiw9Ru8LxYXC9GioF4TobijNhISKwkzV2j9f50J4kd1MeIi3jUPZKBOybtrnL1XEDL8mP7fm+aBOMPYWno9q5jc+aFayUNc1wqPSlxSdHaABY8ZG4EUSsQ03Iyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JS75Q9Mf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDAB4C4CEEA;
	Mon, 23 Jun 2025 18:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750704495;
	bh=LQvOsrvAxtIF9zfBp3smdp/HiFPvr9jOTvuEZPP26Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JS75Q9MfbQfoHA5DAb5JNukDtcuHrGxfcafNkpLiX14PNqg5XVuoHJ4DkyEmAOQsu
	 2CWHKd09v5vLoAQ4Ob2WS5Mg/FzhIbHYL5ZTKzERsRiB71XeEK+fqTRCWZMc+XwzbC
	 L2OlSU2ilTw9s67vcEMuBqHZANl7uVIhx5iIL77IgkiXSmClDYu8gAU/U9UdQlZaWJ
	 55CkUA6zy4Q6bWmupa3bBt8xpTBzdlgvyTuzY7w0c3tDyE0t7ITjUNg/sxU9j2p26T
	 6XHEwDgKgsxlDSJtjRSqKNRYzEqyYiJYnyp0K8n6IYRt+mbXmiyzsXtB5VyMROFVLu
	 XmlA8rK3OBGeg==
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
Subject: [PATCH v4 3/8] vga_switcheroo: Use pci_is_display()
Date: Mon, 23 Jun 2025 13:47:52 -0500
Message-ID: <20250623184757.3774786-4-superm1@kernel.org>
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


