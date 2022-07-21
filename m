Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B5257D0F2
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 18:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbiGUQNa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 12:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbiGUQNW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 12:13:22 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB3486892;
        Thu, 21 Jul 2022 09:13:20 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LFiFTG010772;
        Thu, 21 Jul 2022 16:13:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=gUfBBWvMDKHDlFJCcnHgIEf1u7YZKu0I4ae72L1nzzQ=;
 b=OeDuvKUi4+ktzEeawwkT285TVSrNKFBWgp+cDe7xf938XLP+YSwGpNnnAbWKx8g8ZWdR
 /mbf93kCzLJShwzW6EgHcPWE0HKXX9QgZPWvxKGmc1VrAMc1VG143uek6pZ4uzXnnbpP
 xExUUkbmFLJQiDY7IxYnLuKZ5KvwcrGgI+CrXiK64YcPh/ec/IvDL+oyNHno7B6j9R94
 sxJ5EOUAl/t7Fz+kLQ8NGPB7TRciJ/U/HIkQt+Vf86Bk2G32B4Q3g7/jzcekz7Zbep9v
 rC87FblKp1KqTBlaprf8DyUZAWachTMUBA+UejEwoIXTC/5qfDkq9yNdCIYOMBgVsOM1 Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9pu0uxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:19 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LFiPjq011041;
        Thu, 21 Jul 2022 16:13:19 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9pu0uwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:19 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LG6rfg017840;
        Thu, 21 Jul 2022 16:13:17 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3hbmy8y56q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:16 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LGDEsh11665798
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 16:13:14 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12204A4060;
        Thu, 21 Jul 2022 16:13:14 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E289A4054;
        Thu, 21 Jul 2022 16:13:13 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 16:13:13 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        thuth@redhat.com, david@redhat.com,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Subject: [GIT PULL 16/42] KVM: s390: pci: add routines to start/stop interpretive execution
Date:   Thu, 21 Jul 2022 18:12:36 +0200
Message-Id: <20220721161302.156182-17-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721161302.156182-1-imbrenda@linux.ibm.com>
References: <20220721161302.156182-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 30fCRukZk8He1apEmvS8ihHy1Je8gWa7
X-Proofpoint-GUID: cVs2Na6bBvuYoh1RG7tEDinU-nT_Uo9z
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_22,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 adultscore=0 malwarescore=0 priorityscore=1501 suspectscore=0 phishscore=0
 mlxlogscore=999 impostorscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207210064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Matthew Rosato <mjrosato@linux.ibm.com>

These routines will be invoked at the time an s390x vfio-pci device is
associated with a KVM (or when the association is removed), allowing
the zPCI device to enable or disable load/store intepretation mode;
this requires the host zPCI device to inform firmware of the unique
token (GISA designation) that is associated with the owning KVM.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Acked-by: Pierre Morel <pmorel@linux.ibm.com>
Link: https://lore.kernel.org/r/20220606203325.110625-17-mjrosato@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  18 ++++
 arch/s390/include/asm/pci.h      |   1 +
 arch/s390/kvm/kvm-s390.c         |  15 +++
 arch/s390/kvm/pci.c              | 162 +++++++++++++++++++++++++++++++
 arch/s390/kvm/pci.h              |   5 +
 arch/s390/pci/pci.c              |   4 +
 6 files changed, 205 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 8e381603b6a7..6e83d746bae2 100644
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
@@ -1017,4 +1020,19 @@ static inline void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 
+#define __KVM_HAVE_ARCH_VM_FREE
+void kvm_arch_free_vm(struct kvm *kvm);
+
+#ifdef CONFIG_VFIO_PCI_ZDEV_KVM
+int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm);
+void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev);
+#else
+static inline int kvm_s390_pci_register_kvm(struct zpci_dev *dev,
+					    struct kvm *kvm)
+{
+	return -EPERM;
+}
+static inline void kvm_s390_pci_unregister_kvm(struct zpci_dev *dev) {}
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
index a66da3f66114..4758bb731199 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2790,6 +2790,14 @@ static void sca_dispose(struct kvm *kvm)
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
@@ -2872,6 +2880,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
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
index b232c8cbaa81..24211741deb0 100644
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
+	if (zdev->kzdev || zdev->gisa != 0 || !kvm) {
+		mutex_unlock(&zdev->kzdev_lock);
+		return -EINVAL;
+	}
+
+	kvm_get_kvm(kvm);
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
+	kvm_put_kvm(kvm);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pci_register_kvm);
+
+void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev)
+{
+	struct kvm *kvm;
+
+	if (!zdev)
+		return;
+
+	mutex_lock(&zdev->kzdev_lock);
+
+	if (WARN_ON(!zdev->kzdev)) {
+		mutex_unlock(&zdev->kzdev_lock);
+		return;
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
+		if (zpci_disable_device(zdev))
+			goto out;
+	}
+
+	if (zpci_enable_device(zdev))
+		goto out;
+
+	/* Re-register the IOMMU that was already created */
+	zpci_register_ioat(zdev, 0, zdev->start_dma, zdev->end_dma,
+			   virt_to_phys(zdev->dma_table));
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
+	kvm_put_kvm(kvm);
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
index 86cd4d8446b1..73cdc5539384 100644
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
2.36.1

