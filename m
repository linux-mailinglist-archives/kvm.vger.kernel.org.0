Return-Path: <kvm+bounces-21288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D46692CDAA
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 10:58:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2121F1F239D1
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 08:58:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1A1717DE13;
	Wed, 10 Jul 2024 08:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="d0+HcxMh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9105.amazon.com (smtp-fw-9105.amazon.com [207.171.188.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9724216C6B7
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 08:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.188.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720601806; cv=none; b=mu6j/1TFNYTXlYyeRtnzRC3w0fV5Xpq9OHPL4nJ3a+C/T0PReTN6kOJoHDrH4HezmzNK3dh4wOKGbjF90OnQED+CBCEemI/ARRBLl0YoZ8k6GY5aL3lajalt/7+lvQCHZA242A2XI9MyBFTugEdEzKhow03bQUPUAS/RG3emYac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720601806; c=relaxed/simple;
	bh=xZRC+TSL9t1kkYmHGAHFXNLUkVZ4ZmsHu4HN+7myEDA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WvhkGKilVDFMcnGpjxnAZ9FcUKsGXwSjWznJ9ivq+FTO4kFTWeiySJZszEhZ3nRuthLKUcZEQFbmRV52RC/1JK8q5QPuO6DDBYgwkWXqy3Ztv/ACEDPMHrQ1ePrpK/VHks3/hoJS/ReXJtM42d6vNc8Va9Hqwvd+bOFvuuzb7PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=d0+HcxMh; arc=none smtp.client-ip=207.171.188.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1720601805; x=1752137805;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JPthk+H6+rV2P4lFS2mAgQOgY5YoGWBX1ScOjvxoVg8=;
  b=d0+HcxMhU0qR8y6WB4Vfv033TyNvEtdDkHcYlhlp0z24FMSzPP8BE8y9
   b1KGAZFtUp+94kXoLw/ygUy8kD9QgfxGP1V/jPUy2W+CBSkxLw+YuMB+n
   NmG76dyLVob1j1fI/N1t2JfjcDUr1jKZsVwMNzspTgJExBUQRtWPxDQ71
   A=;
X-IronPort-AV: E=Sophos;i="6.09,197,1716249600"; 
   d="scan'208";a="740291003"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-9105.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2024 08:56:38 +0000
Received: from EX19MTAEUB002.ant.amazon.com [10.0.17.79:48111]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.31.69:2525] with esmtp (Farcaster)
 id 02814e8b-f899-496e-b152-8b80ab24fc8a; Wed, 10 Jul 2024 08:56:37 +0000 (UTC)
X-Farcaster-Flow-ID: 02814e8b-f899-496e-b152-8b80ab24fc8a
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 10 Jul 2024 08:56:37 +0000
Received: from u94b036d6357a55.ant.amazon.com (10.106.83.14) by
 EX19D018EUA002.ant.amazon.com (10.252.50.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 10 Jul 2024 08:56:32 +0000
From: Ilias Stamatis <ilstam@amazon.com>
To: <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC: <pdurrant@amazon.co.uk>, <dwmw@amazon.co.uk>, <Laurent.Vivier@bull.net>,
	<ghaskins@novell.com>, <avi@redhat.com>, <mst@redhat.com>,
	<levinsasha928@gmail.com>, <peng.hao2@zte.com.cn>,
	<nh-open-source@amazon.com>
Subject: [PATCH 4/6] KVM: Add KVM_(UN)REGISTER_COALESCED_MMIO2 ioctls
Date: Wed, 10 Jul 2024 09:52:57 +0100
Message-ID: <20240710085259.2125131-5-ilstam@amazon.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240710085259.2125131-1-ilstam@amazon.com>
References: <20240710085259.2125131-1-ilstam@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D046UWB001.ant.amazon.com (10.13.139.187) To
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
---
 include/uapi/linux/kvm.h  | 16 ++++++++++++++++
 virt/kvm/coalesced_mmio.c | 36 ++++++++++++++++++++++++++++++------
 virt/kvm/coalesced_mmio.h |  7 ++++---
 virt/kvm/kvm_main.c       | 36 +++++++++++++++++++++++++++++++++++-
 4 files changed, 85 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6d6f132e6203..e49dda50b639 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -467,6 +467,16 @@ struct kvm_coalesced_mmio_zone {
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
@@ -917,6 +927,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_MEMORY_ATTRIBUTES 233
 #define KVM_CAP_GUEST_MEMFD 234
 #define KVM_CAP_VM_TYPES 235
+#define KVM_CAP_COALESCED_MMIO2 236
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1548,6 +1559,11 @@ struct kvm_create_guest_memfd {
 	__u64 reserved[6];
 };
 
+/* Available with KVM_CAP_COALESCED_MMIO2 */
 #define KVM_CREATE_COALESCED_MMIO_BUFFER _IO(KVMIO,   0xd5)
+#define KVM_REGISTER_COALESCED_MMIO2 \
+			_IOW(KVMIO,  0xd6, struct kvm_coalesced_mmio_zone2)
+#define KVM_UNREGISTER_COALESCED_MMIO2 \
+			_IOW(KVMIO,  0xd7, struct kvm_coalesced_mmio_zone2)
 
 #endif /* __LINUX_KVM_H */
diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 00439e035d74..8d6d98c01f6e 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -277,19 +277,40 @@ int kvm_vm_ioctl_create_coalesced_mmio_buffer(struct kvm *kvm)
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
@@ -305,17 +326,20 @@ int kvm_vm_ioctl_register_coalesced_mmio(struct kvm *kvm,
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
index 54df2e88d4f4..683b5d392b5f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4815,6 +4815,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #ifdef CONFIG_KVM_MMIO
 	case KVM_CAP_COALESCED_MMIO:
 		return KVM_COALESCED_MMIO_PAGE_OFFSET;
+	case KVM_CAP_COALESCED_MMIO2:
 	case KVM_CAP_COALESCED_PIO:
 		return 1;
 #endif
@@ -5153,15 +5154,48 @@ static long kvm_vm_ioctl(struct file *filp,
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


