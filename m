Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD1E78C3EA
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 14:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234694AbjH2MKP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 08:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233841AbjH2MJ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 08:09:57 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5BA98;
        Tue, 29 Aug 2023 05:09:55 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37TC6j2R007897;
        Tue, 29 Aug 2023 12:09:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=nEqsRe6dUAVNR/4wfBiL+Qm/ldsq4/znFVFBo2UdvaM=;
 b=doio/KVpcfY4NFtHpjjlH+wrbeJzwUTb5UAyFEzUn1qW0Q5HWvwtM7qDVWVZeibW59JS
 +aWnNqiB0NOAHEBXjvpiW3cPvJ1+5ZHdg4PWeXus8rPZ/RXVPZ5kgYN2wLDeDPPv95JG
 /tLKUwpA+T+3qg+xCGjmwIajlCFmlvy5MrblEFitTiDeB1yI2s6wrLKNWjiHbhxmE3rL
 dFZOF4zszWouTu2ZopEEoPPHnFOB/SPhiybniPgrX/3dJ1i4yhvpdSEiCMAKJwgNe7II
 X1KXKJAUPcsB+ExF2jMZhe5SL7UaeQfqgmmBPzHatkMx4quIrNQz/Smn1eRws7g7Ax6v +g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sr7vyuk91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Aug 2023 12:09:52 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37TC6x4P009477;
        Tue, 29 Aug 2023 12:09:43 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sr7vyujr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Aug 2023 12:09:37 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37TBwIBH020514;
        Tue, 29 Aug 2023 12:09:23 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sqv3ybcpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Aug 2023 12:09:23 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37TC9Jx417105450
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Aug 2023 12:09:19 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88F0420043;
        Tue, 29 Aug 2023 12:09:19 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE3162004B;
        Tue, 29 Aug 2023 12:09:18 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.19.123])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 29 Aug 2023 12:09:18 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, mihajlov@linux.ibm.com, seiden@linux.ibm.com,
        akrowiak@linux.ibm.com, seanjc@google.com
Subject: [GIT PULL v2 01/10] KVM: s390: interrupt: Fix single-stepping into interrupt handlers
Date:   Tue, 29 Aug 2023 14:03:56 +0200
Message-ID: <20230829120843.66637-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230829120843.66637-1-frankja@linux.ibm.com>
References: <20230829120843.66637-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: d8gP8bFbEyWEl7I_h_BzDL1MoqUrUrL0
X-Proofpoint-GUID: KmOm8HVYb9FsN5n6WWHYzzcYUrLbJeUQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-29_09,2023-08-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 spamscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=836
 priorityscore=1501 suspectscore=0 bulkscore=0 impostorscore=0
 clxscore=1015 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2308100000 definitions=main-2308290105
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
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
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

