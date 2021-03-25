Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B92348E7B
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 12:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhCYLEX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 07:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbhCYLEQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 07:04:16 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B673C061761
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 04:04:15 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id z1so1907074edb.8
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 04:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j2E60y1zApCOo+ENPh4Raxx8g6jv2cSuCJQwpROVgZM=;
        b=NJGQnx0hgav0GkNAdtKNYFd7qAmAChqCbGdNkXAUa3cC8TQHvdXIjOG60ulPMn73HL
         mA7Nflw13a2bx1P7QUnfLz54yS/cJ+Ull7wFnwig6BLiedqJxfX5CyYUygAgJ4pdF9xa
         xcYhu982NODL5AucrVjVrnlv5A9vCfEYPJAipKfO2tFBXZYTb/VExa3Zvno/Rw5kNgo5
         WyLZxP+lh+89M2hO1MZdYmMLcldZYgIoM77y5S0HwTLg5URwYyKFyn3/bKzIpMl8D2Cr
         EkrMNUf+M/nxEAToXIbU7k05Dosj/5n7X/mn+VoUgYzebFt4zXmbPtTTsWNrOXymqeQg
         6Myw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j2E60y1zApCOo+ENPh4Raxx8g6jv2cSuCJQwpROVgZM=;
        b=oBfmR9Ol1tydrtDxc7wcAajmFl/idgq6DKG21UPe3adYAg3bLfP8+CYFHMtAAIyOU2
         PlX80ryLTVN4WrF2Vo/+RmeLnmwJsh09BFXT4BzWfcYbxcwkY+/TKL4z8Q2RjJXjpb3k
         CTIv7Iw9paDW5ECG0cE2997ZWlfTCet3G8IzgQHBy4fjjQcNhozB0FNP03+obQm6epNX
         moIAVkgpzVvbX+1+noPmxtTvzqUKM/oBMbZ65DSsNAjj7QkmeNy4Af/w5e04lyKHsPJD
         f8tGseE+52VrzVgLSP2IB23/30xExQD2hzP2lclqCuEtmWqsJmi4/6ChQDORPIs9Yggl
         Wpdw==
X-Gm-Message-State: AOAM532tGk3n01tSKSZKvXxArC8agocUmyqYqzrAxGDTZEvr6v1wQbNR
        X6tQI2MbjPOE99oUONBs3r2kuK483wOOKlXu5hlD
X-Google-Smtp-Source: ABdhPJwfx6x9YQM73q+Dp50D7TkGMmiBWWO++0MkTstakFGwRy8KOMmbPhHLSGmWxz4gE1lZVY0LAsR3u2gni+Bnu6Q=
X-Received: by 2002:a05:6402:4314:: with SMTP id m20mr8215245edc.5.1616670254143;
 Thu, 25 Mar 2021 04:04:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210315053721.189-1-xieyongji@bytedance.com> <20210315053721.189-2-xieyongji@bytedance.com>
 <20210315090822.GA4166677@infradead.org> <CACycT3vrHOExXj6v8ULvUzdLcRkdzS5=TNK6=g4+RWEdN-nOJw@mail.gmail.com>
 <20210325082352.GA2988009@infradead.org>
In-Reply-To: <20210325082352.GA2988009@infradead.org>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 25 Mar 2021 19:04:03 +0800
Message-ID: <CACycT3ta_FdLD2GMNuJ7QHNucCaf4hHEsUgG0WNZJNQzNk9J9A@mail.gmail.com>
Subject: Re: Re: [PATCH v5 01/11] file: Export __receive_fd() to modules
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Christian Brauner <christian.brauner@canonical.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        "Mika Penttil??" <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 25, 2021 at 4:25 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Mon, Mar 15, 2021 at 05:46:43PM +0800, Yongji Xie wrote:
> > On Mon, Mar 15, 2021 at 5:08 PM Christoph Hellwig <hch@infradead.org> wrote:
> > >
> > > On Mon, Mar 15, 2021 at 01:37:11PM +0800, Xie Yongji wrote:
> > > > Export __receive_fd() so that some modules can use
> > > > it to pass file descriptor between processes.
> > >
> > > I really don't think any non-core code should do that, especilly not
> > > modular mere driver code.
> >
> > Do you see any issue? Now I think we're able to do that with the help
> > of get_unused_fd_flags() and fd_install() in modules. But we may miss
> > some security stuff in this way. So I try to export __receive_fd() and
> > use it instead.
>
> The real problem is now what helper to use, but rather that random
> drivers should not just mess with the FD table like that.

I see. I will use receive_fd() instead that only receives and installs
an fd. This is indeed needed in our cases.

Thanks,
Yongji
