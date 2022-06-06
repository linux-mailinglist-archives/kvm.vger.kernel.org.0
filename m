Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9DB253EFE3
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 22:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233987AbiFFUhy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 16:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234184AbiFFUhX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 16:37:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E20CEBA8;
        Mon,  6 Jun 2022 13:35:28 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256KTm4e006929;
        Mon, 6 Jun 2022 20:35:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=zNSjFdn15xA0Qz7206qb1x9g6FO4Lxv+AMZFEYhLDHM=;
 b=OucaaWD2nZr7jDxv6ba4PezPv6Rgk1lq9WdWEgNeB4j+V/PVdqc/WtguedeUxBLbZuir
 MKhsV/8chSLerLVwf/A5fuUW60T8KRfqTxyTOsi2uNxxyPDc4l41aSArHHBbIvEN+TRI
 gctW3cC5raNT74tChQQr9kRA9wNPkCN+urIkA/84dJOVUSo+KgNnfu+5DKhQLFE1Asy5
 QwtHwwbdnWJg2lFP1jf8Tc50QrdjJ+pEfbsfSdBmK063v/fBv2b16KmTRYYO6aPi2swi
 6fEdL7N3g3Ux4DceCQAPmaZH8ZEkhK8ZjhStqg3EiJ9y2GdUxxb+ipk2JGgTtJOCoEoX MQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ghpset9an-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:35:26 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 256KZQTf029655;
        Mon, 6 Jun 2022 20:35:26 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ghpset9ab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:35:25 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 256KKD1n030464;
        Mon, 6 Jun 2022 20:35:24 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma03wdc.us.ibm.com with ESMTP id 3gfy19fvue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:35:24 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 256KZNei63766900
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Jun 2022 20:35:24 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE6D328059;
        Mon,  6 Jun 2022 20:35:23 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B86128058;
        Mon,  6 Jun 2022 20:35:18 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.163.20.188])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  6 Jun 2022 20:35:18 +0000 (GMT)
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
Subject: [PATCH v9 17/21] vfio-pci/zdev: add open/close device hooks
Date:   Mon,  6 Jun 2022 16:33:21 -0400
Message-Id: <20220606203325.110625-18-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220606203325.110625-1-mjrosato@linux.ibm.com>
References: <20220606203325.110625-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: b7vHG5Bgu4AH4FDMMkbBU2X1JWfEj6hH
X-Proofpoint-ORIG-GUID: ThhZZY384koPm2NpLJn8O0pjEEWBo6i1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-06_06,2022-06-03_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 phishscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206060081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

During vfio-pci open_device, pass the KVM associated with the vfio group
(if one exists).  This is needed in order to pass a special indicator
(GISA) to firmware to allow zPCI interpretation facilities to be used
for only the specific KVM associated with the vfio-pci device.  During
vfio-pci close_device, unregister the notifier.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 10 +++++++++-
 drivers/vfio/pci/vfio_pci_zdev.c | 24 ++++++++++++++++++++++++
 include/linux/vfio_pci_core.h    | 10 ++++++++++
 3 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index a0d69ddaf90d..b1e5cfbadf38 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -316,10 +316,14 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 		pci_write_config_word(pdev, PCI_COMMAND, cmd);
 	}
 
-	ret = vfio_config_init(vdev);
+	ret = vfio_pci_zdev_open_device(vdev);
 	if (ret)
 		goto out_free_state;
 
+	ret = vfio_config_init(vdev);
+	if (ret)
+		goto out_free_zdev;
+
 	msix_pos = pdev->msix_cap;
 	if (msix_pos) {
 		u16 flags;
@@ -340,6 +344,8 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 
 	return 0;
 
+out_free_zdev:
+	vfio_pci_zdev_close_device(vdev);
 out_free_state:
 	kfree(vdev->pci_saved_state);
 	vdev->pci_saved_state = NULL;
@@ -418,6 +424,8 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 
 	vdev->needs_reset = true;
 
+	vfio_pci_zdev_close_device(vdev);
+
 	/*
 	 * If we have saved state, restore it.  If we can reset the device,
 	 * even better.  Resetting with current state seems better than
diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index ea4c0d2b0663..686f2e75e392 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -11,6 +11,7 @@
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
 #include <linux/vfio_zdev.h>
+#include <linux/kvm_host.h>
 #include <asm/pci_clp.h>
 #include <asm/pci_io.h>
 
@@ -136,3 +137,26 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 
 	return ret;
 }
+
+int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
+{
+	struct zpci_dev *zdev = to_zpci(vdev->pdev);
+
+	if (!zdev)
+		return -ENODEV;
+
+	if (!vdev->vdev.kvm)
+		return 0;
+
+	return kvm_s390_pci_register_kvm(zdev, vdev->vdev.kvm);
+}
+
+void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
+{
+	struct zpci_dev *zdev = to_zpci(vdev->pdev);
+
+	if (!zdev || !vdev->vdev.kvm)
+		return;
+
+	kvm_s390_pci_unregister_kvm(zdev);
+}
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 63af2897939c..d5d9e17f0156 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -209,12 +209,22 @@ static inline int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
 #ifdef CONFIG_VFIO_PCI_ZDEV_KVM
 extern int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 				       struct vfio_info_cap *caps);
+int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev);
+void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev);
 #else
 static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 					      struct vfio_info_cap *caps)
 {
 	return -ENODEV;
 }
+
+static inline int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
+{
+	return 0;
+}
+
+static inline void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
+{}
 #endif
 
 /* Will be exported for vfio pci drivers usage */
-- 
2.27.0

