Return-Path: <kvm+bounces-65001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F03CC9767A
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 13:54:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74BFE3A8188
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 12:49:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5206C322557;
	Mon,  1 Dec 2025 12:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JrNYBjFz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF533128BE;
	Mon,  1 Dec 2025 12:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764593122; cv=none; b=DHGYap+r+eYwo0GnnDUmdEye5yIPoS1jJmPUpsw3l7eWjI5A8SxWe7IPJCJ4CKRX9qY8ELet+xsUSN0IdDBXc5JkuUUJr1ysDLqGT2hmA+TDEZwwCCRGtuTUprQB4dvx/auCYTs1OxdyCcPEU5BLg4Dd3SF92h0e+mxaqiAN3cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764593122; c=relaxed/simple;
	bh=otVJoqLc4jtg6UpBtcmsCQuS7eaWBQUdHHzUmUQBty4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2XQG2bVFsWLgjYQD8vggOS07LH/iNFIh0l7b1ay/jAwr0ffsHz181jodoHTLUSgDzMD0P6bInyS76XzebRQGpSekzIYvIrPrT6oVmtpwQbCtf4cEoAiv//J8SYptIrTOpYtqgDqPYmD1BQJ/Gpjx+CndXubewgQgOKX02EJJD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JrNYBjFz; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5B17bC8u029716;
	Mon, 1 Dec 2025 12:45:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=qCWcIZ73acpCnUavH
	H1GHsqdJWbxh9MR6S/l3+I3h1Y=; b=JrNYBjFzQ2trv5fVuO4J7UC6TrTBsfdcx
	yG67a+Rp8gdeezj6kkp5qYDNs0I6SyO39OjbRTOO5yplbitGpyzKt/FC5Uap97xS
	HT2EaJv+TkxnaBnGwSLuTy94faEZ3BHYMh9e3zPMHdfrWZ+S8o9ZmAs43wIhBGrH
	wclsHJEMa/s9w88MpvttLWvDaaDJ8WGE1A4Qm5Bj5QSlmzB3Vivomjlu+aBV/irN
	SlHLwbZ5FsMikR0zQqFTSzJfinapoLj0JWBhc9MLQz7MGkOPXo5oahgjVeLKRQ5A
	e5TNSH3HsENzuaP3hxZtWgFLE9k2gJESoJnSLeeTHvVZk1C5IN9cw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aqq8uf21u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 12:45:18 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5B1ASFlq029361;
	Mon, 1 Dec 2025 12:45:17 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ardv164ca-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 12:45:17 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5B1CjDEl24641808
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Dec 2025 12:45:13 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8315220040;
	Mon,  1 Dec 2025 12:45:13 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 169CC20043;
	Mon,  1 Dec 2025 12:45:13 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.111.74.48])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  1 Dec 2025 12:45:13 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        Andrew Donnellan <ajd@linux.ibm.com>
Subject: [GIT PULL 09/10] KVM: s390: Enable and disable interrupts in entry code
Date: Mon,  1 Dec 2025 13:33:51 +0100
Message-ID: <20251201124334.110483-10-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201124334.110483-1-frankja@linux.ibm.com>
References: <20251201124334.110483-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: S5j03koRs5o23U4xthWft3SEQUrZvVrS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDAwOCBTYWx0ZWRfX8qub15MW8BSk
 oaQXCXnNXJpMVHOIRELGXyPRlARbTzw+v8noydY6/Vtjt32pVX9mQbALjR1iyFh0m6qGQEXms9E
 HcXwlEi1lF+3Ko2M7dBzhOM2HY/pUO1wjFVMkFRXjs9i5eobEZSAXBtKIX101Jq4Hv6+oLnqhSV
 /bXeqEv31ao/s9H1EMx3Te7g4tNqB8bvWlYfuo3ZY4HQq6qDPdVloenrpIXu5Jr5zLGNa9QLZK6
 bWm3Yl0tEHSgErpon/WpnyFM04tWfIHXfHMEmiE9KhRdq0dLzx5e+236W4lkgOUa1HTyQd6MTca
 fEhq3LuS0KEW/PEe+fDh0rzIei14EMDgSrfRM7ylbIxFdN/Qf9wFg5G4rs98Eu/K6tTiMoRRKWP
 YtkKL1nrTw1AEcnz9bp21CAJS3UnWQ==
X-Authority-Analysis: v=2.4 cv=Scz6t/Ru c=1 sm=1 tr=0 ts=692d8dde cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=eOUov4wa0NbOG_Jv4UoA:9
X-Proofpoint-GUID: S5j03koRs5o23U4xthWft3SEQUrZvVrS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511290008

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
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/stacktrace.h | 1 +
 arch/s390/kernel/asm-offsets.c     | 1 +
 arch/s390/kernel/entry.S           | 2 ++
 arch/s390/kvm/kvm-s390.c           | 5 -----
 4 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/s390/include/asm/stacktrace.h b/arch/s390/include/asm/stacktrace.h
index 810a6b9d9628..c9ae680a28af 100644
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
index a8915663e917..730449f464af 100644
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
index 75b0fbb236d0..e906f4ab6cf3 100644
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
index 8db37e508a71..4d13601ec217 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4962,13 +4962,8 @@ int noinstr kvm_s390_enter_exit_sie(struct kvm_s390_sie_block *scb,
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


