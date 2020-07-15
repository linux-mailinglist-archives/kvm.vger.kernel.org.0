Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3D522156E
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 21:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbgGOTsI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 15:48:08 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:53080 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbgGOTsH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 15:48:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594842486; x=1626378486;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hr56f0ZiHVijz3WLq7h8AE+d9N4BX7x9sl3UcUWr05c=;
  b=Lcm0QxJv3EWt9JVa9361EwffUK+UkHPVT0lhfBPrh+V4QFgSOsWzAaOq
   f5+Ff3sUfjpqHoll02dfHffefiHAewGpbAAeEfB5u4gnXnCgMQQBnYJ1u
   8erBpBFrw0R+1I73854q39+ZIW0CUrV+7jUDSKx2jGUUYU2K/L5+jjqKz
   4=;
IronPort-SDR: 79izNC3rIzeRbm3gEaqIJP9c8B1ChRO3O96+JgAY2ckqxyS+C+PTGsYWt2d+AmawITOMZCKUCq
 g5lRuic2QyrA==
X-IronPort-AV: E=Sophos;i="5.75,356,1589241600"; 
   d="scan'208";a="51929689"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 15 Jul 2020 19:48:06 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id C7DDA22752D;
        Wed, 15 Jul 2020 19:48:04 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 15 Jul 2020 19:48:04 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.26) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 15 Jul 2020 19:47:54 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     <linux-kernel@vger.kernel.org>
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
        Vitaly Kuznetsov <vkuznets@redhat.com>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v5 12/18] nitro_enclaves: Add logic for starting an enclave
Date:   Wed, 15 Jul 2020 22:45:34 +0300
Message-ID: <20200715194540.45532-13-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200715194540.45532-1-andraprs@amazon.com>
References: <20200715194540.45532-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.160.26]
X-ClientProxiedBy: EX13D40UWC002.ant.amazon.com (10.43.162.191) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After all the enclave resources are set, the enclave is ready for
beginning to run.

Add ioctl command logic for starting an enclave after all its resources,
memory regions and CPUs, have been set.

The enclave start information includes the local channel addressing -
vsock CID - and the flags associated with the enclave.

Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
Changelog

v4 -> v5

* Add early exit on enclave start ioctl function call error.
* Move sanity checks in the enclave start ioctl function, outside of the
  switch-case block.
* Remove log on copy_from_user() / copy_to_user() failure.

v3 -> v4

* Use dev_err instead of custom NE log pattern.
* Update the naming for the ioctl command from metadata to info.
* Check for minimum enclave memory size.

v2 -> v3

* Remove the WARN_ON calls.
* Update static calls sanity checks.

v1 -> v2

* Add log pattern for NE.
* Check if enclave state is init when starting an enclave.
* Remove the BUG_ON calls.
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 106 ++++++++++++++++++++++
 1 file changed, 106 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index 4998aa0eee10..d57656cc11ce 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -736,6 +736,77 @@ static int ne_set_user_memory_region_ioctl(struct ne_enclave *ne_enclave,
 	return rc;
 }
 
+/**
+ * ne_start_enclave_ioctl - Trigger enclave start after the enclave resources,
+ * such as memory and CPU, have been set.
+ *
+ * This function gets called with the ne_enclave mutex held.
+ *
+ * @ne_enclave: private data associated with the current enclave.
+ * @enclave_start_info: enclave info that includes enclave cid and flags.
+ *
+ * @returns: 0 on success, negative return value on failure.
+ */
+static int ne_start_enclave_ioctl(struct ne_enclave *ne_enclave,
+	struct ne_enclave_start_info *enclave_start_info)
+{
+	struct ne_pci_dev_cmd_reply cmd_reply = {};
+	unsigned int cpu = 0;
+	struct enclave_start_req enclave_start_req = {};
+	unsigned int i = 0;
+	int rc = -EINVAL;
+
+	if (!ne_enclave->nr_mem_regions) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Enclave has no mem regions\n");
+
+		return -NE_ERR_NO_MEM_REGIONS_ADDED;
+	}
+
+	if (ne_enclave->mem_size < NE_MIN_ENCLAVE_MEM_SIZE) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Enclave memory is less than %ld\n",
+				    NE_MIN_ENCLAVE_MEM_SIZE);
+
+		return -NE_ERR_ENCLAVE_MEM_MIN_SIZE;
+	}
+
+	if (!ne_enclave->nr_vcpus) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Enclave has no vCPUs\n");
+
+		return -NE_ERR_NO_VCPUS_ADDED;
+	}
+
+	for (i = 0; i < ne_enclave->avail_cpu_cores_size; i++)
+		for_each_cpu(cpu, ne_enclave->avail_cpu_cores[i])
+			if (!cpumask_test_cpu(cpu, ne_enclave->vcpu_ids)) {
+				dev_err_ratelimited(ne_misc_dev.this_device,
+						    "Full CPU cores not used\n");
+
+				return -NE_ERR_FULL_CORES_NOT_USED;
+			}
+
+	enclave_start_req.enclave_cid = enclave_start_info->enclave_cid;
+	enclave_start_req.flags = enclave_start_info->flags;
+	enclave_start_req.slot_uid = ne_enclave->slot_uid;
+
+	rc = ne_do_request(ne_enclave->pdev, ENCLAVE_START, &enclave_start_req,
+			   sizeof(enclave_start_req), &cmd_reply, sizeof(cmd_reply));
+	if (rc < 0) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Error in enclave start [rc=%d]\n", rc);
+
+		return rc;
+	}
+
+	ne_enclave->state = NE_STATE_RUNNING;
+
+	enclave_start_info->enclave_cid = cmd_reply.enclave_cid;
+
+	return 0;
+}
+
 static long ne_enclave_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct ne_enclave *ne_enclave = file->private_data;
@@ -867,6 +938,41 @@ static long ne_enclave_ioctl(struct file *file, unsigned int cmd, unsigned long
 		return 0;
 	}
 
+	case NE_START_ENCLAVE: {
+		struct ne_enclave_start_info enclave_start_info = {};
+		int rc = -EINVAL;
+
+		if (copy_from_user(&enclave_start_info, (void __user *)arg,
+				   sizeof(enclave_start_info)))
+			return -EFAULT;
+
+		mutex_lock(&ne_enclave->enclave_info_mutex);
+
+		if (ne_enclave->state != NE_STATE_INIT) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Enclave is not in init state\n");
+
+			mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+			return -NE_ERR_NOT_IN_INIT_STATE;
+		}
+
+		rc = ne_start_enclave_ioctl(ne_enclave, &enclave_start_info);
+		if (rc < 0) {
+			mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+			return rc;
+		}
+
+		mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+		if (copy_to_user((void __user *)arg, &enclave_start_info,
+				 sizeof(enclave_start_info)))
+			return -EFAULT;
+
+		return 0;
+	}
+
 	default:
 		return -ENOTTY;
 	}
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

