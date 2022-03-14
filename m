Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A84D34D8CBD
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244288AbiCNTrZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244236AbiCNTrV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:47:21 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89AC83DA79;
        Mon, 14 Mar 2022 12:46:06 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22EHZLlB007314;
        Mon, 14 Mar 2022 19:45:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=y+x5NavMDqXE05u5ib6MT+5ovwZbRe+RoVZq+Y/Dkqo=;
 b=MfGay1jZE2PWK1mj2Lf3dTj+oVLy9xGtZsrbYiWdwN5xM0GXlt/NMONcHw8oEkqN3GZK
 hg2bmZ4Wj8nfCsXhPPjx+dBS2Vnqv5AxonkAJFjz9Q1M13GSNLmBYbBxGuZEQ1rKpBHM
 6UN/Mrd4y2b4Z1e4t+7VcCx7otqyKmRJ7qZnuuwYXtQ09h8/cb0Yt06XKb0hXkRU6vnT
 jzjpL4mIHxeK47Sqn0cAu8MUoOP1zfgI2n0QkGsyTvmepz5AN31einQ2DOIqh1aYWG+n
 IeJBsXRNpfL3b2g82RnLYPjPVeZ/RRWJcqYJqYWPVoqYUo5pQQqPdoKj7NjA1SfXoCqs Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3et6dcrjwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:45:58 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22EJbRMI017447;
        Mon, 14 Mar 2022 19:45:57 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3et6dcrjwg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:45:57 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22EJN7cw009007;
        Mon, 14 Mar 2022 19:45:57 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02wdc.us.ibm.com with ESMTP id 3erk59g7pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:45:56 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22EJjtsK52625840
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 19:45:55 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 825D6112061;
        Mon, 14 Mar 2022 19:45:55 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74EAB112067;
        Mon, 14 Mar 2022 19:45:48 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.184])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Mar 2022 19:45:48 +0000 (GMT)
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
Subject: [PATCH v4 05/32] s390/airq: pass more TPI info to airq handlers
Date:   Mon, 14 Mar 2022 15:44:24 -0400
Message-Id: <20220314194451.58266-6-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220314194451.58266-1-mjrosato@linux.ibm.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nmpcWAcQfT7Ogm8hlbMBbFekiUPd2k-l
X-Proofpoint-ORIG-GUID: zuSCNYU2hLinAlX0nr48eS7hyAYXeJNU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_13,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=790 impostorscore=0 adultscore=0 clxscore=1015 suspectscore=0
 mlxscore=0 priorityscore=1501 bulkscore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203140116
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A subsequent patch will introduce an airq handler that requires additional
TPI information beyond directed vs floating, so pass the entire tpi_info
structure via the handler.  Only pci actually uses this information today,
for the other airq handlers this is effectively a no-op.

Reviewed-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Acked-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/airq.h     | 3 ++-
 arch/s390/kvm/interrupt.c        | 4 +++-
 arch/s390/pci/pci_irq.c          | 9 +++++++--
 drivers/s390/cio/airq.c          | 2 +-
 drivers/s390/cio/qdio_thinint.c  | 6 ++++--
 drivers/s390/crypto/ap_bus.c     | 9 ++++++---
 drivers/s390/virtio/virtio_ccw.c | 4 +++-
 7 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/arch/s390/include/asm/airq.h b/arch/s390/include/asm/airq.h
index 01936fdfaddb..7918a7d09028 100644
--- a/arch/s390/include/asm/airq.h
+++ b/arch/s390/include/asm/airq.h
@@ -12,10 +12,11 @@
 
 #include <linux/bit_spinlock.h>
 #include <linux/dma-mapping.h>
+#include <asm/tpi.h>
 
 struct airq_struct {
 	struct hlist_node list;		/* Handler queueing. */
-	void (*handler)(struct airq_struct *airq, bool floating);
+	void (*handler)(struct airq_struct *airq, struct tpi_info *tpi_info);
 	u8 *lsi_ptr;			/* Local-Summary-Indicator pointer */
 	u8 lsi_mask;			/* Local-Summary-Indicator mask */
 	u8 isc;				/* Interrupt-subclass */
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index db933c252dbc..65e75ca2fc5d 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -28,6 +28,7 @@
 #include <asm/switch_to.h>
 #include <asm/nmi.h>
 #include <asm/airq.h>
+#include <asm/tpi.h>
 #include "kvm-s390.h"
 #include "gaccess.h"
 #include "trace-s390.h"
@@ -3269,7 +3270,8 @@ int kvm_s390_gisc_unregister(struct kvm *kvm, u32 gisc)
 }
 EXPORT_SYMBOL_GPL(kvm_s390_gisc_unregister);
 
-static void gib_alert_irq_handler(struct airq_struct *airq, bool floating)
+static void gib_alert_irq_handler(struct airq_struct *airq,
+				  struct tpi_info *tpi_info)
 {
 	inc_irq_stat(IRQIO_GAL);
 	process_gib_alert_list();
diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
index 2b6062c486f5..cc4c8d7c8f5c 100644
--- a/arch/s390/pci/pci_irq.c
+++ b/arch/s390/pci/pci_irq.c
@@ -11,6 +11,7 @@
 
 #include <asm/isc.h>
 #include <asm/airq.h>
+#include <asm/tpi.h>
 
 static enum {FLOATING, DIRECTED} irq_delivery;
 
@@ -216,8 +217,11 @@ static void zpci_handle_fallback_irq(void)
 	}
 }
 
-static void zpci_directed_irq_handler(struct airq_struct *airq, bool floating)
+static void zpci_directed_irq_handler(struct airq_struct *airq,
+				      struct tpi_info *tpi_info)
 {
+	bool floating = !tpi_info->directed_irq;
+
 	if (floating) {
 		inc_irq_stat(IRQIO_PCF);
 		zpci_handle_fallback_irq();
@@ -227,7 +231,8 @@ static void zpci_directed_irq_handler(struct airq_struct *airq, bool floating)
 	}
 }
 
-static void zpci_floating_irq_handler(struct airq_struct *airq, bool floating)
+static void zpci_floating_irq_handler(struct airq_struct *airq,
+				      struct tpi_info *tpi_info)
 {
 	unsigned long si, ai;
 	struct airq_iv *aibv;
diff --git a/drivers/s390/cio/airq.c b/drivers/s390/cio/airq.c
index e56535c99888..2f2226786319 100644
--- a/drivers/s390/cio/airq.c
+++ b/drivers/s390/cio/airq.c
@@ -99,7 +99,7 @@ static irqreturn_t do_airq_interrupt(int irq, void *dummy)
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(airq, head, list)
 		if ((*airq->lsi_ptr & airq->lsi_mask) != 0)
-			airq->handler(airq, !tpi_info->directed_irq);
+			airq->handler(airq, tpi_info);
 	rcu_read_unlock();
 
 	return IRQ_HANDLED;
diff --git a/drivers/s390/cio/qdio_thinint.c b/drivers/s390/cio/qdio_thinint.c
index 8e09bf3a2fcd..9b9335dd06db 100644
--- a/drivers/s390/cio/qdio_thinint.c
+++ b/drivers/s390/cio/qdio_thinint.c
@@ -15,6 +15,7 @@
 #include <asm/qdio.h>
 #include <asm/airq.h>
 #include <asm/isc.h>
+#include <asm/tpi.h>
 
 #include "cio.h"
 #include "ioasm.h"
@@ -93,9 +94,10 @@ static inline u32 clear_shared_ind(void)
 /**
  * tiqdio_thinint_handler - thin interrupt handler for qdio
  * @airq: pointer to adapter interrupt descriptor
- * @floating: flag to recognize floating vs. directed interrupts (unused)
+ * @tpi_info: interrupt information (e.g. floating vs directed -- unused)
  */
-static void tiqdio_thinint_handler(struct airq_struct *airq, bool floating)
+static void tiqdio_thinint_handler(struct airq_struct *airq,
+				   struct tpi_info *tpi_info)
 {
 	u64 irq_time = S390_lowcore.int_clock;
 	u32 si_used = clear_shared_ind();
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 1986243f9cd3..df1a038442db 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -27,6 +27,7 @@
 #include <linux/kthread.h>
 #include <linux/mutex.h>
 #include <asm/airq.h>
+#include <asm/tpi.h>
 #include <linux/atomic.h>
 #include <asm/isc.h>
 #include <linux/hrtimer.h>
@@ -129,7 +130,8 @@ static int ap_max_adapter_id = 63;
 static struct bus_type ap_bus_type;
 
 /* Adapter interrupt definitions */
-static void ap_interrupt_handler(struct airq_struct *airq, bool floating);
+static void ap_interrupt_handler(struct airq_struct *airq,
+				 struct tpi_info *tpi_info);
 
 static bool ap_irq_flag;
 
@@ -442,9 +444,10 @@ static enum hrtimer_restart ap_poll_timeout(struct hrtimer *unused)
 /**
  * ap_interrupt_handler() - Schedule ap_tasklet on interrupt
  * @airq: pointer to adapter interrupt descriptor
- * @floating: ignored
+ * @tpi_info: ignored
  */
-static void ap_interrupt_handler(struct airq_struct *airq, bool floating)
+static void ap_interrupt_handler(struct airq_struct *airq,
+				 struct tpi_info *tpi_info)
 {
 	inc_irq_stat(IRQIO_APB);
 	tasklet_schedule(&ap_tasklet);
diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index d35e7a3f7067..52c376d15978 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -33,6 +33,7 @@
 #include <asm/virtio-ccw.h>
 #include <asm/isc.h>
 #include <asm/airq.h>
+#include <asm/tpi.h>
 
 /*
  * virtio related functions
@@ -203,7 +204,8 @@ static void drop_airq_indicator(struct virtqueue *vq, struct airq_info *info)
 	write_unlock_irqrestore(&info->lock, flags);
 }
 
-static void virtio_airq_handler(struct airq_struct *airq, bool floating)
+static void virtio_airq_handler(struct airq_struct *airq,
+				struct tpi_info *tpi_info)
 {
 	struct airq_info *info = container_of(airq, struct airq_info, airq);
 	unsigned long ai;
-- 
2.27.0

