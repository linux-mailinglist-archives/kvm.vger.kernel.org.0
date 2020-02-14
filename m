Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEB9415F9C1
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 23:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgBNW2n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 17:28:43 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32452 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727843AbgBNW1R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 17:27:17 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EMNu8o134670;
        Fri, 14 Feb 2020 17:27:15 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y5jxu9k5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 17:27:15 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01EMPkud138073;
        Fri, 14 Feb 2020 17:27:15 -0500
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y5jxu9k5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 17:27:15 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01EMP7GV017936;
        Fri, 14 Feb 2020 22:27:14 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma05wdc.us.ibm.com with ESMTP id 2y5bbysw03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 22:27:14 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01EMRAYD57868616
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Feb 2020 22:27:10 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3B08136091;
        Fri, 14 Feb 2020 22:27:10 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D328D136094;
        Fri, 14 Feb 2020 22:27:09 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Feb 2020 22:27:09 +0000 (GMT)
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
Subject: [PATCH v2 09/42] KVM: s390: protvirt: Add initial vm and cpu lifecycle handling
Date:   Fri, 14 Feb 2020 17:26:25 -0500
Message-Id: <20200214222658.12946-10-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200214222658.12946-1-borntraeger@de.ibm.com>
References: <20200214222658.12946-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_08:2020-02-14,2020-02-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 impostorscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=2 clxscore=1015
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002140165
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

This contains 3 main changes:
1. changes in SIE control block handling for secure guests
2. helper functions for create/destroy/unpack secure guests
3. KVM_S390_PV_COMMAND ioctl to allow userspace dealing with secure
machines

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
[borntraeger@de.ibm.com: patch merging, splitting, fixing]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  24 ++-
 arch/s390/include/asm/uv.h       |  69 ++++++++
 arch/s390/kvm/Makefile           |   2 +-
 arch/s390/kvm/kvm-s390.c         | 202 +++++++++++++++++++++++-
 arch/s390/kvm/kvm-s390.h         |  27 ++++
 arch/s390/kvm/pv.c               | 262 +++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h         |  35 +++++
 7 files changed, 617 insertions(+), 4 deletions(-)
 create mode 100644 arch/s390/kvm/pv.c

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index d058289385a5..1aa2382fe363 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -160,7 +160,13 @@ struct kvm_s390_sie_block {
 	__u8	reserved08[4];		/* 0x0008 */
 #define PROG_IN_SIE (1<<0)
 	__u32	prog0c;			/* 0x000c */
-	__u8	reserved10[16];		/* 0x0010 */
+	union {
+		__u8	reserved10[16];		/* 0x0010 */
+		struct {
+			__u64	pv_handle_cpu;
+			__u64	pv_handle_config;
+		};
+	};
 #define PROG_BLOCK_SIE	(1<<0)
 #define PROG_REQUEST	(1<<1)
 	atomic_t prog20;		/* 0x0020 */
@@ -233,7 +239,7 @@ struct kvm_s390_sie_block {
 #define ECB3_RI  0x01
 	__u8    ecb3;			/* 0x0063 */
 	__u32	scaol;			/* 0x0064 */
-	__u8	reserved68;		/* 0x0068 */
+	__u8	sdf;			/* 0x0068 */
 	__u8    epdx;			/* 0x0069 */
 	__u8    reserved6a[2];		/* 0x006a */
 	__u32	todpr;			/* 0x006c */
@@ -645,6 +651,11 @@ struct kvm_guestdbg_info_arch {
 	unsigned long last_bp;
 };
 
+struct kvm_s390_pv_vcpu {
+	u64 handle;
+	unsigned long stor_base;
+};
+
 struct kvm_vcpu_arch {
 	struct kvm_s390_sie_block *sie_block;
 	/* if vsie is active, currently executed shadow sie control block */
@@ -673,6 +684,7 @@ struct kvm_vcpu_arch {
 	__u64 cputm_start;
 	bool gs_enabled;
 	bool skey_enabled;
+	struct kvm_s390_pv_vcpu pv;
 };
 
 struct kvm_vm_stat {
@@ -843,6 +855,13 @@ struct kvm_s390_gisa_interrupt {
 	DECLARE_BITMAP(kicked_mask, KVM_MAX_VCPUS);
 };
 
+struct kvm_s390_pv {
+	u64 handle;
+	u64 guest_len;
+	unsigned long stor_base;
+	void *stor_var;
+};
+
 struct kvm_arch{
 	void *sca;
 	int use_esca;
@@ -878,6 +897,7 @@ struct kvm_arch{
 	DECLARE_BITMAP(cpu_feat, KVM_S390_VM_CPU_FEAT_NR_BITS);
 	DECLARE_BITMAP(idle_mask, KVM_MAX_VCPUS);
 	struct kvm_s390_gisa_interrupt gisa_int;
+	struct kvm_s390_pv pv;
 };
 
 #define KVM_HVA_ERR_BAD		(-1UL)
diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index bc452a15ac3f..839cb3a89986 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -23,11 +23,19 @@
 #define UVC_RC_INV_STATE	0x0003
 #define UVC_RC_INV_LEN		0x0005
 #define UVC_RC_NO_RESUME	0x0007
+#define UVC_RC_NEED_DESTROY	0x8000
 
 #define UVC_CMD_QUI			0x0001
 #define UVC_CMD_INIT_UV			0x000f
+#define UVC_CMD_CREATE_SEC_CONF		0x0100
+#define UVC_CMD_DESTROY_SEC_CONF	0x0101
+#define UVC_CMD_CREATE_SEC_CPU		0x0120
+#define UVC_CMD_DESTROY_SEC_CPU		0x0121
 #define UVC_CMD_CONV_TO_SEC_STOR	0x0200
 #define UVC_CMD_CONV_FROM_SEC_STOR	0x0201
+#define UVC_CMD_SET_SEC_CONF_PARAMS	0x0300
+#define UVC_CMD_UNPACK_IMG		0x0301
+#define UVC_CMD_VERIFY_IMG		0x0302
 #define UVC_CMD_PIN_PAGE_SHARED		0x0341
 #define UVC_CMD_UNPIN_PAGE_SHARED	0x0342
 #define UVC_CMD_SET_SHARED_ACCESS	0x1000
@@ -37,10 +45,17 @@
 enum uv_cmds_inst {
 	BIT_UVC_CMD_QUI = 0,
 	BIT_UVC_CMD_INIT_UV = 1,
+	BIT_UVC_CMD_CREATE_SEC_CONF = 2,
+	BIT_UVC_CMD_DESTROY_SEC_CONF = 3,
+	BIT_UVC_CMD_CREATE_SEC_CPU = 4,
+	BIT_UVC_CMD_DESTROY_SEC_CPU = 5,
 	BIT_UVC_CMD_CONV_TO_SEC_STOR = 6,
 	BIT_UVC_CMD_CONV_FROM_SEC_STOR = 7,
 	BIT_UVC_CMD_SET_SHARED_ACCESS = 8,
 	BIT_UVC_CMD_REMOVE_SHARED_ACCESS = 9,
+	BIT_UVC_CMD_SET_SEC_PARMS = 11,
+	BIT_UVC_CMD_UNPACK_IMG = 13,
+	BIT_UVC_CMD_VERIFY_IMG = 14,
 	BIT_UVC_CMD_PIN_PAGE_SHARED = 21,
 	BIT_UVC_CMD_UNPIN_PAGE_SHARED = 22,
 };
@@ -52,6 +67,7 @@ struct uv_cb_header {
 	u16 rrc;	/* Return Reason Code */
 } __packed __aligned(8);
 
+/* Query Ultravisor Information */
 struct uv_cb_qui {
 	struct uv_cb_header header;
 	u64 reserved08;
@@ -71,6 +87,7 @@ struct uv_cb_qui {
 	u64 reserveda0;
 } __packed __aligned(8);
 
+/* Initialize Ultravisor */
 struct uv_cb_init {
 	struct uv_cb_header header;
 	u64 reserved08[2];
@@ -79,6 +96,35 @@ struct uv_cb_init {
 	u64 reserved28[4];
 } __packed __aligned(8);
 
+/* Create Guest Configuration */
+struct uv_cb_cgc {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 guest_handle;
+	u64 conf_base_stor_origin;
+	u64 conf_virt_stor_origin;
+	u64 reserved30;
+	u64 guest_stor_origin;
+	u64 guest_stor_len;
+	u64 guest_sca;
+	u64 guest_asce;
+	u64 reserved58[5];
+} __packed __aligned(8);
+
+/* Create Secure CPU */
+struct uv_cb_csc {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 cpu_handle;
+	u64 guest_handle;
+	u64 stor_origin;
+	u8  reserved30[6];
+	u16 num;
+	u64 state_origin;
+	u64 reserved40[4];
+} __packed __aligned(8);
+
+/* Convert to Secure */
 struct uv_cb_cts {
 	struct uv_cb_header header;
 	u64 reserved08[2];
@@ -86,12 +132,34 @@ struct uv_cb_cts {
 	u64 gaddr;
 } __packed __aligned(8);
 
+/* Convert from Secure / Pin Page Shared */
 struct uv_cb_cfs {
 	struct uv_cb_header header;
 	u64 reserved08[2];
 	u64 paddr;
 } __packed __aligned(8);
 
+/* Set Secure Config Parameter */
+struct uv_cb_ssc {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 guest_handle;
+	u64 sec_header_origin;
+	u32 sec_header_len;
+	u32 reserved2c;
+	u64 reserved30[4];
+} __packed __aligned(8);
+
+/* Unpack */
+struct uv_cb_unp {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 guest_handle;
+	u64 gaddr;
+	u64 tweak[2];
+	u64 reserved38[3];
+} __packed __aligned(8);
+
 /*
  * A common UV call struct for calls that take no payload
  * Examples:
@@ -105,6 +173,7 @@ struct uv_cb_nodata {
 	u64 reserved20[4];
 } __packed __aligned(8);
 
+/* Set Shared Access */
 struct uv_cb_share {
 	struct uv_cb_header header;
 	u64 reserved08[3];
diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
index 05ee90a5ea08..12decca22e7c 100644
--- a/arch/s390/kvm/Makefile
+++ b/arch/s390/kvm/Makefile
@@ -9,6 +9,6 @@ common-objs = $(KVM)/kvm_main.o $(KVM)/eventfd.o  $(KVM)/async_pf.o $(KVM)/irqch
 ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
 
 kvm-objs := $(common-objs) kvm-s390.o intercept.o interrupt.o priv.o sigp.o
-kvm-objs += diag.o gaccess.o guestdbg.o vsie.o
+kvm-objs += diag.o gaccess.o guestdbg.o vsie.o pv.o
 
 obj-$(CONFIG_KVM) += kvm.o
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index cc7793525a69..f3cd469c2e7b 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -44,6 +44,7 @@
 #include <asm/cpacf.h>
 #include <asm/timex.h>
 #include <asm/ap.h>
+#include <asm/uv.h>
 #include "kvm-s390.h"
 #include "gaccess.h"
 
@@ -234,8 +235,10 @@ int kvm_arch_check_processor_compat(void)
 	return 0;
 }
 
+/* forward declarations */
 static void kvm_gmap_notifier(struct gmap *gmap, unsigned long start,
 			      unsigned long end);
+static int sca_switch_to_extended(struct kvm *kvm);
 
 static void kvm_clock_sync_scb(struct kvm_s390_sie_block *scb, u64 delta)
 {
@@ -571,6 +574,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_S390_BPB:
 		r = test_facility(82);
 		break;
+	case KVM_CAP_S390_PROTECTED:
+		r = is_prot_virt_host();
+		break;
 	default:
 		r = 0;
 	}
@@ -2165,6 +2171,114 @@ static int kvm_s390_set_cmma_bits(struct kvm *kvm,
 	return r;
 }
 
+static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
+{
+	int r = 0;
+	void __user *argp = (void __user *)cmd->data;
+
+	switch (cmd->cmd) {
+	case KVM_PV_VM_CREATE: {
+		r = -EINVAL;
+		if (kvm_s390_pv_is_protected(kvm))
+			break;
+
+		r = kvm_s390_pv_alloc_vm(kvm);
+		if (r)
+			break;
+
+		mutex_lock(&kvm->lock);
+		kvm_s390_vcpu_block_all(kvm);
+		/* FMT 4 SIE needs esca */
+		r = sca_switch_to_extended(kvm);
+		if (r) {
+			kvm_s390_pv_dealloc_vm(kvm);
+			kvm_s390_vcpu_unblock_all(kvm);
+			mutex_unlock(&kvm->lock);
+			break;
+		}
+		r = kvm_s390_pv_create_vm(kvm, &cmd->rc, &cmd->rrc);
+		kvm_s390_vcpu_unblock_all(kvm);
+		mutex_unlock(&kvm->lock);
+		break;
+	}
+	case KVM_PV_VM_DESTROY: {
+		r = -EINVAL;
+		if (!kvm_s390_pv_is_protected(kvm))
+			break;
+
+		/* All VCPUs have to be destroyed before this call. */
+		mutex_lock(&kvm->lock);
+		kvm_s390_vcpu_block_all(kvm);
+		r = kvm_s390_pv_destroy_vm(kvm, &cmd->rc, &cmd->rrc);
+		if (!r)
+			kvm_s390_pv_dealloc_vm(kvm);
+		kvm_s390_vcpu_unblock_all(kvm);
+		mutex_unlock(&kvm->lock);
+		break;
+	}
+	case KVM_PV_VM_SET_SEC_PARMS: {
+		struct kvm_s390_pv_sec_parm parms = {};
+		void *hdr;
+
+		r = -EINVAL;
+		if (!kvm_s390_pv_is_protected(kvm))
+			break;
+
+		r = -EFAULT;
+		if (copy_from_user(&parms, argp, sizeof(parms)))
+			break;
+
+		/* Currently restricted to 8KB */
+		r = -EINVAL;
+		if (parms.length > PAGE_SIZE * 2)
+			break;
+
+		r = -ENOMEM;
+		hdr = vmalloc(parms.length);
+		if (!hdr)
+			break;
+
+		r = -EFAULT;
+		if (!copy_from_user(hdr, (void __user *)parms.origin,
+				    parms.length))
+			r = kvm_s390_pv_set_sec_parms(kvm, hdr, parms.length,
+						      &cmd->rc, &cmd->rrc);
+
+		vfree(hdr);
+		break;
+	}
+	case KVM_PV_VM_UNPACK: {
+		struct kvm_s390_pv_unp unp = {};
+
+		r = -EINVAL;
+		if (!kvm_s390_pv_is_protected(kvm))
+			break;
+
+		r = -EFAULT;
+		if (copy_from_user(&unp, argp, sizeof(unp)))
+			break;
+
+		r = kvm_s390_pv_unpack(kvm, unp.addr, unp.size, unp.tweak,
+				       &cmd->rc, &cmd->rrc);
+		break;
+	}
+	case KVM_PV_VM_VERIFY: {
+		r = -EINVAL;
+		if (!kvm_s390_pv_is_protected(kvm))
+			break;
+
+		r = uv_cmd_nodata(kvm_s390_pv_handle(kvm),
+				  UVC_CMD_VERIFY_IMG, &cmd->rc, &cmd->rrc);
+		KVM_UV_EVENT(kvm, 3, "PROTVIRT VERIFY: rc %x rrc %x", cmd->rc,
+			     cmd->rrc);
+		break;
+	}
+	default:
+		return -ENOTTY;
+	}
+	return r;
+}
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
@@ -2262,6 +2376,25 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		mutex_unlock(&kvm->slots_lock);
 		break;
 	}
+	case KVM_S390_PV_COMMAND: {
+		struct kvm_pv_cmd args;
+
+		r = 0;
+		if (!is_prot_virt_host()) {
+			r = -EINVAL;
+			break;
+		}
+		if (copy_from_user(&args, argp, sizeof(args))) {
+			r = -EFAULT;
+			break;
+		}
+		r = kvm_s390_handle_pv(kvm, &args);
+		if (copy_to_user(argp, &args, sizeof(args))) {
+			r = -EFAULT;
+			break;
+		}
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
@@ -2525,6 +2658,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
+	u16 rc, rrc;
+
 	VCPU_EVENT(vcpu, 3, "%s", "free cpu");
 	trace_kvm_s390_destroy_vcpu(vcpu->vcpu_id);
 	kvm_s390_clear_local_irqs(vcpu);
@@ -2537,6 +2672,8 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 	if (vcpu->kvm->arch.use_cmma)
 		kvm_s390_vcpu_unsetup_cmma(vcpu);
+	if (kvm_s390_pv_handle_cpu(vcpu))
+		kvm_s390_pv_destroy_cpu(vcpu, &rc, &rrc);
 	free_page((unsigned long)(vcpu->arch.sie_block));
 }
 
@@ -2558,10 +2695,15 @@ static void kvm_free_vcpus(struct kvm *kvm)
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
+	u16 rc, rrc;
 	kvm_free_vcpus(kvm);
 	sca_dispose(kvm);
-	debug_unregister(kvm->arch.dbf);
 	kvm_s390_gisa_destroy(kvm);
+	if (kvm_s390_pv_is_protected(kvm)) {
+		kvm_s390_pv_destroy_vm(kvm, &rc, &rrc);
+		kvm_s390_pv_dealloc_vm(kvm);
+	}
+	debug_unregister(kvm->arch.dbf);
 	free_page((unsigned long)kvm->arch.sie_page2);
 	if (!kvm_is_ucontrol(kvm))
 		gmap_remove(kvm->arch.gmap);
@@ -2657,6 +2799,9 @@ static int sca_switch_to_extended(struct kvm *kvm)
 	unsigned int vcpu_idx;
 	u32 scaol, scaoh;
 
+	if (kvm->arch.use_esca)
+		return 0;
+
 	new_sca = alloc_pages_exact(sizeof(*new_sca), GFP_KERNEL|__GFP_ZERO);
 	if (!new_sca)
 		return -ENOMEM;
@@ -2908,6 +3053,7 @@ static void kvm_s390_vcpu_setup_model(struct kvm_vcpu *vcpu)
 static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
 {
 	int rc = 0;
+	u16 uvrc, uvrrc;
 
 	atomic_set(&vcpu->arch.sie_block->cpuflags, CPUSTAT_ZARCH |
 						    CPUSTAT_SM |
@@ -2975,6 +3121,9 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
 
 	kvm_s390_vcpu_crypto_setup(vcpu);
 
+	if (kvm_s390_pv_is_protected(vcpu->kvm))
+		rc = kvm_s390_pv_create_cpu(vcpu, &uvrc, &uvrrc);
+
 	return rc;
 }
 
@@ -4352,6 +4501,38 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
 	return -ENOIOCTLCMD;
 }
 
+static int kvm_s390_handle_pv_vcpu(struct kvm_vcpu *vcpu,
+				   struct kvm_pv_cmd *cmd)
+{
+	int r = 0;
+
+	if (!kvm_s390_pv_is_protected(vcpu->kvm))
+		return -EINVAL;
+
+	if (cmd->flags)
+		return -EINVAL;
+
+	switch (cmd->cmd) {
+	case KVM_PV_VCPU_CREATE: {
+		if (kvm_s390_pv_handle_cpu(vcpu))
+			return -EINVAL;
+
+		r = kvm_s390_pv_create_cpu(vcpu, &cmd->rc, &cmd->rrc);
+		break;
+	}
+	case KVM_PV_VCPU_DESTROY: {
+		if (!kvm_s390_pv_handle_cpu(vcpu))
+			return -EINVAL;
+
+		r = kvm_s390_pv_destroy_cpu(vcpu, &cmd->rc, &cmd->rrc);
+		break;
+	}
+	default:
+		r = -ENOTTY;
+	}
+	return r;
+}
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
@@ -4493,6 +4674,25 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 					   irq_state.len);
 		break;
 	}
+	case KVM_S390_PV_COMMAND_VCPU: {
+		struct kvm_pv_cmd args;
+
+		r = 0;
+		if (!is_prot_virt_host()) {
+			r = -EINVAL;
+			break;
+		}
+		if (copy_from_user(&args, argp, sizeof(args))) {
+			r = -EFAULT;
+			break;
+		}
+		r = kvm_s390_handle_pv_vcpu(vcpu, &args);
+		if (copy_to_user(argp, &args, sizeof(args))) {
+			r = -EFAULT;
+			break;
+		}
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 83dabb18e4d9..d5503dd0d1e4 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -207,6 +207,33 @@ static inline int kvm_s390_user_cpu_state_ctrl(struct kvm *kvm)
 	return kvm->arch.user_cpu_state_ctrl != 0;
 }
 
+/* implemented in pv.c */
+void kvm_s390_pv_dealloc_vm(struct kvm *kvm);
+int kvm_s390_pv_alloc_vm(struct kvm *kvm);
+int kvm_s390_pv_create_vm(struct kvm *kvm, u16 *rc, u16 *rrc);
+int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
+int kvm_s390_pv_destroy_vm(struct kvm *kvm, u16 *rc, u16 *rrc);
+int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
+int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, u16 *rc,
+			      u16 *rrc);
+int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
+		       unsigned long tweak, u16 *rc, u16 *rrc);
+
+static inline bool kvm_s390_pv_is_protected(struct kvm *kvm)
+{
+	return !!kvm->arch.pv.handle;
+}
+
+static inline u64 kvm_s390_pv_handle(struct kvm *kvm)
+{
+	return kvm->arch.pv.handle;
+}
+
+static inline u64 kvm_s390_pv_handle_cpu(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.pv.handle;
+}
+
 /* implemented in interrupt.c */
 int kvm_s390_handle_wait(struct kvm_vcpu *vcpu);
 void kvm_s390_vcpu_wakeup(struct kvm_vcpu *vcpu);
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
new file mode 100644
index 000000000000..bf00cde1ead8
--- /dev/null
+++ b/arch/s390/kvm/pv.c
@@ -0,0 +1,262 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Hosting Secure Execution virtual machines
+ *
+ * Copyright IBM Corp. 2019
+ *    Author(s): Janosch Frank <frankja@linux.ibm.com>
+ */
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <linux/pagemap.h>
+#include <linux/sched/signal.h>
+#include <asm/pgalloc.h>
+#include <asm/gmap.h>
+#include <asm/uv.h>
+#include <asm/gmap.h>
+#include <asm/mman.h>
+#include "kvm-s390.h"
+
+void kvm_s390_pv_dealloc_vm(struct kvm *kvm)
+{
+	vfree(kvm->arch.pv.stor_var);
+	free_pages(kvm->arch.pv.stor_base,
+		   get_order(uv_info.guest_base_stor_len));
+	memset(&kvm->arch.pv, 0, sizeof(kvm->arch.pv));
+}
+
+int kvm_s390_pv_alloc_vm(struct kvm *kvm)
+{
+	unsigned long base = uv_info.guest_base_stor_len;
+	unsigned long virt = uv_info.guest_virt_var_stor_len;
+	unsigned long npages = 0, vlen = 0;
+	struct kvm_memory_slot *memslot;
+
+	kvm->arch.pv.stor_var = NULL;
+	kvm->arch.pv.stor_base = __get_free_pages(GFP_KERNEL, get_order(base));
+	if (!kvm->arch.pv.stor_base)
+		return -ENOMEM;
+
+	/*
+	 * Calculate current guest storage for allocation of the
+	 * variable storage, which is based on the length in MB.
+	 *
+	 * Slots are sorted by GFN
+	 */
+	mutex_lock(&kvm->slots_lock);
+	memslot = kvm_memslots(kvm)->memslots;
+	npages = memslot->base_gfn + memslot->npages;
+	mutex_unlock(&kvm->slots_lock);
+
+	kvm->arch.pv.guest_len = npages * PAGE_SIZE;
+
+	/* Allocate variable storage */
+	vlen = ALIGN(virt * ((npages * PAGE_SIZE) / HPAGE_SIZE), PAGE_SIZE);
+	vlen += uv_info.guest_virt_base_stor_len;
+	kvm->arch.pv.stor_var = vzalloc(vlen);
+	if (!kvm->arch.pv.stor_var)
+		goto out_err;
+	return 0;
+
+out_err:
+	kvm_s390_pv_dealloc_vm(kvm);
+	return -ENOMEM;
+}
+
+int kvm_s390_pv_destroy_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
+{
+	int cc;
+
+	cc = uv_cmd_nodata(kvm_s390_pv_handle(kvm),
+			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
+	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
+	atomic_set(&kvm->mm->context.is_protected, 0);
+	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
+	return cc;
+}
+
+int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
+{
+	int cc = 0;
+
+	if (kvm_s390_pv_handle_cpu(vcpu)) {
+		cc = uv_cmd_nodata(kvm_s390_pv_handle_cpu(vcpu),
+				   UVC_CMD_DESTROY_SEC_CPU, rc, rrc);
+
+		VCPU_EVENT(vcpu, 3, "PROTVIRT DESTROY VCPU: rc %x rrc %x",
+			   *rc, *rrc);
+		KVM_UV_EVENT(vcpu->kvm, 3, "PROTVIRT DESTROY VCPU: rc %x rrc %x",
+			     *rc, *rrc);
+	}
+
+	free_pages(vcpu->arch.pv.stor_base,
+		   get_order(uv_info.guest_cpu_stor_len));
+	vcpu->arch.sie_block->pv_handle_cpu = 0;
+	vcpu->arch.sie_block->pv_handle_config = 0;
+	memset(&vcpu->arch.pv, 0, sizeof(vcpu->arch.pv));
+	vcpu->arch.sie_block->sdf = 0;
+	return cc;
+}
+
+int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
+{
+	struct uv_cb_csc uvcb = {
+		.header.cmd = UVC_CMD_CREATE_SEC_CPU,
+		.header.len = sizeof(uvcb),
+	};
+	int cc;
+
+	if (kvm_s390_pv_handle_cpu(vcpu))
+		return -EINVAL;
+
+	vcpu->arch.pv.stor_base = __get_free_pages(GFP_KERNEL,
+						   get_order(uv_info.guest_cpu_stor_len));
+	if (!vcpu->arch.pv.stor_base)
+		return -ENOMEM;
+
+	/* Input */
+	uvcb.guest_handle = kvm_s390_pv_handle(vcpu->kvm);
+	uvcb.num = vcpu->arch.sie_block->icpua;
+	uvcb.state_origin = (u64)vcpu->arch.sie_block;
+	uvcb.stor_origin = (u64)vcpu->arch.pv.stor_base;
+
+	cc = uv_call(0, (u64)&uvcb);
+	*rc = uvcb.header.rc;
+	*rrc = uvcb.header.rrc;
+	VCPU_EVENT(vcpu, 3, "PROTVIRT CREATE VCPU: handle %llx rc %x rrc %x",
+		   uvcb.cpu_handle, uvcb.header.rc, uvcb.header.rrc);
+	KVM_UV_EVENT(vcpu->kvm, 3,
+		     "PROTVIRT CREATE VCPU: cpu %d handle %llx rc %x rrc %x",
+		     vcpu->vcpu_id, uvcb.cpu_handle, uvcb.header.rc,
+		     uvcb.header.rrc);
+
+	if (cc) {
+		u16 dummy;
+
+		kvm_s390_pv_destroy_cpu(vcpu, &dummy, &dummy);
+		return -EINVAL;
+	}
+
+	/* Output */
+	vcpu->arch.pv.handle = uvcb.cpu_handle;
+	vcpu->arch.sie_block->pv_handle_cpu = uvcb.cpu_handle;
+	vcpu->arch.sie_block->pv_handle_config = kvm_s390_pv_handle(vcpu->kvm);
+	vcpu->arch.sie_block->sdf = 2;
+	return 0;
+}
+
+int kvm_s390_pv_create_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
+{
+	u16 drc, drrc;
+	int cc;
+
+	struct uv_cb_cgc uvcb = {
+		.header.cmd = UVC_CMD_CREATE_SEC_CONF,
+		.header.len = sizeof(uvcb)
+	};
+
+	if (kvm_s390_pv_handle(kvm))
+		return -EINVAL;
+
+	/* Inputs */
+	uvcb.guest_stor_origin = 0; /* MSO is 0 for KVM */
+	uvcb.guest_stor_len = kvm->arch.pv.guest_len;
+	uvcb.guest_asce = kvm->arch.gmap->asce;
+	uvcb.guest_sca = (unsigned long)kvm->arch.sca;
+	uvcb.conf_base_stor_origin = (u64)kvm->arch.pv.stor_base;
+	uvcb.conf_virt_stor_origin = (u64)kvm->arch.pv.stor_var;
+
+	cc = uv_call(0, (u64)&uvcb);
+	*rc = uvcb.header.rc;
+	*rrc = uvcb.header.rrc;
+	KVM_UV_EVENT(kvm, 3, "PROTVIRT CREATE VM: handle %llx len %llx rc %x rrc %x",
+		     uvcb.guest_handle, uvcb.guest_stor_len, *rc, *rrc);
+
+	/* Outputs */
+	kvm->arch.pv.handle = uvcb.guest_handle;
+
+	if (cc && (uvcb.header.rc & UVC_RC_NEED_DESTROY)) {
+		kvm_s390_pv_destroy_vm(kvm, &drc, &drrc);
+		return -EINVAL;
+	}
+	kvm->arch.gmap->guest_handle = uvcb.guest_handle;
+	atomic_set(&kvm->mm->context.is_protected, 1);
+	return cc;
+}
+
+int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, u16 *rc,
+			      u16 *rrc)
+{
+	struct uv_cb_ssc uvcb = {
+		.header.cmd = UVC_CMD_SET_SEC_CONF_PARAMS,
+		.header.len = sizeof(uvcb),
+		.sec_header_origin = (u64)hdr,
+		.sec_header_len = length,
+		.guest_handle = kvm_s390_pv_handle(kvm),
+	};
+	int cc;
+
+	if (!kvm_s390_pv_handle(kvm))
+		return -EINVAL;
+
+	cc = uv_call(0, (u64)&uvcb);
+	*rc = uvcb.header.rc;
+	*rrc = uvcb.header.rrc;
+	KVM_UV_EVENT(kvm, 3, "PROTVIRT VM SET PARMS: rc %x rrc %x",
+		     uvcb.header.rc, uvcb.header.rrc);
+	if (cc)
+		return -EINVAL;
+	return 0;
+}
+
+static int unpack_one(struct kvm *kvm, unsigned long addr, u64 tweak[2],
+		      u16 *rc, u16 *rrc)
+{
+	struct uv_cb_unp uvcb = {
+		.header.cmd = UVC_CMD_UNPACK_IMG,
+		.header.len = sizeof(uvcb),
+		.guest_handle = kvm_s390_pv_handle(kvm),
+		.gaddr = addr,
+		.tweak[0] = tweak[0],
+		.tweak[1] = tweak[1],
+	};
+	int ret;
+
+	ret = gmap_make_secure(kvm->arch.gmap, addr, &uvcb);
+	*rc = uvcb.header.rc;
+	*rrc = uvcb.header.rrc;
+
+	if (ret && ret != -EAGAIN)
+		KVM_UV_EVENT(kvm, 3, "PROTVIRT VM UNPACK: failed addr %llx with rc %x rrc %x",
+			     uvcb.gaddr, *rc, *rrc);
+	return ret;
+}
+
+int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
+		       unsigned long tweak, u16 *rc, u16 *rrc)
+{
+	u64 tw[2] = {tweak, 0};
+	int ret = 0;
+
+	if (addr & ~PAGE_MASK || !size || size & ~PAGE_MASK)
+		return -EINVAL;
+
+	KVM_UV_EVENT(kvm, 3, "PROTVIRT VM UNPACK: start addr %lx size %lx",
+		     addr, size);
+
+	while (tw[1] < size) {
+		ret = unpack_one(kvm, addr, tw, rc, rrc);
+		if (ret == -EAGAIN) {
+			cond_resched();
+			if (fatal_signal_pending(current))
+				break;
+			continue;
+		}
+		if (ret)
+			break;
+		addr += PAGE_SIZE;
+		tw[1] += PAGE_SIZE;
+	}
+	if (!ret)
+		KVM_UV_EVENT(kvm, 3, "%s", "PROTVIRT VM UNPACK: successful");
+	return ret;
+}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 4b95f9a31a2f..207915488502 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1010,6 +1010,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_NISV_TO_USER 177
 #define KVM_CAP_ARM_INJECT_EXT_DABT 178
 #define KVM_CAP_S390_VCPU_RESETS 179
+#define KVM_CAP_S390_PROTECTED 181
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1478,6 +1479,40 @@ struct kvm_enc_region {
 #define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
 #define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
 
+struct kvm_s390_pv_sec_parm {
+	__u64	origin;
+	__u64	length;
+};
+
+struct kvm_s390_pv_unp {
+	__u64 addr;
+	__u64 size;
+	__u64 tweak;
+};
+
+enum pv_cmd_id {
+	KVM_PV_VM_CREATE,
+	KVM_PV_VM_DESTROY,
+	KVM_PV_VM_SET_SEC_PARMS,
+	KVM_PV_VM_UNPACK,
+	KVM_PV_VM_VERIFY,
+	KVM_PV_VCPU_CREATE,
+	KVM_PV_VCPU_DESTROY,
+};
+
+struct kvm_pv_cmd {
+	__u32 cmd;	/* Command to be executed */
+	__u16 rc;	/* Ultravisor return code */
+	__u16 rrc;	/* Ultravisor return reason code */
+	__u64 data;	/* Data or address */
+	__u32 flags;    /* flags for future extensions. Must be 0 for now */
+	__u32 reserved[3];
+};
+
+/* Available with KVM_CAP_S390_PROTECTED */
+#define KVM_S390_PV_COMMAND		_IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
+#define KVM_S390_PV_COMMAND_VCPU	_IOWR(KVMIO, 0xc6, struct kvm_pv_cmd)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.25.0

