Return-Path: <kvm+bounces-45527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 19318AAB3EE
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 06:55:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32E9116E89A
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 04:52:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EBA834050A;
	Tue,  6 May 2025 00:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YF8iyEOq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60393991DB;
	Mon,  5 May 2025 23:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746486477; cv=none; b=UoRijZQ5ryh+HJ5sfVz+kpypsLYWu3T7WAY2qzpoB0oLyo/kqPltfF7cIf9VgvVBEIaBMjG5g9rHxHm2VHxHzQpw5JvkvP+3VHaQQ3QKZXutJj3fnSEKwI9IJcaKQw7PYLNLSp2OCXoBISb8E1LvzVu234UNKJUeZdK55sqItvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746486477; c=relaxed/simple;
	bh=AiT5k0s5mXpAD3zPqGOswp5BQWHKAGYaSBP6/TbyIVE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tGeH7fPRVajIEuN8UQ73TP/jELfLf6VwNXrHUda/PE6DkLwAvZlnVxdKQk4kWYnLvcSa4Su9hsiVnElTptTKnflobfI8SZvEJlO1bNTMNPjVjSkOrKB8k+iHxwj7YHNJzc3BoQp6BhW09x/blcWHFa7/o61+cqyHG1QRwI89F74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YF8iyEOq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27397C4CEE4;
	Mon,  5 May 2025 23:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746486476;
	bh=AiT5k0s5mXpAD3zPqGOswp5BQWHKAGYaSBP6/TbyIVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YF8iyEOqlhkyWrEwtrpfTdAw3ZRQit84Eg8U0NhBW1InQp8GV7IXZ6gqARihwfj0P
	 h2xcKlc4CicxkzXB8xiRgms0OnlNM8cEb0R0YaoehjYqpBkGpsPI2q+4btZiEfMrHl
	 cyNtEuktRbE0nBs+LnTl1SsLGYfUxwZQXp7aOec7+og3KQH+u9FcZcbNSuYSxA3CCH
	 1w4+wqJSANTDNdngdF7V8vuhkLxB7WNOx9bvu6BMNaiFmCVXz61vM7uqz7hWXnYwQy
	 vWqz/5CKsAsun0GkxQxT5PuLGHGwjoBXcvGcw1uqcctq6ywnwduEqldfHSvNm+lGDy
	 JiH6G6qb425RA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Yunxiang.Li@amd.com,
	avihaih@nvidia.com,
	yi.l.liu@intel.com,
	zhangdongdong@eswincomputing.com,
	jgg@ziepe.ca,
	bhelgaas@google.com,
	peterx@redhat.com,
	pstanner@redhat.com,
	dan.carpenter@linaro.org,
	pabeni@redhat.com,
	kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 049/212] vfio/pci: Handle INTx IRQ_NOTCONNECTED
Date: Mon,  5 May 2025 19:03:41 -0400
Message-Id: <20250505230624.2692522-49-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505230624.2692522-1-sashal@kernel.org>
References: <20250505230624.2692522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.136
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
index 7902e1ec0fef2..105243d83b2dc 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1806,7 +1806,8 @@ int vfio_config_init(struct vfio_pci_core_device *vdev)
 					cpu_to_le16(PCI_COMMAND_MEMORY);
 	}
 
-	if (!IS_ENABLED(CONFIG_VFIO_PCI_INTX) || vdev->nointx)
+	if (!IS_ENABLED(CONFIG_VFIO_PCI_INTX) || vdev->nointx ||
+	    vdev->pdev->irq == IRQ_NOTCONNECTED)
 		vconfig[PCI_INTERRUPT_PIN] = 0;
 
 	ret = vfio_cap_init(vdev);
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index f357fd157e1ed..aa362b434413a 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -719,15 +719,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_finish_enable);
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
index 5cbcde32ff79e..64d78944efa53 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -207,7 +207,7 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev,
 	if (!is_irq_none(vdev))
 		return -EINVAL;
 
-	if (!pdev->irq)
+	if (!pdev->irq || pdev->irq == IRQ_NOTCONNECTED)
 		return -ENODEV;
 
 	name = kasprintf(GFP_KERNEL_ACCOUNT, "vfio-intx(%s)", pci_name(pdev));
-- 
2.39.5


