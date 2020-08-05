Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CC723C8DF
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 11:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgHEJOC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 05:14:02 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:58952 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728534AbgHEJMm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 05:12:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1596618762; x=1628154762;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/Ae5VW+70xpnD8hTAzV/FHF1PuU2sVr8vHuAhjOfPOM=;
  b=j7afnAq0tSyADFK7+pr1B/1m1e69LK5Kx/o7a2DpJRECjFtmd3WjaL53
   47IF7xRVH0RsKHxvmdoPCLFycICJH2V+MmGiyPnIkEZhXzv9DjYqPqPSf
   7zfVTOciYTdKfhcEVf11UHzXdbL2khVkX62AVxd5oHMGk8s8OiiDYCwKV
   U=;
IronPort-SDR: zPRus7cThy/J2lwAC75fBmtGVh5y6c8AjKvTOfmo1wa7rDpmAEqzatl69WftNAA9oV6ru/mQlA
 dpjtjCNHzmhA==
X-IronPort-AV: E=Sophos;i="5.75,436,1589241600"; 
   d="scan'208";a="46143680"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 05 Aug 2020 09:12:40 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com (Postfix) with ESMTPS id 7FD91A189F;
        Wed,  5 Aug 2020 09:12:38 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 5 Aug 2020 09:12:37 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.248) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 5 Aug 2020 09:12:28 +0000
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
Subject: [PATCH v6 12/18] nitro_enclaves: Add logic for starting an enclave
Date:   Wed, 5 Aug 2020 12:10:11 +0300
Message-ID: <20200805091017.86203-13-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200805091017.86203-1-andraprs@amazon.com>
References: <20200805091017.86203-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.162.248]
X-ClientProxiedBy: EX13D37UWA003.ant.amazon.com (10.43.160.25) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
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

v5 -> v6

* Check for invalid enclave start flags.
* Update documentation to kernel-doc format.

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
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 109 ++++++++++++++++++++++
 1 file changed, 109 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index 88536a415246..c7eb1146a6c0 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -820,6 +820,77 @@ static int ne_set_user_memory_region_ioctl(struct ne_enclave *ne_enclave,
 	return rc;
 }
 
+/**
+ * ne_start_enclave_ioctl() - Trigger enclave start after the enclave resources,
+ *			      such as memory and CPU, have been set.
+ * @ne_enclave :		Private data associated with the current enclave.
+ * @enclave_start_info :	Enclave info that includes enclave cid and flags.
+ *
+ * Context: Process context. This function is called with the ne_enclave mutex held.
+ * Return:
+ * * 0 on success.
+ * * Negative return value on failure.
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
 /**
  * ne_enclave_ioctl() - Ioctl function provided by the enclave file.
  * @file:	File associated with this ioctl function.
@@ -967,6 +1038,44 @@ static long ne_enclave_ioctl(struct file *file, unsigned int cmd, unsigned long
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
+		if (enclave_start_info.flags >= NE_ENCLAVE_START_MAX_FLAG_VAL)
+			return -EINVAL;
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

