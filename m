Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7933F526A2F
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 21:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377798AbiEMTRm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 15:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383600AbiEMTRb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 15:17:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFDC39168;
        Fri, 13 May 2022 12:16:50 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24DGoIqY004323;
        Fri, 13 May 2022 19:16:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=2FfPojlGWj5RmYwkzCEdIiLokkFExWV98aJUGNPqav0=;
 b=Gj0qMQqoCJ8CsGq49ZuyQK0AJsnCZGdpSNJM2Bv7rv+4kF3/76XKq9qG6D7TjqppTnmL
 +fW8pohZ6vaPYS3uwIir4wMAaM7tgCjSYdneQB4nl1m2OYuQCN9HXCgPXb3AzA6FgKJR
 FocUH1M6XzDznCeOAaKqeF6rAj1sHuaBOFVWp5DbGG4v/mNIM85L8aElKDy9IvvM25Rf
 2MO1craKbz2/2nIWSPeIiWWZ4or5KNvx4B05aEcyGHG5AkHDi32KSleNzSMpbnsKypVj
 YGN8NXKSVYLbVCI4+v3gGdxI3OwOXQHDT2HVg0t8aWgdY5ULpv/fV/Hd5odMSLbeRhZz jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1u71ajse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 19:16:48 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24DIoM3A008651;
        Fri, 13 May 2022 19:16:47 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1u71ajs0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 19:16:47 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24DJDTlf007648;
        Fri, 13 May 2022 19:16:46 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02wdc.us.ibm.com with ESMTP id 3fwgdacetu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 19:16:46 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24DJGj1m33161484
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 May 2022 19:16:45 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87A71124054;
        Fri, 13 May 2022 19:16:45 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80AA2124053;
        Fri, 13 May 2022 19:16:40 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.49.28])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 13 May 2022 19:16:40 +0000 (GMT)
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
Subject: [PATCH v7 16/22] KVM: s390: pci: add routines to start/stop interpretive execution
Date:   Fri, 13 May 2022 15:15:03 -0400
Message-Id: <20220513191509.272897-17-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220513191509.272897-1-mjrosato@linux.ibm.com>
References: <20220513191509.272897-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CGvD6EX0rL0Nc8iBMYnCGKjXPnjtEhBw
X-Proofpoint-GUID: 4vRJcTASjfQK7oc5t3MtYuwMHqLYKqIl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_11,2022-05-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 phishscore=0 suspectscore=0 clxscore=1015 impostorscore=0 mlxlogscore=989
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205130076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These routines will be invoked at the time an s390x vfio-pci device is
associated with a KVM (or when the association is removed), allowing
the zPCI device to enable or disable load/store intepretation mode;
this requires the host zPCI device to inform firmware of the unique
token (GISA designation) that is associated with the owning KVM.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  21 ++++
 arch/s390/include/asm/pci.h      |   1 +
 arch/s390/kvm/kvm-s390.c         |  15 +++
 arch/s390/kvm/pci.c              | 162 +++++++++++++++++++++++++++++++
 arch/s390/kvm/pci.h              |   5 +
 arch/s390/pci/pci.c              |   4 +
 6 files changed, 208 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 8e381603b6a7..2bf931d290b5 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -19,6 +19,7 @@
 #include <linux/kvm.h>
 #include <linux/seqlock.h>
 #include <linux/module.h>
+#include <linux/pci.h>
 #include <asm/debug.h>
 #include <asm/cpu.h>
 #include <asm/fpu/api.h>
@@ -967,6 +968,8 @@ struct kvm_arch{
 	DECLARE_BITMAP(idle_mask, KVM_MAX_VCPUS);
 	struct kvm_s390_gisa_interrupt gisa_int;
 	struct kvm_s390_pv pv;
+	struct list_head kzdev_list;
+	spinlock_t kzdev_list_lock;
 };
 
 #define KVM_HVA_ERR_BAD		(-1UL)
@@ -1017,4 +1020,22 @@ static inline void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 
+#define __KVM_HAVE_ARCH_VM_FREE
+void kvm_arch_free_vm(struct kvm *kvm);
+
+#ifdef CONFIG_VFIO_PCI_ZDEV_KVM
+int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm);
+int kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev);
+#else
+static inline int kvm_s390_pci_register_kvm(struct zpci_dev *dev,
+					    struct kvm *kvm)
+{
+	return -EPERM;
+}
+static inline int kvm_s390_pci_unregister_kvm(struct zpci_dev *dev)
+{
+	return -EPERM;
+}
+#endif
+
 #endif
diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index 322060a75d9f..85eb0ef9d4c3 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -194,6 +194,7 @@ struct zpci_dev {
 	/* IOMMU and passthrough */
 	struct s390_domain *s390_domain; /* s390 IOMMU domain data */
 	struct kvm_zdev *kzdev;
+	struct mutex kzdev_lock;
 };
 
 static inline bool zdev_enabled(struct zpci_dev *zdev)
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 0797661732cc..b95b25490018 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2794,6 +2794,14 @@ static void sca_dispose(struct kvm *kvm)
 	kvm->arch.sca = NULL;
 }
 
+void kvm_arch_free_vm(struct kvm *kvm)
+{
+	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM))
+		kvm_s390_pci_clear_list(kvm);
+
+	__kvm_arch_free_vm(kvm);
+}
+
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	gfp_t alloc_flags = GFP_KERNEL_ACCOUNT;
@@ -2876,6 +2884,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	kvm_s390_crypto_init(kvm);
 
+	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM)) {
+		mutex_lock(&kvm->lock);
+		kvm_s390_pci_init_list(kvm);
+		kvm_s390_vcpu_pci_enable_interp(kvm);
+		mutex_unlock(&kvm->lock);
+	}
+
 	mutex_init(&kvm->arch.float_int.ais_lock);
 	spin_lock_init(&kvm->arch.float_int.lock);
 	for (i = 0; i < FIRQ_LIST_COUNT; i++)
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index 5a9bc954e677..1393a1604494 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -12,7 +12,9 @@
 #include <asm/pci.h>
 #include <asm/pci_insn.h>
 #include <asm/pci_io.h>
+#include <asm/sclp.h>
 #include "pci.h"
+#include "kvm-s390.h"
 
 struct zpci_aift *aift;
 
@@ -423,6 +425,166 @@ static void kvm_s390_pci_dev_release(struct zpci_dev *zdev)
 	kfree(kzdev);
 }
 
+
+/*
+ * Register device with the specified KVM. If interpetation facilities are
+ * available, enable them and let userspace indicate whether or not they will
+ * be used (specify SHM bit to disable).
+ */
+int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm)
+{
+	int rc;
+
+	if (!zdev)
+		return -EINVAL;
+
+	mutex_lock(&zdev->kzdev_lock);
+
+	if (zdev->kzdev || zdev->gisa != 0) {
+		mutex_unlock(&zdev->kzdev_lock);
+		return -EINVAL;
+	}
+
+	mutex_lock(&kvm->lock);
+
+	rc = kvm_s390_pci_dev_open(zdev);
+	if (rc)
+		goto err;
+
+	/*
+	 * If interpretation facilities aren't available, add the device to
+	 * the kzdev list but don't enable for interpretation.
+	 */
+	if (!kvm_s390_pci_interp_allowed())
+		goto out;
+
+	/*
+	 * If this is the first request to use an interpreted device, make the
+	 * necessary vcpu changes
+	 */
+	if (!kvm->arch.use_zpci_interp)
+		kvm_s390_vcpu_pci_enable_interp(kvm);
+
+	if (zdev_enabled(zdev)) {
+		rc = zpci_disable_device(zdev);
+		if (rc)
+			goto err;
+	}
+
+	/*
+	 * Store information about the identity of the kvm guest allowed to
+	 * access this device via interpretation to be used by host CLP
+	 */
+	zdev->gisa = (u32)virt_to_phys(&kvm->arch.sie_page2->gisa);
+
+	rc = zpci_enable_device(zdev);
+	if (rc)
+		goto clear_gisa;
+
+	/* Re-register the IOMMU that was already created */
+	rc = zpci_register_ioat(zdev, 0, zdev->start_dma, zdev->end_dma,
+				virt_to_phys(zdev->dma_table));
+	if (rc)
+		goto clear_gisa;
+
+out:
+	zdev->kzdev->kvm = kvm;
+
+	spin_lock(&kvm->arch.kzdev_list_lock);
+	list_add_tail(&zdev->kzdev->entry, &kvm->arch.kzdev_list);
+	spin_unlock(&kvm->arch.kzdev_list_lock);
+
+	mutex_unlock(&kvm->lock);
+	mutex_unlock(&zdev->kzdev_lock);
+	return 0;
+
+clear_gisa:
+	zdev->gisa = 0;
+err:
+	if (zdev->kzdev)
+		kvm_s390_pci_dev_release(zdev);
+	mutex_unlock(&kvm->lock);
+	mutex_unlock(&zdev->kzdev_lock);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pci_register_kvm);
+
+int kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev)
+{
+	struct kvm *kvm;
+	int rc;
+
+	if (!zdev)
+		return -EINVAL;
+
+	mutex_lock(&zdev->kzdev_lock);
+
+	if (!zdev->kzdev) {
+		mutex_unlock(&zdev->kzdev_lock);
+		return -EINVAL;
+	}
+
+	kvm = zdev->kzdev->kvm;
+	mutex_lock(&kvm->lock);
+
+	/*
+	 * A 0 gisa means interpretation was never enabled, just remove the
+	 * device from the list.
+	 */
+	if (zdev->gisa == 0)
+		goto out;
+
+	/* Forwarding must be turned off before interpretation */
+	if (zdev->kzdev->fib.fmt0.aibv != 0)
+		kvm_s390_pci_aif_disable(zdev, true);
+
+	/* Remove the host CLP guest designation */
+	zdev->gisa = 0;
+
+	if (zdev_enabled(zdev)) {
+		rc = zpci_disable_device(zdev);
+		if (rc)
+			goto out;
+	}
+
+	rc = zpci_enable_device(zdev);
+	if (rc)
+		goto out;
+
+	/* Re-register the IOMMU that was already created */
+	rc = zpci_register_ioat(zdev, 0, zdev->start_dma, zdev->end_dma,
+				virt_to_phys(zdev->dma_table));
+
+out:
+	spin_lock(&kvm->arch.kzdev_list_lock);
+	list_del(&zdev->kzdev->entry);
+	spin_unlock(&kvm->arch.kzdev_list_lock);
+	kvm_s390_pci_dev_release(zdev);
+
+	mutex_unlock(&kvm->lock);
+	mutex_unlock(&zdev->kzdev_lock);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pci_unregister_kvm);
+
+void kvm_s390_pci_init_list(struct kvm *kvm)
+{
+	spin_lock_init(&kvm->arch.kzdev_list_lock);
+	INIT_LIST_HEAD(&kvm->arch.kzdev_list);
+}
+
+void kvm_s390_pci_clear_list(struct kvm *kvm)
+{
+	/*
+	 * This list should already be empty, either via vfio device closures
+	 * or kvm fd cleanup.
+	 */
+	spin_lock(&kvm->arch.kzdev_list_lock);
+	WARN_ON_ONCE(!list_empty(&kvm->arch.kzdev_list));
+	spin_unlock(&kvm->arch.kzdev_list_lock);
+}
+
 int kvm_s390_pci_init(void)
 {
 	aift = kzalloc(sizeof(struct zpci_aift), GFP_KERNEL);
diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
index 9d091033fc02..fb2b91b76e0c 100644
--- a/arch/s390/kvm/pci.h
+++ b/arch/s390/kvm/pci.h
@@ -13,6 +13,7 @@
 #include <linux/kvm_host.h>
 #include <linux/pci.h>
 #include <linux/mutex.h>
+#include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <asm/airq.h>
 #include <asm/cpu.h>
@@ -21,6 +22,7 @@ struct kvm_zdev {
 	struct zpci_dev *zdev;
 	struct kvm *kvm;
 	struct zpci_fib fib;
+	struct list_head entry;
 };
 
 struct zpci_gaite {
@@ -54,6 +56,9 @@ static inline struct kvm *kvm_s390_pci_si_to_kvm(struct zpci_aift *aift,
 int kvm_s390_pci_aen_init(u8 nisc);
 void kvm_s390_pci_aen_exit(void);
 
+void kvm_s390_pci_init_list(struct kvm *kvm);
+void kvm_s390_pci_clear_list(struct kvm *kvm);
+
 int kvm_s390_pci_init(void);
 void kvm_s390_pci_exit(void);
 
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index f0a439c43395..c0a20c418513 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -132,6 +132,7 @@ int zpci_register_ioat(struct zpci_dev *zdev, u8 dmaas,
 		zpci_dbg(3, "reg ioat fid:%x, cc:%d, status:%d\n", zdev->fid, cc, status);
 	return cc;
 }
+EXPORT_SYMBOL_GPL(zpci_register_ioat);
 
 /* Modify PCI: Unregister I/O address translation parameters */
 int zpci_unregister_ioat(struct zpci_dev *zdev, u8 dmaas)
@@ -712,6 +713,7 @@ int zpci_enable_device(struct zpci_dev *zdev)
 		zpci_update_fh(zdev, fh);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(zpci_enable_device);
 
 int zpci_disable_device(struct zpci_dev *zdev)
 {
@@ -735,6 +737,7 @@ int zpci_disable_device(struct zpci_dev *zdev)
 	}
 	return rc;
 }
+EXPORT_SYMBOL_GPL(zpci_disable_device);
 
 /**
  * zpci_hot_reset_device - perform a reset of the given zPCI function
@@ -828,6 +831,7 @@ struct zpci_dev *zpci_create_device(u32 fid, u32 fh, enum zpci_state state)
 
 	kref_init(&zdev->kref);
 	mutex_init(&zdev->lock);
+	mutex_init(&zdev->kzdev_lock);
 
 	rc = zpci_init_iommu(zdev);
 	if (rc)
-- 
2.27.0

