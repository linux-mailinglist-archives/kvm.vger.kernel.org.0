Return-Path: <kvm+bounces-65205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BA43C9F227
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 14:28:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C897834803D
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 13:28:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 927F92F83AE;
	Wed,  3 Dec 2025 13:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="F6+MDQHc"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9A42E719B;
	Wed,  3 Dec 2025 13:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764768522; cv=none; b=JXiSRR2FttskxVcUZA8Ua1PYp6tq1RVHqoLW0pUv7BlZtZO8QJxe10TDz07GwGNhhXubNHjHgzVZcxmC1T2jNAG1Jzj6I60PRJ9xiRshE9Wre8treVePdi0Y/PQH0gpCK0b+D6QUpUEp9JApzTloallPngymGDiglPoqN1ATSnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764768522; c=relaxed/simple;
	bh=9mY8Yf4bW2k9L1DWggOCbOFScJnD8eYSXOmjCuaEv18=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c/v214muQCodMKQJbrjw/NPu6aK0B7n7OKEp+ruTF42nqGayOR4p4LbNEtZGw0ZjLlhdHWLuw0uASzNqSYSas2Mg0pL5j5r9mLxbe4LN6ZM8f8KFm+ojnnHhl8ULBx8UuH8tpz9hnqj4kgA5YgexWYZDqG/BplRdEQriywIFozo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=F6+MDQHc; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5B3BtPR3006545;
	Wed, 3 Dec 2025 13:28:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=3r8m3ujySEwGzvYYFlCm8bT+TejmpDgozSw5ZyVBi
	LI=; b=F6+MDQHcs+NTQ8uS7dIQT8nRI6NhwwzznnYWUjHwcriPaVnPRoJ2H6juu
	8Ws8m+mX2JQfXSO6lyYOdwKnKLlaYXYha26dWbAPbAIlTDNhy5h4qtEbURv/YTk9
	H8f+y5qmRI3gHXW64Ri8rTan2e9cM4PV89mxc06HztrT67gROcFpgTR959BF8NSW
	0xhNmNz3IEGqf3e9fXvwHsbsiRvC/wxticfuFLoUSKNTv24d2+VJRvRqcF0REcyR
	XOWWcZGMMC+eW8VuqxLLD193Ajd/UprusjyTJNSBH32sp+RWkfgbaBv9I7QqMELT
	VMrOm+J8YuMePm8V7eAFo8U0di8CQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aqq8utgab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Dec 2025 13:28:19 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5B3DKXlA007237;
	Wed, 3 Dec 2025 13:28:18 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aqq8utga7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Dec 2025 13:28:18 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5B3CA7rq024098;
	Wed, 3 Dec 2025 13:28:17 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4arb5sjctd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Dec 2025 13:28:17 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5B3DSDxg25952710
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 3 Dec 2025 13:28:13 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5F6B120043;
	Wed,  3 Dec 2025 13:28:13 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C33FF20040;
	Wed,  3 Dec 2025 13:28:09 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.43.93.147])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  3 Dec 2025 13:28:09 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: maddy@linux.ibm.com, vaibhav@gmail.com, npiggin@gmail.com,
        mpe@ellerman.id.au, christophe.leroy@csgroup.eu
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: PPC: Add the missing character/behaviour bits for KVM_PPC_GET_CPU_CHAR ioctl
Date: Wed,  3 Dec 2025 18:58:03 +0530
Message-ID: <20251203132804.16692-1-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MOyR1RV_mJtTNWylyerCyANyXdgGe9XO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDAwOCBTYWx0ZWRfX1iS6lacoqI21
 Dd/4IHQVQ0NQhQ6Mt1X8X+rz1pAhAU9oVSfraHhymH8jAcNFq1uKlqXL2hMo1iD5PQUQzg8IzhG
 6Xdx/aYqkdDQZWRV3rgVgzx0Ir20mLONB7PmPQZ6XstZtD+e5xsPjkb3Nibu6+ZQ4jh18pGLLZl
 NI10vuzv0qfcih89NDO/lg98X8qbq9YCKPXhdwktOc4QaHwSuYhn221jqEEGlhgR2E/MUz2zWLW
 x0i7RZdTOce20VbjLovnVjdwKGEzmrVo6sAyS8ik80CAlEVBVaLikYABdRF5EX+Vr8ar0WwvcSr
 KxTFTtu/4jhZdwd27Vd7gCoh9IT8w9Dv0FnlEdoLGm1PKavfEoTDFcYx6l1RHw+sM5kX8voZYRs
 FpkmKKiujlKqOJMmFR7p3yBXlN1nyA==
X-Authority-Analysis: v=2.4 cv=Scz6t/Ru c=1 sm=1 tr=0 ts=69303af3 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=TlQordfOB7iyn_4i_zgA:9
X-Proofpoint-GUID: yD6JfmJtiEzK7Rb1S0UuQWWQAjVT6kwV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-03_01,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511290008

Add the missing bits for the character and behaviour masks used to
indicate the valid bits in the result of KVM_PPC_GET_CPU_CHAR ioctl
used by KVM guests to know the host mitigation status.

Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
---
 arch/powerpc/include/uapi/asm/kvm.h |  6 ++++++
 arch/powerpc/kvm/powerpc.c          | 10 ++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/uapi/asm/kvm.h b/arch/powerpc/include/uapi/asm/kvm.h
index 077c5437f521..19ad60fb9147 100644
--- a/arch/powerpc/include/uapi/asm/kvm.h
+++ b/arch/powerpc/include/uapi/asm/kvm.h
@@ -450,11 +450,17 @@ struct kvm_ppc_cpu_char {
 #define KVM_PPC_CPU_CHAR_MTTRIG_THR_RECONF	(1ULL << 57)
 #define KVM_PPC_CPU_CHAR_COUNT_CACHE_DIS	(1ULL << 56)
 #define KVM_PPC_CPU_CHAR_BCCTR_FLUSH_ASSIST	(1ull << 54)
+#define KVM_PPC_CPU_CHAR_BCCTR_LINK_FLUSH_ASSIST (1ull << 52)
 
 #define KVM_PPC_CPU_BEHAV_FAVOUR_SECURITY	(1ULL << 63)
 #define KVM_PPC_CPU_BEHAV_L1D_FLUSH_PR		(1ULL << 62)
 #define KVM_PPC_CPU_BEHAV_BNDS_CHK_SPEC_BAR	(1ULL << 61)
+#define KVM_PPC_CPU_BEHAV_FAVOUR_SECURITY_H	(1ull << 60)
 #define KVM_PPC_CPU_BEHAV_FLUSH_COUNT_CACHE	(1ull << 58)
+#define KVM_PPC_CPU_BEHAV_FLUSH_LINK_STACK	(1ull << 57)
+#define KVM_PPC_CPU_BEHAV_NO_L1D_FLUSH_ENTRY	(1ull << 56)
+#define KVM_PPC_CPU_BEHAV_NO_L1D_FLUSH_UACCESS (1ull << 55)
+#define KVM_PPC_CPU_BEHAV_NO_STF_BARRIER	(1ull << 54)
 
 /* Per-vcpu XICS interrupt controller state */
 #define KVM_REG_PPC_ICP_STATE	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0x8c)
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 2ba057171ebe..642740c86272 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -2261,11 +2261,17 @@ static int pseries_get_cpu_char(struct kvm_ppc_cpu_char *cp)
 			KVM_PPC_CPU_CHAR_BR_HINT_HONOURED |
 			KVM_PPC_CPU_CHAR_MTTRIG_THR_RECONF |
 			KVM_PPC_CPU_CHAR_COUNT_CACHE_DIS |
-			KVM_PPC_CPU_CHAR_BCCTR_FLUSH_ASSIST;
+			KVM_PPC_CPU_CHAR_BCCTR_FLUSH_ASSIST |
+			KVM_PPC_CPU_CHAR_BCCTR_LINK_FLUSH_ASSIST;
 		cp->behaviour_mask = KVM_PPC_CPU_BEHAV_FAVOUR_SECURITY |
 			KVM_PPC_CPU_BEHAV_L1D_FLUSH_PR |
 			KVM_PPC_CPU_BEHAV_BNDS_CHK_SPEC_BAR |
-			KVM_PPC_CPU_BEHAV_FLUSH_COUNT_CACHE;
+			KVM_PPC_CPU_BEHAV_FAVOUR_SECURITY_H |
+			KVM_PPC_CPU_BEHAV_FLUSH_COUNT_CACHE |
+			KVM_PPC_CPU_BEHAV_FLUSH_LINK_STACK |
+			KVM_PPC_CPU_BEHAV_NO_L1D_FLUSH_ENTRY |
+			KVM_PPC_CPU_BEHAV_NO_L1D_FLUSH_UACCESS |
+			KVM_PPC_CPU_BEHAV_NO_STF_BARRIER;
 	}
 	return 0;
 }
-- 
2.50.1 (Apple Git-155)


