Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4431E17A0
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 00:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731235AbgEYWOF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 18:14:05 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:8233 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729589AbgEYWOE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 18:14:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590444842; x=1621980842;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J+W1uF/+pHzCPt7+R5eOTYXFdxlNyATSaaicqu0ygi4=;
  b=DV/WS2SEsl6SN7mojgkKHKccRJXPIQQYjY7shJa+vE+S+cX1aC53pA6K
   C91u0weH7SxRkcT8iLVXYqyR4K99jIyO1FMpmBccSc2WXGszsX6YIuJH6
   LsizebSBWExKRHFqKOJGcbEeKPKi5O+EvsxUelnwGNDFq+DlGIlIkErQc
   M=;
IronPort-SDR: ufGBgo4KxIqswKpBp10OaHci71Oh2zVMMMtxLHse5CRqI8VsWAEmGO9NwwFAnlutgpp/CTWwuS
 1aWhJXJcC2Ag==
X-IronPort-AV: E=Sophos;i="5.73,435,1583193600"; 
   d="scan'208";a="32159712"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 25 May 2020 22:14:01 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id 33E3CA1B68;
        Mon, 25 May 2020 22:14:00 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 25 May 2020 22:13:59 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.90) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 25 May 2020 22:13:49 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Bjoern Doebel" <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        "Martin Pohlack" <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v3 01/18] nitro_enclaves: Add ioctl interface definition
Date:   Tue, 26 May 2020 01:13:17 +0300
Message-ID: <20200525221334.62966-2-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200525221334.62966-1-andraprs@amazon.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.160.90]
X-ClientProxiedBy: EX13D12UWC004.ant.amazon.com (10.43.162.182) To
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

Include part of the KVM ioctls in the provided ioctl interface, with
additional NE ioctl commands that e.g. triggers the enclave run.

Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
Changelog

v2 -> v3

* Remove the GPL additional wording as SPDX-License-Identifier is already in
place.

v1 -> v2

* Add ioctl for getting enclave image load metadata.
* Update NE_ENCLAVE_START ioctl name to NE_START_ENCLAVE. 
* Add entry in Documentation/userspace-api/ioctl/ioctl-number.rst for NE ioctls.
* Update NE ioctls definition based on the updated ioctl range for major and
minor.
---
 .../userspace-api/ioctl/ioctl-number.rst      |  5 +-
 include/linux/nitro_enclaves.h                | 11 ++++
 include/uapi/linux/nitro_enclaves.h           | 65 +++++++++++++++++++
 3 files changed, 80 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/nitro_enclaves.h
 create mode 100644 include/uapi/linux/nitro_enclaves.h

diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index f759edafd938..8a19b5e871d3 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -325,8 +325,11 @@ Code  Seq#    Include File                                           Comments
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
index 000000000000..3413352baf32
--- /dev/null
+++ b/include/uapi/linux/nitro_enclaves.h
@@ -0,0 +1,65 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ */
+
+#ifndef _UAPI_LINUX_NITRO_ENCLAVES_H_
+#define _UAPI_LINUX_NITRO_ENCLAVES_H_
+
+#include <linux/kvm.h>
+#include <linux/types.h>
+
+/* Nitro Enclaves (NE) Kernel Driver Interface */
+
+/**
+ * The command is used to get information needed for in-memory enclave image
+ * loading e.g. offset in enclave memory to start placing the enclave image.
+ *
+ * The image load metadata is an in / out data structure. It includes info
+ * provided by the caller - flags - and returns the offset in enclave memory
+ * where to start placing the enclave image.
+ */
+#define NE_GET_IMAGE_LOAD_METADATA _IOWR(0xAE, 0x20, struct image_load_metadata)
+
+/**
+ * The command is used to trigger enclave start after the enclave resources,
+ * such as memory and CPU, have been set.
+ *
+ * The enclave start metadata is an in / out data structure. It includes info
+ * provided by the caller - enclave cid and flags - and returns the slot uid
+ * and the cid (if input cid is 0).
+ */
+#define NE_START_ENCLAVE _IOWR(0xAE, 0x21, struct enclave_start_metadata)
+
+/* Metadata necessary for in-memory enclave image loading. */
+struct image_load_metadata {
+	/**
+	 * Flags to determine the enclave image type e.g. Enclave Image Format
+	 * (EIF) (in).
+	 */
+	__u64 flags;
+
+	/**
+	 * Offset in enclave memory where to start placing the enclave image
+	 * (out).
+	 */
+	__u64 memory_offset;
+};
+
+/* Setup metadata necessary for enclave start. */
+struct enclave_start_metadata {
+	/* Flags for the enclave to start with (e.g. debug mode) (in). */
+	__u64 flags;
+
+	/**
+	 * Context ID (CID) for the enclave vsock device. If 0 as input, the
+	 * CID is autogenerated by the hypervisor and returned back as output
+	 * by the driver (in/out).
+	 */
+	__u64 enclave_cid;
+
+	/* Slot unique id mapped to the enclave to start (out). */
+	__u64 slot_uid;
+};
+
+#endif /* _UAPI_LINUX_NITRO_ENCLAVES_H_ */
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

