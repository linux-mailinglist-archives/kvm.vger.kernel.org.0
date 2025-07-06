Return-Path: <kvm+bounces-51620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F2CEFAFA5DA
	for <lists+kvm@lfdr.de>; Sun,  6 Jul 2025 16:36:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9DF0318990A3
	for <lists+kvm@lfdr.de>; Sun,  6 Jul 2025 14:37:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 803522877FF;
	Sun,  6 Jul 2025 14:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ll4o4Sol"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960C5249E5;
	Sun,  6 Jul 2025 14:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751812585; cv=none; b=Mj34goKXISx7z0kcLc2y3EvVytTGSiNie6XrYMtOsxzLf+f4YQ+vqGhoRfbJX05a3EA0BJXbBMpsL87RGbvWfBZGF6R0tTRKyTa7vR1ng1pMHAeDz3oXC3BlYIHJmwlYaoWiaKB12TwjZPn/FfwpmTpQGLQvi7HbxRYKRl4rWFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751812585; c=relaxed/simple;
	bh=ekByHfhCU5YFqk89HOWrsMr+RRd71IlBqB2XanDxxo0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tFSyDmMP3anZt1pHytH9Yf4Mqzn5KKPMQOq90zrv8o9QQkx/4cza9jEB/gzKYO7zv9MvsHOYNxl/KlsLIH6wYcr5ChMdtchciH2k5v6WOdcwx5WahNF1HLcOIz4weMKuX9GmcUiCWDNOrNB4K47PBGBpQr6ilKxclDrQeOWfzVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ll4o4Sol; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6AFC4CEED;
	Sun,  6 Jul 2025 14:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751812585;
	bh=ekByHfhCU5YFqk89HOWrsMr+RRd71IlBqB2XanDxxo0=;
	h=From:To:Cc:Subject:Date:From;
	b=Ll4o4Sol1xB9CHvaGKW/406YEBaUdZrTWq6lLV1dFJM2KaUURPnzXKOKi4uTgdkBT
	 1ARmrnpLtOY7KMVDB1gDHAyrmr+XQkK70EWXKhVUZTeRpMdo/Te6dPK1XIjfMDqk2F
	 JNs1d4BtRaLfWKAppA6dwapoZGigjAsBXAI15chD5JjzbpP/CbfnqPMJBmp90fFLDj
	 EHmkjyr7KRKy+owRH85kLyWUqRUpvY0QS8x+4o2UU6BdcNMgrQEf7O3k+wuUb6uyo7
	 mitoySK8mt5KCmY4x8lFrjn65/4yysdrxaisXKCB964z8BXN/NQ+lJ6TdguYwgTZoQ
	 TtD7bp2k/QZEQ==
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
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH v7 0/9] Adjust fbcon console device detection
Date: Sun,  6 Jul 2025 09:36:04 -0500
Message-ID: <20250706143613.1972252-1-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

This series started out as changes to VGA arbiter to try to handle a case
of a system with 2 GPUs that are not VGA devices.  This was discussed
but decided not to overload the VGA arbiter for non VGA devices.

Instead move the x86 specific detection of framebuffer resources into x86
specific code that the fbcon can use to properly identify the primary
device. This code is still called from the VGA arbiter, and the logic does
not change there. To avoid regression default to VGA arbiter and only fall
back to looking up with x86 specific detection method.

In order for userspace to also be able to discover which device was the
primary video display device create a new sysfs file 'boot_display'.

A matching userspace implementation for this file is available here:
Link: https://gitlab.freedesktop.org/xorg/lib/libpciaccess/-/merge_requests/39
Link: https://gitlab.freedesktop.org/xorg/xserver/-/merge_requests/2038

Dave Airlie has been pinged for a comment on this approach.
Dave had suggested in the past [1]:

"
 But yes if that doesn't work, then maybe we need to make the boot_vga
 flag mean boot_display_gpu, and fix it in the kernel
"

This was one of the approached tried in earlier revisions and it was
rejected in favor of creating a new sysfs file (which is what this
version does).

It is suggested that this series merge entirely through the PCI tree.

Link: https://gitlab.freedesktop.org/xorg/lib/libpciaccess/-/merge_requests/37#note_2938602 [1]
Mario Limonciello (9):
  PCI: Add helper for checking if a PCI device is a display controller
  vfio/pci: Use pci_is_display()
  vga_switcheroo: Use pci_is_display()
  iommu/vt-d: Use pci_is_display()
  ALSA: hda: Use pci_is_display()
  Fix access to video_is_primary_device() when compiled without
    CONFIG_VIDEO
  PCI/VGA: Replace vga_is_firmware_default() with a screen info check
  fbcon: Use screen info to find primary device
  PCI: Add a new 'boot_display' attribute

 Documentation/ABI/testing/sysfs-bus-pci |  8 +++++
 arch/parisc/include/asm/video.h         |  2 +-
 arch/sparc/include/asm/video.h          |  2 ++
 arch/x86/include/asm/video.h            |  2 ++
 arch/x86/video/video-common.c           | 13 ++++++-
 drivers/gpu/vga/vga_switcheroo.c        |  2 +-
 drivers/iommu/intel/iommu.c             |  2 +-
 drivers/pci/pci-sysfs.c                 | 46 +++++++++++++++++++++++++
 drivers/pci/vgaarb.c                    | 31 +++--------------
 drivers/vfio/pci/vfio_pci_igd.c         |  3 +-
 include/linux/pci.h                     | 15 ++++++++
 sound/hda/hdac_i915.c                   |  2 +-
 sound/pci/hda/hda_intel.c               |  4 +--
 13 files changed, 97 insertions(+), 35 deletions(-)

-- 
2.43.0


