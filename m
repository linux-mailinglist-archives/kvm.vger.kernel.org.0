Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195323FA96A
	for <lists+kvm@lfdr.de>; Sun, 29 Aug 2021 08:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbhH2GCW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Aug 2021 02:02:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50896 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230049AbhH2GCU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 29 Aug 2021 02:02:20 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17T5XXFV070994;
        Sun, 29 Aug 2021 02:01:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=yRYlJimhFCwPUF+rsV93cunSY7i+qoN517K4vatAAxc=;
 b=jtXomt6nisAtbxOhwnfmoGpwQK4VliqIzrEMHe0JTHt8NZxpus7F1WEMqxG6ghC3uGax
 CI4izAw4TL4OfHDwAncw39eaKu9NIcNA4S40Fxk+SnHaYdUPhLpFlhlp0CjrL96xN/s3
 i7qwtFG9TJH33HxaOd0svjrkm0igqgEoRiRW1QXUT4sfHhyHOZQgmsEe8bWDpDaWeUKl
 K2f0je2T73xi76bzEQKPJSMMYWJhe89oqAAQirNdRqJv2k+yg1GMgID+okUof2sbEJ8W
 Gz3tyxw1h4yT/RyEi6twNOKLOm1NwQXuPAOw01E5JoJzdkn6fjLaq+s7FNj8BZnmN0L1 Bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ar2tg1u25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 29 Aug 2021 02:01:28 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17T6054o039687;
        Sun, 29 Aug 2021 02:01:28 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ar2tg1u1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 29 Aug 2021 02:01:28 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17T5sE33001032;
        Sun, 29 Aug 2021 06:01:26 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3aqcs8se29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 29 Aug 2021 06:01:26 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17T61Mka46989626
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Aug 2021 06:01:22 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B63E54204D;
        Sun, 29 Aug 2021 06:01:22 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A15CC4204B;
        Sun, 29 Aug 2021 06:01:22 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sun, 29 Aug 2021 06:01:22 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 3DF7DE080C; Sun, 29 Aug 2021 08:01:22 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Subject: [GIT PULL 1/2] KVM: s390: Enable specification exception interpretation
Date:   Sun, 29 Aug 2021 08:01:20 +0200
Message-Id: <20210829060121.16702-2-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210829060121.16702-1-borntraeger@de.ibm.com>
References: <20210829060121.16702-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jq-yMPdI9jT8KvdWx9utGVJgLhcvpw-N
X-Proofpoint-GUID: B3ZyvPhVhwp_ECEnkNXLHLEZsgTliL8M
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-29_01:2021-08-27,2021-08-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 spamscore=0 lowpriorityscore=0 clxscore=1015 phishscore=0 mlxlogscore=999
 impostorscore=0 adultscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108290031
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

When this feature is enabled the hardware is free to interpret
specification exceptions generated by the guest, instead of causing
program interruption interceptions.

This benefits (test) programs that generate a lot of specification
exceptions (roughly 4x increase in exceptions/sec).

Interceptions will occur as before if ICTL_PINT is set,
i.e. if guest debug is enabled.

There is no indication if this feature is available or not and the
hardware is free to interpret or not. So we can simply set this bit and
if the hardware ignores it we fall back to intercept 8 handling.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Link: https://lore.kernel.org/linux-s390/20210706114714.3936825-1-scgl@linux.ibm.com/
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 1 +
 arch/s390/kvm/kvm-s390.c         | 2 ++
 arch/s390/kvm/vsie.c             | 2 ++
 3 files changed, 5 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 8925f3969478..118d5450c523 100644
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
index f72f361d39dd..5b45c83ced21 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3180,6 +3180,8 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
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
2.31.1

