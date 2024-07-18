Return-Path: <kvm+bounces-21870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 570F1935232
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:38:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9CFC1F228CB
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 19:38:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2C441459FA;
	Thu, 18 Jul 2024 19:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="IGvyLPwn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9105.amazon.com (smtp-fw-9105.amazon.com [207.171.188.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA8776C61
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 19:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.188.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721331491; cv=none; b=hGVK0foPmHaHDQ471TIqwdLCkZ7SCowMSO7fgsL2YAUqtd5Qr4FZWhllvXZwaT3wVeYOTIv8J4CcU65mh8Vm32lBLN0dcAfARLVNZ/4MqD+RXOqiFQy1VOMHKbLyLzdS9V/rfoDMDa8KHdJ90Skpt8wz7xbqOlSkQjtG8t4r05A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721331491; c=relaxed/simple;
	bh=mw+1wclq3aMpTfVoYmIPfe5Mlt3mNkfBoYByWPpMPsw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cxDZSjXwkAbgQtw/XX+Q626n1Wprt97GmDcVcVnuFbEq6oGYoxtDMx1tux3IDHMd8YXrkLYLaII9BxLDNfOZeWbWasJiJ4GNbJH0eIu7fHM7awZMdaZqOC1IYy5z6Umn7lVu9qADCswPTcfqdAAFoEvhjQJGVhiMEaaiqCjQy8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=IGvyLPwn; arc=none smtp.client-ip=207.171.188.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1721331489; x=1752867489;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+w7lF+t3bZqR0ZUF/JF76PtdqhRCDfv7lHYYEXZJRlo=;
  b=IGvyLPwn+J8qGp3XcqlIfOacakW3L38HWRHwnfm9YMnD7loPrO7d0RZz
   nHxVLcw5Opag6mAYmrCiZwcTSZENqRfC+lVZZS/pLU9BOgGcPxZ1a5Mfd
   TcY8jzO0i6fA8+DRUYf8jVyahOJsWqrw7BbaKBkWVZdaCPtKb7xcAoPv/
   o=;
X-IronPort-AV: E=Sophos;i="6.09,218,1716249600"; 
   d="scan'208";a="743180324"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-9105.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 19:38:09 +0000
Received: from EX19MTAEUA002.ant.amazon.com [10.0.43.254:47700]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.5.92:2525] with esmtp (Farcaster)
 id dcff267d-6645-482f-8cf5-3933f1d80e8d; Thu, 18 Jul 2024 19:38:07 +0000 (UTC)
X-Farcaster-Flow-ID: dcff267d-6645-482f-8cf5-3933f1d80e8d
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 18 Jul 2024 19:38:06 +0000
Received: from u94b036d6357a55.ant.amazon.com (10.106.82.17) by
 EX19D018EUA002.ant.amazon.com (10.252.50.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 18 Jul 2024 19:38:03 +0000
From: Ilias Stamatis <ilstam@amazon.com>
To: <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC: <pdurrant@amazon.co.uk>, <dwmw@amazon.co.uk>, <nh-open-source@amazon.com>,
	Ilias Stamatis <ilstam@amazon.com>, Paul Durrant <paul@xen.org>
Subject: [PATCH v2 4/6] KVM: Add KVM_(UN)REGISTER_COALESCED_MMIO2 ioctls
Date: Thu, 18 Jul 2024 20:35:41 +0100
Message-ID: <20240718193543.624039-5-ilstam@amazon.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240718193543.624039-1-ilstam@amazon.com>
References: <20240718193543.624039-1-ilstam@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D039UWB003.ant.amazon.com (10.13.138.93) To
 EX19D018EUA002.ant.amazon.com (10.252.50.146)

Add 2 new ioctls, KVM_REGISTER_COALESCED_MMIO2 and
KVM_UNREGISTER_COALESCED_MMIO2. These do the same thing as their v1
equivalents except an fd returned by KVM_CREATE_COALESCED_MMIO_BUFFER
needs to be passed as an argument to them.

The fd representing a ring buffer is associated with an MMIO region
registered for coalescing and all writes to that region are accumulated
there. This is in contrast to the v1 API where all regions have to share
the same buffer. Nevertheless, userspace code can still use the same
ring buffer for multiple zones if it wishes to do so.

Userspace can check for the availability of the new API by checking if
the KVM_CAP_COALESCED_MMIO2 capability is supported.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
Reviewed-by: Paul Durrant <paul@xen.org>
---

v1->v2:
  - Rebased on top of kvm/queue resolving the conflict in kvm.h

 include/uapi/linux/kvm.h  | 16 ++++++++++++++++
 virt/kvm/coalesced_mmio.c | 37 +++++++++++++++++++++++++++++++------
 virt/kvm/coalesced_mmio.h |  7 ++++---
 virt/kvm/kvm_main.c       | 36 +++++++++++++++++++++++++++++++++++-
 4 files changed, 86 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 87f79a820fc0..7e8d5c879986 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -480,6 +480,16 @@ struct kvm_coalesced_mmio_zone {
 	};
 };
 
+struct kvm_coalesced_mmio_zone2 {
+	__u64 addr;
+	__u32 size;
+	union {
+		__u32 pad;
+		__u32 pio;
+	};
+	int buffer_fd;
+};
+
 struct kvm_coalesced_mmio {
 	__u64 phys_addr;
 	__u32 len;
@@ -933,6 +943,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_PRE_FAULT_MEMORY 236
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
+#define KVM_CAP_COALESCED_MMIO2 239
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1573,6 +1584,11 @@ struct kvm_pre_fault_memory {
 	__u64 padding[5];
 };
 
+/* Available with KVM_CAP_COALESCED_MMIO2 */
 #define KVM_CREATE_COALESCED_MMIO_BUFFER _IO(KVMIO,   0xd6)
+#define KVM_REGISTER_COALESCED_MMIO2 \
+			_IOW(KVMIO,  0xd7, struct kvm_coalesced_mmio_zone2)
+#define KVM_UNREGISTER_COALESCED_MMIO2 \
+			_IOW(KVMIO,  0xd8, struct kvm_coalesced_mmio_zone2)
 
 #endif /* __LINUX_KVM_H */
diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 64428b0a4aad..729f3293f768 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -17,6 +17,7 @@
 #include <linux/kvm.h>
 #include <linux/anon_inodes.h>
 #include <linux/poll.h>
+#include <linux/file.h>
 
 #include "coalesced_mmio.h"
 
@@ -279,19 +280,40 @@ int kvm_vm_ioctl_create_coalesced_mmio_buffer(struct kvm *kvm)
 }
 
 int kvm_vm_ioctl_register_coalesced_mmio(struct kvm *kvm,
-					 struct kvm_coalesced_mmio_zone *zone)
+					 struct kvm_coalesced_mmio_zone2 *zone,
+					 bool use_buffer_fd)
 {
-	int ret;
+	int ret = 0;
+	struct file *file;
 	struct kvm_coalesced_mmio_dev *dev;
 	struct kvm_coalesced_mmio_buffer_dev *buffer_dev = NULL;
 
 	if (zone->pio != 1 && zone->pio != 0)
 		return -EINVAL;
 
+	if (use_buffer_fd) {
+		file = fget(zone->buffer_fd);
+		if (!file)
+			return -EBADF;
+
+		if (file->f_op != &coalesced_mmio_buffer_ops) {
+			fput(file);
+			return -EINVAL;
+		}
+
+		buffer_dev = file->private_data;
+		if (!buffer_dev->ring) {
+			fput(file);
+			return -ENOBUFS;
+		}
+	}
+
 	dev = kzalloc(sizeof(struct kvm_coalesced_mmio_dev),
 		      GFP_KERNEL_ACCOUNT);
-	if (!dev)
-		return -ENOMEM;
+	if (!dev) {
+		ret = -ENOMEM;
+		goto out_free_file;
+	}
 
 	kvm_iodevice_init(&dev->dev, &coalesced_mmio_ops);
 	dev->kvm = kvm;
@@ -307,17 +329,20 @@ int kvm_vm_ioctl_register_coalesced_mmio(struct kvm *kvm,
 	list_add_tail(&dev->list, &kvm->coalesced_zones);
 	mutex_unlock(&kvm->slots_lock);
 
-	return 0;
+	goto out_free_file;
 
 out_free_dev:
 	mutex_unlock(&kvm->slots_lock);
 	kfree(dev);
+out_free_file:
+	if (use_buffer_fd)
+		fput(file);
 
 	return ret;
 }
 
 int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
-					   struct kvm_coalesced_mmio_zone *zone)
+					   struct kvm_coalesced_mmio_zone2 *zone)
 {
 	struct kvm_coalesced_mmio_dev *dev, *tmp;
 	int r;
diff --git a/virt/kvm/coalesced_mmio.h b/virt/kvm/coalesced_mmio.h
index d1807ce26464..32792adb7cb4 100644
--- a/virt/kvm/coalesced_mmio.h
+++ b/virt/kvm/coalesced_mmio.h
@@ -19,7 +19,7 @@ struct kvm_coalesced_mmio_dev {
 	struct list_head list;
 	struct kvm_io_device dev;
 	struct kvm *kvm;
-	struct kvm_coalesced_mmio_zone zone;
+	struct kvm_coalesced_mmio_zone2 zone;
 	struct kvm_coalesced_mmio_buffer_dev *buffer_dev;
 };
 
@@ -34,9 +34,10 @@ struct kvm_coalesced_mmio_buffer_dev {
 int kvm_coalesced_mmio_init(struct kvm *kvm);
 void kvm_coalesced_mmio_free(struct kvm *kvm);
 int kvm_vm_ioctl_register_coalesced_mmio(struct kvm *kvm,
-					struct kvm_coalesced_mmio_zone *zone);
+					struct kvm_coalesced_mmio_zone2 *zone,
+					bool use_buffer_fd);
 int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
-					struct kvm_coalesced_mmio_zone *zone);
+					struct kvm_coalesced_mmio_zone2 *zone);
 int kvm_vm_ioctl_create_coalesced_mmio_buffer(struct kvm *kvm);
 
 #else
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9eb22287384f..ef7dcce80136 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4892,6 +4892,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #ifdef CONFIG_KVM_MMIO
 	case KVM_CAP_COALESCED_MMIO:
 		return KVM_COALESCED_MMIO_PAGE_OFFSET;
+	case KVM_CAP_COALESCED_MMIO2:
 	case KVM_CAP_COALESCED_PIO:
 		return 1;
 #endif
@@ -5230,15 +5231,48 @@ static long kvm_vm_ioctl(struct file *filp,
 #ifdef CONFIG_KVM_MMIO
 	case KVM_REGISTER_COALESCED_MMIO: {
 		struct kvm_coalesced_mmio_zone zone;
+		struct kvm_coalesced_mmio_zone2 zone2;
 
 		r = -EFAULT;
 		if (copy_from_user(&zone, argp, sizeof(zone)))
 			goto out;
-		r = kvm_vm_ioctl_register_coalesced_mmio(kvm, &zone);
+
+		zone2.addr = zone.addr;
+		zone2.size = zone.size;
+		zone2.pio = zone.pio;
+		zone2.buffer_fd = -1;
+
+		r = kvm_vm_ioctl_register_coalesced_mmio(kvm, &zone2, false);
+		break;
+	}
+	case KVM_REGISTER_COALESCED_MMIO2: {
+		struct kvm_coalesced_mmio_zone2 zone;
+
+		r = -EFAULT;
+		if (copy_from_user(&zone, argp, sizeof(zone)))
+			goto out;
+
+		r = kvm_vm_ioctl_register_coalesced_mmio(kvm, &zone, true);
 		break;
 	}
 	case KVM_UNREGISTER_COALESCED_MMIO: {
 		struct kvm_coalesced_mmio_zone zone;
+		struct kvm_coalesced_mmio_zone2 zone2;
+
+		r = -EFAULT;
+		if (copy_from_user(&zone, argp, sizeof(zone)))
+			goto out;
+
+		zone2.addr = zone.addr;
+		zone2.size = zone.size;
+		zone2.pio = zone.pio;
+		zone2.buffer_fd = -1;
+
+		r = kvm_vm_ioctl_unregister_coalesced_mmio(kvm, &zone2);
+		break;
+	}
+	case KVM_UNREGISTER_COALESCED_MMIO2: {
+		struct kvm_coalesced_mmio_zone2 zone;
 
 		r = -EFAULT;
 		if (copy_from_user(&zone, argp, sizeof(zone)))
-- 
2.34.1


