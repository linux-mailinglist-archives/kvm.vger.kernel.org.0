Return-Path: <kvm+bounces-49744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B85A6ADDB04
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 19:59:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29C9919417F9
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 17:59:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AADB277807;
	Tue, 17 Jun 2025 17:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ET94/gYe"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAEC277008;
	Tue, 17 Jun 2025 17:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750183158; cv=none; b=P5Cxk6wLjPEeF52JLerZ7WCLHYJWvmh+Us/mt4xKDIdMNlHHpK8YFeyVGfhGmBYbygE0Jen5sXAM6MI0kpTkqFAIoLi5tKLonka0aJptPbdK60NX0gm3Xm+RJHjrd8nKhqB1PHv4eX1+BBow27GjNNOvPEaoye6lWYZhmANZ9iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750183158; c=relaxed/simple;
	bh=LdbdRFx+Ehl4OgY5CnLFfZ3GVdzi7sFfhRUzd9mJ/Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F1oldFlDdVZYYCsGD70thUAFFOpzXj3jLDuH63P0lm0K9Xb5AWVwTyUUBc3cQ0jvVVJDErgtfNeXYM+gpm5w3LVCYQCBdAfq9IUfP5K0PNSb9l1fLDEatiWzHO69goNMCqu/Qu0hwyMx8aZtG5WDGK12na2Yeel3vLy2PvkvvKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ET94/gYe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224E6C4CEE3;
	Tue, 17 Jun 2025 17:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750183157;
	bh=LdbdRFx+Ehl4OgY5CnLFfZ3GVdzi7sFfhRUzd9mJ/Fs=;
	h=From:To:Cc:Subject:Date:From;
	b=ET94/gYeHAvPpJUMomSJtv1Jzzzxo/p9LI5dMKgSOrLCx8AMCTFe2cc5kzsrZusVi
	 pZA6m0yZ3eKaKXwi4r0JXeI6Ld3NTTtLsUrAiE3RdbKqkYZlNPqR3OnR3xLiKJRwKy
	 mW6b2l4vPUooj0+mJXLEuoIO3CsiafjR6Rj+bKNJKIt/ZpHfPG0gxvksHHdpQK2cNz
	 a8C4ACij0uQLfbWMq1/4M0HxNo0dv1d0RkLuGmHvorhRb/hoy6zuFMv+jGHVlO+3kS
	 JhY2OiBuSsuGefP3WTgx6UINJgVBrfUUnuzb/0WSXg7BO3iZhSfkAW/JAVJk1cTYdD
	 WpHOVpKa8Tjuw==
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
Subject: [PATCH v2 0/6] PCI/VGA: Look at all PCI display devices in VGA arbiter
Date: Tue, 17 Jun 2025 12:59:04 -0500
Message-ID: <20250617175910.1640546-1-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

On a mobile system with an AMD integrated GPU + NVIDIA discrete GPU the
AMD GPU is not being selected by some desktop environments for any
rendering tasks. This is because the neither GPU is being treated as
"boot_vga" but that is what some environments use to select a GPU [1].

The VGA arbiter driver only looks at devices that report as PCI display
VGA class devices. Neither GPU on the system is a display VGA class
device:

c5:00.0 3D controller: NVIDIA Corporation Device 2db9 (rev a1)
c6:00.0 Display controller: Advanced Micro Devices, Inc. [AMD/ATI] Device 150e (rev d1)

This series introduces a new helper to find PCI display class devices
and adjusts various places in the kernel to use it.

It also adjust the VGA arbiter code to consider all these devices as
the VGA arbiter code does manage to select the correct device by looking
at which device is using the firmware framebuffer.

v1->v2:
 * Split helper to it's own patch
 * Add patches to use helper elsewhere in kernel
 * Simplify logic instead of making more passes

Mario Limonciello (6):
  PCI: Add helper for checking if a PCI device is a display controller
  vfio/pci: Use pci_is_display()
  vga_switcheroo: Use pci_is_display()
  iommu/vt-d: Use pci_is_display()
  ALSA: hda: Use pci_is_display()
  vgaarb: Look at all PCI display devices in VGA arbiter

 drivers/gpu/vga/vga_switcheroo.c |  2 +-
 drivers/iommu/intel/iommu.c      |  2 +-
 drivers/pci/pci-sysfs.c          |  2 +-
 drivers/pci/vgaarb.c             |  8 ++++----
 drivers/vfio/pci/vfio_pci_igd.c  |  3 +--
 include/linux/pci.h              | 15 +++++++++++++++
 sound/hda/hdac_i915.c            |  2 +-
 sound/pci/hda/hda_intel.c        |  4 ++--
 8 files changed, 26 insertions(+), 12 deletions(-)


base-commit: e04c78d86a9699d136910cfc0bdcf01087e3267e
-- 
2.43.0


