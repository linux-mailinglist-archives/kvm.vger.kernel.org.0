Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 668F22723AC
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 14:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgIUMT6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 08:19:58 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:52608 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbgIUMT6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 08:19:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600690797; x=1632226797;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nNFKuyjezwM1uAW2fqddZDejx8fkAYYUz6LJlaSx4Sg=;
  b=SS0v+lmyaio9L2qask2OKljz6kmoyWXhKcuoZRouEuofuIO9Q1/Mrbrz
   FlX+HNtdX2UQOmBUj0cGWfxhbiqvbAstkvdbhQyv6qceANhZKDcDDDedf
   PRYW5alofwJSVsovS9uP6iFCIS9nhYLZ2s4ooIR/r7tOU0vcI0v4th3l3
   s=;
X-IronPort-AV: E=Sophos;i="5.77,286,1596499200"; 
   d="scan'208";a="55274726"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 21 Sep 2020 12:19:57 +0000
Received: from EX13D16EUB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id 1304AC05D1;
        Mon, 21 Sep 2020 12:19:54 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.71) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 21 Sep 2020 12:19:44 +0000
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
Subject: [PATCH v10 10/18] nitro_enclaves: Add logic for getting the enclave image load info
Date:   Mon, 21 Sep 2020 15:17:24 +0300
Message-ID: <20200921121732.44291-11-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200921121732.44291-1-andraprs@amazon.com>
References: <20200921121732.44291-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.71]
X-ClientProxiedBy: EX13D06UWC001.ant.amazon.com (10.43.162.91) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before setting the memory regions for the enclave, the enclave image
needs to be placed in memory. After the memory regions are set, this
memory cannot be used anymore by the VM, being carved out.

Add ioctl command logic to get the offset in enclave memory where to
place the enclave image. Then the user space tooling copies the enclave
image in the memory using the given memory offset.

Changelog

v9 -> v10

* Update commit message to include the changelog before the SoB tag(s).

v8 -> v9

* No changes.

v7 -> v8

* Add custom error code for incorrect enclave image load info flag.

v6 -> v7

* No changes.

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

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 36 +++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index 24e4270d181d..fe83588c8b02 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -807,6 +807,42 @@ static long ne_enclave_ioctl(struct file *file, unsigned int cmd, unsigned long
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
+		if (!image_load_info.flags ||
+		    image_load_info.flags >= NE_IMAGE_LOAD_MAX_FLAG_VAL) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Incorrect flag in enclave image load info\n");
+
+			return -NE_ERR_INVALID_FLAG_VALUE;
+		}
+
+		if (image_load_info.flags == NE_EIF_IMAGE)
+			image_load_info.memory_offset = NE_EIF_LOAD_OFFSET;
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

