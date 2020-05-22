Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39921DDFD1
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 08:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbgEVGao (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 02:30:44 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:33642 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728243AbgEVGan (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 02:30:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590129043; x=1621665043;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xNKNBXliT9IaYCIFmyg2+Tw4otdxx+qtzW56Ci2KiNA=;
  b=QqEMPO5QrelyGJKoA0RzZ3KGfBjUWJolRymj4PhhsBkKj0cR8R4xUusH
   MkJdM+aX6dAmNFXvxP8a+6/4PJ184uUlL1aMIOY/O8vxZ4pmPfeWmROfS
   zEHT3H/ggkJ76y+zsWFf/eL40a4PGveyPW/g7L47qq8m396zmrljzJ+qJ
   c=;
IronPort-SDR: yoBQ2n0N4EqS8ZKXRmuKdxaFcyeC45AH0GZ0/E6edd8z2HWMkZEQSv/uqfRArPdwBioEEHPZ07
 TjNn1KWUITRg==
X-IronPort-AV: E=Sophos;i="5.73,420,1583193600"; 
   d="scan'208";a="36944277"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-f273de60.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 22 May 2020 06:30:42 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-f273de60.us-east-1.amazon.com (Postfix) with ESMTPS id D7CC7A2504;
        Fri, 22 May 2020 06:30:39 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 06:30:10 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.175) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 06:30:01 +0000
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
Subject: [PATCH v2 01/18] nitro_enclaves: Add ioctl interface definition
Date:   Fri, 22 May 2020 09:29:29 +0300
Message-ID: <20200522062946.28973-2-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200522062946.28973-1-andraprs@amazon.com>
References: <20200522062946.28973-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.175]
X-ClientProxiedBy: EX13D20UWC004.ant.amazon.com (10.43.162.41) To
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
 .../userspace-api/ioctl/ioctl-number.rst      |  5 +-
 include/linux/nitro_enclaves.h                | 23 ++++++
 include/uapi/linux/nitro_enclaves.h           | 77 +++++++++++++++++++
 3 files changed, 104 insertions(+), 1 deletion(-)
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
index 000000000000..7e593a9fbf8c
--- /dev/null
+++ b/include/linux/nitro_enclaves.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
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
index 000000000000..98ba59f15b52
--- /dev/null
+++ b/include/uapi/linux/nitro_enclaves.h
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
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

