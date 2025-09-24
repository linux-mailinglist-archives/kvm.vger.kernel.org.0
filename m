Return-Path: <kvm+bounces-58653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C337DB9A309
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 16:14:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE8811666F3
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 14:13:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3913A1B6D06;
	Wed, 24 Sep 2025 14:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="JxSo6cCE"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.75.33.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12E21A38F9;
	Wed, 24 Sep 2025 14:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=3.75.33.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758723213; cv=none; b=DZ1Id6KqlzzXtAhn2FZI+68swDzybmq+ML+Yg2ePWjpt1iZ/EVJ3PHXXMjV2IhY9NUuzOuRp1ozlHzcDul0uF9ZANI1sSN2Ma5r70wVhQaEIdrY5QDrBoKIpL9/XrFL3MCwyhUKNUhUbfwMTT7a2KxmFq4dYb4o8jFtCd9bwTTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758723213; c=relaxed/simple;
	bh=Psf2UiHbIfFoCKVtGR7vRnCiMvd8l30OQ4xeY9HiHrE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bnQ3/U2g7V46yor8D8eQzNsBqNuu4vw1AQ7qQ7KaVwyseOq20cAWNlqjq3yDXiDBi1LZxv5Y4URhxJ7989n9eWKwVinaegqheQ3pBgDafwB4jdYQ3tyVFTeODUFDx9ilOdsG1BpMnvNg+8fdyol2D9zUgzWtbD+k4TXNEXc94Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=JxSo6cCE; arc=none smtp.client-ip=3.75.33.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1758723211; x=1790259211;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bhLPFvRc8Jr7ZaJZGuxccCtemmZ4vyWewvC1yxLU+O8=;
  b=JxSo6cCEoQ/HDNcYvYdF1tR78CJGGiuWTQ5mPOQTKOOTXwk4Xot0ZZ0N
   Tr1svDmMh7PaZsMhgjns60vn3iYBnJwC8uop0tFuV4E+/AQSwLUB47R2W
   hcsVIXoAanmkq2YAD9gEYwzuP3BaekfQ8Hz8wFU1s53TyRT3W2oe5EI4L
   grntKS6flk5nyxVoYuGfmhOImZod0Zj/+Exc4NcAVWMCI3sR+pFwaNqXW
   S7ou2dVhEKPIz0AFOXkU119LCZRAp8LaDL19tkk0cIHvcDTHyEiPs5Mfz
   akWuJ4iTndAald4ZuV2maBDncNVKGQbcxArjnH/bKp76zvHnjNEbQD5Kl
   w==;
X-CSE-ConnectionGUID: AaxHro97QF2ob+ABW/zNLg==
X-CSE-MsgGUID: F6Ae34Y6SDuTndUMh5RU5A==
X-IronPort-AV: E=Sophos;i="6.18,290,1751241600"; 
   d="scan'208";a="2615973"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 14:13:21 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:28822]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.10.226:2525] with esmtp (Farcaster)
 id e487420e-1f17-415c-8a4b-03885c61768e; Wed, 24 Sep 2025 14:13:20 +0000 (UTC)
X-Farcaster-Flow-ID: e487420e-1f17-415c-8a4b-03885c61768e
Received: from EX19D039EUC004.ant.amazon.com (10.252.61.190) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 14:13:20 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com
 (10.253.107.175) by EX19D039EUC004.ant.amazon.com (10.252.61.190) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 24 Sep 2025
 14:13:16 +0000
From: Mahmoud Adam <mngyadam@amazon.de>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <jgg@ziepe.ca>, <kbusch@kernel.org>,
	<benh@kernel.crashing.org>, David Woodhouse <dwmw@amazon.co.uk>,
	<pravkmr@amazon.de>, <nagy@khwaternagy.com>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 7/7] vfio-pci-core: implement FEATURE_ALIAS_REGION uapi
Date: Wed, 24 Sep 2025 16:09:58 +0200
Message-ID: <20250924141018.80202-8-mngyadam@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924141018.80202-1-mngyadam@amazon.de>
References: <20250924141018.80202-1-mngyadam@amazon.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D041UWB002.ant.amazon.com (10.13.139.179) To
 EX19D039EUC004.ant.amazon.com (10.252.61.190)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This implements the new DEVICE_FEATURE_ALIAS_REGION. As of right now
Alias is only needed for mmaping. So we will allow aliasing mmap
supported regions only.

If the user requested a similar alias (same flags and aliased
index). re-use the old index instead by returning it to the
user. Since creating another alias gives no extra value for the
user. The region with the new flag (WC), will allow the user to
mmap the aliased region with WC enabled.

We also supports probing. When the user probe a region index, we
return the region flags supported to be enabled for this
region. Initially we are supporting WC only when the region is
mmap-able.

add vfio_pci_core_register_dev_region_locked to allow externally
locking the mutex. So that we can check for if a similar region exists
and add a new region under the same mutex lock, to avoid racing.

Signed-off-by: Mahmoud Adam <mngyadam@amazon.de>
---
 drivers/vfio/pci/vfio_pci_core.c | 173 ++++++++++++++++++++++++++++---
 1 file changed, 161 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 962d3eda1ea9f..3c162cf47a1eb 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -882,20 +882,14 @@ static int msix_mmappable_cap(struct vfio_pci_core_device *vdev,
 	return vfio_info_add_capability(caps, &header, sizeof(header));
 }
 
-/*
- * Registers a new region to vfio_pci_core_device. region_lock should
- * be held when multiple registers could happen.
- * Returns region index on success or a negative errno.
- */
-int vfio_pci_core_register_dev_region(struct vfio_pci_core_device *vdev,
-				      unsigned int type, unsigned int subtype,
-				      const struct vfio_pci_regops *ops,
-				      size_t size, u32 flags, void *data)
+static int vfio_pci_core_register_dev_region_locked(
+	struct vfio_pci_core_device *vdev,
+	unsigned int type, unsigned int subtype,
+	const struct vfio_pci_regops *ops,
+	size_t size, u32 flags, void *data)
 {
 	struct vfio_pci_region *region, *old_region;
 	int num_regions;
-
-	mutex_lock(&vdev->region_lock);
 	num_regions = READ_ONCE(vdev->num_regions);
 
 	region = kmalloc((num_regions + 1) * sizeof(*region),
@@ -919,10 +913,29 @@ int vfio_pci_core_register_dev_region(struct vfio_pci_core_device *vdev,
 	rcu_assign_pointer(vdev->region, region);
 	synchronize_rcu();
 	WRITE_ONCE(vdev->num_regions, READ_ONCE(vdev->num_regions) + 1);
-	mutex_unlock(&vdev->region_lock);
 	kfree(old_region);
 	return num_regions;
 }
+
+/*
+ * Registers a new region to vfio_pci_core_device. region_lock should
+ * be held when multiple registers could happen.
+ * Returns region index on success or a negative errno.
+ */
+int vfio_pci_core_register_dev_region(struct vfio_pci_core_device *vdev,
+				      unsigned int type, unsigned int subtype,
+				      const struct vfio_pci_regops *ops,
+				      size_t size, u32 flags, void *data)
+{
+	int index;
+
+	mutex_lock(&vdev->region_lock);
+	index = vfio_pci_core_register_dev_region_locked(vdev, type, subtype,
+							 ops,
+							 size, flags, data);
+	mutex_unlock(&vdev->region_lock);
+	return index;
+}
 EXPORT_SYMBOL_GPL(vfio_pci_core_register_dev_region);
 
 static int vfio_pci_info_atomic_cap(struct vfio_pci_core_device *vdev,
@@ -1528,6 +1541,48 @@ static int vfio_pci_core_feature_token(struct vfio_device *device, u32 flags,
 	return 0;
 }
 
+static bool vfio_pci_region_is_mmap_supported(struct vfio_pci_core_device *vdev,
+					      int index)
+{
+	if (index <= VFIO_PCI_BAR5_REGION_INDEX)
+		return vdev->bar_mmap_supported[index];
+
+	if (index >= VFIO_PCI_NUM_REGIONS) {
+		int i = index - VFIO_PCI_NUM_REGIONS;
+		bool is_mmap;
+		struct vfio_pci_region *region;
+
+		rcu_read_lock();
+		region = &rcu_dereference(vdev->region)[i];
+		is_mmap = (region->flags & VFIO_REGION_INFO_FLAG_MMAP) &&
+			region->ops && region->ops->mmap;
+		rcu_read_unlock();
+		return is_mmap;
+	}
+	return false;
+}
+
+static bool vfio_pci_region_alias_exists(struct vfio_pci_core_device *vdev,
+					 u32 flags, int index, int *alias_index)
+{
+	int i;
+
+	for (i = 0; i < READ_ONCE(vdev->num_regions); i++) {
+		struct vfio_pci_region *region;
+
+		region = &rcu_dereference_protected(
+			vdev->region, lockdep_is_held(&vdev->region_lock))[i];
+		if (!(region->flags & VFIO_REGION_INFO_FLAG_ALIAS))
+			continue;
+		if ((int)(uintptr_t) region->data == index &&
+		    region->flags == flags) {
+			*alias_index = i + VFIO_PCI_NUM_REGIONS;
+			return true;
+		}
+	}
+	return false;
+}
+
 static int vfio_pci_alias_region_mmap(struct vfio_pci_core_device *vdev,
 				      struct vfio_pci_region *region,
 				      struct vm_area_struct *vma)
@@ -1555,6 +1610,97 @@ struct vfio_pci_regops vfio_pci_alias_region_ops = {
 	.mmap = vfio_pci_alias_region_mmap,
 };
 
+static int vfio_pci_core_feature_alias_region(
+	struct vfio_device *device, u32 flags,
+	struct vfio_device_feature_alias_region __user *arg,
+	size_t argsz)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(device, struct vfio_pci_core_device, vdev);
+	struct pci_dev *pdev = vdev->pdev;
+	bool is_probe = false;
+	u32 region_flags;
+	struct vfio_device_feature_alias_region request_region;
+	int ret, index, new_index;
+	size_t size;
+
+	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET,
+				 sizeof(request_region));
+	if (ret < 0)
+		return ret;
+
+	if (ret == 0) /* probing only */
+		is_probe = true;
+
+	if (copy_from_user(&request_region, arg, sizeof(request_region)))
+		return -EFAULT;
+
+	if (request_region.index >= VFIO_PCI_NUM_REGIONS +
+					    READ_ONCE(vdev->num_regions))
+		return -EINVAL;
+
+	index = array_index_nospec(request_region.index,
+				   VFIO_PCI_NUM_REGIONS +
+				   READ_ONCE(vdev->num_regions));
+
+	/* make sure we are not aliasing an alias region */
+	if (index >= VFIO_PCI_NUM_REGIONS) {
+		int i;
+
+		rcu_read_lock();
+		i = index - VFIO_PCI_NUM_REGIONS;
+		if (rcu_dereference(vdev->region)[i].flags &
+		    VFIO_REGION_INFO_FLAG_ALIAS) {
+			rcu_read_unlock();
+			return -EINVAL;
+		}
+		rcu_read_unlock();
+	}
+
+	/* For now we only allow aliasing mmap supported regions. */
+	if (!vfio_pci_region_is_mmap_supported(vdev, index))
+		return -EINVAL;
+
+	if (is_probe) {
+		request_region.flags = VFIO_REGION_INFO_FLAG_WC;
+		goto out_copy;
+	}
+
+	if (request_region.flags & ~VFIO_REGION_INFO_FLAG_WC)
+		return -EINVAL;
+
+	region_flags = VFIO_REGION_INFO_FLAG_ALIAS |
+		       VFIO_REGION_INFO_FLAG_MMAP | VFIO_REGION_INFO_FLAG_WC;
+
+	mutex_lock(&vdev->region_lock);
+	if (vfio_pci_region_alias_exists(vdev, region_flags,
+					 index, &new_index)) {
+		request_region.alias_index = new_index;
+		goto out_copy_unlock;
+	}
+
+	if (index <= VFIO_PCI_BAR5_REGION_INDEX)
+		size = pci_resource_len(pdev, index);
+	else
+		size = vdev->region[index].size;
+
+	new_index = vfio_pci_core_register_dev_region_locked(
+		vdev, 0, 0, &vfio_pci_alias_region_ops, size, region_flags,
+		(void *)(uintptr_t)index);
+
+	if (new_index < 0) {
+		mutex_unlock(&vdev->region_lock);
+		return new_index;
+	}
+	request_region.alias_index = new_index + VFIO_PCI_NUM_REGIONS;
+
+out_copy_unlock:
+	mutex_unlock(&vdev->region_lock);
+out_copy:
+	ret = copy_to_user(arg, &request_region, sizeof(request_region));
+	return ret ? -EFAULT : 0;
+}
+
 int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
 				void __user *arg, size_t argsz)
 {
@@ -1568,6 +1714,9 @@ int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
 		return vfio_pci_core_pm_exit(device, flags, arg, argsz);
 	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
 		return vfio_pci_core_feature_token(device, flags, arg, argsz);
+	case VFIO_DEVICE_FEATURE_ALIAS_REGION:
+		return vfio_pci_core_feature_alias_region(device, flags,
+							  arg, argsz);
 	default:
 		return -ENOTTY;
 	}
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


