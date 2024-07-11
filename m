Return-Path: <kvm+bounces-21404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 688EA92E5B3
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 13:15:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 14B5F1F213E5
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 11:15:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9379916DC0C;
	Thu, 11 Jul 2024 11:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XUXfn2/B"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3406E16D4D6;
	Thu, 11 Jul 2024 11:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720696120; cv=none; b=KBtJkHeEe07B1qumb8Z9B7t0LINck6BOnYXF0xvRpRyQFhG6zaowmYj3NjVAEE5GYHGrPlATxF3YiFb//MbrE/46CaYUdO7qI2H3QFBqzxt5CnEziThJ1FKyyR0UrfNUqcZL5q5x8rOhHTu+W9UqkXqaqgaqcBK/voWDAgoWPAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720696120; c=relaxed/simple;
	bh=X1uQQeRjiqBDA1KWEq9zELGf9xH5AWAAXrgyetGZH/I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qq6AvmG0OlERd6OF/NLKtYLqt8lq7z3dimu8XmKfqK6uQY1sWbParxKtq+Olz9f/s8jg7LcrVedBCYRXo9r0ABErU+e1OaerFLyjUksvZEI3VMAC85umwoLTaJyn7EKpXpY2OIJB4EJFLQfRV/CtGWlRgZ3BQ6y6oaC/M9OhRhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XUXfn2/B; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46B7x87u030141;
	Thu, 11 Jul 2024 11:08:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:content-transfer-encoding
	:mime-version; s=pp1; bh=jiSr8OvXSuOavayingR+fzfqvHSLPGbyMXUndus
	jP2k=; b=XUXfn2/BJ0C5FvxHdnbe6MV+uPTm7pg/CfIz6O/UhAgcLXiCIzlTDbp
	8wj50qk9S6UTENaUwWviStcBl2Gd5vnAM5/yg+aufwM1UCwsjSgW6gMf4K55x25K
	IWKXH3jDpVFE/FtYbXOLg8tjPUfq0rL+wy6dwJrIbTbL+GCph+tRAQ/lJCeqwBRq
	AI+MlPsZYYMoF3p6yT5+Hp7+GlgDJXfbrXlQM/VpZAuHE5eK1imGJgKSK2/AYQeT
	2cgl5m2LxENjYEV2lxieXi8H5Y8QN7vVbPlox2GIWmTr5JCVoxssSvqkZoW0R7YX
	0QcTFHRAdw9bOGbMj/lHKUKxNqMeJxw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40abfpgfe8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jul 2024 11:08:37 +0000 (GMT)
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 46BB8aJP002798;
	Thu, 11 Jul 2024 11:08:36 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40abfpgfe7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jul 2024 11:08:36 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 46B8lO85013976;
	Thu, 11 Jul 2024 11:08:35 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 407h8q0eaq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jul 2024 11:08:35 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 46BB8T1n55706094
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 11:08:31 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6831A20043;
	Thu, 11 Jul 2024 11:08:29 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 309BA20040;
	Thu, 11 Jul 2024 11:08:29 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.boeblingen.de.ibm.com (unknown [9.152.224.253])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Jul 2024 11:08:29 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [GIT PULL 0/3] KVM: s390x: changes for v6.11
Date: Thu, 11 Jul 2024 13:00:03 +0200
Message-ID: <20240711110654.40152-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nZB9RvtMoOfMmh3bckUew5eRGPGPDQD9
X-Proofpoint-GUID: rl94km9M00RjmDirrNrATPPoNaQS5Dm-
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-11_06,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 phishscore=0 adultscore=0 mlxscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=552 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407110077

A couple of minor changes/fixes for 6.11 which aren't time critical.

Christoph's ucontrol selftests are on the list but might need another
round or two so they are not included but will be in 6.12.

Please pull:

The following changes since commit c3f38fa61af77b49866b006939479069cd451173:

  Linux 6.10-rc2 (2024-06-02 15:44:56 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-next-6.11-1

for you to fetch changes up to 7816e58967d0e6cadce05c8540b47ed027dc2499:

  kvm: s390: Reject memory region operations for ucontrol VMs (2024-07-04 09:07:24 +0200)

----------------------------------------------------------------
Assortment of tiny fixes which are not time critical:
 - Rejecting memory region operations for ucontrol mode VMs
 - Rewind the PSW on host intercepts for VSIE
 - Remove unneeded include
----------------------------------------------------------------

Christoph Schlameuss (1):
  kvm: s390: Reject memory region operations for ucontrol VMs

Claudio Imbrenda (1):
  KVM: s390: remove useless include

Eric Farman (1):
  KVM: s390: vsie: retry SIE instruction on host intercepts

 Documentation/virt/kvm/api.rst   | 12 ++++++++++++
 arch/s390/include/asm/kvm_host.h |  1 -
 arch/s390/kvm/kvm-s390.c         |  3 +++
 arch/s390/kvm/vsie.c             | 24 ++++++++++++++++++++----
 4 files changed, 35 insertions(+), 5 deletions(-)

-- 
2.45.2


