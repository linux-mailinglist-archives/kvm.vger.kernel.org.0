Return-Path: <kvm+bounces-20903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 71DFD926567
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 17:59:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2CAB6283844
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 15:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BB80181D08;
	Wed,  3 Jul 2024 15:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZH9LVJF+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03341181BB2;
	Wed,  3 Jul 2024 15:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720022352; cv=none; b=IKnMEHfpNo78X5jBKo6tk3jrPsHgYzNGg0DrcU43BU05n8EUgpM+2HtX1McBycbcD2MsC9wvB5TQsVSQ3nu1XVOtAkUL4SGabv67dHxTw9PeQ1L3o7pEg2EcmG3Q2uFD30k6qp3KR+W8yvuGviJZfDgbJdm+nl51lvUb5wDcjfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720022352; c=relaxed/simple;
	bh=tZyD6Xx1n+OAFzAFajF4ISyU0KwuRVTyRqF7+x8l7T8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EkoluqgC06xxV5uIFzxF0BZISmB+zVu/1Vp3NSBk2Bo7/QXjhWXlW3vjnE+56C8c86ShctxxWYBen2eTONs/3RKF0EnA/19qUheSmyifAJb+OlRnYLC9puaugG9vwFQCeFrj+cLjGpsSk27ihs2ZuTYDPGMB4ca8TeEKmTZYWvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZH9LVJF+; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 463FSENA004150;
	Wed, 3 Jul 2024 15:59:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=pp1; bh=uIxMlxYR2vIYf0wv1QKF0fD6iZ
	fT3HlePHGoukvMi9U=; b=ZH9LVJF+vj/eddwRLxnILzkTvUAU+S6oh+XvDLqoc1
	MjZomNmG8q95yooGzudCWS4nw2r4lC+HrivSH+2yq3xGyUSFvgt5KfKLcMrR/lak
	wvpBmYiVBYbQQMGEThCSlET8dxpdWEdphne0cdOvhGJpTPti3t7lyffKk7S4n/2h
	n28uM5o0TAjo0zpp2PY+PN7ngMGx3Uv/FG+76l+W9W9dB/ZeFAMFWVjkryLG3m5D
	zTfF30A+axTanCw9YXDpGQYPNB4SHM9Mpy/zaopyGf+cosvbqYxNM5/wSFH3M/hc
	ONzNSD9j0vGS4MXjaxlQS0C5mml3xrZ4UI0thrp533oQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4059agg2nu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Jul 2024 15:59:08 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 463Fx8Ap020668;
	Wed, 3 Jul 2024 15:59:08 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4059agg2nn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Jul 2024 15:59:08 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 463FCClR009076;
	Wed, 3 Jul 2024 15:59:07 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 402w00uh62-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Jul 2024 15:59:07 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 463Fx1tv17826192
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 3 Jul 2024 15:59:03 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2D6F02004D;
	Wed,  3 Jul 2024 15:59:01 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C55CE2004B;
	Wed,  3 Jul 2024 15:59:00 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  3 Jul 2024 15:59:00 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, hca@linux.ibm.com,
        svens@linux.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
        nrb@linux.ibm.com, nsg@linux.ibm.com, seiden@linux.ibm.com,
        frankja@linux.ibm.com, borntraeger@de.ibm.com,
        gerald.schaefer@linux.ibm.com, david@redhat.com
Subject: [PATCH v1 0/2] s390: Two small fixes and improvements
Date: Wed,  3 Jul 2024 17:58:58 +0200
Message-ID: <20240703155900.103783-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LFu_ieGu6G489M7TBsIpI6YXxn1nIgJI
X-Proofpoint-ORIG-GUID: s-NHl-JSOxK9KlakjyTWYoj7H4PCM_Vd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-03_11,2024-07-03_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 impostorscore=0 phishscore=0 mlxlogscore=374 suspectscore=0 adultscore=0
 clxscore=1015 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407030118

The main goal of this small series is to do some clean-up and remove some
paper cuts (or at least clear the way for papercuts to be removed in the
future).

Heiko: this can go through the s390 tree, as agreed.

Claudio Imbrenda (2):
  s390/entry: Pass the asce as parameter to sie64a()
  s390/kvm: Move bitfields for dat tables

 arch/s390/include/asm/dat-bits.h   | 170 +++++++++++++++++++++++++++++
 arch/s390/include/asm/kvm_host.h   |   7 +-
 arch/s390/include/asm/stacktrace.h |   1 +
 arch/s390/kernel/asm-offsets.c     |   1 +
 arch/s390/kernel/entry.S           |   8 +-
 arch/s390/kvm/gaccess.c            | 163 +--------------------------
 arch/s390/kvm/kvm-s390.c           |   3 +-
 arch/s390/kvm/vsie.c               |   2 +-
 8 files changed, 185 insertions(+), 170 deletions(-)
 create mode 100644 arch/s390/include/asm/dat-bits.h

-- 
2.45.2


