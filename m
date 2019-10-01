Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05218C2B71
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 02:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbfJAAyx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 20:54:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46480 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbfJAAyx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 20:54:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x910sPFZ044141;
        Tue, 1 Oct 2019 00:54:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=ONs2SYLamQotGg6e7nWLECdwnmymLC6XzGH89lGa0q4=;
 b=MlfXtjzG5jwNI2YrVFFxytoIBParj18rUsOewqPvr0o/TAn4cYgi5dJdhcL4y7Bl1hXT
 ZS++1WWWkviahaAo5GTlPjXe5Mi3+Cy0Sx/i26kfl2EnTmZLAjdrBC+O6BI7RRZSSpFC
 xdVlX/f4GYPVj4TIWevdbUG+dzY+9jpo5fun+Th1JIh0VAOyWIVspdTD3XdhcOK90uf1
 W5Q/dNHxQwsHTFw5IhAyWd3N0MzVuf6YjkoivhEKyS0PYQMEv/ubV0KctVq6/Egddyq3
 4vgyua24QCwxYbcyYkARqALBZxq6hhOElAeCFZdU+imzOxVbpF/mHUbKKB05fqJFUzvJ OQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2v9xxujkq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 00:54:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x910rJXT040250;
        Tue, 1 Oct 2019 00:54:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vbnqbr3rb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 00:54:24 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x910sN8t002278;
        Tue, 1 Oct 2019 00:54:23 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 17:54:23 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Liran Alon <liran.alon@oracle.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [PATCH] KVM: VMX: Refactor to not compare set PI control bits directly to 1
Date:   Tue,  1 Oct 2019 03:54:08 +0300
Message-Id: <20191001005408.129099-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=765
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=849 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010008
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a pure code refactoring.
No semantic change is expected.

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 arch/x86/kvm/vmx/vmx.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e31317fc8c95..92eb4910fe9f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5302,6 +5302,11 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
 	}
 }
 
+static bool vmx_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
+{
+	return pi_test_on(vcpu_to_pi_desc(vcpu));
+}
+
 /*
  * Handler for POSTED_INTERRUPT_WAKEUP_VECTOR.
  */
@@ -5313,9 +5318,7 @@ static void wakeup_handler(void)
 	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
 	list_for_each_entry(vcpu, &per_cpu(blocked_vcpu_on_cpu, cpu),
 			blocked_vcpu_list) {
-		struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
-
-		if (pi_test_on(pi_desc) == 1)
+		if (vmx_dy_apicv_has_pending_interrupt(vcpu))
 			kvm_vcpu_kick(vcpu);
 	}
 	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
@@ -6168,11 +6171,6 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
 	return max_irr;
 }
 
-static bool vmx_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
-{
-	return pi_test_on(vcpu_to_pi_desc(vcpu));
-}
-
 static void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
 {
 	if (!kvm_vcpu_apicv_active(vcpu))
@@ -7336,7 +7334,7 @@ static int pi_pre_block(struct kvm_vcpu *vcpu)
 	do {
 		old.control = new.control = pi_desc->control;
 
-		WARN((pi_desc->sn == 1),
+		WARN(pi_desc->sn,
 		     "Warning: SN field of posted-interrupts "
 		     "is set before blocking\n");
 
@@ -7361,7 +7359,7 @@ static int pi_pre_block(struct kvm_vcpu *vcpu)
 			   new.control) != old.control);
 
 	/* We should not block the vCPU if an interrupt is posted for it.  */
-	if (pi_test_on(pi_desc) == 1)
+	if (pi_test_on(pi_desc))
 		__pi_post_block(vcpu);
 
 	local_irq_enable();
-- 
2.20.1

