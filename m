Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138A536D381
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 09:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236920AbhD1H5K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 03:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236824AbhD1H5K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 03:57:10 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28829C061574
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 00:56:25 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id q6so13771581edr.3
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 00:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8uP8Cz5ttOj/QUqkY1hzWrzAG4GDCZ6Rokqd8IVF7+I=;
        b=d2vgMnn1mocH2D2WukDj7otAIxaNk5+o9I2mOthIPCjfzBBfSROoDwZlACRXxsqy8e
         /d/+nFMz/r4l7XomdKWVY6HKDhx1UqopRFvvSu9fmgv/LWOXAjM+2FTURP1hPB1Dj/pJ
         K8GlnhXlfiluhIlK5BmNkCMQYzQSKs3W9xuFrtUhqWpu9AGma8NLeUtQHgXwaCznyE+3
         XQUgI0dlZ1LW9o/PO5nW4O5Oqvps9RsTWuF9PAfGzom+K3rx1F/Wvgn9r0xc8q7fub5/
         quUS1etW+oP8WO6SnBhbSh0h0teyUNsZgu+9Wh8ep3Me9QhWOxRgJtGEeqJmCi3W6Pwf
         gQmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8uP8Cz5ttOj/QUqkY1hzWrzAG4GDCZ6Rokqd8IVF7+I=;
        b=URYj3sCya2lgPSy86hDMAVdOOI1vMJhZYJ890Ob3rVuGqQeqRNmm41utdFEgCyTSUL
         UYn+DJ5bTXI4PG8vtPUpY7Q19Nbvm8kcCeHE2QSgcO0YEK9eE8MjKgL4Y8Vy2rU8ojX0
         gJ1snUr1u+Sr1GbumYS+O5Jjah5n+nHchh1kqbYjHz3nLyvWWOGK/fEwviQCewNdio/P
         6wn2wbZyG8FA/CcP2gxjjfTpHWATVVIy4ddc1wBIuLr+wYqJ2V22uRE0jJWsSJ4didex
         AltJwywYkRp6sqvXokMKi34sc8vMKWPccsjEOzBrKJhKxRFyHZ8Q4y7PhlEQq1PX+Ejz
         Umdg==
X-Gm-Message-State: AOAM530ftRFbqUUwZqjnzgjfkOdgxxTT4yX3crfxdofdGhiyQcLmnzN0
        rm/KLYlDclfd2TU30zYYcCT3pkrQ9zzsH5Zb6Rgpkw==
X-Google-Smtp-Source: ABdhPJxyDGhbwy5/OMaVNsUOCG28vaIwvnZf0V45qYtFd6PSYGwR7D/5UI5UUGelPDWpAam7fY2B9flLfVrhjxWfrTE=
X-Received: by 2002:a50:ff13:: with SMTP id a19mr9365734edu.300.1619596583911;
 Wed, 28 Apr 2021 00:56:23 -0700 (PDT)
MIME-Version: 1.0
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com> <2-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <20210428060300.GA4092@lst.de>
In-Reply-To: <20210428060300.GA4092@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 28 Apr 2021 00:56:21 -0700
Message-ID: <CAPcyv4g=MFtZMVZPn8AtTX6NyweF25nuFNVBu7pg_QSP+EGE+g@mail.gmail.com>
Subject: Re: [PATCH v2 02/13] vfio/mdev: Allow the mdev_parent_ops to specify
 the device driver to bind
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 27, 2021 at 11:04 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Mon, Apr 26, 2021 at 05:00:04PM -0300, Jason Gunthorpe wrote:
> > +/*
> > + * mdev drivers can refuse to bind during probe(), in this case we want to fail
> > + * the creation of the mdev all the way back to sysfs. This is a weird model
> > + * that doesn't fit in the driver core well, nor does it seem to appear any
> > + * place else in the kernel, so use a simple hack.
> > + */
> > +static int mdev_bind_driver(struct mdev_device *mdev)
> > +{
> > +     struct mdev_driver *drv = mdev->type->parent->ops->device_driver;
> > +     int ret;
> > +
> > +     if (!drv)
> > +             drv = &vfio_mdev_driver;
> > +
> > +     while (1) {
> > +             device_lock(&mdev->dev);
> > +             if (mdev->dev.driver == &drv->driver) {
> > +                     ret = 0;
> > +                     goto out_unlock;
> > +             }
> > +             if (mdev->probe_err) {
> > +                     ret = mdev->probe_err;
> > +                     goto out_unlock;
> > +             }
> > +             device_unlock(&mdev->dev);
> > +             ret = device_attach(&mdev->dev);
> > +             if (ret)
> > +                     return ret;
> > +             mdev->probe_err = -EINVAL;
> > +     }
> > +     return 0;
> > +
> > +out_unlock:
> > +     device_unlock(&mdev->dev);
> > +     return ret;
> > +}
>
> > +++ b/drivers/vfio/mdev/mdev_driver.c
> > @@ -49,7 +49,7 @@ static int mdev_probe(struct device *dev)
> >               return ret;
> >
> >       if (drv->probe) {
> > -             ret = drv->probe(mdev);
> > +             ret = mdev->probe_err = drv->probe(mdev);
> >               if (ret)
> >                       mdev_detach_iommu(mdev);
> >       }
>
> >       return 0;
> >  }
> >
> > +static int mdev_match(struct device *dev, struct device_driver *drv)
> > +{
> > +     struct mdev_device *mdev = to_mdev_device(dev);
> > +     struct mdev_driver *target = mdev->type->parent->ops->device_driver;
> > +
> > +     /*
> > +      * The ops specify the device driver to connect, fall back to the old
> > +      * shim driver if the driver hasn't been converted.
> > +      */
> > +     if (!target)
> > +             target = &vfio_mdev_driver;
> > +     return drv == &target->driver;
> > +}
>
> I still think this going the wrong way.  Why can't we enhance the core
> driver code with a version of device_bind_driver() that does call into
> ->probe?  That probably seems like a better model for those existing
> direct users of device_bind_driver or device_attach with a pre-set
> ->drv anyway.

Wouldn't that just be "export device_driver_attach()" so that drivers
can implement their own custom bind implementation?
