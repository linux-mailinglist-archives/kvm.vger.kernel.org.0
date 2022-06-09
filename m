Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0A065444AA
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 09:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239903AbiFIHU7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 03:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239887AbiFIHU5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 03:20:57 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168E7244091;
        Thu,  9 Jun 2022 00:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1654759252; x=1686295252;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=4wRgwCTUNlO+FMSsfyD4bu/uBJAt9aCSKSvI8p63V04=;
  b=giRVJSVIAkuJu0BVRz7ubLWns/OXueLE4+HhUvhBM8vmJFGCPV9/0SlT
   UuFkpWpRSGN+3ag5xAqpdUtCyDFAKMa07yDyQchqGBD4DEmTxC6P2+ztf
   YMVSxhh3TbKDdgd/Fga9R5o2WQ/q2maOKqqhG99fuIntPmE7bqLjvZRBj
   E=;
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 09 Jun 2022 00:20:51 -0700
X-QCInternal: smtphost
Received: from nasanex01b.na.qualcomm.com ([10.46.141.250])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 00:20:51 -0700
Received: from localhost (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 9 Jun 2022
 00:20:50 -0700
From:   Neeraj Upadhyay <quic_neeraju@quicinc.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>, <sudeep.holla@arm.com>,
        <cristian.marussi@arm.com>
CC:     <quic_sramana@quicinc.com>, <vincent.guittot@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>
Subject: [RFC 2/3] firmware: Add ARM SCMI Virtio backend implementation
Date:   Thu, 9 Jun 2022 12:49:55 +0530
Message-ID: <20220609071956.5183-3-quic_neeraju@quicinc.com>
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

Add implementation for SCMI Virtio backend, for handling SCMI
requests received over Virtio transport. All SCMI
requests from a guest are associated with a unique
client handle. The SCMI request packet, received from
the SCMI Virtio layer is unpacked and depending on the
message id, is forwarded to the correct protocol, if
that protocol is implemented. The response packet is
packed with the payload returned by the protocol layer,
and message header is added to it.

Available protocols are specified using child device tree
nodes of the parent scmi virtio backend node. Current
patch only implements the base protocol.

Notifications and delayed response are not supported at this
point.

As all incoming SCMI requests from a guest are associated
with a unique handle, which is also forwarded to the
protocol layer; on channel close call for a guest, protocols
can do the required cleanup of the resources allocated for
that particular guest.

Co-developed-by: Srinivas Ramana <quic_sramana@quicinc.com>
Signed-off-by: Neeraj Upadhyay <quic_neeraju@quicinc.com>
Signed-off-by: Srinivas Ramana <quic_sramana@quicinc.com>
---
 drivers/firmware/Kconfig                      |   9 +
 drivers/firmware/arm_scmi/Makefile            |   1 +
 drivers/firmware/arm_scmi/base.c              |  12 -
 drivers/firmware/arm_scmi/common.h            |  15 +
 .../firmware/arm_scmi/virtio_backend/Makefile |   5 +
 .../arm_scmi/virtio_backend/backend.c         | 516 ++++++++++++++++++
 .../arm_scmi/virtio_backend/backend.h         |  20 +
 .../virtio_backend/backend_protocol.h         |  93 ++++
 .../firmware/arm_scmi/virtio_backend/base.c   | 474 ++++++++++++++++
 .../arm_scmi/virtio_backend/client_handle.c   |  71 +++
 .../arm_scmi/virtio_backend/client_handle.h   |  24 +
 .../firmware/arm_scmi/virtio_backend/common.h |  53 ++
 include/linux/scmi_vio_backend.h              |  31 ++
 13 files changed, 1312 insertions(+), 12 deletions(-)
 create mode 100644 drivers/firmware/arm_scmi/virtio_backend/Makefile
 create mode 100644 drivers/firmware/arm_scmi/virtio_backend/backend.c
 create mode 100644 drivers/firmware/arm_scmi/virtio_backend/backend.h
 create mode 100644 drivers/firmware/arm_scmi/virtio_backend/backend_protocol.h
 create mode 100644 drivers/firmware/arm_scmi/virtio_backend/base.c
 create mode 100644 drivers/firmware/arm_scmi/virtio_backend/client_handle.c
 create mode 100644 drivers/firmware/arm_scmi/virtio_backend/client_handle.h
 create mode 100644 drivers/firmware/arm_scmi/virtio_backend/common.h
 create mode 100644 include/linux/scmi_vio_backend.h

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index e5cfb01353d8..5adafaa320cc 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -8,6 +8,15 @@ menu "Firmware Drivers"
 
 source "drivers/firmware/arm_scmi/Kconfig"
 
+config ARM_SCMI_VIRTIO_BACKEND
+	tristate "SCMI Message Protocol Virtio Backend device"
+	depends on ARM || ARM64 || COMPILE_TEST
+	help
+	  ARM System Control and Management Interface (SCMI) protocol
+	  platform device for SCMI Virtio transport. This component
+	  provides platform side implementation of SCMI protocols
+	  for clients communication over Virtio transport.
+
 config ARM_SCPI_PROTOCOL
 	tristate "ARM System Control and Power Interface (SCPI) Message Protocol"
 	depends on ARM || ARM64 || COMPILE_TEST
diff --git a/drivers/firmware/arm_scmi/Makefile b/drivers/firmware/arm_scmi/Makefile
index 8d4afadda38c..00d35d1053c0 100644
--- a/drivers/firmware/arm_scmi/Makefile
+++ b/drivers/firmware/arm_scmi/Makefile
@@ -12,6 +12,7 @@ scmi-module-objs := $(scmi-bus-y) $(scmi-driver-y) $(scmi-protocols-y) \
 		    $(scmi-transport-y)
 obj-$(CONFIG_ARM_SCMI_PROTOCOL) += scmi-module.o
 obj-$(CONFIG_ARM_SCMI_POWER_DOMAIN) += scmi_pm_domain.o
+obj-y	+= virtio_backend/
 
 ifeq ($(CONFIG_THUMB2_KERNEL)$(CONFIG_CC_IS_CLANG),yy)
 # The use of R7 in the SMCCC conflicts with the compiler's use of R7 as a frame
diff --git a/drivers/firmware/arm_scmi/base.c b/drivers/firmware/arm_scmi/base.c
index f5219334fd3a..2ad019135afb 100644
--- a/drivers/firmware/arm_scmi/base.c
+++ b/drivers/firmware/arm_scmi/base.c
@@ -16,18 +16,6 @@
 #define SCMI_BASE_NUM_SOURCES		1
 #define SCMI_BASE_MAX_CMD_ERR_COUNT	1024
 
-enum scmi_base_protocol_cmd {
-	BASE_DISCOVER_VENDOR = 0x3,
-	BASE_DISCOVER_SUB_VENDOR = 0x4,
-	BASE_DISCOVER_IMPLEMENT_VERSION = 0x5,
-	BASE_DISCOVER_LIST_PROTOCOLS = 0x6,
-	BASE_DISCOVER_AGENT = 0x7,
-	BASE_NOTIFY_ERRORS = 0x8,
-	BASE_SET_DEVICE_PERMISSIONS = 0x9,
-	BASE_SET_PROTOCOL_PERMISSIONS = 0xa,
-	BASE_RESET_AGENT_CONFIGURATION = 0xb,
-};
-
 struct scmi_msg_resp_base_attributes {
 	u8 num_protocols;
 	u8 num_agents;
diff --git a/drivers/firmware/arm_scmi/common.h b/drivers/firmware/arm_scmi/common.h
index 4fda84bfab42..91cf3ffeb0e8 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -39,6 +39,18 @@ enum scmi_common_cmd {
 	PROTOCOL_MESSAGE_ATTRIBUTES = 0x2,
 };
 
+enum scmi_base_protocol_cmd {
+	BASE_DISCOVER_VENDOR = 0x3,
+	BASE_DISCOVER_SUB_VENDOR = 0x4,
+	BASE_DISCOVER_IMPLEMENT_VERSION = 0x5,
+	BASE_DISCOVER_LIST_PROTOCOLS = 0x6,
+	BASE_DISCOVER_AGENT = 0x7,
+	BASE_NOTIFY_ERRORS = 0x8,
+	BASE_SET_DEVICE_PERMISSIONS = 0x9,
+	BASE_SET_PROTOCOL_PERMISSIONS = 0xa,
+	BASE_RESET_AGENT_CONFIGURATION = 0xb,
+};
+
 /**
  * struct scmi_msg_resp_prot_version - Response for a message
  *
@@ -68,6 +80,9 @@ struct scmi_msg_resp_prot_version {
 #define MSG_TOKEN_ID_MASK	GENMASK(27, 18)
 #define MSG_XTRACT_TOKEN(hdr)	FIELD_GET(MSG_TOKEN_ID_MASK, (hdr))
 #define MSG_TOKEN_MAX		(MSG_XTRACT_TOKEN(MSG_TOKEN_ID_MASK) + 1)
+#define MSG_HDR_SZ		4
+#define MSG_STATUS_SZ		4
+
 
 /*
  * Size of @pending_xfers hashtable included in @scmi_xfers_info; ideally, in
diff --git a/drivers/firmware/arm_scmi/virtio_backend/Makefile b/drivers/firmware/arm_scmi/virtio_backend/Makefile
new file mode 100644
index 000000000000..a77d40e35883
--- /dev/null
+++ b/drivers/firmware/arm_scmi/virtio_backend/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0-only
+scmi-vio-backend-y = backend.o client_handle.o
+scmi-vio-backend-protocols-y = base.o
+scmi-vio-backend-objs := $(scmi-vio-backend-y) $(scmi-vio-backend-protocols-y)
+obj-$(CONFIG_ARM_SCMI_VIRTIO_BACKEND) += scmi-vio-backend.o
diff --git a/drivers/firmware/arm_scmi/virtio_backend/backend.c b/drivers/firmware/arm_scmi/virtio_backend/backend.c
new file mode 100644
index 000000000000..b5e2c6b44b68
--- /dev/null
+++ b/drivers/firmware/arm_scmi/virtio_backend/backend.c
@@ -0,0 +1,516 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2022 Qualcomm Innovation Center, Inc. All rights reserved.
+ */
+
+#define pr_fmt(fmt) "SCMI Virtio BE: " fmt
+
+#include <linux/device.h>
+#include <linux/export.h>
+#include <linux/idr.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/scmi_protocol.h>
+#include <linux/scmi_vio_backend.h>
+#include <linux/slab.h>
+#include <linux/bitfield.h>
+
+#include "common.h"
+#include "backend.h"
+#include "client_handle.h"
+#include "../common.h"
+#include "backend_protocol.h"
+
+
+/**
+ * scmi_vio_client_priv - Structure respreseting client specific
+ * private data maintained by backend.
+ *
+ * @backend_protocol_map:     IDR used by Virtio backend, to maintain per protocol
+ *              private data. This map is initialized with protocol data,
+ *              on scmi_vio_be_open() call during client channel setup.
+ *              The per protocol pointer is initialized by each registered
+ *              backend protocol, in its open() call, and can be used to
+ *              reference client specific bookkeeping information, which
+ *              is maintained by that protocol. This can be used to release
+ *              client specific protocol resources during close call for
+ *              it.
+ */
+struct scmi_vio_client_priv {
+	struct idr backend_protocol_map;
+};
+
+struct scmi_vio_be_info {
+	struct device *dev;
+	struct idr registered_protocols;
+	struct idr active_protocols;
+	struct rw_semaphore active_protocols_rwsem;
+};
+
+static struct scmi_vio_be_info scmi_vio_be_info;
+
+void *scmi_vio_get_protocol_priv(
+	const struct scmi_vio_protocol_h *__maybe_unused prot_h,
+	const struct scmi_vio_client_h *client_h)
+{
+	return scmi_vio_get_client_priv(client_h);
+}
+
+void scmi_vio_set_protocol_priv(
+	const struct scmi_vio_protocol_h *__maybe_unused prot_h,
+	const struct scmi_vio_client_h *client_h,
+	void *priv)
+{
+	scmi_vio_set_client_priv(client_h, priv);
+}
+
+int scmi_vio_protocol_register(const struct scmi_vio_protocol *proto)
+{
+	int ret;
+
+	if (!proto) {
+		pr_err("Invalid protocol\n");
+		return -EINVAL;
+	}
+
+	if (!proto->prot_init_fn || !proto->prot_exit_fn) {
+		pr_err("Missing protocol init/exit fn %#x\n", proto->id);
+		return -EINVAL;
+	}
+
+	ret = idr_alloc(&scmi_vio_be_info.registered_protocols, (void *)proto,
+			proto->id, proto->id + 1, GFP_ATOMIC);
+	if (ret != proto->id) {
+		pr_err(
+		  "Idr allocation failed for %#x - err %d\n",
+		  proto->id, ret);
+		return ret;
+	}
+
+	pr_err("Registered Protocol %#x\n", proto->id);
+
+	return 0;
+}
+
+void scmi_vio_protocol_unregister(const struct scmi_vio_protocol *proto)
+{
+	idr_remove(&scmi_vio_be_info.registered_protocols, proto->id);
+	pr_err("Unregistered Protocol %#x\n", proto->id);
+}
+
+int scmi_vio_implemented_protocols(
+	const struct scmi_vio_protocol_h *__maybe_unused prot_h,
+	const struct scmi_vio_client_h *__maybe_unused client_h,
+	u8 *imp_protocols, int *imp_proto_num)
+{
+	const struct scmi_vio_protocol_h *protocol_h;
+	const struct scmi_vio_protocol_h *base_protocol_h;
+	int active_protocols_num = 0;
+	int proto_num = *imp_proto_num;
+	unsigned int id = 0;
+	int ret = 0;
+
+	base_protocol_h = idr_find(&scmi_vio_be_info.active_protocols,
+					SCMI_PROTOCOL_BASE);
+	if (prot_h != base_protocol_h)
+		return -EINVAL;
+
+	/*
+	 * SCMI agents, identified by client_h, may not have access to
+	 * all protocols?
+	 */
+	idr_for_each_entry(&scmi_vio_be_info.active_protocols, protocol_h, id) {
+		if (id == SCMI_PROTOCOL_BASE)
+			continue;
+		if (active_protocols_num >= proto_num) {
+			pr_err("Number of active protocols %d > max num: %d\n",
+				(active_protocols_num + 1), proto_num);
+			ret = -ENOMEM;
+			goto imp_protocols_exit;
+		}
+		imp_protocols[active_protocols_num] = id;
+		active_protocols_num++;
+	}
+imp_protocols_exit:
+	*imp_proto_num = active_protocols_num;
+	return ret;
+}
+
+static int scmi_vio_protocol_init(struct device *dev, u8 protocol_id)
+{
+	int ret = 0, ret2 = 0;
+	struct scmi_vio_protocol *protocol_info;
+	struct scmi_vio_protocol_h *protocol_h;
+
+	down_write(&scmi_vio_be_info.active_protocols_rwsem);
+	protocol_info = idr_find(&scmi_vio_be_info.registered_protocols, protocol_id);
+	if (!protocol_info) {
+		pr_err("Protocol %#x not registered; protocol init failed\n",
+		       protocol_id);
+		ret = -EINVAL;
+		goto out_protocol_release_rwsem;
+	}
+
+	protocol_h = kzalloc(sizeof(*protocol_h), GFP_KERNEL);
+	if (!protocol_h) {
+		ret = -ENOMEM;
+		goto out_protocol_release_rwsem;
+	}
+
+	protocol_h->dev = dev;
+	ret = protocol_info->prot_init_fn(protocol_h);
+	if (ret) {
+		pr_err("Protocol %#x init function returned: %d\n",
+			protocol_id, ret);
+		kfree(protocol_h);
+		protocol_h = NULL;
+		goto out_protocol_release_rwsem;
+	}
+
+	/* Register this protocol in active protocols list */
+	ret = idr_alloc(&scmi_vio_be_info.active_protocols,
+			(void *)protocol_h,
+			protocol_id, protocol_id + 1, GFP_ATOMIC);
+	if (ret != protocol_id) {
+		pr_err(
+		  "Allocation failed for active protocol %#x - err %d\n",
+		  protocol_id, ret);
+		ret2 = protocol_info->prot_exit_fn(protocol_h);
+		if (ret2)
+			pr_err("Protocol %#x exit function returned: %d\n",
+				protocol_id, ret2);
+		kfree(protocol_h);
+		protocol_h = NULL;
+		goto out_protocol_release_rwsem;
+	}
+
+	ret = 0;
+out_protocol_release_rwsem:
+	up_write(&scmi_vio_be_info.active_protocols_rwsem);
+	return ret;
+}
+
+static int scmi_vio_protocol_exit(struct device *dev)
+{
+	int ret = 0;
+	unsigned int id = 0;
+	struct scmi_vio_protocol *protocol_info;
+	const struct scmi_vio_protocol_h *protocol_h;
+
+	down_write(&scmi_vio_be_info.active_protocols_rwsem);
+	idr_for_each_entry(&scmi_vio_be_info.active_protocols, protocol_h, id) {
+		protocol_info = idr_find(&scmi_vio_be_info.registered_protocols, id);
+		ret = protocol_info->prot_exit_fn(protocol_h);
+		if (ret) {
+			pr_err("Protocol %#x exit function returned: %d\n",
+				id, ret);
+		}
+		kfree(protocol_h);
+		idr_remove(&scmi_vio_be_info.active_protocols, id);
+	}
+	up_write(&scmi_vio_be_info.active_protocols_rwsem);
+
+	return ret;
+}
+
+int scmi_vio_be_open(const struct scmi_vio_client_h *client_h)
+{
+	int tmp_id, ret = 0, close_ret = 0;
+	const struct scmi_vio_protocol_h *protocol_h;
+	struct scmi_vio_protocol *vio_be_protocol;
+	unsigned int id = 0;
+	struct scmi_vio_client_h *proto_client_h;
+	struct scmi_vio_client_priv *client_priv;
+	u8 open_protocols[MAX_PROTOCOLS_IMP];
+	u8 open_protocols_num = 0;
+
+	client_priv = kzalloc(sizeof(*client_priv), GFP_KERNEL);
+
+	if (!client_priv)
+		return -ENOMEM;
+
+	idr_init(&client_priv->backend_protocol_map);
+
+	down_read(&scmi_vio_be_info.active_protocols_rwsem);
+	idr_for_each_entry(&scmi_vio_be_info.active_protocols,
+			   protocol_h, id) {
+		vio_be_protocol = idr_find(&scmi_vio_be_info.registered_protocols, id);
+		proto_client_h = scmi_vio_get_client_h(client_h);
+		if (!proto_client_h) {
+			ret = -ENOMEM;
+			goto vio_proto_open_fail;
+		}
+		ret = vio_be_protocol->prot_ops->open(proto_client_h);
+		if (ret) {
+			pr_err("->open() failed for id: %d ret: %d\n",
+				id, ret);
+			goto vio_proto_open_fail;
+		}
+		tmp_id = idr_alloc(&client_priv->backend_protocol_map,
+			(void *)proto_client_h,
+			id, id + 1, GFP_ATOMIC);
+		if (tmp_id != id) {
+			pr_err("Failed to allocate client handle for %#x\n",
+				id);
+			close_ret = vio_be_protocol->prot_ops->close(
+						proto_client_h);
+			if (close_ret) {
+				pr_err("->close() failed for id: %d ret: %d\n",
+					id, close_ret);
+			}
+			scmi_vio_put_client_h(proto_client_h);
+			ret = -EINVAL;
+			goto vio_proto_open_fail;
+		}
+		open_protocols[open_protocols_num++] = (u8)id;
+	}
+	up_read(&scmi_vio_be_info.active_protocols_rwsem);
+	scmi_vio_set_client_priv(client_h, client_priv);
+
+	return 0;
+
+vio_proto_open_fail:
+	for ( ; open_protocols_num > 0; open_protocols_num--) {
+		id = open_protocols[open_protocols_num-1];
+		vio_be_protocol = idr_find(&scmi_vio_be_info.registered_protocols, id);
+		proto_client_h = idr_find(&client_priv->backend_protocol_map, id);
+		close_ret = vio_be_protocol->prot_ops->close(proto_client_h);
+		WARN(close_ret, "->close() failed for id: %d ret: %d\n",
+			id, close_ret);
+		scmi_vio_put_client_h(proto_client_h);
+	}
+
+	up_read(&scmi_vio_be_info.active_protocols_rwsem);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(scmi_vio_be_open);
+
+int scmi_vio_be_close(const struct scmi_vio_client_h *client_h)
+{
+	const struct scmi_vio_protocol_h *protocol_h;
+	struct scmi_vio_protocol *vio_be_protocol;
+	unsigned int id = 0;
+	struct scmi_vio_client_priv *client_priv =
+		scmi_vio_get_client_priv(client_h);
+	struct scmi_vio_client_h *proto_client_h;
+	int ret = 0, close_ret = 0;
+
+	if (!client_priv) {
+		pr_err("->close() failed: priv data not available\n");
+		return -EINVAL;
+	}
+
+	down_read(&scmi_vio_be_info.active_protocols_rwsem);
+	idr_for_each_entry(&scmi_vio_be_info.active_protocols,
+			   protocol_h, id) {
+		vio_be_protocol = idr_find(&scmi_vio_be_info.registered_protocols, id);
+		proto_client_h = idr_find(&client_priv->backend_protocol_map, id);
+		/* We might have failed to alloc idr, in scmi_vio_be_open() */
+		if (!proto_client_h)
+			continue;
+		close_ret = vio_be_protocol->prot_ops->close(proto_client_h);
+		WARN(close_ret, "->close() failed for id: %d ret: %d\n",
+			id, close_ret);
+		/* Return first failure return code */
+		ret = ret ? : close_ret;
+		scmi_vio_put_client_h(proto_client_h);
+	}
+	up_read(&scmi_vio_be_info.active_protocols_rwsem);
+
+	idr_destroy(&client_priv->backend_protocol_map);
+	kfree(client_priv);
+	scmi_vio_set_client_priv(client_h, NULL);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(scmi_vio_be_close);
+
+int scmi_vio_be_request(const struct scmi_vio_client_h *client_h,
+			const struct scmi_vio_be_msg *req,
+			struct scmi_vio_be_msg *resp)
+{	int ret = 0;
+	struct scmi_vio_be_msg_hdr msg_header;
+	u32 msg;
+	struct scmi_vio_be_payload_buf req_payload, resp_payload;
+	struct scmi_vio_protocol *vio_be_protocol;
+	const struct scmi_vio_protocol_h *protocol_h;
+	struct scmi_vio_client_priv *client_priv =
+		scmi_vio_get_client_priv(client_h);
+	struct scmi_vio_client_h *proto_client_h;
+	int scmi_error = 0;
+
+	/* Unpack message header */
+	if (!req || req->msg_sz < MSG_HDR_SZ ||
+	    !resp || resp->msg_sz <
+			(MSG_HDR_SZ + MSG_STATUS_SZ)) {
+		pr_err("Invalid equest/response message size\n");
+		return -EINVAL;
+	}
+
+	down_read(&scmi_vio_be_info.active_protocols_rwsem);
+	msg = le32_to_cpu(*(__le32 *)req->msg_payld);
+	msg_header.protocol_id = MSG_XTRACT_PROT_ID(msg);
+	msg_header.msg_id = MSG_XTRACT_ID(msg);
+	msg_header.type = MSG_XTRACT_TYPE(msg);
+	msg_header.seq = MSG_XTRACT_TOKEN(msg);
+
+	*(__le32 *)resp->msg_payld = cpu_to_le32(msg);
+
+	resp_payload.payload =
+		(void *)((unsigned long)(uintptr_t)resp->msg_payld
+			+ MSG_HDR_SZ);
+
+	if (!client_priv) {
+		pr_err("Private map not initialized\n");
+		scmi_error = SCMI_VIO_BE_NOT_FOUND;
+		goto protocol_find_fail;
+	}
+
+	protocol_h = idr_find(&scmi_vio_be_info.active_protocols,
+				   msg_header.protocol_id);
+	if (unlikely(!protocol_h)) {
+		pr_err("Invalid protocol id in request header :%#x\n",
+			msg_header.protocol_id);
+		scmi_error = SCMI_VIO_BE_NOT_FOUND;
+		goto protocol_find_fail;
+	}
+
+	proto_client_h = idr_find(&client_priv->backend_protocol_map,
+				   msg_header.protocol_id);
+	if (!proto_client_h) {
+		pr_err("Frontend handle not present for protocol : %#x\n",
+			msg_header.protocol_id);
+		scmi_error = SCMI_VIO_BE_NOT_FOUND;
+		goto protocol_find_fail;
+	}
+
+	vio_be_protocol = idr_find(&scmi_vio_be_info.registered_protocols,
+					msg_header.protocol_id);
+	if (!vio_be_protocol) {
+		pr_err("Protocol %#x is not registered\n",
+			msg_header.protocol_id);
+		scmi_error = SCMI_VIO_BE_NOT_FOUND;
+		goto protocol_find_fail;
+	}
+
+	req_payload.payload =
+		(void *)((unsigned long)(uintptr_t)req->msg_payld +
+		MSG_HDR_SZ);
+	req_payload.payload_size = req->msg_sz - MSG_HDR_SZ;
+
+	resp_payload.payload_size = resp->msg_sz - MSG_HDR_SZ;
+
+	ret = vio_be_protocol->prot_ops->msg_handle(
+		proto_client_h, &msg_header, &req_payload, &resp_payload);
+	if (ret) {
+		pr_err("Protocol %#x ->msg_handle() failed err: %d\n",
+			msg_header.protocol_id, ret);
+		scmi_error = scmi_vio_linux_err_remap(ret);
+		goto protocol_find_fail;
+	}
+
+	up_read(&scmi_vio_be_info.active_protocols_rwsem);
+
+	resp->msg_sz = MSG_HDR_SZ + resp_payload.payload_size;
+
+	return 0;
+
+protocol_find_fail:
+	up_read(&scmi_vio_be_info.active_protocols_rwsem);
+	*((__le32 *)(resp_payload.payload)) = cpu_to_le32(scmi_error);
+	resp->msg_sz = MSG_HDR_SZ + MSG_STATUS_SZ;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(scmi_vio_be_request);
+
+static int scmi_vio_be_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct device *dev = &pdev->dev;
+	struct device_node *child, *np = dev->of_node;
+
+	scmi_vio_be_info.dev = dev;
+
+	platform_set_drvdata(pdev, &scmi_vio_be_info);
+
+	/*
+	 * Base protocol is always implemented. So init it.
+	 */
+	ret = scmi_vio_protocol_init(dev, SCMI_PROTOCOL_BASE);
+	if (ret) {
+		dev_err(dev, "Base protocol init failed with err: %d\n", ret);
+		return -EPROBE_DEFER;
+	}
+
+	for_each_available_child_of_node(np, child) {
+		u32 prot_id;
+
+		if (of_property_read_u32(child, "reg", &prot_id))
+			continue;
+
+		if (!FIELD_FIT(MSG_PROTOCOL_ID_MASK, prot_id)) {
+			dev_err(dev, "Out of range protocol %d\n", prot_id);
+			continue;
+		}
+
+		ret = scmi_vio_protocol_init(dev, prot_id);
+		if (ret == -EPROBE_DEFER)
+			goto vio_be_protocol_exit;
+	}
+
+	return 0;
+
+vio_be_protocol_exit:
+	scmi_vio_protocol_exit(dev);
+
+	return ret;
+}
+
+static int scmi_vio_be_remove(struct platform_device *pdev)
+{
+	scmi_vio_protocol_exit(&pdev->dev);
+
+	return 0;
+}
+
+static const struct of_device_id scmi_vio_be_of_match[] = {
+	{ .compatible = "arm,scmi-vio-backend" },
+	{ },
+};
+
+MODULE_DEVICE_TABLE(of, scmi_vio_be_of_match);
+
+static struct platform_driver scmi_vio_be_driver = {
+	.driver = {
+		   .name = "arm-scmi-virtio-backend",
+		   .of_match_table = scmi_vio_be_of_match,
+		   },
+	.probe = scmi_vio_be_probe,
+	.remove = scmi_vio_be_remove,
+};
+
+static int __init scmi_vio_be_init(void)
+{
+	idr_init(&scmi_vio_be_info.registered_protocols);
+	idr_init(&scmi_vio_be_info.active_protocols);
+	init_rwsem(&scmi_vio_be_info.active_protocols_rwsem);
+	scmi_vio_base_register();
+
+	return platform_driver_register(&scmi_vio_be_driver);
+}
+module_init(scmi_vio_be_init);
+
+static void __exit scmi_vio_be_exit(void)
+{
+	scmi_vio_base_unregister();
+	idr_destroy(&scmi_vio_be_info.active_protocols);
+	idr_destroy(&scmi_vio_be_info.registered_protocols);
+	platform_driver_unregister(&scmi_vio_be_driver);
+}
+module_exit(scmi_vio_be_exit);
+
+MODULE_ALIAS("platform: scmi-vio-backend");
+MODULE_DESCRIPTION("ARM SCMI protocol Virtio Backend driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/firmware/arm_scmi/virtio_backend/backend.h b/drivers/firmware/arm_scmi/virtio_backend/backend.h
new file mode 100644
index 000000000000..9c6d353682dd
--- /dev/null
+++ b/drivers/firmware/arm_scmi/virtio_backend/backend.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2022 Qualcomm Innovation Center, Inc. All rights reserved.
+ */
+#ifndef _SCMI_VIO_BE_H
+#define _SCMI_VIO_BE_H
+
+void *scmi_vio_get_client_priv(
+	const struct scmi_vio_client_h *client_h);
+
+void scmi_vio_set_client_priv(
+	const struct scmi_vio_client_h *client_h,
+	void *priv);
+
+#define DECLARE_SCMI_VIO_REGISTER_UNREGISTER(protocol)          \
+	int __init scmi_vio_##protocol##_register(void);        \
+	void __exit scmi_vio_##protocol##_unregister(void)
+
+DECLARE_SCMI_VIO_REGISTER_UNREGISTER(base);
+#endif /* _SCMI_VIO_BE_H */
diff --git a/drivers/firmware/arm_scmi/virtio_backend/backend_protocol.h b/drivers/firmware/arm_scmi/virtio_backend/backend_protocol.h
new file mode 100644
index 000000000000..a11f24301ff2
--- /dev/null
+++ b/drivers/firmware/arm_scmi/virtio_backend/backend_protocol.h
@@ -0,0 +1,93 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2022 Qualcomm Innovation Center, Inc. All rights reserved.
+ */
+
+#ifndef _SCMI_VIO_BE_PROTOCOL_H
+#define _SCMI_VIO_BE_PROTOCOL_H
+
+#include <linux/bitfield.h>
+
+#define SCMI_VIO_BE_SUCCESS	0
+#define SCMI_VIO_BE_NOT_SUPPORTED	-1
+#define SCMI_VIO_BE_INVALID_PARAMETERS	-2
+#define SCMI_VIO_BE_DENIED	-3
+#define SCMI_VIO_BE_NOT_FOUND	-4
+#define SCMI_VIO_BE_OUT_OF_RANGE	-5
+#define SCMI_VIO_BE_BUSY	-6
+#define SCMI_VIO_BE_COMMS_ERROR	-7
+#define SCMI_VIO_BE_GENERIC_ERROR	-8
+#define SCMI_VIO_BE_HARDWARE_ERROR	-9
+#define SCMI_VIO_BE_PROTOCOL_ERROR	-10
+
+#define SCMI_VIO_BE_VER_MINOR_MASK	GENMASK(15, 0)
+#define SCMI_VIO_BE_VER_MAJOR_MASK	GENMASK(31, 16)
+
+#define SCMI_VIO_BE_PROTO_MAJOR_VERSION(val) \
+	((u32)FIELD_PREP(SCMI_VIO_BE_VER_MAJOR_MASK, (val)))
+#define SCMI_VIO_BE_PROTO_MINOR_VERSION(val) \
+	((u32)FIELD_PREP(SCMI_VIO_BE_VER_MINOR_MASK, (val)))
+
+#define SCMI_VIO_BE_PROTO_VERSION(major, minor) \
+	(SCMI_VIO_BE_PROTO_MAJOR_VERSION((major)) | \
+	 SCMI_VIO_BE_PROTO_MINOR_VERSION((minor)))
+
+static int __maybe_unused scmi_vio_linux_err_remap(const int errno)
+{
+	switch (errno) {
+	case 0:
+		return SCMI_VIO_BE_SUCCESS;
+	case -EOPNOTSUPP:
+		return SCMI_VIO_BE_NOT_SUPPORTED;
+	case -EINVAL:
+		return SCMI_VIO_BE_INVALID_PARAMETERS;
+	case -EACCES:
+		return SCMI_VIO_BE_DENIED;
+	case -ENOENT:
+		return SCMI_VIO_BE_NOT_FOUND;
+	case -ERANGE:
+		return SCMI_VIO_BE_OUT_OF_RANGE;
+	case -EBUSY:
+		return SCMI_VIO_BE_BUSY;
+	case -ECOMM:
+		return SCMI_VIO_BE_COMMS_ERROR;
+	case -EIO:
+		return SCMI_VIO_BE_GENERIC_ERROR;
+	case -EREMOTEIO:
+		return SCMI_VIO_BE_HARDWARE_ERROR;
+	case -EPROTO:
+		return SCMI_VIO_BE_PROTOCOL_ERROR;
+	default:
+		return SCMI_VIO_BE_GENERIC_ERROR;
+	}
+}
+
+int scmi_vio_protocol_register(const struct scmi_vio_protocol *proto);
+void scmi_vio_protocol_unregister(const struct scmi_vio_protocol *proto);
+
+void *scmi_vio_get_protocol_priv(
+	const struct scmi_vio_protocol_h *__maybe_unused prot_handle,
+	const struct scmi_vio_client_h *client_h);
+void scmi_vio_set_protocol_priv(
+	const struct scmi_vio_protocol_h *__maybe_unused prot_handle,
+	const struct scmi_vio_client_h *client_h,
+	void *priv);
+
+int scmi_vio_implemented_protocols(
+	const struct scmi_vio_protocol_h *__maybe_unused prot_handle,
+	const struct scmi_vio_client_h *__maybe_unused client_h,
+	u8 *imp_protocols, int *imp_proto_num);
+
+#define DEFINE_SCMI_VIO_PROT_REG_UNREG(name, proto)	\
+static const struct scmi_vio_protocol *__this_proto = &(proto);	\
+									\
+int __init scmi_vio_##name##_register(void)			\
+{								\
+	return scmi_vio_protocol_register(__this_proto);	\
+}								\
+								\
+void __exit scmi_vio_##name##_unregister(void)		\
+{								\
+	scmi_vio_protocol_unregister(__this_proto);		\
+}
+#endif /* _SCMI_VIO_BE_PROTOCOL_H */
diff --git a/drivers/firmware/arm_scmi/virtio_backend/base.c b/drivers/firmware/arm_scmi/virtio_backend/base.c
new file mode 100644
index 000000000000..465b609dcdab
--- /dev/null
+++ b/drivers/firmware/arm_scmi/virtio_backend/base.c
@@ -0,0 +1,474 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2022 Qualcomm Innovation Center, Inc. All rights reserved.
+ */
+
+#include <linux/device.h>
+#include <linux/export.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/scmi_protocol.h>
+#include <linux/scmi_vio_backend.h>
+#include <linux/slab.h>
+#include <linux/bitfield.h>
+#include <linux/byteorder/generic.h>
+
+#include "common.h"
+#include "backend.h"
+#include "client_handle.h"
+
+#include "../common.h"
+#include "backend_protocol.h"
+
+#define SCMI_VIO_BASE_NUM_AGENTS	1
+#define SCMI_VIO_BASE_AGENT_MASK	GENMASK(15, 8)
+#define SCMI_VIO_BASE_NUM_AGENT(num) \
+	((u32)FIELD_PREP(SCMI_VIO_BASE_AGENT_MASK, (num)))
+#define SCMI_VIO_BASE_NUM_PROT_MASK	GENMASK(7, 0)
+#define SCMI_VIO_BASE_NUM_PROT(num) \
+	((u32)FIELD_PREP(SCMI_VIO_BASE_NUM_PROT_MASK, (num)))
+#define SCMI_VIO_BASE_NUM_AGENT_PROTOCOL(num) \
+	(SCMI_VIO_BASE_NUM_AGENT(SCMI_VIO_BASE_NUM_AGENTS) | \
+	SCMI_VIO_BASE_NUM_PROT(num))
+
+#define SCMI_VIO_BASE_MAX_VENDORID_STR	16
+#define SCMI_VIO_BASE_IMP_VER	1
+
+/*
+ * Number of protocols returned in single call to
+ * DISCOVER_LIST_PROTOCOLS.
+ */
+#define SCMI_VIO_BASE_PROTO_LIST_LEN	8
+
+struct scmi_vio_base_info {
+	const struct scmi_vio_protocol_h *prot_h;
+};
+
+static struct scmi_vio_base_info *scmi_vio_base_proto_info;
+
+struct scmi_vio_base_client_info {
+	const struct scmi_vio_client_h *client_h;
+	u8 *implemented_protocols;
+	int implemented_proto_num;
+};
+
+struct scmi_vio_base_version_resp {
+	__le32 status;
+	__le32 version;
+} __packed;
+
+struct scmi_vio_base_attr_resp {
+	__le32 status;
+	__le32 attributes;
+} __packed;
+
+struct scmi_vio_base_msg_attr_resp {
+	__le32 status;
+	__le32 attributes;
+} __packed;
+
+struct scmi_vio_base_imp_version_resp {
+	__le32 status;
+	__le32 imp_version;
+} __packed;
+
+struct scmi_vio_base_list_protocols_resp {
+	__le32 num_protocols;
+	u8 *protocols;
+} __packed;
+
+static int scmi_vio_base_open(
+	const struct scmi_vio_client_h *client_h)
+{
+	struct scmi_vio_base_client_info *base_client_info =
+		kzalloc(sizeof(*base_client_info),
+			GFP_KERNEL);
+	if (!base_client_info)
+		return -ENOMEM;
+	base_client_info->client_h = client_h;
+	base_client_info->implemented_protocols = kcalloc(
+		sizeof(u8), MAX_PROTOCOLS_IMP,
+		GFP_KERNEL);
+	if (!base_client_info->implemented_protocols)
+		return -ENOMEM;
+	base_client_info->implemented_proto_num = MAX_PROTOCOLS_IMP;
+	scmi_vio_implemented_protocols(
+		scmi_vio_base_proto_info->prot_h,
+		client_h, base_client_info->implemented_protocols,
+		&base_client_info->implemented_proto_num);
+	scmi_vio_set_protocol_priv(
+		scmi_vio_base_proto_info->prot_h,
+		client_h, base_client_info);
+
+	return 0;
+}
+
+static s32 scmi_vio_base_version_get(u32 *version)
+{
+	*version = SCMI_VIO_BE_PROTO_VERSION(2, 0);
+	return SCMI_VIO_BE_SUCCESS;
+}
+
+static s32 scmi_vio_base_attributes_get(int num_protocols, u32 *attributes)
+{
+	*attributes = SCMI_VIO_BASE_NUM_AGENT_PROTOCOL(num_protocols);
+	return SCMI_VIO_BE_SUCCESS;
+}
+
+static s32 scmi_vio_base_msg_attibutes_get(u32 msg_id, u32 *attributes)
+{
+	*attributes = 0;
+	switch (msg_id) {
+	case PROTOCOL_VERSION:
+	case PROTOCOL_ATTRIBUTES:
+	case PROTOCOL_MESSAGE_ATTRIBUTES:
+	case BASE_DISCOVER_VENDOR:
+	case BASE_DISCOVER_IMPLEMENT_VERSION:
+	case BASE_DISCOVER_LIST_PROTOCOLS:
+		return SCMI_VIO_BE_SUCCESS;
+	case BASE_DISCOVER_AGENT:
+	case BASE_NOTIFY_ERRORS:
+	case BASE_SET_DEVICE_PERMISSIONS:
+	case BASE_SET_PROTOCOL_PERMISSIONS:
+	case BASE_RESET_AGENT_CONFIGURATION:
+		return SCMI_VIO_BE_NOT_FOUND;
+	default:
+		return SCMI_VIO_BE_NOT_FOUND;
+	}
+}
+
+static s32 scmi_vio_base_vendor_get(char *vendor_id)
+{
+	char vendor[SCMI_VIO_BASE_MAX_VENDORID_STR] = "SCMI-VIO-BE";
+
+	strscpy(vendor_id, vendor, SCMI_VIO_BASE_MAX_VENDORID_STR);
+	return SCMI_VIO_BE_SUCCESS;
+}
+
+static s32 scmi_vio_base_imp_version_get(u32 *imp_version)
+{
+	*imp_version = SCMI_VIO_BASE_IMP_VER;
+	return SCMI_VIO_BE_SUCCESS;
+}
+
+static s32 scmi_vio_protocol_list_get(
+	const u8 *implemented_protocols, const int num_protocols_imp,
+	u32 skip, u32 *num_protocols,
+	u8 *protocols, int protocols_len)
+{
+	int i = 0;
+
+	if (skip >= num_protocols_imp) {
+		*num_protocols = 0;
+		return SCMI_VIO_BE_INVALID_PARAMETERS;
+	}
+	while (i < protocols_len && skip < num_protocols_imp) {
+		protocols[i] = implemented_protocols[skip];
+		i++;
+		skip++;
+	}
+	*num_protocols = i;
+	return SCMI_VIO_BE_SUCCESS;
+}
+
+static int debug_resp_size(
+	struct scmi_vio_be_payload_buf *resp_payload_buf,
+	u8 msg_id, size_t required_size)
+{
+	if (resp_payload_buf->payload_size < required_size) {
+		pr_err("Invalid response buffer size : %#zx required: %#zx for protocol: %#x msg: %#x\n",
+			resp_payload_buf->payload_size, required_size,
+			SCMI_PROTOCOL_BASE, msg_id);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int handle_protocol_ver(
+	struct scmi_vio_be_payload_buf *resp_payload_buf)
+{
+	int err;
+	s32 ret;
+	u32 version = 0;
+	size_t msg_resp_size;
+	struct scmi_vio_base_version_resp *ver_response;
+
+	msg_resp_size = sizeof(version) + sizeof(ret);
+	err = debug_resp_size(resp_payload_buf, PROTOCOL_VERSION,
+				msg_resp_size);
+	if (err)
+		return err;
+	ret = scmi_vio_base_version_get(&version);
+	ver_response = (struct scmi_vio_base_version_resp *)resp_payload_buf->payload;
+	ver_response->status = cpu_to_le32(ret);
+	ver_response->version = cpu_to_le32(version);
+	resp_payload_buf->payload_size = msg_resp_size;
+
+	return 0;
+}
+
+static int handle_protocol_attrs(int num_protocols,
+	struct scmi_vio_be_payload_buf *resp_payload_buf)
+{
+	int err;
+	s32 ret;
+	u32 attributes = 0;
+	size_t msg_resp_size;
+	struct scmi_vio_base_attr_resp *attr_response;
+
+	msg_resp_size = sizeof(attributes) + sizeof(ret);
+	err = debug_resp_size(resp_payload_buf, PROTOCOL_ATTRIBUTES,
+				 msg_resp_size);
+	if (err)
+		return err;
+	ret = scmi_vio_base_attributes_get(num_protocols, &attributes);
+	attr_response = (struct scmi_vio_base_attr_resp *)resp_payload_buf->payload;
+	attr_response->status = cpu_to_le32(ret);
+	attr_response->attributes = cpu_to_le32(attributes);
+	resp_payload_buf->payload_size = msg_resp_size;
+
+	return 0;
+}
+
+static int handle_msg_attrs(
+	const struct scmi_vio_be_payload_buf *req_payload_buf,
+	struct scmi_vio_be_payload_buf *resp_payload_buf)
+{
+	int err;
+	s32 ret;
+	u32 req_msg_id = 0;
+	size_t msg_resp_size;
+	u32 msg_attributes = 0;
+	struct scmi_vio_base_msg_attr_resp *msg_attr_response;
+
+	msg_resp_size = sizeof(msg_attributes) + sizeof(ret);
+	err = debug_resp_size(
+		resp_payload_buf, PROTOCOL_MESSAGE_ATTRIBUTES,
+		msg_resp_size);
+	if (err)
+		return err;
+	if (req_payload_buf->payload_size < sizeof(req_msg_id)) {
+		pr_err("Invalid request buffer size : %#zx required: %#zx for protocol: %#x msg: %#x\n",
+			req_payload_buf->payload_size, sizeof(req_msg_id),
+			SCMI_PROTOCOL_BASE, PROTOCOL_MESSAGE_ATTRIBUTES);
+		return -EINVAL;
+	}
+	req_msg_id = le32_to_cpu(*((__le32 *)req_payload_buf->payload));
+	ret = scmi_vio_base_msg_attibutes_get(req_msg_id, &msg_attributes);
+	msg_attr_response =
+		(struct scmi_vio_base_msg_attr_resp *)resp_payload_buf->payload;
+	msg_attr_response->status = cpu_to_le32(ret);
+	msg_attr_response->attributes = cpu_to_le32(msg_attributes);
+	resp_payload_buf->payload_size = msg_resp_size;
+
+	return 0;
+}
+
+static int handle_discover_vendor(
+	struct scmi_vio_be_payload_buf *resp_payload_buf)
+{
+	int err;
+	s32 ret;
+	size_t vendor_id_sz;
+	size_t msg_resp_size;
+	void *vendor_payload;
+	char vendor[SCMI_VIO_BASE_MAX_VENDORID_STR];
+
+	msg_resp_size = (size_t)SCMI_VIO_BASE_MAX_VENDORID_STR +
+			sizeof(ret);
+	err = debug_resp_size(
+		resp_payload_buf, BASE_DISCOVER_VENDOR,
+		msg_resp_size);
+	ret = scmi_vio_base_vendor_get(vendor);
+	WARN_ON(strlen(vendor) >= SCMI_VIO_BASE_MAX_VENDORID_STR);
+	vendor_id_sz = (size_t)min_t(size_t, (size_t)(strlen(vendor) + 1),
+					(size_t)SCMI_VIO_BASE_MAX_VENDORID_STR);
+	*(__le32 *)resp_payload_buf->payload = cpu_to_le32(ret);
+	vendor_payload =
+		(void *)((unsigned long)(uintptr_t)resp_payload_buf->payload +
+			 (unsigned long)sizeof(ret));
+	memcpy((u8 *)vendor_payload, vendor, vendor_id_sz);
+	resp_payload_buf->payload_size = vendor_id_sz + sizeof(ret);
+
+	return 0;
+}
+
+static int handle_discover_imp_ver(
+	struct scmi_vio_be_payload_buf *resp_payload_buf)
+{
+	int err;
+	s32 ret;
+	u32 imp_version = 0;
+	size_t msg_resp_size;
+	struct scmi_vio_base_imp_version_resp *imp_ver_response;
+
+	msg_resp_size = sizeof(imp_version) + sizeof(ret);
+	err = debug_resp_size(resp_payload_buf,
+				 BASE_DISCOVER_IMPLEMENT_VERSION,
+				 msg_resp_size);
+	if (err)
+		return err;
+	ret = scmi_vio_base_imp_version_get(&imp_version);
+	imp_ver_response =
+		(struct scmi_vio_base_imp_version_resp *)resp_payload_buf->payload;
+	imp_ver_response->status = cpu_to_le32(ret);
+	imp_ver_response->imp_version = cpu_to_le32(imp_version);
+	resp_payload_buf->payload_size = msg_resp_size;
+
+	return 0;
+}
+
+static int handle_discover_list_protocols(
+	const struct scmi_vio_be_payload_buf *req_payload_buf,
+	struct scmi_vio_be_payload_buf *resp_payload_buf,
+	u8 *implemented_protocols, int num_protocols_imp)
+{
+	int err;
+	s32 ret;
+	u32 num_protocols = 0;
+	size_t msg_resp_size;
+	u32 protocol_skip_count;
+	void *protocol_list_payload;
+	void *protocol_num_payload;
+	u8 proto_list[SCMI_VIO_BASE_PROTO_LIST_LEN];
+
+	msg_resp_size = sizeof(u8) * SCMI_VIO_BASE_PROTO_LIST_LEN +
+			sizeof(ret);
+	err = debug_resp_size(
+		resp_payload_buf, BASE_DISCOVER_LIST_PROTOCOLS,
+		msg_resp_size);
+	if (err)
+		return err;
+	if (req_payload_buf->payload_size < sizeof(protocol_skip_count)) {
+		pr_err("Invalid request buffer size : %#zx required: %#zx for protocol: %#x msg: %#x\n",
+			req_payload_buf->payload_size, sizeof(protocol_skip_count),
+			SCMI_PROTOCOL_BASE, BASE_DISCOVER_LIST_PROTOCOLS);
+		return -EINVAL;
+	}
+	protocol_skip_count =
+		le32_to_cpu((*(__le32 *)req_payload_buf->payload));
+	ret = scmi_vio_protocol_list_get(
+		implemented_protocols, num_protocols_imp,
+		protocol_skip_count, &num_protocols,
+		proto_list, SCMI_VIO_BASE_PROTO_LIST_LEN);
+	*(__le32 *)resp_payload_buf->payload = cpu_to_le32(ret);
+	protocol_num_payload =
+		(void *)((unsigned long)(uintptr_t)resp_payload_buf->payload +
+			 (unsigned long)sizeof(ret));
+	*(__le32 *)protocol_num_payload = cpu_to_le32(num_protocols);
+	if (num_protocols > 0) {
+		pr_info("%s: num_protocols:%d\n", __func__, num_protocols);
+		protocol_list_payload =
+			(void *)((unsigned long)(uintptr_t)resp_payload_buf->payload +
+			 (unsigned long)sizeof(ret) + (unsigned long)sizeof(num_protocols));
+		memcpy((u8 *)protocol_list_payload, proto_list, num_protocols);
+	}
+	resp_payload_buf->payload_size =
+		num_protocols * sizeof(u8) + sizeof(num_protocols) + sizeof(ret);
+
+	return 0;
+}
+
+static int scmi_vio_base_msg_handle(
+	const struct scmi_vio_client_h *client_h,
+	const struct scmi_vio_be_msg_hdr *msg_hdr,
+	const struct scmi_vio_be_payload_buf *req_payload_buf,
+	struct scmi_vio_be_payload_buf *resp_payload_buf)
+{
+	int err;
+	size_t msg_resp_size;
+	struct scmi_vio_base_client_info *base_client_info;
+
+	base_client_info = (struct scmi_vio_base_client_info *)
+		scmi_vio_get_protocol_priv(
+			scmi_vio_base_proto_info->prot_h,
+			client_h);
+	WARN_ON(client_h != base_client_info->client_h);
+
+	WARN_ON(msg_hdr->protocol_id != SCMI_PROTOCOL_BASE);
+	switch (msg_hdr->msg_id) {
+	case PROTOCOL_VERSION:
+		return handle_protocol_ver(resp_payload_buf);
+	case PROTOCOL_ATTRIBUTES:
+		return handle_protocol_attrs(
+			base_client_info->implemented_proto_num,
+			resp_payload_buf);
+	case PROTOCOL_MESSAGE_ATTRIBUTES:
+		return handle_msg_attrs(req_payload_buf, resp_payload_buf);
+	case BASE_DISCOVER_VENDOR:
+		return handle_discover_vendor(resp_payload_buf);
+	case BASE_DISCOVER_IMPLEMENT_VERSION:
+		return handle_discover_imp_ver(resp_payload_buf);
+	case BASE_DISCOVER_LIST_PROTOCOLS:
+		return handle_discover_list_protocols(
+			req_payload_buf, resp_payload_buf,
+			base_client_info->implemented_protocols,
+			base_client_info->implemented_proto_num);
+	default:
+		pr_err("Msg id %#x not supported for base protocol\n",
+				msg_hdr->msg_id);
+		msg_resp_size = sizeof(u32);
+		err = debug_resp_size(resp_payload_buf, msg_hdr->msg_id,
+					 msg_resp_size);
+		if (err)
+			return err;
+		*(__le32 *)resp_payload_buf->payload =
+				cpu_to_le32(SCMI_VIO_BE_NOT_FOUND);
+		resp_payload_buf->payload_size = sizeof(u32);
+		break;
+	}
+
+	return 0;
+}
+
+
+static int scmi_vio_base_close(
+	const struct scmi_vio_client_h *client_h)
+{
+	struct scmi_vio_base_client_info *base_client_info;
+
+	base_client_info = (struct scmi_vio_base_client_info *)
+		scmi_vio_get_protocol_priv(
+			scmi_vio_base_proto_info->prot_h,
+			client_h);
+	WARN_ON(client_h != base_client_info->client_h);
+	kfree(base_client_info->implemented_protocols);
+	kfree(base_client_info);
+	return 0;
+}
+
+const struct scmi_vio_protocol_ops scmi_vio_base_ops = {
+	.open = scmi_vio_base_open,
+	.msg_handle = scmi_vio_base_msg_handle,
+	.close = scmi_vio_base_close,
+};
+
+int scmi_vio_base_init_fn(
+	const struct scmi_vio_protocol_h *prot_h)
+{
+	scmi_vio_base_proto_info = kzalloc(
+		sizeof(*scmi_vio_base_proto_info),
+		GFP_KERNEL);
+	if (!scmi_vio_base_proto_info)
+		return -ENOMEM;
+	scmi_vio_base_proto_info->prot_h = prot_h;
+	return 0;
+}
+
+int scmi_vio_base_exit_fn(
+	const struct scmi_vio_protocol_h *prot_h)
+{
+	kfree(scmi_vio_base_proto_info);
+	scmi_vio_base_proto_info = NULL;
+
+	return 0;
+}
+
+const struct scmi_vio_protocol scmi_vio_base_protocol = {
+	.id = SCMI_PROTOCOL_BASE,
+	.prot_init_fn = scmi_vio_base_init_fn,
+	.prot_exit_fn = scmi_vio_base_exit_fn,
+	.prot_ops = &scmi_vio_base_ops,
+};
+
+DEFINE_SCMI_VIO_PROT_REG_UNREG(base, scmi_vio_base_protocol);
diff --git a/drivers/firmware/arm_scmi/virtio_backend/client_handle.c b/drivers/firmware/arm_scmi/virtio_backend/client_handle.c
new file mode 100644
index 000000000000..1d53ec12e459
--- /dev/null
+++ b/drivers/firmware/arm_scmi/virtio_backend/client_handle.c
@@ -0,0 +1,71 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2022 Qualcomm Innovation Center, Inc. All rights reserved.
+ */
+
+
+#include <linux/slab.h>
+#include <linux/scmi_vio_backend.h>
+
+#define to_client_info(clienth) \
+	container_of((clienth), struct scmi_vio_client_info, \
+		     client_h)
+
+/*
+ * scmi_vio_client_info - Structure respreseting information
+ * associated with a client handle.
+ *
+ * @client_h: Opaque handle used as agent/client idenitifier.
+ * @priv: Private data mainted by SCMI Virtio Backend, for
+ *               an agent/client.
+ *               This pointer can be used by backend, to maintain,
+ *               per protocol private information. This pointer is
+ *               typically populated by SCMI backend, on open() call
+ *               by client, by calling scmi_vio_set_client_priv().
+ */
+struct scmi_vio_client_info {
+	struct scmi_vio_client_h client_h;
+	void *priv;
+};
+
+struct scmi_vio_client_h *scmi_vio_get_client_h(
+	const void *handle)
+{
+	struct scmi_vio_client_info *client_info =
+		kzalloc(sizeof(*client_info), GFP_KERNEL);
+
+	if (!client_info)
+		return NULL;
+	client_info->client_h.handle = handle;
+	return &client_info->client_h;
+}
+EXPORT_SYMBOL_GPL(scmi_vio_get_client_h);
+
+void scmi_vio_put_client_h(
+	const struct scmi_vio_client_h *client_h)
+{
+	struct scmi_vio_client_info *client_info =
+			to_client_info(client_h);
+
+	kfree(client_info);
+}
+EXPORT_SYMBOL_GPL(scmi_vio_put_client_h);
+
+void *scmi_vio_get_client_priv(
+		const struct scmi_vio_client_h *client_h)
+{
+	struct scmi_vio_client_info *client_info =
+			to_client_info(client_h);
+
+	return client_info->priv;
+}
+
+void scmi_vio_set_client_priv(
+		const struct scmi_vio_client_h *client_h,
+		void *priv)
+{
+	struct scmi_vio_client_info *client_info =
+			to_client_info(client_h);
+
+	client_info->priv = priv;
+}
diff --git a/drivers/firmware/arm_scmi/virtio_backend/client_handle.h b/drivers/firmware/arm_scmi/virtio_backend/client_handle.h
new file mode 100644
index 000000000000..2cb2dcbb8481
--- /dev/null
+++ b/drivers/firmware/arm_scmi/virtio_backend/client_handle.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2022 Qualcomm Innovation Center, Inc. All rights reserved.
+ */
+#ifndef _SCMI_VIO_BE_CLIENT_HANDLE_H
+#define _SCMI_VIO_BE_CLIENT_HANDLE_H
+
+/**
+ * scmi_vio_get_client_h: This function in used by callers
+ * to construct a unique client handle, enclosing the client handle.
+ */
+struct scmi_vio_client_h *scmi_vio_get_client_h(
+	const void *handle);
+
+
+/**
+ * scmi_vio_put_client_h: This function in used by callers
+ * to release the client handle, and any private data associated
+ * with it.
+ */
+void scmi_vio_put_client_h(
+	const struct scmi_vio_client_h *client_h);
+
+#endif /*_SCMI_VIO_BE_CLIENT_HANDLE_H */
diff --git a/drivers/firmware/arm_scmi/virtio_backend/common.h b/drivers/firmware/arm_scmi/virtio_backend/common.h
new file mode 100644
index 000000000000..7797a4c1e7a2
--- /dev/null
+++ b/drivers/firmware/arm_scmi/virtio_backend/common.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2022 Qualcomm Innovation Center, Inc. All rights reserved.
+ */
+
+#ifndef _SCMI_VIO_BE_COMMON_H
+#define _SCMI_VIO_BE_COMMON_H
+
+struct scmi_vio_protocol_h {
+	struct device *dev;
+};
+
+struct scmi_vio_be_payload_buf {
+	void *payload;
+	size_t payload_size;
+};
+
+struct scmi_vio_be_msg_hdr {
+	u8 msg_id;
+	u8 protocol_id;
+	u8 type;
+	u16 seq;
+};
+
+/**
+ * struct scmi_vio_protocol_ops - operations
+ *      supported by SCMI Virtio backend protocol drivers.
+ *
+ * @open: Notify protocol driver, about new client.
+ * @close: Notify protocol driver, about exiting client.
+ * @msg_handle: Unparcel a request and parcel response, to be sent over
+ *              client channels.
+ */
+struct scmi_vio_protocol_ops {
+	int (*open)(const struct scmi_vio_client_h *client_h);
+	int (*msg_handle)(const struct scmi_vio_client_h *client_h,
+			  const struct scmi_vio_be_msg_hdr *msg_hdr,
+			  const struct scmi_vio_be_payload_buf *req_payload_buf,
+			  struct scmi_vio_be_payload_buf *resp_payload_buf);
+	int (*close)(const struct scmi_vio_client_h *client_h);
+};
+
+typedef int (*scmi_vio_prot_init_fn_t)(const struct scmi_vio_protocol_h *);
+typedef int (*scmi_vio_prot_exit_fn_t)(const struct scmi_vio_protocol_h *);
+
+struct scmi_vio_protocol {
+	const u8 id;
+	const scmi_vio_prot_init_fn_t prot_init_fn;
+	const scmi_vio_prot_exit_fn_t prot_exit_fn;
+	const struct scmi_vio_protocol_ops *prot_ops;
+};
+
+#endif /* _SCMI_VIO_BE_COMMON_H */
diff --git a/include/linux/scmi_vio_backend.h b/include/linux/scmi_vio_backend.h
new file mode 100644
index 000000000000..1f33122c6856
--- /dev/null
+++ b/include/linux/scmi_vio_backend.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2021-2022 Qualcomm Innovation Center, Inc. All rights reserved.
+ */
+
+#ifndef _LINUX_SCMI_VIO_BACKEND_H
+#define _LINUX_SCMI_VIO_BACKEND_H
+
+#include <linux/idr.h>
+
+/**
+ * scmi_vio_client_h : Structure encapsulating a unique
+ * handle, identifying the client connection to SCMI
+ * Virtio backend.
+ */
+struct scmi_vio_client_h {
+	const void *handle;
+};
+
+struct scmi_vio_be_msg {
+	struct scmi_msg_payld *msg_payld;
+	size_t msg_sz;
+};
+
+int scmi_vio_be_open(const struct scmi_vio_client_h *client_h);
+int scmi_vio_be_close(const struct scmi_vio_client_h *client_h);
+int scmi_vio_be_request(const struct scmi_vio_client_h *client_h,
+			const struct scmi_vio_be_msg *req,
+			struct scmi_vio_be_msg *resp);
+
+#endif /* _LINUX_SCMI_VIO_BACKEND_H */
-- 
2.17.1

