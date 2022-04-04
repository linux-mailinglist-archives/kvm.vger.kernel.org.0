Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1644F1BB8
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381062AbiDDVWW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379665AbiDDRqb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 13:46:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4945D13EBA;
        Mon,  4 Apr 2022 10:44:35 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 234HeG7Q029979;
        Mon, 4 Apr 2022 17:44:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ZdoUNP9wgbudVdDYTw9NBT2YTVYJ7we5S3iAfoDwFDU=;
 b=dO4ednbLHd8AFYh6fvnwPnXSjWtLQPPBYTLKJtWKoSYqxfsVBOdGMH3ZPsZqntW5wab8
 P/dMakZxiu1CjvvBvEXKuU1sAQhRH0+pfFh/fYm2QgsIx1hNXWPU5Wi7Cp4cA4f+Nb09
 El60yI4395fFidVPiIVXCnLI1iQg9s3yRkxKdm6wjmORuDo2jMbTd86JAeBwfm4FCj2r
 m1r/Y06j30SSBbwPw4AdQCXWEr6ksB1SvemCfyGilcR7Jdj6/yJbcsDDrv6WlgLgziiG
 T/PcRrpec9WoPpX7U+4fp/pizkmR1xTCrNsl3KCnx6oxo91N6mJrICS2FvFoEOi8Ni34 1Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f81v9788t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 17:44:34 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 234HfWQg004005;
        Mon, 4 Apr 2022 17:44:34 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f81v97878-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 17:44:33 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 234HgwXT006537;
        Mon, 4 Apr 2022 17:44:32 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01wdc.us.ibm.com with ESMTP id 3f6tyrw9t8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 17:44:32 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 234HiVfa20119822
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Apr 2022 17:44:31 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F18B213605D;
        Mon,  4 Apr 2022 17:44:30 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAC7113604F;
        Mon,  4 Apr 2022 17:44:28 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.125])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  4 Apr 2022 17:44:28 +0000 (GMT)
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
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v5 15/21] KVM: s390: pci: add routines to start/stop interpretive execution
Date:   Mon,  4 Apr 2022 13:43:43 -0400
Message-Id: <20220404174349.58530-16-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220404174349.58530-1-mjrosato@linux.ibm.com>
References: <20220404174349.58530-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CXgiP2QIlXwTl6peoOFIg31Xl15GVpYq
X-Proofpoint-ORIG-GUID: kjdLSpy-KvPk2l8fN63xOPUaDn8WrUvQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_06,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 suspectscore=0 malwarescore=0 mlxscore=0
 spamscore=0 clxscore=1015 impostorscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204040099
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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
 arch/s390/include/asm/kvm_host.h |  11 +++
 arch/s390/kvm/kvm-s390.c         |   5 +
 arch/s390/kvm/pci.c              | 163 +++++++++++++++++++++++++++++++
 arch/s390/kvm/pci.h              |   5 +
 arch/s390/pci/pci.c              |   3 +
 5 files changed, 187 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 8e381603b6a7..ef3364af6b34 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -967,6 +967,8 @@ struct kvm_arch{
 	DECLARE_BITMAP(idle_mask, KVM_MAX_VCPUS);
 	struct kvm_s390_gisa_interrupt gisa_int;
 	struct kvm_s390_pv pv;
+	struct list_head kzdev_list;
+	spinlock_t kzdev_list_lock;
 };
 
 #define KVM_HVA_ERR_BAD		(-1UL)
@@ -1017,4 +1019,13 @@ static inline void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 
+#ifdef CONFIG_PCI
+int kvm_s390_pci_register_kvm(struct device *dev, void *data);
+#else
+static inline int kvm_s390_pci_register_kvm(struct device *dev, void *data)
+{
+	return -EPERM;
+}
+#endif
+
 #endif
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 327649ddddce..704d85214f4f 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2864,6 +2864,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	kvm_s390_crypto_init(kvm);
 
+	if (IS_ENABLED(CONFIG_VFIO_PCI))
+		kvm_s390_pci_init_list(kvm);
+
 	mutex_init(&kvm->arch.float_int.ais_lock);
 	spin_lock_init(&kvm->arch.float_int.lock);
 	for (i = 0; i < FIRQ_LIST_COUNT; i++)
@@ -2949,6 +2952,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	if (!kvm_is_ucontrol(kvm))
 		gmap_remove(kvm->arch.gmap);
 	kvm_s390_destroy_adapters(kvm);
+	if (IS_ENABLED(CONFIG_VFIO_PCI))
+		kvm_s390_pci_clear_list(kvm);
 	kvm_s390_clear_float_irqs(kvm);
 	kvm_s390_vsie_destroy(kvm);
 	KVM_EVENT(3, "vm 0x%pK destroyed", kvm);
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index f0fd68569a9d..66565f5f3f43 100644
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
 
@@ -425,6 +427,167 @@ void kvm_s390_pci_dev_release(struct zpci_dev *zdev)
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
+int kvm_s390_pci_register_kvm(struct device *dev, void *data)
+{
+	struct zpci_dev *zdev = NULL;
+	struct kvm *kvm = data;
+
+	/* Only proceed for zPCI devices, quietly ignore others */
+	if (dev_is_pci(dev))
+		zdev = to_zpci_dev(dev);
+	if (!zdev)
+		return 0;
+
+	/*
+	 * Register all devices with this KVM.  If interpetation facilities
+	 * are available, enable them and let userspace indicate whether or
+	 * not they will be used (specify SHM bit to disable).
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
index b4bf3d1d4b66..cb5ec3208923 100644
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
 
 static inline bool kvm_s390_pci_interp_allowed(void)
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

