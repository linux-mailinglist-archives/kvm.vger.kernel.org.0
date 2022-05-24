Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 840355330EC
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 21:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240673AbiEXS77 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 14:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240624AbiEXS74 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 14:59:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B658666BA;
        Tue, 24 May 2022 11:59:43 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OIolSJ025033;
        Tue, 24 May 2022 18:59:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=gPdw+HIe4uwlvu7l42Qfo+SMYfiBSx6LSxFAJ4yI/D4=;
 b=Qu6R0mIWmIJrQ2VaexmL57Fta1L+AbF94vOoSt8C3LFjm/c/7j5/ab+eQx07o7K3sNkM
 15IyHAy//5BeotXSRmPirqipGPvL36rrfm39IFUG2FxmUI1RzRxoOHuyaBbAbKHfZKWD
 aWPtw8ra2lS19I4bmdSAzusIWZDB6c6TywCBjJkU88uM+tv4VeOtTnJgkYjbgD/ho6iL
 o2UPh0L3h6keUzrA09wsMnVhLt7/68wQZiLz4ApkMOghRjz8y6x4GmX91drLIj/A0iBa
 fbTSFx4vB6eBWM4bt2zJkq2nTB3MPlr2PQL9t0F8G0CGz00IqX86D25X5Xkcjp7r/M93 VA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g950g04uf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:59:40 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24OIp14x025655;
        Tue, 24 May 2022 18:59:39 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g950g04u5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:59:39 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24OIr7AK012297;
        Tue, 24 May 2022 18:59:38 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma05wdc.us.ibm.com with ESMTP id 3g93vb8hmp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:59:38 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24OIxbxH23986678
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 18:59:37 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31403BE056;
        Tue, 24 May 2022 18:59:37 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1CCEFBE051;
        Tue, 24 May 2022 18:59:35 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.163.3.233])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 24 May 2022 18:59:35 +0000 (GMT)
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
Subject: [PATCH v8 10/22] vfio/pci: introduce CONFIG_VFIO_PCI_ZDEV_KVM
Date:   Tue, 24 May 2022 14:58:55 -0400
Message-Id: <20220524185907.140285-11-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220524185907.140285-1-mjrosato@linux.ibm.com>
References: <20220524185907.140285-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ICywi9DXak33jw6EvoehTin15FK_tMV-
X-Proofpoint-GUID: POzwLmC7qE2-oO0tS8wf2XY2UB0CJ4dl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_09,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 suspectscore=0 bulkscore=0 malwarescore=0 adultscore=0
 spamscore=0 impostorscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205240090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current contents of vfio-pci-zdev are today only useful in a KVM
environment; let's tie everything currently under vfio-pci-zdev to
this Kconfig statement and require KVM in this case, reducing complexity
(e.g. symbol lookups).

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
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
2.27.0

