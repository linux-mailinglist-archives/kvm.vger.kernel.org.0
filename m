Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC6414DAAC
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 13:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgA3MfN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 07:35:13 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46426 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727132AbgA3MfN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jan 2020 07:35:13 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00UCZ0L6018341
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2020 07:35:12 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xubctbkn8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2020 07:35:09 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 30 Jan 2020 12:34:52 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 30 Jan 2020 12:34:49 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00UCYmdd54526034
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jan 2020 12:34:48 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1928B5205F;
        Thu, 30 Jan 2020 12:34:48 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.44])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 7983A52057;
        Thu, 30 Jan 2020 12:34:46 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com, david@redhat.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
Subject: [PATCH v9 3/6] KVM: s390: Add new reset vcpu API
Date:   Thu, 30 Jan 2020 07:34:31 -0500
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200130123434.68129-1-frankja@linux.ibm.com>
References: <20200130123434.68129-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20013012-0016-0000-0000-000002E2285E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20013012-0017-0000-0000-00003344F265
Message-Id: <20200130123434.68129-4-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-30_03:2020-01-28,2020-01-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 clxscore=1015 adultscore=0 phishscore=0 suspectscore=1 malwarescore=0
 priorityscore=1501 spamscore=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001300092
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The architecture states that we need to reset local IRQs for all CPU
resets. Because the old reset interface did not support the normal CPU
reset we never did that on a normal reset.

Let's implement an interface for the missing normal and clear resets
and reset all local IRQs, registers and control structures as stated
in the architecture.

Userspace might already reset the registers via the vcpu run struct,
but as we need the interface for the interrupt clearing part anyway,
we implement the resets fully and don't rely on userspace to reset the
rest.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 Documentation/virt/kvm/api.txt | 43 +++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.c       | 63 +++++++++++++++++++++++++++++++---
 include/uapi/linux/kvm.h       |  5 +++
 3 files changed, 107 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
index ebb37b34dcfc..73448764f544 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -4168,6 +4168,42 @@ This ioctl issues an ultravisor call to terminate the secure guest,
 unpins the VPA pages and releases all the device pages that are used to
 track the secure pages by hypervisor.
 
+4.122 KVM_S390_NORMAL_RESET
+
+Capability: KVM_CAP_S390_VCPU_RESETS
+Architectures: s390
+Type: vcpu ioctl
+Parameters: none
+Returns: 0
+
+This ioctl resets VCPU registers and control structures according to
+the cpu reset definition in the POP (Principles Of Operation).
+
+4.123 KVM_S390_INITIAL_RESET
+
+Capability: none
+Architectures: s390
+Type: vcpu ioctl
+Parameters: none
+Returns: 0
+
+This ioctl resets VCPU registers and control structures according to
+the initial cpu reset definition in the POP. However, the cpu is not
+put into ESA mode. This reset is a superset of the normal reset.
+
+4.124 KVM_S390_CLEAR_RESET
+
+Capability: KVM_CAP_S390_VCPU_RESETS
+Architectures: s390
+Type: vcpu ioctl
+Parameters: none
+Returns: 0
+
+This ioctl resets VCPU registers and control structures according to
+the clear cpu reset definition in the POP. However, the cpu is not put
+into ESA mode. This reset is a superset of the initial reset.
+
+
 5. The kvm_run structure
 ------------------------
 
@@ -5396,3 +5432,10 @@ handling by KVM (as some KVM hypercall may be mistakenly treated as TLB
 flush hypercalls by Hyper-V) so userspace should disable KVM identification
 in CPUID and only exposes Hyper-V identification. In this case, guest
 thinks it's running on Hyper-V and only use Hyper-V hypercalls.
+
+8.22 KVM_CAP_S390_VCPU_RESETS
+
+Architectures: s390
+
+This capability indicates that the KVM_S390_NORMAL_RESET and
+KVM_S390_CLEAR_RESET ioctls are available.
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index e0a0799b384e..7ecc5c884840 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -529,6 +529,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_S390_CMMA_MIGRATION:
 	case KVM_CAP_S390_AIS:
 	case KVM_CAP_S390_AIS_MIGRATION:
+	case KVM_CAP_S390_VCPU_RESETS:
 		r = 1;
 		break;
 	case KVM_CAP_S390_HPAGE_1M:
@@ -3274,10 +3275,55 @@ static int kvm_arch_vcpu_ioctl_set_one_reg(struct kvm_vcpu *vcpu,
 	return r;
 }
 
-static int kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
+static void kvm_arch_vcpu_ioctl_normal_reset(struct kvm_vcpu *vcpu)
 {
-	kvm_s390_vcpu_initial_reset(vcpu);
-	return 0;
+	vcpu->arch.sie_block->gpsw.mask &= ~PSW_MASK_RI;
+	vcpu->arch.pfault_token = KVM_S390_PFAULT_TOKEN_INVALID;
+	memset(vcpu->run->s.regs.riccb, 0, sizeof(vcpu->run->s.regs.riccb));
+
+	kvm_clear_async_pf_completion_queue(vcpu);
+	if (!kvm_s390_user_cpu_state_ctrl(vcpu->kvm))
+		kvm_s390_vcpu_stop(vcpu);
+	kvm_s390_clear_local_irqs(vcpu);
+}
+
+static void kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
+{
+	/* Initial reset is a superset of the normal reset */
+	kvm_arch_vcpu_ioctl_normal_reset(vcpu);
+
+	/* this equals initial cpu reset in pop, but we don't switch to ESA */
+	vcpu->arch.sie_block->gpsw.mask = 0;
+	vcpu->arch.sie_block->gpsw.addr = 0;
+	kvm_s390_set_prefix(vcpu, 0);
+	kvm_s390_set_cpu_timer(vcpu, 0);
+	vcpu->arch.sie_block->ckc = 0;
+	vcpu->arch.sie_block->todpr = 0;
+	memset(vcpu->arch.sie_block->gcr, 0, sizeof(vcpu->arch.sie_block->gcr));
+	vcpu->arch.sie_block->gcr[0] = CR0_INITIAL_MASK;
+	vcpu->arch.sie_block->gcr[14] = CR14_INITIAL_MASK;
+	/* make sure the new fpc will be lazily loaded */
+	save_fpu_regs();
+	current->thread.fpu.fpc = 0;
+	vcpu->arch.sie_block->gbea = 1;
+	vcpu->arch.sie_block->pp = 0;
+	vcpu->arch.sie_block->fpf &= ~FPF_BPBC;
+}
+
+static void kvm_arch_vcpu_ioctl_clear_reset(struct kvm_vcpu *vcpu)
+{
+	struct kvm_sync_regs *regs = &vcpu->run->s.regs;
+
+	/* Clear reset is a superset of the initial reset */
+	kvm_arch_vcpu_ioctl_initial_reset(vcpu);
+
+	memset(&regs->gprs, 0, sizeof(regs->gprs));
+	memset(&regs->vrs, 0, sizeof(regs->vrs));
+	memset(&regs->acrs, 0, sizeof(regs->acrs));
+	memset(&regs->gscb, 0, sizeof(regs->gscb));
+
+	regs->etoken = 0;
+	regs->etoken_extension = 0;
 }
 
 int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
@@ -4350,8 +4396,17 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = kvm_arch_vcpu_ioctl_set_initial_psw(vcpu, psw);
 		break;
 	}
+	case KVM_S390_CLEAR_RESET:
+		r = 0;
+		kvm_arch_vcpu_ioctl_clear_reset(vcpu);
+		break;
 	case KVM_S390_INITIAL_RESET:
-		r = kvm_arch_vcpu_ioctl_initial_reset(vcpu);
+		r = 0;
+		kvm_arch_vcpu_ioctl_initial_reset(vcpu);
+		break;
+	case KVM_S390_NORMAL_RESET:
+		r = 0;
+		kvm_arch_vcpu_ioctl_normal_reset(vcpu);
 		break;
 	case KVM_SET_ONE_REG:
 	case KVM_GET_ONE_REG: {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f0a16b4adbbd..4b95f9a31a2f 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1009,6 +1009,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PPC_GUEST_DEBUG_SSTEP 176
 #define KVM_CAP_ARM_NISV_TO_USER 177
 #define KVM_CAP_ARM_INJECT_EXT_DABT 178
+#define KVM_CAP_S390_VCPU_RESETS 179
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1473,6 +1474,10 @@ struct kvm_enc_region {
 /* Available with KVM_CAP_ARM_SVE */
 #define KVM_ARM_VCPU_FINALIZE	  _IOW(KVMIO,  0xc2, int)
 
+/* Available with  KVM_CAP_S390_VCPU_RESETS */
+#define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
+#define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.20.1

