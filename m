Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B63E96242A4
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 13:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbiKJMz5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 07:55:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbiKJMz4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 07:55:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA9B6F36A
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 04:54:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668084898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kv5D6nGeZeuA43cQkawKbkRfxQtTJUdYYzC/bcuYvc0=;
        b=X5M1hE5GkzGOsnmoTsyjALDnYjyp3eH2Rz8KW0QLvUvrxA++qdiGdguEMQtlY5Y3JckwM4
        K2Kdb5Oed/10gN1yGWI3g3IZCIa/ySP/IznOttiDNWWOOowSJNjGZBuiISXJOlL5DtVRY5
        JueYZJupzZKOyXHKprLD9Yl8OQiHvs8=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-490-2Twxbqz1P_O1fpCUPFtENA-1; Thu, 10 Nov 2022 07:54:57 -0500
X-MC-Unique: 2Twxbqz1P_O1fpCUPFtENA-1
Received: by mail-pl1-f200.google.com with SMTP id n1-20020a170902f60100b00179c0a5c51fso1326449plg.7
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 04:54:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kv5D6nGeZeuA43cQkawKbkRfxQtTJUdYYzC/bcuYvc0=;
        b=yhtbyFrh7P8fm4pNSIpNAnIJX4S54ZJ5+SlcHatM4oEz429kjCqRUkfUmCx1Mn7bk1
         7/hu3tFVVKhTjJEokKQ6+FXGS9KQemg5BS5kPo371ozFnUPUrFTGwU8lsBnqKqN21v5u
         4RlkaGyieS7y2kSPMAJqSWe5TwKKHu/OzgQICKyVMY7e/k55P3+fr+ecM+uhE0+MU0Ja
         uoY3zh58tI/qVpXn7sksMH7DEBE4/WCnYr4P27d/igFegK/yvFgui1MP0oARVQ/uqkiq
         qa9hJcfgpYy5o5qo8idWsOvLTQv9GAekX/OaCyGVbduwtRfzftJa5ekJfgMtEwYv5+BV
         zGuA==
X-Gm-Message-State: ACrzQf3SKV1ew4Qly/WaQwbysJrCndVD0cKSWbyflZVUmikuNqwH2dVI
        kGRi+duxdrKBOXMTpv9TT0PIf8BF941B7sohgdDv9zTGx4Aw7XCCDburMYAWTg5FbsGlYf/zziD
        L/gY96NL8d/oRlcvYsuDIXs6FURsh
X-Received: by 2002:a17:902:ce82:b0:187:3591:edac with SMTP id f2-20020a170902ce8200b001873591edacmr48415163plg.153.1668084896393;
        Thu, 10 Nov 2022 04:54:56 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5Cm0JGbxU9riW7wMxVo0gNnoX6jBW7PsAWVyfOuZl1wzOGsVVTjmJX6t9u+i577FFLTl11gxgK8m4ELOLS+NY=
X-Received: by 2002:a17:902:ce82:b0:187:3591:edac with SMTP id
 f2-20020a170902ce8200b001873591edacmr48415155plg.153.1668084896156; Thu, 10
 Nov 2022 04:54:56 -0800 (PST)
MIME-Version: 1.0
References: <20221108170755.92768-1-eperezma@redhat.com> <20221108170755.92768-2-eperezma@redhat.com>
 <CACGkMEtvbSbsNZQV5RB1yyNzpam4QezdJ-f75nh4ToMJU=KYQQ@mail.gmail.com>
In-Reply-To: <CACGkMEtvbSbsNZQV5RB1yyNzpam4QezdJ-f75nh4ToMJU=KYQQ@mail.gmail.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 10 Nov 2022 13:54:20 +0100
Message-ID: <CAJaqyWdf-A8xEDVyX9f6y3FZhyp9bYMnuFU2jWFStCCvVNkDTA@mail.gmail.com>
Subject: Re: [PATCH v6 01/10] vdpa: Use v->shadow_vqs_enabled in
 vhost_vdpa_svqs_start & stop
To:     Jason Wang <jasowang@redhat.com>
Cc:     qemu-devel@nongnu.org, Parav Pandit <parav@mellanox.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Cindy Lu <lulu@redhat.com>, Eli Cohen <eli@mellanox.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, kvm@vger.kernel.org,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 10, 2022 at 6:22 AM Jason Wang <jasowang@redhat.com> wrote:
>
> On Wed, Nov 9, 2022 at 1:08 AM Eugenio P=C3=A9rez <eperezma@redhat.com> w=
rote:
> >
> > This function used to trust in v->shadow_vqs !=3D NULL to know if it mu=
st
> > start svq or not.
> >
> > This is not going to be valid anymore, as qemu is going to allocate svq
> > unconditionally (but it will only start them conditionally).
>
> It might be a waste of memory if we did this. Any reason for this?
>

Well, it's modelled after vhost_vdpa notifier member [1].

But sure we can reduce the memory usage if SVQ is not used. The first
function that needs it is vhost_set_vring_kick. But I think it is not
a good function to place the delayed allocation.

Would it work to move the allocation to vhost_set_features vhost op?
It seems unlikely to me to call callbacks that can affect SVQ earlier
than that one. Or maybe to create a new one and call it the first on
vhost.c:vhost_dev_start?

Thanks!

[1] The notifier member already allocates VIRTIO_QUEUE_MAX
VhostVDPAHostNotifier for each vhost_vdpa, It is easy to reduce at
least to the number of virtqueues on a vhost_vdpa. Should I send a
patch for this one?


> Thanks
>
> >
> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > ---
> >  hw/virtio/vhost-vdpa.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> > index 7468e44b87..7f0ff4df5b 100644
> > --- a/hw/virtio/vhost-vdpa.c
> > +++ b/hw/virtio/vhost-vdpa.c
> > @@ -1029,7 +1029,7 @@ static bool vhost_vdpa_svqs_start(struct vhost_de=
v *dev)
> >      Error *err =3D NULL;
> >      unsigned i;
> >
> > -    if (!v->shadow_vqs) {
> > +    if (!v->shadow_vqs_enabled) {
> >          return true;
> >      }
> >
> > @@ -1082,7 +1082,7 @@ static void vhost_vdpa_svqs_stop(struct vhost_dev=
 *dev)
> >  {
> >      struct vhost_vdpa *v =3D dev->opaque;
> >
> > -    if (!v->shadow_vqs) {
> > +    if (!v->shadow_vqs_enabled) {
> >          return;
> >      }
> >
> > --
> > 2.31.1
> >
>

