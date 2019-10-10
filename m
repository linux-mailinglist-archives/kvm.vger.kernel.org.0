Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDBCFD2C89
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 16:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbfJJO26 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Oct 2019 10:28:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbfJJO26 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Oct 2019 10:28:58 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5579206B6;
        Thu, 10 Oct 2019 14:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570717737;
        bh=JFPH/A6NZ3j9qzNoCJjMrAN/lWSFEF0+cBX8xEbnPnw=;
        h=From:To:Cc:Subject:Date:From;
        b=bLpTpHbKuY0f3fbqL+b9781T4xlsCwiddWV9OsL5iA9IbyKgg7jYcUySuSV3D/n69
         2YDFa/THxKFyT0ySIEkIkz+6n4U11bNlWo9+qp8hRjKCtiPbapCQg71Ynv2hDd44Hu
         kKYnJ3ZdDKjLS+UfttDpL1KYG/lNpb4ZhNf4tCaI=
From:   Will Deacon <will@kernel.org>
To:     kvm@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH kvmtool] virtio: Ensure virt_queue is always initialised
Date:   Thu, 10 Oct 2019 15:28:52 +0100
Message-Id: <20191010142852.15437-1-will@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Failing to initialise the virt_queue via virtio_init_device_vq() leaves,
amongst other things, the endianness unspecified. On arm/arm64 this
results in virtio_guest_to_host_uxx() treating the queue as big-endian
and trying to translate bogus addresses:

  Warning: unable to translate guest address 0x80b8249800000000 to host

Ensure the virt_queue is always initialised by the virtio device during
setup.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 virtio/balloon.c | 1 +
 virtio/rng.c     | 1 +
 virtio/scsi.c    | 1 +
 3 files changed, 3 insertions(+)

diff --git a/virtio/balloon.c b/virtio/balloon.c
index 15a9a46e77e0..0bd16703dfee 100644
--- a/virtio/balloon.c
+++ b/virtio/balloon.c
@@ -212,6 +212,7 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 
 	thread_pool__init_job(&bdev->jobs[vq], kvm, virtio_bln_do_io, queue);
 	vring_init(&queue->vring, VIRTIO_BLN_QUEUE_SIZE, p, align);
+	virtio_init_device_vq(&bdev->vdev, queue);
 
 	return 0;
 }
diff --git a/virtio/rng.c b/virtio/rng.c
index 9dd757b7e6e9..78eaa64bda17 100644
--- a/virtio/rng.c
+++ b/virtio/rng.c
@@ -103,6 +103,7 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 	job = &rdev->jobs[vq];
 
 	vring_init(&queue->vring, VIRTIO_RNG_QUEUE_SIZE, p, align);
+	virtio_init_device_vq(&rdev->vdev, queue);
 
 	*job = (struct rng_dev_job) {
 		.vq	= queue,
diff --git a/virtio/scsi.c b/virtio/scsi.c
index a72bb2a9a206..1ec78fe0945a 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -72,6 +72,7 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
 	p		= virtio_get_vq(kvm, queue->pfn, page_size);
 
 	vring_init(&queue->vring, VIRTIO_SCSI_QUEUE_SIZE, p, align);
+	virtio_init_device_vq(&sdev->vdev, queue);
 
 	if (sdev->vhost_fd == 0)
 		return 0;
-- 
2.23.0.700.g56cf767bdb-goog

