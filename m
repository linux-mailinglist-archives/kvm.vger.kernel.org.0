Return-Path: <kvm+bounces-53837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E5D3B1825E
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 15:19:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 086A83A7532
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 13:19:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37FA9255F2B;
	Fri,  1 Aug 2025 13:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U4i2HfIo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA6241C72
	for <kvm@vger.kernel.org>; Fri,  1 Aug 2025 13:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754054369; cv=none; b=hjGyRqzy6W0QIEYrsYEDACmsUq1vGaURRwt5CWc7doxnyPWj4A6jce6h5txB+b/6t2rFt01p4Krgk4NlNHvri240007aMNNtm/AmW8HWo+APVKVYkLj1WErfo5W4augM6PeHFbTbabisda+aT1fSBIdtUipsQgIOSjGUHUwSKco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754054369; c=relaxed/simple;
	bh=9NerjbYLuoyk/RKlTefAdXQzfB6NwPQkXItsvzNMysk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rih3ky3DdvuEPVpw2d07QpPDg/r9cObf1ffjcwq913sDS+x/57bwDuqUOWi/B7jKqnBySZfWKW3qdc0f8v4TpyAz+CUdOAdqE21rnngR6mvefsiytw440d1OUCqN/KLrgWNlSw/Zq/R3SmnMjOqFMXhHoL0QUVAahk28Rc9Wgzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U4i2HfIo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754054366;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YbLdGk22JzqbKEhu/iJYhhYYSjQLfdAdGKKqzGB0K4Q=;
	b=U4i2HfIoGVR0/5HlTaQYzCZ7oopzDvjfVRxrbMO8qMmkMI6KDYfrbpebum4lqE/+y7Zfil
	4vKK653OgWt9A33iLoaYZHAs8x0LaF7A5ttClnFqE5iHxJ3qfRsYRuHIvXAZnbvOAxnyLa
	0gzK0DnqSfiEx3IYbamU01McHB/I7AU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-132-stC39Q_IMnuehGNxcuOZxw-1; Fri, 01 Aug 2025 09:19:25 -0400
X-MC-Unique: stC39Q_IMnuehGNxcuOZxw-1
X-Mimecast-MFC-AGG-ID: stC39Q_IMnuehGNxcuOZxw_1754054364
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45359bfe631so9548355e9.0
        for <kvm@vger.kernel.org>; Fri, 01 Aug 2025 06:19:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754054364; x=1754659164;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YbLdGk22JzqbKEhu/iJYhhYYSjQLfdAdGKKqzGB0K4Q=;
        b=YHeWQQyihOOy/k3VXmmRkFAbVUocQ5VJ4jDI50TpHJ75qYiFlhDvQHgUUShsV5oUE5
         oQFd9v++wow7csuf/pvIWdfjbhRUucjr3Q3HPkpHZ/VmciOXG4PqIBHTQ5u5RwaQ+wQ3
         m3LjHzJEmnhE9NX3PHWQSt+jzY+c3Y9dWR1RCXWvbQlNpuKoyWj7af89q8Ey5LtuuIM3
         nb+XEJsW6e76V2Lcj2LchrkgixEVEzhM/MjwvPnYq8b7xw19yiyONyxqH3cuOzg36ScC
         nF6ZaroUk5n22RiLvllTdLGb66ZwNpN5Hv8ziWn0DVJK3bYHoKU/AU/+7Wk5VwWuZGcA
         JDow==
X-Gm-Message-State: AOJu0YyaaUaqftYSeABtXHKaEGBsSatrwTx4SlOPrz712bFfhWYtSWdj
	8U4T/+E7lN4PE7vlSgqvahVhCHWxwQutRUHVDRJMZaOMhJfbdsF5UBuBz30Q2AX7xbC0JCz1pbG
	/hwZ/cFKePI5hEOabEJVFJcyUcxXgKKeathCQjSiG1eTfWmqY0k9CKQ==
X-Gm-Gg: ASbGncvLRSm5wdKWq6ElBNxNv+vdEQbfcN6/sy1rtLOK6cK5c2PxJk59KZlfeokDg/Z
	IDJainCk/VvlFCNVEzW65YTslFUbWIDfbLtfYj2AifCiOqT1U0xp/YAnjKyLnb+JNQeZhmDEzny
	wZWeX57cIzK9if7/An3RLlf8iH5cB/wTk6PXQIeczKdqnk10EuhELurBUw8+EBGeY5H1wAhMvmi
	M/fymJADSFLhXNQc8WNiaIpFWshrs8Q7OJONN0Eg1g/W4mJCNoZnsiHPpDS3cZnLieO/8SFXBpB
	lQx7kFYp6Jny200m1fsuR/OdSP9gft4o
X-Received: by 2002:a05:600c:3143:b0:458:b2c4:b3df with SMTP id 5b1f17b1804b1-458b2c4b55cmr7065055e9.33.1754054364129;
        Fri, 01 Aug 2025 06:19:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHmZq6SGlI97jjT0xUjwHMnLWo6+mq6NBKRj1ThNjjX/DhoWqBXT6UeApleX2c0S5DJT9fufQ==
X-Received: by 2002:a05:600c:3143:b0:458:b2c4:b3df with SMTP id 5b1f17b1804b1-458b2c4b55cmr7064765e9.33.1754054363595;
        Fri, 01 Aug 2025 06:19:23 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1515:7300:62e6:253a:2a96:5e3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458af917d20sm11817765e9.2.2025.08.01.06.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 06:19:23 -0700 (PDT)
Date: Fri, 1 Aug 2025 09:19:19 -0400
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
Message-ID: <20250801091454-mutt-send-email-mst@kernel.org>
References: <20250801070032-mutt-send-email-mst@kernel.org>
 <20250801090250-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250801090250-mutt-send-email-mst@kernel.org>

On Fri, Aug 01, 2025 at 09:03:35AM -0400, Michael S. Tsirkin wrote:
> On Fri, Aug 01, 2025 at 07:00:32AM -0400, Michael S. Tsirkin wrote:
> > The following changes since commit 347e9f5043c89695b01e66b3ed111755afcf1911:
> > 
> >   Linux 6.16-rc6 (2025-07-13 14:25:58 -0700)
> > 
> > are available in the Git repository at:
> > 
> >   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
> > 
> > for you to fetch changes up to c7991b44d7b44f9270dec63acd0b2965d29aab43:
> > 
> >   vsock/virtio: Allocate nonlinear SKBs for handling large transmit buffers (2025-07-17 08:33:09 -0400)
> 
> Oh no I am sorry! Please ignore, a bad commit snuck in there - it still
> needs maintainer approval, and I forgot.
> Will resend.
> 

Sent v2 now.
I wanted to apologize for this. I mistakenly put bad commits on the
branch called "master" and when looking at "git log" I did not notice
I was only looking at commits since "master" and not
"origin/master".

I should have reviewed the list of changes in the email before
sending, but as it's autogenerated as opposed the cover letter part
that I write myself, I was focusing on the latter and missed the
bad commits in the former. A less for me to remember to pay attention to that
part, as well.

Thanks!

> > ----------------------------------------------------------------
> > virtio, vhost: features, fixes
> > 
> > vhost can now support legacy threading
> > 	if enabled in Kconfig
> > vsock memory allocation strategies for
> > 	large buffers have been improved,
> > 	reducing pressure on kmalloc
> > vhost now supports the in-order feature
> > 	guest bits missed the merge window
> > 
> > fixes, cleanups all over the place
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > 
> > ----------------------------------------------------------------
> > Alexandre Courbot (1):
> >       media: add virtio-media driver
> > 
> > Alok Tiwari (4):
> >       virtio: Fix typo in register_virtio_device() doc comment
> >       vhost-scsi: Fix typos and formatting in comments and logs
> >       vhost: Fix typos
> >       vhost-scsi: Fix check for inline_sg_cnt exceeding preallocated limit
> > 
> > Anders Roxell (1):
> >       vdpa: Fix IDR memory leak in VDUSE module exit
> > 
> > Cindy Lu (1):
> >       vhost: Reintroduce kthread API and add mode selection
> > 
> > Dr. David Alan Gilbert (2):
> >       vhost: vringh: Remove unused iotlb functions
> >       vhost: vringh: Remove unused functions
> > 
> > Dragos Tatulea (2):
> >       vdpa/mlx5: Fix needs_teardown flag calculation
> >       vdpa/mlx5: Fix release of uninitialized resources on error path
> > 
> > Gerd Hoffmann (1):
> >       drm/virtio: implement virtio_gpu_shutdown
> > 
> > Jason Wang (3):
> >       vhost: fail early when __vhost_add_used() fails
> >       vhost: basic in order support
> >       vhost_net: basic in_order support
> > 
> > Michael S. Tsirkin (6):
> >       virtio: document ENOSPC
> >       pci: report surprise removal event
> >       virtio: fix comments, readability
> >       virtio: pack config changed flags
> >       virtio: allow transports to suppress config change
> >       virtio: support device disconnect
> > 
> > Mike Christie (1):
> >       vhost-scsi: Fix log flooding with target does not exist errors
> > 
> > Pei Xiao (1):
> >       vhost: Use ERR_CAST inlined function instead of ERR_PTR(PTR_ERR(...))
> > 
> > Viresh Kumar (2):
> >       virtio-mmio: Remove virtqueue list from mmio device
> >       virtio-vdpa: Remove virtqueue list
> > 
> > WangYuli (1):
> >       virtio: virtio_dma_buf: fix missing parameter documentation
> > 
> > Will Deacon (9):
> >       vhost/vsock: Avoid allocating arbitrarily-sized SKBs
> >       vsock/virtio: Validate length in packet header before skb_put()
> >       vsock/virtio: Move length check to callers of virtio_vsock_skb_rx_put()
> >       vsock/virtio: Resize receive buffers so that each SKB fits in a 4K page
> >       vsock/virtio: Rename virtio_vsock_alloc_skb()
> >       vsock/virtio: Move SKB allocation lower-bound check to callers
> >       vhost/vsock: Allocate nonlinear SKBs for handling large receive buffers
> >       vsock/virtio: Rename virtio_vsock_skb_rx_put()
> >       vsock/virtio: Allocate nonlinear SKBs for handling large transmit buffers
> > 
> >  MAINTAINERS                                |    6 +
> >  drivers/gpu/drm/virtio/virtgpu_drv.c       |    8 +-
> >  drivers/media/Kconfig                      |   13 +
> >  drivers/media/Makefile                     |    2 +
> >  drivers/media/virtio/Makefile              |    9 +
> >  drivers/media/virtio/protocol.h            |  288 ++++++
> >  drivers/media/virtio/scatterlist_builder.c |  563 ++++++++++++
> >  drivers/media/virtio/scatterlist_builder.h |  111 +++
> >  drivers/media/virtio/session.h             |  109 +++
> >  drivers/media/virtio/virtio_media.h        |   93 ++
> >  drivers/media/virtio/virtio_media_driver.c |  959 ++++++++++++++++++++
> >  drivers/media/virtio/virtio_media_ioctls.c | 1297 ++++++++++++++++++++++++++++
> >  drivers/pci/pci.h                          |    6 +
> >  drivers/vdpa/mlx5/core/mr.c                |    3 +
> >  drivers/vdpa/mlx5/net/mlx5_vnet.c          |   12 +-
> >  drivers/vdpa/vdpa_user/vduse_dev.c         |    1 +
> >  drivers/vhost/Kconfig                      |   18 +
> >  drivers/vhost/net.c                        |   88 +-
> >  drivers/vhost/scsi.c                       |   24 +-
> >  drivers/vhost/vhost.c                      |  377 +++++++-
> >  drivers/vhost/vhost.h                      |   30 +-
> >  drivers/vhost/vringh.c                     |  118 ---
> >  drivers/vhost/vsock.c                      |   15 +-
> >  drivers/virtio/virtio.c                    |   25 +-
> >  drivers/virtio/virtio_dma_buf.c            |    2 +
> >  drivers/virtio/virtio_mmio.c               |   52 +-
> >  drivers/virtio/virtio_pci_common.c         |   45 +
> >  drivers/virtio/virtio_pci_common.h         |    3 +
> >  drivers/virtio/virtio_pci_legacy.c         |    2 +
> >  drivers/virtio/virtio_pci_modern.c         |    2 +
> >  drivers/virtio/virtio_ring.c               |    4 +
> >  drivers/virtio/virtio_vdpa.c               |   44 +-
> >  include/linux/pci.h                        |   45 +
> >  include/linux/virtio.h                     |   13 +-
> >  include/linux/virtio_config.h              |   32 +
> >  include/linux/virtio_vsock.h               |   46 +-
> >  include/linux/vringh.h                     |   12 -
> >  include/uapi/linux/vhost.h                 |   29 +
> >  include/uapi/linux/virtio_ids.h            |    1 +
> >  kernel/vhost_task.c                        |    2 +-
> >  net/vmw_vsock/virtio_transport.c           |   20 +-
> >  net/vmw_vsock/virtio_transport_common.c    |    3 +-
> >  42 files changed, 4186 insertions(+), 346 deletions(-)
> >  create mode 100644 drivers/media/virtio/Makefile
> >  create mode 100644 drivers/media/virtio/protocol.h
> >  create mode 100644 drivers/media/virtio/scatterlist_builder.c
> >  create mode 100644 drivers/media/virtio/scatterlist_builder.h
> >  create mode 100644 drivers/media/virtio/session.h
> >  create mode 100644 drivers/media/virtio/virtio_media.h
> >  create mode 100644 drivers/media/virtio/virtio_media_driver.c
> >  create mode 100644 drivers/media/virtio/virtio_media_ioctls.c


