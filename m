Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B25C2643CE8
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 06:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233928AbiLFF7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 00:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233637AbiLFF6w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 00:58:52 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B7C2613A;
        Mon,  5 Dec 2022 21:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670306328; x=1701842328;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DejVWff0PrM8RwxO5Ftjo/53EiZqKWB8xQb046cdS+4=;
  b=YPrMLn/uYwYrYXr1PdwkLyNdP98ly6xkrdLEAnzF3oPkSUQEQp4klB93
   QYDQjo5otb49GClbvSdPuPiHWjnC9FEJfCtQEuevvL4QVA2umlMljuQ5w
   +aZrmd38/yF3g+e88FIwoXFkcPFMutxJQqTPJDq3v/UePjch1XbJQ3nWN
   A7v5AiV2zuPxQo6SZKDHnkhSNIqyZEdFQMRbNC2WuLkvlWMvPLaMcysjN
   M7eDveWgEtMpuNcOPLGRtThHWXzVM2tlYlDiDBnp7aU3ytYGQ/bmIVfMe
   uao87+bW9d39/Armpj5I9PrwLHPzSaoVlsrYu07ykyJIFpWW42QshbpWB
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="378706679"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="378706679"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 21:58:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="648211398"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="648211398"
Received: from leirao-pc.bj.intel.com ([10.238.156.101])
  by fmsmga007.fm.intel.com with ESMTP; 05 Dec 2022 21:58:41 -0800
From:   Lei Rao <lei.rao@intel.com>
To:     kbusch@kernel.org, axboe@fb.com, kch@nvidia.com, hch@lst.de,
        sagi@grimberg.me, alex.williamson@redhat.com, cohuck@redhat.com,
        jgg@ziepe.ca, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        mjrosato@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, kvm@vger.kernel.org
Cc:     eddie.dong@intel.com, yadong.li@intel.com, yi.l.liu@intel.com,
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com,
        Lei Rao <lei.rao@intel.com>
Subject: [RFC PATCH 3/5] nvme-vfio: enable the function of VFIO live migration.
Date:   Tue,  6 Dec 2022 13:58:14 +0800
Message-Id: <20221206055816.292304-4-lei.rao@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221206055816.292304-1-lei.rao@intel.com>
References: <20221206055816.292304-1-lei.rao@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement specific VFIO live migration operations for NVMe devices.

Signed-off-by: Lei Rao <lei.rao@intel.com>
Signed-off-by: Yadong Li <yadong.li@intel.com>
Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Eddie Dong <eddie.dong@intel.com>
Reviewed-by: Hang Yuan <hang.yuan@intel.com>
---
 drivers/vfio/pci/nvme/Kconfig |   5 +-
 drivers/vfio/pci/nvme/nvme.c  | 543 ++++++++++++++++++++++++++++++++--
 drivers/vfio/pci/nvme/nvme.h  | 111 +++++++
 3 files changed, 637 insertions(+), 22 deletions(-)
 create mode 100644 drivers/vfio/pci/nvme/nvme.h

diff --git a/drivers/vfio/pci/nvme/Kconfig b/drivers/vfio/pci/nvme/Kconfig
index c281fe154007..12e0eaba0de1 100644
--- a/drivers/vfio/pci/nvme/Kconfig
+++ b/drivers/vfio/pci/nvme/Kconfig
@@ -1,9 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config NVME_VFIO_PCI
 	tristate "VFIO support for NVMe PCI devices"
+	depends on NVME_CORE
 	depends on VFIO_PCI_CORE
 	help
-	  This provides generic VFIO PCI support for NVMe device
-	  using the VFIO framework.
+	  This provides migration support for NVMe devices using the
+	  VFIO framework.
 
 	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/pci/nvme/nvme.c b/drivers/vfio/pci/nvme/nvme.c
index f1386d8a9287..698e470a4e53 100644
--- a/drivers/vfio/pci/nvme/nvme.c
+++ b/drivers/vfio/pci/nvme/nvme.c
@@ -13,29 +13,503 @@
 #include <linux/types.h>
 #include <linux/vfio.h>
 #include <linux/anon_inodes.h>
-#include <linux/kernel.h>
-#include <linux/vfio_pci_core.h>
+
+#include "nvme.h"
+
+#define MAX_MIGRATION_SIZE (256 * 1024)
+
+static int nvmevf_cmd_suspend_device(struct nvmevf_pci_core_device *nvmevf_dev)
+{
+	struct pci_dev *dev = nvmevf_dev->core_device.pdev;
+	struct nvme_live_mig_command c = { };
+	int ret;
+
+	c.suspend.opcode = nvme_admin_live_mig_suspend;
+	c.suspend.vf_index = nvmevf_dev->vf_id;
+
+	ret = nvme_submit_vf_cmd(dev, (struct nvme_command *)&c, NULL, NULL, 0);
+	if (ret) {
+		dev_warn(&dev->dev, "Suspend virtual function failed (ret=0x%x)\n", ret);
+		return ret;
+	}
+	return 0;
+}
+
+static int nvmevf_cmd_resume_device(struct nvmevf_pci_core_device *nvmevf_dev)
+{
+	struct pci_dev *dev = nvmevf_dev->core_device.pdev;
+	struct nvme_live_mig_command c = { };
+	int ret;
+
+	c.resume.opcode = nvme_admin_live_mig_resume;
+	c.resume.vf_index = nvmevf_dev->vf_id;
+
+	ret = nvme_submit_vf_cmd(dev, (struct nvme_command *)&c, NULL, NULL, 0);
+	if (ret) {
+		dev_warn(&dev->dev, "Resume virtual function failed (ret=0x%x)\n", ret);
+		return ret;
+	}
+	return 0;
+}
+
+static int nvmevf_cmd_query_data_size(struct nvmevf_pci_core_device *nvmevf_dev,
+					  size_t *state_size)
+{
+	struct pci_dev *dev = nvmevf_dev->core_device.pdev;
+	struct nvme_live_mig_command c = { };
+	size_t result;
+	int ret;
+
+	c.query.opcode = nvme_admin_live_mig_query_data_size;
+	c.query.vf_index = nvmevf_dev->vf_id;
+
+	ret = nvme_submit_vf_cmd(dev, (struct nvme_command *)&c, &result, NULL, 0);
+	if (ret) {
+		dev_warn(&dev->dev, "Query the states size failed (ret=0x%x)\n", ret);
+		*state_size = 0;
+		return ret;
+	}
+	*state_size = result;
+	return 0;
+}
+
+static int nvmevf_cmd_save_data(struct nvmevf_pci_core_device *nvmevf_dev,
+				    void *buffer, size_t buffer_len)
+{
+	struct pci_dev *dev = nvmevf_dev->core_device.pdev;
+	struct nvme_live_mig_command c = { };
+	int ret;
+
+	c.save.opcode = nvme_admin_live_mig_save_data;
+	c.save.vf_index = nvmevf_dev->vf_id;
+
+	ret = nvme_submit_vf_cmd(dev, (struct nvme_command *)&c, NULL, buffer, buffer_len);
+	if (ret) {
+		dev_warn(&dev->dev, "Save the device states failed (ret=0x%x)\n", ret);
+		return ret;
+	}
+	return 0;
+}
+
+static int nvmevf_cmd_load_data(struct nvmevf_pci_core_device *nvmevf_dev,
+				    struct nvmevf_migration_file *migf)
+{
+	struct pci_dev *dev = nvmevf_dev->core_device.pdev;
+	struct nvme_live_mig_command c = { };
+	int ret;
+
+	c.load.opcode = nvme_admin_live_mig_load_data;
+	c.load.vf_index = nvmevf_dev->vf_id;
+	c.load.size = migf->total_length;
+
+	ret = nvme_submit_vf_cmd(dev, (struct nvme_command *)&c, NULL,
+			migf->vf_data, migf->total_length);
+	if (ret) {
+		dev_warn(&dev->dev, "Load the device states failed (ret=0x%x)\n", ret);
+		return ret;
+	}
+	return 0;
+}
+
+static struct nvmevf_pci_core_device *nvmevf_drvdata(struct pci_dev *pdev)
+{
+	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
+
+	return container_of(core_device, struct nvmevf_pci_core_device, core_device);
+}
+
+static void nvmevf_disable_fd(struct nvmevf_migration_file *migf)
+{
+	mutex_lock(&migf->lock);
+
+	/* release the device states buffer */
+	kvfree(migf->vf_data);
+	migf->vf_data = NULL;
+	migf->disabled = true;
+	migf->total_length = 0;
+	migf->filp->f_pos = 0;
+	mutex_unlock(&migf->lock);
+}
+
+static int nvmevf_release_file(struct inode *inode, struct file *filp)
+{
+	struct nvmevf_migration_file *migf = filp->private_data;
+
+	nvmevf_disable_fd(migf);
+	mutex_destroy(&migf->lock);
+	kfree(migf);
+	return 0;
+}
+
+static ssize_t nvmevf_save_read(struct file *filp, char __user *buf, size_t len, loff_t *pos)
+{
+	struct nvmevf_migration_file *migf = filp->private_data;
+	ssize_t done = 0;
+	int ret;
+
+	if (pos)
+		return -ESPIPE;
+	pos = &filp->f_pos;
+
+	mutex_lock(&migf->lock);
+	if (*pos > migf->total_length) {
+		done = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (migf->disabled) {
+		done = -EINVAL;
+		goto out_unlock;
+	}
+
+	len = min_t(size_t, migf->total_length - *pos, len);
+	if (len) {
+		ret = copy_to_user(buf, migf->vf_data + *pos, len);
+		if (ret) {
+			done = -EFAULT;
+			goto out_unlock;
+		}
+		*pos += len;
+		done = len;
+	}
+
+out_unlock:
+	mutex_unlock(&migf->lock);
+	return done;
+}
+
+static const struct file_operations nvmevf_save_fops = {
+	.owner = THIS_MODULE,
+	.read = nvmevf_save_read,
+	.release = nvmevf_release_file,
+	.llseek = no_llseek,
+};
+
+static ssize_t nvmevf_resume_write(struct file *filp, const char __user *buf,
+				       size_t len, loff_t *pos)
+{
+	struct nvmevf_migration_file *migf = filp->private_data;
+	loff_t requested_length;
+	ssize_t done = 0;
+	int ret;
+
+	if (pos)
+		return -ESPIPE;
+	pos = &filp->f_pos;
+
+	if (*pos < 0 || check_add_overflow((loff_t)len, *pos, &requested_length))
+		return -EINVAL;
+
+	if (requested_length > MAX_MIGRATION_SIZE)
+		return -ENOMEM;
+	mutex_lock(&migf->lock);
+	if (migf->disabled) {
+		done = -ENODEV;
+		goto out_unlock;
+	}
+
+	ret = copy_from_user(migf->vf_data + *pos, buf, len);
+	if (ret) {
+		done = -EFAULT;
+		goto out_unlock;
+	}
+	*pos += len;
+	done = len;
+	migf->total_length += len;
+
+out_unlock:
+	mutex_unlock(&migf->lock);
+	return done;
+}
+
+static const struct file_operations nvmevf_resume_fops = {
+	.owner = THIS_MODULE,
+	.write = nvmevf_resume_write,
+	.release = nvmevf_release_file,
+	.llseek = no_llseek,
+};
+
+static void nvmevf_disable_fds(struct nvmevf_pci_core_device *nvmevf_dev)
+{
+	if (nvmevf_dev->resuming_migf) {
+		nvmevf_disable_fd(nvmevf_dev->resuming_migf);
+		fput(nvmevf_dev->resuming_migf->filp);
+		nvmevf_dev->resuming_migf = NULL;
+	}
+
+	if (nvmevf_dev->saving_migf) {
+		nvmevf_disable_fd(nvmevf_dev->saving_migf);
+		fput(nvmevf_dev->saving_migf->filp);
+		nvmevf_dev->saving_migf = NULL;
+	}
+}
+
+static struct nvmevf_migration_file *
+nvmevf_pci_resume_device_data(struct nvmevf_pci_core_device *nvmevf_dev)
+{
+	struct nvmevf_migration_file *migf;
+	int ret;
+
+	migf = kzalloc(sizeof(*migf), GFP_KERNEL);
+	if (!migf)
+		return ERR_PTR(-ENOMEM);
+
+	migf->filp = anon_inode_getfile("nvmevf_mig", &nvmevf_resume_fops, migf,
+					O_WRONLY);
+	if (IS_ERR(migf->filp)) {
+		int err = PTR_ERR(migf->filp);
+
+		kfree(migf);
+		return ERR_PTR(err);
+	}
+	stream_open(migf->filp->f_inode, migf->filp);
+	mutex_init(&migf->lock);
+
+	/* Allocate buffer to load the device states and the max states is 256K */
+	migf->vf_data = kvzalloc(MAX_MIGRATION_SIZE, GFP_KERNEL);
+	if (!migf->vf_data) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	return migf;
+
+out_free:
+	fput(migf->filp);
+	return ERR_PTR(ret);
+}
+
+static struct nvmevf_migration_file *
+nvmevf_pci_save_device_data(struct nvmevf_pci_core_device *nvmevf_dev)
+{
+	struct nvmevf_migration_file *migf;
+	int ret;
+
+	migf = kzalloc(sizeof(*migf), GFP_KERNEL);
+	if (!migf)
+		return ERR_PTR(-ENOMEM);
+
+	migf->filp = anon_inode_getfile("nvmevf_mig", &nvmevf_save_fops, migf,
+					O_RDONLY);
+	if (IS_ERR(migf->filp)) {
+		int err = PTR_ERR(migf->filp);
+
+		kfree(migf);
+		return ERR_PTR(err);
+	}
+
+	stream_open(migf->filp->f_inode, migf->filp);
+	mutex_init(&migf->lock);
+
+	ret = nvmevf_cmd_query_data_size(nvmevf_dev, &migf->total_length);
+	if (ret)
+		goto out_free;
+	/* Allocate buffer and save the device states*/
+	migf->vf_data = kvzalloc(migf->total_length, GFP_KERNEL);
+	if (!migf->vf_data) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	ret = nvmevf_cmd_save_data(nvmevf_dev, migf->vf_data, migf->total_length);
+	if (ret)
+		goto out_free;
+
+	return migf;
+out_free:
+	fput(migf->filp);
+	return ERR_PTR(ret);
+}
+
+static struct file *
+nvmevf_pci_step_device_state_locked(struct nvmevf_pci_core_device *nvmevf_dev, u32 new)
+{
+	u32 cur = nvmevf_dev->mig_state;
+	int ret;
+
+	if (cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_STOP) {
+		ret = nvmevf_cmd_suspend_device(nvmevf_dev);
+		if (ret)
+			return ERR_PTR(ret);
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_STOP_COPY) {
+		struct nvmevf_migration_file *migf;
+
+		migf = nvmevf_pci_save_device_data(nvmevf_dev);
+		if (IS_ERR(migf))
+			return ERR_CAST(migf);
+		get_file(migf->filp);
+		nvmevf_dev->saving_migf = migf;
+		return migf->filp;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_STOP_COPY && new == VFIO_DEVICE_STATE_STOP) {
+		nvmevf_disable_fds(nvmevf_dev);
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_RESUMING) {
+		struct nvmevf_migration_file *migf;
+
+		migf = nvmevf_pci_resume_device_data(nvmevf_dev);
+		if (IS_ERR(migf))
+			return ERR_CAST(migf);
+		get_file(migf->filp);
+		nvmevf_dev->resuming_migf = migf;
+		return migf->filp;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_RESUMING && new == VFIO_DEVICE_STATE_STOP) {
+		ret = nvmevf_cmd_load_data(nvmevf_dev, nvmevf_dev->resuming_migf);
+		if (ret)
+			return ERR_PTR(ret);
+		nvmevf_disable_fds(nvmevf_dev);
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_RUNNING) {
+		nvmevf_cmd_resume_device(nvmevf_dev);
+		return NULL;
+	}
+
+	/* vfio_mig_get_next_state() does not use arcs other than the above */
+	WARN_ON(true);
+	return ERR_PTR(-EINVAL);
+}
+
+static void nvmevf_state_mutex_unlock(struct nvmevf_pci_core_device *nvmevf_dev)
+{
+again:
+	spin_lock(&nvmevf_dev->reset_lock);
+	if (nvmevf_dev->deferred_reset) {
+		nvmevf_dev->deferred_reset = false;
+		spin_unlock(&nvmevf_dev->reset_lock);
+		nvmevf_dev->mig_state = VFIO_DEVICE_STATE_RUNNING;
+		nvmevf_disable_fds(nvmevf_dev);
+		goto again;
+	}
+	mutex_unlock(&nvmevf_dev->state_mutex);
+	spin_unlock(&nvmevf_dev->reset_lock);
+}
+
+static struct file *
+nvmevf_pci_set_device_state(struct vfio_device *vdev, enum vfio_device_mig_state new_state)
+{
+	struct nvmevf_pci_core_device *nvmevf_dev = container_of(vdev,
+			struct nvmevf_pci_core_device, core_device.vdev);
+	enum vfio_device_mig_state next_state;
+	struct file *res = NULL;
+	int ret;
+
+	mutex_lock(&nvmevf_dev->state_mutex);
+	while (new_state != nvmevf_dev->mig_state) {
+		ret = vfio_mig_get_next_state(vdev, nvmevf_dev->mig_state, new_state, &next_state);
+		if (ret) {
+			res = ERR_PTR(-EINVAL);
+			break;
+		}
+
+		res = nvmevf_pci_step_device_state_locked(nvmevf_dev, next_state);
+		if (IS_ERR(res))
+			break;
+		nvmevf_dev->mig_state = next_state;
+		if (WARN_ON(res && new_state != nvmevf_dev->mig_state)) {
+			fput(res);
+			res = ERR_PTR(-EINVAL);
+			break;
+		}
+	}
+	nvmevf_state_mutex_unlock(nvmevf_dev);
+	return res;
+}
+
+static int nvmevf_pci_get_device_state(struct vfio_device *vdev,
+					   enum vfio_device_mig_state *curr_state)
+{
+	struct nvmevf_pci_core_device *nvmevf_dev = container_of(
+			vdev, struct nvmevf_pci_core_device, core_device.vdev);
+
+	mutex_lock(&nvmevf_dev->state_mutex);
+	*curr_state = nvmevf_dev->mig_state;
+	nvmevf_state_mutex_unlock(nvmevf_dev);
+	return 0;
+}
 
 static int nvmevf_pci_open_device(struct vfio_device *core_vdev)
 {
-	struct vfio_pci_core_device *vdev =
-		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	struct nvmevf_pci_core_device *nvmevf_dev = container_of(
+			core_vdev, struct nvmevf_pci_core_device, core_device.vdev);
+	struct vfio_pci_core_device *vdev = &nvmevf_dev->core_device;
 	int ret;
 
 	ret = vfio_pci_core_enable(vdev);
 	if (ret)
 		return ret;
 
+	if (nvmevf_dev->migrate_cap)
+		nvmevf_dev->mig_state = VFIO_DEVICE_STATE_RUNNING;
 	vfio_pci_core_finish_enable(vdev);
 	return 0;
 }
 
+static void nvmevf_cmd_close_migratable(struct nvmevf_pci_core_device *nvmevf_dev)
+{
+	if (!nvmevf_dev->migrate_cap)
+		return;
+
+	mutex_lock(&nvmevf_dev->state_mutex);
+	nvmevf_disable_fds(nvmevf_dev);
+	nvmevf_state_mutex_unlock(nvmevf_dev);
+}
+
+static void nvmevf_pci_close_device(struct vfio_device *core_vdev)
+{
+	struct nvmevf_pci_core_device *nvmevf_dev = container_of(
+			core_vdev, struct nvmevf_pci_core_device, core_device.vdev);
+
+	nvmevf_cmd_close_migratable(nvmevf_dev);
+	vfio_pci_core_close_device(core_vdev);
+}
+
+static const struct vfio_migration_ops nvmevf_pci_mig_ops = {
+	.migration_set_state = nvmevf_pci_set_device_state,
+	.migration_get_state = nvmevf_pci_get_device_state,
+};
+
+static int nvmevf_migration_init_dev(struct vfio_device *core_vdev)
+{
+	struct nvmevf_pci_core_device *nvmevf_dev = container_of(core_vdev,
+					struct nvmevf_pci_core_device, core_device.vdev);
+	struct pci_dev *pdev = to_pci_dev(core_vdev->dev);
+	int vf_id;
+	int ret = -1;
+
+	if (!pdev->is_virtfn)
+		return ret;
+
+	nvmevf_dev->migrate_cap = 1;
+
+	vf_id = pci_iov_vf_id(pdev);
+	if (vf_id < 0)
+		return ret;
+	nvmevf_dev->vf_id = vf_id + 1;
+	core_vdev->migration_flags = VFIO_MIGRATION_STOP_COPY;
+
+	mutex_init(&nvmevf_dev->state_mutex);
+	spin_lock_init(&nvmevf_dev->reset_lock);
+	core_vdev->mig_ops = &nvmevf_pci_mig_ops;
+
+	return vfio_pci_core_init_dev(core_vdev);
+}
+
 static const struct vfio_device_ops nvmevf_pci_ops = {
 	.name = "nvme-vfio-pci",
-	.init = vfio_pci_core_init_dev,
+	.init = nvmevf_migration_init_dev,
 	.release = vfio_pci_core_release_dev,
 	.open_device = nvmevf_pci_open_device,
-	.close_device = vfio_pci_core_close_device,
+	.close_device = nvmevf_pci_close_device,
 	.ioctl = vfio_pci_core_ioctl,
 	.device_feature = vfio_pci_core_ioctl_feature,
 	.read = vfio_pci_core_read,
@@ -47,32 +521,56 @@ static const struct vfio_device_ops nvmevf_pci_ops = {
 
 static int nvmevf_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	struct vfio_pci_core_device *vdev;
+	struct nvmevf_pci_core_device *nvmevf_dev;
 	int ret;
 
-	vdev = vfio_alloc_device(vfio_pci_core_device, vdev, &pdev->dev,
-				&nvmevf_pci_ops);
-	if (IS_ERR(vdev))
-		return PTR_ERR(vdev);
+	nvmevf_dev = vfio_alloc_device(nvmevf_pci_core_device, core_device.vdev,
+					&pdev->dev, &nvmevf_pci_ops);
+	if (IS_ERR(nvmevf_dev))
+		return PTR_ERR(nvmevf_dev);
 
-	dev_set_drvdata(&pdev->dev, vdev);
-	ret = vfio_pci_core_register_device(vdev);
+	dev_set_drvdata(&pdev->dev, &nvmevf_dev->core_device);
+	ret = vfio_pci_core_register_device(&nvmevf_dev->core_device);
 	if (ret)
 		goto out_put_dev;
-
 	return 0;
 
 out_put_dev:
-	vfio_put_device(&vdev->vdev);
+	vfio_put_device(&nvmevf_dev->core_device.vdev);
 	return ret;
+
 }
 
 static void nvmevf_pci_remove(struct pci_dev *pdev)
 {
-	struct vfio_pci_core_device *vdev = dev_get_drvdata(&pdev->dev);
+	struct nvmevf_pci_core_device *nvmevf_dev = nvmevf_drvdata(pdev);
+
+	vfio_pci_core_unregister_device(&nvmevf_dev->core_device);
+	vfio_put_device(&nvmevf_dev->core_device.vdev);
+}
+
+static void nvmevf_pci_aer_reset_done(struct pci_dev *pdev)
+{
+	struct nvmevf_pci_core_device *nvmevf_dev = nvmevf_drvdata(pdev);
+
+	if (!nvmevf_dev->migrate_cap)
+		return;
 
-	vfio_pci_core_unregister_device(vdev);
-	vfio_put_device(&vdev->vdev);
+	/*
+	 * As the higher VFIO layers are holding locks across reset and using
+	 * those same locks with the mm_lock we need to prevent ABBA deadlock
+	 * with the state_mutex and mm_lock.
+	 * In case the state_mutex was taken already we defer the cleanup work
+	 * to the unlock flow of the other running context.
+	 */
+	spin_lock(&nvmevf_dev->reset_lock);
+	nvmevf_dev->deferred_reset = true;
+	if (!mutex_trylock(&nvmevf_dev->state_mutex)) {
+		spin_unlock(&nvmevf_dev->reset_lock);
+		return;
+	}
+	spin_unlock(&nvmevf_dev->reset_lock);
+	nvmevf_state_mutex_unlock(nvmevf_dev);
 }
 
 static const struct pci_device_id nvmevf_pci_table[] = {
@@ -83,12 +581,17 @@ static const struct pci_device_id nvmevf_pci_table[] = {
 
 MODULE_DEVICE_TABLE(pci, nvmevf_pci_table);
 
+static const struct pci_error_handlers nvmevf_err_handlers = {
+	.reset_done = nvmevf_pci_aer_reset_done,
+	.error_detected = vfio_pci_core_aer_err_detected,
+};
+
 static struct pci_driver nvmevf_pci_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = nvmevf_pci_table,
 	.probe = nvmevf_pci_probe,
 	.remove = nvmevf_pci_remove,
-	.err_handler = &vfio_pci_core_err_handlers,
+	.err_handler = &nvmevf_err_handlers,
 	.driver_managed_dma = true,
 };
 
@@ -96,4 +599,4 @@ module_pci_driver(nvmevf_pci_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Lei Rao <lei.rao@intel.com>");
-MODULE_DESCRIPTION("NVMe VFIO PCI - Generic VFIO PCI driver for NVMe");
+MODULE_DESCRIPTION("NVMe VFIO PCI - VFIO PCI driver with live migration support for NVMe");
diff --git a/drivers/vfio/pci/nvme/nvme.h b/drivers/vfio/pci/nvme/nvme.h
new file mode 100644
index 000000000000..c8464554ef53
--- /dev/null
+++ b/drivers/vfio/pci/nvme/nvme.h
@@ -0,0 +1,111 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2022, INTEL CORPORATION. All rights reserved
+ */
+
+#ifndef NVME_VFIO_PCI_H
+#define NVME_VFIO_PCI_H
+
+#include <linux/kernel.h>
+#include <linux/vfio_pci_core.h>
+#include <linux/nvme.h>
+
+struct nvme_live_mig_query_size {
+	__u8	opcode;
+	__u8	flags;
+	__u16	command_id;
+	__u32	rsvd1[9];
+	__u16	vf_index;
+	__u16	rsvd2;
+	__u32	rsvd3[5];
+};
+
+struct nvme_live_mig_suspend {
+	__u8	opcode;
+	__u8	flags;
+	__u16	command_id;
+	__u32	rsvd1[9];
+	__u16	vf_index;
+	__u16	rsvd2;
+	__u32	rsvd3[5];
+};
+
+struct nvme_live_mig_resume {
+	__u8    opcode;
+	__u8    flags;
+	__u16   command_id;
+	__u32   rsvd1[9];
+	__u16   vf_index;
+	__u16   rsvd2;
+	__u32   rsvd3[5];
+};
+
+struct nvme_live_mig_save_data {
+	__u8	opcode;
+	__u8	flags;
+	__u16	command_id;
+	__u32	rsvd1[5];
+	__le64	prp1;
+	__le64	prp2;
+	__u16	vf_index;
+	__u16	rsvd2;
+	__u32	rsvd3[5];
+};
+
+struct nvme_live_mig_load_data {
+	__u8    opcode;
+	__u8    flags;
+	__u16   command_id;
+	__u32   rsvd1[5];
+	__le64  prp1;
+	__le64  prp2;
+	__u16   vf_index;
+	__u16	rsvd2;
+	__u32	size;
+	__u32   rsvd3[4];
+};
+
+enum nvme_live_mig_admin_opcode {
+	nvme_admin_live_mig_query_data_size	= 0xC4,
+	nvme_admin_live_mig_suspend		= 0xC8,
+	nvme_admin_live_mig_resume		= 0xCC,
+	nvme_admin_live_mig_save_data		= 0xD2,
+	nvme_admin_live_mig_load_data		= 0xD5,
+};
+
+struct nvme_live_mig_command {
+	union {
+		struct nvme_live_mig_query_size query;
+		struct nvme_live_mig_suspend	suspend;
+		struct nvme_live_mig_resume	resume;
+		struct nvme_live_mig_save_data	save;
+		struct nvme_live_mig_load_data	load;
+	};
+};
+
+struct nvmevf_migration_file {
+	struct file *filp;
+	struct mutex lock;
+	bool disabled;
+	u8 *vf_data;
+	size_t total_length;
+};
+
+struct nvmevf_pci_core_device {
+	struct vfio_pci_core_device core_device;
+	int vf_id;
+	u8 migrate_cap:1;
+	u8 deferred_reset:1;
+	/* protect migration state */
+	struct mutex state_mutex;
+	enum vfio_device_mig_state mig_state;
+	/* protect the reset_done flow */
+	spinlock_t reset_lock;
+	struct nvmevf_migration_file *resuming_migf;
+	struct nvmevf_migration_file *saving_migf;
+};
+
+extern int nvme_submit_vf_cmd(struct pci_dev *dev, struct nvme_command *cmd,
+			size_t *result, void *buffer, unsigned int bufflen);
+
+#endif /* NVME_VFIO_PCI_H */
-- 
2.34.1

