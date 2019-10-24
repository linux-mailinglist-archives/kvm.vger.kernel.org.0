Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 183BDE30BE
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 13:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409219AbfJXLmI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 07:42:08 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37652 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2439110AbfJXLl7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Oct 2019 07:41:59 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9OBbA9s020734
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:41:58 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vuabhj57n-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:41:58 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 24 Oct 2019 12:41:55 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 24 Oct 2019 12:41:52 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9OBfpLi45678730
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 11:41:51 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E1445204F;
        Thu, 24 Oct 2019 11:41:51 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5EFC05205A;
        Thu, 24 Oct 2019 11:41:49 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com, frankja@linux.ibm.com
Subject: [RFC 04/37] KVM: s390: protvirt: Add initial lifecycle handling
Date:   Thu, 24 Oct 2019 07:40:26 -0400
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024114059.102802-1-frankja@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19102411-0016-0000-0000-000002BCC9A8
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102411-0017-0000-0000-0000331E0E43
Message-Id: <20191024114059.102802-5-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-24_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910240115
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's add a KVM interface to create and destroy protected VMs.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  24 +++-
 arch/s390/include/asm/uv.h       | 110 ++++++++++++++
 arch/s390/kvm/Makefile           |   2 +-
 arch/s390/kvm/kvm-s390.c         | 173 +++++++++++++++++++++-
 arch/s390/kvm/kvm-s390.h         |  47 ++++++
 arch/s390/kvm/pv.c               | 237 +++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h         |  33 +++++
 7 files changed, 622 insertions(+), 4 deletions(-)
 create mode 100644 arch/s390/kvm/pv.c

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 02f4c21c57f6..d4fd0f3af676 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -155,7 +155,13 @@ struct kvm_s390_sie_block {
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
@@ -228,7 +234,7 @@ struct kvm_s390_sie_block {
 #define ECB3_RI  0x01
 	__u8    ecb3;			/* 0x0063 */
 	__u32	scaol;			/* 0x0064 */
-	__u8	reserved68;		/* 0x0068 */
+	__u8	sdf;			/* 0x0068 */
 	__u8    epdx;			/* 0x0069 */
 	__u8    reserved6a[2];		/* 0x006a */
 	__u32	todpr;			/* 0x006c */
@@ -640,6 +646,11 @@ struct kvm_guestdbg_info_arch {
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
@@ -668,6 +679,7 @@ struct kvm_vcpu_arch {
 	__u64 cputm_start;
 	bool gs_enabled;
 	bool skey_enabled;
+	struct kvm_s390_pv_vcpu pv;
 };
 
 struct kvm_vm_stat {
@@ -841,6 +853,13 @@ struct kvm_s390_gisa_interrupt {
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
@@ -876,6 +895,7 @@ struct kvm_arch{
 	DECLARE_BITMAP(cpu_feat, KVM_S390_VM_CPU_FEAT_NR_BITS);
 	DECLARE_BITMAP(idle_mask, KVM_MAX_VCPUS);
 	struct kvm_s390_gisa_interrupt gisa_int;
+	struct kvm_s390_pv pv;
 };
 
 #define KVM_HVA_ERR_BAD		(-1UL)
diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 82a46fb913e7..0bfbafcca136 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -21,9 +21,19 @@
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
+#define UVC_CMD_CONV_TO_SEC_STOR	0x0200
+#define UVC_CMD_CONV_FROM_SEC_STOR	0x0201
+#define UVC_CMD_SET_SEC_CONF_PARAMS	0x0300
+#define UVC_CMD_UNPACK_IMG		0x0301
+#define UVC_CMD_VERIFY_IMG		0x0302
 #define UVC_CMD_SET_SHARED_ACCESS	0x1000
 #define UVC_CMD_REMOVE_SHARED_ACCESS	0x1001
 
@@ -31,8 +41,17 @@
 enum uv_cmds_inst {
 	BIT_UVC_CMD_QUI = 0,
 	BIT_UVC_CMD_INIT_UV = 1,
+	BIT_UVC_CMD_CREATE_SEC_CONF = 2,
+	BIT_UVC_CMD_DESTROY_SEC_CONF = 3,
+	BIT_UVC_CMD_CREATE_SEC_CPU = 4,
+	BIT_UVC_CMD_DESTROY_SEC_CPU = 5,
+	BIT_UVC_CMD_CONV_TO_SEC_STOR = 6,
+	BIT_UVC_CMD_CONV_FROM_SEC_STOR = 7,
 	BIT_UVC_CMD_SET_SHARED_ACCESS = 8,
 	BIT_UVC_CMD_REMOVE_SHARED_ACCESS = 9,
+	BIT_UVC_CMD_SET_SEC_PARMS = 11,
+	BIT_UVC_CMD_UNPACK_IMG = 13,
+	BIT_UVC_CMD_VERIFY_IMG = 14,
 };
 
 struct uv_cb_header {
@@ -70,6 +89,76 @@ struct uv_cb_init {
 
 } __packed __aligned(8);
 
+struct uv_cb_cgc {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 guest_handle;
+	u64 conf_base_stor_origin;
+	u64 conf_var_stor_origin;
+	u64 reserved30;
+	u64 guest_stor_origin;
+	u64 guest_stor_len;
+	u64 reserved48;
+	u64 guest_asce;
+	u64 reserved60[5];
+} __packed __aligned(8);
+
+struct uv_cb_csc {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 cpu_handle;
+	u64 guest_handle;
+	u64 stor_origin;
+	u8  reserved30[6];
+	u16 num;
+	u64 state_origin;
+	u64 reserved[4];
+} __packed __aligned(8);
+
+struct uv_cb_cts {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 guest_handle;
+	u64 gaddr;
+} __packed __aligned(8);
+
+struct uv_cb_cfs {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 paddr;
+} __packed __aligned(8);
+
+struct uv_cb_ssc {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 guest_handle;
+	u64 sec_header_origin;
+	u32 sec_header_len;
+	u32 reserved32;
+	u64 reserved38[4];
+} __packed __aligned(8);
+
+struct uv_cb_unp {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 guest_handle;
+	u64 gaddr;
+	u64 tweak[2];
+	u64 reserved28[3];
+} __packed __aligned(8);
+
+/*
+ * A common UV call struct for the following calls:
+ * Destroy cpu/config
+ * Verify
+ */
+struct uv_cb_nodata {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 handle;
+	u64 reserved20[4];
+} __packed __aligned(8);
+
 struct uv_cb_share {
 	struct uv_cb_header header;
 	u64 reserved08[3];
@@ -170,12 +259,33 @@ static inline int is_prot_virt_host(void)
 	return prot_virt_host;
 }
 
+/*
+ * Generic cmd executor for calls that only transport the cpu or guest
+ * handle and the command.
+ */
+static inline int uv_cmd_nodata(u64 handle, u16 cmd, u32 *ret)
+{
+	int rc;
+	struct uv_cb_nodata uvcb = {
+		.header.cmd = cmd,
+		.header.len = sizeof(uvcb),
+		.handle = handle,
+	};
+
+	WARN(!handle, "No handle provided to Ultravisor call cmd %x\n", cmd);
+	rc = uv_call(0, (u64)&uvcb);
+	if (ret)
+		*ret = *(u32 *)&uvcb.header.rc;
+	return rc ? -EINVAL : 0;
+}
+
 void setup_uv(void);
 void adjust_to_uv_max(unsigned long *vmax);
 #else
 #define is_prot_virt_host() 0
 static inline void setup_uv(void) {}
 static inline void adjust_to_uv_max(unsigned long *vmax) {}
+static inline int uv_cmd_nodata(u64 handle, u16 cmd, u32 *ret) { return 0; }
 #endif
 
 #if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) ||                          \
diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
index 05ee90a5ea08..eaaedf9e61a7 100644
--- a/arch/s390/kvm/Makefile
+++ b/arch/s390/kvm/Makefile
@@ -9,6 +9,6 @@ common-objs = $(KVM)/kvm_main.o $(KVM)/eventfd.o  $(KVM)/async_pf.o $(KVM)/irqch
 ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
 
 kvm-objs := $(common-objs) kvm-s390.o intercept.o interrupt.o priv.o sigp.o
-kvm-objs += diag.o gaccess.o guestdbg.o vsie.o
+kvm-objs += diag.o gaccess.o guestdbg.o vsie.o $(if $(CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST),pv.o)
 
 obj-$(CONFIG_KVM) += kvm.o
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 3b5ebf48f802..924132d92782 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -44,6 +44,7 @@
 #include <asm/cpacf.h>
 #include <asm/timex.h>
 #include <asm/ap.h>
+#include <asm/uv.h>
 #include "kvm-s390.h"
 #include "gaccess.h"
 
@@ -235,6 +236,7 @@ int kvm_arch_check_processor_compat(void)
 
 static void kvm_gmap_notifier(struct gmap *gmap, unsigned long start,
 			      unsigned long end);
+static int sca_switch_to_extended(struct kvm *kvm);
 
 static void kvm_clock_sync_scb(struct kvm_s390_sie_block *scb, u64 delta)
 {
@@ -563,6 +565,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_S390_BPB:
 		r = test_facility(82);
 		break;
+#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
+	case KVM_CAP_S390_PROTECTED:
+		r = is_prot_virt_host();
+		break;
+#endif
 	default:
 		r = 0;
 	}
@@ -2157,6 +2164,96 @@ static int kvm_s390_set_cmma_bits(struct kvm *kvm,
 	return r;
 }
 
+#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
+static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
+{
+	int r = 0;
+	void __user *argp = (void __user *)cmd->data;
+
+	switch (cmd->cmd) {
+	case KVM_PV_VM_CREATE: {
+		r = kvm_s390_pv_alloc_vm(kvm);
+		if (r)
+			break;
+
+		mutex_lock(&kvm->lock);
+		kvm_s390_vcpu_block_all(kvm);
+		/* FMT 4 SIE needs esca */
+		r = sca_switch_to_extended(kvm);
+		if (!r)
+			r = kvm_s390_pv_create_vm(kvm);
+		kvm_s390_vcpu_unblock_all(kvm);
+		mutex_unlock(&kvm->lock);
+		break;
+	}
+	case KVM_PV_VM_DESTROY: {
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
+#endif
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
@@ -2254,6 +2351,22 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		mutex_unlock(&kvm->slots_lock);
 		break;
 	}
+#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
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
+#endif
 	default:
 		r = -ENOTTY;
 	}
@@ -2529,6 +2642,9 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 	if (vcpu->kvm->arch.use_cmma)
 		kvm_s390_vcpu_unsetup_cmma(vcpu);
+	if (IS_ENABLED(CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST) &&
+	    kvm_s390_pv_handle_cpu(vcpu))
+		kvm_s390_pv_destroy_cpu(vcpu);
 	free_page((unsigned long)(vcpu->arch.sie_block));
 
 	kvm_vcpu_uninit(vcpu);
@@ -2555,8 +2671,13 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 {
 	kvm_free_vcpus(kvm);
 	sca_dispose(kvm);
-	debug_unregister(kvm->arch.dbf);
 	kvm_s390_gisa_destroy(kvm);
+	if (IS_ENABLED(CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST) &&
+	    kvm_s390_pv_is_protected(kvm)) {
+		kvm_s390_pv_destroy_vm(kvm);
+		kvm_s390_pv_dealloc_vm(kvm);
+	}
+	debug_unregister(kvm->arch.dbf);
 	free_page((unsigned long)kvm->arch.sie_page2);
 	if (!kvm_is_ucontrol(kvm))
 		gmap_remove(kvm->arch.gmap);
@@ -2652,6 +2773,9 @@ static int sca_switch_to_extended(struct kvm *kvm)
 	unsigned int vcpu_idx;
 	u32 scaol, scaoh;
 
+	if (kvm->arch.use_esca)
+		return 0;
+
 	new_sca = alloc_pages_exact(sizeof(*new_sca), GFP_KERNEL|__GFP_ZERO);
 	if (!new_sca)
 		return -ENOMEM;
@@ -3073,6 +3197,15 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
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
@@ -4338,6 +4471,28 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
 	return -ENOIOCTLCMD;
 }
 
+#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
+static int kvm_s390_handle_pv_vcpu(struct kvm_vcpu *vcpu,
+				   struct kvm_pv_cmd *cmd)
+{
+	int r = 0;
+
+	switch (cmd->cmd) {
+	case KVM_PV_VCPU_CREATE: {
+		r = kvm_s390_pv_create_cpu(vcpu);
+		break;
+	}
+	case KVM_PV_VCPU_DESTROY: {
+		r = kvm_s390_pv_destroy_cpu(vcpu);
+		break;
+	}
+	default:
+		r = -ENOTTY;
+	}
+	return r;
+}
+#endif
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
@@ -4470,6 +4625,22 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 					   irq_state.len);
 		break;
 	}
+#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
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
+#endif
 	default:
 		r = -ENOTTY;
 	}
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 6d9448dbd052..0d61dcc51f0e 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -196,6 +196,53 @@ static inline int kvm_s390_user_cpu_state_ctrl(struct kvm *kvm)
 	return kvm->arch.user_cpu_state_ctrl != 0;
 }
 
+#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
+/* implemented in pv.c */
+void kvm_s390_pv_unpin(struct kvm *kvm);
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
+#else
+static inline void kvm_s390_pv_unpin(struct kvm *kvm) {}
+static inline void kvm_s390_pv_dealloc_vm(struct kvm *kvm) {}
+static inline int kvm_s390_pv_alloc_vm(struct kvm *kvm) { return 0; }
+static inline int kvm_s390_pv_create_vm(struct kvm *kvm) { return 0; }
+static inline int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu) { return 0; }
+static inline int kvm_s390_pv_destroy_vm(struct kvm *kvm) { return 0; }
+static inline int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu) { return 0; }
+static inline int kvm_s390_pv_set_sec_parms(struct kvm *kvm,
+					    u64 origin, u64 length) { return 0; }
+static inline int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr,
+				     unsigned long size,  unsigned long tweak)
+{ return 0; }
+static inline int kvm_s390_pv_verify(struct kvm *kvm) { return 0; }
+static inline bool kvm_s390_pv_is_protected(struct kvm *kvm) { return 0; }
+static inline u64 kvm_s390_pv_handle(struct kvm *kvm) { return 0; }
+static inline u64 kvm_s390_pv_handle_cpu(struct kvm_vcpu *vcpu) { return 0; }
+#endif
+
 /* implemented in interrupt.c */
 int kvm_s390_handle_wait(struct kvm_vcpu *vcpu);
 void kvm_s390_vcpu_wakeup(struct kvm_vcpu *vcpu);
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
new file mode 100644
index 000000000000..94cf16f40f25
--- /dev/null
+++ b/arch/s390/kvm/pv.c
@@ -0,0 +1,237 @@
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
+	struct kvm_memslots *slots;
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
+	slots = kvm_memslots(kvm);
+	memslot = slots->memslots;
+	npages = memslot->base_gfn + memslot->npages;
+
+	mutex_unlock(&kvm->slots_lock);
+	kvm->arch.pv.guest_len = npages * PAGE_SIZE;
+
+	/* Allocate variable storage */
+	vlen = ALIGN(virt * ((npages * PAGE_SIZE) / HPAGE_SIZE), PAGE_SIZE);
+	vlen += uv_info.guest_virt_base_stor_len;
+	kvm->arch.pv.stor_var = vzalloc(vlen);
+	if (!kvm->arch.pv.stor_var) {
+		kvm_s390_pv_dealloc_vm(kvm);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+int kvm_s390_pv_destroy_vm(struct kvm *kvm)
+{
+	int rc;
+	u32 ret;
+
+	rc = uv_cmd_nodata(kvm_s390_pv_handle(kvm),
+			   UVC_CMD_DESTROY_SEC_CONF, &ret);
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
+	/* Clear cpu and vm handle */
+	memset(&vcpu->arch.sie_block->reserved10, 0,
+	       sizeof(vcpu->arch.sie_block->reserved10));
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
+	/* EEXIST and ENOENT? */
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
+	/* Output */
+	vcpu->arch.pv.handle = uvcb.cpu_handle;
+	vcpu->arch.sie_block->pv_handle_cpu = uvcb.cpu_handle;
+	vcpu->arch.sie_block->pv_handle_config = kvm_s390_pv_handle(vcpu->kvm);
+	vcpu->arch.sie_block->sdf = 2;
+	if (!rc)
+		return 0;
+
+	kvm_s390_pv_destroy_cpu(vcpu);
+	return -EINVAL;
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
+	uvcb.conf_base_stor_origin = (u64)kvm->arch.pv.stor_base;
+	uvcb.conf_var_stor_origin = (u64)kvm->arch.pv.stor_var;
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
+		kvm_s390_pv_dealloc_vm(kvm);
+		return -EINVAL;
+	}
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
+int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
+		       unsigned long tweak)
+{
+	int i, rc = 0;
+	struct uv_cb_unp uvcb = {
+		.header.cmd = UVC_CMD_UNPACK_IMG,
+		.header.len = sizeof(uvcb),
+		.guest_handle = kvm_s390_pv_handle(kvm),
+		.tweak[0] = tweak
+	};
+
+	if (addr & ~PAGE_MASK || size & ~PAGE_MASK)
+		return -EINVAL;
+
+
+	VM_EVENT(kvm, 3, "PROTVIRT VM UNPACK: start addr %lx size %lx",
+		 addr, size);
+	for (i = 0; i < size / PAGE_SIZE; i++) {
+		uvcb.gaddr = addr + i * PAGE_SIZE;
+		uvcb.tweak[1] = i * PAGE_SIZE;
+retry:
+		rc = uv_call(0, (u64)&uvcb);
+		if (!rc)
+			continue;
+		/* If not yet mapped fault and retry */
+		if (uvcb.header.rc == 0x10a) {
+			rc = gmap_fault(kvm->arch.gmap, uvcb.gaddr,
+					FAULT_FLAG_WRITE);
+			if (rc)
+				return rc;
+			goto retry;
+		}
+		VM_EVENT(kvm, 3, "PROTVIRT VM UNPACK: failed addr %llx rc %x rrc %x",
+			 uvcb.gaddr, uvcb.header.rc, uvcb.header.rrc);
+		break;
+	}
+	VM_EVENT(kvm, 3, "PROTVIRT VM UNPACK: finished with rc %x rrc %x",
+		 uvcb.header.rc, uvcb.header.rrc);
+	return rc;
+}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 52641d8ca9e8..bb37d5710c89 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1000,6 +1000,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PMU_EVENT_FILTER 173
 #define KVM_CAP_ARM_IRQ_LINE_LAYOUT_2 174
 #define KVM_CAP_HYPERV_DIRECT_TLBFLUSH 175
+#define KVM_CAP_S390_PROTECTED 180
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1461,6 +1462,38 @@ struct kvm_enc_region {
 /* Available with KVM_CAP_ARM_SVE */
 #define KVM_ARM_VCPU_FINALIZE	  _IOW(KVMIO,  0xc2, int)
 
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
+	__u32	cmd;
+	__u16	rc;
+	__u16	rrc;
+	__u64	data;
+};
+
+/* Available with KVM_CAP_S390_SE */
+#define KVM_S390_PV_COMMAND		_IOW(KVMIO, 0xc3, struct kvm_pv_cmd)
+#define KVM_S390_PV_COMMAND_VCPU	_IOW(KVMIO, 0xc4, struct kvm_pv_cmd)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.20.1

