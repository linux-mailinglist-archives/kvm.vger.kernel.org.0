Return-Path: <kvm+bounces-50560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC186AE70CC
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 22:31:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F0753A86FD
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 20:30:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D41E25745F;
	Tue, 24 Jun 2025 20:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kqIMUNjL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E70426CE23;
	Tue, 24 Jun 2025 20:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750797049; cv=none; b=GsCNWVpuiTDfo2e0dE3TKMMYxST0o57onWSxTDZiKxS1nSJFoF6/+e1cB8FbT6uq8JGpssZBBPKshDMzSYDyaD/E3xLIb1/yBn0DKLydM74pFwrGVOzRiBOOwYUQsjYr3LAaoTgAXe4Tgq8V6b4kxn3g4pmm+qjpIMLQ5j00SWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750797049; c=relaxed/simple;
	bh=y+bjAAAX0Ofn2Lf/MUjBwYQIZMlmSNiS8DuXQGq1OB0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZZne06KGIjBSp13bQyUU96k5PQ77qnSVzpsbS486J+8/HPAJ9rxrev+D2Q7UPlIkgxq/5vYZb5Jf9cm/8KpI32tfunzJgClT1fZoPr6Zrct8jPkoDHSgaqSCR/q4zP2co46bfRG4ABIPPa4bAehtyAek7k9t13hFt2tpELZdUeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kqIMUNjL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59CC2C4CEE3;
	Tue, 24 Jun 2025 20:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750797048;
	bh=y+bjAAAX0Ofn2Lf/MUjBwYQIZMlmSNiS8DuXQGq1OB0=;
	h=From:To:Cc:Subject:Date:From;
	b=kqIMUNjL3iQkUXSnp9TFoTNRylBMLcEZtyjimsxiuRpZwQWkh+WcUcNc72yz5lfH/
	 mNeg6/NZVdE8j88oRlt+w6I9/PH7Ka7yyn1+wemXfx6iyx1OUfwTiNkzXB0PPfxSDl
	 jJuNUGgEtTP2pX3Sij1t51tpRSC1G451sJYrIiNH5VLIBLbxoUrXm08+VUJcBZKYQE
	 ox9HooJkf/zf9xswYOuCYIsqgfAHVsy5dJ/VLobZg2mAgS90g81+r+bugVEoF2GpgA
	 wop3ZGTUDts83zcsIZ3N33gBm6DHOkej6YGJ5KMNiO1ll61hvzhbQcpqhCfxNvhtEn
	 cIJha5V58VOug==
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
Subject: [PATCH v5 0/9] Adjust fbcon console device detection
Date: Tue, 24 Jun 2025 15:30:33 -0500
Message-ID: <20250624203042.1102346-1-superm1@kernel.org>
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

 Documentation/ABI/testing/sysfs-bus-pci |  9 ++++++++
 arch/parisc/include/asm/video.h         |  2 +-
 arch/sparc/include/asm/video.h          |  2 ++
 arch/x86/include/asm/video.h            |  2 ++
 arch/x86/video/video-common.c           | 13 ++++++++++-
 drivers/gpu/vga/vga_switcheroo.c        |  2 +-
 drivers/iommu/intel/iommu.c             |  2 +-
 drivers/pci/pci-sysfs.c                 | 14 ++++++++++++
 drivers/pci/vgaarb.c                    | 29 ++-----------------------
 drivers/vfio/pci/vfio_pci_igd.c         |  3 +--
 include/linux/pci.h                     | 15 +++++++++++++
 sound/hda/hdac_i915.c                   |  2 +-
 sound/pci/hda/hda_intel.c               |  4 ++--
 13 files changed, 63 insertions(+), 36 deletions(-)

-- 
2.43.0


