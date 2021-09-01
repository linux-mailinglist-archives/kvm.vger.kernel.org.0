Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B4F3FD1E0
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 05:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241821AbhIADkb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 23:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241754AbhIADkX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Aug 2021 23:40:23 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4B3C061575;
        Tue, 31 Aug 2021 20:39:27 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id r21so1460850qtw.11;
        Tue, 31 Aug 2021 20:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5eznzShYwADvzOPKSZ3hcyxH8Z6TpaitcBld3wKT2jE=;
        b=ZxUdmpWYYqXOgdOl8kR7OgR2kVnqQRcp4rRXZr+R7cy65vJiXCHdgOWVZnhT0QtC8a
         ScDNNQg4VZXKi8CaUvdBeE8NLW+Ox2pC2v8ZE5I8Rcw399wvHI3bDWpmmfgLsduorgTw
         F7yLAFSrLXmyJEM68xdWvdWU0zdB6TM3/ixNz/i8y8ipbu8JXv4/gKrGbFyjVRCP7uRJ
         3aH5BeFhh43sCkPkHlckSA31ChXXAFITyeX9cOvfOOMlwRFZMUCNP/5W2yJHdsuj5IwV
         gf0elhSjhFFk29uOXSQFEjA5Sz/eXw/ggkK7Z+VnaXoReynveSPT9MBZqis88UHvEZs4
         KWGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5eznzShYwADvzOPKSZ3hcyxH8Z6TpaitcBld3wKT2jE=;
        b=lxzvh0CC69Xl6xoRGiNIlef32ukL+4XhdXwofQeC5Mejkm7AWaM4ISZasTpYWY3XdZ
         t8f2CeAC5CKhJSGPTxoXnxswDTaJXX9JTZFVL9RTBxP/4ZTWBYHoQOpSZFMeC1NlFh8T
         rg4W4FFm6oZVMM9e6khJuu0L6ZRxdo40P9ojnAX6T4+xzkRTJXfzXFb5BVHF4KH0btXf
         k4PWZyCvmj81hw64xcpu5n5oQeOfGm7Avn/V1Uv8jiYCe+K+8jjNYfOd18yNbKeccZxO
         anzLFtMx3uKRqNPIx2XpWEKWYbUyl1OseYh+6HElE/n2W2Es2jAVjvoGKGdyh1PIjEWA
         bLvg==
X-Gm-Message-State: AOAM531+UEqUFEltcjwlkshs3+Gfq3dvYBStyJFeBWlDT+X69JRU7arJ
        dSR6kTojPQ74NA+0x3x6ll9Wkg0hFFvUecjS2Ko=
X-Google-Smtp-Source: ABdhPJwzpNMXnzYmkEqSbzN6M0/DOilpaMfT+4BNsm9fEUHLO+pAMb6YMzzmyOn6E8EqKKX82IRDtYijHlMwWzRYuZU=
X-Received: by 2002:ac8:4e0c:: with SMTP id c12mr6239885qtw.173.1630467565374;
 Tue, 31 Aug 2021 20:39:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210830233500.51395-1-mgurtovoy@nvidia.com>
In-Reply-To: <20210830233500.51395-1-mgurtovoy@nvidia.com>
From:   Feng Li <lifeng1519@gmail.com>
Date:   Wed, 1 Sep 2021 11:38:59 +0800
Message-ID: <CAEK8JBBU3zNAWpC36-Lq0UBM1Dp+jYQG105psE38Fy8KRy=M-g@mail.gmail.com>
Subject: Re: [PATCH 1/1] virtio-blk: avoid preallocating big SGL for data
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     hch@infradead.org, mst@redhat.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        stefanha@redhat.com, israelr@nvidia.com, nitzanc@nvidia.com,
        oren@nvidia.com, linux-block <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Does this hurt the performance of virtio-blk?
I think a fio result is needed here.

On Tue, Aug 31, 2021 at 7:36 AM Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
>
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
> +#define VIRTIO_BLK_INLINE_SG_CNT       0
> +#else
> +#define VIRTIO_BLK_INLINE_SG_CNT       2
> +#endif
> +
>  static int virtblk_queue_count_set(const char *val,
>                 const struct kernel_param *kp)
>  {
> @@ -99,7 +105,7 @@ struct virtio_blk {
>  struct virtblk_req {
>         struct virtio_blk_outhdr out_hdr;
>         u8 status;
> -       struct scatterlist sg[];
> +       struct sg_table sg_table;
>  };
>
>  static inline blk_status_t virtblk_result(struct virtblk_req *vbr)
> @@ -188,6 +194,8 @@ static inline void virtblk_request_done(struct request *req)
>  {
>         struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
>
> +       sg_free_table_chained(&vbr->sg_table, VIRTIO_BLK_INLINE_SG_CNT);
> +
>         if (req->rq_flags & RQF_SPECIAL_PAYLOAD) {
>                 kfree(page_address(req->special_vec.bv_page) +
>                       req->special_vec.bv_offset);
> @@ -291,7 +299,15 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
>                         return BLK_STS_RESOURCE;
>         }
>
> -       num = blk_rq_map_sg(hctx->queue, req, vbr->sg);
> +       vbr->sg_table.sgl = (struct scatterlist *)(vbr + 1);
> +       err = sg_alloc_table_chained(&vbr->sg_table,
> +                                    blk_rq_nr_phys_segments(req),
> +                                    vbr->sg_table.sgl,
> +                                    VIRTIO_BLK_INLINE_SG_CNT);
> +       if (err)
> +               return BLK_STS_RESOURCE;
> +
> +       num = blk_rq_map_sg(hctx->queue, req, vbr->sg_table.sgl);
>         if (num) {
>                 if (rq_data_dir(req) == WRITE)
>                         vbr->out_hdr.type |= cpu_to_virtio32(vblk->vdev, VIRTIO_BLK_T_OUT);
> @@ -300,7 +316,7 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
>         }
>
>         spin_lock_irqsave(&vblk->vqs[qid].lock, flags);
> -       err = virtblk_add_req(vblk->vqs[qid].vq, vbr, vbr->sg, num);
> +       err = virtblk_add_req(vblk->vqs[qid].vq, vbr, vbr->sg_table.sgl, num);
>         if (err) {
>                 virtqueue_kick(vblk->vqs[qid].vq);
>                 /* Don't stop the queue if -ENOMEM: we may have failed to
> @@ -309,6 +325,8 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
>                 if (err == -ENOSPC)
>                         blk_mq_stop_hw_queue(hctx);
>                 spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
> +               sg_free_table_chained(&vbr->sg_table,
> +                                     VIRTIO_BLK_INLINE_SG_CNT);
>                 switch (err) {
>                 case -ENOSPC:
>                         return BLK_STS_DEV_RESOURCE;
> @@ -687,16 +705,6 @@ static const struct attribute_group *virtblk_attr_groups[] = {
>         NULL,
>  };
>
> -static int virtblk_init_request(struct blk_mq_tag_set *set, struct request *rq,
> -               unsigned int hctx_idx, unsigned int numa_node)
> -{
> -       struct virtio_blk *vblk = set->driver_data;
> -       struct virtblk_req *vbr = blk_mq_rq_to_pdu(rq);
> -
> -       sg_init_table(vbr->sg, vblk->sg_elems);
> -       return 0;
> -}
> -
>  static int virtblk_map_queues(struct blk_mq_tag_set *set)
>  {
>         struct virtio_blk *vblk = set->driver_data;
> @@ -709,7 +717,6 @@ static const struct blk_mq_ops virtio_mq_ops = {
>         .queue_rq       = virtio_queue_rq,
>         .commit_rqs     = virtio_commit_rqs,
>         .complete       = virtblk_request_done,
> -       .init_request   = virtblk_init_request,
>         .map_queues     = virtblk_map_queues,
>  };
>
> @@ -805,7 +812,7 @@ static int virtblk_probe(struct virtio_device *vdev)
>         vblk->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
>         vblk->tag_set.cmd_size =
>                 sizeof(struct virtblk_req) +
> -               sizeof(struct scatterlist) * sg_elems;
> +               sizeof(struct scatterlist) * VIRTIO_BLK_INLINE_SG_CNT;
>         vblk->tag_set.driver_data = vblk;
>         vblk->tag_set.nr_hw_queues = vblk->num_vqs;
>
> --
> 2.18.1
>
