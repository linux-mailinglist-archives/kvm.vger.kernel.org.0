Return-Path: <kvm+bounces-49747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1471DADDB12
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 20:00:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F92C404755
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 18:00:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3388279785;
	Tue, 17 Jun 2025 17:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rl6veiUA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A33278E60;
	Tue, 17 Jun 2025 17:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750183166; cv=none; b=TU5G9JL2XCQBpvv3Oo7INipO/MFS47krY3Lst59p34BarjHVpcUuo9x3BSbz/6gw2fI57rey+H+Z3cIG0OM2QraPm7gQWH9Yq/lIadn4tsY3IHNUfYHZ6qLhyW3c7+yh1ik/R6BZsSmNtMEwOAioaX2J46hOs6BauR1MbHZH7Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750183166; c=relaxed/simple;
	bh=M+G2okprc7+csSbyn38orLtA+o98910c7qxr3mrgQiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASU+b7bcre7vzD6JSOONH9msj6IDZLEwUxMDO6Yijvn8I77bJu5MxAbX5fYN8dd1mkIBYnX8qKVEdEQfoGr3yduTw9QnXWuRT+KDM0i/6SA6CFhd+j9NYdYLEOOhNlgyPxYi2TB5yuAfUOS5ahzkMwjs+3Ogu9i3M1XUjAURuS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rl6veiUA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3850BC4CEE3;
	Tue, 17 Jun 2025 17:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750183165;
	bh=M+G2okprc7+csSbyn38orLtA+o98910c7qxr3mrgQiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rl6veiUAib3xReD7XXP9/zLBFitwjhmyJXERFXpRFXnhu58yR13sVv7nZkHU153tJ
	 iA9l1o37CB2gms2CnYwsP3Y0WUa86pgo00i4UlsVWAnTdV6CrPf8aCZWvLXhDX2qJO
	 rUAiPjErGsVj7SBIB++oozmLZmUhMH0VfvvR76IOw1sfA/lCJ/nkUa8WyeJZykj/wT
	 I3oTLAJK1/SACScCH1DbJINI4brngZ7/FdDGvrlWOPtzzdy1UpmJEAIW8zk6lz5ttQ
	 lLrr8kFbteuoamIOyXkcK88md4djWrNKGRBCYDZWWqLYsLZG+FPCZXkveA8DEqxpXg
	 uZK6uUeJguEnw==
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
	Bjorn Helgaas <helgaas@kernel.org>
Subject: [PATCH v2 3/6] vga_switcheroo: Use pci_is_display()
Date: Tue, 17 Jun 2025 12:59:07 -0500
Message-ID: <20250617175910.1640546-4-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250617175910.1640546-1-superm1@kernel.org>
References: <20250617175910.1640546-1-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

The inline pci_is_display() helper does the same thing.  Use it.

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


