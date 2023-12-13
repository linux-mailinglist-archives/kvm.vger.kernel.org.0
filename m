Return-Path: <kvm+bounces-4328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 93B658111B7
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 13:50:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F39F281E38
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 12:50:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6650E2C181;
	Wed, 13 Dec 2023 12:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DnuRkQdf"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54451120;
	Wed, 13 Dec 2023 04:49:57 -0800 (PST)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BDCLTNP032482;
	Wed, 13 Dec 2023 12:49:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=JvRD3WuyG3QmNvwgRY+KL+S1xRNX+Q4YFY2HVcc5qLI=;
 b=DnuRkQdfvRv90KoOWt8BIjk57YAJCuwIrh2Lmf1O1r/xYdUqEC7s7nNx90Wxn9MaGNQX
 Z2/9JYhEAVpp8u6okuSriXRdH1VvsBj5zdQ7OVEHA88vsqBnMVX4c/8APGmNeLfjmPVq
 RGEzhq3/OxfaO/9HXLCPIikVc4mV/AINOKHPhnYax2foJn8kpCyAn3BiypGs3TLpUG5s
 cHyZctBbDZ9iK0bLmmZTaoJkap/8/UaSAeVQ6wKQMkAS8ZXdYhMJagwsQ+E7P61xqPXU
 SiObXvm6x4jWTV/AB7W28tzq58i0864gK1akbACExSYYf806ZNwIpWffG5/d3LxMOgkN AA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uybw4j3ep-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 12:49:48 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BDCjOrL007562;
	Wed, 13 Dec 2023 12:49:48 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uybw4j3ed-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 12:49:48 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BDB1fB7008544;
	Wed, 13 Dec 2023 12:49:47 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uw2jth14p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 12:49:46 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BDCniqb44696016
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Dec 2023 12:49:44 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 18CD12004D;
	Wed, 13 Dec 2023 12:49:44 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D9EDD20043;
	Wed, 13 Dec 2023 12:49:43 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Dec 2023 12:49:43 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, Nico Boehr <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 0/5] s390x: STFLE nested interpretation
Date: Wed, 13 Dec 2023 13:49:37 +0100
Message-Id: <20231213124942.604109-1-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ymbu3nF3FB5ULw9LXTQfrr2zC8dZ40yA
X-Proofpoint-ORIG-GUID: EhLXEmgd13kX2cZOk2awkTsaHNh9Powk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-13_05,2023-12-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 phishscore=0 spamscore=0 suspectscore=0 clxscore=1011 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=633 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312130093

Add a test case that tests the interpretation of STFLE performed by a
nested guest using a snippet.
Also add some functionality to lib/, namely:
* simple pseudo random number generation (arch independent)
* exit (optionally with return code) from snippet (s390x)

Nina Schoetterl-Glausch (5):
  lib: Add pseudo random functions
  s390x: lib: Remove double include
  s390x: Add library functions for exiting from snippet
  s390x: Use library functions for snippet exit
  s390x: Add test for STFLE interpretive execution (format-0)

 Makefile                                |   1 +
 s390x/Makefile                          |   3 +
 lib/s390x/asm/arch_def.h                |  13 +++
 lib/s390x/asm/facility.h                |  10 +-
 lib/libcflat.h                          |   7 ++
 lib/s390x/sie.h                         |   1 +
 lib/s390x/snippet-guest.h               |  26 +++++
 lib/s390x/{snippet.h => snippet-host.h} |   9 +-
 lib/rand.c                              |  19 ++++
 lib/s390x/sie.c                         |  29 +++++-
 lib/s390x/snippet-host.c                |  40 +++++++
 lib/s390x/uv.c                          |   2 +-
 s390x/mvpg-sie.c                        |   2 +-
 s390x/pv-diags.c                        |   2 +-
 s390x/pv-icptcode.c                     |   2 +-
 s390x/pv-ipl.c                          |   2 +-
 s390x/sie-dat.c                         |  12 +--
 s390x/snippets/c/sie-dat.c              |  19 +---
 s390x/snippets/c/stfle.c                |  26 +++++
 s390x/spec_ex-sie.c                     |   2 +-
 s390x/stfle-sie.c                       | 132 ++++++++++++++++++++++++
 s390x/uv-host.c                         |   2 +-
 22 files changed, 322 insertions(+), 39 deletions(-)
 create mode 100644 lib/s390x/snippet-guest.h
 rename lib/s390x/{snippet.h => snippet-host.h} (93%)
 create mode 100644 lib/rand.c
 create mode 100644 lib/s390x/snippet-host.c
 create mode 100644 s390x/snippets/c/stfle.c
 create mode 100644 s390x/stfle-sie.c


base-commit: 6b31aa76a038bb56b144825f55301b2ab64c02e9
-- 
2.41.0


