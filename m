Return-Path: <kvm+bounces-36661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6700DA1D8BF
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 15:52:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3AE321886C78
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 14:52:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CB533D64;
	Mon, 27 Jan 2025 14:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aZZhpZHm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A826F30F
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 14:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737989507; cv=none; b=i7PJtavUyYmzj2JuvG/D3CsNOgu0elGxOnqdFBwIN93ncuRYy3mDw99mxaxVjVDwHl2aFlAhJXPpmUHIzfVGH6JtfCv3dLOykr0mNhGiKfrQOLG+ABogw8acS941W6Sre08td6Fb/muS1NHzlfOJTpYDjz8+EQpQUD5shetqDBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737989507; c=relaxed/simple;
	bh=82o5UCZGVSA9UZesK2R8teTwT07ErbjUj7U5zfSimqY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=gLmSROSog5HfIDLzNq2Xq18qZtf9mWG7nuRf1v7gs5VbWzHgiwOG18+zn4ojYn9A53KDJR+TdA1r8CKA0ejhxAatZsSBuutGN7HGvfDnCWDHyWxFq5o+pR/ifShYqSvLgZmUWKy35c7qDciV7Qn0DUPYlDlCfBAo8NqnDBZVms4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aZZhpZHm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737989504;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=iau4JPbloeWL667asjULg/fQ3/zjcPRlyMvVrpALuFo=;
	b=aZZhpZHmoSLOm1bWCLhp02AnyGk70G5DpfAHmZokFRGHmHpi8wyRHFGCP5/4WRm7T1D14+
	2XJZB+Nv3EcYDCNe1UTyaG8MYM7MsiJa0x2Iv0VECn9Chw3BP6ig1jCbR9cycW8qVPwEFc
	2IhQi0t9I9dG7+bqiAw3jeaxM5K8+xU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-581-x6mJZd11Ov26S6vhB6kK6w-1; Mon, 27 Jan 2025 09:51:42 -0500
X-MC-Unique: x6mJZd11Ov26S6vhB6kK6w-1
X-Mimecast-MFC-AGG-ID: x6mJZd11Ov26S6vhB6kK6w
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43619b135bcso22107655e9.1
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 06:51:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737989502; x=1738594302;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iau4JPbloeWL667asjULg/fQ3/zjcPRlyMvVrpALuFo=;
        b=Kbf27QDQlVYGHzTcXIMvrbDnKVhthwHj7MMtYdmHb76mWInlE4s2yV/A7c+G6lQUGh
         xBx2Lr6q6oUXochLjAQarWatabDj+7Xm9MJ+U/mn+oBYpobu+VgVtxmEaKDG2P7snN0/
         V4NOnb542yUFH/a751cdoEzHFgrql96UisJdENY7PmDxXK3W2x+scqkkif6z/lumcexp
         nQ0HcPhaUMzgVUSzrZqO65k6fzbKORP/ClyIN3wUVLQlt9UrBYQ2hXF9T7DItBgjW4Dp
         nuFf+4stzu2xmB/lWuZha+ctZc/NJFU2f3R6SyPum8JfQwCwRrJ30+fUY5PJo7RVwZYg
         Ml2Q==
X-Gm-Message-State: AOJu0YxK9Lay5LCUtjz1LBu/SIoxtQiXjHhMv4LY5T46uq5fObYOh0W1
	5JFJvzYXXZEZ0/PqGC6VMAUF4IXrj7npNyZvulS+ZQ2ayYgCKXN+4y+MucHKEaggjVegGLg60sB
	byOdb7v2TlCGjp9ddveQbz4g0LXTQt6s0YaCJTfn2aa0a9JmX1g==
X-Gm-Gg: ASbGncsofr1jOKQ1E9Ungs3NrjdSE/uKltsXiNAXQ2ZjxtvFdpsx+TwlAtMELhIoBOQ
	bO6C/BxxrzRfq0leQ4sceszfDvijqfycPidriSeb7lqgYIs06voJLBJ6K6xI4S9lDaJLzJ4wcyC
	KPrQDcDHKiNOsnLRB77g6AYUieL4al0TcAhc7GNG9ty3PXXUYBJUFO+XnxckLfrNq7uw4+6VSsS
	AF9VBsp8VlmKj7BAXoD4szfOqnbo99VHePGfPIpWG5I+CcpQHEaen5ginK1RwtubwaVP9cTJ64n
	dA==
X-Received: by 2002:a05:600c:8719:b0:434:9499:9e87 with SMTP id 5b1f17b1804b1-43891437217mr333777625e9.25.1737989501763;
        Mon, 27 Jan 2025 06:51:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHuV4H4eM+0+8cCmZ4gGN82WCYmpRuJq01+bj07H2U3xuDnsFknD44BEnMwIVHwLR+uIAWc4g==
X-Received: by 2002:a05:600c:8719:b0:434:9499:9e87 with SMTP id 5b1f17b1804b1-43891437217mr333777455e9.25.1737989501407;
        Mon, 27 Jan 2025 06:51:41 -0800 (PST)
Received: from redhat.com ([2a06:c701:740d:3500:7f3a:4e66:9c0d:1416])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438b171e68bsm158813595e9.0.2025.01.27.06.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 06:51:40 -0800 (PST)
Date: Mon, 27 Jan 2025 09:51:38 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	akihiko.odaki@daynix.com, akpm@linux-foundation.org, bhe@redhat.com,
	david@redhat.com, israelr@nvidia.com, jasowang@redhat.com,
	mst@redhat.com, pstanner@redhat.com, sgarzare@redhat.com,
	skoteshwar@marvell.com, sthotton@marvell.com,
	xieyongji@bytedance.com, yuxue.liu@jaguarmicro.com,
	zhangjiao2@cmss.chinamobile.com
Subject: [GIT PULL] virtio: features, fixes, cleanups
Message-ID: <20250127095138-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent

There are still some known issues that I hope to address by rc2.
Giving them more time to get tested for now - none of them are
regressions.

The following changes since commit 9d89551994a430b50c4fffcb1e617a057fa76e20:

  Linux 6.13-rc6 (2025-01-05 14:13:40 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 5820a3b08987951e3e4a89fca8ab6e1448f672e1:

  virtio_blk: Add support for transport error recovery (2025-01-27 09:39:26 -0500)

----------------------------------------------------------------
virtio: features, fixes, cleanups

A small number of improvements all over the place:

vdpa/octeon gained support for multiple interrupts
virtio-pci gained support for error recovery
vp_vdpa gained support for notification with data
vhost/net has been fixed to set num_buffers for spec compliance
virtio-mem now works with kdump on s390

Small cleanups all over the place.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Akihiko Odaki (1):
      vhost/net: Set num_buffers for virtio 1.0

David Hildenbrand (12):
      fs/proc/vmcore: convert vmcore_cb_lock into vmcore_mutex
      fs/proc/vmcore: replace vmcoredd_mutex by vmcore_mutex
      fs/proc/vmcore: disallow vmcore modifications while the vmcore is open
      fs/proc/vmcore: prefix all pr_* with "vmcore:"
      fs/proc/vmcore: move vmcore definitions out of kcore.h
      fs/proc/vmcore: factor out allocating a vmcore range and adding it to a list
      fs/proc/vmcore: factor out freeing a list of vmcore ranges
      fs/proc/vmcore: introduce PROC_VMCORE_DEVICE_RAM to detect device RAM ranges in 2nd kernel
      virtio-mem: mark device ready before registering callbacks in kdump mode
      virtio-mem: remember usable region size
      virtio-mem: support CONFIG_PROC_VMCORE_DEVICE_RAM
      s390/kdump: virtio-mem kdump support (CONFIG_PROC_VMCORE_DEVICE_RAM)

Israel Rukshin (2):
      virtio_pci: Add support for PCIe Function Level Reset
      virtio_blk: Add support for transport error recovery

Philipp Stanner (1):
      vdpa: solidrun: Replace deprecated PCI functions

Satha Rao (1):
      vdpa/octeon_ep: handle device config change events

Shijith Thotton (3):
      vdpa/octeon_ep: enable support for multiple interrupts per device
      virtio-pci: define type and header for PCI vendor data
      vdpa/octeon_ep: read vendor-specific PCI capability

Yongji Xie (1):
      vduse: relicense under GPL-2.0 OR BSD-3-Clause

Yuxue Liu (1):
      vdpa/vp_vdpa: implement kick_vq_with_data callback

zhang jiao (1):
      virtio_balloon: Use outer variable 'page'

 arch/s390/Kconfig                        |   1 +
 arch/s390/kernel/crash_dump.c            |  39 ++++-
 drivers/block/virtio_blk.c               |  28 ++-
 drivers/vdpa/octeon_ep/octep_vdpa.h      |  32 +++-
 drivers/vdpa/octeon_ep/octep_vdpa_hw.c   |  38 ++++-
 drivers/vdpa/octeon_ep/octep_vdpa_main.c |  99 +++++++----
 drivers/vdpa/solidrun/snet_main.c        |  57 +++----
 drivers/vdpa/virtio_pci/vp_vdpa.c        |   9 +
 drivers/vhost/net.c                      |   5 +-
 drivers/virtio/virtio.c                  |  94 +++++++---
 drivers/virtio/virtio_balloon.c          |   2 +-
 drivers/virtio/virtio_mem.c              | 103 ++++++++++-
 drivers/virtio/virtio_pci_common.c       |  41 +++++
 fs/proc/Kconfig                          |  19 +++
 fs/proc/vmcore.c                         | 283 ++++++++++++++++++++++++-------
 include/linux/crash_dump.h               |  41 +++++
 include/linux/kcore.h                    |  13 --
 include/linux/virtio.h                   |   8 +
 include/uapi/linux/vduse.h               |   2 +-
 include/uapi/linux/virtio_pci.h          |  14 ++
 20 files changed, 735 insertions(+), 193 deletions(-)


