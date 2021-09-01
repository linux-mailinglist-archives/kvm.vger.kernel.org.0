Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B9B3FDE01
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 16:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbhIAOvh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 10:51:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53583 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232158AbhIAOvg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Sep 2021 10:51:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630507839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KehK5Jbs4kdvorQdCoG9AAvx7Kx9GawvZqLACA7tl6w=;
        b=OkcTL/Jia3KrqI2GjR8Nchkb2/s8A/HXUGw8eURyc94S2tADArGckblBrGBCtlDbwIHOW2
        FN0LN5oabQqajoMI5sSPxCbYNxKcViG2w8u0+rBpZzdlVSF6y+B6mD9kiIsaPei2GVXQrT
        NVsfhiEBetpFHYiXU0Uu0pQDnlHuGts=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-OIEnWMzwMdO4RIQTAsAIcA-1; Wed, 01 Sep 2021 10:50:38 -0400
X-MC-Unique: OIEnWMzwMdO4RIQTAsAIcA-1
Received: by mail-ed1-f70.google.com with SMTP id ch11-20020a0564021bcb00b003c8021b61c4so1401333edb.23
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 07:50:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KehK5Jbs4kdvorQdCoG9AAvx7Kx9GawvZqLACA7tl6w=;
        b=fcSH60mcpAQKm9lEjLkErjDoYb1EAPAbdXOEdaDBsb88E/ARgyhnQXPmsE4qoqN/U1
         ctPrxJiwmPuX7QdvcICLDbb3LNgKc0kPyjUmlqvj4ZhfYAngB6zOM3Ep/gx7ZQH7qIf9
         O1HIIV2sLxeJq6HYxPRzq3VjbtrW9AEigZ/1T5b/icXHkBuT4QLzIc/UY+pMPIw5TV33
         QNjg9MMZqoOv94i58jUmWPGFXHXHABNPjsFIAMnt1o+fo5ovNQWglJTeZHFxa/61VvgN
         HuXTbFRdV96n8tnb6mYuPUnfDxgjf/MRfVVg3ArF6zlx5PchkIFypIBx4dC66dOci9+Y
         IvIg==
X-Gm-Message-State: AOAM530oOw8okg6GanHnQFt0k1dfUJ6ewtR0z6UqX1WAzO/akCPYtiaT
        FvXZEWjOycvmkMrXf7xr2/HcciVNmAPYW8gd6E4NMH4kqsI5BE9XRPC1i7FXcTbwIyIbNZL4+6n
        y4EdCm/+BhBF9
X-Received: by 2002:aa7:c857:: with SMTP id g23mr36031396edt.219.1630507836843;
        Wed, 01 Sep 2021 07:50:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz2XabI56x5N4e12tynXmUzwNYlCnkVvW+5e6SKLFqAQFwy9xHy9UkCtXbluxMdfmB+xkCIWw==
X-Received: by 2002:aa7:c857:: with SMTP id g23mr36031377edt.219.1630507836544;
        Wed, 01 Sep 2021 07:50:36 -0700 (PDT)
Received: from redhat.com ([2.55.138.60])
        by smtp.gmail.com with ESMTPSA id i6sm114434ejd.57.2021.09.01.07.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 07:50:35 -0700 (PDT)
Date:   Wed, 1 Sep 2021 10:50:31 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     hch@infradead.org, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, stefanha@redhat.com, israelr@nvidia.com,
        nitzanc@nvidia.com, oren@nvidia.com, linux-block@vger.kernel.org,
        axboe@kernel.dk
Subject: Re: [PATCH v3 1/1] virtio-blk: avoid preallocating big SGL for data
Message-ID: <20210901102623-mutt-send-email-mst@kernel.org>
References: <20210901131434.31158-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901131434.31158-1-mgurtovoy@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 01, 2021 at 04:14:34PM +0300, Max Gurtovoy wrote:
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
> Re-organize the setup of the IO request to fit the new sg chain
> mechanism.
> 
> No performance degradation was seen (fio libaio engine with 16 jobs and
> 128 iodepth):
> 
> IO size      IOPs Rand Read (before/after)         IOPs Rand Write (before/after)
> --------     ---------------------------------    ----------------------------------
> 512B          318K/316K                                    329K/325K
> 
> 4KB           323K/321K                                    353K/349K
> 
> 16KB          199K/208K                                    250K/275K
> 
> 128KB         36K/36.1K                                    39.2K/41.7K
> 
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> Reviewed-by: Israel Rukshin <israelr@nvidia.com>

Could you use something to give confidence intervals maybe?
As it is it looks like a 1-2% regression for 512B and 4KB.



> ---
> 
> changes from V2:
>  - initialize vbr->out_hdr.sector during virtblk_setup_cmd
> 
> changes from V1:
>  - Kconfig update (from Christoph)
>  - Re-order cmd setup (from Christoph)
>  - use flexible sg pointer in the cmd (from Christoph)
>  - added perf numbers to commit msg (from Feng Li)
> 
> ---
>  drivers/block/Kconfig      |   1 +
>  drivers/block/virtio_blk.c | 155 +++++++++++++++++++++++--------------
>  2 files changed, 100 insertions(+), 56 deletions(-)
> 
> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
> index 63056cfd4b62..ca25a122b8ee 100644
> --- a/drivers/block/Kconfig
> +++ b/drivers/block/Kconfig
> @@ -395,6 +395,7 @@ config XEN_BLKDEV_BACKEND
>  config VIRTIO_BLK
>  	tristate "Virtio block driver"
>  	depends on VIRTIO
> +	select SG_POOL
>  	help
>  	  This is the virtual block driver for virtio.  It can be used with
>            QEMU based VMMs (like KVM or Xen).  Say Y or M.
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 9332fc4e9b31..bdd6d415bd20 100644
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
> @@ -93,6 +99,7 @@ struct virtio_blk {
>  struct virtblk_req {
>  	struct virtio_blk_outhdr out_hdr;
>  	u8 status;
> +	struct sg_table sg_table;
>  	struct scatterlist sg[];
>  };
>  
> @@ -178,15 +185,94 @@ static int virtblk_setup_discard_write_zeroes(struct request *req, bool unmap)
>  	return 0;
>  }
>  
> -static inline void virtblk_request_done(struct request *req)
> +static void virtblk_unmap_data(struct request *req, struct virtblk_req *vbr)
>  {
> -	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
> +	if (blk_rq_nr_phys_segments(req))
> +		sg_free_table_chained(&vbr->sg_table,
> +				      VIRTIO_BLK_INLINE_SG_CNT);
> +}
> +
> +static int virtblk_map_data(struct blk_mq_hw_ctx *hctx, struct request *req,
> +		struct virtblk_req *vbr)
> +{
> +	int err;
> +
> +	if (!blk_rq_nr_phys_segments(req))
> +		return 0;
> +
> +	vbr->sg_table.sgl = vbr->sg;
> +	err = sg_alloc_table_chained(&vbr->sg_table,
> +				     blk_rq_nr_phys_segments(req),
> +				     vbr->sg_table.sgl,
> +				     VIRTIO_BLK_INLINE_SG_CNT);
> +	if (unlikely(err))
> +		return -ENOMEM;
>  
> +	return blk_rq_map_sg(hctx->queue, req, vbr->sg_table.sgl);
> +}
> +
> +static void virtblk_cleanup_cmd(struct request *req)
> +{
>  	if (req->rq_flags & RQF_SPECIAL_PAYLOAD) {
>  		kfree(page_address(req->special_vec.bv_page) +
>  		      req->special_vec.bv_offset);
>  	}
> +}
> +
> +static int virtblk_setup_cmd(struct virtio_device *vdev, struct request *req,
> +		struct virtblk_req *vbr)
> +{
> +	bool unmap = false;
> +	u32 type;
> +
> +	vbr->out_hdr.sector = 0;
> +
> +	switch (req_op(req)) {
> +	case REQ_OP_READ:
> +		type = VIRTIO_BLK_T_IN;
> +		vbr->out_hdr.sector = cpu_to_virtio64(vdev,
> +						      blk_rq_pos(req));
> +		break;
> +	case REQ_OP_WRITE:
> +		type = VIRTIO_BLK_T_OUT;
> +		vbr->out_hdr.sector = cpu_to_virtio64(vdev,
> +						      blk_rq_pos(req));
> +		break;
> +	case REQ_OP_FLUSH:
> +		type = VIRTIO_BLK_T_FLUSH;
> +		break;
> +	case REQ_OP_DISCARD:
> +		type = VIRTIO_BLK_T_DISCARD;
> +		break;
> +	case REQ_OP_WRITE_ZEROES:
> +		type = VIRTIO_BLK_T_WRITE_ZEROES;
> +		unmap = !(req->cmd_flags & REQ_NOUNMAP);
> +		break;
> +	case REQ_OP_DRV_IN:
> +		type = VIRTIO_BLK_T_GET_ID;
> +		break;
> +	default:
> +		WARN_ON_ONCE(1);
> +		return BLK_STS_IOERR;
> +	}
>  
> +	vbr->out_hdr.type = cpu_to_virtio32(vdev, type);
> +	vbr->out_hdr.ioprio = cpu_to_virtio32(vdev, req_get_ioprio(req));
> +
> +	if (type == VIRTIO_BLK_T_DISCARD || type == VIRTIO_BLK_T_WRITE_ZEROES) {
> +		if (virtblk_setup_discard_write_zeroes(req, unmap))
> +			return BLK_STS_RESOURCE;
> +	}
> +
> +	return 0;
> +}
> +
> +static inline void virtblk_request_done(struct request *req)
> +{
> +	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
> +
> +	virtblk_unmap_data(req, vbr);
> +	virtblk_cleanup_cmd(req);
>  	blk_mq_end_request(req, virtblk_result(vbr));
>  }
>  
> @@ -244,57 +330,23 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
>  	int qid = hctx->queue_num;
>  	int err;
>  	bool notify = false;
> -	bool unmap = false;
> -	u32 type;
>  
>  	BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);
>  
> -	switch (req_op(req)) {
> -	case REQ_OP_READ:
> -	case REQ_OP_WRITE:
> -		type = 0;
> -		break;
> -	case REQ_OP_FLUSH:
> -		type = VIRTIO_BLK_T_FLUSH;
> -		break;
> -	case REQ_OP_DISCARD:
> -		type = VIRTIO_BLK_T_DISCARD;
> -		break;
> -	case REQ_OP_WRITE_ZEROES:
> -		type = VIRTIO_BLK_T_WRITE_ZEROES;
> -		unmap = !(req->cmd_flags & REQ_NOUNMAP);
> -		break;
> -	case REQ_OP_DRV_IN:
> -		type = VIRTIO_BLK_T_GET_ID;
> -		break;
> -	default:
> -		WARN_ON_ONCE(1);
> -		return BLK_STS_IOERR;
> -	}
> -
> -	vbr->out_hdr.type = cpu_to_virtio32(vblk->vdev, type);
> -	vbr->out_hdr.sector = type ?
> -		0 : cpu_to_virtio64(vblk->vdev, blk_rq_pos(req));
> -	vbr->out_hdr.ioprio = cpu_to_virtio32(vblk->vdev, req_get_ioprio(req));
> +	err = virtblk_setup_cmd(vblk->vdev, req, vbr);
> +	if (unlikely(err))
> +		return err;
>  
>  	blk_mq_start_request(req);
>  
> -	if (type == VIRTIO_BLK_T_DISCARD || type == VIRTIO_BLK_T_WRITE_ZEROES) {
> -		err = virtblk_setup_discard_write_zeroes(req, unmap);
> -		if (err)
> -			return BLK_STS_RESOURCE;
> -	}
> -
> -	num = blk_rq_map_sg(hctx->queue, req, vbr->sg);
> -	if (num) {
> -		if (rq_data_dir(req) == WRITE)
> -			vbr->out_hdr.type |= cpu_to_virtio32(vblk->vdev, VIRTIO_BLK_T_OUT);
> -		else
> -			vbr->out_hdr.type |= cpu_to_virtio32(vblk->vdev, VIRTIO_BLK_T_IN);
> +	num = virtblk_map_data(hctx, req, vbr);
> +	if (unlikely(num < 0)) {
> +		virtblk_cleanup_cmd(req);
> +		return BLK_STS_RESOURCE;
>  	}
>  
>  	spin_lock_irqsave(&vblk->vqs[qid].lock, flags);
> -	err = virtblk_add_req(vblk->vqs[qid].vq, vbr, vbr->sg, num);
> +	err = virtblk_add_req(vblk->vqs[qid].vq, vbr, vbr->sg_table.sgl, num);
>  	if (err) {
>  		virtqueue_kick(vblk->vqs[qid].vq);
>  		/* Don't stop the queue if -ENOMEM: we may have failed to
> @@ -303,6 +355,8 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
>  		if (err == -ENOSPC)
>  			blk_mq_stop_hw_queue(hctx);
>  		spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
> +		virtblk_unmap_data(req, vbr);
> +		virtblk_cleanup_cmd(req);
>  		switch (err) {
>  		case -ENOSPC:
>  			return BLK_STS_DEV_RESOURCE;
> @@ -681,16 +735,6 @@ static const struct attribute_group *virtblk_attr_groups[] = {
>  	NULL,
>  };
>  
> -static int virtblk_init_request(struct blk_mq_tag_set *set, struct request *rq,
> -		unsigned int hctx_idx, unsigned int numa_node)
> -{
> -	struct virtio_blk *vblk = set->driver_data;
> -	struct virtblk_req *vbr = blk_mq_rq_to_pdu(rq);
> -
> -	sg_init_table(vbr->sg, vblk->sg_elems);
> -	return 0;
> -}
> -
>  static int virtblk_map_queues(struct blk_mq_tag_set *set)
>  {
>  	struct virtio_blk *vblk = set->driver_data;
> @@ -703,7 +747,6 @@ static const struct blk_mq_ops virtio_mq_ops = {
>  	.queue_rq	= virtio_queue_rq,
>  	.commit_rqs	= virtio_commit_rqs,
>  	.complete	= virtblk_request_done,
> -	.init_request	= virtblk_init_request,
>  	.map_queues	= virtblk_map_queues,
>  };
>  
> @@ -783,7 +826,7 @@ static int virtblk_probe(struct virtio_device *vdev)
>  	vblk->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
>  	vblk->tag_set.cmd_size =
>  		sizeof(struct virtblk_req) +
> -		sizeof(struct scatterlist) * sg_elems;
> +		sizeof(struct scatterlist) * VIRTIO_BLK_INLINE_SG_CNT;
>  	vblk->tag_set.driver_data = vblk;
>  	vblk->tag_set.nr_hw_queues = vblk->num_vqs;
>  
> -- 
> 2.18.1

