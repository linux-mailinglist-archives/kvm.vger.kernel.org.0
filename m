Return-Path: <kvm+bounces-53834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4478B18214
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 15:03:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E36D627DEC
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 13:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B14F624728A;
	Fri,  1 Aug 2025 13:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EBOC5j/I"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC3A1798F
	for <kvm@vger.kernel.org>; Fri,  1 Aug 2025 13:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754053421; cv=none; b=TbQvlqZq7q4HCa//E76b6lsQQbLB8FBOKy5E8+ytr7aZKMM0emnTtsrHO1DSuPnuo4UWs3FcqsN0wvCr4PwMpNE34+WSiCCdFN3O4l3Sz8I3tkgZehaM+M8G2QyflfZxtKOH8ei/JQP9IoEGmppMx05G9SHSRc9znB4cpCxe/2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754053421; c=relaxed/simple;
	bh=LGAFsaZhZE9+YVDjSQvh4z1jMFg+F2jCvZkkxWqWe4E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cnQ/iGYBPb8ufdsWd0U80wPmU37rASPh7csaj44VGiC9/gcGZxpTU0QPV0z7AdvtT9NDXqemdRWo14RrAmmieGZsLKcbVmz2lTb4gFSBlMFiI3Hi21aQnzTzQhoKVSZTX97Zo7kqNaMpyvgWps5v58xYFCugz5tVomNT50S1WP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EBOC5j/I; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754053419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wRQvRY1Ic3xqYJoWjzoX1AeSxDMgzF+1WipYbCuWjwo=;
	b=EBOC5j/I6YIV0+ey76MP0svdOAiMYfZqh+YnSZh1BIXV1qn5H0KivhklrQvtMPZ4AqggHY
	ZaKfiE2GbSk1UufBxz6h4mTZifEwaYpvOY9lkD7pAl6sbhFIdSMwddxFNgH0M0hOnphZSq
	mX00aohxkbCne8sKk4ILHmUF6eD5Mvs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-c3GGB3_aMc-6o5anH1dUNA-1; Fri, 01 Aug 2025 09:03:37 -0400
X-MC-Unique: c3GGB3_aMc-6o5anH1dUNA-1
X-Mimecast-MFC-AGG-ID: c3GGB3_aMc-6o5anH1dUNA_1754053417
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-458a321153dso4204055e9.0
        for <kvm@vger.kernel.org>; Fri, 01 Aug 2025 06:03:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754053417; x=1754658217;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wRQvRY1Ic3xqYJoWjzoX1AeSxDMgzF+1WipYbCuWjwo=;
        b=vO8O0nlMW73MP4OJzahTMNKGqi1fZ1XvnlQBYE08m9rYG7wwbkCkA45JvSC1gpBsN+
         tZyEpnlXy4JmZtKeaZNwjoot/7aZLhdXgz1TesfeIaNwGqmVpoVHOFjslIIwHrjJtxJp
         VxLSSzdpkKTJ1GSnOW5IHnCxzF9752AWCNgEW5nJWRcKUk4XihiN3GsWDyaB4kf9d2BA
         rjslqto7JA7tbTd4FEgJI3EQFWgmy/racNu2ZOSYlW3AND+0ax9H+S9beA7IV7LzLmiD
         ZzSUMR1NTcn/OPFZVxw/TTUCgi4Lk8HyNIj+bq2K0z8IqhlCrvkzsGcIDF2YW66qZZDI
         Wm5w==
X-Gm-Message-State: AOJu0Yylxxyqisywmpw4+Sq1ID2t96bckdwWCG61zIO2ROWtn4y433dR
	O2n4hDwXfLdO869rzT3xAbnxxxrJkTiuc1HLuIFJp7ZU592yJKY2ZO4D27FYZCe7Qs1Pw9/rJm6
	suT3WmQehRqpeIpkG6UeatVb42jAnLL1W9zCem32onloPhp62ouSd8A==
X-Gm-Gg: ASbGnctpDnhao7kS19ZgLgvnP79MH8ZayGW6F6L5Dr+VPy6m1Zgoc66MUlx3xUo2IO1
	34DoIR9ugXlWNoxyxXrnwN2KECFKvB7rfFmuKEmwmjgv4ejnAFhvBAn7Hs5Rvs502SewB+xD5iE
	NDWkgQOSf4gaAndVNWyU9fGCPIWDDKli/8nslO+d9d/FA1f7vkv5AuRKoZIlmT9LxMwZQLSqNlq
	PvO7v/9UkSeTOlNpaUwGWNHxCga8t9185RHtgrgQjx8YJs/SZ6ttppgagPtRToIjYoYF/EpKvJz
	6SEuzPs4jv24VffbHpghHwJjXOsN6Iu8
X-Received: by 2002:a05:6000:2481:b0:3b8:bb8b:6b05 with SMTP id ffacd0b85a97d-3b8bb8b6deemr4345590f8f.29.1754053416402;
        Fri, 01 Aug 2025 06:03:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHjHiezwm6gooBQWulD3psAw7200KYzsNILZaaeqjUjY2ZWI9IK3v40njhdn3wBHktdq15jSA==
X-Received: by 2002:a05:6000:2481:b0:3b8:bb8b:6b05 with SMTP id ffacd0b85a97d-3b8bb8b6deemr4345535f8f.29.1754053415774;
        Fri, 01 Aug 2025 06:03:35 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1515:7300:62e6:253a:2a96:5e3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c45346asm5907298f8f.39.2025.08.01.06.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 06:03:35 -0700 (PDT)
Date: Fri, 1 Aug 2025 09:03:31 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	acourbot@google.com, alok.a.tiwari@oracle.com,
	anders.roxell@linaro.org, dtatulea@nvidia.com, eperezma@redhat.com,
	eric.auger@redhat.com, gnurou@gmail.com, jasowang@redhat.com,
	jonah.palmer@oracle.com, kraxel@redhat.com, leiyang@redhat.com,
	linux@treblig.org, lulu@redhat.com, michael.christie@oracle.com,
	parav@nvidia.com, si-wei.liu@oracle.com, stable@vger.kernel.org,
	viresh.kumar@linaro.org, wangyuli@uniontech.com, will@kernel.org,
	wquan@redhat.com, xiaopei01@kylinos.cn
Subject: Re: [GIT PULL] virtio, vhost: features, fixes
Message-ID: <20250801090250-mutt-send-email-mst@kernel.org>
References: <20250801070032-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250801070032-mutt-send-email-mst@kernel.org>

On Fri, Aug 01, 2025 at 07:00:32AM -0400, Michael S. Tsirkin wrote:
> The following changes since commit 347e9f5043c89695b01e66b3ed111755afcf1911:
> 
>   Linux 6.16-rc6 (2025-07-13 14:25:58 -0700)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
> 
> for you to fetch changes up to c7991b44d7b44f9270dec63acd0b2965d29aab43:
> 
>   vsock/virtio: Allocate nonlinear SKBs for handling large transmit buffers (2025-07-17 08:33:09 -0400)

Oh no I am sorry! Please ignore, a bad commit snuck in there - it still
needs maintainer approval, and I forgot.
Will resend.


> ----------------------------------------------------------------
> virtio, vhost: features, fixes
> 
> vhost can now support legacy threading
> 	if enabled in Kconfig
> vsock memory allocation strategies for
> 	large buffers have been improved,
> 	reducing pressure on kmalloc
> vhost now supports the in-order feature
> 	guest bits missed the merge window
> 
> fixes, cleanups all over the place
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> ----------------------------------------------------------------
> Alexandre Courbot (1):
>       media: add virtio-media driver
> 
> Alok Tiwari (4):
>       virtio: Fix typo in register_virtio_device() doc comment
>       vhost-scsi: Fix typos and formatting in comments and logs
>       vhost: Fix typos
>       vhost-scsi: Fix check for inline_sg_cnt exceeding preallocated limit
> 
> Anders Roxell (1):
>       vdpa: Fix IDR memory leak in VDUSE module exit
> 
> Cindy Lu (1):
>       vhost: Reintroduce kthread API and add mode selection
> 
> Dr. David Alan Gilbert (2):
>       vhost: vringh: Remove unused iotlb functions
>       vhost: vringh: Remove unused functions
> 
> Dragos Tatulea (2):
>       vdpa/mlx5: Fix needs_teardown flag calculation
>       vdpa/mlx5: Fix release of uninitialized resources on error path
> 
> Gerd Hoffmann (1):
>       drm/virtio: implement virtio_gpu_shutdown
> 
> Jason Wang (3):
>       vhost: fail early when __vhost_add_used() fails
>       vhost: basic in order support
>       vhost_net: basic in_order support
> 
> Michael S. Tsirkin (6):
>       virtio: document ENOSPC
>       pci: report surprise removal event
>       virtio: fix comments, readability
>       virtio: pack config changed flags
>       virtio: allow transports to suppress config change
>       virtio: support device disconnect
> 
> Mike Christie (1):
>       vhost-scsi: Fix log flooding with target does not exist errors
> 
> Pei Xiao (1):
>       vhost: Use ERR_CAST inlined function instead of ERR_PTR(PTR_ERR(...))
> 
> Viresh Kumar (2):
>       virtio-mmio: Remove virtqueue list from mmio device
>       virtio-vdpa: Remove virtqueue list
> 
> WangYuli (1):
>       virtio: virtio_dma_buf: fix missing parameter documentation
> 
> Will Deacon (9):
>       vhost/vsock: Avoid allocating arbitrarily-sized SKBs
>       vsock/virtio: Validate length in packet header before skb_put()
>       vsock/virtio: Move length check to callers of virtio_vsock_skb_rx_put()
>       vsock/virtio: Resize receive buffers so that each SKB fits in a 4K page
>       vsock/virtio: Rename virtio_vsock_alloc_skb()
>       vsock/virtio: Move SKB allocation lower-bound check to callers
>       vhost/vsock: Allocate nonlinear SKBs for handling large receive buffers
>       vsock/virtio: Rename virtio_vsock_skb_rx_put()
>       vsock/virtio: Allocate nonlinear SKBs for handling large transmit buffers
> 
>  MAINTAINERS                                |    6 +
>  drivers/gpu/drm/virtio/virtgpu_drv.c       |    8 +-
>  drivers/media/Kconfig                      |   13 +
>  drivers/media/Makefile                     |    2 +
>  drivers/media/virtio/Makefile              |    9 +
>  drivers/media/virtio/protocol.h            |  288 ++++++
>  drivers/media/virtio/scatterlist_builder.c |  563 ++++++++++++
>  drivers/media/virtio/scatterlist_builder.h |  111 +++
>  drivers/media/virtio/session.h             |  109 +++
>  drivers/media/virtio/virtio_media.h        |   93 ++
>  drivers/media/virtio/virtio_media_driver.c |  959 ++++++++++++++++++++
>  drivers/media/virtio/virtio_media_ioctls.c | 1297 ++++++++++++++++++++++++++++
>  drivers/pci/pci.h                          |    6 +
>  drivers/vdpa/mlx5/core/mr.c                |    3 +
>  drivers/vdpa/mlx5/net/mlx5_vnet.c          |   12 +-
>  drivers/vdpa/vdpa_user/vduse_dev.c         |    1 +
>  drivers/vhost/Kconfig                      |   18 +
>  drivers/vhost/net.c                        |   88 +-
>  drivers/vhost/scsi.c                       |   24 +-
>  drivers/vhost/vhost.c                      |  377 +++++++-
>  drivers/vhost/vhost.h                      |   30 +-
>  drivers/vhost/vringh.c                     |  118 ---
>  drivers/vhost/vsock.c                      |   15 +-
>  drivers/virtio/virtio.c                    |   25 +-
>  drivers/virtio/virtio_dma_buf.c            |    2 +
>  drivers/virtio/virtio_mmio.c               |   52 +-
>  drivers/virtio/virtio_pci_common.c         |   45 +
>  drivers/virtio/virtio_pci_common.h         |    3 +
>  drivers/virtio/virtio_pci_legacy.c         |    2 +
>  drivers/virtio/virtio_pci_modern.c         |    2 +
>  drivers/virtio/virtio_ring.c               |    4 +
>  drivers/virtio/virtio_vdpa.c               |   44 +-
>  include/linux/pci.h                        |   45 +
>  include/linux/virtio.h                     |   13 +-
>  include/linux/virtio_config.h              |   32 +
>  include/linux/virtio_vsock.h               |   46 +-
>  include/linux/vringh.h                     |   12 -
>  include/uapi/linux/vhost.h                 |   29 +
>  include/uapi/linux/virtio_ids.h            |    1 +
>  kernel/vhost_task.c                        |    2 +-
>  net/vmw_vsock/virtio_transport.c           |   20 +-
>  net/vmw_vsock/virtio_transport_common.c    |    3 +-
>  42 files changed, 4186 insertions(+), 346 deletions(-)
>  create mode 100644 drivers/media/virtio/Makefile
>  create mode 100644 drivers/media/virtio/protocol.h
>  create mode 100644 drivers/media/virtio/scatterlist_builder.c
>  create mode 100644 drivers/media/virtio/scatterlist_builder.h
>  create mode 100644 drivers/media/virtio/session.h
>  create mode 100644 drivers/media/virtio/virtio_media.h
>  create mode 100644 drivers/media/virtio/virtio_media_driver.c
>  create mode 100644 drivers/media/virtio/virtio_media_ioctls.c


