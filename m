Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12175742257
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 10:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbjF2IlS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 04:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbjF2Ik2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 04:40:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A108D3AA7;
        Thu, 29 Jun 2023 01:35:09 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35T8GkEc026597;
        Thu, 29 Jun 2023 08:35:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Y/QK5ZDlZiai1RQOWkH9EXksqAPhidIxr7VNx6JZeGA=;
 b=VkmoaDnn02lb98j4cPYdX1TIvBisDySYxvWSSWdNLluKUIRXvRNDxcHpgqSVFwS02ICU
 7In6VKSjpqa9IX6Ezsw604eLr2v1UqLIP+KIFFtdFTj0KL0xtb7jY1QWQ9/AjBnL3JW5
 gI32XrIonP6akJeArscutBgc34wXHo+C+/TUubRHXeQyuCkTEH4JCqJH3wtNX1GU/+FA
 3kLCM3FRwU3ht3O14oGCLZ6houkpgFpN3zgEvjq9gndbGJRwzUkyinHZM6VqkCPZp1yX
 wwjVIiZC+yzygpDJLiYSGrFohtZ/KqKL7vGw40ZpFzqYxEhazHFhqYDB8KcwwZ7bg4p5 aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rh6ab0bsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jun 2023 08:35:09 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35T8H9SV028816;
        Thu, 29 Jun 2023 08:35:08 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rh6ab0bry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jun 2023 08:35:08 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35T1Kwof004994;
        Thu, 29 Jun 2023 08:35:06 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3rdqre38bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jun 2023 08:35:06 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35T8Z1IT14811898
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jun 2023 08:35:01 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB80C20040;
        Thu, 29 Jun 2023 08:35:01 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D56702004B;
        Thu, 29 Jun 2023 08:35:00 +0000 (GMT)
Received: from heavy.boeblingen.de.ibm.com (unknown [9.179.0.51])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 29 Jun 2023 08:35:00 +0000 (GMT)
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
Subject: [PATCH 1/2] KVM: s390: interrupt: Fix stepping into interrupt handlers
Date:   Thu, 29 Jun 2023 10:32:04 +0200
Message-ID: <20230629083452.183274-2-iii@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230629083452.183274-1-iii@linux.ibm.com>
References: <20230629083452.183274-1-iii@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7gtpBV6AK1LPLqycyqoLLB7RKgXgIuqx
X-Proofpoint-ORIG-GUID: C3P-kw2c-x-FDFipZo0X-b1e1TLHrTIo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-28_14,2023-06-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 mlxlogscore=999 malwarescore=0 priorityscore=1501
 mlxscore=0 clxscore=1015 suspectscore=0 impostorscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306290075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, after single-stepping an instruction that causes a program
interrupt, GDB ends up on the second instruction of the program
interrupt handler.

The reason is that vcpu_pre_run() manually delivers the program
interrupt, and then __vcpu_run() runs the first handler instruction
using the CPUSTAT_P flag. This causes a KVM_SINGLESTEP exit on the
second handler instruction.

Instead, KVM needs to do a KVM_SINGLESTEP exit after the manual
interrupt delivery.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 arch/s390/kvm/interrupt.c | 10 ++++++++++
 arch/s390/kvm/kvm-s390.c  |  4 ++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 9250fde1f97d..e633ec4f98d8 100644
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
index 39b36562c043..2d66d83b682c 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4607,7 +4607,7 @@ static int vcpu_pre_run(struct kvm_vcpu *vcpu)
 
 	if (!kvm_is_ucontrol(vcpu->kvm)) {
 		rc = kvm_s390_deliver_pending_interrupts(vcpu);
-		if (rc)
+		if (rc || guestdbg_exit_pending(vcpu))
 			return rc;
 	}
 
@@ -4734,7 +4734,7 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 
 	do {
 		rc = vcpu_pre_run(vcpu);
-		if (rc)
+		if (rc || guestdbg_exit_pending(vcpu))
 			break;
 
 		kvm_vcpu_srcu_read_unlock(vcpu);
-- 
2.41.0

