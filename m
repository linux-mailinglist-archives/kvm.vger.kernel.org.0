Return-Path: <kvm+bounces-58649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B6B2B9A2DC
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 16:12:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 53E0D19C578E
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 14:12:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEB70305068;
	Wed, 24 Sep 2025 14:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="gglMehBK"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.57.120.243])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4221A841C;
	Wed, 24 Sep 2025 14:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.57.120.243
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758723125; cv=none; b=gBVhPv+Jps6IfmBQXpEyGCZz4Emp1oEHhNlwa9CgyEZnaJJFfTsG36f1vPqMnO6Ge0U3GrssT2ewbVnqOVR/dreyXBqNLnsb+oQ+DNntGsWbru00ZPXK90TUAmQzpfgab0NA/Jk/HKm4RPmNXl9lHIFZdbFC4YbXgKQkDpjQMVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758723125; c=relaxed/simple;
	bh=DPvxm+FfMOM5QjeAEmx9j5Fwj34KHgDs0wexiRvQ1U0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fGssTvvfPoyrqDXG6GlCWaTtVYlIAZjkBV6WUZXcV4QI5jSnwsFXoU0GDoO1FUgLodX6e9mIIsq2qGqFX3mxF2Pn7XERjFuskuyS/5Bu1f7z5wJ5zwnckJuUuH5LybGhrxrE5DOORbgx4cC14o7v15IeN15EkPF/7SQJyN6vXC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=gglMehBK; arc=none smtp.client-ip=52.57.120.243
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1758723123; x=1790259123;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zfql9UowG8WIegMp+ynWapRYmAIWirTs7yiufqTrTrs=;
  b=gglMehBKAi2HlhqiqG9H07ALfuCX0YaTm25Qw1kHp2FPNzgJZ7gvd5FL
   7RO7b00vXPD4E8LunBqXc+X7YbHfrbSuLpW77hkPtL+kAUSJK7HGWCHwD
   SNadWjA53hrltDaMmlhlvU53nDa+Fiu2IBJC/4t7SAr496VFn0lS/VSmG
   MHMHz2sN+3pCQZPbxZxcChxPDipHFSHdFnn30xjxxRasiA5YLqhgkLaCL
   Kyce+c+VD/uGF0I4kJ7EttJk72dkiRAoq/ElUooibiSpe02GMkEgIwY26
   oKIbHAZYNwZkr3S+cqhlQ1yMXexbzQQsRzNV0/KDN6xocg71jwQcGXWdT
   Q==;
X-CSE-ConnectionGUID: Nwrmg35MQmu+3p5o0heSag==
X-CSE-MsgGUID: sz8V3zpBRwug1UcpPuxcNw==
X-IronPort-AV: E=Sophos;i="6.18,290,1751241600"; 
   d="scan'208";a="2511497"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 14:11:53 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:14147]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.23.230:2525] with esmtp (Farcaster)
 id e5c7181d-828d-417b-8d5b-ea01043c173b; Wed, 24 Sep 2025 14:11:53 +0000 (UTC)
X-Farcaster-Flow-ID: e5c7181d-828d-417b-8d5b-ea01043c173b
Received: from EX19D039EUC004.ant.amazon.com (10.252.61.190) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 14:11:51 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com
 (10.253.107.175) by EX19D039EUC004.ant.amazon.com (10.252.61.190) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 24 Sep 2025
 14:11:48 +0000
From: Mahmoud Adam <mngyadam@amazon.de>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <jgg@ziepe.ca>, <kbusch@kernel.org>,
	<benh@kernel.crashing.org>, David Woodhouse <dwmw@amazon.co.uk>,
	<pravkmr@amazon.de>, <nagy@khwaternagy.com>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 3/7] vfio/pci: add RCU locking for regions access
Date: Wed, 24 Sep 2025 16:09:54 +0200
Message-ID: <20250924141018.80202-4-mngyadam@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924141018.80202-1-mngyadam@amazon.de>
References: <20250924141018.80202-1-mngyadam@amazon.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D039EUC004.ant.amazon.com (10.252.61.190)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Since we could request to add more regions after initialization. We
would need locking to avoid racing with readers and cause UAF. use RCU
for read-write synchronization. And region_lock mutex is used to
synchronize the write section.

Changing the value of num_regions is done under the mutex. Since the
num_regions can only increase, using READ_ONCE and WRITE_ONCE should
be enough to make sure we have a valid value. On the write section,
synchronize_rcu() is run before incrementing num_regions. Doing that
makes sure read sections are passed before increasing num_regions to
avoid causing out-of-bound access.

Signed-off-by: Mahmoud Adam <mngyadam@amazon.de>
---
 drivers/vfio/pci/vfio_pci_core.c | 59 +++++++++++++++++++++++---------
 drivers/vfio/pci/vfio_pci_igd.c  | 16 ++++++---
 include/linux/vfio_pci_core.h    |  1 +
 3 files changed, 55 insertions(+), 21 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 6629490c0e46f..78e18bfd973e5 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -882,7 +882,8 @@ static int msix_mmappable_cap(struct vfio_pci_core_device *vdev,
 }
 
 /*
- * Registers a new region to vfio_pci_core_device.
+ * Registers a new region to vfio_pci_core_device. region_lock should
+ * be held when multiple registers could happen.
  * Returns region index on success or a negative errno.
  */
 int vfio_pci_core_register_dev_region(struct vfio_pci_core_device *vdev,
@@ -890,15 +891,20 @@ int vfio_pci_core_register_dev_region(struct vfio_pci_core_device *vdev,
 				      const struct vfio_pci_regops *ops,
 				      size_t size, u32 flags, void *data)
 {
-	int num_regions = vdev->num_regions;
 	struct vfio_pci_region *region, *old_region;
+	int num_regions;
+
+	mutex_lock(&vdev->region_lock);
+	num_regions = READ_ONCE(vdev->num_regions);
 
 	region = kmalloc((num_regions + 1) * sizeof(*region),
 			 GFP_KERNEL_ACCOUNT);
 	if (!region)
 		return -ENOMEM;
 
-	old_region = vdev->region;
+	old_region =
+		rcu_dereference_protected(vdev->region,
+					  lockdep_is_held(&vdev->region_lock));
 	if (old_region)
 		memcpy(region, old_region, num_regions * sizeof(*region));
 
@@ -909,8 +915,10 @@ int vfio_pci_core_register_dev_region(struct vfio_pci_core_device *vdev,
 	region[num_regions].flags = flags;
 	region[num_regions].data = data;
 
-	vdev->region = region;
-	vdev->num_regions++;
+	rcu_assign_pointer(vdev->region, region);
+	synchronize_rcu();
+	WRITE_ONCE(vdev->num_regions, READ_ONCE(vdev->num_regions) + 1);
+	mutex_unlock(&vdev->region_lock);
 	kfree(old_region);
 	return num_regions;
 }
@@ -968,7 +976,7 @@ static int vfio_pci_ioctl_get_info(struct vfio_pci_core_device *vdev,
 	if (vdev->reset_works)
 		info.flags |= VFIO_DEVICE_FLAGS_RESET;
 
-	info.num_regions = VFIO_PCI_NUM_REGIONS + vdev->num_regions;
+	info.num_regions = VFIO_PCI_NUM_REGIONS + READ_ONCE(vdev->num_regions);
 	info.num_irqs = VFIO_PCI_NUM_IRQS;
 
 	ret = vfio_pci_info_zdev_add_caps(vdev, &caps);
@@ -1094,13 +1102,16 @@ static int vfio_pci_ioctl_get_region_info(struct vfio_pci_core_device *vdev,
 			.header.version = 1
 		};
 
-		if (info.index >= VFIO_PCI_NUM_REGIONS + vdev->num_regions)
+		if (info.index >= VFIO_PCI_NUM_REGIONS +
+					  READ_ONCE(vdev->num_regions))
 			return -EINVAL;
-		info.index = array_index_nospec(
-			info.index, VFIO_PCI_NUM_REGIONS + vdev->num_regions);
+		info.index = array_index_nospec(info.index,
+						VFIO_PCI_NUM_REGIONS +
+						READ_ONCE(vdev->num_regions));
 
 		i = info.index - VFIO_PCI_NUM_REGIONS;
-		region = &vdev->region[i];
+		rcu_read_lock();
+		region = &rcu_dereference(vdev->region)[i];
 
 		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
 		info.size = region->size;
@@ -1111,15 +1122,20 @@ static int vfio_pci_ioctl_get_region_info(struct vfio_pci_core_device *vdev,
 
 		ret = vfio_info_add_capability(&caps, &cap_type.header,
 					       sizeof(cap_type));
-		if (ret)
+		if (ret) {
+			rcu_read_unlock();
 			return ret;
+		}
 
 		if (region->ops->add_capability) {
 			ret = region->ops->add_capability(
 				vdev, region, &caps);
-			if (ret)
+			if (ret) {
+				rcu_read_unlock();
 				return ret;
+			}
 		}
+		rcu_read_unlock();
 	}
 	}
 
@@ -1536,7 +1552,7 @@ static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
 	int ret;
 
-	if (index >= VFIO_PCI_NUM_REGIONS + vdev->num_regions)
+	if (index >= VFIO_PCI_NUM_REGIONS + READ_ONCE(vdev->num_regions))
 		return -EINVAL;
 
 	ret = pm_runtime_resume_and_get(&vdev->pdev->dev);
@@ -1568,8 +1584,11 @@ static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 
 	default:
 		index -= VFIO_PCI_NUM_REGIONS;
-		ret = vdev->region[index].ops->rw(vdev, buf,
-						   count, ppos, iswrite);
+		rcu_read_lock();
+		ret = rcu_dereference(vdev->region)[index].ops->rw(vdev, buf,
+								   count, ppos,
+								   iswrite);
+		rcu_read_unlock();
 		break;
 	}
 
@@ -1726,7 +1745,7 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
 
 	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
 
-	if (index >= VFIO_PCI_NUM_REGIONS + vdev->num_regions)
+	if (index >= VFIO_PCI_NUM_REGIONS + READ_ONCE(vdev->num_regions))
 		return -EINVAL;
 	if (vma->vm_end < vma->vm_start)
 		return -EINVAL;
@@ -1734,12 +1753,16 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
 		return -EINVAL;
 	if (index >= VFIO_PCI_NUM_REGIONS) {
 		int regnum = index - VFIO_PCI_NUM_REGIONS;
-		struct vfio_pci_region *region = vdev->region + regnum;
+		struct vfio_pci_region *region;
+
+		rcu_read_lock();
+		region = rcu_dereference(vdev->region) + regnum;
 
 		ret = -EINVAL;
 		if (region->ops && region->ops->mmap &&
 		    (region->flags & VFIO_REGION_INFO_FLAG_MMAP))
 			ret = region->ops->mmap(vdev, region, vma);
+		rcu_read_unlock();
 		return ret;
 	}
 	if (index >= VFIO_PCI_ROM_REGION_INDEX)
@@ -2107,6 +2130,7 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
 	init_rwsem(&vdev->memory_lock);
 	xa_init(&vdev->ctx);
+	mutex_init(&vdev->region_lock);
 
 	return 0;
 }
@@ -2119,6 +2143,7 @@ void vfio_pci_core_release_dev(struct vfio_device *core_vdev)
 
 	mutex_destroy(&vdev->igate);
 	mutex_destroy(&vdev->ioeventfds_lock);
+	mutex_destroy(&vdev->region_lock);
 	kfree(vdev->region);
 	kfree(vdev->pm_save);
 }
diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
index 93ddef48e4e4c..1f7e9e82ac08c 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/vfio_pci_igd.c
@@ -71,13 +71,17 @@ static ssize_t vfio_pci_igd_rw(struct vfio_pci_core_device *vdev,
 	struct vfio_pci_region *region;
 	struct igd_opregion_vbt *opregionvbt;
 
-	region = &vdev->region[i];
+	rcu_read_lock();
+	region = &rcu_dereference(vdev->region)[i];
 	opregionvbt = region->data;
 
-	if (pos >= region->size || iswrite)
+	if (pos >= region->size || iswrite) {
+		rcu_read_unlock();
 		return -EINVAL;
+	}
 
 	count = min_t(size_t, count, region->size - pos);
+	rcu_read_unlock();
 	remaining = count;
 
 	/* Copy until OpRegion version */
@@ -293,13 +297,17 @@ static ssize_t vfio_pci_igd_cfg_rw(struct vfio_pci_core_device *vdev,
 	struct vfio_pci_region *region;
 	struct pci_dev *pdev;
 
-	region = &vdev->region[i];
+	rcu_read_lock();
+	region = &rcu_dereference(vdev->region)[i];
 	pdev = region->data;
 
-	if (pos >= region->size || iswrite)
+	if (pos >= region->size || iswrite) {
+		rcu_read_unlock();
 		return -EINVAL;
+	}
 
 	size = count = min(count, (size_t)(region->size - pos));
+	rcu_read_unlock();
 
 	if ((pos & 1) && size) {
 		u8 val;
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index f541044e42a2a..e106e58f297e9 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -63,6 +63,7 @@ struct vfio_pci_core_device {
 	int			irq_type;
 	int			num_regions;
 	struct vfio_pci_region	*region;
+	struct mutex		region_lock;
 	u8			msi_qmax;
 	u8			msix_bar;
 	u16			msix_size;
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


