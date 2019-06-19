Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECC0F4BDF4
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 18:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbfFSQXR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 12:23:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49896 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfFSQXR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 12:23:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5JGDn2w030848;
        Wed, 19 Jun 2019 16:22:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=DBjYNF4/pkt24mrwuEAr3h34TQt4sLfFgFuRGeEq4+Q=;
 b=OJCEG7AifwUmQe9qTLr7tlefubpKQPr8SqsrsVuiAJlEeRhmS/Emlk23CrlgbA01vhYJ
 /15+DqaREVuxVr0Y1EiyoPKPk7irXuGdj6Cfdk5iahCe9eI3r63/cLITi6FkYIjl87o5
 FcHtb4eZ9ND64IeTBogHmQ0SsAanRkoe7n6Dw5qhfbYPZny5j0tcKr04GBicRYoP+pR1
 QbwQ9m6HqLWqvj6a4zlHI4SXMQjENL2dzJ1532/Ef24xHAYlia84naRAG6egRThdQcEb
 o/PG7EmOCmNHkNKz77mnMe9woNbvruShHeyLenBkJ+DhJNF/m3uew/hZ+uGF7QUP/4Oc Ug== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2t7809cekq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 16:22:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5JGLbur133107;
        Wed, 19 Jun 2019 16:22:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2t77yn6pwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 16:22:12 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5JGMBrI024629;
        Wed, 19 Jun 2019 16:22:11 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Jun 2019 09:22:11 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, mtosatti@redhat.com, rth@twiddle.net,
        ehabkost@redhat.com, kvm@vger.kernel.org, jmattson@google.com,
        maran.wilson@oracle.com, dgilbert@redhat.com,
        Liran Alon <liran.alon@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [QEMU PATCH v4 04/10] target/i386: kvm: Re-inject #DB to guest with updated DR6
Date:   Wed, 19 Jun 2019 19:21:34 +0300
Message-Id: <20190619162140.133674-5-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190619162140.133674-1-liran.alon@oracle.com>
References: <20190619162140.133674-1-liran.alon@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9293 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906190131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9293 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906190131
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If userspace (QEMU) debug guest, when #DB is raised in guest and
intercepted by KVM, KVM forwards information on #DB to userspace
instead of injecting #DB to guest.
While doing so, KVM don't update vCPU DR6 but instead report the #DB DR6
value to userspace for further handling.
See KVM's handle_exception() DB_VECTOR handler.

QEMU handler for this case is kvm_handle_debug(). This handler basically
checks if #DB is related to one of user set hardware breakpoints and if
not, it re-inject #DB into guest.
The re-injection is done by setting env->exception_injected to #DB which
will later be passed as events.exception.nr to KVM_SET_VCPU_EVENTS ioctl
by kvm_put_vcpu_events().

However, in case userspace re-injects #DB, KVM expects userspace to set
vCPU DR6 as reported to userspace when #DB was intercepted! Otherwise,
KVM_REQ_EVENT handler will inject #DB with wrong DR6 to guest.

Fix this issue by updating vCPU DR6 appropriately when re-inject #DB to
guest.

Reviewed-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 target/i386/kvm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 7b3b80833fdd..fa01f18b28f0 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -3561,6 +3561,9 @@ static int kvm_handle_debug(X86CPU *cpu,
         /* pass to guest */
         env->exception_injected = arch_info->exception;
         env->has_error_code = 0;
+        if (arch_info->exception == EXCP01_DB) {
+            env->dr[6] = arch_info->dr6;
+        }
     }
 
     return ret;
-- 
2.20.1

