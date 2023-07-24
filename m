Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 511B575F033
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 11:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbjGXJuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 05:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbjGXJtp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 05:49:45 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCFE30D0;
        Mon, 24 Jul 2023 02:47:52 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36O9gp1B016386;
        Mon, 24 Jul 2023 09:47:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=deG51zCzcUT5GfDMqafHjpZjegCMRnUztn3S9uVudTo=;
 b=qr14BjVsDTfvf2oAOG8kst/BFqj8fQCE0LLycElcXConYkp4RBsBeiqigALsYyB6x8KP
 2mUETEi5ViqDG0+5S3b+Xrrbm3SElSLB5Yfp6wZQdtrI+yJl6fweYujh9gGC4zSRJIEz
 brnyca+v8ZySgB+Af108nv0JssZwvU+S9hjW4xAgze08Aa+e5Yk08tdsN3Zi1h88JgZf
 gKjx2PhwRs82LEqKdI0OL3TikqNvrHS6Z4VQcVmS24Zv3qf0GsU6CUo+VAVcC0LBwzzw
 jSkA7/iUn/XFLgv6cfiX8jF0QCL9TSMOjrJm0JJu6OTNK078Ccq2UbSIRmPfn22DAojb +A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s1pwg83ub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jul 2023 09:47:35 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36O9hqug020132;
        Mon, 24 Jul 2023 09:47:35 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s1pwg83ty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jul 2023 09:47:34 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36O8eCou002068;
        Mon, 24 Jul 2023 09:47:33 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3s0temj1f7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jul 2023 09:47:33 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36O9lUZc44695868
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 09:47:30 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 855E320043;
        Mon, 24 Jul 2023 09:47:30 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC2C120049;
        Mon, 24 Jul 2023 09:47:29 +0000 (GMT)
Received: from heavy.boeblingen.de.ibm.com (unknown [9.171.11.212])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 24 Jul 2023 09:47:29 +0000 (GMT)
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
Subject: [PATCH v3 3/6] KVM: s390: interrupt: Fix single-stepping kernel-emulated instructions
Date:   Mon, 24 Jul 2023 11:44:09 +0200
Message-ID: <20230724094716.91510-4-iii@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230724094716.91510-1-iii@linux.ibm.com>
References: <20230724094716.91510-1-iii@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xHUbj1-NCKZ2Yf-Luh7L78MJGP8GYT9I
X-Proofpoint-GUID: Mj87OfbTJ3OT6uoUXN3pBytyuTqTHq-d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_07,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=946 adultscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 impostorscore=0 mlxscore=0 phishscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307240084
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Single-stepping a kernel-emulated instruction that generates an
interrupt causes GDB to land on the instruction following it instead of
the respective interrupt handler.

The reason is that kvm_handle_sie_intercept(), after injecting the
interrupt, also processes the PER event and arranges a KVM_SINGLESTEP
exit. The interrupt is not yet delivered, however, so the userspace
sees the next instruction.

Fix by avoiding the KVM_SINGLESTEP exit when there is a pending
interrupt. The next __vcpu_run() loop iteration will arrange a
KVM_SINGLESTEP exit after delivering the interrupt.

Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 arch/s390/kvm/intercept.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 7cdd927541b0..d2f7940c5d03 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -583,6 +583,19 @@ static int handle_pv_notification(struct kvm_vcpu *vcpu)
 	return handle_instruction(vcpu);
 }
 
+static bool should_handle_per_ifetch(const struct kvm_vcpu *vcpu, int rc)
+{
+	/* Process PER, also if the instruction is processed in user space. */
+	if (!(vcpu->arch.sie_block->icptstatus & 0x02))
+		return false;
+	if (rc != 0 && rc != -EOPNOTSUPP)
+		return false;
+	if (guestdbg_sstep_enabled(vcpu) && vcpu->arch.local_int.pending_irqs)
+		/* __vcpu_run() will exit after delivering the interrupt. */
+		return false;
+	return true;
+}
+
 int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
 {
 	int rc, per_rc = 0;
@@ -645,9 +658,7 @@ int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
 		return -EOPNOTSUPP;
 	}
 
-	/* process PER, also if the instruction is processed in user space */
-	if (vcpu->arch.sie_block->icptstatus & 0x02 &&
-	    (!rc || rc == -EOPNOTSUPP))
+	if (should_handle_per_ifetch(vcpu, rc))
 		per_rc = kvm_s390_handle_per_ifetch_icpt(vcpu);
 	return per_rc ? per_rc : rc;
 }
-- 
2.41.0

