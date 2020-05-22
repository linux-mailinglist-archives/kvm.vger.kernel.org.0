Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B34C1DDFD6
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 08:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbgEVGa5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 02:30:57 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:20638 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728200AbgEVGa5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 02:30:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590129057; x=1621665057;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+IEnUDauVK6Kxis8XNouhki7DlHBWdmNgib7opoIkYo=;
  b=BMtl+fW3ebTxb1ziSoJCOgjsJoaweb+zvSvWJeKu1BF6SvoNZIIfmcob
   ck418BtCmyG/x+sjX0tdeQ+ULy3GLx/Yq0qJB8WAgDxIxFpQqrjkNfX/d
   RaCQWxK1P1Elvg2hiiS8XcQ66FMZdUHQndrGFER2u1Xa5ekkh5AdUSOEx
   o=;
IronPort-SDR: J/nNhtzoSGxgMBoLAiy5oQWC7pMfbpckNL0V81d/xhBAURoPBmKEaAD0R118eiHhh8qQOB17KU
 2GSwKoNZgGJw==
X-IronPort-AV: E=Sophos;i="5.73,420,1583193600"; 
   d="scan'208";a="31775372"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 22 May 2020 06:30:45 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id C7AC4C0836;
        Fri, 22 May 2020 06:30:41 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 06:30:36 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.175) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 06:30:17 +0000
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
Subject: [PATCH v2 03/18] nitro_enclaves: Define enclave info for internal bookkeeping
Date:   Fri, 22 May 2020 09:29:31 +0300
Message-ID: <20200522062946.28973-4-andraprs@amazon.com>
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

The Nitro Enclaves driver keeps an internal info per each enclave.

This is needed to be able to manage enclave resources state, enclave
notifications and have a reference of the PCI device that handles
command requests for enclave lifetime management.

Signed-off-by: Alexandru-Catalin Vasile <lexnv@amazon.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.h | 121 ++++++++++++++++++++++
 1 file changed, 121 insertions(+)
 create mode 100644 drivers/virt/nitro_enclaves/ne_misc_dev.h

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.h b/drivers/virt/nitro_enclaves/ne_misc_dev.h
new file mode 100644
index 000000000000..9d683607502f
--- /dev/null
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.h
@@ -0,0 +1,121 @@
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
+#ifndef _NE_MISC_DEV_H_
+#define _NE_MISC_DEV_H_
+
+#include <linux/cpumask.h>
+#include <linux/list.h>
+#include <linux/miscdevice.h>
+#include <linux/mm.h>
+#include <linux/mutex.h>
+#include <linux/pci.h>
+#include <linux/wait.h>
+
+/* Entry in vCPU IDs list. */
+struct ne_vcpu_id {
+	/* CPU id associated with a given slot, apic id on x86. */
+	u32 vcpu_id;
+
+	struct list_head vcpu_id_list_entry;
+};
+
+/* Entry in memory regions list. */
+struct ne_mem_region {
+	struct list_head mem_region_list_entry;
+
+	/* Number of pages that make up the memory region. */
+	unsigned long nr_pages;
+
+	/* Pages that make up the user space memory region. */
+	struct page **pages;
+};
+
+/* Per-enclave data used for enclave lifetime management. */
+struct ne_enclave {
+	/**
+	 * CPU pool with siblings of already allocated CPUs to an enclave.
+	 * This is used when a CPU pool is set, to be able to know the CPU
+	 * siblings for the hyperthreading (HT) setup.
+	 */
+	cpumask_var_t cpu_siblings;
+
+	struct list_head enclave_list_entry;
+
+	/* Mutex for accessing this internal state. */
+	struct mutex enclave_info_mutex;
+
+	/**
+	 * Wait queue used for out-of-band event notifications
+	 * triggered from the PCI device event handler to the enclave
+	 * process via the poll function.
+	 */
+	wait_queue_head_t eventq;
+
+	/* Variable used to determine if the out-of-band event was triggered. */
+	bool has_event;
+
+	/**
+	 * The maximum number of memory regions that can be handled by the
+	 * lower levels.
+	 */
+	u64 max_mem_regions;
+
+	/* Enclave memory regions list. */
+	struct list_head mem_regions_list;
+
+	/* Enclave process abstraction mm data struct. */
+	struct mm_struct *mm;
+
+	/* Number of memory regions associated with the enclave. */
+	u64 nr_mem_regions;
+
+	/* Number of vcpus associated with the enclave. */
+	u64 nr_vcpus;
+
+	/* PCI device used for enclave lifetime management. */
+	struct pci_dev *pdev;
+
+	/* Slot unique id mapped to the enclave. */
+	u64 slot_uid;
+
+	/* Enclave state, updated during enclave lifetime. */
+	u16 state;
+
+	/* Enclave vCPUs list. */
+	struct list_head vcpu_ids_list;
+};
+
+/* States available for an enclave. */
+enum ne_state {
+	/* NE_START_ENCLAVE ioctl was never issued for the enclave. */
+	NE_STATE_INIT = 0,
+
+	/**
+	 * NE_START_ENCLAVE ioctl was issued and the enclave is running
+	 * as expected.
+	 */
+	NE_STATE_RUNNING = 2,
+
+	/* Enclave exited without userspace interaction. */
+	NE_STATE_STOPPED = U16_MAX,
+};
+
+/* Nitro Enclaves (NE) misc device */
+extern struct miscdevice ne_miscdevice;
+
+#endif /* _NE_MISC_DEV_H_ */
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

