Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84270E5850
	for <lists+kvm@lfdr.de>; Sat, 26 Oct 2019 05:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbfJZD1B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 23:27:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60256 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbfJZD1A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 23:27:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9Q3Px3J037724;
        Sat, 26 Oct 2019 03:26:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=/mQmjb7wfSmaJZfljuRPQm0BzQAMo1phyWBvnl2e/u8=;
 b=FxwxopXoZNe4NZN3RE0JGJZWLe+/euuOfrtYMr6TcpdH5+eZcmemWv5hM89XTpufL9Gg
 XwRwg6PCGbqfjGBksooOYhApAMNy2iNFX87iue7Ma/r0CO8BnbkrBjL6oLI15RDwLFJ8
 PS99Q2wr6meUs9dTwFNAy+M/Aw7WygwJyeHzey+ZSCO4ED584nmYFqWyOFBN1L5HbX5R
 9JQtIKDFvHEjqEsMDDJKeLPaElBELFnrSYiOvx/lVvjlBMjdZKLxHi6yBGT1/TOOmgjQ
 N+fHV4Z5PLJb2jE9EsAChkpNsd2eejy/faHfHRJu2+5Qwc/aWG46mgmXoMsr/FPmscQu TA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2vve3pr115-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Oct 2019 03:26:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9Q3O9NN018302;
        Sat, 26 Oct 2019 03:24:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2vvdymgd47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Oct 2019 03:24:43 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9Q3OhMd022224;
        Sat, 26 Oct 2019 03:24:43 GMT
Received: from z2.cn.oracle.com (/10.182.71.218)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 25 Oct 2019 20:24:43 -0700
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, mtosatti@redhat.com,
        joao.m.martins@oracle.com, rafael.j.wysocki@intel.com,
        rkrcmar@redhat.com, pbonzini@redhat.com,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>
Subject: [PATCH 1/5] KVM: simplify branch check in host poll code
Date:   Sat, 26 Oct 2019 11:23:55 +0800
Message-Id: <1572060239-17401-2-git-send-email-zhenzhong.duan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1572060239-17401-1-git-send-email-zhenzhong.duan@oracle.com>
References: <1572060239-17401-1-git-send-email-zhenzhong.duan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9421 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910260033
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9421 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910260034
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove redundant check.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
---
 virt/kvm/kvm_main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 67ef3f2..2ca2979 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2366,13 +2366,12 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		} else if (halt_poll_ns) {
 			if (block_ns <= vcpu->halt_poll_ns)
 				;
-			/* we had a long block, shrink polling */
-			else if (vcpu->halt_poll_ns && block_ns > halt_poll_ns)
-				shrink_halt_poll_ns(vcpu);
 			/* we had a short halt and our poll time is too small */
-			else if (vcpu->halt_poll_ns < halt_poll_ns &&
-				block_ns < halt_poll_ns)
+			else if (block_ns < halt_poll_ns)
 				grow_halt_poll_ns(vcpu);
+			/* we had a long block, shrink polling */
+			else if (vcpu->halt_poll_ns)
+				shrink_halt_poll_ns(vcpu);
 		} else {
 			vcpu->halt_poll_ns = 0;
 		}
-- 
1.8.3.1

