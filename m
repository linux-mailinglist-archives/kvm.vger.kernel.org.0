Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00DD04D8D17
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244513AbiCNTuS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244524AbiCNTuQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:50:16 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41FCBC2D;
        Mon, 14 Mar 2022 12:48:51 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22EJlWxo001453;
        Mon, 14 Mar 2022 19:48:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0hS2rG9f4fpDKPeLgqpNUWlTUmku2HZqGewl3bMnrKY=;
 b=nGZdG4NrKYnjYrgIbirgX5i86u/rgrUb32X8smDcbmXpAp84heAuc9Dd0L0f4j5aaR5U
 OzNB6YYsDAL66BNtIJuFUqkYhTufyBeiPXTqIKvJL2M0250s5P30bWUwBYV6W/b076Aj
 I0c4VfFMcO6wDPR97w8AEtDZ1toE2yWxEleZ7uwmKxbJ1pa+8W/uRu59n+JTcYU7j4Nk
 aCvW96cjOZIPAPEhbxmRGmQbA/+EsdCK800NqcP7Akjo+VvQnGBt9UHwvqj3+BEeYWDg
 Pu2gko8uWaMVxAS1puNI5fffFcwvSXFDYST0FwmcXmuR8qWJmmOcJtDXE9VMaH4MEHBu pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6ae148w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:48:32 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22EJm1FT003718;
        Mon, 14 Mar 2022 19:48:32 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6ae148h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:48:32 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22EJlA5v009546;
        Mon, 14 Mar 2022 19:48:31 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 3erk59cc41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:48:31 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22EJmTd347382800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 19:48:29 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D5AD11206E;
        Mon, 14 Mar 2022 19:48:29 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96C08112067;
        Mon, 14 Mar 2022 19:48:20 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.184])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Mar 2022 19:48:20 +0000 (GMT)
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
Subject: [PATCH v4 20/32] KVM: s390: pci: enable host forwarding of Adapter Event Notifications
Date:   Mon, 14 Mar 2022 15:44:39 -0400
Message-Id: <20220314194451.58266-21-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220314194451.58266-1-mjrosato@linux.ibm.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: o6yNKXeOepgXKf-9eslvG3QzZbkunPtI
X-Proofpoint-GUID: AoWbFPYZ9Z3RVGnmo7KFgjCU3CbkFGWs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_13,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 adultscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 phishscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
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

In cases where interrupts are not forwarded to the guest via firmware,
KVM is responsible for ensuring delivery.  When an interrupt presents
with the forwarding bit, we must process the forwarding tables until
all interrupts are delivered.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  1 +
 arch/s390/include/asm/tpi.h      | 13 ++++++
 arch/s390/kvm/interrupt.c        | 77 +++++++++++++++++++++++++++++++-
 arch/s390/kvm/kvm-s390.c         |  3 +-
 arch/s390/kvm/pci.h              | 10 +++++
 5 files changed, 102 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index a22c9266ea05..b468d3a2215e 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -757,6 +757,7 @@ struct kvm_vm_stat {
 	u64 inject_pfault_done;
 	u64 inject_service_signal;
 	u64 inject_virtio;
+	u64 aen_forward;
 };
 
 struct kvm_arch_memory_slot {
diff --git a/arch/s390/include/asm/tpi.h b/arch/s390/include/asm/tpi.h
index 1ac538b8cbf5..f76e5fdff23a 100644
--- a/arch/s390/include/asm/tpi.h
+++ b/arch/s390/include/asm/tpi.h
@@ -19,6 +19,19 @@ struct tpi_info {
 	u32 :12;
 } __packed __aligned(4);
 
+/* I/O-Interruption Code as stored by TPI for an Adapter I/O */
+struct tpi_adapter_info {
+	u32 aism:8;
+	u32 :22;
+	u32 error:1;
+	u32 forward:1;
+	u32 reserved;
+	u32 adapter_IO:1;
+	u32 directed_irq:1;
+	u32 isc:3;
+	u32 :27;
+} __packed __aligned(4);
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_S390_TPI_H */
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 17c7deb516d2..513b393d5d0d 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -3271,11 +3271,86 @@ int kvm_s390_gisc_unregister(struct kvm *kvm, u32 gisc)
 }
 EXPORT_SYMBOL_GPL(kvm_s390_gisc_unregister);
 
+static void aen_host_forward(unsigned long si)
+{
+	struct kvm_s390_gisa_interrupt *gi;
+	struct zpci_gaite *gaite;
+	struct kvm *kvm;
+
+	gaite = (struct zpci_gaite *)aift->gait +
+		(si * sizeof(struct zpci_gaite));
+	if (gaite->count == 0)
+		return;
+	if (gaite->aisb != 0)
+		set_bit_inv(gaite->aisbo, (unsigned long *)gaite->aisb);
+
+	kvm = kvm_s390_pci_si_to_kvm(aift, si);
+	if (!kvm)
+		return;
+	gi = &kvm->arch.gisa_int;
+
+	if (!(gi->origin->g1.simm & AIS_MODE_MASK(gaite->gisc)) ||
+	    !(gi->origin->g1.nimm & AIS_MODE_MASK(gaite->gisc))) {
+		gisa_set_ipm_gisc(gi->origin, gaite->gisc);
+		if (hrtimer_active(&gi->timer))
+			hrtimer_cancel(&gi->timer);
+		hrtimer_start(&gi->timer, 0, HRTIMER_MODE_REL);
+		kvm->stat.aen_forward++;
+	}
+}
+
+static void aen_process_gait(u8 isc)
+{
+	bool found = false, first = true;
+	union zpci_sic_iib iib = {{0}};
+	unsigned long si, flags;
+
+	spin_lock_irqsave(&aift->gait_lock, flags);
+
+	if (!aift->gait) {
+		spin_unlock_irqrestore(&aift->gait_lock, flags);
+		return;
+	}
+
+	for (si = 0;;) {
+		/* Scan adapter summary indicator bit vector */
+		si = airq_iv_scan(aift->sbv, si, airq_iv_end(aift->sbv));
+		if (si == -1UL) {
+			if (first || found) {
+				/* Re-enable interrupts. */
+				zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, isc,
+						  &iib);
+				first = found = false;
+			} else {
+				/* Interrupts on and all bits processed */
+				break;
+			}
+			found = false;
+			si = 0;
+			/* Scan again after re-enabling interrupts */
+			continue;
+		}
+		found = true;
+		aen_host_forward(si);
+	}
+
+	spin_unlock_irqrestore(&aift->gait_lock, flags);
+}
+
 static void gib_alert_irq_handler(struct airq_struct *airq,
 				  struct tpi_info *tpi_info)
 {
+	struct tpi_adapter_info *info = (struct tpi_adapter_info *)tpi_info;
+
 	inc_irq_stat(IRQIO_GAL);
-	process_gib_alert_list();
+
+	if (IS_ENABLED(CONFIG_VFIO_PCI) && (info->forward || info->error)) {
+		aen_process_gait(info->isc);
+		if (info->aism != 0)
+			process_gib_alert_list();
+	} else {
+		process_gib_alert_list();
+	}
 }
 
 static struct airq_struct gib_alert_irq = {
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d89cd16b57dd..32e75f6f4e4d 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -65,7 +65,8 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	STATS_DESC_COUNTER(VM, inject_float_mchk),
 	STATS_DESC_COUNTER(VM, inject_pfault_done),
 	STATS_DESC_COUNTER(VM, inject_service_signal),
-	STATS_DESC_COUNTER(VM, inject_virtio)
+	STATS_DESC_COUNTER(VM, inject_virtio),
+	STATS_DESC_COUNTER(VM, aen_forward)
 };
 
 const struct kvm_stats_header kvm_vm_stats_header = {
diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
index 19609d7a53a7..25cb1c787190 100644
--- a/arch/s390/kvm/pci.h
+++ b/arch/s390/kvm/pci.h
@@ -12,6 +12,7 @@
 
 #include <linux/pci.h>
 #include <linux/mutex.h>
+#include <linux/kvm_host.h>
 #include <asm/airq.h>
 #include <asm/kvm_pci.h>
 
@@ -34,6 +35,15 @@ struct zpci_aift {
 
 extern struct zpci_aift *aift;
 
+static inline struct kvm *kvm_s390_pci_si_to_kvm(struct zpci_aift *aift,
+						 unsigned long si)
+{
+	if (!IS_ENABLED(CONFIG_VFIO_PCI) || aift->kzdev == 0 ||
+	    aift->kzdev[si] == 0)
+		return 0;
+	return aift->kzdev[si]->kvm;
+};
+
 int kvm_s390_pci_aen_init(u8 nisc);
 void kvm_s390_pci_aen_exit(void);
 
-- 
2.27.0

