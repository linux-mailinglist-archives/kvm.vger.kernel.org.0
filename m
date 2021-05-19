Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB90388F47
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 15:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346637AbhESNkx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 09:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240097AbhESNkx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 09:40:53 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701C3C061763
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 06:39:33 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id o5so6422810edc.5
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 06:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZyIq8u+kwqwBpbcwfduylW+9xPyGO1H5rtatjl1f/C8=;
        b=xs/S/LlOVbGml0EAnOsGRxZ5oyqDBbSJlCsgVvbQ04i5427YcKz67n0cj1OtSeZJzl
         3OctonqM0oElTfaoTOk7R2GorMPYS4s6Btg8XNc/c8YJCgYkjK+9gWKXqHAD42DxLpI8
         u88O6hu8P5tyhEqbon4FApOFc19n66atecuVED7etO6q1DkSFutUnSZJ47B113wTUxY4
         BDyFvGJ7MTYq9/FGHolluJ7KGdFbHah2Ii04NPVk3Do6Edo/rTmDaygSrsV/k7OCxbIf
         5fhm7wm6SKx4287C/a43687P2ouGxwFMVU1e5nxsCdXnJ4V1slDmpOxWqN3L8omzqx2q
         Gnng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZyIq8u+kwqwBpbcwfduylW+9xPyGO1H5rtatjl1f/C8=;
        b=qLAGYo1PnF7IBwFGXV+ynBwuafgFaQyno5YpSqNZTmpfk1IBJx9pwMOxQ3XrKj7vSR
         dsonG0qRJeao35QT1I3cOBa3Cxt6Ectk4bx3xfz1FYOqFru54IrG9mBVCeONmBzC+I7D
         AVsyJVp4zlBGCdMVcebjugUr1pdj7KwkwscBrEtv8+vAjxqIC89pZSMlGbmhg6mTMF54
         fOel1271mvCMLMUJfVQLHgu251ovhRPoSXygHtcW3BP77pFKvhLQYtt++OwliECtpU0O
         3X+sqL6VcSBXX+gZYkFf/vkSxawqmlmJwiY5PsQWyld4imlBYAB71gC3m1ji4efNapAJ
         fIGg==
X-Gm-Message-State: AOAM531v5t/ihdhO3SAcAbAnibh99ORopuENT1+Z1YRg/QL/cHCswxZn
        L+JLtLgxWd49dVGl2Im/orcisur16JqqtqWayf3K
X-Google-Smtp-Source: ABdhPJyUaoeoU6jHmwL2wRih6mMfwzvW50aSrjBZb35A6Wf6KcfF+IKFvuHwvdNQjGh/v4RZkom8EsJySMDZrk7j/3M=
X-Received: by 2002:a05:6402:4252:: with SMTP id g18mr14312783edb.195.1621431571306;
 Wed, 19 May 2021 06:39:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210517095513.850-1-xieyongji@bytedance.com> <20210517095513.850-5-xieyongji@bytedance.com>
In-Reply-To: <20210517095513.850-5-xieyongji@bytedance.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 19 May 2021 21:39:20 +0800
Message-ID: <CACycT3s1rEvNnNkJKQsHGRsyLPADieFdVkb1Sp3GObR0Vox5Fg@mail.gmail.com>
Subject: Re: [PATCH v7 04/12] virtio-blk: Add validation for block size in
 config space
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 17, 2021 at 5:56 PM Xie Yongji <xieyongji@bytedance.com> wrote:
>
> This ensures that we will not use an invalid block size
> in config space (might come from an untrusted device).
>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>  drivers/block/virtio_blk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index ebb4d3fe803f..c848aa36d49b 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -826,7 +826,7 @@ static int virtblk_probe(struct virtio_device *vdev)
>         err = virtio_cread_feature(vdev, VIRTIO_BLK_F_BLK_SIZE,
>                                    struct virtio_blk_config, blk_size,
>                                    &blk_size);
> -       if (!err)
> +       if (!err && blk_size > 0 && blk_size <= max_size)

The check here is incorrect. I will use PAGE_SIZE as the maximum
boundary in the new version.

Thanks,
Yongji
