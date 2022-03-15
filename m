Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24CC54D9D12
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 15:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349034AbiCOONI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 10:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349037AbiCOOM7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 10:12:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E3954BC2;
        Tue, 15 Mar 2022 07:11:45 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22FCiX6C010791;
        Tue, 15 Mar 2022 14:11:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=FZ9Ihi1kXsB14+EdFBOQEH0lWlzEWGpkJH0MBanFw1g=;
 b=WgiVtNHXsbYhqlafoH9PSXEL6eyHaT94d5cXI10Tf7EEwrjks5/JuuHa1KEsZ1q/eqOw
 XVXBWtumRZ9G8p+rVeNo1ijCZewHUBWxSGFMmGZajBPqeMQAW/TqXD8MnKhNqKAQmgpk
 eCgciwQ2e1chvqf4B6Uv6JX/A2VhxTc6iRFwcDBdGhymoxYgos9CK+YsnYKOq/FVwRVx
 jvEo9q8IyqjzrMRj851HdEdBCIuaE9KsYXYoJfFF+O56X3M8GMuZx1G//jSaocA7eJ2X
 qSicGYuulzEmlyl3CEiJLzhvzd6P5993BnfnuG3Df0qfCW3gFkvpABJn+sZXyPlfmU3l /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3etu2st0t0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:11:44 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22FDmAtr015297;
        Tue, 15 Mar 2022 14:11:44 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3etu2st0rp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:11:44 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22FE9EEU008152;
        Tue, 15 Mar 2022 14:11:42 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3erk58nsnj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:11:42 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22FEBdFI51511710
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 14:11:39 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3DF54203F;
        Tue, 15 Mar 2022 14:11:38 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC0CA42042;
        Tue, 15 Mar 2022 14:11:38 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 15 Mar 2022 14:11:38 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 87F88E11F3; Tue, 15 Mar 2022 15:11:38 +0100 (CET)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL 2/7] KVM: s390x: fix SCK locking
Date:   Tue, 15 Mar 2022 15:11:32 +0100
Message-Id: <20220315141137.357923-3-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220315141137.357923-1-borntraeger@linux.ibm.com>
References: <20220315141137.357923-1-borntraeger@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rLBdIFX30dDUk0fFm77O9k_JEwqHi_uA
X-Proofpoint-ORIG-GUID: lOxc0aI0ZWBBjVdeaiQexxN5RrNbkJVo
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_03,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 bulkscore=0 phishscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150092
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

When handling the SCK instruction, the kvm lock is taken, even though
the vcpu lock is already being held. The normal locking order is kvm
lock first and then vcpu lock. This is can (and in some circumstances
does) lead to deadlocks.

The function kvm_s390_set_tod_clock is called both by the SCK handler
and by some IOCTLs to set the clock. The IOCTLs will not hold the vcpu
lock, so they can safely take the kvm lock. The SCK handler holds the
vcpu lock, but will also somehow need to acquire the kvm lock without
relinquishing the vcpu lock.

The solution is to factor out the code to set the clock, and provide
two wrappers. One is called like the original function and does the
locking, the other is called kvm_s390_try_set_tod_clock and uses
trylock to try to acquire the kvm lock. This new wrapper is then used
in the SCK handler. If locking fails, -EAGAIN is returned, which is
eventually propagated to userspace, thus also freeing the vcpu lock and
allowing for forward progress.

This is not the most efficient or elegant way to solve this issue, but
the SCK instruction is deprecated and its performance is not critical.

The goal of this patch is just to provide a simple but correct way to
fix the bug.

Fixes: 6a3f95a6b04c ("KVM: s390: Intercept SCK instruction")
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Link: https://lore.kernel.org/r/20220301143340.111129-1-imbrenda@linux.ibm.com
Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 19 ++++++++++++++++---
 arch/s390/kvm/kvm-s390.h |  4 ++--
 arch/s390/kvm/priv.c     | 15 ++++++++++++++-
 3 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index b5ea95cf8686..b53ff693b66e 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3961,14 +3961,12 @@ static int kvm_s390_handle_requests(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-void kvm_s390_set_tod_clock(struct kvm *kvm,
-			    const struct kvm_s390_vm_tod_clock *gtod)
+static void __kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)
 {
 	struct kvm_vcpu *vcpu;
 	union tod_clock clk;
 	unsigned long i;
 
-	mutex_lock(&kvm->lock);
 	preempt_disable();
 
 	store_tod_clock_ext(&clk);
@@ -3989,9 +3987,24 @@ void kvm_s390_set_tod_clock(struct kvm *kvm,
 
 	kvm_s390_vcpu_unblock_all(kvm);
 	preempt_enable();
+}
+
+void kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)
+{
+	mutex_lock(&kvm->lock);
+	__kvm_s390_set_tod_clock(kvm, gtod);
 	mutex_unlock(&kvm->lock);
 }
 
+int kvm_s390_try_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)
+{
+	if (!mutex_trylock(&kvm->lock))
+		return 0;
+	__kvm_s390_set_tod_clock(kvm, gtod);
+	mutex_unlock(&kvm->lock);
+	return 1;
+}
+
 /**
  * kvm_arch_fault_in_page - fault-in guest page if necessary
  * @vcpu: The corresponding virtual cpu
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 4ba8fc30d87a..798955b62fa3 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -358,8 +358,8 @@ int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu);
 int kvm_s390_handle_sigp_pei(struct kvm_vcpu *vcpu);
 
 /* implemented in kvm-s390.c */
-void kvm_s390_set_tod_clock(struct kvm *kvm,
-			    const struct kvm_s390_vm_tod_clock *gtod);
+void kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod);
+int kvm_s390_try_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod);
 long kvm_arch_fault_in_page(struct kvm_vcpu *vcpu, gpa_t gpa, int writable);
 int kvm_s390_store_status_unloaded(struct kvm_vcpu *vcpu, unsigned long addr);
 int kvm_s390_vcpu_store_status(struct kvm_vcpu *vcpu, unsigned long addr);
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 30b24c42ef99..5beb7a4a11b3 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -102,7 +102,20 @@ static int handle_set_clock(struct kvm_vcpu *vcpu)
 		return kvm_s390_inject_prog_cond(vcpu, rc);
 
 	VCPU_EVENT(vcpu, 3, "SCK: setting guest TOD to 0x%llx", gtod.tod);
-	kvm_s390_set_tod_clock(vcpu->kvm, &gtod);
+	/*
+	 * To set the TOD clock the kvm lock must be taken, but the vcpu lock
+	 * is already held in handle_set_clock. The usual lock order is the
+	 * opposite.  As SCK is deprecated and should not be used in several
+	 * cases, for example when the multiple epoch facility or TOD clock
+	 * steering facility is installed (see Principles of Operation),  a
+	 * slow path can be used.  If the lock can not be taken via try_lock,
+	 * the instruction will be retried via -EAGAIN at a later point in
+	 * time.
+	 */
+	if (!kvm_s390_try_set_tod_clock(vcpu->kvm, &gtod)) {
+		kvm_s390_retry_instr(vcpu);
+		return -EAGAIN;
+	}
 
 	kvm_s390_set_psw_cc(vcpu, 0);
 	return 0;
-- 
2.35.1

