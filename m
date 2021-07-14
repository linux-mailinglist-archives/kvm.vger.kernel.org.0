Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690B63C7E0E
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 07:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237959AbhGNFsR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 01:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237802AbhGNFsQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 01:48:16 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03BABC0613EF
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 22:45:23 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id l26so1446705eda.10
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 22:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CHZPSlSYGfv/SLrxAM/jOzUDS1kn5mU0G7/MnH+av7w=;
        b=TFIXYmOj7xWCYyEiL8IfX/z7XfVUXzphq5lOB8eXolpRNkYjOSMo0nDnxvLCmz0v0P
         4eGMqbLigvSrkWD5Ktxv46HxIXTFcGk13cG3kVrsNbQzLREMK2CU0ptM1QqPqXW9BxdS
         yI4oyRP0mP48+7gXh6dqlj0high4D9cExctbn2AE52uoOqBY9Swobwxv+2it40H4ayu7
         w3w1GZTkgOOUrnt/2hwL0W/gWDo4Pi9Ue3FoX1Gqies4/s5dcU7t+zv44Y6s1Srs86AZ
         4j0nZgRECcfTY+He18dAroizi7KMqRIvXRIBJ9g/s8NvMcfm0xZ4ZqsIQ2184Hh5NyoU
         dwow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CHZPSlSYGfv/SLrxAM/jOzUDS1kn5mU0G7/MnH+av7w=;
        b=L5ZUi5ojW7xjtRb3n+OUbttc5WeXLY0R42rv5WuA6t6tC0bbKd0ww4XY6E/tVfhr3k
         9mVFkenUD1eEoiA9n/5ODHkNzhL3PKzmUycJDJmKLMh6BeliNiD7Y8KK7rphDrKkNvsH
         AGNmHn2pGNzN5Bv/wqIk9FawZ15VAfpC/oJZD6+7oE0+OoclQfslWH8fKhIBcKH/sEZ9
         oW/ulRRPbwGIX3yvFq6V7FVHpzz0kOY6jQeGibw3M2Hl2/ABqCi1ZmwZPy1eb12Ss64c
         y7Zr4HGhY+l0nxITc7mcMMuWjdbBOe5F0tJJs6VClkZikaszBv2dbmPK4DFPr2mnWi4d
         tbqQ==
X-Gm-Message-State: AOAM5338nNhCG6G02llgbJTKjJvLFQAvPgLkwMhbOodI6Pa2dN6a1hc3
        7bDB/2L2DzWhZSpeSm5MrClodq7yIip7BQj5ouE4
X-Google-Smtp-Source: ABdhPJxB+DrOBDXuwclE4BqKnRj6flob2oW8SNccGw0iEXIiLGhLEqaAkjs4n04tANFRLCsq6H5lMvNd7tbeRCpkn8s=
X-Received: by 2002:a50:ff01:: with SMTP id a1mr10874200edu.253.1626241521339;
 Tue, 13 Jul 2021 22:45:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210713084656.232-1-xieyongji@bytedance.com> <20210713084656.232-17-xieyongji@bytedance.com>
 <20210713132741.GM1954@kadam> <c42979dd-331f-4af5-fda6-18d80f22be2d@redhat.com>
In-Reply-To: <c42979dd-331f-4af5-fda6-18d80f22be2d@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 14 Jul 2021 13:45:10 +0800
Message-ID: <CACycT3vNiAdOLVRhjqUjZGBfPnCti+_5+vdkgtbJ4XyRsYfrPg@mail.gmail.com>
Subject: Re: [PATCH v9 16/17] vduse: Introduce VDUSE - vDPA Device in Userspace
To:     Jason Wang <jasowang@redhat.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
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
        joro@8bytes.org, Greg KH <gregkh@linuxfoundation.org>,
        He Zhe <zhe.he@windriver.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>,
        songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 14, 2021 at 10:54 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/7/13 =E4=B8=8B=E5=8D=889:27, Dan Carpenter =E5=86=99=E9=81=
=93:
> > On Tue, Jul 13, 2021 at 04:46:55PM +0800, Xie Yongji wrote:
> >> +static int vduse_dev_init_vdpa(struct vduse_dev *dev, const char *nam=
e)
> >> +{
> >> +    struct vduse_vdpa *vdev;
> >> +    int ret;
> >> +
> >> +    if (dev->vdev)
> >> +            return -EEXIST;
> >> +
> >> +    vdev =3D vdpa_alloc_device(struct vduse_vdpa, vdpa, dev->dev,
> >> +                             &vduse_vdpa_config_ops, name, true);
> >> +    if (!vdev)
> >> +            return -ENOMEM;
> > This should be an IS_ERR() check instead of a NULL check.
>
>
> Yes.
>
>
> >
> > The vdpa_alloc_device() macro is doing something very complicated but
> > I'm not sure what.  It calls container_of() and that looks buggy until
> > you spot the BUILD_BUG_ON_ZERO() compile time assert which ensures that
> > the container_of() is a no-op.
> >
> > Only one of the callers checks for error pointers correctly so maybe
> > it's too complicated or maybe there should be better documentation.
>
>
> We need better documentation for this macro and fix all the buggy callers=
.
>
> Yong Ji, want to do that?
>

Sure, I will send the fix soon.

Thanks,
Yongji
