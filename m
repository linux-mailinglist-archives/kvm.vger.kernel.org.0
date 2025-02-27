Return-Path: <kvm+bounces-39568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 63123A47E94
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 14:10:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 47B2B7A3195
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 13:09:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C50C22F39C;
	Thu, 27 Feb 2025 13:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QhLAkZrp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2A121ABBE;
	Thu, 27 Feb 2025 13:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740661812; cv=none; b=OJg5EjuVkGcWTTqsdzu7pM6fV6m9LZxNLICPkJQVsTK0d3zJ/SbZ06rfaF1MLvuZM5aEiU8brhnjlrT4wIlpq2cJP+Y+1rxrSXNdIebvxRrooVGNlfnaUyvF1GdjJ5cTo7JxJMsI1SdfO+r5fjl8NLrRvgjqGRPf6augtBYJ80E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740661812; c=relaxed/simple;
	bh=iPvFzfHv+HaNq9V4wJmNEOwKFfb6l7kprXjTDtXTkPI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M8aVHW6NWhtk1/lxO1ZkwmkHsCs7bZYSrNIhK9Cqt/iv995EfpwhnqIXWPAL373ikHLP+kwISu1Rz2TdMbvbRlXK1w5FaIOq1jkN13H9WvVHC+CqPevIgOa+lf938K5sZVk2zLO2FHwFKGC50LO5KTsTYYSVORoSU9/YT7KfZnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QhLAkZrp; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51R5Nvs8019668;
	Thu, 27 Feb 2025 13:10:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=djq0q+esNrh+kOSfQi0l2ic8Sep7q3DI+XN3MAExA
	Ds=; b=QhLAkZrp79RMZEdk1Q/6m+3p25/57zvAgWIBx7UHmHz63UaBytHKDBA14
	iPEhxuNOptvTTOM/Dxy6sP81sfdy2l17pSCzCEWhOJK8f2tSMU26cob/fwJP7cXY
	Gju7c14H4oubPyhHMfnIvHHj/bFxOERMFSRcPfIGSpxAU8oSl9GgbLWAQS+eqn6s
	zyE0Urd3GCx8TPP/xedhabDtN65eYDEY5rqLG5Dop/ae0Xl4pNDrWDN/6g/IeyRQ
	CYwPnDJ8ke0LCffhrSpUcU/jPnwk71rJI+0XHAwTScwfD74blMG+m/HOfjs5VHDN
	TbKY9ApPOe0FXYFFXkI6ikqidINCw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 452hv8t51p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Feb 2025 13:10:07 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51RBZw96012741;
	Thu, 27 Feb 2025 13:10:06 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 44yrwt0ynm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Feb 2025 13:10:06 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51RDA31N33227066
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Feb 2025 13:10:03 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 319F620043;
	Thu, 27 Feb 2025 13:10:03 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8BCD720040;
	Thu, 27 Feb 2025 13:10:02 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.171.9.246])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 27 Feb 2025 13:10:02 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, david@redhat.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com
Subject: [PATCH v3 0/1] KVM: s390: fix a newly introduced bug
Date: Thu, 27 Feb 2025 14:09:53 +0100
Message-ID: <20250227130954.440821-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: omlANLICp4pbfohSvFTLFyMzRNiayfA3
X-Proofpoint-GUID: omlANLICp4pbfohSvFTLFyMzRNiayfA3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-27_06,2025-02-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0
 impostorscore=0 mlxlogscore=529 priorityscore=1501 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2502100000
 definitions=main-2502270099

Fix race when making a page secure (hold pte lock again)

This should fix the issues I have seen, which I think/hope are also the same
issues that David found.

v2->v3:
* added check for pte_write() in make_hva_secure() [thanks David]

v1->v2:
* major refactoring
* walk the page tables only once
* when importing, manually fault in pages if needed

Claudio Imbrenda (1):
  KVM: s390: pv: fix race when making a page secure

 arch/s390/include/asm/uv.h |   2 +-
 arch/s390/kernel/uv.c      | 107 ++++++++++++++++++++++++++++++++++---
 arch/s390/kvm/gmap.c       |  99 +++-------------------------------
 arch/s390/kvm/kvm-s390.c   |  25 +++++----
 4 files changed, 123 insertions(+), 110 deletions(-)

-- 
2.48.1


