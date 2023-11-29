Return-Path: <kvm+bounces-2744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD6737FD239
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 10:17:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 253EC282F41
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 09:17:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBFF014AB4;
	Wed, 29 Nov 2023 09:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N04WPkSz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B585B1FFA
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 01:17:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701249423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ckwgjfvsxGj0GYdJiZLYltwjMuQpB0mwrwPr8QizCM8=;
	b=N04WPkSzGKRLbebJTu76uaVIx7ebXrq0S1Fjk6rKDSDc81p2bUNFVq8dndf0ct6gAvcCUL
	hbQHEQ77FCwlmv6tww5/NnuKVBGdPCnxgaVgF9avYaEpiLWJ9f6MqORdmzElVwcjjW5yex
	sK3wo8+s39YODl4HorU6uQ8gsHPZpVk=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-7gSTapwMPdaJ2vwtUdmkmg-1; Wed, 29 Nov 2023 04:17:02 -0500
X-MC-Unique: 7gSTapwMPdaJ2vwtUdmkmg-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-50aa9aee5f9so7074953e87.3
        for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 01:17:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701249420; x=1701854220;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ckwgjfvsxGj0GYdJiZLYltwjMuQpB0mwrwPr8QizCM8=;
        b=HiKQVQV0PYUSwU8UgoFlHfEXWSQuNc1Bybd5L9eK1gDS11Y1KjLa23jpi25FT0r4Nm
         +dTBMHVY7MBP0WdJ3i4/KQ/nBi9gzuQ2Nr8TmeOZOUBOkfKyWuMSnYRMCbI7xVrl9ixk
         hhbZ7KWPGQAyRmxNMTCquPQisy+zaw3zWm9Bq6flloOUZPKDhDs2QYp6dz9FQcZp48Ud
         //xwUBQ444K8WNoAQ2JGz0dwTBATeanbnPrH7vWr7FbqwldZtiYPPjhZRF8Ceh6UG+t6
         jwZCeTELMPuK5OSGAyu868FkNNuiEXHdKWyld54F3iY97cNVRdO8qpBGbuuSJR9j8fQe
         FEdw==
X-Gm-Message-State: AOJu0YyfEA78TPbLOc8HfdelaupVXWXTLS3TWTAXRQkrwRB7fZ3C3Yyh
	azMTvxbLDvqbHnR0bSdt+9yK/xvbuxLFZcHQ/T1I7FknRP6DExPktOE4OYCwpEfV9BjT+l6CAjs
	kdv8gOF90IO1NwXZszEAgN8dvbRuw
X-Received: by 2002:a19:671d:0:b0:50b:c08d:69ba with SMTP id b29-20020a19671d000000b0050bc08d69bamr2031906lfc.57.1701249420657;
        Wed, 29 Nov 2023 01:17:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHTpWxMFUv78+9eoh3yywfOCrwElPPyEFR923tcDuFlr5hCVrrpOFJIlTizYOyqCHn5EelCUZdWuJlBEl/NG/Y=
X-Received: by 2002:a19:671d:0:b0:50b:c08d:69ba with SMTP id
 b29-20020a19671d000000b0050bc08d69bamr2031882lfc.57.1701249420311; Wed, 29
 Nov 2023 01:17:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230903181338-mutt-send-email-mst@kernel.org> <647701d8-c99b-4ca8-9817-137eaefda237@linux.intel.com>
In-Reply-To: <647701d8-c99b-4ca8-9817-137eaefda237@linux.intel.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 29 Nov 2023 17:16:49 +0800
Message-ID: <CACGkMEvoGOO0jtq5T7arAjRoB_0_fHB2+hPJe1JsPqcAuvr98w@mail.gmail.com>
Subject: Re: [GIT PULL] virtio: features
To: "Ning, Hongyu" <hongyu.ning@linux.intel.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, xuanzhuo@linux.alibaba.com, 
	Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, eperezma@redhat.com, shannon.nelson@amd.com, 
	yuanyaogoog@chromium.org, yuehaibing@huawei.com, 
	kirill.shutemov@linux.intel.com, sathyanarayanan.kuppuswamy@linux.intel.com, 
	alexander.shishkin@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 29, 2023 at 5:05=E2=80=AFPM Ning, Hongyu
<hongyu.ning@linux.intel.com> wrote:
>
>
>
> On 2023/9/4 6:13, Michael S. Tsirkin wrote:
> > The following changes since commit 2dde18cd1d8fac735875f2e4987f11817cc0=
bc2c:
> >
> >    Linux 6.5 (2023-08-27 14:49:51 -0700)
> >
> > are available in the Git repository at:
> >
> >    https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/f=
or_linus
> >
> > for you to fetch changes up to 1acfe2c1225899eab5ab724c91b7e1eb2881b9ab=
:
> >
> >    virtio_ring: fix avail_wrap_counter in virtqueue_add_packed (2023-09=
-03 18:10:24 -0400)
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
> > Eugenio P=C3=A9rez (4):
> >        vdpa: add VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK flag
> >        vdpa: accept VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK backend feat=
ure
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
> >        virtio_ring: correct the expression of the description of virtqu=
eue_resize()
> >        virtio_ring: separate the logic of reset/enable from virtqueue_r=
esize
> >        virtio_ring: introduce virtqueue_reset()
> >        virtio_ring: introduce dma map api for virtqueue
> >        virtio_ring: introduce dma sync api for virtqueue
> >        virtio_net: merge dma operations when filling mergeable buffers
>
> Hi,
> above patch (upstream commit 295525e29a5b) seems causing a virtnet
> related Call Trace after WARNING from kernel/dma/debug.c.
>
> details (log and test setup) tracked in
> https://bugzilla.kernel.org/show_bug.cgi?id=3D218204
>
> it's recently noticed in a TDX guest testing since v6.6.0 release cycle
> and can still be reproduced in latest v6.7.0-rc3.
>
> as local bisects results show, above WARNING and Call Trace is linked
> with this patch, do you mind to take a look?

Looks like virtqueue_dma_sync_single_range_for_cpu() use
DMA_BIDIRECTIONAL unconditionally.

We should use dir here.

Mind to try?

Thanks

>
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
> >   drivers/virtio/virtio_ring.c       | 412 ++++++++++++++++++++++++++++=
++++-----
> >   drivers/virtio/virtio_vdpa.c       |  17 +-
> >   include/linux/vdpa.h               |   4 +
> >   include/linux/virtio.h             |  22 ++
> >   include/uapi/linux/vhost_types.h   |   4 +
> >   9 files changed, 625 insertions(+), 90 deletions(-)
> >
>


