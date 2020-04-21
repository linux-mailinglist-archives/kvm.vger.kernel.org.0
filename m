Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A161A1B2F4C
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 20:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbgDUSmQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 14:42:16 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:53386 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgDUSmQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 14:42:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587494536; x=1619030536;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p3KGxzu0ADrayANgam9z2ixDAMnSo4ulJX3kwnOktHY=;
  b=dcJohmdrbRTD833Md9aPsOCI9Cn3fSv0r1rELPiU1Wa1mMsBllLTYi8O
   I4jsmkAkZJLGYSRD56ArD376BSriALd8PKHLgjTm7OOOvOsOuOZrYn4ro
   VdZcTM7ocQwfmBxXdF/8OCnx/jPd8ySfMi8gxUMXTkvGfnQCvk06rhLC9
   Q=;
IronPort-SDR: U2pF+64vnqDEzdek/BksJqqn8twIcJln9O+n26hSW7xkaukg9egpCd3UUBG9xeiMWoziJumiLL
 +FIvD9qptL+g==
X-IronPort-AV: E=Sophos;i="5.72,411,1580774400"; 
   d="scan'208";a="38565615"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 21 Apr 2020 18:42:14 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com (Postfix) with ESMTPS id 83459A1DBC;
        Tue, 21 Apr 2020 18:42:13 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Apr 2020 18:42:12 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.90) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Apr 2020 18:42:04 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v1 01/15] nitro_enclaves: Add ioctl interface definition
Date:   Tue, 21 Apr 2020 21:41:36 +0300
Message-ID: <20200421184150.68011-2-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200421184150.68011-1-andraprs@amazon.com>
References: <20200421184150.68011-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.160.90]
X-ClientProxiedBy: EX13D25UWC004.ant.amazon.com (10.43.162.201) To
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

Include the KVM API as part of the provided ioctl interface, with an
additional ENCLAVE_START ioctl command that triggers the enclave run.

Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 include/linux/nitro_enclaves.h      | 23 +++++++++++++
 include/uapi/linux/nitro_enclaves.h | 52 +++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)
 create mode 100644 include/linux/nitro_enclaves.h
 create mode 100644 include/uapi/linux/nitro_enclaves.h

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
index 000000000000..b90dfcf6253a
--- /dev/null
+++ b/include/uapi/linux/nitro_enclaves.h
@@ -0,0 +1,52 @@
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
+ * The command is used to trigger enclave start after the enclave resources,
+ * such as memory and CPU, have been set.
+ *
+ * The enclave start metadata is an in / out data structure. It includes
+ * provided info by the caller - enclave cid and flags - and returns the
+ * slot uid and the cid (if input cid is 0).
+ */
+#define NE_ENCLAVE_START _IOWR('B', 0x1, struct enclave_start_metadata)
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

