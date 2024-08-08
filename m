Return-Path: <kvm+bounces-23593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7E5194B53E
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 04:57:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94A93284C76
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 02:57:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D507533999;
	Thu,  8 Aug 2024 02:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bD3GPTWP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A04B2A1D7
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 02:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723085834; cv=none; b=Z0O+ZW/XYR8LdxOEJDfBw4Ktl0iQH+igSWEBC5c8KVBPbqRcM64cUl8AqvUNi3MHwYClBbP1i8drEUjl+kqJ3/tnoKGcZCXtEHgAavAT5FPToAQBi2saNRyZWMWsVZdqRuO5CF3WBgJubRPhhU36zqFIeoPfQXierSdjgF19aMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723085834; c=relaxed/simple;
	bh=A7MOeA3UL/op8WV3k7OjWeb7EkBqbSKTQqT0eNN45Js=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U6pZkgVzdJJ2NiLyLCea7V4y/QJAFDtFr7H1UA7X1liJLAph6qkaDFWjQozc8MQmHukQqKqXU5daqNj/VJXTRKC7yn7bSNkjCTho7dKjqKLrzavvph0Rv+OGpSFUQe3yCPUDm0p64kXJh8vHtKNxB6NT42O0oLWRt6huAE3AfLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bD3GPTWP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723085830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ae0DB/1sQCe1W+1yx9i6v3XKM9QebP5sAVrnebmOqZ4=;
	b=bD3GPTWPbb/frCEIzSHJVRxXerfK0qkY/B59y4OeEGinqQV9rpRd0AqVJmXZ5jlm7zUFa4
	GmkIUZEyslm/Y+aezN+k3DOZAnr65cB+0nOBMMDaKdZCAc8gHrXfZbiP3XR1mIc4ZZzbqr
	nXNOgviM8I53eCTbpGW8A7W/VgKpj80=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-I9XXzzdrMAWjsJwgCyqLoA-1; Wed, 07 Aug 2024 22:57:09 -0400
X-MC-Unique: I9XXzzdrMAWjsJwgCyqLoA-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2cb5847ff53so730594a91.2
        for <kvm@vger.kernel.org>; Wed, 07 Aug 2024 19:57:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723085828; x=1723690628;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ae0DB/1sQCe1W+1yx9i6v3XKM9QebP5sAVrnebmOqZ4=;
        b=dm+v8LKF7gAPEuLo9AIGnqt512uLnEm71GMQnZbqSR3Nrc6tSqbWKYiCe4is2paLal
         5ypRdYZ/DxpSa/QS/mOy+TAXlJYcsA6btwITovGnGnZcQWa8RApuHUemMsADXn46+yrO
         f324WsT01n2LSN8z+6qu7pPNnNago0xRTPBpqiLajj5OX9XejrVmKdIigloXBO4kV9qk
         6XNxobuPjIaMA7N6z3UZHhPj/lZFtRFredo7MX9tYwDbmQWHmx1/GkL9cpdweOHWML/M
         vkiLqhV5aXUOwMVb9VCmj4G9kz1vunnMsXzlG1Ws+0y2KPL0f8Tdgett8bAfUjrZP2Xi
         jm6A==
X-Gm-Message-State: AOJu0Yz0ROsyeLbvbjkE2zGaAzixAQaC3ANSFq9RWRc2rrsoj8O7YaN1
	kw7WsWq6wzizOy23RYjYokzA/kfwY7P6U+8yp9iiR9wRInH2F3FMCJ0L3Ygsdw9VcI+pjIAwiAe
	RwRItBsf7tZVjNqvG0tvZ8c3eWfVZgSy3s1HK9aENcaBFRC2qjxuCKvev/+VulDxuY7iDZxKVZ4
	SRNvSGYXPhZfwqNmgEOQUHnk+a
X-Received: by 2002:a17:90a:d902:b0:2cd:2992:e8e5 with SMTP id 98e67ed59e1d1-2d1c347b7cemr653884a91.33.1723085828033;
        Wed, 07 Aug 2024 19:57:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGQ6JTZ0RtS1Dyd7BEfalQbLVIcX0tMFw7LvwpP2rWuDcd5abCtSZR6T/OTg7PYtj1F6XOJF/zOHLeUF1RAkGw=
X-Received: by 2002:a17:90a:d902:b0:2cd:2992:e8e5 with SMTP id
 98e67ed59e1d1-2d1c347b7cemr653866a91.33.1723085827386; Wed, 07 Aug 2024
 19:57:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240801153722.191797-2-dtatulea@nvidia.com> <CACGkMEutqWK+N+yddiTsnVW+ZDwyM+EV-gYC8WHHPpjiDzY4_w@mail.gmail.com>
 <51e9ed8f37a1b5fbee9603905b925aedec712131.camel@nvidia.com>
 <CACGkMEuHECjNVEu=QhMDCc5xT_ajaETqAxNFPfb2-_wRwgvyrA@mail.gmail.com>
 <cc771916-62fe-4f6b-88d2-9c17dff65523@nvidia.com> <CACGkMEvPNvdhYmAofP5Xoqf7mPZ97Sv2EaooyEtZVBoGuA-8vA@mail.gmail.com>
 <b603ff51-88d6-4066-aafa-64a60335db37@nvidia.com> <69850046-6b14-4910-9a89-cca8305c1bb9@nvidia.com>
In-Reply-To: <69850046-6b14-4910-9a89-cca8305c1bb9@nvidia.com>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 8 Aug 2024 10:56:55 +0800
Message-ID: <CACGkMEt3Zuv9UcF6YoUgw1UPyHhZCpZufCSejTp6mA6aNVB4oA@mail.gmail.com>
Subject: Re: [RFC PATCH vhost] vhost-vdpa: Fix invalid irq bypass unregister
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "mst@redhat.com" <mst@redhat.com>, 
	"eperezma@redhat.com" <eperezma@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 6, 2024 at 10:45=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
>
>
> On 06.08.24 10:18, Dragos Tatulea wrote:
> > (Re-sending. I messed up the previous message, sorry about that.)
> >
> > On 06.08.24 04:57, Jason Wang wrote:
> >> On Mon, Aug 5, 2024 at 11:59=E2=80=AFPM Dragos Tatulea <dtatulea@nvidi=
a.com> wrote:
> >>>
> >>> On 05.08.24 05:17, Jason Wang wrote:
> >>>> On Fri, Aug 2, 2024 at 2:51=E2=80=AFPM Dragos Tatulea <dtatulea@nvid=
ia.com> wrote:
> >>>>>
> >>>>> On Fri, 2024-08-02 at 11:29 +0800, Jason Wang wrote:
> >>>>>> On Thu, Aug 1, 2024 at 11:38=E2=80=AFPM Dragos Tatulea <dtatulea@n=
vidia.com> wrote:
> >>>>>>>
> >>>>>>> The following workflow triggers the crash referenced below:
> >>>>>>>
> >>>>>>> 1) vhost_vdpa_unsetup_vq_irq() unregisters the irq bypass produce=
r
> >>>>>>>    but the producer->token is still valid.
> >>>>>>> 2) vq context gets released and reassigned to another vq.
> >>>>>>
> >>>>>> Just to make sure I understand here, which structure is referred t=
o as
> >>>>>> "vq context" here? I guess it's not call_ctx as it is a part of th=
e vq
> >>>>>> itself.
> >>>>>>
> >>>>>>> 3) That other vq registers it's producer with the same vq context
> >>>>>>>    pointer as token in vhost_vdpa_setup_vq_irq().
> >>>>>>
> >>>>>> Or did you mean when a single eventfd is shared among different vq=
s?
> >>>>>>
> >>>>> Yes, that's what I mean: vq->call_ctx.ctx which is a eventfd_ctx.
> >>>>>
> >>>>> But I don't think it's shared in this case, only that the old event=
fd_ctx value
> >>>>> is lingering in producer->token. And this old eventfd_ctx is assign=
ed now to
> >>>>> another vq.
> >>>>
> >>>> Just to make sure I understand the issue. The eventfd_ctx should be
> >>>> still valid until a new VHOST_SET_VRING_CALL().
> >>>>
> >>> I think it's not about the validity of the eventfd_ctx. More about
> >>> the lingering ctx value of the producer after vhost_vdpa_unsetup_vq_i=
rq().
> >>
> >> Probably, but
> >>
> >>> That value is the eventfd ctx, but it could be anything else really..=
.
> >>
> >> I mean we hold a refcnt of the eventfd so it should be valid until the
> >> next set_vring_call() or vhost_dev_cleanup().
> >>
> >> But I do spot some possible issue:
> >>
> >> 1) We swap and assign new ctx in vhost_vring_ioctl():
> >>
> >>                 swap(ctx, vq->call_ctx.ctx);
> >>
> >> 2) and old ctx will be put there as well:
> >>
> >>                 if (!IS_ERR_OR_NULL(ctx))
> >>                         eventfd_ctx_put(ctx);
> >>
> >> 3) but in vdpa, we try to unregister the producer with the new token:
> >>
> >> static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int =
cmd,
> >>                            void __user *argp)
> >> {
> >> ...
> >>         r =3D vhost_vring_ioctl(&v->vdev, cmd, argp);
> >> ...
> >>         switch (cmd) {
> >> ...
> >>         case VHOST_SET_VRING_CALL:
> >>                 if (vq->call_ctx.ctx) {
> >>                         cb.callback =3D vhost_vdpa_virtqueue_cb;
> >>                         cb.private =3D vq;
> >>                         cb.trigger =3D vq->call_ctx.ctx;
> >>                 } else {
> >>                         cb.callback =3D NULL;
> >>                         cb.private =3D NULL;
> >>                         cb.trigger =3D NULL;
> >>                 }
> >>                 ops->set_vq_cb(vdpa, idx, &cb);
> >>                 vhost_vdpa_setup_vq_irq(v, idx);
> >>
> >> in vhost_vdpa_setup_vq_irq() we had:
> >>
> >>         irq_bypass_unregister_producer(&vq->call_ctx.producer);
> >>
> >> here the producer->token still points to the old one...
> >>
> >> Is this what you have seen?
> > Yup. That is the issue. The unregister already happened at
> > vhost_vdpa_unsetup_vq_irq(). So this second unregister will
> > work on an already unregistered element due to the token still
> > being set.
> >
> >>
> >>>
> >>>
> >>>> I may miss something but the only way to assign exactly the same
> >>>> eventfd_ctx value to another vq is where the guest tries to share th=
e
> >>>> MSI-X vector among virtqueues, then qemu will use a single eventfd a=
s
> >>>> the callback for multiple virtqueues. If this is true:
> >>>>
> >>> I don't think this is the case. I see the issue happening when runnin=
g qemu vdpa
> >>> live migration tests on the same host. From a vdpa device it's basica=
lly a device
> >>> starting on a VM over and over.
> >>>
> >>>> For bypass registering, only the first registering can succeed as th=
e
> >>>> following registering will fail because the irq bypass manager alrea=
dy
> >>>> had exactly the same producer token.
> >>>> For registering, all unregistering can succeed:
> >>>>
> >>>> 1) the first unregistering will do the real job that unregister the =
token
> >>>> 2) the following unregistering will do nothing by iterating the
> >>>> producer token list without finding a match one
> >>>>
> >>>> Maybe you can show me the userspace behaviour (ioctls) when you see =
this?
> >>>>
> >>> Sure, what would you need? qemu traces?
> >>
> >> Yes, that would be helpful.
> >>
> > Will try to get them.
> As the traces are quite large (~5MB), I uploaded them in this location [0=
].
> I used the following qemu traces:
> --trace vhost_vdpa* --trace virtio_net_handle*
>
> [0] https://drive.google.com/file/d/1XyXYyockJ_O7zMgI7vot6AxYjze9Ljju/vie=
w?usp=3Dsharing

Thanks for doing this.

So it looks not like a case of eventfd sharing:

"""
153@1722953531.918958:vhost_vdpa_iotlb_begin_batch vdpa:0x7f6f9cfb5190
fd: 17 msg_type: 2 type: 5
153@1722953531.918959:vhost_vdpa_set_vring_base dev: 0x55573cc9ca70
index: 6 num: 0 svq 1
153@1722953531.918961:vhost_vdpa_set_vring_kick dev: 0x55573cc9ca70
index: 6 fd: 237
153@1722953531.918964:vhost_vdpa_set_vring_call dev: 0x55573cc9ca70
index: 6 fd: 238
153@1722953531.918978:vhost_vdpa_dma_map vdpa:0x7f6f9cfb5190 fd: 17
msg_type: 2 asid: 1 iova: 0x13000 size: 0x2000 uaddr: 0x7f6f9da1a000
perm: 0x1 type: 2
153@1722953531.918984:vhost_vdpa_dma_map vdpa:0x7f6f9cfb5190 fd: 17
msg_type: 2 asid: 1 iova: 0x15000 size: 0x1000 uaddr: 0x7f6f9da19000
perm: 0x3 type: 2
153@1722953531.918987:vhost_vdpa_set_vring_addr dev: 0x55573cc9ca70
index: 6 flags: 0x0 desc_user_addr: 0x13000 used_user_addr: 0x15000
avail_user_addr: 0x14000 log_guest_\
addr: 0x0
153@1722953531.918989:vhost_vdpa_set_vring_base dev: 0x55573cc9ca70
index: 7 num: 0 svq 1
153@1722953531.918991:vhost_vdpa_set_vring_kick dev: 0x55573cc9ca70
index: 7 fd: 239
153@1722953531.918993:vhost_vdpa_set_vring_call dev: 0x55573cc9ca70
index: 7 fd: 240
"""

I think a more proper way is to unregister and clean the token before
calling vhost_vring_ioctl() in the case of SET_VRING_KICK. Let me try
to draft a patch and see.

Thanks

>
> Thanks,
> Dragos
>


