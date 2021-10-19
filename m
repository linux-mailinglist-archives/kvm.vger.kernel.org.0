Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4B5433DE1
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 19:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234846AbhJSR41 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 13:56:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57486 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234764AbhJSR4Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Oct 2021 13:56:25 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19JGHhnI001930;
        Tue, 19 Oct 2021 13:54:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=8j8IRvTbfKEhdGZ/2KzPAzMCe6mj93EzoEkTRYXgZZQ=;
 b=s//FBVfro4yXLqdvoJtjqSlUqV35RrZWjFaM/bp0Px3Nhnjxpc/SzhvVACH/SloYKsln
 sBdifD7tYbRcAqNf45FVU5MeidBSwz2XSO3cQKwKNNXtk5O3mkKhCjFZseWavyZaHKqf
 yGmlpNOYj9lm4mdrQ6c+GUkkKOALWuCuRPClqFepnZ3z1xNRsfHGrT/V694qcm0nYH9C
 EYui4tdmoUSjxQReDqE1F0PFmy/dbcIlIq33TnmVn74U0/L2lE18aHSjmYjsMXBcLfCg
 IWVZmZtvtHa55aGmIYfh9i2thN/eWiFe3p4o3j61q+Hjwfz2ge/pIzPyNDJ+XtTvChFK Ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bt1draavg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 13:54:12 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19JHpZ7t010078;
        Tue, 19 Oct 2021 13:54:12 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bt1draauy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 13:54:11 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19JHqImb007730;
        Tue, 19 Oct 2021 17:54:10 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3bqpcamv2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 17:54:09 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19JHs6M857213428
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 17:54:06 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 532AFAE056;
        Tue, 19 Oct 2021 17:54:06 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3789AE045;
        Tue, 19 Oct 2021 17:54:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Oct 2021 17:54:05 +0000 (GMT)
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>, farman@linux.ibm.com,
        kvm@vger.kernel.org
Subject: [PATCH 2/3] KVM: s390: preserve deliverable_mask in __airqs_kick_single_vcpu
Date:   Tue, 19 Oct 2021 19:54:00 +0200
Message-Id: <20211019175401.3757927-3-pasic@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211019175401.3757927-1-pasic@linux.ibm.com>
References: <20211019175401.3757927-1-pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6hmWhJcBLY9oj5mrEyvuAWq7yJu5Fstu
X-Proofpoint-ORIG-GUID: VXNIYvIP9jeuW_1nZhAEVrvpI2CUTq30
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-19_02,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 adultscore=0 spamscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=891 phishscore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110190103
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changing the deliverable mask in __airqs_kick_single_vcpu() is a bug. If
one idle vcpu can't take the interrupts we want to deliver, we should
look for another vcpu that can, instead of saying that we don't want
to deliver these interrupts by clearing the bits from the
deliverable_mask.

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Fixes: 9f30f6216378 ("KVM: s390: add gib_alert_irq_handler()")
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
2.25.1

