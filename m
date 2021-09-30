Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11B141DA52
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 14:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351182AbhI3M4c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 08:56:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2132 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351173AbhI3M4a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Sep 2021 08:56:30 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18UBfkj8021433;
        Thu, 30 Sep 2021 08:54:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=haGuvZUVxbk4neiM1DnZ40Zx6zG2foU0ApT3VZ9wlJw=;
 b=eEF3y99tSf2Qhf6m4mD8aAF/v7iLscpHcIAtQDAR+98/VxVDt4xxxeTSDNKfAWcoV4Wo
 GlWfYggkQnsaNeUpunLB09x+gGScds334fPgv1PurXaUf5CNo8OdrNR4ycCeWggfi0PK
 IkbMEZxnpHFfferh/4QHiYrAhHGYTNkz+loUrtVtOTN0e+NK4sc9jA11GcPqHmBpARz+
 HBSZi5dc/t30Il/ZXsZG8mSwgNP2VWPYjlJaQ6zuS34FKxJBX0pwfweOhxMLRnLY9LKN
 c3lKTPvQg5jariGFx02g1xlB5UZZBXS6Fez8tmynLSrWmsqKlqqumlCbjF7vkdqE59tY qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bdck6hke3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Sep 2021 08:54:48 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18UCBGik022313;
        Thu, 30 Sep 2021 08:54:47 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bdck6hkdc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Sep 2021 08:54:47 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18UCq7Os023036;
        Thu, 30 Sep 2021 12:54:45 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3b9udaguqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Sep 2021 12:54:44 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18UCsfdb48300328
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 12:54:41 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 446C24204B;
        Thu, 30 Sep 2021 12:54:41 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D18042042;
        Thu, 30 Sep 2021 12:54:41 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 30 Sep 2021 12:54:41 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id B6D23E168C; Thu, 30 Sep 2021 14:54:40 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [GIT PULL 1/1] KVM: s390: Function documentation fixes
Date:   Thu, 30 Sep 2021 14:54:40 +0200
Message-Id: <20210930125440.22777-2-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930125440.22777-1-borntraeger@de.ibm.com>
References: <20210930125440.22777-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Kof7mAzQpuE4Qfq_GVN2mAt-9GiHT7Hw
X-Proofpoint-GUID: 3yPG1PVOOXgKmZe84gzrN6svTRp4-IqO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-30_04,2021-09-30_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 spamscore=0 phishscore=0
 mlxlogscore=961 malwarescore=0 adultscore=0 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109300079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

The latest compile changes pointed us to a few instances where we use
the kernel documentation style but don't explain all variables or
don't adhere to it 100%.

It's easy to fix so let's do that.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/gaccess.c   | 12 ++++++++++++
 arch/s390/kvm/intercept.c |  4 +++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index b9f85b2dc053..6af59c59cc1b 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -894,6 +894,11 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
 
 /**
  * guest_translate_address - translate guest logical into guest absolute address
+ * @vcpu: virtual cpu
+ * @gva: Guest virtual address
+ * @ar: Access register
+ * @gpa: Guest physical address
+ * @mode: Translation access mode
  *
  * Parameter semantics are the same as the ones from guest_translate.
  * The memory contents at the guest address are not changed.
@@ -934,6 +939,11 @@ int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
 
 /**
  * check_gva_range - test a range of guest virtual addresses for accessibility
+ * @vcpu: virtual cpu
+ * @gva: Guest virtual address
+ * @ar: Access register
+ * @length: Length of test range
+ * @mode: Translation access mode
  */
 int check_gva_range(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
 		    unsigned long length, enum gacc_mode mode)
@@ -956,6 +966,7 @@ int check_gva_range(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
 
 /**
  * kvm_s390_check_low_addr_prot_real - check for low-address protection
+ * @vcpu: virtual cpu
  * @gra: Guest real address
  *
  * Checks whether an address is subject to low-address protection and set
@@ -979,6 +990,7 @@ int kvm_s390_check_low_addr_prot_real(struct kvm_vcpu *vcpu, unsigned long gra)
  * @pgt: pointer to the beginning of the page table for the given address if
  *	 successful (return value 0), or to the first invalid DAT entry in
  *	 case of exceptions (return value > 0)
+ * @dat_protection: referenced memory is write protected
  * @fake: pgt references contiguous guest memory block, not a pgtable
  */
 static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 72b25b7cc6ae..2bd8f854f1b4 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -269,6 +269,7 @@ static int handle_prog(struct kvm_vcpu *vcpu)
 
 /**
  * handle_external_interrupt - used for external interruption interceptions
+ * @vcpu: virtual cpu
  *
  * This interception only occurs if the CPUSTAT_EXT_INT bit was set, or if
  * the new PSW does not have external interrupts disabled. In the first case,
@@ -315,7 +316,8 @@ static int handle_external_interrupt(struct kvm_vcpu *vcpu)
 }
 
 /**
- * Handle MOVE PAGE partial execution interception.
+ * handle_mvpg_pei - Handle MOVE PAGE partial execution interception.
+ * @vcpu: virtual cpu
  *
  * This interception can only happen for guests with DAT disabled and
  * addresses that are currently not mapped in the host. Thus we try to
-- 
2.31.1

