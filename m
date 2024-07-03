Return-Path: <kvm+bounces-20905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5150F926572
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 17:59:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C33B31F21C3B
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 15:59:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9749B18306E;
	Wed,  3 Jul 2024 15:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ovFHBVe/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7648C181CE2;
	Wed,  3 Jul 2024 15:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720022353; cv=none; b=j5J3ZEbeLBIDUiW3QDQ81djkT539NWRegpwWJlkqAX3quhPMO/nN4HcXbWE5Ld0PGN4MWRu/VAMIukPEx+k5aPNeFB0HUwz4LocuvkMeS3G8P1fYZG2PPvZUVT0/tNUrzZVUVPNZmAJS7yoUOO0/A77Kys6es7v5fRrME76QT0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720022353; c=relaxed/simple;
	bh=YWiPJdMsWb8crehYL5jOIn76knUujGeyo3iBPoatpqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OV7PHH9zNz+CBDJ2cUZ9EneBZCICbMN0HZ+QPmy8paYX9zs0d85kRSl7ZZd/96Mgec588ZjOguXYtF62n7+xxWSVeIgJS6+cN9IHbnqI9Tv8Iq8fZn9aF8hDfZ4Dglj7ALH8YdH200IJNWzVJ5mCMwAk7iPGJtVwNBBgRQeB1xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ovFHBVe/; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 463FRFnb001718;
	Wed, 3 Jul 2024 15:59:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=xLhVoXuaS21Gs
	VnwUfMCU+Iy2yH453UPcOTeCUQr9Ao=; b=ovFHBVe/EndVZ0+4zpcOKZYbUYwkN
	rYJp0GRb/qJHOYGtXCNPENS+k0M9qps6regIfFbz3UcbbinD+53pVfFVA7ZeQGPE
	ttPJZvKDWNJOrfG5niVzZACxms92bWnkNuUd7Y9/bQvmsjzE0CnUoaQEDehfW5tb
	VbDet4s2UH7MAbjMRqWwsjVwY4L5pVqYbxxU4h7+jWuvQgN3Pc59cD+j9SR3yLpJ
	wchFVejXcTUg1ILCSAV8uZHUXu0ekEysVzSnENytpLK7rEYmRLsizx8MxFc/pHXn
	HMJVIb348WZCk2qNqpN8ySGGTs9BkiG0/XwJKdiA1Zi2iJKk5JMwD2pSA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4058ecg7hn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Jul 2024 15:59:09 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 463Fx8Zm021892;
	Wed, 3 Jul 2024 15:59:08 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4058ecg7hj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Jul 2024 15:59:08 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 463CQs5g029150;
	Wed, 3 Jul 2024 15:59:07 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 402x3n39fq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Jul 2024 15:59:07 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 463Fx1PG20644332
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 3 Jul 2024 15:59:03 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8948420043;
	Wed,  3 Jul 2024 15:59:01 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 37E8C2004E;
	Wed,  3 Jul 2024 15:59:01 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  3 Jul 2024 15:59:01 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, hca@linux.ibm.com,
        svens@linux.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
        nrb@linux.ibm.com, nsg@linux.ibm.com, seiden@linux.ibm.com,
        frankja@linux.ibm.com, borntraeger@de.ibm.com,
        gerald.schaefer@linux.ibm.com, david@redhat.com
Subject: [PATCH v1 1/2] s390/entry: Pass the asce as parameter to sie64a()
Date: Wed,  3 Jul 2024 17:58:59 +0200
Message-ID: <20240703155900.103783-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703155900.103783-1-imbrenda@linux.ibm.com>
References: <20240703155900.103783-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: I-1XHW8vCg3Wn8uuFZewKiOxd3RyL_UQ
X-Proofpoint-ORIG-GUID: -ZQQjeh_4lZiOWPN4qBT00mT7F9m3Xj1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-03_11,2024-07-03_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 mlxscore=0 malwarescore=0 mlxlogscore=874 adultscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2406140001
 definitions=main-2407030118

Pass the guest ASCE explicitly as parameter, instead of having sie64a()
take it from lowcore.

This removes hidden state from lowcore, and makes things look cleaner.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h   | 7 ++++---
 arch/s390/include/asm/stacktrace.h | 1 +
 arch/s390/kernel/asm-offsets.c     | 1 +
 arch/s390/kernel/entry.S           | 8 +++-----
 arch/s390/kvm/kvm-s390.c           | 3 ++-
 arch/s390/kvm/vsie.c               | 2 +-
 6 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 95990461888f..2d4e3f50a823 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -1029,11 +1029,12 @@ void kvm_arch_crypto_clear_masks(struct kvm *kvm);
 void kvm_arch_crypto_set_masks(struct kvm *kvm, unsigned long *apm,
 			       unsigned long *aqm, unsigned long *adm);
 
-int __sie64a(phys_addr_t sie_block_phys, struct kvm_s390_sie_block *sie_block, u64 *rsa);
+int __sie64a(phys_addr_t sie_block_phys, struct kvm_s390_sie_block *sie_block, u64 *rsa,
+	     unsigned long gasce);
 
-static inline int sie64a(struct kvm_s390_sie_block *sie_block, u64 *rsa)
+static inline int sie64a(struct kvm_s390_sie_block *sie_block, u64 *rsa, unsigned long gasce)
 {
-	return __sie64a(virt_to_phys(sie_block), sie_block, rsa);
+	return __sie64a(virt_to_phys(sie_block), sie_block, rsa, gasce);
 }
 
 extern char sie_exit;
diff --git a/arch/s390/include/asm/stacktrace.h b/arch/s390/include/asm/stacktrace.h
index 85b6738b826a..1d5ca13dc90f 100644
--- a/arch/s390/include/asm/stacktrace.h
+++ b/arch/s390/include/asm/stacktrace.h
@@ -65,6 +65,7 @@ struct stack_frame {
 			unsigned long sie_reason;
 			unsigned long sie_flags;
 			unsigned long sie_control_block_phys;
+			unsigned long sie_guest_asce;
 		};
 	};
 	unsigned long gprs[10];
diff --git a/arch/s390/kernel/asm-offsets.c b/arch/s390/kernel/asm-offsets.c
index f55979f64d49..26bb45d0e6f1 100644
--- a/arch/s390/kernel/asm-offsets.c
+++ b/arch/s390/kernel/asm-offsets.c
@@ -63,6 +63,7 @@ int main(void)
 	OFFSET(__SF_SIE_REASON, stack_frame, sie_reason);
 	OFFSET(__SF_SIE_FLAGS, stack_frame, sie_flags);
 	OFFSET(__SF_SIE_CONTROL_PHYS, stack_frame, sie_control_block_phys);
+	OFFSET(__SF_SIE_GUEST_ASCE, stack_frame, sie_guest_asce);
 	DEFINE(STACK_FRAME_OVERHEAD, sizeof(struct stack_frame));
 	BLANK();
 	OFFSET(__SFUSER_BACKCHAIN, stack_frame_user, back_chain);
diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index 60cf917a7122..454b6b92c7f8 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -179,6 +179,7 @@ SYM_FUNC_END(__switch_to_asm)
  * %r2 pointer to sie control block phys
  * %r3 pointer to sie control block virt
  * %r4 guest register save area
+ * %r5 guest asce
  */
 SYM_FUNC_START(__sie64a)
 	stmg	%r6,%r14,__SF_GPRS(%r15)	# save kernel registers
@@ -186,15 +187,12 @@ SYM_FUNC_START(__sie64a)
 	stg	%r2,__SF_SIE_CONTROL_PHYS(%r15)	# save sie block physical..
 	stg	%r3,__SF_SIE_CONTROL(%r15)	# ...and virtual addresses
 	stg	%r4,__SF_SIE_SAVEAREA(%r15)	# save guest register save area
+	stg	%r5,__SF_SIE_GUEST_ASCE(%r15)	# save guest asce
 	xc	__SF_SIE_REASON(8,%r15),__SF_SIE_REASON(%r15) # reason code = 0
 	mvc	__SF_SIE_FLAGS(8,%r15),__TI_flags(%r12) # copy thread flags
 	lmg	%r0,%r13,0(%r4)			# load guest gprs 0-13
-	lg	%r14,__LC_GMAP			# get gmap pointer
-	ltgr	%r14,%r14
-	jz	.Lsie_gmap
 	oi	__LC_CPU_FLAGS+7,_CIF_SIE
-	lctlg	%c1,%c1,__GMAP_ASCE(%r14)	# load primary asce
-.Lsie_gmap:
+	lctlg	%c1,%c1,__SF_SIE_GUEST_ASCE(%r15) # load primary asce
 	lg	%r14,__SF_SIE_CONTROL(%r15)	# get control block pointer
 	oi	__SIE_PROG0C+3(%r14),1		# we are going into SIE now
 	tm	__SIE_PROG20+3(%r14),3		# last exit...
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 82e9631cd9ef..148dff562386 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4829,7 +4829,8 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 			       sizeof(sie_page->pv_grregs));
 		}
 		exit_reason = sie64a(vcpu->arch.sie_block,
-				     vcpu->run->s.regs.gprs);
+				     vcpu->run->s.regs.gprs,
+				     gmap_get_enabled()->asce);
 		if (kvm_s390_pv_cpu_is_protected(vcpu)) {
 			memcpy(vcpu->run->s.regs.gprs,
 			       sie_page->pv_grregs,
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index c9ecae830634..97a70c2b83ee 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1150,7 +1150,7 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	vcpu->arch.sie_block->prog0c |= PROG_IN_SIE;
 	barrier();
 	if (!kvm_s390_vcpu_sie_inhibited(vcpu))
-		rc = sie64a(scb_s, vcpu->run->s.regs.gprs);
+		rc = sie64a(scb_s, vcpu->run->s.regs.gprs, gmap_get_enabled()->asce);
 	barrier();
 	vcpu->arch.sie_block->prog0c &= ~PROG_IN_SIE;
 
-- 
2.45.2


