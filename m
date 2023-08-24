Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9F2786F5E
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 14:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240378AbjHXMq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 08:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238875AbjHXMqX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 08:46:23 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666DCE59;
        Thu, 24 Aug 2023 05:46:21 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCglu4028728;
        Thu, 24 Aug 2023 12:46:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=g0Gfui9tBZX/lhkwdjtDC1PseYCOQms+T0K9t3ZLSCM=;
 b=qN58imEqpMM3A5onkvy3TGt69KmQWRw24W8mdCSWHgQ9fIsIhbfFaFd2OfwuDItH3/Fu
 xq82eAkOvf6nzVx8PJdkIFUcOMUnz0fxh4bjZ/XkN4uRvnFCyaUR9tKixBnOiuWQ4Kqy
 G6dWmRdsXhH1s0Djlc0+/YXpusOw0HHMUxcdbwh9nGC1x6DBwljtg5TCZsr37ahN+C9t
 nS+UvRmMVy1nNoZzfP3+H5XMKVKxf6Ao7oadHJcIqyudKsQ824eD9KFjHC3zjVmsaLBe
 vLHLD6sKVHZLyQ8jUzGqbmKm/aQpzxQnKSxD51q9hRS7SF/PQez5xmxmU8S/cWjS05Ll LQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7eu0h8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:19 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37OChHGu031144;
        Thu, 24 Aug 2023 12:46:17 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7eu0gx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:16 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCFaiV026117;
        Thu, 24 Aug 2023 12:46:13 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3snqgt6c5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:13 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37OCkAho17826128
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Aug 2023 12:46:10 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E40D2004E;
        Thu, 24 Aug 2023 12:46:10 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC05120043;
        Thu, 24 Aug 2023 12:46:09 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.171.27.69])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 24 Aug 2023 12:46:09 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, mihajlov@linux.ibm.com, seiden@linux.ibm.com,
        akrowiak@linux.ibm.com
Subject: [GIT PULL 03/22] KVM: s390: interrupt: Fix single-stepping kernel-emulated instructions
Date:   Thu, 24 Aug 2023 14:43:12 +0200
Message-ID: <20230824124522.75408-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230824124522.75408-1-frankja@linux.ibm.com>
References: <20230824124522.75408-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: BZ_d1PHHnLmmdHm-kt2S-ubz9NTlIQB6
X-Proofpoint-GUID: 6sTSdp0r9djstbkxaekIPm6BmeKRAzoG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-24_09,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 suspectscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=670 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0
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

