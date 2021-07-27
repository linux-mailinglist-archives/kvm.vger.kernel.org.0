Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A9C3D6CF4
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 05:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234797AbhG0C7s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 22:59:48 -0400
Received: from mx21.baidu.com ([220.181.3.85]:42904 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234608AbhG0C7o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 22:59:44 -0400
Received: from BC-Mail-EX08.internal.baidu.com (unknown [172.31.51.48])
        by Forcepoint Email with ESMTPS id 62CBB2F1BE2BD92E2D04;
        Tue, 27 Jul 2021 11:40:08 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-EX08.internal.baidu.com (172.31.51.48) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Tue, 27 Jul 2021 11:40:08 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Tue, 27 Jul 2021 11:40:07 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <alex.williamson@redhat.com>, <cohuck@redhat.com>, <jgg@ziepe.ca>,
        <eric.auger@redhat.com>, <kevin.tian@intel.com>,
        <giovanni.cabiddu@intel.com>, <mgurtovoy@nvidia.com>,
        <jannh@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Cai Huoqing <caihuoqing@baidu.com>
Subject: [PATCH] vfio: Add "#ifdef CONFIG_MMU" for vma operations
Date:   Tue, 27 Jul 2021 11:40:00 +0800
Message-ID: <20210727034000.547-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex12.internal.baidu.com (172.31.51.52) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add "#ifdef CONFIG_MMU",
because vma mmap and vm_operations_struct depend on MMU

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/vfio/pci/vfio_pci.c | 4 ++++
 drivers/vfio/vfio.c         | 8 ++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 318864d52837..d49b27f15a3f 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1559,6 +1559,7 @@ static int __vfio_pci_add_vma(struct vfio_pci_device *vdev,
  * Zap mmaps on open so that we can fault them in on access and therefore
  * our vma_list only tracks mappings accessed since last zap.
  */
+#ifdef CONFIG_MMU
 static void vfio_pci_mmap_open(struct vm_area_struct *vma)
 {
 	zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);
@@ -1701,6 +1702,7 @@ static int vfio_pci_mmap(struct vfio_device *core_vdev, struct vm_area_struct *v
 
 	return 0;
 }
+#endif /* CONFIG_MMU */
 
 static void vfio_pci_request(struct vfio_device *core_vdev, unsigned int count)
 {
@@ -1875,7 +1877,9 @@ static const struct vfio_device_ops vfio_pci_ops = {
 	.ioctl		= vfio_pci_ioctl,
 	.read		= vfio_pci_read,
 	.write		= vfio_pci_write,
+#ifdef CONFIG_MMU
 	.mmap		= vfio_pci_mmap,
+#endif /* CONFIG_MMU */
 	.request	= vfio_pci_request,
 	.match		= vfio_pci_match,
 };
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 02cc51ce6891..2fb2de8d4d13 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1182,6 +1182,7 @@ static ssize_t vfio_fops_write(struct file *filep, const char __user *buf,
 	return ret;
 }
 
+#ifdef CONFIG_MMU
 static int vfio_fops_mmap(struct file *filep, struct vm_area_struct *vma)
 {
 	struct vfio_container *container = filep->private_data;
@@ -1194,6 +1195,7 @@ static int vfio_fops_mmap(struct file *filep, struct vm_area_struct *vma)
 
 	return ret;
 }
+#endif /* CONFIG_MMU */
 
 static const struct file_operations vfio_fops = {
 	.owner		= THIS_MODULE,
@@ -1203,7 +1205,9 @@ static const struct file_operations vfio_fops = {
 	.write		= vfio_fops_write,
 	.unlocked_ioctl	= vfio_fops_unl_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
+#ifdef CONFIG_MMU
 	.mmap		= vfio_fops_mmap,
+#endif /* CONFIG_MMU */
 };
 
 /**
@@ -1601,6 +1605,7 @@ static ssize_t vfio_device_fops_write(struct file *filep,
 	return device->ops->write(device, buf, count, ppos);
 }
 
+#ifdef CONFIG_MMU
 static int vfio_device_fops_mmap(struct file *filep, struct vm_area_struct *vma)
 {
 	struct vfio_device *device = filep->private_data;
@@ -1610,6 +1615,7 @@ static int vfio_device_fops_mmap(struct file *filep, struct vm_area_struct *vma)
 
 	return device->ops->mmap(device, vma);
 }
+#endif /* CONFIG_MMU */
 
 static const struct file_operations vfio_device_fops = {
 	.owner		= THIS_MODULE,
@@ -1618,7 +1624,9 @@ static const struct file_operations vfio_device_fops = {
 	.write		= vfio_device_fops_write,
 	.unlocked_ioctl	= vfio_device_fops_unl_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
+#ifdef CONFIG_MMU
 	.mmap		= vfio_device_fops_mmap,
+#endif /* CONFIG_MMU */
 };
 
 /**
-- 
2.25.1

