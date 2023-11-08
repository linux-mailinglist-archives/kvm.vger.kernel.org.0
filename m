Return-Path: <kvm+bounces-1226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB6C77E5C1B
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 18:12:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4F182815FB
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 17:12:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 084E3315AB;
	Wed,  8 Nov 2023 17:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="h5CT29iE"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306F330356
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 17:12:37 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA66C19A3;
	Wed,  8 Nov 2023 09:12:36 -0800 (PST)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A8GGmq0013044;
	Wed, 8 Nov 2023 17:12:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=M53atpcg7tAsjFqXGdOm7Q39THxkaM14HR+KbpU8NNQ=;
 b=h5CT29iENerXo4BJ3Qmc8dz7ahKbznS3C5/LG6pEQor4IRuLrmpDDKaEVuxyRKUUdLUW
 36CQEid3kGJ+JoMiAGMNDDCTF3jT3URgmtW9Tk5oVrP5kthChrnQyh00+gWFSkuyMgFg
 l0LJ5CCWV+/E6yp0w+s70XYvHm2D4QSREdaGAEZ69Hky43qwev/aeCPyrjOENcLYNRtY
 zBv6m/f6xH5/PzdJ8SHZYNy7tJ6Cj8Uj1l25jSVwyDnYhBVP2WZ+y7g4oo/0QW+1Vw9e
 G57nuUg/BaSxpqDXs//UNfPi+wGQdi7K9IC4XLGmvgDFL2V2HFe1FIj8Fg7KA7EOEyxt wA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u8dkt29hn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 17:12:35 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A8H9fZL028882;
	Wed, 8 Nov 2023 17:12:35 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u8dkt29h8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 17:12:34 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A8Gc5N7003440;
	Wed, 8 Nov 2023 17:12:34 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u7w21x946-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 17:12:34 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A8HCVDX24511100
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Nov 2023 17:12:31 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 39B0920043;
	Wed,  8 Nov 2023 17:12:31 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0631D2004B;
	Wed,  8 Nov 2023 17:12:31 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Nov 2023 17:12:30 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] KVM: s390: Fix minor bugs in STFLE shadowing
Date: Wed,  8 Nov 2023 18:12:25 +0100
Message-Id: <20231108171229.3404476-1-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pYfAm6Jgr_HWSqMnFExaVvP8u1dvR7W4
X-Proofpoint-ORIG-GUID: kmav-itdVDg4M_QsYbu19NeK3oQgSkqp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-08_05,2023-11-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 priorityscore=1501 mlxlogscore=931 lowpriorityscore=0
 bulkscore=0 adultscore=0 spamscore=0 mlxscore=0 phishscore=0
 suspectscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311060000 definitions=main-2311080141

v2 -> v3 (range-diff below):
 * pick up tags (thanks Claudio)
 * reverse Christmas tree

v1 -> v2:
 * pick up tags (thanks {Claudio, David})
 * drop Fixes tag on cleanup patch, change message (thanks David)
 * drop Fixes tag on second patch since the length of the facility list
   copied wasn't initially specified and only clarified in later
   revisions
 * use READ/WRITE_ONCE (thanks {David, Heiko})

Improve the STFLE vsie implementation.
Firstly, fix a bug concerning the identification if the guest is
intending to use interpretive execution for STFLE for its guest.
Secondly, decrease the amount of guest memory accessed to the
minimum.
Also do some (optional) cleanups.

Nina Schoetterl-Glausch (4):
  KVM: s390: vsie: Fix STFLE interpretive execution identification
  KVM: s390: vsie: Fix length of facility list shadowed
  KVM: s390: cpu model: Use proper define for facility mask size
  KVM: s390: Minor refactor of base/ext facility lists

 arch/s390/include/asm/facility.h |  6 +++++
 arch/s390/include/asm/kvm_host.h |  2 +-
 arch/s390/kernel/Makefile        |  2 +-
 arch/s390/kernel/facility.c      | 21 +++++++++++++++
 arch/s390/kvm/kvm-s390.c         | 44 ++++++++++++++------------------
 arch/s390/kvm/vsie.c             | 15 +++++++++--
 6 files changed, 61 insertions(+), 29 deletions(-)
 create mode 100644 arch/s390/kernel/facility.c

Range-diff against v2:
1:  de77a2c36786 = 1:  de77a2c36786 KVM: s390: vsie: Fix STFLE interpretive execution identification
2:  f3b189627e96 ! 2:  e4b44c4d2400 KVM: s390: vsie: Fix length of facility list shadowed
    @@ Commit message
         case we'd wrongly inject a validity intercept.
     
         Acked-by: David Hildenbrand <david@redhat.com>
    +    Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
      ## arch/s390/include/asm/facility.h ##
    @@ arch/s390/kernel/facility.c (new)
     +unsigned int stfle_size(void)
     +{
     +	static unsigned int size;
    -+	u64 dummy;
     +	unsigned int r;
    ++	u64 dummy;
     +
     +	r = READ_ONCE(size);
     +	if (!r) {
3:  4907bb8fb2bc ! 3:  8b02ac33defb KVM: s390: cpu model: Use proper define for facility mask size
    @@ Commit message
         S390_ARCH_FAC_LIST_SIZE_U64 for defining the fac_mask array.
         Note that both values are the same, there is no functional change.
     
    +    Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
      ## arch/s390/include/asm/kvm_host.h ##
4:  2745898a22c3 ! 4:  a592be823576 KVM: s390: Minor refactor of base/ext facility lists
    @@ Commit message
         Make the constraint of that number on kvm_s390_fac_base obvious.
         Get rid of implicit double anding of stfle_fac_list.
     
    +    Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
     

base-commit: 05d3ef8bba77c1b5f98d941d8b2d4aeab8118ef1
-- 
2.39.2


