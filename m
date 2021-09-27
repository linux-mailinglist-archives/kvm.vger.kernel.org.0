Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF7B419E14
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 20:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236082AbhI0SZM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 14:25:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229875AbhI0SZK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 14:25:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B08FD60F11;
        Mon, 27 Sep 2021 18:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632767012;
        bh=PEfnJvnMLX3HzCxJvQOSm8TUcP24eAq+3o46ij/lCio=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QLX7Zbm4eAjOypOxP3TA0hEiGTi5+UE4LoaR/+AApBexUvYyohRYQVbI6jMzxjzjT
         x7C7XuRfXr6R9vbREJgTXejWww6Lx5aCMT2aHSOGCp0SOLNXpE+mYwjX4WLlXSMT/v
         ZQS+g0wnvpq2ujW9XJK1OJLZHddrXuJyi1DYhLxcyxKjd12eTHHdCDmnTrUleN96Fl
         c0eXtldARexqmfxnp8zVCcFkE7CuqzWmIfQixgEC/+FST13Chzurawv41c4mZmdM3l
         o92h+WUxGNbEEr32hKNpIE6ePp5Mommzze6dEOXkqbDFXVaeu5/hQN3ae0lE+I/uXl
         B+LQXXK7y6xLA==
Date:   Mon, 27 Sep 2021 21:23:28 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, stefanha@redhat.com, oren@nvidia.com,
        nitzanc@nvidia.com, israelr@nvidia.com, hch@infradead.org,
        linux-block@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH 2/2] virtio-blk: set NUMA affinity for a tagset
Message-ID: <YVIMIFxjRcfDDub4@unreal>
References: <20210926145518.64164-1-mgurtovoy@nvidia.com>
 <20210926145518.64164-2-mgurtovoy@nvidia.com>
 <YVGsMsIjD2+aS3eC@unreal>
 <0c155679-e1db-3d1e-2b4e-a0f12ce5950c@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c155679-e1db-3d1e-2b4e-a0f12ce5950c@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 27, 2021 at 08:25:09PM +0300, Max Gurtovoy wrote:
> 
> On 9/27/2021 2:34 PM, Leon Romanovsky wrote:
> > On Sun, Sep 26, 2021 at 05:55:18PM +0300, Max Gurtovoy wrote:
> > > To optimize performance, set the affinity of the block device tagset
> > > according to the virtio device affinity.
> > > 
> > > Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> > > ---
> > >   drivers/block/virtio_blk.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> > > index 9b3bd083b411..1c68c3e0ebf9 100644
> > > --- a/drivers/block/virtio_blk.c
> > > +++ b/drivers/block/virtio_blk.c
> > > @@ -774,7 +774,7 @@ static int virtblk_probe(struct virtio_device *vdev)
> > >   	memset(&vblk->tag_set, 0, sizeof(vblk->tag_set));
> > >   	vblk->tag_set.ops = &virtio_mq_ops;
> > >   	vblk->tag_set.queue_depth = queue_depth;
> > > -	vblk->tag_set.numa_node = NUMA_NO_NODE;
> > > +	vblk->tag_set.numa_node = virtio_dev_to_node(vdev);
> > I afraid that by doing it, you will increase chances to see OOM, because
> > in NUMA_NO_NODE, MM will try allocate memory in whole system, while in
> > the latter mode only on specific NUMA which can be depleted.
> 
> This is a common methodology we use in the block layer and in NVMe subsystem
> and we don't afraid of the OOM issue you raised.

There are many reasons for that, but we are talking about virtio here
and not about NVMe.

> 
> This is not new and I guess that the kernel MM will (or should) be handling
> the fallback you raised.

I afraid that it is not. Can you point me to the place where such
fallback is implemented?

> 
> Anyway, if we're doing this in NVMe I don't see a reason to afraid doing it
> in virtio-blk.

Still, it is nice to have some empirical data to support this copy/paste.

There are too many myths related to optimizations, so finally it will be
good to get some supportive data.

Thanks
