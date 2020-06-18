Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C88F1FFDEB
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 00:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732053AbgFRWWt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 18:22:49 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43524 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732007AbgFRWWq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Jun 2020 18:22:46 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05IM4aDS002370;
        Thu, 18 Jun 2020 18:22:46 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31rekd3p82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Jun 2020 18:22:45 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05IM6Asa015108;
        Thu, 18 Jun 2020 18:22:45 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31rekd3p7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Jun 2020 18:22:45 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05IMJICR025817;
        Thu, 18 Jun 2020 22:22:44 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02dal.us.ibm.com with ESMTP id 31q6c8n6fb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Jun 2020 22:22:44 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05IMMfgB52363614
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Jun 2020 22:22:41 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5DB9A6E04C;
        Thu, 18 Jun 2020 22:22:41 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6EFD66E056;
        Thu, 18 Jun 2020 22:22:40 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.159.16])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 18 Jun 2020 22:22:40 +0000 (GMT)
From:   Collin Walling <walling@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com, thuth@redhat.com
Subject: [PATCH v8 2/2] s390/kvm: diagnose 0x318 sync and reset
Date:   Thu, 18 Jun 2020 18:22:22 -0400
Message-Id: <20200618222222.23175-3-walling@linux.ibm.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200618222222.23175-1-walling@linux.ibm.com>
References: <20200618222222.23175-1-walling@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-18_21:2020-06-18,2020-06-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 cotscore=-2147483648 mlxlogscore=999 impostorscore=0 bulkscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 suspectscore=8 adultscore=0 malwarescore=0 mlxscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006180164
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DIAGNOSE 0x318 (diag318) sets information regarding the environment
the VM is running in (Linux, z/VM, etc) and is observed via
firmware/service events.

This is a privileged s390x instruction that must be intercepted by
SIE. Userspace handles the instruction as well as migration. Data
is communicated via VCPU register synchronization.

The Control Program Name Code (CPNC) is stored in the SIE block. The
CPNC along with the Control Program Version Code (CPVC) are stored
in the kvm_vcpu_arch struct.

The CPNC is shadowed/unshadowed in VSIE.

This data is reset on load normal and clear resets.

Signed-off-by: Collin Walling <walling@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  4 +++-
 arch/s390/include/uapi/asm/kvm.h |  5 ++++-
 arch/s390/kvm/kvm-s390.c         | 11 ++++++++++-
 arch/s390/kvm/vsie.c             |  3 +++
 include/uapi/linux/kvm.h         |  1 +
 5 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 3d554887794e..8bdf6f1607ca 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -260,7 +260,8 @@ struct kvm_s390_sie_block {
 	__u32	scaol;			/* 0x0064 */
 	__u8	sdf;			/* 0x0068 */
 	__u8    epdx;			/* 0x0069 */
-	__u8    reserved6a[2];		/* 0x006a */
+	__u8	cpnc;			/* 0x006a */
+	__u8	reserved6b;		/* 0x006b */
 	__u32	todpr;			/* 0x006c */
 #define GISA_FORMAT1 0x00000001
 	__u32	gd;			/* 0x0070 */
@@ -745,6 +746,7 @@ struct kvm_vcpu_arch {
 	bool gs_enabled;
 	bool skey_enabled;
 	struct kvm_s390_pv_vcpu pv;
+	union diag318_info diag318_info;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
index 436ec7636927..2ae1b660086c 100644
--- a/arch/s390/include/uapi/asm/kvm.h
+++ b/arch/s390/include/uapi/asm/kvm.h
@@ -231,11 +231,13 @@ struct kvm_guest_debug_arch {
 #define KVM_SYNC_GSCB   (1UL << 9)
 #define KVM_SYNC_BPBC   (1UL << 10)
 #define KVM_SYNC_ETOKEN (1UL << 11)
+#define KVM_SYNC_DIAG318 (1UL << 12)
 
 #define KVM_SYNC_S390_VALID_FIELDS \
 	(KVM_SYNC_PREFIX | KVM_SYNC_GPRS | KVM_SYNC_ACRS | KVM_SYNC_CRS | \
 	 KVM_SYNC_ARCH0 | KVM_SYNC_PFAULT | KVM_SYNC_VRS | KVM_SYNC_RICCB | \
-	 KVM_SYNC_FPRS | KVM_SYNC_GSCB | KVM_SYNC_BPBC | KVM_SYNC_ETOKEN)
+	 KVM_SYNC_FPRS | KVM_SYNC_GSCB | KVM_SYNC_BPBC | KVM_SYNC_ETOKEN | \
+	 KVM_SYNC_DIAG318)
 
 /* length and alignment of the sdnx as a power of two */
 #define SDNXC 8
@@ -254,6 +256,7 @@ struct kvm_sync_regs {
 	__u64 pft;	/* pfault token [PFAULT] */
 	__u64 pfs;	/* pfault select [PFAULT] */
 	__u64 pfc;	/* pfault compare [PFAULT] */
+	__u64 diag318;	/* diagnose 0x318 info */
 	union {
 		__u64 vrs[32][2];	/* vector registers (KVM_SYNC_VRS) */
 		__u64 fprs[16];		/* fp registers (KVM_SYNC_FPRS) */
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d0ff26d157bc..b05ad718b64b 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -545,6 +545,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_S390_AIS_MIGRATION:
 	case KVM_CAP_S390_VCPU_RESETS:
 	case KVM_CAP_SET_GUEST_DEBUG:
+	case KVM_CAP_S390_DIAG318:
 		r = 1;
 		break;
 	case KVM_CAP_S390_HPAGE_1M:
@@ -3267,7 +3268,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 				    KVM_SYNC_ACRS |
 				    KVM_SYNC_CRS |
 				    KVM_SYNC_ARCH0 |
-				    KVM_SYNC_PFAULT;
+				    KVM_SYNC_PFAULT |
+				    KVM_SYNC_DIAG318;
 	kvm_s390_set_prefix(vcpu, 0);
 	if (test_kvm_facility(vcpu->kvm, 64))
 		vcpu->run->kvm_valid_regs |= KVM_SYNC_RICCB;
@@ -3562,6 +3564,7 @@ static void kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
 		vcpu->arch.sie_block->pp = 0;
 		vcpu->arch.sie_block->fpf &= ~FPF_BPBC;
 		vcpu->arch.sie_block->todpr = 0;
+		vcpu->arch.sie_block->cpnc = 0;
 	}
 }
 
@@ -3579,6 +3582,7 @@ static void kvm_arch_vcpu_ioctl_clear_reset(struct kvm_vcpu *vcpu)
 
 	regs->etoken = 0;
 	regs->etoken_extension = 0;
+	regs->diag318 = 0;
 }
 
 int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
@@ -4194,6 +4198,10 @@ static void sync_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		if (vcpu->arch.pfault_token == KVM_S390_PFAULT_TOKEN_INVALID)
 			kvm_clear_async_pf_completion_queue(vcpu);
 	}
+	if (kvm_run->kvm_dirty_regs & KVM_SYNC_DIAG318) {
+		vcpu->arch.diag318_info.val = kvm_run->s.regs.diag318;
+		vcpu->arch.sie_block->cpnc = vcpu->arch.diag318_info.cpnc;
+	}
 	/*
 	 * If userspace sets the riccb (e.g. after migration) to a valid state,
 	 * we should enable RI here instead of doing the lazy enablement.
@@ -4295,6 +4303,7 @@ static void store_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	kvm_run->s.regs.pp = vcpu->arch.sie_block->pp;
 	kvm_run->s.regs.gbea = vcpu->arch.sie_block->gbea;
 	kvm_run->s.regs.bpbc = (vcpu->arch.sie_block->fpf & FPF_BPBC) == FPF_BPBC;
+	kvm_run->s.regs.diag318 = vcpu->arch.diag318_info.val;
 	if (MACHINE_HAS_GS) {
 		__ctl_set_bit(2, 4);
 		if (vcpu->arch.gs_enabled)
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 9e9056cebfcf..ba83d0568bc7 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -423,6 +423,8 @@ static void unshadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 		break;
 	}
 
+	scb_o->cpnc = scb_s->cpnc;
+
 	if (scb_s->ihcpu != 0xffffU)
 		scb_o->ihcpu = scb_s->ihcpu;
 }
@@ -548,6 +550,7 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 		scb_s->ecd |= scb_o->ecd & ECD_ETOKENF;
 
 	scb_s->hpid = HPID_VSIE;
+	scb_s->cpnc = scb_o->cpnc;
 
 	prepare_ibc(vcpu, vsie_page);
 	rc = shadow_crycb(vcpu, vsie_page);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 4fdf30316582..35cdb4307904 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1031,6 +1031,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PPC_SECURE_GUEST 181
 #define KVM_CAP_HALT_POLL 182
 #define KVM_CAP_ASYNC_PF_INT 183
+#define KVM_CAP_S390_DIAG318 184
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.21.3

