Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886B71F0210
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 23:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbgFEVkR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 17:40:17 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53854 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728278AbgFEVkP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Jun 2020 17:40:15 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 055LWu8Z094844;
        Fri, 5 Jun 2020 17:40:13 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31fsnk7b3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 17:40:12 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 055Le3X6119018;
        Fri, 5 Jun 2020 17:40:12 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31fsnk7b3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 17:40:12 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 055La02q012409;
        Fri, 5 Jun 2020 21:40:11 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04wdc.us.ibm.com with ESMTP id 31bf49dgb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 21:40:11 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 055Le9FL43188512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Jun 2020 21:40:09 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA144AC05B;
        Fri,  5 Jun 2020 21:40:09 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55FB2AC05E;
        Fri,  5 Jun 2020 21:40:09 +0000 (GMT)
Received: from cpe-172-100-175-116.stny.res.rr.com.com (unknown [9.85.146.208])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  5 Jun 2020 21:40:09 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v8 01/16] s390/ap: introduce new ap function ap_get_qdev()
Date:   Fri,  5 Jun 2020 17:39:49 -0400
Message-Id: <20200605214004.14270-2-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200605214004.14270-1-akrowiak@linux.ibm.com>
References: <20200605214004.14270-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-05_07:2020-06-04,2020-06-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 cotscore=-2147483648 phishscore=0 impostorscore=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 bulkscore=0 clxscore=1011 suspectscore=3
 mlxlogscore=999 adultscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006050159
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Harald Freudenberger <freude@linux.ibm.com>

Provide a new interface function to be used by the ap drivers:
  struct ap_queue *ap_get_qdev(ap_qid_t qid);
Returns ptr to the struct ap_queue device or NULL if there
was no ap_queue device with this qid found. When something is
found, the reference count of the embedded device is increased.
So the caller has to decrease the reference count after use
with a call to put_device(&aq->ap_dev.device).

With this patch also the ap_card_list is removed from the
ap core code and a new hashtable is introduced which stores
hnodes of all the ap queues known to the ap bus.

The hashtable approach and a first implementation of this
interface comes from a previous patch from
Anthony Krowiak and an idea from Halil Pasic.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Suggested-by: Tony Krowiak <akrowiak@linux.ibm.com>
Suggested-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/ap_bus.c   | 94 +++++++++++++++++++---------------
 drivers/s390/crypto/ap_bus.h   | 25 +++++----
 drivers/s390/crypto/ap_card.c  | 47 +++++++++--------
 drivers/s390/crypto/ap_queue.c | 10 ++--
 4 files changed, 95 insertions(+), 81 deletions(-)

diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 35064443e748..e71ca4a719a5 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -62,8 +62,10 @@ MODULE_PARM_DESC(aqmask, "AP bus domain mask.");
 
 static struct device *ap_root_device;
 
-DEFINE_SPINLOCK(ap_list_lock);
-LIST_HEAD(ap_card_list);
+/* Hashtable of all queue devices on the AP bus */
+DEFINE_HASHTABLE(ap_queues, 8);
+/* lock used for the ap_queues hashtable */
+DEFINE_SPINLOCK(ap_queues_lock);
 
 /* Default permissions (ioctl, card and domain masking) */
 struct ap_perms ap_perms;
@@ -414,7 +416,7 @@ static void ap_interrupt_handler(struct airq_struct *airq, bool floating)
  */
 static void ap_tasklet_fn(unsigned long dummy)
 {
-	struct ap_card *ac;
+	int bkt;
 	struct ap_queue *aq;
 	enum ap_wait wait = AP_WAIT_NONE;
 
@@ -425,34 +427,30 @@ static void ap_tasklet_fn(unsigned long dummy)
 	if (ap_using_interrupts())
 		xchg(ap_airq.lsi_ptr, 0);
 
-	spin_lock_bh(&ap_list_lock);
-	for_each_ap_card(ac) {
-		for_each_ap_queue(aq, ac) {
-			spin_lock_bh(&aq->lock);
-			wait = min(wait, ap_sm_event_loop(aq, AP_EVENT_POLL));
-			spin_unlock_bh(&aq->lock);
-		}
+	spin_lock_bh(&ap_queues_lock);
+	hash_for_each(ap_queues, bkt, aq, hnode) {
+		spin_lock_bh(&aq->lock);
+		wait = min(wait, ap_sm_event_loop(aq, AP_EVENT_POLL));
+		spin_unlock_bh(&aq->lock);
 	}
-	spin_unlock_bh(&ap_list_lock);
+	spin_unlock_bh(&ap_queues_lock);
 
 	ap_wait(wait);
 }
 
 static int ap_pending_requests(void)
 {
-	struct ap_card *ac;
+	int bkt;
 	struct ap_queue *aq;
 
-	spin_lock_bh(&ap_list_lock);
-	for_each_ap_card(ac) {
-		for_each_ap_queue(aq, ac) {
-			if (aq->queue_count == 0)
-				continue;
-			spin_unlock_bh(&ap_list_lock);
-			return 1;
-		}
+	spin_lock_bh(&ap_queues_lock);
+	hash_for_each(ap_queues, bkt, aq, hnode) {
+		if (aq->queue_count == 0)
+			continue;
+		spin_unlock_bh(&ap_queues_lock);
+		return 1;
 	}
-	spin_unlock_bh(&ap_list_lock);
+	spin_unlock_bh(&ap_queues_lock);
 	return 0;
 }
 
@@ -683,24 +681,20 @@ static int ap_device_probe(struct device *dev)
 	}
 
 	/* Add queue/card to list of active queues/cards */
-	spin_lock_bh(&ap_list_lock);
-	if (is_card_dev(dev))
-		list_add(&to_ap_card(dev)->list, &ap_card_list);
-	else
-		list_add(&to_ap_queue(dev)->list,
-			 &to_ap_queue(dev)->card->queues);
-	spin_unlock_bh(&ap_list_lock);
+	spin_lock_bh(&ap_queues_lock);
+	if (is_queue_dev(dev))
+		hash_add(ap_queues, &to_ap_queue(dev)->hnode,
+			 to_ap_queue(dev)->qid);
+	spin_unlock_bh(&ap_queues_lock);
 
 	ap_dev->drv = ap_drv;
 	rc = ap_drv->probe ? ap_drv->probe(ap_dev) : -ENODEV;
 
 	if (rc) {
-		spin_lock_bh(&ap_list_lock);
-		if (is_card_dev(dev))
-			list_del_init(&to_ap_card(dev)->list);
-		else
-			list_del_init(&to_ap_queue(dev)->list);
-		spin_unlock_bh(&ap_list_lock);
+		spin_lock_bh(&ap_queues_lock);
+		if (is_queue_dev(dev))
+			hash_del(&to_ap_queue(dev)->hnode);
+		spin_unlock_bh(&ap_queues_lock);
 		ap_dev->drv = NULL;
 	}
 
@@ -725,16 +719,33 @@ static int ap_device_remove(struct device *dev)
 		ap_queue_remove(to_ap_queue(dev));
 
 	/* Remove queue/card from list of active queues/cards */
-	spin_lock_bh(&ap_list_lock);
-	if (is_card_dev(dev))
-		list_del_init(&to_ap_card(dev)->list);
-	else
-		list_del_init(&to_ap_queue(dev)->list);
-	spin_unlock_bh(&ap_list_lock);
+	spin_lock_bh(&ap_queues_lock);
+	if (is_queue_dev(dev))
+		hash_del(&to_ap_queue(dev)->hnode);
+	spin_unlock_bh(&ap_queues_lock);
 
 	return 0;
 }
 
+struct ap_queue *ap_get_qdev(ap_qid_t qid)
+{
+	int bkt;
+	struct ap_queue *aq;
+
+	spin_lock_bh(&ap_queues_lock);
+	hash_for_each(ap_queues, bkt, aq, hnode) {
+		if (aq->qid == qid) {
+			get_device(&aq->ap_dev.device);
+			spin_unlock_bh(&ap_queues_lock);
+			return aq;
+		}
+	}
+	spin_unlock_bh(&ap_queues_lock);
+
+	return NULL;
+}
+EXPORT_SYMBOL(ap_get_qdev);
+
 int ap_driver_register(struct ap_driver *ap_drv, struct module *owner,
 		       char *name)
 {
@@ -1506,6 +1517,9 @@ static int __init ap_module_init(void)
 		return -ENODEV;
 	}
 
+	/* init ap_queue hashtable */
+	hash_init(ap_queues);
+
 	/* set up the AP permissions (ioctls, ap and aq masks) */
 	ap_perms_init();
 
diff --git a/drivers/s390/crypto/ap_bus.h b/drivers/s390/crypto/ap_bus.h
index 8e8e37b6c0ee..053cc34d2ca2 100644
--- a/drivers/s390/crypto/ap_bus.h
+++ b/drivers/s390/crypto/ap_bus.h
@@ -15,6 +15,7 @@
 
 #include <linux/device.h>
 #include <linux/types.h>
+#include <linux/hashtable.h>
 #include <asm/isc.h>
 #include <asm/ap.h>
 
@@ -27,8 +28,8 @@
 
 extern int ap_domain_index;
 
-extern spinlock_t ap_list_lock;
-extern struct list_head ap_card_list;
+extern DECLARE_HASHTABLE(ap_queues, 8);
+extern spinlock_t ap_queues_lock;
 
 static inline int ap_test_bit(unsigned int *ptr, unsigned int nr)
 {
@@ -152,8 +153,6 @@ struct ap_device {
 
 struct ap_card {
 	struct ap_device ap_dev;
-	struct list_head list;		/* Private list of AP cards. */
-	struct list_head queues;	/* List of assoc. AP queues */
 	void *private;			/* ap driver private pointer. */
 	int raw_hwtype;			/* AP raw hardware type. */
 	unsigned int functions;		/* AP device function bitfield. */
@@ -166,7 +165,7 @@ struct ap_card {
 
 struct ap_queue {
 	struct ap_device ap_dev;
-	struct list_head list;		/* Private list of AP queues. */
+	struct hlist_node hnode;	/* Node for the ap_queues hashtable */
 	struct ap_card *card;		/* Ptr to assoc. AP card. */
 	spinlock_t lock;		/* Per device lock. */
 	void *private;			/* ap driver private pointer. */
@@ -223,12 +222,6 @@ static inline void ap_release_message(struct ap_message *ap_msg)
 	kzfree(ap_msg->private);
 }
 
-#define for_each_ap_card(_ac) \
-	list_for_each_entry(_ac, &ap_card_list, list)
-
-#define for_each_ap_queue(_aq, _ac) \
-	list_for_each_entry(_aq, &(_ac)->queues, list)
-
 /*
  * Note: don't use ap_send/ap_recv after using ap_queue_message
  * for the first time. Otherwise the ap message queue will get
@@ -269,6 +262,16 @@ struct ap_perms {
 extern struct ap_perms ap_perms;
 extern struct mutex ap_perms_mutex;
 
+/*
+ * Get ap_queue device for this qid.
+ * Returns ptr to the struct ap_queue device or NULL if there
+ * was no ap_queue device with this qid found. When something is
+ * found, the reference count of the embedded device is increased.
+ * So the caller has to decrease the reference count after use
+ * with a call to put_device(&aq->ap_dev.device).
+ */
+struct ap_queue *ap_get_qdev(ap_qid_t qid);
+
 /*
  * check APQN for owned/reserved by ap bus and default driver(s).
  * Checks if this APQN is or will be in use by the ap bus
diff --git a/drivers/s390/crypto/ap_card.c b/drivers/s390/crypto/ap_card.c
index 0a39dfdb6a1d..6588713319ba 100644
--- a/drivers/s390/crypto/ap_card.c
+++ b/drivers/s390/crypto/ap_card.c
@@ -66,9 +66,9 @@ static ssize_t request_count_show(struct device *dev,
 	u64 req_cnt;
 
 	req_cnt = 0;
-	spin_lock_bh(&ap_list_lock);
+	spin_lock_bh(&ap_queues_lock);
 	req_cnt = atomic64_read(&ac->total_request_count);
-	spin_unlock_bh(&ap_list_lock);
+	spin_unlock_bh(&ap_queues_lock);
 	return scnprintf(buf, PAGE_SIZE, "%llu\n", req_cnt);
 }
 
@@ -76,13 +76,15 @@ static ssize_t request_count_store(struct device *dev,
 				   struct device_attribute *attr,
 				   const char *buf, size_t count)
 {
-	struct ap_card *ac = to_ap_card(dev);
+	int bkt;
 	struct ap_queue *aq;
+	struct ap_card *ac = to_ap_card(dev);
 
-	spin_lock_bh(&ap_list_lock);
-	for_each_ap_queue(aq, ac)
-		aq->total_request_count = 0;
-	spin_unlock_bh(&ap_list_lock);
+	spin_lock_bh(&ap_queues_lock);
+	hash_for_each(ap_queues, bkt, aq, hnode)
+		if (ac == aq->card)
+			aq->total_request_count = 0;
+	spin_unlock_bh(&ap_queues_lock);
 	atomic64_set(&ac->total_request_count, 0);
 
 	return count;
@@ -93,15 +95,17 @@ static DEVICE_ATTR_RW(request_count);
 static ssize_t requestq_count_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
-	struct ap_card *ac = to_ap_card(dev);
+	int bkt;
 	struct ap_queue *aq;
 	unsigned int reqq_cnt;
+	struct ap_card *ac = to_ap_card(dev);
 
 	reqq_cnt = 0;
-	spin_lock_bh(&ap_list_lock);
-	for_each_ap_queue(aq, ac)
-		reqq_cnt += aq->requestq_count;
-	spin_unlock_bh(&ap_list_lock);
+	spin_lock_bh(&ap_queues_lock);
+	hash_for_each(ap_queues, bkt, aq, hnode)
+		if (ac == aq->card)
+			reqq_cnt += aq->requestq_count;
+	spin_unlock_bh(&ap_queues_lock);
 	return scnprintf(buf, PAGE_SIZE, "%d\n", reqq_cnt);
 }
 
@@ -110,15 +114,17 @@ static DEVICE_ATTR_RO(requestq_count);
 static ssize_t pendingq_count_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
-	struct ap_card *ac = to_ap_card(dev);
+	int bkt;
 	struct ap_queue *aq;
 	unsigned int penq_cnt;
+	struct ap_card *ac = to_ap_card(dev);
 
 	penq_cnt = 0;
-	spin_lock_bh(&ap_list_lock);
-	for_each_ap_queue(aq, ac)
-		penq_cnt += aq->pendingq_count;
-	spin_unlock_bh(&ap_list_lock);
+	spin_lock_bh(&ap_queues_lock);
+	hash_for_each(ap_queues, bkt, aq, hnode)
+		if (ac == aq->card)
+			penq_cnt += aq->pendingq_count;
+	spin_unlock_bh(&ap_queues_lock);
 	return scnprintf(buf, PAGE_SIZE, "%d\n", penq_cnt);
 }
 
@@ -163,11 +169,6 @@ static void ap_card_device_release(struct device *dev)
 {
 	struct ap_card *ac = to_ap_card(dev);
 
-	if (!list_empty(&ac->list)) {
-		spin_lock_bh(&ap_list_lock);
-		list_del_init(&ac->list);
-		spin_unlock_bh(&ap_list_lock);
-	}
 	kfree(ac);
 }
 
@@ -179,8 +180,6 @@ struct ap_card *ap_card_create(int id, int queue_depth, int raw_type,
 	ac = kzalloc(sizeof(*ac), GFP_KERNEL);
 	if (!ac)
 		return NULL;
-	INIT_LIST_HEAD(&ac->list);
-	INIT_LIST_HEAD(&ac->queues);
 	ac->ap_dev.device.release = ap_card_device_release;
 	ac->ap_dev.device.type = &ap_card_type;
 	ac->ap_dev.device_type = comp_type;
diff --git a/drivers/s390/crypto/ap_queue.c b/drivers/s390/crypto/ap_queue.c
index 0eaf1d04e8df..73b077dca3e6 100644
--- a/drivers/s390/crypto/ap_queue.c
+++ b/drivers/s390/crypto/ap_queue.c
@@ -568,11 +568,10 @@ static void ap_queue_device_release(struct device *dev)
 {
 	struct ap_queue *aq = to_ap_queue(dev);
 
-	if (!list_empty(&aq->list)) {
-		spin_lock_bh(&ap_list_lock);
-		list_del_init(&aq->list);
-		spin_unlock_bh(&ap_list_lock);
-	}
+	spin_lock_bh(&ap_queues_lock);
+	hash_del(&aq->hnode);
+	spin_unlock_bh(&ap_queues_lock);
+
 	kfree(aq);
 }
 
@@ -590,7 +589,6 @@ struct ap_queue *ap_queue_create(ap_qid_t qid, int device_type)
 	aq->state = AP_STATE_UNBOUND;
 	aq->interrupt = AP_INTR_DISABLED;
 	spin_lock_init(&aq->lock);
-	INIT_LIST_HEAD(&aq->list);
 	INIT_LIST_HEAD(&aq->pendingq);
 	INIT_LIST_HEAD(&aq->requestq);
 	timer_setup(&aq->timeout, ap_request_timeout, 0);
-- 
2.21.1

