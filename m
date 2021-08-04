Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97CAE3DFD45
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 10:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236698AbhHDIum (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 04:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236692AbhHDIul (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 04:50:41 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32299C061798
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 01:50:29 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id qk33so2579432ejc.12
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 01:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gjv7zGBiOnBZ7R9UWN2FDc0uyzBBQAiVLX2gQfI9hbk=;
        b=l6R1WjH+4TvXCxQRV3Evo+qKJY9IwKeaU2/GN2OEK0HHsPbokpR9AjUerM1yTM9Q5T
         CxH5ACTGqUwfghoCSllUxvZ/0SBHv6pWqZlJb385Y3DQxSEii/Wf5nBiQbShhzECbpin
         cpY6mbZ3Z33l/D7+pGyhjVq7QQzW2cxI6vhlJe/nTWHXIgWWIyAQm3yguGiBf0UcH+0n
         K587F3FpiCWTzcW+7JoKaS4zkkVV6ZHsL4gqzHOGtYESD9rGxW+SZGaZtkXLGveyl4yV
         GplFA6qhA18rWIw2ORUS31gh+PT2kczw3tljSbIsPT3a9IS+GyDAeD6tHDzkfeRJGh+6
         RMsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gjv7zGBiOnBZ7R9UWN2FDc0uyzBBQAiVLX2gQfI9hbk=;
        b=byRX2QRVxGLINJ4PD0okj55f8qSy7qBWKJjBi1KH83Uwi75FAvvZbilwkI0kCfadXb
         g16LPCF79Gv+WBC080/9VSq1Oy492Twvi0fFxWrm/7M4R96Ai1W/MmT4f32eXAcICtT2
         rdBVHNF8v5F4Bfi4SB/dMgVn8SbeE4oWcC1gLBBoqMu5lw+2wE3s64Ixfv5FttXBQSeP
         W+vmuoOYgm66W33Cuu4cApqeNV52WUoXLDRXOhqbAeuH1p25aAn2Iridt//+DADLdwhZ
         rbEYjVgP5Wj78MSrXqywFfHOmscxYalSv7lixbRRkWxQ/AA9fVhxr/nMdbtjpO3o/MGO
         KJAQ==
X-Gm-Message-State: AOAM5313KGaNxz4B8ylG1PNtP6x/RHR/i908cSmiT02eTtquIX1r5QBE
        1BNPdY469gtqGY/5ClYBerkD7eLpOQ9oiGQd7hEv
X-Google-Smtp-Source: ABdhPJw9DdRo5GKyuQLnCIkhXlDgxjvKjGN8bxXqI6CDfUKxXZQ0BXWfJJMjYdrbOclRuL7SEzvU5j3XL9DXCsmksZ8=
X-Received: by 2002:a17:906:46d4:: with SMTP id k20mr24791725ejs.395.1628067027711;
 Wed, 04 Aug 2021 01:50:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210729073503.187-1-xieyongji@bytedance.com> <20210729073503.187-11-xieyongji@bytedance.com>
 <6bb6c689-e6dd-cfa2-094b-a0ca4258aded@redhat.com> <CACycT3v7BHxYY0OFYJRFU41Bz1=_v8iMRwzYKgX6cJM-SiNH+A@mail.gmail.com>
 <fdcb0224-11f9-caf2-a44e-e6406087fd50@redhat.com>
In-Reply-To: <fdcb0224-11f9-caf2-a44e-e6406087fd50@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 4 Aug 2021 16:50:16 +0800
Message-ID: <CACycT3v0EQVrv_A1K1bKmiYu0q5aFE=t+0yRaWKC7T3_H3oB-Q@mail.gmail.com>
Subject: Re: [PATCH v10 10/17] virtio: Handle device reset failure in register_virtio_device()
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
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
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        Greg KH <gregkh@linuxfoundation.org>,
        He Zhe <zhe.he@windriver.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>,
        Joe Perches <joe@perches.com>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 4, 2021 at 4:32 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/8/3 =E4=B8=8B=E5=8D=885:38, Yongji Xie =E5=86=99=E9=81=93:
> > On Tue, Aug 3, 2021 at 4:09 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> =E5=9C=A8 2021/7/29 =E4=B8=8B=E5=8D=883:34, Xie Yongji =E5=86=99=E9=81=
=93:
> >>> The device reset may fail in virtio-vdpa case now, so add checks to
> >>> its return value and fail the register_virtio_device().
> >>
> >> So the reset() would be called by the driver during remove as well, or
> >> is it sufficient to deal only with the reset during probe?
> >>
> > Actually there is no way to handle failure during removal. And it
> > should be safe with the protection of software IOTLB even if the
> > reset() fails.
> >
> > Thanks,
> > Yongji
>
>
> If this is true, does it mean we don't even need to care about reset
> failure?
>

But we need to handle the failure in the vhost-vdpa case, isn't it?

Thanks,
Yongji
