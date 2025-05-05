Return-Path: <kvm+bounces-45481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 255A5AAAA89
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 03:39:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF20F161932
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 01:39:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 635ED392626;
	Mon,  5 May 2025 23:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lXLfIguv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9CA372650;
	Mon,  5 May 2025 22:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746485912; cv=none; b=Ru5PTFszurPaESDDwNU3JLYF70Nb2DNn8mtpU/ZQ5lxP/kAeVAZ58hkOZ/IE9Xo+c4+IqiAuV32LsTiJbLiwnTnMkgBrjZ1FUioKT/g9aVzcdTD+xBQi/vZ0HlZ0wtu8czjqg5fR0wHdaTHXJXDnSJ0BQ4ng/jz0LMVov4Qc2Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746485912; c=relaxed/simple;
	bh=FVGpzuCNU8lsWl3ZvVKvbpTSb4GfqDllSSTYSn60rsE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m+EF34Ke22ER65xBWF9KL+MUF38w5Yrdkx3fTQLG3jH/3doabxswP3tIevsc0OORmG4C4Uz30FT1HVky7M5dR4UAFGGgiGerncVDNz9ezU0lIqZKeAW1Zbhj7xJoGmtvaNZyJtjAV+rQ3Ti/635AjTG99nhATZEhHVVVTRqZSf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lXLfIguv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B61C4CEE4;
	Mon,  5 May 2025 22:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746485911;
	bh=FVGpzuCNU8lsWl3ZvVKvbpTSb4GfqDllSSTYSn60rsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lXLfIguvHdiLmRs18I3MlZDCptF0LndghHt85Z1s6kOTHKwtNlBOJfDwpU9hLjEyL
	 P25HXI3GRXlAqYlwweazj8kcuXlwwx0AIPxVt/xmR11p0/eWXqB6I8CbEewfm4SlUs
	 AMXY3qZdK/4ByiISaSq2zGFozHvoBYQlkB1Kf14rCe1OIzo7Xg09DYN26onuPPJWwB
	 DvK6k6SJXgfsPpCtBfbag+iz3E40X0HFmXWPjDDfIZ/Whc2InqVPLDy/iYR50tFPcB
	 v1yNPpJxee/BQuysQafQ/RB8YsFcIuf9P66aY1hYVzdV9YWQIC2RIdxInzxjxSa6fl
	 tT54GCLbnuHEw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Yunxiang.Li@amd.com,
	avihaih@nvidia.com,
	zhangdongdong@eswincomputing.com,
	bhelgaas@google.com,
	jgg@ziepe.ca,
	yi.l.liu@intel.com,
	pstanner@redhat.com,
	linux@treblig.org,
	pabeni@redhat.com,
	kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 060/294] vfio/pci: Handle INTx IRQ_NOTCONNECTED
Date: Mon,  5 May 2025 18:52:40 -0400
Message-Id: <20250505225634.2688578-60-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505225634.2688578-1-sashal@kernel.org>
References: <20250505225634.2688578-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.89
Content-Transfer-Encoding: 8bit

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit 860be250fc32de9cb24154bf21b4e36f40925707 ]

Some systems report INTx as not routed by setting pdev->irq to
IRQ_NOTCONNECTED, resulting in a -ENOTCONN error when trying to
setup eventfd signaling.  Include this in the set of conditions
for which the PIN register is virtualized to zero.

Additionally consolidate vfio_pci_get_irq_count() to use this
virtualized value in reporting INTx support via ioctl and sanity
checking ioctl paths since pdev->irq is re-used when the device
is in MSI mode.

The combination of these results in both the config space of the
device and the ioctl interface behaving as if the device does not
support INTx.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20250311230623.1264283-1-alex.williamson@redhat.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_config.c |  3 ++-
 drivers/vfio/pci/vfio_pci_core.c   | 10 +---------
 drivers/vfio/pci/vfio_pci_intrs.c  |  2 +-
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index a2ad4f7c716bf..d9eb8733a324b 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1813,7 +1813,8 @@ int vfio_config_init(struct vfio_pci_core_device *vdev)
 					cpu_to_le16(PCI_COMMAND_MEMORY);
 	}
 
-	if (!IS_ENABLED(CONFIG_VFIO_PCI_INTX) || vdev->nointx)
+	if (!IS_ENABLED(CONFIG_VFIO_PCI_INTX) || vdev->nointx ||
+	    vdev->pdev->irq == IRQ_NOTCONNECTED)
 		vconfig[PCI_INTERRUPT_PIN] = 0;
 
 	ret = vfio_cap_init(vdev);
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index a8f259bc2f4d0..fa168b4342395 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -731,15 +731,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_finish_enable);
 static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_type)
 {
 	if (irq_type == VFIO_PCI_INTX_IRQ_INDEX) {
-		u8 pin;
-
-		if (!IS_ENABLED(CONFIG_VFIO_PCI_INTX) ||
-		    vdev->nointx || vdev->pdev->is_virtfn)
-			return 0;
-
-		pci_read_config_byte(vdev->pdev, PCI_INTERRUPT_PIN, &pin);
-
-		return pin ? 1 : 0;
+		return vdev->vconfig[PCI_INTERRUPT_PIN] ? 1 : 0;
 	} else if (irq_type == VFIO_PCI_MSI_IRQ_INDEX) {
 		u8 pos;
 		u16 flags;
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 620134041b488..c4322faca2bd5 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -269,7 +269,7 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev,
 	if (!is_irq_none(vdev))
 		return -EINVAL;
 
-	if (!pdev->irq)
+	if (!pdev->irq || pdev->irq == IRQ_NOTCONNECTED)
 		return -ENODEV;
 
 	name = kasprintf(GFP_KERNEL_ACCOUNT, "vfio-intx(%s)", pci_name(pdev));
-- 
2.39.5


