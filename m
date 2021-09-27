Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E44641932D
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 13:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234093AbhI0Lfz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 07:35:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233948AbhI0Lfw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 07:35:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0C2660F0F;
        Mon, 27 Sep 2021 11:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632742454;
        bh=6UbwnYpNicjR1JStRo8iJiVRLVMUG38adSoFtPPxBW0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S0Bg5z5sLPjWjfXYHLabHfbBe2KozrkiecXTq752fNuPKu8VKs/Rt58LeqY0p6JZe
         CQETOP+ZW9m46ko74rb0QsJeKQ+6gG8R1VdtEqVK8+/06V5Z6ydgLEY42Ug/83//Ak
         kWy54QBu8EqDdUN3n2yCJygyB+e8s1PNGqhzYHZsUIv+du4qn6BhkCjfavcJYEXcjp
         FyzOGwUqK0gyGChRIo2f3sraqcoWfWnby/gPMXU1qw1x9Ebs+Q7bD3wQn/dqL2OY5y
         M8wp94XZsHuImJayX1xZ6+5Jmf/HCH7b6WX/bXBEdqgBK5Mkl2q6cdG7hcqZWnqaVE
         ZJoo7HtGT700A==
Date:   Mon, 27 Sep 2021 14:34:10 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, stefanha@redhat.com, oren@nvidia.com,
        nitzanc@nvidia.com, israelr@nvidia.com, hch@infradead.org,
        linux-block@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH 2/2] virtio-blk: set NUMA affinity for a tagset
Message-ID: <YVGsMsIjD2+aS3eC@unreal>
References: <20210926145518.64164-1-mgurtovoy@nvidia.com>
 <20210926145518.64164-2-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210926145518.64164-2-mgurtovoy@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 26, 2021 at 05:55:18PM +0300, Max Gurtovoy wrote:
> To optimize performance, set the affinity of the block device tagset
> according to the virtio device affinity.
> 
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> ---
>  drivers/block/virtio_blk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 9b3bd083b411..1c68c3e0ebf9 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -774,7 +774,7 @@ static int virtblk_probe(struct virtio_device *vdev)
>  	memset(&vblk->tag_set, 0, sizeof(vblk->tag_set));
>  	vblk->tag_set.ops = &virtio_mq_ops;
>  	vblk->tag_set.queue_depth = queue_depth;
> -	vblk->tag_set.numa_node = NUMA_NO_NODE;
> +	vblk->tag_set.numa_node = virtio_dev_to_node(vdev);

I afraid that by doing it, you will increase chances to see OOM, because
in NUMA_NO_NODE, MM will try allocate memory in whole system, while in
the latter mode only on specific NUMA which can be depleted.

Thanks

>  	vblk->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
>  	vblk->tag_set.cmd_size =
>  		sizeof(struct virtblk_req) +
> -- 
> 2.18.1
> 
