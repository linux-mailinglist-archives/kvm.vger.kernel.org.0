Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659AB2E6FA5
	for <lists+kvm@lfdr.de>; Tue, 29 Dec 2020 11:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgL2K1H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Dec 2020 05:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgL2K1G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Dec 2020 05:27:06 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B40EC061793
        for <kvm@vger.kernel.org>; Tue, 29 Dec 2020 02:26:26 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id g24so12126713edw.9
        for <kvm@vger.kernel.org>; Tue, 29 Dec 2020 02:26:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nc9wrQqOQHmsxECh3j17j7lV49RpttyGP0GhLK+17YU=;
        b=g8FZxrXDn29l36mNNRQqFUxk81fk2Itx3WjBIW7Apntu4/KmEVLmiFXE1MWX+ipJUk
         UAOCgAmhI6xFWvmfi4QVNi7V6Fnd6Gkia30Al8+0ji+597aKIgp59LUQICjVT+Y2EtIq
         7FmxX87hvndBrwx1CLhvYJCITcbimW9y8PmB5CXOYo5Hnavn2GjTltMo3o6Gs4bE9mwf
         8IVQd9ZpFU16QHr0XdAztMcAR9X/gKFQrcL6P7MpWpzH/Z1yN5/Yiffds4l9DQI7V8RH
         /CDwaQI2zwTC0oTvhW6eeJhjovdt2wxeDCEcjaz8sHFQL7ncJ35XV9K6bEOE1r3iklXv
         fO3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nc9wrQqOQHmsxECh3j17j7lV49RpttyGP0GhLK+17YU=;
        b=NocjLT2fh4mpPaQwK7/swki/tHIZHWdEJlMrEhERNfIw+qdZT4M4Qv2EQS8ZFyHqfx
         zLfyLbkDUzqoqtGrMPL6Y4DPJ373XFTptTz9aHgL5eHiLUj4nPjz0suLS3q50KyUq4Ld
         i7nOC2sF7CDq8fPB/GQTeJ9Aqg/CRTovl11VvEKwJmF1woUAThyfCmGJk8PHel+60pgP
         9PD/HfHXEvqs4YCfxhiBCJ6baRGsZHHXiuqJcmjmIG9dUuJddp3AFE65hnITogkqn4/u
         scERBSOmEJWyI1Fp3gxeeXqLNBhr7FiraOMAJMOmTYObNgLJIXA9fBFJ1rw1yTXpMlXx
         3Cgg==
X-Gm-Message-State: AOAM532aCEPkMqxv/nDvtHQSJd/56a2PRaxsYRW2738u7S/+zk3VecVm
        uMzP/gNE96qPLLDovkSX9xwZ+fRAl3RiZ8nDYBR8
X-Google-Smtp-Source: ABdhPJx/NBTVMKWG6/lXSJcOyZx0RSEHb+cLeMaWZSq0bAb/JjUzj8ZSiqTJ0rANOmxm2lHwgqBOrLYo0zs8/dQFjnI=
X-Received: by 2002:a50:f304:: with SMTP id p4mr44250614edm.118.1609237585156;
 Tue, 29 Dec 2020 02:26:25 -0800 (PST)
MIME-Version: 1.0
References: <20201222145221.711-1-xieyongji@bytedance.com> <CACycT3s=m=PQb5WFoMGhz8TNGme4+=rmbbBTtrugF9ZmNnWxEw@mail.gmail.com>
 <0e6faf9c-117a-e23c-8d6d-488d0ec37412@redhat.com> <CACycT3uwXBYvRbKDWdN3oCekv+o6_Lc=-KTrxejD=fr-zgibGw@mail.gmail.com>
 <2b24398c-e6d9-14ec-2c0d-c303d528e377@redhat.com> <CACycT3uDV43ecScrMh1QVpStuwDETHykJzzY=pkmZjP2Dd2kvg@mail.gmail.com>
 <e77c97c5-6bdc-cdd0-62c0-6ff75f6dbdff@redhat.com> <CACycT3soQoX5avZiFBLEGBuJpdni6-UxdhAPGpWHBWVf+dEySg@mail.gmail.com>
 <1356137727.40748805.1609233068675.JavaMail.zimbra@redhat.com>
In-Reply-To: <1356137727.40748805.1609233068675.JavaMail.zimbra@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 29 Dec 2020 18:26:14 +0800
Message-ID: <CACycT3sg61yRdupnD+jQEkWKsVEvMWfhkJ=5z_bYZLxCibDiHw@mail.gmail.com>
Subject: Re: Re: [RFC v2 09/13] vduse: Add support for processing vhost iotlb message
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, sgarzare@redhat.com,
        Parav Pandit <parav@nvidia.com>, akpm@linux-foundation.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, bcrl@kvack.org, corbet@lwn.net,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 29, 2020 at 5:11 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
>
> ----- Original Message -----
> > On Mon, Dec 28, 2020 at 4:43 PM Jason Wang <jasowang@redhat.com> wrote:
> > >
> > >
> > > On 2020/12/28 =E4=B8=8B=E5=8D=884:14, Yongji Xie wrote:
> > > >> I see. So all the above two questions are because VHOST_IOTLB_INVA=
LIDATE
> > > >> is expected to be synchronous. This need to be solved by tweaking =
the
> > > >> current VDUSE API or we can re-visit to go with descriptors relayi=
ng
> > > >> first.
> > > >>
> > > > Actually all vdpa related operations are synchronous in current
> > > > implementation. The ops.set_map/dma_map/dma_unmap should not return
> > > > until the VDUSE_UPDATE_IOTLB/VDUSE_INVALIDATE_IOTLB message is repl=
ied
> > > > by userspace. Could it solve this problem?
> > >
> > >
> > >   I was thinking whether or not we need to generate IOTLB_INVALIDATE
> > > message to VDUSE during dma_unmap (vduse_dev_unmap_page).
> > >
> > > If we don't, we're probably fine.
> > >
> >
> > It seems not feasible. This message will be also used in the
> > virtio-vdpa case to notify userspace to unmap some pages during
> > consistent dma unmapping. Maybe we can document it to make sure the
> > users can handle the message correctly.
>
> Just to make sure I understand your point.
>
> Do you mean you plan to notify the unmap of 1) streaming DMA or 2)
> coherent DMA?
>
> For 1) you probably need a workqueue to do that since dma unmap can
> be done in irq or bh context. And if usrspace does't do the unmap, it
> can still access the bounce buffer (if you don't zap pte)?
>

I plan to do it in the coherent DMA case. It's true that userspace can
access the dma buffer if userspace doesn't do the unmap. But the dma
pages would not be freed and reused unless user space called munmap()
for them.

Thanks,
Yongji
