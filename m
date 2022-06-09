Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8548F5444AC
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 09:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239868AbiFIHVO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 03:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239337AbiFIHVH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 03:21:07 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2464B244176;
        Thu,  9 Jun 2022 00:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1654759262; x=1686295262;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=ReMpO4Gqh7OcNKtXV5JaAMJ364SBlpWr3mqaJQRVpwU=;
  b=sHNlQTAmKxHJlXPMcaGLqjLFYedRbwujratj5c8QmixMZhKs53OEXm3P
   jZdfxtzYnIqHyRkcKDsQc7Ed0QB5f6grVrcSNlje3fNHdomU2i+DuNJG6
   bZ7iiZYUF2xs5bbpbgoODLJmIoHMm0xB4QvDMSHBoJ80sjBhV8pHa++0I
   w=;
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 09 Jun 2022 00:21:01 -0700
X-QCInternal: smtphost
Received: from nasanex01b.na.qualcomm.com ([10.46.141.250])
  by ironmsg03-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 00:21:01 -0700
Received: from localhost (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 9 Jun 2022
 00:21:00 -0700
From:   Neeraj Upadhyay <quic_neeraju@quicinc.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>, <sudeep.holla@arm.com>,
        <cristian.marussi@arm.com>
CC:     <quic_sramana@quicinc.com>, <vincent.guittot@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>
Subject: [RFC 3/3] vhost/scmi: Add Host kernel accelerator for Virtio SCMI
Date:   Thu, 9 Jun 2022 12:49:56 +0530
Message-ID: <20220609071956.5183-4-quic_neeraju@quicinc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220609071956.5183-1-quic_neeraju@quicinc.com>
References: <20220609071956.5183-1-quic_neeraju@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add Vhost implementation for SCMI over Virtio transport.
The SCMI Vhost driver adds a misc device (/dev/vhost-scmi)
that exposes the SCMI Virtio channel capabilities to userspace:

- Set up cmdq, eventq.
- VIRTIO_SCMI_F_P2A_CHANNELS feature is not negotiated, as
  notifications and delayed response are not implemented
  at present.
- VIRTIO_SCMI_F_SHARED_MEMORY feature is not negotiated.

1. cmdq

All cmd requests on cmdq, for a guest are processed sequentially.
So, all outstanding SCMI requests from a guest are processed in order
and response for current request is send before handling next request.
This behavior may change in furture; however, compliance with Virtio
SCMI spec will be ensured. SCMI request/response from different
guests can be handled concurrently.

Each SCMI request is forwarded to the SCMI Virtio backend device, and
the response from SCMI backend is put into the response buffer of the
cmdq entry for that request.

Any error during request handling like failure to read the request
message, results in signalling a response with response length 0
to the frontend. As a future enhancement, we can see the feasibility
of adding capability to frontend, to associate such failures with
outstanding requests and returning error to the upper layers
immediately (rather than waiting for the channel timeout).

2. eventq

As VIRTIO_SCMI_F_P2A_CHANNELS feature is not negotiated.

3. Error handling

On occurrence of any event, which triggers release of SCMI channel,
for a guest - guest VM crash, VMM crash; all inflight SCMI requests
are waited upon; however the outstanding SCMI requests, which
haven't been forwarded to the SCMI backend device, are dropped.

Co-developed-by: Srinivas Ramana <quic_sramana@quicinc.com>
Signed-off-by: Neeraj Upadhyay <quic_neeraju@quicinc.com>
Signed-off-by: Srinivas Ramana <quic_sramana@quicinc.com>
---
 drivers/firmware/arm_scmi/common.h |  14 +
 drivers/firmware/arm_scmi/msg.c    |  11 -
 drivers/firmware/arm_scmi/virtio.c |   3 -
 drivers/vhost/Kconfig              |  10 +
 drivers/vhost/Makefile             |   3 +
 drivers/vhost/scmi.c               | 466 +++++++++++++++++++++++++++++
 include/uapi/linux/vhost.h         |   3 +
 7 files changed, 496 insertions(+), 14 deletions(-)
 create mode 100644 drivers/vhost/scmi.c

diff --git a/drivers/firmware/arm_scmi/common.h b/drivers/firmware/arm_scmi/common.h
index 91cf3ffeb0e8..833575b7f5e2 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -156,6 +156,17 @@ struct scmi_msg {
 	size_t len;
 };
 
+/*
+ * struct scmi_msg_payld - Transport SDU layout
+ *
+ * The SCMI specification requires all parameters, message headers, return
+ * arguments or any protocol data to be expressed in little endian format only.
+ */
+struct scmi_msg_payld {
+	__le32 msg_header;
+	__le32 msg_payload[];
+};
+
 /**
  * struct scmi_xfer - Structure representing a message flow
  *
@@ -483,6 +494,9 @@ struct scmi_msg_payld;
 
 /* Maximum overhead of message w.r.t. struct scmi_desc.max_msg_size */
 #define SCMI_MSG_MAX_PROT_OVERHEAD (2 * sizeof(__le32))
+#define VIRTIO_SCMI_MAX_MSG_SIZE 128 /* Value may be increased. */
+#define VIRTIO_SCMI_MAX_PDU_SIZE \
+	(VIRTIO_SCMI_MAX_MSG_SIZE + SCMI_MSG_MAX_PROT_OVERHEAD)
 
 size_t msg_response_size(struct scmi_xfer *xfer);
 size_t msg_command_size(struct scmi_xfer *xfer);
diff --git a/drivers/firmware/arm_scmi/msg.c b/drivers/firmware/arm_scmi/msg.c
index d33a704e5814..613c0a9c4e63 100644
--- a/drivers/firmware/arm_scmi/msg.c
+++ b/drivers/firmware/arm_scmi/msg.c
@@ -12,17 +12,6 @@
 
 #include "common.h"
 
-/*
- * struct scmi_msg_payld - Transport SDU layout
- *
- * The SCMI specification requires all parameters, message headers, return
- * arguments or any protocol data to be expressed in little endian format only.
- */
-struct scmi_msg_payld {
-	__le32 msg_header;
-	__le32 msg_payload[];
-};
-
 /**
  * msg_command_size() - Actual size of transport SDU for command.
  *
diff --git a/drivers/firmware/arm_scmi/virtio.c b/drivers/firmware/arm_scmi/virtio.c
index 14709dbc96a1..f09100481c80 100644
--- a/drivers/firmware/arm_scmi/virtio.c
+++ b/drivers/firmware/arm_scmi/virtio.c
@@ -30,9 +30,6 @@
 #include "common.h"
 
 #define VIRTIO_MAX_RX_TIMEOUT_MS	60000
-#define VIRTIO_SCMI_MAX_MSG_SIZE 128 /* Value may be increased. */
-#define VIRTIO_SCMI_MAX_PDU_SIZE \
-	(VIRTIO_SCMI_MAX_MSG_SIZE + SCMI_MSG_MAX_PROT_OVERHEAD)
 #define DESCRIPTORS_PER_TX_MSG 2
 
 /**
diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index 587fbae06182..c2e9b0e026c3 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -74,6 +74,16 @@ config VHOST_VDPA
 	  To compile this driver as a module, choose M here: the module
 	  will be called vhost_vdpa.
 
+config VHOST_SCMI
+	tristate "Host kernel accelerator for Virtio SCMI"
+	select VHOST
+	help
+	  This kernel module can be loaded in host kernel to accelerate
+	  guest SCMI over Virtio transport.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called vhost_scmi.
+
 config VHOST_CROSS_ENDIAN_LEGACY
 	bool "Cross-endian support for vhost"
 	default n
diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
index f3e1897cce85..16862ba89cb4 100644
--- a/drivers/vhost/Makefile
+++ b/drivers/vhost/Makefile
@@ -13,6 +13,9 @@ obj-$(CONFIG_VHOST_RING) += vringh.o
 obj-$(CONFIG_VHOST_VDPA) += vhost_vdpa.o
 vhost_vdpa-y := vdpa.o
 
+obj-$(CONFIG_VHOST_SCMI) += vhost_scmi.o
+vhost_scmi-y := scmi.o
+
 obj-$(CONFIG_VHOST)	+= vhost.o
 
 obj-$(CONFIG_VHOST_IOTLB) += vhost_iotlb.o
diff --git a/drivers/vhost/scmi.c b/drivers/vhost/scmi.c
new file mode 100644
index 000000000000..4ed0e6419ab5
--- /dev/null
+++ b/drivers/vhost/scmi.c
@@ -0,0 +1,466 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021 Qualcomm Innovation Center, Inc. All rights reserved.
+ */
+
+#include <linux/eventfd.h>
+#include <linux/vhost.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/mutex.h>
+#include <linux/workqueue.h>
+#include <linux/slab.h>
+#include <linux/sched/signal.h>
+#include <linux/vmalloc.h>
+#include <uapi/linux/virtio_scmi.h>
+#include <linux/scmi_vio_backend.h>
+
+#include "vhost.h"
+#include "../firmware/arm_scmi/common.h"
+#include "../firmware/arm_scmi/virtio_backend/client_handle.h"
+
+enum {
+	VHOST_SCMI_VQ_TX = 0,
+	VHOST_SCMI_VQ_RX = 1,
+	VHOST_SCMI_VQ_NUM = 2,
+};
+
+/*
+ * P2A_CHANNELS and SHARED_MEMORY features are negotiated,
+ * based on whether backend device supports these features/
+ */
+enum {
+	VHOST_SCMI_FEATURES = VHOST_FEATURES,
+};
+
+struct vhost_scmi {
+	struct vhost_dev dev;
+	struct vhost_virtqueue vqs[VHOST_SCMI_VQ_NUM];
+	/* Single request/response msg per VQ */
+	void *req_msg_payld;
+	void *resp_msg_payld;
+	struct scmi_vio_client_h *client_handle;
+	atomic_t release_fe_channels;
+};
+
+static int vhost_scmi_handle_request(struct vhost_virtqueue *vq,
+	struct vhost_scmi *vh_scmi, const struct iovec *iov,
+	size_t req_sz, size_t *resp_sz)
+{
+	int ret;
+	struct iov_iter req_iter;
+
+	struct scmi_vio_be_msg req_msg_payld = {
+		.msg_payld = vh_scmi->req_msg_payld,
+		.msg_sz = req_sz,
+	};
+	struct scmi_vio_be_msg resp_msg_payld = {
+		.msg_payld = vh_scmi->resp_msg_payld,
+		.msg_sz = *resp_sz,
+	};
+
+	/* Clear request and response buffers */
+	memset(vh_scmi->req_msg_payld, 0, VIRTIO_SCMI_MAX_PDU_SIZE);
+	memset(vh_scmi->resp_msg_payld, 0, VIRTIO_SCMI_MAX_PDU_SIZE);
+
+	iov_iter_init(&req_iter, READ, iov, 1, req_sz);
+
+	if (unlikely(!copy_from_iter_full(
+		vh_scmi->req_msg_payld, req_sz, &req_iter))) {
+		vq_err(vq, "Faulted on SCMI request copy\n");
+		return -EFAULT;
+	}
+
+	ret = scmi_vio_be_request(vh_scmi->client_handle, &req_msg_payld,
+				   &resp_msg_payld);
+	*resp_sz = resp_msg_payld.msg_sz;
+
+	return ret;
+}
+
+static int vhost_scmi_send_resp(struct vhost_scmi *vh_scmi,
+	const struct iovec *iov, size_t resp_sz)
+{
+	void *resp = iov->iov_base;
+
+	return copy_to_user(resp, vh_scmi->resp_msg_payld, resp_sz);
+}
+
+static void handle_scmi_rx_kick(struct vhost_work *work)
+{
+	pr_err("%s: unexpected call for rx kick\n", __func__);
+}
+
+static void handle_scmi_tx(struct vhost_scmi *vh_scmi)
+{
+	struct vhost_virtqueue *vq = &vh_scmi->vqs[VHOST_SCMI_VQ_TX];
+	unsigned int out, in;
+	int head;
+	void *private;
+	size_t req_sz, resp_sz = 0, orig_resp_sz;
+	int ret = 0;
+
+	mutex_lock(&vq->mutex);
+	private = vhost_vq_get_backend(vq);
+	if (!private) {
+		mutex_unlock(&vq->mutex);
+		return;
+	}
+
+	vhost_disable_notify(&vh_scmi->dev, vq);
+
+	for (;;) {
+		/*
+		 * Skip descriptor processing, if teardown has started for the client.
+		 * Enforce visibility by using atomic_add_return().
+		 */
+		if (unlikely(atomic_add_return(0, &vh_scmi->release_fe_channels)))
+			break;
+
+		head = vhost_get_vq_desc(vq, vq->iov,
+					 ARRAY_SIZE(vq->iov),
+					 &out, &in,
+					 NULL, NULL);
+		/* On error, stop handling until the next kick. */
+		if (unlikely(head < 0))
+			break;
+		/*
+		 * Nothing new? Check if any new entry is available -
+		 * vhost_enable_notify() returns non-zero.
+		 * Otherwise wait for eventfd to tell us that client
+		 * refilled.
+		 */
+		if (head == vq->num) {
+			if (unlikely(vhost_enable_notify(&vh_scmi->dev, vq))) {
+				vhost_disable_notify(&vh_scmi->dev, vq);
+				continue;
+			}
+			break;
+		}
+
+		/*
+		 * Each new scmi request over Virtio transport is a descriptor
+		 * chain, consisting of 2 descriptors. First descriptor is
+		 * the request desc and the second one is for response.
+		 * vhost_get_vq_desc() checks the order of these 2 descriptors
+		 * in the chain. Check for correct number of each:
+		 * "in" = Number of response descriptors.
+		 * "out" = Number of request descriptors.
+		 *
+		 * Note: All descriptor entries, which result in vhost error,
+		 * are skipped. This will result in SCMI Virtio clients
+		 * for these descs to timeout. At this layer, we do not have
+		 * enough information, to populate the response descriptor.
+		 * As a possible future enhancement, client can be enhanced
+		 * to handle 0 length response descriptors, and we signal
+		 * 0 length response descriptor here, on vhost errors.
+		 */
+		if (in != 1 || out != 1) {
+			vq_err(vq, "Unexpected req(%d)/resp(%d) buffers\n",
+			       out, in);
+			continue;
+		}
+
+		req_sz = iov_length(vq->iov, out);
+		resp_sz = orig_resp_sz = iov_length(&vq->iov[out], out);
+		/* Sanitize request and response buffer size */
+		if (!req_sz || !resp_sz
+			|| req_sz > VIRTIO_SCMI_MAX_PDU_SIZE
+			|| orig_resp_sz > VIRTIO_SCMI_MAX_PDU_SIZE) {
+			vq_err(vq,
+			  "Unexpected len for SCMI req(%#zx)/resp(%#zx)\n",
+			  req_sz, orig_resp_sz);
+			goto error_scmi_tx;
+		}
+
+		ret = vhost_scmi_handle_request(vq, vh_scmi, vq->iov, req_sz, &resp_sz);
+		if (ret) {
+			vq_err(vq, "Handle request failed with error : %d\n", ret);
+			goto error_scmi_tx;
+		}
+
+		if (resp_sz > orig_resp_sz) {
+			vq_err(vq,
+			  "Unexpected response size: %#zx orig: %#zx\n",
+			  resp_sz, orig_resp_sz);
+			resp_sz = orig_resp_sz;
+		}
+
+		ret = vhost_scmi_send_resp(vh_scmi, &vq->iov[in], resp_sz);
+		if (ret) {
+			vq_err(vq, "Handle request failed with error : %d\n",
+				ret);
+			goto error_scmi_tx;
+		}
+		goto scmi_tx_signal;
+error_scmi_tx:
+		resp_sz = 0;
+scmi_tx_signal:
+		vhost_add_used_and_signal(&vh_scmi->dev, vq, head, resp_sz);
+		/*
+		 * Implement vhost_exceeds_weight(), to avoid flooding of SCMI
+		 * requests and starvation of other virtio clients?
+		 */
+	}
+
+	mutex_unlock(&vq->mutex);
+}
+
+static void handle_scmi_tx_kick(struct vhost_work *work)
+{
+	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
+						  poll.work);
+	struct vhost_scmi *vh_scmi = container_of(vq->dev,
+					struct vhost_scmi, dev);
+
+	handle_scmi_tx(vh_scmi);
+}
+
+static int vhost_scmi_open(struct inode *inode, struct file *f)
+{
+	struct vhost_scmi *vh_scmi = kzalloc(sizeof(*vh_scmi), GFP_KERNEL);
+	struct vhost_dev *dev;
+	struct vhost_virtqueue **vqs;
+	int ret = -ENOMEM;
+
+	if (!vh_scmi)
+		return ret;
+
+	vqs = kcalloc(VHOST_SCMI_VQ_NUM, sizeof(*vqs), GFP_KERNEL);
+	if (!vqs)
+		goto free_vh_scmi;
+
+	vh_scmi->req_msg_payld = kzalloc(VIRTIO_SCMI_MAX_PDU_SIZE,
+						GFP_KERNEL);
+	if (!vh_scmi->req_msg_payld)
+		goto free_vqs;
+
+	vh_scmi->resp_msg_payld = kzalloc(VIRTIO_SCMI_MAX_PDU_SIZE,
+						GFP_KERNEL);
+	if (!vh_scmi->resp_msg_payld)
+		goto free_req_msg;
+
+	vh_scmi->client_handle = scmi_vio_get_client_h(vh_scmi);
+	if (!vh_scmi->client_handle)
+		goto free_resp_msg;
+
+	dev = &vh_scmi->dev;
+	vqs[VHOST_SCMI_VQ_RX] = &vh_scmi->vqs[VHOST_SCMI_VQ_RX];
+	vqs[VHOST_SCMI_VQ_TX] = &vh_scmi->vqs[VHOST_SCMI_VQ_TX];
+	vh_scmi->vqs[VHOST_SCMI_VQ_RX].handle_kick = handle_scmi_rx_kick;
+	vh_scmi->vqs[VHOST_SCMI_VQ_TX].handle_kick = handle_scmi_tx_kick;
+	/* Use kworker and disable weight checks */
+	vhost_dev_init(dev, vqs, VHOST_SCMI_VQ_NUM, UIO_MAXIOV,
+		       0, 0, true, NULL);
+
+	f->private_data = vh_scmi;
+	ret = scmi_vio_be_open(vh_scmi->client_handle);
+	if (ret) {
+		pr_err("SCMI Virtio backend open() failed with error %d\n", ret);
+		goto free_client_handle;
+	}
+	return ret;
+
+free_client_handle:
+	scmi_vio_put_client_h(vh_scmi->client_handle);
+free_resp_msg:
+	kfree(vh_scmi->resp_msg_payld);
+free_req_msg:
+	kfree(vh_scmi->req_msg_payld);
+free_vqs:
+	kfree(vqs);
+free_vh_scmi:
+	kfree(vh_scmi);
+	return ret;
+}
+
+static int vhost_scmi_start(struct vhost_scmi *vh_scmi)
+{
+	struct vhost_virtqueue *vq;
+	size_t i;
+	int ret;
+
+	mutex_lock(&vh_scmi->dev.mutex);
+
+	ret = vhost_dev_check_owner(&vh_scmi->dev);
+	if (ret)
+		goto err;
+
+	for (i = 0; i < ARRAY_SIZE(vh_scmi->vqs); i++) {
+		vq = &vh_scmi->vqs[i];
+
+		mutex_lock(&vq->mutex);
+
+		if (!vhost_vq_access_ok(vq)) {
+			ret = -EFAULT;
+			goto err_vq;
+		}
+
+		if (!vhost_vq_get_backend(vq)) {
+			vhost_vq_set_backend(vq, vh_scmi);
+			ret = vhost_vq_init_access(vq);
+			if (ret)
+				goto err_vq;
+		}
+
+		mutex_unlock(&vq->mutex);
+	}
+
+	mutex_unlock(&vh_scmi->dev.mutex);
+	return 0;
+
+err_vq:
+	mutex_unlock(&vq->mutex);
+	for (i = 0; i < ARRAY_SIZE(vh_scmi->vqs); i++) {
+		vq = &vh_scmi->vqs[i];
+
+		mutex_lock(&vq->mutex);
+		vhost_vq_set_backend(vq, NULL);
+		mutex_unlock(&vq->mutex);
+	}
+err:
+	mutex_unlock(&vh_scmi->dev.mutex);
+	return ret;
+}
+
+static int vhost_scmi_stop(struct vhost_scmi *vh_scmi)
+{
+	int ret = 0, i;
+	struct vhost_virtqueue *vq;
+
+	mutex_lock(&vh_scmi->dev.mutex);
+	ret = vhost_dev_check_owner(&vh_scmi->dev);
+	if (ret)
+		goto err;
+	for (i = 0; i < ARRAY_SIZE(vh_scmi->vqs); i++) {
+		vq = &vh_scmi->vqs[i];
+		mutex_lock(&vq->mutex);
+		vhost_vq_set_backend(vq, NULL);
+		mutex_unlock(&vq->mutex);
+	}
+err:
+	mutex_unlock(&vh_scmi->dev.mutex);
+	return ret;
+}
+
+static void vhost_scmi_flush_vq(struct vhost_scmi *vh_scmi, int index)
+{
+	vhost_poll_flush(&vh_scmi->vqs[index].poll);
+}
+
+static void vhost_scmi_flush(struct vhost_scmi *vh_scmi)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(vh_scmi->vqs); i++)
+		vhost_scmi_flush_vq(vh_scmi, i);
+}
+
+static int vhost_scmi_release(struct inode *inode, struct file *f)
+{
+	struct vhost_scmi *vh_scmi = f->private_data;
+	int ret = 0;
+
+	atomic_set(&vh_scmi->release_fe_channels, 1);
+	vhost_scmi_stop(vh_scmi);
+	vhost_scmi_flush(vh_scmi);
+	vhost_dev_stop(&vh_scmi->dev);
+	vhost_dev_cleanup(&vh_scmi->dev);
+	/*
+	 * We do an extra flush before freeing memory,
+	 * since jobs can re-queue themselves.
+	 */
+
+	vhost_scmi_flush(vh_scmi);
+	ret = scmi_vio_be_close(vh_scmi->client_handle);
+	if (ret)
+		pr_err("SCMI Virtio backend  close() failed with error %d\n", ret);
+	scmi_vio_put_client_h(vh_scmi->client_handle);
+	kfree(vh_scmi->resp_msg_payld);
+	kfree(vh_scmi->req_msg_payld);
+	kfree(vh_scmi->dev.vqs);
+	kfree(vh_scmi);
+
+	return ret;
+}
+
+static int vhost_scmi_set_features(struct vhost_scmi *vh_scmi, u64 features)
+{
+	struct vhost_virtqueue *vq;
+	int i;
+
+	mutex_lock(&vh_scmi->dev.mutex);
+	if ((features & (1 << VHOST_F_LOG_ALL)) &&
+	    !vhost_log_access_ok(&vh_scmi->dev)) {
+		mutex_unlock(&vh_scmi->dev.mutex);
+		return -EFAULT;
+	}
+
+	for (i = 0; i < VHOST_SCMI_VQ_NUM; ++i) {
+		vq = &vh_scmi->vqs[i];
+		mutex_lock(&vq->mutex);
+		vq->acked_features = features;
+		mutex_unlock(&vq->mutex);
+	}
+	mutex_unlock(&vh_scmi->dev.mutex);
+	return 0;
+}
+
+static long vhost_scmi_ioctl(struct file *f, unsigned int ioctl,
+			     unsigned long arg)
+{
+	struct vhost_scmi *vh_scmi = f->private_data;
+	void __user *argp = (void __user *)arg;
+	u64 __user *featurep = argp;
+	u64 features;
+	int r, start;
+
+	switch (ioctl) {
+	case VHOST_GET_FEATURES:
+		features = VHOST_SCMI_FEATURES;
+		if (copy_to_user(featurep, &features, sizeof(features)))
+			return -EFAULT;
+		return 0;
+	case VHOST_SET_FEATURES:
+		if (copy_from_user(&features, featurep, sizeof(features)))
+			return -EFAULT;
+		if (features & ~VHOST_SCMI_FEATURES)
+			return -EOPNOTSUPP;
+		return vhost_scmi_set_features(vh_scmi, features);
+	case VHOST_SCMI_SET_RUNNING:
+		if (copy_from_user(&start, argp, sizeof(start)))
+			return -EFAULT;
+		if (start)
+			return vhost_scmi_start(vh_scmi);
+		else
+			return vhost_scmi_stop(vh_scmi);
+	default:
+		mutex_lock(&vh_scmi->dev.mutex);
+		r = vhost_dev_ioctl(&vh_scmi->dev, ioctl, argp);
+		if (r == -ENOIOCTLCMD)
+			r = vhost_vring_ioctl(&vh_scmi->dev, ioctl, argp);
+		vhost_scmi_flush(vh_scmi);
+		mutex_unlock(&vh_scmi->dev.mutex);
+		return r;
+	}
+}
+
+static const struct file_operations vhost_scmi_fops = {
+	.owner          = THIS_MODULE,
+	.release        = vhost_scmi_release,
+	.unlocked_ioctl = vhost_scmi_ioctl,
+	.compat_ioctl   = compat_ptr_ioctl,
+	.open           = vhost_scmi_open,
+	.llseek		= noop_llseek,
+};
+
+static struct miscdevice vhost_scmi_misc = {
+	MISC_DYNAMIC_MINOR,
+	"vhost-scmi",
+	&vhost_scmi_fops,
+};
+module_misc_device(vhost_scmi_misc);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Host kernel accelerator for SCMI Virtio");
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index 5d99e7c242a2..e5ad915bed84 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -157,4 +157,7 @@
 /* Get the count of all virtqueues */
 #define VHOST_VDPA_GET_VQS_COUNT	_IOR(VHOST_VIRTIO, 0x80, __u32)
 
+/* VHOST_SCMI specific defines */
+#define VHOST_SCMI_SET_RUNNING          _IOW(VHOST_VIRTIO, 0x81, int)
+
 #endif
-- 
2.17.1

