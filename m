Return-Path: <kvm+bounces-66720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 93473CE4836
	for <lists+kvm@lfdr.de>; Sun, 28 Dec 2025 02:55:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 86A063003FE5
	for <lists+kvm@lfdr.de>; Sun, 28 Dec 2025 01:55:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 665EE1C8616;
	Sun, 28 Dec 2025 01:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WmcIDuZU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBBB1548C
	for <kvm@vger.kernel.org>; Sun, 28 Dec 2025 01:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766886915; cv=none; b=DgGu3qJ1rbvcmsVgVAK4gaCz71ywRzY5Weop+0jKLMUx9kUwAQvA2P2PtHZXgSk17dvI/Eg2GZ0NHcjP9JXi2EGO194uWDRo80D5bvzpXnxdPpXN0hBTvADLc5pwEFEYy48AaIYCUUaCEz5q5gnaMcqqYDNk9MjuzoWVhoIYidI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766886915; c=relaxed/simple;
	bh=byoo8KNevI6VM5DBfXOAwWxnyC3dBzmmOVFle2gnDWc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NreOECZ1DoZoVCkByLIO9Ef1mjY8WX8TdtypbsrC6mapw0uJJtCojtity1ZanDQEiT5EtyUBAO618GySPru7pszD9O+ADof4fe8o2KCK+Cm6v6eysPaYzKktqM5kQ2qLfr9ocWJ6yssOj/AuOspA3n6XR1u9yzzuqkRu2m1j9Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WmcIDuZU; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a0bb2f093aso82093885ad.3
        for <kvm@vger.kernel.org>; Sat, 27 Dec 2025 17:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766886913; x=1767491713; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IDMN2QsI+iRtzRqt0/x2AOTqf/i/U7jFS23RvqcAqqY=;
        b=WmcIDuZUDbdw9rV119cqC8mVP80ssY5h5W3jnOcd/IR5RPwAYFl6qsNsaQ4uxM3rgu
         P65akgTxEZ11zh+VIhtklCU1dM2rnlHrF3S6LkMJMjgSQCGCU1XBAW7T3HEDhSUloETN
         r4Cu217WXj0AWDMjUTtBxsl8ZXaNVvQ7neILT46Qls7BYQI3AoyNUKeNHbqKG1X3UdeF
         MKTcT3Lx14B9kxccjjnr0ysg1fLH715Y4Ab/slwxCtyIrVdGtxGPfZl18YTRTnJT58XW
         dymzX6vqe2m141X941o/FZr/sACXo+h8e7+VEPSGDZLRErJe07YR/biJYbhWueVQqaBc
         BZhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766886913; x=1767491713;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IDMN2QsI+iRtzRqt0/x2AOTqf/i/U7jFS23RvqcAqqY=;
        b=FCkEekvlfMh4UUtMxS8B8VGqUqseT/b6uq21XHFsijB5FYAdYe6i7T+RdHKPts3w8o
         1mcYX4NnXLtb+LngXPJ6Bu155cbreTO8my9ZWVHY+eGfyGhqfNY+RAm9IsWomQ1E7FmB
         7THMvvJHn3omdR2CXg96fI0Ah0v+yEaGe+JpnYBp/1Ih6rFIBwz5f0huviFEDF4PpyEf
         HmyoayoOo7JBmqSkMOUct/v6pAuGauuv5t5wBhfI4sQvfCdXsF0mvhJ1gh5BWXpPIpvA
         vocT7lEvG4w4/FXxlJe2Ac3umn5+yAG8xKIWfz3i2RTds2Fu1W0JPikkt92UQP1JwEEX
         ayGg==
X-Forwarded-Encrypted: i=1; AJvYcCVKq+aRdtHAz63lG0pTP0IYeUmZzvmQs6LDRO/M3Ckd9x6LMQah8dc6RgORReLllvMRZOs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyv2htrBt3zeVrCH+CPSmU38gBntymU454YdS+julLUOB0gRPQE
	8KcZXbi+x/zQwQ2AHOkpSzIoNiPbxnV5zETruLxAR9j9cyBzztSX8IxY
X-Gm-Gg: AY/fxX4CWYB++Gx7auYT8rASm2q+KsoE7JqmMFRdEEnrhy4mKN3vyI2OR2GEFwi/mBt
	iyU2n0i5xD9gnZu5DDYJQoBn4p95oKSuVhdc26ACaT3l0SUrhuS+DCqI8eFN4G0R+VoOLVa1Abz
	pDtHfAYjT+63ylPgSECmaYsdXCzbBGTdEMDnsCuS804XzMoiXwGaiMaJz982M1lArTIDQ4/CBAV
	tsEZl0+7+j3ff5cPsUI+v2qC7/qCPOP+nCGpEu/CN6QomxgtHISjAT35DIW4M5jvq945ku0hcrn
	gJc9gvanXl/AZlY6AF7Qt0sl6ufwb53oc/Et7TzFW5GlPGy5zdXmm6Uf0w6fkSj3p5iR3kjCGGg
	5vHmclzyFH7QQ7XPhA87HqN2+LxwEV6NAyEAj+sKXZCXxpLzSTrOOZEiiczwf9y8yy/wa3Haprw
	o8n9ZnCeKjatuZRjBd
X-Google-Smtp-Source: AGHT+IE0nFxVLl5lOzzYbj+9pKcgkYAP+5kPuBKfiZKgvZOWrNF2KYXGcHPj9hI1jbW2+jQFBdTDGA==
X-Received: by 2002:a17:903:298b:b0:2a1:5f23:7ddf with SMTP id d9443c01a7336-2a2f2202fb9mr280224175ad.6.1766886912968;
        Sat, 27 Dec 2025 17:55:12 -0800 (PST)
Received: from pop-os.. ([2601:647:6802:dbc0:70f5:5037:d004:a56e])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c66401sm232967495ad.4.2025.12.27.17.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Dec 2025 17:55:12 -0800 (PST)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: netdev@vger.kernel.org
Cc: virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	Cong Wang <cwang@multikernel.io>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>
Subject: [Patch net] vsock: fix DMA cacheline overlap warning using coherent memory
Date: Sat, 27 Dec 2025 17:54:51 -0800
Message-Id: <20251228015451.1253271-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Cong Wang <cwang@multikernel.io>

The virtio-vsock driver triggers a DMA debug warning during probe:

[    9.267139] ------------[ cut here ]------------
[    9.268694] DMA-API: virtio-pci 0000:08:00.0: cacheline tracking EEXIST, overlapping mappings aren't supported
[    9.271297] WARNING: kernel/dma/debug.c:601 at add_dma_entry+0x220/0x278, CPU#3: swapper/0/1
[    9.273628] CPU: 3 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.19.0-rc1+ #1383 PREEMPT(voluntary)
[    9.276124] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
[    9.278232] RIP: 0010:add_dma_entry+0x223/0x278
[    9.279456] Code: e8 63 ad 30 00 4c 8b 6d 00 48 89 ef e8 d5 6d aa 00 48 89 c6 eb 0a 49 c7 c5 80 55 90 82 4c 89 ee 48 8d 3d 4c 2a 1c 03 4c 89 ea <67> 48 0f b9 3a 48 89 df e8 de f1 ff ff 83 3d 85 e8 19 03 00 74 86
[    9.284284] RSP: 0018:ffff8880077ff6a8 EFLAGS: 00010246
[    9.285541] RAX: ffffffff82c433a0 RBX: ffff888007aed200 RCX: ffffffff81ec0591
[    9.287124] RDX: ffff88800ae7a830 RSI: ffffffff82c433a0 RDI: ffffffff845dc1f0
[    9.288801] RBP: ffff88800b2610c8 R08: 0000000000000007 R09: 0000000000000000
[    9.290407] R10: ffffffff814d2dcf R11: fffffbfff08b6fd4 R12: 1ffff11000effed5
[    9.292111] R13: ffff88800ae7a830 R14: 00000000ffffffef R15: 0000000000000202
[    9.293736] FS:  0000000000000000(0000) GS:ffff8880e7da8000(0000) knlGS:0000000000000000
[    9.295595] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    9.297095] CR2: 0000000000000000 CR3: 0000000003ca0000 CR4: 0000000000350ef0
[    9.298712] Call Trace:
[    9.299229]  <TASK>
[    9.299709]  ? __pfx_add_dma_entry+0x10/0x10
[    9.300729]  ? _raw_spin_unlock_irqrestore+0x2e/0x44
[    9.301786]  ? dma_entry_alloc+0x120/0x131
[    9.302650]  ? debug_dma_map_phys+0xf2/0x118
[    9.303553]  dma_map_phys+0x1b3/0x1c6
[    9.304392]  vring_map_one_sg+0xdf/0x111
[    9.305312]  virtqueue_add_split+0x348/0x767
[    9.306243]  ? __pfx_virtqueue_add_split+0x10/0x10
[    9.307243]  ? lock_acquire.part.0+0xb0/0x1c6
[    9.308246]  ? find_held_lock+0x2b/0x71
[    9.309078]  ? local_clock_noinstr+0x32/0x9c
[    9.310070]  ? local_clock+0x11/0x24
[    9.310915]  ? virtqueue_add+0x3e/0x89
[    9.311881]  virtqueue_add_inbuf+0x73/0x9a
[    9.312840]  ? __pfx_virtqueue_add_inbuf+0x10/0x10
[    9.313968]  ? sg_assign_page+0xd/0x32
[    9.314907]  ? sg_init_one+0x75/0x84
[    9.316025]  virtio_vsock_event_fill_one.isra.0+0x86/0xae
[    9.317236]  ? __pfx_virtio_vsock_event_fill_one.isra.0+0x10/0x10
[    9.318529]  virtio_vsock_vqs_start+0xab/0xf7
[    9.319453]  virtio_vsock_probe.part.0+0x3aa/0x3f0
[    9.320546]  virtio_dev_probe+0x397/0x454
[    9.321431]  ? __pfx_virtio_dev_probe+0x10/0x10
[    9.322382]  ? kernfs_create_link+0xc1/0xec
[    9.323290]  ? kernfs_put+0x19/0x33
[    9.324106]  ? sysfs_do_create_link_sd+0x7a/0xc0
[    9.325104]  really_probe+0x167/0x316
[    9.325932]  ? __pfx___driver_attach+0x10/0x10
[    9.326905]  __driver_probe_device+0x11e/0x155
[    9.327934]  driver_probe_device+0x4a/0xc4
[    9.328828]  __driver_attach+0x129/0x14c
[    9.329832]  bus_for_each_dev+0xd9/0x12b
[    9.330741]  ? __pfx_bus_for_each_dev+0x10/0x10
[    9.331851]  ? __lock_release.isra.0+0xdb/0x193
[    9.332847]  ? bus_add_driver+0xef/0x246
[    9.333700]  bus_add_driver+0x10f/0x246
[    9.334521]  driver_register+0x12c/0x181
[    9.335572]  ? __pfx_virtio_vsock_init+0x10/0x10
[    9.336949]  virtio_vsock_init+0x4f/0x75
[    9.337998]  do_one_initcall+0x15e/0x371
[    9.339056]  ? __pfx_do_one_initcall+0x10/0x10
[    9.340313]  ? parameqn+0x11/0x6b
[    9.341205]  ? poison_kmalloc_redzone+0x44/0x69
[    9.342435]  ? kasan_save_track+0x10/0x29
[    9.343513]  ? rcu_is_watching+0x1c/0x3c
[    9.344696]  ? trace_kmalloc+0x82/0x97
[    9.345733]  ? __kmalloc_noprof+0x41c/0x446
[    9.346888]  ? do_initcalls+0x2c/0x15e
[    9.348064]  do_initcalls+0x131/0x15e
[    9.349051]  kernel_init_freeable+0x250/0x2a2
[    9.350201]  ? __pfx_kernel_init+0x10/0x10
[    9.351285]  kernel_init+0x18/0x136
[    9.352307]  ? __pfx_kernel_init+0x10/0x10
[    9.353383]  ret_from_fork+0x78/0x2e5
[    9.354371]  ? __pfx_ret_from_fork+0x10/0x10
[    9.355501]  ? __switch_to+0x453/0x4c2
[    9.356591]  ? __pfx_kernel_init+0x10/0x10
[    9.357666]  ret_from_fork_asm+0x1a/0x30
[    9.358713]  </TASK>
[    9.359305] irq event stamp: 1580331
[    9.360349] hardirqs last  enabled at (1580341): [<ffffffff813c0bf5>] __up_console_sem+0x53/0x59
[    9.362650] hardirqs last disabled at (1580348): [<ffffffff813c0bda>] __up_console_sem+0x38/0x59
[    9.365096] softirqs last  enabled at (1580150): [<ffffffff812ecf1e>] handle_softirqs+0x46b/0x4bd
[    9.367426] softirqs last disabled at (1580145): [<ffffffff812ecfcb>] __irq_exit_rcu+0x4b/0xc3
[    9.369750] ---[ end trace 0000000000000000 ]---
[    9.370965] DMA-API: Mapped at:
[    9.371885]  dma_entry_alloc+0x115/0x131
[    9.372921]  debug_dma_map_phys+0x4c/0x118
[    9.374014]  dma_map_phys+0x1b3/0x1c6
[    9.375000]  vring_map_one_sg+0xdf/0x111
[    9.376161]  virtqueue_add_split+0x348/0x767

This occurs because event_list[8] contains 8 struct virtio_vsock_event
entries, each only 4 bytes (__le32 id). When virtio_vsock_event_fill()
creates DMA mappings for all 8 events via virtqueue_add_inbuf(), these
32 bytes all fit within a single 64-byte cacheline.

The DMA debug subsystem warns about this because multiple DMA_FROM_DEVICE
mappings within the same cacheline can cause data corruption: if the CPU
writes to one event while the device is writing another event in the same
cacheline, the CPU cache writeback could overwrite device data.

Fix this by allocating the event buffers from DMA coherent memory using
dma_alloc_coherent(). This memory is always coherent between CPU and
device, eliminating the cacheline overlap issue. The premapped virtqueue
API (virtqueue_add_inbuf_premapped) is used to prevent virtio from
performing redundant DMA mapping on the already-coherent memory.

Fixes: 0ea9e1d3a9e3 ("VSOCK: Introduce virtio_transport.ko")
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 net/vmw_vsock/virtio_transport.c | 47 ++++++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 9 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 8c867023a2e5..34606de587c0 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -26,6 +26,8 @@ static struct virtio_vsock __rcu *the_virtio_vsock;
 static DEFINE_MUTEX(the_virtio_vsock_mutex); /* protects the_virtio_vsock */
 static struct virtio_transport virtio_transport; /* forward declaration */
 
+#define VIRTIO_VSOCK_EVENT_BUFS	8
+
 struct virtio_vsock {
 	struct virtio_device *vdev;
 	struct virtqueue *vqs[VSOCK_VQ_MAX];
@@ -59,7 +61,8 @@ struct virtio_vsock {
 	 */
 	struct mutex event_lock;
 	bool event_run;
-	struct virtio_vsock_event event_list[8];
+	struct virtio_vsock_event *event_list;	/* DMA coherent memory */
+	dma_addr_t event_list_dma;
 
 	u32 guest_cid;
 	bool seqpacket_allow;
@@ -381,16 +384,19 @@ static bool virtio_transport_more_replies(struct virtio_vsock *vsock)
 
 /* event_lock must be held */
 static int virtio_vsock_event_fill_one(struct virtio_vsock *vsock,
-				       struct virtio_vsock_event *event)
+				       struct virtio_vsock_event *event,
+				       dma_addr_t dma_addr)
 {
 	struct scatterlist sg;
 	struct virtqueue *vq;
 
 	vq = vsock->vqs[VSOCK_VQ_EVENT];
 
-	sg_init_one(&sg, event, sizeof(*event));
+	sg_init_table(&sg, 1);
+	sg_dma_address(&sg) = dma_addr;
+	sg_dma_len(&sg) = sizeof(*event);
 
-	return virtqueue_add_inbuf(vq, &sg, 1, event, GFP_KERNEL);
+	return virtqueue_add_inbuf_premapped(vq, &sg, 1, event, NULL, GFP_KERNEL);
 }
 
 /* event_lock must be held */
@@ -398,10 +404,12 @@ static void virtio_vsock_event_fill(struct virtio_vsock *vsock)
 {
 	size_t i;
 
-	for (i = 0; i < ARRAY_SIZE(vsock->event_list); i++) {
+	for (i = 0; i < VIRTIO_VSOCK_EVENT_BUFS; i++) {
 		struct virtio_vsock_event *event = &vsock->event_list[i];
+		dma_addr_t dma_addr = vsock->event_list_dma +
+				      i * sizeof(*event);
 
-		virtio_vsock_event_fill_one(vsock, event);
+		virtio_vsock_event_fill_one(vsock, event, dma_addr);
 	}
 
 	virtqueue_kick(vsock->vqs[VSOCK_VQ_EVENT]);
@@ -461,10 +469,14 @@ static void virtio_transport_event_work(struct work_struct *work)
 
 		virtqueue_disable_cb(vq);
 		while ((event = virtqueue_get_buf(vq, &len)) != NULL) {
+			size_t idx = event - vsock->event_list;
+			dma_addr_t dma_addr = vsock->event_list_dma +
+					      idx * sizeof(*event);
+
 			if (len == sizeof(*event))
 				virtio_vsock_event_handle(vsock, event);
 
-			virtio_vsock_event_fill_one(vsock, event);
+			virtio_vsock_event_fill_one(vsock, event, dma_addr);
 		}
 	} while (!virtqueue_enable_cb(vq));
 
@@ -796,6 +808,15 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 
 	vsock->vdev = vdev;
 
+	vsock->event_list = dma_alloc_coherent(vdev->dev.parent,
+					       VIRTIO_VSOCK_EVENT_BUFS *
+					       sizeof(*vsock->event_list),
+					       &vsock->event_list_dma,
+					       GFP_KERNEL);
+	if (!vsock->event_list) {
+		ret = -ENOMEM;
+		goto out_free_vsock;
+	}
 
 	mutex_init(&vsock->tx_lock);
 	mutex_init(&vsock->rx_lock);
@@ -813,7 +834,7 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 
 	ret = virtio_vsock_vqs_init(vsock);
 	if (ret < 0)
-		goto out;
+		goto out_free_event_list;
 
 	for (i = 0; i < ARRAY_SIZE(vsock->out_sgs); i++)
 		vsock->out_sgs[i] = &vsock->out_bufs[i];
@@ -825,8 +846,13 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 
 	return 0;
 
-out:
+out_free_event_list:
+	dma_free_coherent(vdev->dev.parent,
+			  VIRTIO_VSOCK_EVENT_BUFS * sizeof(*vsock->event_list),
+			  vsock->event_list, vsock->event_list_dma);
+out_free_vsock:
 	kfree(vsock);
+out:
 	mutex_unlock(&the_virtio_vsock_mutex);
 	return ret;
 }
@@ -853,6 +879,9 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
 
 	mutex_unlock(&the_virtio_vsock_mutex);
 
+	dma_free_coherent(vdev->dev.parent,
+			  VIRTIO_VSOCK_EVENT_BUFS * sizeof(*vsock->event_list),
+			  vsock->event_list, vsock->event_list_dma);
 	kfree(vsock);
 }
 
-- 
2.34.1


