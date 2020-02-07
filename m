Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16F201556EC
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 12:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbgBGLk3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 06:40:29 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26136 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727117AbgBGLkI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 06:40:08 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 017BcBCv117405;
        Fri, 7 Feb 2020 06:40:04 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y0knevr0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Feb 2020 06:40:04 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 017Be3wp124262;
        Fri, 7 Feb 2020 06:40:03 -0500
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y0knevqy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Feb 2020 06:40:03 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 017BclGP006538;
        Fri, 7 Feb 2020 11:40:02 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma05wdc.us.ibm.com with ESMTP id 2xykc9vt3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Feb 2020 11:40:02 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 017Be0N152363584
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Feb 2020 11:40:00 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B70AAC05B;
        Fri,  7 Feb 2020 11:40:00 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52AFDAC064;
        Fri,  7 Feb 2020 11:40:00 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  7 Feb 2020 11:40:00 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 02/35] KVM: s390/interrupt: do not pin adapter interrupt pages
Date:   Fri,  7 Feb 2020 06:39:25 -0500
Message-Id: <20200207113958.7320-3-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200207113958.7320-1-borntraeger@de.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-07_01:2020-02-07,2020-02-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=930 adultscore=0 impostorscore=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002070089
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>

The adapter interrupt page containing the indicator bits is currently
pinned. That means that a guest with many devices can pin a lot of
memory pages in the host. This also complicates the reference tracking
which is needed for memory management handling of protected virtual
machines.
We can reuse the pte notifiers to "cache" the page without pinning it.

Signed-off-by: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Suggested-by: Andrea Arcangeli <aarcange@redhat.com>
[borntraeger@de.ibm.com: patch merging, splitting, fixing]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |   4 +-
 arch/s390/kvm/interrupt.c        | 155 +++++++++++++++++++++++--------
 arch/s390/kvm/kvm-s390.c         |   4 +
 arch/s390/kvm/kvm-s390.h         |   2 +
 4 files changed, 123 insertions(+), 42 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 73044545ecac..884503e05424 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -701,9 +701,9 @@ struct s390_io_adapter {
 	bool masked;
 	bool swap;
 	bool suppressible;
-	struct rw_semaphore maps_lock;
+	spinlock_t maps_lock;
 	struct list_head maps;
-	atomic_t nr_maps;
+	int nr_maps;
 };
 
 #define MAX_S390_IO_ADAPTERS ((MAX_ISC + 1) * 8)
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index c06c89d370a7..4bfb2f8fe57c 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -28,6 +28,7 @@
 #include <asm/switch_to.h>
 #include <asm/nmi.h>
 #include <asm/airq.h>
+#include <linux/pagemap.h>
 #include "kvm-s390.h"
 #include "gaccess.h"
 #include "trace-s390.h"
@@ -2328,8 +2329,8 @@ static int register_io_adapter(struct kvm_device *dev,
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&adapter->maps);
-	init_rwsem(&adapter->maps_lock);
-	atomic_set(&adapter->nr_maps, 0);
+	spin_lock_init(&adapter->maps_lock);
+	adapter->nr_maps = 0;
 	adapter->id = adapter_info.id;
 	adapter->isc = adapter_info.isc;
 	adapter->maskable = adapter_info.maskable;
@@ -2375,19 +2376,15 @@ static int kvm_s390_adapter_map(struct kvm *kvm, unsigned int id, __u64 addr)
 		ret = -EFAULT;
 		goto out;
 	}
-	ret = get_user_pages_fast(map->addr, 1, FOLL_WRITE, &map->page);
-	if (ret < 0)
-		goto out;
-	BUG_ON(ret != 1);
-	down_write(&adapter->maps_lock);
-	if (atomic_inc_return(&adapter->nr_maps) < MAX_S390_ADAPTER_MAPS) {
+	spin_lock(&adapter->maps_lock);
+	if (adapter->nr_maps < MAX_S390_ADAPTER_MAPS) {
+		adapter->nr_maps++;
 		list_add_tail(&map->list, &adapter->maps);
 		ret = 0;
 	} else {
-		put_page(map->page);
 		ret = -EINVAL;
 	}
-	up_write(&adapter->maps_lock);
+	spin_unlock(&adapter->maps_lock);
 out:
 	if (ret)
 		kfree(map);
@@ -2403,18 +2400,17 @@ static int kvm_s390_adapter_unmap(struct kvm *kvm, unsigned int id, __u64 addr)
 	if (!adapter || !addr)
 		return -EINVAL;
 
-	down_write(&adapter->maps_lock);
+	spin_lock(&adapter->maps_lock);
 	list_for_each_entry_safe(map, tmp, &adapter->maps, list) {
 		if (map->guest_addr == addr) {
 			found = 1;
-			atomic_dec(&adapter->nr_maps);
+			adapter->nr_maps--;
 			list_del(&map->list);
-			put_page(map->page);
 			kfree(map);
 			break;
 		}
 	}
-	up_write(&adapter->maps_lock);
+	spin_unlock(&adapter->maps_lock);
 
 	return found ? 0 : -EINVAL;
 }
@@ -2430,7 +2426,6 @@ void kvm_s390_destroy_adapters(struct kvm *kvm)
 		list_for_each_entry_safe(map, tmp,
 					 &kvm->arch.adapters[i]->maps, list) {
 			list_del(&map->list);
-			put_page(map->page);
 			kfree(map);
 		}
 		kfree(kvm->arch.adapters[i]);
@@ -2690,6 +2685,31 @@ struct kvm_device_ops kvm_flic_ops = {
 	.destroy = flic_destroy,
 };
 
+void kvm_s390_adapter_gmap_notifier(struct gmap *gmap, unsigned long start,
+				    unsigned long end)
+{
+	struct kvm *kvm = gmap->private;
+	struct s390_map_info *map, *tmp;
+	int i;
+
+	for (i = 0; i < MAX_S390_IO_ADAPTERS; i++) {
+		struct s390_io_adapter *adapter = kvm->arch.adapters[i];
+
+		if (!adapter)
+			continue;
+		spin_lock(&adapter->maps_lock);
+		list_for_each_entry_safe(map, tmp, &adapter->maps, list) {
+			if (start <= map->guest_addr && map->guest_addr < end) {
+				if (IS_ERR(map->page))
+					map->page = ERR_PTR(-EAGAIN);
+				else
+					map->page = NULL;
+			}
+		}
+		spin_unlock(&adapter->maps_lock);
+	}
+}
+
 static unsigned long get_ind_bit(__u64 addr, unsigned long bit_nr, bool swap)
 {
 	unsigned long bit;
@@ -2699,19 +2719,71 @@ static unsigned long get_ind_bit(__u64 addr, unsigned long bit_nr, bool swap)
 	return swap ? (bit ^ (BITS_PER_LONG - 1)) : bit;
 }
 
-static struct s390_map_info *get_map_info(struct s390_io_adapter *adapter,
-					  u64 addr)
+static struct page *get_map_page(struct kvm *kvm,
+				 struct s390_io_adapter *adapter,
+				 u64 addr)
 {
 	struct s390_map_info *map;
+	unsigned long uaddr;
+	struct page *page;
+	bool need_retry;
+	int ret;
 
 	if (!adapter)
 		return NULL;
+retry:
+	page = NULL;
+	uaddr = 0;
+	spin_lock(&adapter->maps_lock);
+	list_for_each_entry(map, &adapter->maps, list)
+		if (map->guest_addr == addr) {
+			uaddr = map->addr;
+			page = map->page;
+			if (!page)
+				map->page = ERR_PTR(-EBUSY);
+			else if (IS_ERR(page) || !page_cache_get_speculative(page)) {
+				spin_unlock(&adapter->maps_lock);
+				goto retry;
+			}
+			break;
+		}
+	spin_unlock(&adapter->maps_lock);
+
+	if (page)
+		return page;
+	if (!uaddr)
+		return NULL;
 
-	list_for_each_entry(map, &adapter->maps, list) {
-		if (map->guest_addr == addr)
-			return map;
+	down_read(&kvm->mm->mmap_sem);
+	ret = set_pgste_bits(kvm->mm, uaddr, PGSTE_IN_BIT, PGSTE_IN_BIT);
+	if (ret)
+		goto fail;
+	ret = get_user_pages_remote(NULL, kvm->mm, uaddr, 1, FOLL_WRITE,
+				    &page, NULL, NULL);
+	if (ret < 1)
+		page = NULL;
+fail:
+	up_read(&kvm->mm->mmap_sem);
+	need_retry = true;
+	spin_lock(&adapter->maps_lock);
+	list_for_each_entry(map, &adapter->maps, list)
+		if (map->guest_addr == addr) {
+			if (map->page == ERR_PTR(-EBUSY)) {
+				map->page = page;
+				need_retry = false;
+			} else if (IS_ERR(map->page)) {
+				map->page = NULL;
+			}
+			break;
+		}
+	spin_unlock(&adapter->maps_lock);
+	if (need_retry) {
+		if (page)
+			put_page(page);
+		goto retry;
 	}
-	return NULL;
+
+	return page;
 }
 
 static int adapter_indicators_set(struct kvm *kvm,
@@ -2720,30 +2792,35 @@ static int adapter_indicators_set(struct kvm *kvm,
 {
 	unsigned long bit;
 	int summary_set, idx;
-	struct s390_map_info *info;
+	struct page *ind_page, *summary_page;
 	void *map;
 
-	info = get_map_info(adapter, adapter_int->ind_addr);
-	if (!info)
+	ind_page = get_map_page(kvm, adapter, adapter_int->ind_addr);
+	if (!ind_page)
 		return -1;
-	map = page_address(info->page);
-	bit = get_ind_bit(info->addr, adapter_int->ind_offset, adapter->swap);
-	set_bit(bit, map);
-	idx = srcu_read_lock(&kvm->srcu);
-	mark_page_dirty(kvm, info->guest_addr >> PAGE_SHIFT);
-	set_page_dirty_lock(info->page);
-	info = get_map_info(adapter, adapter_int->summary_addr);
-	if (!info) {
-		srcu_read_unlock(&kvm->srcu, idx);
+	summary_page = get_map_page(kvm, adapter, adapter_int->summary_addr);
+	if (!summary_page) {
+		put_page(ind_page);
 		return -1;
 	}
-	map = page_address(info->page);
-	bit = get_ind_bit(info->addr, adapter_int->summary_offset,
-			  adapter->swap);
+
+	idx = srcu_read_lock(&kvm->srcu);
+	map = page_address(ind_page);
+	bit = get_ind_bit(adapter_int->ind_addr,
+			  adapter_int->ind_offset, adapter->swap);
+	set_bit(bit, map);
+	mark_page_dirty(kvm, adapter_int->ind_addr >> PAGE_SHIFT);
+	set_page_dirty_lock(ind_page);
+	map = page_address(summary_page);
+	bit = get_ind_bit(adapter_int->summary_addr,
+			  adapter_int->summary_offset, adapter->swap);
 	summary_set = test_and_set_bit(bit, map);
-	mark_page_dirty(kvm, info->guest_addr >> PAGE_SHIFT);
-	set_page_dirty_lock(info->page);
+	mark_page_dirty(kvm, adapter_int->summary_addr >> PAGE_SHIFT);
+	set_page_dirty_lock(summary_page);
 	srcu_read_unlock(&kvm->srcu, idx);
+
+	put_page(ind_page);
+	put_page(summary_page);
 	return summary_set ? 0 : 1;
 }
 
@@ -2765,9 +2842,7 @@ static int set_adapter_int(struct kvm_kernel_irq_routing_entry *e,
 	adapter = get_io_adapter(kvm, e->adapter.adapter_id);
 	if (!adapter)
 		return -1;
-	down_read(&adapter->maps_lock);
 	ret = adapter_indicators_set(kvm, adapter, &e->adapter);
-	up_read(&adapter->maps_lock);
 	if ((ret > 0) && !adapter->masked) {
 		ret = kvm_s390_inject_airq(kvm, adapter);
 		if (ret == 0)
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index e39f6ef97b09..1a48214ac507 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -219,6 +219,7 @@ static struct kvm_s390_vm_cpu_subfunc kvm_s390_available_subfunc;
 
 static struct gmap_notifier gmap_notifier;
 static struct gmap_notifier vsie_gmap_notifier;
+static struct gmap_notifier adapter_gmap_notifier;
 debug_info_t *kvm_s390_dbf;
 
 /* Section: not file related */
@@ -299,6 +300,8 @@ int kvm_arch_hardware_setup(void)
 	gmap_register_pte_notifier(&gmap_notifier);
 	vsie_gmap_notifier.notifier_call = kvm_s390_vsie_gmap_notifier;
 	gmap_register_pte_notifier(&vsie_gmap_notifier);
+	adapter_gmap_notifier.notifier_call = kvm_s390_adapter_gmap_notifier;
+	gmap_register_pte_notifier(&adapter_gmap_notifier);
 	atomic_notifier_chain_register(&s390_epoch_delta_notifier,
 				       &kvm_clock_notifier);
 	return 0;
@@ -308,6 +311,7 @@ void kvm_arch_hardware_unsetup(void)
 {
 	gmap_unregister_pte_notifier(&gmap_notifier);
 	gmap_unregister_pte_notifier(&vsie_gmap_notifier);
+	gmap_unregister_pte_notifier(&adapter_gmap_notifier);
 	atomic_notifier_chain_unregister(&s390_epoch_delta_notifier,
 					 &kvm_clock_notifier);
 }
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 6d9448dbd052..54c5eb4b275d 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -367,6 +367,8 @@ int s390int_to_s390irq(struct kvm_s390_interrupt *s390int,
 			struct kvm_s390_irq *s390irq);
 
 /* implemented in interrupt.c */
+void kvm_s390_adapter_gmap_notifier(struct gmap *gmap, unsigned long start,
+				    unsigned long end);
 int kvm_s390_vcpu_has_irq(struct kvm_vcpu *vcpu, int exclude_stop);
 int psw_extint_disabled(struct kvm_vcpu *vcpu);
 void kvm_s390_destroy_adapters(struct kvm *kvm);
-- 
2.24.0

