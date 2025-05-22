Return-Path: <kvm+bounces-47357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DE95AC08C5
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 11:33:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9721A7A36A5
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 09:32:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E171D268C55;
	Thu, 22 May 2025 09:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bK+Ol6Ys"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844E1CA52;
	Thu, 22 May 2025 09:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747906396; cv=none; b=dszlq6el0LquThEL2iWogW55iBbRxP75BPvsuNjLKdVbR0JTXZWQoWlNmTdasEw+LGgdGixA7KMi/bcO2y/MJYqnCtBgaGb4+UGbeDZKYzcLSd1RbMo8gIQlV2+wmyjci2xKsBVwrcbQGOVChiSWU698dD8Tp2KE34/miufNnG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747906396; c=relaxed/simple;
	bh=8tQ+M52rkSqrJ0/6EBuiT6vdxhRbbrpkDty23nOA0wI=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=tl/6Gc+dZiN7YSlfX2imsQ8wYvwl7xKOH31Fd4hI7Uws1w8yL0lrLLye6srl5npdDzlKiPJZSNFas1uOVSFNScowluTBG8ihuqYj364H2pbFXNV67KOn0rjql2YDCtPgQ1YFxT7KbzZq6BTunrhq+Uibrv/Ouxzj/0Bnrw+fl+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bK+Ol6Ys; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54M8lWfJ008553;
	Thu, 22 May 2025 09:33:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=jrXq+azAqF7DQ5VBPRTpJZ7u5qnL
	UqYv80NBocRJpYQ=; b=bK+Ol6YsQbc6uu62vhhQkepE24XOcZITWbLTL0WwilLn
	xVNfmanoo89dV3BwEoHJP8jdmFeNey5SBiCmAVD3QQABTXztEgHAEs1aBXPzYqI1
	zx4IlUgJgvr6XuT7iAi2u6vE/DeaYJB9i60Ev70zUdj+BftdKSsM4E5eD3o0uXGw
	lCMVmOmNGSV7wegdyBplIYjDzheJz6NljlAhBUM49VFLl4vfUwHU3e1SLwHDwWbP
	EU1WZOo8KO2Kj5u5BhOizzupeZEl2obHL/qw2kQ6TnvY/VM8rJ8d+LccO025u9zO
	S2jWIskb7uvV4K4GNCKO4bgUFphuYfx+Hidu10i6rQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46sg234ur7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 09:33:11 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54M5ShJ4020713;
	Thu, 22 May 2025 09:33:11 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwkq0tcd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 09:33:10 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54M9X7iA50921754
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 09:33:07 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 273D32004E;
	Thu, 22 May 2025 09:33:07 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CB5092004B;
	Thu, 22 May 2025 09:33:06 +0000 (GMT)
Received: from [9.155.210.150] (unknown [9.155.210.150])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 22 May 2025 09:33:06 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Subject: [PATCH v3 0/3] KVM: s390: Use ESCA instead of BSCA at VM init
Date: Thu, 22 May 2025 11:31:56 +0200
Message-Id: <20250522-rm-bsca-v3-0-51d169738fcf@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAzvLmgC/12Myw6CMBBFf8V0bUkftIIr/8O4mJZRJhEwrTYYw
 r9bSHzE5bm550wsYiCMbL+ZWMBEkYY+g95umG+hvyCnJjNTQhlhpOah4y564OAkVraswcOO5fc
 t4JnGtXQ8ZW4p3ofwXMNJLuu7UX4aSXLBrVdOWAOVrcThSv1jLMh1hR86tnSS+nXrr6uyixrB6
 KYRui7/3XmeX+0Fq9XeAAAA
X-Change-ID: 20250513-rm-bsca-ab1e8649aca7
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2331;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=8tQ+M52rkSqrJ0/6EBuiT6vdxhRbbrpkDty23nOA0wI=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDBl674NWsHP+XPPFwuibTKpQglTzb9ew++p1er8V+LdYL
 nrJ1t3XUcrCIMbFICumyFItbp1X1de6dM5By2swc1iZQIYwcHEKwETuBTAyvMy1fTc1/2xn2dr4
 u6/Wnpx2xtxs0VqJ04cP1Ee/C3N0P8TI8O2Ho/q1iT2/tuc+1/jW16ui6VXHvf3M7Dim4/17Fux
 5wAwA
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EAbtsl58EgBDN9f9o6rl6LbBYjp6xl1W
X-Authority-Analysis: v=2.4 cv=RPmzH5i+ c=1 sm=1 tr=0 ts=682eef57 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=VArqnPT4Db3YZojHL3MA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDA5MSBTYWx0ZWRfX5cZN3BD3FmKL OkRu98LK2Sb/9iFlGUQVxTYneZfv1MFKp3PBAFWAsjfUGEU5WrAX9W2vUsmM9WEpasDPtBlNbAh IglIM7z+z76g0fGCLEu9hmyhI3Y6bO47bHKosRvoxXbcYYv5dVpndEHuVyh2ToSYIQ7xRJO/sPJ
 0A3RNaPEq5s2rcOKWaomHYUwaPSSfx0Y9LkMt8v9ueUvBvGzXov9fkYbo5u9btSnr23vURTLl9o 2CgAbRKIeDx6fT40PY3HqdtNgqcxa6+BQkvfEyhxyYgeGBDETg+0KkIc5VcekUjI+0mZqJNLDgj ikh2NYuqx1GXk+Zy/0XOat9dt48YRvdNsIMS6WVD1cnvQEv6W7yYMw5WsrOOj4J1DbFToC5aUtW
 wDXgBfuXOLRfBd1LqzQbZ4rPDpVh+KzaA/3MBFKz+crnmdn6iCRoYV2zCTzShiqErOEiO5ic
X-Proofpoint-GUID: EAbtsl58EgBDN9f9o6rl6LbBYjp6xl1W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_04,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 adultscore=0 priorityscore=1501
 bulkscore=0 phishscore=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=448 suspectscore=0 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505160000 definitions=main-2505220091

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

---
I found a slight problem when testing this to run without sca entries.
Fixed now and tests are successful with and without using the sca
entries (incl. vsie).

Changes in v3:
- do not enable sigp for guests when kvm_s390_use_sca_entries() is false
  - consistently use kvm_s390_use_sca_entries() instead of sclp.has_sigpif
- Link to v2: https://lore.kernel.org/r/20250519-rm-bsca-v2-0-e3ea53dd0394@linux.ibm.com

Changes in v2:
- properly apply checkpatch --strict (Thanks Claudio)
- some small comment wording changes
- rebased
- Link to v1: https://lore.kernel.org/r/20250514-rm-bsca-v1-0-6c2b065a8680@linux.ibm.com

---
Christoph Schlameuss (3):
      KVM: s390: Set KVM_MAX_VCPUS to 256
      KVM: s390: Always allocate esca_block
      KVM: s390: Specify kvm->arch.sca as esca_block

 arch/s390/include/asm/kvm_host.h       |   7 +-
 arch/s390/include/asm/kvm_host_types.h |   2 +
 arch/s390/kvm/gaccess.c                |  10 +-
 arch/s390/kvm/interrupt.c              |  71 ++++----------
 arch/s390/kvm/kvm-s390.c               | 163 ++++++---------------------------
 arch/s390/kvm/kvm-s390.h               |   9 +-
 6 files changed, 55 insertions(+), 207 deletions(-)
---
base-commit: a5806cd506af5a7c19bcd596e4708b5c464bfd21
change-id: 20250513-rm-bsca-ab1e8649aca7

Best regards,
-- 
Christoph Schlameuss <schlameuss@linux.ibm.com>


