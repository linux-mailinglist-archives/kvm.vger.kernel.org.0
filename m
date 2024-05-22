Return-Path: <kvm+bounces-17948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4950D8CC068
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 13:38:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 008862842D0
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 11:38:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C45E582D7A;
	Wed, 22 May 2024 11:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fv7PJ2Qm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2ED982872
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 11:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716377904; cv=none; b=eTCGmIsS/9DfcNRm+Mr47W8wKJtWJWTsX9zt8JDKLLEm4IdYBQvgu5obY48NN7ZgNav9GbY6AHIYNuruHdSZ1BfYvSZ/+vsyWxVdEllvMEH1Wr6oMFUESTI42offtFe4rrEBvexRG/52SpXTPwvcbyfsqUxn8SZSlIar25cLAVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716377904; c=relaxed/simple;
	bh=TYPRc8K5lINwHSpAKS3gPPNAiyGdkK9OMzfTF/F3uCk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=unlZMqXs59CQznABrFiOMFEgrJQwJrclL2jjhPHWU9iPr4NGvl2QJxrtdIGVbyg8MPAyT6roLXuC35bNRCk2rUiSZiOWD9T6zUPxcE6gEAd+Owcn7SPDFz7jHjnVyfTQ916UwyFZ8tyKlL103a5RR3ys6+98bspnjPVA182I+YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fv7PJ2Qm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716377899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HVaOOA6qGL/CK6WZX/6d0obWvvk3+JicZE8KikRaOUo=;
	b=Fv7PJ2Qmh66pbWNk7wbLbaq5tUAkpFZoroGLO20S4eG8R7C7HvrWAt5ZGUcWLnLviqbz3L
	D8DRQSJZkJNIlaq4B4hE5Xrul229HODOBWBfYx8K7qDaJ9iXpMRWOVSTS54iB8X5qZTKjm
	6X4CXst6PjR+N+Al9ZLSIaOD0w5GVvo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-182-q4N0k7QlMAyAFgiddpUlAw-1; Wed, 22 May 2024 07:38:17 -0400
X-MC-Unique: q4N0k7QlMAyAFgiddpUlAw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-351bd229b88so7442175f8f.1
        for <kvm@vger.kernel.org>; Wed, 22 May 2024 04:38:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716377896; x=1716982696;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HVaOOA6qGL/CK6WZX/6d0obWvvk3+JicZE8KikRaOUo=;
        b=mcoYSkbjDUIpnkDTGaqjG4tj5jEbSOgz5s81DzqPxHSuWMbfJ4LkQWMvmyKedTxD/a
         8gxgMnBUHpy8vkbRGcJp+VLZHreoPXzp8GKpu8tVTf2U4Tda6RS3CZUH+BgKlRxVkDSS
         NwXlzKI07208ouZZybC0RO8AmH1xQ8kPVg5CMNSY3rIuKrsLYpG4E0be7GbdrhzOpCCM
         bQ6tlMh9hWS0hXw/e9y+vL1bweF0IlN7M3SXHb0bq0GY+7GPfvbTrqyWxwwNKrKj44o7
         2NndivnMxY5B5hKbNBq/6oZR3UPB/9py0r/86cnYEL9VDOtNFNH2k1EYocPHYg1z/j4j
         ul5Q==
X-Gm-Message-State: AOJu0YyBQeIOgZ8oSLyqugXF/QpPe4aTA27xJpeGyG4JLzXslFhKFtm6
	Q+dKfFqa7nUHHcEvS4vDgfPlHlSBdw+c9sqjRZJhEQqD2v+QT22Hj9luN9L3RIqXjJNBEzLfYLT
	6EKwuFRqE7qhaBGDl7CParwnZOXB0mriQde+4K+kFPLQaNKqtjA==
X-Received: by 2002:a05:600c:5105:b0:41b:cc7d:1207 with SMTP id 5b1f17b1804b1-420fd31e112mr15624335e9.19.1716377896347;
        Wed, 22 May 2024 04:38:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEt6Cbeq9f6S2CBwMYNTzyGc4qDdBN6K2JnTNHMSnN9QXLcMstq+yPsTE9sbhgVDijWWVE1jw==
X-Received: by 2002:a05:600c:5105:b0:41b:cc7d:1207 with SMTP id 5b1f17b1804b1-420fd31e112mr15624025e9.19.1716377895712;
        Wed, 22 May 2024 04:38:15 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc7:55d:e862:558a:a573:a176:1825])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4201c3f8032sm347952525e9.28.2024.05.22.04.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 May 2024 04:38:15 -0700 (PDT)
Date: Wed, 22 May 2024 07:38:01 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	anton.yakovlev@opensynergy.com, bartosz.golaszewski@linaro.org,
	christophe.jaillet@wanadoo.fr, dave.jiang@intel.com,
	david@redhat.com, eperezma@redhat.com, herbert@gondor.apana.org.au,
	jasowang@redhat.com, jiri@nvidia.com, jiri@resnulli.us,
	johannes@sipsolutions.net, krzysztof.kozlowski@linaro.org,
	lingshan.zhu@intel.com, linus.walleij@linaro.org,
	lizhijian@fujitsu.com, martin.petersen@oracle.com,
	maxime.coquelin@redhat.com, michael.christie@oracle.com,
	sgarzare@redhat.com, stevensd@chromium.org, sudeep.holla@arm.com,
	syzbot+98edc2df894917b3431f@syzkaller.appspotmail.com,
	u.kleine-koenig@pengutronix.de, viresh.kumar@linaro.org,
	yuxue.liu@jaguarmicro.com, Srujana Challa <schalla@marvell.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] virtio: features, fixes, cleanups
Message-ID: <20240522073727-mutt-send-email-mst@kernel.org>
References: <20240522060301-mutt-send-email-mst@kernel.org>
 <1716373365.1499481-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1716373365.1499481-1-xuanzhuo@linux.alibaba.com>

On Wed, May 22, 2024 at 06:22:45PM +0800, Xuan Zhuo wrote:
> On Wed, 22 May 2024 06:03:01 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > Things to note here:
> >
> > - the new Marvell OCTEON DPU driver is not here: latest v4 keeps causing
> >   build failures on mips. I deferred the pull hoping to get it in
> >   and I might merge a new version post rc1
> >   (supposed to be ok for new drivers as they can't cause regressions),
> >   but we'll see.
> > - there are also a couple bugfixes under review, to be merged after rc1
> > - I merged a trivial patch (removing a comment) that also got
> >   merged through net.
> >   git handles this just fine and it did not seem worth it
> >   rebasing to drop it.
> > - there is a trivial conflict in the header file. Shouldn't be any
> >   trouble to resolve, but fyi the resolution by Stephen is here
> > 	diff --cc drivers/virtio/virtio_mem.c
> > 	index e8355f55a8f7,6d4dfbc53a66..000000000000
> > 	--- a/drivers/virtio/virtio_mem.c
> > 	+++ b/drivers/virtio/virtio_mem.c
> > 	@@@ -21,7 -21,7 +21,8 @@@
> > 	  #include <linux/bitmap.h>
> > 	  #include <linux/lockdep.h>
> > 	  #include <linux/log2.h>
> > 	 +#include <linux/vmalloc.h>
> > 	+ #include <linux/suspend.h>
> >   Also see it here:
> >   https://lore.kernel.org/all/20240423145947.142171f6@canb.auug.org.au/
> >
> >
> >
> > The following changes since commit 18daea77cca626f590fb140fc11e3a43c5d41354:
> >
> >   Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm (2024-04-30 12:40:41 -0700)
> >
> > are available in the Git repository at:
> >
> >   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
> >
> > for you to fetch changes up to 0b8dbbdcf2e42273fbac9b752919e2e5b2abac21:
> >
> >   Merge tag 'for_linus' into vhost (2024-05-12 08:15:28 -0400)
> >
> > ----------------------------------------------------------------
> > virtio: features, fixes, cleanups
> >
> > Several new features here:
> >
> > - virtio-net is finally supported in vduse.
> >
> > - Virtio (balloon and mem) interaction with suspend is improved
> >
> > - vhost-scsi now handles signals better/faster.
> >
> > - virtio-net now supports premapped mode by default,
> >   opening the door for all kind of zero copy tricks.
> >
> > Fixes, cleanups all over the place.
> >
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >
> > ----------------------------------------------------------------
> > Christophe JAILLET (1):
> >       vhost-vdpa: Remove usage of the deprecated ida_simple_xx() API
> >
> > David Hildenbrand (1):
> >       virtio-mem: support suspend+resume
> >
> > David Stevens (2):
> >       virtio_balloon: Give the balloon its own wakeup source
> >       virtio_balloon: Treat stats requests as wakeup events
> >
> > Eugenio Pérez (2):
> >       MAINTAINERS: add Eugenio Pérez as reviewer
> >       MAINTAINERS: add Eugenio Pérez as reviewer
> >
> > Jiri Pirko (1):
> >       virtio: delete vq in vp_find_vqs_msix() when request_irq() fails
> >
> > Krzysztof Kozlowski (24):
> >       virtio: balloon: drop owner assignment
> >       virtio: input: drop owner assignment
> >       virtio: mem: drop owner assignment
> >       um: virt-pci: drop owner assignment
> >       virtio_blk: drop owner assignment
> >       bluetooth: virtio: drop owner assignment
> >       hwrng: virtio: drop owner assignment
> >       virtio_console: drop owner assignment
> >       crypto: virtio - drop owner assignment
> >       firmware: arm_scmi: virtio: drop owner assignment
> >       gpio: virtio: drop owner assignment
> >       drm/virtio: drop owner assignment
> >       iommu: virtio: drop owner assignment
> >       misc: nsm: drop owner assignment
> >       net: caif: virtio: drop owner assignment
> >       net: virtio: drop owner assignment
> >       net: 9p: virtio: drop owner assignment
> >       vsock/virtio: drop owner assignment
> >       wifi: mac80211_hwsim: drop owner assignment
> >       nvdimm: virtio_pmem: drop owner assignment
> >       rpmsg: virtio: drop owner assignment
> >       scsi: virtio: drop owner assignment
> >       fuse: virtio: drop owner assignment
> >       sound: virtio: drop owner assignment
> >
> > Li Zhijian (1):
> >       vdpa: Convert sprintf/snprintf to sysfs_emit
> >
> > Maxime Coquelin (6):
> >       vduse: validate block features only with block devices
> >       vduse: Temporarily fail if control queue feature requested
> >       vduse: enable Virtio-net device type
> >       vduse: validate block features only with block devices
> >       vduse: Temporarily fail if control queue feature requested
> >       vduse: enable Virtio-net device type
> >
> > Michael S. Tsirkin (2):
> >       Merge tag 'stable/vduse-virtio-net' into vhost
> >       Merge tag 'for_linus' into vhost
> >
> > Mike Christie (9):
> >       vhost-scsi: Handle vhost_vq_work_queue failures for events
> >       vhost-scsi: Handle vhost_vq_work_queue failures for cmds
> >       vhost-scsi: Use system wq to flush dev for TMFs
> >       vhost: Remove vhost_vq_flush
> >       vhost_scsi: Handle vhost_vq_work_queue failures for TMFs
> >       vhost: Use virtqueue mutex for swapping worker
> >       vhost: Release worker mutex during flushes
> >       vhost_task: Handle SIGKILL by flushing work and exiting
> >       kernel: Remove signal hacks for vhost_tasks
> >
> > Uwe Kleine-König (1):
> >       virtio-mmio: Convert to platform remove callback returning void
> >
> > Xuan Zhuo (7):
> >       virtio_ring: introduce dma map api for page
> >       virtio_ring: enable premapped mode whatever use_dma_api
> >       virtio_net: replace private by pp struct inside page
> >       virtio_net: big mode support premapped
> >       virtio_net: enable premapped by default
> >       virtio_net: rx remove premapped failover code
> >       virtio_net: remove the misleading comment
> 
> Hi Michael,
> 
> As we discussed here:
> 
> 	http://lore.kernel.org/all/CACGkMEuyeJ9mMgYnnB42=hw6umNuo=agn7VBqBqYPd7GN=+39Q@mail.gmail.com
> 
> This patch set has been abandoned.

You mean I should drop it? OK.

> And you miss
> 
> 	https://lore.kernel.org/all/20240424091533.86949-1-xuanzhuo@linux.alibaba.com/
> 
> Thanks.
> 
> >
> > Yuxue Liu (2):
> >       vp_vdpa: Fix return value check vp_vdpa_request_irq
> >       vp_vdpa: don't allocate unused msix vectors
> >
> > Zhu Lingshan (1):
> >       MAINTAINERS: apply maintainer role of Intel vDPA driver
> >
> >  MAINTAINERS                                   |  10 +-
> >  arch/um/drivers/virt-pci.c                    |   1 -
> >  drivers/block/virtio_blk.c                    |   1 -
> >  drivers/bluetooth/virtio_bt.c                 |   1 -
> >  drivers/char/hw_random/virtio-rng.c           |   1 -
> >  drivers/char/virtio_console.c                 |   2 -
> >  drivers/crypto/virtio/virtio_crypto_core.c    |   1 -
> >  drivers/firmware/arm_scmi/virtio.c            |   1 -
> >  drivers/gpio/gpio-virtio.c                    |   1 -
> >  drivers/gpu/drm/virtio/virtgpu_drv.c          |   1 -
> >  drivers/iommu/virtio-iommu.c                  |   1 -
> >  drivers/misc/nsm.c                            |   1 -
> >  drivers/net/caif/caif_virtio.c                |   1 -
> >  drivers/net/virtio_net.c                      | 248 +++++++++++++++++---------
> >  drivers/net/wireless/virtual/mac80211_hwsim.c |   1 -
> >  drivers/nvdimm/virtio_pmem.c                  |   1 -
> >  drivers/rpmsg/virtio_rpmsg_bus.c              |   1 -
> >  drivers/scsi/virtio_scsi.c                    |   1 -
> >  drivers/vdpa/vdpa.c                           |   2 +-
> >  drivers/vdpa/vdpa_user/vduse_dev.c            |  24 ++-
> >  drivers/vdpa/virtio_pci/vp_vdpa.c             |  27 ++-
> >  drivers/vhost/scsi.c                          |  70 +++++---
> >  drivers/vhost/vdpa.c                          |   6 +-
> >  drivers/vhost/vhost.c                         | 130 ++++++++++----
> >  drivers/vhost/vhost.h                         |   3 +-
> >  drivers/virtio/virtio_balloon.c               |  85 +++++----
> >  drivers/virtio/virtio_input.c                 |   1 -
> >  drivers/virtio/virtio_mem.c                   |  69 ++++++-
> >  drivers/virtio/virtio_mmio.c                  |   6 +-
> >  drivers/virtio/virtio_pci_common.c            |   4 +-
> >  drivers/virtio/virtio_ring.c                  |  59 +++++-
> >  fs/coredump.c                                 |   4 +-
> >  fs/fuse/virtio_fs.c                           |   1 -
> >  include/linux/sched/vhost_task.h              |   3 +-
> >  include/linux/virtio.h                        |   7 +
> >  include/uapi/linux/virtio_mem.h               |   2 +
> >  kernel/exit.c                                 |   5 +-
> >  kernel/signal.c                               |   4 +-
> >  kernel/vhost_task.c                           |  53 ++++--
> >  net/9p/trans_virtio.c                         |   1 -
> >  net/vmw_vsock/virtio_transport.c              |   1 -
> >  sound/virtio/virtio_card.c                    |   1 -
> >  42 files changed, 578 insertions(+), 265 deletions(-)
> >


