Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8721516A52A
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 12:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727724AbgBXLlf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 06:41:35 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45914 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727486AbgBXLlR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Feb 2020 06:41:17 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01OBdMfc108465;
        Mon, 24 Feb 2020 06:41:16 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb1pgc6b1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 06:41:16 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01OBfF8Z116449;
        Mon, 24 Feb 2020 06:41:15 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb1pgc6ah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 06:41:15 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01OBdol6030261;
        Mon, 24 Feb 2020 11:41:14 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01dal.us.ibm.com with ESMTP id 2yaux6fwdb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 11:41:14 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01OBfC7D40239444
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 11:41:12 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63DCF2805A;
        Mon, 24 Feb 2020 11:41:12 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3FF212805C;
        Mon, 24 Feb 2020 11:41:12 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 24 Feb 2020 11:41:12 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [PATCH v4 25/36] KVM: s390: protvirt: Only sync fmt4 registers
Date:   Mon, 24 Feb 2020 06:40:56 -0500
Message-Id: <20200224114107.4646-26-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200224114107.4646-1-borntraeger@de.ibm.com>
References: <20200224114107.4646-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-24_02:2020-02-21,2020-02-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=860
 clxscore=1015 suspectscore=0 lowpriorityscore=0 priorityscore=1501
 mlxscore=0 malwarescore=0 phishscore=0 impostorscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240099
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
Reviewed-by: David Hildenbrand <david@redhat.com>
[borntraeger@de.ibm.com: patch merging, splitting, fixing]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 110 +++++++++++++++++++++++++--------------
 1 file changed, 70 insertions(+), 40 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index c734e89235f9..d6dcd0f5859f 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4105,7 +4105,7 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 	return rc;
 }
 
-static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static void sync_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	struct runtime_instr_cb *riccb;
 	struct gs_cb *gscb;
@@ -4114,16 +4114,7 @@ static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	gscb = (struct gs_cb *) &kvm_run->s.regs.gscb;
 	vcpu->arch.sie_block->gpsw.mask = kvm_run->psw_mask;
 	vcpu->arch.sie_block->gpsw.addr = kvm_run->psw_addr;
-	if (kvm_run->kvm_dirty_regs & KVM_SYNC_PREFIX)
-		kvm_s390_set_prefix(vcpu, kvm_run->s.regs.prefix);
-	if (kvm_run->kvm_dirty_regs & KVM_SYNC_CRS) {
-		memcpy(&vcpu->arch.sie_block->gcr, &kvm_run->s.regs.crs, 128);
-		/* some control register changes require a tlb flush */
-		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
-	}
 	if (kvm_run->kvm_dirty_regs & KVM_SYNC_ARCH0) {
-		kvm_s390_set_cpu_timer(vcpu, kvm_run->s.regs.cputm);
-		vcpu->arch.sie_block->ckc = kvm_run->s.regs.ckc;
 		vcpu->arch.sie_block->todpr = kvm_run->s.regs.todpr;
 		vcpu->arch.sie_block->pp = kvm_run->s.regs.pp;
 		vcpu->arch.sie_block->gbea = kvm_run->s.regs.gbea;
@@ -4164,6 +4155,36 @@ static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
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
@@ -4178,23 +4199,47 @@ static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	if (test_fp_ctl(current->thread.fpu.fpc))
 		/* User space provided an invalid FPC, let's clear it */
 		current->thread.fpu.fpc = 0;
+
+	/* Sync fmt2 only data */
+	if (likely(!kvm_s390_pv_cpu_is_protected(vcpu))) {
+		sync_regs_fmt2(vcpu, kvm_run);
+	} else {
+		/*
+		 * In several places we have to modify our internal view to
+		 * not do things that are disallowed by the ultravisor. For
+		 * example we must not inject interrupts after specific exits
+		 * (e.g. 112 prefix page not secure). We do this by turning
+		 * off the machine check, external and I/O interrupt bits
+		 * of our PSW copy. To avoid getting validity intercepts, we
+		 * do only accept the condition code from userspace.
+		 */
+		vcpu->arch.sie_block->gpsw.mask &= ~PSW_MASK_CC;
+		vcpu->arch.sie_block->gpsw.mask |= kvm_run->psw_mask &
+						   PSW_MASK_CC;
+	}
+
+	kvm_run->kvm_dirty_regs = 0;
+}
+
+static void store_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	kvm_run->s.regs.todpr = vcpu->arch.sie_block->todpr;
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
@@ -4205,13 +4250,9 @@ static void store_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	memcpy(&kvm_run->s.regs.crs, &vcpu->arch.sie_block->gcr, 128);
 	kvm_run->s.regs.cputm = kvm_s390_get_cpu_timer(vcpu);
 	kvm_run->s.regs.ckc = vcpu->arch.sie_block->ckc;
-	kvm_run->s.regs.todpr = vcpu->arch.sie_block->todpr;
-	kvm_run->s.regs.pp = vcpu->arch.sie_block->pp;
-	kvm_run->s.regs.gbea = vcpu->arch.sie_block->gbea;
 	kvm_run->s.regs.pft = vcpu->arch.pfault_token;
 	kvm_run->s.regs.pfs = vcpu->arch.pfault_select;
 	kvm_run->s.regs.pfc = vcpu->arch.pfault_compare;
-	kvm_run->s.regs.bpbc = (vcpu->arch.sie_block->fpf & FPF_BPBC) == FPF_BPBC;
 	save_access_regs(vcpu->run->s.regs.acrs);
 	restore_access_regs(vcpu->arch.host_acrs);
 	/* Save guest register state */
@@ -4220,19 +4261,8 @@ static void store_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
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
+	if (likely(!kvm_s390_pv_cpu_is_protected(vcpu)))
+		store_regs_fmt2(vcpu, kvm_run);
 }
 
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
-- 
2.25.0

