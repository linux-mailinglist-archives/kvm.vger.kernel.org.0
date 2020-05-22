Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39651DDFE6
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 08:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728636AbgEVGbo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 02:31:44 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:33810 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728371AbgEVGbo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 02:31:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590129104; x=1621665104;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rJzeHtcicxOU0HUoPr5xYwGnt2a0NWxVxt6g39XUl0w=;
  b=c6EYPwLwQqZveFYxqgD+l0SmKcDZM8xMq50Yh2CB3huuZRQjGiejfCIj
   r34UJo9TFdAJw+MW33RW7Lqyf+nZPWfmhW/Y2PtdyAPmGdBPDgo1kHEEL
   ykFfCqz4HWvkt+m0mLFk+2p5USD47AXJhO1lM9Z5qAsj0sSOSwLkA5UJX
   M=;
IronPort-SDR: 6QSeRXkxjIg1mY5B2lTZcHSl4+0sPQlPsUYV0coQvY2i9k1b9auDyXyo9tzxXtchqk4lgQuZWr
 Rwq83ZnYOzEw==
X-IronPort-AV: E=Sophos;i="5.73,420,1583193600"; 
   d="scan'208";a="36944429"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-17c49630.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 22 May 2020 06:31:43 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-17c49630.us-east-1.amazon.com (Postfix) with ESMTPS id 2E52EA067A;
        Fri, 22 May 2020 06:31:41 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 06:31:40 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.175) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 06:31:31 +0000
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
Subject: [PATCH v2 10/18] nitro_enclaves: Add logic for enclave image load metadata
Date:   Fri, 22 May 2020 09:29:38 +0300
Message-ID: <20200522062946.28973-11-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200522062946.28973-1-andraprs@amazon.com>
References: <20200522062946.28973-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.175]
X-ClientProxiedBy: EX13D27UWA001.ant.amazon.com (10.43.160.19) To
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
image in the memory using the giveni memory offset.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 24 +++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index 8cf262ac1bbc..936c9ce19213 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -295,6 +295,30 @@ static long ne_enclave_ioctl(struct file *file, unsigned int cmd,
 		return rc;
 	}
 
+	case NE_GET_IMAGE_LOAD_METADATA: {
+		struct image_load_metadata image_load_metadata = {};
+
+		if (copy_from_user(&image_load_metadata, (void *)arg,
+				   sizeof(image_load_metadata))) {
+			pr_err_ratelimited(NE "Error in copy from user\n");
+
+			return -EFAULT;
+		}
+
+		/* TODO: Check flags before setting the memory offset. */
+
+		image_load_metadata.memory_offset = NE_IMAGE_LOAD_OFFSET;
+
+		if (copy_to_user((void *)arg, &image_load_metadata,
+				 sizeof(image_load_metadata))) {
+			pr_err_ratelimited(NE "Error in copy to user\n");
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

