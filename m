Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B00400E9A
	for <lists+kvm@lfdr.de>; Sun,  5 Sep 2021 09:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbhIEHrj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Sep 2021 03:47:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229599AbhIEHrj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Sep 2021 03:47:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C849360555;
        Sun,  5 Sep 2021 07:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630827996;
        bh=O/ZxP3FhOz37k0frdZmwLZpa5oBRB8mmxRGdut1wTDs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l/n5ExtJ0lN140PPLg37CRQXuH3DT+TA3Oki8D+6E8+aoYkaeS3r68Rucy5CGcKbI
         mpp9ne8wEbkSqnLUxI2hGXfIdxTvYXYkEmfEUzPMGn3FYHzNmjmCkMLagls1eJqpRh
         wWVoCqII96pbG56Tt6e9mjtgw9QcVdTbs3hU5lGdOBJEibeq9n/uNR3xnormFYb1f9
         9c2tNLosDtsYTePJ6Y/c+SXGfD/3uJd+SGXSS4LXw8O74bNXXqWleV9E7f79nzkw0C
         WCTE+4WdfdKFbLhkQFWG9TChM2kWIJXtPjkuCvV0gopzPjDXiG8Uqj5ItTWHdAr+Af
         THLmYI/iz//nA==
Date:   Sun, 5 Sep 2021 10:46:32 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     hch@infradead.org, mst@redhat.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        stefanha@redhat.com, israelr@nvidia.com, nitzanc@nvidia.com,
        oren@nvidia.com, linux-block@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH v3 1/1] virtio-blk: add num_request_queues module
 parameter
Message-ID: <YTR12AHOGs1nhfz1@unreal>
References: <20210902204622.54354-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902204622.54354-1-mgurtovoy@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 02, 2021 at 11:46:22PM +0300, Max Gurtovoy wrote:
> Sometimes a user would like to control the amount of request queues to
> be created for a block device. For example, for limiting the memory
> footprint of virtio-blk devices.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> ---
> 
> changes from v2:
>  - renamed num_io_queues to num_request_queues (from Stefan)
>  - added Reviewed-by signatures (from Stefan and Christoph)
> 
> changes from v1:
>  - use param_set_uint_minmax (from Christoph)
>  - added "Should > 0" to module description
> 
> Note: This commit apply on top of Jens's branch for-5.15/drivers
> 
> ---
>  drivers/block/virtio_blk.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 4b49df2dfd23..aaa2833a4734 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -24,6 +24,23 @@
>  /* The maximum number of sg elements that fit into a virtqueue */
>  #define VIRTIO_BLK_MAX_SG_ELEMS 32768
>  
> +static int virtblk_queue_count_set(const char *val,
> +		const struct kernel_param *kp)
> +{
> +	return param_set_uint_minmax(val, kp, 1, nr_cpu_ids);
> +}
> +
> +static const struct kernel_param_ops queue_count_ops = {
> +	.set = virtblk_queue_count_set,
> +	.get = param_get_uint,
> +};
> +
> +static unsigned int num_request_queues;
> +module_param_cb(num_request_queues, &queue_count_ops, &num_request_queues,
> +		0644);
> +MODULE_PARM_DESC(num_request_queues,
> +		 "Number of request queues to use for blk device. Should > 0");
> +

Won't it limit all virtio block devices to the same limit?

It is very common to see multiple virtio-blk devices on the same system
and they probably need different limits.

Thanks
