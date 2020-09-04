Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B3C25E11B
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 19:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgIDRkT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 13:40:19 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:37119 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728245AbgIDRkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 13:40:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599241202; x=1630777202;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nbyWTFeOZZR57KSpqNP9YA6sOZzSZMtSryytZtxqtRw=;
  b=CuiA0Wk1kPK8G1cq+zKDNdgGgJiBzoS863UjddvlmkWgNX8IBxsDzYNn
   5naoedlgzWFtwe4V64Wwjz2oFneWu9LDvZzQyc4r42OSm9w6OZb7hZxyj
   XGYHiYHxOkz9iyqZHb/fGB4an1r4YocgG0/B/yhVYPzzzGl7VjPwkgxgS
   M=;
X-IronPort-AV: E=Sophos;i="5.76,390,1592870400"; 
   d="scan'208";a="72479778"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 04 Sep 2020 17:40:01 +0000
Received: from EX13D16EUB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id 12884A2105;
        Fri,  4 Sep 2020 17:39:57 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.145) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Sep 2020 17:39:47 +0000
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
Subject: [PATCH v8 13/18] nitro_enclaves: Add logic for terminating an enclave
Date:   Fri, 4 Sep 2020 20:37:13 +0300
Message-ID: <20200904173718.64857-14-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200904173718.64857-1-andraprs@amazon.com>
References: <20200904173718.64857-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.145]
X-ClientProxiedBy: EX13D08UWC002.ant.amazon.com (10.43.162.168) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
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
Reviewed-by: Alexander Graf <graf@amazon.com>
---
Changelog

v7 -> v8

* No changes.

v6 -> v7

* Remove the pci_dev_put() call as the NE misc device parent field is
  used now to get the NE PCI device.
* Update the naming and add more comments to make more clear the logic
  of handling full CPU cores and dedicating them to the enclave.

v5 -> v6

* Update documentation to kernel-doc format.
* Use directly put_page() instead of unpin_user_pages(), to match the
  get_user_pages() calls.

v4 -> v5

* Release the reference to the NE PCI device on enclave fd release.
* Adapt the logic to cpumask enclave vCPU ids and CPU cores.
* Remove sanity checks for situations that shouldn't happen, only if
  buggy system or broken logic at all.

v3 -> v4

* Use dev_err instead of custom NE log pattern.

v2 -> v3

* Remove the WARN_ON calls.
* Update static calls sanity checks.
* Update kzfree() calls to kfree().

v1 -> v2

* Add log pattern for NE.
* Remove the BUG_ON calls.
* Update goto labels to match their purpose.
* Add early exit in release() if there was a slot alloc error in the fd
  creation path.
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 166 ++++++++++++++++++++++
 1 file changed, 166 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index 5ec7fdf9d08e..1fb194d3ab62 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -1309,6 +1309,171 @@ static long ne_enclave_ioctl(struct file *file, unsigned int cmd, unsigned long
 	return 0;
 }
 
+/**
+ * ne_enclave_remove_all_mem_region_entries() - Remove all memory region entries
+ *						from the enclave data structure.
+ * @ne_enclave :	Private data associated with the current enclave.
+ *
+ * Context: Process context. This function is called with the ne_enclave mutex held.
+ */
+static void ne_enclave_remove_all_mem_region_entries(struct ne_enclave *ne_enclave)
+{
+	unsigned long i = 0;
+	struct ne_mem_region *ne_mem_region = NULL;
+	struct ne_mem_region *ne_mem_region_tmp = NULL;
+
+	list_for_each_entry_safe(ne_mem_region, ne_mem_region_tmp,
+				 &ne_enclave->mem_regions_list,
+				 mem_region_list_entry) {
+		list_del(&ne_mem_region->mem_region_list_entry);
+
+		for (i = 0; i < ne_mem_region->nr_pages; i++)
+			put_page(ne_mem_region->pages[i]);
+
+		kfree(ne_mem_region->pages);
+
+		kfree(ne_mem_region);
+	}
+}
+
+/**
+ * ne_enclave_remove_all_vcpu_id_entries() - Remove all vCPU id entries from
+ *					     the enclave data structure.
+ * @ne_enclave :	Private data associated with the current enclave.
+ *
+ * Context: Process context. This function is called with the ne_enclave mutex held.
+ */
+static void ne_enclave_remove_all_vcpu_id_entries(struct ne_enclave *ne_enclave)
+{
+	unsigned int cpu = 0;
+	unsigned int i = 0;
+
+	mutex_lock(&ne_cpu_pool.mutex);
+
+	for (i = 0; i < ne_enclave->nr_parent_vm_cores; i++) {
+		for_each_cpu(cpu, ne_enclave->threads_per_core[i])
+			/* Update the available NE CPU pool. */
+			cpumask_set_cpu(cpu, ne_cpu_pool.avail_threads_per_core[i]);
+
+		free_cpumask_var(ne_enclave->threads_per_core[i]);
+	}
+
+	mutex_unlock(&ne_cpu_pool.mutex);
+
+	kfree(ne_enclave->threads_per_core);
+
+	free_cpumask_var(ne_enclave->vcpu_ids);
+}
+
+/**
+ * ne_pci_dev_remove_enclave_entry() - Remove the enclave entry from the data
+ *				       structure that is part of the NE PCI
+ *				       device private data.
+ * @ne_enclave :	Private data associated with the current enclave.
+ * @ne_pci_dev :	Private data associated with the PCI device.
+ *
+ * Context: Process context. This function is called with the ne_pci_dev enclave
+ *	    mutex held.
+ */
+static void ne_pci_dev_remove_enclave_entry(struct ne_enclave *ne_enclave,
+					    struct ne_pci_dev *ne_pci_dev)
+{
+	struct ne_enclave *ne_enclave_entry = NULL;
+	struct ne_enclave *ne_enclave_entry_tmp = NULL;
+
+	list_for_each_entry_safe(ne_enclave_entry, ne_enclave_entry_tmp,
+				 &ne_pci_dev->enclaves_list, enclave_list_entry) {
+		if (ne_enclave_entry->slot_uid == ne_enclave->slot_uid) {
+			list_del(&ne_enclave_entry->enclave_list_entry);
+
+			break;
+		}
+	}
+}
+
+/**
+ * ne_enclave_release() - Release function provided by the enclave file.
+ * @inode:	Inode associated with this file release function.
+ * @file:	File associated with this release function.
+ *
+ * Context: Process context.
+ * Return:
+ * * 0 on success.
+ * * Negative return value on failure.
+ */
+static int ne_enclave_release(struct inode *inode, struct file *file)
+{
+	struct ne_pci_dev_cmd_reply cmd_reply = {};
+	struct enclave_stop_req enclave_stop_request = {};
+	struct ne_enclave *ne_enclave = file->private_data;
+	struct ne_pci_dev *ne_pci_dev = NULL;
+	int rc = -EINVAL;
+	struct slot_free_req slot_free_req = {};
+
+	if (!ne_enclave)
+		return 0;
+
+	/*
+	 * Early exit in case there is an error in the enclave creation logic
+	 * and fput() is called on the cleanup path.
+	 */
+	if (!ne_enclave->slot_uid)
+		return 0;
+
+	ne_pci_dev = pci_get_drvdata(ne_enclave->pdev);
+
+	/*
+	 * Acquire the enclave list mutex before the enclave mutex
+	 * in order to avoid deadlocks with @ref ne_event_work_handler.
+	 */
+	mutex_lock(&ne_pci_dev->enclaves_list_mutex);
+	mutex_lock(&ne_enclave->enclave_info_mutex);
+
+	if (ne_enclave->state != NE_STATE_INIT && ne_enclave->state != NE_STATE_STOPPED) {
+		enclave_stop_request.slot_uid = ne_enclave->slot_uid;
+
+		rc = ne_do_request(ne_enclave->pdev, ENCLAVE_STOP,
+				   &enclave_stop_request, sizeof(enclave_stop_request),
+				   &cmd_reply, sizeof(cmd_reply));
+		if (rc < 0) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Error in enclave stop [rc=%d]\n", rc);
+
+			goto unlock_mutex;
+		}
+
+		memset(&cmd_reply, 0, sizeof(cmd_reply));
+	}
+
+	slot_free_req.slot_uid = ne_enclave->slot_uid;
+
+	rc = ne_do_request(ne_enclave->pdev, SLOT_FREE, &slot_free_req, sizeof(slot_free_req),
+			   &cmd_reply, sizeof(cmd_reply));
+	if (rc < 0) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Error in slot free [rc=%d]\n", rc);
+
+		goto unlock_mutex;
+	}
+
+	ne_pci_dev_remove_enclave_entry(ne_enclave, ne_pci_dev);
+	ne_enclave_remove_all_mem_region_entries(ne_enclave);
+	ne_enclave_remove_all_vcpu_id_entries(ne_enclave);
+
+	mutex_unlock(&ne_enclave->enclave_info_mutex);
+	mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
+
+	kfree(ne_enclave);
+
+	return 0;
+
+unlock_mutex:
+	mutex_unlock(&ne_enclave->enclave_info_mutex);
+	mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
+
+	return rc;
+}
+
 /**
  * ne_enclave_poll() - Poll functionality used for enclave out-of-band events.
  * @file:	File associated with this poll function.
@@ -1338,6 +1503,7 @@ static const struct file_operations ne_enclave_fops = {
 	.llseek		= noop_llseek,
 	.poll		= ne_enclave_poll,
 	.unlocked_ioctl	= ne_enclave_ioctl,
+	.release	= ne_enclave_release,
 };
 
 /**
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

