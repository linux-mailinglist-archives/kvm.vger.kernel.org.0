Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20631B2F53
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 20:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729480AbgDUSme (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 14:42:34 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:64501 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729457AbgDUSmd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 14:42:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587494552; x=1619030552;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JvAkbGXE1TkqLW/VIeJ1UyQVKOVRurbP5B+dKLPBzQM=;
  b=FQ1xIRVPrambeWWZ8V9Px9igxHKBcFcQJxpnIjzDYYy1BG2G9XZGmYD5
   DOPsUDCAjLocLYrzhwdVWk1gz/8ttFOdZkp+d7mgov3id03hszbl9TJ4E
   grSZGe6QCQZAZRncJchBahvjx6Qis5UDPhGqgd6UW+NxjaygfxL5w14sc
   o=;
IronPort-SDR: iTDTXD0VqbwQEv8BZHVf78cDcxHnyu4DA5JEEZvZhTMvucS95gF47zQxlGu8JiElk0mequShib
 N40L7bUh51kQ==
X-IronPort-AV: E=Sophos;i="5.72,411,1580774400"; 
   d="scan'208";a="30232759"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-e7be2041.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 21 Apr 2020 18:42:31 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-e7be2041.us-west-2.amazon.com (Postfix) with ESMTPS id DC015A22F5;
        Tue, 21 Apr 2020 18:42:29 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Apr 2020 18:42:29 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.90) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Apr 2020 18:42:20 +0000
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
Subject: [PATCH v1 03/15] nitro_enclaves: Define enclave info for internal bookkeeping
Date:   Tue, 21 Apr 2020 21:41:38 +0300
Message-ID: <20200421184150.68011-4-andraprs@amazon.com>
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

The Nitro Enclaves driver keeps an internal info per each enclave.

This is needed to be able to manage enclave resources state, enclave
notifications and have a reference of the PCI device that handles
command requests for enclave lifetime management.

Signed-off-by: Alexandru-Catalin Vasile <lexnv@amazon.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 .../virt/amazon/nitro_enclaves/ne_misc_dev.h  | 120 ++++++++++++++++++
 1 file changed, 120 insertions(+)
 create mode 100644 drivers/virt/amazon/nitro_enclaves/ne_misc_dev.h

diff --git a/drivers/virt/amazon/nitro_enclaves/ne_misc_dev.h b/drivers/virt/amazon/nitro_enclaves/ne_misc_dev.h
new file mode 100644
index 000000000000..dece3ead86b9
--- /dev/null
+++ b/drivers/virt/amazon/nitro_enclaves/ne_misc_dev.h
@@ -0,0 +1,120 @@
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
+/**
+ * States available for an enclave.
+ *
+ * TODO: Determine if the following states are exposing enough information
+ * to the kernel driver.
+ */
+enum ne_state {
+	/* NE_ENCLAVE_START ioctl was never issued for the enclave. */
+	NE_STATE_INIT = 0,
+
+	/**
+	 * NE_ENCLAVE_START ioctl was issued and the enclave is running
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

