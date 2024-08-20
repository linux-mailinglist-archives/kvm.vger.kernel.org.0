Return-Path: <kvm+bounces-24640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 65C2295880B
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 15:36:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E468C1F23119
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 13:36:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD2A118FDD0;
	Tue, 20 Aug 2024 13:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="mvQXhZ1M"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B1D1AACB
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 13:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.184.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724160980; cv=none; b=F1H9Zi2Mfe70IpS/7yFtyhl5/YAW+bXDfUNl4XsTHQ1lGI1SoAZJY9hn/iTt3vVOpwDzrnRyF+jmjAmgSUlfCYrJBLTDqbHa1dZamBoDOMEgkOGSyubae01bG/Y5GIH+2LuBiT1MXWRkQaXsGYNpMyzakkBNV2sz5gbbvLTVneE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724160980; c=relaxed/simple;
	bh=iw1QWwjO96/sdC+kz/Am60/DexumwNF4Cpl59Um2lWQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VesXlSGz01LD6lK/QYBTRprOrKzb5/1bC6+kFvOAzm35VGXOdSF8cCy34nz39AC4UhQhbIQhU7OiNgbeMjSG/oeEH/RRk5H1+D7FzXk1RKAPoY2aabNWQShuHmZ82YdmXhls2wYQ/d206GpmVvUKL4kWNg8IxvSthQazt+p+e30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=mvQXhZ1M; arc=none smtp.client-ip=207.171.184.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1724160980; x=1755696980;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pxAqEm5rxhhnLv8GE0igYRWRK9hF/AAIPjpVwR077/I=;
  b=mvQXhZ1MkLW3iNcnZmnDIbcxqECAEm5aqQOp062j17X8g7obcc61u16l
   OPXQX3pek2b/h0gQGudm19Onu4kPabU7S10sX2lJ2lzJS8d/KHBuTCKJb
   GJqrlggvrRpy5LScGr84ZZ8NWU7iC3iivpQZkBHkQyUF9Af8x2aoyFPr9
   E=;
X-IronPort-AV: E=Sophos;i="6.10,162,1719878400"; 
   d="scan'208";a="445536591"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 13:36:18 +0000
Received: from EX19MTAEUB002.ant.amazon.com [10.0.10.100:13602]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.12.81:2525] with esmtp (Farcaster)
 id f759a4a7-0a4a-45da-82d1-d9f07ea0aadf; Tue, 20 Aug 2024 13:36:16 +0000 (UTC)
X-Farcaster-Flow-ID: f759a4a7-0a4a-45da-82d1-d9f07ea0aadf
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 20 Aug 2024 13:36:15 +0000
Received: from u94b036d6357a55.ant.amazon.com (10.106.82.48) by
 EX19D018EUA002.ant.amazon.com (10.252.50.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 20 Aug 2024 13:36:12 +0000
From: Ilias Stamatis <ilstam@amazon.com>
To: <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC: <pdurrant@amazon.co.uk>, <dwmw@amazon.co.uk>, <seanjc@google.com>,
	<nh-open-source@amazon.com>, Ilias Stamatis <ilstam@amazon.com>
Subject: [PATCH v3 3/6] KVM: Support poll() on coalesced mmio buffer fds
Date: Tue, 20 Aug 2024 14:33:30 +0100
Message-ID: <20240820133333.1724191-4-ilstam@amazon.com>
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

There is no direct way for userspace to be notified about coalesced MMIO
writes when using KVM_REGISTER_COALESCED_MMIO. If the next MMIO exit is
when the ring buffer has filled then a substantial (and unbounded)
amount of time may have passed since the first coalesced MMIO.

To improve this, make it possible for userspace to use poll() and
select() on the fd returned by the KVM_CREATE_COALESCED_MMIO_BUFFER
ioctl. This way a userspace VMM could have dedicated threads that deal
with writes to specific MMIO zones.

For example, a common use of MMIO, particularly in the realm of network
devices, is as a doorbell. A write to a doorbell register will trigger
the device to initiate a DMA transfer.

When a network device is emulated by userspace a write to a doorbell
register would typically result in an MMIO exit so that userspace can
emulate the DMA transfer in a timely manner. No further processing can
be done until userspace performs the necessary emulation and re-invokes
KVM_RUN. Even if userspace makes use of another thread to emulate the
DMA transfer such MMIO exits are disruptive to the vCPU and they may
also be quite frequent if, for example, the vCPU is sending a sequence
of short packets to the network device.

By supporting poll() on coalesced buffer fds, userspace can have
dedicated threads wait for new doorbell writes and avoid the performance
hit of userspace exits on the main vCPU threads.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
---

v2->v3:
  - Changed POLLIN | POLLRDNORM to EPOLLIN | EPOLLRDNORM

 virt/kvm/coalesced_mmio.c | 22 ++++++++++++++++++++++
 virt/kvm/coalesced_mmio.h |  1 +
 2 files changed, 23 insertions(+)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 98b7e8760aa7..039c6ffcb2a8 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/kvm.h>
 #include <linux/anon_inodes.h>
+#include <linux/poll.h>
 
 #include "coalesced_mmio.h"
 
@@ -97,6 +98,10 @@ static int coalesced_mmio_write(struct kvm_vcpu *vcpu,
 	smp_wmb();
 	ring->last = (insert + 1) % KVM_COALESCED_MMIO_MAX;
 	spin_unlock(lock);
+
+	if (dev->buffer_dev)
+		wake_up_interruptible(&dev->buffer_dev->wait_queue);
+
 	return 0;
 }
 
@@ -223,9 +228,25 @@ static int coalesced_mmio_buffer_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static __poll_t coalesced_mmio_buffer_poll(struct file *file, struct poll_table_struct *wait)
+{
+	struct kvm_coalesced_mmio_buffer_dev *dev = file->private_data;
+	__poll_t mask = 0;
+
+	poll_wait(file, &dev->wait_queue, wait);
+
+	spin_lock(&dev->ring_lock);
+	if (dev->ring && (READ_ONCE(dev->ring->first) != READ_ONCE(dev->ring->last)))
+		mask = EPOLLIN | EPOLLRDNORM;
+	spin_unlock(&dev->ring_lock);
+
+	return mask;
+}
+
 static const struct file_operations coalesced_mmio_buffer_ops = {
 	.mmap = coalesced_mmio_buffer_mmap,
 	.release = coalesced_mmio_buffer_release,
+	.poll = coalesced_mmio_buffer_poll,
 };
 
 int kvm_vm_ioctl_create_coalesced_mmio_buffer(struct kvm *kvm)
@@ -239,6 +260,7 @@ int kvm_vm_ioctl_create_coalesced_mmio_buffer(struct kvm *kvm)
 		return -ENOMEM;
 
 	dev->kvm = kvm;
+	init_waitqueue_head(&dev->wait_queue);
 	spin_lock_init(&dev->ring_lock);
 
 	ret = anon_inode_getfd("coalesced_mmio_buf", &coalesced_mmio_buffer_ops,
diff --git a/virt/kvm/coalesced_mmio.h b/virt/kvm/coalesced_mmio.h
index 37d9d8f325bb..d1807ce26464 100644
--- a/virt/kvm/coalesced_mmio.h
+++ b/virt/kvm/coalesced_mmio.h
@@ -26,6 +26,7 @@ struct kvm_coalesced_mmio_dev {
 struct kvm_coalesced_mmio_buffer_dev {
 	struct list_head list;
 	struct kvm *kvm;
+	wait_queue_head_t wait_queue;
 	spinlock_t ring_lock;
 	struct kvm_coalesced_mmio_ring *ring;
 };
-- 
2.34.1


