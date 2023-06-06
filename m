Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB2E8723480
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 03:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233672AbjFFBaX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 21:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbjFFBaV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 21:30:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB5C109
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 18:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686014976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LO0PcoIQipRUJHYAP4IZqQY6Y4aLmW6KIu9FvB1onCA=;
        b=SbfCjf/BhLm68DtmdtVWQKGTfZA42ZougQdNGNd9m/YwUYw99VJNU5YUcY49loDexsa/Dj
        BqOHfLcDUE0MhkDNrfqfZbNdVrSyV5ndfX5EvmktT8Sa+UnGOccxItiMHxSZzPOkxT0UvU
        DFEQDDNH1fpInc/Q0sHEli96MF1PdUg=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-467-oVHKRYNjM3O5eAUtwr-Vtg-1; Mon, 05 Jun 2023 21:29:35 -0400
X-MC-Unique: oVHKRYNjM3O5eAUtwr-Vtg-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2b1b1693338so26602331fa.3
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 18:29:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686014974; x=1688606974;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LO0PcoIQipRUJHYAP4IZqQY6Y4aLmW6KIu9FvB1onCA=;
        b=Kmk6dEB+UrKw9AwTSCv/4V0q33v0N8mTa6fONezMVdvHnw2nwLlFknC8MzGBEDLjzL
         k8NFpEUZ5/TfD//pz7W03tObtcATT9GNTtceeejcf4nX/PlwAGSY/McGQss/ZBvfnCrc
         CknwOjdaDQ+cjRzqUTsnTXjvaXVMAbtQTjah4ILA7Ibnnrtd1iZ3U5AiEQ+/UPiZPPxl
         eoFqcXxRgij1YLrIqMxeor+TLKxstBawndPLb9daLhMJZRStISUPN1FD4s9Tn0fc/qYF
         Kg6gR32rvK3N2MrgSLjKb5/S7hn+etwCYN9c4j86rC9ynFwvhY/RH2NkwMRWTuj2qwg6
         eZhA==
X-Gm-Message-State: AC+VfDzoajjdwWcB9blzf55gOJMJWyAYZ9FcSx0C8qfK+jnkYtSf1CsP
        hbHYPRbCiErtozDx9Zf+Y2tNegSjswCtWqr5YdXZXYhLYXG0B6FhDYWdw+P4rO0ePQLe3Lrj7Go
        7GDwLoWbp2fDjs4WkCPsnknlA8OWo
X-Received: by 2002:a05:651c:90:b0:2ac:770f:8831 with SMTP id 16-20020a05651c009000b002ac770f8831mr471631ljq.40.1686014974167;
        Mon, 05 Jun 2023 18:29:34 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7q8xwsG2H2HJLbjrNSEB15Tcb4Vhw2h23yOvguszqhRoiFXNx/aA4LQRn2qI/jZv0NF0GvO+g7EwDrFoZVmEY=
X-Received: by 2002:a05:651c:90:b0:2ac:770f:8831 with SMTP id
 16-20020a05651c009000b002ac770f8831mr471619ljq.40.1686014973831; Mon, 05 Jun
 2023 18:29:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230605110644.151211-1-sgarzare@redhat.com> <20230605084104-mutt-send-email-mst@kernel.org>
 <24fjdwp44hovz3d3qkzftmvjie45er3g3boac7aezpvzbwvuol@lmo47ydvnqau>
 <20230605085840-mutt-send-email-mst@kernel.org> <gi2hngx3ndsgz5d2rpqjywdmou5vxhd7xgi5z2lbachr7yoos4@kpifz37oz2et>
 <20230605095404-mutt-send-email-mst@kernel.org> <32ejjuvhvcicv7wjuetkv34qtlpa657n4zlow4eq3fsi2twozk@iqnd2t5tw2an>
In-Reply-To: <32ejjuvhvcicv7wjuetkv34qtlpa657n4zlow4eq3fsi2twozk@iqnd2t5tw2an>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 6 Jun 2023 09:29:22 +0800
Message-ID: <CACGkMEu3PqQ99UoKF5NHgVADD3q=BF6jhLiyumeT4S1QCqN1tw@mail.gmail.com>
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Shannon Nelson <shannon.nelson@amd.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 5, 2023 at 10:58=E2=80=AFPM Stefano Garzarella <sgarzare@redhat=
.com> wrote:
>
> On Mon, Jun 05, 2023 at 09:54:57AM -0400, Michael S. Tsirkin wrote:
> >On Mon, Jun 05, 2023 at 03:30:35PM +0200, Stefano Garzarella wrote:
> >> On Mon, Jun 05, 2023 at 09:00:25AM -0400, Michael S. Tsirkin wrote:
> >> > On Mon, Jun 05, 2023 at 02:54:20PM +0200, Stefano Garzarella wrote:
> >> > > On Mon, Jun 05, 2023 at 08:41:54AM -0400, Michael S. Tsirkin wrote=
:
> >> > > > On Mon, Jun 05, 2023 at 01:06:44PM +0200, Stefano Garzarella wro=
te:
> >> > > > > vhost-vdpa IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET_VRING_B=
ASE)
> >> > > > > don't support packed virtqueue well yet, so let's filter the
> >> > > > > VIRTIO_F_RING_PACKED feature for now in vhost_vdpa_get_feature=
s().
> >> > > > >
> >> > > > > This way, even if the device supports it, we don't risk it bei=
ng
> >> > > > > negotiated, then the VMM is unable to set the vring state prop=
erly.
> >> > > > >
> >> > > > > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> >> > > > > Cc: stable@vger.kernel.org
> >> > > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> >> > > > > ---
> >> > > > >
> >> > > > > Notes:
> >> > > > >     This patch should be applied before the "[PATCH v2 0/3] vh=
ost_vdpa:
> >> > > > >     better PACKED support" series [1] and backported in stable=
 branches.
> >> > > > >
> >> > > > >     We can revert it when we are sure that everything is worki=
ng with
> >> > > > >     packed virtqueues.
> >> > > > >
> >> > > > >     Thanks,
> >> > > > >     Stefano
> >> > > > >
> >> > > > >     [1] https://lore.kernel.org/virtualization/20230424225031.=
18947-1-shannon.nelson@amd.com/
> >> > > >
> >> > > > I'm a bit lost here. So why am I merging "better PACKED support"=
 then?
> >> > >
> >> > > To really support packed virtqueue with vhost-vdpa, at that point =
we would
> >> > > also have to revert this patch.
> >> > >
> >> > > I wasn't sure if you wanted to queue the series for this merge win=
dow.
> >> > > In that case do you think it is better to send this patch only for=
 stable
> >> > > branches?
> >> > > > Does this patch make them a NOP?
> >> > >
> >> > > Yep, after applying the "better PACKED support" series and being
> >> > > sure that
> >> > > the IOCTLs of vhost-vdpa support packed virtqueue, we should rever=
t this
> >> > > patch.
> >> > >
> >> > > Let me know if you prefer a different approach.
> >> > >
> >> > > I'm concerned that QEMU uses vhost-vdpa IOCTLs thinking that the k=
ernel
> >> > > interprets them the right way, when it does not.
> >> > >
> >> > > Thanks,
> >> > > Stefano
> >> > >
> >> >
> >> > If this fixes a bug can you add Fixes tags to each of them? Then it'=
s ok
> >> > to merge in this window. Probably easier than the elaborate
> >> > mask/unmask dance.
> >>
> >> CCing Shannon (the original author of the "better PACKED support"
> >> series).
> >>
> >> IIUC Shannon is going to send a v3 of that series to fix the
> >> documentation, so Shannon can you also add the Fixes tags?
> >>
> >> Thanks,
> >> Stefano
> >
> >Well this is in my tree already. Just reply with
> >Fixes: <>
> >to each and I will add these tags.
>
> I tried, but it is not easy since we added the support for packed
> virtqueue in vdpa and vhost incrementally.
>
> Initially I was thinking of adding the same tag used here:
>
> Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
>
> Then I discovered that vq_state wasn't there, so I was thinking of
>
> Fixes: 530a5678bc00 ("vdpa: support packed virtqueue for set/get_vq_state=
()")
>
> So we would have to backport quite a few patches into the stable branches=
.
> I don't know if it's worth it...
>
> I still think it is better to disable packed in the stable branches,
> otherwise I have to make a list of all the patches we need.
>
> Any other ideas?

AFAIK, except for vp_vdpa, pds seems to be the first parent that
supports packed virtqueue. Users should not notice anything wrong if
they don't use packed virtqueue. And the problem of vp_vdpa + packed
virtqueue came since the day0 of vp_vdpa. It seems fine to do nothing
I guess.

Thanks

>
> Thanks,
> Stefano
>
>

