Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD762040D9
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 22:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbgFVUD6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 16:03:58 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:63405 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728705AbgFVUD5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 16:03:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1592856235; x=1624392235;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HN3iuqvXzazy6PTJ1frneZ9rbwR5fbtHmHH+MbPMD/k=;
  b=afcyCd/TgZsvLt0UxUSA3wJhYuj9cpvUkDaYeaSLB2V+tg+YHQBSvxT5
   +cbCTS3CqoIOO7i1BObngJMgaDk/ewbRiOVC43C222L7hiKhQG2WCiJ7E
   WDVOB3U62hdxpCourCM0xhVA64U/oienNy4o/1jB1Hf2+WR5B/DwBr7Pc
   A=;
IronPort-SDR: NHQe3lmSg5yRLmjpRtheXB8GcwxwC8mkmRcPoh84ltl9ccV1yGNluRsTraI2rTXK7iWkuO3mJ4
 J1GXhPMt3eYQ==
X-IronPort-AV: E=Sophos;i="5.75,268,1589241600"; 
   d="scan'208";a="46040881"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 22 Jun 2020 20:03:55 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com (Postfix) with ESMTPS id A0D72A1D12;
        Mon, 22 Jun 2020 20:03:54 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 22 Jun 2020 20:03:54 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.145) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 22 Jun 2020 20:03:44 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Bjoern Doebel" <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        Martin Pohlack <mpohlack@amazon.de>,
        "Matt Wilson" <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        "Uwe Dannowski" <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v4 01/18] nitro_enclaves: Add ioctl interface definition
Date:   Mon, 22 Jun 2020 23:03:12 +0300
Message-ID: <20200622200329.52996-2-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200622200329.52996-1-andraprs@amazon.com>
References: <20200622200329.52996-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.145]
X-ClientProxiedBy: EX13D12UWC002.ant.amazon.com (10.43.162.253) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Nitro Enclaves driver handles the enclave lifetime management. This
includes enclave creation, termination and setting up its resources such
as memory and CPU.

An enclave runs alongside the VM that spawned it. It is abstracted as a
process running in the VM that launched it. The process interacts with
the NE driver, that exposes an ioctl interface for creating an enclave
and setting up its resources.

Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
Changelog

v3 -> v4

* Decouple NE ioctl interface from KVM API.
* Add NE API version and the corresponding ioctl call.
* Add enclave / image load flags options.

v2 -> v3

* Remove the GPL additional wording as SPDX-License-Identifier is
  already in place.

v1 -> v2

* Add ioctl for getting enclave image load metadata.
* Update NE_ENCLAVE_START ioctl name to NE_START_ENCLAVE.
* Add entry in Documentation/userspace-api/ioctl/ioctl-number.rst for NE
  ioctls.
* Update NE ioctls definition based on the updated ioctl range for major
  and minor.
---
 .../userspace-api/ioctl/ioctl-number.rst      |   5 +-
 include/linux/nitro_enclaves.h                |  11 ++
 include/uapi/linux/nitro_enclaves.h           | 137 ++++++++++++++++++
 3 files changed, 152 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/nitro_enclaves.h
 create mode 100644 include/uapi/linux/nitro_enclaves.h

diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index 59472cd6a11d..783440c6719b 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -328,8 +328,11 @@ Code  Seq#    Include File                                           Comments
 0xAC  00-1F  linux/raw.h
 0xAD  00                                                             Netfilter device in development:
                                                                      <mailto:rusty@rustcorp.com.au>
-0xAE  all    linux/kvm.h                                             Kernel-based Virtual Machine
+0xAE  00-1F  linux/kvm.h                                             Kernel-based Virtual Machine
                                                                      <mailto:kvm@vger.kernel.org>
+0xAE  40-FF  linux/kvm.h                                             Kernel-based Virtual Machine
+                                                                     <mailto:kvm@vger.kernel.org>
+0xAE  20-3F  linux/nitro_enclaves.h                                  Nitro Enclaves
 0xAF  00-1F  linux/fsl_hypervisor.h                                  Freescale hypervisor
 0xB0  all                                                            RATIO devices in development:
                                                                      <mailto:vgo@ratio.de>
diff --git a/include/linux/nitro_enclaves.h b/include/linux/nitro_enclaves.h
new file mode 100644
index 000000000000..d91ef2bfdf47
--- /dev/null
+++ b/include/linux/nitro_enclaves.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ */
+
+#ifndef _LINUX_NITRO_ENCLAVES_H_
+#define _LINUX_NITRO_ENCLAVES_H_
+
+#include <uapi/linux/nitro_enclaves.h>
+
+#endif /* _LINUX_NITRO_ENCLAVES_H_ */
diff --git a/include/uapi/linux/nitro_enclaves.h b/include/uapi/linux/nitro_enclaves.h
new file mode 100644
index 000000000000..3270eb939a97
--- /dev/null
+++ b/include/uapi/linux/nitro_enclaves.h
@@ -0,0 +1,137 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ */
+
+#ifndef _UAPI_LINUX_NITRO_ENCLAVES_H_
+#define _UAPI_LINUX_NITRO_ENCLAVES_H_
+
+#include <linux/types.h>
+
+/* Nitro Enclaves (NE) Kernel Driver Interface */
+
+#define NE_API_VERSION (1)
+
+/**
+ * The command is used to get the version of the NE API. This way the user space
+ * processes can be aware of the feature sets provided by the NE kernel driver.
+ *
+ * The NE API version is returned as result of this ioctl call.
+ */
+#define NE_GET_API_VERSION _IO(0xAE, 0x20)
+
+/**
+ * The command is used to create a slot that is associated with an enclave VM.
+ *
+ * The generated unique slot id is a read parameter of this command. An enclave
+ * file descriptor is returned as result of this ioctl call. The enclave fd can
+ * be further used with ioctl calls to set vCPUs and memory regions, then start
+ * the enclave.
+ */
+#define NE_CREATE_VM _IOR(0xAE, 0x21, __u64)
+
+/**
+ * The command is used to set a vCPU for an enclave. A CPU pool needs to be set
+ * for enclave usage, before calling this function. CPU 0 and its siblings need
+ * to remain available for the primary / parent VM, so they cannot be set for
+ * an enclave.
+ *
+ * The vCPU id is a write / read parameter. If its value is 0, then a CPU is
+ * chosen from the enclave CPU pool and returned via this parameter. A vCPU file
+ * descriptor is returned as result of this ioctl call.
+ */
+#define NE_CREATE_VCPU _IOWR(0xAE, 0x22, __u32)
+
+/**
+ * The command is used to get information needed for in-memory enclave image
+ * loading e.g. offset in enclave memory to start placing the enclave image.
+ *
+ * The image load info is a write / read parameter. It includes info provided
+ * by the caller - flags - and returns the offset in enclave memory where to
+ * start placing the enclave image.
+ */
+#define NE_GET_IMAGE_LOAD_INFO _IOWR(0xAE, 0x23, struct ne_image_load_info)
+
+/**
+ * The command is used to set a memory region for an enclave, given the
+ * allocated memory from the userspace.
+ *
+ * The user memory region is a write parameter. It includes info provided
+ * by the caller - flags, memory size and userspace address.
+ */
+#define NE_SET_USER_MEMORY_REGION _IOW(0xAE, 0x24, struct ne_user_memory_region)
+
+/**
+ * The command is used to trigger enclave start after the enclave resources,
+ * such as memory and CPU, have been set.
+ *
+ * The enclave start info is a write / read parameter. It includes info provided
+ * by the caller - enclave cid and flags - and returns the cid (if input cid is
+ * 0).
+ */
+#define NE_START_ENCLAVE _IOWR(0xAE, 0x25, struct ne_enclave_start_info)
+
+/* Image load info flags */
+
+/* Enclave Image Format (EIF) */
+#define NE_EIF_IMAGE (0x01)
+
+/* Info necessary for in-memory enclave image loading (write / read). */
+struct ne_image_load_info {
+	/**
+	 * Flags to determine the enclave image type (e.g. Enclave Image Format
+	 * - EIF) (write).
+	 */
+	__u64 flags;
+
+	/**
+	 * Offset in enclave memory where to start placing the enclave image
+	 * (read).
+	 */
+	__u64 memory_offset;
+};
+
+/* User memory region flags */
+
+/* Memory region for enclave general usage. */
+#define NE_DEFAULT_MEMORY_REGION (0x00)
+
+/* Memory region to be set for an enclave (write). */
+struct ne_user_memory_region {
+	/**
+	 * Flags to determine the usage for the memory region (write).
+	 */
+	__u64 flags;
+
+	/**
+	 * The size, in bytes, of the memory region to be set for an enclave
+	 * (write).
+	 */
+	__u64 memory_size;
+
+	/**
+	 * The start of the userspace allocated memory of the memory region to
+	 * set for an enclave (write).
+	 */
+	__u64 userspace_addr;
+};
+
+/* Enclave start info flags */
+
+/* Start enclave in debug mode. */
+#define NE_ENCLAVE_DEBUG_MODE (0x01)
+
+/* Setup info necessary for enclave start (write / read). */
+struct ne_enclave_start_info {
+	/* Flags for the enclave to start with (e.g. debug mode) (write). */
+	__u64 flags;
+
+	/**
+	 * Context ID (CID) for the enclave vsock device. If 0 as input, the
+	 * CID is autogenerated by the hypervisor and returned back as output
+	 * by the driver (write / read).
+	 */
+	__u64 enclave_cid;
+};
+
+#endif /* _UAPI_LINUX_NITRO_ENCLAVES_H_ */
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

