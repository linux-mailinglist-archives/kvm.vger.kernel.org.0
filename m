Return-Path: <kvm+bounces-47893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 372BEAC6DBC
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 18:17:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9500CA24A94
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 16:17:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37C3328D8E5;
	Wed, 28 May 2025 16:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="njVbXHry"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDD728C5A6;
	Wed, 28 May 2025 16:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748449015; cv=none; b=kndJIFIFcvqzy3PcnK26ZXMeawHpGqXIWMsZdUUd5qKzpnRx6+1KV/VP4IHXQz1+9okS1uQs78bFKyZj3W3vYc4nXn9BLG9gZtvVN9iX0VuG3jcLuHdRh0BSz0x+MyxCNxxUS1QM7rqafLBvAQIBZExNQvnTb+hbUKbJGdSp8mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748449015; c=relaxed/simple;
	bh=4C/qgM8ewvDh80NuAA/pJldhZN2gQzE9q1EJ+adOGlo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tikLMvXaad4b5Z/m55HzxtaaCxl9IZqOhK9oS6sOL+K9ABL1D/Lo186x2779k/5biP6rPJTUkbno0LT6uSN2l6N3aclyULjHwWjONmDAB/doIdBFWNiTbw8Lt1ujB3nEurRPC3MqaABTMIxGcxizGUcYLSCk7I73RZ2tY/bdOKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=njVbXHry; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54SE9XXQ032017;
	Wed, 28 May 2025 16:16:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=IE9J5sR8L+vcgV6mQoHdHxyI+RrX/jwPojdG3ehAR
	Y4=; b=njVbXHry0e6S2MFPkeO8iSK1LOQb40mRofxnIuHsrTOF6Qk+wfEEyDGU7
	tuS5ORZiiLH2UASKeytoui3IMJexjpaWP0jUxk5MbqXuyRTg8BAGu2R6pwhDm7yZ
	g666I7/dhIY9LNnaqw+AfZyFPGFGa0Q9ydguCf01GXsYNKiLlnU7Os1cdYz5q/wD
	ROWym4FSARwFhU/cQYNSdxWEaOS1ag00to3Xjpf0Emnkf6CrPbtksGRB+81SqsBB
	65X3ynCtnTNQjgzWZ6KOXNYT5qeU174pc14/8sFi0AG2MqNhazo4uB5LrgTU6b5L
	PM3jWZako4Q4IgTHElonhjfD5nEwg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46x40jrpnm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 16:16:50 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54SF1t4L028909;
	Wed, 28 May 2025 16:16:49 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46useq08x1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 16:16:49 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54SGGjOM55443914
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 16:16:45 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2504E20049;
	Wed, 28 May 2025 16:16:45 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C589E20040;
	Wed, 28 May 2025 16:16:44 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.111.56.81])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 28 May 2025 16:16:44 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v1 0/7] KVM: s390: A fix and some refactoring
Date: Wed, 28 May 2025 18:16:29 +0200
Message-ID: <20250528161636.280717-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=SdL3duRu c=1 sm=1 tr=0 ts=683736f2 cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=mIUbo4bBOdFWAsOasuAA:9
X-Proofpoint-GUID: 48wB08JM3CN3rngp5u8_b8q6yBwgkxQ7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDEzOSBTYWx0ZWRfX8t08jpQ/1GEq pMqB4Gppv23TIkBM+9FnzYOvyYuFlGY1xp6ZGl54yUbDXp6Ro1HT1AsRWy4T0hidignbocVIUkq y5NTRuZDz7Ikqvz8w3DpC6V9zdleggNJyUcjZRwU5lDo2NiBfJcyuOJK6mwt2gdmJJBLrIu0hpI
 07OJ61N1KBrUMsj+eROl8rfeD3PA/bn3Up5NiXWfgGOPg92s+RnYxSyAxuQJNbPfOuNBUtfMIU/ u++5PkB+aU++yoS4f++ubpZrIz02sCIwa7ONKIJG7jUREsJN/VK6potkKypPEESbI/TFeG7Yryf uCY2BV3lBS56SO+CcboG1U5PIZ2eLDYAG+GEuW+AVDc0f6EZw3gwwN3zYikl0B7AiRuDI0YEz47
 ZryF+mu77sn74yiHKVra8eANWxku+BBJEswjcHwgnqX5CdQ2O+jgvr7WUOrTBUc/X9e6CX+R
X-Proofpoint-ORIG-GUID: 48wB08JM3CN3rngp5u8_b8q6yBwgkxQ7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-28_08,2025-05-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 spamscore=0 clxscore=1015 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505280139

Ciao Paolo,

In this pull request you find a fix by David and some refactoring in
preparation for a bigger upcoming series (hopefully 6.17, but might end
up being 6.18)

David's patches fix an issue with the interaction between protected
guests and some filesystems. The issue was due to how those
filesystems handled large folios, which with the existing code could
not be split and led to hanging. David's fix allows those large folios
to be split, thus solving the hangs.

My cleanup / refactoring patches are in preparation for a bigger
series where gmap handling will be moved entirely within kvm. Since
these patches are good enough on their own, I figured I could send them
out now and have a smaller series later.


The following changes since commit 8ffd015db85fea3e15a77027fda6c02ced4d2444:

  Linux 6.15-rc2 (2025-04-13 11:54:49 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-next-6.16-1

for you to fetch changes up to d6c8097803cbc3bb8d875baef542e6d77d10c203:

  KVM: s390: Simplify and move pv code (2025-05-28 17:48:04 +0200)

----------------------------------------------------------------
* Fix interaction between some filesystems and Secure Execution
* Some cleanups and refactorings, preparing for an upcoming big series

----------------------------------------------------------------
Claudio Imbrenda (4):
      s390: Remove unneeded includes
      KVM: s390: Remove unneeded srcu lock
      KVM: s390: Refactor and split some gmap helpers
      KVM: s390: Simplify and move pv code

David Hildenbrand (3):
      s390/uv: Don't return 0 from make_hva_secure() if the operation was not successful
      s390/uv: Always return 0 from s390_wiggle_split_folio() if successful
      s390/uv: Improve splitting of large folios that cannot be split while dirty

 MAINTAINERS                          |   2 +
 arch/s390/include/asm/gmap.h         |   2 -
 arch/s390/include/asm/gmap_helpers.h |  15 +++
 arch/s390/include/asm/tlb.h          |   1 +
 arch/s390/include/asm/uv.h           |   1 -
 arch/s390/kernel/uv.c                |  97 ++++++++++++---
 arch/s390/kvm/Makefile               |   2 +-
 arch/s390/kvm/diag.c                 |  30 ++++-
 arch/s390/kvm/gaccess.c              |   3 +-
 arch/s390/kvm/gmap-vsie.c            |   1 -
 arch/s390/kvm/gmap.c                 | 121 -------------------
 arch/s390/kvm/gmap.h                 |  39 -------
 arch/s390/kvm/intercept.c            |   9 +-
 arch/s390/kvm/kvm-s390.c             |  10 +-
 arch/s390/kvm/kvm-s390.h             |  42 +++++++
 arch/s390/kvm/priv.c                 |   6 +-
 arch/s390/kvm/pv.c                   |  61 +++++++++-
 arch/s390/kvm/vsie.c                 |  19 ++-
 arch/s390/mm/Makefile                |   2 +
 arch/s390/mm/fault.c                 |   1 -
 arch/s390/mm/gmap.c                  | 185 +----------------------------
 arch/s390/mm/gmap_helpers.c          | 221 +++++++++++++++++++++++++++++++++++
 arch/s390/mm/init.c                  |   1 -
 arch/s390/mm/pgalloc.c               |   2 -
 arch/s390/mm/pgtable.c               |   1 -
 25 files changed, 482 insertions(+), 392 deletions(-)
 create mode 100644 arch/s390/include/asm/gmap_helpers.h
 delete mode 100644 arch/s390/kvm/gmap.c
 delete mode 100644 arch/s390/kvm/gmap.h
 create mode 100644 arch/s390/mm/gmap_helpers.c

