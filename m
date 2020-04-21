Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B621B2F67
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 20:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbgDUSn4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 14:43:56 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:62511 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbgDUSn4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 14:43:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587494635; x=1619030635;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+uXZSd+rA8gs8cQcgD50Ns4MwYbbNyukGlXYfO8A2+0=;
  b=IkTkgwEAlB2H1j8Oal6l8cNfW3i1YlzCnuOAyClEHnztsQw8KMYC4yMm
   1NQryUZRftbKfY6vuPUB4g6cnMxoYKwwhQoOOVgNAvXRYZjqW2a6nxSpT
   2F7yLxbLkGTOuILx1rY8PIblycos35SoegPtPAvU4I4BoYV5h/AeYuFuF
   I=;
IronPort-SDR: wSYXh4zgWBWEcWcU/2R6X/NlO+JoCVVnmS/45Lh7Gn8gH4vmX348CEiRh0ka1WQvyLVuw3EMUZ
 Knn9mzpdl7BA==
X-IronPort-AV: E=Sophos;i="5.72,411,1580774400"; 
   d="scan'208";a="39978613"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 21 Apr 2020 18:43:54 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id 05C61A17AD;
        Tue, 21 Apr 2020 18:43:53 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Apr 2020 18:43:53 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.217) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Apr 2020 18:43:45 +0000
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
Subject: [PATCH v1 12/15] nitro_enclaves: Add logic for enclave termination
Date:   Tue, 21 Apr 2020 21:41:47 +0300
Message-ID: <20200421184150.68011-13-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200421184150.68011-1-andraprs@amazon.com>
References: <20200421184150.68011-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.217]
X-ClientProxiedBy: EX13D17UWC002.ant.amazon.com (10.43.162.61) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

An enclave is associated with an fd that is returned after the enclave
creation logic is completed. This enclave fd is further used to setup
enclave resources. Once the enclave needs to be terminated, the enclave
fd is closed.

Add logic for enclave termination, that is mapped to the enclave fd
release callback. Free the internal enclave info used for bookkeeping.

Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 .../virt/amazon/nitro_enclaves/ne_misc_dev.c  | 164 ++++++++++++++++++
 1 file changed, 164 insertions(+)

diff --git a/drivers/virt/amazon/nitro_enclaves/ne_misc_dev.c b/drivers/virt/amazon/nitro_enclaves/ne_misc_dev.c
index f07eb46f7995..08ba8295d524 100644
--- a/drivers/virt/amazon/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/amazon/nitro_enclaves/ne_misc_dev.c
@@ -611,8 +611,172 @@ static long ne_enclave_ioctl(struct file *file, unsigned int cmd,
 	return 0;
 }
 
+/**
+ * ne_enclave_remove_all_mem_region_entries - Remove all memory region
+ * entries from the enclave data structure.
+ *
+ * This function gets called with the ne_enclave mutex held.
+ *
+ * @ne_enclave: private data associated with the current enclave.
+ */
+static void ne_enclave_remove_all_mem_region_entries(
+	struct ne_enclave *ne_enclave)
+{
+	struct ne_mem_region *ne_mem_region = NULL;
+	struct ne_mem_region *ne_mem_region_tmp = NULL;
+
+	BUG_ON(!ne_enclave);
+
+	list_for_each_entry_safe(ne_mem_region, ne_mem_region_tmp,
+				 &ne_enclave->mem_regions_list,
+				 mem_region_list_entry) {
+		list_del(&ne_mem_region->mem_region_list_entry);
+
+		unpin_user_pages(ne_mem_region->pages,
+				 ne_mem_region->nr_pages);
+
+		kzfree(ne_mem_region->pages);
+
+		kzfree(ne_mem_region);
+	}
+}
+
+/**
+ * ne_enclave_remove_all_vcpu_id_entries - Remove all vCPU id entries
+ * from the enclave data structure.
+ *
+ * This function gets called with the ne_enclave mutex held.
+ *
+ * @ne_enclave: private data associated with the current enclave.
+ */
+static void ne_enclave_remove_all_vcpu_id_entries(struct ne_enclave *ne_enclave)
+{
+	unsigned int cpu = 0;
+	struct ne_vcpu_id *ne_vcpu_id = NULL;
+	struct ne_vcpu_id *ne_vcpu_id_tmp = NULL;
+
+	BUG_ON(!ne_enclave);
+
+	mutex_lock(&ne_cpu_pool_mutex);
+
+	list_for_each_entry_safe(ne_vcpu_id, ne_vcpu_id_tmp,
+				 &ne_enclave->vcpu_ids_list,
+				 vcpu_id_list_entry) {
+		list_del(&ne_vcpu_id->vcpu_id_list_entry);
+
+		/* Update the available CPU pool. */
+		cpumask_set_cpu(ne_vcpu_id->vcpu_id, ne_cpu_pool.avail);
+
+		kzfree(ne_vcpu_id);
+	}
+
+	/* If any siblings left in the enclave CPU pool, move to available. */
+	for_each_cpu(cpu, ne_enclave->cpu_siblings) {
+		cpumask_clear_cpu(cpu, ne_enclave->cpu_siblings);
+
+		cpumask_set_cpu(cpu, ne_cpu_pool.avail);
+	}
+
+	free_cpumask_var(ne_enclave->cpu_siblings);
+
+	mutex_unlock(&ne_cpu_pool_mutex);
+}
+
+/**
+ * ne_pci_dev_remove_enclave_entry - Remove enclave entry from the data
+ * structure that is part of the PCI device private data.
+ *
+ * This function gets called with the ne_pci_dev enclave mutex held.
+ *
+ * @ne_enclave: private data associated with the current enclave.
+ * @ne_pci_dev: private data associated with the PCI device.
+ */
+static void ne_pci_dev_remove_enclave_entry(struct ne_enclave *ne_enclave,
+					    struct ne_pci_dev *ne_pci_dev)
+{
+	struct ne_enclave *ne_enclave_entry = NULL;
+	struct ne_enclave *ne_enclave_entry_tmp = NULL;
+
+	BUG_ON(!ne_enclave);
+	BUG_ON(!ne_pci_dev);
+
+	list_for_each_entry_safe(ne_enclave_entry, ne_enclave_entry_tmp,
+				 &ne_pci_dev->enclaves_list,
+				 enclave_list_entry) {
+		if (ne_enclave_entry->slot_uid == ne_enclave->slot_uid) {
+			list_del(&ne_enclave_entry->enclave_list_entry);
+
+			break;
+		}
+	}
+}
+
 static int ne_enclave_release(struct inode *inode, struct file *file)
 {
+	struct ne_pci_dev_cmd_reply cmd_reply = {};
+	struct enclave_stop_req enclave_stop_request = {};
+	struct ne_enclave *ne_enclave = file->private_data;
+	struct ne_pci_dev *ne_pci_dev = NULL;
+	int rc = -EINVAL;
+	struct slot_free_req slot_free_req = {};
+
+	BUG_ON(!ne_enclave);
+	BUG_ON(!ne_enclave->pdev);
+
+	ne_pci_dev = pci_get_drvdata(ne_enclave->pdev);
+	BUG_ON(!ne_pci_dev);
+
+	/*
+	 * Acquire the enclave list mutex before the enclave mutex
+	 * in order to avoid deadlocks with @ref ne_event_work_handler.
+	 */
+	mutex_lock(&ne_pci_dev->enclaves_list_mutex);
+	mutex_lock(&ne_enclave->enclave_info_mutex);
+
+	if (ne_enclave->state != NE_STATE_INIT &&
+	    ne_enclave->state != NE_STATE_STOPPED) {
+		enclave_stop_request.slot_uid = ne_enclave->slot_uid;
+
+		rc = ne_do_request(ne_enclave->pdev, ENCLAVE_STOP,
+				   &enclave_stop_request,
+				   sizeof(enclave_stop_request), &cmd_reply,
+				   sizeof(cmd_reply));
+		if (WARN_ON(rc < 0)) {
+			pr_err_ratelimited("Failure in enclave stop [rc=%d]\n",
+					   rc);
+
+			mutex_unlock(&ne_enclave->enclave_info_mutex);
+			mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
+
+			return rc;
+		}
+
+		memset(&cmd_reply, 0, sizeof(cmd_reply));
+	}
+
+	slot_free_req.slot_uid = ne_enclave->slot_uid;
+
+	rc = ne_do_request(ne_enclave->pdev, SLOT_FREE, &slot_free_req,
+			   sizeof(slot_free_req), &cmd_reply,
+			   sizeof(cmd_reply));
+	if (WARN_ON(rc < 0)) {
+		pr_err_ratelimited("Failure in slot free [rc=%d]\n", rc);
+
+		mutex_unlock(&ne_enclave->enclave_info_mutex);
+		mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
+
+		return rc;
+	}
+
+	ne_pci_dev_remove_enclave_entry(ne_enclave, ne_pci_dev);
+	ne_enclave_remove_all_mem_region_entries(ne_enclave);
+	ne_enclave_remove_all_vcpu_id_entries(ne_enclave);
+
+	mutex_unlock(&ne_enclave->enclave_info_mutex);
+	mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
+
+	kzfree(ne_enclave);
+
 	return 0;
 }
 
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

