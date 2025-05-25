Return-Path: <kvm+bounces-47669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E55DAC32CD
	for <lists+kvm@lfdr.de>; Sun, 25 May 2025 09:50:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A3F9518980AF
	for <lists+kvm@lfdr.de>; Sun, 25 May 2025 07:50:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BC1D19F11B;
	Sun, 25 May 2025 07:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aijBYeMS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20E7192584
	for <kvm@vger.kernel.org>; Sun, 25 May 2025 07:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748159401; cv=none; b=DWTpHIextHXAqR18Be+Ry8E1RlkB4953VGKICXtJJ50GSOUiHrT/v2d5CALfnppr+q/3ofLlpENlB7fpHGfIiOe1l8RdvYGgpKBOGFzFDmOiWwjSM1+BnPvcDnYAd0hnDuRHUiz8rvM0ZQrlTYhC9qE5r0tiXtZh+fou4LH7gXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748159401; c=relaxed/simple;
	bh=C5jGDTKsaULCeZrAIiLr7gGUOhzWqWQMWV3X65aeYv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMHQtSy99rPouilnkgQrIglKrfChnJZlFxLfi6pH/ASAqI2Es/D5utDWT8nxBLgH1ecDPn5Rv7U9hNW3CS7EY8EH+MNS6+WANy0xe/YypLZh4jEUFsk364YW96yArrJ/cGaWWmOM+08kI0A3kgnEcKZVoeth0ZbGg6u+rphpcNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aijBYeMS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F7DC4CEEA;
	Sun, 25 May 2025 07:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748159401;
	bh=C5jGDTKsaULCeZrAIiLr7gGUOhzWqWQMWV3X65aeYv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aijBYeMS/R/As+IRc8veoP7VMAGhSPDO9ZPhwcwC61VBm423Q2IkgEVNW/uVM2JCz
	 FB376nl1EU6/PN0UEA9kAV4GKL+5pBRVOeGrSnBRVRgXJqhlULkiWU45nd4DcJriux
	 gnicFOTNiHU6oka/9ZH8Pjibw6t3OA7mD2in1nIQ9fAp4EVAkkAj/Q11Oj3GZBPLNq
	 O8CWeRr9hpeiKwDlDL99dQGqvc5JuONLdXI7wF6ptQ27yz1M/qSAkKLCnegLCwQJnl
	 FYDJwRsA+DiUZY1xPjp6V8SS8uFimxHEpjtBAgyc+Nl9wM9vVhXSahUcPia8tYxwot
	 fcujeaCikujDA==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: kvm@vger.kernel.org
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Subject: [RFC PATCH kvmtool 09/10] vfio/iommufd: Add viommu and vdevice objects
Date: Sun, 25 May 2025 13:19:15 +0530
Message-ID: <20250525074917.150332-9-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250525074917.150332-1-aneesh.kumar@kernel.org>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This also allocates a stage1 bypass and stage2 translate table.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 builtin-run.c            |   2 +
 include/kvm/kvm-config.h |   1 +
 vfio/core.c              |   4 +-
 vfio/iommufd.c           | 115 ++++++++++++++++++++++++++++++++++++++-
 4 files changed, 119 insertions(+), 3 deletions(-)

diff --git a/builtin-run.c b/builtin-run.c
index 39198f9bc0d6..bfa3e8b09f82 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -263,6 +263,8 @@ static int loglevel_parser(const struct option *opt, const char *arg, int unset)
 		     "Assign a PCI device to the virtual machine",	\
 		     vfio_device_parser, kvm),				\
 	OPT_BOOLEAN('\0', "iommufd", &(cfg)->iommufd, "Use iommufd interface"),	\
+	OPT_BOOLEAN('\0', "iommufd-vdevice", &(cfg)->iommufd_vdevice,   \
+			"Use iommufd vdevice interface"),			\
 									\
 	OPT_GROUP("Debug options:"),					\
 	OPT_CALLBACK_NOOPT('\0', "debug", kvm, NULL,			\
diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
index 632eaf84b7eb..d80be6826469 100644
--- a/include/kvm/kvm-config.h
+++ b/include/kvm/kvm-config.h
@@ -66,6 +66,7 @@ struct kvm_config {
 	bool mmio_debug;
 	int virtio_transport;
 	bool iommufd;
+	bool iommufd_vdevice;
 };
 
 #endif
diff --git a/vfio/core.c b/vfio/core.c
index 0b1796c54ffd..8dfcf3ca35c1 100644
--- a/vfio/core.c
+++ b/vfio/core.c
@@ -373,7 +373,7 @@ static int vfio__init(struct kvm *kvm)
 	}
 	kvm_vfio_device = device.fd;
 
-	if (kvm->cfg.iommufd)
+	if (kvm->cfg.iommufd || kvm->cfg.iommufd_vdevice)
 		return iommufd__init(kvm);
 	return legacy_vfio__init(kvm);
 }
@@ -395,7 +395,7 @@ static int vfio__exit(struct kvm *kvm)
 
 	free(kvm->cfg.vfio_devices);
 
-	if (kvm->cfg.iommufd)
+	if (kvm->cfg.iommufd || kvm->cfg.iommufd_vdevice)
 		return iommufd__exit(kvm);
 
 	return legacy_vfio__exit(kvm);
diff --git a/vfio/iommufd.c b/vfio/iommufd.c
index 742550705746..39870320e4ac 100644
--- a/vfio/iommufd.c
+++ b/vfio/iommufd.c
@@ -108,6 +108,116 @@ err_out:
 	return ret;
 }
 
+static int iommufd_alloc_s1bypass_hwpt(struct vfio_device *vdev)
+{
+	int ret;
+	unsigned long dev_num;
+	unsigned long guest_bdf;
+	struct vfio_device_bind_iommufd bind;
+	struct vfio_device_attach_iommufd_pt attach_data;
+	struct iommu_hwpt_alloc alloc_hwpt;
+	struct iommu_viommu_alloc alloc_viommu;
+	struct iommu_hwpt_arm_smmuv3 bypass_ste;
+	struct iommu_vdevice_alloc alloc_vdev;
+
+	bind.argsz = sizeof(bind);
+	bind.flags = 0;
+	bind.iommufd = iommu_fd;
+
+	/* now bind the iommufd */
+	if (ioctl(vdev->fd, VFIO_DEVICE_BIND_IOMMUFD, &bind)) {
+		ret = -errno;
+		vfio_dev_err(vdev, "failed to get info");
+		goto err_out;
+	}
+
+	alloc_hwpt.size = sizeof(struct iommu_hwpt_alloc);
+	alloc_hwpt.flags = IOMMU_HWPT_ALLOC_NEST_PARENT;
+	alloc_hwpt.dev_id = bind.out_devid;
+	alloc_hwpt.pt_id = ioas_id;
+	alloc_hwpt.data_type = IOMMU_HWPT_DATA_NONE;
+	alloc_hwpt.data_len = 0;
+	alloc_hwpt.data_uptr = 0;
+
+	if (ioctl(iommu_fd, IOMMU_HWPT_ALLOC, &alloc_hwpt)) {
+		ret = -errno;
+		pr_err("Failed to allocate HWPT");
+		goto err_out;
+	}
+
+	attach_data.argsz = sizeof(attach_data);
+	attach_data.flags = 0;
+	attach_data.pt_id = alloc_hwpt.out_hwpt_id;
+
+	if (ioctl(vdev->fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &attach_data)) {
+		ret = -errno;
+		vfio_dev_err(vdev, "failed to attach to IOAS ");
+		goto err_out;
+	}
+
+	alloc_viommu.size = sizeof(alloc_viommu);
+	alloc_viommu.flags = 0;
+	alloc_viommu.type = IOMMU_VIOMMU_TYPE_ARM_SMMUV3;
+	alloc_viommu.dev_id = bind.out_devid;
+	alloc_viommu.hwpt_id = alloc_hwpt.out_hwpt_id;
+
+	if (ioctl(iommu_fd, IOMMU_VIOMMU_ALLOC, &alloc_viommu)) {
+		ret = -errno;
+		vfio_dev_err(vdev, "failed to allocate VIOMMU %d", ret);
+		goto err_out;
+	}
+#define STRTAB_STE_0_V			(1UL << 0)
+#define STRTAB_STE_0_CFG_S2_TRANS	6
+#define STRTAB_STE_0_CFG_S1_TRANS	5
+#define STRTAB_STE_0_CFG_BYPASS		4
+
+	/* set up virtual ste as bypass ste */
+	bypass_ste.ste[0] = STRTAB_STE_0_V | (STRTAB_STE_0_CFG_BYPASS << 1);
+	bypass_ste.ste[1] = 0x0UL;
+
+	alloc_hwpt.size = sizeof(struct iommu_hwpt_alloc);
+	alloc_hwpt.flags = 0;
+	alloc_hwpt.dev_id = bind.out_devid;
+	alloc_hwpt.pt_id = alloc_viommu.out_viommu_id;
+	alloc_hwpt.data_type = IOMMU_HWPT_DATA_ARM_SMMUV3;
+	alloc_hwpt.data_len = sizeof(bypass_ste);
+	alloc_hwpt.data_uptr = (unsigned long)&bypass_ste;
+
+	if (ioctl(iommu_fd, IOMMU_HWPT_ALLOC, &alloc_hwpt)) {
+		ret = -errno;
+		pr_err("Failed to allocate S1 bypass HWPT %d", ret);
+		goto err_out;
+	}
+
+	alloc_vdev.size = sizeof(alloc_vdev),
+	alloc_vdev.viommu_id = alloc_viommu.out_viommu_id;
+	alloc_vdev.dev_id = bind.out_devid;
+
+	dev_num = vdev->dev_hdr.dev_num;
+	/* kvmtool only do 0 domain, 0 bus and 0 function devices. */
+	guest_bdf = (0ULL << 32) | (0 << 16) | dev_num << 11 | (0 << 8);
+	alloc_vdev.virt_id = guest_bdf;
+	if (ioctl(iommu_fd, IOMMU_VDEVICE_ALLOC, &alloc_vdev)) {
+		ret = -errno;
+		pr_err("Failed to allocate vdevice %d", ret);
+		goto err_out;
+	}
+
+	/* Now attach to the nested domain */
+	attach_data.argsz = sizeof(attach_data);
+	attach_data.flags = 0;
+	attach_data.pt_id = alloc_hwpt.out_hwpt_id;
+	if (ioctl(vdev->fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &attach_data)) {
+		ret = -errno;
+		vfio_dev_err(vdev, "failed to attach Nested config to IOAS %d ", ret);
+		goto err_out;
+	}
+
+	return 0;
+err_out:
+	return ret;
+}
+
 static int iommufd_configure_device(struct kvm *kvm, struct vfio_device *vdev)
 {
 	int ret;
@@ -160,7 +270,10 @@ static int iommufd_configure_device(struct kvm *kvm, struct vfio_device *vdev)
 		goto err_close_device;
 	}
 
-	ret = iommufd_alloc_s2bypass_hwpt(vdev);
+	if (kvm->cfg.iommufd_vdevice)
+		ret = iommufd_alloc_s1bypass_hwpt(vdev);
+	else
+		ret = iommufd_alloc_s2bypass_hwpt(vdev);
 	if (ret)
 		goto err_close_device;
 
-- 
2.43.0


