Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCDE91556E2
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 12:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgBGLkX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 06:40:23 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48604 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727518AbgBGLkT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 06:40:19 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 017BdtYT180996;
        Fri, 7 Feb 2020 06:40:17 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y0nru52ne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Feb 2020 06:40:15 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 017Be9pl181638;
        Fri, 7 Feb 2020 06:40:13 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y0nru52hp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Feb 2020 06:40:12 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 017BckpT031699;
        Fri, 7 Feb 2020 11:40:03 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04dal.us.ibm.com with ESMTP id 2xykca20vu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Feb 2020 11:40:03 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 017Be1b350921872
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Feb 2020 11:40:01 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E637AC05B;
        Fri,  7 Feb 2020 11:40:01 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1069CAC059;
        Fri,  7 Feb 2020 11:40:01 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  7 Feb 2020 11:40:01 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [PATCH 08/35] KVM: s390: protvirt: Add initial lifecycle handling
Date:   Fri,  7 Feb 2020 06:39:31 -0500
Message-Id: <20200207113958.7320-9-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200207113958.7320-1-borntraeger@de.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-07_01:2020-02-07,2020-02-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=2 clxscore=1015 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002070089
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
 arch/s390/include/asm/uv.h       |  69 +++++++++
 arch/s390/kvm/Makefile           |   2 +-
 arch/s390/kvm/kvm-s390.c         | 191 +++++++++++++++++++++++-
 arch/s390/kvm/kvm-s390.h         |  27 ++++
 arch/s390/kvm/pv.c               | 244 +++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h         |  33 +++++
 7 files changed, 586 insertions(+), 4 deletions(-)
 create mode 100644 arch/s390/kvm/pv.c

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 884503e05424..3ed31c5f80e1 100644
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
@@ -846,6 +858,13 @@ struct kvm_s390_gisa_interrupt {
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
@@ -881,6 +900,7 @@ struct kvm_arch{
 	DECLARE_BITMAP(cpu_feat, KVM_S390_VM_CPU_FEAT_NR_BITS);
 	DECLARE_BITMAP(idle_mask, KVM_MAX_VCPUS);
 	struct kvm_s390_gisa_interrupt gisa_int;
+	struct kvm_s390_pv pv;
 };
 
 #define KVM_HVA_ERR_BAD		(-1UL)
diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index e1cef772fde1..7c21d55d2e49 100644
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
index 1a48214ac507..e1bccbb41fdd 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -44,6 +44,7 @@
 #include <asm/cpacf.h>
 #include <asm/timex.h>
 #include <asm/ap.h>
+#include <asm/uv.h>
 #include "kvm-s390.h"
 #include "gaccess.h"
 
@@ -236,6 +237,7 @@ int kvm_arch_check_processor_compat(void)
 
 static void kvm_gmap_notifier(struct gmap *gmap, unsigned long start,
 			      unsigned long end);
+static int sca_switch_to_extended(struct kvm *kvm);
 
 static void kvm_clock_sync_scb(struct kvm_s390_sie_block *scb, u64 delta)
 {
@@ -568,6 +570,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_S390_BPB:
 		r = test_facility(82);
 		break;
+	case KVM_CAP_S390_PROTECTED:
+		r = is_prot_virt_host();
+		break;
 	default:
 		r = 0;
 	}
@@ -2162,6 +2167,115 @@ static int kvm_s390_set_cmma_bits(struct kvm *kvm,
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
+		r = kvm_s390_pv_create_vm(kvm);
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
+		r = kvm_s390_pv_destroy_vm(kvm);
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
+				   parms.length))
+			r = kvm_s390_pv_set_sec_parms(kvm, hdr, parms.length);
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
+		r = kvm_s390_pv_unpack(kvm, unp.addr, unp.size, unp.tweak);
+		break;
+	}
+	case KVM_PV_VM_VERIFY: {
+		u32 ret;
+
+		r = -EINVAL;
+		if (!kvm_s390_pv_is_protected(kvm))
+			break;
+
+		r = uv_cmd_nodata(kvm_s390_pv_handle(kvm),
+				  UVC_CMD_VERIFY_IMG,
+				  &ret);
+		VM_EVENT(kvm, 3, "PROTVIRT VERIFY: rc %x rrc %x",
+			 ret >> 16, ret & 0x0000ffff);
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
@@ -2259,6 +2373,20 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		mutex_unlock(&kvm->slots_lock);
 		break;
 	}
+	case KVM_S390_PV_COMMAND: {
+		struct kvm_pv_cmd args;
+
+		r = -EINVAL;
+		if (!is_prot_virt_host())
+			break;
+
+		r = -EFAULT;
+		if (copy_from_user(&args, argp, sizeof(args)))
+			break;
+
+		r = kvm_s390_handle_pv(kvm, &args);
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
@@ -2534,6 +2662,8 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 	if (vcpu->kvm->arch.use_cmma)
 		kvm_s390_vcpu_unsetup_cmma(vcpu);
+	if (kvm_s390_pv_handle_cpu(vcpu))
+		kvm_s390_pv_destroy_cpu(vcpu);
 	free_page((unsigned long)(vcpu->arch.sie_block));
 
 	kvm_vcpu_uninit(vcpu);
@@ -2560,8 +2690,12 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 {
 	kvm_free_vcpus(kvm);
 	sca_dispose(kvm);
-	debug_unregister(kvm->arch.dbf);
 	kvm_s390_gisa_destroy(kvm);
+	if (kvm_s390_pv_is_protected(kvm)) {
+		kvm_s390_pv_destroy_vm(kvm);
+		kvm_s390_pv_dealloc_vm(kvm);
+	}
+	debug_unregister(kvm->arch.dbf);
 	free_page((unsigned long)kvm->arch.sie_page2);
 	if (!kvm_is_ucontrol(kvm))
 		gmap_remove(kvm->arch.gmap);
@@ -2657,6 +2791,9 @@ static int sca_switch_to_extended(struct kvm *kvm)
 	unsigned int vcpu_idx;
 	u32 scaol, scaoh;
 
+	if (kvm->arch.use_esca)
+		return 0;
+
 	new_sca = alloc_pages_exact(sizeof(*new_sca), GFP_KERNEL|__GFP_ZERO);
 	if (!new_sca)
 		return -ENOMEM;
@@ -3049,6 +3186,15 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 	rc = kvm_vcpu_init(vcpu, kvm, id);
 	if (rc)
 		goto out_free_sie_block;
+
+	if (kvm_s390_pv_is_protected(kvm)) {
+		rc = kvm_s390_pv_create_cpu(vcpu);
+		if (rc) {
+			kvm_vcpu_uninit(vcpu);
+			goto out_free_sie_block;
+		}
+	}
+
 	VM_EVENT(kvm, 3, "create cpu %d at 0x%pK, sie block at 0x%pK", id, vcpu,
 		 vcpu->arch.sie_block);
 	trace_kvm_s390_create_vcpu(id, vcpu, vcpu->arch.sie_block);
@@ -4357,6 +4503,35 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
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
+	switch (cmd->cmd) {
+	case KVM_PV_VCPU_CREATE: {
+		if (kvm_s390_pv_handle_cpu(vcpu))
+			return -EINVAL;
+
+		r = kvm_s390_pv_create_cpu(vcpu);
+		break;
+	}
+	case KVM_PV_VCPU_DESTROY: {
+		if (!kvm_s390_pv_handle_cpu(vcpu))
+			return -EINVAL;
+
+		r = kvm_s390_pv_destroy_cpu(vcpu);
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
@@ -4498,6 +4673,20 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 					   irq_state.len);
 		break;
 	}
+	case KVM_S390_PV_COMMAND_VCPU: {
+		struct kvm_pv_cmd args;
+
+		r = -EINVAL;
+		if (!is_prot_virt_host())
+			break;
+
+		r = -EFAULT;
+		if (copy_from_user(&args, argp, sizeof(args)))
+			break;
+
+		r = kvm_s390_handle_pv_vcpu(vcpu, &args);
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 54c5eb4b275d..32c0c01d5df0 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -196,6 +196,33 @@ static inline int kvm_s390_user_cpu_state_ctrl(struct kvm *kvm)
 	return kvm->arch.user_cpu_state_ctrl != 0;
 }
 
+/* implemented in pv.c */
+void kvm_s390_pv_dealloc_vm(struct kvm *kvm);
+int kvm_s390_pv_alloc_vm(struct kvm *kvm);
+int kvm_s390_pv_create_vm(struct kvm *kvm);
+int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu);
+int kvm_s390_pv_destroy_vm(struct kvm *kvm);
+int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu);
+int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length);
+int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
+		       unsigned long tweak);
+int kvm_s390_pv_verify(struct kvm *kvm);
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
index 000000000000..4795e61f4e16
--- /dev/null
+++ b/arch/s390/kvm/pv.c
@@ -0,0 +1,244 @@
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
+int kvm_s390_pv_destroy_vm(struct kvm *kvm)
+{
+	int rc;
+	u32 ret;
+
+	rc = uv_cmd_nodata(kvm_s390_pv_handle(kvm),
+			   UVC_CMD_DESTROY_SEC_CONF, &ret);
+	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
+	atomic_set(&kvm->mm->context.is_protected, 0);
+	VM_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x",
+		 ret >> 16, ret & 0x0000ffff);
+	return rc;
+}
+
+int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu)
+{
+	int rc = 0;
+	u32 ret;
+
+	if (kvm_s390_pv_handle_cpu(vcpu)) {
+		rc = uv_cmd_nodata(kvm_s390_pv_handle_cpu(vcpu),
+				   UVC_CMD_DESTROY_SEC_CPU,
+				   &ret);
+
+		VCPU_EVENT(vcpu, 3, "PROTVIRT DESTROY VCPU: cpu %d rc %x rrc %x",
+			   vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);
+	}
+
+	free_pages(vcpu->arch.pv.stor_base,
+		   get_order(uv_info.guest_cpu_stor_len));
+	vcpu->arch.sie_block->pv_handle_cpu = 0;
+	vcpu->arch.sie_block->pv_handle_config = 0;
+	memset(&vcpu->arch.pv, 0, sizeof(vcpu->arch.pv));
+	vcpu->arch.sie_block->sdf = 0;
+	return rc;
+}
+
+int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu)
+{
+	int rc;
+	struct uv_cb_csc uvcb = {
+		.header.cmd = UVC_CMD_CREATE_SEC_CPU,
+		.header.len = sizeof(uvcb),
+	};
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
+	rc = uv_call(0, (u64)&uvcb);
+	VCPU_EVENT(vcpu, 3, "PROTVIRT CREATE VCPU: cpu %d handle %llx rc %x rrc %x",
+		   vcpu->vcpu_id, uvcb.cpu_handle, uvcb.header.rc,
+		   uvcb.header.rrc);
+
+	if (rc) {
+		kvm_s390_pv_destroy_cpu(vcpu);
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
+int kvm_s390_pv_create_vm(struct kvm *kvm)
+{
+	int rc;
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
+	rc = uv_call(0, (u64)&uvcb);
+	VM_EVENT(kvm, 3, "PROTVIRT CREATE VM: handle %llx len %llx rc %x rrc %x",
+		 uvcb.guest_handle, uvcb.guest_stor_len, uvcb.header.rc,
+		 uvcb.header.rrc);
+
+	/* Outputs */
+	kvm->arch.pv.handle = uvcb.guest_handle;
+
+	if (rc && (uvcb.header.rc & 0x8000)) {
+		kvm_s390_pv_destroy_vm(kvm);
+		return -EINVAL;
+	}
+	kvm->arch.gmap->guest_handle = uvcb.guest_handle;
+	atomic_set(&kvm->mm->context.is_protected, 1);
+	return rc;
+}
+
+int kvm_s390_pv_set_sec_parms(struct kvm *kvm,
+			      void *hdr, u64 length)
+{
+	int rc;
+	struct uv_cb_ssc uvcb = {
+		.header.cmd = UVC_CMD_SET_SEC_CONF_PARAMS,
+		.header.len = sizeof(uvcb),
+		.sec_header_origin = (u64)hdr,
+		.sec_header_len = length,
+		.guest_handle = kvm_s390_pv_handle(kvm),
+	};
+
+	if (!kvm_s390_pv_handle(kvm))
+		return -EINVAL;
+
+	rc = uv_call(0, (u64)&uvcb);
+	VM_EVENT(kvm, 3, "PROTVIRT VM SET PARMS: rc %x rrc %x",
+		 uvcb.header.rc, uvcb.header.rrc);
+	if (rc)
+		return -EINVAL;
+	return 0;
+}
+
+static int unpack_one(struct kvm *kvm, unsigned long addr, u64 tweak[2])
+{
+	struct uv_cb_unp uvcb = {
+		.header.cmd = UVC_CMD_UNPACK_IMG,
+		.header.len = sizeof(uvcb),
+		.guest_handle = kvm_s390_pv_handle(kvm),
+		.gaddr = addr,
+		.tweak[0] = tweak[0],
+		.tweak[1] = tweak[1],
+	};
+	int rc;
+
+	rc = uv_make_secure(kvm->arch.gmap, addr, &uvcb);
+
+	if (rc)
+		VM_EVENT(kvm, 3, "PROTVIRT VM UNPACK: failed addr %llx rc %x rrc %x",
+			 uvcb.gaddr, uvcb.header.rc, uvcb.header.rrc);
+	return rc;
+}
+
+int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
+		       unsigned long tweak)
+{
+	int rc = 0;
+	u64 tw[2] = {tweak, 0};
+
+	if (addr & ~PAGE_MASK || !size || size & ~PAGE_MASK)
+		return -EINVAL;
+
+	VM_EVENT(kvm, 3, "PROTVIRT VM UNPACK: start addr %lx size %lx",
+		 addr, size);
+
+	while (tw[1] < size) {
+		rc = unpack_one(kvm, addr, tw);
+		if (rc == -EAGAIN)
+			continue;
+		if (rc)
+			break;
+		addr += PAGE_SIZE;
+		tw[1] += PAGE_SIZE;
+	}
+	VM_EVENT(kvm, 3, "PROTVIRT VM UNPACK: finished with rc %x", rc);
+	return rc;
+}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 4b95f9a31a2f..eab741bc12c3 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1010,6 +1010,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_NISV_TO_USER 177
 #define KVM_CAP_ARM_INJECT_EXT_DABT 178
 #define KVM_CAP_S390_VCPU_RESETS 179
+#define KVM_CAP_S390_PROTECTED 181
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1478,6 +1479,38 @@ struct kvm_enc_region {
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
+	__u32	cmd;	/* Command to be executed */
+	__u16	rc;	/* Ultravisor return code */
+	__u16	rrc;	/* Ultravisor return reason code */
+	__u64	data;	/* Data or address */
+};
+
+/* Available with KVM_CAP_S390_PROTECTED */
+#define KVM_S390_PV_COMMAND		_IOW(KVMIO, 0xc5, struct kvm_pv_cmd)
+#define KVM_S390_PV_COMMAND_VCPU	_IOW(KVMIO, 0xc6, struct kvm_pv_cmd)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.24.0

