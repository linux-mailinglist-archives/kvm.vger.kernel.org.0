Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36F2949510B
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 16:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376484AbiATPIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 10:08:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46928 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1376471AbiATPIt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Jan 2022 10:08:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642691328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gYYcMS9ElXmPxhejwGj3w8BFf5deCBvIUvWdoFiI1Oo=;
        b=EJD7E8ejrHNuxo8LJWUM6ntAyDHLmUFGhweTBZhm9Q3SrYcLFFB1iUOmvvuG+KmIE/IFWW
        OjaIjEfM6lf3dQYu7NoAbzqge/6cMMR6gQ+lELsyfCcy+Qvo4epMq5Zw+T+C5JYJ7ykf4w
        AHzs+XX+MNLETDUmD7SiacBdN9gnKrU=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-cVBpQcYbPpyQ5FuTVunDcg-1; Thu, 20 Jan 2022 10:08:47 -0500
X-MC-Unique: cVBpQcYbPpyQ5FuTVunDcg-1
Received: by mail-qk1-f199.google.com with SMTP id b13-20020a05620a270d00b0047ba5ddde8dso4349783qkp.2
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 07:08:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gYYcMS9ElXmPxhejwGj3w8BFf5deCBvIUvWdoFiI1Oo=;
        b=Vsy9+D/QhGrI8kfENvJTKKdDglTU8wvCXXltXwxafGLdI2ZG2M/afMdone86Yquhzm
         t+8XbtFLjqI8qk3IG+l13ytQO2VyYhko9kFft2GiRhUOyfjn37GITeMXlt53tFgsB79R
         CRP7nntHemrlNIiJ2AVSVplJGLtPk0l3cTa6Vjk6vK+jmXjau3Ofkxgpn+OM8SysgQ/5
         nqEXZT77bkE8FacfpeGrLDn86zK8j/VTjyf7cPSxXIGa1blxlW3ko6pztOBUHJiCrsD3
         KPJWEOBcYEcV4Ps7w9ILDA3+ImzoLBEh4xgbI5La5uE+tMilVLYQe6mYi25yU29bCUzZ
         DmtQ==
X-Gm-Message-State: AOAM531ggezvdWmr8/d7xbOfWChxXLk6hk0P0qUaeJgAQfSJQdYw+jOR
        NLKmMnkqcgtMGTCn6L9h2bnPZEWeW6HvnPy+yydfTc1cfRWWnEAioipZ20H6wIBRwS1KMuSh2lA
        FMrXvzsYmOilf
X-Received: by 2002:a37:be05:: with SMTP id o5mr24710547qkf.783.1642691326852;
        Thu, 20 Jan 2022 07:08:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy5Pi4s98oM6StYysiaSOHyNFUiF/d2WGoxCsgiVXZwqPlJaOX0N2+jgGMV1C+i5MoHhbalXA==
X-Received: by 2002:a37:be05:: with SMTP id o5mr24710516qkf.783.1642691326552;
        Thu, 20 Jan 2022 07:08:46 -0800 (PST)
Received: from steredhat (host-95-238-125-214.retail.telecomitalia.it. [95.238.125.214])
        by smtp.gmail.com with ESMTPSA id o126sm1512302qke.53.2022.01.20.07.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 07:08:45 -0800 (PST)
Date:   Thu, 20 Jan 2022 16:08:39 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linux Virtualization <virtualization@lists.linux-foundation.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        kvm <kvm@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v1] vhost: cache avail index in vhost_enable_notify()
Message-ID: <CAGxU2F7r6cH9Ywygv1QNxKyfyn=yGoDPNDQ-tHkeFMUcbpfXYA@mail.gmail.com>
References: <20220114090508.36416-1-sgarzare@redhat.com>
 <20220114074454-mutt-send-email-mst@kernel.org>
 <20220114133816.7niyaqygvdveddmi@steredhat>
 <20220114084016-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220114084016-mutt-send-email-mst@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 14, 2022 at 2:40 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Fri, Jan 14, 2022 at 02:38:16PM +0100, Stefano Garzarella wrote:
> > On Fri, Jan 14, 2022 at 07:45:35AM -0500, Michael S. Tsirkin wrote:
> > > On Fri, Jan 14, 2022 at 10:05:08AM +0100, Stefano Garzarella wrote:
> > > > In vhost_enable_notify() we enable the notifications and we read
> > > > the avail index to check if new buffers have become available in
> > > > the meantime.
> > > >
> > > > We are not caching the avail index, so when the device will call
> > > > vhost_get_vq_desc(), it will find the old value in the cache and
> > > > it will read the avail index again.
> > > >
> > > > It would be better to refresh the cache every time we read avail
> > > > index, so let's change vhost_enable_notify() caching the value in
> > > > `avail_idx` and compare it with `last_avail_idx` to check if there
> > > > are new buffers available.
> > > >
> > > > Anyway, we don't expect a significant performance boost because
> > > > the above path is not very common, indeed vhost_enable_notify()
> > > > is often called with unlikely(), expecting that avail index has
> > > > not been updated.
> > > >
> > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > >
> > > ... and can in theory even hurt due to an extra memory write.
> > > So ... performance test restults pls?
> >
> > Right, could be.
> >
> > I'll run some perf test with vsock, about net, do you have a test suite or
> > common step to follow to test it?
> >
> > Thanks,
> > Stefano
>
> You can use the vhost test as a unit test as well.

Thanks for the advice, I did indeed use it!

I run virtio_test (with vhost_test.ko) using 64 as batch to increase the 
chance of the path being taken. (I changed bufs=0x1000000 in 
virtio_test.c to increase the duration).

I used `perf stat` to take some numbers, running this command:

   taskset -c 2 perf stat -r 10 --log-fd 1 -- ./virtio_test --batch=64

- Linux v5.16 without the patch applied

 Performance counter stats for './virtio_test --batch=64' (10 runs):

          2,791.70 msec task-clock                #    0.996 CPUs utilized            ( +-  0.36% )
                23      context-switches          #    8.209 /sec                     ( +-  2.75% )
                 0      cpu-migrations            #    0.000 /sec
                79      page-faults               #   28.195 /sec                     ( +-  0.41% )
     7,249,926,989      cycles                    #    2.587 GHz                      ( +-  0.36% )
     7,711,999,656      instructions              #    1.06  insn per cycle           ( +-  1.08% )
     1,838,436,806      branches                  #  656.134 M/sec                    ( +-  1.44% )
         3,055,439      branch-misses             #    0.17% of all branches          ( +-  6.22% )

            2.8024 +- 0.0100 seconds time elapsed  ( +-  0.36% )

- Linux v5.16 with this patch applied

 Performance counter stats for './virtio_test --batch=64' (10 runs):

          2,753.36 msec task-clock                #    0.998 CPUs utilized            ( +-  0.20% )
                24      context-switches          #    8.699 /sec                     ( +-  2.86% )
                 0      cpu-migrations            #    0.000 /sec
                76      page-faults               #   27.545 /sec                     ( +-  0.56% )
     7,150,358,721      cycles                    #    2.592 GHz                      ( +-  0.20% )
     7,420,639,950      instructions              #    1.04  insn per cycle           ( +-  0.76% )
     1,745,759,193      branches                  #  632.730 M/sec                    ( +-  1.03% )
         3,022,508      branch-misses             #    0.17% of all branches          ( +-  3.24% )

           2.75952 +- 0.00561 seconds time elapsed  ( +-  0.20% )


The difference seems minimal with a slight improvement.

To try to stress the patch more, I modified vhost_test.ko to call 
vhost_enable_notify()/vhost_disable_notify() on every cycle when calling 
vhost_get_vq_desc():

- Linux v5.16 modified without the patch applied

 Performance counter stats for './virtio_test --batch=64' (10 runs):

          4,126.66 msec task-clock                #    1.006 CPUs utilized            ( +-  0.25% )
                28      context-switches          #    6.826 /sec                     ( +-  3.41% )
                 0      cpu-migrations            #    0.000 /sec
                85      page-faults               #   20.721 /sec                     ( +-  0.44% )
    10,716,808,883      cycles                    #    2.612 GHz                      ( +-  0.25% )
    11,804,381,462      instructions              #    1.11  insn per cycle           ( +-  0.86% )
     3,138,813,438      branches                  #  765.153 M/sec                    ( +-  1.03% )
        11,286,860      branch-misses             #    0.35% of all branches          ( +-  1.23% )

            4.1027 +- 0.0103 seconds time elapsed  ( +-  0.25% )

- Linux v5.16 modified with this patch applied

 Performance counter stats for './virtio_test --batch=64' (10 runs):

          3,953.55 msec task-clock                #    1.001 CPUs utilized            ( +-  0.33% )
                29      context-switches          #    7.345 /sec                     ( +-  2.67% )
                 0      cpu-migrations            #    0.000 /sec
                83      page-faults               #   21.021 /sec                     ( +-  0.65% )
    10,267,242,653      cycles                    #    2.600 GHz                      ( +-  0.33% )
     7,972,866,579      instructions              #    0.78  insn per cycle           ( +-  0.21% )
     1,663,770,390      branches                  #  421.377 M/sec                    ( +-  0.45% )
        16,986,093      branch-misses             #    1.02% of all branches          ( +-  0.47% )

            3.9489 +- 0.0130 seconds time elapsed  ( +-  0.33% )

In this case the difference is bigger, with a reduction in execution 
time (3.7 %) and fewer branches and instructions. It should be the 
branch `if (vq->avail_idx == vq->last_avail_idx)` in vhost_get_vq_desc() 
that is not taken.

Should I resend the patch adding some more performance information?

Thanks,
Stefano

