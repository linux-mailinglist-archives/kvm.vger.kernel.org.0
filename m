Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C0A334888
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 21:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbhCJUCY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 15:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232327AbhCJUCC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 15:02:02 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622BEC061760
        for <kvm@vger.kernel.org>; Wed, 10 Mar 2021 12:02:02 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id c10so41146454ejx.9
        for <kvm@vger.kernel.org>; Wed, 10 Mar 2021 12:02:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y/4oQIiIiGY41bf4LdGEjnexINZZWNtFCosgyikKips=;
        b=vm1EkIRlLwzbO+VVuedRPi0Ia3slBrjkpEDzIqTTk5wwvxc7TGOWF2wTkSz3OVSIB4
         SAqUC1TMrtHpHvs+szazRJGyIRpR2JMrXD95imyIJjs93EXtUsn4rdk6sAJz0dLfEOzL
         hNaavYXHsq4KaFDZZZRhLTVeq2XhtyYQIvp2sLeeobRpsrBldDbByAqAaIsVs62O9tv3
         3V1r0RJs1OFYyKPNDGHgHowOkxfmNQHCk4OnvzYy4o6n/5cLWWUILA0mvzWHd2xy694L
         5pZIkHWpZBLEMphUw9Hqhntn6jLpsL4bYk3KsQQpq3FY/iNue1pHKZOAegfOnVfy4I0J
         Nfog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y/4oQIiIiGY41bf4LdGEjnexINZZWNtFCosgyikKips=;
        b=rDp13NTmSORXSDD9v16qrhmVrwJlGDq8grSZk+C0ovXQ6j+vsatKBUIRn1IVSVYchT
         v5mVhSG1xHk2cdb2sDtVrvH5FBeSnUoErozOsEyRLS+M1nzsuI+557rQhHaNV9iDCioG
         UJxdd3ZPT8s6e1kGIRuvet2AfQiYuj6Is6NczPpJa8dfeO42R3urnGHMMJZ3DbkbVrVd
         5ULxcIn2V5dKklVB43sqp1nSzQKq+BD5e5NBnVrvsVSl2boWbpqFYFtpTH2+MP18nKhx
         GaYfhSAbgiICOq1o8xTYkMH/yh7nLDDU9nHExBmrKpCgBeG6+BHZUx6ze41gevge76hk
         A1TA==
X-Gm-Message-State: AOAM531naBSIATCiqmNqEw5PSHSZsygG4fY97gBLgRXbGSA37+zyH4uI
        QsclkWzzmRSa8cPekVwb+T9A+nQQFZweo3hsEzBfYw==
X-Google-Smtp-Source: ABdhPJyMBUXVMy1dbXS/9jiSxzuOB4+MPHYYNxYv2v7Sgm+ygNxoI6AmV9m7ksTpLP81TrjRBtfaaWBuaBVsowf6H4Q=
X-Received: by 2002:a17:906:1386:: with SMTP id f6mr121260ejc.45.1615406520961;
 Wed, 10 Mar 2021 12:02:00 -0800 (PST)
MIME-Version: 1.0
References: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com> <8-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
 <CAPcyv4hqALoBpH-yir4WNPj4+z1n-zj4o_6bfOMBRmd5sOCMNw@mail.gmail.com> <20210310125826.GV2356281@nvidia.com>
In-Reply-To: <20210310125826.GV2356281@nvidia.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 10 Mar 2021 12:01:49 -0800
Message-ID: <CAPcyv4ipwPeKOxtY4iTbP=4ZyeKsk2yLOGNdiNLv2_vWFk8h8g@mail.gmail.com>
Subject: Re: [PATCH 08/10] vfio: Make vfio_device_ops pass a 'struct
 vfio_device *' instead of 'void *'
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Eric Auger <eric.auger@redhat.com>,
        KVM list <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 10, 2021 at 4:58 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Tue, Mar 09, 2021 at 09:52:30PM -0800, Dan Williams wrote:
> > On Tue, Mar 9, 2021 at 1:39 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >
> > > This is the standard kernel pattern, the ops associated with a struct get
> > > the struct pointer in for typesafety. The expected design is to use
> > > container_of to cleanly go from the subsystem level type to the driver
> > > level type without having any type erasure in a void *.
> >
> > This patch alone is worth the price of admission.
>
> Right, this is how I got here as I was going to do the mdev stuff and
> we end up doing transformations like this:
>
> -static long mtty_ioctl(struct mdev_device *mdev, unsigned int cmd,
> +static long mtty_ioctl(struct vfio_device *vdev, unsigned int cmd,
>                         unsigned long arg)
>
> And if the 'struct vfio_device *vdev' was left a 'void *' then the
> compiler doesn't get to help any more :(
>
> > Seems like it would be worth adding
> > to_vfio_{pci,platform,fsl_mc}_device() helpers in this patch as well.
>
> I have mixed feelings on these one-liners. If people feel they are
> worthwhile I'll add them

It's only worthwhile in my opinion if it makes the diffstat more
favorable for lines removed.

>
> > I've sometimes added runtime type safety to to_* helpers for early
> > warning of mistakes that happen when refactoring...
> >
> > static inline struct vfio_pci_device *
> > to_vfio_pci_device(struct vfio_device *core_dev)
> > {
> >         if (dev_WARN_ONCE(core_dev->dev, core_dev->ops != &vfio_pci_ops,
> >                           "not a vfio_pci_device!\n"))
> >                 return NULL;
> >         return container_of(core_vdev, struct vfio_pci_device, vdev);
>
> In this case I don't think we need to worry as everything is tidy in a
> single module such that the compilation units can't see other
> container_of options anyhow and vfio core isn't going to accidently
> call an ops with the wrong type.

Sounds good.

You can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
