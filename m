Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 203D416A537
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 12:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgBXLlQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 06:41:16 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57872 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727185AbgBXLlP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Feb 2020 06:41:15 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01OBckT1005573;
        Mon, 24 Feb 2020 06:41:13 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yaygnpg51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 06:41:13 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01OBew4b010351;
        Mon, 24 Feb 2020 06:41:12 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yaygnpg4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 06:41:12 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01OBZALb021354;
        Mon, 24 Feb 2020 11:41:12 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03dal.us.ibm.com with ESMTP id 2yaux5yvf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 11:41:12 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01OBf98s33554702
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 11:41:09 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD44A2805E;
        Mon, 24 Feb 2020 11:41:09 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A06CB28059;
        Mon, 24 Feb 2020 11:41:09 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 24 Feb 2020 11:41:09 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH v4 02/36] KVM: s390/interrupt: do not pin adapter interrupt pages
Date:   Mon, 24 Feb 2020 06:40:33 -0500
Message-Id: <20200224114107.4646-3-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200224114107.4646-1-borntraeger@de.ibm.com>
References: <20200224114107.4646-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-24_02:2020-02-21,2020-02-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=2
 bulkscore=0 malwarescore=0 adultscore=0 priorityscore=1501 spamscore=0
 phishscore=0 clxscore=1015 impostorscore=0 mlxlogscore=991
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>

The adapter interrupt page containing the indicator bits is currently
pinned. That means that a guest with many devices can pin a lot of
memory pages in the host. This also complicates the reference tracking
which is needed for memory management handling of protected virtual
machines. It might also have some strange side effects for madvise
MADV_DONTNEED and other things.

We can simply try to get the userspace page set the bits and free the
page. By storing the userspace address in the irq routing entry instead
of the guest address we can actually avoid many lookups and list walks
so that this variant is very likely not slower.

If userspace messes around with the memory slots the worst thing that
can happen is that we write to some other memory within that process.
As we get the the page with FOLL_WRITE this can also not be used to
write to shared read-only pages.

Signed-off-by: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
[borntraeger@de.ibm.com: patch simplification]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 Documentation/virt/kvm/devices/s390_flic.rst |  11 +-
 arch/s390/include/asm/kvm_host.h             |   3 -
 arch/s390/kvm/interrupt.c                    | 170 ++++++-------------
 3 files changed, 51 insertions(+), 133 deletions(-)

diff --git a/Documentation/virt/kvm/devices/s390_flic.rst b/Documentation/virt/kvm/devices/s390_flic.rst
index 954190da7d04..ea96559ba501 100644
--- a/Documentation/virt/kvm/devices/s390_flic.rst
+++ b/Documentation/virt/kvm/devices/s390_flic.rst
@@ -108,16 +108,9 @@ Groups:
       mask or unmask the adapter, as specified in mask
 
     KVM_S390_IO_ADAPTER_MAP
-      perform a gmap translation for the guest address provided in addr,
-      pin a userspace page for the translated address and add it to the
-      list of mappings
-
-      .. note:: A new mapping will be created unconditionally; therefore,
-	        the calling code should avoid making duplicate mappings.
-
+      This is now a no-op. The mapping is purely done by the irq route.
     KVM_S390_IO_ADAPTER_UNMAP
-      release a userspace page for the translated address specified in addr
-      from the list of mappings
+      This is now a no-op. The mapping is purely done by the irq route.
 
   KVM_DEV_FLIC_AISM
     modify the adapter-interruption-suppression mode for a given isc if the
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 1726224e7772..d058289385a5 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -701,9 +701,6 @@ struct s390_io_adapter {
 	bool masked;
 	bool swap;
 	bool suppressible;
-	struct rw_semaphore maps_lock;
-	struct list_head maps;
-	atomic_t nr_maps;
 };
 
 #define MAX_S390_IO_ADAPTERS ((MAX_ISC + 1) * 8)
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index c06c89d370a7..d29f575fb372 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -2,7 +2,7 @@
 /*
  * handling kvm guest interrupts
  *
- * Copyright IBM Corp. 2008, 2015
+ * Copyright IBM Corp. 2008, 2020
  *
  *    Author(s): Carsten Otte <cotte@de.ibm.com>
  */
@@ -2327,9 +2327,6 @@ static int register_io_adapter(struct kvm_device *dev,
 	if (!adapter)
 		return -ENOMEM;
 
-	INIT_LIST_HEAD(&adapter->maps);
-	init_rwsem(&adapter->maps_lock);
-	atomic_set(&adapter->nr_maps, 0);
 	adapter->id = adapter_info.id;
 	adapter->isc = adapter_info.isc;
 	adapter->maskable = adapter_info.maskable;
@@ -2354,87 +2351,12 @@ int kvm_s390_mask_adapter(struct kvm *kvm, unsigned int id, bool masked)
 	return ret;
 }
 
-static int kvm_s390_adapter_map(struct kvm *kvm, unsigned int id, __u64 addr)
-{
-	struct s390_io_adapter *adapter = get_io_adapter(kvm, id);
-	struct s390_map_info *map;
-	int ret;
-
-	if (!adapter || !addr)
-		return -EINVAL;
-
-	map = kzalloc(sizeof(*map), GFP_KERNEL);
-	if (!map) {
-		ret = -ENOMEM;
-		goto out;
-	}
-	INIT_LIST_HEAD(&map->list);
-	map->guest_addr = addr;
-	map->addr = gmap_translate(kvm->arch.gmap, addr);
-	if (map->addr == -EFAULT) {
-		ret = -EFAULT;
-		goto out;
-	}
-	ret = get_user_pages_fast(map->addr, 1, FOLL_WRITE, &map->page);
-	if (ret < 0)
-		goto out;
-	BUG_ON(ret != 1);
-	down_write(&adapter->maps_lock);
-	if (atomic_inc_return(&adapter->nr_maps) < MAX_S390_ADAPTER_MAPS) {
-		list_add_tail(&map->list, &adapter->maps);
-		ret = 0;
-	} else {
-		put_page(map->page);
-		ret = -EINVAL;
-	}
-	up_write(&adapter->maps_lock);
-out:
-	if (ret)
-		kfree(map);
-	return ret;
-}
-
-static int kvm_s390_adapter_unmap(struct kvm *kvm, unsigned int id, __u64 addr)
-{
-	struct s390_io_adapter *adapter = get_io_adapter(kvm, id);
-	struct s390_map_info *map, *tmp;
-	int found = 0;
-
-	if (!adapter || !addr)
-		return -EINVAL;
-
-	down_write(&adapter->maps_lock);
-	list_for_each_entry_safe(map, tmp, &adapter->maps, list) {
-		if (map->guest_addr == addr) {
-			found = 1;
-			atomic_dec(&adapter->nr_maps);
-			list_del(&map->list);
-			put_page(map->page);
-			kfree(map);
-			break;
-		}
-	}
-	up_write(&adapter->maps_lock);
-
-	return found ? 0 : -EINVAL;
-}
-
 void kvm_s390_destroy_adapters(struct kvm *kvm)
 {
 	int i;
-	struct s390_map_info *map, *tmp;
 
-	for (i = 0; i < MAX_S390_IO_ADAPTERS; i++) {
-		if (!kvm->arch.adapters[i])
-			continue;
-		list_for_each_entry_safe(map, tmp,
-					 &kvm->arch.adapters[i]->maps, list) {
-			list_del(&map->list);
-			put_page(map->page);
-			kfree(map);
-		}
+	for (i = 0; i < MAX_S390_IO_ADAPTERS; i++)
 		kfree(kvm->arch.adapters[i]);
-	}
 }
 
 static int modify_io_adapter(struct kvm_device *dev,
@@ -2456,11 +2378,14 @@ static int modify_io_adapter(struct kvm_device *dev,
 		if (ret > 0)
 			ret = 0;
 		break;
+	/*
+	 * The following operations are no longer needed and therefore no-ops.
+	 * The gpa to hva translation is done when an IRQ route is set up. The
+	 * set_irq code uses get_user_pages_remote() to do the actual write.
+	 */
 	case KVM_S390_IO_ADAPTER_MAP:
-		ret = kvm_s390_adapter_map(dev->kvm, req.id, req.addr);
-		break;
 	case KVM_S390_IO_ADAPTER_UNMAP:
-		ret = kvm_s390_adapter_unmap(dev->kvm, req.id, req.addr);
+		ret = 0;
 		break;
 	default:
 		ret = -EINVAL;
@@ -2699,19 +2624,15 @@ static unsigned long get_ind_bit(__u64 addr, unsigned long bit_nr, bool swap)
 	return swap ? (bit ^ (BITS_PER_LONG - 1)) : bit;
 }
 
-static struct s390_map_info *get_map_info(struct s390_io_adapter *adapter,
-					  u64 addr)
+static struct page *get_map_page(struct kvm *kvm, u64 uaddr)
 {
-	struct s390_map_info *map;
+	struct page *page = NULL;
 
-	if (!adapter)
-		return NULL;
-
-	list_for_each_entry(map, &adapter->maps, list) {
-		if (map->guest_addr == addr)
-			return map;
-	}
-	return NULL;
+	down_read(&kvm->mm->mmap_sem);
+	get_user_pages_remote(NULL, kvm->mm, uaddr, 1, FOLL_WRITE,
+			      &page, NULL, NULL);
+	up_read(&kvm->mm->mmap_sem);
+	return page;
 }
 
 static int adapter_indicators_set(struct kvm *kvm,
@@ -2720,30 +2641,35 @@ static int adapter_indicators_set(struct kvm *kvm,
 {
 	unsigned long bit;
 	int summary_set, idx;
-	struct s390_map_info *info;
+	struct page *ind_page, *summary_page;
 	void *map;
 
-	info = get_map_info(adapter, adapter_int->ind_addr);
-	if (!info)
+	ind_page = get_map_page(kvm, adapter_int->ind_addr);
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
+	summary_page = get_map_page(kvm, adapter_int->summary_addr);
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
 
@@ -2765,9 +2691,7 @@ static int set_adapter_int(struct kvm_kernel_irq_routing_entry *e,
 	adapter = get_io_adapter(kvm, e->adapter.adapter_id);
 	if (!adapter)
 		return -1;
-	down_read(&adapter->maps_lock);
 	ret = adapter_indicators_set(kvm, adapter, &e->adapter);
-	up_read(&adapter->maps_lock);
 	if ((ret > 0) && !adapter->masked) {
 		ret = kvm_s390_inject_airq(kvm, adapter);
 		if (ret == 0)
@@ -2818,23 +2742,27 @@ int kvm_set_routing_entry(struct kvm *kvm,
 			  struct kvm_kernel_irq_routing_entry *e,
 			  const struct kvm_irq_routing_entry *ue)
 {
-	int ret;
+	u64 uaddr;
 
 	switch (ue->type) {
+	/* we store the userspace addresses instead of the guest addresses */
 	case KVM_IRQ_ROUTING_S390_ADAPTER:
 		e->set = set_adapter_int;
-		e->adapter.summary_addr = ue->u.adapter.summary_addr;
-		e->adapter.ind_addr = ue->u.adapter.ind_addr;
+		uaddr =  gmap_translate(kvm->arch.gmap, ue->u.adapter.summary_addr);
+		if (uaddr == -EFAULT)
+			return -EFAULT;
+		e->adapter.summary_addr = uaddr;
+		uaddr =  gmap_translate(kvm->arch.gmap, ue->u.adapter.ind_addr);
+		if (uaddr == -EFAULT)
+			return -EFAULT;
+		e->adapter.ind_addr = uaddr;
 		e->adapter.summary_offset = ue->u.adapter.summary_offset;
 		e->adapter.ind_offset = ue->u.adapter.ind_offset;
 		e->adapter.adapter_id = ue->u.adapter.adapter_id;
-		ret = 0;
-		break;
+		return 0;
 	default:
-		ret = -EINVAL;
+		return -EINVAL;
 	}
-
-	return ret;
 }
 
 int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm,
-- 
2.25.0

