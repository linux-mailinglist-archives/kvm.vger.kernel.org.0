Return-Path: <kvm+bounces-45475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A588AAAA15D
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 00:46:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65E941A847D4
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 22:46:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A426B29DB6D;
	Mon,  5 May 2025 22:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LfxLZ1P1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52D327E7E9;
	Mon,  5 May 2025 22:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746483580; cv=none; b=HbqEIakruMF/IJ0y87zdN0O6NiOATSTG4hiBWciKcjo0k6kMLIXwOwQCy0HNS2dlZnzojTYrNwxRXjOTtZMbsb7KChZOEzCi1Usl6UUjJbPFIw+ME9MDoB9bf5Cw62mjQAb0NHvuuW8kN8+gMkgL0yaiyjOl8w0UOXjISefnUZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746483580; c=relaxed/simple;
	bh=9isxBk9UMsNxND/RKHbE4Koc82Y8C2/3YId+EYsuRe8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o5C86djZeRSIVwJrA9ZQ1xjrjWi+y6c7QSCxa7NfbSh/JDIT8mUl9917sK7720Fvz2FIEj6BzWQaaKR8Wji5rHMzH5HT1GjSvCa7GyG8IiQUXBU29vLR2RpTSvdMqSixXVWRJg4BjFLgUMOHd5BS7+8E3NpuC1D/Sk4yM1r1iB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LfxLZ1P1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27305C4CEE4;
	Mon,  5 May 2025 22:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746483580;
	bh=9isxBk9UMsNxND/RKHbE4Koc82Y8C2/3YId+EYsuRe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LfxLZ1P1Cahn37KG3Bh5hekd5/mgkCe/YvR049FiZrbtY+2VCudCPFaZoQN6qwJcg
	 czJRyAEmpwJqapL+ThgP+CUUFhob9oMoe+DIOUUFew6tjkrqrxWjl6sbJ1tlQiW9HO
	 RR7zsu1MUNpf7btgAAi4MEfwnk8jhlwE1IgMoWBwcPSw7ag8MD/5JBTa/gAgdUuK8w
	 r5DXYE1JCDcEC2E1mHavXrZPDQC1WzJUZ68YUcgDlBH/vYpvgSQr7psffvqOa9r+bY
	 6YL4o/hCltt0TqtAuO3p1b5XF//gYs6OqFmOXSbkorPEYUtBM+lXpIA7Prla0mEs+b
	 ZIkweJsO5sv4w==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Yunxiang.Li@amd.com,
	zhangdongdong@eswincomputing.com,
	bhelgaas@google.com,
	avihaih@nvidia.com,
	jgg@ziepe.ca,
	pstanner@redhat.com,
	linux@treblig.org,
	dan.carpenter@linaro.org,
	pabeni@redhat.com,
	kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 124/642] vfio/pci: Handle INTx IRQ_NOTCONNECTED
Date: Mon,  5 May 2025 18:05:40 -0400
Message-Id: <20250505221419.2672473-124-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505221419.2672473-1-sashal@kernel.org>
References: <20250505221419.2672473-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
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
index 94142581c98ce..14437396d7211 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1814,7 +1814,8 @@ int vfio_config_init(struct vfio_pci_core_device *vdev)
 					cpu_to_le16(PCI_COMMAND_MEMORY);
 	}
 
-	if (!IS_ENABLED(CONFIG_VFIO_PCI_INTX) || vdev->nointx)
+	if (!IS_ENABLED(CONFIG_VFIO_PCI_INTX) || vdev->nointx ||
+	    vdev->pdev->irq == IRQ_NOTCONNECTED)
 		vconfig[PCI_INTERRUPT_PIN] = 0;
 
 	ret = vfio_cap_init(vdev);
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 586e49efb81be..c857630f447b3 100644
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


