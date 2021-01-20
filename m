Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18C42FCB35
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 07:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbhATGyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 01:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbhATGxa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 01:53:30 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3472DC0613D3
        for <kvm@vger.kernel.org>; Tue, 19 Jan 2021 22:52:50 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id bx12so10445802edb.8
        for <kvm@vger.kernel.org>; Tue, 19 Jan 2021 22:52:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OUwyk7xtJXT5NiDavD07ZTFekT45AnyTwd1+tu8BV2s=;
        b=pnwim4oCTPJUkeAUxNAT5zomyWF/8LBZ1cr/prJSrtoyHr6HXwRulATLeGbM/zO+Ds
         iqSkBnm5FA9GpCYr9mahnXVLdDvm3bdZX5GeRjmIUXWkd0oW4aY7i0dX6thJBZ3mMVSV
         kWWzYR0S87bDJHTos/rkGTLnwTAx9SG+OZRig4PiWcIGWCrfXuJmOjX0DzJnInkNrP35
         pB4N6RKJdbQJV87bfF3r/Bm8NHvVpa5erF24fOAXjjbO5h7EtqLSRTdmt2rPNoqOJQ/v
         xZ5GndPVEXc7GmGALiHmeXTnM/YhXGYk4iKYyiuWGdXGm8MYsZHmPZawRrhsinkdASfM
         xHOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OUwyk7xtJXT5NiDavD07ZTFekT45AnyTwd1+tu8BV2s=;
        b=ZbCUhGbEpenzTPbXCBh6VF4BBoDiRwU9OfejyqAuSpTU+2RUos6aeJAenDbTwhAwdk
         +nfxDwD1Dese7FBODgIFZWUjb48emdtvEfmxZ/fMj/6R5L0zmXFMLtlf7VWPh0qRcwce
         Wd9AqyXne6rEn9nJV4kGG8b/ibRuXPsPDjAAXRejJVpsDYD+1oBCV9uPAbhYWUHKtd0c
         hUMghq2EsLcuFG3uczkNLSY0CZ48jvr4xsi6LJFcYpQhhj2fLlImafamMbkf6u/LGE3e
         dktNP3S3c2uYHb3z93gfJ0f7mZlI05dySP9DPXdYiZux1AXVPCxw2GfzjpfXo1sBAu9r
         MaSA==
X-Gm-Message-State: AOAM5307jwwUmp9bmRu0vIH6A7oZzg9hsQMDWbGqeQhy8EIykRptuREO
        uYuJLfZeOb+XzMHQ19OBOwWQV9l+dapvBA9eWVVH
X-Google-Smtp-Source: ABdhPJz8mSZjfHOOyqb5onfPHShDdIVRGCg/2N4z9UKpZS1PnUlAPw4lgExHz6G+gVcVSgVIvukJvyXD7wAAibCHYOw=
X-Received: by 2002:a05:6402:407:: with SMTP id q7mr6214637edv.312.1611125568895;
 Tue, 19 Jan 2021 22:52:48 -0800 (PST)
MIME-Version: 1.0
References: <20210119045920.447-1-xieyongji@bytedance.com> <20210119045920.447-2-xieyongji@bytedance.com>
 <e8a2cc15-80f5-01e0-75ec-ea6281fda0eb@redhat.com>
In-Reply-To: <e8a2cc15-80f5-01e0-75ec-ea6281fda0eb@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 20 Jan 2021 14:52:38 +0800
Message-ID: <CACycT3sN0+dg-NubAK+N-DWf3UDXwWh=RyRX-qC9fwdg3QaLWA@mail.gmail.com>
Subject: Re: Re: [RFC v3 01/11] eventfd: track eventfd_signal() recursion
 depth separately in different cases
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, sgarzare@redhat.com,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, bcrl@kvack.org, Jonathan Corbet <corbet@lwn.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 20, 2021 at 12:24 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/1/19 =E4=B8=8B=E5=8D=8812:59, Xie Yongji wrote:
> > Now we have a global percpu counter to limit the recursion depth
> > of eventfd_signal(). This can avoid deadlock or stack overflow.
> > But in stack overflow case, it should be OK to increase the
> > recursion depth if needed. So we add a percpu counter in eventfd_ctx
> > to limit the recursion depth for deadlock case. Then it could be
> > fine to increase the global percpu counter later.
>
>
> I wonder whether or not it's worth to introduce percpu for each eventfd.
>
> How about simply check if eventfd_signal_count() is greater than 2?
>

It can't avoid deadlock in this way. So we need a percpu counter for
each eventfd to limit the recursion depth for deadlock cases. And
using a global percpu counter to avoid stack overflow.

Thanks,
Yongji
