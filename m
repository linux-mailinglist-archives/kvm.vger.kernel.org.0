Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9BE3BE573
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 11:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbhGGJW2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 05:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbhGGJW1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 05:22:27 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F4FC061762
        for <kvm@vger.kernel.org>; Wed,  7 Jul 2021 02:19:47 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id v20so2157377eji.10
        for <kvm@vger.kernel.org>; Wed, 07 Jul 2021 02:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ntF5ShiMpxZzH3NgDCu0lj/qLit/wsTznB+iv/n6Jts=;
        b=EkUktZhVW6Hw0D3CwFrVu6SPtBCLkJYy2M7BJM1xaa8T71w3Am8UIGnGLzZ7sZjGBy
         oJPZFOsWMkQsg1Eor8GYHzrS0gvtg/qEnI+kjIYCFKEPoLzQIQX6UgYFrffMXB7uW8ud
         DAJeTUNRxqnYoE0JTnNDRQ4iWBS+hwKVMh6CzB8D/Nd7MUwmVBFXb/1DGoN5IcQxOlxA
         XEcMYCGgJ6/e1b9/F4uGKBE66Lafq27VxOH+bGLgnrQlIyePfFxmfVAzA2OsUgePTZRJ
         T3ukDS1lDG6sIQr7dau/XyarH0KZbl27sp8FmAm/INCn+Zavbu6Ds2cG23H+ZLiJNIkK
         nv1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ntF5ShiMpxZzH3NgDCu0lj/qLit/wsTznB+iv/n6Jts=;
        b=LdifzSU/2JiWoYgqg9roYkucj7sv+XwoQY8LYLsvqG0Hg6fM4ao8wk1WwRjNmNZQ8o
         YT22mje7Gc5YxzoNxYi+TbzFdINR2KJser8bE9OVvDJV1EKWSjOkmpmgfG0P1+AlmmFu
         1fKwRCuuQFw0bCHqTnT1/zHbuMJBSwFlIfDlQAZXTu4vi/FmfYLXUmzT7OPvDo0+/amB
         svbXAo7bIUw4LXV1YemuHLA5i18tjB/gg8cuDxpq4Ryp6gw7BPOVy9B3SGhaCjwUjVI3
         i5D6wGQxI7VmvAlDeBof/t2KPS8TzbGvw1txBujRLxPZ2DyTp+5qlVyK0sg1ZPQu6K3Y
         yzVA==
X-Gm-Message-State: AOAM533/XU3G/876zcw4CRHwbnNJVjVrqQO3hQSpYIZXBhMeITmqIAd7
        U7nyZnRsJ6/5J+3HgpO9yt1IZzMgusM5z95aNsN/
X-Google-Smtp-Source: ABdhPJwfUSLvIX93bY45nGlunKheveZx2mGwfBnicH+p8nMulhsjVrxLC9+PoE5I/qwuA5U0XX93SwRw5wHXZDNyzBo=
X-Received: by 2002:a17:906:cb93:: with SMTP id mf19mr20870738ejb.427.1625649585892;
 Wed, 07 Jul 2021 02:19:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210615141331.407-1-xieyongji@bytedance.com> <20210615141331.407-10-xieyongji@bytedance.com>
 <YOVrZtGIEjZZSSoU@stefanha-x1.localdomain>
In-Reply-To: <YOVrZtGIEjZZSSoU@stefanha-x1.localdomain>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 7 Jul 2021 17:19:35 +0800
Message-ID: <CACycT3tvvMpsjmJGhY5duNCXt5YyyWqQ2MpxRuMKQwmtpgF0Aw@mail.gmail.com>
Subject: Re: [PATCH v8 09/10] vduse: Introduce VDUSE - vDPA Device in Userspace
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
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
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 7, 2021 at 4:53 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> On Tue, Jun 15, 2021 at 10:13:30PM +0800, Xie Yongji wrote:
> > +static bool vduse_validate_config(struct vduse_dev_config *config)
> > +{
>
> The name field needs to be NUL terminated?
>

I think so.

> > +     case VDUSE_CREATE_DEV: {
> > +             struct vduse_dev_config config;
> > +             unsigned long size = offsetof(struct vduse_dev_config, config);
> > +             void *buf;
> > +
> > +             ret = -EFAULT;
> > +             if (copy_from_user(&config, argp, size))
> > +                     break;
> > +
> > +             ret = -EINVAL;
> > +             if (vduse_validate_config(&config) == false)
> > +                     break;
> > +
> > +             buf = vmemdup_user(argp + size, config.config_size);
> > +             if (IS_ERR(buf)) {
> > +                     ret = PTR_ERR(buf);
> > +                     break;
> > +             }
> > +             ret = vduse_create_dev(&config, buf, control->api_version);
> > +             break;
> > +     }
> > +     case VDUSE_DESTROY_DEV: {
> > +             char name[VDUSE_NAME_MAX];
> > +
> > +             ret = -EFAULT;
> > +             if (copy_from_user(name, argp, VDUSE_NAME_MAX))
> > +                     break;
>
> Is this missing a NUL terminator?

Oh, yes. Looks like I need to set '\0' to name[VDUSE_VDUSE_NAME_MAX - 1] here.

Thanks,
Yongji
