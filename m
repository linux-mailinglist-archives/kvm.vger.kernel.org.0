Return-Path: <kvm+bounces-24641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DEE5E95880E
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 15:36:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 50F80B22226
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 13:36:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B00B5190462;
	Tue, 20 Aug 2024 13:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="oYR6GnYK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A2C1AACB
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 13:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724160995; cv=none; b=Ht/DwWCiNsye9q/EdzE5Y2hxkBKvcOFzVIWDp7SnE96VWIQ0MiRJnoZ1oo3X2q/bwEuhf6ecw1K+UwnxangWeVQ/9A+8w21xaahTkX0xUeoJIzWE3aqgd2+iZYK1+vP69kSwifBL6AYgBH2/A3a3yQ9dQGchXdIaLk58Coy3qEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724160995; c=relaxed/simple;
	bh=8qRz65138DbQ1wYR8NJQERvCVlqRCL9dw54IgzqNIwY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ApDltt7xMk9nVgfO1nIqsZcVuY/RzPiVDsB5BEQaw+GiCco8DeEBL2nEbE6LxOp8gtU0V2thkA05397tAHEaQvCFOoaMEif1/hJOH4IxXMuaaWoyhnpZy1m+ynflBo+UwY6HETEMGwLwTJbA7u0h9z1vu+VEMPCTE15/mJm3tEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=oYR6GnYK; arc=none smtp.client-ip=52.119.213.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1724160994; x=1755696994;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cfR30k25ea+4miTS6gGoJvcvkvW0H+8ygzR5VlhnEdw=;
  b=oYR6GnYKl0GwA8bb3YaoBtD2KyGO2qhiDU/GY9wSXKVyCjvcV2VS8Mve
   RAzCCSHTmWKHq322c+otpRyjYU3SOgO95DMf0wLadHandCIU4Ke/+6E8q
   EJz3P/xqJo3L8CNwJsaYw4LqEy5D86Vyvf/PVuwAQY5dhceF5s5Efyvor
   U=;
X-IronPort-AV: E=Sophos;i="6.10,162,1719878400"; 
   d="scan'208";a="674929191"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 13:36:29 +0000
Received: from EX19MTAEUC002.ant.amazon.com [10.0.17.79:63397]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.26.14:2525] with esmtp (Farcaster)
 id 45fac969-3a73-4d03-95ca-d1de2b0d7440; Tue, 20 Aug 2024 13:36:28 +0000 (UTC)
X-Farcaster-Flow-ID: 45fac969-3a73-4d03-95ca-d1de2b0d7440
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 20 Aug 2024 13:36:27 +0000
Received: from u94b036d6357a55.ant.amazon.com (10.106.82.48) by
 EX19D018EUA002.ant.amazon.com (10.252.50.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 20 Aug 2024 13:36:24 +0000
From: Ilias Stamatis <ilstam@amazon.com>
To: <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC: <pdurrant@amazon.co.uk>, <dwmw@amazon.co.uk>, <seanjc@google.com>,
	<nh-open-source@amazon.com>, Ilias Stamatis <ilstam@amazon.com>, Paul Durrant
	<paul@xen.org>
Subject: [PATCH v3 4/6] KVM: Add KVM_(UN)REGISTER_COALESCED_MMIO2 ioctls
Date: Tue, 20 Aug 2024 14:33:31 +0100
Message-ID: <20240820133333.1724191-5-ilstam@amazon.com>
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

v2->v3:
  - Changed type of buffer_fd from int to __u32
  - Removed 0 initialisation of ret in
    kvm_vm_ioctl_register_coalesced_mmio()

 include/uapi/linux/kvm.h  | 16 ++++++++++++++++
 virt/kvm/coalesced_mmio.c | 36 +++++++++++++++++++++++++++++++-----
 virt/kvm/coalesced_mmio.h |  7 ++++---
 virt/kvm/kvm_main.c       | 34 +++++++++++++++++++++++++++++++++-
 4 files changed, 84 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 87f79a820fc0..5e9fcc560cc1 100644
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
+	__u32 buffer_fd;
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
index 039c6ffcb2a8..4e237ee66711 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -17,6 +17,7 @@
 #include <linux/kvm.h>
 #include <linux/anon_inodes.h>
 #include <linux/poll.h>
+#include <linux/file.h>
 
 #include "coalesced_mmio.h"
 
@@ -278,19 +279,40 @@ int kvm_vm_ioctl_create_coalesced_mmio_buffer(struct kvm *kvm)
 }
 
 int kvm_vm_ioctl_register_coalesced_mmio(struct kvm *kvm,
-					 struct kvm_coalesced_mmio_zone *zone)
+					 struct kvm_coalesced_mmio_zone2 *zone,
+					 bool use_buffer_fd)
 {
 	int ret;
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
@@ -306,17 +328,21 @@ int kvm_vm_ioctl_register_coalesced_mmio(struct kvm *kvm,
 	list_add_tail(&dev->list, &kvm->coalesced_zones);
 	mutex_unlock(&kvm->slots_lock);
 
-	return 0;
+	ret = 0;
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
index 9f6ad6e03317..0850f151ef16 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4890,6 +4890,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #ifdef CONFIG_KVM_MMIO
 	case KVM_CAP_COALESCED_MMIO:
 		return KVM_COALESCED_MMIO_PAGE_OFFSET;
+	case KVM_CAP_COALESCED_MMIO2:
 	case KVM_CAP_COALESCED_PIO:
 		return 1;
 #endif
@@ -5228,15 +5229,46 @@ static long kvm_vm_ioctl(struct file *filp,
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


