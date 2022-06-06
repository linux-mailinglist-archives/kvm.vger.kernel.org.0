Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C40253EFF7
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 22:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234211AbiFFUip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 16:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234063AbiFFUia (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 16:38:30 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ECCAEBAA8;
        Mon,  6 Jun 2022 13:35:46 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256KUs5p038410;
        Mon, 6 Jun 2022 20:35:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=9PY6pODLk+W5f2RN9XkDtgU+3F3fCvDB31bmzhefeK4=;
 b=VdgDd6aXgCRBlBedF5vY3Cy2Gvgp3ssoiykoIqIs2XiACOk3unP7uarWyAg8J7bI7wxT
 6flZGa6eTZGqgsIBUvl+0bStEdh252j0W4WhdjcKUOLMidWQrLKCHyi2+SS1mR6cJiVR
 i3StXx9na16Ut8Sf0/idLcTE9I4ynQbSRhh3AhIwltJPAKB/39xLPH3q6U0der7FB0gC
 oSdOZleoEFntgXcp9XHgn6Bca5+nB/D5x0wKf9/zBQaF9om+tz3LXZcGNE8oYEMKtZKH
 4IvZMy0Vl7UxS7WCdS3B7VPPgQ9o4rTQSm/flXpOAOdCj9vJnkzytQY3wB5TdEtvPoeA Ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ghqs6145a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:35:43 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 256KUwXt038795;
        Mon, 6 Jun 2022 20:35:42 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ghqs61454-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:35:42 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 256KL04a016487;
        Mon, 6 Jun 2022 20:35:41 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04dal.us.ibm.com with ESMTP id 3gfy19uthf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:35:41 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 256KZeO227132322
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Jun 2022 20:35:40 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE13F28058;
        Mon,  6 Jun 2022 20:35:40 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED98728059;
        Mon,  6 Jun 2022 20:35:35 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.163.20.188])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  6 Jun 2022 20:35:35 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        jgg@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v9 20/21] KVM: s390: add KVM_S390_ZPCI_OP to manage guest zPCI devices
Date:   Mon,  6 Jun 2022 16:33:24 -0400
Message-Id: <20220606203325.110625-21-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220606203325.110625-1-mjrosato@linux.ibm.com>
References: <20220606203325.110625-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KFvHIeN5lomen70XaKKt8WYtn2T6nVuO
X-Proofpoint-GUID: xCymYlRIgN4_3DZpwj_TSaVHCSlkjkfJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-06_06,2022-06-03_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=892 impostorscore=0
 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM_S390_ZPCI_OP ioctl provides a mechanism for managing
hardware-assisted virtualization features for s390x zPCI passthrough.
Add the first 2 operations, which can be used to enable/disable
the specified device for Adapter Event Notification interpretation.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst | 47 +++++++++++++++++++
 arch/s390/kvm/kvm-s390.c       | 16 +++++++
 arch/s390/kvm/pci.c            | 85 ++++++++++++++++++++++++++++++++++
 arch/s390/kvm/pci.h            |  2 +
 include/uapi/linux/kvm.h       | 31 +++++++++++++
 5 files changed, 181 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 11e00a46c610..2eb604769dce 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5802,6 +5802,53 @@ of CPUID leaf 0xD on the host.
 
 This ioctl injects an event channel interrupt directly to the guest vCPU.
 
+4.136 KVM_S390_ZPCI_OP
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
index 5088bd9f1922..52cc12d53022 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1157,6 +1157,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_TSC_CONTROL 214
 #define KVM_CAP_SYSTEM_EVENT_DATA 215
 #define KVM_CAP_ARM_SYSTEM_SUSPEND 216
+#define KVM_CAP_S390_ZPCI_OP 217
 
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
2.27.0

