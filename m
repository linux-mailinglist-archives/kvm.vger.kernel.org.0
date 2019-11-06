Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEA8DF11C5
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 10:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731605AbfKFJJy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 04:09:54 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54918 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727854AbfKFJJx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 04:09:53 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA698esT105144;
        Wed, 6 Nov 2019 09:09:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=ITh4bqD9xE5YeUegJCsH0m9UXI6eEn2CS5ZImoYu/nk=;
 b=iQh2wmGVZDwHP9W9EYfMdAbLGPCZiuUvlzUzKZXJCiSWZvsUn2zMF5tUcWit3V4jP4SH
 HKthPepnN0qhfJHvn00u7Sfmo4SAP138qUFjUODFQGyTIFJLvjw7oXJPmEPqJ5vL/mHS
 hN8UVAWG45/ANuB/qDBTx1KhtjBbC0SUMhqPR0R6uXYmJd1jOzeRrg64dn9slWWgotwO
 cFIMc6PUTTFFXmtYbADuJv02MZ03deoP+HpSb3SMQuPSyz5WTSB6RjWC96/k95q/N+4p
 0c+hDuEQWRu11d0HORSwy9jx/wo7GMCckOLZvyGuBvg5t1mOEZgRfT5XIe8cH1loTAgM 5w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2w11rq4f35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 09:09:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA69867h077683;
        Wed, 6 Nov 2019 09:09:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2w35pqk3c2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 09:09:31 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA699U1x006074;
        Wed, 6 Nov 2019 09:09:30 GMT
Received: from z2.cn.oracle.com (/10.182.71.218)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 01:09:30 -0800
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        rafael.j.wysocki@intel.com, joao.m.martins@oracle.com,
        mtosatti@redhat.com, Zhenzhong Duan <zhenzhong.duan@oracle.com>
Subject: [PATCH v2 4/4] KVM: ensure vCPU halt_poll_us in right scope
Date:   Wed,  6 Nov 2019 17:08:52 +0800
Message-Id: <1573031332-2121-5-git-send-email-zhenzhong.duan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573031332-2121-1-git-send-email-zhenzhong.duan@oracle.com>
References: <1573031332-2121-1-git-send-email-zhenzhong.duan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911060096
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911060096
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As user can adjust halt_poll_ns_grow_start and halt_poll_ns which
leads to vcpu->halt_poll_ns beyond the two boundaries. This patch
ensures vcpu->halt_poll_ns in that scope after growing or shrinking.

If halt_poll_ns_shrink is 0, shrink vcpu->halt_poll_ns to
halt_poll_ns_grow_start instead of 0. To disable poll we can set
halt_poll_ns to 0.

In case user wrongly set halt_poll_ns_grow_start > halt_poll_ns > 0,
halt_poll_ns take precedency and poll time is a fixed value of
halt_poll_ns.

This patch also simplifies branch check based on the guest haltpoll
code.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
---
 virt/kvm/kvm_main.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 359516b..b4fca66 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2308,9 +2308,15 @@ static void shrink_halt_poll_ns(struct kvm_vcpu *vcpu)
 	old = val = vcpu->halt_poll_ns;
 	shrink = READ_ONCE(halt_poll_ns_shrink);
 	if (shrink == 0)
-		val = 0;
-	else
+		val = halt_poll_ns_grow_start;
+	else {
 		val /= shrink;
+		if (val < halt_poll_ns_grow_start)
+			val = halt_poll_ns_grow_start;
+	}
+
+	if (val > halt_poll_ns)
+		val = halt_poll_ns;
 
 	vcpu->halt_poll_ns = val;
 	trace_kvm_halt_poll_ns_shrink(vcpu->vcpu_id, val, old);
@@ -2385,21 +2391,12 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
 
 	if (!kvm_arch_no_poll(vcpu)) {
-		if (!vcpu_valid_wakeup(vcpu)) {
+		/* we had a long block, shrink polling */
+		if (!vcpu_valid_wakeup(vcpu) || block_ns > halt_poll_ns)
 			shrink_halt_poll_ns(vcpu);
-		} else if (halt_poll_ns) {
-			if (block_ns <= vcpu->halt_poll_ns)
-				;
-			/* we had a long block, shrink polling */
-			else if (vcpu->halt_poll_ns && block_ns > halt_poll_ns)
-				shrink_halt_poll_ns(vcpu);
-			/* we had a short halt and our poll time is too small */
-			else if (vcpu->halt_poll_ns < halt_poll_ns &&
-				block_ns < halt_poll_ns)
-				grow_halt_poll_ns(vcpu);
-		} else {
-			vcpu->halt_poll_ns = 0;
-		}
+		/* we had a short block and our poll time is too small */
+		else if (block_ns > vcpu->halt_poll_ns)
+			grow_halt_poll_ns(vcpu);
 	}
 
 	trace_kvm_vcpu_wakeup(block_ns, waited, vcpu_valid_wakeup(vcpu));
-- 
1.8.3.1

