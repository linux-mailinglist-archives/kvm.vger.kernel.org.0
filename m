Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0FB4D8D0C
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244500AbiCNTuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244565AbiCNTt5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:49:57 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 381523ED3C;
        Mon, 14 Mar 2022 12:48:31 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22EJlUZE021925;
        Mon, 14 Mar 2022 19:48:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=XWBUX3tDB4gHd27/6tNWuEkOWh+/fn/nIkCnoX+m594=;
 b=kjCfJD6wukNLjo3ccRYWqDd5f22fFcfGmgFjQrWOJVPZldh3ro2KTv1xvEF+D2zbMjdz
 j0gv4LNysI3a7+XaBFy5Y761kGb6LHOB9mYbYQJ88NpY6/K+myNAC0Ebx1ixIkjd6Y2d
 S6cAAqEQZtlo8MRxen0XtCYIwXqE14eGIP/CL9yJmwKjQqFnFrDp6a6tzyPpUOfQUQJI
 Lh+2EiMUxUofSE057/JGC4z8Ivf+tNFzms3ys3xYcWXTGgWgISYIvY1ew+/fKSIKocbW
 h8EcTpAcRTPUruHgEQWkk0PlqBunM2YtI+78TkJn7zJcumTCeLGMElxKZS+wC6ntasiE ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6a7153k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:48:12 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22EJlbJB022392;
        Mon, 14 Mar 2022 19:48:12 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6a71531-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:48:12 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22EJlukb010595;
        Mon, 14 Mar 2022 19:48:11 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma03dal.us.ibm.com with ESMTP id 3erk594d00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:48:11 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22EJm9r541550168
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 19:48:09 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8522D112063;
        Mon, 14 Mar 2022 19:48:09 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B80E411206D;
        Mon, 14 Mar 2022 19:47:58 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.184])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Mar 2022 19:47:58 +0000 (GMT)
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
Subject: [PATCH v4 18/32] iommu/s390: add support for IOMMU_DOMAIN_KVM
Date:   Mon, 14 Mar 2022 15:44:37 -0400
Message-Id: <20220314194451.58266-19-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220314194451.58266-1-mjrosato@linux.ibm.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pvsTXi4K_yIjiWbOJKZAxCgYgy2Su9Jx
X-Proofpoint-ORIG-GUID: _Qr9GCMiMkcfqAW7kr13pZdu4ojy24Ks
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_13,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0
 clxscore=1015 suspectscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203140116
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an alternate domain ops for type IOMMU_DOMAIN_KVM.  This type is
intended for use when KVM is managing the IOMMU domain on behalf of a
VM.  Mapping can only be performed once a KVM is registered with the
domain as well as a guest IOTA (address translation anchor).

The map operation is expected to be received in response to an
04 intercept of a guest RPCIT instruction, and will perform a
synchronization operation between the host DMA and guest DMA tables
over the range specified.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/kvm_pci.h |   6 +
 arch/s390/include/asm/pci_dma.h |   3 +
 drivers/iommu/Kconfig           |   8 +
 drivers/iommu/Makefile          |   1 +
 drivers/iommu/s390-iommu.c      |  49 ++--
 drivers/iommu/s390-iommu.h      |  53 ++++
 drivers/iommu/s390-kvm-iommu.c  | 469 ++++++++++++++++++++++++++++++++
 7 files changed, 562 insertions(+), 27 deletions(-)
 create mode 100644 drivers/iommu/s390-iommu.h
 create mode 100644 drivers/iommu/s390-kvm-iommu.c

diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
index ae8669105f72..ebc0da5d9ac1 100644
--- a/arch/s390/include/asm/kvm_pci.h
+++ b/arch/s390/include/asm/kvm_pci.h
@@ -11,6 +11,7 @@
 #define ASM_KVM_PCI_H
 
 #include <linux/types.h>
+#include <linux/iommu.h>
 #include <linux/kvm_types.h>
 #include <linux/kvm_host.h>
 #include <linux/kvm.h>
@@ -19,9 +20,14 @@
 struct kvm_zdev {
 	struct zpci_dev *zdev;
 	struct kvm *kvm;
+	struct iommu_domain *dom; /* Used to invoke IOMMU API for RPCIT */
 };
 
 int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
 void kvm_s390_pci_dev_release(struct zpci_dev *zdev);
 
+int zpci_iommu_attach_kvm(struct zpci_dev *zdev, struct kvm *kvm);
+int zpci_iommu_kvm_assign_iota(struct zpci_dev *zdev, u64 iota);
+int zpci_iommu_kvm_remove_iota(struct zpci_dev *zdev);
+
 #endif /* ASM_KVM_PCI_H */
diff --git a/arch/s390/include/asm/pci_dma.h b/arch/s390/include/asm/pci_dma.h
index 91e63426bdc5..38004e0a4383 100644
--- a/arch/s390/include/asm/pci_dma.h
+++ b/arch/s390/include/asm/pci_dma.h
@@ -50,6 +50,9 @@ enum zpci_ioat_dtype {
 #define ZPCI_TABLE_ALIGN		ZPCI_TABLE_SIZE
 #define ZPCI_TABLE_ENTRY_SIZE		(sizeof(unsigned long))
 #define ZPCI_TABLE_ENTRIES		(ZPCI_TABLE_SIZE / ZPCI_TABLE_ENTRY_SIZE)
+#define ZPCI_TABLE_PAGES		(ZPCI_TABLE_SIZE >> PAGE_SHIFT)
+#define ZPCI_TABLE_ENTRIES_PAGES	(ZPCI_TABLE_ENTRIES * ZPCI_TABLE_PAGES)
+#define ZPCI_TABLE_ENTRIES_PER_PAGE	(ZPCI_TABLE_ENTRIES / ZPCI_TABLE_PAGES)
 
 #define ZPCI_TABLE_BITS			11
 #define ZPCI_PT_BITS			8
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 3eb68fa1b8cc..9637f73925ec 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -411,6 +411,14 @@ config S390_AP_IOMMU
 	  Enables bits of IOMMU API required by VFIO. The iommu_ops
 	  is not implemented as it is not necessary for VFIO.
 
+config S390_KVM_IOMMU
+	bool "S390 KVM IOMMU Support"
+	depends on S390_IOMMU && KVM || COMPILE_TEST
+	select IOMMU_API
+	help
+	  Extends the S390 IOMMU API to support a domain owned and managed by
+	  KVM. This allows KVM to manage nested mappings vs userspace.
+
 config MTK_IOMMU
 	tristate "MediaTek IOMMU Support"
 	depends on ARCH_MEDIATEK || COMPILE_TEST
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index bc7f730edbb0..5476e978d7f5 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_TEGRA_IOMMU_SMMU) += tegra-smmu.o
 obj-$(CONFIG_EXYNOS_IOMMU) += exynos-iommu.o
 obj-$(CONFIG_FSL_PAMU) += fsl_pamu.o fsl_pamu_domain.o
 obj-$(CONFIG_S390_IOMMU) += s390-iommu.o
+obj-$(CONFIG_S390_KVM_IOMMU) += s390-kvm-iommu.o
 obj-$(CONFIG_HYPERV_IOMMU) += hyperv-iommu.o
 obj-$(CONFIG_VIRTIO_IOMMU) += virtio-iommu.o
 obj-$(CONFIG_IOMMU_SVA_LIB) += iommu-sva-lib.o io-pgfault.o
diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
index 73a85c599dc2..0ead37f6e232 100644
--- a/drivers/iommu/s390-iommu.c
+++ b/drivers/iommu/s390-iommu.c
@@ -11,6 +11,7 @@
 #include <linux/iommu-helper.h>
 #include <linux/sizes.h>
 #include <asm/pci_dma.h>
+#include "s390-iommu.h"
 
 /*
  * Physically contiguous memory regions can be mapped with 4 KiB alignment,
@@ -21,24 +22,6 @@
 
 static const struct iommu_ops s390_iommu_ops;
 
-struct s390_domain {
-	struct iommu_domain	domain;
-	struct list_head	devices;
-	unsigned long		*dma_table;
-	spinlock_t		dma_table_lock;
-	spinlock_t		list_lock;
-};
-
-struct s390_domain_device {
-	struct list_head	list;
-	struct zpci_dev		*zdev;
-};
-
-static struct s390_domain *to_s390_domain(struct iommu_domain *dom)
-{
-	return container_of(dom, struct s390_domain, domain);
-}
-
 static bool s390_iommu_capable(enum iommu_cap cap)
 {
 	switch (cap) {
@@ -55,7 +38,12 @@ static struct iommu_domain *s390_domain_alloc(unsigned domain_type)
 {
 	struct s390_domain *s390_domain;
 
-	if (domain_type != IOMMU_DOMAIN_UNMANAGED)
+	if (domain_type != IOMMU_DOMAIN_UNMANAGED &&
+	    domain_type != IOMMU_DOMAIN_KVM)
+		return NULL;
+
+	if (domain_type == IOMMU_DOMAIN_KVM &&
+	    !IS_ENABLED(CONFIG_S390_KVM_IOMMU))
 		return NULL;
 
 	s390_domain = kzalloc(sizeof(*s390_domain), GFP_KERNEL);
@@ -68,23 +56,30 @@ static struct iommu_domain *s390_domain_alloc(unsigned domain_type)
 		return NULL;
 	}
 
+	/* If KVM-managed, swap in alternate ops now */
+	if (IS_ENABLED(CONFIG_S390_KVM_IOMMU) &&
+	    domain_type == IOMMU_DOMAIN_KVM)
+		s390_domain->domain.ops = &s390_kvm_domain_ops;
+
 	spin_lock_init(&s390_domain->dma_table_lock);
 	spin_lock_init(&s390_domain->list_lock);
+	mutex_init(&s390_domain->kvm_dom.ioat_lock);
 	INIT_LIST_HEAD(&s390_domain->devices);
 
 	return &s390_domain->domain;
 }
 
-static void s390_domain_free(struct iommu_domain *domain)
+void s390_domain_free(struct iommu_domain *domain)
 {
 	struct s390_domain *s390_domain = to_s390_domain(domain);
 
 	dma_cleanup_tables(s390_domain->dma_table);
+	mutex_destroy(&s390_domain->kvm_dom.ioat_lock);
 	kfree(s390_domain);
 }
 
-static int s390_iommu_attach_device(struct iommu_domain *domain,
-				    struct device *dev)
+int s390_iommu_attach_device(struct iommu_domain *domain,
+			     struct device *dev)
 {
 	struct s390_domain *s390_domain = to_s390_domain(domain);
 	struct zpci_dev *zdev = to_zpci_dev(dev);
@@ -143,8 +138,8 @@ static int s390_iommu_attach_device(struct iommu_domain *domain,
 	return rc;
 }
 
-static void s390_iommu_detach_device(struct iommu_domain *domain,
-				     struct device *dev)
+void s390_iommu_detach_device(struct iommu_domain *domain,
+			      struct device *dev)
 {
 	struct s390_domain *s390_domain = to_s390_domain(domain);
 	struct zpci_dev *zdev = to_zpci_dev(dev);
@@ -200,7 +195,7 @@ static void s390_iommu_release_device(struct device *dev)
 	if (zdev && zdev->s390_domain) {
 		domain = iommu_get_domain_for_dev(dev);
 		if (domain)
-			s390_iommu_detach_device(domain, dev);
+			domain->ops->detach_dev(domain, dev);
 	}
 }
 
@@ -282,8 +277,8 @@ static int s390_iommu_map(struct iommu_domain *domain, unsigned long iova,
 	return rc;
 }
 
-static phys_addr_t s390_iommu_iova_to_phys(struct iommu_domain *domain,
-					   dma_addr_t iova)
+phys_addr_t s390_iommu_iova_to_phys(struct iommu_domain *domain,
+				    dma_addr_t iova)
 {
 	struct s390_domain *s390_domain = to_s390_domain(domain);
 	unsigned long *sto, *pto, *rto, flags;
diff --git a/drivers/iommu/s390-iommu.h b/drivers/iommu/s390-iommu.h
new file mode 100644
index 000000000000..21c8243a36b1
--- /dev/null
+++ b/drivers/iommu/s390-iommu.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * IOMMU API for s390 PCI devices
+ *
+ * Copyright IBM Corp. 2022
+ * Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
+ */
+
+#ifndef _S390_IOMMU_H
+#define _S390_IOMMU_H
+
+#include <linux/iommu.h>
+#include <linux/kvm_host.h>
+
+extern const struct iommu_domain_ops s390_kvm_domain_ops;
+
+struct s390_kvm_domain {
+	struct kvm		*kvm;
+	unsigned long		*head[ZPCI_TABLE_PAGES];
+	unsigned long		**seg;
+	unsigned long		***pt;
+	struct page *(*pin)(struct kvm *kvm, gfn_t gfn);
+	void (*unpin)(kvm_pfn_t pfn);
+	struct mutex		ioat_lock;
+	bool			map_enabled;
+};
+
+struct s390_domain {
+	struct iommu_domain	domain;
+	struct list_head	devices;
+	unsigned long		*dma_table;
+	spinlock_t		dma_table_lock;
+	spinlock_t		list_lock;
+	struct s390_kvm_domain	kvm_dom;
+};
+
+struct s390_domain_device {
+	struct list_head	list;
+	struct zpci_dev		*zdev;
+};
+
+static inline struct s390_domain *to_s390_domain(struct iommu_domain *dom)
+{
+	return container_of(dom, struct s390_domain, domain);
+}
+
+void s390_domain_free(struct iommu_domain *domain);
+int s390_iommu_attach_device(struct iommu_domain *domain, struct device *dev);
+void s390_iommu_detach_device(struct iommu_domain *domain, struct device *dev);
+phys_addr_t s390_iommu_iova_to_phys(struct iommu_domain *domain,
+				    dma_addr_t iova);
+
+#endif /* _S390_IOMMU_H */
diff --git a/drivers/iommu/s390-kvm-iommu.c b/drivers/iommu/s390-kvm-iommu.c
new file mode 100644
index 000000000000..d24e6904d5f8
--- /dev/null
+++ b/drivers/iommu/s390-kvm-iommu.c
@@ -0,0 +1,469 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * IOMMU API domain ops for s390 PCI devices using KVM passthrough
+ *
+ * Copyright IBM Corp. 2022
+ * Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
+ */
+
+#include <linux/pci.h>
+#include <linux/iommu.h>
+#include <linux/iommu-helper.h>
+#include <linux/sizes.h>
+#include <linux/kvm_host.h>
+#include <asm/kvm_pci.h>
+#include <asm/pci_dma.h>
+#include "s390-iommu.h"
+
+const struct iommu_domain_ops s390_kvm_domain_ops;
+
+static int dma_shadow_cpu_trans(struct s390_kvm_domain *kvm_dom,
+				unsigned long *entry, unsigned long *gentry)
+{
+	phys_addr_t gaddr = 0;
+	unsigned long idx;
+	struct page *page;
+	kvm_pfn_t pfn;
+	gpa_t addr;
+	int rc = 0;
+
+	if (pt_entry_isvalid(*gentry)) {
+		/* pin and validate */
+		addr = *gentry & ZPCI_PTE_ADDR_MASK;
+		idx = srcu_read_lock(&kvm_dom->kvm->srcu);
+		page = kvm_dom->pin(kvm_dom->kvm, gpa_to_gfn(addr));
+		srcu_read_unlock(&kvm_dom->kvm->srcu, idx);
+		if (is_error_page(page))
+			return -EIO;
+		gaddr = page_to_phys(page) + (addr & ~PAGE_MASK);
+	}
+
+	if (pt_entry_isvalid(*entry)) {
+		/* Either we are invalidating, replacing or no-op */
+		if (gaddr != 0) {
+			if ((*entry & ZPCI_PTE_ADDR_MASK) == gaddr) {
+				/* Duplicate */
+				kvm_dom->unpin(*entry >> PAGE_SHIFT);
+			} else {
+				/* Replace */
+				pfn = (*entry >> PAGE_SHIFT);
+				invalidate_pt_entry(entry);
+				set_pt_pfaa(entry, gaddr);
+				validate_pt_entry(entry);
+				kvm_dom->unpin(pfn);
+				rc = 1;
+			}
+		} else {
+			/* Invalidate */
+			pfn = (*entry >> PAGE_SHIFT);
+			invalidate_pt_entry(entry);
+			kvm_dom->unpin(pfn);
+			rc = 1;
+		}
+	} else if (gaddr != 0) {
+		/* New Entry */
+		set_pt_pfaa(entry, gaddr);
+		validate_pt_entry(entry);
+	}
+
+	return rc;
+}
+
+static unsigned long *dma_walk_guest_cpu_trans(struct s390_kvm_domain *kvm_dom,
+					       dma_addr_t dma_addr)
+{
+	unsigned long *rto, *sto, *pto;
+	unsigned int rtx, rts, sx, px, idx;
+	struct page *page;
+	gpa_t addr;
+	int i;
+
+	/* Pin guest segment table if needed */
+	rtx = calc_rtx(dma_addr);
+	rto = kvm_dom->head[(rtx / ZPCI_TABLE_ENTRIES_PER_PAGE)];
+	rts = rtx * ZPCI_TABLE_PAGES;
+	if (!kvm_dom->seg[rts]) {
+		if (!reg_entry_isvalid(rto[rtx % ZPCI_TABLE_ENTRIES_PER_PAGE]))
+			return NULL;
+		sto = get_rt_sto(rto[rtx % ZPCI_TABLE_ENTRIES_PER_PAGE]);
+		addr = ((u64)sto & ZPCI_RTE_ADDR_MASK);
+		idx = srcu_read_lock(&kvm_dom->kvm->srcu);
+		for (i = 0; i < ZPCI_TABLE_PAGES; i++) {
+			page = kvm_dom->pin(kvm_dom->kvm, gpa_to_gfn(addr));
+			if (is_error_page(page)) {
+				srcu_read_unlock(&kvm_dom->kvm->srcu, idx);
+				return NULL;
+			}
+			kvm_dom->seg[rts + i] = (page_to_virt(page) +
+						 (addr & ~PAGE_MASK));
+			addr += PAGE_SIZE;
+		}
+		srcu_read_unlock(&kvm_dom->kvm->srcu, idx);
+	}
+
+	/* Allocate pin pointers for another segment table if needed */
+	if (!kvm_dom->pt[rtx]) {
+		kvm_dom->pt[rtx] = kcalloc(ZPCI_TABLE_ENTRIES,
+					   (sizeof(unsigned long *)),
+					   GFP_KERNEL);
+		if (!kvm_dom->pt[rtx])
+			return NULL;
+	}
+	/* Pin guest page table if needed */
+	sx = calc_sx(dma_addr);
+	sto = kvm_dom->seg[(rts + (sx / ZPCI_TABLE_ENTRIES_PER_PAGE))];
+	if (!kvm_dom->pt[rtx][sx]) {
+		if (!reg_entry_isvalid(sto[sx % ZPCI_TABLE_ENTRIES_PER_PAGE]))
+			return NULL;
+		pto = get_st_pto(sto[sx % ZPCI_TABLE_ENTRIES_PER_PAGE]);
+		if (!pto)
+			return NULL;
+		addr = ((u64)pto & ZPCI_STE_ADDR_MASK);
+		idx = srcu_read_lock(&kvm_dom->kvm->srcu);
+		page = kvm_dom->pin(kvm_dom->kvm, gpa_to_gfn(addr));
+		srcu_read_unlock(&kvm_dom->kvm->srcu, idx);
+		if (is_error_page(page))
+			return NULL;
+		kvm_dom->pt[rtx][sx] = page_to_virt(page) + (addr & ~PAGE_MASK);
+	}
+	pto = kvm_dom->pt[rtx][sx];
+
+	/* Return guest PTE */
+	px = calc_px(dma_addr);
+	return &pto[px];
+}
+
+static int dma_table_shadow(struct s390_domain *s390_domain,
+			    dma_addr_t dma_addr, size_t nr_pages,
+			    size_t *mapped_pages)
+{
+	struct s390_kvm_domain *kvm_dom = &s390_domain->kvm_dom;
+	unsigned long *entry, *gentry;
+	int rc = 0, rc2;
+
+	for (*mapped_pages = 0; *mapped_pages < nr_pages; (*mapped_pages)++) {
+		gentry = dma_walk_guest_cpu_trans(kvm_dom, dma_addr);
+		if (!gentry)
+			continue;
+		entry = dma_walk_cpu_trans(s390_domain->dma_table, dma_addr);
+
+		if (!entry)
+			return -ENOMEM;
+
+		rc2 = dma_shadow_cpu_trans(kvm_dom, entry, gentry);
+		if (rc2 < 0)
+			return -EIO;
+
+		dma_addr += PAGE_SIZE;
+		rc += rc2;
+	}
+
+	return rc;
+}
+
+static int s390_kvm_iommu_update_trans(struct s390_domain *s390_domain,
+				       dma_addr_t dma_addr, size_t nr_pages,
+				       size_t *mapped)
+{
+	struct s390_domain_device *domain_device;
+	unsigned long irq_flags;
+	size_t mapped_pages;
+	int rc = 0;
+	u8 status;
+
+	mutex_lock(&s390_domain->kvm_dom.ioat_lock);
+	rc = dma_table_shadow(s390_domain, dma_addr, nr_pages, &mapped_pages);
+
+	/* If error or no new mappings, leave immediately without refresh */
+	if (rc <= 0)
+		goto exit;
+
+	spin_lock_irqsave(&s390_domain->list_lock, irq_flags);
+	list_for_each_entry(domain_device, &s390_domain->devices, list) {
+		rc = zpci_refresh_trans((u64) domain_device->zdev->fh << 32,
+					dma_addr, nr_pages * PAGE_SIZE,
+					&status);
+		if (rc) {
+			if (status == 0)
+				rc = -EINVAL;
+			else
+				rc = -EIO;
+		}
+	}
+	spin_unlock_irqrestore(&s390_domain->list_lock, irq_flags);
+
+exit:
+	if (mapped)
+		*mapped = mapped_pages << PAGE_SHIFT;
+
+	mutex_unlock(&s390_domain->kvm_dom.ioat_lock);
+	return rc;
+}
+
+static int s390_kvm_iommu_map(struct iommu_domain *domain, unsigned long iova,
+			      phys_addr_t paddr, size_t size, int prot,
+			      gfp_t gfp)
+{
+	struct s390_domain *s390_domain = to_s390_domain(domain);
+	size_t nr_pages;
+
+	int rc = 0;
+
+	if (!(prot & (IOMMU_READ | IOMMU_WRITE)))
+		return -EINVAL;
+
+	/* Can only perform mapping when a guest IOTA is registered */
+	if (!s390_domain->kvm_dom.map_enabled)
+		return -EINVAL;
+
+	nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
+	if (!nr_pages)
+		return -EINVAL;
+
+	rc = s390_kvm_iommu_update_trans(s390_domain, iova, nr_pages, NULL);
+
+	return rc;
+}
+
+static int s390_kvm_iommu_map_pages(struct iommu_domain *domain,
+				    unsigned long iova, phys_addr_t paddr,
+				    size_t pgsize, size_t pgcount, int prot,
+				    gfp_t gfp, size_t *mapped)
+{
+	struct s390_domain *s390_domain = to_s390_domain(domain);
+	size_t nr_pages;
+
+	int rc = 0;
+
+	if (!(prot & (IOMMU_READ | IOMMU_WRITE)))
+		return -EINVAL;
+
+	/* Can only perform mapping when a guest IOTA is registered */
+	if (!s390_domain->kvm_dom.map_enabled)
+		return -EINVAL;
+
+	nr_pages = pgcount * (pgsize / PAGE_SIZE);
+	if (!nr_pages)
+		return -EINVAL;
+
+	rc = s390_kvm_iommu_update_trans(s390_domain, iova, nr_pages, mapped);
+
+	return rc;
+}
+
+static void free_pt_entry(struct s390_kvm_domain *kvm_dom, int st, int pt)
+{
+	if (!kvm_dom->pt[st][pt])
+		return;
+
+	kvm_dom->unpin((u64)kvm_dom->pt[st][pt]);
+}
+
+static void free_seg_entry(struct s390_kvm_domain *kvm_dom, int entry)
+{
+	int i, st, count = 0;
+
+	for (i = 0; i < ZPCI_TABLE_PAGES; i++) {
+		if (kvm_dom->seg[entry + i]) {
+			kvm_dom->unpin((u64)kvm_dom->seg[entry + i]);
+			count++;
+		}
+	}
+
+	if (count == 0)
+		return;
+
+	st = entry / ZPCI_TABLE_PAGES;
+	for (i = 0; i < ZPCI_TABLE_ENTRIES; i++)
+		free_pt_entry(kvm_dom, st, i);
+	kfree(kvm_dom->pt[st]);
+}
+
+static int s390_kvm_clear_ioat_tables(struct s390_domain *s390_domain)
+{
+	struct s390_kvm_domain *kvm_dom = &s390_domain->kvm_dom;
+	unsigned long *entry;
+	dma_addr_t dma_addr;
+	kvm_pfn_t pfn;
+	int i;
+
+	if (!kvm_dom->kvm || !kvm_dom->map_enabled)
+		return -EINVAL;
+
+	mutex_lock(&s390_domain->kvm_dom.ioat_lock);
+
+	/* Invalidate and unpin remaining guest pages */
+	for (dma_addr = s390_domain->domain.geometry.aperture_start;
+	     dma_addr < s390_domain->domain.geometry.aperture_end;
+	     dma_addr += PAGE_SIZE) {
+		entry = dma_walk_cpu_trans(s390_domain->dma_table, dma_addr);
+		if (entry && pt_entry_isvalid(*entry)) {
+			pfn = (*entry >> PAGE_SHIFT);
+			invalidate_pt_entry(entry);
+			kvm_dom->unpin(pfn);
+		}
+	}
+
+	/* Unpin all shadow tables */
+	for (i = 0; i < ZPCI_TABLE_PAGES; i++) {
+		kvm_dom->unpin((u64)kvm_dom->head[i] >> PAGE_SHIFT);
+		kvm_dom->head[i] = 0;
+	}
+
+	for (i = 0; i < ZPCI_TABLE_ENTRIES_PAGES; i += ZPCI_TABLE_PAGES)
+		free_seg_entry(kvm_dom, i);
+
+	kfree(kvm_dom->seg);
+	kfree(kvm_dom->pt);
+
+	mutex_unlock(&s390_domain->kvm_dom.ioat_lock);
+
+	kvm_dom->map_enabled = false;
+
+	return 0;
+}
+
+static void s390_kvm_domain_free(struct iommu_domain *domain)
+{
+	struct s390_domain *s390_domain = to_s390_domain(domain);
+
+	s390_kvm_clear_ioat_tables(s390_domain);
+
+	if (s390_domain->kvm_dom.kvm) {
+		symbol_put(gfn_to_page);
+		symbol_put(kvm_release_pfn_dirty);
+	}
+
+	s390_domain_free(domain);
+}
+
+int zpci_iommu_attach_kvm(struct zpci_dev *zdev, struct kvm *kvm)
+{
+	struct s390_domain *s390_domain = zdev->s390_domain;
+	struct iommu_domain *domain = &s390_domain->domain;
+	struct s390_domain_device *domain_device;
+	unsigned long flags;
+	int rc = 0;
+
+	if (domain->type != IOMMU_DOMAIN_KVM)
+		return -EINVAL;
+
+	if (s390_domain->kvm_dom.kvm != 0)
+		return -EINVAL;
+
+	spin_lock_irqsave(&s390_domain->list_lock, flags);
+	list_for_each_entry(domain_device, &s390_domain->devices, list) {
+		if (domain_device->zdev->kzdev->kvm != kvm) {
+			rc = -EINVAL;
+			break;
+		}
+		domain_device->zdev->kzdev->dom = domain;
+	}
+	spin_unlock_irqrestore(&s390_domain->list_lock, flags);
+
+	if (rc)
+		return rc;
+
+	s390_domain->kvm_dom.pin = symbol_get(gfn_to_page);
+	if (!s390_domain->kvm_dom.pin)
+		return -EINVAL;
+
+	s390_domain->kvm_dom.unpin = symbol_get(kvm_release_pfn_dirty);
+	if (!s390_domain->kvm_dom.unpin) {
+		symbol_put(gfn_to_page);
+		return -EINVAL;
+	}
+
+	s390_domain->kvm_dom.kvm = kvm;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(zpci_iommu_attach_kvm);
+
+int zpci_iommu_kvm_assign_iota(struct zpci_dev *zdev, u64 iota)
+{
+	struct s390_domain *s390_domain = zdev->s390_domain;
+	struct s390_kvm_domain *kvm_dom = &s390_domain->kvm_dom;
+	gpa_t gpa = (gpa_t)(iota & ZPCI_RTE_ADDR_MASK);
+	struct page *page;
+	struct kvm *kvm;
+	unsigned int idx;
+	void *iaddr;
+	int i, rc;
+
+	/* Ensure KVM associated and IOTA not already registered */
+	if (!kvm_dom->kvm || kvm_dom->map_enabled)
+		return -EINVAL;
+
+	/* Ensure supported type specified */
+	if ((iota & ZPCI_IOTA_RTTO_FLAG) != ZPCI_IOTA_RTTO_FLAG)
+		return -EINVAL;
+
+	kvm = kvm_dom->kvm;
+	mutex_lock(&s390_domain->kvm_dom.ioat_lock);
+	idx = srcu_read_lock(&kvm->srcu);
+	for (i = 0; i < ZPCI_TABLE_PAGES; i++) {
+		page = kvm_dom->pin(kvm, gpa_to_gfn(gpa));
+		if (is_error_page(page)) {
+			srcu_read_unlock(&kvm->srcu, idx);
+			rc = -EIO;
+			goto unpin;
+		}
+		iaddr = page_to_virt(page) + (gpa & ~PAGE_MASK);
+		kvm_dom->head[i] = (unsigned long *)iaddr;
+		gpa += PAGE_SIZE;
+	}
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	kvm_dom->seg = kcalloc(ZPCI_TABLE_ENTRIES_PAGES,
+			       sizeof(unsigned long *), GFP_KERNEL);
+	if (!kvm_dom->seg)
+		goto unpin;
+	kvm_dom->pt = kcalloc(ZPCI_TABLE_ENTRIES, sizeof(unsigned long **),
+			      GFP_KERNEL);
+	if (!kvm_dom->pt)
+		goto free_seg;
+
+	mutex_unlock(&s390_domain->kvm_dom.ioat_lock);
+	kvm_dom->map_enabled = true;
+	return 0;
+
+free_seg:
+	kfree(kvm_dom->seg);
+	rc = -ENOMEM;
+unpin:
+	for (i = 0; i < ZPCI_TABLE_PAGES; i++) {
+		kvm_dom->unpin((u64)kvm_dom->head[i] >> PAGE_SHIFT);
+		kvm_dom->head[i] = 0;
+	}
+	mutex_unlock(&s390_domain->kvm_dom.ioat_lock);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(zpci_iommu_kvm_assign_iota);
+
+int zpci_iommu_kvm_remove_iota(struct zpci_dev *zdev)
+{
+	struct s390_domain *s390_domain = zdev->s390_domain;
+
+	return s390_kvm_clear_ioat_tables(s390_domain);
+}
+EXPORT_SYMBOL_GPL(zpci_iommu_kvm_remove_iota);
+
+const struct iommu_domain_ops s390_kvm_domain_ops = {
+	.attach_dev	= s390_iommu_attach_device,
+	.detach_dev	= s390_iommu_detach_device,
+	/*
+	 * All iommu mapping and unmapping operations are handled via the map
+	 * ops.  A map over a given range will synchronize the host and guest
+	 * DMA tables, performing the necessary mappings / unmappings to
+	 * synchronize the table states.
+	 * Partial mapping failures do not require a rewind, the guest will
+	 * receive an indication that will trigger a global refresh of the
+	 * tables.
+	 */
+	.map		= s390_kvm_iommu_map,
+	.map_pages	= s390_kvm_iommu_map_pages,
+	.unmap		= NULL,
+	.unmap_pages	= NULL,
+	.iova_to_phys	= s390_iommu_iova_to_phys,
+	.free		= s390_kvm_domain_free,
+};
-- 
2.27.0

