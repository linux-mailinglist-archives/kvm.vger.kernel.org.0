Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98AF8F1100
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 09:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730256AbfKFI1E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 03:27:04 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:59064 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729951AbfKFI1D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 03:27:03 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA68O1Ia053343;
        Wed, 6 Nov 2019 08:26:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=GFk4Eu9gAUGOFn6+W8/fSbeHy1Ds/V3T6NhIdP6+YpE=;
 b=RhHmxNxy+8XGCiW2QN8CyYWSoumDNQknM5k7OEl6k5P/VqGVYHmQ3X9kWTAQhvJ4IFUk
 0C7O30SzrH0kU5FmHLBkMOUnQrDvZhSoDqeQEXodIEEc7NCezUKFgvEsiz3/whrwoZqN
 rA/j4ZAJkJCWWpFGCBlwcVbWS832+YaqAKkaDDdElU3fvlfdWxfStMu0JqytaY+4R3wb
 2hjbxywlVEEFugssX1FTCQxlehK7mQyi0i1bOcfG55HkRLzsre8E825UzVK4LGxpsWw5
 DCdx34OV/9CkkTVQr6TguSViytC5Ve9O3y4WX3Lh2mROM7DDSdl6eqZlWaJgiMlKy/sl gA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w12erc2kc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 08:26:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA68NSwK058423;
        Wed, 6 Nov 2019 08:26:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2w333wvb2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 08:26:45 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA68QgTh013138;
        Wed, 6 Nov 2019 08:26:42 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 00:26:42 -0800
Date:   Wed, 6 Nov 2019 11:26:36 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Junaid Shahid <junaids@google.com>, kvm@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] kvm: Fix NULL dereference doing kvm_create_vm()
Message-ID: <20191106082636.GB31923@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911060088
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911060088
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If init_srcu_struct() or init_srcu_struct() fails then this function
returns ERR_PTR(0) which is NULL.  It leads to a NULL dereference in the
caller.

Fixes: 9121923c457d ("kvm: Allocate memslots and buses before calling kvm_arch_init_vm")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 virt/kvm/kvm_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d16d2054e937..91971811fa5f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -675,6 +675,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	INIT_HLIST_HEAD(&kvm->irq_ack_notifier_list);
 #endif
 
+	r = -ENOMEM;
 	if (init_srcu_struct(&kvm->srcu))
 		goto out_err_no_srcu;
 	if (init_srcu_struct(&kvm->irq_srcu))
-- 
2.20.1

