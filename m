Return-Path: <kvm+bounces-21771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24A4E9339DA
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 11:31:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47BC21C21FD5
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 09:30:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0087C44C61;
	Wed, 17 Jul 2024 09:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TodRx2Xw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F0F1BF37
	for <kvm@vger.kernel.org>; Wed, 17 Jul 2024 09:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721208647; cv=none; b=g9Hr+ki4Qpyc3zZG02Sz36Sjv1wSOELvdlpovELrtmsldkEcqbFHm2iKXy1gwkys4ERvEAX29kS0LDUELCuD7jse89NhvLMuMTZ2m+yfsbhaUYzKaC2gEcDs2CfdTuCtpvqppMJ96GwqT1VR3gBc4THxkLCMz7z5FWfn7OkC3/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721208647; c=relaxed/simple;
	bh=+j1oKxXC2+mctg/T18SUJCQoGsIT+7q3eTg13N64o6o=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=dsqjJxaVktokBoV6QYdffIk3Z2V+mPYlpr9Uc8/DNddcHaHUtsCwnISbFod/xcKSnHV2psCFrJWM+z3DbRcgqbg4p8EKWhzHJnSImbkxrgnZ5dAgFeAfA7pUUklinn3uvvEvMXFcLRADv8AX/AV990ttKBSV3NSo5AyJP0sreNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TodRx2Xw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721208644;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=hHn4PM15X6BfGZ4IGsolrdvu6NyZm1/S/3s13S/ihyc=;
	b=TodRx2XwOAPl3/EmcDeOoQXtqdJpBpBbMbZAdHXdz0Sztyr8rM6hopS/W+QytYGQS5aM3l
	0Spgxt5j6t5/0i4v4mRbsBTEyeVBiXyRcQ2xF/F0hLUSKUz5PuIvb/bOS4Og9eIG12jkli
	fm7VquRmR4KQ1KRYNtAvXOQSsFb2eE8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-EW3T2kNpOheXRo_Fis9FYg-1; Wed, 17 Jul 2024 05:30:42 -0400
X-MC-Unique: EW3T2kNpOheXRo_Fis9FYg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-36835daf8b7so313674f8f.2
        for <kvm@vger.kernel.org>; Wed, 17 Jul 2024 02:30:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721208641; x=1721813441;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hHn4PM15X6BfGZ4IGsolrdvu6NyZm1/S/3s13S/ihyc=;
        b=PDIsvz/NHr36vsKE5IjNrExosujkEMjTraKJMEhnG8TF1lXg5v74UoglPTvuJaNYaF
         vQR2edE4lmL/5KOdva9jCE19KlxKDDLjnDBlJxjeF7AStMcG59BdXEzdLy/2ULOtWz+C
         VExkSZPLhujBmMOkfoqDK2WNYRz64a2LU9lMUVi+6Fkr8vETycR/4542aFQ1OIs2hb7w
         w8IuLE5yoIBaHqJeVnHmpmDJXnC4FEUhXQVxT3GqPyFoVvjVhpr8/dPZtq7DZcuZrWAo
         A2ycixD+hMc0lGPVlnZhp7I0zFQzSETCvnwg3lUFAbNggR1dhhtlcGgrIrs0urrMwtdU
         VFFA==
X-Gm-Message-State: AOJu0YwuW0I272gHTPHXxCh/CS4/9wXt1sR3ddNxY/WGkOPYxaD6r11A
	0m5RFwMXC733a1sjcisRQBMvYF7RVcMec7Dz9IMf5YtHbG2By95E+PtOng2jqiFkZSwk0v2B2Sf
	no8+B9Nr5/wvtH2vsGahH69+Np+2QXKN6rx/3jfmgGSsssgzEGg==
X-Received: by 2002:a05:6000:184a:b0:367:f054:620a with SMTP id ffacd0b85a97d-3683164e06bmr1272086f8f.30.1721208640806;
        Wed, 17 Jul 2024 02:30:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHgi0vY4A7VA4fVejzyPOXOYvLRx878qRE1TDykdArGWkaZv/7uQtCouTKFxTNvVX6I2b0+jg==
X-Received: by 2002:a05:6000:184a:b0:367:f054:620a with SMTP id ffacd0b85a97d-3683164e06bmr1272042f8f.30.1721208640135;
        Wed, 17 Jul 2024 02:30:40 -0700 (PDT)
Received: from redhat.com ([2a02:14f:1f6:360d:da73:bbf7:ba86:37fb])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3680dafbec3sm11246395f8f.85.2024.07.17.02.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jul 2024 02:30:38 -0700 (PDT)
Date: Wed, 17 Jul 2024 05:30:34 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	aha310510@gmail.com, arefev@swemel.ru, arseny.krasnov@kaspersky.com,
	davem@davemloft.net, dtatulea@nvidia.com, eperezma@redhat.com,
	glider@google.com, iii@linux.ibm.com, jasowang@redhat.com,
	jiri@nvidia.com, jiri@resnulli.us, kuba@kernel.org,
	lingshan.zhu@intel.com, mst@redhat.com, ndabilpuram@marvell.com,
	pgootzen@nvidia.com, pizhenwei@bytedance.com,
	quic_jjohnson@quicinc.com, schalla@marvell.com, stefanha@redhat.com,
	sthotton@marvell.com,
	syzbot+6c21aeb59d0e82eb2782@syzkaller.appspotmail.com,
	vattunuru@marvell.com, will@kernel.org, xuanzhuo@linux.alibaba.com,
	yskelg@gmail.com
Subject: [GIT PULL] virtio: features, fixes, cleanups
Message-ID: <20240717053034-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent

This is relatively small.
I had to drop a buggy commit in the middle so some hashes
changed from what was in linux-next.
Deferred admin vq scalability fix to after rc2 as a minor issue was
found with it recently, but the infrastructure for it
is there now.

The following changes since commit e9d22f7a6655941fc8b2b942ed354ec780936b3e:

  Merge tag 'linux_kselftest-fixes-6.10-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest (2024-07-02 13:53:24 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 6c85d6b653caeba2ef982925703cbb4f2b3b3163:

  virtio: rename virtio_find_vqs_info() to virtio_find_vqs() (2024-07-17 05:20:58 -0400)

----------------------------------------------------------------
virtio: features, fixes, cleanups

Several new features here:

- Virtio find vqs API has been reworked
  (required to fix the scalability issue we have with
   adminq, which I hope to merge later in the cycle)

- vDPA driver for Marvell OCTEON

- virtio fs performance improvement

- mlx5 migration speedups

Fixes, cleanups all over the place.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Denis Arefev (1):
      net: missing check virtio

Dragos Tatulea (24):
      vdpa/mlx5: Clarify meaning thorough function rename
      vdpa/mlx5: Make setup/teardown_vq_resources() symmetrical
      vdpa/mlx5: Drop redundant code
      vdpa/mlx5: Drop redundant check in teardown_virtqueues()
      vdpa/mlx5: Iterate over active VQs during suspend/resume
      vdpa/mlx5: Remove duplicate suspend code
      vdpa/mlx5: Initialize and reset device with one queue pair
      vdpa/mlx5: Clear and reinitialize software VQ data on reset
      vdpa/mlx5: Rename init_mvqs
      vdpa/mlx5: Add support for modifying the virtio_version VQ field
      vdpa/mlx5: Add support for modifying the VQ features field
      vdpa/mlx5: Set an initial size on the VQ
      vdpa/mlx5: Start off rqt_size with max VQPs
      vdpa/mlx5: Set mkey modified flags on all VQs
      vdpa/mlx5: Allow creation of blank VQs
      vdpa/mlx5: Accept Init -> Ready VQ transition in resume_vq()
      vdpa/mlx5: Add error code for suspend/resume VQ
      vdpa/mlx5: Consolidate all VQ modify to Ready to use resume_vq()
      vdpa/mlx5: Forward error in suspend/resume device
      vdpa/mlx5: Use suspend/resume during VQP change
      vdpa/mlx5: Pre-create hardware VQs at vdpa .dev_add time
      vdpa/mlx5: Re-create HW VQs under certain conditions
      vdpa/mlx5: Don't reset VQs more than necessary
      vdpa/mlx5: Don't enable non-active VQs in .set_vq_ready()

Jeff Johnson (3):
      vringh: add MODULE_DESCRIPTION()
      virtio: add missing MODULE_DESCRIPTION() macros
      vDPA: add missing MODULE_DESCRIPTION() macros

Jiri Pirko (19):
      caif_virtio: use virtio_find_single_vq() for single virtqueue finding
      virtio: make virtio_find_vqs() call virtio_find_vqs_ctx()
      virtio: make virtio_find_single_vq() call virtio_find_vqs()
      virtio: introduce virtio_queue_info struct and find_vqs_info() config op
      virtio_pci: convert vp_*find_vqs() ops to find_vqs_info()
      virtio: convert find_vqs() op implementations to find_vqs_info()
      virtio: call virtio_find_vqs_info() from virtio_find_single_vq() directly
      virtio: remove the original find_vqs() op
      virtio: rename find_vqs_info() op to find_vqs()
      virtio_blk: convert to use virtio_find_vqs_info()
      virtio_console: convert to use virtio_find_vqs_info()
      virtio_crypto: convert to use virtio_find_vqs_info()
      virtio_net: convert to use virtio_find_vqs_info()
      scsi: virtio_scsi: convert to use virtio_find_vqs_info()
      virtiofs: convert to use virtio_find_vqs_info()
      virtio_balloon: convert to use virtio_find_vqs_info()
      virtio: convert the rest virtio_find_vqs() users to virtio_find_vqs_info()
      virtio: remove unused virtio_find_vqs() and virtio_find_vqs_ctx() helpers
      virtio: rename virtio_find_vqs_info() to virtio_find_vqs()

Michael S. Tsirkin (2):
      vhost/vsock: always initialize seqpacket_allow
      vhost: move smp_rmb() into vhost_get_avail_idx()

Peter-Jan Gootzen (2):
      virtio-fs: let -ENOMEM bubble up or burst gently
      virtio-fs: improved request latencies when Virtio queue is full

Srujana Challa (1):
      virtio: vdpa: vDPA driver for Marvell OCTEON DPU devices

Xuan Zhuo (1):
      virtio_ring: fix KMSAN error for premapped mode

Yunseong Kim (1):
      tools/virtio: creating pipe assertion in vringh_test

Zhu Lingshan (1):
      MAINTAINERS: Change lingshan's email to kernel.org

zhenwei pi (1):
      virtio_balloon: separate vm events into a function

 MAINTAINERS                                   |   7 +-
 arch/um/drivers/virt-pci.c                    |   8 +-
 arch/um/drivers/virtio_uml.c                  |  12 +-
 drivers/block/virtio_blk.c                    |  20 +-
 drivers/bluetooth/virtio_bt.c                 |  13 +-
 drivers/char/virtio_console.c                 |  43 +-
 drivers/crypto/virtio/virtio_crypto_core.c    |  31 +-
 drivers/firmware/arm_scmi/virtio.c            |  11 +-
 drivers/gpio/gpio-virtio.c                    |  10 +-
 drivers/gpu/drm/virtio/virtgpu_kms.c          |   9 +-
 drivers/iommu/virtio-iommu.c                  |  11 +-
 drivers/net/caif/caif_virtio.c                |   8 +-
 drivers/net/virtio_net.c                      |  34 +-
 drivers/net/wireless/virtual/mac80211_hwsim.c |  12 +-
 drivers/platform/mellanox/mlxbf-tmfifo.c      |  10 +-
 drivers/remoteproc/remoteproc_virtio.c        |  12 +-
 drivers/rpmsg/virtio_rpmsg_bus.c              |   8 +-
 drivers/s390/virtio/virtio_ccw.c              |  13 +-
 drivers/scsi/virtio_scsi.c                    |  32 +-
 drivers/vdpa/Kconfig                          |  11 +
 drivers/vdpa/Makefile                         |   1 +
 drivers/vdpa/ifcvf/ifcvf_main.c               |   1 +
 drivers/vdpa/mlx5/net/mlx5_vnet.c             | 429 ++++++++-----
 drivers/vdpa/mlx5/net/mlx5_vnet.h             |   1 +
 drivers/vdpa/octeon_ep/Makefile               |   4 +
 drivers/vdpa/octeon_ep/octep_vdpa.h           |  94 +++
 drivers/vdpa/octeon_ep/octep_vdpa_hw.c        | 517 ++++++++++++++++
 drivers/vdpa/octeon_ep/octep_vdpa_main.c      | 857 ++++++++++++++++++++++++++
 drivers/vdpa/vdpa.c                           |   1 +
 drivers/vhost/vhost.c                         | 105 ++--
 drivers/vhost/vringh.c                        |   1 +
 drivers/vhost/vsock.c                         |   4 +-
 drivers/virtio/virtio.c                       |   1 +
 drivers/virtio/virtio_balloon.c               |  75 ++-
 drivers/virtio/virtio_input.c                 |   9 +-
 drivers/virtio/virtio_mmio.c                  |  12 +-
 drivers/virtio/virtio_pci_common.c            |  48 +-
 drivers/virtio/virtio_pci_common.h            |   3 +-
 drivers/virtio/virtio_pci_modern.c            |   5 +-
 drivers/virtio/virtio_ring.c                  |   5 +-
 drivers/virtio/virtio_vdpa.c                  |  13 +-
 fs/fuse/virtio_fs.c                           |  62 +-
 include/linux/mlx5/mlx5_ifc_vdpa.h            |   2 +
 include/linux/virtio_config.h                 |  64 +-
 include/linux/virtio_net.h                    |  11 +
 net/vmw_vsock/virtio_transport.c              |  16 +-
 sound/virtio/virtio_card.c                    |  23 +-
 tools/virtio/vringh_test.c                    |   9 +-
 48 files changed, 2145 insertions(+), 543 deletions(-)
 create mode 100644 drivers/vdpa/octeon_ep/Makefile
 create mode 100644 drivers/vdpa/octeon_ep/octep_vdpa.h
 create mode 100644 drivers/vdpa/octeon_ep/octep_vdpa_hw.c
 create mode 100644 drivers/vdpa/octeon_ep/octep_vdpa_main.c


