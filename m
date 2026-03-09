Return-Path: <kvm+bounces-73281-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cLvGEqutrmkSHwIAu9opvQ
	(envelope-from <kvm+bounces-73281-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 12:23:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C8CEE237DDF
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 12:23:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8AC3D30BDF0A
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 11:17:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA8FC39A80D;
	Mon,  9 Mar 2026 11:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KThGJ7eq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D93399032;
	Mon,  9 Mar 2026 11:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773055053; cv=none; b=UfglHdRhI5zuuWR1e6dFrBIx7q9warDNeQA4eGs9SspKAyGHJAWfNMSPu/heDRWnVDPsdskK8AgMI3+l6bm4t5A71A3YmpOmrVZ3eJWPWrOamMgFXow+XKSIKRhDjEebRxDElLyh30scyxyrhGmgyxTYTHxogQxhV3vMiRq3RW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773055053; c=relaxed/simple;
	bh=F5Zm0UVICZbWezI1fp8Hz+Q6fqxqJVOmYIbu8pPJtcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQVEmCwjDK0oDGwvdoBFLkICu0RgDPyo6CsxZWj52VW3r8wub7IOVrXAHPXs7aagMSFqLa/afRdy47C0cQZoECieNBZjhIOGWK/O7yoq28U2JGR1l/6ubWXA1mrmdS6/ZfCkT9y2tUmehvlDD9pIMtW1Bf2ijsKErILvdqoKLvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KThGJ7eq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41BE2C2BCAF;
	Mon,  9 Mar 2026 11:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773055053;
	bh=F5Zm0UVICZbWezI1fp8Hz+Q6fqxqJVOmYIbu8pPJtcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KThGJ7eqNHRweBH21oVCx0yy4L4ILEJTW5ln+J9ETxSGvIy9XH75fDwkOVPSClCH5
	 jhWBbXPc7RVfHIUk0/bbZDBwvFkhvjx1uKastEbT0iEltR2L2LXglSrIywcvASGZlg
	 dFO1lyklF+SFLv/M07dAfaGHPbOVY9Zv4SEcNdWS0SqJJKgMl8TQRUOyQ78y/qg+vR
	 PgRdsHenEV2o1zUtzlWETntx5eiBi2Aa02r/LIL0J9FIijyAj9L7+arvDhFUqP5EfE
	 GVThSMmy3K3nSY40o9P5c6j84WHrFipPaadPfWqNSpzkFaVfrsOYQuDrXbFwlUNdv3
	 4Cp3Dl+1wceYg==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Bjorn Helgaas <helgaas@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v2 1/3] iommufd/viommu: Allow associating a KVM VM fd with a vIOMMU
Date: Mon,  9 Mar 2026 16:47:02 +0530
Message-ID: <20260309111704.2330479-2-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260309111704.2330479-1-aneesh.kumar@kernel.org>
References: <20260309111704.2330479-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C8CEE237DDF
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73281-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[aneesh.kumar@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-0.978];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,ziepe.ca:email,rivosinc.com:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,arm.com:email,8bytes.org:email]
X-Rspamd-Action: no action

Add optional KVM association to IOMMU_VIOMMU_ALLOC by introducing
IOMMU_VIOMMU_KVM_FD and iommu_viommu_alloc::kvm_vm_fd.

When the flag is set, iommufd validates that kvm_vm_fd refers to a KVM
VM file and stores a referenced struct file in the vIOMMU object, so
later iommufd operations can safely resolve the owning VM.

This is preparatory plumbing for subsequent patches that bind TDI state
to the associated KVM VM.

The patch also switch file_is_kvm from EXPORT_SYMBOL_FOR_KVM_INTERNAL to
EXPORT_SYMBOL_GPL so that iommu module can use that.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Will Deacon <will@kernel.org>
Cc: Bjorn Helgaas <helgaas@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Samuel Ortiz <sameo@rivosinc.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: Steven Price <steven.price@arm.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/iommu/iommufd/viommu.c | 54 +++++++++++++++++++++++++++++++++-
 include/linux/iommufd.h        |  3 ++
 include/uapi/linux/iommufd.h   | 13 +++++++-
 virt/kvm/kvm_main.c            |  2 +-
 4 files changed, 69 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommufd/viommu.c b/drivers/iommu/iommufd/viommu.c
index 4081deda9b33..08f8930c86da 100644
--- a/drivers/iommu/iommufd/viommu.c
+++ b/drivers/iommu/iommufd/viommu.c
@@ -2,6 +2,45 @@
 /* Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
  */
 #include "iommufd_private.h"
+#include <linux/cleanup.h>
+
+#if IS_ENABLED(CONFIG_KVM)
+#include <linux/kvm_host.h>
+
+static int viommu_get_kvm(struct iommufd_viommu *viommu, int kvm_vm_fd)
+{
+	int rc = -EBADF;
+	struct file *filp __free(fput) = fget(kvm_vm_fd);
+
+	if (!file_is_kvm(filp))
+		return rc;
+
+	/* hold the kvm reference via file descriptor */
+	viommu->kvm_filp = no_free_ptr(filp);
+	return 0;
+}
+
+static void viommu_put_kvm(struct iommufd_viommu *viommu)
+{
+	if (!viommu->kvm_filp)
+		return;
+
+	fput(viommu->kvm_filp);
+	viommu->kvm_filp = NULL;
+}
+
+#else
+
+static inline int viommu_get_kvm(struct iommufd_viommu *viommu, int kvm_vm_fd)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void viommu_put_kvm(struct iommufd_viommu *viommu)
+{
+}
+
+#endif
 
 void iommufd_viommu_destroy(struct iommufd_object *obj)
 {
@@ -12,6 +51,8 @@ void iommufd_viommu_destroy(struct iommufd_object *obj)
 		viommu->ops->destroy(viommu);
 	refcount_dec(&viommu->hwpt->common.obj.users);
 	xa_destroy(&viommu->vdevs);
+
+	viommu_put_kvm(viommu);
 }
 
 int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
@@ -29,7 +70,9 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
 	size_t viommu_size;
 	int rc;
 
-	if (cmd->flags || cmd->type == IOMMU_VIOMMU_TYPE_DEFAULT)
+	if (cmd->flags & ~IOMMU_VIOMMU_KVM_FD)
+		return -EOPNOTSUPP;
+	if (cmd->type == IOMMU_VIOMMU_TYPE_DEFAULT)
 		return -EOPNOTSUPP;
 
 	idev = iommufd_get_device(ucmd, cmd->dev_id);
@@ -100,8 +143,17 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
 		goto out_put_hwpt;
 	}
 
+	/* get the kvm details if specified. */
+	if (cmd->flags & IOMMU_VIOMMU_KVM_FD) {
+		rc = viommu_get_kvm(viommu, cmd->kvm_vm_fd);
+		if (rc)
+			goto out_put_hwpt;
+	}
+
 	cmd->out_viommu_id = viommu->obj.id;
 	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
+	if (rc)
+		viommu_put_kvm(viommu);
 
 out_put_hwpt:
 	iommufd_put_object(ucmd->ictx, &hwpt_paging->common.obj);
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 6e7efe83bc5d..7c515d3c52db 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -12,6 +12,7 @@
 #include <linux/refcount.h>
 #include <linux/types.h>
 #include <linux/xarray.h>
+#include <linux/file.h>
 #include <uapi/linux/iommufd.h>
 
 struct device;
@@ -58,6 +59,7 @@ struct iommufd_object {
 	unsigned int id;
 };
 
+struct kvm;
 struct iommufd_device *iommufd_device_bind(struct iommufd_ctx *ictx,
 					   struct device *dev, u32 *id);
 void iommufd_device_unbind(struct iommufd_device *idev);
@@ -101,6 +103,7 @@ struct iommufd_viommu {
 	struct iommufd_ctx *ictx;
 	struct iommu_device *iommu_dev;
 	struct iommufd_hwpt_paging *hwpt;
+	struct file *kvm_filp;
 
 	const struct iommufd_viommu_ops *ops;
 
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 1dafbc552d37..b862c3e57133 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -1071,10 +1071,19 @@ struct iommu_viommu_tegra241_cmdqv {
 	__aligned_u64 out_vintf_mmap_length;
 };
 
+/**
+ * define IOMMU_VIOMMU_KVM_FD - Flag indicating a valid KVM VM file descriptor
+ *
+ * Set this flag when allocating a viommu instance that should be associated
+ * with a specific KVM VM. If this flag is not provided,
+ * @iommu_viommu_alloc::kvm_vm_fd is ignored.
+ */
+#define IOMMU_VIOMMU_KVM_FD	BIT(0)
+
 /**
  * struct iommu_viommu_alloc - ioctl(IOMMU_VIOMMU_ALLOC)
  * @size: sizeof(struct iommu_viommu_alloc)
- * @flags: Must be 0
+ * @flags: Supported flags (IOMMU_VIOMMU_KVM_FD)
  * @type: Type of the virtual IOMMU. Must be defined in enum iommu_viommu_type
  * @dev_id: The device's physical IOMMU will be used to back the virtual IOMMU
  * @hwpt_id: ID of a nesting parent HWPT to associate to
@@ -1082,6 +1091,7 @@ struct iommu_viommu_tegra241_cmdqv {
  * @data_len: Length of the type specific data
  * @__reserved: Must be 0
  * @data_uptr: User pointer to a driver-specific virtual IOMMU data
+ * @kvm_vm_fd: KVM VM file descriptor when IOMMU_VIOMMU_KVM_FD is set
  *
  * Allocate a virtual IOMMU object, representing the underlying physical IOMMU's
  * virtualization support that is a security-isolated slice of the real IOMMU HW
@@ -1105,6 +1115,7 @@ struct iommu_viommu_alloc {
 	__u32 data_len;
 	__u32 __reserved;
 	__aligned_u64 data_uptr;
+	__s32 kvm_vm_fd;
 };
 #define IOMMU_VIOMMU_ALLOC _IO(IOMMUFD_TYPE, IOMMUFD_CMD_VIOMMU_ALLOC)
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1bc1da66b4b0..f076c5a7a290 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5481,7 +5481,7 @@ bool file_is_kvm(struct file *file)
 {
 	return file && file->f_op == &kvm_vm_fops;
 }
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(file_is_kvm);
+EXPORT_SYMBOL_GPL(file_is_kvm);
 
 static int kvm_dev_ioctl_create_vm(unsigned long type)
 {
-- 
2.43.0


