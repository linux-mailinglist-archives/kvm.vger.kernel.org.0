Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B857439034
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 09:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbhJYHWK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 03:22:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11472 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229727AbhJYHWJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Oct 2021 03:22:09 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19P6HGI0022489;
        Mon, 25 Oct 2021 03:19:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=msNpFNZPwbg/fmbFCq9r/cC5NA9Ksjz/Dhv+NBKkwlI=;
 b=VR4Gr+24YSaiOM0YG/B2m9/sU+/5sRtAu4qAkCo64z1kwIWj+AGvpB8oxRv1ni3fpIMh
 82+QdLghljoWzUx+4dgacTj+ix0/kVNe0gRHfIpGFqmkQGVyCfGA4jo0gX0H+g10VA+E
 uhOErvNSmu9VKwPmiI88XfEhmTCmxwzkxXj/rZpwuPo3vD5Ldic/IBVtqP5E2Ijr0XO7
 wfcqOzpEAtii4bx2sF/HWavCnIWip3xZKXzcFHawrH5GeW2mthMhWkueXpj515Yer9WF
 OtpoHhkjd8oruFz5/XSekDenvA93cDje1gJpw75OIPLYFNOgAZWVfJjJfU85GxBN1Z1K KQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bvy98319m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 03:19:46 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19P6xflv021823;
        Mon, 25 Oct 2021 03:19:46 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bvy983197-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 03:19:46 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19P7ImQQ030206;
        Mon, 25 Oct 2021 07:19:44 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3bva19jsda-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 07:19:44 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19P7Jfg52687646
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 07:19:41 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68C0B11C066;
        Mon, 25 Oct 2021 07:19:41 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6130111C052;
        Mon, 25 Oct 2021 07:19:41 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 25 Oct 2021 07:19:41 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 17A4BE074D; Mon, 25 Oct 2021 09:19:41 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [GIT PULL 2/2] KVM: s390: preserve deliverable_mask in __airqs_kick_single_vcpu
Date:   Mon, 25 Oct 2021 09:19:40 +0200
Message-Id: <20211025071940.43696-3-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211025071940.43696-1-borntraeger@de.ibm.com>
References: <20211025071940.43696-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pTps9lRn_vxCy4cgO6GrgSfbqMclrtem
X-Proofpoint-ORIG-GUID: woglhp7UbSXK7IztrhSxbkYBH5dD4T7e
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_02,2021-10-25_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 mlxlogscore=885 suspectscore=0 phishscore=0 adultscore=0 malwarescore=0
 mlxscore=0 impostorscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110250040
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Halil Pasic <pasic@linux.ibm.com>

Changing the deliverable mask in __airqs_kick_single_vcpu() is a bug. If
one idle vcpu can't take the interrupts we want to deliver, we should
look for another vcpu that can, instead of saying that we don't want
to deliver these interrupts by clearing the bits from the
deliverable_mask.

Fixes: 9f30f6216378 ("KVM: s390: add gib_alert_irq_handler()")
Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Michael Mueller <mimu@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20211019175401.3757927-3-pasic@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/interrupt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 10722455fd02..2245f4b8d362 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -3053,13 +3053,14 @@ static void __airqs_kick_single_vcpu(struct kvm *kvm, u8 deliverable_mask)
 	int vcpu_idx, online_vcpus = atomic_read(&kvm->online_vcpus);
 	struct kvm_s390_gisa_interrupt *gi = &kvm->arch.gisa_int;
 	struct kvm_vcpu *vcpu;
+	u8 vcpu_isc_mask;
 
 	for_each_set_bit(vcpu_idx, kvm->arch.idle_mask, online_vcpus) {
 		vcpu = kvm_get_vcpu(kvm, vcpu_idx);
 		if (psw_ioint_disabled(vcpu))
 			continue;
-		deliverable_mask &= (u8)(vcpu->arch.sie_block->gcr[6] >> 24);
-		if (deliverable_mask) {
+		vcpu_isc_mask = (u8)(vcpu->arch.sie_block->gcr[6] >> 24);
+		if (deliverable_mask & vcpu_isc_mask) {
 			/* lately kicked but not yet running */
 			if (test_and_set_bit(vcpu_idx, gi->kicked_mask))
 				return;
-- 
2.31.1

