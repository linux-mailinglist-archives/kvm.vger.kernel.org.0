Return-Path: <kvm+bounces-49748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 56C5DADDB16
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 20:00:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0D9E4046BD
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 18:00:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45BBE2777F3;
	Tue, 17 Jun 2025 17:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rl9eUy7n"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563002797AB;
	Tue, 17 Jun 2025 17:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750183168; cv=none; b=O27xdMB/OJo4nh7aS7uip3U/4xQ6xiEmH/51gv4AmWvXXnDhVfzdv4xspIz7as/ZcTjlrtjzWCHGaIqaESYwor+9D4cliXbiLUL5vzNKhDkjoJ8AEFP6BdX2hkAf2d9Z/A5yMcCl+Khz+YG2ee3XtPxCX/gW9/+EWH8lgAJBJCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750183168; c=relaxed/simple;
	bh=77/gxLtAPvAxa1AK1aJlDnuTAAm2yyps4mDMdQg/RYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WeceGsZQKQAKCHUihSCkPkqkiS8FU8rw9WnNx+8zNeytORTiwZereztJt/oTf/d/6TyWmRQyA84jftzyqGOo3B8618S3EbXaN899pEVAqCE59F+a62VtvKU2deo6AtHGwjvQK8MgBAk+exhQUGHv9dgmbEGylqROa+sqTHJCpXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rl9eUy7n; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0AA1C4CEF1;
	Tue, 17 Jun 2025 17:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750183168;
	bh=77/gxLtAPvAxa1AK1aJlDnuTAAm2yyps4mDMdQg/RYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rl9eUy7nE0GLjzybBSBdoGe0tK6HHsbNwXjhbhSHdMi83sHIyJPrwQWCzIo4lXatr
	 qcM7Wl9KAeFOVLCmjIOJq1LJQeyZm0DX3jx3kNGnU4PJtlM8BRvIp/qOpSd/naPSj/
	 2z7XGSsGn0kTMcnJarNi6QMNJsMwvPvtwiUuGPjrwL4az4IybB1mTivJNfoA0W5XV0
	 FBpszsr7WNq/gfUM3VUdkPKbYCV8ojZ7X5K9XctDkTZdqaJR+D8xhXlsh9PlIbYjIO
	 OW+TVbOeWPXGM+g3cE8BxXmlpUqa2o1A9ZLRX6ZnbipjdAvxtYM0wir9mH7O8LNDEJ
	 fl4ko+kSitVhQ==
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
	Bjorn Helgaas <helgaas@kernel.org>
Subject: [PATCH v2 4/6] iommu/vt-d: Use pci_is_display()
Date: Tue, 17 Jun 2025 12:59:08 -0500
Message-ID: <20250617175910.1640546-5-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250617175910.1640546-1-superm1@kernel.org>
References: <20250617175910.1640546-1-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

The inline pci_is_display() helper does the same thing.  Use it.

Suggested-by: Bjorn Helgaas <helgaas@kernel.org>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/iommu/intel/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 7aa3932251b2f..17267cd476ce7 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -34,7 +34,7 @@
 #define ROOT_SIZE		VTD_PAGE_SIZE
 #define CONTEXT_SIZE		VTD_PAGE_SIZE
 
-#define IS_GFX_DEVICE(pdev) ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY)
+#define IS_GFX_DEVICE(pdev) pci_is_display(pdev)
 #define IS_USB_DEVICE(pdev) ((pdev->class >> 8) == PCI_CLASS_SERIAL_USB)
 #define IS_ISA_DEVICE(pdev) ((pdev->class >> 8) == PCI_CLASS_BRIDGE_ISA)
 #define IS_AZALIA(pdev) ((pdev)->vendor == 0x8086 && (pdev)->device == 0x3a3e)
-- 
2.43.0


