Return-Path: <kvm+bounces-53836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 43BEAB18234
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 15:13:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65C2E3AB230
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 13:13:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A7C024FC09;
	Fri,  1 Aug 2025 13:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CKzIlzyd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A39322069E
	for <kvm@vger.kernel.org>; Fri,  1 Aug 2025 13:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754054008; cv=none; b=LncXw8iOhj9UynzIv8Ktyj/4OAP9gDw7eKpfJ1WMOe5St4uORX1gOKXaBplE/A3221xFFrJ7xIxjosnjiFXa9FIkJ34qzSRFIj/R89iOaRFMofJWkVQlVi0LsOQnfIpMPLbb/RR8WuvnoRx+U17eRATooTp0m1WTvOfGXXTK0o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754054008; c=relaxed/simple;
	bh=NDqaf9lbxEaRm64yxxyEsy03EPkdWuBKt9nEAdu2dVk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=KjOYmPDYhihh/ClTU19FBzNK8BVKxKU3WhgBhJJfoo3Fnbbhwn3WwxTCFyiwrSVeTV7gzXG68/CIVUu8C6Ilt4zhxGO7Zf1VbpUcX0IAp0FSkqX6zjwMD6v0AeVMf1iN+yD11utCs4+r9sJfElTz4/XU/QnYxHhzaoiIwxRRwG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CKzIlzyd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754054005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=cw5+teQN0AMP87x3H2Uh+QGhf4VtRQnjJ3fqJ5dQbO0=;
	b=CKzIlzydDaqyGStAMOLNKWdg7Q3+r/Qgi557YRSG4edyDuZD7XWoj8n9kRUIqCXnVUq+k+
	+WoqporQN9E/WVUVkDCsxc+1aL9PVsKPRU1R8ROkZaC8EdLXR4zvAKuYwqHOFfN788EDgT
	VzroxEmqiuNp7O6tLpoI5z+/vwTAEFc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-FseKkM4HNXWWNjML-OG4ZQ-1; Fri, 01 Aug 2025 09:13:24 -0400
X-MC-Unique: FseKkM4HNXWWNjML-OG4ZQ-1
X-Mimecast-MFC-AGG-ID: FseKkM4HNXWWNjML-OG4ZQ_1754054004
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b7892c42b7so545533f8f.0
        for <kvm@vger.kernel.org>; Fri, 01 Aug 2025 06:13:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754054002; x=1754658802;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cw5+teQN0AMP87x3H2Uh+QGhf4VtRQnjJ3fqJ5dQbO0=;
        b=tuyy+p8cC7wxXtRZMKxzzP5+XRN9MSbb5prWmPUWVfmI78+EftZKo3l1dxXg4RBEg1
         SxYHAAjiIPcV57FyT6WnM2T4BWmJE/GqlNVXb4pGrXIquLxQQn/WelvD0PBiLxlawybZ
         iYZS66jnoFvJEA5idvGoQfMoT1tFt4buFgSQE+BuNhdbJqmrRZKBlPViXt48MXNU5rRM
         dl8l10t9zbEFdl6yZV1Nu9nRktncWVYJFIn7sqad15zr6AKv/YTaNamFT0SYtKisUoiO
         kYgm4EnO8lbBk8EOSlqsYHKlDBz6zUTUVCgdOIfZ6w3hJSOZUKw2nWW45wnL0NGua/6W
         5vDw==
X-Gm-Message-State: AOJu0Yw5ra+37v0rshEWgx+gmzsdH8/Q61FiDKtBwU7i0GrN751GRQuw
	/SRCRbSf0VP6NFVfTUXbZn64Zh3H3VpH6vKbFn7rcbkuJtBQeClXTaez9wzjWIaJo/1W1jTlp96
	DpkgA493MZPCfhtGo+fobJgWKY5r4gCI1/0VdduTHI1nN2R1IY5QkwQ==
X-Gm-Gg: ASbGnctRDASbcqMB4sANhUk3jGjBvEAsij9t+G41cTU2oHvrfJEncxg4cnAhT/iNJ2l
	cOFoPCAlbVrwya4deIA3xkm8zC+61ifb2D3EydjLtYi3YYlxykTf7CGYxT/1N+/jxMTIAz0zwWX
	nLoqpu3ckFB1UV6gUDRGSF2Ui1s/fbIbIoi9GP4cjK06mNqXExaXN2Lnth+DOXrJ1jKQfANhVnN
	Sd/20SrfHh043PpedtvtFetUgrRxKcxgDa6mOBg9wt+Oq67vtzzkayzh5HkUT3tT+l0KBG1Y75i
	LIwgOyH/gANg3HXuQfc6mAUEHyVIYuwH
X-Received: by 2002:a05:6000:2311:b0:3b7:81a6:45c1 with SMTP id ffacd0b85a97d-3b794fc2b76mr8552819f8f.6.1754054002369;
        Fri, 01 Aug 2025 06:13:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGJ3kgk/LB9Em5/+L4oKnLTGpba8hhaIHh5AL+aBInP59wFrNOjQfBJh5ZGXhgf1vfWGUgM8w==
X-Received: by 2002:a05:6000:2311:b0:3b7:81a6:45c1 with SMTP id ffacd0b85a97d-3b794fc2b76mr8552779f8f.6.1754054001893;
        Fri, 01 Aug 2025 06:13:21 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1515:7300:62e6:253a:2a96:5e3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c48de68sm5859929f8f.67.2025.08.01.06.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 06:13:21 -0700 (PDT)
Date: Fri, 1 Aug 2025 09:13:18 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	alok.a.tiwari@oracle.com, anders.roxell@linaro.org,
	dtatulea@nvidia.com, eperezma@redhat.com, eric.auger@redhat.com,
	jasowang@redhat.com, jonah.palmer@oracle.com, kraxel@redhat.com,
	leiyang@redhat.com, linux@treblig.org, lulu@redhat.com,
	michael.christie@oracle.com, mst@redhat.com, parav@nvidia.com,
	si-wei.liu@oracle.com, stable@vger.kernel.org,
	viresh.kumar@linaro.org, wangyuli@uniontech.com, will@kernel.org,
	wquan@redhat.com, xiaopei01@kylinos.cn
Subject: [GIT PULL v2] virtio, vhost: features, fixes
Message-ID: <20250801091318-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent

The following changes since commit 347e9f5043c89695b01e66b3ed111755afcf1911:

  Linux 6.16-rc6 (2025-07-13 14:25:58 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 6693731487a8145a9b039bc983d77edc47693855:

  vsock/virtio: Allocate nonlinear SKBs for handling large transmit buffers (2025-08-01 09:11:09 -0400)

Changes from v1:
	drop commits that I put in there by mistake. Sorry!

----------------------------------------------------------------
virtio, vhost: features, fixes

vhost can now support legacy threading
	if enabled in Kconfig
vsock memory allocation strategies for
	large buffers have been improved,
	reducing pressure on kmalloc
vhost now supports the in-order feature
	guest bits missed the merge window

fixes, cleanups all over the place

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Alok Tiwari (4):
      virtio: Fix typo in register_virtio_device() doc comment
      vhost-scsi: Fix typos and formatting in comments and logs
      vhost: Fix typos
      vhost-scsi: Fix check for inline_sg_cnt exceeding preallocated limit

Anders Roxell (1):
      vdpa: Fix IDR memory leak in VDUSE module exit

Cindy Lu (1):
      vhost: Reintroduce kthread API and add mode selection

Dr. David Alan Gilbert (2):
      vhost: vringh: Remove unused iotlb functions
      vhost: vringh: Remove unused functions

Dragos Tatulea (2):
      vdpa/mlx5: Fix needs_teardown flag calculation
      vdpa/mlx5: Fix release of uninitialized resources on error path

Gerd Hoffmann (1):
      drm/virtio: implement virtio_gpu_shutdown

Jason Wang (3):
      vhost: fail early when __vhost_add_used() fails
      vhost: basic in order support
      vhost_net: basic in_order support

Michael S. Tsirkin (2):
      virtio: fix comments, readability
      virtio: document ENOSPC

Mike Christie (1):
      vhost-scsi: Fix log flooding with target does not exist errors

Pei Xiao (1):
      vhost: Use ERR_CAST inlined function instead of ERR_PTR(PTR_ERR(...))

Viresh Kumar (2):
      virtio-mmio: Remove virtqueue list from mmio device
      virtio-vdpa: Remove virtqueue list

WangYuli (1):
      virtio: virtio_dma_buf: fix missing parameter documentation

Will Deacon (9):
      vhost/vsock: Avoid allocating arbitrarily-sized SKBs
      vsock/virtio: Validate length in packet header before skb_put()
      vsock/virtio: Move length check to callers of virtio_vsock_skb_rx_put()
      vsock/virtio: Resize receive buffers so that each SKB fits in a 4K page
      vsock/virtio: Rename virtio_vsock_alloc_skb()
      vsock/virtio: Move SKB allocation lower-bound check to callers
      vhost/vsock: Allocate nonlinear SKBs for handling large receive buffers
      vsock/virtio: Rename virtio_vsock_skb_rx_put()
      vsock/virtio: Allocate nonlinear SKBs for handling large transmit buffers

 drivers/gpu/drm/virtio/virtgpu_drv.c    |   8 +-
 drivers/vdpa/mlx5/core/mr.c             |   3 +
 drivers/vdpa/mlx5/net/mlx5_vnet.c       |  12 +-
 drivers/vdpa/vdpa_user/vduse_dev.c      |   1 +
 drivers/vhost/Kconfig                   |  18 ++
 drivers/vhost/net.c                     |  88 +++++---
 drivers/vhost/scsi.c                    |  24 +-
 drivers/vhost/vhost.c                   | 377 ++++++++++++++++++++++++++++----
 drivers/vhost/vhost.h                   |  30 ++-
 drivers/vhost/vringh.c                  | 118 ----------
 drivers/vhost/vsock.c                   |  15 +-
 drivers/virtio/virtio.c                 |   7 +-
 drivers/virtio/virtio_dma_buf.c         |   2 +
 drivers/virtio/virtio_mmio.c            |  52 +----
 drivers/virtio/virtio_ring.c            |   4 +
 drivers/virtio/virtio_vdpa.c            |  44 +---
 include/linux/virtio.h                  |   2 +-
 include/linux/virtio_vsock.h            |  46 +++-
 include/linux/vringh.h                  |  12 -
 include/uapi/linux/vhost.h              |  29 +++
 kernel/vhost_task.c                     |   2 +-
 net/vmw_vsock/virtio_transport.c        |  20 +-
 net/vmw_vsock/virtio_transport_common.c |   3 +-
 23 files changed, 575 insertions(+), 342 deletions(-)


