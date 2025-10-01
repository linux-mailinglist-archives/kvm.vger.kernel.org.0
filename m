Return-Path: <kvm+bounces-59284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BA08CBB02B5
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 13:32:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 28B1D1943056
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 11:32:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6CD92D0629;
	Wed,  1 Oct 2025 11:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h2+f/SDI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4081E2C21C1
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 11:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759318326; cv=none; b=NFyKHIeoeDdEToY5cpP1znYVTHBfLfymEee+E9ICZR4TEDOHKyunrzeUkXnq1LppxPpeMih7jyRLl0tclBSzhLoblpEmaRUjK/WhX2xGS8ZBQFy97Meo/uK271qgKDoIvS1RjRrhxIDBx5Y6gmX6WsCAd8Yw+/I94OBtyj/3HOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759318326; c=relaxed/simple;
	bh=E8TP+jTXRnR5ypNl9rTKJR9W/tHyfS8KQ+ykqiS8ARQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=B6ooM/CvHTOQlvoIH273Ad2fVLPHLAv5Wh1RxxmXqyXCYJb2BeCXFfWcGJlrSqnbDctjx/Ew8B0B4PzLwJ9oGp9oRZRnnkRv2rMFdJ8dIE6rJKFvaWoirz7pKBDVHbHsoSDxOlo6I5CjuGbetLKXqmVLF/8IgJfA8HKKyNBaaAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h2+f/SDI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759318324;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=iJSRuteQOX9gctlwdxDghNzdOhBrLQto5XenHeU3Vv8=;
	b=h2+f/SDI1lFKzHj2ZfTwofW0QajYgPX4oS0J/GF+mmXbdq+mQcy/x8xt4Gqdc3iQchcYgG
	s3K3t7iiVK/JiU590XAwmaopfOdDG+eXE9wSrcxE0yQtp1FbB1K5ks2qPH7oeQUCb0jHjv
	ksiHdp5DHH9BQE1G9ew9RZZgQ45xMtQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-CEghHFacP86JWGFb7cLwTA-1; Wed, 01 Oct 2025 07:32:03 -0400
X-MC-Unique: CEghHFacP86JWGFb7cLwTA-1
X-Mimecast-MFC-AGG-ID: CEghHFacP86JWGFb7cLwTA_1759318322
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e3e177893so44911995e9.2
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 04:32:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759318322; x=1759923122;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iJSRuteQOX9gctlwdxDghNzdOhBrLQto5XenHeU3Vv8=;
        b=QpMdkf+HAkhPou+Qif4LXO4HOtIYg2UHbCnAjm8R0LlinZbnZ5713Tn8CrnE2Yi/B1
         xCv6RvbQX0xOZWEP5EhQxOidKVzq/Doo7ff0N3THrIIKq9ZGP7KSx+zwtQ9CecuG/qH3
         IDEkXU4cP3WPK4HsEUF63y+BnZDNX/byROfO14sWwEdL0qEEUEAVxEqvI24xfhqeS/AT
         8+wDQkLNmBHMBqpX69mvbDwtsBaCnjjPaei/1O5lCgQjY4YJIJTgoaYuv5C1T82O3Wpa
         jHwlVFyQz+y8T5TS5mY6wbfuGbh3PD+RWFYnnrmbNZ8zr29ZH5/1v+XpZeMR5njMIEI8
         hJXw==
X-Gm-Message-State: AOJu0YzrTO4kcgXxiEo7+KfutAIQeaiK8W6z0IgqM1auznEpuw4k2ZT6
	55zOBZrA9a1CnU+LktqkNKnQxiNcgqtzFRqne8f40EkvMCptjZoxw6ug7k2tCEqlgrc+hqAjH6c
	Ifw237pqBXZpFErE2d5lBVPY5kvmc0IrNr4Rf0l7sOEF9J/ygBdQRQw==
X-Gm-Gg: ASbGnctn/U9WlZ7pd5drexSfNrN1Zoibw6hhWLQj3AApoZ0Oubsx6MEKR6N+5Q3i3Bm
	Jrp1l4uqA41OCBRuWLRRSvdLJu0vL//c8rVSFeo3yYPrujUXQh54suvrlOs5r1izC8nanWA17hX
	Rfb+2eN201Yjb+VbzToOH9wKi7hsWb2aVa+9pKndS1nQ8gJpkAt6h8vYXt7KxTHXMeWIatqTkjS
	A1omJhEvLAAkRKs+TiIJyaWJiLA8zM7mXFkjTYNIen437ltbyiLbrwg9E5CvCA73/ahRbd+j3TE
	kdmSGIGh9ssPy1gE6x0bY8oIE5MhUuw3znAJ7d4=
X-Received: by 2002:a05:600c:45d0:b0:45c:b6fa:352e with SMTP id 5b1f17b1804b1-46e612bc7f7mr25101275e9.18.1759318321585;
        Wed, 01 Oct 2025 04:32:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGstrQbPl2ux574MZQ5paDC88d3YGXhrfcZSAq6ToKm0J+thPm2S97lL7iQ8LvaDhELHu4bFA==
X-Received: by 2002:a05:600c:45d0:b0:45c:b6fa:352e with SMTP id 5b1f17b1804b1-46e612bc7f7mr25100985e9.18.1759318320967;
        Wed, 01 Oct 2025 04:32:00 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1518:6900:b69a:73e1:9698:9cd3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e619c3b75sm34870125e9.7.2025.10.01.04.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 04:32:00 -0700 (PDT)
Date: Wed, 1 Oct 2025 07:31:58 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	jasowang@redhat.com, leiyang@redhat.com, mst@redhat.com,
	rongqianfeng@vivo.com, sgarzare@redhat.com,
	sheng.zhao@bytedance.com, zhangjiao2@cmss.chinamobile.com,
	zhao.xichao@vivo.com
Subject: [GIT PULL] virtio,vhost: fixes, cleanups
Message-ID: <20251001073158-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent

The following changes since commit e5f0a698b34ed76002dc5cff3804a61c80233a7a:

  Linux 6.17 (2025-09-28 14:39:22 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to ed9f3ab9f3d3655e7447239cac80e4e0388faea8:

  virtio-vdpa: Drop redundant conversion to bool (2025-10-01 07:24:55 -0400)

----------------------------------------------------------------
virtio,vhost: fixes, cleanups

Just fixes and cleanups this time around.  The mapping cleanups are
preparing the ground for new features, though.
In order patches were almost there but I feel they didn't
spend enough time in next yet.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Jason Wang (9):
      virtio_ring: constify virtqueue pointer for DMA helpers
      virtio_ring: switch to use dma_{map|unmap}_page()
      virtio: rename dma helpers
      virtio: introduce virtio_map container union
      virtio_ring: rename dma_handle to map_handle
      virtio: introduce map ops in virtio core
      vdpa: support virtio_map
      vdpa: introduce map ops
      vduse: switch to use virtio map API instead of DMA API

Michael S. Tsirkin (1):
      vhost: vringh: Fix copy_to_iter return value check

Qianfeng Rong (1):
      virtio_balloon: Remove redundant __GFP_NOWARN

Sheng Zhao (1):
      vduse: Use fixed 4KB bounce pages for non-4KB page size

Xichao Zhao (1):
      virtio-vdpa: Drop redundant conversion to bool

zhang jiao (1):
      vhost: vringh: Modify the return value check

 drivers/net/virtio_net.c                 |  28 +-
 drivers/vdpa/Kconfig                     |   8 +-
 drivers/vdpa/alibaba/eni_vdpa.c          |   5 +-
 drivers/vdpa/ifcvf/ifcvf_main.c          |   5 +-
 drivers/vdpa/mlx5/core/mr.c              |   4 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c        |  15 +-
 drivers/vdpa/octeon_ep/octep_vdpa_main.c |   6 +-
 drivers/vdpa/pds/vdpa_dev.c              |   5 +-
 drivers/vdpa/solidrun/snet_main.c        |   8 +-
 drivers/vdpa/vdpa.c                      |   5 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c         |   4 +-
 drivers/vdpa/vdpa_user/iova_domain.c     | 132 ++++++---
 drivers/vdpa/vdpa_user/iova_domain.h     |   7 +-
 drivers/vdpa/vdpa_user/vduse_dev.c       |  79 +++---
 drivers/vdpa/virtio_pci/vp_vdpa.c        |   5 +-
 drivers/vhost/vdpa.c                     |   6 +-
 drivers/vhost/vringh.c                   |  14 +-
 drivers/virtio/virtio_balloon.c          |   2 +-
 drivers/virtio/virtio_ring.c             | 459 +++++++++++++++++++------------
 drivers/virtio/virtio_vdpa.c             |  22 +-
 include/linux/vdpa.h                     |  25 +-
 include/linux/virtio.h                   |  46 +++-
 include/linux/virtio_config.h            |  72 +++++
 include/linux/virtio_ring.h              |   7 +-
 24 files changed, 635 insertions(+), 334 deletions(-)


