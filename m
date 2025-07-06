Return-Path: <kvm+bounces-51626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EED82AFA5EB
	for <lists+kvm@lfdr.de>; Sun,  6 Jul 2025 16:40:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 541AA16F176
	for <lists+kvm@lfdr.de>; Sun,  6 Jul 2025 14:40:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03A5428A724;
	Sun,  6 Jul 2025 14:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rb39vlJC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDA628A3FC;
	Sun,  6 Jul 2025 14:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751812600; cv=none; b=NOJSO0CkoW1F/wBdStEveqGAoTClMvTCvnBNoRj1WLncSAay42t0jR7O0h56yG+NiDNaNgFqCdUOtnVwK/RQ0nAKVQDfWiOAHcK7Abzn6mUMwS7/TY0XG+TDPhxQ4o8ypy0EJoPdBZF+J/xJp6A2wq7wRNuht8aLsD4RuiKG2Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751812600; c=relaxed/simple;
	bh=glRBi2ARDp3d+Stsv79iYRajcXAB16Ljdcta010d3iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+bzwQmCiNh40dpbIyNNoWvYwhIMthpcxfloSwKHl1iVczQmohj2Xeu8dK3jqznMxllB0Sc4ZrTZr14sDQYGZtFYweUmXfd+l8OMPYsgvru6HM7urJW95JI4Cpz73+qa+Q2nBnooqsDSaAhBpFRM7g2TdDSPB1oByWrPdBB5ACM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rb39vlJC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A09C4CEED;
	Sun,  6 Jul 2025 14:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751812599;
	bh=glRBi2ARDp3d+Stsv79iYRajcXAB16Ljdcta010d3iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rb39vlJCKeQwVdPoO/bdw5hvXKkd3cqPAyVwOMlpGBCHBuAbkPjUuOFF+Skkg3SHw
	 Qi/4h8679eEnUCSbDGbPx5CFn6ScV+cHOdhFEdR+mGgndyfLMrRkOKalzZ0lv6D83g
	 fHa6CLIWd0av4S4LyFmJUFDTz+kfEQuDYQLK4pPOphpNNsYQgj2L0xNSv6oXxuNCJ6
	 EkYNmBpK8wuvMc7GfoyeZ8iX8bRMjusJk2gCyhsON+kFJ0rQmPVMVgvw0oXhBIVKR7
	 xvGoboZXv3412PwIrJB/CVcAcuoDOTPljmwRv/EZDLpGR3KvDmgvVSO0/SwQR2oq87
	 0C44YUNKj4r8A==
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
	kernel test robot <lkp@intel.com>
Subject: [PATCH v7 6/9] Fix access to video_is_primary_device() when compiled without CONFIG_VIDEO
Date: Sun,  6 Jul 2025 09:36:10 -0500
Message-ID: <20250706143613.1972252-7-superm1@kernel.org>
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

When compiled without CONFIG_VIDEO the architecture specific
implementations of video_is_primary_device() include prototypes and
assume that video-common.c will be linked. Guard against this so that the
fallback inline implementation that returns false will be used when
compiled without CONFIG_VIDEO.

Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506221312.49Fy1aNA-lkp@intel.com/
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
v5:
 * add tag
v4:
 * new patch
---
 arch/parisc/include/asm/video.h | 2 +-
 arch/sparc/include/asm/video.h  | 2 ++
 arch/x86/include/asm/video.h    | 2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/parisc/include/asm/video.h b/arch/parisc/include/asm/video.h
index c5dff3223194a..a9d50ebd6e769 100644
--- a/arch/parisc/include/asm/video.h
+++ b/arch/parisc/include/asm/video.h
@@ -6,7 +6,7 @@
 
 struct device;
 
-#if defined(CONFIG_STI_CORE)
+#if defined(CONFIG_STI_CORE) && defined(CONFIG_VIDEO)
 bool video_is_primary_device(struct device *dev);
 #define video_is_primary_device video_is_primary_device
 #endif
diff --git a/arch/sparc/include/asm/video.h b/arch/sparc/include/asm/video.h
index a6f48f52db584..773717b6d4914 100644
--- a/arch/sparc/include/asm/video.h
+++ b/arch/sparc/include/asm/video.h
@@ -19,8 +19,10 @@ static inline pgprot_t pgprot_framebuffer(pgprot_t prot,
 #define pgprot_framebuffer pgprot_framebuffer
 #endif
 
+#ifdef CONFIG_VIDEO
 bool video_is_primary_device(struct device *dev);
 #define video_is_primary_device video_is_primary_device
+#endif
 
 static inline void fb_memcpy_fromio(void *to, const volatile void __iomem *from, size_t n)
 {
diff --git a/arch/x86/include/asm/video.h b/arch/x86/include/asm/video.h
index 0950c9535fae9..08ec328203ef8 100644
--- a/arch/x86/include/asm/video.h
+++ b/arch/x86/include/asm/video.h
@@ -13,8 +13,10 @@ pgprot_t pgprot_framebuffer(pgprot_t prot,
 			    unsigned long offset);
 #define pgprot_framebuffer pgprot_framebuffer
 
+#ifdef CONFIG_VIDEO
 bool video_is_primary_device(struct device *dev);
 #define video_is_primary_device video_is_primary_device
+#endif
 
 #include <asm-generic/video.h>
 
-- 
2.43.0


