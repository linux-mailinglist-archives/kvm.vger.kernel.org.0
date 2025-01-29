Return-Path: <kvm+bounces-36852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 29C4BA21EA8
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 15:10:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E06BE165BE0
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 14:08:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F2C71E9B25;
	Wed, 29 Jan 2025 14:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B7XB23jb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A181E991B;
	Wed, 29 Jan 2025 14:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738159411; cv=none; b=IKSd6Y5v7siBxSTgD8oNs7VDJ1DzmR6rd40p7Fw99b4TLhX0GZH56J4jXayFxNQ9jadNGYq1bTsfpQZSCD8sqpG0uwv5SqFoHNeoejlivJ7WC8OGPCrpXGtSoKAyLxFZW3Ud4YbZBXdxGzQz9QTpApgPDh7+pzo5FipVIZb9c+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738159411; c=relaxed/simple;
	bh=3qnb2y7OEMwqibPFxzj2aNuoKrOGbeCc9z1iL1/UVww=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I4CTpmNcdQ9IHu4HN2QDtwST9he8KfO+dCOrCeUCxwZD7kxMNNAxFV6wBj52qUf1NX5v+BmvCnq+rMZXVU5GpFrrHDJVQM5ktc1yyE4smCuKqhVUUZBEl0EJIKKfkwfQmWAlLGhbL8ZPCL6XOHBg+s955RXlykTI9yan9G3ALBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B7XB23jb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C15EC4CED1;
	Wed, 29 Jan 2025 14:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738159411;
	bh=3qnb2y7OEMwqibPFxzj2aNuoKrOGbeCc9z1iL1/UVww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B7XB23jbWBTs0Evg3JgZ104gK9pbmTKzKZtIYbuo9n5kOqLRLKnhDfDTdexKzswvL
	 jWsf6mY9e/LGf2Swb2PaYIfqdYvzrli/u4UcuMw6vr+J0c6oy5yQPiVr71dSRC76Y2
	 RBYibQ7x9jnorlos+UOz0e13FU/jfI3HQ7VdJ4pNtBfy8/3GZWwb8PZE96x6Pr/LRg
	 nzebF3oMigq3sM+M3d1UArnWNzJ5fosRPRQOLH024K+0QMHnQEGDhTisaCInnzgrYz
	 NCgnDJyfyHAirM+TmzX3CpWGVrBFM6UR+ENDTD9TTTbsvqfsb+eF8XX00q+KgRROiH
	 vzJPKaAPlp4mw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Ankit Agrawal <ankita@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 7/8] vfio/nvgrace-gpu: Read dvsec register to determine need for uncached resmem
Date: Wed, 29 Jan 2025 07:59:27 -0500
Message-Id: <20250129125930.1273051-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250129125930.1273051-1-sashal@kernel.org>
References: <20250129125930.1273051-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.11
Content-Transfer-Encoding: 8bit

From: Ankit Agrawal <ankita@nvidia.com>

[ Upstream commit bd53764a60ad586ad5b6ed339423ad5e67824464 ]

NVIDIA's recently introduced Grace Blackwell (GB) Superchip is a
continuation with the Grace Hopper (GH) superchip that provides a
cache coherent access to CPU and GPU to each other's memory with
an internal proprietary chip-to-chip cache coherent interconnect.

There is a HW defect on GH systems to support the Multi-Instance
GPU (MIG) feature [1] that necessiated the presence of a 1G region
with uncached mapping carved out from the device memory. The 1G
region is shown as a fake BAR (comprising region 2 and 3) to
workaround the issue. This is fixed on the GB systems.

The presence of the fix for the HW defect is communicated by the
device firmware through the DVSEC PCI config register with ID 3.
The module reads this to take a different codepath on GB vs GH.

Scan through the DVSEC registers to identify the correct one and use
it to determine the presence of the fix. Save the value in the device's
nvgrace_gpu_pci_core_device structure.

Link: https://www.nvidia.com/en-in/technologies/multi-instance-gpu/ [1]

CC: Jason Gunthorpe <jgg@nvidia.com>
CC: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
Link: https://lore.kernel.org/r/20250124183102.3976-2-ankita@nvidia.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index a7fd018aa5483..178ee4180d5c4 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -23,6 +23,11 @@
 /* A hardwired and constant ABI value between the GPU FW and VFIO driver. */
 #define MEMBLK_SIZE SZ_512M
 
+#define DVSEC_BITMAP_OFFSET 0xA
+#define MIG_SUPPORTED_WITH_CACHED_RESMEM BIT(0)
+
+#define GPU_CAP_DVSEC_REGISTER 3
+
 /*
  * The state of the two device memory region - resmem and usemem - is
  * saved as struct mem_region.
@@ -46,6 +51,7 @@ struct nvgrace_gpu_pci_core_device {
 	struct mem_region resmem;
 	/* Lock to control device memory kernel mapping */
 	struct mutex remap_lock;
+	bool has_mig_hw_bug;
 };
 
 static void nvgrace_gpu_init_fake_bar_emu_regs(struct vfio_device *core_vdev)
@@ -812,6 +818,26 @@ nvgrace_gpu_init_nvdev_struct(struct pci_dev *pdev,
 	return ret;
 }
 
+static bool nvgrace_gpu_has_mig_hw_bug(struct pci_dev *pdev)
+{
+	int pcie_dvsec;
+	u16 dvsec_ctrl16;
+
+	pcie_dvsec = pci_find_dvsec_capability(pdev, PCI_VENDOR_ID_NVIDIA,
+					       GPU_CAP_DVSEC_REGISTER);
+
+	if (pcie_dvsec) {
+		pci_read_config_word(pdev,
+				     pcie_dvsec + DVSEC_BITMAP_OFFSET,
+				     &dvsec_ctrl16);
+
+		if (dvsec_ctrl16 & MIG_SUPPORTED_WITH_CACHED_RESMEM)
+			return false;
+	}
+
+	return true;
+}
+
 static int nvgrace_gpu_probe(struct pci_dev *pdev,
 			     const struct pci_device_id *id)
 {
@@ -832,6 +858,8 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
 	dev_set_drvdata(&pdev->dev, &nvdev->core_device);
 
 	if (ops == &nvgrace_gpu_pci_ops) {
+		nvdev->has_mig_hw_bug = nvgrace_gpu_has_mig_hw_bug(pdev);
+
 		/*
 		 * Device memory properties are identified in the host ACPI
 		 * table. Set the nvgrace_gpu_pci_core_device structure.
-- 
2.39.5


