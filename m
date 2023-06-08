Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C90A07273D0
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 02:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbjFHAnT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 20:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbjFHAnS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 20:43:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EC72685
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 17:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686184950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lEl6t5FZvqqMGtRao10LY7MIqY+vo/3jnIQEpVR8PDs=;
        b=QtBLCN/1XEGU11QzEnC3DgloVrkixo2XC/5fcp79BD7qJMHaBkfYo0i/9QcYnVt78duna8
        aDGhffrgocFw5Y0D16PazbRtJNZC9nflOAPTL77V4QmkGXQoi/tKqw+gPdrUbUJabGrLWR
        Cmz5pJP1LT62NJ8fm0ErdHTcdPbahEw=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-126-l2XmHrEwNx68ZQwIMpd4gw-1; Wed, 07 Jun 2023 20:42:28 -0400
X-MC-Unique: l2XmHrEwNx68ZQwIMpd4gw-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-4ecb00906d0so49067e87.1
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 17:42:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686184947; x=1688776947;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lEl6t5FZvqqMGtRao10LY7MIqY+vo/3jnIQEpVR8PDs=;
        b=HzSSMz3knYjV9ZYBYqKuJL7Dan+HJkIDdp0Nuy3Pz8u18zW6h/NMQEkC37AVGUGXvO
         SMEtdR++TmiPl6AOQBWbM5XHI7b6IM4bFDXS9/rnhGSUGkcaSbgF17RHFRh9kZBExwla
         SKwUAM3kkOxfSW61kg+euNp2TECzqnZwM9pxmNX20w14nNv+tNZKsZYGvGlBHpROUy0R
         S12bWdcUHDKhi3oAmLW+G46Iq4cAlFsqyzIXMH3ry3711vQovKr/UuwIhGQac/6wvOac
         WUuHta2Q/vRqYZiM92WoW4iYjVZq+wigTd4uvfXrVLkSBT8Iu9C2yYQjoRB47c2RK9Dt
         FX0g==
X-Gm-Message-State: AC+VfDzl9b9CpojwBWrrjgSOM3ERrfvR7mYhpdL9X1eAJXGatr9z+T3/
        SZWXwC7oGZYyZRyWxKCAquycL8ukaPIvmZnxqAURc3+kfXWPv0HwtJrO2R2BHQofcnzXFpwuC+5
        BGv/kvbVcUk5Q7haAeUOM8XsrtOaI
X-Received: by 2002:ac2:592b:0:b0:4f2:5ef9:45fb with SMTP id v11-20020ac2592b000000b004f25ef945fbmr2270035lfi.52.1686184947241;
        Wed, 07 Jun 2023 17:42:27 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6Jagu8jFL3Tk7QBl5bX84sKkwXDyc0yqpe5DjC3wP0g8RxkLKVB46KhsINWWUbRs14XNdausmTmzDN1x+iH7M=
X-Received: by 2002:ac2:592b:0:b0:4f2:5ef9:45fb with SMTP id
 v11-20020ac2592b000000b004f25ef945fbmr2270024lfi.52.1686184946912; Wed, 07
 Jun 2023 17:42:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230605110644.151211-1-sgarzare@redhat.com> <20230605084104-mutt-send-email-mst@kernel.org>
 <24fjdwp44hovz3d3qkzftmvjie45er3g3boac7aezpvzbwvuol@lmo47ydvnqau>
 <20230605085840-mutt-send-email-mst@kernel.org> <gi2hngx3ndsgz5d2rpqjywdmou5vxhd7xgi5z2lbachr7yoos4@kpifz37oz2et>
 <20230605095404-mutt-send-email-mst@kernel.org> <32ejjuvhvcicv7wjuetkv34qtlpa657n4zlow4eq3fsi2twozk@iqnd2t5tw2an>
 <CACGkMEu3PqQ99UoKF5NHgVADD3q=BF6jhLiyumeT4S1QCqN1tw@mail.gmail.com>
 <20230606085643-mutt-send-email-mst@kernel.org> <CAGxU2F7fkgL-HpZdj=5ZEGNWcESCHQpgRAYQA3W2sPZaoEpNyQ@mail.gmail.com>
 <20230607054246-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230607054246-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 8 Jun 2023 08:42:15 +0800
Message-ID: <CACGkMEuUapKvUYiJiLwtsN+x941jafDKS9tuSkiNrvkrrSmQkg@mail.gmail.com>
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Shannon Nelson <shannon.nelson@amd.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 7, 2023 at 5:43=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com> =
wrote:
>
> On Wed, Jun 07, 2023 at 10:39:15AM +0200, Stefano Garzarella wrote:
> > On Tue, Jun 6, 2023 at 2:58=E2=80=AFPM Michael S. Tsirkin <mst@redhat.c=
om> wrote:
> > >
> > > On Tue, Jun 06, 2023 at 09:29:22AM +0800, Jason Wang wrote:
> > > > On Mon, Jun 5, 2023 at 10:58=E2=80=AFPM Stefano Garzarella <sgarzar=
e@redhat.com> wrote:
> > > > >
> > > > > On Mon, Jun 05, 2023 at 09:54:57AM -0400, Michael S. Tsirkin wrot=
e:
> > > > > >On Mon, Jun 05, 2023 at 03:30:35PM +0200, Stefano Garzarella wro=
te:
> > > > > >> On Mon, Jun 05, 2023 at 09:00:25AM -0400, Michael S. Tsirkin w=
rote:
> > > > > >> > On Mon, Jun 05, 2023 at 02:54:20PM +0200, Stefano Garzarella=
 wrote:
> > > > > >> > > On Mon, Jun 05, 2023 at 08:41:54AM -0400, Michael S. Tsirk=
in wrote:
> > > > > >> > > > On Mon, Jun 05, 2023 at 01:06:44PM +0200, Stefano Garzar=
ella wrote:
> > > > > >> > > > > vhost-vdpa IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET=
_VRING_BASE)
> > > > > >> > > > > don't support packed virtqueue well yet, so let's filt=
er the
> > > > > >> > > > > VIRTIO_F_RING_PACKED feature for now in vhost_vdpa_get=
_features().
> > > > > >> > > > >
> > > > > >> > > > > This way, even if the device supports it, we don't ris=
k it being
> > > > > >> > > > > negotiated, then the VMM is unable to set the vring st=
ate properly.
> > > > > >> > > > >
> > > > > >> > > > > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based back=
end")
> > > > > >> > > > > Cc: stable@vger.kernel.org
> > > > > >> > > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com=
>
> > > > > >> > > > > ---
> > > > > >> > > > >
> > > > > >> > > > > Notes:
> > > > > >> > > > >     This patch should be applied before the "[PATCH v2=
 0/3] vhost_vdpa:
> > > > > >> > > > >     better PACKED support" series [1] and backported i=
n stable branches.
> > > > > >> > > > >
> > > > > >> > > > >     We can revert it when we are sure that everything =
is working with
> > > > > >> > > > >     packed virtqueues.
> > > > > >> > > > >
> > > > > >> > > > >     Thanks,
> > > > > >> > > > >     Stefano
> > > > > >> > > > >
> > > > > >> > > > >     [1] https://lore.kernel.org/virtualization/2023042=
4225031.18947-1-shannon.nelson@amd.com/
> > > > > >> > > >
> > > > > >> > > > I'm a bit lost here. So why am I merging "better PACKED =
support" then?
> > > > > >> > >
> > > > > >> > > To really support packed virtqueue with vhost-vdpa, at tha=
t point we would
> > > > > >> > > also have to revert this patch.
> > > > > >> > >
> > > > > >> > > I wasn't sure if you wanted to queue the series for this m=
erge window.
> > > > > >> > > In that case do you think it is better to send this patch =
only for stable
> > > > > >> > > branches?
> > > > > >> > > > Does this patch make them a NOP?
> > > > > >> > >
> > > > > >> > > Yep, after applying the "better PACKED support" series and=
 being
> > > > > >> > > sure that
> > > > > >> > > the IOCTLs of vhost-vdpa support packed virtqueue, we shou=
ld revert this
> > > > > >> > > patch.
> > > > > >> > >
> > > > > >> > > Let me know if you prefer a different approach.
> > > > > >> > >
> > > > > >> > > I'm concerned that QEMU uses vhost-vdpa IOCTLs thinking th=
at the kernel
> > > > > >> > > interprets them the right way, when it does not.
> > > > > >> > >
> > > > > >> > > Thanks,
> > > > > >> > > Stefano
> > > > > >> > >
> > > > > >> >
> > > > > >> > If this fixes a bug can you add Fixes tags to each of them? =
Then it's ok
> > > > > >> > to merge in this window. Probably easier than the elaborate
> > > > > >> > mask/unmask dance.
> > > > > >>
> > > > > >> CCing Shannon (the original author of the "better PACKED suppo=
rt"
> > > > > >> series).
> > > > > >>
> > > > > >> IIUC Shannon is going to send a v3 of that series to fix the
> > > > > >> documentation, so Shannon can you also add the Fixes tags?
> > > > > >>
> > > > > >> Thanks,
> > > > > >> Stefano
> > > > > >
> > > > > >Well this is in my tree already. Just reply with
> > > > > >Fixes: <>
> > > > > >to each and I will add these tags.
> > > > >
> > > > > I tried, but it is not easy since we added the support for packed
> > > > > virtqueue in vdpa and vhost incrementally.
> > > > >
> > > > > Initially I was thinking of adding the same tag used here:
> > > > >
> > > > > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> > > > >
> > > > > Then I discovered that vq_state wasn't there, so I was thinking o=
f
> > > > >
> > > > > Fixes: 530a5678bc00 ("vdpa: support packed virtqueue for set/get_=
vq_state()")
> > > > >
> > > > > So we would have to backport quite a few patches into the stable =
branches.
> > > > > I don't know if it's worth it...
> > > > >
> > > > > I still think it is better to disable packed in the stable branch=
es,
> > > > > otherwise I have to make a list of all the patches we need.
> > > > >
> > > > > Any other ideas?
> > > >
> > > > AFAIK, except for vp_vdpa, pds seems to be the first parent that
> > > > supports packed virtqueue. Users should not notice anything wrong i=
f
> > > > they don't use packed virtqueue. And the problem of vp_vdpa + packe=
d
> > > > virtqueue came since the day0 of vp_vdpa. It seems fine to do nothi=
ng
> > > > I guess.
> > > >
> > > > Thanks
> > >
> > >
> > > I have a question though, what if down the road there
> > > is a new feature that needs more changes? It will be
> > > broken too just like PACKED no?
> > > Shouldn't vdpa have an allowlist of features it knows how
> > > to support?
> >
> > It looks like we had it, but we took it out (by the way, we were
> > enabling packed even though we didn't support it):
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D6234f80574d7569444d8718355fa2838e92b158b
> >
> > The only problem I see is that for each new feature we have to modify
> > the kernel.
> > Could we have new features that don't require handling by vhost-vdpa?
> >
> > Thanks,
> > Stefano
>
> Jason what do you say to reverting this?

I may miss something but I don't see any problem with vDPA core.

It's the duty of the parents to advertise the features it has. For example,

1) If some kernel version that is packed is not supported via
set_vq_state, parents should not advertise PACKED features in this
case.
2) If the kernel has support packed set_vq_state(), but it's emulated
cvq doesn't support, parents should not advertise PACKED as well

If a parent violates the above 2, it looks like a bug of the parents.

Thanks

>
> --
> MST
>

