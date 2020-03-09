Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBDF817DBBE
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 09:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgCIIvm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 04:51:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11060 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726528AbgCIIvj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 04:51:39 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0298ovSu087106
        for <kvm@vger.kernel.org>; Mon, 9 Mar 2020 04:51:38 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ym8n6wjn8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 04:51:38 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 9 Mar 2020 08:51:35 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 9 Mar 2020 08:51:32 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0298pUAi58392678
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Mar 2020 08:51:30 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 829D552050;
        Mon,  9 Mar 2020 08:51:30 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 69B4B52052;
        Mon,  9 Mar 2020 08:51:30 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 2F739E0251; Mon,  9 Mar 2020 09:51:30 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Ulrich Weigand <uweigand@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL 09/36] KVM: s390: protvirt: Add initial vm and cpu lifecycle handling
Date:   Mon,  9 Mar 2020 09:50:59 +0100
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309085126.3334302-1-borntraeger@de.ibm.com>
References: <20200309085126.3334302-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20030908-0016-0000-0000-000002EE8103
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030908-0017-0000-0000-00003351DF45
Message-Id: <20200309085126.3334302-10-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_02:2020-03-06,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 suspectscore=2 spamscore=0
 phishscore=0 bulkscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003090066
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
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
[borntraeger@de.ibm.com: patch merging, splitting, fixing]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  24 ++-
 arch/s390/include/asm/uv.h       |  69 ++++++++
 arch/s390/kvm/Makefile           |   2 +-
 arch/s390/kvm/kvm-s390.c         | 214 ++++++++++++++++++++++++-
 arch/s390/kvm/kvm-s390.h         |  33 ++++
 arch/s390/kvm/pv.c               | 266 +++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h         |  31 ++++
 7 files changed, 635 insertions(+), 4 deletions(-)
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
index d7aa91c89f6c..91ef26983bfd 100644
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
 	u8  reserveda0[200 - 160];
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
index 7e4a982bfea3..87258bebb955 100644
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
@@ -2165,6 +2168,160 @@ static int kvm_s390_set_cmma_bits(struct kvm *kvm,
 	return r;
 }
 
+static int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rcp, u16 *rrcp)
+{
+	struct kvm_vcpu *vcpu;
+	u16 rc, rrc;
+	int ret = 0;
+	int i;
+
+	/*
+	 * We ignore failures and try to destroy as many CPUs as possible.
+	 * At the same time we must not free the assigned resources when
+	 * this fails, as the ultravisor has still access to that memory.
+	 * So kvm_s390_pv_destroy_cpu can leave a "wanted" memory leak
+	 * behind.
+	 * We want to return the first failure rc and rrc, though.
+	 */
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		mutex_lock(&vcpu->mutex);
+		if (kvm_s390_pv_destroy_cpu(vcpu, &rc, &rrc) && !ret) {
+			*rcp = rc;
+			*rrcp = rrc;
+			ret = -EIO;
+		}
+		mutex_unlock(&vcpu->mutex);
+	}
+	return ret;
+}
+
+static int kvm_s390_cpus_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
+{
+	int i, r = 0;
+	u16 dummy;
+
+	struct kvm_vcpu *vcpu;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		mutex_lock(&vcpu->mutex);
+		r = kvm_s390_pv_create_cpu(vcpu, rc, rrc);
+		mutex_unlock(&vcpu->mutex);
+		if (r)
+			break;
+	}
+	if (r)
+		kvm_s390_cpus_from_pv(kvm, &dummy, &dummy);
+	return r;
+}
+
+static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
+{
+	int r = 0;
+	u16 dummy;
+	void __user *argp = (void __user *)cmd->data;
+
+	switch (cmd->cmd) {
+	case KVM_PV_ENABLE: {
+		r = -EINVAL;
+		if (kvm_s390_pv_is_protected(kvm))
+			break;
+
+		/*
+		 *  FMT 4 SIE needs esca. As we never switch back to bsca from
+		 *  esca, we need no cleanup in the error cases below
+		 */
+		r = sca_switch_to_extended(kvm);
+		if (r)
+			break;
+
+		r = kvm_s390_pv_init_vm(kvm, &cmd->rc, &cmd->rrc);
+		if (r)
+			break;
+
+		r = kvm_s390_cpus_to_pv(kvm, &cmd->rc, &cmd->rrc);
+		if (r)
+			kvm_s390_pv_deinit_vm(kvm, &dummy, &dummy);
+		break;
+	}
+	case KVM_PV_DISABLE: {
+		r = -EINVAL;
+		if (!kvm_s390_pv_is_protected(kvm))
+			break;
+
+		r = kvm_s390_cpus_from_pv(kvm, &cmd->rc, &cmd->rrc);
+		/*
+		 * If a CPU could not be destroyed, destroy VM will also fail.
+		 * There is no point in trying to destroy it. Instead return
+		 * the rc and rrc from the first CPU that failed destroying.
+		 */
+		if (r)
+			break;
+		r = kvm_s390_pv_deinit_vm(kvm, &cmd->rc, &cmd->rrc);
+		break;
+	}
+	case KVM_PV_SET_SEC_PARMS: {
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
+	case KVM_PV_UNPACK: {
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
+	case KVM_PV_VERIFY: {
+		r = -EINVAL;
+		if (!kvm_s390_pv_is_protected(kvm))
+			break;
+
+		r = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
+				  UVC_CMD_VERIFY_IMG, &cmd->rc, &cmd->rrc);
+		KVM_UV_EVENT(kvm, 3, "PROTVIRT VERIFY: rc %x rrc %x", cmd->rc,
+			     cmd->rrc);
+		break;
+	}
+	default:
+		r = -ENOTTY;
+	}
+	return r;
+}
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
@@ -2262,6 +2419,31 @@ long kvm_arch_vm_ioctl(struct file *filp,
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
+		if (args.flags) {
+			r = -EINVAL;
+			break;
+		}
+		mutex_lock(&kvm->lock);
+		r = kvm_s390_handle_pv(kvm, &args);
+		mutex_unlock(&kvm->lock);
+		if (copy_to_user(argp, &args, sizeof(args))) {
+			r = -EFAULT;
+			break;
+		}
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
@@ -2525,6 +2707,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
+	u16 rc, rrc;
+
 	VCPU_EVENT(vcpu, 3, "%s", "free cpu");
 	trace_kvm_s390_destroy_vcpu(vcpu->vcpu_id);
 	kvm_s390_clear_local_irqs(vcpu);
@@ -2537,6 +2721,9 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 	if (vcpu->kvm->arch.use_cmma)
 		kvm_s390_vcpu_unsetup_cmma(vcpu);
+	/* We can not hold the vcpu mutex here, we are already dying */
+	if (kvm_s390_pv_cpu_get_handle(vcpu))
+		kvm_s390_pv_destroy_cpu(vcpu, &rc, &rrc);
 	free_page((unsigned long)(vcpu->arch.sie_block));
 }
 
@@ -2558,10 +2745,20 @@ static void kvm_free_vcpus(struct kvm *kvm)
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
+	u16 rc, rrc;
+
 	kvm_free_vcpus(kvm);
 	sca_dispose(kvm);
-	debug_unregister(kvm->arch.dbf);
 	kvm_s390_gisa_destroy(kvm);
+	/*
+	 * We are already at the end of life and kvm->lock is not taken.
+	 * This is ok as the file descriptor is closed by now and nobody
+	 * can mess with the pv state. To avoid lockdep_assert_held from
+	 * complaining we do not use kvm_s390_pv_is_protected.
+	 */
+	if (kvm_s390_pv_get_handle(kvm))
+		kvm_s390_pv_deinit_vm(kvm, &rc, &rrc);
+	debug_unregister(kvm->arch.dbf);
 	free_page((unsigned long)kvm->arch.sie_page2);
 	if (!kvm_is_ucontrol(kvm))
 		gmap_remove(kvm->arch.gmap);
@@ -2657,6 +2854,9 @@ static int sca_switch_to_extended(struct kvm *kvm)
 	unsigned int vcpu_idx;
 	u32 scaol, scaoh;
 
+	if (kvm->arch.use_esca)
+		return 0;
+
 	new_sca = alloc_pages_exact(sizeof(*new_sca), GFP_KERNEL|__GFP_ZERO);
 	if (!new_sca)
 		return -ENOMEM;
@@ -2908,6 +3108,7 @@ static void kvm_s390_vcpu_setup_model(struct kvm_vcpu *vcpu)
 static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
 {
 	int rc = 0;
+	u16 uvrc, uvrrc;
 
 	atomic_set(&vcpu->arch.sie_block->cpuflags, CPUSTAT_ZARCH |
 						    CPUSTAT_SM |
@@ -2975,6 +3176,14 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
 
 	kvm_s390_vcpu_crypto_setup(vcpu);
 
+	mutex_lock(&vcpu->kvm->lock);
+	if (kvm_s390_pv_is_protected(vcpu->kvm)) {
+		rc = kvm_s390_pv_create_cpu(vcpu, &uvrc, &uvrrc);
+		if (rc)
+			kvm_s390_vcpu_unsetup_cmma(vcpu);
+	}
+	mutex_unlock(&vcpu->kvm->lock);
+
 	return rc;
 }
 
@@ -4540,6 +4749,9 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	if (mem->guest_phys_addr + mem->memory_size > kvm->arch.mem_limit)
 		return -EINVAL;
 
+	/* When we are protected, we should not change the memory slots */
+	if (kvm_s390_pv_get_handle(kvm))
+		return -EINVAL;
 	return 0;
 }
 
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index be55b4b99bd3..13e6986596ed 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -15,6 +15,7 @@
 #include <linux/hrtimer.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
+#include <linux/lockdep.h>
 #include <asm/facility.h>
 #include <asm/processor.h>
 #include <asm/sclp.h>
@@ -207,6 +208,38 @@ static inline int kvm_s390_user_cpu_state_ctrl(struct kvm *kvm)
 	return kvm->arch.user_cpu_state_ctrl != 0;
 }
 
+/* implemented in pv.c */
+int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
+int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
+int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc);
+int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc);
+int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, u16 *rc,
+			      u16 *rrc);
+int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
+		       unsigned long tweak, u16 *rc, u16 *rrc);
+
+static inline u64 kvm_s390_pv_get_handle(struct kvm *kvm)
+{
+	return kvm->arch.pv.handle;
+}
+
+static inline u64 kvm_s390_pv_cpu_get_handle(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.pv.handle;
+}
+
+static inline bool kvm_s390_pv_is_protected(struct kvm *kvm)
+{
+	lockdep_assert_held(&kvm->lock);
+	return !!kvm_s390_pv_get_handle(kvm);
+}
+
+static inline bool kvm_s390_pv_cpu_is_protected(struct kvm_vcpu *vcpu)
+{
+	lockdep_assert_held(&vcpu->mutex);
+	return !!kvm_s390_pv_cpu_get_handle(vcpu);
+}
+
 /* implemented in interrupt.c */
 int kvm_s390_handle_wait(struct kvm_vcpu *vcpu);
 void kvm_s390_vcpu_wakeup(struct kvm_vcpu *vcpu);
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
new file mode 100644
index 000000000000..e9e020475f4a
--- /dev/null
+++ b/arch/s390/kvm/pv.c
@@ -0,0 +1,266 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Hosting Protected Virtual Machines
+ *
+ * Copyright IBM Corp. 2019, 2020
+ *    Author(s): Janosch Frank <frankja@linux.ibm.com>
+ */
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <linux/pagemap.h>
+#include <linux/sched/signal.h>
+#include <asm/pgalloc.h>
+#include <asm/gmap.h>
+#include <asm/uv.h>
+#include <asm/mman.h>
+#include "kvm-s390.h"
+
+int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
+{
+	int cc = 0;
+
+	if (kvm_s390_pv_cpu_get_handle(vcpu)) {
+		cc = uv_cmd_nodata(kvm_s390_pv_cpu_get_handle(vcpu),
+				   UVC_CMD_DESTROY_SEC_CPU, rc, rrc);
+
+		KVM_UV_EVENT(vcpu->kvm, 3,
+			     "PROTVIRT DESTROY VCPU %d: rc %x rrc %x",
+			     vcpu->vcpu_id, *rc, *rrc);
+		WARN_ONCE(cc, "protvirt destroy cpu failed rc %x rrc %x",
+			  *rc, *rrc);
+	}
+	/* Intended memory leak for something that should never happen. */
+	if (!cc)
+		free_pages(vcpu->arch.pv.stor_base,
+			   get_order(uv_info.guest_cpu_stor_len));
+	vcpu->arch.sie_block->pv_handle_cpu = 0;
+	vcpu->arch.sie_block->pv_handle_config = 0;
+	memset(&vcpu->arch.pv, 0, sizeof(vcpu->arch.pv));
+	vcpu->arch.sie_block->sdf = 0;
+	kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
+
+	return cc ? EIO : 0;
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
+	if (kvm_s390_pv_cpu_get_handle(vcpu))
+		return -EINVAL;
+
+	vcpu->arch.pv.stor_base = __get_free_pages(GFP_KERNEL,
+						   get_order(uv_info.guest_cpu_stor_len));
+	if (!vcpu->arch.pv.stor_base)
+		return -ENOMEM;
+
+	/* Input */
+	uvcb.guest_handle = kvm_s390_pv_get_handle(vcpu->kvm);
+	uvcb.num = vcpu->arch.sie_block->icpua;
+	uvcb.state_origin = (u64)vcpu->arch.sie_block;
+	uvcb.stor_origin = (u64)vcpu->arch.pv.stor_base;
+
+	cc = uv_call(0, (u64)&uvcb);
+	*rc = uvcb.header.rc;
+	*rrc = uvcb.header.rrc;
+	KVM_UV_EVENT(vcpu->kvm, 3,
+		     "PROTVIRT CREATE VCPU: cpu %d handle %llx rc %x rrc %x",
+		     vcpu->vcpu_id, uvcb.cpu_handle, uvcb.header.rc,
+		     uvcb.header.rrc);
+
+	if (cc) {
+		u16 dummy;
+
+		kvm_s390_pv_destroy_cpu(vcpu, &dummy, &dummy);
+		return -EIO;
+	}
+
+	/* Output */
+	vcpu->arch.pv.handle = uvcb.cpu_handle;
+	vcpu->arch.sie_block->pv_handle_cpu = uvcb.cpu_handle;
+	vcpu->arch.sie_block->pv_handle_config = kvm_s390_pv_get_handle(vcpu->kvm);
+	vcpu->arch.sie_block->sdf = 2;
+	kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
+	return 0;
+}
+
+/* only free resources when the destroy was successful */
+static void kvm_s390_pv_dealloc_vm(struct kvm *kvm)
+{
+	vfree(kvm->arch.pv.stor_var);
+	free_pages(kvm->arch.pv.stor_base,
+		   get_order(uv_info.guest_base_stor_len));
+	memset(&kvm->arch.pv, 0, sizeof(kvm->arch.pv));
+}
+
+static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
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
+/* this should not fail, but if it does, we must not free the donated memory */
+int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
+{
+	int cc;
+
+	cc = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
+			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
+	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
+	atomic_set(&kvm->mm->context.is_protected, 0);
+	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
+	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
+	/* Inteded memory leak on "impossible" error */
+	if (!cc)
+		kvm_s390_pv_dealloc_vm(kvm);
+	return cc ? -EIO : 0;
+}
+
+int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
+{
+	struct uv_cb_cgc uvcb = {
+		.header.cmd = UVC_CMD_CREATE_SEC_CONF,
+		.header.len = sizeof(uvcb)
+	};
+	int cc, ret;
+	u16 dummy;
+
+	ret = kvm_s390_pv_alloc_vm(kvm);
+	if (ret)
+		return ret;
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
+	if (cc) {
+		if (uvcb.header.rc & UVC_RC_NEED_DESTROY)
+			kvm_s390_pv_deinit_vm(kvm, &dummy, &dummy);
+		else
+			kvm_s390_pv_dealloc_vm(kvm);
+		return -EIO;
+	}
+	kvm->arch.gmap->guest_handle = uvcb.guest_handle;
+	atomic_set(&kvm->mm->context.is_protected, 1);
+	return 0;
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
+		.guest_handle = kvm_s390_pv_get_handle(kvm),
+	};
+	int cc = uv_call(0, (u64)&uvcb);
+
+	*rc = uvcb.header.rc;
+	*rrc = uvcb.header.rrc;
+	KVM_UV_EVENT(kvm, 3, "PROTVIRT VM SET PARMS: rc %x rrc %x",
+		     *rc, *rrc);
+	return cc ? -EINVAL : 0;
+}
+
+static int unpack_one(struct kvm *kvm, unsigned long addr, u64 tweak,
+		      u64 offset, u16 *rc, u16 *rrc)
+{
+	struct uv_cb_unp uvcb = {
+		.header.cmd = UVC_CMD_UNPACK_IMG,
+		.header.len = sizeof(uvcb),
+		.guest_handle = kvm_s390_pv_get_handle(kvm),
+		.gaddr = addr,
+		.tweak[0] = tweak,
+		.tweak[1] = offset,
+	};
+	int ret = gmap_make_secure(kvm->arch.gmap, addr, &uvcb);
+
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
+	u64 offset = 0;
+	int ret = 0;
+
+	if (addr & ~PAGE_MASK || !size || size & ~PAGE_MASK)
+		return -EINVAL;
+
+	KVM_UV_EVENT(kvm, 3, "PROTVIRT VM UNPACK: start addr %lx size %lx",
+		     addr, size);
+
+	while (offset < size) {
+		ret = unpack_one(kvm, addr, tweak, offset, rc, rrc);
+		if (ret == -EAGAIN) {
+			cond_resched();
+			if (fatal_signal_pending(current))
+				break;
+			continue;
+		}
+		if (ret)
+			break;
+		addr += PAGE_SIZE;
+		offset += PAGE_SIZE;
+	}
+	if (!ret)
+		KVM_UV_EVENT(kvm, 3, "%s", "PROTVIRT VM UNPACK: successful");
+	return ret;
+}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 4b95f9a31a2f..ad69817f7792 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1478,6 +1478,37 @@ struct kvm_enc_region {
 #define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
 #define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
 
+struct kvm_s390_pv_sec_parm {
+	__u64 origin;
+	__u64 length;
+};
+
+struct kvm_s390_pv_unp {
+	__u64 addr;
+	__u64 size;
+	__u64 tweak;
+};
+
+enum pv_cmd_id {
+	KVM_PV_ENABLE,
+	KVM_PV_DISABLE,
+	KVM_PV_SET_SEC_PARMS,
+	KVM_PV_UNPACK,
+	KVM_PV_VERIFY,
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
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.24.1

