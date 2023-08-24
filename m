Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 793CC786F62
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 14:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240344AbjHXMq5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 08:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235870AbjHXMqU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 08:46:20 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2804410FE;
        Thu, 24 Aug 2023 05:46:19 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCglH3028747;
        Thu, 24 Aug 2023 12:46:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=xBtss/olnWfblRMo7cLqlSw6RgnKf1xdTP8gKpey42E=;
 b=YHbaBQZ5z11d8j1c2f1UZLizTg9p6I1mPpZ/ChcOHV5oudIksgYbIJAhKK2QFoueks98
 czlSUFU6stKYoZIJAi7Om6KrOln7W3u1vKdxtjhlydRR8FAo0OYgukA1OObojbykyQvc
 VEftaq7WUXTgZ7ZY916z6tqwJzNB23QMs48L7gIC7RfQS8f6+xt1e65kZKemkaeCDqY3
 G5/jfqvGPLjHjmXxOYbRB6yCafCb5ZslGewWu6m9oHLNqJR7s0TDaGV1rozYkcMzS4cm
 nFteboZkITOr1n1J1DYITxISMWZqJzrF/ZpK8/lN3qlL5ffRSUa4GILR3KqNjoQfHqN5 zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7eu0h2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:17 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37OCgsri029127;
        Thu, 24 Aug 2023 12:46:14 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7eu0gsh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:14 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCFaiT026117;
        Thu, 24 Aug 2023 12:46:11 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3snqgt6c56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:11 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37OCk9bL21824092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Aug 2023 12:46:09 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA35220040;
        Thu, 24 Aug 2023 12:46:08 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41B6D20043;
        Thu, 24 Aug 2023 12:46:08 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.171.27.69])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 24 Aug 2023 12:46:08 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, mihajlov@linux.ibm.com, seiden@linux.ibm.com,
        akrowiak@linux.ibm.com
Subject: [GIT PULL 01/22] KVM: s390: interrupt: Fix single-stepping into interrupt handlers
Date:   Thu, 24 Aug 2023 14:43:10 +0200
Message-ID: <20230824124522.75408-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230824124522.75408-1-frankja@linux.ibm.com>
References: <20230824124522.75408-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yx3oiLwt5qfFdGcfikFf2QcriFP7x1i_
X-Proofpoint-GUID: m_2XxhtGPANGiC4Dm0VgcKeSYvpv7CZN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-24_09,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 suspectscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=831 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308240103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

After single-stepping an instruction that generates an interrupt, GDB
ends up on the second instruction of the respective interrupt handler.

The reason is that vcpu_pre_run() manually delivers the interrupt, and
then __vcpu_run() runs the first handler instruction using the
CPUSTAT_P flag. This causes a KVM_SINGLESTEP exit on the second handler
instruction.

Fix by delaying the KVM_SINGLESTEP exit until after the manual
interrupt delivery.

Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Message-ID: <20230725143857.228626-2-iii@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/interrupt.c | 14 ++++++++++++++
 arch/s390/kvm/kvm-s390.c  |  4 ++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 9bd0a873f3b1..85e39f472bb4 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -1392,6 +1392,7 @@ int __must_check kvm_s390_deliver_pending_interrupts(struct kvm_vcpu *vcpu)
 {
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
 	int rc = 0;
+	bool delivered = false;
 	unsigned long irq_type;
 	unsigned long irqs;
 
@@ -1465,6 +1466,19 @@ int __must_check kvm_s390_deliver_pending_interrupts(struct kvm_vcpu *vcpu)
 			WARN_ONCE(1, "Unknown pending irq type %ld", irq_type);
 			clear_bit(irq_type, &li->pending_irqs);
 		}
+		delivered |= !rc;
+	}
+
+	/*
+	 * We delivered at least one interrupt and modified the PC. Force a
+	 * singlestep event now.
+	 */
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

