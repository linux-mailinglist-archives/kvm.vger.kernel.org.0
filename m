Return-Path: <kvm+bounces-45479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 324F0AAA977
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 03:14:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42C4C3AF17B
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 01:09:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ADB535EB99;
	Mon,  5 May 2025 22:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oiZQfDFc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFEE6359DEB;
	Mon,  5 May 2025 22:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746484966; cv=none; b=eu1SM4Br7JH3fjXxXpuI92yG/OjCmMT+5IyDCTzk++EH6983P2j+S1O3M7WN/FYFQ4ayAhMt624VMyZT1BUW26E1uGTKis8K/CUWQJoxj8DNDboJuU7q3t7OaBY68KnqL1qj65Fu1pozk7iwc1Tbg3vgrCy/WWDk3Qbp0hnjzR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746484966; c=relaxed/simple;
	bh=8Px92X0rep1rzpGJQXsFfMufCoV9W339JOUAHmkNmIc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q6Mk/XFT8CoNnNYtKxJ4bNDnBlZ5JAa5VgKFlI/mX+B5qD99Y86yJfuqp+jn51raSk+F/F1wkVfEa5aevUWE1lUUbI3OmzfbtOgYU9E/MoJ9YUF2jkBGBVXKZ4UQiqN8ku9MRiCTNGcaVQDvwA3yb4247X7hds/p44LucT99udc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oiZQfDFc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6AA0C4CEE4;
	Mon,  5 May 2025 22:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746484965;
	bh=8Px92X0rep1rzpGJQXsFfMufCoV9W339JOUAHmkNmIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oiZQfDFcqbrOYot0U94ElZ/JfUnoAsv5p2RFOG4oU7S0bE3prRYpfsGCurxGvG7Vs
	 1uOI8BMdAhHCsRmr8geko9JHIE1vgiQkiutAdDFT9JkG6/zqdrJN4nlKGqOD0PG0bg
	 S+ZJJ/+ViOF21D+G//3/IOF6LhSMTCkc2ouKVw9E+jfpbsiJqvYbOG531nkbrKnQmx
	 3SuMtA1m8kRNv9QKOczNfLTqbopeWyoviyzHR/8QBk/vx26vw1pJZKVTOuhknioIlM
	 uFNk73oiNBtzg6F0X3bM2vQmyFBW5QSp9rG1VgFk2ypsUXLLwB5mqEYs5a8VTi4lgZ
	 v/DTNXBBtt77w==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Yunxiang.Li@amd.com,
	bhelgaas@google.com,
	zhangdongdong@eswincomputing.com,
	avihaih@nvidia.com,
	jgg@ziepe.ca,
	pstanner@redhat.com,
	schnelle@linux.ibm.com,
	yi.l.liu@intel.com,
	pabeni@redhat.com,
	kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 098/486] vfio/pci: Handle INTx IRQ_NOTCONNECTED
Date: Mon,  5 May 2025 18:32:54 -0400
Message-Id: <20250505223922.2682012-98-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505223922.2682012-1-sashal@kernel.org>
References: <20250505223922.2682012-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.26
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
index ea2745c1ac5e6..8ea38e7421df4 100644
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
index 1a4ed5a357d36..40725e3349b0d 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -727,15 +727,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_finish_enable);
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
index 8382c58343356..565966351dfad 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -259,7 +259,7 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev,
 	if (!is_irq_none(vdev))
 		return -EINVAL;
 
-	if (!pdev->irq)
+	if (!pdev->irq || pdev->irq == IRQ_NOTCONNECTED)
 		return -ENODEV;
 
 	name = kasprintf(GFP_KERNEL_ACCOUNT, "vfio-intx(%s)", pci_name(pdev));
-- 
2.39.5


