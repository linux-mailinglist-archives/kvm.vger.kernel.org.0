Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 208461556F9
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 12:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbgBGLkj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 06:40:39 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27692 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727075AbgBGLkH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 06:40:07 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 017BcAL8117309;
        Fri, 7 Feb 2020 06:40:06 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y0knevr2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Feb 2020 06:40:06 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 017BdZ04122637;
        Fri, 7 Feb 2020 06:40:06 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y0knevr1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Feb 2020 06:40:06 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 017Bcl0C026906;
        Fri, 7 Feb 2020 11:40:05 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02dal.us.ibm.com with ESMTP id 2xykca1y7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Feb 2020 11:40:05 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 017Be2nP49611164
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Feb 2020 11:40:03 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3BCCAC05E;
        Fri,  7 Feb 2020 11:40:02 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA9F5AC05B;
        Fri,  7 Feb 2020 11:40:02 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  7 Feb 2020 11:40:02 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [PATCH 25/35] KVM: s390: protvirt: Only sync fmt4 registers
Date:   Fri,  7 Feb 2020 06:39:48 -0500
Message-Id: <20200207113958.7320-26-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200207113958.7320-1-borntraeger@de.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-07_01:2020-02-07,2020-02-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=936 adultscore=0 impostorscore=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002070089
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

A lot of the registers are controlled by the Ultravisor and never
visible to KVM. Also some registers are overlayed, like gbea is with
sidad, which might leak data to userspace.

Hence we sync a minimal set of registers for both SIE formats and then
check and sync format 2 registers if necessary.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
[borntraeger@de.ibm.com: patch merging, splitting, fixing]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 116 ++++++++++++++++++++++++---------------
 1 file changed, 72 insertions(+), 44 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index f995040102ea..7df48cc942fd 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3447,9 +3447,11 @@ static void kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
 	vcpu->arch.sie_block->gcr[0] = CR0_INITIAL_MASK;
 	vcpu->arch.sie_block->gcr[14] = CR14_INITIAL_MASK;
 	vcpu->run->s.regs.fpc = 0;
-	vcpu->arch.sie_block->gbea = 1;
-	vcpu->arch.sie_block->pp = 0;
-	vcpu->arch.sie_block->fpf &= ~FPF_BPBC;
+	if (!kvm_s390_pv_handle_cpu(vcpu)) {
+		vcpu->arch.sie_block->gbea = 1;
+		vcpu->arch.sie_block->pp = 0;
+		vcpu->arch.sie_block->fpf &= ~FPF_BPBC;
+	}
 }
 
 static void kvm_arch_vcpu_ioctl_clear_reset(struct kvm_vcpu *vcpu)
@@ -4060,25 +4062,16 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 	return rc;
 }
 
-static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static void sync_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	struct runtime_instr_cb *riccb;
 	struct gs_cb *gscb;
 
-	riccb = (struct runtime_instr_cb *) &kvm_run->s.regs.riccb;
-	gscb = (struct gs_cb *) &kvm_run->s.regs.gscb;
 	vcpu->arch.sie_block->gpsw.mask = kvm_run->psw_mask;
 	vcpu->arch.sie_block->gpsw.addr = kvm_run->psw_addr;
-	if (kvm_run->kvm_dirty_regs & KVM_SYNC_PREFIX)
-		kvm_s390_set_prefix(vcpu, kvm_run->s.regs.prefix);
-	if (kvm_run->kvm_dirty_regs & KVM_SYNC_CRS) {
-		memcpy(&vcpu->arch.sie_block->gcr, &kvm_run->s.regs.crs, 128);
-		/* some control register changes require a tlb flush */
-		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
-	}
+	riccb = (struct runtime_instr_cb *) &kvm_run->s.regs.riccb;
+	gscb = (struct gs_cb *) &kvm_run->s.regs.gscb;
 	if (kvm_run->kvm_dirty_regs & KVM_SYNC_ARCH0) {
-		kvm_s390_set_cpu_timer(vcpu, kvm_run->s.regs.cputm);
-		vcpu->arch.sie_block->ckc = kvm_run->s.regs.ckc;
 		vcpu->arch.sie_block->todpr = kvm_run->s.regs.todpr;
 		vcpu->arch.sie_block->pp = kvm_run->s.regs.pp;
 		vcpu->arch.sie_block->gbea = kvm_run->s.regs.gbea;
@@ -4119,6 +4112,47 @@ static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		vcpu->arch.sie_block->fpf &= ~FPF_BPBC;
 		vcpu->arch.sie_block->fpf |= kvm_run->s.regs.bpbc ? FPF_BPBC : 0;
 	}
+	if (MACHINE_HAS_GS) {
+		preempt_disable();
+		__ctl_set_bit(2, 4);
+		if (current->thread.gs_cb) {
+			vcpu->arch.host_gscb = current->thread.gs_cb;
+			save_gs_cb(vcpu->arch.host_gscb);
+		}
+		if (vcpu->arch.gs_enabled) {
+			current->thread.gs_cb = (struct gs_cb *)
+						&vcpu->run->s.regs.gscb;
+			restore_gs_cb(current->thread.gs_cb);
+		}
+		preempt_enable();
+	}
+	/* SIE will load etoken directly from SDNX and therefore kvm_run */
+}
+
+static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	/*
+	 * at several places we have to modify our internal view to not do
+	 * things that are disallowed by the ultravisor. For example we must
+	 * not inject interrupts after specific exits (e.g. 112). We do this
+	 * by turning off the MIE bits of our PSW copy. To avoid getting
+	 * validity intercepts, we do only accept the condition code from
+	 * userspace.
+	 */
+	vcpu->arch.sie_block->gpsw.mask &= ~PSW_MASK_CC;
+	vcpu->arch.sie_block->gpsw.mask |= kvm_run->psw_mask & PSW_MASK_CC;
+
+	if (kvm_run->kvm_dirty_regs & KVM_SYNC_PREFIX)
+		kvm_s390_set_prefix(vcpu, kvm_run->s.regs.prefix);
+	if (kvm_run->kvm_dirty_regs & KVM_SYNC_CRS) {
+		memcpy(&vcpu->arch.sie_block->gcr, &kvm_run->s.regs.crs, 128);
+		/* some control register changes require a tlb flush */
+		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
+	}
+	if (kvm_run->kvm_dirty_regs & KVM_SYNC_ARCH0) {
+		kvm_s390_set_cpu_timer(vcpu, kvm_run->s.regs.cputm);
+		vcpu->arch.sie_block->ckc = kvm_run->s.regs.ckc;
+	}
 	save_access_regs(vcpu->arch.host_acrs);
 	restore_access_regs(vcpu->run->s.regs.acrs);
 	/* save host (userspace) fprs/vrs */
@@ -4133,23 +4167,31 @@ static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	if (test_fp_ctl(current->thread.fpu.fpc))
 		/* User space provided an invalid FPC, let's clear it */
 		current->thread.fpu.fpc = 0;
+
+	/* Sync fmt2 only data */
+	if (likely(!kvm_s390_pv_is_protected(vcpu->kvm)))
+		sync_regs_fmt2(vcpu, kvm_run);
+	kvm_run->kvm_dirty_regs = 0;
+}
+
+static void store_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	kvm_run->s.regs.pp = vcpu->arch.sie_block->pp;
+	kvm_run->s.regs.gbea = vcpu->arch.sie_block->gbea;
+	kvm_run->s.regs.bpbc = (vcpu->arch.sie_block->fpf & FPF_BPBC) == FPF_BPBC;
 	if (MACHINE_HAS_GS) {
-		preempt_disable();
 		__ctl_set_bit(2, 4);
-		if (current->thread.gs_cb) {
-			vcpu->arch.host_gscb = current->thread.gs_cb;
-			save_gs_cb(vcpu->arch.host_gscb);
-		}
-		if (vcpu->arch.gs_enabled) {
-			current->thread.gs_cb = (struct gs_cb *)
-						&vcpu->run->s.regs.gscb;
-			restore_gs_cb(current->thread.gs_cb);
-		}
+		if (vcpu->arch.gs_enabled)
+			save_gs_cb(current->thread.gs_cb);
+		preempt_disable();
+		current->thread.gs_cb = vcpu->arch.host_gscb;
+		restore_gs_cb(vcpu->arch.host_gscb);
 		preempt_enable();
+		if (!vcpu->arch.host_gscb)
+			__ctl_clear_bit(2, 4);
+		vcpu->arch.host_gscb = NULL;
 	}
-	/* SIE will load etoken directly from SDNX and therefore kvm_run */
-
-	kvm_run->kvm_dirty_regs = 0;
+	/* SIE will save etoken directly into SDNX and therefore kvm_run */
 }
 
 static void store_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
@@ -4161,12 +4203,9 @@ static void store_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	kvm_run->s.regs.cputm = kvm_s390_get_cpu_timer(vcpu);
 	kvm_run->s.regs.ckc = vcpu->arch.sie_block->ckc;
 	kvm_run->s.regs.todpr = vcpu->arch.sie_block->todpr;
-	kvm_run->s.regs.pp = vcpu->arch.sie_block->pp;
-	kvm_run->s.regs.gbea = vcpu->arch.sie_block->gbea;
 	kvm_run->s.regs.pft = vcpu->arch.pfault_token;
 	kvm_run->s.regs.pfs = vcpu->arch.pfault_select;
 	kvm_run->s.regs.pfc = vcpu->arch.pfault_compare;
-	kvm_run->s.regs.bpbc = (vcpu->arch.sie_block->fpf & FPF_BPBC) == FPF_BPBC;
 	save_access_regs(vcpu->run->s.regs.acrs);
 	restore_access_regs(vcpu->arch.host_acrs);
 	/* Save guest register state */
@@ -4175,19 +4214,8 @@ static void store_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	/* Restore will be done lazily at return */
 	current->thread.fpu.fpc = vcpu->arch.host_fpregs.fpc;
 	current->thread.fpu.regs = vcpu->arch.host_fpregs.regs;
-	if (MACHINE_HAS_GS) {
-		__ctl_set_bit(2, 4);
-		if (vcpu->arch.gs_enabled)
-			save_gs_cb(current->thread.gs_cb);
-		preempt_disable();
-		current->thread.gs_cb = vcpu->arch.host_gscb;
-		restore_gs_cb(vcpu->arch.host_gscb);
-		preempt_enable();
-		if (!vcpu->arch.host_gscb)
-			__ctl_clear_bit(2, 4);
-		vcpu->arch.host_gscb = NULL;
-	}
-	/* SIE will save etoken directly into SDNX and therefore kvm_run */
+	if (likely(!kvm_s390_pv_is_protected(vcpu->kvm)))
+		store_regs_fmt2(vcpu, kvm_run);
 }
 
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
-- 
2.24.0

