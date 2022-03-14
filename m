Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2164D8D25
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244522AbiCNTvD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234960AbiCNTvB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:51:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005193FD90;
        Mon, 14 Mar 2022 12:49:24 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22EJlWg8009799;
        Mon, 14 Mar 2022 19:49:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=/7s44qEQdB7o8TYA5VEF1+kzxTBmxOzmg9jgtC/B8dU=;
 b=hc7na8oboC8HZLY74z5d4y7QTfiayLQE0O9fWSjx72CY0UvmvZBbdz/N/zDixdui+kxA
 sGK12X8grSAyKcqT1niEvuh1HDtbYiA25sd1LyTzkL6o4Pvlaozg6TgJZccaSXfPswEg
 8s96ON7EJ2rHJ5bMDIqiNu5TdQG6IviC7yQV7Kt6DMmW3TtlDgrES11yinz7PB6Tg8l1
 e8CO96uzavpMW2A61gDvzbskyEBI5F1/gm8/zQBbpztfNpNp/LeaHj5EaVTW1cKQmNjS
 tUEGYyRylk/xYeEjlVEKMWArYDTNAERjyB/34d2YwqsTiCjRV1SJ9NkswwB74bZKlXNe 3g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3et6cw8pa5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:49:02 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22EJlttg011329;
        Mon, 14 Mar 2022 19:49:02 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3et6cw8p9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:49:02 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22EJluCR010602;
        Mon, 14 Mar 2022 19:49:01 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03dal.us.ibm.com with ESMTP id 3erk594d56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:49:01 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22EJmx7H13697330
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 19:48:59 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81F31112071;
        Mon, 14 Mar 2022 19:48:59 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67FB111206D;
        Mon, 14 Mar 2022 19:48:50 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.184])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Mar 2022 19:48:50 +0000 (GMT)
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
Subject: [PATCH v4 23/32] KVM: s390: pci: provide routines for enabling/disabling interpretation
Date:   Mon, 14 Mar 2022 15:44:42 -0400
Message-Id: <20220314194451.58266-24-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220314194451.58266-1-mjrosato@linux.ibm.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wKYVF5108cgS-4hyYYJ7D7sj8Orx7VJz
X-Proofpoint-GUID: 52EhpqTujOOY9N6EpdHc7wE0kEqhj6hZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_13,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0 priorityscore=1501
 adultscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203140116
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These routines will be wired into a kvm ioctl in order to respond to
requests to enable / disable a device for zPCI Load/Store intepretation.

The first time such a request is received, enable the necessary facilities
for the guest.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/kvm/pci.c | 86 +++++++++++++++++++++++++++++++++++++++++++++
 arch/s390/pci/pci.c |  3 ++
 2 files changed, 89 insertions(+)

diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index 28fe95f13c33..df50dd6114c3 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -13,7 +13,9 @@
 #include <asm/kvm_pci.h>
 #include <asm/pci.h>
 #include <asm/pci_insn.h>
+#include <asm/sclp.h>
 #include "pci.h"
+#include "kvm-s390.h"
 
 struct zpci_aift *aift;
 
@@ -170,6 +172,87 @@ int kvm_s390_pci_aen_init(u8 nisc)
 	return rc;
 }
 
+static int kvm_s390_pci_interp_enable(struct zpci_dev *zdev)
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
+
+static int kvm_s390_pci_interp_disable(struct zpci_dev *zdev)
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
+
 static int kvm_s390_pci_group_notifier(struct notifier_block *nb,
 				       unsigned long action, void *data)
 {
@@ -203,6 +286,9 @@ void kvm_s390_pci_dev_release(struct zpci_dev *zdev)
 {
 	struct kvm_zdev *kzdev;
 
+	if (zdev->gisa != 0)
+		kvm_s390_pci_interp_disable(zdev, true);
+
 	kzdev = zdev->kzdev;
 	WARN_ON(kzdev->zdev != zdev);
 	zdev->kzdev = 0;
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

