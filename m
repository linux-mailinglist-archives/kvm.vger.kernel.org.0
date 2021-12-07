Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C8F46C595
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 22:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235064AbhLGVD0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 16:03:26 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48944 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235129AbhLGVDO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 16:03:14 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7Jbibn013535;
        Tue, 7 Dec 2021 20:59:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=7t+DoPKI/RxYnMzzJgmPIysxGPar6hNhSN2rMien8Y4=;
 b=OHelrWVn+M2mReEVpqGuAYGBtn/JrYP1TZrXHjFYE8qeXJ0/K/iHRQ3cwYWaMM9jFXMG
 v0NIw1wcG3QT1vo6YrtSTzI6g02dFB0zA6HL3+M6Nl4udT9oVMWOysKd+MyPYf9/x19q
 cJOHtnqGOH9VLsxztv7xG2evbsCN5JJbLyK7a46gtFf9N8m2WcjhnquuPTD6rDmFunaR
 CvaXnYiTFWTziiC3DyPsr6pPqpS+tyvvGg8zVHshbfchL/7XBHQyyKEQj+NGDlrFRFA2
 ZWxqoc9lEzym5eMr+uF4KqVatyeBxuF9JgsGwD6LRvTNosjmKZqRIeRtcqsdfqmd2xOt rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ctdn69rmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:59:43 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7Kw2OI004993;
        Tue, 7 Dec 2021 20:59:43 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ctdn69rmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:59:42 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7KwJx1001246;
        Tue, 7 Dec 2021 20:59:42 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma03wdc.us.ibm.com with ESMTP id 3cqyy7vm38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:59:42 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7KxeqX50987370
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 20:59:40 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70CA7AE071;
        Tue,  7 Dec 2021 20:59:40 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88971AE062;
        Tue,  7 Dec 2021 20:59:35 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.152.43])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 20:59:35 +0000 (GMT)
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
Subject: [PATCH 20/32] KVM: s390: pci: provide routines for enabling/disabling interpretation
Date:   Tue,  7 Dec 2021 15:57:31 -0500
Message-Id: <20211207205743.150299-21-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211207205743.150299-1-mjrosato@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EncaCya0Av-Nw6TWu-k9umH4WHsjzLlK
X-Proofpoint-ORIG-GUID: m4JGgGZPoPFEXOrfG2ll6F2ITVdgU3FN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_08,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 impostorscore=0 mlxscore=0 adultscore=0
 clxscore=1015 spamscore=0 malwarescore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070126
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
 arch/s390/kvm/pci.c             | 91 +++++++++++++++++++++++++++++++++
 arch/s390/pci/pci.c             |  3 ++
 3 files changed, 98 insertions(+)

diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
index 3e491a39704c..5d6283acb54c 100644
--- a/arch/s390/include/asm/kvm_pci.h
+++ b/arch/s390/include/asm/kvm_pci.h
@@ -26,4 +26,8 @@ extern int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
 extern void kvm_s390_pci_dev_release(struct zpci_dev *zdev);
 extern int kvm_s390_pci_attach_kvm(struct zpci_dev *zdev, struct kvm *kvm);
 
+extern int kvm_s390_pci_interp_probe(struct zpci_dev *zdev);
+extern int kvm_s390_pci_interp_enable(struct zpci_dev *zdev);
+extern int kvm_s390_pci_interp_disable(struct zpci_dev *zdev);
+
 #endif /* ASM_KVM_PCI_H */
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index f0e5386ff943..57cbe3827ea6 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -10,7 +10,9 @@
 #include <linux/kvm_host.h>
 #include <linux/pci.h>
 #include <asm/kvm_pci.h>
+#include <asm/sclp.h>
 #include "pci.h"
+#include "kvm-s390.h"
 
 static struct zpci_aift aift;
 
@@ -118,6 +120,95 @@ int kvm_s390_pci_aen_init(u8 nisc)
 	return rc;
 }
 
+int kvm_s390_pci_interp_probe(struct zpci_dev *zdev)
+{
+	if (!(sclp.has_zpci_interp && test_facility(69)))
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
+				(u64)zdev->dma_table);
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
+				(u64)zdev->dma_table);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pci_interp_disable);
+
 int kvm_s390_pci_dev_open(struct zpci_dev *zdev)
 {
 	struct kvm_zdev *kzdev;
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 175854c861cd..0eac84387f3c 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -141,6 +141,7 @@ int zpci_register_ioat(struct zpci_dev *zdev, u8 dmaas,
 		zpci_dbg(3, "reg ioat fid:%x, cc:%d, status:%d\n", zdev->fid, cc, status);
 	return cc;
 }
+EXPORT_SYMBOL_GPL(zpci_register_ioat);
 
 /* Modify PCI: Unregister I/O address translation parameters */
 int zpci_unregister_ioat(struct zpci_dev *zdev, u8 dmaas)
@@ -740,6 +741,7 @@ int zpci_enable_device(struct zpci_dev *zdev)
 		zpci_update_fh(zdev, fh);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(zpci_enable_device);
 
 int zpci_disable_device(struct zpci_dev *zdev)
 {
@@ -763,6 +765,7 @@ int zpci_disable_device(struct zpci_dev *zdev)
 	}
 	return rc;
 }
+EXPORT_SYMBOL_GPL(zpci_disable_device);
 
 /**
  * zpci_hot_reset_device - perform a reset of the given zPCI function
-- 
2.27.0

