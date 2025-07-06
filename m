Return-Path: <kvm+bounces-51625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EEFAAFA5E9
	for <lists+kvm@lfdr.de>; Sun,  6 Jul 2025 16:39:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5D5C27A7068
	for <lists+kvm@lfdr.de>; Sun,  6 Jul 2025 14:38:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DB41286D78;
	Sun,  6 Jul 2025 14:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YxWfi23s"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78D4289E3C;
	Sun,  6 Jul 2025 14:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751812597; cv=none; b=bwbE6Fa0ZwUY6HlyzsHRrx1CFqXN+lQmqtuBXStbgIF0pYRut775DjvEmUQGyu08S50hge5SbdhjPongQWwTRh1RwST+pl4qMj62STh0r5Tl+z4qEHW/jC04H56lgsR7VPYtuy4VkemtU82o8Gd2qA1j0STNRF5/8lGbl7UJrHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751812597; c=relaxed/simple;
	bh=IOGKTg8m2lLVk2BGnUQp473zWXZ7OF1rNECuXqPIWig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKVL6QQnUJZEymjnEf700zCrXez58PyHGhi51dhVo+T24G05psCRM8z5uY12uI6qJ0737I4oLo1vLtCegLFRx64rzJ0Ottv/oHKG3I612AOUAw0MdzcVG9wTc8zqTGlfJ0LZ4zOef9+HMpZDrPURxnhJdSSZSP85oYpXJaUmuG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YxWfi23s; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3204C4CEF3;
	Sun,  6 Jul 2025 14:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751812597;
	bh=IOGKTg8m2lLVk2BGnUQp473zWXZ7OF1rNECuXqPIWig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YxWfi23sDAy9X7cXgFuSlqj7s43zWSmUz8rZTQl9H4vYetTG6ItJoNAZnqHXytTrS
	 Hq8oROP4hF0ik2x3lScFmRDpj/wyFeeNuBS5n1Vyz+QTV3dmRYh1FlyPJbAXiHwTvF
	 pFqeraxEhkrY2yRJBSIUEnmw3VANCy+RAnbDKTjCB1bxKbybzxh9A4ED9cS8f+deqs
	 55SAL9cF1KqoNadNJfH1TD9NRTf3xl7bdfv3Oo9flBlz/22Vdg2oHRL+ZPtcnIqAqB
	 S8GLDIjDTCOFStl0yx5oW4DpDRgkHyn/zI793fO4Jh+4rFKVygOqzCgOn+z2XkVq9n
	 bAvjTJuCjkhow==
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
	Mario Limonciello <mario.limonciello@amd.com>,
	Takashi Iwai <tiwai@suse.de>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Bjorn Helgaas <helgaas@kernel.org>
Subject: [PATCH v7 5/9] ALSA: hda: Use pci_is_display()
Date: Sun,  6 Jul 2025 09:36:09 -0500
Message-ID: <20250706143613.1972252-6-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250706143613.1972252-1-superm1@kernel.org>
References: <20250706143613.1972252-1-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

The inline pci_is_display() helper does the same thing.  Use it.

Reviewed-by: Takashi Iwai <tiwai@suse.de>
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
index 439cf1bda6e66..75badb5c69b8e 100644
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


