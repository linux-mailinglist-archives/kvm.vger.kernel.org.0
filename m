Return-Path: <kvm+bounces-50012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B14A6AE1155
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 04:52:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5AB024A2DD1
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 02:52:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5578021B8EC;
	Fri, 20 Jun 2025 02:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="naIyrRPL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675F1218ADC;
	Fri, 20 Jun 2025 02:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750387818; cv=none; b=FcfFB0uGLwhHU2PYtSX6c6kHI4Y+pHoLVC9NO1zU2p2eV4qF4ppzp2jubzc0d7Y3d2MVztyMzzx2tplp8I57rVahs1mnwjswgu98S86y67EqJlEBDloBONg48T/bmthYcYuo2Nj7jUGBPPml1gcxm0Yr9+lN3OOAEdNx7xLxa9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750387818; c=relaxed/simple;
	bh=klJlszl08GEvhj7kAFdQZmJniKnIexv1qYhrTfixYqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l50lqKNgSXupmtNFYRYds8mfLTj2iVd2qHoIrorwKFzFgpjIJIzgmEHEzh+L8gsSHGs4hwAb9DBrnjSZzQsl4grzQGXz7PPRYEqMlPt9/Dh76CBKhBvf2ndypVFYAMW7Bplay9Hbguf/1djyRwryZ5LVV1TpUvFu0kmhtgdsmdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=naIyrRPL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD48C4CEF1;
	Fri, 20 Jun 2025 02:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750387817;
	bh=klJlszl08GEvhj7kAFdQZmJniKnIexv1qYhrTfixYqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=naIyrRPLeY2lvdbu5xv1/dFUU8Zqa7AM0VH0zT/DdWK8tthyBzVRvimPKtfoyYjsf
	 SQl6Sr9yMGCeMz7yRvwr4BUHETBWncZVp/I7i40NUYUB+7SMi3irgX3KG/6f6FHCek
	 bpupS2Y9yn4SwsMVlOc1EBsU4yHxrMLEER3DMaGs2giiJt9gjbPZhgY/YNukW6xadH
	 ALg/fHc0XA9/HFgwygPKLOI6vJmbkR1YZVlRx77+d4asemrgs0nGcO1yGaI/z6TxEP
	 CSQFdVsyA0aLxTcy+dmiEiwLAxlnI4GdRWA8z5rSS3Ath1qWVEoHYebH87S4gjQ+SN
	 9K4SCJePtMdSA==
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
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH v3 7/7] fbcon: Make a symlink to the device selected as primary
Date: Thu, 19 Jun 2025 21:49:43 -0500
Message-ID: <20250620024943.3415685-8-superm1@kernel.org>
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

Knowing which device is the primary device can be useful for userspace
to make decisions on which device to start a display server.

Create a link to that device called 'primary_device'.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/video/fbdev/core/fbcon.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 2df48037688d1..46f21570723e5 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2934,7 +2934,7 @@ static void fbcon_select_primary(struct fb_info *info)
 {
 	if (!map_override && primary_device == -1 &&
 	    video_is_primary_device(info->device)) {
-		int i;
+		int i, r;
 
 		printk(KERN_INFO "fbcon: %s (fb%i) is primary device\n",
 		       info->fix.id, info->node);
@@ -2949,6 +2949,10 @@ static void fbcon_select_primary(struct fb_info *info)
 			       first_fb_vc + 1, last_fb_vc + 1);
 			info_idx = primary_device;
 		}
+		r = sysfs_create_link(&fbcon_device->kobj, &info->device->kobj,
+				      "primary_device");
+		if (r)
+			pr_err("fbcon: Failed to link to primary device: %d\n", r);
 	}
 
 }
@@ -3376,6 +3380,10 @@ void __init fb_console_init(void)
 
 void __exit fb_console_exit(void)
 {
+#ifdef CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY
+	if (primary_device != -1)
+		sysfs_remove_link(&fbcon_device->kobj, "primary_device");
+#endif
 #ifdef CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER
 	console_lock();
 	if (deferred_takeover)
-- 
2.43.0


