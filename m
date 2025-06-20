Return-Path: <kvm+bounces-50010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38CDEAE1151
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 04:51:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14F426A2489
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 02:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46A2920C489;
	Fri, 20 Jun 2025 02:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IbBeR8cF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5974720468C;
	Fri, 20 Jun 2025 02:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750387813; cv=none; b=O8pC/ptmrcVyG3dlIlOJN826Z48lpR8LYNaAQuWO+WgdLhzE9UkUF6/08VQkj7oOcwwFXAeFEa3fyd2KLRzqmcssnl0PcZkjpxA/12H0D3qrQezXodvGglMzRb4PmoDevtn8EML9Qgn09pvrSabb5v/4ryh+OcZ+q0a7ZtAfU0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750387813; c=relaxed/simple;
	bh=jA4gnuDewWS3532FipQUrqJVwhvNJ+77h1lJRVOGOrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFMQZPDtXMpj0QS1CPBzjp3DHWQwDHPGXTLeKwAyybVrmOqvD5mN66PUoD2pQD6VJ/BG9MSPeDIlz4UU6/eXyBWh9CTKxDQAdn1RhgNyDM5T2nhyVjpX1FqwaBZP4gqpj6RKsTulAa+BhZVXtDhyX7nQOOHoEBDfHMF5xoozrNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IbBeR8cF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F376C4CEF1;
	Fri, 20 Jun 2025 02:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750387812;
	bh=jA4gnuDewWS3532FipQUrqJVwhvNJ+77h1lJRVOGOrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IbBeR8cFe6L6Pbvn5/KtK5CD0n69p9F8D5s21I6kaHf+GBexLVXDE9IZdi9rVwJl9
	 gAzk4PG4eeDskwJ+xrQOoOW/a0LSaZp7W+9VPqTgV5PaR2dLiQIhWvt+Fon3UJDIc0
	 6uhDpRTTnoSpwSwDb1JBlo9B1kpWh+u+eRzQfNPaKmDQCUfuJ41Xbw1gbTtzU/glRB
	 DNLTKxKdibrBOjRJPrG1inwhp8YrDwoAKf2EO35YDnCuXLl4gsfk1nK+xxjih3quSq
	 JbW2aoLII3Y4EW2b0AByXyRAYkxld5gV4R9LcksGFQbLXzA+inR9CeU2OU/3sFawHm
	 i2aPGY11Nh/AA==
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
Subject: [PATCH v3 5/7] ALSA: hda: Use pci_is_display()
Date: Thu, 19 Jun 2025 21:49:41 -0500
Message-ID: <20250620024943.3415685-6-superm1@kernel.org>
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

The inline pci_is_display() helper does the same thing.  Use it.

Reviewed-by: Daniel Dadap <ddadap@nvidia.com>
Reviewed-by: Simona Vetter <simona.vetter@ffwll.ch>
Suggested-by: Bjorn Helgaas <helgaas@kernel.org>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 sound/hda/hdac_i915.c     | 2 +-
 sound/pci/hda/hda_intel.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/hda/hdac_i915.c b/sound/hda/hdac_i915.c
index e9425213320ea..44438c799f957 100644
--- a/sound/hda/hdac_i915.c
+++ b/sound/hda/hdac_i915.c
@@ -155,7 +155,7 @@ static int i915_gfx_present(struct pci_dev *hdac_pci)
 
 	for_each_pci_dev(display_dev) {
 		if (display_dev->vendor != PCI_VENDOR_ID_INTEL ||
-		    (display_dev->class >> 16) != PCI_BASE_CLASS_DISPLAY)
+		    !pci_is_display(display_dev))
 			continue;
 
 		if (pci_match_id(denylist, display_dev))
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index e5210ed48ddf1..a165c44b43940 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1465,7 +1465,7 @@ static struct pci_dev *get_bound_vga(struct pci_dev *pci)
 				 * the dGPU is the one who is involved in
 				 * vgaswitcheroo.
 				 */
-				if (((p->class >> 16) == PCI_BASE_CLASS_DISPLAY) &&
+				if (pci_is_display(p) &&
 				    (atpx_present() || apple_gmux_detect(NULL, NULL)))
 					return p;
 				pci_dev_put(p);
@@ -1477,7 +1477,7 @@ static struct pci_dev *get_bound_vga(struct pci_dev *pci)
 			p = pci_get_domain_bus_and_slot(pci_domain_nr(pci->bus),
 							pci->bus->number, 0);
 			if (p) {
-				if ((p->class >> 16) == PCI_BASE_CLASS_DISPLAY)
+				if (pci_is_display(p))
 					return p;
 				pci_dev_put(p);
 			}
-- 
2.43.0


