Return-Path: <kvm+bounces-73282-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +HIQJYSsrmnMHgIAu9opvQ
	(envelope-from <kvm+bounces-73282-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 12:18:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C057237C1F
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 12:18:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1A4DB300E694
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 11:18:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EC3339A803;
	Mon,  9 Mar 2026 11:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eZm8CLQM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C15D3A1D1F;
	Mon,  9 Mar 2026 11:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773055059; cv=none; b=ue9GbiDgHYhUCQ6DEZ9POQvWBhCDmRTtKppSNBeo+VX5c9jRJpEmGF0qvREFe3PsRsO2JI3v5OOcqBLyovZrgabJeF2pMRclJ3GISUdfjmQAJiwAmA6W+6AqlxCb3/IPo/kBf/EQEoaud9GZ0f9ntb1jTWWLVvyhxMyLC2FP6LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773055059; c=relaxed/simple;
	bh=FXOwjOtb0lik0JoRc6nz9TJV7sakxmBgRJTv/CV2Al0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e48NP+K4LEYbhAnksbA5PJgyfA7m/IgriSdb/Tsq2NNG4XA+yYETklsTqo0NdwOTHBSTE9/W4pc+ESLzO+BxW7gDhcm3b7tyXKumxYPIHIlTJcYgHl8XmTupX05oLP5pd/GiwfjPVEvhRScb7rAEzMsqigbFGOJqYsRL1nuiSf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eZm8CLQM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40F4C4CEF7;
	Mon,  9 Mar 2026 11:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773055058;
	bh=FXOwjOtb0lik0JoRc6nz9TJV7sakxmBgRJTv/CV2Al0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eZm8CLQMQwSuaSi2fIn8FCx4Fm8UFjpb4+EmGP2N2QpqmxPXn1OT87DMFJnUCLiRg
	 37bdD30hy6m7FEd+VVat2QOdoOOTR4gZSBnqdFzvfMhhkhXQsptDRTSAEoNsXjhI0v
	 JxYVOiYvV/8L1yNl1oJiPZ4zFICe5sz611jsxUMqARUJBK8BK4R3BLYauorqa1qOn7
	 9hBlK9Nx0o/TaBGOUAe5+Ab2CbjTjmdjMKdlu1RUrNpIeHAf2mKX1m6ueJPK6GZM31
	 ti0IY+MN/50JfhxOkIgz0p6faEmWt5g9KbFn9FVBN940DkTKECqvG2sewwWqI6eOJS
	 o6a/mDFSxslUw==
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
Subject: [PATCH v2 2/3] iommufd/tsm: add vdevice TSM bind/unbind ioctl
Date: Mon,  9 Mar 2026 16:47:03 +0530
Message-ID: <20260309111704.2330479-3-aneesh.kumar@kernel.org>
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
X-Rspamd-Queue-Id: 9C057237C1F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73282-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[aneesh.kumar@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-0.978];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,ziepe.ca:email,amd.com:email,intel.com:email,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

Introduce IOMMU_VDEVICE_TSM_OP to allow userspace to issue TSM bind/unbind
operations for an iommufd vdevice.

The new ioctl:
- looks up the vdevice object from vdevice_id
- resolves the associated KVM VM from the vIOMMU KVM file reference
- dispatches bind/unbind via tsm_bind()/tsm_unbind()

Also add common TSM helpers in tsm-core and wire vdevice teardown to unbind
the device from TSM state.

This provides iommufd plumbing to bind a TDI to a confidential guest through
the TSM layer.

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
 drivers/iommu/iommufd/Makefile          |  2 +
 drivers/iommu/iommufd/iommufd_private.h |  8 +++
 drivers/iommu/iommufd/main.c            |  3 ++
 drivers/iommu/iommufd/tsm.c             | 67 +++++++++++++++++++++++++
 drivers/iommu/iommufd/viommu.c          |  3 ++
 drivers/virt/coco/tsm-core.c            | 19 +++++++
 include/linux/tsm.h                     | 18 +++++++
 include/uapi/linux/iommufd.h            | 18 +++++++
 8 files changed, 138 insertions(+)
 create mode 100644 drivers/iommu/iommufd/tsm.c

diff --git a/drivers/iommu/iommufd/Makefile b/drivers/iommu/iommufd/Makefile
index 71d692c9a8f4..431089089ee9 100644
--- a/drivers/iommu/iommufd/Makefile
+++ b/drivers/iommu/iommufd/Makefile
@@ -10,6 +10,8 @@ iommufd-y := \
 	vfio_compat.o \
 	viommu.o
 
+iommufd-$(CONFIG_TSM) += tsm.o
+
 iommufd-$(CONFIG_IOMMUFD_TEST) += selftest.o
 
 obj-$(CONFIG_IOMMUFD) += iommufd.o
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 6ac1965199e9..aa1ceed924c2 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -697,6 +697,14 @@ void iommufd_vdevice_destroy(struct iommufd_object *obj);
 void iommufd_vdevice_abort(struct iommufd_object *obj);
 int iommufd_hw_queue_alloc_ioctl(struct iommufd_ucmd *ucmd);
 void iommufd_hw_queue_destroy(struct iommufd_object *obj);
+#ifdef CONFIG_TSM
+int iommufd_vdevice_tsm_op_ioctl(struct iommufd_ucmd *ucmd);
+#else
+static inline int iommufd_vdevice_tsm_op_ioctl(struct iommufd_ucmd *ucmd)
+{
+	return -EOPNOTSUPP;
+}
+#endif
 
 static inline struct iommufd_vdevice *
 iommufd_get_vdevice(struct iommufd_ctx *ictx, u32 id)
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 8c6d43601afb..d73e6b391c6f 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -432,6 +432,7 @@ union ucmd_buffer {
 	struct iommu_veventq_alloc veventq;
 	struct iommu_vfio_ioas vfio_ioas;
 	struct iommu_viommu_alloc viommu;
+	struct iommu_vdevice_tsm_op tsm_op;
 #ifdef CONFIG_IOMMUFD_TEST
 	struct iommu_test_cmd test;
 #endif
@@ -493,6 +494,8 @@ static const struct iommufd_ioctl_op iommufd_ioctl_ops[] = {
 		 __reserved),
 	IOCTL_OP(IOMMU_VIOMMU_ALLOC, iommufd_viommu_alloc_ioctl,
 		 struct iommu_viommu_alloc, out_viommu_id),
+	IOCTL_OP(IOMMU_VDEVICE_TSM_OP, iommufd_vdevice_tsm_op_ioctl,
+		 struct iommu_vdevice_tsm_op, vdevice_id),
 #ifdef CONFIG_IOMMUFD_TEST
 	IOCTL_OP(IOMMU_TEST_CMD, iommufd_test, struct iommu_test_cmd, last),
 #endif
diff --git a/drivers/iommu/iommufd/tsm.c b/drivers/iommu/iommufd/tsm.c
new file mode 100644
index 000000000000..401469110752
--- /dev/null
+++ b/drivers/iommu/iommufd/tsm.c
@@ -0,0 +1,67 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2026 ARM Ltd.
+ */
+
+#include "iommufd_private.h"
+#include <linux/tsm.h>
+
+/**
+ * iommufd_vdevice_tsm_op_ioctl - Handle vdevice TSM operations
+ * @ucmd: user command data for IOMMU_VDEVICE_TSM_OP
+ *
+ * Currently only supports TSM bind/unbind operations
+ * Resolve @iommu_vdevice_tsm_op::vdevice_id to a vdevice and dispatch the
+ * requested bind/unbind operation through the TSM core.
+ *
+ * Return: 0 on success, or a negative error code on failure.
+ */
+int iommufd_vdevice_tsm_op_ioctl(struct iommufd_ucmd *ucmd)
+{
+	int rc;
+	struct kvm *kvm;
+	struct iommufd_vdevice *vdev;
+	struct iommu_vdevice_tsm_op *cmd = ucmd->cmd;
+
+	if (cmd->flags)
+		return -EOPNOTSUPP;
+
+	vdev = container_of(iommufd_get_object(ucmd->ictx, cmd->vdevice_id,
+					       IOMMUFD_OBJ_VDEVICE),
+			    struct iommufd_vdevice, obj);
+	if (IS_ERR(vdev))
+		return PTR_ERR(vdev);
+
+	if (!vdev->viommu->kvm_filp) {
+		rc = -ENODEV;
+		goto out_put_vdev;
+	}
+
+	kvm = vdev->viommu->kvm_filp->private_data;
+	if (!kvm) {
+		rc = -ENODEV;
+		goto out_put_vdev;
+	}
+
+	/* tsm layer will take care of parallel calls to tsm_bind/unbind */
+	switch (cmd->op) {
+	case IOMMU_VDEVICE_TSM_BIND:
+		rc = tsm_bind(vdev->idev->dev, kvm, vdev->virt_id);
+		break;
+	case IOMMU_VDEVICE_TSM_UNBIND:
+		rc = tsm_unbind(vdev->idev->dev);
+		break;
+	default:
+		rc = -EINVAL;
+		goto out_put_vdev;
+	}
+
+	if (rc)
+		goto out_put_vdev;
+
+	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
+
+out_put_vdev:
+	iommufd_put_object(ucmd->ictx, &vdev->obj);
+	return rc;
+}
diff --git a/drivers/iommu/iommufd/viommu.c b/drivers/iommu/iommufd/viommu.c
index 08f8930c86da..8eb7a3441a61 100644
--- a/drivers/iommu/iommufd/viommu.c
+++ b/drivers/iommu/iommufd/viommu.c
@@ -3,6 +3,7 @@
  */
 #include "iommufd_private.h"
 #include <linux/cleanup.h>
+#include <linux/tsm.h>
 
 #if IS_ENABLED(CONFIG_KVM)
 #include <linux/kvm_host.h>
@@ -171,6 +172,8 @@ void iommufd_vdevice_abort(struct iommufd_object *obj)
 
 	lockdep_assert_held(&idev->igroup->lock);
 
+	tsm_unbind(idev->dev);
+
 	if (vdev->destroy)
 		vdev->destroy(vdev);
 	/* xa_cmpxchg is okay to fail if alloc failed xa_cmpxchg previously */
diff --git a/drivers/virt/coco/tsm-core.c b/drivers/virt/coco/tsm-core.c
index ae3617abd2ac..f0e35fc38776 100644
--- a/drivers/virt/coco/tsm-core.c
+++ b/drivers/virt/coco/tsm-core.c
@@ -240,6 +240,25 @@ void tsm_ide_stream_unregister(struct pci_ide *ide)
 }
 EXPORT_SYMBOL_GPL(tsm_ide_stream_unregister);
 
+int tsm_bind(struct device *dev, struct kvm *kvm, u64 tdi_id)
+{
+	if (!dev_is_pci(dev))
+		return -EINVAL;
+
+	return pci_tsm_bind(to_pci_dev(dev), kvm, tdi_id);
+}
+EXPORT_SYMBOL_GPL(tsm_bind);
+
+int tsm_unbind(struct device *dev)
+{
+	if (!dev_is_pci(dev))
+		return -EINVAL;
+
+	pci_tsm_unbind(to_pci_dev(dev));
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tsm_unbind);
+
 static void tsm_release(struct device *dev)
 {
 	struct tsm_dev *tsm_dev = container_of(dev, typeof(*tsm_dev), dev);
diff --git a/include/linux/tsm.h b/include/linux/tsm.h
index 7f72a154b6b2..9f2a7868021a 100644
--- a/include/linux/tsm.h
+++ b/include/linux/tsm.h
@@ -124,6 +124,24 @@ struct tsm_dev *tsm_register(struct device *parent, struct pci_tsm_ops *ops);
 void tsm_unregister(struct tsm_dev *tsm_dev);
 struct tsm_dev *find_tsm_dev(int id);
 struct pci_ide;
+struct kvm;
 int tsm_ide_stream_register(struct pci_ide *ide);
 void tsm_ide_stream_unregister(struct pci_ide *ide);
+#ifdef CONFIG_TSM
+int tsm_bind(struct device *dev, struct kvm *kvm, u64 tdi_id);
+int tsm_unbind(struct device *dev);
+
+#else
+
+static inline int tsm_bind(struct device *dev, struct kvm *kvm, u64 tdi_id)
+{
+	return -EINVAL;
+}
+
+static inline int tsm_unbind(struct device *dev)
+{
+	return 0;
+}
+#endif
+
 #endif /* __TSM_H */
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index b862c3e57133..653402e7048a 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -57,6 +57,7 @@ enum {
 	IOMMUFD_CMD_IOAS_CHANGE_PROCESS = 0x92,
 	IOMMUFD_CMD_VEVENTQ_ALLOC = 0x93,
 	IOMMUFD_CMD_HW_QUEUE_ALLOC = 0x94,
+	IOMMUFD_CMD_VDEVICE_TSM_OP = 0x95,
 };
 
 /**
@@ -1174,6 +1175,23 @@ enum iommu_veventq_flag {
 	IOMMU_VEVENTQ_FLAG_LOST_EVENTS = (1U << 0),
 };
 
+/**
+ * struct iommu_vdevice_tsm_op - ioctl(IOMMU_VDEVICE_TSM_OP)
+ * @size: sizeof(struct iommu_vdevice_tsm_op)
+ * @op: Either TSM_BIND or TSM_UNBIND
+ * @flags: Must be 0
+ * @vdevice_id: Object handle for the vDevice. Returned from IOMMU_VDEVICE_ALLOC
+ */
+struct iommu_vdevice_tsm_op {
+	__u32 size;
+	__u32 op;
+	__u32 flags;
+	__u32 vdevice_id;
+};
+#define IOMMU_VDEVICE_TSM_OP	_IO(IOMMUFD_TYPE, IOMMUFD_CMD_VDEVICE_TSM_OP)
+#define IOMMU_VDEVICE_TSM_BIND		0x1
+#define IOMMU_VDEVICE_TSM_UNBIND	0x2
+
 /**
  * struct iommufd_vevent_header - Virtual Event Header for a vEVENTQ Status
  * @flags: Combination of enum iommu_veventq_flag
-- 
2.43.0


