Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37D874D8D3C
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244565AbiCNTux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244600AbiCNTup (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:50:45 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B733EAB1;
        Mon, 14 Mar 2022 12:49:09 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22EJlUvf008369;
        Mon, 14 Mar 2022 19:48:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=fd5fQI4HUmVzn6H5qypbsY6eukCX/bkqPN4nxqPV2TQ=;
 b=QyGHLukqW/OpJ1/Gfk1oodcJBsw6yBMlsOiMkIwT/dvvC9JR9IwUe9bEr/3jrWHitoHw
 VLOxnn8NFbfQv0p6WvlUNQ7C3hPlcw/c5tb67xdqf8O5m87rCCCuThMAXN0a07g1Lkuw
 XlMS9J/DkA0xRxIbmk+dt6Ms8yrsh3oV7fkcFWcNLP0S1Y5DJFEiCvesiO7sVT2VBblD
 Rx4SBWTjAt87g9j0kSKPowGnRo9DWwrh6od3feDVuumyxfk5VEtaY3FirZGIZXMo0L99
 N6GDoWlKBxYOR7MlayGOqx9n1N11C1xY9RR4Foq0OLcEEzGj/qLc4lv07ivpmF5x4XcE gQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6cs0q47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:48:53 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22EJloeP009950;
        Mon, 14 Mar 2022 19:48:52 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6cs0q43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:48:52 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22EJlDfl010241;
        Mon, 14 Mar 2022 19:48:51 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma05wdc.us.ibm.com with ESMTP id 3erk59rah6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:48:51 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22EJmoPX18022730
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 19:48:50 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DEFCA112073;
        Mon, 14 Mar 2022 19:48:49 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1DF0112062;
        Mon, 14 Mar 2022 19:48:39 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.184])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Mar 2022 19:48:39 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, joro@8bytes.org, will@kernel.org,
        pbonzini@redhat.com, corbet@lwn.net, jgg@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-doc@vger.kernel.org
Subject: [PATCH v4 22/32] KVM: s390: pci: routines for (dis)associating zPCI devices with a KVM
Date:   Mon, 14 Mar 2022 15:44:41 -0400
Message-Id: <20220314194451.58266-23-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220314194451.58266-1-mjrosato@linux.ibm.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BvStC7B5dCYRItOiKOYZBS0KWHJUM6cg
X-Proofpoint-ORIG-GUID: SV6XvuXVs85AmjhY90X5FXWuFotfl424
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_13,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=969
 priorityscore=1501 mlxscore=0 suspectscore=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 spamscore=0 adultscore=0 impostorscore=0
 clxscore=1015 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2203140116
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These routines will be wired into a KVM ioctl, to be issued from
userspace to (dis)associate a specific zPCI device with the issuing
KVM.  This will create/delete a relationship between KVM, zPCI device
and the associated IOMMU domain for the device.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |   2 +
 arch/s390/include/asm/kvm_pci.h  |   2 +
 arch/s390/kvm/kvm-s390.c         |   5 +
 arch/s390/kvm/pci.c              | 225 +++++++++++++++++++++++++++++++
 arch/s390/kvm/pci.h              |   5 +
 5 files changed, 239 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index bf61ab05f98c..bd171abbb8ef 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -965,6 +965,8 @@ struct kvm_arch{
 	DECLARE_BITMAP(idle_mask, KVM_MAX_VCPUS);
 	struct kvm_s390_gisa_interrupt gisa_int;
 	struct kvm_s390_pv pv;
+	struct list_head kzdev_list;
+	spinlock_t kzdev_list_lock;
 };
 
 #define KVM_HVA_ERR_BAD		(-1UL)
diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
index ebc0da5d9ac1..47ce18b5bddd 100644
--- a/arch/s390/include/asm/kvm_pci.h
+++ b/arch/s390/include/asm/kvm_pci.h
@@ -21,6 +21,8 @@ struct kvm_zdev {
 	struct zpci_dev *zdev;
 	struct kvm *kvm;
 	struct iommu_domain *dom; /* Used to invoke IOMMU API for RPCIT */
+	struct notifier_block nb;
+	struct list_head entry;
 };
 
 int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d91b2547f0bf..84acaf59a7d3 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2775,6 +2775,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	kvm_s390_crypto_init(kvm);
 
+	if (IS_ENABLED(CONFIG_VFIO_PCI))
+		kvm_s390_pci_init_list(kvm);
+
 	mutex_init(&kvm->arch.float_int.ais_lock);
 	spin_lock_init(&kvm->arch.float_int.lock);
 	for (i = 0; i < FIRQ_LIST_COUNT; i++)
@@ -2860,6 +2863,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	if (!kvm_is_ucontrol(kvm))
 		gmap_remove(kvm->arch.gmap);
 	kvm_s390_destroy_adapters(kvm);
+	if (IS_ENABLED(CONFIG_VFIO_PCI))
+		kvm_s390_pci_clear_list(kvm);
 	kvm_s390_clear_float_irqs(kvm);
 	kvm_s390_vsie_destroy(kvm);
 	KVM_EVENT(3, "vm 0x%pK destroyed", kvm);
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index 1c42d25de697..28fe95f13c33 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -9,6 +9,7 @@
 
 #include <linux/kvm_host.h>
 #include <linux/pci.h>
+#include <linux/vfio.h>
 #include <asm/kvm_pci.h>
 #include <asm/pci.h>
 #include <asm/pci_insn.h>
@@ -23,6 +24,22 @@ static inline int __set_irq_noiib(u16 ctl, u8 isc)
 	return zpci_set_irq_ctrl(ctl, isc, &iib);
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
 /* Caller must hold the aift lock before calling this function */
 void kvm_s390_pci_aen_exit(void)
 {
@@ -153,6 +170,20 @@ int kvm_s390_pci_aen_init(u8 nisc)
 	return rc;
 }
 
+static int kvm_s390_pci_group_notifier(struct notifier_block *nb,
+				       unsigned long action, void *data)
+{
+	struct kvm_zdev *kzdev = container_of(nb, struct kvm_zdev, nb);
+
+	if (action == VFIO_GROUP_NOTIFY_SET_KVM) {
+		if (!data || !kzdev->zdev)
+			return NOTIFY_DONE;
+		kzdev->kvm = data;
+	}
+
+	return NOTIFY_OK;
+}
+
 int kvm_s390_pci_dev_open(struct zpci_dev *zdev)
 {
 	struct kvm_zdev *kzdev;
@@ -179,6 +210,200 @@ void kvm_s390_pci_dev_release(struct zpci_dev *zdev)
 }
 EXPORT_SYMBOL_GPL(kvm_s390_pci_dev_release);
 
+static struct vfio_device *get_vdev(struct device *dev)
+{
+	struct vfio_device *(*fn)(struct device *dev);
+	struct vfio_device *vdev;
+
+	fn = symbol_get(vfio_device_get_from_dev);
+	if (!fn)
+		return NULL;
+
+	vdev = fn(dev);
+
+	symbol_put(vfio_device_get_from_dev);
+
+	return vdev;
+}
+
+static void put_vdev(struct vfio_device *vdev)
+{
+	void (*fn)(struct vfio_device *vdev);
+
+	fn = symbol_get(vfio_device_put);
+	if (!fn)
+		return;
+
+	fn(vdev);
+
+	symbol_put(vfio_device_put);
+}
+
+static int register_notifier(struct device *dev, struct notifier_block *nb)
+{
+	int (*fn)(struct device *dev, enum vfio_notify_type type,
+		  unsigned long *events, struct notifier_block *nb);
+	unsigned long events = VFIO_GROUP_NOTIFY_SET_KVM;
+	int rc;
+
+	fn = symbol_get(vfio_register_notifier);
+	if (!fn)
+		return -EINVAL;
+
+	rc = fn(dev, VFIO_GROUP_NOTIFY, &events, nb);
+
+	symbol_put(vfio_register_notifier);
+
+	return rc;
+}
+
+static int unregister_notifier(struct device *dev, struct notifier_block *nb)
+{
+	int (*fn)(struct device *dev, enum vfio_notify_type type,
+		  struct notifier_block *nb);
+	int rc;
+
+	fn = symbol_get(vfio_unregister_notifier);
+	if (!fn)
+		return -EINVAL;
+
+	rc = fn(dev, VFIO_GROUP_NOTIFY, nb);
+
+	symbol_put(vfio_unregister_notifier);
+
+	return rc;
+}
+
+int kvm_s390_pci_zpci_start(struct kvm *kvm, struct zpci_dev *zdev)
+{
+	struct vfio_device *vdev;
+	struct pci_dev *pdev;
+	int rc;
+
+	rc = kvm_s390_pci_dev_open(zdev);
+	if (rc)
+		return rc;
+
+	pdev = pci_get_slot(zdev->zbus->bus, zdev->devfn);
+	if (!pdev) {
+		rc = -ENODEV;
+		goto exit_err;
+	}
+
+	vdev = get_vdev(&pdev->dev);
+	if (!vdev) {
+		pci_dev_put(pdev);
+		rc = -ENODEV;
+		goto exit_err;
+	}
+
+	zdev->kzdev->nb.notifier_call = kvm_s390_pci_group_notifier;
+
+	/*
+	 * At this point, a KVM should already be associated with this device,
+	 * so registering the notifier now should immediately trigger the
+	 * event.  We also want to know if the KVM association is later removed
+	 * to ensure proper cleanup happens.
+	 */
+	rc = register_notifier(vdev->dev, &zdev->kzdev->nb);
+
+	put_vdev(vdev);
+	pci_dev_put(pdev);
+
+	/* Make sure the registered KVM matches the KVM issuing the ioctl */
+	if (rc || zdev->kzdev->kvm != kvm) {
+		rc = -ENODEV;
+		goto exit_err;
+	}
+
+	/* Must support KVM-managed IOMMU to proceed */
+	if (IS_ENABLED(CONFIG_S390_KVM_IOMMU))
+		rc = zpci_iommu_attach_kvm(zdev, kvm);
+	else
+		rc = -EINVAL;
+
+	if (rc)
+		goto exit_err;
+
+	spin_lock(&kvm->arch.kzdev_list_lock);
+	list_add_tail(&zdev->kzdev->entry, &kvm->arch.kzdev_list);
+	spin_unlock(&kvm->arch.kzdev_list_lock);
+	return 0;
+
+exit_err:
+	kvm_s390_pci_dev_release(zdev);
+	return rc;
+}
+
+int kvm_s390_pci_zpci_stop(struct kvm *kvm, struct zpci_dev *zdev)
+{
+	struct vfio_device *vdev;
+	struct pci_dev *pdev;
+	int rc = 0;
+
+	if (!zdev || !zdev->kzdev)
+		return -EINVAL;
+
+	pdev = pci_get_slot(zdev->zbus->bus, zdev->devfn);
+	if (!pdev) {
+		rc = -ENODEV;
+		goto exit_err;
+	}
+
+	vdev = get_vdev(&pdev->dev);
+	if (!vdev) {
+		pci_dev_put(pdev);
+		rc = -ENODEV;
+		goto exit_err;
+	}
+
+	spin_lock(&kvm->arch.kzdev_list_lock);
+	list_del(&zdev->kzdev->entry);
+	spin_unlock(&kvm->arch.kzdev_list_lock);
+
+	rc = unregister_notifier(vdev->dev, &zdev->kzdev->nb);
+
+	put_vdev(vdev);
+	pci_dev_put(pdev);
+
+exit_err:
+	kvm_s390_pci_dev_release(zdev);
+	return rc;
+}
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
+	struct vfio_device *vdev;
+	struct pci_dev *pdev;
+	LIST_HEAD(remove);
+
+	spin_lock(&kvm->arch.kzdev_list_lock);
+	list_for_each_entry_safe(kzdev, tmp, &kvm->arch.kzdev_list, entry)
+		list_move_tail(&kzdev->entry, &remove);
+	spin_unlock(&kvm->arch.kzdev_list_lock);
+
+	list_for_each_entry_safe(kzdev, tmp, &remove, entry) {
+		pdev = pci_get_slot(kzdev->zdev->zbus->bus, kzdev->zdev->devfn);
+		if (pdev) {
+			vdev = get_vdev(&pdev->dev);
+			if (vdev) {
+				unregister_notifier(vdev->dev,
+						    &kzdev->nb);
+				put_vdev(vdev);
+			}
+			pci_dev_put(pdev);
+		}
+		kvm_s390_pci_dev_release(kzdev->zdev);
+	}
+}
+
 int kvm_s390_pci_init(void)
 {
 	aift = kzalloc(sizeof(struct zpci_aift), GFP_KERNEL);
diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
index 25cb1c787190..a95d9fdc91be 100644
--- a/arch/s390/kvm/pci.h
+++ b/arch/s390/kvm/pci.h
@@ -47,6 +47,11 @@ static inline struct kvm *kvm_s390_pci_si_to_kvm(struct zpci_aift *aift,
 int kvm_s390_pci_aen_init(u8 nisc);
 void kvm_s390_pci_aen_exit(void);
 
+int kvm_s390_pci_zpci_start(struct kvm *kvm, struct zpci_dev *zdev);
+int kvm_s390_pci_zpci_stop(struct kvm *kvm, struct zpci_dev *zdev);
+void kvm_s390_pci_init_list(struct kvm *kvm);
+void kvm_s390_pci_clear_list(struct kvm *kvm);
+
 int kvm_s390_pci_init(void);
 
 #endif /* __KVM_S390_PCI_H */
-- 
2.27.0

