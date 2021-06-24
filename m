Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6DE33B2B2E
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 11:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhFXJTN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 05:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbhFXJTL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 05:19:11 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB8FC061756
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 02:16:52 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id c7so7497548edn.6
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 02:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ToYKmnHgqk/66SzWjvRy2Lj5kh6aXbY58HiBGtTfTYc=;
        b=ZEweUXuAJoGCGMqY3z9xEzvHeOc45CgfE+oRLPnwvWDM8sEylSod/l69pmO1wTq6Fk
         dJ6IJffz8PwtlA84nAwOMbu/T24GwtdMUEWh7Wfy0A/5i4gI8Lx4GorjU0lFTf+6k/vp
         waHl9OMa0UhLOi5kJckBgVUzPJL/7362ZFcIUrXc9waM3czme6JE2Mo08y5M7V+vITDj
         FSMllieK9ieeAYx2zFLgwFaafNl51St8nhwF6tDUKXqzbB8XsjnOGrlgyKrhcMFFDR5E
         SiRzn5cHnpY863Xr8EDmjh2FISKPY1AoSdoR/zlJVxPQyBejxzBJIxXPRJBt624oRvsJ
         Nt6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ToYKmnHgqk/66SzWjvRy2Lj5kh6aXbY58HiBGtTfTYc=;
        b=GBNVjI2h5czV/wCIpQxm/cl6NRR4ERSimwMEjFBKIOFjS7PawErprWV4RkeD+LoBEh
         MLsS75oH1pPb9ejfdcEaB44XewG3M0/b+PcPlWnIEW9pofT97zjyXHPnGdPW3y8YaBt9
         GmtIR2K+noD9iJ6zE/HRShFevVQc0MRqT/EVMe6Vx4ngfV6sVLZfBrPKkbFQJI+q2QJr
         ry5uvO51go/ehPNWUYW68ax9dFgupqC+QjjBRmHLqKfRvNdWEXn+eF01pIK86JsYI75Q
         st/X2CoSg5AM5bmmevVgKFUxJVceMwkUOFlE0W/9kA+a85HV9eyalcOHpb1NGL3qVMoH
         RoIw==
X-Gm-Message-State: AOAM533zPoilM5M/tWO20mlw1TA0+lylw0oDV5LCBj2lLQ9FoP/pDlZ7
        /IzA6nEkz4P2m7CrsrUxpqdXhJirBmE0GvAymbbS
X-Google-Smtp-Source: ABdhPJwzxlNtCT4qXONVb1tZWclCON16CNPSh2qEimKMjvYzH/fk8YJnTCoKh644GYgJY+nPjC5RJVk2i47qjgJpKlM=
X-Received: by 2002:a05:6402:27ce:: with SMTP id c14mr5750686ede.118.1624526210663;
 Thu, 24 Jun 2021 02:16:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210615141331.407-1-xieyongji@bytedance.com> <20210615141331.407-10-xieyongji@bytedance.com>
 <adfb2be9-9ed9-ca37-ac37-4cd00bdff349@redhat.com> <CACycT3tAON+-qZev+9EqyL2XbgH5HDspOqNt3ohQLQ8GqVK=EA@mail.gmail.com>
 <1bba439f-ffc8-c20e-e8a4-ac73e890c592@redhat.com> <CACycT3uzMJS7vw6MVMOgY4rb=SPfT2srV+8DPdwUVeELEiJgbA@mail.gmail.com>
 <0aeb7cb7-58e5-1a95-d830-68edd7e8ec2e@redhat.com> <CACycT3uuooKLNnpPHewGZ=q46Fap2P4XCFirdxxn=FxK+X1ECg@mail.gmail.com>
 <e4cdee72-b6b4-d055-9aac-3beae0e5e3e1@redhat.com> <CACycT3u8=_D3hCtJR+d5BgeUQMce6S7c_6P3CVfvWfYhCQeXFA@mail.gmail.com>
 <d2334f66-907c-2e9c-ea4f-f912008e9be8@redhat.com> <CACycT3uCSLUDVpQHdrmuxSuoBDg-4n22t+N-Jm2GoNNp9JYB2w@mail.gmail.com>
 <48cab125-093b-2299-ff9c-3de8c7c5ed3d@redhat.com>
In-Reply-To: <48cab125-093b-2299-ff9c-3de8c7c5ed3d@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 24 Jun 2021 17:16:39 +0800
Message-ID: <CACycT3tS=10kcUCNGYm=dUZsK+vrHzDvB3FSwAzuJCu3t+QuUQ@mail.gmail.com>
Subject: Re: Re: [PATCH v8 09/10] vduse: Introduce VDUSE - vDPA Device in Userspace
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        Greg KH <gregkh@linuxfoundation.org>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 24, 2021 at 4:14 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/6/24 =E4=B8=8B=E5=8D=8812:46, Yongji Xie =E5=86=99=E9=81=
=93:
> >> So we need to deal with both FEATURES_OK and reset, but probably not
> >> DRIVER_OK.
> >>
> > OK, I see. Thanks for the explanation. One more question is how about
> > clearing the corresponding status bit in get_status() rather than
> > making set_status() fail. Since the spec recommends this way for
> > validation which is done in virtio_dev_remove() and
> > virtio_finalize_features().
> >
> > Thanks,
> > Yongji
> >
>
> I think you can. Or it would be even better that we just don't set the
> bit during set_status().
>

Yes, that's what I mean.

> I just realize that in vdpa_reset() we had:
>
> static inline void vdpa_reset(struct vdpa_device *vdev)
> {
>          const struct vdpa_config_ops *ops =3D vdev->config;
>
>          vdev->features_valid =3D false;
>          ops->set_status(vdev, 0);
> }
>
> We probably need to add the synchronization here. E.g re-read with a
> timeout.
>

Looks like the timeout is already in set_status(). Do we really need a
duplicated one here? And how to handle failure? Adding a return value
to virtio_config_ops->reset() and passing the error to the upper
layer?

Thanks,
Yongji
