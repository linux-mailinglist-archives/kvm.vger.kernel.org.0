Return-Path: <kvm+bounces-2749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FBA57FD31C
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 10:47:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 575D2B21900
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 09:47:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA81B18E21;
	Wed, 29 Nov 2023 09:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cF23uCnb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A1419BC
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 01:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701251236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8FUL7xaq2WNQBPHMTY8ZTJkkLmUhL7UnsbnYobOmCzM=;
	b=cF23uCnbDgtBVu/PFjh4DnfmKASshe8nXxLYBnt49brIdjx1mpRO8XsQ5JU9hk6zk1DC+z
	QDQzqCRUbBOooxBkQmXJDgBQ507MCo0KE3fB/HlsNX71mAbyu8ljKscxUr5X2ci8jEDb94
	bPZTxEFX9/tNzcRBfXaBGkUPwBuevZw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-393-tB1QDWzNOEGPQqa2jE8EVg-1; Wed, 29 Nov 2023 04:47:14 -0500
X-MC-Unique: tB1QDWzNOEGPQqa2jE8EVg-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a01a0032b19so490028766b.2
        for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 01:47:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701251233; x=1701856033;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8FUL7xaq2WNQBPHMTY8ZTJkkLmUhL7UnsbnYobOmCzM=;
        b=PLraeBWBDnqVOmeV9s9pcHk4ZOp/B8Wwurvuq674QQQEAzwS6abzFN846JMHk9zAFH
         ClbyY6coecUssSnp6YJGwydSla55Pr+sVpHQe5ZMw5svLA/fZ7+l4+iW520rhizIflDj
         VTlOTFw5X337uJN7qd/Zlo7E70aZsS9XUlX3zoj+nzVwUA+1vkuG3C9tgAl/NMH2HU5z
         K9r/KlFKWxTHx+F9KE+Y74cK/8K1jKiQtFG2Ba0MVUXYGMQN4BTPtFClftHb4W/WQUmB
         zcB/PFeeb13GOTCet4zt0Ddb5sohEf68wOF10vda34dl+8LuaB7frgYF5QasjUpMTn/I
         iFOA==
X-Gm-Message-State: AOJu0YzhIxlNt3wS28nVvls4hJr237hIijcy+cSaCRTn/d8hvoV1tyD3
	4h18N4NYsVcc2+G0UHMM/7WEvv8o3fZKWGbwAMqrLnsl0hOPqpn6lukU8a02prexJ9+s93gMwg9
	H0+QZjcX8tp80Xr6XSYnf
X-Received: by 2002:a17:906:5349:b0:a0a:391d:2dad with SMTP id j9-20020a170906534900b00a0a391d2dadmr13424745ejo.75.1701251233277;
        Wed, 29 Nov 2023 01:47:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEcdjDb3B9JI1PiGSAemY+jsGIUrA/1PnJLVzsoGUWFBHqpyAnt/MTb5gBPxFzfJMBSJ9M+Hw==
X-Received: by 2002:a17:906:5349:b0:a0a:391d:2dad with SMTP id j9-20020a170906534900b00a0a391d2dadmr13424728ejo.75.1701251232928;
        Wed, 29 Nov 2023 01:47:12 -0800 (PST)
Received: from redhat.com ([2.55.57.48])
        by smtp.gmail.com with ESMTPSA id s8-20020a170906454800b00997d7aa59fasm7810806ejq.14.2023.11.29.01.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Nov 2023 01:47:12 -0800 (PST)
Date: Wed, 29 Nov 2023 04:47:08 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Ning, Hongyu" <hongyu.ning@linux.intel.com>
Cc: xuanzhuo@linux.alibaba.com,
	Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, eperezma@redhat.com,
	jasowang@redhat.com, shannon.nelson@amd.com,
	yuanyaogoog@chromium.org, yuehaibing@huawei.com,
	kirill.shutemov@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com,
	alexander.shishkin@linux.intel.com
Subject: Re: [GIT PULL] virtio: features
Message-ID: <20231129044651-mutt-send-email-mst@kernel.org>
References: <20230903181338-mutt-send-email-mst@kernel.org>
 <647701d8-c99b-4ca8-9817-137eaefda237@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <647701d8-c99b-4ca8-9817-137eaefda237@linux.intel.com>

On Wed, Nov 29, 2023 at 05:03:50PM +0800, Ning, Hongyu wrote:
> 
> 
> On 2023/9/4 6:13, Michael S. Tsirkin wrote:
> > The following changes since commit 2dde18cd1d8fac735875f2e4987f11817cc0bc2c:
> > 
> >    Linux 6.5 (2023-08-27 14:49:51 -0700)
> > 
> > are available in the Git repository at:
> > 
> >    https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
> > 
> > for you to fetch changes up to 1acfe2c1225899eab5ab724c91b7e1eb2881b9ab:
> > 
> >    virtio_ring: fix avail_wrap_counter in virtqueue_add_packed (2023-09-03 18:10:24 -0400)
> > 
> > ----------------------------------------------------------------
> > virtio: features
> > 
> > a small pull request this time around, mostly because the
> > vduse network got postponed to next relase so we can be sure
> > we got the security store right.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > 
> > ----------------------------------------------------------------
> > Eugenio Pérez (4):
> >        vdpa: add VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK flag
> >        vdpa: accept VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK backend feature
> >        vdpa: add get_backend_features vdpa operation
> >        vdpa_sim: offer VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK
> > 
> > Jason Wang (1):
> >        virtio_vdpa: build affinity masks conditionally
> > 
> > Xuan Zhuo (12):
> >        virtio_ring: check use_dma_api before unmap desc for indirect
> >        virtio_ring: put mapping error check in vring_map_one_sg
> >        virtio_ring: introduce virtqueue_set_dma_premapped()
> >        virtio_ring: support add premapped buf
> >        virtio_ring: introduce virtqueue_dma_dev()
> >        virtio_ring: skip unmap for premapped
> >        virtio_ring: correct the expression of the description of virtqueue_resize()
> >        virtio_ring: separate the logic of reset/enable from virtqueue_resize
> >        virtio_ring: introduce virtqueue_reset()
> >        virtio_ring: introduce dma map api for virtqueue
> >        virtio_ring: introduce dma sync api for virtqueue
> >        virtio_net: merge dma operations when filling mergeable buffers
> 
> Hi,
> above patch (upstream commit 295525e29a5b) seems causing a virtnet related
> Call Trace after WARNING from kernel/dma/debug.c.
> 
> details (log and test setup) tracked in
> https://bugzilla.kernel.org/show_bug.cgi?id=218204
> 
> it's recently noticed in a TDX guest testing since v6.6.0 release cycle and
> can still be reproduced in latest v6.7.0-rc3.
> 
> as local bisects results show, above WARNING and Call Trace is linked with
> this patch, do you mind to take a look?

Does your testing tree include the fixup
5720c43d5216b5dbd9ab25595f7c61e55d36d4fc ?

> > 
> > Yuan Yao (1):
> >        virtio_ring: fix avail_wrap_counter in virtqueue_add_packed
> > 
> > Yue Haibing (1):
> >        vdpa/mlx5: Remove unused function declarations
> > 
> >   drivers/net/virtio_net.c           | 230 ++++++++++++++++++---
> >   drivers/vdpa/mlx5/core/mlx5_vdpa.h |   3 -
> >   drivers/vdpa/vdpa_sim/vdpa_sim.c   |   8 +
> >   drivers/vhost/vdpa.c               |  15 +-
> >   drivers/virtio/virtio_ring.c       | 412 ++++++++++++++++++++++++++++++++-----
> >   drivers/virtio/virtio_vdpa.c       |  17 +-
> >   include/linux/vdpa.h               |   4 +
> >   include/linux/virtio.h             |  22 ++
> >   include/uapi/linux/vhost_types.h   |   4 +
> >   9 files changed, 625 insertions(+), 90 deletions(-)
> > 


