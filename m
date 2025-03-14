Return-Path: <kvm+bounces-41083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B1A16A61607
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 17:16:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF8F13A9416
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 16:16:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C097202F88;
	Fri, 14 Mar 2025 16:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pNuyf2p8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C6A18B494;
	Fri, 14 Mar 2025 16:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741968967; cv=none; b=st0oO7/oRUwGwoIPuG2+RKvhq49m5KCEn9IKsk3XXo1sU3UM5tOq996Hw8PxOkeCsuo2p74dyUHefPel4rB8D3+qAt9o39qG2kJ7BGXH1dYSH7k+R4TlsIthuSmDiqRYzDmJhGEjcWE9vUJKcfY+c8+cNAn52IYahTlRKg9Mxqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741968967; c=relaxed/simple;
	bh=iU242pUR+tOyl29TUwZ4IHKiFB05BuJ52voXpXAvJbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sWEsGXf/8hBPJLSb7WgYnn4GIrMs1tdSE0Mfy2gF7ow3dxy+kbwxvttY41ErGLNecaEu7NuJqWM2YzHUL1KjRyUEQgDN/kTOIef6CGQlOKT0viCHxE/XgYcActFnN1n0VTy+nTURKb785BgdKzdXvmKb4GhB2FzLIpfLPVqczK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pNuyf2p8; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52EE3C8T001603;
	Fri, 14 Mar 2025 16:16:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=Mu3YsUhINQ1o0Nq4t7Xd5ejYk2l3dHricOUtdJ3HW
	dw=; b=pNuyf2p8q9wTHn4avcFtlUbSk5qco5ejvjyCcrZT2zuLvlin1vqaUGLjc
	tSlJrQ0tfIJSj6Zn/uK76Tn24bZJQtPa7hCrmLeRFYJd7wzo9NgVnFFrtuRZCg6Q
	5qjoHRiwZS2hBZHNFZaaHDttE1GjUL340PLGb5u6WlDPzBFDxmhsjaKNl70f18xF
	uZS5QKv0cOqm2/Fzu1vWfdRpJAtm0QQT3hL3rdVMVjd51+tYzFvBqSyqbg89PBIS
	brvkr+zNdy5ViwH5o3t0GZF6G56oEmLtkFFFX5cZOAaiAavBh1yIZzlUqW0ZiVtM
	AOSzN1TeW4ahswpd2X2ILULlSAUng==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45cnvqgn9x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Mar 2025 16:16:02 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52ED2qML003175;
	Fri, 14 Mar 2025 16:16:01 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 45atstyq4t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Mar 2025 16:16:01 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52EGFvge15728972
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Mar 2025 16:15:57 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4F31120043;
	Fri, 14 Mar 2025 16:15:57 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E305920040;
	Fri, 14 Mar 2025 16:15:56 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.171.13.224])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 14 Mar 2025 16:15:56 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v1 0/1] KVM: s390: pv: fix race when making a page secure
Date: Fri, 14 Mar 2025 17:15:50 +0100
Message-ID: <20250314161551.424804-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hhyuYQvE3Zw4yaFzgWAjuNO1B3N0lS62
X-Proofpoint-ORIG-GUID: hhyuYQvE3Zw4yaFzgWAjuNO1B3N0lS62
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-14_06,2025-03-14_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 spamscore=0 mlxlogscore=702
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2503140125

ciao Paolo,

please pull this late fix for 6.14.

It fixes a race that in some circumstances can lead to a stall.


The following changes since commit 695caca9345a160ecd9645abab8e70cfe849e9ff:

  Merge tag 'leds-fixes-6.14' of git://git.kernel.org/pub/scm/linux/kernel/git/lee/leds (2025-03-13 22:52:52 -1000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-master-6.14-1

for you to fetch changes up to d8dfda5af0be6e48178b6f4b46c6af30b06335b2:

  KVM: s390: pv: fix race when making a page secure (2025-03-14 15:24:19 +0100)

----------------------------------------------------------------
KVM: s390: pv: fix race when making a page secure

----------------------------------------------------------------
Claudio Imbrenda (1):
      KVM: s390: pv: fix race when making a page secure

 arch/s390/include/asm/gmap.h |   1 -
 arch/s390/include/asm/uv.h   |   2 +-
 arch/s390/kernel/uv.c        | 136 ++++++++++++++++++++++++++++++++++++++++---
 arch/s390/kvm/gmap.c         | 103 ++------------------------------
 arch/s390/kvm/kvm-s390.c     |  25 ++++----
 arch/s390/mm/gmap.c          |  28 ---------
 6 files changed, 151 insertions(+), 144 deletions(-)

