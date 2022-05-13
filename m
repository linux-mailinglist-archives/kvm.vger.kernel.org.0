Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD60526A13
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 21:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383661AbiEMTRD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 15:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383716AbiEMTQy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 15:16:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26FAA3AA63;
        Fri, 13 May 2022 12:16:30 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24DIVejf006174;
        Fri, 13 May 2022 19:16:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=bcIkHDDE9CBTib8HklU9WPUB3i95RCiMuxJRFaOB9go=;
 b=hBOBFNC5AKudImfp2MAt0kdY+lInbvgTNSRSNQPfcBaWqGCcuUhRUw9Oayoxktgnpkxk
 z3XRQ5xRyRHfvA83jZpnZLWa7pNDYxtqjXf/6wxCpx4u0gCcA2KY8B1E/OYZOVBxqLWq
 F75o/e5EJmUnpoY9lFvlw+U3lj8zuMU5h/cgWsBRsOb/gj0H34O21r9SMCI47V0NBwFw
 O5G5eNQAY+mJpJPu5DlxQPaJxVCAKPgfJ6kSUPlbaZOovSVlGU5r3qFE6o32yCExURtd
 IPYbq4iXq84mUeTfJOzQ1bxVYcb6IPp0uGv8wtykiFDtxfLenCPJtY9fy4PhlzYne3aw 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1vpgrs9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 19:16:27 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24DIWLPA007644;
        Fri, 13 May 2022 19:16:27 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1vpgrs9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 19:16:27 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24DJDHQU015065;
        Fri, 13 May 2022 19:16:25 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03wdc.us.ibm.com with ESMTP id 3fwgda4dvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 19:16:25 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24DJGPlB26935634
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 May 2022 19:16:25 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1BC7124054;
        Fri, 13 May 2022 19:16:24 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88074124053;
        Fri, 13 May 2022 19:16:20 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.49.28])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 13 May 2022 19:16:20 +0000 (GMT)
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
Subject: [PATCH v7 12/22] KVM: s390: pci: do initial setup for AEN interpretation
Date:   Fri, 13 May 2022 15:14:59 -0400
Message-Id: <20220513191509.272897-13-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220513191509.272897-1-mjrosato@linux.ibm.com>
References: <20220513191509.272897-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FGoI6OBxI6n2Zea0OSbRoNxayOoPRjCX
X-Proofpoint-ORIG-GUID: qFlgKHd-nt5SnoBaTp0HBYD-IZ2pNRNi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_11,2022-05-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 bulkscore=0 impostorscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205130077
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Initial setup for Adapter Event Notification Interpretation for zPCI
passthrough devices.  Specifically, allocate a structure for forwarding of
adapter events and pass the address of this structure to firmware.

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/pci.h      |   4 +
 arch/s390/include/asm/pci_insn.h |  12 +++
 arch/s390/kvm/interrupt.c        |  14 +++
 arch/s390/kvm/kvm-s390.c         |  11 +++
 arch/s390/kvm/pci.c              | 160 +++++++++++++++++++++++++++++++
 arch/s390/kvm/pci.h              |  49 ++++++++++
 arch/s390/pci/pci.c              |   6 ++
 7 files changed, 256 insertions(+)

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index 50f1851edfbe..322060a75d9f 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -9,6 +9,7 @@
 #include <asm-generic/pci.h>
 #include <asm/pci_clp.h>
 #include <asm/pci_debug.h>
+#include <asm/pci_insn.h>
 #include <asm/sclp.h>
 
 #define PCIBIOS_MIN_IO		0x1000
@@ -204,6 +205,9 @@ extern const struct attribute_group *zpci_attr_groups[];
 extern unsigned int s390_pci_force_floating __initdata;
 extern unsigned int s390_pci_no_rid;
 
+extern union zpci_sic_iib *zpci_aipb;
+extern struct airq_iv *zpci_aif_sbv;
+
 /* -----------------------------------------------------------------------------
   Prototypes
 ----------------------------------------------------------------------------- */
diff --git a/arch/s390/include/asm/pci_insn.h b/arch/s390/include/asm/pci_insn.h
index 5331082fa516..e5f57cfe1d45 100644
--- a/arch/s390/include/asm/pci_insn.h
+++ b/arch/s390/include/asm/pci_insn.h
@@ -101,6 +101,7 @@ struct zpci_fib {
 /* Set Interruption Controls Operation Controls  */
 #define	SIC_IRQ_MODE_ALL		0
 #define	SIC_IRQ_MODE_SINGLE		1
+#define	SIC_SET_AENI_CONTROLS		2
 #define	SIC_IRQ_MODE_DIRECT		4
 #define	SIC_IRQ_MODE_D_ALL		16
 #define	SIC_IRQ_MODE_D_SINGLE		17
@@ -127,9 +128,20 @@ struct zpci_cdiib {
 	u64 : 64;
 } __packed __aligned(8);
 
+/* adapter interruption parameters block */
+struct zpci_aipb {
+	u64 faisb;
+	u64 gait;
+	u16 : 13;
+	u16 afi : 3;
+	u32 : 32;
+	u16 faal;
+} __packed __aligned(8);
+
 union zpci_sic_iib {
 	struct zpci_diib diib;
 	struct zpci_cdiib cdiib;
+	struct zpci_aipb aipb;
 };
 
 DECLARE_STATIC_KEY_FALSE(have_mio);
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 17ff475157d8..37ff4358121a 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -32,6 +32,7 @@
 #include "kvm-s390.h"
 #include "gaccess.h"
 #include "trace-s390.h"
+#include "pci.h"
 
 #define PFAULT_INIT 0x0600
 #define PFAULT_DONE 0x0680
@@ -3328,6 +3329,11 @@ void kvm_s390_gib_destroy(void)
 {
 	if (!gib)
 		return;
+	if (kvm_s390_pci_interp_allowed() && aift) {
+		mutex_lock(&aift->aift_lock);
+		kvm_s390_pci_aen_exit();
+		mutex_unlock(&aift->aift_lock);
+	}
 	chsc_sgib(0);
 	unregister_adapter_interrupt(&gib_alert_irq);
 	free_page((unsigned long)gib);
@@ -3365,6 +3371,14 @@ int kvm_s390_gib_init(u8 nisc)
 		goto out_unreg_gal;
 	}
 
+	if (kvm_s390_pci_interp_allowed()) {
+		if (kvm_s390_pci_aen_init(nisc)) {
+			pr_err("Initializing AEN for PCI failed\n");
+			rc = -EIO;
+			goto out_unreg_gal;
+		}
+	}
+
 	KVM_EVENT(3, "gib 0x%pK (nisc=%d) initialized", gib, gib->nisc);
 	goto out;
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 76ad6408cb2c..efc0d8e22308 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -47,6 +47,7 @@
 #include <asm/fpu/api.h>
 #include "kvm-s390.h"
 #include "gaccess.h"
+#include "pci.h"
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
@@ -502,6 +503,14 @@ int kvm_arch_init(void *opaque)
 		goto out;
 	}
 
+	if (kvm_s390_pci_interp_allowed()) {
+		rc = kvm_s390_pci_init();
+		if (rc) {
+			pr_err("Unable to allocate AIFT for PCI\n");
+			goto out;
+		}
+	}
+
 	rc = kvm_s390_gib_init(GAL_ISC);
 	if (rc)
 		goto out;
@@ -516,6 +525,8 @@ int kvm_arch_init(void *opaque)
 void kvm_arch_exit(void)
 {
 	kvm_s390_gib_destroy();
+	if (kvm_s390_pci_interp_allowed())
+		kvm_s390_pci_exit();
 	debug_unregister(kvm_s390_dbf);
 	debug_unregister(kvm_s390_dbf_uv);
 }
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index 21c2be5c2713..268cbe99fbac 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -9,8 +9,149 @@
 
 #include <linux/kvm_host.h>
 #include <linux/pci.h>
+#include <asm/pci.h>
+#include <asm/pci_insn.h>
 #include "pci.h"
 
+struct zpci_aift *aift;
+
+static inline int __set_irq_noiib(u16 ctl, u8 isc)
+{
+	union zpci_sic_iib iib = {{0}};
+
+	return zpci_set_irq_ctrl(ctl, isc, &iib);
+}
+
+void kvm_s390_pci_aen_exit(void)
+{
+	unsigned long flags;
+	struct kvm_zdev **gait_kzdev;
+
+	lockdep_assert_held(&aift->aift_lock);
+
+	/*
+	 * Contents of the aipb remain registered for the life of the host
+	 * kernel, the information preserved in zpci_aipb and zpci_aif_sbv
+	 * in case we insert the KVM module again later.  Clear the AIFT
+	 * information and free anything not registered with underlying
+	 * firmware.
+	 */
+	spin_lock_irqsave(&aift->gait_lock, flags);
+	gait_kzdev = aift->kzdev;
+	aift->gait = 0;
+	aift->sbv = 0;
+	aift->kzdev = 0;
+	spin_unlock_irqrestore(&aift->gait_lock, flags);
+
+	kfree(gait_kzdev);
+}
+
+static int zpci_setup_aipb(u8 nisc)
+{
+	struct page *page;
+	int size, rc;
+
+	zpci_aipb = kzalloc(sizeof(union zpci_sic_iib), GFP_KERNEL);
+	if (!zpci_aipb)
+		return -ENOMEM;
+
+	aift->sbv = airq_iv_create(ZPCI_NR_DEVICES, AIRQ_IV_ALLOC, 0);
+	if (!aift->sbv) {
+		rc = -ENOMEM;
+		goto free_aipb;
+	}
+	zpci_aif_sbv = aift->sbv;
+	size = get_order(PAGE_ALIGN(ZPCI_NR_DEVICES *
+						sizeof(struct zpci_gaite)));
+	page = alloc_pages(GFP_KERNEL | __GFP_ZERO, size);
+	if (!page) {
+		rc = -ENOMEM;
+		goto free_sbv;
+	}
+	aift->gait = (struct zpci_gaite *)page_to_phys(page);
+
+	zpci_aipb->aipb.faisb = virt_to_phys(aift->sbv->vector);
+	zpci_aipb->aipb.gait = virt_to_phys(aift->gait);
+	zpci_aipb->aipb.afi = nisc;
+	zpci_aipb->aipb.faal = ZPCI_NR_DEVICES;
+
+	/* Setup Adapter Event Notification Interpretation */
+	if (zpci_set_irq_ctrl(SIC_SET_AENI_CONTROLS, 0, zpci_aipb)) {
+		rc = -EIO;
+		goto free_gait;
+	}
+
+	return 0;
+
+free_gait:
+	free_pages((unsigned long)aift->gait, size);
+free_sbv:
+	airq_iv_release(aift->sbv);
+	zpci_aif_sbv = 0;
+free_aipb:
+	kfree(zpci_aipb);
+	zpci_aipb = 0;
+
+	return rc;
+}
+
+static int zpci_reset_aipb(u8 nisc)
+{
+	/*
+	 * AEN registration can only happen once per system boot.  If
+	 * an aipb already exists then AEN was already registered and
+	 * we can re-use the aipb contents.  This can only happen if
+	 * the KVM module was removed and re-inserted.  However, we must
+	 * ensure that the same forwarding ISC is used as this is assigned
+	 * during KVM module load.
+	 */
+	if (zpci_aipb->aipb.afi != nisc)
+		return -EINVAL;
+
+	aift->sbv = zpci_aif_sbv;
+	aift->gait = (struct zpci_gaite *)zpci_aipb->aipb.gait;
+
+	return 0;
+}
+
+int kvm_s390_pci_aen_init(u8 nisc)
+{
+	int rc = 0;
+
+	/* If already enabled for AEN, bail out now */
+	if (aift->gait || aift->sbv)
+		return -EPERM;
+
+	mutex_lock(&aift->aift_lock);
+	aift->kzdev = kcalloc(ZPCI_NR_DEVICES, sizeof(struct kvm_zdev),
+			      GFP_KERNEL);
+	if (!aift->kzdev) {
+		rc = -ENOMEM;
+		goto unlock;
+	}
+
+	if (!zpci_aipb)
+		rc = zpci_setup_aipb(nisc);
+	else
+		rc = zpci_reset_aipb(nisc);
+	if (rc)
+		goto free_zdev;
+
+	/* Enable floating IRQs */
+	if (__set_irq_noiib(SIC_IRQ_MODE_SINGLE, nisc)) {
+		rc = -EIO;
+		kvm_s390_pci_aen_exit();
+	}
+
+	goto unlock;
+
+free_zdev:
+	kfree(aift->kzdev);
+unlock:
+	mutex_unlock(&aift->aift_lock);
+	return rc;
+}
+
 static int kvm_s390_pci_dev_open(struct zpci_dev *zdev)
 {
 	struct kvm_zdev *kzdev;
@@ -34,3 +175,22 @@ static void kvm_s390_pci_dev_release(struct zpci_dev *zdev)
 	zdev->kzdev = 0;
 	kfree(kzdev);
 }
+
+int kvm_s390_pci_init(void)
+{
+	aift = kzalloc(sizeof(struct zpci_aift), GFP_KERNEL);
+	if (!aift)
+		return -ENOMEM;
+
+	spin_lock_init(&aift->gait_lock);
+	mutex_init(&aift->aift_lock);
+
+	return 0;
+}
+
+void kvm_s390_pci_exit(void)
+{
+	mutex_destroy(&aift->aift_lock);
+
+	kfree(aift);
+}
diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
index ce93978e8913..c357d900f8b0 100644
--- a/arch/s390/kvm/pci.h
+++ b/arch/s390/kvm/pci.h
@@ -12,10 +12,59 @@
 
 #include <linux/kvm_host.h>
 #include <linux/pci.h>
+#include <linux/mutex.h>
+#include <asm/airq.h>
+#include <asm/cpu.h>
 
 struct kvm_zdev {
 	struct zpci_dev *zdev;
 	struct kvm *kvm;
 };
 
+struct zpci_gaite {
+	u32 gisa;
+	u8 gisc;
+	u8 count;
+	u8 reserved;
+	u8 aisbo;
+	u64 aisb;
+};
+
+struct zpci_aift {
+	struct zpci_gaite *gait;
+	struct airq_iv *sbv;
+	struct kvm_zdev **kzdev;
+	spinlock_t gait_lock; /* Protects the gait, used during AEN forward */
+	struct mutex aift_lock; /* Protects the other structures in aift */
+};
+
+extern struct zpci_aift *aift;
+
+int kvm_s390_pci_aen_init(u8 nisc);
+void kvm_s390_pci_aen_exit(void);
+
+int kvm_s390_pci_init(void);
+void kvm_s390_pci_exit(void);
+
+static inline bool kvm_s390_pci_interp_allowed(void)
+{
+	struct cpuid cpu_id;
+
+	get_cpu_id(&cpu_id);
+	switch (cpu_id.machine) {
+	case 0x2817:
+	case 0x2818:
+	case 0x2827:
+	case 0x2828:
+	case 0x2964:
+	case 0x2965:
+		/* No SHM on certain machines */
+		return false;
+	default:
+		return (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM) &&
+			sclp.has_zpci_lsi && sclp.has_aeni && sclp.has_aisi &&
+			sclp.has_aisii);
+	}
+}
+
 #endif /* __KVM_S390_PCI_H */
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index a86cd1cbb80e..f0a439c43395 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -61,6 +61,12 @@ DEFINE_STATIC_KEY_FALSE(have_mio);
 
 static struct kmem_cache *zdev_fmb_cache;
 
+/* AEN structures that must be preserved over KVM module re-insertion */
+union zpci_sic_iib *zpci_aipb;
+EXPORT_SYMBOL_GPL(zpci_aipb);
+struct airq_iv *zpci_aif_sbv;
+EXPORT_SYMBOL_GPL(zpci_aif_sbv);
+
 struct zpci_dev *get_zdev_by_fid(u32 fid)
 {
 	struct zpci_dev *tmp, *zdev = NULL;
-- 
2.27.0

