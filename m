Return-Path: <kvm+bounces-12168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 832FD8802AA
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 17:46:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4C071C22AEB
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 16:46:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C79A811CA1;
	Tue, 19 Mar 2024 16:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mtgo6XRz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABAE1171C;
	Tue, 19 Mar 2024 16:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710866753; cv=none; b=hes+mA+D0tYG0QNzaXdoa8OwwCUMHjS50hOhDIF5j/8/TYtdfnijSTIKquWjhFKlvbkeR5wmVXzrbuVvqGHZUMrgEiBbG/iVOIlN5sGlXv6FDGTaMvAMyD++zgHeCkCqTFLmzdbPMQzeDg+WoXMrZ+dYy19hG3Pxb4J6JfMv2Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710866753; c=relaxed/simple;
	bh=WeQCYm+MhXwSIvkBg2FGmOP5EPVeJUv4HAMFDixtsKM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CiypeTJbkLjO6CgA+jsZIUqIE6ksYMgpj4lYW+HfjmZXlNY0cjr6RKQkovL+7JjFebAi6Jf6BMULOPVcPv/PdncQREDE9pZzn0JdJfkjQSezh3V8L4R19/kGNS9+OJeRGKYeln2+i/XKbh2b9u/sL4FTFGCdPhm2G9zg0oNdIlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mtgo6XRz; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42JGMaj1030858;
	Tue, 19 Mar 2024 16:45:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=n/pP5d29NyH5V1cnKGJv6V1xIfsfQJultqnn14e9mjU=;
 b=mtgo6XRzn9xAxkQ2u1+EHU7zDYvN7U4pNXdVewgaAZQxKWOAy3Q3nHVikQrMEE8NXZD2
 101AuQyL5hZlsN9N3MvKnAiSDXjyl+2jiF9CPqZWd1rCBMKzD1SJ8Om7MeXYU8zzcPTY
 DXN8KhKVAkhqlYpr/AebA3PDb0+eOp4Jb3Z1c1dkfMoqe49PxJ/ysXqizsCWDZPVLJjv
 6OYQh3ln6uQCVPLn8YLMJeyM9GGUvysZ/q9uWPGDLomDLQ7DDC2qqOhUS7FaRXIsPdNs
 YzojLbwE7lnFcUlKpbU3CWTMeQptU6Dfmub3QWgExLGBfBgbdl295qrGsBOPpo7FjjqK Cw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wye5yg1u5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Mar 2024 16:45:49 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42JGg45x031816;
	Tue, 19 Mar 2024 16:45:48 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wye5yg1tk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Mar 2024 16:45:48 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42JEtZ3O019843;
	Tue, 19 Mar 2024 16:44:38 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3wwqykgh0v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Mar 2024 16:44:37 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 42JGiWgr43909478
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Mar 2024 16:44:34 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 801682004B;
	Tue, 19 Mar 2024 16:44:32 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2DEBF20040;
	Tue, 19 Mar 2024 16:44:32 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 19 Mar 2024 16:44:32 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Sven Schnelle <svens@linux.ibm.com>
Subject: [PATCH 0/2] KVM: s390: Fix V!=R bug in STFLE shadowing
Date: Tue, 19 Mar 2024 17:44:18 +0100
Message-Id: <20240319164420.4053380-1-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LqhuP0TmlnrZ-YbQHFMvoyGn-2j4y5-W
X-Proofpoint-GUID: yTlrPZGSlX8qkBUEbAL3Bn5amzyHPhdr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-19_06,2024-03-18_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 priorityscore=1501
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=715 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403140000 definitions=main-2403190126

The address of the facility control block is a physical address,
and therefore requires conversion from virtual (patch 2).

Also send unrelated patch 1 which was previously sent as part of
"KVM: s390: Fix minor bugs in STFLE shadowing" but deferred.

Nina Schoetterl-Glausch (2):
  KVM: s390: Minor refactor of base/ext facility lists
  KVM: s390: vsie: Use virt_to_phys for facility control block

 arch/s390/kvm/kvm-s390.c | 44 +++++++++++++++++-----------------------
 arch/s390/kvm/vsie.c     |  3 ++-
 2 files changed, 21 insertions(+), 26 deletions(-)


base-commit: e8f897f4afef0031fe618a8e94127a0934896aba
-- 
2.40.1


