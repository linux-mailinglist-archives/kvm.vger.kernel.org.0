Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D1F48F121
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 21:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244365AbiANUcN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 15:32:13 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56504 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244370AbiANUcH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 15:32:07 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EKQhTM026288;
        Fri, 14 Jan 2022 20:32:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=LSHLapkn48h9Vwzz7wQ8O7WY10xA4NFhTPN6hyTer5k=;
 b=M/AUSKlkUJJT4kH9r/ARUMXx/DPbPNAyv0zY1n+q0DOKOTv72bph4RejGi8sTs6e/V6M
 nMoCgbYsxmxFPzSzY4TANBbuv1rrVin7FylBoVeK3JVg0PXUMfvaONzd7B39N+yD46d8
 //MXwls0/eLnY++6kHJMU3RV7zsPEWvQf3geEUDqlmD7YDbfLOW/SQuHIMnq5e0ak7aO
 juGJP9St1IUYz0UsnganvklPIW6b6yH//FGkL+Dl5LTkl8UhtnNTwy6EiEvBWebDAa79
 VTuDCezSpn8k8kBYQ8HPy0EqqZEFBK/23e6t/DZhORYY5CF6+2Myq25C4I5GayRr1i5f ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkdncb631-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:07 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EKBmv8007913;
        Fri, 14 Jan 2022 20:32:06 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkdncb62h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:06 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EKLr3I027865;
        Fri, 14 Jan 2022 20:32:05 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma05wdc.us.ibm.com with ESMTP id 3df28cyfat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:05 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EKW1eU33292560
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 20:32:01 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B549C6073;
        Fri, 14 Jan 2022 20:32:01 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F107C6059;
        Fri, 14 Jan 2022 20:31:59 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.65.142])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 20:31:59 +0000 (GMT)
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
Subject: [PATCH v2 05/30] s390/airq: pass more TPI info to airq handlers
Date:   Fri, 14 Jan 2022 15:31:20 -0500
Message-Id: <20220114203145.242984-6-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220114203145.242984-1-mjrosato@linux.ibm.com>
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3vKgMlJTd3vo06bXBVG8eZqxQ6JGdlPU
X-Proofpoint-GUID: 2FGcOWRoHhpKzbKi1aksHJT_Ga-_nQHC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_06,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 malwarescore=0 bulkscore=0 suspectscore=0 adultscore=0
 clxscore=1015 phishscore=0 spamscore=0 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140120
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
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
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
index c3bd993fdd0c..f9b872e358c6 100644
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
@@ -3261,7 +3262,8 @@ int kvm_s390_gisc_unregister(struct kvm *kvm, u32 gisc)
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

