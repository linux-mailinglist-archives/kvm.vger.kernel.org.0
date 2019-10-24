Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43657E30DF
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 13:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439166AbfJXLmi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 07:42:38 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19694 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2439106AbfJXLmh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Oct 2019 07:42:37 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9OBbUDD011433
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:42:36 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vu9avvrdr-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:42:36 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 24 Oct 2019 12:42:34 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 24 Oct 2019 12:42:31 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9OBgTIG50921542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 11:42:29 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55E5C52054;
        Thu, 24 Oct 2019 11:42:29 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A9CB652052;
        Thu, 24 Oct 2019 11:42:27 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com, frankja@linux.ibm.com
Subject: [RFC 26/37] KVM: s390: protvirt: Only sync fmt4 registers
Date:   Thu, 24 Oct 2019 07:40:48 -0400
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024114059.102802-1-frankja@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19102411-0020-0000-0000-0000037DCE92
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102411-0021-0000-0000-000021D414FB
Message-Id: <20191024114059.102802-27-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-24_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=596 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910240115
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A lot of the registers are controlled by the Ultravisor and never
visible to KVM. Also some registers are overlayed, like gbea is with
sidad, which might leak data to userspace.

Hence we sync a minimal set of registers for both SIE formats and then
check and sync format 2 registers if necessary.

Also we disable set/get one reg for the same reason. It's an old
interface anyway.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 138 +++++++++++++++++++++++----------------
 1 file changed, 82 insertions(+), 56 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 17a78774c617..f623c64aeade 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2997,7 +2997,8 @@ static void kvm_s390_vcpu_initial_reset(struct kvm_vcpu *vcpu)
 	/* make sure the new fpc will be lazily loaded */
 	save_fpu_regs();
 	current->thread.fpu.fpc = 0;
-	vcpu->arch.sie_block->gbea = 1;
+	if (!kvm_s390_pv_is_protected(vcpu->kvm))
+		vcpu->arch.sie_block->gbea = 1;
 	vcpu->arch.sie_block->pp = 0;
 	vcpu->arch.sie_block->fpf &= ~FPF_BPBC;
 	vcpu->arch.pfault_token = KVM_S390_PFAULT_TOKEN_INVALID;
@@ -3367,6 +3368,10 @@ static int kvm_arch_vcpu_ioctl_get_one_reg(struct kvm_vcpu *vcpu,
 			     (u64 __user *)reg->addr);
 		break;
 	case KVM_REG_S390_GBEA:
+		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
+			r = 0;
+			break;
+		}
 		r = put_user(vcpu->arch.sie_block->gbea,
 			     (u64 __user *)reg->addr);
 		break;
@@ -3420,6 +3425,10 @@ static int kvm_arch_vcpu_ioctl_set_one_reg(struct kvm_vcpu *vcpu,
 			     (u64 __user *)reg->addr);
 		break;
 	case KVM_REG_S390_GBEA:
+		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
+			r = 0;
+			break;
+		}
 		r = get_user(vcpu->arch.sie_block->gbea,
 			     (u64 __user *)reg->addr);
 		break;
@@ -4023,28 +4032,19 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 	return rc;
 }
 
-static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static void sync_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	struct runtime_instr_cb *riccb;
 	struct gs_cb *gscb;
 
 	riccb = (struct runtime_instr_cb *) &kvm_run->s.regs.riccb;
 	gscb = (struct gs_cb *) &kvm_run->s.regs.gscb;
-	vcpu->arch.sie_block->gpsw.mask = kvm_run->psw_mask;
-	vcpu->arch.sie_block->gpsw.addr = kvm_run->psw_addr;
-	if (kvm_run->kvm_dirty_regs & KVM_SYNC_PREFIX)
-		kvm_s390_set_prefix(vcpu, kvm_run->s.regs.prefix);
-	if (kvm_run->kvm_dirty_regs & KVM_SYNC_CRS) {
-		memcpy(&vcpu->arch.sie_block->gcr, &kvm_run->s.regs.crs, 128);
-		/* some control register changes require a tlb flush */
-		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
-	}
-	if (kvm_run->kvm_dirty_regs & KVM_SYNC_ARCH0) {
-		kvm_s390_set_cpu_timer(vcpu, kvm_run->s.regs.cputm);
-		vcpu->arch.sie_block->ckc = kvm_run->s.regs.ckc;
-		vcpu->arch.sie_block->todpr = kvm_run->s.regs.todpr;
-		vcpu->arch.sie_block->pp = kvm_run->s.regs.pp;
-		vcpu->arch.sie_block->gbea = kvm_run->s.regs.gbea;
+	if (kvm_run->kvm_dirty_regs & KVM_SYNC_ARCH0)
+		  vcpu->arch.sie_block->gbea = kvm_run->s.regs.gbea;
+	if ((kvm_run->kvm_dirty_regs & KVM_SYNC_BPBC) &&
+	    test_kvm_facility(vcpu->kvm, 82)) {
+		vcpu->arch.sie_block->fpf &= ~FPF_BPBC;
+		vcpu->arch.sie_block->fpf |= kvm_run->s.regs.bpbc ? FPF_BPBC : 0;
 	}
 	if (kvm_run->kvm_dirty_regs & KVM_SYNC_PFAULT) {
 		vcpu->arch.pfault_token = kvm_run->s.regs.pft;
@@ -4077,25 +4077,6 @@ static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		vcpu->arch.sie_block->ecd |= ECD_HOSTREGMGMT;
 		vcpu->arch.gs_enabled = 1;
 	}
-	if ((kvm_run->kvm_dirty_regs & KVM_SYNC_BPBC) &&
-	    test_kvm_facility(vcpu->kvm, 82)) {
-		vcpu->arch.sie_block->fpf &= ~FPF_BPBC;
-		vcpu->arch.sie_block->fpf |= kvm_run->s.regs.bpbc ? FPF_BPBC : 0;
-	}
-	save_access_regs(vcpu->arch.host_acrs);
-	restore_access_regs(vcpu->run->s.regs.acrs);
-	/* save host (userspace) fprs/vrs */
-	save_fpu_regs();
-	vcpu->arch.host_fpregs.fpc = current->thread.fpu.fpc;
-	vcpu->arch.host_fpregs.regs = current->thread.fpu.regs;
-	if (MACHINE_HAS_VX)
-		current->thread.fpu.regs = vcpu->run->s.regs.vrs;
-	else
-		current->thread.fpu.regs = vcpu->run->s.regs.fprs;
-	current->thread.fpu.fpc = vcpu->run->s.regs.fpc;
-	if (test_fp_ctl(current->thread.fpu.fpc))
-		/* User space provided an invalid FPC, let's clear it */
-		current->thread.fpu.fpc = 0;
 	if (MACHINE_HAS_GS) {
 		preempt_disable();
 		__ctl_set_bit(2, 4);
@@ -4111,33 +4092,50 @@ static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		preempt_enable();
 	}
 	/* SIE will load etoken directly from SDNX and therefore kvm_run */
+}
 
+static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	vcpu->arch.sie_block->gpsw.mask = kvm_run->psw_mask;
+	vcpu->arch.sie_block->gpsw.addr = kvm_run->psw_addr;
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
+		vcpu->arch.sie_block->todpr = kvm_run->s.regs.todpr;
+		vcpu->arch.sie_block->pp = kvm_run->s.regs.pp;
+	}
+	save_access_regs(vcpu->arch.host_acrs);
+	restore_access_regs(vcpu->run->s.regs.acrs);
+	/* save host (userspace) fprs/vrs */
+	save_fpu_regs();
+	vcpu->arch.host_fpregs.fpc = current->thread.fpu.fpc;
+	vcpu->arch.host_fpregs.regs = current->thread.fpu.regs;
+	if (MACHINE_HAS_VX)
+		current->thread.fpu.regs = vcpu->run->s.regs.vrs;
+	else
+		current->thread.fpu.regs = vcpu->run->s.regs.fprs;
+	current->thread.fpu.fpc = vcpu->run->s.regs.fpc;
+	if (test_fp_ctl(current->thread.fpu.fpc))
+		/* User space provided an invalid FPC, let's clear it */
+		current->thread.fpu.fpc = 0;
+
+	/* Sync fmt2 only data */
+	if (likely(!kvm_s390_pv_is_protected(vcpu->kvm)))
+		sync_regs_fmt2(vcpu, kvm_run);
 	kvm_run->kvm_dirty_regs = 0;
 }
 
-static void store_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static void store_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
-	kvm_run->psw_mask = vcpu->arch.sie_block->gpsw.mask;
-	kvm_run->psw_addr = vcpu->arch.sie_block->gpsw.addr;
-	kvm_run->s.regs.prefix = kvm_s390_get_prefix(vcpu);
-	memcpy(&kvm_run->s.regs.crs, &vcpu->arch.sie_block->gcr, 128);
-	kvm_run->s.regs.cputm = kvm_s390_get_cpu_timer(vcpu);
-	kvm_run->s.regs.ckc = vcpu->arch.sie_block->ckc;
-	kvm_run->s.regs.todpr = vcpu->arch.sie_block->todpr;
-	kvm_run->s.regs.pp = vcpu->arch.sie_block->pp;
 	kvm_run->s.regs.gbea = vcpu->arch.sie_block->gbea;
-	kvm_run->s.regs.pft = vcpu->arch.pfault_token;
-	kvm_run->s.regs.pfs = vcpu->arch.pfault_select;
-	kvm_run->s.regs.pfc = vcpu->arch.pfault_compare;
 	kvm_run->s.regs.bpbc = (vcpu->arch.sie_block->fpf & FPF_BPBC) == FPF_BPBC;
-	save_access_regs(vcpu->run->s.regs.acrs);
-	restore_access_regs(vcpu->arch.host_acrs);
-	/* Save guest register state */
-	save_fpu_regs();
-	vcpu->run->s.regs.fpc = current->thread.fpu.fpc;
-	/* Restore will be done lazily at return */
-	current->thread.fpu.fpc = vcpu->arch.host_fpregs.fpc;
-	current->thread.fpu.regs = vcpu->arch.host_fpregs.regs;
 	if (MACHINE_HAS_GS) {
 		__ctl_set_bit(2, 4);
 		if (vcpu->arch.gs_enabled)
@@ -4153,6 +4151,31 @@ static void store_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	/* SIE will save etoken directly into SDNX and therefore kvm_run */
 }
 
+static void store_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	kvm_run->psw_mask = vcpu->arch.sie_block->gpsw.mask;
+	kvm_run->psw_addr = vcpu->arch.sie_block->gpsw.addr;
+	kvm_run->s.regs.prefix = kvm_s390_get_prefix(vcpu);
+	memcpy(&kvm_run->s.regs.crs, &vcpu->arch.sie_block->gcr, 128);
+	kvm_run->s.regs.cputm = kvm_s390_get_cpu_timer(vcpu);
+	kvm_run->s.regs.ckc = vcpu->arch.sie_block->ckc;
+	kvm_run->s.regs.todpr = vcpu->arch.sie_block->todpr;
+	kvm_run->s.regs.pp = vcpu->arch.sie_block->pp;
+	kvm_run->s.regs.pft = vcpu->arch.pfault_token;
+	kvm_run->s.regs.pfs = vcpu->arch.pfault_select;
+	kvm_run->s.regs.pfc = vcpu->arch.pfault_compare;
+	save_access_regs(vcpu->run->s.regs.acrs);
+	restore_access_regs(vcpu->arch.host_acrs);
+	/* Save guest register state */
+	save_fpu_regs();
+	vcpu->run->s.regs.fpc = current->thread.fpu.fpc;
+	/* Restore will be done lazily at return */
+	current->thread.fpu.fpc = vcpu->arch.host_fpregs.fpc;
+	current->thread.fpu.regs = vcpu->arch.host_fpregs.regs;
+	if (likely(!kvm_s390_pv_is_protected(vcpu->kvm)))
+		store_regs_fmt2(vcpu, kvm_run);
+}
+
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	int rc;
@@ -4585,6 +4608,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	case KVM_SET_ONE_REG:
 	case KVM_GET_ONE_REG: {
 		struct kvm_one_reg reg;
+		r = -EINVAL;
+		if (kvm_s390_pv_is_protected(vcpu->kvm))
+			break;
 		r = -EFAULT;
 		if (copy_from_user(&reg, argp, sizeof(reg)))
 			break;
-- 
2.20.1

