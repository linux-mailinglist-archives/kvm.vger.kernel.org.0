Return-Path: <kvm+bounces-3058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B05E8002EE
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 06:16:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4CCBF1C20365
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 05:16:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8275D882A;
	Fri,  1 Dec 2023 05:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SmzexBMd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E3A1724
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 21:15:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701407750;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SHwmJNsb+e2xdb/Uv7JTIMOAPZD+rYanzUJIDl9T/t0=;
	b=SmzexBMdmo1xDInR1ja6tbyNUJ/i7tHPUWpps0HZ9k9orUySejP5RAoDfKzh1xtFYGxQjm
	sxmL7GGuEhv21ICd7zMVpi3yujfU3f20NImeXit8fkiGHI4G0Mz7249kG+yli6EajBvN/1
	tvGRj6/+XcFmE6q0ghs/TPmyQIrCUuc=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-463-Zj9lkP7yP4yROi6nTwtR4w-1; Fri, 01 Dec 2023 00:15:46 -0500
X-MC-Unique: Zj9lkP7yP4yROi6nTwtR4w-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-50bd74b7869so569931e87.0
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 21:15:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701407745; x=1702012545;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SHwmJNsb+e2xdb/Uv7JTIMOAPZD+rYanzUJIDl9T/t0=;
        b=XCvhgk3txQOAOfJYR6/GfktpB+Hu7ghDkKxXolQvbXpGKDu86RIslHtG+266M1QO3Q
         kBqGq0qDm465n56EWPwR317bnLnS4Uq5c0hQf4bnr+zV9dlv1wmaAg2a8UIUadt9bSOd
         uhcAmPunqR9S4xrUwzDhy0BtMCuuc3nvG4l1lF9GkRqtj/dlNWaoZGCctZm54j0esLpV
         dDK7rdmQo+RpdOfMUNaIL/9RkLHsAp4K4GDzJ4F3rV8OFlOKj747KvpaJUXPZY6fZRxu
         GOC2QpcZBGPiBSN2Y/eNNp8y8XvT7S/mV/L7p8pEGDS3A2LNiEATJfAJ0llFNhwkCffb
         NLGA==
X-Gm-Message-State: AOJu0YyKkN3c74LBvGhBZKCiaTBvEwACundEAASd6Wf8kgV97ymExSrk
	+gNoaPaMTCyPbEhSwLDZibVRL5IaPzkwRK4gr6ihywaw0l8ZtbhQlWkRs2eDQi6YHahukiIeT/N
	osb3f81T1FmWhhKBH3UWO2N5jVFCr
X-Received: by 2002:a19:5507:0:b0:50b:d944:c01c with SMTP id n7-20020a195507000000b0050bd944c01cmr120815lfe.222.1701407745185;
        Thu, 30 Nov 2023 21:15:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHDBmetXyWF5RpBUSGtpgeHdSYlEbcjte2vsAB88zgUOH9Pe6a2lbEGXksrcRpWFGOS8rAg498bSWjWs3JsMxo=
X-Received: by 2002:a19:5507:0:b0:50b:d944:c01c with SMTP id
 n7-20020a195507000000b0050bd944c01cmr120809lfe.222.1701407744848; Thu, 30 Nov
 2023 21:15:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230903181338-mutt-send-email-mst@kernel.org>
 <647701d8-c99b-4ca8-9817-137eaefda237@linux.intel.com> <CACGkMEvoGOO0jtq5T7arAjRoB_0_fHB2+hPJe1JsPqcAuvr98w@mail.gmail.com>
 <6f84bbad-62f9-43df-8134-a6836cc3b66c@linux.intel.com> <CACGkMEvtus2BseZec8at6YORO=As1v9r9p=xtZjE1e2i=uhwhA@mail.gmail.com>
 <20231130044045-mutt-send-email-mst@kernel.org>
In-Reply-To: <20231130044045-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 1 Dec 2023 13:15:32 +0800
Message-ID: <CACGkMEuvnmif_pBJRqAER3wuYmF_ebzgRnKwwUnHMH4kv2XrFQ@mail.gmail.com>
Subject: Re: [GIT PULL] virtio: features
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Ning, Hongyu" <hongyu.ning@linux.intel.com>, xuanzhuo@linux.alibaba.com, 
	Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, eperezma@redhat.com, shannon.nelson@amd.com, 
	yuanyaogoog@chromium.org, yuehaibing@huawei.com, 
	kirill.shutemov@linux.intel.com, sathyanarayanan.kuppuswamy@linux.intel.com, 
	alexander.shishkin@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 30, 2023 at 5:44=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Wed, Nov 29, 2023 at 06:20:31PM +0800, Jason Wang wrote:
> > On Wed, Nov 29, 2023 at 6:12=E2=80=AFPM Ning, Hongyu
> > <hongyu.ning@linux.intel.com> wrote:
> > >
> > >
> > > On 2023/11/29 17:16, Jason Wang wrote:
> > > > On Wed, Nov 29, 2023 at 5:05=E2=80=AFPM Ning, Hongyu
> > > > <hongyu.ning@linux.intel.com> wrote:
> > > >>
> > > >>
> > > >>
> > > >> On 2023/9/4 6:13, Michael S. Tsirkin wrote:
> > > >>> The following changes since commit 2dde18cd1d8fac735875f2e4987f11=
817cc0bc2c:
> > > >>>
> > > >>>     Linux 6.5 (2023-08-27 14:49:51 -0700)
> > > >>>
> > > >>> are available in the Git repository at:
> > > >>>
> > > >>>     https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git=
 tags/for_linus
> > > >>>
> > > >>> for you to fetch changes up to 1acfe2c1225899eab5ab724c91b7e1eb28=
81b9ab:
> > > >>>
> > > >>>     virtio_ring: fix avail_wrap_counter in virtqueue_add_packed (=
2023-09-03 18:10:24 -0400)
> > > >>>
> > > >>> ----------------------------------------------------------------
> > > >>> virtio: features
> > > >>>
> > > >>> a small pull request this time around, mostly because the
> > > >>> vduse network got postponed to next relase so we can be sure
> > > >>> we got the security store right.
> > > >>>
> > > >>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > >>>
> > > >>> ----------------------------------------------------------------
> > > >>> Eugenio P=C3=A9rez (4):
> > > >>>         vdpa: add VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK flag
> > > >>>         vdpa: accept VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK backe=
nd feature
> > > >>>         vdpa: add get_backend_features vdpa operation
> > > >>>         vdpa_sim: offer VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK
> > > >>>
> > > >>> Jason Wang (1):
> > > >>>         virtio_vdpa: build affinity masks conditionally
> > > >>>
> > > >>> Xuan Zhuo (12):
> > > >>>         virtio_ring: check use_dma_api before unmap desc for indi=
rect
> > > >>>         virtio_ring: put mapping error check in vring_map_one_sg
> > > >>>         virtio_ring: introduce virtqueue_set_dma_premapped()
> > > >>>         virtio_ring: support add premapped buf
> > > >>>         virtio_ring: introduce virtqueue_dma_dev()
> > > >>>         virtio_ring: skip unmap for premapped
> > > >>>         virtio_ring: correct the expression of the description of=
 virtqueue_resize()
> > > >>>         virtio_ring: separate the logic of reset/enable from virt=
queue_resize
> > > >>>         virtio_ring: introduce virtqueue_reset()
> > > >>>         virtio_ring: introduce dma map api for virtqueue
> > > >>>         virtio_ring: introduce dma sync api for virtqueue
> > > >>>         virtio_net: merge dma operations when filling mergeable b=
uffers
> > > >>
> > > >> Hi,
> > > >> above patch (upstream commit 295525e29a5b) seems causing a virtnet
> > > >> related Call Trace after WARNING from kernel/dma/debug.c.
> > > >>
> > > >> details (log and test setup) tracked in
> > > >> https://bugzilla.kernel.org/show_bug.cgi?id=3D218204
> > > >>
> > > >> it's recently noticed in a TDX guest testing since v6.6.0 release =
cycle
> > > >> and can still be reproduced in latest v6.7.0-rc3.
> > > >>
> > > >> as local bisects results show, above WARNING and Call Trace is lin=
ked
> > > >> with this patch, do you mind to take a look?
> > > >
> > > > Looks like virtqueue_dma_sync_single_range_for_cpu() use
> > > > DMA_BIDIRECTIONAL unconditionally.
> > > >
> > > > We should use dir here.
> > > >
> > > > Mind to try?
> > > >
> > > > Thanks
> > > >
> > >
> > > sure, but what I see in the code
> > > virtqueue_dma_sync_single_range_for_cpu() is using DMA_FROM_DEVICE,
> > > probably I misunderstood your point?
> > >
> > > Please let me know any patch/setting to try here.
> >
> > Something like attached.  (Not even compiling test).
> >
> > Thanks
>
> Forwarding it inline for the record - I am not sure all the
> 0 day machinery handles attachments. Jason given it's reported to work
> can you please repost properly with a full commit log etc?
> I think we also need to fix virtqueue_dma_sync_single_range_for_device -
> please include that too.

Yes, want to sent something like this yesterday but it was interrupted
by other tasks.

I see Xuan has posted a patch, I will ack on that.

Thanks

>
>
> From: Jason Wang <jasowang@redhat.com>
> Date: Wed, 29 Nov 2023 17:14:15 +0800
> Subject: [PATCH] virtio_ring: fix DMA dir during sync
> Content-type: text/plain
>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>
> ---
>  drivers/virtio/virtio_ring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 81ecb29c88f1..91d869814373 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -3220,7 +3220,7 @@ void virtqueue_dma_sync_single_range_for_cpu(struct=
 virtqueue *_vq,
>                 return;
>
>         dma_sync_single_range_for_cpu(dev, addr, offset, size,
> -                                     DMA_BIDIRECTIONAL);
> +                                     dir);
>  }
>  EXPORT_SYMBOL_GPL(virtqueue_dma_sync_single_range_for_cpu);
>
> --
> 2.42.0
>


