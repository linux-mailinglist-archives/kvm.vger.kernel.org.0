Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4D51B2F68
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 20:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729682AbgDUSoB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 14:44:01 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:44135 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729679AbgDUSoB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 14:44:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587494640; x=1619030640;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tTIsnBjqE+u3ZnWQbEklQODug9U78pYyqe4mU4uBc4s=;
  b=dEHSY03iRIklzqdLG50OhP3VrruByRRy7Wjeq1OA+o/p8QSJknN5cWzJ
   Es/aXy6EjJGq+NJpmvO8PXvffO23F7gqDHLElc6B23D1Z3eM4cfExrwvn
   f9ANVvcQxujTTSoBQv/uWrk0h21VjiBkBRMmyLkaZF88pjEJjBOmg9lMJ
   Y=;
IronPort-SDR: 1bfE/NL9nQ9wrCFDt9DoWxRX8LrzLfnEPlo1zt6gTs3ktQWjKCYzSxPuO4sTQK/UMHDp8d6JIH
 RnHSDQO0y6wQ==
X-IronPort-AV: E=Sophos;i="5.72,411,1580774400"; 
   d="scan'208";a="28051328"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 21 Apr 2020 18:43:47 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com (Postfix) with ESMTPS id 68F07C5B80;
        Tue, 21 Apr 2020 18:43:46 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Apr 2020 18:43:45 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.217) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Apr 2020 18:43:37 +0000
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
Subject: [PATCH v1 11/15] nitro_enclaves: Add logic for enclave start
Date:   Tue, 21 Apr 2020 21:41:46 +0300
Message-ID: <20200421184150.68011-12-andraprs@amazon.com>
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

After all the enclave resources are set, the enclave is ready for
beginning to run.

Add ioctl command logic for starting an enclave after all its resources,
memory regions and CPUs, have been set.

The enclave start information includes the local channel addressing -
vsock CID - and the flags associated with the enclave.

Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 .../virt/amazon/nitro_enclaves/ne_misc_dev.c  | 83 +++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/drivers/virt/amazon/nitro_enclaves/ne_misc_dev.c b/drivers/virt/amazon/nitro_enclaves/ne_misc_dev.c
index 0bd283f73a87..f07eb46f7995 100644
--- a/drivers/virt/amazon/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/amazon/nitro_enclaves/ne_misc_dev.c
@@ -455,6 +455,53 @@ static int ne_set_user_memory_region_ioctl(struct ne_enclave *ne_enclave,
 	return rc;
 }
 
+/**
+ * ne_enclave_start_ioctl - Trigger enclave start after the enclave resources,
+ * such as memory and CPU, have been set.
+ *
+ * This function gets called with the ne_enclave mutex held.
+ *
+ * @ne_enclave: private data associated with the current enclave.
+ * @enclave_start_metadata: enclave metadata that includes enclave cid and
+ *			    flags and the slot uid.
+ *
+ * @returns: 0 on success, negative return value on failure.
+ */
+static int ne_enclave_start_ioctl(struct ne_enclave *ne_enclave,
+	struct enclave_start_metadata *enclave_start_metadata)
+{
+	struct ne_pci_dev_cmd_reply cmd_reply = {};
+	struct enclave_start_req enclave_start_req = {};
+	int rc = -EINVAL;
+
+	BUG_ON(!ne_enclave);
+	BUG_ON(!ne_enclave->pdev);
+
+	if (WARN_ON(!enclave_start_metadata))
+		return -EINVAL;
+
+	enclave_start_metadata->slot_uid = ne_enclave->slot_uid;
+
+	enclave_start_req.enclave_cid = enclave_start_metadata->enclave_cid;
+	enclave_start_req.flags = enclave_start_metadata->flags;
+	enclave_start_req.slot_uid = enclave_start_metadata->slot_uid;
+
+	rc = ne_do_request(ne_enclave->pdev, ENCLAVE_START, &enclave_start_req,
+			   sizeof(enclave_start_req), &cmd_reply,
+			   sizeof(cmd_reply));
+	if (rc < 0) {
+		pr_err_ratelimited("Failure in enclave start [rc=%d]\n", rc);
+
+		return rc;
+	}
+
+	ne_enclave->state = NE_STATE_RUNNING;
+
+	enclave_start_metadata->enclave_cid = cmd_reply.enclave_cid;
+
+	return 0;
+}
+
 static int ne_enclave_open(struct inode *node, struct file *file)
 {
 	return 0;
@@ -521,6 +568,42 @@ static long ne_enclave_ioctl(struct file *file, unsigned int cmd,
 		return rc;
 	}
 
+	case NE_ENCLAVE_START: {
+		struct enclave_start_metadata enclave_start_metadata = {};
+		int rc = -EINVAL;
+
+		if (copy_from_user(&enclave_start_metadata, (void *)arg,
+				   sizeof(enclave_start_metadata))) {
+			pr_err_ratelimited("Failure in copy from user\n");
+
+			return -EFAULT;
+		}
+
+		mutex_lock(&ne_enclave->enclave_info_mutex);
+
+		if (!cpumask_empty(ne_enclave->cpu_siblings)) {
+			pr_err_ratelimited("Enclave has CPU siblings avail\n");
+
+			mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+			return -EINVAL;
+		}
+
+		rc = ne_enclave_start_ioctl(ne_enclave,
+					    &enclave_start_metadata);
+
+		mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+		if (copy_to_user((void *)arg, &enclave_start_metadata,
+				 sizeof(enclave_start_metadata))) {
+			pr_err_ratelimited("Failure in copy to user\n");
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

