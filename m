Return-Path: <kvm+bounces-20944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 24CF69271EF
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 10:43:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 568751C23249
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 08:43:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC95C1A4F1F;
	Thu,  4 Jul 2024 08:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IBHi4v8w"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA701A4F02;
	Thu,  4 Jul 2024 08:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720082577; cv=none; b=gw+fv0jTi0tg7Ahvg+MTI+3aHd/UB2eI06uuPmWcFnVMLaesvTtx+7Ssb49wvJMj6zxNxRDquIZZidux/bOn58CNAx5qMTcx+7dc40UVoGzdHgIQfv9pU5WeZK8MCmig8qtZLheejaUctl6mOdqVnEe3wtcIB7/G5uMfVGnrs5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720082577; c=relaxed/simple;
	bh=AL5tVQpzre6sImi9QzyuR4N8ddgD4VheDM5f0+myMgg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Bkxfxslv3hM+FBsoiUe40CWUj9A3/DpCfowNLvXmAlyc9q8pwMYqkowfO9/dA9qAtn0giFqduruV1GdNGfhp8UeW3iP8dZD8GM4Jm3zI4LFfUIHJFKgCayz90Z/PCy3RnMTlNovyd0OftY84PRoHhkQGpaA7VV2wjhpKXPzqT+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IBHi4v8w; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4646vela015212;
	Thu, 4 Jul 2024 08:42:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:content-transfer-encoding
	:mime-version; s=pp1; bh=PhQeK48jrNkfABg5R1xJlxmR/2oDoUShyRY5EaP
	SXIE=; b=IBHi4v8w4kJuKU8UrJqqA6fx6XNvc9/S33mcIWWbBTCl/hMt2CBGrxi
	oC43v30ClpC4/eUKfhgY9KTAzqITka3Wnqk2gnuRvahQlNNm5vpzwbfFzltFYc1n
	AzUCeUP+o5dLyKkbxMPXqnlisKR2UhuInOfo94dvS7fvBHvYtDwlyCvIC9/30Heq
	St5zKYjaizFFO4lAN/IBHn2wqAApz8yllR5rCot+CUgydiFNtbyTzoSPCUw265F1
	W1JZxU5B0unVlpYsI5YdUPrIe/caMgeVhCSe/0wbrb4l/i1m/lASCuJkpKi47kIf
	dwEWYC4Y6N30bvt8wlFImcGXhQ8etYA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 405pge0bnv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Jul 2024 08:42:53 +0000 (GMT)
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4648gqoE017193;
	Thu, 4 Jul 2024 08:42:52 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 405pge0bnt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Jul 2024 08:42:52 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 46470oY3009154;
	Thu, 4 Jul 2024 08:42:52 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 402w00ydfx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Jul 2024 08:42:51 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4648gkdQ48300338
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 4 Jul 2024 08:42:48 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3AE112005A;
	Thu,  4 Jul 2024 08:42:46 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EDE822004F;
	Thu,  4 Jul 2024 08:42:45 +0000 (GMT)
Received: from m83lp52.lnxne.boe (unknown [9.152.108.100])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  4 Jul 2024 08:42:45 +0000 (GMT)
From: Christian Borntraeger <borntraeger@linux.ibm.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, Sven Schnelle <svens@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: [GIT PULL 0/1] KVM: s390: Fix z16 support (for KVM master)
Date: Thu,  4 Jul 2024 10:42:44 +0200
Message-ID: <20240704084245.13539-1-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.45.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kDjVKll_MG1_fb9pZak7708Xxhfkf9cg
X-Proofpoint-ORIG-GUID: e4gDn0uQr3d3Siwhx8d6NTGHzh9R2RC2
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
 definitions=2024-07-03_18,2024-07-03_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 mlxlogscore=769 spamscore=0 lowpriorityscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407040058

Paolo,

please pull the following for 6.10


The following changes since commit dee67a94d4c6cbd05b8f6e1181498e94caa33334:

  Merge tag 'kvm-x86-fixes-6.10-rcN' of https://github.com/kvm-x86/linux into HEAD (2024-06-21 08:03:55 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-master-6.10-1

for you to fetch changes up to 4c6abb7f7b349f00c0f7ed5045bf67759c012892:

  KVM: s390: fix LPSWEY handling (2024-07-01 14:31:15 +0200)

----------------------------------------------------------------
KVM: s390: Fix z16 support

The z16 support might fail with the lpswey instruction. Provide a
handler.

----------------------------------------------------------------
Christian Borntraeger (1):
      KVM: s390: fix LPSWEY handling

 arch/s390/include/asm/kvm_host.h |  1 +
 arch/s390/kvm/kvm-s390.c         |  1 +
 arch/s390/kvm/kvm-s390.h         | 15 +++++++++++++++
 arch/s390/kvm/priv.c             | 32 ++++++++++++++++++++++++++++++++
 4 files changed, 49 insertions(+)

