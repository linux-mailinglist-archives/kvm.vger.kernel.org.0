Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379BA22D443
	for <lists+kvm@lfdr.de>; Sat, 25 Jul 2020 05:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbgGYD06 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 23:26:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34458 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726904AbgGYD06 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 23:26:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P3EOxf089366;
        Sat, 25 Jul 2020 03:26:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=1uVks55KihUgSYCMq0k3DOhEyTRXQpuU/TvMQ/0yXqg=;
 b=PPRQymo8w5KkBYDjCZ/MB59NlZKipH8astj3Phi6YYV93mRr4+91aoYzZR9v9lw/QKQt
 F6QLzUcxgNtFLyh15Bh7ZnZBoV/m1zHG1+jr+FQ316ERBAhRuoLpDmk/AvBTV2Yug3+W
 tEDkBiTAJphBALI1buoRU4FhM+JCxjHvnBU90f6+fX1sVtNqDYRQ73ZyUc2wc0OGc++f
 8mIwJ6+orkb3mTKj8sTell3Z9WlJlnObwt+AsCeg+SZ2Qkt92ZrkCsTzU3Enc/jTrNQE
 qbRUlqyG0CH99P5EZ46nkJQUARPOkS31TL9bhGeSklRuAc8tQB/0swqPIju8iaAsuz+N 0w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32d6kt65su-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 25 Jul 2020 03:26:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P3CLU1195972;
        Sat, 25 Jul 2020 03:26:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 32gc2h2j4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Jul 2020 03:26:52 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06P3Qp4c014036;
        Sat, 25 Jul 2020 03:26:51 GMT
Received: from nsvm-sadhukhan.osdevelopmeniad.oraclevcn.com (/100.100.231.196)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 25 Jul 2020 03:26:51 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     jmattson@google.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com
Subject: [PATCH 3/5 v2] KVM: nSVM: Fill in conforming svm_nested_ops via macro
Date:   Sat, 25 Jul 2020 03:26:36 +0000
Message-Id: <1595647598-53208-4-git-send-email-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1595647598-53208-1-git-send-email-krish.sadhukhan@oracle.com>
References: <1595647598-53208-1-git-send-email-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0 bulkscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 bulkscore=0 mlxscore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 spamscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250024
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The names of the nested_svm_ops functions do not have a corresponding
'nested_svm_' prefix. Generate the names using a macro so that the names are
conformant. Fixing the naming will help in better readability and
maintenance of the code.

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/nested.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 3be6256..7cb834a 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -718,7 +718,7 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
 		/*
 		 * Host-intercepted exceptions have been checked already in
 		 * nested_svm_exit_special.  There is nothing to do here,
-		 * the vmexit is injected by svm_check_nested_events.
+		 * the vmexit is injected by nested_svm_check_events().
 		 */
 		vmexit = NESTED_EXIT_DONE;
 		break;
@@ -850,7 +850,7 @@ static void nested_svm_init(struct vcpu_svm *svm)
 }
 
 
-static int svm_check_nested_events(struct kvm_vcpu *vcpu)
+static int nested_svm_check_events(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	bool block_nested_events =
@@ -933,7 +933,7 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
 	return NESTED_EXIT_CONTINUE;
 }
 
-static int svm_get_nested_state(struct kvm_vcpu *vcpu,
+static int nested_svm_get_state(struct kvm_vcpu *vcpu,
 				struct kvm_nested_state __user *user_kvm_nested_state,
 				u32 user_data_size)
 {
@@ -990,7 +990,7 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
 	return kvm_state.size;
 }
 
-static int svm_set_nested_state(struct kvm_vcpu *vcpu,
+static int nested_svm_set_state(struct kvm_vcpu *vcpu,
 				struct kvm_nested_state __user *user_kvm_nested_state,
 				struct kvm_nested_state *kvm_state)
 {
@@ -1075,8 +1075,10 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+#define KVM_X86_NESTED_OP(name) .name = nested_svm_##name
+
 struct kvm_x86_nested_ops svm_nested_ops = {
-	.check_events = svm_check_nested_events,
-	.get_state = svm_get_nested_state,
-	.set_state = svm_set_nested_state,
+	KVM_X86_NESTED_OP(check_events),
+	KVM_X86_NESTED_OP(get_state),
+	KVM_X86_NESTED_OP(set_state),
 };
-- 
1.8.3.1

