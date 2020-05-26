Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426561D6058
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 12:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbgEPKQP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 May 2020 06:16:15 -0400
Received: from mga12.intel.com ([192.55.52.136]:37165 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725792AbgEPKQN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 May 2020 06:16:13 -0400
IronPort-SDR: i+262E0LkHnpBm4VMX8kyunPQIuqPzMIOr4ry+PWW7Wq4FU2BZZ6CcPkukx/tkbA16AfbTU5ye
 8GmsR7q2CTnQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2020 03:16:12 -0700
IronPort-SDR: E8NjAMPFQKWjtoqyfArlrqD9tn/bYi0ZDSQbC9qS2Zuma7opB/dZMxV7q0MJfSmBS39u84u+9m
 2qG9OG/tx+dA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,398,1583222400"; 
   d="scan'208";a="252322439"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu.ger.corp.intel.com) ([10.249.40.45])
  by orsmga007.jf.intel.com with ESMTP; 16 May 2020 03:16:10 -0700
From:   Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>
Subject: [PATCH RFC] vhost: add an SOF Audio DSP driver
Date:   Sat, 16 May 2020 12:16:09 +0200
Message-Id: <20200516101609.2845-1-guennadi.liakhovetski@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SOF ADSP vhost driver consists of two parts: a sound and a vhost
part. This patch implements the vhost part of the driver. It handles
QEMU communication with the vhost misc device and virtual queues to
any VirtIO RPMsg guests.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
---

This is marked as an RFC / request for review, since it depends on other
patches, that haven't been merged yet. It uses the vhost RPMsg API, submitted
minutes ago to the lists
https://lists.linuxfoundation.org/pipermail/virtualization/2020-May/047669.html
and is a part of the SOF virtualisation project
https://github.com/thesofproject/linux/pull/1501/commits

Thanks
Guennadi

 drivers/vhost/Kconfig  |  10 +
 drivers/vhost/Makefile |   3 +
 drivers/vhost/adsp.c   | 618 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 631 insertions(+)
 create mode 100644 drivers/vhost/adsp.c

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index 4021522..2aff7c1 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -28,6 +28,16 @@ config VHOST_SCSI
 	Say M here to enable the vhost_scsi TCM fabric module
 	for use with virtio-scsi guests
 
+config VHOST_SOF
+	tristate "Vhost SOF driver"
+	depends on SND_SOC_SOF
+	select VHOST
+	select VHOST_RPMSG
+	default n
+	---help---
+	  SOF vhost VirtIO driver. It exports the same IPC interface, as the
+	  one, used for Audio DSP communication, to Linux VirtIO guests.
+
 config VHOST_VSOCK
 	tristate "vhost virtio-vsock driver"
 	depends on VSOCKETS && EVENTFD
diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
index 29b8115..3de5e08 100644
--- a/drivers/vhost/Makefile
+++ b/drivers/vhost/Makefile
@@ -8,6 +8,9 @@ vhost_rpmsg-y := rpmsg.o
 obj-$(CONFIG_VHOST_SCSI) += vhost_scsi.o
 vhost_scsi-y := scsi.o
 
+obj-$(CONFIG_VHOST_SOF) += vhost_sof.o
+vhost_sof-y := adsp.o
+
 obj-$(CONFIG_VHOST_VSOCK) += vhost_vsock.o
 vhost_vsock-y := vsock.o
 
diff --git a/drivers/vhost/adsp.c b/drivers/vhost/adsp.c
new file mode 100644
index 00000000..c386cf3
--- /dev/null
+++ b/drivers/vhost/adsp.c
@@ -0,0 +1,618 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
+/*
+ * Copyright(c) 2019-2020 Intel Corporation. All rights reserved.
+ *
+ * Author: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
+ *
+ * vhost-SOF VirtIO interface
+ */
+
+#include <linux/bitmap.h>
+#include <linux/compat.h>
+#include <linux/file.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/vhost.h>
+#include <linux/virtio_rpmsg.h>
+#include <uapi/linux/rpmsg.h>
+
+#include <sound/sof/stream.h>
+#include <sound/sof/rpmsg.h>
+
+#include "vhost.h"
+#include "vhost_rpmsg.h"
+
+#define VHOST_DSP_FEATURES (VHOST_FEATURES | (1ULL << VIRTIO_RPMSG_F_NS))
+
+struct snd_sof_dev;
+struct sof_vhost_client;
+
+struct vhost_dsp {
+	struct vhost_rpmsg vrdev;
+
+	struct sof_vhost_client *snd;
+
+	bool active;
+
+	/* RPMsg address of the position update endpoint */
+	u32 posn_addr;
+	/* position update buffer and work */
+	struct vhost_work posn_work;
+	struct sof_ipc_stream_posn posn;
+
+	/* IPC request buffer */
+	struct sof_rpmsg_ipc_req ipc_buf;
+	/* IPC response buffer */
+	u8 reply_buf[SOF_IPC_MSG_MAX_SIZE];
+	/*
+	 * data response header, captured audio data is copied directly from the
+	 * DMA buffer
+	 */
+	struct sof_rpmsg_data_resp data_resp;
+};
+
+/* A guest is booting */
+static int vhost_dsp_activate(struct vhost_dsp *dsp)
+{
+	unsigned int i;
+	int ret = 0;
+
+	mutex_lock(&dsp->vrdev.dev.mutex);
+
+	/* Wait until all the VirtQueues have been initialised */
+	if (!dsp->active) {
+		struct vhost_virtqueue *vq;
+
+		for (i = 0, vq = dsp->vrdev.vq;
+		     i < ARRAY_SIZE(dsp->vrdev.vq);
+		     i++, vq++) {
+			/* .private_data is required != NULL */
+			vq->private_data = vq;
+			/* needed for re-initialisation upon guest reboot */
+			ret = vhost_vq_init_access(vq);
+			if (ret)
+				vq_err(vq,
+				       "%s(): error %d initialising vq #%d\n",
+				       __func__, ret, i);
+		}
+
+		/* Send an RPMsg namespace announcement */
+		if (!ret && !vhost_rpmsg_ns_announce(&dsp->vrdev, "sof_rpmsg",
+						     SOF_RPMSG_ADDR_IPC))
+			dsp->active = true;
+	}
+
+	mutex_unlock(&dsp->vrdev.dev.mutex);
+
+	return ret;
+}
+
+/* A guest is powered off or reset */
+static void vhost_dsp_deactivate(struct vhost_dsp *dsp)
+{
+	unsigned int i;
+
+	mutex_lock(&dsp->vrdev.dev.mutex);
+
+	if (dsp->active) {
+		struct vhost_virtqueue *vq;
+
+		dsp->active = false;
+
+		/* If a VM reboots sof_vhost_client_release() isn't called */
+		sof_vhost_topology_purge(dsp->snd);
+
+		/* signal, that we're inactive */
+		for (i = 0, vq = dsp->vrdev.vq;
+		     i < ARRAY_SIZE(dsp->vrdev.vq);
+		     i++, vq++) {
+			mutex_lock(&vq->mutex);
+			vq->private_data = NULL;
+			mutex_unlock(&vq->mutex);
+		}
+	}
+
+	mutex_unlock(&dsp->vrdev.dev.mutex);
+}
+
+/* No special features at the moment */
+static int vhost_dsp_set_features(struct vhost_dsp *dsp, u64 features)
+{
+	struct vhost_virtqueue *vq;
+	unsigned int i;
+
+	if (features & ~VHOST_DSP_FEATURES)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&dsp->vrdev.dev.mutex);
+
+	if ((features & (1 << VHOST_F_LOG_ALL)) &&
+	    !vhost_log_access_ok(&dsp->vrdev.dev)) {
+		mutex_unlock(&dsp->vrdev.dev.mutex);
+		return -EFAULT;
+	}
+
+	for (i = 0, vq = dsp->vrdev.vq;
+	     i < ARRAY_SIZE(dsp->vrdev.vq);
+	     i++, vq++) {
+		mutex_lock(&vq->mutex);
+		vq->acked_features = features;
+		mutex_unlock(&vq->mutex);
+	}
+
+	mutex_unlock(&dsp->vrdev.dev.mutex);
+
+	return 0;
+}
+
+/* .ioctl(): we only use VHOST_SET_RUNNING in a non-default way */
+static long vhost_dsp_ioctl(struct file *filp, unsigned int ioctl,
+			    unsigned long arg)
+{
+	struct vhost_dsp *dsp = filp->private_data;
+	void __user *argp = (void __user *)arg;
+	struct vhost_adsp_topology tplg;
+	u64 __user *featurep = argp;
+	u64 features;
+	int start;
+	long ret;
+
+	switch (ioctl) {
+	case VHOST_GET_FEATURES:
+		features = VHOST_DSP_FEATURES;
+		if (copy_to_user(featurep, &features, sizeof(features)))
+			return -EFAULT;
+		return 0;
+	case VHOST_SET_FEATURES:
+		if (copy_from_user(&features, featurep, sizeof(features)))
+			return -EFAULT;
+		return vhost_dsp_set_features(dsp, features);
+	case VHOST_GET_BACKEND_FEATURES:
+		features = 0;
+		if (copy_to_user(featurep, &features, sizeof(features)))
+			return -EFAULT;
+		return 0;
+	case VHOST_SET_BACKEND_FEATURES:
+		if (copy_from_user(&features, featurep, sizeof(features)))
+			return -EFAULT;
+		if (features)
+			return -EOPNOTSUPP;
+		return 0;
+	case VHOST_RESET_OWNER:
+		mutex_lock(&dsp->vrdev.dev.mutex);
+		ret = vhost_dev_check_owner(&dsp->vrdev.dev);
+		if (!ret) {
+			struct vhost_umem *umem =
+				vhost_dev_reset_owner_prepare();
+			if (!umem) {
+				ret = -ENOMEM;
+			} else {
+				vhost_dev_stop(&dsp->vrdev.dev);
+				vhost_dev_reset_owner(&dsp->vrdev.dev, umem);
+			}
+		}
+		mutex_unlock(&dsp->vrdev.dev.mutex);
+		return ret;
+	case VHOST_SET_OWNER:
+		mutex_lock(&dsp->vrdev.dev.mutex);
+		ret = vhost_dev_set_owner(&dsp->vrdev.dev);
+		mutex_unlock(&dsp->vrdev.dev.mutex);
+		return ret;
+	case VHOST_SET_RUNNING:
+		if (copy_from_user(&start, argp, sizeof(start)))
+			return -EFAULT;
+
+		if (start)
+			return vhost_dsp_activate(dsp);
+
+		vhost_dsp_deactivate(dsp);
+		return 0;
+	case VHOST_ADSP_SET_GUEST_TPLG:
+		if (copy_from_user(&tplg, argp, sizeof(tplg)))
+			return -EFAULT;
+		return sof_vhost_set_tplg(dsp->snd, &tplg);
+	}
+
+	mutex_lock(&dsp->vrdev.dev.mutex);
+	ret = vhost_dev_ioctl(&dsp->vrdev.dev, ioctl, argp);
+	if (ret == -ENOIOCTLCMD)
+		ret = vhost_vring_ioctl(&dsp->vrdev.dev, ioctl, argp);
+	mutex_unlock(&dsp->vrdev.dev.mutex);
+
+	return ret;
+}
+
+#ifdef CONFIG_COMPAT
+static long vhost_dsp_compat_ioctl(struct file *filp, unsigned int ioctl,
+				   unsigned long arg)
+{
+	return vhost_dsp_ioctl(filp, ioctl, (unsigned long)compat_ptr(arg));
+}
+#endif
+
+static ssize_t vhost_dsp_chr_read_iter(struct kiocb *iocb, struct iov_iter *to)
+{
+	struct file *filp = iocb->ki_filp;
+	struct vhost_dsp *dsp = filp->private_data;
+	struct vhost_dev *dev = &dsp->vrdev.dev;
+	int noblock = filp->f_flags & O_NONBLOCK;
+
+	return vhost_chr_read_iter(dev, to, noblock);
+}
+
+static ssize_t vhost_dsp_chr_write_iter(struct kiocb *iocb,
+					struct iov_iter *from)
+{
+	struct file *filp = iocb->ki_filp;
+	struct vhost_dsp *dsp = filp->private_data;
+	struct vhost_dev *dev = &dsp->vrdev.dev;
+
+	return vhost_chr_write_iter(dev, from);
+}
+
+static __poll_t vhost_dsp_chr_poll(struct file *filp, poll_table *wait)
+{
+	struct vhost_dsp *dsp = filp->private_data;
+	struct vhost_dev *dev = &dsp->vrdev.dev;
+
+	return vhost_chr_poll(filp, dev, wait);
+}
+
+static ssize_t vhost_dsp_data_read(struct vhost_rpmsg *vr,
+				   struct vhost_rpmsg_iter *iter)
+{
+	struct vhost_dsp *dsp = container_of(vr, struct vhost_dsp, vrdev);
+	struct vhost_virtqueue *vq = iter->vq;
+	struct sof_rpmsg_data_resp *resp = &dsp->data_resp;
+	struct sof_rpmsg_data_req req;
+	size_t len = vhost_rpmsg_iter_len(iter);
+	size_t nbytes;
+
+	if (len < sizeof(req)) {
+		vq_err(vq, "%s(): data count %zu too small\n",
+		       __func__, len);
+		return -EINVAL;
+	}
+
+	/* copy_{to,from}_iter() can be called repeatedly to continue copying */
+	nbytes = vhost_rpmsg_copy(vr, iter, &req, sizeof(req));
+	if (nbytes != sizeof(req)) {
+		vq_err(vq,
+		       "%s(): got %zu instead of %zu bytes of data header\n",
+		       __func__, nbytes, sizeof(req));
+		return -EIO;
+	}
+
+	len -= nbytes;
+
+	/* Get a pointer to copy data to or from the audio buffer */
+	iter->priv = sof_vhost_stream_data(dsp->snd, &req, resp);
+	if (IS_ERR(iter->priv)) {
+		vq_err(vq, "%s(): error %ld getting data pointer\n",
+		       __func__, PTR_ERR(iter->priv));
+		return PTR_ERR(iter->priv);
+	}
+
+	if (len) {
+		/* Data in the buffer: playback */
+		if (len != req.size) {
+			vq_err(vq,
+			       "%s(): inconsistent data count: %zu vs. %u bytes\n",
+			       __func__, len, req.size);
+			return -EPROTO;
+		}
+
+		nbytes = vhost_rpmsg_copy(vr, iter, iter->priv, len);
+		if (nbytes != len) {
+			vq_err(vq,
+			       "%s(): copied %zu instead of %zu bytes of data\n",
+			       __func__, nbytes, len);
+			return -EIO;
+		}
+
+		return sizeof(*resp);
+	}
+
+	return sizeof(*resp) + resp->size;
+}
+
+static ssize_t vhost_dsp_data_write(struct vhost_rpmsg *vr,
+				    struct vhost_rpmsg_iter *iter)
+{
+	struct vhost_dsp *dsp = container_of(vr, struct vhost_dsp, vrdev);
+	struct vhost_virtqueue *vq = iter->vq;
+	struct sof_rpmsg_data_resp *resp = &dsp->data_resp;
+	size_t len = vhost_rpmsg_iter_len(iter);
+	size_t nbytes;
+
+	if (len < sizeof(*resp)) {
+		vq_err(vq,
+		       "%s(): %zu bytes aren't enough for %zu bytes of header\n",
+		       __func__, len, sizeof(*resp));
+		return -ENOBUFS;
+	}
+
+	nbytes = vhost_rpmsg_copy(vr, iter, resp, sizeof(*resp));
+	if (nbytes != sizeof(*resp)) {
+		vq_err(vq,
+		       "%s(): copied %zu instead of %zu bytes of data\n",
+		       __func__, nbytes, sizeof(*resp));
+		return -EIO;
+	}
+
+	if (resp->size && !resp->error) {
+		/* Capture */
+		len -= sizeof(*resp);
+
+		if (len < resp->size) {
+			vq_err(vq,
+			       "%s(): insufficient buffer space %zu for %u bytes\n",
+			       __func__, len, resp->size);
+			return -EPROTO;
+		}
+
+		nbytes = vhost_rpmsg_copy(vr, iter, iter->priv, resp->size);
+		if (nbytes != resp->size) {
+			vq_err(vq,
+			       "%s(): copied %zu instead of %u bytes of data\n",
+			       __func__, nbytes, resp->size);
+			return -EIO;
+		}
+	}
+
+	return 0;
+}
+
+static ssize_t vhost_dsp_ipc_read(struct vhost_rpmsg *vr,
+				  struct vhost_rpmsg_iter *iter)
+{
+	struct vhost_dsp *dsp = container_of(vr, struct vhost_dsp, vrdev);
+	struct vhost_virtqueue *vq = iter->vq;
+	size_t len = vhost_rpmsg_iter_len(iter);
+	size_t nbytes;
+	int ret;
+
+	if (len > sizeof(dsp->ipc_buf)) {
+		vq_err(vq, "%s(): data count %zu too large\n",
+		       __func__, len);
+		return -ENOBUFS;
+	}
+
+	if (len < sizeof(struct sof_ipc_cmd_hdr)) {
+		vq_err(vq, "%s(): data count %zu too small\n",
+		       __func__, len);
+		return -EINVAL;
+	}
+
+	nbytes = vhost_rpmsg_copy(vr, iter, &dsp->ipc_buf, len);
+	if (nbytes != len) {
+		vq_err(vq, "Expected %zu bytes for IPC, got %zu bytes\n",
+		       len, nbytes);
+		return -EIO;
+	}
+
+	/* Process the IPC payload */
+	ret = sof_vhost_ipc_fwd(dsp->snd, dsp->ipc_buf.ipc_msg,
+				dsp->reply_buf, len -
+				offsetof(struct sof_rpmsg_ipc_req, ipc_msg),
+				dsp->ipc_buf.reply_size);
+	if (ret < 0) {
+		struct sof_ipc_cmd_hdr *cmd_hdr =
+			(struct sof_ipc_cmd_hdr *)dsp->ipc_buf.ipc_msg;
+		vq_err(vq, "%s(): IPC 0x%x failed with error %d\n",
+		       __func__, cmd_hdr->cmd, ret);
+		/* continue to send an error response */
+	}
+
+	return ((struct sof_ipc_reply *)dsp->reply_buf)->hdr.size;
+}
+
+static ssize_t vhost_dsp_ipc_write(struct vhost_rpmsg *vr,
+				   struct vhost_rpmsg_iter *iter)
+{
+	struct vhost_dsp *dsp = container_of(vr, struct vhost_dsp, vrdev);
+
+	return vhost_rpmsg_copy(vr, iter, dsp->reply_buf,
+				vhost_rpmsg_iter_len(iter)) ==
+		vhost_rpmsg_iter_len(iter) ? 0 : -EIO;
+}
+
+/* Called only once to get guest's position update endpoint address */
+static ssize_t vhost_dsp_posn_read(struct vhost_rpmsg *vr,
+				   struct vhost_rpmsg_iter *iter)
+{
+	struct vhost_dsp *dsp = container_of(vr, struct vhost_dsp, vrdev);
+	struct vhost_virtqueue *vq = &dsp->vrdev.vq[VIRTIO_RPMSG_REQUEST];
+	size_t len = vhost_rpmsg_iter_len(iter);
+	size_t nbytes;
+
+	if ((int)dsp->posn_addr >= 0) {
+		vq_err(vq, "%s(): position queue address %u already set\n",
+		       __func__, dsp->posn_addr);
+		return -EINVAL;
+	}
+
+	if (len != sizeof(dsp->posn_addr)) {
+		vq_err(vq, "%s(): data count %zu invalid\n",
+		       __func__, len);
+		return -EINVAL;
+	}
+
+	nbytes = vhost_rpmsg_copy(vr, iter, &dsp->posn_addr,
+				  sizeof(dsp->posn_addr));
+	if (nbytes != sizeof(dsp->posn_addr)) {
+		vq_err(vq,
+		       "%s(): got %zu instead of %zu bytes position update\n",
+		       __func__, nbytes, sizeof(dsp->posn_addr));
+		return -EIO;
+	}
+
+	pr_debug("%s(): guest position endpoint address 0x%x\n", __func__,
+		 dsp->posn_addr);
+
+	return 0;
+}
+
+static void vhost_dsp_send_posn(struct vhost_work *work)
+{
+	struct vhost_dsp *dsp = container_of(work, struct vhost_dsp, posn_work);
+	struct vhost_rpmsg_iter iter = VHOST_RPMSG_ITER(SOF_RPMSG_ADDR_POSN,
+							dsp->posn_addr);
+	ssize_t nbytes;
+	int ret;
+
+	ret = vhost_rpmsg_start_lock(&dsp->vrdev, &iter, VIRTIO_RPMSG_RESPONSE,
+				     sizeof(dsp->posn));
+	if (ret < 0)
+		return;
+
+	nbytes = vhost_rpmsg_copy(&dsp->vrdev, &iter, &dsp->posn,
+				  sizeof(dsp->posn));
+	if (nbytes != sizeof(dsp->posn))
+		vq_err(iter.vq, "%s(): added %zd instead of %zu bytes\n",
+		       __func__, nbytes, sizeof(dsp->posn));
+
+	ret = vhost_rpmsg_finish_unlock(&dsp->vrdev, &iter);
+}
+
+static const struct vhost_rpmsg_ept vhost_dsp_ept[] = {
+	{
+		.addr = SOF_RPMSG_ADDR_IPC,
+		.read = vhost_dsp_ipc_read,
+		.write = vhost_dsp_ipc_write,
+	}, {
+		.addr = SOF_RPMSG_ADDR_POSN,
+		.read = vhost_dsp_posn_read,
+		.write = NULL, /* position updates are sent from a work-queue */
+	}, {
+		.addr = SOF_RPMSG_ADDR_DATA,
+		.read = vhost_dsp_data_read,
+		.write = vhost_dsp_data_write,
+	}
+};
+
+static int vhost_dsp_open(struct inode *inode, struct file *filp)
+{
+	struct miscdevice *misc = filp->private_data;
+	struct snd_sof_dev *sdev = dev_get_drvdata(misc->parent);
+	struct vhost_dsp *dsp = kmalloc(sizeof(*dsp), GFP_KERNEL);
+
+	if (!dsp)
+		return -ENOMEM;
+
+	dsp->vrdev.dev.mm = NULL;
+	dsp->snd = sof_vhost_client_add(sdev, dsp);
+	if (!dsp->snd) {
+		kfree(dsp);
+		return -ENOMEM;
+	}
+
+	/*
+	 * TODO: do we ever want to support multiple guest machines per DSP, if
+	 * not, we might as well perform all allocations when registering the
+	 * misc device.
+	 */
+	dsp->active = false;
+	dsp->posn_addr = -EINVAL;
+	dsp->posn.rhdr.error = -ENODATA;
+
+	vhost_rpmsg_init(&dsp->vrdev, vhost_dsp_ept, ARRAY_SIZE(vhost_dsp_ept));
+	vhost_work_init(&dsp->posn_work, vhost_dsp_send_posn);
+
+	/* Overwrite file private data */
+	filp->private_data = dsp;
+
+	return 0;
+}
+
+/*
+ * The device is closed by QEMU when the client driver is unloaded or the guest
+ * is shut down
+ */
+static int vhost_dsp_release(struct inode *inode, struct file *filp)
+{
+	struct vhost_dsp *dsp = filp->private_data;
+
+	vhost_work_flush(&dsp->vrdev.dev, &dsp->posn_work);
+
+	vhost_rpmsg_destroy(&dsp->vrdev);
+
+	sof_vhost_client_release(dsp->snd);
+
+	kfree(dsp);
+
+	return 0;
+}
+
+static const struct file_operations vhost_dsp_fops = {
+	.owner          = THIS_MODULE,
+	.release        = vhost_dsp_release,
+	.read_iter      = vhost_dsp_chr_read_iter,
+	.write_iter     = vhost_dsp_chr_write_iter,
+	.poll           = vhost_dsp_chr_poll,
+	.unlocked_ioctl = vhost_dsp_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl   = vhost_dsp_compat_ioctl,
+#endif
+	.open           = vhost_dsp_open,
+	.llseek		= noop_llseek,
+};
+
+static struct miscdevice vhost_dsp_misc = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = "vhost-dsp",
+	.fops = &vhost_dsp_fops,
+};
+
+/* Always called from an interrupt thread context */
+static int vhost_dsp_update_posn(struct vhost_dsp *dsp,
+				 struct sof_ipc_stream_posn *posn)
+{
+	struct vhost_virtqueue *vq = &dsp->vrdev.vq[VIRTIO_RPMSG_RESPONSE];
+	int ret;
+
+	if (!dsp->active)
+		return 0;
+
+	memcpy(&dsp->posn, posn, sizeof(dsp->posn));
+
+	mutex_lock(&vq->mutex);
+
+	/*
+	 * VirtQueues can only be processed in the context of the VMM process or
+	 * a vhost work queue
+	 */
+	vhost_work_queue(&dsp->vrdev.dev, &dsp->posn_work);
+
+	mutex_unlock(&vq->mutex);
+
+	return ret;
+}
+
+static struct sof_vhost_ops vhost_dsp_ops = {
+	.update_posn = vhost_dsp_update_posn,
+};
+
+static int __init vhost_dsp_init(void)
+{
+	vhost_dsp_misc.parent = sof_vhost_dev_init(&vhost_dsp_ops);
+	if (!vhost_dsp_misc.parent)
+		return -ENODEV;
+
+	return misc_register(&vhost_dsp_misc);
+}
+
+static void __exit vhost_dsp_exit(void)
+{
+	misc_deregister(&vhost_dsp_misc);
+}
+
+module_init(vhost_dsp_init);
+module_exit(vhost_dsp_exit);
+
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_AUTHOR("Guennadi Liakhovetski");
+MODULE_DESCRIPTION("Host kernel accelerator for virtio sound");
-- 
1.9.3

