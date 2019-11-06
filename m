Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68D1BF11C3
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 10:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731541AbfKFJJs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 04:09:48 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45848 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbfKFJJr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 04:09:47 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6990N7090942;
        Wed, 6 Nov 2019 09:09:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=1qFf9aDf9zG7q8bwQc3g1PGXiQtKf91A0j9zzYWPIcQ=;
 b=CWii5o0wVZR6wlZLovTknVR4Y08PDzKB9j3h7iOz6ZInWdZdkbpCTQqauuXy9XyvoDj7
 02F8cs+IvM+CB0/yRNrDHcvqz1/nYq4klwSVNxe32BKxabPDbhUoqwMdCJGwGW7bEBGn
 iLZwGF4VaXIhx5dZ/cvMHyJSigxZyZHNmNRQKu9MuwjssgULBS83fJ6HCdCDcNlHAG7l
 yzTzJolhhdz8cwJVxoutk1GqM1DqfO43ARs4TZM854yKHrbXccmdL2jY2+ACEKtN7G9K
 bMjECqDf44W1QmF2xSCmvxwQbIm5DeMl19cg6G+SnUt7wNQg4cCo4SjEMQlhI9N6lvIs 6Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2w12erca51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 09:09:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA698rfP015319;
        Wed, 6 Nov 2019 09:09:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2w31631dv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 09:09:27 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA699QHM001033;
        Wed, 6 Nov 2019 09:09:26 GMT
Received: from z2.cn.oracle.com (/10.182.71.218)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 01:09:25 -0800
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        rafael.j.wysocki@intel.com, joao.m.martins@oracle.com,
        mtosatti@redhat.com, Zhenzhong Duan <zhenzhong.duan@oracle.com>
Subject: [PATCH v2 2/4] KVM: ensure grow start value is nonzero
Date:   Wed,  6 Nov 2019 17:08:50 +0800
Message-Id: <1573031332-2121-3-git-send-email-zhenzhong.duan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573031332-2121-1-git-send-email-zhenzhong.duan@oracle.com>
References: <1573031332-2121-1-git-send-email-zhenzhong.duan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=729
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911060096
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=807 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911060096
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vcpu->halt_poll_ns could be zeroed in certain cases (e.g. by
halt_poll_ns = 0). If halt_poll_grow_start is zero,
vcpu->halt_poll_ns will never be bigger than zero.

Use param callback to avoid writing zero to halt_poll_grow_start.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
---
 virt/kvm/kvm_main.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d6f0696..359516b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -69,6 +69,26 @@
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
+static int grow_start_set(const char *val, const struct kernel_param *kp)
+{
+	int ret;
+	unsigned int n;
+
+	if (!val)
+		return -EINVAL;
+
+	ret = kstrtouint(val, 0, &n);
+	if (ret || !n)
+		return -EINVAL;
+
+	return param_set_uint(val, kp);
+}
+
+static const struct kernel_param_ops grow_start_ops = {
+	.set = grow_start_set,
+	.get = param_get_uint,
+};
+
 /* Architectures should define their poll value according to the halt latency */
 unsigned int halt_poll_ns = KVM_HALT_POLL_NS_DEFAULT;
 module_param(halt_poll_ns, uint, 0644);
@@ -81,7 +101,7 @@
 
 /* The start value to grow halt_poll_ns from */
 unsigned int halt_poll_ns_grow_start = 10000; /* 10us */
-module_param(halt_poll_ns_grow_start, uint, 0644);
+module_param_cb(halt_poll_ns_grow_start, &grow_start_ops, &halt_poll_ns_grow_start, 0644);
 EXPORT_SYMBOL_GPL(halt_poll_ns_grow_start);
 
 /* Default resets per-vcpu halt_poll_ns . */
-- 
1.8.3.1

