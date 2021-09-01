Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DA23FD3B7
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 08:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242191AbhIAGUt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 02:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242071AbhIAGUs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 02:20:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE8BC061575;
        Tue, 31 Aug 2021 23:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+olqZsf6bAX4osBZPKKIMT0l5hnOLxO3gzA9/z2x/Po=; b=dWxkNESFLdcE17ZkOOKTM/QcPX
        ET8iXU812Iuu9GGevlXcf6H8zI6o3A93cv/JjixVshao+iBbgaG1mTbj58jEb3LsqC2yKywqm/J9X
        Uo6BKxmvgTqq/tWPPimeZN0bZycd+6L5ZSw24HLIVUte7cg1wl0SFdz6uFs4p605JZsP/iPdBDF6b
        gtHseKQnIrXSv+++0NnBbfFLmcnILE6lDW+W1tOxMesbZQ0ouviPBIVXrFN5ivSIdEjrcoTSQqAn1
        PlFDP3f+XTWNBW7FNa/U4KaY/knxrf3Yhzngyx0YuFMViUQ6lXWXDXNZmU1eempVTSi8noHj9NMy7
        t7+FK/cQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mLJaJ-001whS-0n; Wed, 01 Sep 2021 06:19:00 +0000
Date:   Wed, 1 Sep 2021 07:18:55 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     hch@infradead.org, mst@redhat.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        stefanha@redhat.com, israelr@nvidia.com, nitzanc@nvidia.com,
        oren@nvidia.com, linux-block@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH 1/1] virtio-blk: avoid preallocating big SGL for data
Message-ID: <YS8bT23rdMfT/+AF@infradead.org>
References: <20210830233500.51395-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830233500.51395-1-mgurtovoy@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 31, 2021 at 02:35:00AM +0300, Max Gurtovoy wrote:
> No need to pre-allocate a big buffer for the IO SGL anymore. If a device
> has lots of deep queues, preallocation for the sg list can consume
> substantial amounts of memory. For HW virtio-blk device, nr_hw_queues
> can be 64 or 128 and each queue's depth might be 128. This means the
> resulting preallocation for the data SGLs is big.
> 
> Switch to runtime allocation for SGL for lists longer than 2 entries.
> This is the approach used by NVMe drivers so it should be reasonable for
> virtio block as well. Runtime SGL allocation has always been the case
> for the legacy I/O path so this is nothing new.
> 
> The preallocated small SGL depends on SG_CHAIN so if the ARCH doesn't
> support SG_CHAIN, use only runtime allocation for the SGL.
> 
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> Reviewed-by: Israel Rukshin <israelr@nvidia.com>
> ---
>  drivers/block/virtio_blk.c | 37 ++++++++++++++++++++++---------------
>  1 file changed, 22 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 77e8468e8593..9a4c5d428b58 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -24,6 +24,12 @@
>  /* The maximum number of sg elements that fit into a virtqueue */
>  #define VIRTIO_BLK_MAX_SG_ELEMS 32768
>  
> +#ifdef CONFIG_ARCH_NO_SG_CHAIN
> +#define VIRTIO_BLK_INLINE_SG_CNT	0
> +#else
> +#define VIRTIO_BLK_INLINE_SG_CNT	2
> +#endif
> +
>  static int virtblk_queue_count_set(const char *val,
>  		const struct kernel_param *kp)
>  {
> @@ -99,7 +105,7 @@ struct virtio_blk {
>  struct virtblk_req {
>  	struct virtio_blk_outhdr out_hdr;
>  	u8 status;
> -	struct scatterlist sg[];
> +	struct sg_table sg_table;

Please keep the sg flexible array member here instead of the pointer
arithmetics that is added instead below.

> +	err = sg_alloc_table_chained(&vbr->sg_table,
> +				     blk_rq_nr_phys_segments(req),
> +				     vbr->sg_table.sgl,
> +				     VIRTIO_BLK_INLINE_SG_CNT);
> +	if (err)
> +		return BLK_STS_RESOURCE;
> +

This will BUG() for requests without segments (fush and discard).  You
probably want a separate helper to actually map data in the, extending
the big switch on the op.  While we're at it, the blk_mq_start_request
should also move as close as possible to the actual sending of the
request to the host.

You'll also need to select SG_POOL now that you're using these
functions.
