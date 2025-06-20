Return-Path: <kvm+bounces-50005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 900DEAE113E
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 04:50:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D5F13BE47B
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 02:49:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 471941C862D;
	Fri, 20 Jun 2025 02:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BLmH3ddh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EB323CE;
	Fri, 20 Jun 2025 02:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750387800; cv=none; b=TFLMvXOJ2vqPWUdiE24VTt4OitjwxLg+zxBMgVEVo11o32nT4TWREKvCRu6dQQG6z7Ut7UVjg2ktvlXa6HAeh/9VACBX+kWss/aWpZQbngBJ9026JVXjfJkp+87RASKn9klMvSWt1FFgKDZQ3U96q+z+lwAYeC27smQYYQ+ChBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750387800; c=relaxed/simple;
	bh=tVUGmwudnPHtt0FAp/eQCsy7CQzmylV7GVpKzRyrQJg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AmSq+mLt5iYf2EbwGXwSxgE8BYHjbrJpclKMNlRp4yfGzufYXOLo/FAJ4aYxFwBeGXYkiy6m9HgEEbeLWXaL/GlMzEWg0Fok06dCM5tnnm/XFwCIR7h0+xBzn3ROnJ5ykaJzuaipLjegZh16NargQ7OarsZzdRPO4SmSfRhxFhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BLmH3ddh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861FDC4CEEA;
	Fri, 20 Jun 2025 02:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750387799;
	bh=tVUGmwudnPHtt0FAp/eQCsy7CQzmylV7GVpKzRyrQJg=;
	h=From:To:Cc:Subject:Date:From;
	b=BLmH3ddh0nPQLvGOwLBQLZwrJOUsaYpuI2kEgbnH6ZtRch276fXQS0xPY1H078mDm
	 q75Z4C04WDgTyP1KGLfar17f6fBNXrT497v7S4FPlgdvAmNsogPoRUccHYChCLpSFc
	 zsrOSeP7SpX+TkYqydvB1fbqsVg+LzB+zyq+5wZg2JukriPj2bZnHTzfd8/R/ebW3p
	 g09B6O/OGGIK8RgoSGW2v1j5Gg5tygKyW2WgSAxafqPYKhj41htmBRl+/C+jugkKu2
	 RTVD85tVhod62FJ8SV/hYDq5LcDRbRQDnPiMwOhdM4Mdb98e6J3hVd6aSgXoKPOdaA
	 DN9o3rXnyvNrA==
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
Subject: [PATCH v3 0/7] Adjust fbcon console device detection
Date: Thu, 19 Jun 2025 21:49:36 -0500
Message-ID: <20250620024943.3415685-1-superm1@kernel.org>
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
not change there. To avoid regression to fbcon, fall back to VGA arbiter.

In order for userspace to also be able to discover which device was the
primary framebuffer create a link to that device from fbcon.

v2->v3:
 * Pick up tags
 * Drop old patch 6
 * Add 2 new patches for fbcon

Link: https://lore.kernel.org/linux-pci/20250617175910.1640546-1-superm1@kernel.org/ [1]

Mario Limonciello (7):
  PCI: Add helper for checking if a PCI device is a display controller
  vfio/pci: Use pci_is_display()
  vga_switcheroo: Use pci_is_display()
  iommu/vt-d: Use pci_is_display()
  ALSA: hda: Use pci_is_display()
  PCI/VGA: Move check for firmware default out of VGA arbiter
  fbcon: Make a symlink to the device selected as primary

 arch/x86/video/video-common.c    | 28 +++++++++++++++++++++++++
 drivers/gpu/vga/vga_switcheroo.c |  2 +-
 drivers/iommu/intel/iommu.c      |  2 +-
 drivers/pci/vgaarb.c             | 36 ++------------------------------
 drivers/vfio/pci/vfio_pci_igd.c  |  3 +--
 drivers/video/fbdev/core/fbcon.c | 10 ++++++++-
 include/linux/pci.h              | 15 +++++++++++++
 sound/hda/hdac_i915.c            |  2 +-
 sound/pci/hda/hda_intel.c        |  4 ++--
 9 files changed, 60 insertions(+), 42 deletions(-)

-- 
2.43.0


