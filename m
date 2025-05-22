Return-Path: <kvm+bounces-47360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C761FAC08CB
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 11:33:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 66A247A2F0D
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 09:32:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B13A267F5D;
	Thu, 22 May 2025 09:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mK0+Kk5E"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D172FCA52;
	Thu, 22 May 2025 09:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747906399; cv=none; b=tRA/j4V9Le//Hiu8LcyiwS5Cvo+1wgHrwPMMgyI0TknA3jGOhqEGESAnmSGOpkhC8CGbP73aDwYPJ9wH/lMew3SKMQXI+CuyP6XEeSWMuZp38LMhiWQaa3vPoWn9jlIG/Gk2h02bAghz2ZgSUQiBvRZwS0HRA6pg/U4bVE2l6P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747906399; c=relaxed/simple;
	bh=v9bMSSXzzTP52MAIXi1/0iB4UvcEDNmTPLpAeI6+lTg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ByjsIrTKg9oBn/GhhZk199IEUGvQNwZgBYNV99mJo23Shn2NAfo/xYJltu9HCXSNxM3m0PKCdaaANg9NAqyiLJIUypvbbCjVPQ/qR1G7azwv767sI5bIFT3PKbQAMe+xUmAwyqCRJtth9NKxYU6TxfXmqewPVihBKw1Po3CWjh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mK0+Kk5E; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54M6l5QB006476;
	Thu, 22 May 2025 09:33:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=IJPqZ/
	BxLDNz2+2Ti32s+FYQCU3m7M8uuaeBLdePDnU=; b=mK0+Kk5EzHH0yDEtItDawR
	RSoF+mGASoGGSjMqG2ZBahvQH2FdwHNFcvQKwOXS87WlAqcjYO+GqUP7r/62U2y4
	Z8SsNUQP5H36C3DMq4eIOqWUd6Ajo+ivb5Vp7MSQ92ZS0Jmx1r2HY1P5yFo3PkYo
	jfjrdFVgm9R7b4hQltXoJTm/NmV60MVD17wGpp2qQuq24rKiEVXSb6HBiirdxyb0
	aJcD5U1vj3IvhqetgGuLX8ZXTc9dKbECf5o3nPeBwTh+OjnEv/Ulm/z4t2sn1s31
	X7Jb4I74UTgM1oaKvOv+ws8qmc48HEk4LIwYaZrGuBQDTx0afYfp9O37DMsCfRTA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46smf9bdys-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 09:33:12 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54M5TjFx032084;
	Thu, 22 May 2025 09:33:11 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwnmgs3c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 09:33:11 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54M9X7l350921758
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 09:33:07 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 802FA2004B;
	Thu, 22 May 2025 09:33:07 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 313D52004F;
	Thu, 22 May 2025 09:33:07 +0000 (GMT)
Received: from [9.155.210.150] (unknown [9.155.210.150])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 22 May 2025 09:33:07 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Date: Thu, 22 May 2025 11:31:57 +0200
Subject: [PATCH v3 1/3] KVM: s390: Set KVM_MAX_VCPUS to 256
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250522-rm-bsca-v3-1-51d169738fcf@linux.ibm.com>
References: <20250522-rm-bsca-v3-0-51d169738fcf@linux.ibm.com>
In-Reply-To: <20250522-rm-bsca-v3-0-51d169738fcf@linux.ibm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2266;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=v9bMSSXzzTP52MAIXi1/0iB4UvcEDNmTPLpAeI6+lTg=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDBl674NeL/92qr2iNrcg7m9Zcv9VnXU7JSQe211xS+1qv
 hu8QMq9o5SFQYyLQVZMkaVa3Dqvqq916ZyDltdg5rAygQxh4OIUgImszWZkWFXzcWWB3OkHM9ru
 vfz/M21dytwvC45NcD6h/2xaOX/Q8UUM/ywudLsGHLav/f5hi8wJk/zCpKSs2/sEshjm34k9Lm3
 TyAkA
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ds5e8uAMs9i32HMyGIQP8iY8XoXwDVVq
X-Proofpoint-ORIG-GUID: ds5e8uAMs9i32HMyGIQP8iY8XoXwDVVq
X-Authority-Analysis: v=2.4 cv=TbqWtQQh c=1 sm=1 tr=0 ts=682eef58 cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=wggSNQFzZ8jKG0l6iRoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDA4NiBTYWx0ZWRfX/hSwYN1vxF0I Ji1/ParHOX536r544j1qeBCYsOAM86TFe/0K9e9dKQsWtQjFGnVsecz0tPUC5+7QbIIXrvtHYui Zkc1MNRjbmsPa756fQwH/UUi3IALcti85BdzS+EGIoW9jP8tWFNXXO3yXZ+UzLxBVskYfXuydR6
 ZWZGQy5AdsoABowC7MVWtEETSzGAzA8YngaPP5gasPBStLYPwayzvNXE5jfEWkDu4gXssV+pp93 DDyJuBSECZ3DtlI7pGGIwptjj/c4UJYus1Bk9m4bAPlGkKzAj4CCXBfGJDi4CE9wrWcba1wWwYH bMiUUFt5HONwFZkvglntTdkWz2PPZUMxbJC2Nw+IlZs4Wl/9WaBvdGruVFNobFCofCtCd8XtXYi
 TFpNj99FCjmVfHzycrWTjpVWOJ2lHpaXYVBy42j+5LIRYHoetFIB4cS8uEfY/X9JpAr381Ak
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_04,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 phishscore=0 adultscore=0 spamscore=0 mlxlogscore=589 malwarescore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 clxscore=1015
 impostorscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505220086

The s390x architecture allows for 256 vCPUs with a max CPUID of 255.
The current KVM implementation limits this to 248 when using the
extended system control area (ESCA). So this correction should not cause
any real world problems but actually correct the values returned by the
ioctls:

* KVM_CAP_NR_VCPUS
* KVM_CAP_MAX_VCPUS
* KVM_CAP_MAX_VCPU_ID

KVM_MAX_VCPUS is also moved to kvm_host_types to allow using this in
future type definitions.

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h       | 2 --
 arch/s390/include/asm/kvm_host_types.h | 2 ++
 arch/s390/kvm/kvm-s390.c               | 2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index cb89e54ada257eb4fdfe840ff37b2ea639c2d1cb..f51bac835260f562eaf4bbfd373a24bfdbc43834 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -27,8 +27,6 @@
 #include <asm/isc.h>
 #include <asm/guarded_storage.h>
 
-#define KVM_MAX_VCPUS 255
-
 #define KVM_INTERNAL_MEM_SLOTS 1
 
 /*
diff --git a/arch/s390/include/asm/kvm_host_types.h b/arch/s390/include/asm/kvm_host_types.h
index 1394d3fb648f1e46dba2c513ed26e5dfd275fad4..9697db9576f6c39a6689251f85b4b974c344769a 100644
--- a/arch/s390/include/asm/kvm_host_types.h
+++ b/arch/s390/include/asm/kvm_host_types.h
@@ -6,6 +6,8 @@
 #include <linux/atomic.h>
 #include <linux/types.h>
 
+#define KVM_MAX_VCPUS 256
+
 #define KVM_S390_BSCA_CPU_SLOTS 64
 #define KVM_S390_ESCA_CPU_SLOTS 248
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 3f3175193fd7a7a26658eb2e2533d8037447a0b4..b65e4cbe67cf70a7d614607ebdd679060e7d31f4 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -638,6 +638,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 			r = KVM_S390_ESCA_CPU_SLOTS;
 		if (ext == KVM_CAP_NR_VCPUS)
 			r = min_t(unsigned int, num_online_cpus(), r);
+		else if (ext == KVM_CAP_MAX_VCPU_ID)
+			r -= 1;
 		break;
 	case KVM_CAP_S390_COW:
 		r = machine_has_esop();

-- 
2.49.0


