Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C627F1D21DC
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 00:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731033AbgEMWRV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 18:17:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35044 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730794AbgEMWRU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 May 2020 18:17:20 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04DM24XK074564;
        Wed, 13 May 2020 18:17:20 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 310jtydbsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 May 2020 18:17:19 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04DM2qGa086117;
        Wed, 13 May 2020 18:17:19 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 310jtydbrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 May 2020 18:17:19 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04DMEtCh012449;
        Wed, 13 May 2020 22:17:18 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02wdc.us.ibm.com with ESMTP id 3100ubj04y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 May 2020 22:17:18 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04DMHGTQ40960488
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 May 2020 22:17:16 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 16F97AC062;
        Wed, 13 May 2020 22:17:16 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6223AC05B;
        Wed, 13 May 2020 22:17:15 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.196.213])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 13 May 2020 22:17:15 +0000 (GMT)
From:   Collin Walling <walling@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
Subject: [PATCH v6 2/2] s390/kvm: diagnose 318 handling
Date:   Wed, 13 May 2020 18:15:57 -0400
Message-Id: <20200513221557.14366-3-walling@linux.ibm.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200513221557.14366-1-walling@linux.ibm.com>
References: <20200513221557.14366-1-walling@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_09:2020-05-13,2020-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 adultscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 cotscore=-2147483648 malwarescore=0 suspectscore=8 mlxscore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005130184
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

By default, this feature is disabled and can only be enabled if a
user space program (such as QEMU) explicitly requests it.

The Control Program Name Code (CPNC) is stored in the SIE block
and a copy is retained in each VCPU. The Control Program Version
Code (CPVC) is not designed to be stored in the SIE block, so we
retain a copy in each VCPU next to the CPNC.

Signed-off-by: Collin Walling <walling@linux.ibm.com>
---
 Documentation/virt/kvm/devices/vm.rst | 29 +++++++++
 arch/s390/include/asm/kvm_host.h      |  6 +-
 arch/s390/include/uapi/asm/kvm.h      |  5 ++
 arch/s390/kvm/diag.c                  | 20 ++++++
 arch/s390/kvm/kvm-s390.c              | 89 +++++++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.h              |  1 +
 arch/s390/kvm/vsie.c                  |  2 +
 7 files changed, 151 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/devices/vm.rst b/Documentation/virt/kvm/devices/vm.rst
index 0aa5b1cfd700..9344d45ace6d 100644
--- a/Documentation/virt/kvm/devices/vm.rst
+++ b/Documentation/virt/kvm/devices/vm.rst
@@ -314,3 +314,32 @@ Allows userspace to query the status of migration mode.
 	     if it is enabled
 :Returns:   -EFAULT if the given address is not accessible from kernel space;
 	    0 in case of success.
+
+6. GROUP: KVM_S390_VM_MISC
+Architectures: s390
+
+ 6.1. KVM_S390_VM_MISC_ENABLE_DIAG318
+
+ Allows userspace to enable the DIAGNOSE 0x318 instruction call for a
+ guest OS. By default, KVM will not allow this instruction to be executed
+ by a guest, even if support is in place. Userspace must explicitly enable
+ the instruction handling for DIAGNOSE 0x318 via this call.
+
+ Parameters: none
+ Returns:    0 after setting a flag telling KVM to enable this feature
+
+ 6.2. KVM_S390_VM_MISC_DIAG318 (r/w)
+
+ Allows userspace to retrieve and set the DIAGNOSE 0x318 information,
+ which consists of a 1-byte "Control Program Name Code" and a 7-byte
+ "Control Program Version Code" (a 64 bit value all in all). This
+ information is set by the guest (usually during IPL). This interface is
+ intended to allow retrieving and setting it during migration; while no
+ real harm is done if the information is changed outside of migration,
+ it is strongly discouraged.
+
+ Parameters: address of a buffer in user space (u64), where the
+	     information is read from or stored into
+ Returns:    -EFAULT if the given address is not accessible from kernel space;
+	     -EOPNOTSUPP if feature has not been requested to be enabled first;
+	     0 in case of success
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index d6bcd34f3ec3..77a46416bd62 100644
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
@@ -454,6 +455,7 @@ struct kvm_vcpu_stat {
 	u64 diagnose_9c_ignored;
 	u64 diagnose_258;
 	u64 diagnose_308;
+	u64 diagnose_318;
 	u64 diagnose_500;
 	u64 diagnose_other;
 };
@@ -938,6 +940,7 @@ struct kvm_arch{
 	int user_sigp;
 	int user_stsi;
 	int user_instr0;
+	int use_diag318;
 	struct s390_io_adapter *adapters[MAX_S390_IO_ADAPTERS];
 	wait_queue_head_t ipte_wq;
 	int ipte_lock_count;
@@ -956,6 +959,7 @@ struct kvm_arch{
 	DECLARE_BITMAP(idle_mask, KVM_MAX_VCPUS);
 	struct kvm_s390_gisa_interrupt gisa_int;
 	struct kvm_s390_pv pv;
+	union diag318_info diag318_info;
 };
 
 #define KVM_HVA_ERR_BAD		(-1UL)
diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
index 436ec7636927..92cfe14ba2e1 100644
--- a/arch/s390/include/uapi/asm/kvm.h
+++ b/arch/s390/include/uapi/asm/kvm.h
@@ -74,6 +74,7 @@ struct kvm_s390_io_adapter_req {
 #define KVM_S390_VM_CRYPTO		2
 #define KVM_S390_VM_CPU_MODEL		3
 #define KVM_S390_VM_MIGRATION		4
+#define KVM_S390_VM_MISC		5
 
 /* kvm attributes for mem_ctrl */
 #define KVM_S390_VM_MEM_ENABLE_CMMA	0
@@ -171,6 +172,10 @@ struct kvm_s390_vm_cpu_subfunc {
 #define KVM_S390_VM_MIGRATION_START	1
 #define KVM_S390_VM_MIGRATION_STATUS	2
 
+/* kvm attributes for KVM_S390_VM_MISC */
+#define KVM_S390_VM_MISC_ENABLE_DIAG318	0
+#define KVM_S390_VM_MISC_DIAG318		1
+
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
 	/* general purpose regs for s390 */
diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
index 563429dece03..3caed4b880c8 100644
--- a/arch/s390/kvm/diag.c
+++ b/arch/s390/kvm/diag.c
@@ -253,6 +253,24 @@ static int __diag_virtio_hypercall(struct kvm_vcpu *vcpu)
 	return ret < 0 ? ret : 0;
 }
 
+static int __diag_set_diag318_info(struct kvm_vcpu *vcpu)
+{
+	unsigned int reg = (vcpu->arch.sie_block->ipa & 0xf0) >> 4;
+	u64 info = vcpu->run->s.regs.gprs[reg];
+
+	if (!vcpu->kvm->arch.use_diag318)
+		return -EOPNOTSUPP;
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
@@ -272,6 +290,8 @@ int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
 		return __diag_page_ref_service(vcpu);
 	case 0x308:
 		return __diag_ipl_functions(vcpu);
+	case 0x318:
+		return __diag_set_diag318_info(vcpu);
 	case 0x500:
 		return __diag_virtio_hypercall(vcpu);
 	default:
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d05bb040fd42..c3eee468815f 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -159,6 +159,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "diag_9c_ignored", VCPU_STAT(diagnose_9c_ignored) },
 	{ "instruction_diag_258", VCPU_STAT(diagnose_258) },
 	{ "instruction_diag_308", VCPU_STAT(diagnose_308) },
+	{ "instruction_diag_318", VCPU_STAT(diagnose_318) },
 	{ "instruction_diag_500", VCPU_STAT(diagnose_500) },
 	{ "instruction_diag_other", VCPU_STAT(diagnose_other) },
 	{ NULL }
@@ -1243,6 +1244,76 @@ static int kvm_s390_get_tod(struct kvm *kvm, struct kvm_device_attr *attr)
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
+		 kvm->arch.diag318_info.cpnc, kvm->arch.diag318_info.cpvc);
+
+	if (sclp.has_diag318) {
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			vcpu->arch.sie_block->cpnc = kvm->arch.diag318_info.cpnc;
+		}
+	}
+}
+
+static int kvm_s390_vm_set_misc(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	int ret;
+	u64 diag318_info;
+
+	switch (attr->attr) {
+	case KVM_S390_VM_MISC_ENABLE_DIAG318:
+		kvm->arch.use_diag318 = 1;
+		ret = 0;
+		break;
+	case KVM_S390_VM_MISC_DIAG318:
+		ret = -EFAULT;
+		if (!kvm->arch.use_diag318)
+			return -EOPNOTSUPP;
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
+		if (!kvm->arch.use_diag318)
+			return -ENXIO;
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
@@ -1689,6 +1760,9 @@ static int kvm_s390_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 	case KVM_S390_VM_MIGRATION:
 		ret = kvm_s390_vm_set_migration(kvm, attr);
 		break;
+	case KVM_S390_VM_MISC:
+		ret = kvm_s390_vm_set_misc(kvm, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -1714,6 +1788,9 @@ static int kvm_s390_vm_get_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 	case KVM_S390_VM_MIGRATION:
 		ret = kvm_s390_vm_get_migration(kvm, attr);
 		break;
+	case KVM_S390_VM_MISC:
+		ret = kvm_s390_get_misc(kvm, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -1787,6 +1864,16 @@ static int kvm_s390_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
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
@@ -3075,6 +3162,8 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 		vcpu->arch.sie_block->ictl |= ICTL_OPEREXC;
 	/* make vcpu_load load the right gmap on the first trigger */
 	vcpu->arch.enabled_gmap = vcpu->arch.gmap;
+	if (sclp.has_diag318)
+		vcpu->arch.sie_block->cpnc = vcpu->kvm->arch.diag318_info.cpnc;
 }
 
 static bool kvm_has_pckmo_subfunc(struct kvm *kvm, unsigned long nr)
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 79dcd647b378..59195447737e 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -326,6 +326,7 @@ int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu);
 int kvm_s390_handle_sigp_pei(struct kvm_vcpu *vcpu);
 
 /* implemented in kvm-s390.c */
+void kvm_s390_set_diag318_info(struct kvm *kvm, u64 info);
 void kvm_s390_set_tod_clock(struct kvm *kvm,
 			    const struct kvm_s390_vm_tod_clock *gtod);
 long kvm_arch_fault_in_page(struct kvm_vcpu *vcpu, gpa_t gpa, int writable);
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 4f6c22d72072..3a63ad5ee8d8 100644
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
2.21.3

