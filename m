Return-Path: <kvm+bounces-24639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 56A1A958807
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 15:36:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0EC2E281E42
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 13:36:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80D9E18FDD0;
	Tue, 20 Aug 2024 13:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="I1m+IeYp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12E618A6D1
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 13:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.48.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724160957; cv=none; b=acMZNSU5WNFluD4yfr+yU16Qz5aIqsi1AvhttA9xqnLqtEi1xSLBQpz9q3mfsgw2mlJK7CVDxWplnYijjNJMK6XjvznBCY7qEZmvvNwZj5cX3y1ISmm+r8OvXPAbMrkHNIGlKTVtiwgC6TH1tMryKHi87wPIioTSu3SlUoOL+Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724160957; c=relaxed/simple;
	bh=CHJVhmXt6gaABg54QaIeVarOiPHqy6jztApjB/pYWo0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gaw1HOTSp2MGDGirEdIOiy0VucjkWFFAs6IzE6zXgTfhmcTgoRyt8lzm4gv3rxTjnMLQ3o5+GDarU2bFPRMN+3QGiDGLeyRmkoVKaBGQ1x0A//M65/HUiLcpEJS/e6+i0T1dd5iFmlYoYfFc5VisfCsVNSgYiIRymGRpY5AFUj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=I1m+IeYp; arc=none smtp.client-ip=52.95.48.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1724160956; x=1755696956;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sySJcTFm+Th9SLlNnfq+siH3BRW0PPP2QTvHlVZnpsw=;
  b=I1m+IeYpqYgkVDJaxlTinCBrgiPMec/XjBzPjzgTCXXWo2NkdPhVBWOR
   NZJcdOb/VyRs/IoyuFlrpXrA2ZMHy7tb/414AlXX92oJTQmo7DEP4x776
   gYdb7g9U7Fbq+OcQuTKq9nMJGdlqejgtBVNIceyy/Pb7FzX/EaVkQKhwH
   0=;
X-IronPort-AV: E=Sophos;i="6.10,162,1719878400"; 
   d="scan'208";a="418261980"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 13:35:53 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.17.79:48359]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.21.54:2525] with esmtp (Farcaster)
 id ab0157be-c78d-470c-85db-0e60224b2e25; Tue, 20 Aug 2024 13:35:51 +0000 (UTC)
X-Farcaster-Flow-ID: ab0157be-c78d-470c-85db-0e60224b2e25
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 20 Aug 2024 13:35:51 +0000
Received: from u94b036d6357a55.ant.amazon.com (10.106.82.48) by
 EX19D018EUA002.ant.amazon.com (10.252.50.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 20 Aug 2024 13:35:47 +0000
From: Ilias Stamatis <ilstam@amazon.com>
To: <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC: <pdurrant@amazon.co.uk>, <dwmw@amazon.co.uk>, <seanjc@google.com>,
	<nh-open-source@amazon.com>, Ilias Stamatis <ilstam@amazon.com>, Paul Durrant
	<paul@xen.org>
Subject: [PATCH v3 2/6] KVM: Add KVM_CREATE_COALESCED_MMIO_BUFFER ioctl
Date: Tue, 20 Aug 2024 14:33:29 +0100
Message-ID: <20240820133333.1724191-3-ilstam@amazon.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240820133333.1724191-1-ilstam@amazon.com>
References: <20240820133333.1724191-1-ilstam@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D032UWA003.ant.amazon.com (10.13.139.37) To
 EX19D018EUA002.ant.amazon.com (10.252.50.146)

The current MMIO coalescing design has a few drawbacks which limit its
usefulness. Currently all coalesced MMIO zones use the same ring buffer.
That means that upon a userspace exit we have to handle potentially
unrelated MMIO writes synchronously. And a VM-wide lock needs to be
taken in the kernel when an MMIO exit occurs.

Additionally, there is no direct way for userspace to be notified about
coalesced MMIO writes. If the next MMIO exit to userspace is when the
ring buffer has filled then a substantial (and unbounded) amount of time
may have passed since the first coalesced MMIO.

Add a KVM_CREATE_COALESCED_MMIO_BUFFER ioctl to KVM. This ioctl simply
returns a file descriptor to the caller but does not allocate a ring
buffer. Userspace can then pass this fd to mmap() to actually allocate a
buffer and map it to its address space.

Subsequent patches will allow userspace to:

- Associate the fd with a coalescing zone when registering it so that
  writes to that zone are accumulated in that specific ring buffer
  rather than the VM-wide one.
- Poll for MMIO writes using this fd.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
Reviewed-by: Paul Durrant <paul@xen.org>
---

v2->v3: 
  - Removed unnecessary brackets in a switch case and adjusted
    indentation on a spinlock as suggested by Sean Christopherson

 include/linux/kvm_host.h  |   1 +
 include/uapi/linux/kvm.h  |   2 +
 virt/kvm/coalesced_mmio.c | 141 +++++++++++++++++++++++++++++++++++---
 virt/kvm/coalesced_mmio.h |   9 +++
 virt/kvm/kvm_main.c       |   3 +
 5 files changed, 148 insertions(+), 8 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ed0520268de4..efb07422e76b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -808,6 +808,7 @@ struct kvm {
 	struct kvm_coalesced_mmio_ring *coalesced_mmio_ring;
 	spinlock_t ring_lock;
 	struct list_head coalesced_zones;
+	struct list_head coalesced_buffers;
 #endif
 
 	struct mutex irq_lock;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 637efc055145..87f79a820fc0 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1573,4 +1573,6 @@ struct kvm_pre_fault_memory {
 	__u64 padding[5];
 };
 
+#define KVM_CREATE_COALESCED_MMIO_BUFFER _IO(KVMIO,   0xd6)
+
 #endif /* __LINUX_KVM_H */
diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 184c5c40c9c1..98b7e8760aa7 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -4,6 +4,7 @@
  *
  * Copyright (c) 2008 Bull S.A.S.
  * Copyright 2009 Red Hat, Inc. and/or its affiliates.
+ * Copyright 2024 Amazon.com, Inc. or its affiliates. All Rights Reserved.
  *
  *  Author: Laurent Vivier <Laurent.Vivier@bull.net>
  *
@@ -14,6 +15,7 @@
 #include <linux/kvm_host.h>
 #include <linux/slab.h>
 #include <linux/kvm.h>
+#include <linux/anon_inodes.h>
 
 #include "coalesced_mmio.h"
 
@@ -40,17 +42,14 @@ static int coalesced_mmio_in_range(struct kvm_coalesced_mmio_dev *dev,
 	return 1;
 }
 
-static int coalesced_mmio_has_room(struct kvm_coalesced_mmio_dev *dev, u32 last)
+static int coalesced_mmio_has_room(struct kvm_coalesced_mmio_ring *ring, u32 last)
 {
-	struct kvm_coalesced_mmio_ring *ring;
-
 	/* Are we able to batch it ? */
 
 	/* last is the first free entry
 	 * check if we don't meet the first used entry
 	 * there is always one unused entry in the buffer
 	 */
-	ring = dev->kvm->coalesced_mmio_ring;
 	if ((last + 1) % KVM_COALESCED_MMIO_MAX == READ_ONCE(ring->first)) {
 		/* full */
 		return 0;
@@ -65,17 +64,27 @@ static int coalesced_mmio_write(struct kvm_vcpu *vcpu,
 {
 	struct kvm_coalesced_mmio_dev *dev = to_mmio(this);
 	struct kvm_coalesced_mmio_ring *ring = dev->kvm->coalesced_mmio_ring;
+	spinlock_t *lock = dev->buffer_dev ? &dev->buffer_dev->ring_lock :
+					     &dev->kvm->ring_lock;
 	__u32 insert;
 
 	if (!coalesced_mmio_in_range(dev, addr, len))
 		return -EOPNOTSUPP;
 
-	spin_lock(&dev->kvm->ring_lock);
+	spin_lock(lock);
+
+	if (dev->buffer_dev) {
+		ring = dev->buffer_dev->ring;
+		if (!ring) {
+			spin_unlock(lock);
+			return -EOPNOTSUPP;
+		}
+	}
 
 	insert = READ_ONCE(ring->last);
-	if (!coalesced_mmio_has_room(dev, insert) ||
+	if (!coalesced_mmio_has_room(ring, insert) ||
 	    insert >= KVM_COALESCED_MMIO_MAX) {
-		spin_unlock(&dev->kvm->ring_lock);
+		spin_unlock(lock);
 		return -EOPNOTSUPP;
 	}
 
@@ -87,7 +96,7 @@ static int coalesced_mmio_write(struct kvm_vcpu *vcpu,
 	ring->coalesced_mmio[insert].pio = dev->zone.pio;
 	smp_wmb();
 	ring->last = (insert + 1) % KVM_COALESCED_MMIO_MAX;
-	spin_unlock(&dev->kvm->ring_lock);
+	spin_unlock(lock);
 	return 0;
 }
 
@@ -122,6 +131,7 @@ int kvm_coalesced_mmio_init(struct kvm *kvm)
 	 */
 	spin_lock_init(&kvm->ring_lock);
 	INIT_LIST_HEAD(&kvm->coalesced_zones);
+	INIT_LIST_HEAD(&kvm->coalesced_buffers);
 
 	return 0;
 }
@@ -132,11 +142,125 @@ void kvm_coalesced_mmio_free(struct kvm *kvm)
 		free_page((unsigned long)kvm->coalesced_mmio_ring);
 }
 
+static void coalesced_mmio_buffer_vma_close(struct vm_area_struct *vma)
+{
+	struct kvm_coalesced_mmio_buffer_dev *dev = vma->vm_private_data;
+
+	spin_lock(&dev->ring_lock);
+
+	vfree(dev->ring);
+	dev->ring = NULL;
+
+	spin_unlock(&dev->ring_lock);
+}
+
+static const struct vm_operations_struct coalesced_mmio_buffer_vm_ops = {
+	.close = coalesced_mmio_buffer_vma_close,
+};
+
+static int coalesced_mmio_buffer_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct kvm_coalesced_mmio_buffer_dev *dev = file->private_data;
+	unsigned long pfn;
+	int ret = 0;
+
+	spin_lock(&dev->ring_lock);
+
+	if (dev->ring) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
+	dev->ring = vmalloc_user(PAGE_SIZE);
+	if (!dev->ring) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+
+	pfn = vmalloc_to_pfn(dev->ring);
+
+	if (remap_pfn_range(vma, vma->vm_start, pfn, PAGE_SIZE,
+			    vma->vm_page_prot)) {
+		vfree(dev->ring);
+		dev->ring = NULL;
+		ret = -EAGAIN;
+		goto out_unlock;
+	}
+
+	vma->vm_ops = &coalesced_mmio_buffer_vm_ops;
+	vma->vm_private_data = dev;
+
+out_unlock:
+	spin_unlock(&dev->ring_lock);
+
+	return ret;
+}
+
+static int coalesced_mmio_buffer_release(struct inode *inode, struct file *file)
+{
+
+	struct kvm_coalesced_mmio_buffer_dev *buffer_dev = file->private_data;
+	struct kvm_coalesced_mmio_dev *mmio_dev, *tmp;
+	struct kvm *kvm = buffer_dev->kvm;
+
+	/* Deregister all zones associated with this ring buffer */
+	mutex_lock(&kvm->slots_lock);
+
+	list_for_each_entry_safe(mmio_dev, tmp, &kvm->coalesced_zones, list) {
+		if (mmio_dev->buffer_dev == buffer_dev) {
+			if (kvm_io_bus_unregister_dev(kvm,
+			    mmio_dev->zone.pio ? KVM_PIO_BUS : KVM_MMIO_BUS,
+			    &mmio_dev->dev))
+				break;
+		}
+	}
+
+	list_del(&buffer_dev->list);
+	kfree(buffer_dev);
+
+	mutex_unlock(&kvm->slots_lock);
+
+	return 0;
+}
+
+static const struct file_operations coalesced_mmio_buffer_ops = {
+	.mmap = coalesced_mmio_buffer_mmap,
+	.release = coalesced_mmio_buffer_release,
+};
+
+int kvm_vm_ioctl_create_coalesced_mmio_buffer(struct kvm *kvm)
+{
+	int ret;
+	struct kvm_coalesced_mmio_buffer_dev *dev;
+
+	dev = kzalloc(sizeof(struct kvm_coalesced_mmio_buffer_dev),
+		      GFP_KERNEL_ACCOUNT);
+	if (!dev)
+		return -ENOMEM;
+
+	dev->kvm = kvm;
+	spin_lock_init(&dev->ring_lock);
+
+	ret = anon_inode_getfd("coalesced_mmio_buf", &coalesced_mmio_buffer_ops,
+			       dev, O_RDWR | O_CLOEXEC);
+	if (ret < 0) {
+		kfree(dev);
+		return ret;
+	}
+
+	mutex_lock(&kvm->slots_lock);
+	list_add_tail(&dev->list, &kvm->coalesced_buffers);
+	mutex_unlock(&kvm->slots_lock);
+
+	return ret;
+}
+
 int kvm_vm_ioctl_register_coalesced_mmio(struct kvm *kvm,
 					 struct kvm_coalesced_mmio_zone *zone)
 {
 	int ret;
 	struct kvm_coalesced_mmio_dev *dev;
+	struct kvm_coalesced_mmio_buffer_dev *buffer_dev = NULL;
 
 	if (zone->pio != 1 && zone->pio != 0)
 		return -EINVAL;
@@ -149,6 +273,7 @@ int kvm_vm_ioctl_register_coalesced_mmio(struct kvm *kvm,
 	kvm_iodevice_init(&dev->dev, &coalesced_mmio_ops);
 	dev->kvm = kvm;
 	dev->zone = *zone;
+	dev->buffer_dev = buffer_dev;
 
 	mutex_lock(&kvm->slots_lock);
 	ret = kvm_io_bus_register_dev(kvm,
diff --git a/virt/kvm/coalesced_mmio.h b/virt/kvm/coalesced_mmio.h
index 36f84264ed25..37d9d8f325bb 100644
--- a/virt/kvm/coalesced_mmio.h
+++ b/virt/kvm/coalesced_mmio.h
@@ -20,6 +20,14 @@ struct kvm_coalesced_mmio_dev {
 	struct kvm_io_device dev;
 	struct kvm *kvm;
 	struct kvm_coalesced_mmio_zone zone;
+	struct kvm_coalesced_mmio_buffer_dev *buffer_dev;
+};
+
+struct kvm_coalesced_mmio_buffer_dev {
+	struct list_head list;
+	struct kvm *kvm;
+	spinlock_t ring_lock;
+	struct kvm_coalesced_mmio_ring *ring;
 };
 
 int kvm_coalesced_mmio_init(struct kvm *kvm);
@@ -28,6 +36,7 @@ int kvm_vm_ioctl_register_coalesced_mmio(struct kvm *kvm,
 					struct kvm_coalesced_mmio_zone *zone);
 int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
 					struct kvm_coalesced_mmio_zone *zone);
+int kvm_vm_ioctl_create_coalesced_mmio_buffer(struct kvm *kvm);
 
 #else
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 238940c3cb32..9f6ad6e03317 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5244,6 +5244,9 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = kvm_vm_ioctl_unregister_coalesced_mmio(kvm, &zone);
 		break;
 	}
+	case KVM_CREATE_COALESCED_MMIO_BUFFER:
+		r = kvm_vm_ioctl_create_coalesced_mmio_buffer(kvm);
+		break;
 #endif
 	case KVM_IRQFD: {
 		struct kvm_irqfd data;
-- 
2.34.1


