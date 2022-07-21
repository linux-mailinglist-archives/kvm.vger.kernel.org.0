Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3230D57D0E9
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 18:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbiGUQNY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 12:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbiGUQNS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 12:13:18 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66F584ED2;
        Thu, 21 Jul 2022 09:13:16 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LFFbR7027917;
        Thu, 21 Jul 2022 16:13:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=6tTn7Hmiz6+2hgxkforuHWKhlYDlMaJt+RrojxHe+nk=;
 b=ZxtQ8Gp1eqo3H0LlnYGbONj6/Csxi7EowLFF3v49pkXBuAguMy04tgH233GglEaPNA+e
 UFCNIucsCmGLJ+6yuhyPTn27oqZcHa8EOF2To+vpmWFTCHPJYx+LhWIpEEkd6OyLVl0W
 040RUjM+kgoAdcC9BckO1Z4WO8PoyT3VPHx9Md4kBt1Toy578NiabsU5UO209kzJl6gl
 4Lvfmu59BiWG6Sq6tisKDVaPcwso3B74NN1tcooUN8mpvCoh/+a3AWwqdSQUA8vk1ERH
 9SjWZm4PN6ghCJ8TG6O3mtxieBgWSEIp1i6+6MY8c1PffNAxuamF6GmRuS6UGlkOQndS dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf8jsbb7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:15 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LFFrQh029812;
        Thu, 21 Jul 2022 16:13:15 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf8jsbb6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:15 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LG6srR017848;
        Thu, 21 Jul 2022 16:13:13 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3hbmy8y56k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:13 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LGDM9F25362808
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 16:13:22 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F043A405B;
        Thu, 21 Jul 2022 16:13:10 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82A85A4054;
        Thu, 21 Jul 2022 16:13:09 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 16:13:09 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        thuth@redhat.com, david@redhat.com,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Subject: [GIT PULL 10/42] vfio/pci: introduce CONFIG_VFIO_PCI_ZDEV_KVM
Date:   Thu, 21 Jul 2022 18:12:30 +0200
Message-Id: <20220721161302.156182-11-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721161302.156182-1-imbrenda@linux.ibm.com>
References: <20220721161302.156182-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rTjJ__wFzqOD16-L5fkHrKQI-RkV5GZZ
X-Proofpoint-GUID: LaYEzzKMxgpLnUvfsWcC4iHDQDu3ZnVk
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_22,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 priorityscore=1501 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 lowpriorityscore=0
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

The current contents of vfio-pci-zdev are today only useful in a KVM
environment; let's tie everything currently under vfio-pci-zdev to
this Kconfig statement and require KVM in this case, reducing complexity
(e.g. symbol lookups).

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Acked-by: Alex Williamson <alex.williamson@redhat.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Link: https://lore.kernel.org/r/20220606203325.110625-11-mjrosato@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 drivers/vfio/pci/Kconfig      | 11 +++++++++++
 drivers/vfio/pci/Makefile     |  2 +-
 include/linux/vfio_pci_core.h |  2 +-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 4da1914425e1..f9d0c908e738 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -44,6 +44,17 @@ config VFIO_PCI_IGD
 	  To enable Intel IGD assignment through vfio-pci, say Y.
 endif
 
+config VFIO_PCI_ZDEV_KVM
+	bool "VFIO PCI extensions for s390x KVM passthrough"
+	depends on S390 && KVM
+	default y
+	help
+	  Support s390x-specific extensions to enable support for enhancements
+	  to KVM passthrough capabilities, such as interpretive execution of
+	  zPCI instructions.
+
+	  To enable s390x KVM vfio-pci extensions, say Y.
+
 source "drivers/vfio/pci/mlx5/Kconfig"
 
 source "drivers/vfio/pci/hisilicon/Kconfig"
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 7052ebd893e0..24c524224da5 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
 vfio-pci-core-y := vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
-vfio-pci-core-$(CONFIG_S390) += vfio_pci_zdev.o
+vfio-pci-core-$(CONFIG_VFIO_PCI_ZDEV_KVM) += vfio_pci_zdev.o
 obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
 
 vfio-pci-y := vfio_pci.o
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 23c176d4b073..63af2897939c 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -206,7 +206,7 @@ static inline int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
 }
 #endif
 
-#ifdef CONFIG_S390
+#ifdef CONFIG_VFIO_PCI_ZDEV_KVM
 extern int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 				       struct vfio_info_cap *caps);
 #else
-- 
2.36.1

