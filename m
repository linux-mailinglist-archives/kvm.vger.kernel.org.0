Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B077F157C
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 12:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729847AbfKFL4E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 06:56:04 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:40140 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbfKFL4D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 06:56:03 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6BsJOu050056;
        Wed, 6 Nov 2019 11:55:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=ITh4bqD9xE5YeUegJCsH0m9UXI6eEn2CS5ZImoYu/nk=;
 b=eKPgNEYLBCRGh1Pax3oS6cIJQHd5BE6cCoIie94e2RzspGhfduHmCKVrIGdWJ1CnVZ7O
 2vnFPgOVNuJXhZ1hwynUHMZbzzdbuNrTTBuZHwK1xMzJB7DyOAsoyVRi79Vl6heh6AD4
 PVDPj25M9Vb23d80Ah9JIJYVc+xu5BEsvh9VPSwwkkZg2VRm85XY/L+dg5fVmoi9Idx9
 loyZVrJcHsP+7LjxMMcfsPv+ZYmJDctwQGUf4XPeO63deomVN/kIVSwjFjjK3J7/XXKj
 3QIW2+oIfSjZuscvP3Wi38JJz6NS5XHp2A/8ZLzs8wo1MdYUzN+iAbnIkjPswuYprsEH 4w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2w11rq5m73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 11:55:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6Btgxv061288;
        Wed, 6 Nov 2019 11:55:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2w3vr25smd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 11:55:51 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA6BtnVQ027585;
        Wed, 6 Nov 2019 11:55:49 GMT
Received: from z2.cn.oracle.com (/10.182.71.218)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 03:55:48 -0800
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        rafael.j.wysocki@intel.com, joao.m.martins@oracle.com,
        mtosatti@redhat.com, kvm@vger.kernel.org, linux-pm@vger.kernel.org,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>
Subject: [PATCH RESEND v2 4/4] KVM: ensure vCPU halt_poll_us in right scope
Date:   Wed,  6 Nov 2019 19:55:02 +0800
Message-Id: <1573041302-4904-5-git-send-email-zhenzhong.duan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573041302-4904-1-git-send-email-zhenzhong.duan@oracle.com>
References: <1573041302-4904-1-git-send-email-zhenzhong.duan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=990
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911060119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911060119
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

