Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA76C78C3E6
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 14:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234385AbjH2MKN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 08:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233799AbjH2MJt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 08:09:49 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6311AB;
        Tue, 29 Aug 2023 05:09:42 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37TC93Ri006229;
        Tue, 29 Aug 2023 12:09:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dgDh4vgOaxJAmygDmQpyGxmK9tu6ZVpzyPHFYtJ875c=;
 b=CX68fcBj3t3Hqlm9xcA8mzDMIceMYKwh0Yt3jfAvKHIZmKbd6BiHbSEATWS2l9gy+3Xe
 cIRlfl98Vqt7CZB+HEvI52n6r5TpnkB+2nafdw4OpXnrE91qxTdkrMn3FvB+Z0O3V0Y7
 IE38tKGKzc3T5+eDA8d90tfsMKgmGka4FrVE6McvEoY8vgNdVCXqdfQsucFp6tVyVMcc
 9Td1r7Eihzfbf+LcjhqQEZzHZvBGhCCnEq/D6dm3GWf5uRnoZGJfpmrG61kEfDp9RYqH
 asE7Zjf+7Zheyg/V9zS3rXnds+i8OuJqiiJ64CVWq3Sabwux7ALQtL0BSDOTPNUhtZA4 /g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sr8q82crq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Aug 2023 12:09:41 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37TC9ClO007155;
        Tue, 29 Aug 2023 12:09:37 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sr8q82cb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Aug 2023 12:09:37 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37TBPAYp004911;
        Tue, 29 Aug 2023 12:09:24 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3squqskgg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Aug 2023 12:09:24 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37TC9LYC48955746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Aug 2023 12:09:21 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5114720043;
        Tue, 29 Aug 2023 12:09:21 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85D9420040;
        Tue, 29 Aug 2023 12:09:20 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.19.123])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 29 Aug 2023 12:09:20 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, mihajlov@linux.ibm.com, seiden@linux.ibm.com,
        akrowiak@linux.ibm.com, seanjc@google.com
Subject: [GIT PULL v2 03/10] KVM: s390: interrupt: Fix single-stepping kernel-emulated instructions
Date:   Tue, 29 Aug 2023 14:03:58 +0200
Message-ID: <20230829120843.66637-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230829120843.66637-1-frankja@linux.ibm.com>
References: <20230829120843.66637-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nSj9dow4a9ZvaouLnMokPJyC-EPusPkW
X-Proofpoint-ORIG-GUID: j6sy5BW1zpmAPO7CB5FyfFiGY0ioXvFw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-29_09,2023-08-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 mlxlogscore=675 suspectscore=0 bulkscore=0 spamscore=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308290105
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

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
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Message-ID: <20230725143857.228626-4-iii@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/intercept.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index e54496740859..db222c749e5e 100644
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

