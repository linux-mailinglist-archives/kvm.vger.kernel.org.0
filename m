Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72BBA1D6046
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 12:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgEPKLT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 May 2020 06:11:19 -0400
Received: from mga12.intel.com ([192.55.52.136]:36845 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbgEPKLS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 May 2020 06:11:18 -0400
IronPort-SDR: yYXRVgn0hXwqOYeRoP9a80yJ+tAMsijtmtaTJg0yumcwik6n1oc4pPaJ7/UpckjFiybC+fRvLB
 7c4ZKXinda9A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2020 03:11:17 -0700
IronPort-SDR: SH3VsvpKROuw7c/msrHCv9CglDMCVjUnm1F3kAoZco+F5BE1g1ykXqm45M3dPBBhHROYd6JNGl
 DadyMY15mU7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,398,1583222400"; 
   d="scan'208";a="281484336"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu.ger.corp.intel.com) ([10.249.40.45])
  by orsmga002.jf.intel.com with ESMTP; 16 May 2020 03:11:15 -0700
From:   Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>
Subject: [PATCH 3/6] rpmsg: move common structures and defines to headers
Date:   Sat, 16 May 2020 12:11:06 +0200
Message-Id: <20200516101109.2624-4-guennadi.liakhovetski@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200516101109.2624-1-guennadi.liakhovetski@linux.intel.com>
References: <20200516101109.2624-1-guennadi.liakhovetski@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

virtio_rpmsg_bus.c keeps RPMsg protocol structure declarations and
common defines like the ones, needed for name-space announcements,
internal. Move them to common headers instead.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
---
 drivers/rpmsg/virtio_rpmsg_bus.c | 78 +-------------------------------------
 include/linux/virtio_rpmsg.h     | 81 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/rpmsg.h       |  3 ++
 3 files changed, 86 insertions(+), 76 deletions(-)
 create mode 100644 include/linux/virtio_rpmsg.h

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index 07d4f33..f3bd050 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -25,7 +25,9 @@
 #include <linux/virtio.h>
 #include <linux/virtio_ids.h>
 #include <linux/virtio_config.h>
+#include <linux/virtio_rpmsg.h>
 #include <linux/wait.h>
+#include <uapi/linux/rpmsg.h>
 
 #include "rpmsg_internal.h"
 
@@ -69,58 +71,6 @@ struct virtproc_info {
 	struct rpmsg_endpoint *ns_ept;
 };
 
-/* The feature bitmap for virtio rpmsg */
-#define VIRTIO_RPMSG_F_NS	0 /* RP supports name service notifications */
-
-/**
- * struct rpmsg_hdr - common header for all rpmsg messages
- * @src: source address
- * @dst: destination address
- * @reserved: reserved for future use
- * @len: length of payload (in bytes)
- * @flags: message flags
- * @data: @len bytes of message payload data
- *
- * Every message sent(/received) on the rpmsg bus begins with this header.
- */
-struct rpmsg_hdr {
-	u32 src;
-	u32 dst;
-	u32 reserved;
-	u16 len;
-	u16 flags;
-	u8 data[];
-} __packed;
-
-/**
- * struct rpmsg_ns_msg - dynamic name service announcement message
- * @name: name of remote service that is published
- * @addr: address of remote service that is published
- * @flags: indicates whether service is created or destroyed
- *
- * This message is sent across to publish a new service, or announce
- * about its removal. When we receive these messages, an appropriate
- * rpmsg channel (i.e device) is created/destroyed. In turn, the ->probe()
- * or ->remove() handler of the appropriate rpmsg driver will be invoked
- * (if/as-soon-as one is registered).
- */
-struct rpmsg_ns_msg {
-	char name[RPMSG_NAME_SIZE];
-	u32 addr;
-	u32 flags;
-} __packed;
-
-/**
- * enum rpmsg_ns_flags - dynamic name service announcement flags
- *
- * @RPMSG_NS_CREATE: a new remote service was just created
- * @RPMSG_NS_DESTROY: a known remote service was just destroyed
- */
-enum rpmsg_ns_flags {
-	RPMSG_NS_CREATE		= 0,
-	RPMSG_NS_DESTROY	= 1,
-};
-
 /**
  * @vrp: the remote processor this channel belongs to
  */
@@ -134,36 +84,12 @@ struct virtio_rpmsg_channel {
 	container_of(_rpdev, struct virtio_rpmsg_channel, rpdev)
 
 /*
- * We're allocating buffers of 512 bytes each for communications. The
- * number of buffers will be computed from the number of buffers supported
- * by the vring, upto a maximum of 512 buffers (256 in each direction).
- *
- * Each buffer will have 16 bytes for the msg header and 496 bytes for
- * the payload.
- *
- * This will utilize a maximum total space of 256KB for the buffers.
- *
- * We might also want to add support for user-provided buffers in time.
- * This will allow bigger buffer size flexibility, and can also be used
- * to achieve zero-copy messaging.
- *
- * Note that these numbers are purely a decision of this driver - we
- * can change this without changing anything in the firmware of the remote
- * processor.
- */
-#define MAX_RPMSG_NUM_BUFS	(512)
-#define MAX_RPMSG_BUF_SIZE	(512)
-
-/*
  * Local addresses are dynamically allocated on-demand.
  * We do not dynamically assign addresses from the low 1024 range,
  * in order to reserve that address range for predefined services.
  */
 #define RPMSG_RESERVED_ADDRESSES	(1024)
 
-/* Address 53 is reserved for advertising remote services */
-#define RPMSG_NS_ADDR			(53)
-
 static void virtio_rpmsg_destroy_ept(struct rpmsg_endpoint *ept);
 static int virtio_rpmsg_send(struct rpmsg_endpoint *ept, void *data, int len);
 static int virtio_rpmsg_sendto(struct rpmsg_endpoint *ept, void *data, int len,
diff --git a/include/linux/virtio_rpmsg.h b/include/linux/virtio_rpmsg.h
new file mode 100644
index 00000000..bf2fd69
--- /dev/null
+++ b/include/linux/virtio_rpmsg.h
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#ifndef _LINUX_VIRTIO_RPMSG_H
+#define _LINUX_VIRTIO_RPMSG_H
+
+#include <linux/mod_devicetable.h>
+
+/* Address 53 is reserved for advertising remote services */
+#define RPMSG_NS_ADDR			(53)
+
+/*
+ * We're allocating buffers of 512 bytes each for communications. The
+ * number of buffers will be computed from the number of buffers supported
+ * by the vring, upto a maximum of 512 buffers (256 in each direction).
+ *
+ * Each buffer will have 16 bytes for the msg header and 496 bytes for
+ * the payload.
+ *
+ * This will utilize a maximum total space of 256KB for the buffers.
+ *
+ * We might also want to add support for user-provided buffers in time.
+ * This will allow bigger buffer size flexibility, and can also be used
+ * to achieve zero-copy messaging.
+ *
+ * Note that these numbers are purely a decision of this driver - we
+ * can change this without changing anything in the firmware of the remote
+ * processor.
+ */
+#define MAX_RPMSG_NUM_BUFS	512
+#define MAX_RPMSG_BUF_SIZE	512
+
+/**
+ * struct rpmsg_hdr - common header for all rpmsg messages
+ * @src: source address
+ * @dst: destination address
+ * @reserved: reserved for future use
+ * @len: length of payload (in bytes)
+ * @flags: message flags
+ * @data: @len bytes of message payload data
+ *
+ * Every message sent(/received) on the rpmsg bus begins with this header.
+ */
+struct rpmsg_hdr {
+	u32 src;
+	u32 dst;
+	u32 reserved;
+	u16 len;
+	u16 flags;
+	u8 data[];
+} __packed;
+
+/**
+ * struct rpmsg_ns_msg - dynamic name service announcement message
+ * @name: name of remote service that is published
+ * @addr: address of remote service that is published
+ * @flags: indicates whether service is created or destroyed
+ *
+ * This message is sent across to publish a new service, or announce
+ * about its removal. When we receive these messages, an appropriate
+ * rpmsg channel (i.e device) is created/destroyed. In turn, the ->probe()
+ * or ->remove() handler of the appropriate rpmsg driver will be invoked
+ * (if/as-soon-as one is registered).
+ */
+struct rpmsg_ns_msg {
+	char name[RPMSG_NAME_SIZE];
+	u32 addr;
+	u32 flags;
+} __packed;
+
+/**
+ * enum rpmsg_ns_flags - dynamic name service announcement flags
+ *
+ * @RPMSG_NS_CREATE: a new remote service was just created
+ * @RPMSG_NS_DESTROY: a known remote service was just destroyed
+ */
+enum rpmsg_ns_flags {
+	RPMSG_NS_CREATE		= 0,
+	RPMSG_NS_DESTROY	= 1,
+};
+
+#endif
diff --git a/include/uapi/linux/rpmsg.h b/include/uapi/linux/rpmsg.h
index e14c6da..d669c04 100644
--- a/include/uapi/linux/rpmsg.h
+++ b/include/uapi/linux/rpmsg.h
@@ -24,4 +24,7 @@ struct rpmsg_endpoint_info {
 #define RPMSG_CREATE_EPT_IOCTL	_IOW(0xb5, 0x1, struct rpmsg_endpoint_info)
 #define RPMSG_DESTROY_EPT_IOCTL	_IO(0xb5, 0x2)
 
+/* The feature bitmap for virtio rpmsg */
+#define VIRTIO_RPMSG_F_NS	0 /* RP supports name service notifications */
+
 #endif
-- 
1.9.3

