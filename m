Return-Path: <kvm+bounces-46973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 307BAABBCB7
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 13:39:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2C6C3A5017
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 11:37:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A813427511C;
	Mon, 19 May 2025 11:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KMZQTWNO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2F126FA6A;
	Mon, 19 May 2025 11:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747654645; cv=none; b=J2YRWoBi3lavhXa5HObw47J87zOS11ElrY83aqu9wzggrOVtl4tAw0/3e/m1IcUTrXfDlr0EJSgVfqpWQZkZ24uDtrB8EW+1xz2lChEpeflsHcOaiPPzhAJB4twu9yQ3nniFh333q0AtVp56prJSeNUSVnKTb4MXmcoBfD46URM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747654645; c=relaxed/simple;
	bh=O6opUvNK95laGKROpxPTDqp7VEpA9UpaVaHT4c/Ueak=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pxJaizXoqnEmnC3Kb0pBFvBLIzO3tGojkGNHGKiaocXbx2bmIlaENS3tLcmCiJT2cEv0DXnL3JEqbXobaLgGivuZczSCl9+u0S/L/TmwkAwbrHf1tGwnpcV/RXEmDeKXpiAas0P+u/l8nKn9TEluvnhEVlReJ3Yu2QkuNKfKPJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KMZQTWNO; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54JAwCNv027411;
	Mon, 19 May 2025 11:37:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=EnJ0TX
	RpxtpHwBKCQvFjAJ2lCWG9WF6tNtjFMmClok4=; b=KMZQTWNOQZ6rUfarhOjuND
	vMVhg1CJZP2vNGP2Wj2l6icvYQiDldfeQFMYbrndBZ09ccPME4+nAMrnl6P3n8OY
	T9MTi6l15gc0btkwYpWP7H0qVRN+mM83r/Rx6+VoFZLD6R1fbkf4KBsSMn9/qIx3
	Jo9p0MUCS+LlXp9yDZx6UcwY84fG1laU6iGU+gBxHP16BYJP72wvByc7Vfu/CIc7
	CTVa1BJ6PeqtFelC4iiy1xeEgesxWpWPYSG+PzB7lMi8aH0SM/WcfZE1tdeQPGW+
	stIkIIuB+CRwIfuEaNlhE4qufMjjFvJzj19t0KfYxB+yABk9DlvB6B75F2GkO5dQ
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46qgs2v3rf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 May 2025 11:37:21 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54JBLMjp007216;
	Mon, 19 May 2025 11:37:20 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 46q70k66nw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 May 2025 11:37:20 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54JBbGHi57540958
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 May 2025 11:37:16 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 84129204BB;
	Mon, 19 May 2025 11:37:16 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 07E5E204C0;
	Mon, 19 May 2025 11:37:16 +0000 (GMT)
Received: from [192.168.88.52] (unknown [9.111.40.56])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 19 May 2025 11:37:15 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Date: Mon, 19 May 2025 13:36:09 +0200
Subject: [PATCH v2 1/3] KVM: s390: Set KVM_MAX_VCPUS to 256
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250519-rm-bsca-v2-1-e3ea53dd0394@linux.ibm.com>
References: <20250519-rm-bsca-v2-0-e3ea53dd0394@linux.ibm.com>
In-Reply-To: <20250519-rm-bsca-v2-0-e3ea53dd0394@linux.ibm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2221;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=O6opUvNK95laGKROpxPTDqp7VEpA9UpaVaHT4c/Ueak=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDBna4q8jV/CeTSx5ErOeb4bs5pmc7RV1FTc/7jmkpjN/F
 ue0pKkPOkpZGMS4GGTFFFmqxa3zqvpal845aHkNZg4rE8gQBi5OAZjIVxlGhtPvNm9LfmshoM95
 48uV46+971+ISfO+rD/V/JT6nRMLeXYwMjxbzPn6k/vJ/mf191+9nDyX0ehn79nd7vnyqWtslbr
 77rABAA==
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Z/fsHGRA c=1 sm=1 tr=0 ts=682b17f1 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=wggSNQFzZ8jKG0l6iRoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE5MDEwOSBTYWx0ZWRfX8WeOy6OtuyoY TxF0Db270Um2OwN4DP9NIoB0joBuwgz8hQL4choTQIUq8hre5QvkSj73edlIUYU04jGlh6ZABp4 oimYbRxHj4B3RyHk2vjAhgxvXoyB4qNIMam+GkUrMBdpO4tFsaHwW6HJJenfBMyH5u+3E5OK/82
 Yey5hxhETWWnFbPdzsZIapXELRYDPLYWAgql2zckR/8rPssdIPRxF2MloZKzAyQXlZsn4zEz+mh F98L1QsSDtSSWCSHiN3lFSDM4cjtAIWaZRFSudbFql8JTE41RExTuoJzw06i+VGmpo3OFYZ9aaT n9vGU275wchfV6F5ECB7fKu6h1KmM9DlQ8WmW8/RCnt8o3dlpxfnDBsagcBW7QPlmRHKytUE0kF
 lKeiG9aKd92JDQCioBhaNy0KZumZdsipIrIYjfI91kumFtuMzplXJaAS9wsOJ+QJL5vz/atg
X-Proofpoint-ORIG-GUID: WrnGl9IgAv7aGgrY_QjNpiYm-e7ZdNV4
X-Proofpoint-GUID: WrnGl9IgAv7aGgrY_QjNpiYm-e7ZdNV4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-19_05,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=552
 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0 adultscore=0
 clxscore=1015 spamscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505190109

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


