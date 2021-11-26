Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F76345F260
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 17:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236777AbhKZQvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 11:51:13 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46510 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1349352AbhKZQtM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Nov 2021 11:49:12 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AQGEJ2A030556;
        Fri, 26 Nov 2021 16:45:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=hkEWBp0FWiO4JBBYiuCIKiraO696DE2ToO66MHvtzJs=;
 b=of71cOhEltdWGfwyKAJ/HtMf0sOblUxtLM8CrZ+u/atKZHLH8cBoiCplS0yIWgBvV5hK
 N+6VTdh7ecvaXbxYQ9AvK5P2XS5kbw8SOtBQa31CrZW428kKktxwNzrB0BEojj98PVq6
 zDEouAs/jv6dUHLYGPD0AVBVQTjGAn8RqvtjffKmU6BAbwIDyVUe1KEx95GtLFCmBlbW
 F9Q0s4ualAQClFNGa2s7tThM8vED0eovfABtQW1jspdbPU1vsEE9/t909o79JC2MsLd1
 43v3pJ/CFMWNktooEP9hF6lfkztGNxEqrkIOvWY1LROkfyrjYV1IXHdqNTVBfrU6ZIdl bA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ck1972spn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Nov 2021 16:45:58 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AQGQV2j026795;
        Fri, 26 Nov 2021 16:45:58 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ck1972spa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Nov 2021 16:45:58 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AQGb801014234;
        Fri, 26 Nov 2021 16:45:56 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3cernawanx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Nov 2021 16:45:56 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AQGjroD29360602
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Nov 2021 16:45:53 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 500A611C04C;
        Fri, 26 Nov 2021 16:45:53 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBB2E11C052;
        Fri, 26 Nov 2021 16:45:52 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 26 Nov 2021 16:45:52 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] KVM: s390: Some gaccess cleanup
Date:   Fri, 26 Nov 2021 17:45:46 +0100
Message-Id: <20211126164549.7046-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rsfFx3E_hJS-oo5GDoNBqFccQPbFwGUv
X-Proofpoint-ORIG-GUID: 5eaLLeIVPoYi87IBYkk-YEgPMTKTBKIZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-26_04,2021-11-25_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111260095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cleanup s390 guest access code a bit, getting rid of some code
duplication and improving readability.

v2 -> v3
	minor changes only
		typo fixes
		whitespace
		line reordering
		picked up Reviewed-by's

v1 -> v2
	separate patch for renamed variable
		fragment_len instead of seg
	expand comment of guest_range_to_gpas
	fix nits

Janis Schoetterl-Glausch (3):
  KVM: s390: gaccess: Refactor gpa and length calculation
  KVM: s390: gaccess: Refactor access address range check
  KVM: s390: gaccess: Cleanup access to guest pages

 arch/s390/kvm/gaccess.c | 158 +++++++++++++++++++++++-----------------
 1 file changed, 92 insertions(+), 66 deletions(-)

Range-diff against v2:
1:  60d050210198 ! 1:  e5d7d2d7a4da KVM: s390: gaccess: Refactor gpa and length calculation
    @@ Metadata
      ## Commit message ##
         KVM: s390: gaccess: Refactor gpa and length calculation
     
    -    Improve readability be renaming the length variable and
    +    Improve readability by renaming the length variable and
         not calculating the offset manually.
     
         Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
    +    Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
     
      ## arch/s390/kvm/gaccess.c ##
     @@ arch/s390/kvm/gaccess.c: int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
    @@ arch/s390/kvm/gaccess.c: int access_guest(struct kvm_vcpu *vcpu, unsigned long g
      	psw_t *psw = &vcpu->arch.sie_block->gpsw;
     -	unsigned long _len, nr_pages, gpa, idx;
     +	unsigned long nr_pages, gpa, idx;
    -+	unsigned int fragment_len;
      	unsigned long pages_array[2];
    ++	unsigned int fragment_len;
      	unsigned long *pages;
      	int need_ipte_lock;
    + 	union asce asce;
     @@ arch/s390/kvm/gaccess.c: int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
      		ipte_lock(vcpu);
      	rc = guest_page_range(vcpu, ga, ar, pages, nr_pages, asce, mode);
2:  7080846c8c07 ! 2:  91cadb42cbbc KVM: s390: gaccess: Refactor access address range check
    @@ Commit message
         range.
     
         Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
    +    Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
     
      ## arch/s390/kvm/gaccess.c ##
     @@ arch/s390/kvm/gaccess.c: static int low_address_protection_enabled(struct kvm_vcpu *vcpu,
    @@ arch/s390/kvm/gaccess.c: static int low_address_protection_enabled(struct kvm_vc
     + * a correct exception into the guest.
     + * The resulting gpas are stored into @gpas, unless it is NULL.
     + *
    -+ * Note: All gpas except the first one start at the beginning of a page.
    ++ * Note: All fragments except the first one start at the beginning of a page.
     + *       When deriving the boundaries of a fragment from a gpa, all but the last
     + *       fragment end at the end of the page.
     + *
    @@ arch/s390/kvm/gaccess.c: int access_guest(struct kvm_vcpu *vcpu, unsigned long g
      {
      	psw_t *psw = &vcpu->arch.sie_block->gpsw;
     -	unsigned long nr_pages, gpa, idx;
    +-	unsigned long pages_array[2];
     +	unsigned long nr_pages, idx;
    ++	unsigned long gpa_array[2];
      	unsigned int fragment_len;
    --	unsigned long pages_array[2];
     -	unsigned long *pages;
    -+	unsigned long gpa_array[2];
     +	unsigned long *gpas;
      	int need_ipte_lock;
      	union asce asce;
3:  c991cbdbfbd5 ! 3:  f5000a22efcd KVM: s390: gaccess: Cleanup access to guest frames
    @@ Metadata
     Author: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
     
      ## Commit message ##
    -    KVM: s390: gaccess: Cleanup access to guest frames
    +    KVM: s390: gaccess: Cleanup access to guest pages
     
         Introduce a helper function for guest frame access.
     
         Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
    +    Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
     
      ## arch/s390/kvm/gaccess.c ##
     @@ arch/s390/kvm/gaccess.c: static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
    @@ arch/s390/kvm/gaccess.c: static int guest_range_to_gpas(struct kvm_vcpu *vcpu, u
      }
      
     +static int access_guest_page(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
    -+			      void *data, unsigned int len)
    ++			     void *data, unsigned int len)
     +{
     +	const unsigned int offset = offset_in_page(gpa);
     +	const gfn_t gfn = gpa_to_gfn(gpa);

base-commit: d25f27432f80a800a3592db128254c8140bd71bf
-- 
2.32.0

