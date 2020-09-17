Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8FEF26E75E
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 23:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgIQVZQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 17:25:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33404 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgIQVZP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 17:25:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HLEuaa012382;
        Thu, 17 Sep 2020 21:22:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=3eJ0X/nkHtps0s17VeY8/THZYuT416x78/To7uTXJRs=;
 b=dWc+A2UeJjT8CBTBhcUyYOpcm9ctECAJCMHTGbdWW0SecjEghfjSELijW/7fDQy79Lj5
 jFfVxGD/DTb9GjZcVCcxh03lQ+avFocdH8VitgIHYiItwFCjT/VUZCUhHnQL6+cQ24A+
 4KLnRfC+F8zvwgYoFIop+wlndwQG6YIjeS95dU63W9qp9LZkd05tBGGh05uILRgmszT4
 KR8erff3zt4OEyxAR/TAK0DgY4h+airDe2lN35PyUDCdryrGeh8sY+EcQCgD5I9cmncT
 InYKCfgfHgCmyhhYc3XtEcyYXySnAsNYxJWIZzm5ImZHh5+hqk3SchWHpy6BhQ9WqLTI Pg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33gp9mku7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 21:22:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HL9uEE148201;
        Thu, 17 Sep 2020 21:22:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33hm35k152-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 21:22:32 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08HLMSwF026929;
        Thu, 17 Sep 2020 21:22:28 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 21:22:28 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, joro@8bytes.org,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: [PATCH 3/3 v4] KVM: SVM: Don't flush cache if hardware enforces cache coherency across encryption domains
Date:   Thu, 17 Sep 2020 21:20:38 +0000
Message-Id: <20200917212038.5090-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200917212038.5090-1-krish.sadhukhan@oracle.com>
References: <20200917212038.5090-1-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=808
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=823
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=1 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170158
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In some hardware implementations, coherency between the encrypted and
unencrypted mappings of the same physical page in a VM is enforced. In such a
system, it is not required for software to flush the VM's page from all CPU
caches in the system prior to changing the value of the C-bit for the page.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/sev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7bf7bf734979..3c9a45efdd4d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -384,7 +384,8 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
 	uint8_t *page_virtual;
 	unsigned long i;
 
-	if (npages == 0 || pages == NULL)
+	if (this_cpu_has(X86_FEATURE_SME_COHERENT) || npages == 0 ||
+	    pages == NULL)
 		return;
 
 	for (i = 0; i < npages; i++) {
-- 
2.18.4

