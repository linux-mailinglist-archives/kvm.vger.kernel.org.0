Return-Path: <kvm+bounces-18019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 99B118CCBF3
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 08:00:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 15B8E1F21BBC
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 06:00:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E228713B596;
	Thu, 23 May 2024 06:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fAM1gbHA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC3D1C20
	for <kvm@vger.kernel.org>; Thu, 23 May 2024 06:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716444034; cv=none; b=kTgHWpaQUJSfmv3J1BNH0ZP5beQG7ik3GMZeC2Y/EQuWuNKAkbvve7H3xcQzlFDe1dhojoWOIlzbSLUvW/FXey8f1jbKXwYJSqAtJ4KYCFV0t/Ab+poJw/VTV28goty+m84d3oqoELpsa4jKAXT6wLf0kCSFfNdcj49RQuSmwB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716444034; c=relaxed/simple;
	bh=Se4JJHuUK1YAcPMwJrWNIBI9Ci1nNIC9TTJtr6ON0KA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ZtkwFmCB0citNkwRoyTPQs7xbnYwbHdPrh4Pecx/txqotEeCkqIrkDmrxhycqM/6QIavEvpzmaWhYAq5nEL9bd96O+D0Obg4ZSHnOrm+v2LCnJPwq+oTUuC3ceWkiB0wZr1e3uqo/8yphOKVcfh6lHtKu5I51urnpeOdYi62m7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fAM1gbHA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716444029;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yeUwdxW+9athxBr6SBuU13bYsy0ba7pdIdq8UligVLc=;
	b=fAM1gbHAldiX+d8bGSYMGxW6Q5Cqnau4+9+hAc7s0dLxJKfMUf3BoaTLzhJJS8ITC18Uwb
	4UgkuEf8uuTrShjZ38sT/PUg+B1STZi8UEbQTGuUzQE7UTX6HH7xJKbNwN0sJ55qzs+PxM
	GKg2/o/70neTe4CmTeiEvKwaxaITS6g=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-637-kb87F0CEPYOi8ZeVwQpfcQ-1; Thu, 23 May 2024 02:00:27 -0400
X-MC-Unique: kb87F0CEPYOi8ZeVwQpfcQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-354c964f74aso2856568f8f.0
        for <kvm@vger.kernel.org>; Wed, 22 May 2024 23:00:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716444026; x=1717048826;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yeUwdxW+9athxBr6SBuU13bYsy0ba7pdIdq8UligVLc=;
        b=gM1s2mgmW3EinExihymb0/47A0WrGGFzta8fcDrVnedJQUncdkl/97aiv8Wldejpji
         CTJZh9JTgdBTvBHhWz6Tkdakw+hZe9yUOOoj64sJcCHF5Z4xL+4NjmeCAaFhA0Lrk2pM
         6GQ1xZsUKnVBkDQyLKiDMY9uQ5hjX0qij216i/eJkwZk+Gj0tqTDxx+LR7vhqnzcgLcI
         eDY6pzu2iJq1BN+52WsAdS3/Fv+yJoGbdfLyJ01Yuor/xgRq4SLZubnskxRtisycVMfN
         HgwmpDRIhPUoo1GfBik5yIbIJgMYQCa1zzz7moTTtD1twoZ2cEY3YY7ZAW0f+IkCPCcV
         +lxA==
X-Gm-Message-State: AOJu0Yw2DSYUmWELgPrN7QWhpcrXs/p1DY6geVPFPUUJt/LbSwTXMY/F
	UjPhhHQHhFGk6uGhp2i9BgGnE2fGGriN4VZiTaXyl/GQkn757UZOcXgSGFWG5EjupPM6EhETrZK
	0P0lUSkCGxlKyrGrAm+3GS/Ky7OOK14etzq62wpoffxAylbu8iQ==
X-Received: by 2002:a5d:4104:0:b0:354:f2a7:97dc with SMTP id ffacd0b85a97d-354f2a79916mr2112184f8f.2.1716444025811;
        Wed, 22 May 2024 23:00:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHggXEqAc5WDd25UhTKUSbGqVNdQxbTGJOXdMfMSLslbIWkT+TDNK7KDuOftvOQ4EXBOWM/fg==
X-Received: by 2002:a5d:4104:0:b0:354:f2a7:97dc with SMTP id ffacd0b85a97d-354f2a79916mr2112094f8f.2.1716444024784;
        Wed, 22 May 2024 23:00:24 -0700 (PDT)
Received: from redhat.com ([2a02:14f:1f8:1442:5e01:de24:22c0:6071])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3502b896a34sm35664458f8f.35.2024.05.22.23.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 May 2024 23:00:23 -0700 (PDT)
Date: Thu, 23 May 2024 02:00:17 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
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
	mst@redhat.com, sgarzare@redhat.com, stevensd@chromium.org,
	sudeep.holla@arm.com,
	syzbot+98edc2df894917b3431f@syzkaller.appspotmail.com,
	u.kleine-koenig@pengutronix.de, viresh.kumar@linaro.org,
	xuanzhuo@linux.alibaba.com, yuxue.liu@jaguarmicro.com,
	zhanglikernel@gmail.com, Srujana Challa <schalla@marvell.com>
Subject: [GIT PULL v2] virtio: features, fixes, cleanups
Message-ID: <Zk7bX3XlEWtaPbxZ@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


Things to note here:
- dropped a couple of patches at the last moment. Did a bunch
  of testing in the last day to make sure that's not causing
  any fallout, it's a revert and no other changes in the same area
  so I feel rather safe doing that.
- the new Marvell OCTEON DPU driver is not here: latest v4 keeps causing
  build failures on mips. I kept deferring the pull hoping to get it in
  and I might try to merge a new version post rc1 (supposed to be ok for
  new drivers as they can't cause regressions), but we'll see.
- there are also a couple bugfixes under review, to be merged after rc1
- there is a trivial conflict in the header file. Shouldn't be any
  trouble to resolve, but fyi the resolution by Stephen is here
        diff --cc drivers/virtio/virtio_mem.c
        index e8355f55a8f7,6d4dfbc53a66..000000000000
        --- a/drivers/virtio/virtio_mem.c
        +++ b/drivers/virtio/virtio_mem.c
        @@@ -21,7 -21,7 +21,8 @@@
          #include <linux/bitmap.h>
          #include <linux/lockdep.h>
          #include <linux/log2.h>
         +#include <linux/vmalloc.h>
        + #include <linux/suspend.h>
  Also see it here:
  https://lore.kernel.org/all/20240423145947.142171f6@canb.auug.org.au/


The following changes since commit 18daea77cca626f590fb140fc11e3a43c5d41354:

  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm (2024-04-30 12:40:41 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to c8fae27d141a32a1624d0d0d5419d94252824498:

  virtio-pci: Check if is_avq is NULL (2024-05-22 08:39:41 -0400)

----------------------------------------------------------------
virtio: features, fixes, cleanups

Several new features here:

- virtio-net is finally supported in vduse.

- Virtio (balloon and mem) interaction with suspend is improved

- vhost-scsi now handles signals better/faster.

Fixes, cleanups all over the place.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Christophe JAILLET (1):
      vhost-vdpa: Remove usage of the deprecated ida_simple_xx() API

David Hildenbrand (1):
      virtio-mem: support suspend+resume

David Stevens (2):
      virtio_balloon: Give the balloon its own wakeup source
      virtio_balloon: Treat stats requests as wakeup events

Eugenio Pérez (1):
      MAINTAINERS: add Eugenio Pérez as reviewer

Jiri Pirko (1):
      virtio: delete vq in vp_find_vqs_msix() when request_irq() fails

Krzysztof Kozlowski (24):
      virtio: balloon: drop owner assignment
      virtio: input: drop owner assignment
      virtio: mem: drop owner assignment
      um: virt-pci: drop owner assignment
      virtio_blk: drop owner assignment
      bluetooth: virtio: drop owner assignment
      hwrng: virtio: drop owner assignment
      virtio_console: drop owner assignment
      crypto: virtio - drop owner assignment
      firmware: arm_scmi: virtio: drop owner assignment
      gpio: virtio: drop owner assignment
      drm/virtio: drop owner assignment
      iommu: virtio: drop owner assignment
      misc: nsm: drop owner assignment
      net: caif: virtio: drop owner assignment
      net: virtio: drop owner assignment
      net: 9p: virtio: drop owner assignment
      vsock/virtio: drop owner assignment
      wifi: mac80211_hwsim: drop owner assignment
      nvdimm: virtio_pmem: drop owner assignment
      rpmsg: virtio: drop owner assignment
      scsi: virtio: drop owner assignment
      fuse: virtio: drop owner assignment
      sound: virtio: drop owner assignment

Li Zhang (1):
      virtio-pci: Check if is_avq is NULL

Li Zhijian (1):
      vdpa: Convert sprintf/snprintf to sysfs_emit

Maxime Coquelin (3):
      vduse: validate block features only with block devices
      vduse: Temporarily fail if control queue feature requested
      vduse: enable Virtio-net device type

Michael S. Tsirkin (1):
      Merge tag 'stable/vduse-virtio-net' into vhost

Mike Christie (9):
      vhost-scsi: Handle vhost_vq_work_queue failures for events
      vhost-scsi: Handle vhost_vq_work_queue failures for cmds
      vhost-scsi: Use system wq to flush dev for TMFs
      vhost: Remove vhost_vq_flush
      vhost_scsi: Handle vhost_vq_work_queue failures for TMFs
      vhost: Use virtqueue mutex for swapping worker
      vhost: Release worker mutex during flushes
      vhost_task: Handle SIGKILL by flushing work and exiting
      kernel: Remove signal hacks for vhost_tasks

Uwe Kleine-König (1):
      virtio-mmio: Convert to platform remove callback returning void

Yuxue Liu (2):
      vp_vdpa: Fix return value check vp_vdpa_request_irq
      vp_vdpa: don't allocate unused msix vectors

Zhu Lingshan (1):
      MAINTAINERS: apply maintainer role of Intel vDPA driver

 MAINTAINERS                                   |  10 +-
 arch/um/drivers/virt-pci.c                    |   1 -
 drivers/block/virtio_blk.c                    |   1 -
 drivers/bluetooth/virtio_bt.c                 |   1 -
 drivers/char/hw_random/virtio-rng.c           |   1 -
 drivers/char/virtio_console.c                 |   2 -
 drivers/crypto/virtio/virtio_crypto_core.c    |   1 -
 drivers/firmware/arm_scmi/virtio.c            |   1 -
 drivers/gpio/gpio-virtio.c                    |   1 -
 drivers/gpu/drm/virtio/virtgpu_drv.c          |   1 -
 drivers/iommu/virtio-iommu.c                  |   1 -
 drivers/misc/nsm.c                            |   1 -
 drivers/net/caif/caif_virtio.c                |   1 -
 drivers/net/virtio_net.c                      |   1 -
 drivers/net/wireless/virtual/mac80211_hwsim.c |   1 -
 drivers/nvdimm/virtio_pmem.c                  |   1 -
 drivers/rpmsg/virtio_rpmsg_bus.c              |   1 -
 drivers/scsi/virtio_scsi.c                    |   1 -
 drivers/vdpa/vdpa.c                           |   2 +-
 drivers/vdpa/vdpa_user/vduse_dev.c            |  24 ++++-
 drivers/vdpa/virtio_pci/vp_vdpa.c             |  27 ++++--
 drivers/vhost/scsi.c                          |  70 ++++++++------
 drivers/vhost/vdpa.c                          |   6 +-
 drivers/vhost/vhost.c                         | 130 ++++++++++++++++++--------
 drivers/vhost/vhost.h                         |   3 +-
 drivers/virtio/virtio_balloon.c               |  85 +++++++++++------
 drivers/virtio/virtio_input.c                 |   1 -
 drivers/virtio/virtio_mem.c                   |  69 ++++++++++++--
 drivers/virtio/virtio_mmio.c                  |   6 +-
 drivers/virtio/virtio_pci_common.c            |   6 +-
 fs/coredump.c                                 |   4 +-
 fs/fuse/virtio_fs.c                           |   1 -
 include/linux/sched/vhost_task.h              |   3 +-
 include/uapi/linux/virtio_mem.h               |   2 +
 kernel/exit.c                                 |   5 +-
 kernel/signal.c                               |   4 +-
 kernel/vhost_task.c                           |  53 +++++++----
 net/9p/trans_virtio.c                         |   1 -
 net/vmw_vsock/virtio_transport.c              |   1 -
 sound/virtio/virtio_card.c                    |   1 -
 40 files changed, 355 insertions(+), 177 deletions(-)


