Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE5C285213
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 21:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbgJFTHM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 15:07:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57562 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbgJFTHM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 15:07:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 096IxSr8088743;
        Tue, 6 Oct 2020 19:07:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=l0DN7SaI5UEPyyJX46rJ/Q/12TWLBEcXNgvs0DHAGls=;
 b=A9xQQcQeTpwCmn76/yeWH8VyFelz9hCL+QxeoDBoCyqPqn7JTuJTZjWwNB8YZScWh7tA
 2IfAuwa7ttPvQP0MTYeYwk+qqkjrEkL8pzOdI8r8DyIzxBgDpktg5c7wky+IBtTNn6d+
 Ao58037G6+exaqpU6XORTdRAcHyiywIyYWd2NZht/VQkEGsXktozgc4Aw76mQT9u5wAn
 AxwhvamrfVwxbCHcte8r6spZQizO0V/4E0/XATmexmX2Hqn3Oq0OtZs4vGh/1y6td8s+
 ZdPJOtFUCFRlWML9cVjMuaWVEJYpyQg3yR/PJH6IqG1votd2+t8yo2TVbmKnaGDc2O0O zQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33xhxmwuqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 06 Oct 2020 19:07:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 096J0pRP109851;
        Tue, 6 Oct 2020 19:07:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33y36yf1k4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Oct 2020 19:07:05 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 096J74O3016168;
        Tue, 6 Oct 2020 19:07:04 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 12:07:04 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 4/4 v3] KVM: nSVM: nested_vmcb_checks() needs to check all bits of EFER
Date:   Tue,  6 Oct 2020 19:06:54 +0000
Message-Id: <20201006190654.32305-5-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201006190654.32305-1-krish.sadhukhan@oracle.com>
References: <20201006190654.32305-1-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=968 adultscore=0
 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=1 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010060123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=1 phishscore=0
 mlxlogscore=978 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060123
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
index 28a931fa599e..2426f50226d8 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -238,7 +238,8 @@ static bool nested_vmcb_check_cr3_cr4(struct vcpu_svm *svm,
 
 static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb)
 {
-	if ((vmcb->save.efer & EFER_SVME) == 0)
+	if (((vmcb->save.efer & EFER_SVME) == 0) ||
+	     !kvm_valid_efer(&(svm->vcpu), vmcb->save.efer))
 		return false;
 
 	if (((vmcb->save.cr0 & X86_CR0_CD) == 0) &&
-- 
2.18.4

