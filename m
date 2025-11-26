Return-Path: <kvm+bounces-64607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ACD6C882A6
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 06:34:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 72835350259
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 05:34:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2111315D29;
	Wed, 26 Nov 2025 05:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JsP65eH/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C74A279327;
	Wed, 26 Nov 2025 05:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764135250; cv=none; b=H7rIOdsiT6XWfl98nrcj7jLRMWiB8woAGAS/tIPixItqcMjiyrQYBHvdbFLMo9IYFj6qej7uwyjaztXylu3lDa9GiXYooQ/Zo04JqdAV6u6hCP9nnN7OtQXGXvzMncca7GZkxfNgXeAFKS2tkY8XjAbctH+YhMmioe0l4bHFWQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764135250; c=relaxed/simple;
	bh=CVAehinaEnZHYHUhTa9lbfiyB5JcoF0zOenOgH3BQGs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OXj9815oNSV9hRIGhbkV2X9uEEhecJhzRcN4f/EAbpEsqJzXhxSdO9JKBwDNSIWhRGXbtFvGeJs49KEFDd+9pza0CAwVRcehsYP9kN0OssnkpdAVrBXDPEhKUaNjT/PNcimbtXQ4/olWRCzvcU2IpdSMdGb+3GLMjh5aGnfdVgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JsP65eH/; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQ15hWH009766;
	Wed, 26 Nov 2025 05:33:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=+5MZso
	xhQJ3lZmOwjZ3unECkPcyh1PKFDS5e3r7VU7U=; b=JsP65eH/uoxUrNx3bmZapB
	RY/ACw6Q5adsEoQC5v5RXmJs4dCNOuhP1N/VHfIiplUHSaOTUA6O73JDT144rkYi
	cNp1tOfnLi4rxiNcRrFQsZ3MOfJtPAvkEf3OpZ2iZBKJSVYyEKivbz3Bzi5Q2TCv
	TLoE1r+Y7VJQfeB6uryjGhasILM1rQG6DBDyeCxy+2KDETCqIAN8Z9ochwgZprPM
	luoS0u4cyAyAPH706LxkRlPkEeHCC5Jpw+udgUVSIgLyoOlhDoVL17aS5d2L5utd
	hSF9QE8E2Cpj1iyvm9IWk/PusaYlO4PCgaP5iwy7tTwnM/YOZ6WWCgJNXQGMfoHw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4u21364-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 05:33:51 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQ1hmBC013866;
	Wed, 26 Nov 2025 05:33:50 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4akrgn89kc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 05:33:50 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AQ5XncA19727052
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 05:33:49 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 01FD958056;
	Wed, 26 Nov 2025 05:33:49 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 60EA658052;
	Wed, 26 Nov 2025 05:33:44 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com (unknown [9.90.171.232])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 26 Nov 2025 05:33:44 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
Date: Wed, 26 Nov 2025 16:33:11 +1100
Subject: [PATCH v2 2/3] KVM: s390: Enable and disable interrupts in entry
 code
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251126-s390-kvm-xfer-to-guest-work-v2-2-1b8767879235@linux.ibm.com>
References: <20251126-s390-kvm-xfer-to-guest-work-v2-0-1b8767879235@linux.ibm.com>
In-Reply-To: <20251126-s390-kvm-xfer-to-guest-work-v2-0-1b8767879235@linux.ibm.com>
To: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Cc: Nicholas Miehlbradt <nicholas@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        David Hildenbrand <david@kernel.org>
X-Mailer: b4 0.14.2
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAyMSBTYWx0ZWRfX40fPO0NhunCn
 zoBMZLXNClCh3lHesAO18FYeRcyb7ZwpzKAomLvJ0Br/P7u6lDjvmaCs/zFY6zjOul23mdAcHzG
 BXh24caeojalhUDEHi9XRw1PDYaiVDEBCz6ZkjnhbuhGNr8dMxIU85sfFq5gYNCvwE3+LCUcxv1
 mmBdGPKV+fEMonPtDp1Bbsx+uyfWZ33UvtiMLA4902cKLYhC0HXT4Ha2+V82fElWOr2vLTgX2o/
 /PhgsvJ+GRoXrA4DVggpEswD6SDe6l5j+jl/uw2RzRcJKNg0q3Tw5nehEZqDZualvxJnj62zsj1
 +DVQUFa7xQk7+YUWuuC0czVfReaycgXbVK8ySsEWQtejmv5BHoOTqXQaOg559CN7i3UhYmRZU/V
 ExVXtrfauHsTZsIMAkRlDNQ7oFTMAw==
X-Authority-Analysis: v=2.4 cv=SuidKfO0 c=1 sm=1 tr=0 ts=6926913f cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=eOUov4wa0NbOG_Jv4UoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: S6y-rRKzirX4k6aNsoBOZCZjtPQWiyAV
X-Proofpoint-GUID: S6y-rRKzirX4k6aNsoBOZCZjtPQWiyAV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511220021

From: Heiko Carstens <hca@linux.ibm.com>

Move enabling and disabling of interrupts around the SIE instruction to
entry code. Enabling interrupts only after the __TI_sie flag has been set
guarantees that the SIE instruction is not executed if an interrupt happens
between enabling interrupts and the execution of the SIE instruction.
Interrupt handlers and machine check handler forward the PSW to the
sie_exit label in such cases.

This is a prerequisite for VIRT_XFER_TO_GUEST_WORK to prevent that guest
context is entered when e.g. a scheduler IPI, indicating that a reschedule
is required, happens right before the SIE instruction, which could lead to
long delays.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Tested-by: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
---
 arch/s390/include/asm/stacktrace.h | 1 +
 arch/s390/kernel/asm-offsets.c     | 1 +
 arch/s390/kernel/entry.S           | 2 ++
 arch/s390/kvm/kvm-s390.c           | 5 -----
 4 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/s390/include/asm/stacktrace.h b/arch/s390/include/asm/stacktrace.h
index 810a6b9d96280f73311de873ad180c59a0cfbd5f..c9ae680a28af910c4703eee179be4db6c1ec9ad1 100644
--- a/arch/s390/include/asm/stacktrace.h
+++ b/arch/s390/include/asm/stacktrace.h
@@ -66,6 +66,7 @@ struct stack_frame {
 			unsigned long sie_flags;
 			unsigned long sie_control_block_phys;
 			unsigned long sie_guest_asce;
+			unsigned long sie_irq;
 		};
 	};
 	unsigned long gprs[10];
diff --git a/arch/s390/kernel/asm-offsets.c b/arch/s390/kernel/asm-offsets.c
index a8915663e917faed4551276b64013ee073662cc9..730449f464aff25761264b00d63d92e907f17f78 100644
--- a/arch/s390/kernel/asm-offsets.c
+++ b/arch/s390/kernel/asm-offsets.c
@@ -64,6 +64,7 @@ int main(void)
 	OFFSET(__SF_SIE_FLAGS, stack_frame, sie_flags);
 	OFFSET(__SF_SIE_CONTROL_PHYS, stack_frame, sie_control_block_phys);
 	OFFSET(__SF_SIE_GUEST_ASCE, stack_frame, sie_guest_asce);
+	OFFSET(__SF_SIE_IRQ, stack_frame, sie_irq);
 	DEFINE(STACK_FRAME_OVERHEAD, sizeof(struct stack_frame));
 	BLANK();
 	OFFSET(__SFUSER_BACKCHAIN, stack_frame_user, back_chain);
diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index 75b0fbb236d05f420b20cac6bac925e8ac36fa68..e906f4ab6cf35e53061a27192911629c10c347ed 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -189,6 +189,7 @@ SYM_FUNC_START(__sie64a)
 	mvc	__SF_SIE_FLAGS(8,%r15),__TI_flags(%r14) # copy thread flags
 	lmg	%r0,%r13,0(%r4)			# load guest gprs 0-13
 	mvi	__TI_sie(%r14),1
+	stosm	__SF_SIE_IRQ(%r15),0x03		# enable interrupts
 	lctlg	%c1,%c1,__SF_SIE_GUEST_ASCE(%r15) # load primary asce
 	lg	%r14,__SF_SIE_CONTROL(%r15)	# get control block pointer
 	oi	__SIE_PROG0C+3(%r14),1		# we are going into SIE now
@@ -212,6 +213,7 @@ SYM_FUNC_START(__sie64a)
 	lg	%r14,__LC_CURRENT(%r14)
 	mvi	__TI_sie(%r14),0
 SYM_INNER_LABEL(sie_exit, SYM_L_GLOBAL)
+	stnsm	__SF_SIE_IRQ(%r15),0xfc		# disable interrupts
 	lg	%r14,__SF_SIE_SAVEAREA(%r15)	# load guest register save area
 	stmg	%r0,%r13,0(%r14)		# save guest gprs 0-13
 	xgr	%r0,%r0				# clear guest registers to
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index fa6b5150ca31e4d9f0bdafabc1fb1d90ef3f3d0d..3cad08662b3d80aaf6f5f8891fc08b383c3c44d4 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5075,13 +5075,8 @@ int noinstr kvm_s390_enter_exit_sie(struct kvm_s390_sie_block *scb,
 	 * The guest_state_{enter,exit}_irqoff() functions inform lockdep and
 	 * tracing that entry to the guest will enable host IRQs, and exit from
 	 * the guest will disable host IRQs.
-	 *
-	 * We must not use lockdep/tracing/RCU in this critical section, so we
-	 * use the low-level arch_local_irq_*() helpers to enable/disable IRQs.
 	 */
-	arch_local_irq_enable();
 	ret = sie64a(scb, gprs, gasce);
-	arch_local_irq_disable();
 
 	guest_state_exit_irqoff();
 

-- 
2.52.0


