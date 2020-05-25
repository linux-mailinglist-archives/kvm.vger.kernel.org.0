Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F7F1E17B8
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 00:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731363AbgEYWPy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 18:15:54 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:45210 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729769AbgEYWPy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 18:15:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590444952; x=1621980952;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+uRbgVQ073Qjebi6ZNDN7o3ZZo0J/KTgp8rgPUIYZCA=;
  b=Xn+omYJO0JrLRxssHDil0ow8odTp0IiYo7ROTXf5cSF877FzWNkl2gMw
   05e7/OKPvmacdgrr28hOh/8shPqDeFBXZF1c81qy0qxPCP0N0LpFcOVvq
   /MiZaeb5YPnqo2zDRaZhfrfk8mOKx4kMFn95+Eca7LaMaQ+MDho+iABQl
   Q=;
IronPort-SDR: rGXzbREjh2PQIB+JJvEekvZyZtSQePxggiqOE9MRWdZ/SxEjfZiKtafviodnFtaoDiU18LrwHq
 ctHkFok1yJpA==
X-IronPort-AV: E=Sophos;i="5.73,435,1583193600"; 
   d="scan'208";a="32159810"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 25 May 2020 22:15:52 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id 4D185A1F48;
        Mon, 25 May 2020 22:15:50 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 25 May 2020 22:15:49 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.50) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 25 May 2020 22:15:41 +0000
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
Subject: [PATCH v3 12/18] nitro_enclaves: Add logic for enclave start
Date:   Tue, 26 May 2020 01:13:28 +0300
Message-ID: <20200525221334.62966-13-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200525221334.62966-1-andraprs@amazon.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.162.50]
X-ClientProxiedBy: EX13D06UWA002.ant.amazon.com (10.43.160.143) To
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

v2 -> v3

* Remove the WARN_ON calls.
* Update static calls sanity checks.

v1 -> v2

* Add log pattern for NE.
* Check if enclave state is init when starting an enclave.
* Remove the BUG_ON calls.
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 101 ++++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index a7b0903d7d28..2a8e61d6a260 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -409,6 +409,47 @@ static int ne_set_user_memory_region_ioctl(struct ne_enclave *ne_enclave,
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
+		pr_err_ratelimited(NE "Error in enclave start [rc=%d]\n", rc);
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
 static long ne_enclave_ioctl(struct file *file, unsigned int cmd,
 			     unsigned long arg)
 {
@@ -511,6 +552,66 @@ static long ne_enclave_ioctl(struct file *file, unsigned int cmd,
 		return rc;
 	}
 
+	case NE_START_ENCLAVE: {
+		struct enclave_start_metadata enclave_start_metadata = {};
+		int rc = -EINVAL;
+
+		if (copy_from_user(&enclave_start_metadata, (void *)arg,
+				   sizeof(enclave_start_metadata))) {
+			pr_err_ratelimited(NE "Error in copy from user\n");
+
+			return -EFAULT;
+		}
+
+		mutex_lock(&ne_enclave->enclave_info_mutex);
+
+		if (ne_enclave->state != NE_STATE_INIT) {
+			pr_err_ratelimited(NE "Enclave isn't in init state\n");
+
+			mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+			return -EINVAL;
+		}
+
+		if (!ne_enclave->nr_mem_regions) {
+			pr_err_ratelimited(NE "Enclave has no mem regions\n");
+
+			mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+			return -EINVAL;
+		}
+
+		if (!ne_enclave->nr_vcpus) {
+			pr_err_ratelimited(NE "Enclave has no vcpus\n");
+
+			mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+			return -EINVAL;
+		}
+
+		if (!cpumask_empty(ne_enclave->cpu_siblings)) {
+			pr_err_ratelimited(NE "CPU siblings not used\n");
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
+			pr_err_ratelimited(NE "Error in copy to user\n");
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

