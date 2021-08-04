Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08BD3DFADA
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 07:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234982AbhHDFC1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 01:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234937AbhHDFC0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 01:02:26 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE72C061798
        for <kvm@vger.kernel.org>; Tue,  3 Aug 2021 22:02:14 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id z11so1875535edb.11
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 22:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=N+beALY95MrjF7EQlWQ+7qrLEnnewleV96sjHNxuEQs=;
        b=1rLCLS4VnBkloqKEKCZnZytWQey60VsL3htB4tjjDdGtlLAiqoh4sNKJRTSD6PwHMR
         9vnNHw1iSS/Fx6i0RCE4RQQ4vyqq5rtIc36Im9QY2RqHEKf/w7Ug3oZhwlGcXQQVWu+G
         DaqQtL3jX0bh/ha8PFkv/P+nkTaCYS0lRvDdZ7eTBoSHDgR6igcI7RQpNA/OnHviNAOp
         B3a2lMoBgB2yx2PIRIb70LzX8dilNPja4adYWApEFw1rdfLmQVuZMJXeYvIXWxCdUk2b
         bPhkn+mywOFmHQT2BPGuByMD4SU6R+J4yLdJWCNVm7lh1t2vV6tsAG7vZpgywjnOueBE
         IJ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=N+beALY95MrjF7EQlWQ+7qrLEnnewleV96sjHNxuEQs=;
        b=J2oin2p1r6WukfaBoqVtjVTeQmi3CueMyF5gMB/wBURZVX/LwzUIPFcOIbVVef5Vet
         3cvejbvFbh/ju6MOik2Ic4f3ErinF9/FsP+s8TjS1olFMpCiu70Q8q+Mlr+p0zqHNQCl
         ryRypEd7T1sSKR16Qade4yQqZjC8vyGV+7tmia1Cc4lbVxI8L9tp800VdmKzATapo3lk
         pwmCbV3BOCwF0s2g8S1EIeQs6W4xYVKDcaVnkjEle3if3o/vlX7yD+LhIPsoqQU3DQJt
         9jIiSb42xWdMW8qL8F7UQxVbCSCS5Tqev7hlefs4Hu3eLAFMXF80hGwZiy8nXskX6mqR
         0THg==
X-Gm-Message-State: AOAM530/uRmglW7t1AhUjOJWlPsYVPbOlXpwQWuje6npHfK1BP5VS21X
        DY51xYRGF8W19Jt118Im9LUXi5Ob056wCjBu/UHV
X-Google-Smtp-Source: ABdhPJyt1k/RSWy83+1+OmhkaAmWeFnxG6MZmwR66lsbk5H/EN4omlE0NKvZ4kUYOjDCLtkcwCUQ7smkV99GEEOO3As=
X-Received: by 2002:aa7:c50a:: with SMTP id o10mr29218603edq.118.1628053332808;
 Tue, 03 Aug 2021 22:02:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210729073503.187-1-xieyongji@bytedance.com> <20210729073503.187-2-xieyongji@bytedance.com>
 <43d88942-1cd3-c840-6fec-4155fd544d80@redhat.com> <CACycT3vcpwyA3xjD29f1hGnYALyAd=-XcWp8+wJiwSqpqUu00w@mail.gmail.com>
 <6e05e25e-e569-402e-d81b-8ac2cff1c0e8@arm.com>
In-Reply-To: <6e05e25e-e569-402e-d81b-8ac2cff1c0e8@arm.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 4 Aug 2021 13:02:01 +0800
Message-ID: <CACycT3sm2r8NMMUPy1k1PuSZZ3nM9aic-O4AhdmRRCwgmwGj4Q@mail.gmail.com>
Subject: Re: [PATCH v10 01/17] iova: Export alloc_iova_fast() and free_iova_fast()
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Jason Wang <jasowang@redhat.com>, kvm <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        songmuchun@bytedance.com, Jens Axboe <axboe@kernel.dk>,
        He Zhe <zhe.he@windriver.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org, bcrl@kvack.org,
        netdev@vger.kernel.org, Joe Perches <joe@perches.com>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 3, 2021 at 6:54 PM Robin Murphy <robin.murphy@arm.com> wrote:
>
> On 2021-08-03 09:54, Yongji Xie wrote:
> > On Tue, Aug 3, 2021 at 3:41 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >>
> >> =E5=9C=A8 2021/7/29 =E4=B8=8B=E5=8D=883:34, Xie Yongji =E5=86=99=E9=81=
=93:
> >>> Export alloc_iova_fast() and free_iova_fast() so that
> >>> some modules can use it to improve iova allocation efficiency.
> >>
> >>
> >> It's better to explain why alloc_iova() is not sufficient here.
> >>
> >
> > Fine.
>
> What I fail to understand from the later patches is what the IOVA domain
> actually represents. If the "device" is a userspace process then
> logically the "IOVA" would be the userspace address, so presumably
> somewhere you're having to translate between this arbitrary address
> space and actual usable addresses - if you're worried about efficiency
> surely it would be even better to not do that?
>

Yes, userspace daemon needs to translate the "IOVA" in a DMA
descriptor to the VA (from mmap(2)). But this actually doesn't affect
performance since it's an identical mapping in most cases.

> Presumably userspace doesn't have any concern about alignment and the
> things we have to worry about for the DMA API in general, so it's pretty
> much just allocating slots in a buffer, and there are far more effective
> ways to do that than a full-blown address space manager.

Considering iova allocation efficiency, I think the iova allocator is
better here. In most cases, we don't even need to hold a spin lock
during iova allocation.

> If you're going
> to reuse any infrastructure I'd have expected it to be SWIOTLB rather
> than the IOVA allocator. Because, y'know, you're *literally implementing
> a software I/O TLB* ;)
>

But actually what we can reuse in SWIOTLB is the IOVA allocator. And
the IOVA management in SWIOTLB is not what we want. For example,
SWIOTLB allocates and uses contiguous memory for bouncing, which is
not necessary in VDUSE case. And VDUSE needs coherent mapping which is
not supported by the SWIOTLB. Besides, the SWIOTLB works in singleton
mode (designed for platform IOMMU) , but VDUSE is based on on-chip
IOMMU (supports multiple instances). So I still prefer to reuse the
IOVA allocator to implement a MMU-based software IOTLB.

Thanks,
Yongji
