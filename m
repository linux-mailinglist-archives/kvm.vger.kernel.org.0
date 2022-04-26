Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D94705109F8
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 22:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354752AbiDZUPo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 16:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354700AbiDZUNZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 16:13:25 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426D6DF99;
        Tue, 26 Apr 2022 13:10:13 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QK4oVK005894;
        Tue, 26 Apr 2022 20:10:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=fKGJpwWLY7Ri5uUW+pL/fwIxBYE/PSXboYCoYiz49Eg=;
 b=e7UBMZKpEfWkIrhPxNGdFIxfAOrNH+o5VHfWhG9ai0/exVy7/2CSPH9mcBgfvpT6OX2K
 ANTO66DYK7h3UuwZIPLnECemlHq2jeR2lJWeKluj0QoXq+eE/OsZha4skdbPF3BTs1E9
 abonTDir3CSeAm02nQd9QQ5rHhAWWcA+Mo3Ac3RxiSWMcu4dEKUITwC1W2YBvcquAln9
 VtjWedUrNVUZPNZGErSI/XJ3V2DoCsY8dcNy0FKBfsU0wkLzNJCbpUuVYzSavw1NO5XU
 zojetA5xvZSKMIvR8nqijbRXllpGNMvGaSYMFfrp30W7CGmsVp+z3A/gNCKJThftgxcs GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpm2vcd7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 20:10:09 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23QK60oX010085;
        Tue, 26 Apr 2022 20:10:02 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpm2vcd75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 20:10:02 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23QK8dnd009932;
        Tue, 26 Apr 2022 20:10:01 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03dal.us.ibm.com with ESMTP id 3fm939w9vv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 20:10:01 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23QKA0O55768038
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 20:10:00 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DBE8B206A;
        Tue, 26 Apr 2022 20:10:00 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74AE0B2067;
        Tue, 26 Apr 2022 20:09:56 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.73.42])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 26 Apr 2022 20:09:56 +0000 (GMT)
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
Subject: [PATCH v6 15/21] KVM: s390: pci: add routines to start/stop interpretive execution
Date:   Tue, 26 Apr 2022 16:08:36 -0400
Message-Id: <20220426200842.98655-16-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220426200842.98655-1-mjrosato@linux.ibm.com>
References: <20220426200842.98655-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: U19dY12hsE-MlFolnNi8_kVa9eNjO8px
X-Proofpoint-ORIG-GUID: 36z9-H3yiSdAXUq4vNV5qt-D8bygyZF0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_06,2022-04-26_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501
 bulkscore=0 clxscore=1015 phishscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204260127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

Furthemore, add/remove these devices from a list associated with the
kvm and ensure proper cleanup always occurs during vm exit.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  13 +++
 arch/s390/kvm/kvm-s390.c         |   9 ++
 arch/s390/kvm/pci.c              | 158 +++++++++++++++++++++++++++++++
 arch/s390/kvm/pci.h              |   5 +
 arch/s390/pci/pci.c              |   3 +
 5 files changed, 188 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 8e381603b6a7..cd58f204305e 100644
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
@@ -1017,4 +1020,14 @@ static inline void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 
+#ifdef CONFIG_PCI
+int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm);
+#else
+static inline int kvm_s390_pci_register_kvm(struct zpci_dev *dev,
+					    struct kvm *kvm)
+{
+	return -EPERM;
+}
+#endif
+
 #endif
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 504f312c1c27..bd6c8aeabc24 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2866,6 +2866,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	kvm_s390_crypto_init(kvm);
 
+	if (IS_ENABLED(CONFIG_VFIO_PCI)) {
+		mutex_lock(&kvm->lock);
+		kvm_s390_pci_init_list(kvm);
+		kvm_s390_vcpu_pci_enable_interp(kvm);
+		mutex_unlock(&kvm->lock);
+	}
+
 	mutex_init(&kvm->arch.float_int.ais_lock);
 	spin_lock_init(&kvm->arch.float_int.lock);
 	for (i = 0; i < FIRQ_LIST_COUNT; i++)
@@ -2951,6 +2958,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	if (!kvm_is_ucontrol(kvm))
 		gmap_remove(kvm->arch.gmap);
 	kvm_s390_destroy_adapters(kvm);
+	if (IS_ENABLED(CONFIG_VFIO_PCI))
+		kvm_s390_pci_clear_list(kvm);
 	kvm_s390_clear_float_irqs(kvm);
 	kvm_s390_vsie_destroy(kvm);
 	KVM_EVENT(3, "vm 0x%pK destroyed", kvm);
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index 72a9c6bfae86..2aee7f11db1d 100644
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
 
@@ -424,6 +426,162 @@ void kvm_s390_pci_dev_release(struct zpci_dev *zdev)
 }
 EXPORT_SYMBOL_GPL(kvm_s390_pci_dev_release);
 
+static inline int register_kvm(struct zpci_dev *zdev, struct kvm *kvm)
+{
+	int rc;
+
+	if (zdev->kzdev || zdev->gisa != 0)
+		return -EINVAL;
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
+	return 0;
+
+clear_gisa:
+	zdev->gisa = 0;
+err:
+	if (zdev->kzdev)
+		kvm_s390_pci_dev_release(zdev);
+	mutex_unlock(&kvm->lock);
+	return rc;
+}
+
+static inline int unregister_kvm(struct zpci_dev *zdev)
+{
+	struct kvm *kvm;
+	int rc;
+
+	if (!zdev->kzdev)
+		return -EINVAL;
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
+
+	return rc;
+}
+
+int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm)
+{
+	if (!zdev)
+		return 0;
+
+	/*
+	 * Register device with this KVM (or remove the KVM association if 0).
+	 * If interpetation facilities are available, enable them and let
+	 * userspace indicate whether or not they will be used (specify SHM bit
+	 * to disable).
+	 */
+	if (kvm)
+		return register_kvm(zdev, kvm);
+	else
+		return unregister_kvm(zdev);
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pci_register_kvm);
+
+void kvm_s390_pci_init_list(struct kvm *kvm)
+{
+	spin_lock_init(&kvm->arch.kzdev_list_lock);
+	INIT_LIST_HEAD(&kvm->arch.kzdev_list);
+}
+
+void kvm_s390_pci_clear_list(struct kvm *kvm)
+{
+	struct kvm_zdev *tmp, *kzdev;
+	LIST_HEAD(remove);
+
+	spin_lock(&kvm->arch.kzdev_list_lock);
+	list_for_each_entry_safe(kzdev, tmp, &kvm->arch.kzdev_list, entry)
+		list_move_tail(&kzdev->entry, &remove);
+	spin_unlock(&kvm->arch.kzdev_list_lock);
+
+	list_for_each_entry_safe(kzdev, tmp, &remove, entry)
+		unregister_kvm(kzdev->zdev);
+}
+
 int kvm_s390_pci_init(void)
 {
 	aift = kzalloc(sizeof(struct zpci_aift), GFP_KERNEL);
diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
index f567c3189a40..d11662fadb78 100644
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
index f0a439c43395..d9b021fb84d5 100644
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
-- 
2.27.0

