Return-Path: <kvm+bounces-14067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 47EC989E8F4
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 06:35:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B3C71C22C89
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 04:35:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EC2715E90;
	Wed, 10 Apr 2024 04:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bnTf2kRK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E922A28F0
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 04:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712723728; cv=none; b=cfVCh6SxalOBmWWQNgSvA+gOw3Dj+KK1xGkGlxYFFThW1o1t/H6pPVDg1GR4uWy0LlwiaKrvj8vWo29mdtN7EkTt2179TnXAjNDVvVnK73vVrub/WFSUyw7z6dPDyXJAR0ps4MEh2Cpe8m4qsRSGvBZVZZWSHY73zo3vTOwyTzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712723728; c=relaxed/simple;
	bh=sDnn+yYCBm7ElRQy1ycc5UvcLwyRTYy3YNE8uqqDjiU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OggRC/0Im00pCmLgxnJAmyAB+c9XMNc/BqtE44/Dy2SYyMrhJrhPOrMHuDb6wC8Wai5BNw4qrec+cGbsZ1DPN6eqscdIqK63q948FywtPDGisvCWcrHJd5/ioVVV1SYehAy4zQI1lCK+s+zr71kPrCyb8YJKUIDXm5qpj0w2lXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bnTf2kRK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712723726;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5YBPkm0MVsrY4P8NrGpgwej+RiZZMRPoIxqpdijnhXw=;
	b=bnTf2kRKTANn4Bx0A2699I7kpIQMo9EOBWDtHkShsZVNSWZkzInMPnST6+nHmjFOdI1UKS
	C1DsA4aAxeirPLQ3x0p67VSbJSlJHp9gQp7MF+cFhxVXjNRMEI0xaP6rVn7vFsW845a/Px
	N4pyfGGdLCoXMnusa0jpDzrs3S0Wfp4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-588-X0r9GjBfMNO4VACzome34A-1; Wed,
 10 Apr 2024 00:35:22 -0400
X-MC-Unique: X0r9GjBfMNO4VACzome34A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60CDF3C025C3;
	Wed, 10 Apr 2024 04:35:22 +0000 (UTC)
Received: from server.redhat.com (unknown [10.72.112.217])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6BF15490F9;
	Wed, 10 Apr 2024 04:35:19 +0000 (UTC)
From: Cindy Lu <lulu@redhat.com>
To: lulu@redhat.com,
	mst@redhat.com,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] virtio-pci: Fix the crash that the vector was used after released.
Date: Wed, 10 Apr 2024 12:33:15 +0800
Message-ID: <20240410043450.416752-2-lulu@redhat.com>
In-Reply-To: <20240410043450.416752-1-lulu@redhat.com>
References: <20240410043450.416752-1-lulu@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

When the guest triggers vhost_stop and then virtio_reset, the vector will the
IRQFD for this vector will be released and change to VIRTIO_NO_VECTOR.
After that, the guest called vhost_net_start,  (at this time, the configure
vector is still VIRTIO_NO_VECTOR),  vector 0 still was not "init".
The guest system continued to boot, set the vector back to 0, and then met the crash.

To fix this, we need to call the function "kvm_virtio_pci_vector_use_one()"
when the vector changes back from VIRTIO_NO_VECTOR

(gdb) bt
0  __pthread_kill_implementation (threadid=<optimized out>, signo=signo@entry=6, no_tid=no_tid@entry=0)
    at pthread_kill.c:44
1  0x00007fc87148ec53 in __pthread_kill_internal (signo=6, threadid=<optimized out>) at pthread_kill.c:78
2  0x00007fc87143e956 in __GI_raise (sig=sig@entry=6) at ../sysdeps/posix/raise.c:26
3  0x00007fc8714287f4 in __GI_abort () at abort.c:79
4  0x00007fc87142871b in __assert_fail_base
    (fmt=0x7fc8715bbde0 "%s%s%s:%u: %s%sAssertion `%s' failed.\n%n", assertion=0x5606413efd53 "ret == 0", file=0x5606413ef87d "../accel/kvm/kvm-all.c", line=1837, function=<optimized out>) at assert.c:92
5  0x00007fc871437536 in __GI___assert_fail
    (assertion=0x5606413efd53 "ret == 0", file=0x5606413ef87d "../accel/kvm/kvm-all.c", line=1837, function=0x5606413f06f0 <__PRETTY_FUNCTION__.19> "kvm_irqchip_commit_routes") at assert.c:101
6  0x0000560640f884b5 in kvm_irqchip_commit_routes (s=0x560642cae1f0) at ../accel/kvm/kvm-all.c:1837
7  0x0000560640c98f8e in virtio_pci_one_vector_unmask
    (proxy=0x560643c65f00, queue_no=4294967295, vector=0, msg=..., n=0x560643c6e4c8)
    at ../hw/virtio/virtio-pci.c:1005
8  0x0000560640c99201 in virtio_pci_vector_unmask (dev=0x560643c65f00, vector=0, msg=...)
    at ../hw/virtio/virtio-pci.c:1070
9  0x0000560640bc402e in msix_fire_vector_notifier (dev=0x560643c65f00, vector=0, is_masked=false)
    at ../hw/pci/msix.c:120
10 0x0000560640bc40f1 in msix_handle_mask_update (dev=0x560643c65f00, vector=0, was_masked=true)
    at ../hw/pci/msix.c:140
11 0x0000560640bc4503 in msix_table_mmio_write (opaque=0x560643c65f00, addr=12, val=0, size=4)
    at ../hw/pci/msix.c:231
12 0x0000560640f26d83 in memory_region_write_accessor
    (mr=0x560643c66540, addr=12, value=0x7fc86b7bc628, size=4, shift=0, mask=4294967295, attrs=...)
    at ../system/memory.c:497
13 0x0000560640f270a6 in access_with_adjusted_size

     (addr=12, value=0x7fc86b7bc628, size=4, access_size_min=1, access_size_max=4, access_fn=0x560640f26c8d <memory_region_write_accessor>, mr=0x560643c66540, attrs=...) at ../system/memory.c:573
14 0x0000560640f2a2b5 in memory_region_dispatch_write (mr=0x560643c66540, addr=12, data=0, op=MO_32, attrs=...)
    at ../system/memory.c:1521
15 0x0000560640f37bac in flatview_write_continue
    (fv=0x7fc65805e0b0, addr=4273803276, attrs=..., ptr=0x7fc871e9c028, len=4, addr1=12, l=4, mr=0x560643c66540)
    at ../system/physmem.c:2714
16 0x0000560640f37d0f in flatview_write
    (fv=0x7fc65805e0b0, addr=4273803276, attrs=..., buf=0x7fc871e9c028, len=4) at ../system/physmem.c:2756
17 0x0000560640f380bf in address_space_write
    (as=0x560642161ae0 <address_space_memory>, addr=4273803276, attrs=..., buf=0x7fc871e9c028, len=4)
    at ../system/physmem.c:2863
18 0x0000560640f3812c in address_space_rw
    (as=0x560642161ae0 <address_space_memory>, addr=4273803276, attrs=..., buf=0x7fc871e9c028, len=4, is_write=true) at ../system/physmem.c:2873
--Type <RET> for more, q to quit, c to continue without paging--
19 0x0000560640f8aa55 in kvm_cpu_exec (cpu=0x560642f205e0) at ../accel/kvm/kvm-all.c:2915
20 0x0000560640f8d731 in kvm_vcpu_thread_fn (arg=0x560642f205e0) at ../accel/kvm/kvm-accel-ops.c:51
21 0x00005606411949f4 in qemu_thread_start (args=0x560642f292b0) at ../util/qemu-thread-posix.c:541
22 0x00007fc87148cdcd in start_thread (arg=<optimized out>) at pthread_create.c:442
23 0x00007fc871512630 in clone3 () at ../sysdeps/unix/sysv/linux/x86_64/clone3.S:81
(gdb)
Signed-off-by: Cindy Lu <lulu@redhat.com>
---
 hw/virtio/virtio-pci.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
index 1a7039fb0c..344f4fb844 100644
--- a/hw/virtio/virtio-pci.c
+++ b/hw/virtio/virtio-pci.c
@@ -880,6 +880,7 @@ static int kvm_virtio_pci_vector_use_one(VirtIOPCIProxy *proxy, int queue_no)
     int ret;
     EventNotifier *n;
     PCIDevice *dev = &proxy->pci_dev;
+    VirtIOIRQFD *irqfd;
     VirtIODevice *vdev = virtio_bus_get_device(&proxy->bus);
     VirtioDeviceClass *k = VIRTIO_DEVICE_GET_CLASS(vdev);
 
@@ -890,10 +891,19 @@ static int kvm_virtio_pci_vector_use_one(VirtIOPCIProxy *proxy, int queue_no)
     if (vector >= msix_nr_vectors_allocated(dev)) {
         return 0;
     }
+    /*
+     * if the irqfd still in use, means the irqfd was not
+     * release before and don't need to set up
+     */
+    irqfd = &proxy->vector_irqfd[vector];
+    if (irqfd->users != 0) {
+        return 0;
+    }
     ret = kvm_virtio_pci_vq_vector_use(proxy, vector);
     if (ret < 0) {
         goto undo;
     }
+
     /*
      * If guest supports masking, set up irqfd now.
      * Otherwise, delay until unmasked in the frontend.
@@ -1570,7 +1580,19 @@ static void virtio_pci_common_write(void *opaque, hwaddr addr,
         } else {
             val = VIRTIO_NO_VECTOR;
         }
+        vector = vdev->config_vector;
         vdev->config_vector = val;
+        /*
+         *if the val was change from NO_VECTOR, this means the vector maybe
+         * release before, need to check if need to set up
+         */
+        if ((val != VIRTIO_NO_VECTOR) && (vector == VIRTIO_NO_VECTOR) &&
+            (vdev->status & VIRTIO_CONFIG_S_DRIVER_OK)) {
+            /* check if use irqfd*/
+            if (msix_enabled(&proxy->pci_dev) && kvm_msi_via_irqfd_enabled()) {
+                kvm_virtio_pci_vector_use_one(proxy, VIRTIO_CONFIG_IRQ_IDX);
+            }
+        }
         break;
     case VIRTIO_PCI_COMMON_STATUS:
         if (!(val & VIRTIO_CONFIG_S_DRIVER_OK)) {
@@ -1611,6 +1633,19 @@ static void virtio_pci_common_write(void *opaque, hwaddr addr,
             val = VIRTIO_NO_VECTOR;
         }
         virtio_queue_set_vector(vdev, vdev->queue_sel, val);
+
+        /*
+         *if the val was change from NO_VECTOR, this means the vector maybe
+         * release before, need to check if need to set up
+         */
+
+        if ((val != VIRTIO_NO_VECTOR) && (vector == VIRTIO_NO_VECTOR) &&
+            (vdev->status & VIRTIO_CONFIG_S_DRIVER_OK)) {
+            /* check if use irqfd*/
+            if (msix_enabled(&proxy->pci_dev) && kvm_msi_via_irqfd_enabled()) {
+                kvm_virtio_pci_vector_use_one(proxy, vdev->queue_sel);
+            }
+        }
         break;
     case VIRTIO_PCI_COMMON_Q_ENABLE:
         if (val == 1) {
-- 
2.43.0


