Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F327ACEAC
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 05:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbjIYDVY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Sep 2023 23:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbjIYDVW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Sep 2023 23:21:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42684C2
        for <kvm@vger.kernel.org>; Sun, 24 Sep 2023 20:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695612029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TrR3zPpsYfW5fFIFy5P2/fVt+bsSu1JVw5qNlGgU7cU=;
        b=P5IYo/Xa0+SOXGyY2JBDwd+bjGXCCEO6UQ+ivTnm/8vLvGKY7xiAvv8sgkGKZ1yURfcjeU
        YAvP2xFiygBmJZH8VycddCTVkHz13HGTmeGzPlyZFG0ddkH/sLa1ZXqXwuP0UjQAPoNt2p
        Dg+AEtQzjz2F0MzMeIDLRe+XlZgZyvk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-168-ngw_srV9M_2mUjKlsnLIJg-1; Sun, 24 Sep 2023 23:20:28 -0400
X-MC-Unique: ngw_srV9M_2mUjKlsnLIJg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-31dc8f0733dso4459084f8f.3
        for <kvm@vger.kernel.org>; Sun, 24 Sep 2023 20:20:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695612026; x=1696216826;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TrR3zPpsYfW5fFIFy5P2/fVt+bsSu1JVw5qNlGgU7cU=;
        b=uuSsmmOTTjFsVfQao8krnmLfHO3KKuRRBwbJk9qsDAMekrwMIKd94ZoFrU7pG95RBE
         /pX/GaB/0w+hoB7HMKZ4KYTdDADKPuIMeEzTQ53xwkSbsqGDsNKl+nAMHvDncEgNS5P+
         czQ1HIeJsV4/eT+HFnj1hzZ/awNu3fcU8l6Bb9WO7s7NYpvhxnp3UP1a2B5gU0TBuYbj
         /uwGIkqWrUtQV5AdY1V8q+CLMA1uzjhT19Ffq3wjTQMzyUu8LQNPTiUdh4fglDYy8/xP
         L1G9I7I8XfEojFbGhHcykraj8F/zuKaWSfoBRND5A5V1bvAFkQDyZpgpn92Jpcss+des
         5jkA==
X-Gm-Message-State: AOJu0YynfKsR3p40WO1HpbpYZzbuveQf9JH4jWt0hGcrmwi2SGlOkbky
        RzsjGaI0dEY+KlU2o1gvj077QA5iVOhYZsmvWkHmrwzsce7UhbljMxMNtwlVssGgbZ487cfU1GO
        GILXCvrj6/83P09mwkNiLP9Bskb/B2bf05EpH
X-Received: by 2002:a5d:46d2:0:b0:321:5211:8e20 with SMTP id g18-20020a5d46d2000000b0032152118e20mr4758437wrs.59.1695612026261;
        Sun, 24 Sep 2023 20:20:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEbXDBE4JRcEE3biGXQuHAfiqMbcwu40ARqWUHJUoOs6GS1iq/4wyEprZ6iOJlEp6+YDnDyEiJj72z74/YU8Os=
X-Received: by 2002:a5d:46d2:0:b0:321:5211:8e20 with SMTP id
 g18-20020a5d46d2000000b0032152118e20mr4758423wrs.59.1695612025955; Sun, 24
 Sep 2023 20:20:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230912030008.3599514-1-lulu@redhat.com> <20230912030008.3599514-5-lulu@redhat.com>
 <CACGkMEtCYG8-Pt+V-OOwUV7fYFp_cnxU68Moisfxju9veJ-=qw@mail.gmail.com>
 <CACLfguW3NS_4+YhqTtGqvQb70mVazGVfheryHx4aCBn+=Skf9w@mail.gmail.com> <CACGkMEt-m9bOh9YnqLw0So5wqbZ69D0XRVBbfG73Oh7Q8qTJsQ@mail.gmail.com>
In-Reply-To: <CACGkMEt-m9bOh9YnqLw0So5wqbZ69D0XRVBbfG73Oh7Q8qTJsQ@mail.gmail.com>
From:   Cindy Lu <lulu@redhat.com>
Date:   Mon, 25 Sep 2023 11:19:47 +0800
Message-ID: <CACLfguWQ=-M1f2QLH-_Y44xd7-AWtWg=v89W_u83NTGjRmAkqg@mail.gmail.com>
Subject: Re: [RFC v2 4/4] vduse: Add new ioctl VDUSE_GET_RECONNECT_INFO
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, maxime.coquelin@redhat.com,
        xieyongji@bytedance.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 25, 2023 at 10:58=E2=80=AFAM Jason Wang <jasowang@redhat.com> w=
rote:
>
> On Thu, Sep 21, 2023 at 10:07=E2=80=AFPM Cindy Lu <lulu@redhat.com> wrote=
:
> >
> > On Mon, Sep 18, 2023 at 4:49=E2=80=AFPM Jason Wang <jasowang@redhat.com=
> wrote:
> > >
> > > On Tue, Sep 12, 2023 at 11:01=E2=80=AFAM Cindy Lu <lulu@redhat.com> w=
rote:
> > > >
> > > > In VDUSE_GET_RECONNECT_INFO, the Userspace App can get the map size
> > > > and The number of mapping memory pages from the kernel. The userspa=
ce
> > > > App can use this information to map the pages.
> > > >
> > > > Signed-off-by: Cindy Lu <lulu@redhat.com>
> > > > ---
> > > >  drivers/vdpa/vdpa_user/vduse_dev.c | 15 +++++++++++++++
> > > >  include/uapi/linux/vduse.h         | 15 +++++++++++++++
> > > >  2 files changed, 30 insertions(+)
> > > >
> > > > diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa=
_user/vduse_dev.c
> > > > index 680b23dbdde2..c99f99892b5c 100644
> > > > --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> > > > +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> > > > @@ -1368,6 +1368,21 @@ static long vduse_dev_ioctl(struct file *fil=
e, unsigned int cmd,
> > > >                 ret =3D 0;
> > > >                 break;
> > > >         }
> > > > +       case VDUSE_GET_RECONNECT_INFO: {
> > > > +               struct vduse_reconnect_mmap_info info;
> > > > +
> > > > +               ret =3D -EFAULT;
> > > > +               if (copy_from_user(&info, argp, sizeof(info)))
> > > > +                       break;
> > > > +
> > > > +               info.size =3D PAGE_SIZE;
> > > > +               info.max_index =3D dev->vq_num + 1;
> > > > +
> > > > +               if (copy_to_user(argp, &info, sizeof(info)))
> > > > +                       break;
> > > > +               ret =3D 0;
> > > > +               break;
> > > > +       }
> > > >         default:
> > > >                 ret =3D -ENOIOCTLCMD;
> > > >                 break;
> > > > diff --git a/include/uapi/linux/vduse.h b/include/uapi/linux/vduse.=
h
> > > > index d585425803fd..ce55e34f63d7 100644
> > > > --- a/include/uapi/linux/vduse.h
> > > > +++ b/include/uapi/linux/vduse.h
> > > > @@ -356,4 +356,19 @@ struct vhost_reconnect_vring {
> > > >         _Bool avail_wrap_counter;
> > > >  };
> > > >
> > > > +/**
> > > > + * struct vduse_reconnect_mmap_info
> > > > + * @size: mapping memory size, always page_size here
> > > > + * @max_index: the number of pages allocated in kernel,just
> > > > + * use for check
> > > > + */
> > > > +
> > > > +struct vduse_reconnect_mmap_info {
> > > > +       __u32 size;
> > > > +       __u32 max_index;
> > > > +};
> > >
> > > One thing I didn't understand is that, aren't the things we used to
> > > store connection info belong to uAPI? If not, how can we make sure th=
e
> > > connections work across different vendors/implementations. If yes,
> > > where?
> > >
> > > Thanks
> > >
> > The process for this reconnecttion  is
> > A.The first-time connection
> > 1> The userland app checks if the device exists
> > 2>  use the ioctl to create the vduse device
> > 3> Mapping the kernel page to userland and save the
> > App-version/features/other information to this page
> > 4>  if the Userland app needs to exit, then the Userland app will only
> > unmap the page and then exit
> >
> > B, the re-connection
> > 1> the userland app finds the device is existing
> > 2> Mapping the kernel page to userland
> > 3> check if the information in shared memory is satisfied to
> > reconnect,if ok then continue to reconnect
> > 4> continue working
> >
> >  For now these information are all from userland,So here the page will
> > be maintained by the userland App
> > in the previous code we only saved the api-version by uAPI .  if  we
> > need to support reconnection maybe we need to add 2 new uAPI for this,
> > one of the uAPI is to save the reconnect  information and another is
> > to get the information
> >
> > maybe something like
> >
> > struct vhost_reconnect_data {
> > uint32_t version;
> > uint64_t features;
> > uint8_t status;
> > struct virtio_net_config config;
> > uint32_t nr_vrings;
> > };
>
> Probably, then we can make sure the re-connection works across
> different vduse-daemon implementations.
>
> >
> > #define VDUSE_GET_RECONNECT_INFO _IOR (VDUSE_BASE, 0x1c, struct
> > vhost_reconnect_data)
> >
> > #define VDUSE_SET_RECONNECT_INFO  _IOWR(VDUSE_BASE, 0x1d, struct
> > vhost_reconnect_data)
>
> Not sure I get this, but the idea is to map those pages to user space,
> any reason we need this uAPI?
>
> Thanks
>
Sorry=EF=BC=8C I didn't write it clearly, I mean if I we don't want to use =
the
mmap to sync/check the vduse status, we need to add these 2 new uAPIs,
 these 2 methods are all ok for me.
For the vq related information still need to use the mmap to sync
Thanks
cindy
> >
> > Thanks
> > Cindy
> >
> >
> >
> >
> > > > +
> > > > +#define VDUSE_GET_RECONNECT_INFO \
> > > > +       _IOWR(VDUSE_BASE, 0x1b, struct vduse_reconnect_mmap_info)
> > > > +
> > > >  #endif /* _UAPI_VDUSE_H_ */
> > > > --
> > > > 2.34.3
> > > >
> > >
> >
>

