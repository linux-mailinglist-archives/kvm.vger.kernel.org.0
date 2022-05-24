Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA5545330E7
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 20:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240642AbiEXS7s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 14:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240574AbiEXS7d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 14:59:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66005BD3D;
        Tue, 24 May 2022 11:59:32 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OIeP5R005678;
        Tue, 24 May 2022 18:59:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=cu+rWV8LDqJscyU/8zIAVgKkWiYzdZkxYh1Uj3EL7Go=;
 b=raTgiObE/xi/lHYZ4LCvuuDOcvnlp3CDVCKrsBbuipS0UbjJDXh7HBfXeCfJ5IUHkP10
 NEDRsosbBTv3O1KCBQgB7se4H2AyGcXk/YcM64AGE+GYCzA7zHFwOXU4PyC/mlttyNeb
 jNgfD6V5lllVpvXbc9yPdkhUZfBn59E/uRqFWYXMPfCV0XN2jtXmgUFZ0b/dyemsLBDB
 0qU7WwkGHjc4GWQyeqLdtE/qEeYkJUOHSFCFEDVp5yp5M3TRhB2hcdx+WWdisGh19BXt
 bzEZ6CE3m+YRv7ZujmewCOBJo7TkLhJ8fpYOajMkzZ+/PHfiomQ/Z5OWfMIf2d6jFYp8 MA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g93vcsgrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:59:28 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24OIebf2006223;
        Tue, 24 May 2022 18:59:28 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g93vcsgrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:59:28 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24OIr1MX032483;
        Tue, 24 May 2022 18:59:27 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01dal.us.ibm.com with ESMTP id 3g93v8gnpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:59:27 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24OIxP5928967298
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 18:59:26 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8F4FBE05D;
        Tue, 24 May 2022 18:59:25 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C3E3ABE056;
        Tue, 24 May 2022 18:59:23 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.163.3.233])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 24 May 2022 18:59:23 +0000 (GMT)
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
Subject: [PATCH v8 05/22] s390/airq: pass more TPI info to airq handlers
Date:   Tue, 24 May 2022 14:58:50 -0400
Message-Id: <20220524185907.140285-6-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220524185907.140285-1-mjrosato@linux.ibm.com>
References: <20220524185907.140285-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: t-9rYD9MQSr03YdLW7l0pNAivX717nCZ
X-Proofpoint-ORIG-GUID: aU4070epRHnVmowtA8HtjBA9cXOFIiID
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_09,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 mlxscore=0 mlxlogscore=834
 malwarescore=0 bulkscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205240090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index af96dc0549a4..17ff475157d8 100644
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
@@ -3311,7 +3312,8 @@ int kvm_s390_gisc_unregister(struct kvm *kvm, u32 gisc)
 }
 EXPORT_SYMBOL_GPL(kvm_s390_gisc_unregister);
 
-static void gib_alert_irq_handler(struct airq_struct *airq, bool floating)
+static void gib_alert_irq_handler(struct airq_struct *airq,
+				  struct tpi_info *tpi_info)
 {
 	inc_irq_stat(IRQIO_GAL);
 	process_gib_alert_list();
diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
index 500cd2dbdf53..b805c75252ed 100644
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
index c0ed364bf446..230eb5b5b64e 100644
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
index fdf16cb70881..6cb8a2802ef8 100644
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
@@ -131,7 +132,8 @@ static int ap_max_adapter_id = 63;
 static struct bus_type ap_bus_type;
 
 /* Adapter interrupt definitions */
-static void ap_interrupt_handler(struct airq_struct *airq, bool floating);
+static void ap_interrupt_handler(struct airq_struct *airq,
+				 struct tpi_info *tpi_info);
 
 static bool ap_irq_flag;
 
@@ -452,9 +454,10 @@ static enum hrtimer_restart ap_poll_timeout(struct hrtimer *unused)
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

