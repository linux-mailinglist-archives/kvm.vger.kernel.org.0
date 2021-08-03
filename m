Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C534B3DE9B2
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 11:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234910AbhHCJbq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 05:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234687AbhHCJbp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Aug 2021 05:31:45 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3793CC061764
        for <kvm@vger.kernel.org>; Tue,  3 Aug 2021 02:31:33 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id b7so28189439edu.3
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 02:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XnFT0+T34CYtIhtj9AFRhRgp0BmU14hBeulSmSMqkco=;
        b=lnh5e5rtm1i3OI43NQE8IstmfTWykpBHTHoQHdfbzzsQX7nlQoH6dmaIGzGDt/3IpX
         hVaLY2SyXmPXkpBBd9scceDJf/zBQ4A76NX2+7ALhUhIU4ZBFN+VFm3yT5ahwH3xFnI5
         e4JmTQu0w1sKOfhaBUWL7fjXF1tZIaQNk1baawfU+UMg2Icf5373OPJbGCHz6/DLMbMX
         WiHewdxY/zEYYxZs2QOJhCw6f774C+Tq2heA/u+W2YvusHjifhzWyPmdNcLd7MathYyr
         f4iT9bjGEC8A90IGAxotEqF8N9hdUVOFaJEcIDHz/CheJ4AdYPep42urz4UhJ0ASDRKH
         BIYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XnFT0+T34CYtIhtj9AFRhRgp0BmU14hBeulSmSMqkco=;
        b=Lm23HvvHAopwIYOy2W7jcDKm+I6wvVRgjTSqzrUgXWqci9jC4EJ9L4RcoLt+XD/3EW
         MDDV5KowUoq4gwlwgGV6f2Bpza4KQMLd4KI0I3erkuGQXfIzxKRCugVozorEhO5avzt+
         Rk3eENLRYw0XX6B/n14gai2UuUt77T7Br3JffNjW4rp9vIRYn3UCqsnkgFouhWAMYUGB
         gbiybooayJR3stQXmI8UdNRXxImK+XDzHEHnhbqVCyMvvLWqytjddF/XDflR9RVc6FI3
         BJFt4R/dY0AkHTmYVRQmlm0Yho+9D0LrXfFaPPfY8I3kpGGBuRux2ffTL423i+lm723s
         5rvA==
X-Gm-Message-State: AOAM533+2TdMCeGhsYVGz5L5mCBe5DeklkSFPMDzJL1JYOji2732sOME
        CPcd1udLj9WopCLTw2IxWwhyoDNvzZ2mkLhf/5iy
X-Google-Smtp-Source: ABdhPJy+LxOFqB8YD73zckkZYLMc9dK6jQxb/4DjwmZe9c1z6ZeWREgaWSDzSR2aIdoSx6+rDpaFnlN8W0AAfJNPoJw=
X-Received: by 2002:a05:6402:74f:: with SMTP id p15mr24038732edy.195.1627983091785;
 Tue, 03 Aug 2021 02:31:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210729073503.187-1-xieyongji@bytedance.com> <20210729073503.187-5-xieyongji@bytedance.com>
 <39a191f6-555b-d2e6-e712-735b540526d0@redhat.com>
In-Reply-To: <39a191f6-555b-d2e6-e712-735b540526d0@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 3 Aug 2021 17:31:20 +0800
Message-ID: <CACycT3sdH3zVzznsaMb0+3mzrLF7FjmB89U11fZv_23Y4_WbEw@mail.gmail.com>
Subject: Re: [PATCH v10 04/17] vdpa: Fail the vdpa_reset() if fail to set
 device status to zero
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
        Greg KH <gregkh@linuxfoundation.org>,
        He Zhe <zhe.he@windriver.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>,
        Joe Perches <joe@perches.com>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 3, 2021 at 3:58 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/7/29 =E4=B8=8B=E5=8D=883:34, Xie Yongji =E5=86=99=E9=81=93=
:
> > Re-read the device status to ensure it's set to zero during
> > resetting. Otherwise, fail the vdpa_reset() after timeout.
> >
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > ---
> >   include/linux/vdpa.h | 15 ++++++++++++++-
> >   1 file changed, 14 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> > index 406d53a606ac..d1a80ef05089 100644
> > --- a/include/linux/vdpa.h
> > +++ b/include/linux/vdpa.h
> > @@ -6,6 +6,7 @@
> >   #include <linux/device.h>
> >   #include <linux/interrupt.h>
> >   #include <linux/vhost_iotlb.h>
> > +#include <linux/delay.h>
> >
> >   /**
> >    * struct vdpa_calllback - vDPA callback definition.
> > @@ -340,12 +341,24 @@ static inline struct device *vdpa_get_dma_dev(str=
uct vdpa_device *vdev)
> >       return vdev->dma_dev;
> >   }
> >
> > -static inline void vdpa_reset(struct vdpa_device *vdev)
> > +#define VDPA_RESET_TIMEOUT_MS 1000
> > +
> > +static inline int vdpa_reset(struct vdpa_device *vdev)
> >   {
> >       const struct vdpa_config_ops *ops =3D vdev->config;
> > +     int timeout =3D 0;
> >
> >       vdev->features_valid =3D false;
> >       ops->set_status(vdev, 0);
> > +     while (ops->get_status(vdev)) {
> > +             timeout +=3D 20;
> > +             if (timeout > VDPA_RESET_TIMEOUT_MS)
> > +                     return -EIO;
> > +
> > +             msleep(20);
> > +     }
>
>
> I wonder if it's better to do this in the vDPA parent?
>
> Thanks
>

Sorry, I didn't get you here. Do you mean vDPA parent driver (e.g.
VDUSE)? Actually I didn't find any other place where I can do
set_status() and get_status().

Thanks,
Yongji
