Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073155963B0
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 22:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236984AbiHPUYD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 16:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiHPUYC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 16:24:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207274BD30;
        Tue, 16 Aug 2022 13:24:01 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27GKH2FP004357;
        Tue, 16 Aug 2022 20:23:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=EvcBurXOXaiaLUlkvNdLUiPP49PF3Z+Z73Ky8mIwjVg=;
 b=I7lJVvj1sZTB7ItlNu9zCE29ABRkh/YydyM5WyN8PURfWptfh+LgS43xVWylYyV5JZq+
 WbHUcxdYtgWge7w+L8S2BSt/TkyT0w8QSEXz6ZMTN9cHHEIic5fUN5VKBJDTUFw4Pjr/
 OeZQTRefVPo0d6LMqEY0bSKhxx0sdgyAIJ6CWLnof4KT4ah06+kZzlBgMyxX8kX3wpH6
 7klTt4zwUKDqt5eXdX4/+HIqTX0WDFfnxdMJ2SacgEq4Vu7nwO2R9zd60sUNbytmfCxR
 f8Ku/TDX807K0iV0J2Y4K0C527EnBjEZ1yhXpqtiNMDI7XsfT/K7h+0zB7uygmJDV3WA JQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j0j4w841y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 20:23:55 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27GKKNr3009498;
        Tue, 16 Aug 2022 20:23:54 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3hx3k8umc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 20:23:53 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27GKNo4e33816864
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Aug 2022 20:23:50 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92E1B42041;
        Tue, 16 Aug 2022 20:23:50 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2923C4203F;
        Tue, 16 Aug 2022 20:23:50 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.18.167])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 16 Aug 2022 20:23:50 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     mjrosato@linux.ibm.com
Cc:     rdunlap@infradead.org, linux-kernel@vger.kernel.org, lkp@intel.com,
        borntraeger@linux.ibm.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: s390: pci: VFIO_PCI ZDEV configuration fix
Date:   Tue, 16 Aug 2022 22:28:55 +0200
Message-Id: <20220816202855.189410-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <1f2dd65e-b79b-44df-cc6a-8b3aa8fd61af@linux.ibm.com>
References: <1f2dd65e-b79b-44df-cc6a-8b3aa8fd61af@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4rhapsDdV8JAp6gwFhmUDKkeNpJFiEmQ
X-Proofpoint-GUID: 4rhapsDdV8JAp6gwFhmUDKkeNpJFiEmQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_08,2022-08-16_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 mlxscore=0 mlxlogscore=890 phishscore=0 spamscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208160074
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixing configuration for VFIO PCI interpretation.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Fixes: 09340b2fca007 ("KVM: s390: pci: add routines to start/stop inter..")
Fixes: c435c54639aa5 ("vfio/pci: introduce CONFIG_VFIO_PCI_ZDEV_KVM..")
Cc: <stable@vger.kernel.org>
---
 arch/s390/include/asm/kvm_host.h | 9 ---------
 arch/s390/kvm/Makefile           | 2 +-
 arch/s390/kvm/pci.c              | 4 ++--
 drivers/vfio/pci/Kconfig         | 4 ++--
 include/linux/vfio_pci_core.h    | 2 +-
 5 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index f39092e0ceaa..f6cf961731af 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -1038,16 +1038,7 @@ static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 #define __KVM_HAVE_ARCH_VM_FREE
 void kvm_arch_free_vm(struct kvm *kvm);
 
-#ifdef CONFIG_VFIO_PCI_ZDEV_KVM
 int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm);
 void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev);
-#else
-static inline int kvm_s390_pci_register_kvm(struct zpci_dev *dev,
-					    struct kvm *kvm)
-{
-	return -EPERM;
-}
-static inline void kvm_s390_pci_unregister_kvm(struct zpci_dev *dev) {}
-#endif
 
 #endif
diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
index 02217fb4ae10..be36afcfd6ff 100644
--- a/arch/s390/kvm/Makefile
+++ b/arch/s390/kvm/Makefile
@@ -9,6 +9,6 @@ ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
 
 kvm-y += kvm-s390.o intercept.o interrupt.o priv.o sigp.o
 kvm-y += diag.o gaccess.o guestdbg.o vsie.o pv.o
+kvm-y += pci.o
 
-kvm-$(CONFIG_VFIO_PCI_ZDEV_KVM) += pci.o
 obj-$(CONFIG_KVM) += kvm.o
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index 4946fb7757d6..cf8ab72a2109 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -435,7 +435,7 @@ int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm)
 {
 	int rc;
 
-	if (!zdev)
+	if (!IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM) || !zdev)
 		return -EINVAL;
 
 	mutex_lock(&zdev->kzdev_lock);
@@ -516,7 +516,7 @@ void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev)
 {
 	struct kvm *kvm;
 
-	if (!zdev)
+	if (!IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM) || !zdev)
 		return;
 
 	mutex_lock(&zdev->kzdev_lock);
diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index f9d0c908e738..bbc375b028ef 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -45,9 +45,9 @@ config VFIO_PCI_IGD
 endif
 
 config VFIO_PCI_ZDEV_KVM
-	bool "VFIO PCI extensions for s390x KVM passthrough"
+	def_tristate y
+	prompt "VFIO PCI extensions for s390x KVM passthrough"
 	depends on S390 && KVM
-	default y
 	help
 	  Support s390x-specific extensions to enable support for enhancements
 	  to KVM passthrough capabilities, such as interpretive execution of
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 5579ece4347b..7db3bb8129b1 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -205,7 +205,7 @@ static inline int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
 }
 #endif
 
-#ifdef CONFIG_VFIO_PCI_ZDEV_KVM
+#if IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM)
 int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 				struct vfio_info_cap *caps);
 int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev);
-- 
2.31.1

