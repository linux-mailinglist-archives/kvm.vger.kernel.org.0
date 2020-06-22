Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5022040DD
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 22:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728830AbgFVUER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 16:04:17 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:18694 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728228AbgFVUER (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 16:04:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1592856256; x=1624392256;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nxQyxOpKY0tSVVOPt7xEfQ5vER0k/lEs0PeRhy82lVQ=;
  b=J/73sWEMef9s1cfCo+yDpFNSd4TPvGxAxzPDmCLA2dlOtEbFvXXo5TXS
   Xs5cXYw1yxbzjOh4ak2AIwKALaiqv7/2AuMKOEpn81uvMYuDhJ4M7tstW
   Hma0Usc01wtcqqQ2dshFZxVs7V1fcHqZUt+nKwyl29sTtNAfP6AtcIZMq
   Q=;
IronPort-SDR: chEw7QLPKckPL26j41NC9bPyCaX76NM6qCIRWRZfgggaMXhs+cbXOdDigPWVBdTMAKk+AeRl8P
 UObpVPMfPVzg==
X-IronPort-AV: E=Sophos;i="5.75,268,1589241600"; 
   d="scan'208";a="37800285"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-69849ee2.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 22 Jun 2020 20:04:13 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-69849ee2.us-west-2.amazon.com (Postfix) with ESMTPS id 8A9FCA0756;
        Mon, 22 Jun 2020 20:04:12 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 22 Jun 2020 20:04:12 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.145) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 22 Jun 2020 20:04:02 +0000
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
Subject: [PATCH v4 03/18] nitro_enclaves: Define enclave info for internal bookkeeping
Date:   Mon, 22 Jun 2020 23:03:14 +0300
Message-ID: <20200622200329.52996-4-andraprs@amazon.com>
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

The Nitro Enclaves driver keeps an internal info per each enclave.

This is needed to be able to manage enclave resources state, enclave
notifications and have a reference of the PCI device that handles
command requests for enclave lifetime management.

Signed-off-by: Alexandru-Catalin Vasile <lexnv@amazon.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
Changelog

v3 -> v4

* Add NUMA node field for an enclave metadata as the enclave memory and
  CPUs need to be from the same NUMA node.

v2 -> v3

* Remove the GPL additional wording as SPDX-License-Identifier is
  already in place.

v1 -> v2

* Add enclave memory regions and vcpus count for enclave bookkeeping.
* Update ne_state comments to reflect NE_START_ENCLAVE ioctl naming
  update.
---
 drivers/virt/nitro_enclaves/ne_misc_dev.h | 115 ++++++++++++++++++++++
 1 file changed, 115 insertions(+)
 create mode 100644 drivers/virt/nitro_enclaves/ne_misc_dev.h

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.h b/drivers/virt/nitro_enclaves/ne_misc_dev.h
new file mode 100644
index 000000000000..58eb9884379f
--- /dev/null
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.h
@@ -0,0 +1,115 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
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
+	/* Enclave memory size. */
+	u64 mem_size;
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
+	/* NUMA node of the enclave memory and CPUs. */
+	u32 numa_node;
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
+extern struct miscdevice ne_misc_dev;
+
+#endif /* _NE_MISC_DEV_H_ */
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

