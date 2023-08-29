Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 803B778C3E2
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 14:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234067AbjH2MKK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 08:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233717AbjH2MJm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 08:09:42 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FCBEBB;
        Tue, 29 Aug 2023 05:09:40 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37TC4OYI026084;
        Tue, 29 Aug 2023 12:09:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=iY1aRpRnSnKs3mQyXzIySTUdxyjB8EKqvU537uxoWHE=;
 b=FfcMNp3yu+8a0HjTlH1oVsBI2WHPT/7oLTR8Ut0qTeZx1CUs9OPpaAyMADG6yb5rgnn1
 An9ONDqFO4ns/A/O8iroKDDIG0hXblLRzpxa/lgwgAyJiP+qcQCTWVD9+MG4iCajTsO2
 B9FIk5glVwAlXOqrL04026mgcKS5Ikeyy9FaY0eU2FpXfI7BkQj7T7YHP0tlnYNpvGkc
 PK7wMnxhMF8YEtRMtrhczkHR0e6MOPMiKnFPZXl8i1o7zqswBimBe4MA/25H0bRww035
 Byl3ShBQ/lorY8r4/3ylQsEGfo8dV8Uu9VCuN5Jds6aOaAK7+37cHrurgctuMp7XXtdD 8Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ssf7tj8px-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Aug 2023 12:09:39 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37TBj3nh027077;
        Tue, 29 Aug 2023 12:09:33 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ssf7tj8e6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Aug 2023 12:09:33 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37T9tTJs014349;
        Tue, 29 Aug 2023 12:09:23 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sqvqn36au-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Aug 2023 12:09:23 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37TC9KQA45220310
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Aug 2023 12:09:20 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D18D2004E;
        Tue, 29 Aug 2023 12:09:20 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A11AE2004B;
        Tue, 29 Aug 2023 12:09:19 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.19.123])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 29 Aug 2023 12:09:19 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, mihajlov@linux.ibm.com, seiden@linux.ibm.com,
        akrowiak@linux.ibm.com, seanjc@google.com
Subject: [GIT PULL v2 02/10] KVM: s390: interrupt: Fix single-stepping into program interrupt handlers
Date:   Tue, 29 Aug 2023 14:03:57 +0200
Message-ID: <20230829120843.66637-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230829120843.66637-1-frankja@linux.ibm.com>
References: <20230829120843.66637-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Ig6tsfKaLmwLukOmC5xT0HiyhYRWiZvY
X-Proofpoint-GUID: 1XzSIaJdzie3VAiZiQonWTFteyiRN8uR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-29_09,2023-08-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=905 impostorscore=0
 bulkscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308290105
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

Currently, after single-stepping an instruction that generates a
specification exception, GDB ends up on the instruction immediately
following it.

The reason is that vcpu_post_run() injects the interrupt and sets
KVM_GUESTDBG_EXIT_PENDING, causing a KVM_SINGLESTEP exit. The
interrupt is not delivered, however, therefore userspace sees the
address of the next instruction.

Fix by letting the __vcpu_run() loop go into the next iteration,
where vcpu_pre_run() delivers the interrupt and sets
KVM_GUESTDBG_EXIT_PENDING.

Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20230725143857.228626-3-iii@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/intercept.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 954d39adf85c..e54496740859 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -228,6 +228,21 @@ static int handle_itdb(struct kvm_vcpu *vcpu)
 
 #define per_event(vcpu) (vcpu->arch.sie_block->iprcc & PGM_PER)
 
+static bool should_handle_per_event(const struct kvm_vcpu *vcpu)
+{
+	if (!guestdbg_enabled(vcpu) || !per_event(vcpu))
+		return false;
+	if (guestdbg_sstep_enabled(vcpu) &&
+	    vcpu->arch.sie_block->iprcc != PGM_PER) {
+		/*
+		 * __vcpu_run() will exit after delivering the concurrently
+		 * indicated condition.
+		 */
+		return false;
+	}
+	return true;
+}
+
 static int handle_prog(struct kvm_vcpu *vcpu)
 {
 	psw_t psw;
@@ -242,7 +257,7 @@ static int handle_prog(struct kvm_vcpu *vcpu)
 	if (kvm_s390_pv_cpu_is_protected(vcpu))
 		return -EOPNOTSUPP;
 
-	if (guestdbg_enabled(vcpu) && per_event(vcpu)) {
+	if (should_handle_per_event(vcpu)) {
 		rc = kvm_s390_handle_per_event(vcpu);
 		if (rc)
 			return rc;
-- 
2.41.0

