Return-Path: <kvm+bounces-27286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 029CE97E5F9
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 08:28:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE3F5281348
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 06:28:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D159E18044;
	Mon, 23 Sep 2024 06:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tVss2vLv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6153312E4D;
	Mon, 23 Sep 2024 06:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727072910; cv=none; b=ZfnD6xqorSxCsmuBCsAAGO8ioQhmK02Hs4twfli9ZHjQDrWsyJ0GnV9WV9XdEZuj2M7o/8JMUDNlXh3n0C5WEAzsTulCK6TNXH/Ei8MO1sH5vqY647k37lCtH0RgFR32zkF0h4Sh/tyavnS/tmoxoj0oj78oxnP3pwWW+J8aC58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727072910; c=relaxed/simple;
	bh=pjhCmGmTppj0WMKX6XNf278JGytRcmbojnzMZizT0/c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BH7bI3qhKqizY70fKmj4YcijvxKCgd5iKqm9EEIX6+cYwetsjxVgFA16Df6gOeLgeSZtRjPBQTG/rNGuGfyUmYl5qyeCin72Eh8ery7YTTuYEjzD5qLEAxhiVJbgXCnrVruOMpQs5EjiZ7U0aCAbIgi5nqiBju8RBq9hhDELmcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tVss2vLv; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48MBvY1d021322;
	Mon, 23 Sep 2024 06:28:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:content-transfer-encoding
	:mime-version; s=pp1; bh=MR/drjJfS16d4os3nKm5aDSfh9rmPbHsXFnNcfD
	8MgI=; b=tVss2vLvB8tHzp61QKMrYNNVqZcx/0Ei6Ux1H5gbFTUjZwgYmPKq4+B
	9q5DU8kHWK0Zz+6K9oyw+hHyu0EQs8adTSRFXoffRB0zBsoYUDXfPEbftybCdrb3
	pBGfYCGxgeSKGfRB4BP7GLFZ/M55b1yA+Apvbl6G/LioZvBWosaRjJMsszJCt/cj
	R3i+EqFoxSn/Y9IxQjIeC4gvC4Qur+j7p6PBhssIM+pE6Dfgiz84xc3Zz37gHc5i
	Ax5HZAXKEJZta5HDd5zLdoqHy64Mkh+qmIsnWWtyqR367SyE7grNR6/HKHttpJar
	KNyYL8SDUz57mp+yPNCxkk7ByJ72AvA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41snvasw60-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Sep 2024 06:28:27 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 48N6ReFU020170;
	Mon, 23 Sep 2024 06:28:26 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41snvasw5v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Sep 2024 06:28:26 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48N3qEAm013953;
	Mon, 23 Sep 2024 06:28:25 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41t9ymmtfr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Sep 2024 06:28:25 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48N6SLQK27919048
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Sep 2024 06:28:21 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4EC802004B;
	Mon, 23 Sep 2024 06:28:21 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1106720043;
	Mon, 23 Sep 2024 06:28:21 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 23 Sep 2024 06:28:21 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 0/2] s390x: add tests for diag258
Date: Mon, 23 Sep 2024 08:26:02 +0200
Message-ID: <20240923062820.319308-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.46.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Upywq_T4D1irTwdr0Orcn_JPdVRmiAfq
X-Proofpoint-GUID: UDwvgbGkJCYelAXmgQLqreLCk3O4tUrG
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-23_03,2024-09-19_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 spamscore=0 mlxscore=0
 adultscore=0 impostorscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=470 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409230043

v2:
---
* do not run test under TCG

Add tests for diag258 handling on s390x.

There recently was a bugfix in the kernel:
https://lore.kernel.org/r/20240917151904.74314-2-nrb@linux.ibm.com

This adds tests for it.

Nico Boehr (2):
  s390x: add test for diag258
  s390x: edat: move LC_SIZE to arch_def.h

 lib/s390x/asm/arch_def.h |   1 +
 s390x/Makefile           |   1 +
 s390x/diag258.c          | 258 +++++++++++++++++++++++++++++++++++++++
 s390x/edat.c             |   1 -
 s390x/unittests.cfg      |   3 +
 5 files changed, 263 insertions(+), 1 deletion(-)
 create mode 100644 s390x/diag258.c

-- 
2.46.0


