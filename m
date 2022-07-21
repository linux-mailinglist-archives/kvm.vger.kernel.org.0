Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0D157D0EE
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 18:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbiGUQN0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 12:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbiGUQNU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 12:13:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549BA87345;
        Thu, 21 Jul 2022 09:13:18 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LFmdZu020261;
        Thu, 21 Jul 2022 16:13:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=e+vpgonEXpdfPiGFc23+3r1kvpQe/HE9r7d7X+g+Kpw=;
 b=EAM1/+xCLpIbAtK0uwcqCcN/x3oWe0yqgncdtTPxtMSJTfU2vn/Nx2EEeBiOL2ugKftg
 YL0tHL52X+Yq7oZ3r4iJ1r11Cm5PmX6wvC6gDWZyP2a+kJweYnybbO6Ys0NMSQan1RA2
 Z0GWQuxmeFwBvYzxKtDq3slLMWkeCUsbcfg+BTZrPxNsMISphVSNyhjbwrdvHMYWQoaL
 lL0ORNXApdNMD8Qxb6Q1X7KTRdN7IXmDNAwBmJDrlLWeM8jiM9UR+Y39Y8PevHaClQ2k
 HEhqRGO3Wq7CbUf1w+8Nk4Mtw3w7GKwhDm4CMEtMuokMbqTz7/0tqCQvLgXhNIi1uuUj Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9s4rshm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:17 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LFn2ex022246;
        Thu, 21 Jul 2022 16:13:17 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9s4rsg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:16 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LGD4vA004183;
        Thu, 21 Jul 2022 16:13:14 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3hbmy8y540-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:14 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LGBNPp21889318
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 16:11:23 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66CA3A405B;
        Thu, 21 Jul 2022 16:13:11 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D915AA4054;
        Thu, 21 Jul 2022 16:13:10 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 16:13:10 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        thuth@redhat.com, david@redhat.com,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: [GIT PULL 12/42] KVM: s390: pci: do initial setup for AEN interpretation
Date:   Thu, 21 Jul 2022 18:12:32 +0200
Message-Id: <20220721161302.156182-13-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721161302.156182-1-imbrenda@linux.ibm.com>
References: <20220721161302.156182-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JLUWUMwycZq6hpOqSL579XNIRAnaGa4J
X-Proofpoint-GUID: m6kcB4-GRtNYYejiLjfsjsW2wsN2RCPx
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_22,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 impostorscore=0 phishscore=0 suspectscore=0
 bulkscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207210061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Matthew Rosato <mjrosato@linux.ibm.com>

Initial setup for Adapter Event Notification Interpretation for zPCI
passthrough devices.  Specifically, allocate a structure for forwarding of
adapter events and pass the address of this structure to firmware.

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Link: https://lore.kernel.org/r/20220606203325.110625-13-mjrosato@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
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
index 8fcb56141689..251eaaff9c67 100644
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
index e27191ea27c4..d566551d3018 100644
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
+	aift->gait = NULL;
+	aift->sbv = NULL;
+	aift->kzdev = NULL;
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
+	zpci_aif_sbv = NULL;
+free_aipb:
+	kfree(zpci_aipb);
+	zpci_aipb = NULL;
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
 	zdev->kzdev = NULL;
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
index c8b9d866434c..86cd4d8446b1 100644
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
2.36.1

