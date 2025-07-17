Return-Path: <kvm+bounces-52778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 102E4B09357
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 19:38:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0D2E3AAAA5
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 17:38:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F66C2FE383;
	Thu, 17 Jul 2025 17:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MfNsPaxj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B6B1F872D;
	Thu, 17 Jul 2025 17:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752773902; cv=none; b=fbSxQuN4Kjco6LdHR8lmQyH1qZGpY2W6LBaP4ESudj1YJ3KZzCELxQ/4Ceh00usCo70MmAR0Mk8WEugvCIO+m4B/p3CY7rgF/HakOkdqZFU/je3HJXdczv7OAELicEhGnraNNnivoBqr4mdO8pDKUfB0daF7bcwsR2NmoVcYpog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752773902; c=relaxed/simple;
	bh=HMRVZWEXmaYc2Zc2cFVavR2PqNmonVLbZH+86HyVwiw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gy3ZmFeMpGyPV9f7PCRGQFVceah/8C1DQBzcMsaDhzrrdGMGLl3noa0flP/On/tW4/OYg0tgbRAPQU0hGhvs7ms0aPzE8yYg4uOVjrEV4IiN6oLr/ugu1bj3Zi8uaKabWYtcw4SbLdxnSkX+WSWcx+CadpKZifWNEP+bP34QPPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MfNsPaxj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB44C4CEE3;
	Thu, 17 Jul 2025 17:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752773902;
	bh=HMRVZWEXmaYc2Zc2cFVavR2PqNmonVLbZH+86HyVwiw=;
	h=From:To:Cc:Subject:Date:From;
	b=MfNsPaxjUp1Pjz4H96JqkhZjofo0GdFbLT03skjKKlu5rUqGBZHAwsTcKk5oEotNo
	 CP90yzu2stYpo71vcRQN03uGiSGoEd40w78wOSb9uikCR7UWyCQe+IWE/xPht2deqe
	 5eKsGo3uG6EdCJQRsi54cZZNxBZl0YtsM3Fy1lJb6e37vRSZp5DiJjKlOlzVP5MP2l
	 Ig7eEjBDBg6RGE3vsomuUi08aA3Mv9olx0uZI27u0M/AWR86t9DUdQLPaUh7Dh5SbX
	 1aUsKIylZL64Fb4oSkNbP2JdnEAj2zA5H0ipWJLg/8L2w9anjQsowu7BeXRzpY3Uww
	 n4vIsJcaRGHtw==
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
Subject: [PATCH v9 0/9] Adjust fbcon console device detection
Date: Thu, 17 Jul 2025 12:38:03 -0500
Message-ID: <20250717173812.3633478-1-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

Systems with more than one GPU userspace doesn't know which one to be
used to treat as primary.  The concept of primary is important to be
able to decide which GPU is used for display and  which is used for
rendering.  If it's guessed wrong then both GPUs will be kept awake
burning a lot of power.

Historically it would use the "boot_vga" attribute but this isn't
present on modern GPUs.

This series started out as changes to VGA arbiter to try to handle a case
of a system with 2 GPUs that are not VGA devices and avoid changes to
userspace.  This was discussed but decided not to overload the VGA arbiter
for non VGA devices.

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

v9:
 * Add more to cover letter
 * Add bug link to last patch
 * Update commit message for last patch
 * Update boot_display documentation description

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

 Documentation/ABI/testing/sysfs-bus-pci |  9 +++++
 arch/parisc/include/asm/video.h         |  2 +-
 arch/sparc/include/asm/video.h          |  2 ++
 arch/x86/include/asm/video.h            |  2 ++
 arch/x86/video/video-common.c           | 17 ++++++++-
 drivers/gpu/vga/vga_switcheroo.c        |  2 +-
 drivers/iommu/intel/iommu.c             |  2 +-
 drivers/pci/pci-sysfs.c                 | 46 +++++++++++++++++++++++++
 drivers/pci/vgaarb.c                    | 31 +++--------------
 drivers/vfio/pci/vfio_pci_igd.c         |  3 +-
 include/linux/pci.h                     | 15 ++++++++
 sound/hda/hdac_i915.c                   |  2 +-
 sound/pci/hda/hda_intel.c               |  4 +--
 13 files changed, 102 insertions(+), 35 deletions(-)

-- 
2.43.0


