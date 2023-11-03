Return-Path: <kvm+bounces-510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 811AA7E0762
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 18:30:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B21F91C210AA
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 17:30:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41C6E20B21;
	Fri,  3 Nov 2023 17:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kq46efc0"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087661CF88
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 17:30:17 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDDE8136;
	Fri,  3 Nov 2023 10:30:16 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A3H9QiC002850;
	Fri, 3 Nov 2023 17:30:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=F/MbwI7I3lpLeDSp5tJGhwWlILsNf2tIxZUSdv1jJW4=;
 b=kq46efc0g04pDo+g0qI8SQr+byAcAF/1W989ivWJuNW+08Z3RUQvxynp3e9N57q72d4s
 krV73avZ3rVLEWV4/sK5rCemKeOmzSI1oAgesn2frV8CWLOWuf3WDIM/p/CamDB6yTdS
 Es+ZcI0aFxTwnR6WShTyjGAjyuuP5tRKWjsuJddEpxXON6YyyFOMZSd0rghp6aonxdM+
 jHPUZidZpHMDaru8ShIIW6RRJZBwmzBKV+3lpG9m0nRLBjoJoLV2CDaP7s4NBPfrEmTq
 ERf98zCEy4b4g639mqNpjucpdNK9K9/T0v+33MCyOm2ISPkHFWv3fDGgc2yQP4JA8IV0 hQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u550x0jm6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 17:30:15 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A3HMDbb011979;
	Fri, 3 Nov 2023 17:30:15 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u550x0jkd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 17:30:15 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A3GOdS7000614;
	Fri, 3 Nov 2023 17:30:14 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u1cmtqt16-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 17:30:14 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A3HU9Ni13828734
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 3 Nov 2023 17:30:09 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A565620049;
	Fri,  3 Nov 2023 17:30:09 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5D2DC2004B;
	Fri,  3 Nov 2023 17:30:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  3 Nov 2023 17:30:09 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Vasily Gorbik <gor@linux.ibm.com>,
        David Hildenbrand <dahi@linux.vnet.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Michael Mueller <mimu@linux.vnet.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org
Subject: [PATCH 0/4] KVM: s390: Fix minor bugs in STFLE shadowing
Date: Fri,  3 Nov 2023 18:30:04 +0100
Message-Id: <20231103173008.630217-1-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Q_zCaKUp-8IIUHy5yN_UU-IkoDTomx56
X-Proofpoint-GUID: Q87tJPGnOcREUlAH-YTmxrOv4QvkE00p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-03_16,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=617 bulkscore=0
 clxscore=1011 phishscore=0 spamscore=0 priorityscore=1501 malwarescore=0
 adultscore=0 suspectscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311030146

Fix two bugs in the STFLE vsie implementation.
The first concerns the identification if the guest is intending
to use interpretive execution for STFLE for its guest.
The second fixes too much of the guests memory being accessed when
shadowing.

Nina Schoetterl-Glausch (4):
  KVM: s390: vsie: Fix STFLE interpretive execution identification
  KVM: s390: vsie: Fix length of facility list shadowed
  KVM: s390: cpu model: Use previously unused constant
  KVM: s390: Minor refactor of base/ext facility lists

 arch/s390/include/asm/facility.h |  6 +++++
 arch/s390/include/asm/kvm_host.h |  2 +-
 arch/s390/kernel/Makefile        |  2 +-
 arch/s390/kernel/facility.c      | 18 +++++++++++++
 arch/s390/kvm/kvm-s390.c         | 44 ++++++++++++++------------------
 arch/s390/kvm/vsie.c             | 15 +++++++++--
 6 files changed, 58 insertions(+), 29 deletions(-)
 create mode 100644 arch/s390/kernel/facility.c


base-commit: 05d3ef8bba77c1b5f98d941d8b2d4aeab8118ef1
-- 
2.39.2


