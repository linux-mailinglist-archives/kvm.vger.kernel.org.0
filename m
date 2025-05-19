Return-Path: <kvm+bounces-46974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E502ABBCAD
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 13:38:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD4791763A1
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 11:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29B8D27510C;
	Mon, 19 May 2025 11:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZQw3czxz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE12274657;
	Mon, 19 May 2025 11:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747654673; cv=none; b=rgU71HXWiqY1r0S4Z6tRIbXQvFLhZWvkbqMLSovCKcSKvSf2IOvG1ikzj5V+MKRNB51On6OfevEr8yjYcDmAFLtTr/CKmGzi3ttVXwIfrwwkyWDYZBH8ZKawXje1Eo7EGCJUDl13p971ckKjNvp1y2j6OYYdmInrTpr1W0VLhfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747654673; c=relaxed/simple;
	bh=BjOYZ5eMDuDFUDfOQrRfHFuJXV9suk2SlHZ3XosSVeE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=pwWff06ywvSsKvorbNS/iH6lADypVx1FxJ6gZNYKztxmP63aAT0xX+Prnhd1VI/8gyAzdFuF9Hjt41inUOJi4U08ZM+PevH2HAAfBgOjifDpRqBUkzMMUri0SMkIVZt2+IMw05WhwYSLCkxzvXKiAltmZ0LpqARcwUaVBAVv9+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZQw3czxz; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54J96lTt011883;
	Mon, 19 May 2025 11:37:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=XzUO9GWAhqAPVJpKlbziEV6/5FdW
	sskOYtQ4cTcbUc8=; b=ZQw3czxzCQHSS/SnwtIJ7Ozeqg1UxkwuJCV0RngVdKIx
	OFReKu4pDcswMiR7rCnACfS5BVm8Ie0zJcn+RJXWsX7ErbhEQvgko40geQoOkxKd
	24jnLeo2qK50AHa+zu2P5ZMfoIClO7t9R6HItHGaW0a90ltsQnBbZh3XwsU8lS2W
	B8zcmETR++tOwX18qCU00BheVwJgSoj9e5VhP0DfPBgL++nvLhXRYKHo3FYqMEZc
	VKbodbsVpaWW3V9Z2a9qggZJw0LG8C4uGKzCg6CYJonN+vASswlA5ce4jh7QzRsp
	D5tqfjnNEPZjqzp2kZ0r2dZzHzbwmF1J2xRcvXqUcg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46qn87ub3j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 May 2025 11:37:48 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54JAGcsx002518;
	Mon, 19 May 2025 11:37:19 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46q5snpdsj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 May 2025 11:37:19 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54JBbGJ846596370
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 May 2025 11:37:16 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EC1E2204BF;
	Mon, 19 May 2025 11:37:15 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7D8A8204BB;
	Mon, 19 May 2025 11:37:15 +0000 (GMT)
Received: from [192.168.88.52] (unknown [9.111.40.56])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 19 May 2025 11:37:15 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Subject: [PATCH v2 0/3] KVM: s390: Use ESCA instead of BSCA at VM init
Date: Mon, 19 May 2025 13:36:08 +0200
Message-Id: <20250519-rm-bsca-v2-0-e3ea53dd0394@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKgXK2gC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyjHQUlJIzE
 vPSU3UzU4B8JSMDI1MDU0Nj3aJc3aTi5ETdxCTDVAszE8vE5ERzJaDqgqLUtMwKsEnRsbW1AK3
 SXNVZAAAA
X-Change-ID: 20250513-rm-bsca-ab1e8649aca7
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1809;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=BjOYZ5eMDuDFUDfOQrRfHFuJXV9suk2SlHZ3XosSVeE=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDBna4q+/WXRenVdZou48K/PC+fkbBF+vOPV/RXCjxOYTV
 yxdTpu87ChlYRDjYpAVU2SpFrfOq+prXTrnoOU1mDmsTCBDGLg4BWAid/cxMixZ/Zx7xdzLbd6O
 /H9EDzW/vDaFKdZe9/h57Wrth0Y1DyQZfrO/8r148Emx77V/VusSWXwPXdrt1Mpj9qLLdTb3gvX
 L7vICAA==
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE5MDEwOSBTYWx0ZWRfXzrUNuA8HkmpK v4WGMtGVodhsHd//wzWPRYktkcRE3YVrHQJVz26kaOVpUN55uTi93bbukGB7sQRto6Uc5V3brzA 5UWWxoqPCepZf+LKhJ8reDM/79hEiIhweDdFnispejtjwxQSu5avoW9yH7xTtkozygMOmpZUnLj
 PeQdPpXEqCQLp4twRF/k9Ul7VX+C3kKXMptVU/34/JMMdBN11LRhlRFhvFBH2djdFLJt0zYHtvM UmpmFeBPcXdZlnCLabbyNKnCf588qM1bo2mKB/5imrxbVoX3kZLJOmswOOQsMwOHp+xCMx4UaDE IllVL7exEgEimyQ1VOyl5Fp0ZzpgWbhpW1uOsl8YshZAUWyUj46aeIwzExlJJeKWeystiV3FzXN
 to4QD9P6ih3PR2f2xe+Cb3EFE6m5KpgEMU6zL5SJUkkPxM5q/qCNGzxMvrA3/oiPwbkN/Fnw
X-Proofpoint-ORIG-GUID: 8l3Clqd0MehytZKcdX0NtGoe1yZadxzz
X-Authority-Analysis: v=2.4 cv=ff+ty1QF c=1 sm=1 tr=0 ts=682b180c cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=ydhgtpP_JLF7X-5lMI8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 8l3Clqd0MehytZKcdX0NtGoe1yZadxzz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-19_05,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 spamscore=0
 mlxlogscore=268 adultscore=0 lowpriorityscore=0 phishscore=0 mlxscore=0
 bulkscore=0 clxscore=1015 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505190109

All modern IBM Z and Linux One machines do offer support for the
Extended System Control Area (ESCA). The ESCA is available since the
z114/z196 released in 2010.
KVM needs to allocate and manage the SCA for guest VMs. Prior to this
change the SCA was setup as Basic SCA only supporting a maximum of 64
vCPUs when initializing the VM. With addition of the 65th vCPU the SCA
was needed to be converted to a ESCA.

Instead we will now allocate the ESCA directly upon VM creation
simplifying the code in multiple places as well as completely removing
the need to convert an existing SCA.

In cases where the ESCA is not supported (z10 and earlier) the use of
the SCA entries and with that SIGP interpretation are disabled for VMs.
This increases the number of exits from the VM in multiprocessor
scenarios and thus decreases performance.
The same is true for VSIE where SIGP is currently disabled and thus no
SCA entries are used.

--

v2:
- properly apply checkpatch --strict (Thanks Claudio)
- some small comment wording changes
- rebased

---
Christoph Schlameuss (3):
      KVM: s390: Set KVM_MAX_VCPUS to 256
      KVM: s390: Always allocate esca_block
      KVM: s390: Specify kvm->arch.sca as esca_block

 arch/s390/include/asm/kvm_host.h       |   7 +-
 arch/s390/include/asm/kvm_host_types.h |   2 +
 arch/s390/kvm/gaccess.c                |  10 +-
 arch/s390/kvm/interrupt.c              |  67 ++++----------
 arch/s390/kvm/kvm-s390.c               | 161 ++++++---------------------------
 arch/s390/kvm/kvm-s390.h               |   9 +-
 6 files changed, 52 insertions(+), 204 deletions(-)
---
base-commit: a5806cd506af5a7c19bcd596e4708b5c464bfd21
change-id: 20250513-rm-bsca-ab1e8649aca7

Best regards,
-- 
Christoph Schlameuss <schlameuss@linux.ibm.com>


