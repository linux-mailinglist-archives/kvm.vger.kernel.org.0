Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF4B4AA1E7
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243137AbiBDVRR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:17:17 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54872 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243096AbiBDVQZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 16:16:25 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214JxBRV017309;
        Fri, 4 Feb 2022 21:16:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=BHrYgIH1G5YQBgkXUTVvN2xQbz46N+yXKMrEuyz4n0Q=;
 b=p+7fcUgoMrHlBVVIuDMYGCVFD5674rmHSvcZ/NFyt6GJcDxUWygrme9xj+r8bfM9UMTb
 /zczWXTrxWpHyekgoIXa3YKeuZripfCUkfX/iQQeSJjVUIWtbw5MjLecEcWV0QaEM3KS
 MetP9QX+cPkmcdiE+H8837HFdNfjL1LujWEzEl9HdUrc0vEK5LtazPwdFa7t+PbeWG+Q
 2CN/ibgo//LVAq0GrN6Rjhrd/0wf+S5gvqhjEkIIayiaPQzPU6+pXyARd4q4q5fV7SgA
 LpeuoHu3No5DbmymDqZEC53Ux/gHBPa7VWJ6WsGFw0bKm9a0WqlcQxSZ7JBKjPbnGfXE Sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx9ew2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:24 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214L3orC018555;
        Fri, 4 Feb 2022 21:16:24 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx9ew1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:24 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214LCaGl021806;
        Fri, 4 Feb 2022 21:16:23 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03dal.us.ibm.com with ESMTP id 3e0r0k7gx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:23 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214LGLok37421482
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 21:16:21 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41431136060;
        Fri,  4 Feb 2022 21:16:21 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71FA6136055;
        Fri,  4 Feb 2022 21:16:19 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.82.52])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 21:16:19 +0000 (GMT)
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
Subject: [PATCH v3 19/30] KVM: s390: pci: provide routines for enabling/disabling interpretation
Date:   Fri,  4 Feb 2022 16:15:25 -0500
Message-Id: <20220204211536.321475-20-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220204211536.321475-1-mjrosato@linux.ibm.com>
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: z-IsFruyxBsj1cc6oxF-ijN4SE8Hird2
X-Proofpoint-ORIG-GUID: uUj4ybssPPMD4kK4xu27gEFBlnvQJc9w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 impostorscore=0 spamscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202040117
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
 arch/s390/include/asm/kvm_pci.h |   4 ++
 arch/s390/kvm/pci.c             | 102 ++++++++++++++++++++++++++++++++
 arch/s390/pci/pci.c             |   3 +
 3 files changed, 109 insertions(+)

diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
index ef10f9e46e37..422701d526dd 100644
--- a/arch/s390/include/asm/kvm_pci.h
+++ b/arch/s390/include/asm/kvm_pci.h
@@ -24,4 +24,8 @@ struct kvm_zdev {
 int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
 void kvm_s390_pci_dev_release(struct zpci_dev *zdev);
 
+int kvm_s390_pci_interp_probe(struct zpci_dev *zdev);
+int kvm_s390_pci_interp_enable(struct zpci_dev *zdev);
+int kvm_s390_pci_interp_disable(struct zpci_dev *zdev);
+
 #endif /* ASM_KVM_PCI_H */
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index 9b8390133e15..16bef3935284 100644
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
 
@@ -153,6 +155,106 @@ int kvm_s390_pci_aen_init(u8 nisc)
 	return rc;
 }
 
+int kvm_s390_pci_interp_probe(struct zpci_dev *zdev)
+{
+	/* Must have appropriate hardware facilities */
+	if (!sclp.has_zpci_lsi || !sclp.has_aisii || !sclp.has_aeni ||
+	    !sclp.has_aisi || !test_facility(69) || !test_facility(70) ||
+	    !test_facility(71) || !test_facility(72)) {
+		return -EINVAL;
+	}
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
+	u32 gisa;
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
+	gisa = (u32)virt_to_phys(&zdev->kzdev->kvm->arch.sie_page2->gisa);
+	if (zdev->gisa != 0 && zdev->gisa != gisa)
+		return -EPERM;
+
+	if (zdev_enabled(zdev)) {
+		zdev->gisa = 0;
+		rc = zpci_disable_device(zdev);
+		if (rc)
+			return rc;
+	}
+
+	/*
+	 * Store information about the identity of the kvm guest allowed to
+	 * access this device via interpretation to be used by host CLP
+	 */
+	zdev->gisa = gisa;
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
+	zdev->gisa = 0;
+	return rc;
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pci_interp_enable);
+
+int kvm_s390_pci_interp_disable(struct zpci_dev *zdev)
+{
+	int rc;
+
+	if (zdev->gisa == 0)
+		return -EINVAL;
+
+	/* Remove the host CLP guest designation */
+	zdev->gisa = 0;
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
index 13033717cd4e..5dbe49ec325e 100644
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

