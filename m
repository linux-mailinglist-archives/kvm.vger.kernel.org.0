Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C9E57D0DC
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 18:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbiGUQNS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 12:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbiGUQNO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 12:13:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70ACE73927;
        Thu, 21 Jul 2022 09:13:13 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LG6keR006345;
        Thu, 21 Jul 2022 16:13:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=yQ9bF9j+G28zUT6FGy4DS31qMH054iqWoWrDpcfZ3lI=;
 b=lBxey5pcwsSv70EK+qH55NIQpt98rb3fSNWUqbQN7Uvp3+m2WyOP/uADHlnbFWVtCDFf
 2weyIY3EdJMXyVljr6fkY0WOP/bcrj7ekwhUPb/Tp8RdpPiQ8XZkChUjtwNnejw8BOpP
 eEvwvxqTEivE0x8vMEDGBRa6uS28rAFkcwkpNOOAJcQXRNUrsbwyCF1EoXGVZ/HnS8cv
 9rIKnsGXHU+jXhTJ08Ui8ndbLLJoWO5Kb7WDZwCQGkZJokJYDIs7hBhcevOe12Zy9QiR
 UVU3QdjyMhsugXfqWDgkq5TjBmKfiOl9u2kF00vu0SVcGwxAqHxsekn0cONr9ERAREHX qA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9tfgfc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:13 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LG7BLa010868;
        Thu, 21 Jul 2022 16:13:12 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9tfgfb0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:12 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LG6k6b000977;
        Thu, 21 Jul 2022 16:13:10 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3hbmkht0a7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:10 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LGD6b323462250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 16:13:06 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFEA5A405C;
        Thu, 21 Jul 2022 16:13:06 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19B0BA4054;
        Thu, 21 Jul 2022 16:13:06 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 16:13:06 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        thuth@redhat.com, david@redhat.com,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [GIT PULL 05/42] s390/airq: pass more TPI info to airq handlers
Date:   Thu, 21 Jul 2022 18:12:25 +0200
Message-Id: <20220721161302.156182-6-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721161302.156182-1-imbrenda@linux.ibm.com>
References: <20220721161302.156182-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pzoG3OwAI9dkaxDlggDHMF9f88T0DVXC
X-Proofpoint-ORIG-GUID: ZJXaeshbXA-W4IM3dD3xO3BzQkJJYz6N
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_22,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 mlxlogscore=962 clxscore=1015 bulkscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Matthew Rosato <mjrosato@linux.ibm.com>

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
Link: https://lore.kernel.org/r/20220606203325.110625-6-mjrosato@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
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
index 5c13d2079d96..1b85f21c151b 100644
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
index 97e51c34e6cf..58cca50996ee 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -33,6 +33,7 @@
 #include <asm/virtio-ccw.h>
 #include <asm/isc.h>
 #include <asm/airq.h>
+#include <asm/tpi.h>
 
 /*
  * virtio related functions
@@ -204,7 +205,8 @@ static void drop_airq_indicator(struct virtqueue *vq, struct airq_info *info)
 	write_unlock_irqrestore(&info->lock, flags);
 }
 
-static void virtio_airq_handler(struct airq_struct *airq, bool floating)
+static void virtio_airq_handler(struct airq_struct *airq,
+				struct tpi_info *tpi_info)
 {
 	struct airq_info *info = container_of(airq, struct airq_info, airq);
 	unsigned long ai;
-- 
2.36.1

