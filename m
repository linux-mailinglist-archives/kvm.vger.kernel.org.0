Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765761E17A6
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 00:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388627AbgEYWOY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 18:14:24 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:7110 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388523AbgEYWOV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 18:14:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590444861; x=1621980861;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b18dv13yc4zKf3QUlz/1mXvBUI/WDEDUZCWpefJO1LE=;
  b=emQHM7jQbq0buFZ8kj+wT7zKjRSIWWy3Jpa81kr205arKONQmZvIJExU
   aTVzINP4wk30OKH6TLD3raTZGfK0l6hJ3fxQ9vrNONZDG66XrtKzif5BZ
   x0s6hLLOb976s9Fw6AmdGudsO1LhehqK8XE16ie1h8PsgEy89eeaH58c4
   A=;
IronPort-SDR: 6EkIdD04Ex4vn4M+iVk9ZVqa91G7R9jRUCXQ+PNRBm/gl74MwSnKvHeDgsLgU28w6m8uBvyzNg
 J+UnN08sxVnw==
X-IronPort-AV: E=Sophos;i="5.73,435,1583193600"; 
   d="scan'208";a="37543768"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 25 May 2020 22:14:20 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id 6236DA232B;
        Mon, 25 May 2020 22:14:18 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 25 May 2020 22:14:17 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.90) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 25 May 2020 22:14:08 +0000
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
Subject: [PATCH v3 03/18] nitro_enclaves: Define enclave info for internal bookkeeping
Date:   Tue, 26 May 2020 01:13:19 +0300
Message-ID: <20200525221334.62966-4-andraprs@amazon.com>
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

The Nitro Enclaves driver keeps an internal info per each enclave.

This is needed to be able to manage enclave resources state, enclave
notifications and have a reference of the PCI device that handles
command requests for enclave lifetime management.

Signed-off-by: Alexandru-Catalin Vasile <lexnv@amazon.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
Changelog

v2 -> v3

* Remove the GPL additional wording as SPDX-License-Identifier is already in
place.

v1 -> v2

* Add enclave memory regions and vcpus count for enclave bookkeeping.
* Update ne_state comments to reflect NE_START_ENCLAVE ioctl naming update.
---
 drivers/virt/nitro_enclaves/ne_misc_dev.h | 109 ++++++++++++++++++++++
 1 file changed, 109 insertions(+)
 create mode 100644 drivers/virt/nitro_enclaves/ne_misc_dev.h

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.h b/drivers/virt/nitro_enclaves/ne_misc_dev.h
new file mode 100644
index 000000000000..6f1db85fc741
--- /dev/null
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.h
@@ -0,0 +1,109 @@
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

