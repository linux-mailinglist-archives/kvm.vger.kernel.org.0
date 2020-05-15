Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4D01D5C4B
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 00:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgEOWUG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 18:20:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26796 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726212AbgEOWUF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 18:20:05 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04FM2vCw177572;
        Fri, 15 May 2020 18:20:04 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 310x57pndq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 18:20:04 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04FM3C8f179435;
        Fri, 15 May 2020 18:20:04 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 310x57pndd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 18:20:04 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04FMEnSf011790;
        Fri, 15 May 2020 22:20:03 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma05wdc.us.ibm.com with ESMTP id 3100ucjfw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 22:20:03 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04FMJxn724379880
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 22:19:59 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7ED32C6057;
        Fri, 15 May 2020 22:19:59 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF59BC605B;
        Fri, 15 May 2020 22:19:58 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.146.125])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 15 May 2020 22:19:58 +0000 (GMT)
From:   Collin Walling <walling@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com, thuth@redhat.com
Subject: [PATCH v7 3/3] s390/kvm: diagnose 0x318 get/set handling
Date:   Fri, 15 May 2020 18:19:35 -0400
Message-Id: <20200515221935.18775-4-walling@linux.ibm.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200515221935.18775-1-walling@linux.ibm.com>
References: <20200515221935.18775-1-walling@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-15_07:2020-05-15,2020-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 mlxscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999 impostorscore=0
 adultscore=0 clxscore=1015 cotscore=-2147483648 lowpriorityscore=0
 suspectscore=8 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005150181
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DIAGNOSE 0x318 (diag 318) sets information regarding the environment
the VM is running in (Linux, z/VM, etc) and is observed via
firmware/service events.

This is a privileged s390x instruction that must be intercepted by
SIE. Userspace handling is required, so let's introduce some functions
to communicate between userspace and KVM via ioctls. These will be used
to get/set the diag 318 related information.

The Control Program Name Code (CPNC) is stored in the SIE block. The
CPNC along with the Control Program Version Code (CPVC) are stored in
the kvm_arch struct.

Signed-off-by: Collin Walling <walling@linux.ibm.com>
---
 Documentation/virt/kvm/devices/vm.rst | 21 +++++++
 arch/s390/include/asm/kvm_host.h      |  5 +-
 arch/s390/include/uapi/asm/kvm.h      |  4 ++
 arch/s390/kvm/kvm-s390.c              | 82 +++++++++++++++++++++++++++
 arch/s390/kvm/vsie.c                  |  2 +
 5 files changed, 113 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/devices/vm.rst b/Documentation/virt/kvm/devices/vm.rst
index 0aa5b1cfd700..52cc906dd7bd 100644
--- a/Documentation/virt/kvm/devices/vm.rst
+++ b/Documentation/virt/kvm/devices/vm.rst
@@ -314,3 +314,24 @@ Allows userspace to query the status of migration mode.
 	     if it is enabled
 :Returns:   -EFAULT if the given address is not accessible from kernel space;
 	    0 in case of success.
+
+6. GROUP: KVM_S390_VM_MISC
+==========================
+
+:Architectures: s390
+
+6.1. KVM_S390_VM_MISC_DIAG_318 (r/w)
+-----------------------------------
+
+Allows userspace to retrieve and set the DIAGNOSE 0x318 information,
+which consists of a 1-byte "Control Program Name Code" and a 7-byte
+"Control Program Version Code" (a 64 bit value all in all). This
+information is set by the guest (usually during IPL). This interface is
+intended to allow retrieving and setting it during migration; while no
+real harm is done if the information is changed outside of migration,
+it is strongly discouraged.
+
+:Parameters: address of a buffer in user space (u64), where the
+	     information is read from or stored into
+:Returns:    -EFAULT if the given address is not accessible from kernel space;
+	     0 in case of success
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index d6bcd34f3ec3..c03222051043 100644
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
@@ -938,6 +939,7 @@ struct kvm_arch{
 	int user_sigp;
 	int user_stsi;
 	int user_instr0;
+	int use_diag_318;
 	struct s390_io_adapter *adapters[MAX_S390_IO_ADAPTERS];
 	wait_queue_head_t ipte_wq;
 	int ipte_lock_count;
@@ -956,6 +958,7 @@ struct kvm_arch{
 	DECLARE_BITMAP(idle_mask, KVM_MAX_VCPUS);
 	struct kvm_s390_gisa_interrupt gisa_int;
 	struct kvm_s390_pv pv;
+	union diag_318_info diag_318_info;
 };
 
 #define KVM_HVA_ERR_BAD		(-1UL)
diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
index 436ec7636927..2ce8e6f72206 100644
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
+#define KVM_S390_VM_MISC_DIAG_318	0
+
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
 	/* general purpose regs for s390 */
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d05bb040fd42..cf8a3f1be839 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1243,6 +1243,70 @@ static int kvm_s390_get_tod(struct kvm *kvm, struct kvm_device_attr *attr)
 	return ret;
 }
 
+static int kvm_s390_set_diag_318_info(struct kvm *kvm, __u64 addr)
+{
+	struct kvm_vcpu *vcpu;
+	u64 info;
+	int i;
+
+	if (get_user(info, (u64 __user *)addr))
+		return -EFAULT;
+
+	kvm->arch.diag_318_info.val = info;
+
+	if (sclp.has_diag_318) {
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			vcpu->arch.sie_block->cpnc = kvm->arch.diag_318_info.cpnc;
+		}
+	}
+
+	VM_EVENT(kvm, 3, "SET: CPNC: 0x%x CPVC: 0x%llx",
+		 kvm->arch.diag_318_info.cpnc, (u64)kvm->arch.diag_318_info.cpvc);
+
+	return 0;
+}
+
+static int kvm_s390_vm_set_misc(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	int ret;
+
+	switch (attr->attr) {
+	case KVM_S390_VM_MISC_DIAG_318:
+		ret = kvm_s390_set_diag_318_info(kvm, attr->addr);
+		break;
+	default:
+		ret = -ENXIO;
+		break;
+	}
+	return ret;
+}
+
+static int kvm_s390_get_diag_318_info(struct kvm *kvm, __u64 addr)
+{
+	if (put_user(kvm->arch.diag_318_info.val, (u64 __user *)addr))
+		return -EFAULT;
+
+	VM_EVENT(kvm, 3, "QUERY: CPNC: 0x%x, CPVC: 0x%llx",
+		 kvm->arch.diag_318_info.cpnc, (u64)kvm->arch.diag_318_info.cpvc);
+
+	return 0;
+}
+
+static int kvm_s390_get_misc(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	int ret;
+
+	switch (attr->attr) {
+	case KVM_S390_VM_MISC_DIAG_318:
+		ret = kvm_s390_get_diag_318_info(kvm, attr->addr);
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
@@ -1689,6 +1753,9 @@ static int kvm_s390_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 	case KVM_S390_VM_MIGRATION:
 		ret = kvm_s390_vm_set_migration(kvm, attr);
 		break;
+	case KVM_S390_VM_MISC:
+		ret = kvm_s390_vm_set_misc(kvm, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -1714,6 +1781,9 @@ static int kvm_s390_vm_get_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 	case KVM_S390_VM_MIGRATION:
 		ret = kvm_s390_vm_get_migration(kvm, attr);
 		break;
+	case KVM_S390_VM_MISC:
+		ret = kvm_s390_get_misc(kvm, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -1787,6 +1857,16 @@ static int kvm_s390_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 	case KVM_S390_VM_MIGRATION:
 		ret = 0;
 		break;
+	case KVM_S390_VM_MISC:
+		switch (attr->attr) {
+		case KVM_S390_VM_MISC_DIAG_318:
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
@@ -3075,6 +3155,8 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 		vcpu->arch.sie_block->ictl |= ICTL_OPEREXC;
 	/* make vcpu_load load the right gmap on the first trigger */
 	vcpu->arch.enabled_gmap = vcpu->arch.gmap;
+	if (sclp.has_diag_318)
+		vcpu->arch.sie_block->cpnc = vcpu->kvm->arch.diag_318_info.cpnc;
 }
 
 static bool kvm_has_pckmo_subfunc(struct kvm *kvm, unsigned long nr)
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 4f6c22d72072..a6820267e661 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -548,6 +548,8 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 		scb_s->ecd |= scb_o->ecd & ECD_ETOKENF;
 
 	scb_s->hpid = HPID_VSIE;
+	if (sclp.has_diag_318)
+		scb_s->cpnc = scb_o->cpnc;
 
 	prepare_ibc(vcpu, vsie_page);
 	rc = shadow_crycb(vcpu, vsie_page);
-- 
2.21.3

