Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 222D85109E8
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 22:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354693AbiDZUO1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 16:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354606AbiDZUNb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 16:13:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4069E0FD;
        Tue, 26 Apr 2022 13:10:20 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QK4GGx010864;
        Tue, 26 Apr 2022 20:10:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qM156XiOhem89vlgb5dzpsVtLVIoU1j9vXYPk+D3O7s=;
 b=hC/UszsX+cN1sJyhgzUyLxkW0pWTIQt+0gRDh121/2SHrRRypz1NLIqccsGWHIG5JWst
 J2SwuB5X/utJrdhbsYj776fmFjdH3h72U+qRap801FDwRgLgz4vnHbMEKXpnjYswZsee
 u4rUgv7zWoJWwSMe0LGUFj9rQtnvkjsWA67ZODue0ihl1QKtOZCvAogr8oL/M7X+TKd2
 +6Xn/DA6VTCEJRNNpgMZvJ+K/onAb474Uby6jYBdNMUndP0xdEGAW6takahGsrldBIbM
 gkOviqMF1tqTm7DD6zQ/D/MQbvPzLv76f/46vyInwP62UeY6Lq0kNznZza0/oSS0dEHX mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpj07yqj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 20:10:18 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23QK4RcK011900;
        Tue, 26 Apr 2022 20:10:17 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpj07yqhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 20:10:17 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23QK8P6o001222;
        Tue, 26 Apr 2022 20:10:16 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 3fm93anagq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 20:10:16 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23QKAFsc28443134
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 20:10:15 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BD54B2068;
        Tue, 26 Apr 2022 20:10:15 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30154B206A;
        Tue, 26 Apr 2022 20:10:11 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.73.42])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 26 Apr 2022 20:10:11 +0000 (GMT)
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
Subject: [PATCH v6 19/21] KVM: s390: add KVM_S390_ZPCI_OP to manage guest zPCI devices
Date:   Tue, 26 Apr 2022 16:08:40 -0400
Message-Id: <20220426200842.98655-20-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220426200842.98655-1-mjrosato@linux.ibm.com>
References: <20220426200842.98655-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: u8wSbppgWqLd7tIB7zFHOmobbndLCJKS
X-Proofpoint-ORIG-GUID: vBYst80ThbjJfsvac5lQUu_NRd2xkWcj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_06,2022-04-26_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 phishscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=969 adultscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204260127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM_S390_ZPCI_OP ioctl provides a mechanism for managing
hardware-assisted virtualization features for s390X zPCI passthrough.
Add the first 2 operations, which can be used to enable/disable
the specified device for Adapter Event Notification interpretation.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst | 45 +++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.c       | 23 ++++++++++++
 arch/s390/kvm/pci.c            | 65 ++++++++++++++++++++++++++++++++++
 arch/s390/kvm/pci.h            |  2 ++
 include/uapi/linux/kvm.h       | 31 ++++++++++++++++
 5 files changed, 166 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 85c7abc51af5..c5689df07d71 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5645,6 +5645,51 @@ enabled with ``arch_prctl()``, but this may change in the future.
 The offsets of the state save areas in struct kvm_xsave follow the contents
 of CPUID leaf 0xD on the host.
 
+4.135 KVM_S390_ZPCI_OP
+--------------------
+
+:Capability: KVM_CAP_S390_ZPCI_OP
+:Architectures: s390
+:Type: vcpu ioctl
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
+The "reserved" field is meant for future extensions.
 
 5. The kvm_run structure
 ========================
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index bd6c8aeabc24..69e435b06425 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -618,6 +618,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_S390_PROTECTED:
 		r = is_prot_virt_host();
 		break;
+	case KVM_CAP_S390_ZPCI_OP:
+		if (kvm_s390_pci_interp_allowed())
+			r = 1;
+		else
+			r = 0;
+		break;
 	default:
 		r = 0;
 	}
@@ -2623,6 +2629,23 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			r = -EFAULT;
 		break;
 	}
+	case KVM_S390_ZPCI_OP: {
+		struct kvm_s390_zpci_op args;
+
+		r = -EINVAL;
+		if (!IS_ENABLED(CONFIG_VFIO_PCI))
+			break;
+		if (copy_from_user(&args, argp, sizeof(args))) {
+			r = -EFAULT;
+			break;
+		}
+		r = kvm_s390_pci_zpci_op(kvm, &args);
+		if (r)
+			break;
+		if (copy_to_user(argp, &args, sizeof(args)))
+			r = -EFAULT;
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index 2aee7f11db1d..fdf8a0f8dcd3 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -582,6 +582,71 @@ void kvm_s390_pci_clear_list(struct kvm *kvm)
 		unregister_kvm(kzdev->zdev);
 }
 
+static struct kvm_zdev *get_kzdev_by_fh(struct kvm *kvm, u32 fh)
+{
+	struct kvm_zdev *kzdev, *retval = NULL;
+
+	spin_lock(&kvm->arch.kzdev_list_lock);
+	list_for_each_entry(kzdev, &kvm->arch.kzdev_list, entry) {
+		if (kzdev->zdev->fh == fh) {
+			retval = kzdev;
+			break;
+		}
+	}
+	spin_unlock(&kvm->arch.kzdev_list_lock);
+
+	return retval;
+}
+
+static int kvm_s390_pci_zpci_reg_aen(struct zpci_dev *zdev,
+				     struct kvm_s390_zpci_op *args)
+{
+	struct zpci_fib fib = {};
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
+	if (args->u.reg_aen.flags & KVM_S390_ZPCIOP_REGAEN_HOST)
+		return kvm_s390_pci_aif_enable(zdev, &fib, true);
+	else
+		return kvm_s390_pci_aif_enable(zdev, &fib, false);
+}
+
+int kvm_s390_pci_zpci_op(struct kvm *kvm, struct kvm_s390_zpci_op *args)
+{
+	struct kvm_zdev *kzdev;
+	struct zpci_dev *zdev;
+	int r;
+
+	kzdev = get_kzdev_by_fh(kvm, args->fh);
+	if (!kzdev)
+		return -ENODEV;
+	zdev = kzdev->zdev;
+
+	switch (args->op) {
+	case KVM_S390_ZPCIOP_REG_AEN:
+		r = kvm_s390_pci_zpci_reg_aen(zdev, args);
+		break;
+	case KVM_S390_ZPCIOP_DEREG_AEN:
+		r = kvm_s390_pci_aif_disable(zdev, false);
+		break;
+	default:
+		r = -EINVAL;
+	}
+
+	return r;
+}
+
 int kvm_s390_pci_init(void)
 {
 	aift = kzalloc(sizeof(struct zpci_aift), GFP_KERNEL);
diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
index d11662fadb78..f099c790a15a 100644
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
index 91a6fe4e02c0..014adb30d42c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1144,6 +1144,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_MEM_OP_EXTENSION 211
 #define KVM_CAP_PMU_CAPABILITY 212
 #define KVM_CAP_DISABLE_QUIRKS2 213
+#define KVM_CAP_S390_ZPCI_OP 214
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -2060,4 +2061,34 @@ struct kvm_stats_desc {
 /* Available with KVM_CAP_XSAVE2 */
 #define KVM_GET_XSAVE2		  _IOR(KVMIO,  0xcf, struct kvm_xsave)
 
+/* Available with KVM_CAP_S390_ZPCI_OP */
+#define KVM_S390_ZPCI_OP	  _IOW(KVMIO,  0xd0, struct kvm_s390_zpci_op)
+
+struct kvm_s390_zpci_op {
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
+};
+
+/* types for kvm_s390_zpci_op->op */
+#define KVM_S390_ZPCIOP_REG_AEN		0
+#define KVM_S390_ZPCIOP_DEREG_AEN	1
+
+/* flags for kvm_s390_zpci_op->u.reg_aen.flags */
+#define KVM_S390_ZPCIOP_REGAEN_HOST	(1 << 0)
+
 #endif /* __LINUX_KVM_H */
-- 
2.27.0

