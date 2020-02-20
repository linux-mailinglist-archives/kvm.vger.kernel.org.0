Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14DF6165BD9
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 11:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgBTKkt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 05:40:49 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59050 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727941AbgBTKkb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 05:40:31 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01KAZJ3X005816;
        Thu, 20 Feb 2020 05:40:29 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y8ubx2ndr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Feb 2020 05:40:29 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01KAZIlh005708;
        Thu, 20 Feb 2020 05:40:29 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y8ubx2ncw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Feb 2020 05:40:29 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01KAVa7N021658;
        Thu, 20 Feb 2020 10:40:27 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03dal.us.ibm.com with ESMTP id 2y6897ex8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Feb 2020 10:40:27 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01KAeP1J48169420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 10:40:25 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F268C112062;
        Thu, 20 Feb 2020 10:40:24 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB0D3112061;
        Thu, 20 Feb 2020 10:40:24 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 20 Feb 2020 10:40:24 +0000 (GMT)
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
Subject: [PATCH v3 26/37] KVM: s390: protvirt: Only sync fmt4 registers
Date:   Thu, 20 Feb 2020 05:40:09 -0500
Message-Id: <20200220104020.5343-27-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200220104020.5343-1-borntraeger@de.ibm.com>
References: <20200220104020.5343-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-20_02:2020-02-19,2020-02-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=764 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200078
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
 arch/s390/kvm/kvm-s390.c | 110 +++++++++++++++++++++++++--------------
 1 file changed, 70 insertions(+), 40 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index db28a717a622..303f994f3d03 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4084,7 +4084,7 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 	return rc;
 }
 
-static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static void sync_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	struct runtime_instr_cb *riccb;
 	struct gs_cb *gscb;
@@ -4093,16 +4093,7 @@ static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
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
@@ -4143,6 +4134,36 @@ static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
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
@@ -4157,23 +4178,47 @@ static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
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
@@ -4184,13 +4229,9 @@ static void store_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
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
@@ -4199,19 +4240,8 @@ static void store_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
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

