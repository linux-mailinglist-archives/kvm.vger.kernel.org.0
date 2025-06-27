Return-Path: <kvm+bounces-50936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 52DF4AEADD5
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 06:31:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B20704A39AF
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 04:31:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7DEA1D63DF;
	Fri, 27 Jun 2025 04:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HwNMc6br"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96B32F1FE2;
	Fri, 27 Jun 2025 04:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750998675; cv=none; b=InII+qAfocEQZwtJVpc6dZXA1A9ZuzZa313XMsGSB0d3fPIrhse/c1yL8EwclMY/XLiVLt5y96lZ8nrWaQs4mkUayE7o+C26MJPM6iG33PiSJ7Qw0ASCXUXEY86bcqmc1fNwW2xbZPBz92B0GMQia0TDB4SWL6djfq7/mTElOnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750998675; c=relaxed/simple;
	bh=0M8ENBUgJpYWdqDPptXBiIAcVDOQpN779919of1Ylao=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bWrf/WRsD+qcttGiuJHxfnc7G1judx+Jweu6Y6MiFwDjo20txTqo/JE7ogcRBV7ItR7GKaYIMlM9LA6S5kLaYj8Qalc4NFoWg+ZRhG2eZNBdB12XIZIj16zdJkMFjdjDJcHD/0FMDZSkluwAqHQI78yPleizdIqM8m5t3RkXzCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HwNMc6br; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A804C4CEE3;
	Fri, 27 Jun 2025 04:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750998675;
	bh=0M8ENBUgJpYWdqDPptXBiIAcVDOQpN779919of1Ylao=;
	h=From:To:Cc:Subject:Date:From;
	b=HwNMc6br/86SWTAf2Al9i/DC7sIhdMgBlr/piYuh5A7ga2cP+v2QumzvTssRb8ZJN
	 o0woLJRiKrqiM+dXvzwt/+gfXV4ku2aXwAzfLvY62rxlWrjCuJ2lH+FJeWkne3rpHn
	 H7JveObRMVtBrdcP/NbYAE15jX0kO0/PBcnzf6v69O0zSi2x1ozaObNMgcdWTAHyHD
	 6+Es8DoRDoqWzQk7lcSIVHTIrCV7wyz4slJR1ZeslyFbsBeMaihJUbYVeIj/AVA1BP
	 Tz2Uiz/wEzjjs4q7V/uBCbOpZgsUtCl3/Ik/kcf/pfRhPXGvzE1kCn9mR47gIwz70o
	 87JfFd+kufeKQ==
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
Subject: [PATCH v6 0/9] Adjust fbcon console device detection
Date: Thu, 26 Jun 2025 23:30:59 -0500
Message-ID: <20250627043108.3141206-1-superm1@kernel.org>
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
of a system with 2 GPUs that are not VGA devices [1].  This was discussed
but decided not to overload the VGA arbiter for non VGA devices.

Instead move the x86 specific detection of framebuffer resources into x86
specific code that the fbcon can use to properly identify the primary
device. This code is still called from the VGA arbiter, and the logic does
not change there. To avoid regression default to VGA arbiter and only fall
back to looking up with x86 specific detection method.

In order for userspace to also be able to discover which device was the
primary video display device create a new sysfs file 'boot_display'.

A matching userspace implementation for this file is available here:
https://gitlab.freedesktop.org/xorg/lib/libpciaccess/-/merge_requests/39
https://gitlab.freedesktop.org/xorg/xserver/-/merge_requests/2038

It is suggested that this series merge entirely through the PCI tree.

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


