Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF7723C8D6
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 11:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgHEJNM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 05:13:12 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:63541 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728206AbgHEJLK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 05:11:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1596618669; x=1628154669;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jgwIFKvbvPEuNgC5UldSfkmOKqQ8fuVUxSFZEozV5L8=;
  b=j/94qh7epDGQUqHfGPLBrZ7l7bkLSl0gpHbktO8rlbFJ6uCZsywkEMhn
   wyjlIoGlw4hSg5jB5D625ONdMuYXj5cF1X5awxez/IWSEefaj6Tx0rDhs
   TzDeZPIWUJdwgWmmAO5xOn9jGUvkj6h+fem//Ey+8VsP3gTVYWWMqfEM1
   4=;
IronPort-SDR: dR/PSD7+KxZeOowrlM+AioSUvFpwlmrwo/leS0LlsLEHiE70envEAYIDad5cBSMtJygQV9YN++
 DHbj9E6LBjug==
X-IronPort-AV: E=Sophos;i="5.75,436,1589241600"; 
   d="scan'208";a="47577566"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-69849ee2.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 05 Aug 2020 09:11:05 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-69849ee2.us-west-2.amazon.com (Postfix) with ESMTPS id 880A6A070D;
        Wed,  5 Aug 2020 09:11:02 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 5 Aug 2020 09:11:01 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.26) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 5 Aug 2020 09:10:52 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     linux-kernel <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "David Duncan" <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        "David Woodhouse" <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Karen Noel" <knoel@redhat.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        "Uwe Dannowski" <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v6 03/18] nitro_enclaves: Define enclave info for internal bookkeeping
Date:   Wed, 5 Aug 2020 12:10:02 +0300
Message-ID: <20200805091017.86203-4-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200805091017.86203-1-andraprs@amazon.com>
References: <20200805091017.86203-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.160.26]
X-ClientProxiedBy: EX13D03UWA003.ant.amazon.com (10.43.160.39) To
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
Reviewed-by: Alexander Graf <graf@amazon.com>
---
Changelog

v5 -> v6

* Update documentation to kernel-doc format.
* Include in the enclave memory region data structure the user space
  address and size for duplicate user space memory regions checks.

v4 -> v5

* Include enclave cores field in the enclave metadata.
* Update the vCPU ids data structure to be a cpumask instead of a list.

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
 drivers/virt/nitro_enclaves/ne_misc_dev.h | 92 +++++++++++++++++++++++
 1 file changed, 92 insertions(+)
 create mode 100644 drivers/virt/nitro_enclaves/ne_misc_dev.h

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.h b/drivers/virt/nitro_enclaves/ne_misc_dev.h
new file mode 100644
index 000000000000..ae5882ae2e05
--- /dev/null
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.h
@@ -0,0 +1,92 @@
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
+/**
+ * struct ne_mem_region - Entry in the enclave user space memory regions list.
+ * @mem_region_list_entry:	Entry in the list of enclave memory regions.
+ * @memory_size:		Size of the user space memory region.
+ * @nr_pages:			Number of pages that make up the memory region.
+ * @pages:			Pages that make up the user space memory region.
+ * @userspace_addr:		User space address of the memory region.
+ */
+struct ne_mem_region {
+	struct list_head	mem_region_list_entry;
+	u64			memory_size;
+	unsigned long		nr_pages;
+	struct page		**pages;
+	u64			userspace_addr;
+};
+
+/**
+ * struct ne_enclave - Per-enclave data used for enclave lifetime management.
+ * @avail_cpu_cores:		Available CPU cores for the enclave.
+ * @avail_cpu_cores_size:	The size of the available cores array.
+ * @enclave_info_mutex :	Mutex for accessing this internal state.
+ * @enclave_list_entry :	Entry in the list of created enclaves.
+ * @eventq:			Wait queue used for out-of-band event notifications
+ *				triggered from the PCI device event handler to
+ *				the enclave process via the poll function.
+ * @has_event:			Variable used to determine if the out-of-band event
+ *				was triggered.
+ * @max_mem_regions:		The maximum number of memory regions that can be
+ *				handled by the hypervisor.
+ * @mem_regions_list:		Enclave user space memory regions list.
+ * @mem_size:			Enclave memory size.
+ * @mm :			Enclave process abstraction mm data struct.
+ * @nr_mem_regions:		Number of memory regions associated with the enclave.
+ * @nr_vcpus:			Number of vcpus associated with the enclave.
+ * @numa_node:			NUMA node of the enclave memory and CPUs.
+ * @pdev:			PCI device used for enclave lifetime management.
+ * @slot_uid:			Slot unique id mapped to the enclave.
+ * @state:			Enclave state, updated during enclave lifetime.
+ * @vcpu_ids:			Enclave vCPUs.
+ */
+struct ne_enclave {
+	cpumask_var_t		*avail_cpu_cores;
+	unsigned int		avail_cpu_cores_size;
+	struct mutex		enclave_info_mutex;
+	struct list_head	enclave_list_entry;
+	wait_queue_head_t	eventq;
+	bool			has_event;
+	u64			max_mem_regions;
+	struct list_head	mem_regions_list;
+	u64			mem_size;
+	struct mm_struct	*mm;
+	u64			nr_mem_regions;
+	u64			nr_vcpus;
+	int			numa_node;
+	struct pci_dev		*pdev;
+	u64			slot_uid;
+	u16			state;
+	cpumask_var_t		vcpu_ids;
+};
+
+/**
+ * enum ne_state - States available for an enclave.
+ * @NE_STATE_INIT:	The enclave has not been started yet.
+ * @NE_STATE_RUNNING:	The enclave was started and is running as expected.
+ * @NE_STATE_STOPPED:	The enclave exited without userspace interaction.
+ */
+enum ne_state {
+	NE_STATE_INIT		= 0,
+	NE_STATE_RUNNING	= 2,
+	NE_STATE_STOPPED	= U16_MAX,
+};
+
+/* Nitro Enclaves (NE) misc device */
+extern struct miscdevice ne_misc_dev;
+
+#endif /* _NE_MISC_DEV_H_ */
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

