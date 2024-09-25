Return-Path: <kvm+bounces-27417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1C459857AB
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 13:10:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E9E40B23F9A
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 11:10:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A516B15B559;
	Wed, 25 Sep 2024 11:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a3ow9NCj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343AE154BEC
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 11:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727262597; cv=none; b=nyAPoLGMsnWdepOO9WAJtL2Dd4ESKGSMw0Mej9TWRlpBSl4+VbPVbmx/FjoDfMXU/lwtzcDop+2ljv6ILTxgt3ZWzKYpSYSn+WRyxf7+ZC6kMWjw6CT5p515flImFO0C6lO0aOmacmQ0QJVcaDd8yNA9qhdlwzWM0eXIUxCHKrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727262597; c=relaxed/simple;
	bh=xtxsvm8uRDT0k+Fdso/owoT8wFfjLj3xm055kPKyiKk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Gbnr+ozoFyGvfxE075AL4E6PD6zPw8DPMpNmuVqlMjW/DF91UnPebex2+d95KDnxFNnKjynsG1UMMf9ly+Mr6W0kj7AcA96HsZORiPixxhESR7K2iVgHX5L+gIZwg1ZkhLRwnKAYnkBPyMQ0VkptPycJpRCl6vxVTHFjrcmIz3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a3ow9NCj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727262595;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=GYARqqH/zIw2gIrAZ+tTLBZyNzYt/nqsl4mA84ZpEqE=;
	b=a3ow9NCjxICxby1QpdwZaMQH0cafnWgeyxlwQVMCc7jPuk2CFY2P+XF4vVmKdyXnTuL6GI
	njHHrpik0/JLpHZcxbr9zhGDGfEHuovG38tONVWvMN+0xsi533RxeSQq/NljBG0pgd+Lp3
	v14Vcs+/iFFTtaijU/f+VvWcdNA8LPQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-282-WzRBJEh7P7KZ-lMhjyRiiA-1; Wed, 25 Sep 2024 07:09:54 -0400
X-MC-Unique: WzRBJEh7P7KZ-lMhjyRiiA-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-374c90d24e3so4623413f8f.0
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 04:09:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727262593; x=1727867393;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GYARqqH/zIw2gIrAZ+tTLBZyNzYt/nqsl4mA84ZpEqE=;
        b=g2aq6YTsLDqgELNOewXV0nh6HOykrmQM+4DuyA+0Eu3FLsfgDvSvyhryDJ5uz5bKsp
         BUgZ4p7vqd1j5gekG5Lz38q9avj8tiYWg0+3y+UlEmtzDG49kTf61SkLGUSKM9gDE3Cl
         qYdx/pZHK3Xn0jtS4cz87ovPiaTWHFwS6KLZ/JyY7AizDIe5LOQG1G+gPC7a7mPHKrAM
         GrC1IkeqCZHa3Qc3FiywHZx/X3aQpnZrR7kPEb5dj4IgWBAP+DtL6YzgIpjnOo0ROl6E
         OV+URvmGhdqA8hYCbERgau4mzwKuZHXelNfU/w3J598Ukzy/gWb8JQbHak9ic+lcaGbf
         2gLg==
X-Gm-Message-State: AOJu0YxUK/26UOnvf2ZujU0EoZhmp7TlFexuvygyg8vSHwXiD3IFz995
	0cz1HODvBhbC+twgYg0sIct7vvBK4EhfuLfaA/fZOglg+vYtTh/ihk471gd+xVTpFuAuSuQeFVu
	8fAOU7C7HiWX0hBrnP91oIZsosOfD/8QtCQdvwFtngwUPFcw6sA==
X-Received: by 2002:a05:6000:18c9:b0:374:c3e4:d6b1 with SMTP id ffacd0b85a97d-37cc24b25b5mr1902410f8f.44.1727262592657;
        Wed, 25 Sep 2024 04:09:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFVT6hBQDAGQX3+vy1AsamAzh0r2GQEW+rZO8mUVTLUvy6RGX+GkdPmK+Lzdj53mjsxARrWvA==
X-Received: by 2002:a05:6000:18c9:b0:374:c3e4:d6b1 with SMTP id ffacd0b85a97d-37cc24b25b5mr1902383f8f.44.1727262592214;
        Wed, 25 Sep 2024 04:09:52 -0700 (PDT)
Received: from redhat.com ([2a06:c701:7405:9900:56a3:401a:f419:5de9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42e96a07e69sm14908845e9.21.2024.09.25.04.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2024 04:09:51 -0700 (PDT)
Date: Wed, 25 Sep 2024 07:09:49 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	david@redhat.com, dtatulea@nvidia.com, eperezma@redhat.com,
	jasowang@redhat.com, leiyang@redhat.com, leonro@nvidia.com,
	lihongbo22@huawei.com, luigi.leonardi@outlook.com, lulu@redhat.com,
	marco.pinn95@gmail.com, mgurtovoy@nvidia.com, mst@redhat.com,
	pankaj.gupta.linux@gmail.com, philipchen@chromium.org,
	pizhenwei@bytedance.com, sgarzare@redhat.com, yuehaibing@huawei.com,
	zhujun2@cmss.chinamobile.com
Subject: [GIT PULL v2] virtio: features, fixes, cleanups
Message-ID: <20240925070949-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent

Changes from v1:
	add a missing ack, removing an empty commit that I used to
	record it.  no code changes.

The following changes since commit 431c1646e1f86b949fa3685efc50b660a364c2b6:

  Linux 6.11-rc6 (2024-09-01 19:46:02 +1200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to efcd71af38be403fa52223092f79ada446e121ba:

  vsock/virtio: avoid queuing packets when intermediate queue is empty (2024-09-25 07:07:44 -0400)

----------------------------------------------------------------
virtio: features, fixes, cleanups

Several new features here:

	virtio-balloon supports new stats

	vdpa supports setting mac address

	vdpa/mlx5 suspend/resume as well as MKEY ops are now faster

	virtio_fs supports new sysfs entries for queue info

	virtio/vsock performance has been improved

Fixes, cleanups all over the place.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Cindy Lu (3):
      vdpa: support set mac address from vdpa tool
      vdpa_sim_net: Add the support of set mac address
      vdpa/mlx5: Add the support of set mac address

Dragos Tatulea (18):
      vdpa/mlx5: Fix invalid mr resource destroy
      net/mlx5: Support throttled commands from async API
      vdpa/mlx5: Introduce error logging function
      vdpa/mlx5: Introduce async fw command wrapper
      vdpa/mlx5: Use async API for vq query command
      vdpa/mlx5: Use async API for vq modify commands
      vdpa/mlx5: Parallelize device suspend
      vdpa/mlx5: Parallelize device resume
      vdpa/mlx5: Keep notifiers during suspend but ignore
      vdpa/mlx5: Small improvement for change_num_qps()
      vdpa/mlx5: Parallelize VQ suspend/resume for CVQ MQ command
      vdpa/mlx5: Create direct MKEYs in parallel
      vdpa/mlx5: Delete direct MKEYs in parallel
      vdpa/mlx5: Rename function
      vdpa/mlx5: Extract mr members in own resource struct
      vdpa/mlx5: Rename mr_mtx -> lock
      vdpa/mlx5: Introduce init/destroy for MR resources
      vdpa/mlx5: Postpone MR deletion

Hongbo Li (1):
      fw_cfg: Constify struct kobj_type

Jason Wang (1):
      vhost_vdpa: assign irq bypass producer token correctly

Luigi Leonardi (1):
      vsock/virtio: avoid queuing packets when intermediate queue is empty

Marco Pinna (1):
      vsock/virtio: refactor virtio_transport_send_pkt_work

Max Gurtovoy (2):
      virtio_fs: introduce virtio_fs_put_locked helper
      virtio_fs: add sysfs entries for queue information

Philip Chen (1):
      virtio_pmem: Check device status before requesting flush

Stefano Garzarella (1):
      MAINTAINERS: add virtio-vsock driver in the VIRTIO CORE section

Yue Haibing (1):
      vdpa: Remove unused declarations

Zhu Jun (1):
      tools/virtio:Fix the wrong format specifier

zhenwei pi (3):
      virtio_balloon: introduce oom-kill invocations
      virtio_balloon: introduce memory allocation stall counter
      virtio_balloon: introduce memory scan/reclaim info

 MAINTAINERS                                   |   1 +
 drivers/firmware/qemu_fw_cfg.c                |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |  21 +-
 drivers/nvdimm/nd_virtio.c                    |   9 +
 drivers/vdpa/ifcvf/ifcvf_base.h               |   3 -
 drivers/vdpa/mlx5/core/mlx5_vdpa.h            |  47 ++-
 drivers/vdpa/mlx5/core/mr.c                   | 291 +++++++++++++---
 drivers/vdpa/mlx5/core/resources.c            |  76 +++-
 drivers/vdpa/mlx5/net/mlx5_vnet.c             | 477 +++++++++++++++++---------
 drivers/vdpa/pds/cmds.h                       |   1 -
 drivers/vdpa/vdpa.c                           |  79 +++++
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c          |  21 +-
 drivers/vhost/vdpa.c                          |  16 +-
 drivers/virtio/virtio_balloon.c               |  18 +
 fs/fuse/virtio_fs.c                           | 164 ++++++++-
 include/linux/vdpa.h                          |   9 +
 include/uapi/linux/vdpa.h                     |   1 +
 include/uapi/linux/virtio_balloon.h           |  16 +-
 net/vmw_vsock/virtio_transport.c              | 144 +++++---
 tools/virtio/ringtest/main.c                  |   2 +-
 20 files changed, 1098 insertions(+), 300 deletions(-)


