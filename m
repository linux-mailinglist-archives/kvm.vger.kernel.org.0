Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4513E2A31B1
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 18:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgKBRgq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 12:36:46 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:5473 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727395AbgKBRgq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 12:36:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1604338605; x=1635874605;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=63PIJXKLFwrFkRjowWo20b8DPKycpZ23Q/BMc+ghSfk=;
  b=X694F9AqmVjeRErGig164uYjTV3JWrVduqTWXdEHKtiKOBesHF4yQ/pF
   fsMLPkHmNUHi/VViVzhoWHM5nnAXQ/M+q36ZknxvYvL/vxClYEmuPj7pX
   5V5xZ82koqslXRVCxC/6h2/GEk32K9kGoSFWX5kOPCakSwiiteZCUdKJH
   c=;
X-IronPort-AV: E=Sophos;i="5.77,445,1596499200"; 
   d="scan'208";a="62248451"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 02 Nov 2020 17:36:38 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id 0F334A21C2;
        Mon,  2 Nov 2020 17:36:36 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.229) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 2 Nov 2020 17:36:27 +0000
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Karen Noel <knoel@redhat.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        "Uwe Dannowski" <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v2] nitro_enclaves: Fixup type and simplify logic of the poll mask setup
Date:   Mon, 2 Nov 2020 19:36:22 +0200
Message-ID: <20201102173622.32169-1-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
X-Originating-IP: [10.43.160.229]
X-ClientProxiedBy: EX13D34UWC002.ant.amazon.com (10.43.162.137) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update the assigned value of the poll result to be EPOLLHUP instead of
POLLHUP to match the __poll_t type.

While at it, simplify the logic of setting the mask result of the poll
function.

Changelog

v1 -> v2

* Simplify the mask setting logic from the poll function.

Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
Reported-by: kernel test robot <lkp@intel.com>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index f06622b48d695..f1964ea4b8269 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -1505,10 +1505,8 @@ static __poll_t ne_enclave_poll(struct file *file, poll_table *wait)
 
 	poll_wait(file, &ne_enclave->eventq, wait);
 
-	if (!ne_enclave->has_event)
-		return mask;
-
-	mask = POLLHUP;
+	if (ne_enclave->has_event)
+		mask |= EPOLLHUP;
 
 	return mask;
 }
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

