Return-Path: <kvm+bounces-21287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 452FA92CDA1
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 10:57:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68D8C1C224CD
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 08:57:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2707317D348;
	Wed, 10 Jul 2024 08:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="mby4iCOD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DA21662FB
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 08:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720601778; cv=none; b=bgCB8kTdFZEgcKOc74Oyh+ATBZsXDctSj/VcUEL8cmDZreJj+KrrQSJlCT0AiS6QydoSA0GbCO2lrNd66iP22pWQULjaoLpaStKu00oQsStuGKm1I4MIcM+M8zRWRMXgFeI15SVHgyS1GQ3KQ5+g0g+NXSZwOzFtXDRNlKSpNV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720601778; c=relaxed/simple;
	bh=ZjeDvDObxXH1b1bA/g41/b+MiCmdmansuuiRTh6MWnQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YZWhBGSF85+fd58UJjyyxViE+LVsmlLGoFUR7TcG3DfzAQMK5lZxeyDyRD6rgS7SRWxoD9p9h+FOgWzN9prUEMsFk5GWdSNbIOZuPQErcWvGt6QJd8PFTyuyeo4fZfciGisUiNiVwWh7H0X3NwXiVT1V7pp+cJ6xTXQBSI4XV38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=mby4iCOD; arc=none smtp.client-ip=99.78.197.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1720601776; x=1752137776;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h2un9lSjiEuBtfp02pKJ13FNhmDbUr4oVeo65jVHVM4=;
  b=mby4iCODZz60w5XcoH2EsiZuDW5Z2mRDBA8JTd2et3n++zsYahxhi1V1
   KtwQ/26dVe+zUq4+njCzCOFpWjpDJK1Ps4R1o7pEnRUsk9on0p57jiFBO
   AdfUPqNSwzYuyuy3XC10qlVvx0UbU4IG0UIFwJSWDHOrd2wANjcKUoCTu
   E=;
X-IronPort-AV: E=Sophos;i="6.09,197,1716249600"; 
   d="scan'208";a="104039809"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2024 08:56:16 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.17.79:53606]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.10.84:2525] with esmtp (Farcaster)
 id 5cb3eb48-0fbb-420d-a325-8846768b3211; Wed, 10 Jul 2024 08:56:15 +0000 (UTC)
X-Farcaster-Flow-ID: 5cb3eb48-0fbb-420d-a325-8846768b3211
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 10 Jul 2024 08:56:15 +0000
Received: from u94b036d6357a55.ant.amazon.com (10.106.83.14) by
 EX19D018EUA002.ant.amazon.com (10.252.50.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 10 Jul 2024 08:56:10 +0000
From: Ilias Stamatis <ilstam@amazon.com>
To: <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC: <pdurrant@amazon.co.uk>, <dwmw@amazon.co.uk>, <Laurent.Vivier@bull.net>,
	<ghaskins@novell.com>, <avi@redhat.com>, <mst@redhat.com>,
	<levinsasha928@gmail.com>, <peng.hao2@zte.com.cn>,
	<nh-open-source@amazon.com>
Subject: [PATCH 3/6] KVM: Support poll() on coalesced mmio buffer fds
Date: Wed, 10 Jul 2024 09:52:56 +0100
Message-ID: <20240710085259.2125131-4-ilstam@amazon.com>
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
 virt/kvm/coalesced_mmio.c | 20 ++++++++++++++++++++
 virt/kvm/coalesced_mmio.h |  1 +
 2 files changed, 21 insertions(+)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 6443d4b62548..00439e035d74 100644
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
 
@@ -224,9 +229,23 @@ static int coalesced_mmio_buffer_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static __poll_t coalesced_mmio_buffer_poll(struct file *file, struct poll_table_struct *wait)
+{
+	struct kvm_coalesced_mmio_buffer_dev *dev = file->private_data;
+	__poll_t mask = 0;
+
+	poll_wait(file, &dev->wait_queue, wait);
+
+	if (READ_ONCE(dev->ring->first) != READ_ONCE(dev->ring->last))
+		mask = POLLIN | POLLRDNORM;
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
@@ -240,6 +259,7 @@ int kvm_vm_ioctl_create_coalesced_mmio_buffer(struct kvm *kvm)
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


