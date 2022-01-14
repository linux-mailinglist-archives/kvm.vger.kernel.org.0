Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1987048F162
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 21:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240460AbiANUdf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 15:33:35 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42060 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244581AbiANUce (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 15:32:34 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EKPqsD026299;
        Fri, 14 Jan 2022 20:32:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=BM6vPHo8E2GSbxhK2v9hO2yly6LLeazVtB4bAw+F6hs=;
 b=LaaUrSsfAB12vpgd9Ne1a46jgW5QNFkE+yoLqBNHhsjY8Kvu52HXFwd90uw7lxbPYoGi
 IWuIqUfh4yghQtRVTzncOQWW5vSmqtBVYyFKI6U/BG5QYt8U4JGAjhpoW651NSodKwc3
 lU8xKtJ9swMKGwTcS/We0XeTmmgsqVJHVAIEgbrM2oM4jO/1sjxo/vqOiFAHqbsBj4un
 jEidpKTM4xj/8pPzVgZb/kMoU3fmQES0/dGduDZ5hI6i4WMIJjhmTyTKjQObrbFvVrjn
 LH408NyNdbbUDRtQJ6o0C1PoQK1+D9zXLzlqj293vMFaogHc97TDIR9RiZpZVadqbU2A rA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkg72r44y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:33 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EKWXOp015959;
        Fri, 14 Jan 2022 20:32:33 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkg72r44d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:33 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EKLcXN022046;
        Fri, 14 Jan 2022 20:32:32 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04wdc.us.ibm.com with ESMTP id 3df28cqjau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:32 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EKWQ6U22806896
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 20:32:26 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63EFAC6065;
        Fri, 14 Jan 2022 20:32:26 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC613C6069;
        Fri, 14 Jan 2022 20:32:24 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.65.142])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 20:32:24 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 18/30] KVM: s390: pci: provide routines for enabling/disabling interpretation
Date:   Fri, 14 Jan 2022 15:31:33 -0500
Message-Id: <20220114203145.242984-19-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220114203145.242984-1-mjrosato@linux.ibm.com>
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KS47p-QfUQfm2-J0QBw_jvhpW168JJ5J
X-Proofpoint-GUID: Jpqw1vQaHTdzLA6_5DAcCj41jaWDdwn_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_06,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 clxscore=1015 impostorscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 priorityscore=1501 adultscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These routines will be wired into the vfio_pci_zdev ioctl handlers to
respond to requests to enable / disable a device for zPCI Load/Store
interpretation.

The first time such a request is received, enable the necessary facilities
for the guest.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/kvm_pci.h |  4 ++
 arch/s390/kvm/pci.c             | 99 +++++++++++++++++++++++++++++++++
 arch/s390/pci/pci.c             |  3 +
 3 files changed, 106 insertions(+)

diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
index aafee2976929..072401aa7922 100644
--- a/arch/s390/include/asm/kvm_pci.h
+++ b/arch/s390/include/asm/kvm_pci.h
@@ -26,4 +26,8 @@ int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
 void kvm_s390_pci_dev_release(struct zpci_dev *zdev);
 void kvm_s390_pci_attach_kvm(struct zpci_dev *zdev, struct kvm *kvm);
 
+int kvm_s390_pci_interp_probe(struct zpci_dev *zdev);
+int kvm_s390_pci_interp_enable(struct zpci_dev *zdev);
+int kvm_s390_pci_interp_disable(struct zpci_dev *zdev);
+
 #endif /* ASM_KVM_PCI_H */
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index dae853da6df1..122d0992b521 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -12,7 +12,9 @@
 #include <asm/kvm_pci.h>
 #include <asm/pci.h>
 #include <asm/pci_insn.h>
+#include <asm/sclp.h>
 #include "pci.h"
+#include "kvm-s390.h"
 
 struct zpci_aift *aift;
 
@@ -143,6 +145,103 @@ int kvm_s390_pci_aen_init(u8 nisc)
 	return rc;
 }
 
+int kvm_s390_pci_interp_probe(struct zpci_dev *zdev)
+{
+	/* Must have appropriate hardware facilities */
+	if (!(sclp.has_zpci_lsi && test_facility(69)))
+		return -EINVAL;
+
+	/* Must have a KVM association registered */
+	if (!zdev->kzdev || !zdev->kzdev->kvm)
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pci_interp_probe);
+
+int kvm_s390_pci_interp_enable(struct zpci_dev *zdev)
+{
+	u32 gd;
+	int rc;
+
+	if (!zdev->kzdev || !zdev->kzdev->kvm)
+		return -EINVAL;
+
+	/*
+	 * If this is the first request to use an interpreted device, make the
+	 * necessary vcpu changes
+	 */
+	if (!zdev->kzdev->kvm->arch.use_zpci_interp)
+		kvm_s390_vcpu_pci_enable_interp(zdev->kzdev->kvm);
+
+	/*
+	 * In the event of a system reset in userspace, the GISA designation
+	 * may still be assigned because the device is still enabled.
+	 * Verify it's the same guest before proceeding.
+	 */
+	gd = (u32)(u64)&zdev->kzdev->kvm->arch.sie_page2->gisa;
+	if (zdev->gd != 0 && zdev->gd != gd)
+		return -EPERM;
+
+	if (zdev_enabled(zdev)) {
+		zdev->gd = 0;
+		rc = zpci_disable_device(zdev);
+		if (rc)
+			return rc;
+	}
+
+	/*
+	 * Store information about the identity of the kvm guest allowed to
+	 * access this device via interpretation to be used by host CLP
+	 */
+	zdev->gd = gd;
+
+	rc = zpci_enable_device(zdev);
+	if (rc)
+		goto err;
+
+	/* Re-register the IOMMU that was already created */
+	rc = zpci_register_ioat(zdev, 0, zdev->start_dma, zdev->end_dma,
+				virt_to_phys(zdev->dma_table));
+	if (rc)
+		goto err;
+
+	return rc;
+
+err:
+	zdev->gd = 0;
+	return rc;
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pci_interp_enable);
+
+int kvm_s390_pci_interp_disable(struct zpci_dev *zdev)
+{
+	int rc;
+
+	if (zdev->gd == 0)
+		return -EINVAL;
+
+	/* Remove the host CLP guest designation */
+	zdev->gd = 0;
+
+	if (zdev_enabled(zdev)) {
+		rc = zpci_disable_device(zdev);
+		if (rc)
+			return rc;
+	}
+
+	rc = zpci_enable_device(zdev);
+	if (rc)
+		return rc;
+
+	/* Re-register the IOMMU that was already created */
+	rc = zpci_register_ioat(zdev, 0, zdev->start_dma, zdev->end_dma,
+				virt_to_phys(zdev->dma_table));
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pci_interp_disable);
+
 int kvm_s390_pci_dev_open(struct zpci_dev *zdev)
 {
 	struct kvm_zdev *kzdev;
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 2a19becbc14c..58673f633869 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -147,6 +147,7 @@ int zpci_register_ioat(struct zpci_dev *zdev, u8 dmaas,
 		zpci_dbg(3, "reg ioat fid:%x, cc:%d, status:%d\n", zdev->fid, cc, status);
 	return cc;
 }
+EXPORT_SYMBOL_GPL(zpci_register_ioat);
 
 /* Modify PCI: Unregister I/O address translation parameters */
 int zpci_unregister_ioat(struct zpci_dev *zdev, u8 dmaas)
@@ -727,6 +728,7 @@ int zpci_enable_device(struct zpci_dev *zdev)
 		zpci_update_fh(zdev, fh);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(zpci_enable_device);
 
 int zpci_disable_device(struct zpci_dev *zdev)
 {
@@ -750,6 +752,7 @@ int zpci_disable_device(struct zpci_dev *zdev)
 	}
 	return rc;
 }
+EXPORT_SYMBOL_GPL(zpci_disable_device);
 
 /**
  * zpci_hot_reset_device - perform a reset of the given zPCI function
-- 
2.27.0

