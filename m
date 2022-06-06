Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD9B53EFBE
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 22:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbiFFUfQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 16:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233855AbiFFUev (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 16:34:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2682AB0D9;
        Mon,  6 Jun 2022 13:34:28 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256KXXoH001820;
        Mon, 6 Jun 2022 20:34:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=PX07NvwOcQrHogupa2v4tdYW4WwZzUrujICzrgWt2w0=;
 b=OLZqeQ5AL2nYS3lUjeLu1T5Ze2Szk2EXZOnYrILniZkc0pV7OflLnERaYJgM+1kahXqA
 6v1ovt0HPmc81xYnZcrJPZzfre3A3ZeQRNkPISpuKT3Q8WsYfKga7p4jQYzYx/qRfQLb
 KdPo+VHJJciv6jc/t+Jvcgdz3s5UJail9QqMWqAdfpKdZreUkE1gG30VZ7lcciQ+umdP
 hagEJ1NtqA2tjpGupi3JBjDwidzWBFS+UdM/bvHXL2g0XE9l2r3BCM0GWU0TH86y11BO
 OmPsCob6YR/En7wIBAI/O4OEDojlkm4We0r6jg90E0pMmCWmSNO3+5N54edcMYr08rMe 3w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ghqj1h88v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:34:24 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 256KXg3Q002980;
        Mon, 6 Jun 2022 20:34:24 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ghqj1h88r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:34:24 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 256KK7df016799;
        Mon, 6 Jun 2022 20:34:23 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma05wdc.us.ibm.com with ESMTP id 3gfy19fwbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:34:23 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 256KYMaI40829416
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Jun 2022 20:34:22 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B08E2805A;
        Mon,  6 Jun 2022 20:34:22 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B1662805C;
        Mon,  6 Jun 2022 20:34:15 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.163.20.188])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  6 Jun 2022 20:34:15 +0000 (GMT)
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
Subject: [PATCH v9 07/21] s390/pci: externalize the SIC operation controls and routine
Date:   Mon,  6 Jun 2022 16:33:11 -0400
Message-Id: <20220606203325.110625-8-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220606203325.110625-1-mjrosato@linux.ibm.com>
References: <20220606203325.110625-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZC3Bpzhp_NMt5BpX5xvFuLFG9FenxdwP
X-Proofpoint-GUID: TK2PvzvPCMxO-hAc_M2AOnn60O_NOvn4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-06_06,2022-06-03_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 adultscore=0 suspectscore=0 mlxlogscore=706 phishscore=0 impostorscore=0
 bulkscore=0 clxscore=1015 spamscore=0 malwarescore=0 lowpriorityscore=0
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
index 1a822b7799f8..5798178aec9d 100644
--- a/arch/s390/pci/pci_insn.c
+++ b/arch/s390/pci/pci_insn.c
@@ -138,7 +138,7 @@ int zpci_refresh_trans(u64 fn, u64 addr, u64 range)
 }
 
 /* Set Interruption Controls */
-int __zpci_set_irq_ctrl(u16 ctl, u8 isc, union zpci_sic_iib *iib)
+int zpci_set_irq_ctrl(u16 ctl, u8 isc, union zpci_sic_iib *iib)
 {
 	if (!test_facility(72))
 		return -EIO;
@@ -149,6 +149,7 @@ int __zpci_set_irq_ctrl(u16 ctl, u8 isc, union zpci_sic_iib *iib)
 
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

