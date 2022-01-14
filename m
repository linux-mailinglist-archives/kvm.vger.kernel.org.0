Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D6348F169
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 21:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244981AbiANUdq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 15:33:46 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46842 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244519AbiANUc1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 15:32:27 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EKPofC026181;
        Fri, 14 Jan 2022 20:32:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=KJvUVC+kjxxs9E1KTaJTUavDvgnKS2bxvjXEN45e/yM=;
 b=INpOF71n8NgfO2iZsun6SCqryvRSzwAsEuysgtgu3Jw/aO9XG75MVczXbINEkX8biriv
 cQWlTEaNb+E+ODyempwTjpQKgvHoBDmxjRng7WuA8efBEhUS7KoXs8AH/ZLgq4GS+KWT
 91VGrdAY+/QPcE+Y8epWm5MCVU7DIWExETGAZh9ht40ykxcxL+TouqGr3n7eaaIvl0ul
 qfvIqedKVQDAgKX7QnO3Gyus9uD/jiUNvvi7qiRhPiTL9MY/fe7O0MDd7D9avaNfINVn
 hcqK43koXA53ivZuSHZHQ1vksyEfLng9rYTOOBoaTrkNScw7OIF4JJAZWJOk75lMt3uO Zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkg72r42e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:27 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EKU86U008709;
        Fri, 14 Jan 2022 20:32:26 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkg72r420-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:26 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EKLiCw023989;
        Fri, 14 Jan 2022 20:32:25 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03wdc.us.ibm.com with ESMTP id 3djknt7p9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:25 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EKWMvI30081478
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 20:32:22 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 935A0C6061;
        Fri, 14 Jan 2022 20:32:22 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA252C6059;
        Fri, 14 Jan 2022 20:32:20 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.65.142])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 20:32:20 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 16/30] KVM: s390: pci: enable host forwarding of Adapter Event Notifications
Date:   Fri, 14 Jan 2022 15:31:31 -0500
Message-Id: <20220114203145.242984-17-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220114203145.242984-1-mjrosato@linux.ibm.com>
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Y4UBdRrcla9yGg8ddDVrNtfMx-dtGFGK
X-Proofpoint-GUID: 9N64wiGs5GbhrbNwWBvtxGP-xahtCSMl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_06,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 clxscore=1015 impostorscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 priorityscore=1501 adultscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140120
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
 arch/s390/kvm/interrupt.c        | 76 +++++++++++++++++++++++++++++++-
 arch/s390/kvm/kvm-s390.c         |  3 +-
 arch/s390/kvm/pci.h              |  9 ++++
 5 files changed, 100 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index a604d51acfc8..3f147b8d050b 100644
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
index a591b8cd662f..07743c6a67c4 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -3263,11 +3263,85 @@ int kvm_s390_gisc_unregister(struct kvm *kvm, u32 gisc)
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
+	if (kvm == 0)
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
+				/* Reenable interrupts. */
+				if (zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, isc,
+						      &iib))
+					break;
+				first = found = false;
+			} else {
+				/* Interrupts on and all bits processed */
+				break;
+			}
+			found = false;
+			si = 0;
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
+	if (IS_ENABLED(CONFIG_PCI) && (info->forward || info->error)) {
+		aen_process_gait(info->isc);
+		if (info->aism != 0)
+			process_gib_alert_list();
+	} else
+		process_gib_alert_list();
 }
 
 static struct airq_struct gib_alert_irq = {
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 01dc3f6883d0..ab8b56deed11 100644
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
index b2000ed7b8c3..387b637863c9 100644
--- a/arch/s390/kvm/pci.h
+++ b/arch/s390/kvm/pci.h
@@ -12,6 +12,7 @@
 
 #include <linux/pci.h>
 #include <linux/mutex.h>
+#include <linux/kvm_host.h>
 #include <asm/airq.h>
 #include <asm/kvm_pci.h>
 
@@ -34,6 +35,14 @@ struct zpci_aift {
 
 extern struct zpci_aift *aift;
 
+static inline struct kvm *kvm_s390_pci_si_to_kvm(struct zpci_aift *aift,
+						 unsigned long si)
+{
+	if (!IS_ENABLED(CONFIG_PCI) || aift->kzdev == 0 || aift->kzdev[si] == 0)
+		return 0;
+	return aift->kzdev[si]->kvm;
+};
+
 int kvm_s390_pci_aen_init(u8 nisc);
 void kvm_s390_pci_aen_exit(void);
 
-- 
2.27.0

