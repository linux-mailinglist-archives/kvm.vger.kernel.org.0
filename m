Return-Path: <kvm+bounces-47859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43FADAC6575
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 11:15:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF8653A8665
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 09:14:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C8212750F0;
	Wed, 28 May 2025 09:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oUzVzA5B"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5ACC274FFC;
	Wed, 28 May 2025 09:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748423698; cv=none; b=iT/TVGh9rnlKFANa+WDKyh0UR630JcMbdnfxJnW4fn+lo4fL1FQTbhhwJMuvfQs+AmY/rvvCzeyCq4YVoqzkI/+aw0HeKnbqthDj5qpjdLrNtDNiycBdJqKiL6XAWPDMO6zh+NPK//+P4LwZKqljOylOEse3x/1Fx2yCkdiC8hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748423698; c=relaxed/simple;
	bh=7Dk3zmErUKZlJgxAcY+StxJwW4GQveQR445ku3WDVjw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cWLuUcf+gvR8PAc1hbd5lnI0nQnp216yVhTPIOjKw0z+Kk7dwsLa5YVyK12LapVPIzRVF8uaivWGwdLpVmQ6TaNZ7zahjQKVjchcm+UYhbL957EgHPNgmu7e9rHtOMcCSqTSemjwhj5MqtbLvZhdepV0IjpBVPEe076bKGNabXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=oUzVzA5B; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54S8ebuq003189;
	Wed, 28 May 2025 09:14:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=9ALM3yCJhqSPs4OCeRMCLjrqPRQIc90Ugcj/JJP3W
	/4=; b=oUzVzA5BZJzhxx/TZtE/qeWQay/C+GgeMoMYXzEsNseC3NvVaR5/X60WR
	nY2KyuWR0hrvG6JEOZXyv2184f7nJM+xwhEmGiS1nBkcLG3k3Aw1PwOAfEMXKQxF
	pqXnp7RqqxtAjfOllHcGrzu9Q9kjfOaCwUSfUKbKCwndms5Yx0r/633e79bpa9R1
	0ZB5gGjY5wVeJ3lYWb48jOrkHIO23kFCpIMuvoKHxv16I7DhiNFXJDzo1yE0MhGB
	o0ftjPOx3YlKQFuNJthlrdy8XiscDU4WoE+1nYqHBL5lFf7RWkqJJs0rfNMNMJHn
	Kz69dLh91yV9XMcB+aXZoKwXCSFzQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46wy69054f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 09:14:54 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54S62EHS016212;
	Wed, 28 May 2025 09:14:53 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46uru0px8v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 09:14:53 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54S9EnSW23134472
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 09:14:49 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7447720043;
	Wed, 28 May 2025 09:14:49 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 33BBA20040;
	Wed, 28 May 2025 09:14:49 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 28 May 2025 09:14:49 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH 0/2] s390x: diag10: Fixup
Date: Wed, 28 May 2025 09:13:48 +0000
Message-ID: <20250528091412.19483-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=UP3dHDfy c=1 sm=1 tr=0 ts=6836d40e cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=dt9VzEwgFbYA:10 a=YbkSLyDRy1wxu5pb_RcA:9
X-Proofpoint-GUID: oBiJ6PvbGtXnDGns6I46HKfi0SsKEyen
X-Proofpoint-ORIG-GUID: oBiJ6PvbGtXnDGns6I46HKfi0SsKEyen
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDA3OCBTYWx0ZWRfX42yw3zAH5dAI HzNw/DEVa1Pgwq7tG0vRFElbhbqwBZdpqfELlhIKDdy+bLpVnHHR7/PP3fxcOXpF2AY8XPPdFWj 2o+aWowMit5OjzU/QW1wHs1JtuLDU3rbS9oBRgfpMCdfVbC9EOpY6uS3E4pg5BATqkxEkGnWAla
 OQJJtyHV3cOJYqSZKY4EbIXu+cI1m0oOZw0JyZCsNc4U51ydgRFuCMz9PEdPgDm7UgcXMocaC8/ RGkPX4KUjHSoaxqA9gN3+jpMvP4sg/yt89lSZH3ZAToK6Eg7/F0Iaq7t/2fbAemHEuhgVxIvqY4 G5mw32dnr47+MeLoDmgugUW5U7BE2JJ7fQA2pRqhRmDpt0QRHAQbhU/JHxaHj0bhNbJat63pJgY
 GSr+02KdLUh6zIIa0Nb1aooS3tR7HWBaUOX1OgaqBPvJeucMDDEi0xOYi2ONvxHovponeZfa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-28_04,2025-05-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=835 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 spamscore=0 mlxscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505280078

While reviewing Claudio's patch set I found a problem that should've
been caught by the diag10 test but wasn't.

Not only does the test never check the good case but it also doesn't
fence against environments where diag10 is not available. The part
that makes this problematic is the fact that this test only tests priv
and spec PGMs. These PGMs are presented even if no diag10 support is
provided since they are also part of the base diagnose architecture.

The tests currently succeed in TCG emulation and PV, both of which do
not implement this specific diagnose.

Therefore this series fences TCG & PV as well as adding a check if the page has
really been cleared.


Janosch Frank (2):
  s390x: diag10: Fence tcg and pv environments
  s390x: diag10: Check page clear

 s390x/diag10.c      | 26 ++++++++++++++++++++++++++
 s390x/unittests.cfg |  1 +
 2 files changed, 27 insertions(+)

-- 
2.48.1


