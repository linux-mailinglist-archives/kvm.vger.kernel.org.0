Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B77A2040F6
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 22:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728785AbgFVUFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 16:05:49 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:32909 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728664AbgFVUFt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 16:05:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1592856348; x=1624392348;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VEII4kh1AXc7vnvBWzJ9rZdPU4SnXmHcT5TSrlZuiPk=;
  b=ODwunKz1l2ucXhqH4zq0EJXsrKzDL/q51xH/7oARpOoRjvtpsYr5r7DF
   Y8cyYlBKcvUWlWkB6RvJtgVRUG6anWMOn79dS6skQ/g+QO2oU89vgvGEi
   2AdX11vZO9FXvFb6hBsSxATm7L8x7J/FhIiw08U95Tqo/kzmkYr14XfUH
   g=;
IronPort-SDR: iFo6/w4zRjtv5CqqSkWzHe3uGl8PkAUP/J4G3GfhBr38Xaf0Byl1AyrNZNr+QmRwQO7Trvr1/N
 07Pfr+550mLg==
X-IronPort-AV: E=Sophos;i="5.75,268,1589241600"; 
   d="scan'208";a="52986809"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-69849ee2.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 22 Jun 2020 20:05:47 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-69849ee2.us-west-2.amazon.com (Postfix) with ESMTPS id E4C4EA21BB;
        Mon, 22 Jun 2020 20:05:46 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 22 Jun 2020 20:05:46 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.65) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 22 Jun 2020 20:05:37 +0000
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
Subject: [PATCH v4 12/18] nitro_enclaves: Add logic for enclave start
Date:   Mon, 22 Jun 2020 23:03:23 +0300
Message-ID: <20200622200329.52996-13-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200622200329.52996-1-andraprs@amazon.com>
References: <20200622200329.52996-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.160.65]
X-ClientProxiedBy: EX13D45UWB004.ant.amazon.com (10.43.161.54) To
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
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 114 ++++++++++++++++++++++
 1 file changed, 114 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index 17ccb6cdbd75..d9794f327169 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -703,6 +703,45 @@ static int ne_set_user_memory_region_ioctl(struct ne_enclave *ne_enclave,
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
+	struct enclave_start_req enclave_start_req = {};
+	int rc = -EINVAL;
+
+	enclave_start_req.enclave_cid = enclave_start_info->enclave_cid;
+	enclave_start_req.flags = enclave_start_info->flags;
+	enclave_start_req.slot_uid = ne_enclave->slot_uid;
+
+	rc = ne_do_request(ne_enclave->pdev, ENCLAVE_START, &enclave_start_req,
+			   sizeof(enclave_start_req), &cmd_reply,
+			   sizeof(cmd_reply));
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
 static long ne_enclave_ioctl(struct file *file, unsigned int cmd,
 			     unsigned long arg)
 {
@@ -818,6 +857,81 @@ static long ne_enclave_ioctl(struct file *file, unsigned int cmd,
 		return rc;
 	}
 
+	case NE_START_ENCLAVE: {
+		struct ne_enclave_start_info enclave_start_info = {};
+		int rc = -EINVAL;
+
+		if (copy_from_user(&enclave_start_info, (void *)arg,
+				   sizeof(enclave_start_info))) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Error in copy from user\n");
+
+			return -EFAULT;
+		}
+
+		mutex_lock(&ne_enclave->enclave_info_mutex);
+
+		if (ne_enclave->state != NE_STATE_INIT) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Enclave isn't in init state\n");
+
+			mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+			return -EINVAL;
+		}
+
+		if (!ne_enclave->nr_mem_regions) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Enclave has no mem regions\n");
+
+			mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+			return -ENOMEM;
+		}
+
+		if (ne_enclave->mem_size < NE_MIN_ENCLAVE_MEM_SIZE) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Enclave memory is less than %ld\n",
+					    NE_MIN_ENCLAVE_MEM_SIZE);
+
+			mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+			return -ENOMEM;
+		}
+
+		if (!ne_enclave->nr_vcpus) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Enclave has no vcpus\n");
+
+			mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+			return -EINVAL;
+		}
+
+		if (!cpumask_empty(ne_enclave->cpu_siblings)) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "CPU siblings not used\n");
+
+			mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+			return -EINVAL;
+		}
+
+		rc = ne_start_enclave_ioctl(ne_enclave, &enclave_start_info);
+
+		mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+		if (copy_to_user((void *)arg, &enclave_start_info,
+				 sizeof(enclave_start_info))) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Error in copy to user\n");
+
+			return -EFAULT;
+		}
+
+		return rc;
+	}
+
 	default:
 		return -ENOTTY;
 	}
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

