Return-Path: <kvm+bounces-7733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DFEF6845BE5
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 16:43:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1015D1C25595
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 15:43:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4285015D5BC;
	Thu,  1 Feb 2024 15:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nePjss3P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCDC6A32E;
	Thu,  1 Feb 2024 15:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706802149; cv=none; b=C4m3XQmwG6UsA6z6WDxMgKFgUTyF6MW+xUgaZvIHU05pZ6ENeQ+1B3rcn9dhd6i/DQiUEuGSfUOiVicwUFTCidwiD0bDv+ge7nvt+idOoHJ+Iw3/h9A6Ys7zfMwXdaXhxHRftoE7F1XhlMsLOK0nuZmjsISIiXZassqY1Subakg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706802149; c=relaxed/simple;
	bh=kiDmkd3VAtk8BTiAS8050ICmXaETCzDpevhqnzyc8Zk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=XZrv2nJUo7V9p8AOW+8r67+QOu+/g5yybur6542Z+LT6I1Y20wN7WWmsQqIybyR//h9aw4QoqurHEoiGsTAow1dIGqmAMRrQMiIJzn9ETzjgRsHKyBSf9F1I/5kSv6MpkBxkTRO7CFfPs6O0V/x/Q8uqhi0H2bHClfwQGktG/HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nePjss3P; arc=none smtp.client-ip=192.55.52.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706802147; x=1738338147;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=kiDmkd3VAtk8BTiAS8050ICmXaETCzDpevhqnzyc8Zk=;
  b=nePjss3PhwRkAs8PsSTWutwwfkLIOBbSoPWuvG0xZYDgLYdSdwQP2e0Y
   TnDpXOI5+/GhQAx5wFDauh9PTX3z+NVcjr8AjW0kP2LVn40WseLoOIRXC
   dK9H5ZDx3GpKeBsxrvo6aRzSjrvyjQ/sQO7woN6zoObpHoNmnTR/skW2Q
   nqVFrJdAlCB/E8MpxCzaYvCyjkqT7jjvcI7Nx6KRteQH4fC5whSNepdiW
   k5j0BcB3fT5aFFUCRU4pnt/36Hu5J16KByAP0n7II0oghouc5n0tkVn3e
   SCMswSZsFTF90Fp1sgIME4Nd7mgdacKubAkahFxMW9XI+EE9/SehI+2q9
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="401053082"
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="401053082"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 07:42:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="133374"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by orviesa007.jf.intel.com with ESMTP; 01 Feb 2024 07:42:24 -0800
From: Xin Zeng <xin.zeng@intel.com>
To: herbert@gondor.apana.org.au,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com
Cc: linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org,
	qat-linux@intel.com,
	Xin Zeng <xin.zeng@intel.com>,
	Yahui Cao <yahui.cao@intel.com>
Subject: [PATCH 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF devices
Date: Thu,  1 Feb 2024 23:33:37 +0800
Message-Id: <20240201153337.4033490-11-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20240201153337.4033490-1-xin.zeng@intel.com>
References: <20240201153337.4033490-1-xin.zeng@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Add vfio pci driver for Intel QAT VF devices.

This driver uses vfio_pci_core to register to the VFIO subsystem. It
acts as a vfio agent and interacts with the QAT PF driver to implement
VF live migration.

Co-developed-by: Yahui Cao <yahui.cao@intel.com>
Signed-off-by: Yahui Cao <yahui.cao@intel.com>
Signed-off-by: Xin Zeng <xin.zeng@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 MAINTAINERS                         |   8 +
 drivers/vfio/pci/Kconfig            |   2 +
 drivers/vfio/pci/Makefile           |   2 +
 drivers/vfio/pci/intel/qat/Kconfig  |  13 +
 drivers/vfio/pci/intel/qat/Makefile |   4 +
 drivers/vfio/pci/intel/qat/main.c   | 572 ++++++++++++++++++++++++++++
 6 files changed, 601 insertions(+)
 create mode 100644 drivers/vfio/pci/intel/qat/Kconfig
 create mode 100644 drivers/vfio/pci/intel/qat/Makefile
 create mode 100644 drivers/vfio/pci/intel/qat/main.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 8d1052fa6a69..c1d3e4cb3892 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -23095,6 +23095,14 @@ S:	Maintained
 F:	Documentation/networking/device_drivers/ethernet/amd/pds_vfio_pci.rst
 F:	drivers/vfio/pci/pds/
 
+VFIO QAT PCI DRIVER
+M:	Xin Zeng <xin.zeng@intel.com>
+M:	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
+L:	kvm@vger.kernel.org
+L:	qat-linux@intel.com
+S:	Supported
+F:	drivers/vfio/pci/intel/qat/
+
 VFIO PLATFORM DRIVER
 M:	Eric Auger <eric.auger@redhat.com>
 L:	kvm@vger.kernel.org
diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 18c397df566d..329d25c53274 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -67,4 +67,6 @@ source "drivers/vfio/pci/pds/Kconfig"
 
 source "drivers/vfio/pci/virtio/Kconfig"
 
+source "drivers/vfio/pci/intel/qat/Kconfig"
+
 endmenu
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 046139a4eca5..a87b6b43ce1c 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -15,3 +15,5 @@ obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
 obj-$(CONFIG_PDS_VFIO_PCI) += pds/
 
 obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio/
+
+obj-$(CONFIG_QAT_VFIO_PCI) += intel/qat/
diff --git a/drivers/vfio/pci/intel/qat/Kconfig b/drivers/vfio/pci/intel/qat/Kconfig
new file mode 100644
index 000000000000..71b28ac0bf6a
--- /dev/null
+++ b/drivers/vfio/pci/intel/qat/Kconfig
@@ -0,0 +1,13 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config QAT_VFIO_PCI
+	tristate "VFIO support for QAT VF PCI devices"
+	select VFIO_PCI_CORE
+	depends on CRYPTO_DEV_QAT
+	depends on CRYPTO_DEV_QAT_4XXX
+	help
+	  This provides migration support for Intel(R) QAT Virtual Function
+	  using the VFIO framework.
+
+	  To compile this as a module, choose M here: the module
+	  will be called qat_vfio_pci. If you don't know what to do here,
+	  say N.
diff --git a/drivers/vfio/pci/intel/qat/Makefile b/drivers/vfio/pci/intel/qat/Makefile
new file mode 100644
index 000000000000..9289ae4c51bf
--- /dev/null
+++ b/drivers/vfio/pci/intel/qat/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_QAT_VFIO_PCI) += qat_vfio_pci.o
+qat_vfio_pci-y := main.o
+
diff --git a/drivers/vfio/pci/intel/qat/main.c b/drivers/vfio/pci/intel/qat/main.c
new file mode 100644
index 000000000000..85d0ed701397
--- /dev/null
+++ b/drivers/vfio/pci/intel/qat/main.c
@@ -0,0 +1,572 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2024 Intel Corporation */
+
+#include <linux/anon_inodes.h>
+#include <linux/container_of.h>
+#include <linux/device.h>
+#include <linux/file.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/pci.h>
+#include <linux/sizes.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <linux/vfio_pci_core.h>
+#include <linux/qat/qat_mig_dev.h>
+
+struct qat_vf_migration_file {
+	struct file *filp;
+	/* protects migration region context */
+	struct mutex lock;
+	bool disabled;
+	struct qat_mig_dev *mdev;
+};
+
+struct qat_vf_core_device {
+	struct vfio_pci_core_device core_device;
+	struct qat_mig_dev *mdev;
+	/* protects migration state */
+	struct mutex state_mutex;
+	enum vfio_device_mig_state mig_state;
+	/* protects reset down flow */
+	spinlock_t reset_lock;
+	bool deferred_reset;
+	struct qat_vf_migration_file *resuming_migf;
+	struct qat_vf_migration_file *saving_migf;
+};
+
+static int qat_vf_pci_open_device(struct vfio_device *core_vdev)
+{
+	struct qat_vf_core_device *qat_vdev =
+		container_of(core_vdev, struct qat_vf_core_device,
+			     core_device.vdev);
+	struct vfio_pci_core_device *vdev = &qat_vdev->core_device;
+	int ret;
+
+	ret = vfio_pci_core_enable(vdev);
+	if (ret)
+		return ret;
+
+	ret = qat_vdev->mdev->ops->open(qat_vdev->mdev);
+	if (ret) {
+		vfio_pci_core_disable(vdev);
+		return ret;
+	}
+	qat_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
+
+	vfio_pci_core_finish_enable(vdev);
+
+	return 0;
+}
+
+static void qat_vf_disable_fd(struct qat_vf_migration_file *migf)
+{
+	mutex_lock(&migf->lock);
+	migf->disabled = true;
+	migf->filp->f_pos = 0;
+	mutex_unlock(&migf->lock);
+}
+
+static void qat_vf_disable_fds(struct qat_vf_core_device *qat_vdev)
+{
+	if (qat_vdev->resuming_migf) {
+		qat_vf_disable_fd(qat_vdev->resuming_migf);
+		fput(qat_vdev->resuming_migf->filp);
+		qat_vdev->resuming_migf = NULL;
+	}
+
+	if (qat_vdev->saving_migf) {
+		qat_vf_disable_fd(qat_vdev->saving_migf);
+		fput(qat_vdev->saving_migf->filp);
+		qat_vdev->saving_migf = NULL;
+	}
+}
+
+static void qat_vf_pci_close_device(struct vfio_device *core_vdev)
+{
+	struct qat_vf_core_device *qat_vdev = container_of(core_vdev,
+			struct qat_vf_core_device, core_device.vdev);
+
+	qat_vdev->mdev->ops->close(qat_vdev->mdev);
+	qat_vf_disable_fds(qat_vdev);
+	vfio_pci_core_close_device(core_vdev);
+}
+
+static ssize_t qat_vf_save_read(struct file *filp, char __user *buf,
+				size_t len, loff_t *pos)
+{
+	struct qat_vf_migration_file *migf = filp->private_data;
+	ssize_t done = 0;
+	loff_t *offs;
+	int ret;
+
+	if (pos)
+		return -ESPIPE;
+	offs = &filp->f_pos;
+
+	mutex_lock(&migf->lock);
+	if (*offs > migf->mdev->state_size || *offs < 0) {
+		done = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (migf->disabled) {
+		done = -ENODEV;
+		goto out_unlock;
+	}
+
+	len = min_t(size_t, migf->mdev->state_size - *offs, len);
+	if (len) {
+		ret = copy_to_user(buf, migf->mdev->state + *offs, len);
+		if (ret) {
+			done = -EFAULT;
+			goto out_unlock;
+		}
+		*offs += len;
+		done = len;
+	}
+
+out_unlock:
+	mutex_unlock(&migf->lock);
+	return done;
+}
+
+static int qat_vf_release_file(struct inode *inode, struct file *filp)
+{
+	struct qat_vf_migration_file *migf = filp->private_data;
+
+	qat_vf_disable_fd(migf);
+	mutex_destroy(&migf->lock);
+	kfree(migf);
+
+	return 0;
+}
+
+static const struct file_operations qat_vf_save_fops = {
+	.owner = THIS_MODULE,
+	.read = qat_vf_save_read,
+	.release = qat_vf_release_file,
+	.llseek = no_llseek,
+};
+
+static struct qat_vf_migration_file *
+qat_vf_save_device_data(struct qat_vf_core_device *qat_vdev)
+{
+	struct qat_vf_migration_file *migf;
+	int ret;
+
+	migf = kzalloc(sizeof(*migf), GFP_KERNEL);
+	if (!migf)
+		return ERR_PTR(-ENOMEM);
+
+	migf->filp = anon_inode_getfile("qat_vf_mig", &qat_vf_save_fops, migf, O_RDONLY);
+	ret = PTR_ERR_OR_ZERO(migf->filp);
+	if (ret) {
+		kfree(migf);
+		return ERR_PTR(ret);
+	}
+
+	stream_open(migf->filp->f_inode, migf->filp);
+	mutex_init(&migf->lock);
+
+	ret = qat_vdev->mdev->ops->save_state(qat_vdev->mdev);
+	if (ret) {
+		fput(migf->filp);
+		kfree(migf);
+		return ERR_PTR(ret);
+	}
+
+	migf->mdev = qat_vdev->mdev;
+
+	return migf;
+}
+
+static ssize_t qat_vf_resume_write(struct file *filp, const char __user *buf,
+				   size_t len, loff_t *pos)
+{
+	struct qat_vf_migration_file *migf = filp->private_data;
+	loff_t end, *offs;
+	ssize_t done = 0;
+	int ret;
+
+	if (pos)
+		return -ESPIPE;
+	offs = &filp->f_pos;
+
+	if (*offs < 0 ||
+	    check_add_overflow((loff_t)len, *offs, &end))
+		return -EOVERFLOW;
+
+	if (end > migf->mdev->state_size)
+		return -ENOMEM;
+
+	mutex_lock(&migf->lock);
+	if (migf->disabled) {
+		done = -ENODEV;
+		goto out_unlock;
+	}
+
+	ret = copy_from_user(migf->mdev->state + *offs, buf, len);
+	if (ret) {
+		done = -EFAULT;
+		goto out_unlock;
+	}
+	*offs += len;
+	done = len;
+
+out_unlock:
+	mutex_unlock(&migf->lock);
+	return done;
+}
+
+static const struct file_operations qat_vf_resume_fops = {
+	.owner = THIS_MODULE,
+	.write = qat_vf_resume_write,
+	.release = qat_vf_release_file,
+	.llseek = no_llseek,
+};
+
+static struct qat_vf_migration_file *
+qat_vf_resume_device_data(struct qat_vf_core_device *qat_vdev)
+{
+	struct qat_vf_migration_file *migf;
+	int ret;
+
+	migf = kzalloc(sizeof(*migf), GFP_KERNEL);
+	if (!migf)
+		return ERR_PTR(-ENOMEM);
+
+	migf->filp = anon_inode_getfile("qat_vf_mig", &qat_vf_resume_fops, migf, O_WRONLY);
+	ret = PTR_ERR_OR_ZERO(migf->filp);
+	if (ret) {
+		kfree(migf);
+		return ERR_PTR(ret);
+	}
+
+	migf->mdev = qat_vdev->mdev;
+	stream_open(migf->filp->f_inode, migf->filp);
+	mutex_init(&migf->lock);
+
+	return migf;
+}
+
+static int qat_vf_load_device_data(struct qat_vf_core_device *qat_vdev)
+{
+	return qat_vdev->mdev->ops->load_state(qat_vdev->mdev);
+}
+
+static struct file *qat_vf_pci_step_device_state(struct qat_vf_core_device *qat_vdev, u32 new)
+{
+	u32 cur = qat_vdev->mig_state;
+	int ret;
+
+	if ((cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_RUNNING_P2P)) {
+		ret = qat_vdev->mdev->ops->suspend(qat_vdev->mdev);
+		if (ret)
+			return ERR_PTR(ret);
+		return NULL;
+	}
+
+	if ((cur == VFIO_DEVICE_STATE_RUNNING_P2P && new == VFIO_DEVICE_STATE_STOP) ||
+	    (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_RUNNING_P2P))
+		return NULL;
+
+	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_STOP_COPY) {
+		struct qat_vf_migration_file *migf;
+
+		migf = qat_vf_save_device_data(qat_vdev);
+		if (IS_ERR(migf))
+			return ERR_CAST(migf);
+		get_file(migf->filp);
+		qat_vdev->saving_migf = migf;
+		return migf->filp;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_STOP_COPY && new == VFIO_DEVICE_STATE_STOP) {
+		qat_vf_disable_fds(qat_vdev);
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_RESUMING) {
+		struct qat_vf_migration_file *migf;
+
+		migf = qat_vf_resume_device_data(qat_vdev);
+		if (IS_ERR(migf))
+			return ERR_CAST(migf);
+		get_file(migf->filp);
+		qat_vdev->resuming_migf = migf;
+		return migf->filp;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_RESUMING && new == VFIO_DEVICE_STATE_STOP) {
+		ret = qat_vf_load_device_data(qat_vdev);
+		if (ret)
+			return ERR_PTR(ret);
+
+		qat_vf_disable_fds(qat_vdev);
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && new == VFIO_DEVICE_STATE_RUNNING) {
+		qat_vdev->mdev->ops->resume(qat_vdev->mdev);
+		return NULL;
+	}
+
+	/* vfio_mig_get_next_state() does not use arcs other than the above */
+	WARN_ON(true);
+	return ERR_PTR(-EINVAL);
+}
+
+static void qat_vf_state_mutex_unlock(struct qat_vf_core_device *qat_vdev)
+{
+again:
+	spin_lock(&qat_vdev->reset_lock);
+	if (qat_vdev->deferred_reset) {
+		qat_vdev->deferred_reset = false;
+		spin_unlock(&qat_vdev->reset_lock);
+		qat_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
+		qat_vf_disable_fds(qat_vdev);
+		goto again;
+	}
+	mutex_unlock(&qat_vdev->state_mutex);
+	spin_unlock(&qat_vdev->reset_lock);
+}
+
+static struct file *qat_vf_pci_set_device_state(struct vfio_device *vdev,
+						enum vfio_device_mig_state new_state)
+{
+	struct qat_vf_core_device *qat_vdev = container_of(vdev,
+			struct qat_vf_core_device, core_device.vdev);
+	enum vfio_device_mig_state next_state;
+	struct file *res = NULL;
+	int ret;
+
+	mutex_lock(&qat_vdev->state_mutex);
+	while (new_state != qat_vdev->mig_state) {
+		ret = vfio_mig_get_next_state(vdev, qat_vdev->mig_state,
+					      new_state, &next_state);
+		if (ret) {
+			res = ERR_PTR(ret);
+			break;
+		}
+		res = qat_vf_pci_step_device_state(qat_vdev, next_state);
+		if (IS_ERR(res))
+			break;
+		qat_vdev->mig_state = next_state;
+		if (WARN_ON(res && new_state != qat_vdev->mig_state)) {
+			fput(res);
+			res = ERR_PTR(-EINVAL);
+			break;
+		}
+	}
+	qat_vf_state_mutex_unlock(qat_vdev);
+
+	return res;
+}
+
+static int qat_vf_pci_get_device_state(struct vfio_device *vdev,
+				       enum vfio_device_mig_state *curr_state)
+{
+	struct qat_vf_core_device *qat_vdev = container_of(vdev,
+			struct qat_vf_core_device, core_device.vdev);
+
+	mutex_lock(&qat_vdev->state_mutex);
+	*curr_state = qat_vdev->mig_state;
+	qat_vf_state_mutex_unlock(qat_vdev);
+
+	return 0;
+}
+
+static int qat_vf_pci_get_data_size(struct vfio_device *vdev,
+				    unsigned long *stop_copy_length)
+{
+	struct qat_vf_core_device *qat_vdev = container_of(vdev,
+			struct qat_vf_core_device, core_device.vdev);
+
+	*stop_copy_length = qat_vdev->mdev->state_size;
+	return 0;
+}
+
+static const struct vfio_migration_ops qat_vf_pci_mig_ops = {
+	.migration_set_state = qat_vf_pci_set_device_state,
+	.migration_get_state = qat_vf_pci_get_device_state,
+	.migration_get_data_size = qat_vf_pci_get_data_size,
+};
+
+static void qat_vf_pci_release_dev(struct vfio_device *core_vdev)
+{
+	struct qat_vf_core_device *qat_vdev = container_of(core_vdev,
+			struct qat_vf_core_device, core_device.vdev);
+
+	qat_vdev->mdev->ops->cleanup(qat_vdev->mdev);
+	qat_vfmig_destroy(qat_vdev->mdev);
+	mutex_destroy(&qat_vdev->state_mutex);
+	vfio_pci_core_release_dev(core_vdev);
+}
+
+static int qat_vf_pci_init_dev(struct vfio_device *core_vdev)
+{
+	struct qat_vf_core_device *qat_vdev = container_of(core_vdev,
+			struct qat_vf_core_device, core_device.vdev);
+	struct qat_migdev_ops *ops;
+	struct qat_mig_dev *mdev;
+	struct pci_dev *parent;
+	int ret, vf_id;
+
+	core_vdev->migration_flags = VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P;
+	core_vdev->mig_ops = &qat_vf_pci_mig_ops;
+
+	ret = vfio_pci_core_init_dev(core_vdev);
+	if (ret)
+		return ret;
+
+	mutex_init(&qat_vdev->state_mutex);
+	spin_lock_init(&qat_vdev->reset_lock);
+
+	parent = qat_vdev->core_device.pdev->physfn;
+	vf_id = pci_iov_vf_id(qat_vdev->core_device.pdev);
+	if (!parent || vf_id < 0) {
+		ret = -ENODEV;
+		goto err_rel;
+	}
+
+	mdev = qat_vfmig_create(parent, vf_id);
+	if (IS_ERR(mdev)) {
+		ret = PTR_ERR(mdev);
+		goto err_rel;
+	}
+
+	ops = mdev->ops;
+	if (!ops || !ops->init || !ops->cleanup ||
+	    !ops->open || !ops->close ||
+	    !ops->save_state || !ops->load_state ||
+	    !ops->suspend || !ops->resume) {
+		ret = -EIO;
+		dev_err(&parent->dev, "Incomplete device migration ops structure!");
+		goto err_destroy;
+	}
+	ret = ops->init(mdev);
+	if (ret)
+		goto err_destroy;
+
+	qat_vdev->mdev = mdev;
+
+	return 0;
+
+err_destroy:
+	qat_vfmig_destroy(mdev);
+err_rel:
+	vfio_pci_core_release_dev(core_vdev);
+	return ret;
+}
+
+static const struct vfio_device_ops qat_vf_pci_ops = {
+	.name = "qat-vf-vfio-pci",
+	.init = qat_vf_pci_init_dev,
+	.release = qat_vf_pci_release_dev,
+	.open_device = qat_vf_pci_open_device,
+	.close_device = qat_vf_pci_close_device,
+	.ioctl = vfio_pci_core_ioctl,
+	.read = vfio_pci_core_read,
+	.write = vfio_pci_core_write,
+	.mmap = vfio_pci_core_mmap,
+	.request = vfio_pci_core_request,
+	.match = vfio_pci_core_match,
+	.bind_iommufd = vfio_iommufd_physical_bind,
+	.unbind_iommufd = vfio_iommufd_physical_unbind,
+	.attach_ioas = vfio_iommufd_physical_attach_ioas,
+	.detach_ioas = vfio_iommufd_physical_detach_ioas,
+};
+
+static struct qat_vf_core_device *qat_vf_drvdata(struct pci_dev *pdev)
+{
+	struct vfio_pci_core_device *core_device = pci_get_drvdata(pdev);
+
+	return container_of(core_device, struct qat_vf_core_device, core_device);
+}
+
+static void qat_vf_pci_aer_reset_done(struct pci_dev *pdev)
+{
+	struct qat_vf_core_device *qat_vdev = qat_vf_drvdata(pdev);
+
+	if (!qat_vdev->core_device.vdev.mig_ops)
+		return;
+
+	/*
+	 * As the higher VFIO layers are holding locks across reset and using
+	 * those same locks with the mm_lock we need to prevent ABBA deadlock
+	 * with the state_mutex and mm_lock.
+	 * In case the state_mutex was taken already we defer the cleanup work
+	 * to the unlock flow of the other running context.
+	 */
+	spin_lock(&qat_vdev->reset_lock);
+	qat_vdev->deferred_reset = true;
+	if (!mutex_trylock(&qat_vdev->state_mutex)) {
+		spin_unlock(&qat_vdev->reset_lock);
+		return;
+	}
+	spin_unlock(&qat_vdev->reset_lock);
+	qat_vf_state_mutex_unlock(qat_vdev);
+}
+
+static int
+qat_vf_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct device *dev = &pdev->dev;
+	struct qat_vf_core_device *qat_vdev;
+	int ret;
+
+	qat_vdev = vfio_alloc_device(qat_vf_core_device, core_device.vdev, dev, &qat_vf_pci_ops);
+	if (IS_ERR(qat_vdev))
+		return PTR_ERR(qat_vdev);
+
+	pci_set_drvdata(pdev, &qat_vdev->core_device);
+	ret = vfio_pci_core_register_device(&qat_vdev->core_device);
+	if (ret)
+		goto out_put_device;
+
+	return 0;
+
+out_put_device:
+	vfio_put_device(&qat_vdev->core_device.vdev);
+	return ret;
+}
+
+static void qat_vf_vfio_pci_remove(struct pci_dev *pdev)
+{
+	struct qat_vf_core_device *qat_vdev = qat_vf_drvdata(pdev);
+
+	vfio_pci_core_unregister_device(&qat_vdev->core_device);
+	vfio_put_device(&qat_vdev->core_device.vdev);
+}
+
+static const struct pci_device_id qat_vf_vfio_pci_table[] = {
+	/* Intel QAT GEN4 4xxx VF device */
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_INTEL, 0x4941) },
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_INTEL, 0x4943) },
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_INTEL, 0x4945) },
+	{}
+};
+MODULE_DEVICE_TABLE(pci, qat_vf_vfio_pci_table);
+
+static const struct pci_error_handlers qat_vf_err_handlers = {
+	.reset_done = qat_vf_pci_aer_reset_done,
+	.error_detected = vfio_pci_core_aer_err_detected,
+};
+
+static struct pci_driver qat_vf_vfio_pci_driver = {
+	.name = "qat_vfio_pci",
+	.id_table = qat_vf_vfio_pci_table,
+	.probe = qat_vf_vfio_pci_probe,
+	.remove = qat_vf_vfio_pci_remove,
+	.err_handler = &qat_vf_err_handlers,
+	.driver_managed_dma = true,
+};
+module_pci_driver(qat_vf_vfio_pci_driver)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Intel Corporation");
+MODULE_DESCRIPTION("QAT VFIO PCI - VFIO PCI driver with live migration support for Intel(R) QAT GEN4 device family");
+MODULE_IMPORT_NS(CRYPTO_QAT);
-- 
2.18.2


