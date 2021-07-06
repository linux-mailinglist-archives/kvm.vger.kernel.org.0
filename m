Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85E43BD373
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 13:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235563AbhGFLxo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 07:53:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20028 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241259AbhGFLuX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 07:50:23 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 166BXxFJ080520;
        Tue, 6 Jul 2021 07:47:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=31Ml+5y0bBePeWagPBybVFvajX0e8VDBdmj4/JcMdB8=;
 b=RqUQf3rjlnvTWmAcIWyZNb8O0j+WjEad0GJVAMs+Hk/o53Rul1BX3QVkn1xNOhDghloF
 i7z+jAlB6zCm13kqR7kKFoFkZmFjxaOv5OtaeoYS8U9YsoVcmS7yqQk8rJ2PlmDSSFqm
 4fEfLgl5uhOBQQZ8eUEh8mFa1RgGG2nJK25U6h/rBF6U9NEJ2ZaxYkFd14mzz+XgY+kH
 YBA2rFXkNkqFEtvrFyOUAZlAOLn3et3sLyShbhdve0rnEZV8zeQTJIF8Ri1DzWzSaFIl
 K+mPmBNR/AV+7E6ra5JnQVpFsMXni5g0vf479NaLFNRd4CeLQ72X0Ioc7r7T9B/MzBsR xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mc14ycjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 07:47:42 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 166BZQtY091384;
        Tue, 6 Jul 2021 07:47:42 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mc14ycj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 07:47:42 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 166BbxJC023029;
        Tue, 6 Jul 2021 11:47:40 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 39jf5hgnhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 11:47:40 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 166Bjlxf26411380
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jul 2021 11:45:47 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0CE95204F;
        Tue,  6 Jul 2021 11:47:36 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 48C9F52059;
        Tue,  6 Jul 2021 11:47:36 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        kvm@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE for s390
        (KVM/s390)), linux-s390@vger.kernel.org (open list:S390),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] KVM: s390: Enable specification exception interpretation
Date:   Tue,  6 Jul 2021 13:47:13 +0200
Message-Id: <20210706114714.3936825-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xP9UPiUJfQu3SBQKzGm6G_O1iZgI9csr
X-Proofpoint-GUID: AH13xw-P3S29Jw6NCOSV9pMBV_xuRFVg
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-06_06:2021-07-02,2021-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0 clxscore=1011
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107060057
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When this feature is enabled the hardware is free to interpret
specification exceptions generated by the guest, instead of causing
program interruption interceptions.

This benefits (test) programs that generate a lot of specification
exceptions (roughly 4x increase in exceptions/sec).

Interceptions will occur as before if ICTL_PINT is set,
i.e. if guest debug is enabled.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
I'll additionally send kvm-unit-tests for testing this feature.

 arch/s390/include/asm/kvm_host.h | 1 +
 arch/s390/kvm/kvm-s390.c         | 2 ++
 arch/s390/kvm/vsie.c             | 2 ++
 3 files changed, 5 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 9b4473f76e56..3a5b5084cdbe 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -244,6 +244,7 @@ struct kvm_s390_sie_block {
 	__u8	fpf;			/* 0x0060 */
 #define ECB_GS		0x40
 #define ECB_TE		0x10
+#define ECB_SPECI	0x08
 #define ECB_SRSI	0x04
 #define ECB_HOSTPROTINT	0x02
 	__u8	ecb;			/* 0x0061 */
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index b655a7d82bf0..aadd589a3755 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3200,6 +3200,8 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
 		vcpu->arch.sie_block->ecb |= ECB_SRSI;
 	if (test_kvm_facility(vcpu->kvm, 73))
 		vcpu->arch.sie_block->ecb |= ECB_TE;
+	if (!kvm_is_ucontrol(vcpu->kvm))
+		vcpu->arch.sie_block->ecb |= ECB_SPECI;
 
 	if (test_kvm_facility(vcpu->kvm, 8) && vcpu->kvm->arch.use_pfmfi)
 		vcpu->arch.sie_block->ecb2 |= ECB2_PFMFI;
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 4002a24bc43a..acda4b6fc851 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -510,6 +510,8 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 			prefix_unmapped(vsie_page);
 		scb_s->ecb |= ECB_TE;
 	}
+	/* specification exception interpretation */
+	scb_s->ecb |= scb_o->ecb & ECB_SPECI;
 	/* branch prediction */
 	if (test_kvm_facility(vcpu->kvm, 82))
 		scb_s->fpf |= scb_o->fpf & FPF_BPBC;
-- 
2.25.1

