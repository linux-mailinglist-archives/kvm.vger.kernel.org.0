Return-Path: <kvm+bounces-34790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 82B75A05FF8
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 16:24:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 816FC166C91
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 15:24:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 653AA1FE472;
	Wed,  8 Jan 2025 15:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ml2bhC1/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D14B644;
	Wed,  8 Jan 2025 15:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736349839; cv=none; b=aicMk0RIAPpIYTisoNqv7vNv6VnEUiWJvS5TbzFZqNhB6MIr+pMbTh7fAX4JnDGfmCoj/67Eb76mNwREdTNMuaHWqH0t1xBbBJJf6qZKaAWCD6UC34Bc3v4jE/+9Uw5HUfWbRlmV+O6Oqdb6zFzZEgrz8pkLeps8jg64ilBpdHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736349839; c=relaxed/simple;
	bh=YHre15BBQYfblvXMEh+DGJl85CZlh1RdGUCI8R/3DpY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h/Fry4dFyhlL9/fa+oieZqbP7boel+XimqAMeAOqlLgHmH9dxJd5hRYX6rJN0BzueyDCCxxA5iXJSq3gU+QKE1u7SEr068c/eN34kT9H7QSE3FRZCrQSeMVsD9ntbbfh6zbn4KCo7V9NfX1gXkLohHXlPj1PRjuVrrWZxyjVAjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ml2bhC1/; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50886DIq022826;
	Wed, 8 Jan 2025 15:23:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=iYqc55MzCq7FynYrf0qlaNPTW4RMx7hlk44ldf/we
	8A=; b=Ml2bhC1/IXVeTiY+d13DYNxELtc80pZIUoorErvoq+BywHVqYLh7nrsMx
	KeBOQ9mczU9EWsgmGKZwzazdrIrjs9fhD9wpCiB0VjcW0STo13/fodYYw9Jqb8KI
	sSCKeJuiElYoMPjjwfVkqBf9L4NCOt+h2suAiICTy780UWNr60aUeQRD2RXWGJ7P
	1VhSqJGR26HuC5u/ifAjqArmmgGtW72/31vi7EAuYm4YnZrOLuzgRjCgxR7QijQK
	hhA/S0z5GO1JjoZTzSumD8Kz1L+UFQWXSnIe1rKck2kZ86SZtF4XWXuF4pDuJ5ww
	c5vkS0+Ml/bB7G2OYo5PhaZ97Q9hA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 441nj39yk6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 15:23:55 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 508DqX4L015795;
	Wed, 8 Jan 2025 15:23:54 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43ygtm083f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 15:23:54 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 508FNoEq51184066
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jan 2025 15:23:50 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AA2B52004E;
	Wed,  8 Jan 2025 15:23:50 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8A87520043;
	Wed,  8 Jan 2025 15:23:50 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Jan 2025 15:23:50 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v1 0/6] KVM: s390: three small bugfixes for 6.13
Date: Wed,  8 Jan 2025 16:23:44 +0100
Message-ID: <20250108152350.48892-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FK8WfQ7OFsmDn1Ps3TQBBFApGyy7mWvS
X-Proofpoint-GUID: FK8WfQ7OFsmDn1Ps3TQBBFApGyy7mWvS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 clxscore=1015 adultscore=0 impostorscore=0 mlxlogscore=832 phishscore=0
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501080125

Ciao Paolo,

please pull the following fixes for 6.13

sorry for the holiday-induced lateness :)


The following changes since commit 9d89551994a430b50c4fffcb1e617a057fa76e20:

  Linux 6.13-rc6 (2025-01-05 14:13:40 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-master-6.13-1

for you to fetch changes up to e376d958871c0eeb7e97cf95655015fc343d209c:

  KVM: s390: selftests: Add has device attr check to uc_attr_mem_limit selftest (2025-01-07 16:36:11 +0100)

----------------------------------------------------------------
KVM: s390: three small bugfixes

Fix a latent bug when the kernel is compiled in debug mode.
Two small UCONTROL fixes and their selftests.

----------------------------------------------------------------
Christoph Schlameuss (5):
      KVM: s390: Reject setting flic pfault attributes on ucontrol VMs
      KVM: s390: selftests: Add ucontrol flic attr selftests
      KVM: s390: Reject KVM_SET_GSI_ROUTING on ucontrol VMs
      KVM: s390: selftests: Add ucontrol gis routing test
      KVM: s390: selftests: Add has device attr check to uc_attr_mem_limit selftest

Claudio Imbrenda (1):
      KVM: s390: vsie: fix virtual/physical address in unpin_scb()

 Documentation/virt/kvm/api.rst                    |   3 +
 Documentation/virt/kvm/devices/s390_flic.rst      |   4 +
 arch/s390/kvm/interrupt.c                         |   6 +
 arch/s390/kvm/vsie.c                              |   2 +-
 tools/testing/selftests/kvm/s390x/ucontrol_test.c | 172 +++++++++++++++++++++-
 5 files changed, 185 insertions(+), 2 deletions(-)

