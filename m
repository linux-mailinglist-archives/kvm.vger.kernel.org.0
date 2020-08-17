Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8D2246722
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 15:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbgHQNNR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 09:13:17 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:22355 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728780AbgHQNMb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 09:12:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597669951; x=1629205951;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=htnncjjl+S5fLaxkynUMEyDjHBhcTj+SwhLxbd25kfA=;
  b=E7jiwY3H8U+uo3nIAhgiDAquKos+z+q0OhkexSKELrcTo8X4tEIF32bL
   ScQisNfcyXFsn7KB6pHkgH7CW8CWVjT416mJ9Dj01npU1etC9VAi2Ie5b
   n+w/Mcr27Vo7577vxfOftjXEAvxzhQkeTj2sAogsELHiQs77+qAVxHlqM
   k=;
X-IronPort-AV: E=Sophos;i="5.76,322,1592870400"; 
   d="scan'208";a="48202812"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 17 Aug 2020 13:12:30 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id 7ACB8A04EA;
        Mon, 17 Aug 2020 13:12:27 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 17 Aug 2020 13:12:26 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.228) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 17 Aug 2020 13:12:13 +0000
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
Subject: [PATCH v7 12/18] nitro_enclaves: Add logic for starting an enclave
Date:   Mon, 17 Aug 2020 16:09:57 +0300
Message-ID: <20200817131003.56650-13-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200817131003.56650-1-andraprs@amazon.com>
References: <20200817131003.56650-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.162.228]
X-ClientProxiedBy: EX13D34UWC004.ant.amazon.com (10.43.162.155) To
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
Reviewed-by: Alexander Graf <graf@amazon.com>
---
Changelog

v6 -> v7

* Update the naming and add more comments to make more clear the logic
  of handling full CPU cores and dedicating them to the enclave.

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
index 3d8a771bde1d..be81ff5634af 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -957,6 +957,77 @@ static int ne_set_user_memory_region_ioctl(struct ne_enclave *ne_enclave,
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
+	for (i = 0; i < ne_enclave->nr_parent_vm_cores; i++)
+		for_each_cpu(cpu, ne_enclave->threads_per_core[i])
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
@@ -1105,6 +1176,44 @@ static long ne_enclave_ioctl(struct file *file, unsigned int cmd, unsigned long
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

