Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35A127239B
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 14:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgIUMSd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 08:18:33 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:6513 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbgIUMSd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 08:18:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600690712; x=1632226712;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pKTN/iaxRvbpIa/9sjPSM6v3Fu7sjctYW6qKGYIvSlY=;
  b=i1xWBJDKy57oIcYNSc0ZN5KtFRwwQQWKsbsJNVaUkmOdjmpXVU8A9phU
   rZFktK0YnIsiOHeiSnpUCB+/u8Cn4ysscm6Cn66Rntm3i3u0Eu9V4VLYx
   Ddph85FW5fj1vwN2bVc5n0VWPgyZSwXag4XkRWnqcI8TIoUvhdFrJvjya
   A=;
X-IronPort-AV: E=Sophos;i="5.77,286,1596499200"; 
   d="scan'208";a="76696935"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 21 Sep 2020 12:18:29 +0000
Received: from EX13D16EUB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id DC5CFA1CCA;
        Mon, 21 Sep 2020 12:18:26 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.229) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 21 Sep 2020 12:18:16 +0000
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
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v10 03/18] nitro_enclaves: Define enclave info for internal bookkeeping
Date:   Mon, 21 Sep 2020 15:17:17 +0300
Message-ID: <20200921121732.44291-4-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200921121732.44291-1-andraprs@amazon.com>
References: <20200921121732.44291-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.160.229]
X-ClientProxiedBy: EX13D36UWB001.ant.amazon.com (10.43.161.84) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Nitro Enclaves driver keeps an internal info per each enclave.

This is needed to be able to manage enclave resources state, enclave
notifications and have a reference of the PCI device that handles
command requests for enclave lifetime management.

Changelog

v9 -> v10

* Update commit message to include the changelog before the SoB tag(s).

v8 -> v9

* Add data structure to keep references to both Nitro Enclaves misc and
  PCI devices.

v7 -> v8

* No changes.

v6 -> v7

* Update the naming and add more comments to make more clear the logic
  of handling full CPU cores and dedicating them to the enclave.

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

Signed-off-by: Alexandru-Catalin Vasile <lexnv@amazon.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.h | 109 ++++++++++++++++++++++
 1 file changed, 109 insertions(+)
 create mode 100644 drivers/virt/nitro_enclaves/ne_misc_dev.h

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.h b/drivers/virt/nitro_enclaves/ne_misc_dev.h
new file mode 100644
index 000000000000..2a4d2224baba
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
+#include "ne_pci_dev.h"
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
+ * @nr_parent_vm_cores :	The size of the threads per core array. The
+ *				total number of CPU cores available on the
+ *				parent / primary VM.
+ * @nr_threads_per_core:	The number of threads that a full CPU core has.
+ * @nr_vcpus:			Number of vcpus associated with the enclave.
+ * @numa_node:			NUMA node of the enclave memory and CPUs.
+ * @slot_uid:			Slot unique id mapped to the enclave.
+ * @state:			Enclave state, updated during enclave lifetime.
+ * @threads_per_core:		Enclave full CPU cores array, indexed by core id,
+ *				consisting of cpumasks with all their threads.
+ *				Full CPU cores are taken from the NE CPU pool
+ *				and are available to the enclave.
+ * @vcpu_ids:			Cpumask of the vCPUs that are set for the enclave.
+ */
+struct ne_enclave {
+	struct mutex		enclave_info_mutex;
+	struct list_head	enclave_list_entry;
+	wait_queue_head_t	eventq;
+	bool			has_event;
+	u64			max_mem_regions;
+	struct list_head	mem_regions_list;
+	u64			mem_size;
+	struct mm_struct	*mm;
+	unsigned int		nr_mem_regions;
+	unsigned int		nr_parent_vm_cores;
+	unsigned int		nr_threads_per_core;
+	unsigned int		nr_vcpus;
+	int			numa_node;
+	u64			slot_uid;
+	u16			state;
+	cpumask_var_t		*threads_per_core;
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
+/**
+ * struct ne_devs - Data structure to keep refs to the NE misc and PCI devices.
+ * @ne_misc_dev:	Nitro Enclaves misc device.
+ * @ne_pci_dev :	Nitro Enclaves PCI device.
+ */
+struct ne_devs {
+	struct miscdevice	*ne_misc_dev;
+	struct ne_pci_dev	*ne_pci_dev;
+};
+
+/* Nitro Enclaves (NE) data structure for keeping refs to the NE misc and PCI devices. */
+extern struct ne_devs ne_devs;
+
+#endif /* _NE_MISC_DEV_H_ */
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

