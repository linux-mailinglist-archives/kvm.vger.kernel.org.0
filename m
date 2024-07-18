Return-Path: <kvm+bounces-21869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B97E935231
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:38:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 667291F22A41
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 19:38:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AFBF1459FA;
	Thu, 18 Jul 2024 19:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="uLACcLni"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9106.amazon.com (smtp-fw-9106.amazon.com [207.171.188.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0019576C61
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 19:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.188.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721331483; cv=none; b=t7kgzUZihZ4mJzjXYykp+4Ug2Tl+iXIeKy1lmLKytQNiIq6QHRVYd3Wjm/Q1jaUpUqDLcwUwvyYEnelWh50hmHcu5qDiEsCJiRrsOJGNmSpqCRpqxD9VRzVJKh1Kr3OX528DdvHEI5vYn9ZMCgsEci33YZMDAKYXwImZpKVDT0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721331483; c=relaxed/simple;
	bh=ThggfbtUR+HIxIxprWsdalkBJgWFtsLFkvRsvdVg6b4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oF02jHRlb3xGYZZxtQLbZjpF94lNF/iO1PkGiyJSxsOtnBXgpJRHU5reLzpHP68SKxy69u4zFn9fuyXNEvIQzJiPlTfi13UMChk46NZzUKqiJ6zGpwHEKnwVsOLJUJXhShVvhy4Hg949ZWtwdjPqTCvrgAUpRBGDLAIDHCx//vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=uLACcLni; arc=none smtp.client-ip=207.171.188.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1721331483; x=1752867483;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MB+EHQVG319OhWh0cAtog6YRfreSRQvFRo5mZIIKpHY=;
  b=uLACcLniJSI4c4xff9YST4teJSE1KTUvYHDhC4Fj6ZB+RPiLai4C/oFd
   WLTpwOqtGQFjBOBjhdS5wfOXboD7dbah+R7LfO39kVF47aZ6dpQxu3YdC
   QDRaUYfqABfJZbhRgC+v8UBvZnYZozKN032CZ6GA0TgNlHli8cEHwtVyA
   8=;
X-IronPort-AV: E=Sophos;i="6.09,218,1716249600"; 
   d="scan'208";a="742561287"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-9106.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 19:37:56 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.10.100:32441]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.19.28:2525] with esmtp (Farcaster)
 id aab5836e-b3b6-48a1-98a7-92e882e7f357; Thu, 18 Jul 2024 19:37:54 +0000 (UTC)
X-Farcaster-Flow-ID: aab5836e-b3b6-48a1-98a7-92e882e7f357
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 18 Jul 2024 19:37:54 +0000
Received: from u94b036d6357a55.ant.amazon.com (10.106.82.17) by
 EX19D018EUA002.ant.amazon.com (10.252.50.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 18 Jul 2024 19:37:51 +0000
From: Ilias Stamatis <ilstam@amazon.com>
To: <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC: <pdurrant@amazon.co.uk>, <dwmw@amazon.co.uk>, <nh-open-source@amazon.com>,
	Ilias Stamatis <ilstam@amazon.com>
Subject: [PATCH v2 3/6] KVM: Support poll() on coalesced mmio buffer fds
Date: Thu, 18 Jul 2024 20:35:40 +0100
Message-ID: <20240718193543.624039-4-ilstam@amazon.com>
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

v1->v2:
  - Added a NULL-check for dev->ring in coalesced_mmio_buffer_poll()

 virt/kvm/coalesced_mmio.c | 22 ++++++++++++++++++++++
 virt/kvm/coalesced_mmio.h |  1 +
 2 files changed, 23 insertions(+)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 6443d4b62548..64428b0a4aad 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/kvm.h>
 #include <linux/anon_inodes.h>
+#include <linux/poll.h>
 
 #include "coalesced_mmio.h"
 
@@ -98,6 +99,10 @@ static int coalesced_mmio_write(struct kvm_vcpu *vcpu,
 	smp_wmb();
 	ring->last = (insert + 1) % KVM_COALESCED_MMIO_MAX;
 	spin_unlock(lock);
+
+	if (dev->buffer_dev)
+		wake_up_interruptible(&dev->buffer_dev->wait_queue);
+
 	return 0;
 }
 
@@ -224,9 +229,25 @@ static int coalesced_mmio_buffer_release(struct inode *inode, struct file *file)
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
+		mask = POLLIN | POLLRDNORM;
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
@@ -240,6 +261,7 @@ int kvm_vm_ioctl_create_coalesced_mmio_buffer(struct kvm *kvm)
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


