Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5BF2040F1
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 22:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbgFVUFc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 16:05:32 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:63836 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728560AbgFVUFb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 16:05:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1592856331; x=1624392331;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HatlV912NQkkbEgQV2ZmF4rTB7Ipr6N20oR3XWRDTaU=;
  b=ludtmChhVnNSmr/TNxvLYhK85+8XHHPJ0sLVDmRqpb4/bUSp55QVa1Ir
   ejsPtG0+FHTG5vb4DeM0tFGef44Dib/liu4x64HBoAbF4iHqPj5VrJ7mA
   /x5TVdaX74QC0rJJM2oDWYXzZZvl8NGWSPOhQQtzW+59agTUMYon5z3VI
   s=;
IronPort-SDR: UyE7kmL91OLarbeeFva/BYRdoRMf0cqUkQgTOFxFa+s2KsCKEcrZ8erTkHJ6Q4yJqLQI1CFnNI
 T/egnmCmUBPA==
X-IronPort-AV: E=Sophos;i="5.75,268,1589241600"; 
   d="scan'208";a="46041319"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-69849ee2.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 22 Jun 2020 20:05:30 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-69849ee2.us-west-2.amazon.com (Postfix) with ESMTPS id 12D25A0593;
        Mon, 22 Jun 2020 20:05:30 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 22 Jun 2020 20:05:29 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.65) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 22 Jun 2020 20:05:19 +0000
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
Subject: [PATCH v4 10/18] nitro_enclaves: Add logic for enclave image load info
Date:   Mon, 22 Jun 2020 23:03:21 +0300
Message-ID: <20200622200329.52996-11-andraprs@amazon.com>
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

Before setting the memory regions for the enclave, the enclave image
needs to be placed in memory. After the memory regions are set, this
memory cannot be used anymore by the VM, being carved out.

Add ioctl command logic to get the offset in enclave memory where to
place the enclave image. Then the user space tooling copies the enclave
image in the memory using the given memory offset.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
Changelog

v3 -> v4

* Use dev_err instead of custom NE log pattern.
* Set enclave image load offset based on flags.
* Update the naming for the ioctl command from metadata to info.

v2 -> v3

* No changes.

v1 -> v2

* New in v2.
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 25 +++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index d6777008f685..cfdefa52ed2a 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -536,6 +536,31 @@ static long ne_enclave_ioctl(struct file *file, unsigned int cmd,
 		return rc;
 	}
 
+	case NE_GET_IMAGE_LOAD_INFO: {
+		struct ne_image_load_info image_load_info = {};
+
+		if (copy_from_user(&image_load_info, (void *)arg,
+				   sizeof(image_load_info))) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Error in copy from user\n");
+
+			return -EFAULT;
+		}
+
+		if (image_load_info.flags == NE_EIF_IMAGE)
+			image_load_info.memory_offset = NE_EIF_LOAD_OFFSET;
+
+		if (copy_to_user((void *)arg, &image_load_info,
+				 sizeof(image_load_info))) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Error in copy to user\n");
+
+			return -EFAULT;
+		}
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

