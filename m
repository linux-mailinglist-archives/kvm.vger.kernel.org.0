Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C288C229B08
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 17:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732646AbgGVPJo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 11:09:44 -0400
Received: from mga14.intel.com ([192.55.52.115]:33994 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732515AbgGVPJo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 11:09:44 -0400
IronPort-SDR: +yG8gRp7JzbpN9Q9yUJTDJJPnwKGhHb3MiDuTzJ0JeGyOWc8yuBEJ3wrLz56u5/9KhEuj7ugBd
 Y3tmCkq753EA==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="149513632"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="149513632"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 08:09:43 -0700
IronPort-SDR: QstIaZ9Fuk8wxOdNJbtkU3EPIYrBDOplKOpkmKvvMKsqLiSfq0eHCWKELI94F4HMl9oBCO4ka0
 QJ3ntCK9bKBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="432407346"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu.ger.corp.intel.com) ([10.252.58.190])
  by orsmga004.jf.intel.com with ESMTP; 22 Jul 2020 08:09:40 -0700
From:   Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: [PATCH v4 4/4] vhost: add an RPMsg API
Date:   Wed, 22 Jul 2020 17:09:27 +0200
Message-Id: <20200722150927.15587-5-guennadi.liakhovetski@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200722150927.15587-1-guennadi.liakhovetski@linux.intel.com>
References: <20200722150927.15587-1-guennadi.liakhovetski@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linux supports running the RPMsg protocol over the VirtIO transport
protocol, but currently there is only support for VirtIO clients and
no support for a VirtIO server. This patch adds a vhost-based RPMsg
server implementation.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
---
 drivers/vhost/Kconfig       |   7 +
 drivers/vhost/Makefile      |   3 +
 drivers/vhost/rpmsg.c       | 375 ++++++++++++++++++++++++++++++++++++
 drivers/vhost/vhost_rpmsg.h |  74 +++++++
 4 files changed, 459 insertions(+)
 create mode 100644 drivers/vhost/rpmsg.c
 create mode 100644 drivers/vhost/vhost_rpmsg.h

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index d3688c6afb87..602421bf1d03 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -38,6 +38,13 @@ config VHOST_NET
 	  To compile this driver as a module, choose M here: the module will
 	  be called vhost_net.
 
+config VHOST_RPMSG
+	tristate
+	depends on VHOST
+	help
+	  Vhost RPMsg API allows vhost drivers to communicate with VirtIO
+	  drivers, using the RPMsg over VirtIO protocol.
+
 config VHOST_SCSI
 	tristate "VHOST_SCSI TCM fabric driver"
 	depends on TARGET_CORE && EVENTFD
diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
index f3e1897cce85..9cf459d59f97 100644
--- a/drivers/vhost/Makefile
+++ b/drivers/vhost/Makefile
@@ -2,6 +2,9 @@
 obj-$(CONFIG_VHOST_NET) += vhost_net.o
 vhost_net-y := net.o
 
+obj-$(CONFIG_VHOST_RPMSG) += vhost_rpmsg.o
+vhost_rpmsg-y := rpmsg.o
+
 obj-$(CONFIG_VHOST_SCSI) += vhost_scsi.o
 vhost_scsi-y := scsi.o
 
diff --git a/drivers/vhost/rpmsg.c b/drivers/vhost/rpmsg.c
new file mode 100644
index 000000000000..d7ab48414224
--- /dev/null
+++ b/drivers/vhost/rpmsg.c
@@ -0,0 +1,375 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright(c) 2020 Intel Corporation. All rights reserved.
+ *
+ * Author: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
+ *
+ * Vhost RPMsg VirtIO interface. It provides a set of functions to match the
+ * guest side RPMsg VirtIO API, provided by drivers/rpmsg/virtio_rpmsg_bus.c
+ * These functions handle creation of 2 virtual queues, handling of endpoint
+ * addresses, sending a name-space announcement to the guest as well as any
+ * user messages. This API can be used by any vhost driver to handle RPMsg
+ * specific processing.
+ * Specific vhost drivers, using this API will use their own VirtIO device
+ * IDs, that should then also be added to the ID table in virtio_rpmsg_bus.c
+ */
+
+#include <linux/compat.h>
+#include <linux/file.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/vhost.h>
+#include <linux/virtio_rpmsg.h>
+#include <uapi/linux/rpmsg.h>
+
+#include "vhost.h"
+#include "vhost_rpmsg.h"
+
+/*
+ * All virtio-rpmsg virtual queue kicks always come with just one buffer -
+ * either input or output
+ */
+static int vhost_rpmsg_get_single(struct vhost_virtqueue *vq)
+{
+	struct vhost_rpmsg *vr = container_of(vq->dev, struct vhost_rpmsg, dev);
+	unsigned int out, in;
+	int head = vhost_get_vq_desc(vq, vq->iov, ARRAY_SIZE(vq->iov), &out, &in,
+				     NULL, NULL);
+	if (head < 0) {
+		vq_err(vq, "%s(): error %d getting buffer\n",
+		       __func__, head);
+		return head;
+	}
+
+	/* Nothing new? */
+	if (head == vq->num)
+		return head;
+
+	if (vq == &vr->vq[VIRTIO_RPMSG_RESPONSE] && (out || in != 1)) {
+		vq_err(vq,
+		       "%s(): invalid %d input and %d output in response queue\n",
+		       __func__, in, out);
+		goto return_buf;
+	}
+
+	if (vq == &vr->vq[VIRTIO_RPMSG_REQUEST] && (in || out != 1)) {
+		vq_err(vq,
+		       "%s(): invalid %d input and %d output in request queue\n",
+		       __func__, in, out);
+		goto return_buf;
+	}
+
+	return head;
+
+return_buf:
+	/*
+	 * FIXME: might need to return the buffer using vhost_add_used()
+	 * or vhost_discard_vq_desc(). vhost_discard_vq_desc() is
+	 * described as "being useful for error handling," but it makes
+	 * the thus discarded buffers "unseen," so next time we look we
+	 * retrieve them again?
+	 */
+	return -EINVAL;
+}
+
+static const struct vhost_rpmsg_ept *vhost_rpmsg_ept_find(struct vhost_rpmsg *vr, int addr)
+{
+	unsigned int i;
+
+	for (i = 0; i < vr->n_epts; i++)
+		if (vr->ept[i].addr == addr)
+			return vr->ept + i;
+
+	return NULL;
+}
+
+/*
+ * if len < 0, then for reading a request, the complete virtual queue buffer
+ * size is prepared, for sending a response, the length in the iterator is used
+ */
+int vhost_rpmsg_start_lock(struct vhost_rpmsg *vr, struct vhost_rpmsg_iter *iter,
+			   unsigned int qid, ssize_t len)
+	__acquires(vq->mutex)
+{
+	struct vhost_virtqueue *vq = vr->vq + qid;
+	size_t tmp;
+
+	if (qid >= VIRTIO_RPMSG_NUM_OF_VQS)
+		return -EINVAL;
+
+	iter->vq = vq;
+
+	mutex_lock(&vq->mutex);
+	vhost_disable_notify(&vr->dev, vq);
+
+	iter->head = vhost_rpmsg_get_single(vq);
+	if (iter->head == vq->num)
+		iter->head = -EAGAIN;
+
+	if (iter->head < 0)
+		goto unlock;
+
+	tmp = vq->iov[0].iov_len;
+	if (tmp < sizeof(iter->rhdr)) {
+		vq_err(vq, "%s(): size %zu too small\n", __func__, tmp);
+		iter->head = -ENOBUFS;
+		goto return_buf;
+	}
+
+	switch (qid) {
+	case VIRTIO_RPMSG_REQUEST:
+		if (len < 0) {
+			len = tmp - sizeof(iter->rhdr);
+		} else if (tmp < sizeof(iter->rhdr) + len) {
+			iter->head = -ENOBUFS;
+			goto return_buf;
+		}
+
+		/* len is now the size of the payload */
+		iov_iter_init(&iter->iov_iter, WRITE,
+			      vq->iov, 1, sizeof(iter->rhdr) + len);
+
+		/* Read the RPMSG header with endpoint addresses */
+		tmp = copy_from_iter(&iter->rhdr, sizeof(iter->rhdr), &iter->iov_iter);
+		if (tmp != sizeof(iter->rhdr)) {
+			vq_err(vq, "%s(): got %zu instead of %zu\n", __func__,
+			       tmp, sizeof(iter->rhdr));
+			iter->head = -EIO;
+			goto return_buf;
+		}
+
+		iter->ept = vhost_rpmsg_ept_find(vr, vhost32_to_cpu(vq, iter->rhdr.dst));
+		if (!iter->ept) {
+			vq_err(vq, "%s(): no endpoint with address %d\n",
+			       __func__, vhost32_to_cpu(vq, iter->rhdr.dst));
+			iter->head = -ENOENT;
+			goto return_buf;
+		}
+
+		/* Let the endpoint read the payload */
+		if (iter->ept->read) {
+			ssize_t ret = iter->ept->read(vr, iter);
+
+			if (ret < 0) {
+				iter->head = ret;
+				goto return_buf;
+			}
+
+			iter->rhdr.len = cpu_to_vhost16(vq, ret);
+		} else {
+			iter->rhdr.len = 0;
+		}
+
+		/* Prepare for the response phase */
+		iter->rhdr.dst = iter->rhdr.src;
+		iter->rhdr.src = cpu_to_vhost32(vq, iter->ept->addr);
+
+		break;
+	case VIRTIO_RPMSG_RESPONSE:
+		if (!iter->ept && iter->rhdr.dst != cpu_to_vhost32(vq, RPMSG_NS_ADDR)) {
+			/*
+			 * Usually the iterator is configured when processing a
+			 * message on the request queue, but it's also possible
+			 * to send a message on the response queue without a
+			 * preceding request, in that case the iterator must
+			 * contain source and destination addresses.
+			 */
+			iter->ept = vhost_rpmsg_ept_find(vr, vhost32_to_cpu(vq, iter->rhdr.src));
+			if (!iter->ept) {
+				iter->head = -ENOENT;
+				goto return_buf;
+			}
+		}
+
+		if (len < 0) {
+			len = tmp - sizeof(iter->rhdr);
+		} else if (tmp < sizeof(iter->rhdr) + len) {
+			iter->head = -ENOBUFS;
+			goto return_buf;
+		} else {
+			iter->rhdr.len = cpu_to_vhost16(vq, len);
+		}
+
+		/* len is now the size of the payload */
+		iov_iter_init(&iter->iov_iter, READ, vq->iov, 1, sizeof(iter->rhdr) + len);
+
+		/* Write the RPMSG header with endpoint addresses */
+		tmp = copy_to_iter(&iter->rhdr, sizeof(iter->rhdr), &iter->iov_iter);
+		if (tmp != sizeof(iter->rhdr)) {
+			iter->head = -EIO;
+			goto return_buf;
+		}
+
+		/* Let the endpoint write the payload */
+		if (iter->ept && iter->ept->write) {
+			ssize_t ret = iter->ept->write(vr, iter);
+
+			if (ret < 0) {
+				iter->head = ret;
+				goto return_buf;
+			}
+		}
+
+		break;
+	}
+
+	return 0;
+
+return_buf:
+	/*
+	 * FIXME: vhost_discard_vq_desc() or vhost_add_used(), see comment in
+	 * vhost_rpmsg_get_single()
+	 */
+unlock:
+	vhost_enable_notify(&vr->dev, vq);
+	mutex_unlock(&vq->mutex);
+
+	return iter->head;
+}
+EXPORT_SYMBOL_GPL(vhost_rpmsg_start_lock);
+
+size_t vhost_rpmsg_copy(struct vhost_rpmsg *vr, struct vhost_rpmsg_iter *iter,
+			void *data, size_t size)
+{
+	/*
+	 * We could check for excess data, but copy_{to,from}_iter() don't do
+	 * that either
+	 */
+	if (iter->vq == vr->vq + VIRTIO_RPMSG_RESPONSE)
+		return copy_to_iter(data, size, &iter->iov_iter);
+
+	return copy_from_iter(data, size, &iter->iov_iter);
+}
+EXPORT_SYMBOL_GPL(vhost_rpmsg_copy);
+
+int vhost_rpmsg_finish_unlock(struct vhost_rpmsg *vr,
+			      struct vhost_rpmsg_iter *iter)
+	__releases(vq->mutex)
+{
+	if (iter->head >= 0)
+		vhost_add_used_and_signal(iter->vq->dev, iter->vq, iter->head,
+					  vhost16_to_cpu(iter->vq, iter->rhdr.len) +
+					  sizeof(iter->rhdr));
+
+	vhost_enable_notify(&vr->dev, iter->vq);
+	mutex_unlock(&iter->vq->mutex);
+
+	return iter->head;
+}
+EXPORT_SYMBOL_GPL(vhost_rpmsg_finish_unlock);
+
+/*
+ * Return false to terminate the external loop only if we fail to obtain either
+ * a request or a response buffer
+ */
+static bool handle_rpmsg_req_single(struct vhost_rpmsg *vr,
+				    struct vhost_virtqueue *vq)
+{
+	struct vhost_rpmsg_iter iter;
+	int ret = vhost_rpmsg_start_lock(vr, &iter, VIRTIO_RPMSG_REQUEST, -EINVAL);
+	if (!ret)
+		ret = vhost_rpmsg_finish_unlock(vr, &iter);
+	if (ret < 0) {
+		if (ret != -EAGAIN)
+			vq_err(vq, "%s(): RPMSG processing failed %d\n",
+			       __func__, ret);
+		return false;
+	}
+
+	if (!iter.ept->write)
+		return true;
+
+	ret = vhost_rpmsg_start_lock(vr, &iter, VIRTIO_RPMSG_RESPONSE, -EINVAL);
+	if (!ret)
+		ret = vhost_rpmsg_finish_unlock(vr, &iter);
+	if (ret < 0) {
+		vq_err(vq, "%s(): RPMSG finalising failed %d\n", __func__, ret);
+		return false;
+	}
+
+	return true;
+}
+
+static void handle_rpmsg_req_kick(struct vhost_work *work)
+{
+	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
+						  poll.work);
+	struct vhost_rpmsg *vr = container_of(vq->dev, struct vhost_rpmsg, dev);
+
+	while (handle_rpmsg_req_single(vr, vq))
+		;
+}
+
+/*
+ * initialise two virtqueues with an array of endpoints,
+ * request and response callbacks
+ */
+void vhost_rpmsg_init(struct vhost_rpmsg *vr, const struct vhost_rpmsg_ept *ept,
+		      unsigned int n_epts)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(vr->vq); i++)
+		vr->vq_p[i] = &vr->vq[i];
+
+	/* vq[0]: host -> guest, vq[1]: host <- guest */
+	vr->vq[VIRTIO_RPMSG_REQUEST].handle_kick = handle_rpmsg_req_kick;
+	vr->vq[VIRTIO_RPMSG_RESPONSE].handle_kick = NULL;
+
+	vr->ept = ept;
+	vr->n_epts = n_epts;
+
+	vhost_dev_init(&vr->dev, vr->vq_p, VIRTIO_RPMSG_NUM_OF_VQS,
+		       UIO_MAXIOV, 0, 0, true, NULL);
+}
+EXPORT_SYMBOL_GPL(vhost_rpmsg_init);
+
+void vhost_rpmsg_destroy(struct vhost_rpmsg *vr)
+{
+	if (vhost_dev_has_owner(&vr->dev))
+		vhost_poll_flush(&vr->vq[VIRTIO_RPMSG_REQUEST].poll);
+
+	vhost_dev_cleanup(&vr->dev);
+}
+EXPORT_SYMBOL_GPL(vhost_rpmsg_destroy);
+
+/* send namespace */
+int vhost_rpmsg_ns_announce(struct vhost_rpmsg *vr, const char *name, unsigned int src)
+{
+	struct vhost_virtqueue *vq = &vr->vq[VIRTIO_RPMSG_RESPONSE];
+	struct vhost_rpmsg_iter iter = {
+		.rhdr = {
+			.src = 0,
+			.dst = cpu_to_vhost32(vq, RPMSG_NS_ADDR),
+			.flags = cpu_to_vhost16(vq, RPMSG_NS_CREATE), /* rpmsg_recv_single() */
+		},
+	};
+	struct rpmsg_ns_msg ns = {
+		.addr = cpu_to_vhost32(vq, src),
+		.flags = cpu_to_vhost32(vq, RPMSG_NS_CREATE), /* for rpmsg_ns_cb() */
+	};
+	int ret = vhost_rpmsg_start_lock(vr, &iter, VIRTIO_RPMSG_RESPONSE, sizeof(ns));
+
+	if (ret < 0)
+		return ret;
+
+	strlcpy(ns.name, name, sizeof(ns.name));
+
+	ret = vhost_rpmsg_copy(vr, &iter, &ns, sizeof(ns));
+	if (ret != sizeof(ns))
+		vq_err(iter.vq, "%s(): added %d instead of %zu bytes\n",
+		       __func__, ret, sizeof(ns));
+
+	ret = vhost_rpmsg_finish_unlock(vr, &iter);
+	if (ret < 0)
+		vq_err(iter.vq, "%s(): namespace announcement failed: %d\n",
+		       __func__, ret);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vhost_rpmsg_ns_announce);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Intel, Inc.");
+MODULE_DESCRIPTION("Vhost RPMsg API");
diff --git a/drivers/vhost/vhost_rpmsg.h b/drivers/vhost/vhost_rpmsg.h
new file mode 100644
index 000000000000..30072cecb8a0
--- /dev/null
+++ b/drivers/vhost/vhost_rpmsg.h
@@ -0,0 +1,74 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright(c) 2020 Intel Corporation. All rights reserved.
+ *
+ * Author: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
+ */
+
+#ifndef VHOST_RPMSG_H
+#define VHOST_RPMSG_H
+
+#include <linux/uio.h>
+#include <linux/virtio_rpmsg.h>
+
+#include "vhost.h"
+
+/* RPMsg uses two VirtQueues: one for each direction */
+enum {
+	VIRTIO_RPMSG_RESPONSE,	/* RPMsg response (host->guest) buffers */
+	VIRTIO_RPMSG_REQUEST,	/* RPMsg request (guest->host) buffers */
+	/* Keep last */
+	VIRTIO_RPMSG_NUM_OF_VQS,
+};
+
+struct vhost_rpmsg_ept;
+
+struct vhost_rpmsg_iter {
+	struct iov_iter iov_iter;
+	struct rpmsg_hdr rhdr;
+	struct vhost_virtqueue *vq;
+	const struct vhost_rpmsg_ept *ept;
+	int head;
+	void *priv;
+};
+
+struct vhost_rpmsg {
+	struct vhost_dev dev;
+	struct vhost_virtqueue vq[VIRTIO_RPMSG_NUM_OF_VQS];
+	struct vhost_virtqueue *vq_p[VIRTIO_RPMSG_NUM_OF_VQS];
+	const struct vhost_rpmsg_ept *ept;
+	unsigned int n_epts;
+};
+
+struct vhost_rpmsg_ept {
+	ssize_t (*read)(struct vhost_rpmsg *, struct vhost_rpmsg_iter *);
+	ssize_t (*write)(struct vhost_rpmsg *, struct vhost_rpmsg_iter *);
+	int addr;
+};
+
+static inline size_t vhost_rpmsg_iter_len(const struct vhost_rpmsg_iter *iter)
+{
+	return iter->rhdr.len;
+}
+
+#define VHOST_RPMSG_ITER(_vq, _src, _dst) {			\
+	.rhdr = {						\
+			.src = cpu_to_vhost32(_vq, _src),	\
+			.dst = cpu_to_vhost32(_vq, _dst),	\
+		},						\
+	}
+
+void vhost_rpmsg_init(struct vhost_rpmsg *vr, const struct vhost_rpmsg_ept *ept,
+		      unsigned int n_epts);
+void vhost_rpmsg_destroy(struct vhost_rpmsg *vr);
+int vhost_rpmsg_ns_announce(struct vhost_rpmsg *vr, const char *name,
+			    unsigned int src);
+int vhost_rpmsg_start_lock(struct vhost_rpmsg *vr,
+			   struct vhost_rpmsg_iter *iter,
+			   unsigned int qid, ssize_t len);
+size_t vhost_rpmsg_copy(struct vhost_rpmsg *vr, struct vhost_rpmsg_iter *iter,
+			void *data, size_t size);
+int vhost_rpmsg_finish_unlock(struct vhost_rpmsg *vr,
+			      struct vhost_rpmsg_iter *iter);
+
+#endif
-- 
2.27.0

