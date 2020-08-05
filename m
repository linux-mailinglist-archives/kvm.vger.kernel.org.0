Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06EB823C8DE
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 11:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbgHEJNp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 05:13:45 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:2072 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728520AbgHEJM1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 05:12:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1596618746; x=1628154746;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VOjgwAcvIpz+2XwKl01VpERw5XYtxTjTT5LdbafIEdA=;
  b=H4BNjpRf8pSYyBbuvVU4GR3rhk68RCUIrJYnzgygtL9XQQ8HTFnEzO6h
   Ur5arGn36TNc4PuA2/z3NJl+nyGyH39jwYH7zWSXJ2QwwvSUZPkBraYkk
   Z2MHcEiSgNNKr+D0n1vSkhl+TscLznNlffbN5PEMYuasStWrWBpcZmyLe
   o=;
IronPort-SDR: Nn6jFpiauAN6079SSV7IVIDXPrnpIEPBmu4CQo7LfDVEBxjNTW7eAvpuepyH4FNk2LcwkK/w0/
 vRnxcj9jTklA==
X-IronPort-AV: E=Sophos;i="5.75,436,1589241600"; 
   d="scan'208";a="46247639"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 05 Aug 2020 09:12:24 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (Postfix) with ESMTPS id 71339A21F9;
        Wed,  5 Aug 2020 09:12:22 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 5 Aug 2020 09:12:21 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.248) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 5 Aug 2020 09:12:09 +0000
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
Subject: [PATCH v6 10/18] nitro_enclaves: Add logic for getting the enclave image load info
Date:   Wed, 5 Aug 2020 12:10:09 +0300
Message-ID: <20200805091017.86203-11-andraprs@amazon.com>
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

Before setting the memory regions for the enclave, the enclave image
needs to be placed in memory. After the memory regions are set, this
memory cannot be used anymore by the VM, being carved out.

Add ioctl command logic to get the offset in enclave memory where to
place the enclave image. Then the user space tooling copies the enclave
image in the memory using the given memory offset.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
Changelog

v5 -> v6

* Check for invalid enclave image load flags.

v4 -> v5

* Check for the enclave not being started when invoking this ioctl call.
* Remove log on copy_from_user() / copy_to_user() failure.

v3 -> v4

* Use dev_err instead of custom NE log pattern.
* Set enclave image load offset based on flags.
* Update the naming for the ioctl command from metadata to info.

v2 -> v3

* No changes.

v1 -> v2

* New in v2.
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 30 +++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index 4787bc59d39d..850e5e0ce0e9 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -652,6 +652,36 @@ static long ne_enclave_ioctl(struct file *file, unsigned int cmd, unsigned long
 		return 0;
 	}
 
+	case NE_GET_IMAGE_LOAD_INFO: {
+		struct ne_image_load_info image_load_info = {};
+
+		if (copy_from_user(&image_load_info, (void __user *)arg, sizeof(image_load_info)))
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
+		mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+		if (image_load_info.flags == NE_EIF_IMAGE)
+			image_load_info.memory_offset = NE_EIF_LOAD_OFFSET;
+		else
+			return -EINVAL;
+
+		if (copy_to_user((void __user *)arg, &image_load_info, sizeof(image_load_info)))
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

