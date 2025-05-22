Return-Path: <kvm+bounces-47366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7913EAC0C9C
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 15:23:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88D8E176F17
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 13:23:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6633328C005;
	Thu, 22 May 2025 13:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GIbY4ir6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F1523C384;
	Thu, 22 May 2025 13:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747920189; cv=none; b=Eo6FkYgkDlRUm2K46wroglFLYbaL8pUQEtRu2Dd0Ya/ubn6wFIRXSG6ApZUTT1bFZCg2rcgZG8u9gJfBaakCQyFC8nKMFtjtgWuvdrgZFdgNPeyA2Ycv4ebfNe56LW6jN3b4BQMlW69aqe1026zcX3BnLJqK4bLBIUO2hSX6R/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747920189; c=relaxed/simple;
	bh=0JEORw2SsyVLR1uBJgZXcGvnlMAFQlhaAsBpKDqoWxY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S3fVGn20fYrWmRxdqH1fCmX4knmMrUbr22UFY/4T+G2VzAmMpX0eUzkdpK8legPraTLdNl1jlCqcCahcwVOv4pXcwrytPC+PZGFF/qv8fJN8V9Sa0hs8dIxhx5rcyKbm0MDFgKGXy7EKXpGtN+CHGZXd/f4j0M+rj/NxlnXgVrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GIbY4ir6; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54M6cN8O006356;
	Thu, 22 May 2025 13:23:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=JYcdlJ2XmPgESj6kRfPMCI0aagW2DlGv4CwXfajfw
	/0=; b=GIbY4ir6QPlgNP1Qq/ByE0ejT0TXy3gkQyOnQ+DFxxjoBjtkjTjWL5thu
	iDtZZq1jB+6YeeZcKPJje90+mc68Xeq8w7y6b4ya1vX0FeirjXKIiX3TvP6GxtHq
	whDcPzJgTujftf6cyzGpr7KcTbsTRjUPW1gXgsUfn9dqx0XDtbYAtthhkz35HSHR
	SxXZPqK1Lw2B+V+GoUKnvABXC8twq4sQE8YoSsjrfKSwTAB4xDySinFG78/DFzNF
	x4wTObY2xwEEvFCl3wsBLrlZnR1PvuOoE5JLaKro/Sdbnuc/gbgcoNOkYL3m3uPt
	naYyECYIVD2JklmzHqpP1BMrMYIWQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46smf9cf71-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 13:23:05 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54M9keuG032070;
	Thu, 22 May 2025 13:23:04 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwnmhj6p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 13:23:04 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54MDN0BB19595678
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 13:23:00 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3606B2004B;
	Thu, 22 May 2025 13:23:00 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CFF4320043;
	Thu, 22 May 2025 13:22:59 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 22 May 2025 13:22:59 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, gor@linux.ibm.com,
        schlameuss@linux.ibm.com
Subject: [PATCH v3 0/4] KVM: s390: some cleanup and small fixes
Date: Thu, 22 May 2025 15:22:55 +0200
Message-ID: <20250522132259.167708-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uEkRsBbkhwOjPv5KA3xbJzcFfKFMsw8U
X-Proofpoint-ORIG-GUID: uEkRsBbkhwOjPv5KA3xbJzcFfKFMsw8U
X-Authority-Analysis: v=2.4 cv=TbqWtQQh c=1 sm=1 tr=0 ts=682f2539 cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=dt9VzEwgFbYA:10 a=mc03PJ0X8kF70Z1LeTwA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDEzMyBTYWx0ZWRfX5bfvoFCoihjD W9KwnVxTr62ceNS9L9U+mSaaUzksXqUCvaNt9mL5nG7v+cTbnyZmQbMs3o+5nQEqUcF5t8v/TDZ /IMphltXMXd5295qqp9R6i7NLlbJ03G4hWa1jEsEmGgcfVoFVWno/wLV1MVvg42KdFGNpxZubBH
 3oJ3DOjjtkyAamlzA9q8oFrUW4w5yttnxrvhOlVApATgcmauBbDbGUdFDGt4u2tl3HeUMxmvXf9 t/cuQCDh7ronXRv7XB8ZWyQN8CmrRNdL5j0QH+yi1k9u+qQOGlPLaxqbs6JJ+kgUqahefr3X3Fs trRHhbu5bj2y2d+JLFAoGGxLNSFpCGzrKHRRcY04WSgqX1SQrfFrkK0RRl/zl0vN8TCFQSOlUp5
 plPLnLsV3Ta4MtEnlbOaMzAYMOClZ7bA3mL8YkbSJtCYTrrH0GlErcXx3GbUMh0WsqrewT9h
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_06,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 phishscore=0 adultscore=0 spamscore=0 mlxlogscore=684 malwarescore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 clxscore=1015
 impostorscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505220133

This series has some cleanups and small fixes in preparation of the
upcoming series that will finally completely move all guest page table
handling into kvm. The cleaups and fixes in this series are good enough
on their own, hence why they are being sent now.

v2->v3  (mainly addresses Nina's and Heiko's comments)
* drop patch 3 - it was just an attempt to clean up the code a little
  and make it more readable, but there were too many issues to address
* remove all dead code from s390/mm/gmap.c that is being replaced by
  code in s390/mm/gmap_helpers.c
* remove a couple of unused functions from s390/mm/gmap_helpers.c, some
  of them will be introduced again in a later series when they are
  actually needed
* added documentation to the functions in s390/mm/gmap_helpers.c
* general readability improvements

v1->v2
* remove uneeded "gmap.h" include from gaccess.c (thanks Christph)
* use a custom helper instead of u64_replace_bits() (thanks Nina)
* new helper functions in priv.c to increase readability (thanks Nina)
* add lockdep assertion in handle_essa() (thanks Nina)
* gmap_helper_disable_cow_sharing() will not take the mmap lock, and
  must now be called while already holding the mmap lock in write mode

Claudio Imbrenda (4):
  s390: remove unneeded includes
  KVM: s390: remove unneeded srcu lock
  KVM: s390: refactor and split some gmap helpers
  KVM: s390: simplify and move pv code

 MAINTAINERS                          |   2 +
 arch/s390/include/asm/gmap.h         |   2 -
 arch/s390/include/asm/gmap_helpers.h |  15 ++
 arch/s390/include/asm/tlb.h          |   1 +
 arch/s390/include/asm/uv.h           |   1 -
 arch/s390/kernel/uv.c                |  12 +-
 arch/s390/kvm/Makefile               |   2 +-
 arch/s390/kvm/diag.c                 |  13 +-
 arch/s390/kvm/gaccess.c              |   3 +-
 arch/s390/kvm/gmap-vsie.c            |   1 -
 arch/s390/kvm/gmap.c                 | 121 ---------------
 arch/s390/kvm/gmap.h                 |  39 -----
 arch/s390/kvm/intercept.c            |   9 +-
 arch/s390/kvm/kvm-s390.c             |  10 +-
 arch/s390/kvm/kvm-s390.h             |  42 +++++
 arch/s390/kvm/priv.c                 |   6 +-
 arch/s390/kvm/pv.c                   |  61 +++++++-
 arch/s390/kvm/vsie.c                 |  19 ++-
 arch/s390/mm/Makefile                |   2 +
 arch/s390/mm/fault.c                 |   1 -
 arch/s390/mm/gmap.c                  | 158 +------------------
 arch/s390/mm/gmap_helpers.c          | 223 +++++++++++++++++++++++++++
 arch/s390/mm/init.c                  |   1 -
 arch/s390/mm/pgalloc.c               |   2 -
 arch/s390/mm/pgtable.c               |   1 -
 25 files changed, 395 insertions(+), 352 deletions(-)
 create mode 100644 arch/s390/include/asm/gmap_helpers.h
 delete mode 100644 arch/s390/kvm/gmap.c
 delete mode 100644 arch/s390/kvm/gmap.h
 create mode 100644 arch/s390/mm/gmap_helpers.c

-- 
2.49.0


