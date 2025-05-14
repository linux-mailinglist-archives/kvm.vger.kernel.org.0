Return-Path: <kvm+bounces-46517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 113A2AB718E
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 18:35:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D3A8179700
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 16:35:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDA4E27FB16;
	Wed, 14 May 2025 16:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DTV4eb4t"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E096C27A905;
	Wed, 14 May 2025 16:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747240509; cv=none; b=TnjK3XX8I3gayLRPBvgv1fgsM1XZ6Rbe0hK8gqpUmHAIVNLGOHUpB0S/9hGjdNdKi2BnJWhV7/7STuWWap1xKoiDTS0g4M9Q2YJBIokk8CUHR0hwwz/D+az8uObwKbWlct3Y2z0VU1eup+fCn90PK4oe1icX1/7MSLvngJHaCQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747240509; c=relaxed/simple;
	bh=RCqJNYx2ZDaVy1cin3D5+VChmt+ibOrvS4bE4ZOiIxc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tYLiK9sCJ66HeqiudZsf1y7b7tDP7IqK1hWt4hPbPWOEvV/3TLgqIFfeB58SJHISIMZyi2iYWswosDEBl1OS9JmPJtkh5WqkwMM7IPOuJZo6V6nWwf4F90Zkt1Z1lFGLNwMh50seeQ8HD17QD6EMUYFUj3+Nz3gwFSnuzT/ddEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DTV4eb4t; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54EEwfIT025706;
	Wed, 14 May 2025 16:35:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=kUWtd4WmdpJPY2SO2bgORN/x+TZR
	rN/VujhFkZdhMEs=; b=DTV4eb4tLMRofHDhq/qX9bWjNCcWZSmNI3eRqG2LEzEY
	43NVmC/KzoqpRVeK1Ozkt+2htQtV5fv2Z+6VASTmNa0pQX0x8iWrJBICQGowwbk9
	oSrTll+62YhaOdP4dTUIEJCgYqKmXO0/hQJYWm+ArhkbTS3KlRhmR8XA8Sjjk7M5
	Pc3XlvFYXFuqyvSBhHSipPq8OVImB/kCtT9bdHRAjRM0jQfUvqvdlA8Uql0fjeOo
	YbYTJSPyY++FmvZaAn0hGTHC1k5hlTh+1GUnM9CUDk7MV7/UUdY/KlhXVSnPIXyB
	WPkLKelxvg9SE/a4I9BfGhQC5ngZ+IyUoK8PcLgYmg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46mnst32br-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 16:35:02 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54EDfCTX026912;
	Wed, 14 May 2025 16:35:02 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 46mbfpd91e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 16:35:01 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54EGYw5j59113868
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 16:34:58 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 70C532008D;
	Wed, 14 May 2025 16:34:58 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 038932008B;
	Wed, 14 May 2025 16:34:58 +0000 (GMT)
Received: from darkmoore.ibmuc.com (unknown [9.111.91.37])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 14 May 2025 16:34:57 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: [PATCH 0/3] KVM: s390: Use ESCA instead of BSCA at VM init
Date: Wed, 14 May 2025 18:34:48 +0200
Message-ID: <20250514-rm-bsca-v1-0-6c2b065a8680@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20250513-rm-bsca-ab1e8649aca7
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iCQMRV_jecWIpZfbzex3nd1ZaS93FkOf
X-Authority-Analysis: v=2.4 cv=V+590fni c=1 sm=1 tr=0 ts=6824c637 cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=ZXmyin5w7QkRfgh2LRkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: iCQMRV_jecWIpZfbzex3nd1ZaS93FkOf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDE0MyBTYWx0ZWRfX6VPsqind2AbL BfhanctLkh9EHTr/U2h6MCNZODbKxVhJzLfXYevWMFgXyoXVY8gpbfdBoF6nAx5cjoGR3mL7JqM JxzGBGAuyKSjPIhIFMK9yjrZ5LIoLrn33kSgWdKp1DX65cABR93bCAc+PemgXuBpeWEnoZku/tn
 dzfmqKjZrA/214Fmxgw3j82S6+IvE8UJGv7xFHmnOlLwUUTqBWHAJTAhL6HPyiNtZ8MfIox72xL vg1yvszXztthUO5713P2dX+9ZbZSulAJJJHetbVuyrS0X5iTPYprwJDfJombL4RAgPpjsdgLmQa AJxfp3u8KVKAx1TienR+aI7XRpczMUmVEb77dPgeyQNsKySem0WUGzlutGzewymCR1tioyoGXdC
 BJiYfh3ITBRxL4NQy9TNfmCQGkHyn6CKBfktvZgDuU6W4WrkdulQG9KMDcak/mhizN/sg88x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_04,2025-05-14_03,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 mlxlogscore=415 lowpriorityscore=0 bulkscore=0 suspectscore=0
 impostorscore=0 malwarescore=0 phishscore=0 adultscore=0 clxscore=1015
 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505140143

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

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
Christoph Schlameuss (3):
      KVM: s390: Set KVM_MAX_VCPUS to 256
      KVM: s390: Always allocate esca_block
      KVM: s390: Specify kvm->arch.sca as esca_block

 arch/s390/include/asm/kvm_host.h       |   7 +-
 arch/s390/include/asm/kvm_host_types.h |   2 +
 arch/s390/kvm/gaccess.c                |  10 +-
 arch/s390/kvm/interrupt.c              |  74 +++++----------
 arch/s390/kvm/kvm-s390.c               | 161 ++++++---------------------------
 arch/s390/kvm/kvm-s390.h               |   9 +-
 6 files changed, 57 insertions(+), 206 deletions(-)
---
base-commit: 82f2b0b97b36ee3fcddf0f0780a9a0825d52fec3
change-id: 20250513-rm-bsca-ab1e8649aca7

Best regards,
-- 
Christoph Schlameuss <schlameuss@linux.ibm.com>

