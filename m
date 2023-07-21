Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF2E75C64F
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 14:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbjGUMBG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 08:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbjGUMBE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 08:01:04 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7472130E2;
        Fri, 21 Jul 2023 05:00:56 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36LBap3n015800;
        Fri, 21 Jul 2023 12:00:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=bBL1eULngDUlwrfV7XCTYdZd8TYLa2Yv1SvONurZWvU=;
 b=EqHpFt/XVPymY+Fiv9Zf8W4n1Ziho4kQQqLNF7OOBdFMx6W2JwvfXb0Tb99N7AXQkYHs
 mN2qtk8+svnBCCtRbc3PjNN0Q8CtDFHzWnUU9LuY3OORzGe3z/pOE1mHVEfu1UcnHDm2
 ZPAuPfOkCOJ4L1i9gi0VBQGswcJHvAp3f1wWvsBqdxEMv/OUQUbybNrAerfJYBUnQf0k
 k5b3NCseBxoop+NDZO3U4SMTxySAWw435Aqbj+RZ145oos7xqnpjehRdxujMW8iRYYlT
 EWYjpbrOEnWQR5vRzn9rsMHzKzA6NTIkIjI7fvGR+7uAw6Kf4fNpnnHKNL756zJMrrzg eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ry9q8qfuq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jul 2023 12:00:55 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36LBb0tF017270;
        Fri, 21 Jul 2023 12:00:55 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ry9q8qfu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jul 2023 12:00:55 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36LAsSuR016914;
        Fri, 21 Jul 2023 12:00:54 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3rv5ss77be-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jul 2023 12:00:54 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36LC0pOM17891986
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 12:00:51 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CAFA2004D;
        Fri, 21 Jul 2023 12:00:51 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1FB9A20040;
        Fri, 21 Jul 2023 12:00:51 +0000 (GMT)
Received: from heavy.boeblingen.de.ibm.com (unknown [9.155.200.166])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 21 Jul 2023 12:00:51 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Freimann <jfreimann@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v2 1/6] KVM: s390: interrupt: Fix single-stepping into interrupt handlers
Date:   Fri, 21 Jul 2023 13:57:54 +0200
Message-ID: <20230721120046.2262291-2-iii@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721120046.2262291-1-iii@linux.ibm.com>
References: <20230721120046.2262291-1-iii@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nJZ7zXzOTKNlmGT-rQAZcF_PZCtoDA0_
X-Proofpoint-GUID: jOedvZKsaczI6N4IflAWL_-I3qCnVAbo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-21_07,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 clxscore=1011 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307210104
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After single-stepping an instruction that generates an interrupt, GDB
ends up on the second instruction of the respective interrupt handler.

The reason is that vcpu_pre_run() manually delivers the interrupt, and
then __vcpu_run() runs the first handler instruction using the
CPUSTAT_P flag. This causes a KVM_SINGLESTEP exit on the second handler
instruction.

Fix by delaying the KVM_SINGLESTEP exit until after the manual
interrupt delivery.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 arch/s390/kvm/interrupt.c | 10 ++++++++++
 arch/s390/kvm/kvm-s390.c  |  4 ++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 9bd0a873f3b1..2cebe4227b8e 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -1392,6 +1392,7 @@ int __must_check kvm_s390_deliver_pending_interrupts(struct kvm_vcpu *vcpu)
 {
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
 	int rc = 0;
+	bool delivered = false;
 	unsigned long irq_type;
 	unsigned long irqs;
 
@@ -1465,6 +1466,15 @@ int __must_check kvm_s390_deliver_pending_interrupts(struct kvm_vcpu *vcpu)
 			WARN_ONCE(1, "Unknown pending irq type %ld", irq_type);
 			clear_bit(irq_type, &li->pending_irqs);
 		}
+		delivered |= !rc;
+	}
+
+	if (delivered && guestdbg_sstep_enabled(vcpu)) {
+		struct kvm_debug_exit_arch *debug_exit = &vcpu->run->debug.arch;
+
+		debug_exit->addr = vcpu->arch.sie_block->gpsw.addr;
+		debug_exit->type = KVM_SINGLESTEP;
+		vcpu->guest_debug |= KVM_GUESTDBG_EXIT_PENDING;
 	}
 
 	set_intercept_indicators(vcpu);
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d1e768bcfe1d..0c6333b108ba 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4611,7 +4611,7 @@ static int vcpu_pre_run(struct kvm_vcpu *vcpu)
 
 	if (!kvm_is_ucontrol(vcpu->kvm)) {
 		rc = kvm_s390_deliver_pending_interrupts(vcpu);
-		if (rc)
+		if (rc || guestdbg_exit_pending(vcpu))
 			return rc;
 	}
 
@@ -4738,7 +4738,7 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 
 	do {
 		rc = vcpu_pre_run(vcpu);
-		if (rc)
+		if (rc || guestdbg_exit_pending(vcpu))
 			break;
 
 		kvm_vcpu_srcu_read_unlock(vcpu);
-- 
2.41.0

