Return-Path: <kvm+bounces-50400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DCA1AE4D00
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 20:48:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E6893BD733
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 18:47:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F31782D4B4D;
	Mon, 23 Jun 2025 18:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MSvgL1q5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0875F1E1A05;
	Mon, 23 Jun 2025 18:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750704488; cv=none; b=cv1z4AlAHqgjy/pF+jpVC/t1cwXUVgkoKyzCIGY3Ms2IiRB5QexGQO9R86GH0v4wwFKYFIYrowKamvpS3MTDvtBNqKusK1VQJMglxEFwUG+MCOfUA0rHD9NcwvSebV6c0rTFSHkZvKje+q5FnJEtcWCQ8IKGWmmQg8mncO6w4pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750704488; c=relaxed/simple;
	bh=GY8tIufr4Hd6SlZygWeAkfnwAyZfajXtBmdtfEVITZg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HQQ5n6s/4yRS+EoBlr1vobdQ5CMPzfgDYGIuk9PP9Iz31QfJvU3517b3OL7apr/y6ufLWqjRXGO+5kRiCjV/FZ0D7bjlF0232w9/afbLLjrZFWHpewh0pHqxdYhWmgLkO5vfXpkbjbWs3rq3WQyUnxtYBT4jNPalUY8cam37Xi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MSvgL1q5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4790CC4CEEA;
	Mon, 23 Jun 2025 18:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750704487;
	bh=GY8tIufr4Hd6SlZygWeAkfnwAyZfajXtBmdtfEVITZg=;
	h=From:To:Cc:Subject:Date:From;
	b=MSvgL1q5wZGV5IyyqUmlkvkUm7K0i8jPT1haS86qUQi+Kq92/DOHXePlD9lPVaMss
	 oQYDZSms3mw8PVeDaBUngX0e49Q+iWyDeaVhFCQktYG5ShQLIIXNVyUuf3M1OkB7U+
	 Q2hXfc1EfR7RP1vMRaq+T97sMyMwsLxxFVM3HWADNlMK4KlXkOwJF6PsUAKkPd/RWw
	 Vx+YKnTT9vgkxhmRUykmTqyXw9/sGEqyXM2FGvCJN4DjBfeEBsqn3Vc8UFAvAQ72rw
	 GczZPRxH0XE/cp9RLMf0oOOZX/ZrTwU4w2UB4IONrlDYWh57Sc82zUzdX5vm6XUIhq
	 Yhc7XqWstP+RA==
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
Subject: [PATCH v4 0/8] Adjust fbcon console device detection
Date: Mon, 23 Jun 2025 13:47:49 -0500
Message-ID: <20250623184757.3774786-1-superm1@kernel.org>
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

Mario Limonciello (8):
  PCI: Add helper for checking if a PCI device is a display controller
  vfio/pci: Use pci_is_display()
  vga_switcheroo: Use pci_is_display()
  iommu/vt-d: Use pci_is_display()
  ALSA: hda: Use pci_is_display()
  Fix access to video_is_primary_device() when compiled without
    CONFIG_VIDEO
  PCI/VGA: Move check for firmware default out of VGA arbiter
  PCI: Add a new 'boot_display' attribute

 Documentation/ABI/testing/sysfs-bus-pci |  9 +++++++
 arch/parisc/include/asm/video.h         |  2 +-
 arch/sparc/include/asm/video.h          |  2 ++
 arch/x86/include/asm/video.h            |  2 ++
 arch/x86/video/video-common.c           | 13 ++++++++-
 drivers/gpu/vga/vga_switcheroo.c        |  2 +-
 drivers/iommu/intel/iommu.c             |  2 +-
 drivers/pci/pci-sysfs.c                 | 14 ++++++++++
 drivers/pci/vgaarb.c                    | 36 ++-----------------------
 drivers/vfio/pci/vfio_pci_igd.c         |  3 +--
 include/linux/pci.h                     | 15 +++++++++++
 sound/hda/hdac_i915.c                   |  2 +-
 sound/pci/hda/hda_intel.c               |  4 +--
 13 files changed, 63 insertions(+), 43 deletions(-)


base-commit: 86731a2a651e58953fc949573895f2fa6d456841
-- 
2.43.0


