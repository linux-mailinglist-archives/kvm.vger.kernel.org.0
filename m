Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12CF674AEB7
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 12:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbjGGK1Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 06:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjGGK1V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 06:27:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564611B6
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 03:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688725593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l9uA3+6C8czFWrHbeU5PWZu0llUuglU6MsiOJc1L2uI=;
        b=U+jHinJXfZLXxbTY52/vI5MPAkGIPqiZux8txWSeXmbi4IhEaQEs5NlZoguUrRSyTok56W
        k3XfGDkFdTpgsRcjRho8jPKpn035pVE6CMFtncKUV+n+0davGsivtwZ+uQDbpc5m9+YisF
        urjWb7yHlISuui/J/okDNebRD57+phk=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-215-ETRLWMhiOzKyFf9n1N-_cw-1; Fri, 07 Jul 2023 06:26:31 -0400
X-MC-Unique: ETRLWMhiOzKyFf9n1N-_cw-1
Received: by mail-yb1-f197.google.com with SMTP id 3f1490d57ef6-c5fc972760eso1734122276.1
        for <kvm@vger.kernel.org>; Fri, 07 Jul 2023 03:26:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688725591; x=1691317591;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l9uA3+6C8czFWrHbeU5PWZu0llUuglU6MsiOJc1L2uI=;
        b=ejHpD9ID2+4B80LrHSFmjyU1kxWzUfS/SiSSSzFNNTJg26pIVqpoTD7yHk19MDYLrX
         qlZM37cva+gpyAZm5M/b+VKtwaJzC7rSM/8Yqfxse+waH2A8XMEd0f6VVJdbmvhsLPdZ
         AebgMZ5mYupE8ZPhqmZ8h13cu99h1z0ddtuNVs0rXtkXySsZAO9ZoI+G32dyg/KLlL5k
         YpzzszE9QZDszaKozal1GZXHfRfaWZxrnS9cxfmo2c1zEH26bl/g7nAGspq0lM/8tzt2
         Lr7TRH1LAiyh/SL5hJXgTR2VTTFkrbJYjU15e3RDRuirzSFxgijbZEcSjx70dc0mrOZL
         084A==
X-Gm-Message-State: ABy/qLbIhrZA2fLSIjsfzgRiso9WPiqLtF3sPu4cm6O0kE3k3eU/mdhn
        Nzb7Aj39MIc1ahhD9UCbrfrgJq2NV8dk7uE+U/GO/UN533fAQG2GXV+4UGkF9kz6exNqHlDXVA2
        7i+JY/CNDi9QAbRYxMjK+qEVNnQeH
X-Received: by 2002:a25:9d0d:0:b0:c5e:168c:72f8 with SMTP id i13-20020a259d0d000000b00c5e168c72f8mr3816546ybp.31.1688725590997;
        Fri, 07 Jul 2023 03:26:30 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHFfR+HB16RaNn8E06+qB/HUi3xKPCzbR0jJx4SJpdKzJsTRsNQo/dOxZKtprgsX1KxB9yKeDaDkO95DqxRmpI=
X-Received: by 2002:a25:9d0d:0:b0:c5e:168c:72f8 with SMTP id
 i13-20020a259d0d000000b00c5e168c72f8mr3816533ybp.31.1688725590714; Fri, 07
 Jul 2023 03:26:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230703142218.362549-1-eperezma@redhat.com> <20230703105022-mutt-send-email-mst@kernel.org>
 <CAJaqyWf2F_yBLBjj1RiPeJ92_zfq8BSMz8Pak2Vg6QinN8jS1Q@mail.gmail.com>
 <20230704063646-mutt-send-email-mst@kernel.org> <CAJaqyWfdPpkD5pY4tfzQdOscLBcrDBhBqzWjMbY_ZKsoyiqGdA@mail.gmail.com>
 <20230704114159-mutt-send-email-mst@kernel.org> <CACGkMEtWjOMtsbgQ2sx=e1BkuRSyDmVfXDccCm-QSiSbacQyCA@mail.gmail.com>
 <20230705043940-mutt-send-email-mst@kernel.org> <CACGkMEufNZGvWMN9Shh6NPOZOe-vf0RomfS1DX6DtxJjvO7fNA@mail.gmail.com>
 <CAJaqyWcqNkzJXxsoz_Lk_X0CvNW24Ay2Ki6q02EB8iR=qpwsfg@mail.gmail.com>
 <CACGkMEvDsZcyTDBhS8ekXHyv-kiipyHizewpM2+=0XgSYMsmbw@mail.gmail.com>
 <CACGkMEuKNXCSWWqDTZQpogHqT1K=rsQMFAYxL6OC8OL=XeU3-g@mail.gmail.com>
 <CAJaqyWdv_DFdxghHQPoUE4KZ7pqmaR__=JyHFONRuard3KBtSQ@mail.gmail.com> <CACGkMEsv3vyupAbmiq=MtQozq_7O=JKok9sB-Ka9A2PdEgNLag@mail.gmail.com>
In-Reply-To: <CACGkMEsv3vyupAbmiq=MtQozq_7O=JKok9sB-Ka9A2PdEgNLag@mail.gmail.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 7 Jul 2023 12:25:54 +0200
Message-ID: <CAJaqyWfLFGGZa2Ue=n4cD3z329_z1p8Vr9X_ceBn+eBQ6LyjQw@mail.gmail.com>
Subject: Re: [PATCH] vdpa: reject F_ENABLE_AFTER_DRIVER_OK if backend does not
 support it
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Shannon Nelson <shannon.nelson@amd.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 7, 2023 at 9:57=E2=80=AFAM Jason Wang <jasowang@redhat.com> wro=
te:
>
> On Thu, Jul 6, 2023 at 5:39=E2=80=AFPM Eugenio Perez Martin <eperezma@red=
hat.com> wrote:
> >
> > On Thu, Jul 6, 2023 at 10:03=E2=80=AFAM Jason Wang <jasowang@redhat.com=
> wrote:
> > >
> > > On Thu, Jul 6, 2023 at 3:55=E2=80=AFPM Jason Wang <jasowang@redhat.co=
m> wrote:
> > > >
> > > > On Thu, Jul 6, 2023 at 3:06=E2=80=AFPM Eugenio Perez Martin <eperez=
ma@redhat.com> wrote:
> > > > >
> > > > > On Thu, Jul 6, 2023 at 3:55=E2=80=AFAM Jason Wang <jasowang@redha=
t.com> wrote:
> > > > > >
> > > > > > On Wed, Jul 5, 2023 at 4:41=E2=80=AFPM Michael S. Tsirkin <mst@=
redhat.com> wrote:
> > > > > > >
> > > > > > > On Wed, Jul 05, 2023 at 03:49:58PM +0800, Jason Wang wrote:
> > > > > > > > On Tue, Jul 4, 2023 at 11:45=E2=80=AFPM Michael S. Tsirkin =
<mst@redhat.com> wrote:
> > > > > > > > >
> > > > > > > > > On Tue, Jul 04, 2023 at 01:36:11PM +0200, Eugenio Perez M=
artin wrote:
> > > > > > > > > > On Tue, Jul 4, 2023 at 12:38=E2=80=AFPM Michael S. Tsir=
kin <mst@redhat.com> wrote:
> > > > > > > > > > >
> > > > > > > > > > > On Tue, Jul 04, 2023 at 12:25:32PM +0200, Eugenio Per=
ez Martin wrote:
> > > > > > > > > > > > On Mon, Jul 3, 2023 at 4:52=E2=80=AFPM Michael S. T=
sirkin <mst@redhat.com> wrote:
> > > > > > > > > > > > >
> > > > > > > > > > > > > On Mon, Jul 03, 2023 at 04:22:18PM +0200, Eugenio=
 P=C3=A9rez wrote:
> > > > > > > > > > > > > > With the current code it is accepted as long as=
 userland send it.
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > Although userland should not set a feature flag=
 that has not been
> > > > > > > > > > > > > > offered to it with VHOST_GET_BACKEND_FEATURES, =
the current code will not
> > > > > > > > > > > > > > complain for it.
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > Since there is no specific reason for any paren=
t to reject that backend
> > > > > > > > > > > > > > feature bit when it has been proposed, let's co=
ntrol it at vdpa frontend
> > > > > > > > > > > > > > level. Future patches may move this control to =
the parent driver.
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > Fixes: 967800d2d52e ("vdpa: accept VHOST_BACKEN=
D_F_ENABLE_AFTER_DRIVER_OK backend feature")
> > > > > > > > > > > > > > Signed-off-by: Eugenio P=C3=A9rez <eperezma@red=
hat.com>
> > > > > > > > > > > > >
> > > > > > > > > > > > > Please do send v3. And again, I don't want to sen=
d "after driver ok" hack
> > > > > > > > > > > > > upstream at all, I merged it in next just to give=
 it some testing.
> > > > > > > > > > > > > We want RING_ACCESS_AFTER_KICK or some such.
> > > > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > > Current devices do not support that semantic.
> > > > > > > > > > >
> > > > > > > > > > > Which devices specifically access the ring after DRIV=
ER_OK but before
> > > > > > > > > > > a kick?
> > > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > Previous versions of the QEMU LM series did a spurious =
kick to start
> > > > > > > > > > traffic at the LM destination [1]. When it was proposed=
, that spurious
> > > > > > > > > > kick was removed from the series because to check for d=
escriptors
> > > > > > > > > > after driver_ok, even without a kick, was considered wo=
rk of the
> > > > > > > > > > parent driver.
> > > > > > > > > >
> > > > > > > > > > I'm ok to go back to this spurious kick, but I'm not su=
re if the hw
> > > > > > > > > > will read the ring before the kick actually. I can ask.
> > > > > > > > > >
> > > > > > > > > > Thanks!
> > > > > > > > > >
> > > > > > > > > > [1] https://lists.nongnu.org/archive/html/qemu-devel/20=
23-01/msg02775.html
> > > > > > > > >
> > > > > > > > > Let's find out. We need to check for ENABLE_AFTER_DRIVER_=
OK too, no?
> > > > > > > >
> > > > > > > > My understanding is [1] assuming ACCESS_AFTER_KICK. This se=
ems
> > > > > > > > sub-optimal than assuming ENABLE_AFTER_DRIVER_OK.
> > > > > > > >
> > > > > > > > But this reminds me one thing, as the thread is going too l=
ong, I
> > > > > > > > wonder if we simply assume ENABLE_AFTER_DRIVER_OK if RING_R=
ESET is
> > > > > > > > supported?
> > > > > > > >
> > > > > > > > Thanks
> > > > > > >
> > > > > > > I don't see what does one have to do with another ...
> > > > > > >
> > > > > > > I think with RING_RESET we had another solution, enable rings
> > > > > > > mapping them to a zero page, then reset and re-enable later.
> > > > > >
> > > > > > As discussed before, this seems to have some problems:
> > > > > >
> > > > > > 1) The behaviour is not clarified in the document
> > > > > > 2) zero is a valid IOVA
> > > > > >
> > > > >
> > > > > I think we're not on the same page here.
> > > > >
> > > > > As I understood, rings mapped to a zero page means essentially an
> > > > > avail ring whose avail_idx is always 0, offered to the device ins=
tead
> > > > > of the guest's ring. Once all CVQ commands are processed, we use
> > > > > RING_RESET to switch to the right ring, being guest's or SVQ vrin=
g.
> > > >
> > > > I get this. This seems more complicated in the destination: shadow =
vq + ASID?
> > >
> > > So it's something like:
> > >
> > > 1) set all vq ASID to shadow virtqueue
> > > 2) do not add any bufs to data qp (stick 0 as avail index)
> > > 3) start to restore states via cvq
> > > 4) ring_rest for dataqp
> > > 5) set_vq_state for dataqp
> > > 6) re-initialize dataqp address etc
> > > 7) set data QP ASID to guest
> > > 8) set queue_enable
> > >
> > > ?
> > >
> >
> > I think the change of ASID is not needed, as the guest cannot access
> > the device in that timeframe anyway.
>
> Yes but after the restore, we still want to shadow cvq, so ASID is still =
needed?
>

Device or parent driver support for ASID is needed to shadow only CVQ.
Bue the device may not support the switch of ASID after DRIVER_OK.

Since dataplane can go in passthrough ASID all the time, we don't need
to switch it after DRIVER_OK.

> Thanks
>
> > Moreover, it may require HW
> > support. So steps 1 and 7 are not needed.
> >
> > Apart from that, the process is right.
> >
> >
> > > Thanks
> > >
> > > >
> > > > Thanks
> > > >
> > > > >
> > > > >
> > > > >
> > > > > > Thanks
> > > > > >
> > > > > > >
> > > > > > > > >
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > > > > My plan was to convert
> > > > > > > > > > > > it in vp_vdpa if needed, and reuse the current vdpa=
 ops. Sorry if I
> > > > > > > > > > > > was not explicit enough.
> > > > > > > > > > > >
> > > > > > > > > > > > The only solution I can see to that is to trap & em=
ulate in the vdpa
> > > > > > > > > > > > (parent?) driver, as talked in virtio-comment. But =
that complicates
> > > > > > > > > > > > the architecture:
> > > > > > > > > > > > * Offer VHOST_BACKEND_F_RING_ACCESS_AFTER_KICK
> > > > > > > > > > > > * Store vq enable state separately, at
> > > > > > > > > > > > vdpa->config->set_vq_ready(true), but not transmit =
that enable to hw
> > > > > > > > > > > > * Store the doorbell state separately, but do not c=
onfigure it to the
> > > > > > > > > > > > device directly.
> > > > > > > > > > > >
> > > > > > > > > > > > But how to recover if the device cannot configure t=
hem at kick time,
> > > > > > > > > > > > for example?
> > > > > > > > > > > >
> > > > > > > > > > > > Maybe we can just fail if the parent driver does no=
t support enabling
> > > > > > > > > > > > the vq after DRIVER_OK? That way no new feature fla=
g is needed.
> > > > > > > > > > > >
> > > > > > > > > > > > Thanks!
> > > > > > > > > > > >
> > > > > > > > > > > > >
> > > > > > > > > > > > > > ---
> > > > > > > > > > > > > > Sent with Fixes: tag pointing to git.kernel.org=
/pub/scm/linux/kernel/git/mst
> > > > > > > > > > > > > > commit. Please let me know if I should send a v=
3 of [1] instead.
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > [1] https://lore.kernel.org/lkml/20230609121244=
-mutt-send-email-mst@kernel.org/T/
> > > > > > > > > > > > > > ---
> > > > > > > > > > > > > >  drivers/vhost/vdpa.c | 7 +++++--
> > > > > > > > > > > > > >  1 file changed, 5 insertions(+), 2 deletions(-=
)
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > diff --git a/drivers/vhost/vdpa.c b/drivers/vho=
st/vdpa.c
> > > > > > > > > > > > > > index e1abf29fed5b..a7e554352351 100644
> > > > > > > > > > > > > > --- a/drivers/vhost/vdpa.c
> > > > > > > > > > > > > > +++ b/drivers/vhost/vdpa.c
> > > > > > > > > > > > > > @@ -681,18 +681,21 @@ static long vhost_vdpa_un=
locked_ioctl(struct file *filep,
> > > > > > > > > > > > > >  {
> > > > > > > > > > > > > >       struct vhost_vdpa *v =3D filep->private_d=
ata;
> > > > > > > > > > > > > >       struct vhost_dev *d =3D &v->vdev;
> > > > > > > > > > > > > > +     const struct vdpa_config_ops *ops =3D v->=
vdpa->config;
> > > > > > > > > > > > > >       void __user *argp =3D (void __user *)arg;
> > > > > > > > > > > > > >       u64 __user *featurep =3D argp;
> > > > > > > > > > > > > > -     u64 features;
> > > > > > > > > > > > > > +     u64 features, parent_features =3D 0;
> > > > > > > > > > > > > >       long r =3D 0;
> > > > > > > > > > > > > >
> > > > > > > > > > > > > >       if (cmd =3D=3D VHOST_SET_BACKEND_FEATURES=
) {
> > > > > > > > > > > > > >               if (copy_from_user(&features, fea=
turep, sizeof(features)))
> > > > > > > > > > > > > >                       return -EFAULT;
> > > > > > > > > > > > > > +             if (ops->get_backend_features)
> > > > > > > > > > > > > > +                     parent_features =3D ops->=
get_backend_features(v->vdpa);
> > > > > > > > > > > > > >               if (features & ~(VHOST_VDPA_BACKE=
ND_FEATURES |
> > > > > > > > > > > > > >                                BIT_ULL(VHOST_BA=
CKEND_F_SUSPEND) |
> > > > > > > > > > > > > >                                BIT_ULL(VHOST_BA=
CKEND_F_RESUME) |
> > > > > > > > > > > > > > -                              BIT_ULL(VHOST_BA=
CKEND_F_ENABLE_AFTER_DRIVER_OK)))
> > > > > > > > > > > > > > +                              parent_features)=
)
> > > > > > > > > > > > > >                       return -EOPNOTSUPP;
> > > > > > > > > > > > > >               if ((features & BIT_ULL(VHOST_BAC=
KEND_F_SUSPEND)) &&
> > > > > > > > > > > > > >                    !vhost_vdpa_can_suspend(v))
> > > > > > > > > > > > > > --
> > > > > > > > > > > > > > 2.39.3
> > > > > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > >
> > > > > > >
> > > > > >
> > > > >
> > >
> >
>

