Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D51FB5330E2
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 20:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240619AbiEXS7n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 14:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240612AbiEXS7j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 14:59:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ECB0663CB;
        Tue, 24 May 2022 11:59:37 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OIqFel018782;
        Tue, 24 May 2022 18:59:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=oPlTje8q8fTPLtgLYkPdM/Laz9L6Ss7hY8QHaPqnKXE=;
 b=LcEKr5Lx0CScZL81CL/NAntr+dlGhEFKUEMvCs5CJX7+gcFC0q27VWavFiIGrpPXQCht
 0V6pwQHQT6XHhsh9eJC1hLmLd9/itOD0FjvtRKfBe9vQxhspQHMkz+MKQH4wwll4PtCj
 WmwaZhHSWNcQ8wty30QMlYHHK9mGoUuR19oHjKhI1CONuikpmzbKPjfLxVrzWB/FNOWm
 vycG7f+d5DgvA33ndTkrl1BY4t4ZNRXhd+y94BJbwp6pPkQjKW1z8PiyYHDs/YZu6SHK
 IsL0jZwrLBO0T8GNuq7QQUOryFg4z7eUF2AikqQ6lSnDI5/GxAF4x32Idmb25tFDmBwn Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g950y834s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:59:33 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24OIxWuL040937;
        Tue, 24 May 2022 18:59:32 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g950y8348-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:59:32 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24OIsH5H023581;
        Tue, 24 May 2022 18:59:31 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02wdc.us.ibm.com with ESMTP id 3g93uw0hj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:59:31 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24OIxUbr34210062
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 18:59:30 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F22DBE051;
        Tue, 24 May 2022 18:59:30 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33B27BE058;
        Tue, 24 May 2022 18:59:28 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.163.3.233])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 24 May 2022 18:59:28 +0000 (GMT)
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
Subject: [PATCH v8 07/22] s390/pci: externalize the SIC operation controls and routine
Date:   Tue, 24 May 2022 14:58:52 -0400
Message-Id: <20220524185907.140285-8-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220524185907.140285-1-mjrosato@linux.ibm.com>
References: <20220524185907.140285-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xNd88inm4U6I6SCqU-u9pYzUzlMh4-Cb
X-Proofpoint-ORIG-GUID: 3SkX28H_pZvwnKOCwrds8V6AlYLOoKcc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_09,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 impostorscore=0 spamscore=0 suspectscore=0 mlxlogscore=711 phishscore=0
 adultscore=0 lowpriorityscore=0 mlxscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205240090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A subsequent patch will be issuing SIC from KVM -- export the necessary
routine and make the operation control definitions available from a header.
Because the routine will now be exported, let's rename __zpci_set_irq_ctrl
to zpci_set_irq_ctrl and get rid of the zero'd iib wrapper function of
the same name.

Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/pci_insn.h | 17 +++++++++--------
 arch/s390/pci/pci_insn.c         |  3 ++-
 arch/s390/pci/pci_irq.c          | 26 ++++++++++++--------------
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/arch/s390/include/asm/pci_insn.h b/arch/s390/include/asm/pci_insn.h
index 61cf9531f68f..5331082fa516 100644
--- a/arch/s390/include/asm/pci_insn.h
+++ b/arch/s390/include/asm/pci_insn.h
@@ -98,6 +98,14 @@ struct zpci_fib {
 	u32 gd;
 } __packed __aligned(8);
 
+/* Set Interruption Controls Operation Controls  */
+#define	SIC_IRQ_MODE_ALL		0
+#define	SIC_IRQ_MODE_SINGLE		1
+#define	SIC_IRQ_MODE_DIRECT		4
+#define	SIC_IRQ_MODE_D_ALL		16
+#define	SIC_IRQ_MODE_D_SINGLE		17
+#define	SIC_IRQ_MODE_SET_CPU		18
+
 /* directed interruption information block */
 struct zpci_diib {
 	u32 : 1;
@@ -134,13 +142,6 @@ int __zpci_store(u64 data, u64 req, u64 offset);
 int zpci_store(const volatile void __iomem *addr, u64 data, unsigned long len);
 int __zpci_store_block(const u64 *data, u64 req, u64 offset);
 void zpci_barrier(void);
-int __zpci_set_irq_ctrl(u16 ctl, u8 isc, union zpci_sic_iib *iib);
-
-static inline int zpci_set_irq_ctrl(u16 ctl, u8 isc)
-{
-	union zpci_sic_iib iib = {{0}};
-
-	return __zpci_set_irq_ctrl(ctl, isc, &iib);
-}
+int zpci_set_irq_ctrl(u16 ctl, u8 isc, union zpci_sic_iib *iib);
 
 #endif
diff --git a/arch/s390/pci/pci_insn.c b/arch/s390/pci/pci_insn.c
index 1710d006ee93..4c6967b73932 100644
--- a/arch/s390/pci/pci_insn.c
+++ b/arch/s390/pci/pci_insn.c
@@ -98,7 +98,7 @@ int zpci_refresh_trans(u64 fn, u64 addr, u64 range)
 }
 
 /* Set Interruption Controls */
-int __zpci_set_irq_ctrl(u16 ctl, u8 isc, union zpci_sic_iib *iib)
+int zpci_set_irq_ctrl(u16 ctl, u8 isc, union zpci_sic_iib *iib)
 {
 	if (!test_facility(72))
 		return -EIO;
@@ -109,6 +109,7 @@ int __zpci_set_irq_ctrl(u16 ctl, u8 isc, union zpci_sic_iib *iib)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(zpci_set_irq_ctrl);
 
 /* PCI Load */
 static inline int ____pcilg(u64 *data, u64 req, u64 offset, u8 *status)
diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
index 87c7d121c255..f2b3145b6697 100644
--- a/arch/s390/pci/pci_irq.c
+++ b/arch/s390/pci/pci_irq.c
@@ -15,13 +15,6 @@
 
 static enum {FLOATING, DIRECTED} irq_delivery;
 
-#define	SIC_IRQ_MODE_ALL		0
-#define	SIC_IRQ_MODE_SINGLE		1
-#define	SIC_IRQ_MODE_DIRECT		4
-#define	SIC_IRQ_MODE_D_ALL		16
-#define	SIC_IRQ_MODE_D_SINGLE		17
-#define	SIC_IRQ_MODE_SET_CPU		18
-
 /*
  * summary bit vector
  * FLOATING - summary bit per function
@@ -154,6 +147,7 @@ static struct irq_chip zpci_irq_chip = {
 static void zpci_handle_cpu_local_irq(bool rescan)
 {
 	struct airq_iv *dibv = zpci_ibv[smp_processor_id()];
+	union zpci_sic_iib iib = {{0}};
 	unsigned long bit;
 	int irqs_on = 0;
 
@@ -165,7 +159,7 @@ static void zpci_handle_cpu_local_irq(bool rescan)
 				/* End of second scan with interrupts on. */
 				break;
 			/* First scan complete, reenable interrupts. */
-			if (zpci_set_irq_ctrl(SIC_IRQ_MODE_D_SINGLE, PCI_ISC))
+			if (zpci_set_irq_ctrl(SIC_IRQ_MODE_D_SINGLE, PCI_ISC, &iib))
 				break;
 			bit = 0;
 			continue;
@@ -193,6 +187,7 @@ static void zpci_handle_remote_irq(void *data)
 static void zpci_handle_fallback_irq(void)
 {
 	struct cpu_irq_data *cpu_data;
+	union zpci_sic_iib iib = {{0}};
 	unsigned long cpu;
 	int irqs_on = 0;
 
@@ -203,7 +198,7 @@ static void zpci_handle_fallback_irq(void)
 				/* End of second scan with interrupts on. */
 				break;
 			/* First scan complete, reenable interrupts. */
-			if (zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, PCI_ISC))
+			if (zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, PCI_ISC, &iib))
 				break;
 			cpu = 0;
 			continue;
@@ -234,6 +229,7 @@ static void zpci_directed_irq_handler(struct airq_struct *airq,
 static void zpci_floating_irq_handler(struct airq_struct *airq,
 				      struct tpi_info *tpi_info)
 {
+	union zpci_sic_iib iib = {{0}};
 	unsigned long si, ai;
 	struct airq_iv *aibv;
 	int irqs_on = 0;
@@ -247,7 +243,7 @@ static void zpci_floating_irq_handler(struct airq_struct *airq,
 				/* End of second scan with interrupts on. */
 				break;
 			/* First scan complete, reenable interrupts. */
-			if (zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, PCI_ISC))
+			if (zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, PCI_ISC, &iib))
 				break;
 			si = 0;
 			continue;
@@ -407,11 +403,12 @@ static struct airq_struct zpci_airq = {
 static void __init cpu_enable_directed_irq(void *unused)
 {
 	union zpci_sic_iib iib = {{0}};
+	union zpci_sic_iib ziib = {{0}};
 
 	iib.cdiib.dibv_addr = (u64) zpci_ibv[smp_processor_id()]->vector;
 
-	__zpci_set_irq_ctrl(SIC_IRQ_MODE_SET_CPU, 0, &iib);
-	zpci_set_irq_ctrl(SIC_IRQ_MODE_D_SINGLE, PCI_ISC);
+	zpci_set_irq_ctrl(SIC_IRQ_MODE_SET_CPU, 0, &iib);
+	zpci_set_irq_ctrl(SIC_IRQ_MODE_D_SINGLE, PCI_ISC, &ziib);
 }
 
 static int __init zpci_directed_irq_init(void)
@@ -426,7 +423,7 @@ static int __init zpci_directed_irq_init(void)
 	iib.diib.isc = PCI_ISC;
 	iib.diib.nr_cpus = num_possible_cpus();
 	iib.diib.disb_addr = virt_to_phys(zpci_sbv->vector);
-	__zpci_set_irq_ctrl(SIC_IRQ_MODE_DIRECT, 0, &iib);
+	zpci_set_irq_ctrl(SIC_IRQ_MODE_DIRECT, 0, &iib);
 
 	zpci_ibv = kcalloc(num_possible_cpus(), sizeof(*zpci_ibv),
 			   GFP_KERNEL);
@@ -471,6 +468,7 @@ static int __init zpci_floating_irq_init(void)
 
 int __init zpci_irq_init(void)
 {
+	union zpci_sic_iib iib = {{0}};
 	int rc;
 
 	irq_delivery = sclp.has_dirq ? DIRECTED : FLOATING;
@@ -502,7 +500,7 @@ int __init zpci_irq_init(void)
 	 * Enable floating IRQs (with suppression after one IRQ). When using
 	 * directed IRQs this enables the fallback path.
 	 */
-	zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, PCI_ISC);
+	zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, PCI_ISC, &iib);
 
 	return 0;
 out_airq:
-- 
2.27.0

