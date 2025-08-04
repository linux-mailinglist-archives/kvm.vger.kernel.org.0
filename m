Return-Path: <kvm+bounces-53900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 878C0B19FDE
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 12:43:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 145A0189BB81
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 10:43:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B5B224CEE8;
	Mon,  4 Aug 2025 10:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="sLQF1fW4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91549248F6F
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 10:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754304195; cv=none; b=cBqUtEtP6anT4ai9Gg5q/nEZnCDpO1HEzcD7cct2dKxMFwoaWFRwCTobwNNZn9twJg/Xb6QZWSZYh8m4JnRiG0g+1mtYwUpcxLwdBQsMIoz3pJSja1eS1W1ykUs97/IpQKcbu6lCzxyMHLW2kH7yieXRLww7q1HVYoo51TylX5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754304195; c=relaxed/simple;
	bh=raevhSImABmzlqu0yDEokzsIdQhJMOcFDiZy6uYSN9g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pXJZglL/FaMrdDIPHri3EfOIQVwKgdvbZsCo/ZAWQHhcmnfDGja08c8UXmPIct7i9x5Ujw3P1sFU99x6tS3oy7clvz6uoWSF6dDbdgM0OQ2tevzzhq04RF1TZ55WuQbNKzKCb+5NpgxB0EZTFwPW2DMcTyh7UfDegBggmP3sDs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=sLQF1fW4; arc=none smtp.client-ip=99.78.197.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1754304193; x=1785840193;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VGxD3sMlZjxboeinJiH6A+3F4RZk3OpPsmg7n4tg95I=;
  b=sLQF1fW4G9stNgNTS9PTOjccyBw9MZuTeUQkdjUYDayFJSv5z2cDysRy
   4xKMqzFDqWGu1kAjwRuGXYS9vwA4wN4kwQWcKWMBF2CvHAoa40vp7giGx
   /ApXjN4eZrw2G6YMBCUdQJkbt95BXjA7ozztD51uK5bk9kdZtWmySYOTq
   5tyMHiUzYP832aqsCAnrE5GG9FPV7N0gzaW7Rzy+/vn0TCSc+1reMXw4x
   29R/fxlkgT4nHc0GXFGf5X2i5Zo3gG6aJX858m1dDdkLAgOoUy7ZM2WBd
   GiltoZYrlhVbTVbWmELZhQxeLlNsbPJV4koXlZY04NIcpC44g54Q13Yoz
   Q==;
X-IronPort-AV: E=Sophos;i="6.17,258,1747699200"; 
   d="scan'208";a="223118926"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 10:43:12 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.17.79:54828]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.17.135:2525] with esmtp (Farcaster)
 id bde425d1-5bf7-47ce-a453-fccbcf23346d; Mon, 4 Aug 2025 10:43:10 +0000 (UTC)
X-Farcaster-Flow-ID: bde425d1-5bf7-47ce-a453-fccbcf23346d
Received: from EX19D039EUC004.ant.amazon.com (10.252.61.190) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 4 Aug 2025 10:43:10 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com
 (10.253.107.175) by EX19D039EUC004.ant.amazon.com (10.252.61.190) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Mon, 4 Aug 2025
 10:43:07 +0000
From: Mahmoud Adam <mngyadam@amazon.de>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <jgg@ziepe.ca>, <benh@kernel.crashing.org>,
	David Woodhouse <dwmw@amazon.co.uk>, <pravkmr@amazon.de>,
	<nagy@khwaternagy.com>
Subject: [RFC PATCH 6/9] vfio-pci-core: support the new vfio ops
Date: Mon, 4 Aug 2025 12:39:59 +0200
Message-ID: <20250804104012.87915-7-mngyadam@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250804104012.87915-1-mngyadam@amazon.de>
References: <20250804104012.87915-1-mngyadam@amazon.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D044UWA003.ant.amazon.com (10.13.139.43) To
 EX19D039EUC004.ant.amazon.com (10.252.61.190)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This use the new mt to create the mmap offset entries when user calls
get_region_info, and return the vmmap range offset, and when the user
use the same region range for mmaping, we have access on the vmmap
entry, where we could know which bar from the bar_index, and later
change mmaping attributes like WC. On top of that since we use the mt
range offset, eventually we will not need this legacy
VFIO_PCI_INDEX_TO_OFFSET, which means more dynamic offset calculation
that remove the limitation of the legacy system.  To avoid duplicating
the functions for mmap & get_region_info, this create a common
function and use mmap_mt/vmmap if not null, for ioctl2 just override
VFIO_DEVICE_GET_REGION_INFO only with the new function.

Signed-off-by: Mahmoud Adam <mngyadam@amazon.de>
---
This follow the same temprory suffix "2", but also this is only for
the migration period, the other function will be dropped and replace
eventually.
 drivers/vfio/pci/vfio_pci_core.c | 72 +++++++++++++++++++++++++++++---
 include/linux/vfio_pci_core.h    |  4 ++
 2 files changed, 71 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 7a431a03bd850..8418d98ac66ce 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1041,8 +1041,10 @@ static int vfio_pci_ioctl_get_info(struct vfio_pci_core_device *vdev,
 	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
 }
 
-static int vfio_pci_ioctl_get_region_info(struct vfio_pci_core_device *vdev,
-					  struct vfio_region_info __user *arg)
+
+static int _vfio_pci_ioctl_get_region_info(struct vfio_pci_core_device *vdev,
+					   struct maple_tree *mmap_mt,
+					   struct vfio_region_info __user *arg)
 {
 	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
 	struct pci_dev *pdev = vdev->pdev;
@@ -1170,10 +1172,32 @@ static int vfio_pci_ioctl_get_region_info(struct vfio_pci_core_device *vdev,
 		kfree(caps.buf);
 	}
 
-	info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+	if (mmap_mt) {
+		ret = vfio_pci_mmap_alloc(vdev, mmap_mt,
+					  info.flags, info.size, info.index,
+					  (unsigned long *) &info.offset);
+		if (ret)
+			return ret;
+	} else {
+		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+	}
+
 	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
 }
 
+static int vfio_pci_ioctl_get_region_info(struct vfio_pci_core_device *vdev,
+					   struct vfio_region_info __user *arg)
+{
+	return _vfio_pci_ioctl_get_region_info(vdev, NULL, arg);
+}
+
+static int vfio_pci_ioctl_get_region_info2(struct vfio_pci_core_device *vdev,
+					   struct maple_tree *mmap_mt,
+					   struct vfio_region_info __user *arg)
+{
+	return _vfio_pci_ioctl_get_region_info(vdev, mmap_mt, arg);
+}
+
 static int vfio_pci_ioctl_get_irq_info(struct vfio_pci_core_device *vdev,
 				       struct vfio_irq_info __user *arg)
 {
@@ -1514,6 +1538,23 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl);
 
+
+long vfio_pci_core_ioctl2(struct vfio_device *core_vdev, unsigned int cmd,
+			  unsigned long arg, struct maple_tree *mmap_mt)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	void __user *uarg = (void __user *)arg;
+
+	switch (cmd) {
+	case VFIO_DEVICE_GET_REGION_INFO:
+		return vfio_pci_ioctl_get_region_info2(vdev, mmap_mt, uarg);
+	default:
+		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
+	}
+}
+EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl2);
+
 static int vfio_pci_core_feature_token(struct vfio_device *device, u32 flags,
 				       uuid_t __user *arg, size_t argsz)
 {
@@ -1748,16 +1789,24 @@ static const struct vm_operations_struct vfio_pci_vm_ops = {
 #endif
 };
 
-int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma)
+static int _vfio_pci_core_mmap(struct vfio_device *core_vdev,
+			       struct vm_area_struct *vma,
+			       struct vfio_mmap *core_vmmap)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	struct vfio_pci_mmap *vmmap = NULL;
 	struct pci_dev *pdev = vdev->pdev;
 	unsigned int index;
 	u64 phys_len, req_len, pgoff, req_start;
 	int ret;
 
-	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
+	if (core_vmmap) {
+		vmmap = container_of(core_vmmap, struct vfio_pci_mmap, core);
+		index = vmmap->bar_index;
+	} else {
+		index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
+	}
 
 	if (index >= VFIO_PCI_NUM_REGIONS + vdev->num_regions)
 		return -EINVAL;
@@ -1836,8 +1885,21 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
 
 	return 0;
 }
+
+int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma)
+{
+	return _vfio_pci_core_mmap(core_vdev, vma, NULL);
+}
 EXPORT_SYMBOL_GPL(vfio_pci_core_mmap);
 
+int vfio_pci_core_mmap2(struct vfio_device *core_vdev,
+			struct vm_area_struct *vma,
+			struct vfio_mmap *core_vmmap)
+{
+	return _vfio_pci_core_mmap(core_vdev, vma, core_vmmap);
+}
+EXPORT_SYMBOL_GPL(vfio_pci_core_mmap2);
+
 void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count)
 {
 	struct vfio_pci_core_device *vdev =
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 532d2914a9c2e..cb52b92340451 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -118,6 +118,8 @@ int vfio_pci_core_sriov_configure(struct vfio_pci_core_device *vdev,
 				  int nr_virtfn);
 long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		unsigned long arg);
+long vfio_pci_core_ioctl2(struct vfio_device *core_vdev, unsigned int cmd,
+			unsigned long arg, struct maple_tree *mmap_attrs_mt);
 int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
 				void __user *arg, size_t argsz);
 ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
@@ -125,6 +127,8 @@ ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
 ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
 		size_t count, loff_t *ppos);
 int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma);
+int vfio_pci_core_mmap2(struct vfio_device *core_vdev, struct vm_area_struct *vma,
+		struct vfio_mmap *core_vmmap);
 void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count);
 int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
 int vfio_pci_core_enable(struct vfio_pci_core_device *vdev);
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


