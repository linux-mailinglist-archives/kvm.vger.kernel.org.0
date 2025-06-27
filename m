Return-Path: <kvm+bounces-50941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F2EBDAEADED
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 06:33:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D8E51C2229A
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 04:33:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7977620297C;
	Fri, 27 Jun 2025 04:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pz52yDph"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0AD1FF1C7;
	Fri, 27 Jun 2025 04:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750998688; cv=none; b=pU9Tble5545YZk1OHXCeDW9vH9Qua/FuXW9+xrXfGnjqyqCDa6u/HfS+LbqXnAsQp+Gh+gkG475JbkvLtoPGK8E4qgxMojtFoEZlzkC9X2czIHwI20uys9l9PE//CXQrSEuTu0aB6abde+83Ue4a6Gqff9YmDXjMRvKMSfU7CVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750998688; c=relaxed/simple;
	bh=IOGKTg8m2lLVk2BGnUQp473zWXZ7OF1rNECuXqPIWig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PAmUfqD7WnJVtraF9xaQ3/VAW+VyesM3YIiA2l7MRKFgDip4yUlXX8hY4eFfTMJHMRIocHto5F3kvLFpGnSvpZ/mkWUnJQQ7WyI66A2ymdqQwsmoOo8iWuSRragozxV2FjROWHDVeJ4MfX6zNdY9JK/5lpmtLSEgZdKSCBNFTzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pz52yDph; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2661C4CEF1;
	Fri, 27 Jun 2025 04:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750998688;
	bh=IOGKTg8m2lLVk2BGnUQp473zWXZ7OF1rNECuXqPIWig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pz52yDph4lvxRO78/df2VuOpp1fNDNoWqYOUxhyJnuo9OirhP0CkrWu10l3S5rVyu
	 XuFAqxFzKqMboIlA4BR+Pbv0vs/oJMEcDBqGA405UxJWnAtQW4SRY+wTRUicKNWlFK
	 dyHMX5cDSal5TcPwzheVlN8FkGBWcBiJcFba5wlR+KmSLfi8ij/MH7wQo3RYbTFDWe
	 xhIz3YnCPfcGTq9RBHOnX9KzVEbJxPsktL5NDRqLAE7c/UW301XfcSVTwAUKHjx4Sd
	 bQ61w7HQyq3fVIG3TPV7S3qQOl086ZQ8dnRnjiDgHQMHsEfugU0pyVjbZBUSN+jlFu
	 /OEA7R1YbmVaQ==
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
	Takashi Iwai <tiwai@suse.de>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Bjorn Helgaas <helgaas@kernel.org>
Subject: [PATCH v6 5/9] ALSA: hda: Use pci_is_display()
Date: Thu, 26 Jun 2025 23:31:04 -0500
Message-ID: <20250627043108.3141206-6-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250627043108.3141206-1-superm1@kernel.org>
References: <20250627043108.3141206-1-superm1@kernel.org>
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


