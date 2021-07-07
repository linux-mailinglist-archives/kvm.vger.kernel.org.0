Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D123BE7A0
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 14:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbhGGMMS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 08:12:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9434 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231428AbhGGMMQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 08:12:16 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167C4wko190071;
        Wed, 7 Jul 2021 08:09:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=RfrOqRtoOVElWwtaBVljkx0zHfTRfJUGld1xA9G+Ry0=;
 b=SCiwnSyKkRkwrsfaxxwh1JsWO6fr93goPx9ZHyvbotmuTc5zqsjat4KSl7C1WcTdeMcm
 JwWRRnbIVr2mMS3I6cko3KyUcwtW69cRGwO5H2S/94KvwuzB/pZ4D9fR1lUM69FsBoYQ
 7RvJQQ8FEQ/LPvDE+SfFj2WMB88bN9FSVMASYT+skGuhWxewDvf+TudzQxka3Dso8fbc
 401NrpV+aaw3OAQzKAF6fB+6hQR5mFWxHp3Kau+paX+DNohNxFxevvSpAKX8XnIJiE8l
 bNyZubk1/ur4kUVb0OeUanqpLte6Np9AVS/gEJk1VIXPOyE8MEhRjiy90W8sYKQ1mX6J Bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mn8fks53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 08:09:36 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 167C5KCp192121;
        Wed, 7 Jul 2021 08:09:35 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mn8fks4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 08:09:35 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 167C8d2u013348;
        Wed, 7 Jul 2021 12:09:34 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 39jfh88wyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 12:09:33 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 167C9UwB22938038
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Jul 2021 12:09:31 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEDF74204D;
        Wed,  7 Jul 2021 12:09:30 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6054542042;
        Wed,  7 Jul 2021 12:09:30 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  7 Jul 2021 12:09:30 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: s390: Enable specification exception interpretation
Date:   Wed,  7 Jul 2021 14:07:45 +0200
Message-Id: <20210707120745.531571-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3T0jtjYSpuIO4lwMMyyEketgmkI0nRIb
X-Proofpoint-GUID: QoD2VbuUfFj0ZTed5JlMOftA_7od6npd
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-07_06:2021-07-06,2021-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 clxscore=1015 impostorscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107070073
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When this feature is enabled the hardware is free to interpret
specification exceptions generated by the guest, instead of causing
program interruption interceptions, but it is not required to.
There is no indication if this feature is available or not,
so we can simply set this bit and if the hardware ignores it
we fall back to intercept 8 handling.
The same applies to vSIE, we forward the guest hypervisor's bit
and fall back to injection if interpretation does not occur.

This benefits (test) programs that generate a lot of specification
exceptions (roughly 4x increase in exceptions/sec).

Interceptions will occur as before if ICTL_PINT is set,
i.e. if guest debug is enabled.
A specification exception detected on the program new PSW
will also always cause an interception.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
v1 -> v2
	Rephrase commit message
	Add comment about opting into interpretation

 arch/s390/include/asm/kvm_host.h | 1 +
 arch/s390/kvm/kvm-s390.c         | 5 +++++
 arch/s390/kvm/vsie.c             | 2 ++
 3 files changed, 8 insertions(+)

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
index b655a7d82bf0..7675b72a3ddf 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3200,6 +3200,11 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
 		vcpu->arch.sie_block->ecb |= ECB_SRSI;
 	if (test_kvm_facility(vcpu->kvm, 73))
 		vcpu->arch.sie_block->ecb |= ECB_TE;
+	/* no facility bit, can opt in because we do not need
+	 * to observe specification exception intercepts
+	 */
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

