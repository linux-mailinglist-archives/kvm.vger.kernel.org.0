Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99836232FD2
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 11:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729433AbgG3JtH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 05:49:07 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25620 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726832AbgG3JtF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jul 2020 05:49:05 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06U9VoHJ138883;
        Thu, 30 Jul 2020 05:49:04 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32ks38dbq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jul 2020 05:49:04 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06U9X63G143620;
        Thu, 30 Jul 2020 05:49:03 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32ks38dbpn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jul 2020 05:49:03 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06U9jVYG010309;
        Thu, 30 Jul 2020 09:49:02 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 32gcqk3pa3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jul 2020 09:49:01 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06U9mx6821692852
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jul 2020 09:48:59 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0777F11C04C;
        Thu, 30 Jul 2020 09:48:59 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E19DA11C050;
        Thu, 30 Jul 2020 09:48:58 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 30 Jul 2020 09:48:58 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 9EBF1E0661; Thu, 30 Jul 2020 11:48:58 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Collin Walling <walling@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [GIT PULL 2/2] s390/kvm: diagnose 0x318 sync and reset
Date:   Thu, 30 Jul 2020 11:48:57 +0200
Message-Id: <20200730094857.175501-3-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200730094857.175501-1-borntraeger@de.ibm.com>
References: <20200730094857.175501-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-30_05:2020-07-30,2020-07-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 clxscore=1015
 impostorscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007300066
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Collin Walling <walling@linux.ibm.com>

DIAGNOSE 0x318 (diag318) sets information regarding the environment
the VM is running in (Linux, z/VM, etc) and is observed via
firmware/service events.

This is a privileged s390x instruction that must be intercepted by
SIE. Userspace handles the instruction as well as migration. Data
is communicated via VCPU register synchronization.

The Control Program Name Code (CPNC) is stored in the SIE block. The
CPNC along with the Control Program Version Code (CPVC) are stored
in the kvm_vcpu_arch struct.

This data is reset on load normal and clear resets.

Signed-off-by: Collin Walling <walling@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Acked-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/20200622154636.5499-3-walling@linux.ibm.com
[borntraeger@de.ibm.com: fix sync_reg position]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  4 +++-
 arch/s390/include/uapi/asm/kvm.h |  7 +++++--
 arch/s390/kvm/kvm-s390.c         | 11 ++++++++++-
 arch/s390/kvm/vsie.c             |  1 +
 include/uapi/linux/kvm.h         |  1 +
 5 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index cee3cb6455a2..371ec6beb618 100644
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
index 436ec7636927..7a6b14874d65 100644
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
@@ -264,7 +266,8 @@ struct kvm_sync_regs {
 	__u8 reserved2 : 7;
 	__u8 padding1[51];	/* riccb needs to be 64byte aligned */
 	__u8 riccb[64];		/* runtime instrumentation controls block */
-	__u8 padding2[192];	/* sdnx needs to be 256byte aligned */
+	__u64 diag318;		/* diagnose 0x318 info */
+	__u8 padding2[184];	/* sdnx needs to be 256byte aligned */
 	union {
 		__u8 sdnx[SDNXL];  /* state description annex */
 		struct {
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d47c19718615..08e6cf6cb454 100644
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
@@ -4196,6 +4200,10 @@ static void sync_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
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
@@ -4297,6 +4305,7 @@ static void store_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	kvm_run->s.regs.pp = vcpu->arch.sie_block->pp;
 	kvm_run->s.regs.gbea = vcpu->arch.sie_block->gbea;
 	kvm_run->s.regs.bpbc = (vcpu->arch.sie_block->fpf & FPF_BPBC) == FPF_BPBC;
+	kvm_run->s.regs.diag318 = vcpu->arch.diag318_info.val;
 	if (MACHINE_HAS_GS) {
 		__ctl_set_bit(2, 4);
 		if (vcpu->arch.gs_enabled)
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 9e9056cebfcf..4f3cbf6003a9 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -548,6 +548,7 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
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
2.25.4

