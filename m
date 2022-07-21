Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52F6557D0FB
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 18:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbiGUQNk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 12:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232545AbiGUQNZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 12:13:25 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B86868A5;
        Thu, 21 Jul 2022 09:13:23 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LFs2YE006282;
        Thu, 21 Jul 2022 16:13:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=+/HyQVWbmTzpk7Nf0Sw9dlG0yhXMJ/EsZNwrvqbTfoQ=;
 b=ErpnksAAna4oFkhddPSPQxTkbWSr1B3MCnVfmOxtmS0xBdRZ7t9PIZTcHHI/7OhJeSj6
 yRIZQ04pnjKoo0ZwPfnpvHi8v1NZtxpuI87d1DL3zUSvHKcJorlpeabABpFfcjMEkbHB
 diCS300BS9PIFWSRkDu4cv4IqxIM29AsqFXkpbgcVgkBEhrwW1Xr1lexHvnaqqphWwMm
 wsUbvymSHdEUTssKicB2T4taVeVtM4oC+toJvLg1/55TXh1C/kRnEeLB6Q3lHv1eW4nC
 NzU83JSPIF5raHmn8K/oITFuLhRHNIOow81UR1qZ21+H/ctgxACalfTZUK7NJsiRvp/s Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9um8f95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:22 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LFs1Ma006234;
        Thu, 21 Jul 2022 16:13:21 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9um8f86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:21 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LG7X3b018697;
        Thu, 21 Jul 2022 16:13:20 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3hbmy8nexu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:19 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LGDG6724052188
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 16:13:16 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4A40A405F;
        Thu, 21 Jul 2022 16:13:16 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26E82A4054;
        Thu, 21 Jul 2022 16:13:16 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 16:13:16 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        thuth@redhat.com, david@redhat.com,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Subject: [GIT PULL 20/42] KVM: s390: add KVM_S390_ZPCI_OP to manage guest zPCI devices
Date:   Thu, 21 Jul 2022 18:12:40 +0200
Message-Id: <20220721161302.156182-21-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721161302.156182-1-imbrenda@linux.ibm.com>
References: <20220721161302.156182-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TdB2__dvWcDi9dCJQjjQgd1k4jNMwzsp
X-Proofpoint-GUID: cf2Er_I0i01bpJo6iTgPSw8Bt0X3rbjW
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_22,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxlogscore=999 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Matthew Rosato <mjrosato@linux.ibm.com>

The KVM_S390_ZPCI_OP ioctl provides a mechanism for managing
hardware-assisted virtualization features for s390x zPCI passthrough.
Add the first 2 operations, which can be used to enable/disable
the specified device for Adapter Event Notification interpretation.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Acked-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Link: https://lore.kernel.org/r/20220606203325.110625-21-mjrosato@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst | 47 +++++++++++++++++++
 arch/s390/kvm/kvm-s390.c       | 16 +++++++
 arch/s390/kvm/pci.c            | 85 ++++++++++++++++++++++++++++++++++
 arch/s390/kvm/pci.h            |  2 +
 include/uapi/linux/kvm.h       | 31 +++++++++++++
 5 files changed, 181 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 11e00a46c610..d58354e9af8f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5802,6 +5802,53 @@ of CPUID leaf 0xD on the host.
 
 This ioctl injects an event channel interrupt directly to the guest vCPU.
 
+4.137 KVM_S390_ZPCI_OP
+--------------------
+
+:Capability: KVM_CAP_S390_ZPCI_OP
+:Architectures: s390
+:Type: vm ioctl
+:Parameters: struct kvm_s390_zpci_op (in)
+:Returns: 0 on success, <0 on error
+
+Used to manage hardware-assisted virtualization features for zPCI devices.
+
+Parameters are specified via the following structure::
+
+  struct kvm_s390_zpci_op {
+	/* in */
+	__u32 fh;		/* target device */
+	__u8  op;		/* operation to perform */
+	__u8  pad[3];
+	union {
+		/* for KVM_S390_ZPCIOP_REG_AEN */
+		struct {
+			__u64 ibv;	/* Guest addr of interrupt bit vector */
+			__u64 sb;	/* Guest addr of summary bit */
+			__u32 flags;
+			__u32 noi;	/* Number of interrupts */
+			__u8 isc;	/* Guest interrupt subclass */
+			__u8 sbo;	/* Offset of guest summary bit vector */
+			__u16 pad;
+		} reg_aen;
+		__u64 reserved[8];
+	} u;
+  };
+
+The type of operation is specified in the "op" field.
+KVM_S390_ZPCIOP_REG_AEN is used to register the VM for adapter event
+notification interpretation, which will allow firmware delivery of adapter
+events directly to the vm, with KVM providing a backup delivery mechanism;
+KVM_S390_ZPCIOP_DEREG_AEN is used to subsequently disable interpretation of
+adapter event notifications.
+
+The target zPCI function must also be specified via the "fh" field.  For the
+KVM_S390_ZPCIOP_REG_AEN operation, additional information to establish firmware
+delivery must be provided via the "reg_aen" struct.
+
+The "pad" and "reserved" fields may be used for future extensions and should be
+set to 0s by userspace.
+
 5. The kvm_run structure
 ========================
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 4758bb731199..f214e0fc62ed 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -618,6 +618,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_S390_PROTECTED:
 		r = is_prot_virt_host();
 		break;
+	case KVM_CAP_S390_ZPCI_OP:
+		r = kvm_s390_pci_interp_allowed();
+		break;
 	default:
 		r = 0;
 	}
@@ -2629,6 +2632,19 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			r = -EFAULT;
 		break;
 	}
+	case KVM_S390_ZPCI_OP: {
+		struct kvm_s390_zpci_op args;
+
+		r = -EINVAL;
+		if (!IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM))
+			break;
+		if (copy_from_user(&args, argp, sizeof(args))) {
+			r = -EFAULT;
+			break;
+		}
+		r = kvm_s390_pci_zpci_op(kvm, &args);
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index 24211741deb0..4946fb7757d6 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -585,6 +585,91 @@ void kvm_s390_pci_clear_list(struct kvm *kvm)
 	spin_unlock(&kvm->arch.kzdev_list_lock);
 }
 
+static struct zpci_dev *get_zdev_from_kvm_by_fh(struct kvm *kvm, u32 fh)
+{
+	struct zpci_dev *zdev = NULL;
+	struct kvm_zdev *kzdev;
+
+	spin_lock(&kvm->arch.kzdev_list_lock);
+	list_for_each_entry(kzdev, &kvm->arch.kzdev_list, entry) {
+		if (kzdev->zdev->fh == fh) {
+			zdev = kzdev->zdev;
+			break;
+		}
+	}
+	spin_unlock(&kvm->arch.kzdev_list_lock);
+
+	return zdev;
+}
+
+static int kvm_s390_pci_zpci_reg_aen(struct zpci_dev *zdev,
+				     struct kvm_s390_zpci_op *args)
+{
+	struct zpci_fib fib = {};
+	bool hostflag;
+
+	fib.fmt0.aibv = args->u.reg_aen.ibv;
+	fib.fmt0.isc = args->u.reg_aen.isc;
+	fib.fmt0.noi = args->u.reg_aen.noi;
+	if (args->u.reg_aen.sb != 0) {
+		fib.fmt0.aisb = args->u.reg_aen.sb;
+		fib.fmt0.aisbo = args->u.reg_aen.sbo;
+		fib.fmt0.sum = 1;
+	} else {
+		fib.fmt0.aisb = 0;
+		fib.fmt0.aisbo = 0;
+		fib.fmt0.sum = 0;
+	}
+
+	hostflag = !(args->u.reg_aen.flags & KVM_S390_ZPCIOP_REGAEN_HOST);
+	return kvm_s390_pci_aif_enable(zdev, &fib, hostflag);
+}
+
+int kvm_s390_pci_zpci_op(struct kvm *kvm, struct kvm_s390_zpci_op *args)
+{
+	struct kvm_zdev *kzdev;
+	struct zpci_dev *zdev;
+	int r;
+
+	zdev = get_zdev_from_kvm_by_fh(kvm, args->fh);
+	if (!zdev)
+		return -ENODEV;
+
+	mutex_lock(&zdev->kzdev_lock);
+	mutex_lock(&kvm->lock);
+
+	kzdev = zdev->kzdev;
+	if (!kzdev) {
+		r = -ENODEV;
+		goto out;
+	}
+	if (kzdev->kvm != kvm) {
+		r = -EPERM;
+		goto out;
+	}
+
+	switch (args->op) {
+	case KVM_S390_ZPCIOP_REG_AEN:
+		/* Fail on unknown flags */
+		if (args->u.reg_aen.flags & ~KVM_S390_ZPCIOP_REGAEN_HOST) {
+			r = -EINVAL;
+			break;
+		}
+		r = kvm_s390_pci_zpci_reg_aen(zdev, args);
+		break;
+	case KVM_S390_ZPCIOP_DEREG_AEN:
+		r = kvm_s390_pci_aif_disable(zdev, false);
+		break;
+	default:
+		r = -EINVAL;
+	}
+
+out:
+	mutex_unlock(&kvm->lock);
+	mutex_unlock(&zdev->kzdev_lock);
+	return r;
+}
+
 int kvm_s390_pci_init(void)
 {
 	aift = kzalloc(sizeof(struct zpci_aift), GFP_KERNEL);
diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
index fb2b91b76e0c..0351382e990f 100644
--- a/arch/s390/kvm/pci.h
+++ b/arch/s390/kvm/pci.h
@@ -59,6 +59,8 @@ void kvm_s390_pci_aen_exit(void);
 void kvm_s390_pci_init_list(struct kvm *kvm);
 void kvm_s390_pci_clear_list(struct kvm *kvm);
 
+int kvm_s390_pci_zpci_op(struct kvm *kvm, struct kvm_s390_zpci_op *args);
+
 int kvm_s390_pci_init(void);
 void kvm_s390_pci_exit(void);
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5088bd9f1922..2f302e2287d1 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1157,6 +1157,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_TSC_CONTROL 214
 #define KVM_CAP_SYSTEM_EVENT_DATA 215
 #define KVM_CAP_ARM_SYSTEM_SUSPEND 216
+#define KVM_CAP_S390_ZPCI_OP 221
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -2118,4 +2119,34 @@ struct kvm_stats_desc {
 /* Available with KVM_CAP_XSAVE2 */
 #define KVM_GET_XSAVE2		  _IOR(KVMIO,  0xcf, struct kvm_xsave)
 
+/* Available with KVM_CAP_S390_ZPCI_OP */
+#define KVM_S390_ZPCI_OP         _IOW(KVMIO,  0xd1, struct kvm_s390_zpci_op)
+
+struct kvm_s390_zpci_op {
+	/* in */
+	__u32 fh;               /* target device */
+	__u8  op;               /* operation to perform */
+	__u8  pad[3];
+	union {
+		/* for KVM_S390_ZPCIOP_REG_AEN */
+		struct {
+			__u64 ibv;      /* Guest addr of interrupt bit vector */
+			__u64 sb;       /* Guest addr of summary bit */
+			__u32 flags;
+			__u32 noi;      /* Number of interrupts */
+			__u8 isc;       /* Guest interrupt subclass */
+			__u8 sbo;       /* Offset of guest summary bit vector */
+			__u16 pad;
+		} reg_aen;
+		__u64 reserved[8];
+	} u;
+};
+
+/* types for kvm_s390_zpci_op->op */
+#define KVM_S390_ZPCIOP_REG_AEN                0
+#define KVM_S390_ZPCIOP_DEREG_AEN      1
+
+/* flags for kvm_s390_zpci_op->u.reg_aen.flags */
+#define KVM_S390_ZPCIOP_REGAEN_HOST    (1 << 0)
+
 #endif /* __LINUX_KVM_H */
-- 
2.36.1

