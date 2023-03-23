Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02DD26C69C5
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 14:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbjCWNoR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 09:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbjCWNoO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 09:44:14 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE2019C59
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 06:44:11 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id cy23so86678968edb.12
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 06:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679579050;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YZfX6hzdmslBpzK/oLezbGbbunUpJ7IENOhg7HXj/Uw=;
        b=nfYzXP5Y/CbidlxAru1x5YVDxIQlOd3DpgKND+WY6wl5fk0LhXz0cFdWlnbE1FLvjz
         +SlkbWGfrw800pgIFT4agDDIQiOD6J53Kl6sHaxr6EpM62YgETYLmr/JWw8KP31Tzph1
         JofQBPykI1ybnbx+U0bC7xb4SiEjw2Qz/jNNjky5YyZWGuJKZ3kKMyy+7kjL+ptlut1/
         axhEYTpiRAlMuZ33rolK9PC6gcIHBWghJaHmJFPp19DrKFAPIhlNnHEtHo+WqjFRUWcW
         WhaAAV0UcOoS+VIZTjyEq9vhLy2z0G9ufDMpGj+vheb36c1Do4qvDAZzNx4AgB2BqXSI
         VywA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679579050;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YZfX6hzdmslBpzK/oLezbGbbunUpJ7IENOhg7HXj/Uw=;
        b=iLoNgxDj4BQps4an5huulx3V3sOxN0/5I2rH8dcw2tjvX3M2NqqYQybOSF/4dKgwkJ
         Z17bVz6ZjV+VM1HMciF2KacTpAShQPjOAFc5VE21PAvpxgKmM5ZHTgwseJgS8XcGUTF6
         1tyudowDaU1EwbxInzSgTlWunrJchocXJETlvKvxYxWoAP0ZC+Nl0+KEWFR7H5EBCZ2I
         s32YcTOyBX+AGtH0P5kcP0nH2hjjHlIudvuA3JCUYlx3/iVKBDt4A/IrGE4Xu1WGFHX+
         LFU++GU8hMALrtKglFAJaZGrwmYtEHYc5H+36Sd28d0VVtMWyXmnXppmV2vkJ16/J0hu
         Ct2g==
X-Gm-Message-State: AO0yUKWiMxG8Q/SmdWwsGRdMa8x/n2kOZVa7OF8XnZKtbU92Ae1fkaaK
        lGJFLQC/2NQK3t+ShKA0sT2B7JFlmUuyvcVYxRKpA3+Cxxh88v3zqo4=
X-Google-Smtp-Source: AK7set+2bbBb4x6POMbWwXZiaSHh3eDYO51Kmfch6y59Nm6/Qvf0ST6dBBN+MYwjbk8jc2naJCrDWO8yPsD/2IpRtEM=
X-Received: by 2002:a17:906:7193:b0:87f:e5af:416e with SMTP id
 h19-20020a170906719300b0087fe5af416emr5466027ejk.7.1679579049840; Thu, 23 Mar
 2023 06:44:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230323052828.6545-1-faithilikerun@gmail.com>
 <20230323052828.6545-3-faithilikerun@gmail.com> <a826f507-d216-adfb-1212-4d577db0ce9f@bjorling.me>
In-Reply-To: <a826f507-d216-adfb-1212-4d577db0ce9f@bjorling.me>
From:   Sam Li <faithilikerun@gmail.com>
Date:   Thu, 23 Mar 2023 21:43:43 +0800
Message-ID: <CAAAx-8L5RBeMmcL8UvxNNc8aYCeGMwKm4O65EiFcKCMmdZo4FQ@mail.gmail.com>
Subject: Re: [PATCH v8 2/4] virtio-blk: add zoned storage emulation for zoned devices
To:     =?UTF-8?Q?Matias_Bj=C3=B8rling?= <m@bjorling.me>
Cc:     qemu-devel@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        qemu-block@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>,
        damien.lemoal@opensource.wdc.com, kvm@vger.kernel.org,
        hare@suse.de, Paolo Bonzini <pbonzini@redhat.com>,
        dmitry.fomichev@wdc.com, Hanna Reitz <hreitz@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Matias Bj=C3=B8rling <m@bjorling.me> =E4=BA=8E2023=E5=B9=B43=E6=9C=8823=E6=
=97=A5=E5=91=A8=E5=9B=9B 21:39=E5=86=99=E9=81=93=EF=BC=9A
>
> On 23/03/2023 06.28, Sam Li wrote:
> > This patch extends virtio-blk emulation to handle zoned device commands
> > by calling the new block layer APIs to perform zoned device I/O on
> > behalf of the guest. It supports Report Zone, four zone oparations (ope=
n,
> > close, finish, reset), and Append Zone.
> >
> > The VIRTIO_BLK_F_ZONED feature bit will only be set if the host does
> > support zoned block devices. Regular block devices(conventional zones)
> > will not be set.
> >
> > The guest os can use blktests, fio to test those commands on zoned devi=
ces.
> > Furthermore, using zonefs to test zone append write is also supported.
> >
> > Signed-off-by: Sam Li <faithilikerun@gmail.com>
> > ---
> >   hw/block/virtio-blk-common.c |   2 +
> >   hw/block/virtio-blk.c        | 389 ++++++++++++++++++++++++++++++++++=
+
> >   2 files changed, 391 insertions(+)
> >
> > diff --git a/hw/block/virtio-blk-common.c b/hw/block/virtio-blk-common.=
c
> > index ac52d7c176..e2f8e2f6da 100644
> > --- a/hw/block/virtio-blk-common.c
> > +++ b/hw/block/virtio-blk-common.c
> > @@ -29,6 +29,8 @@ static const VirtIOFeature feature_sizes[] =3D {
> >        .end =3D endof(struct virtio_blk_config, discard_sector_alignmen=
t)},
> >       {.flags =3D 1ULL << VIRTIO_BLK_F_WRITE_ZEROES,
> >        .end =3D endof(struct virtio_blk_config, write_zeroes_may_unmap)=
},
> > +    {.flags =3D 1ULL << VIRTIO_BLK_F_ZONED,
> > +     .end =3D endof(struct virtio_blk_config, zoned)},
> >       {}
> >   };
>
> I used the qemu monitor to expect the state of the devices, and on the
> zoned block device specific entries, the zoned device feature shows up
> in the "unknown-features" field (info virtio-status <device>)
>
> What is missing is an entry in the blk_feature_map structure within
> hw/virtio/virtio-qmp.c. The below fixes it up.
>
> diff --git i/hw/virtio/virtio-qmp.c w/hw/virtio/virtio-qmp.c
> index b70148aba9..3efa529bab 100644
> --- i/hw/virtio/virtio-qmp.c
> +++ w/hw/virtio/virtio-qmp.c
> @@ -176,6 +176,8 @@ static const qmp_virtio_feature_map_t
> virtio_blk_feature_map[] =3D {
>               "VIRTIO_BLK_F_DISCARD: Discard command supported"),
>       FEATURE_ENTRY(VIRTIO_BLK_F_WRITE_ZEROES, \
>               "VIRTIO_BLK_F_WRITE_ZEROES: Write zeroes command supported"=
),
> +    FEATURE_ENTRY(VIRTIO_BLK_F_ZONED, \
> +            "VIRTIO_BLK_F_ZONED: Zoned block device"),
>   #ifndef VIRTIO_BLK_NO_LEGACY
>       FEATURE_ENTRY(VIRTIO_BLK_F_BARRIER, \
>               "VIRTIO_BLK_F_BARRIER: Request barriers supported"),
>
> Which then lets qemu report the support like this:
>
> (qemu) info virtio-status /machine/peripheral/virtblk0/virtio-backend
> /machine/peripheral/virtblk0/virtio-backend:
>    device_name:             virtio-blk
>    device_id:               2
>    vhost_started:           false
>    bus_name:                (null)
>    broken:                  false
>    disabled:                false
>    disable_legacy_check:    false
>    started:                 true
>    use_started:             true
>    start_on_kick:           false
>    use_guest_notifier_mask: true
>    vm_running:              true
>    num_vqs:                 4
>    queue_sel:               3
>    isr:                     1
>    endianness:              little
>    status:
>          VIRTIO_CONFIG_S_ACKNOWLEDGE: Valid virtio device found,
>          VIRTIO_CONFIG_S_DRIVER: Guest OS compatible with device,
>          VIRTIO_CONFIG_S_FEATURES_OK: Feature negotiation complete,
>          VIRTIO_CONFIG_S_DRIVER_OK: Driver setup and ready
>    Guest features:
>          VIRTIO_RING_F_EVENT_IDX: Used & avail. event fields enabled,
>          VIRTIO_RING_F_INDIRECT_DESC: Indirect descriptors supported,
>          VIRTIO_F_VERSION_1: Device compliant for v1 spec (legacy)
>          VIRTIO_BLK_F_CONFIG_WCE: Cache writeback and ...,
>          VIRTIO_BLK_F_FLUSH: Flush command supported,
>          VIRTIO_BLK_F_ZONED: Zoned block device,
>          VIRTIO_BLK_F_WRITE_ZEROES: Write zeroes command supported,
>          VIRTIO_BLK_F_MQ: Multiqueue supported,
>          VIRTIO_BLK_F_TOPOLOGY: Topology information available,
>          VIRTIO_BLK_F_BLK_SIZE: Block size of disk available,
>          VIRTIO_BLK_F_GEOMETRY: Legacy geometry available,
>          VIRTIO_BLK_F_SEG_MAX: Max segments in a request is seg_max
>    unknown-features(0x0000010000000000)
>    Host features:
>          VIRTIO_RING_F_EVENT_IDX: Used & avail. event fields enabled,
>          VIRTIO_RING_F_INDIRECT_DESC: Indirect descriptors supported,
>          VIRTIO_F_VERSION_1: Device compliant for v1 spec (legacy),
>          VIRTIO_F_ANY_LAYOUT: Device accepts arbitrary desc. layouts,
>          VIRTIO_F_NOTIFY_ON_EMPTY: Notify when device ...,
>          VHOST_USER_F_PROTOCOL_FEATURES: Vhost-user protocol ...,
>          VIRTIO_BLK_F_CONFIG_WCE: Cache writeback and w...,
>          VIRTIO_BLK_F_FLUSH: Flush command supported,
>          VIRTIO_BLK_F_ZONED: Zoned block device,
>          VIRTIO_BLK_F_WRITE_ZEROES: Write zeroes command supported,
>          VIRTIO_BLK_F_MQ: Multiqueue supported,
>          VIRTIO_BLK_F_TOPOLOGY: Topology information available,
>          VIRTIO_BLK_F_BLK_SIZE: Block size of disk available,
>          VIRTIO_BLK_F_GEOMETRY: Legacy geometry available,
>          VIRTIO_BLK_F_SEG_MAX: Max segments in a request is seg_max
>    unknown-features(0x0000010000000000)
>    Backend features:

Great!

>
> Cheers, Matias
