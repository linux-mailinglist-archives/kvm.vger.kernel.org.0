Return-Path: <kvm+bounces-23606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D6FF594B8F3
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 10:23:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 30E5B1F20FAB
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 08:23:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A97D81898F5;
	Thu,  8 Aug 2024 08:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IWB/w5kP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547CD18950E
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 08:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723105399; cv=none; b=fKd5Qi8ahfhkqVHJ6C3nbNtAas4RUlc3quAW83LWaTyPryc50Ti7Wfsw7u0UYGzhq7+pup0jmv1N53GXLI4nLzC9V51NPxliB8zClVgy9BcKQJxmimqQhyAumJTQNR8ltwSb+JTrU/wIdSdA1fOxBF73dR/ahyXSG1FD3YvVFtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723105399; c=relaxed/simple;
	bh=rYs0xBw0Gjql2y66a/D5Zjd80I5J6xFemY/YYFHA1vk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N7rs6Upb3IFX4iShgG5O1aVmWPEDVMwFDG2s4yyFTYE0FHFjZdLsdjKbZHVqjGNXGT4t+6tDxIz/QPksT1TIKlzZoclWbk/+XK+VeQ1j0Ngu1H3Fl0Ju6m9ngCtPoQyvI52Y7K9cq0t4yvKfmeCf0yFNWAdfbasEWfL1GfLOgRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IWB/w5kP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723105397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l0A20Uov+OyNtb3al7aHaWJQ9qEXD3mIhigIcXWDeEM=;
	b=IWB/w5kPU4Pb/J6LeHI0gEysc/WI/RB9wxfl0jTLv7AehlbsQz708cMmlAs8srx+OqAOdg
	qDpOwSnOyHjqzQzBrpjWbeZ5x00Rwc16Z0le4GFFR+NPqoeNxkVkic2ZaAiDycDKy32T53
	hms0iyVAoGhL9gyq6tyllD/RBGFuy9s=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-cK2RbdrQPfqgkV1UauxvRQ-1; Thu, 08 Aug 2024 04:23:16 -0400
X-MC-Unique: cK2RbdrQPfqgkV1UauxvRQ-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2d1bc2352e1so711834a91.0
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2024 01:23:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723105393; x=1723710193;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l0A20Uov+OyNtb3al7aHaWJQ9qEXD3mIhigIcXWDeEM=;
        b=mFEnW777mEA1TvKJOJTxBoejs5fUcH8OCVKD1m3KGo4CvouvhM7KKf7CwhzateW3Td
         s3dltmG4zLBZWk6JfnpX7F4j45gt96mV2Dd9ZebpR/xcv+TwTm4FKwovVkHebgl9wu2N
         gkBmWvHuRuVcSyxkq7Fe1otqiXOnh8dfUEFssvEpFbABUUscdzRK+x7cpPui9+nt8krm
         6LJDahUJEivEvYU5vO7z0948qQe5xc0y4eBJCUuFe3tDhBJ28CQQQhZ3tpeRx+mPybNc
         BIm8JeHhEVzyIae1g/Xkc6PUOIZt3R3fMhZfHEYDd2JBmD1lGTI1/MDg1bqphQekv7Zr
         4DJQ==
X-Gm-Message-State: AOJu0YxR+NT/1eWmfpFx7BZvWrx/NGeFXvXKQh94+9BvFmmI4WGgPdkF
	HLUHYeCF2etbKRTENZTo/9lhepBE0JlQQo8eXRx41cNnZgcZP4VRSgoJMUqO8z1yQ7SDzff74Ud
	UtTL8epdYP3+75hWKw0vhwMfyvJtZ40kFRPHBtGrKqZncsC7k2wJA+HJl1AELS2Rqra9q/3ikP1
	7WgNmVVFahI3s8jFNqtWXrdInK
X-Received: by 2002:a17:90a:1101:b0:2c9:63fb:d3ab with SMTP id 98e67ed59e1d1-2d1c516396emr1412640a91.22.1723105392620;
        Thu, 08 Aug 2024 01:23:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHXkUKCyr84JcKtnNjWT4uFvHMb5WKTN4thytsIwauo27ntH/qn52Bv+h4iEAijzx22xOWvDB9gGJpUvf9V5+o=
X-Received: by 2002:a17:90a:1101:b0:2c9:63fb:d3ab with SMTP id
 98e67ed59e1d1-2d1c516396emr1412602a91.22.1723105391894; Thu, 08 Aug 2024
 01:23:11 -0700 (PDT)
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
 <CACGkMEt3Zuv9UcF6YoUgw1UPyHhZCpZufCSejTp6mA6aNVB4oA@mail.gmail.com>
In-Reply-To: <CACGkMEt3Zuv9UcF6YoUgw1UPyHhZCpZufCSejTp6mA6aNVB4oA@mail.gmail.com>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 8 Aug 2024 16:23:00 +0800
Message-ID: <CACGkMEtzmYwoOj7Z0fnDkB+t6HCx+387_VjH0byWcsOxm3thmg@mail.gmail.com>
Subject: Re: [RFC PATCH vhost] vhost-vdpa: Fix invalid irq bypass unregister
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "mst@redhat.com" <mst@redhat.com>, 
	"eperezma@redhat.com" <eperezma@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 8, 2024 at 10:56=E2=80=AFAM Jason Wang <jasowang@redhat.com> wr=
ote:
>
> On Tue, Aug 6, 2024 at 10:45=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.c=
om> wrote:
> >
> >
> >
> > On 06.08.24 10:18, Dragos Tatulea wrote:
> > > (Re-sending. I messed up the previous message, sorry about that.)
> > >
> > > On 06.08.24 04:57, Jason Wang wrote:
> > >> On Mon, Aug 5, 2024 at 11:59=E2=80=AFPM Dragos Tatulea <dtatulea@nvi=
dia.com> wrote:
> > >>>
> > >>> On 05.08.24 05:17, Jason Wang wrote:
> > >>>> On Fri, Aug 2, 2024 at 2:51=E2=80=AFPM Dragos Tatulea <dtatulea@nv=
idia.com> wrote:
> > >>>>>
> > >>>>> On Fri, 2024-08-02 at 11:29 +0800, Jason Wang wrote:
> > >>>>>> On Thu, Aug 1, 2024 at 11:38=E2=80=AFPM Dragos Tatulea <dtatulea=
@nvidia.com> wrote:
> > >>>>>>>
> > >>>>>>> The following workflow triggers the crash referenced below:
> > >>>>>>>
> > >>>>>>> 1) vhost_vdpa_unsetup_vq_irq() unregisters the irq bypass produ=
cer
> > >>>>>>>    but the producer->token is still valid.
> > >>>>>>> 2) vq context gets released and reassigned to another vq.
> > >>>>>>
> > >>>>>> Just to make sure I understand here, which structure is referred=
 to as
> > >>>>>> "vq context" here? I guess it's not call_ctx as it is a part of =
the vq
> > >>>>>> itself.
> > >>>>>>
> > >>>>>>> 3) That other vq registers it's producer with the same vq conte=
xt
> > >>>>>>>    pointer as token in vhost_vdpa_setup_vq_irq().
> > >>>>>>
> > >>>>>> Or did you mean when a single eventfd is shared among different =
vqs?
> > >>>>>>
> > >>>>> Yes, that's what I mean: vq->call_ctx.ctx which is a eventfd_ctx.
> > >>>>>
> > >>>>> But I don't think it's shared in this case, only that the old eve=
ntfd_ctx value
> > >>>>> is lingering in producer->token. And this old eventfd_ctx is assi=
gned now to
> > >>>>> another vq.
> > >>>>
> > >>>> Just to make sure I understand the issue. The eventfd_ctx should b=
e
> > >>>> still valid until a new VHOST_SET_VRING_CALL().
> > >>>>
> > >>> I think it's not about the validity of the eventfd_ctx. More about
> > >>> the lingering ctx value of the producer after vhost_vdpa_unsetup_vq=
_irq().
> > >>
> > >> Probably, but
> > >>
> > >>> That value is the eventfd ctx, but it could be anything else really=
...
> > >>
> > >> I mean we hold a refcnt of the eventfd so it should be valid until t=
he
> > >> next set_vring_call() or vhost_dev_cleanup().
> > >>
> > >> But I do spot some possible issue:
> > >>
> > >> 1) We swap and assign new ctx in vhost_vring_ioctl():
> > >>
> > >>                 swap(ctx, vq->call_ctx.ctx);
> > >>
> > >> 2) and old ctx will be put there as well:
> > >>
> > >>                 if (!IS_ERR_OR_NULL(ctx))
> > >>                         eventfd_ctx_put(ctx);
> > >>
> > >> 3) but in vdpa, we try to unregister the producer with the new token=
:
> > >>
> > >> static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned in=
t cmd,
> > >>                            void __user *argp)
> > >> {
> > >> ...
> > >>         r =3D vhost_vring_ioctl(&v->vdev, cmd, argp);
> > >> ...
> > >>         switch (cmd) {
> > >> ...
> > >>         case VHOST_SET_VRING_CALL:
> > >>                 if (vq->call_ctx.ctx) {
> > >>                         cb.callback =3D vhost_vdpa_virtqueue_cb;
> > >>                         cb.private =3D vq;
> > >>                         cb.trigger =3D vq->call_ctx.ctx;
> > >>                 } else {
> > >>                         cb.callback =3D NULL;
> > >>                         cb.private =3D NULL;
> > >>                         cb.trigger =3D NULL;
> > >>                 }
> > >>                 ops->set_vq_cb(vdpa, idx, &cb);
> > >>                 vhost_vdpa_setup_vq_irq(v, idx);
> > >>
> > >> in vhost_vdpa_setup_vq_irq() we had:
> > >>
> > >>         irq_bypass_unregister_producer(&vq->call_ctx.producer);
> > >>
> > >> here the producer->token still points to the old one...
> > >>
> > >> Is this what you have seen?
> > > Yup. That is the issue. The unregister already happened at
> > > vhost_vdpa_unsetup_vq_irq(). So this second unregister will
> > > work on an already unregistered element due to the token still
> > > being set.
> > >
> > >>
> > >>>
> > >>>
> > >>>> I may miss something but the only way to assign exactly the same
> > >>>> eventfd_ctx value to another vq is where the guest tries to share =
the
> > >>>> MSI-X vector among virtqueues, then qemu will use a single eventfd=
 as
> > >>>> the callback for multiple virtqueues. If this is true:
> > >>>>
> > >>> I don't think this is the case. I see the issue happening when runn=
ing qemu vdpa
> > >>> live migration tests on the same host. From a vdpa device it's basi=
cally a device
> > >>> starting on a VM over and over.
> > >>>
> > >>>> For bypass registering, only the first registering can succeed as =
the
> > >>>> following registering will fail because the irq bypass manager alr=
eady
> > >>>> had exactly the same producer token.
> > >>>> For registering, all unregistering can succeed:
> > >>>>
> > >>>> 1) the first unregistering will do the real job that unregister th=
e token
> > >>>> 2) the following unregistering will do nothing by iterating the
> > >>>> producer token list without finding a match one
> > >>>>
> > >>>> Maybe you can show me the userspace behaviour (ioctls) when you se=
e this?
> > >>>>
> > >>> Sure, what would you need? qemu traces?
> > >>
> > >> Yes, that would be helpful.
> > >>
> > > Will try to get them.
> > As the traces are quite large (~5MB), I uploaded them in this location =
[0].
> > I used the following qemu traces:
> > --trace vhost_vdpa* --trace virtio_net_handle*
> >
> > [0] https://drive.google.com/file/d/1XyXYyockJ_O7zMgI7vot6AxYjze9Ljju/v=
iew?usp=3Dsharing
>
> Thanks for doing this.
>
> So it looks not like a case of eventfd sharing:
>
> """
> 153@1722953531.918958:vhost_vdpa_iotlb_begin_batch vdpa:0x7f6f9cfb5190
> fd: 17 msg_type: 2 type: 5
> 153@1722953531.918959:vhost_vdpa_set_vring_base dev: 0x55573cc9ca70
> index: 6 num: 0 svq 1
> 153@1722953531.918961:vhost_vdpa_set_vring_kick dev: 0x55573cc9ca70
> index: 6 fd: 237
> 153@1722953531.918964:vhost_vdpa_set_vring_call dev: 0x55573cc9ca70
> index: 6 fd: 238
> 153@1722953531.918978:vhost_vdpa_dma_map vdpa:0x7f6f9cfb5190 fd: 17
> msg_type: 2 asid: 1 iova: 0x13000 size: 0x2000 uaddr: 0x7f6f9da1a000
> perm: 0x1 type: 2
> 153@1722953531.918984:vhost_vdpa_dma_map vdpa:0x7f6f9cfb5190 fd: 17
> msg_type: 2 asid: 1 iova: 0x15000 size: 0x1000 uaddr: 0x7f6f9da19000
> perm: 0x3 type: 2
> 153@1722953531.918987:vhost_vdpa_set_vring_addr dev: 0x55573cc9ca70
> index: 6 flags: 0x0 desc_user_addr: 0x13000 used_user_addr: 0x15000
> avail_user_addr: 0x14000 log_guest_\
> addr: 0x0
> 153@1722953531.918989:vhost_vdpa_set_vring_base dev: 0x55573cc9ca70
> index: 7 num: 0 svq 1
> 153@1722953531.918991:vhost_vdpa_set_vring_kick dev: 0x55573cc9ca70
> index: 7 fd: 239
> 153@1722953531.918993:vhost_vdpa_set_vring_call dev: 0x55573cc9ca70
> index: 7 fd: 240
> """
>
> I think a more proper way is to unregister and clean the token before
> calling vhost_vring_ioctl() in the case of SET_VRING_KICK. Let me try
> to draft a patch and see.

I've posted a RFC patch, please try to see if it works.

Thanks

>
> Thanks
>
> >
> > Thanks,
> > Dragos
> >


