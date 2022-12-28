Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90CE965739C
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 08:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbiL1HVT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 02:21:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiL1HVQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 02:21:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EFDAFACB
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 23:20:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672212026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7p/vayyP8zWaxjPZEqa7TOM9QZB/OUBM2psrPg6s4TY=;
        b=XNhzPtEHGrGzkqzELeuXmYgTu2JRi+C8g9HqLpyXecp7RtyY7oHUmH/yWYkz/XP6kJs9hk
        mL3JSeVnehz+ZFYDfGP/1VvSdUIwUidgmtCteZkNH8Wu/Id0UgehphXe2hp3OOw383nqHx
        P821EI9IWtA+z7Y2HYJVHm5tjLvQJBc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-98-hNxsSkEBM1ev_7-LY2wI8Q-1; Wed, 28 Dec 2022 02:20:24 -0500
X-MC-Unique: hNxsSkEBM1ev_7-LY2wI8Q-1
Received: by mail-wr1-f71.google.com with SMTP id t18-20020adfa2d2000000b00277e6c6f275so904179wra.0
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 23:20:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7p/vayyP8zWaxjPZEqa7TOM9QZB/OUBM2psrPg6s4TY=;
        b=6UD9DdUtWy+4mFHi55Yk2BpzJkA9IQqJcHNrq4tm2JeUUh9nLUQ1owRcyvWB29W5Di
         gUlrQRPwolpdfLgAUPI7OQHHPd1Nw4mjleHghpwc0VUiw72m/Tg2o3742+Amhs0/POs+
         iFYxisVLwulUzgzliii1DVY65eHH6TR5j9M+AMCQWNP3C+ivBJzfMTl+mMDhBCwQSj9k
         WxXf32j7PURlmQ9/G2TXY0kQWMLJLieYa9/oas90FUp/ZGqvf9BZSGkj+rRXkSQwHalS
         NwJA9ckM7BwsNkYEJfO6NAJEkvtN3hRGnWMWPMSosoGaC1REYoEjaoGLWTm+G3P6HJXD
         f2kQ==
X-Gm-Message-State: AFqh2koCIJutOPa6sahCIrgjPaUbXVzuxfovFGBZVoBDQqxkJ3TXABHQ
        +XoR62XjJ+pur6MGA7+V57phuOb4WnVbU1+K2Zmp0OOVK7RWDEcf68+pOfKsj2XOtijmZmKdCq9
        eq2lOxfTV06NP
X-Received: by 2002:a7b:cbd4:0:b0:3d3:3d51:7d44 with SMTP id n20-20020a7bcbd4000000b003d33d517d44mr17093102wmi.33.1672212023523;
        Tue, 27 Dec 2022 23:20:23 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtANV2jcLiF8FOUgRwAbdZCJlTx1cmFHZF/EGV/YNCYif1iFoN8Etw6/Ex+BxcMNQN/2wrnfg==
X-Received: by 2002:a7b:cbd4:0:b0:3d3:3d51:7d44 with SMTP id n20-20020a7bcbd4000000b003d33d517d44mr17093090wmi.33.1672212023191;
        Tue, 27 Dec 2022 23:20:23 -0800 (PST)
Received: from redhat.com ([2.52.151.85])
        by smtp.gmail.com with ESMTPSA id k31-20020a05600c1c9f00b003d22528decesm26573211wms.43.2022.12.27.23.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 23:20:22 -0800 (PST)
Date:   Wed, 28 Dec 2022 02:20:19 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Shunsuke Mie <mie@igel.co.jp>
Cc:     Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/9] vringh: unify the APIs for all accessors
Message-ID: <20221228021354-mutt-send-email-mst@kernel.org>
References: <20221227022528.609839-1-mie@igel.co.jp>
 <20221227022528.609839-5-mie@igel.co.jp>
 <20221227020007-mutt-send-email-mst@kernel.org>
 <CANXvt5pRy-i7=_ikNkZPp2HcRmWZYNJYpjO_ieBJJVc90nds+A@mail.gmail.com>
 <CANXvt5qUUOqB1CVgAk5KyL9sV+NsnJSKhatvdV12jH5=kBjjJw@mail.gmail.com>
 <20221227075332-mutt-send-email-mst@kernel.org>
 <CANXvt5qTbGi7p5Y7eVSjyHJ7MLjiMgGKyAM-LEkJZXvhtSh7vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANXvt5qTbGi7p5Y7eVSjyHJ7MLjiMgGKyAM-LEkJZXvhtSh7vw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 28, 2022 at 11:24:10AM +0900, Shunsuke Mie wrote:
> 2022年12月27日(火) 23:37 Michael S. Tsirkin <mst@redhat.com>:
> >
> > On Tue, Dec 27, 2022 at 07:22:36PM +0900, Shunsuke Mie wrote:
> > > 2022年12月27日(火) 16:49 Shunsuke Mie <mie@igel.co.jp>:
> > > >
> > > > 2022年12月27日(火) 16:04 Michael S. Tsirkin <mst@redhat.com>:
> > > > >
> > > > > On Tue, Dec 27, 2022 at 11:25:26AM +0900, Shunsuke Mie wrote:
> > > > > > Each vringh memory accessors that are for user, kern and iotlb has own
> > > > > > interfaces that calls common code. But some codes are duplicated and that
> > > > > > becomes loss extendability.
> > > > > >
> > > > > > Introduce a struct vringh_ops and provide a common APIs for all accessors.
> > > > > > It can bee easily extended vringh code for new memory accessor and
> > > > > > simplified a caller code.
> > > > > >
> > > > > > Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
> > > > > > ---
> > > > > >  drivers/vhost/vringh.c | 667 +++++++++++------------------------------
> > > > > >  include/linux/vringh.h | 100 +++---
> > > > > >  2 files changed, 225 insertions(+), 542 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> > > > > > index aa3cd27d2384..ebfd3644a1a3 100644
> > > > > > --- a/drivers/vhost/vringh.c
> > > > > > +++ b/drivers/vhost/vringh.c
> > > > > > @@ -35,15 +35,12 @@ static __printf(1,2) __cold void vringh_bad(const char *fmt, ...)
> > > > > >  }
> > > > > >
> > > > > >  /* Returns vring->num if empty, -ve on error. */
> > > > > > -static inline int __vringh_get_head(const struct vringh *vrh,
> > > > > > -                                 int (*getu16)(const struct vringh *vrh,
> > > > > > -                                               u16 *val, const __virtio16 *p),
> > > > > > -                                 u16 *last_avail_idx)
> > > > > > +static inline int __vringh_get_head(const struct vringh *vrh, u16 *last_avail_idx)
> > > > > >  {
> > > > > >       u16 avail_idx, i, head;
> > > > > >       int err;
> > > > > >
> > > > > > -     err = getu16(vrh, &avail_idx, &vrh->vring.avail->idx);
> > > > > > +     err = vrh->ops.getu16(vrh, &avail_idx, &vrh->vring.avail->idx);
> > > > > >       if (err) {
> > > > > >               vringh_bad("Failed to access avail idx at %p",
> > > > > >                          &vrh->vring.avail->idx);
> > > > >
> > > > > I like that this patch removes more lines of code than it adds.
> > > > >
> > > > > However one of the design points of vringh abstractions is that they were
> > > > > carefully written to be very low overhead.
> > > > > This is why we are passing function pointers to inline functions -
> > > > > compiler can optimize that out.
> > > > >
> > > > > I think that introducing ops indirect functions calls here is going to break
> > > > > these assumptions and hurt performance.
> > > > > Unless compiler can somehow figure it out and optimize?
> > > > > I don't see how it's possible with ops pointer in memory
> > > > > but maybe I'm wrong.
> > > > I think your concern is correct. I have to understand the compiler
> > > > optimization and redesign this approach If it is needed.
> > > > > Was any effort taken to test effect of these patches on performance?
> > > > I just tested vringh_test and already faced little performance reduction.
> > > > I have to investigate that, as you said.
> > > I attempted to test with perf. I found that the performance of patched code
> > > is almost the same as the upstream one. However, I have to investigate way
> > > this patch leads to this result, also the profiling should be run on
> > > more powerful
> > > machines too.
> > >
> > > environment:
> > > $ grep 'model name' /proc/cpuinfo
> > > model name      : Intel(R) Core(TM) i3-7020U CPU @ 2.30GHz
> > > model name      : Intel(R) Core(TM) i3-7020U CPU @ 2.30GHz
> > > model name      : Intel(R) Core(TM) i3-7020U CPU @ 2.30GHz
> > > model name      : Intel(R) Core(TM) i3-7020U CPU @ 2.30GHz
> > >
> > > results:
> > > * for patched code
> > >  Performance counter stats for 'nice -n -20 ./vringh_test_patched
> > > --parallel --eventidx --fast-vringh --indirect --virtio-1' (20 runs):
> > >
> > >           3,028.05 msec task-clock                #    0.995 CPUs
> > > utilized            ( +-  0.12% )
> > >             78,150      context-switches          #   25.691 K/sec
> > >                ( +-  0.00% )
> > >                  5      cpu-migrations            #    1.644 /sec
> > >                ( +-  3.33% )
> > >                190      page-faults               #   62.461 /sec
> > >                ( +-  0.41% )
> > >      6,919,025,222      cycles                    #    2.275 GHz
> > >                ( +-  0.13% )
> > >      8,990,220,160      instructions              #    1.29  insn per
> > > cycle           ( +-  0.04% )
> > >      1,788,326,786      branches                  #  587.899 M/sec
> > >                ( +-  0.05% )
> > >          4,557,398      branch-misses             #    0.25% of all
> > > branches          ( +-  0.43% )
> > >
> > >            3.04359 +- 0.00378 seconds time elapsed  ( +-  0.12% )
> > >
> > > * for upstream code
> > >  Performance counter stats for 'nice -n -20 ./vringh_test_base
> > > --parallel --eventidx --fast-vringh --indirect --virtio-1' (10 runs):
> > >
> > >           3,058.41 msec task-clock                #    0.999 CPUs
> > > utilized            ( +-  0.14% )
> > >             78,149      context-switches          #   25.545 K/sec
> > >                ( +-  0.00% )
> > >                  5      cpu-migrations            #    1.634 /sec
> > >                ( +-  2.67% )
> > >                194      page-faults               #   63.414 /sec
> > >                ( +-  0.43% )
> > >      6,988,713,963      cycles                    #    2.284 GHz
> > >                ( +-  0.14% )
> > >      8,512,533,269      instructions              #    1.22  insn per
> > > cycle           ( +-  0.04% )
> > >      1,638,375,371      branches                  #  535.549 M/sec
> > >                ( +-  0.05% )
> > >          4,428,866      branch-misses             #    0.27% of all
> > > branches          ( +- 22.57% )
> > >
> > >            3.06085 +- 0.00420 seconds time elapsed  ( +-  0.14% )
> >
> >
> > How you compiled it also matters. ATM we don't enable retpolines
> > and it did not matter since we didn't have indirect calls,
> > but we should. Didn't yet investigate how to do that for virtio tools.
> I think the retpolines certainly affect performance. Thank you for pointing
> it out. I'd like to start the investigation that how to apply the
> retpolines to the
> virtio tools.
> > > > Thank you for your comments.
> > > > > Thanks!
> > > > >
> > > > >
> > > > Best,
> > > > Shunsuke.

This isn't all that trivial if we want this at runtime.
But compile time is kind of easy.
See Documentation/admin-guide/hw-vuln/spectre.rst



-- 
MST

