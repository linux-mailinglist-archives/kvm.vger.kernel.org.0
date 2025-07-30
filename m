Return-Path: <kvm+bounces-53724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96B2BB15A3D
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 10:13:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 55DAA17D2B6
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 08:13:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C091264A6E;
	Wed, 30 Jul 2025 08:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="opbLEuOr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE62256C8A;
	Wed, 30 Jul 2025 08:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753863217; cv=none; b=Lx35uRU+gNlz9Og35TJK6yAGmHUJM6OqnAViT8Usswa3xPj7l12Ome5/wXuT8hytrLjjm08DfbNU22CHGO2hjfK+GTA1jjMFs5izT5Gb0z1erlSLbwUDVYm08qu6c2gD8y/RwGYO5hvZ7UlH5R4u0qT2sJ6pM+/7WE/oJbNkoxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753863217; c=relaxed/simple;
	bh=Ik/n5jt2JUkDg+eghRLtMrzS2A+c9IbvzgpquCteAcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JforCtadagGWEsxsSt+WrhWbtpnXx1hqlbQ/yWprnzdHmLSNpbwh8RaNIG66TRM6cciPlJTevFCun4YZxV5qNwfdUuQmhCNuPI16mjH77V3p6zIxzPe5o2hW91oRZsFVrII6a5zR3apxnuCxxa3C9RAOFCCpSV/FqOCiSTvLPe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=opbLEuOr; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56U1vpFd008885;
	Wed, 30 Jul 2025 08:13:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=WWTPa9NQu/c0zDSla
	zdYMw4iozTmETI+tGFtjgN3HfU=; b=opbLEuOrAzDAwmpqhZDl1ILmAbRJenJMV
	J3CN69XSs0xOA4vXYSPhw4pD5SR4k439Ane893fq24zZF2APSEg2qSsMP4mqeASm
	hMWE1wcI1ByD+LOAvEJcB/L59uiQNex+fiCXSR4zuO9IizsuFqJD8g4INeExKsyL
	hE8q/zid5RgAkDgl+IRf0s7Fa+3bjm39vIUHAaMGRLrtgf6OQZ7qqiSYmbmq7hkz
	XNaY9uxUyDUUkrLnTgzqSwFlv0r1YpEMotgiIRDyQN9blWnV+5W3BNRY4Hf4f+XH
	7R6/3mb6ibnmGRwt96i3WqGCKMgFIlSSWzJ5e1yoHWEYIDf4GnR9w==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 484qcg3j3d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Jul 2025 08:13:15 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56U5Ru2X017296;
	Wed, 30 Jul 2025 08:13:14 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4859r06ktx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Jul 2025 08:13:14 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56U8DBbD54788442
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Jul 2025 08:13:11 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E312020040;
	Wed, 30 Jul 2025 08:13:10 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 456432004F;
	Wed, 30 Jul 2025 08:13:10 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.87.148.140])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 30 Jul 2025 08:13:10 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, ajd@linux.ibm.com,
        sfr@canb.auug.org.au, Mark Rutland <mark.rutland@arm.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sven Schnelle <svens@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [GIT PULL 2/2] KVM: s390: Rework guest entry logic
Date: Wed, 30 Jul 2025 10:10:33 +0200
Message-ID: <20250730081224.38778-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730081224.38778-1-frankja@linux.ibm.com>
References: <20250730081224.38778-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMwMDA1MyBTYWx0ZWRfX1kfGhKEAcN5J
 Y7DAHivs3WNgST0jtLRGVzq68/uurxRaJDrXAubX7SOvrM0Zdy0DZtS4XL2hLWrDYzA9Z4M5sr/
 mBdcvDin5SnHAyjYzwhCBUbeI3NwM09UyhO4aQ2GpuRH20O4dbGv7aWBZWr0BDmCX98lA9L7FWB
 wh7NSdr/MDWxSgURhS/abNng84s4z4sxDQX+euk7+wXvwrlgrGByHDSdWGokBFcODIInUD4OZht
 vnWlnla/bKlOVTE6tCQP8Mpoq7TYhQ01O8d8zSPnuQlJE0KAKiXTpsNU6fbtxhoXRZl1Hmi1hsn
 GEETxWTwpSpRRQmAENExW9IDdjDfJh8BJba28Yxn8eQmVwahw08k/Ux7eJsJOl8j/mscq3Q6DhV
 f7hnCpZ8jI92j3VfE18FqlCMi+K6C6jzA4jEd/S10hvFODd/FfLydBsB+Eq11+SwPAJMf553
X-Proofpoint-ORIG-GUID: wiJu3qeqsNJWX6VGLEmqicYyQM9-7_WD
X-Authority-Analysis: v=2.4 cv=Lp2Symdc c=1 sm=1 tr=0 ts=6889d41b cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=7CQSdrXTAAAA:8
 a=20KFwNOVAAAA:8 a=Na8OWgsjXXK3TkZkIhcA:9 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-GUID: wiJu3qeqsNJWX6VGLEmqicYyQM9-7_WD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-30_03,2025-07-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 impostorscore=0 mlxscore=0 priorityscore=1501
 adultscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507300053

From: Mark Rutland <mark.rutland@arm.com>

In __vcpu_run() and do_vsie_run(), we enter an RCU extended quiescent
state (EQS) by calling guest_enter_irqoff(), which lasts until
__vcpu_run() calls guest_exit_irqoff(). However, between the two we
enable interrupts and may handle interrupts during the EQS. As the IRQ
entry code will not wake RCU in this case, we may run the core IRQ code
and IRQ handler without RCU watching, leading to various potential
problems.

It is necessary to unmask (host) interrupts around entering the guest,
as entering the guest via SIE will not automatically unmask these. When
a host interrupt is taken from a guest, it is taken via its regular
host IRQ handler rather than being treated as a direct exit from SIE.
Due to this, we cannot simply mask interrupts around guest entry, and
must handle interrupts during this window, waking RCU as required.

Additionally, between guest_enter_irqoff() and guest_exit_irqoff(), we
use local_irq_enable() and local_irq_disable() to unmask interrupts,
violating the ordering requirements for RCU/lockdep/tracing around
entry/exit sequences. Further, since this occurs in an instrumentable
function, it's possible that instrumented code runs during this window,
with potential usage of RCU, etc.

To fix the RCU wakeup problem, an s390 implementation of
arch_in_rcu_eqs() is added which checks for PF_VCPU in current->flags.
PF_VCPU is set/cleared by guest_timing_{enter,exit}_irqoff(), which
surround the actual guest entry.

To fix the remaining issues, the lower-level guest entry logic is moved
into a shared noinstr helper function using the
guest_state_{enter,exit}_irqoff() helpers. These perform all the
lockdep/RCU/tracing manipulation necessary, but as sie64a() does not
enable/disable interrupts, we must do this explicitly with the
non-instrumented arch_local_irq_{enable,disable}() helpers:

        guest_state_enter_irqoff()

        arch_local_irq_enable();
        sie64a(...);
        arch_local_irq_disable();

        guest_state_exit_irqoff();

[ajd@linux.ibm.com: rebase, fix commit message]

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20250708092742.104309-3-ajd@linux.ibm.com
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-ID: <20250708092742.104309-3-ajd@linux.ibm.com>
---
 arch/s390/include/asm/entry-common.h | 10 ++++++
 arch/s390/include/asm/kvm_host.h     |  3 ++
 arch/s390/kvm/kvm-s390.c             | 51 +++++++++++++++++++++-------
 arch/s390/kvm/vsie.c                 | 17 ++++------
 4 files changed, 59 insertions(+), 22 deletions(-)

diff --git a/arch/s390/include/asm/entry-common.h b/arch/s390/include/asm/entry-common.h
index 35555c944630..979af986a8fe 100644
--- a/arch/s390/include/asm/entry-common.h
+++ b/arch/s390/include/asm/entry-common.h
@@ -59,4 +59,14 @@ static inline void arch_exit_to_user_mode_prepare(struct pt_regs *regs,
 
 #define arch_exit_to_user_mode_prepare arch_exit_to_user_mode_prepare
 
+static __always_inline bool arch_in_rcu_eqs(void)
+{
+	if (IS_ENABLED(CONFIG_KVM))
+		return current->flags & PF_VCPU;
+
+	return false;
+}
+
+#define arch_in_rcu_eqs arch_in_rcu_eqs
+
 #endif
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index cb89e54ada25..f870d09515cc 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -716,6 +716,9 @@ extern char sie_exit;
 bool kvm_s390_pv_is_protected(struct kvm *kvm);
 bool kvm_s390_pv_cpu_is_protected(struct kvm_vcpu *vcpu);
 
+extern int kvm_s390_enter_exit_sie(struct kvm_s390_sie_block *scb,
+				   u64 *gprs, unsigned long gasce);
+
 extern int kvm_s390_gisc_register(struct kvm *kvm, u32 gisc);
 extern int kvm_s390_gisc_unregister(struct kvm *kvm, u32 gisc);
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d5ad10791c25..bfe9ba5c4f45 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5062,6 +5062,30 @@ static int vcpu_post_run(struct kvm_vcpu *vcpu, int exit_reason)
 	return vcpu_post_run_handle_fault(vcpu);
 }
 
+int noinstr kvm_s390_enter_exit_sie(struct kvm_s390_sie_block *scb,
+				    u64 *gprs, unsigned long gasce)
+{
+	int ret;
+
+	guest_state_enter_irqoff();
+
+	/*
+	 * The guest_state_{enter,exit}_irqoff() functions inform lockdep and
+	 * tracing that entry to the guest will enable host IRQs, and exit from
+	 * the guest will disable host IRQs.
+	 *
+	 * We must not use lockdep/tracing/RCU in this critical section, so we
+	 * use the low-level arch_local_irq_*() helpers to enable/disable IRQs.
+	 */
+	arch_local_irq_enable();
+	ret = sie64a(scb, gprs, gasce);
+	arch_local_irq_disable();
+
+	guest_state_exit_irqoff();
+
+	return ret;
+}
+
 #define PSW_INT_MASK (PSW_MASK_EXT | PSW_MASK_IO | PSW_MASK_MCHECK)
 static int __vcpu_run(struct kvm_vcpu *vcpu)
 {
@@ -5082,20 +5106,27 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 		kvm_vcpu_srcu_read_unlock(vcpu);
 		/*
 		 * As PF_VCPU will be used in fault handler, between
-		 * guest_enter and guest_exit should be no uaccess.
+		 * guest_timing_enter_irqoff and guest_timing_exit_irqoff
+		 * should be no uaccess.
 		 */
-		local_irq_disable();
-		guest_enter_irqoff();
-		__disable_cpu_timer_accounting(vcpu);
-		local_irq_enable();
 		if (kvm_s390_pv_cpu_is_protected(vcpu)) {
 			memcpy(sie_page->pv_grregs,
 			       vcpu->run->s.regs.gprs,
 			       sizeof(sie_page->pv_grregs));
 		}
-		exit_reason = sie64a(vcpu->arch.sie_block,
-				     vcpu->run->s.regs.gprs,
-				     vcpu->arch.gmap->asce);
+
+		local_irq_disable();
+		guest_timing_enter_irqoff();
+		__disable_cpu_timer_accounting(vcpu);
+
+		exit_reason = kvm_s390_enter_exit_sie(vcpu->arch.sie_block,
+						      vcpu->run->s.regs.gprs,
+						      vcpu->arch.gmap->asce);
+
+		__enable_cpu_timer_accounting(vcpu);
+		guest_timing_exit_irqoff();
+		local_irq_enable();
+
 		if (kvm_s390_pv_cpu_is_protected(vcpu)) {
 			memcpy(vcpu->run->s.regs.gprs,
 			       sie_page->pv_grregs,
@@ -5111,10 +5142,6 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 				vcpu->arch.sie_block->gpsw.mask &= ~PSW_INT_MASK;
 			}
 		}
-		local_irq_disable();
-		__enable_cpu_timer_accounting(vcpu);
-		guest_exit_irqoff();
-		local_irq_enable();
 		kvm_vcpu_srcu_read_lock(vcpu);
 
 		rc = vcpu_post_run(vcpu, exit_reason);
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 13a9661d2b28..347268f89f2f 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1170,10 +1170,6 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	    vcpu->arch.sie_block->fpf & FPF_BPBC)
 		set_thread_flag(TIF_ISOLATE_BP_GUEST);
 
-	local_irq_disable();
-	guest_enter_irqoff();
-	local_irq_enable();
-
 	/*
 	 * Simulate a SIE entry of the VCPU (see sie64a), so VCPU blocking
 	 * and VCPU requests also hinder the vSIE from running and lead
@@ -1183,15 +1179,16 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	vcpu->arch.sie_block->prog0c |= PROG_IN_SIE;
 	current->thread.gmap_int_code = 0;
 	barrier();
-	if (!kvm_s390_vcpu_sie_inhibited(vcpu))
-		rc = sie64a(scb_s, vcpu->run->s.regs.gprs, vsie_page->gmap->asce);
+	if (!kvm_s390_vcpu_sie_inhibited(vcpu)) {
+		local_irq_disable();
+		guest_timing_enter_irqoff();
+		rc = kvm_s390_enter_exit_sie(scb_s, vcpu->run->s.regs.gprs, vsie_page->gmap->asce);
+		guest_timing_exit_irqoff();
+		local_irq_enable();
+	}
 	barrier();
 	vcpu->arch.sie_block->prog0c &= ~PROG_IN_SIE;
 
-	local_irq_disable();
-	guest_exit_irqoff();
-	local_irq_enable();
-
 	/* restore guest state for bp isolation override */
 	if (!guest_bp_isolation)
 		clear_thread_flag(TIF_ISOLATE_BP_GUEST);
-- 
2.50.1


