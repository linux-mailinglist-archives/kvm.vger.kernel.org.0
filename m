Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626ED27A873
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 09:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgI1HVL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 03:21:11 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42312 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbgI1HVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Sep 2020 03:21:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08S7JfdW104550;
        Mon, 28 Sep 2020 07:21:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=+wgZovlYdZGn7Y2x+uGG+6wH9IBQmVM/PG2WslPvhZE=;
 b=twM1JNYpzJU+9cgEXQ4K49B1Pqjxb4/6olS0WhJNfkvfwUh5GA/p1phNTZPr/gSiSSrk
 SVlnfVlpoeXyUy83bKqb0mzDV5teunaOemri7zL8E1PIPGp9lZdEnAyT18ps0ofrPwmO
 ggv0X9oHFbSalUSRCJHN+Ju84kni9G6Hsb+IM81FmNr+BRsPQmWrZtw0p7IxgtDPoKLM
 MjzX/Ps79v+k3rl1GMlD1jg7RBV3MQYsWvZVU6N2moaJK9eoGzY1rjgT1vkEARB08XwQ
 Oku5tlVaoW7PbH4yWEDkqnVdnNOHddqeM8up6CSnYgRlkpx6BZ/kYyyPPSJFHC3hRl4X cg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33swkkkdpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 07:21:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08S7KMK0187049;
        Mon, 28 Sep 2020 07:21:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33tfhvwm00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 07:21:08 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08S7L7E4030768;
        Mon, 28 Sep 2020 07:21:07 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 00:21:07 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 4/4 v2] KVM: nSVM: nested_vmcb_checks() needs to check all bits of EFER
Date:   Mon, 28 Sep 2020 07:20:43 +0000
Message-Id: <20200928072043.9359-5-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200928072043.9359-1-krish.sadhukhan@oracle.com>
References: <20200928072043.9359-1-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=940 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=1 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280061
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=1 mlxlogscore=946 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280061
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current implementation of nested_vmcb_checks() checks only the SVME bit in
EFER. We need to check all other bits of EFER including the reserved bits.
This patch enhances nested_vmcb_checks() by calling kvm_valid_efer() which
checks all bits of EFER.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/nested.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 55c785587bd4..cf4048401737 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -244,7 +244,8 @@ static bool nested_vmcb_check_cr3_cr4(struct vcpu_svm *svm,
 
 static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb)
 {
-	if ((vmcb->save.efer & EFER_SVME) == 0)
+	if (((vmcb->save.efer & EFER_SVME) == 0) ||
+	     !kvm_valid_efer(&(svm->vcpu), vmcb->save.efer))
 		return false;
 
 	if (((vmcb->save.cr0 & X86_CR0_CD) == 0) &&
-- 
2.18.4

