Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4AA552D1
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 17:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731366AbfFYPE7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 11:04:59 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2028 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730607AbfFYPE7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jun 2019 11:04:59 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5PF4Str101065;
        Tue, 25 Jun 2019 11:04:37 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tbkamfrc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jun 2019 11:04:35 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x5PExdtx005085;
        Tue, 25 Jun 2019 15:04:06 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01wdc.us.ibm.com with ESMTP id 2t9by6rug2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jun 2019 15:04:06 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5PF45ZZ11928542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jun 2019 15:04:05 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CBDA4B2064;
        Tue, 25 Jun 2019 15:04:05 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1772B2065;
        Tue, 25 Jun 2019 15:04:05 +0000 (GMT)
Received: from collin-T470p.pok.ibm.com (unknown [9.63.14.221])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jun 2019 15:04:05 +0000 (GMT)
From:   Collin Walling <walling@linux.ibm.com>
To:     cohuck@redhat.com, david@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v5 2/2] s390/kvm: diagnose 318 handling
Date:   Tue, 25 Jun 2019 11:03:42 -0400
Message-Id: <1561475022-18348-3-git-send-email-walling@linux.ibm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561475022-18348-1-git-send-email-walling@linux.ibm.com>
References: <1561475022-18348-1-git-send-email-walling@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-25_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906250116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DIAGNOSE 0x318 (diag318) is a privileged s390x instruction that must
be intercepted by SIE and handled via KVM. Let's introduce some
functions to communicate between userspace and KVM via ioctls. These
will be used to get/set the diag318 related information, as well as
check the system if KVM supports handling this instruction.

This information can help with diagnosing the environment the VM is
running in (Linux, z/VM, etc) if the OS calls this instruction.

The get/set functions are introduced primarily for VM migration and
reset, though no harm could be done to the system if a userspace
program decides to alter this data (this is highly discouraged).

The Control Program Name Code (CPNC) is stored in the SIE block (if
host hardware supports it) and a copy is retained in each VCPU. The
Control Program Version Code (CPVC) is not designed to be stored in
the SIE block, so we retain a copy in each VCPU next to the CPNC.

At this time, the CPVC is not reported during a VM_EVENT as its
format is yet to be properly defined.

Signed-off-by: Collin Walling <walling@linux.ibm.com>
---
 Documentation/virtual/kvm/devices/vm.txt | 14 ++++++
 arch/s390/include/asm/kvm_host.h         |  5 +-
 arch/s390/include/uapi/asm/kvm.h         |  4 ++
 arch/s390/kvm/diag.c                     | 17 +++++++
 arch/s390/kvm/kvm-s390.c                 | 81 ++++++++++++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.h                 |  1 +
 arch/s390/kvm/vsie.c                     |  2 +
 7 files changed, 123 insertions(+), 1 deletion(-)

diff --git a/Documentation/virtual/kvm/devices/vm.txt b/Documentation/virtual/kvm/devices/vm.txt
index 4ffb82b..56f7d9c 100644
--- a/Documentation/virtual/kvm/devices/vm.txt
+++ b/Documentation/virtual/kvm/devices/vm.txt
@@ -268,3 +268,17 @@ Parameters: address of a buffer in user space to store the data (u64) to;
 	    if it is enabled
 Returns:    -EFAULT if the given address is not accessible from kernel space
 	    0 in case of success.
+
+6. GROUP: KVM_S390_VM_MISC
+Architectures: s390
+
+6.1. KVM_S390_VM_MISC_DIAG318 (r/w)
+
+Allows userspace to access the DIAGNOSE 0x318 information which consists of a
+1-byte "Control Program Name Code" and a 7-byte "Control Program Version Code".
+This information is initialized during IPL and must be preserved during
+migration.
+
+Parameters: address of a buffer in user space to store the data (u64) to
+Returns:    -EFAULT if the given address is not accessible from kernel space
+	     0 in case of success.
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 2b00a3e..b70e8a4 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -229,7 +229,8 @@ struct kvm_s390_sie_block {
 	__u32	scaol;			/* 0x0064 */
 	__u8	reserved68;		/* 0x0068 */
 	__u8    epdx;			/* 0x0069 */
-	__u8    reserved6a[2];		/* 0x006a */
+	__u8	cpnc;			/* 0x006a */
+	__u8	reserved6b;		/* 0x006b */
 	__u32	todpr;			/* 0x006c */
 #define GISA_FORMAT1 0x00000001
 	__u32	gd;			/* 0x0070 */
@@ -393,6 +394,7 @@ struct kvm_vcpu_stat {
 	u64 diagnose_9c;
 	u64 diagnose_258;
 	u64 diagnose_308;
+	u64 diagnose_318;
 	u64 diagnose_500;
 	u64 diagnose_other;
 };
@@ -868,6 +870,7 @@ struct kvm_arch{
 	DECLARE_BITMAP(cpu_feat, KVM_S390_VM_CPU_FEAT_NR_BITS);
 	DECLARE_BITMAP(idle_mask, KVM_MAX_VCPUS);
 	struct kvm_s390_gisa_interrupt gisa_int;
+	union diag318_info diag318_info;
 };
 
 #define KVM_HVA_ERR_BAD		(-1UL)
diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
index 47104e5..e0684da 100644
--- a/arch/s390/include/uapi/asm/kvm.h
+++ b/arch/s390/include/uapi/asm/kvm.h
@@ -74,6 +74,7 @@ struct kvm_s390_io_adapter_req {
 #define KVM_S390_VM_CRYPTO		2
 #define KVM_S390_VM_CPU_MODEL		3
 #define KVM_S390_VM_MIGRATION		4
+#define KVM_S390_VM_MISC		5
 
 /* kvm attributes for mem_ctrl */
 #define KVM_S390_VM_MEM_ENABLE_CMMA	0
@@ -171,6 +172,9 @@ struct kvm_s390_vm_cpu_subfunc {
 #define KVM_S390_VM_MIGRATION_START	1
 #define KVM_S390_VM_MIGRATION_STATUS	2
 
+/* kvm attributes for KVM_S390_VM_MISC */
+#define KVM_S390_VM_MISC_DIAG318	0
+
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
 	/* general purpose regs for s390 */
diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
index 45634b3d..42a8db3 100644
--- a/arch/s390/kvm/diag.c
+++ b/arch/s390/kvm/diag.c
@@ -235,6 +235,21 @@ static int __diag_virtio_hypercall(struct kvm_vcpu *vcpu)
 	return ret < 0 ? ret : 0;
 }
 
+static int __diag_set_diag318_info(struct kvm_vcpu *vcpu)
+{
+	unsigned int reg = (vcpu->arch.sie_block->ipa & 0xf0) >> 4;
+	u64 info = vcpu->run->s.regs.gprs[reg];
+
+	vcpu->stat.diagnose_318++;
+	kvm_s390_set_diag318_info(vcpu->kvm, info);
+
+	VCPU_EVENT(vcpu, 3, "diag 0x318 cpnc: 0x%x cpvc: 0x%llx",
+		   vcpu->kvm->arch.diag318_info.cpnc,
+		   (u64)vcpu->kvm->arch.diag318_info.cpvc);
+
+	return 0;
+}
+
 int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
 {
 	int code = kvm_s390_get_base_disp_rs(vcpu, NULL) & 0xffff;
@@ -254,6 +269,8 @@ int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
 		return __diag_page_ref_service(vcpu);
 	case 0x308:
 		return __diag_ipl_functions(vcpu);
+	case 0x318:
+		return __diag_set_diag318_info(vcpu);
 	case 0x500:
 		return __diag_virtio_hypercall(vcpu);
 	default:
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 28ebd64..8be9867 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -157,6 +157,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "instruction_diag_9c", VCPU_STAT(diagnose_9c) },
 	{ "instruction_diag_258", VCPU_STAT(diagnose_258) },
 	{ "instruction_diag_308", VCPU_STAT(diagnose_308) },
+	{ "instruction_diag_318", VCPU_STAT(diagnose_318) },
 	{ "instruction_diag_500", VCPU_STAT(diagnose_500) },
 	{ "instruction_diag_other", VCPU_STAT(diagnose_other) },
 	{ NULL }
@@ -1228,6 +1229,68 @@ static int kvm_s390_get_tod(struct kvm *kvm, struct kvm_device_attr *attr)
 	return ret;
 }
 
+void kvm_s390_set_diag318_info(struct kvm *kvm, u64 info)
+{
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	kvm->arch.diag318_info.val = info;
+
+	VM_EVENT(kvm, 3, "SET: CPNC: 0x%x CPVC: 0x%llx",
+		 kvm->arch.diag318_info.cpnc, (u64)kvm->arch.diag318_info.cpvc);
+
+	if (sclp.has_diag318) {
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			vcpu->arch.sie_block->cpnc = kvm->arch.diag318_info.cpnc;
+		}
+	}
+}
+
+static int kvm_s390_set_misc(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	int ret;
+	u64 diag318_info;
+
+	switch (attr->attr) {
+	case KVM_S390_VM_MISC_DIAG318:
+		ret = -EFAULT;
+		if (get_user(diag318_info, (u64 __user *)attr->addr))
+			break;
+		kvm_s390_set_diag318_info(kvm, diag318_info);
+		ret = 0;
+		break;
+	default:
+		ret = -ENXIO;
+		break;
+	}
+	return ret;
+}
+
+static int kvm_s390_get_diag318_info(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	if (put_user(kvm->arch.diag318_info.val, (u64 __user *)attr->addr))
+		return -EFAULT;
+
+	VM_EVENT(kvm, 3, "QUERY: CPNC: 0x%x, CPVC: 0x%llx",
+		 kvm->arch.diag318_info.cpnc, (u64)kvm->arch.diag318_info.cpvc);
+	return 0;
+}
+
+static int kvm_s390_get_misc(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	int ret;
+
+	switch (attr->attr) {
+	case KVM_S390_VM_MISC_DIAG318:
+		ret = kvm_s390_get_diag318_info(kvm, attr);
+		break;
+	default:
+		ret = -ENXIO;
+		break;
+	}
+	return ret;
+}
+
 static int kvm_s390_set_processor(struct kvm *kvm, struct kvm_device_attr *attr)
 {
 	struct kvm_s390_vm_cpu_processor *proc;
@@ -1674,6 +1737,9 @@ static int kvm_s390_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 	case KVM_S390_VM_MIGRATION:
 		ret = kvm_s390_vm_set_migration(kvm, attr);
 		break;
+	case KVM_S390_VM_MISC:
+		ret = kvm_s390_set_misc(kvm, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -1699,6 +1765,9 @@ static int kvm_s390_vm_get_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 	case KVM_S390_VM_MIGRATION:
 		ret = kvm_s390_vm_get_migration(kvm, attr);
 		break;
+	case KVM_S390_VM_MISC:
+		ret = kvm_s390_get_misc(kvm, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -1772,6 +1841,16 @@ static int kvm_s390_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 	case KVM_S390_VM_MIGRATION:
 		ret = 0;
 		break;
+	case KVM_S390_VM_MISC:
+		switch (attr->attr) {
+		case KVM_S390_VM_MISC_DIAG318:
+			ret = 0;
+			break;
+		default:
+			ret = -ENXIO;
+			break;
+		}
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -2892,6 +2971,8 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 		vcpu->arch.sie_block->ictl |= ICTL_OPEREXC;
 	/* make vcpu_load load the right gmap on the first trigger */
 	vcpu->arch.enabled_gmap = vcpu->arch.gmap;
+	if (sclp.has_diag318)
+		vcpu->arch.sie_block->cpnc = vcpu->kvm->arch.diag318_info.cpnc;
 }
 
 static bool kvm_has_pckmo_subfunc(struct kvm *kvm, unsigned long nr)
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 6d9448d..70a21b4 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -281,6 +281,7 @@ int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu);
 int kvm_s390_handle_sigp_pei(struct kvm_vcpu *vcpu);
 
 /* implemented in kvm-s390.c */
+void kvm_s390_set_diag318_info(struct kvm *kvm, u64 info);
 void kvm_s390_set_tod_clock(struct kvm *kvm,
 			    const struct kvm_s390_vm_tod_clock *gtod);
 long kvm_arch_fault_in_page(struct kvm_vcpu *vcpu, gpa_t gpa, int writable);
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 076090f..50e522e0 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -548,6 +548,8 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 		scb_s->ecd |= scb_o->ecd & ECD_ETOKENF;
 
 	scb_s->hpid = HPID_VSIE;
+	if (sclp.has_diag318)
+		scb_s->cpnc = scb_o->cpnc;
 
 	prepare_ibc(vcpu, vsie_page);
 	rc = shadow_crycb(vcpu, vsie_page);
-- 
2.7.4

