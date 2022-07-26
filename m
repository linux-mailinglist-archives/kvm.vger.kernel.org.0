Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2DE85815A1
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 16:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239312AbiGZOps (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 10:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiGZOpr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 10:45:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A2E96614B
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 07:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658846744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=84ZfrNa5yoHAhq0ZrcLkroLHzQItjvunPyOhWeRCkPs=;
        b=GgUymXk1LHP3rMO9OorTUXCim7hjYpI2cEvse3Z3t2jhp76PgXzPfHKAPhqA/3Z2at+iHq
        dti4Hu4IUi/XPYw0ySlR/dt8qLbA8I2sBlTuDz+w74zZ+nNhrM5+JFoioaR7dVixVcqa5c
        Ec8S1tzrDemjj0HtAjRHEltK3i531AM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-158-Fhh8IcboP8m7RD4fcQjGow-1; Tue, 26 Jul 2022 10:45:43 -0400
X-MC-Unique: Fhh8IcboP8m7RD4fcQjGow-1
Received: by mail-wm1-f69.google.com with SMTP id 130-20020a1c0288000000b003a3497306a8so1242083wmc.9
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 07:45:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=84ZfrNa5yoHAhq0ZrcLkroLHzQItjvunPyOhWeRCkPs=;
        b=JRJbgUMQRLXHSOMeKmvbE6N+ZYFzuSIZarPDextdwnyuS9dwLA8HlR2otbSUW2rt+u
         7HmyftlDmp4athrX36Cx7Q88Hzj9SuCV75yFX+QT2YN34Cj+fG4fexOwhL6t9NLUqOgU
         kLJInbiNAUb7V7lc2U+05g8o6WKY8iMepDQBhp2D4EVFrBzmkUjJ4fvYrKAure+L6eoA
         yKJswfXa/Jv9j1MgsiVb7jPT99VOOhpGhveCJdQ2xHMdISAvi0bQSiWzwPyh4HvFtPDl
         ttLfY4fvbA4N2Utr9vvw4CjDtm4S/AVhx56ZVPQdFNqHHKZgSge/WGbnHHIJS3S4sakL
         QUkw==
X-Gm-Message-State: AJIora+nSwFAKvqmQ5N6G8L/mUyfCXpcVOX9W13rhQHu3Zc6KrQD2ZRn
        PwKfe47IO1zy4cDw7PYtdbkX6JhRdiWFJYBg9nuiBoZB8ZGvt5jQ1KfK47U9FM5vS+gAf3SOg2V
        Si7Aiqgdz5ZdK
X-Received: by 2002:a05:600c:4e94:b0:3a3:4448:62cc with SMTP id f20-20020a05600c4e9400b003a3444862ccmr12345485wmq.108.1658846742100;
        Tue, 26 Jul 2022 07:45:42 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s5kPAQ12tYkaxnjB3qywnwU12zef+zBnYHWHd5Bzd65n/uF+pqQGFvOqoRAt/Pccw/ZzniBA==
X-Received: by 2002:a05:600c:4e94:b0:3a3:4448:62cc with SMTP id f20-20020a05600c4e9400b003a3444862ccmr12345457wmq.108.1658846741408;
        Tue, 26 Jul 2022 07:45:41 -0700 (PDT)
Received: from redhat.com ([2.55.4.105])
        by smtp.gmail.com with ESMTPSA id r8-20020adfdc88000000b0021e13efa17esm14531398wrj.70.2022.07.26.07.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 07:45:40 -0700 (PDT)
Date:   Tue, 26 Jul 2022 10:45:37 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        jasowang@redhat.com, asias@redhat.com, den@virtuozzo.com
Subject: Re: [RFC PATCH 1/1] drivers/vhost: vhost-blk accelerator for
 virtio-blk guests
Message-ID: <20220726104354-mutt-send-email-mst@kernel.org>
References: <20220725202753.298725-1-andrey.zhadchenko@virtuozzo.com>
 <20220725202753.298725-2-andrey.zhadchenko@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220725202753.298725-2-andrey.zhadchenko@virtuozzo.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 25, 2022 at 11:27:53PM +0300, Andrey Zhadchenko wrote:
> Although QEMU virtio is quite fast, there is still some room for
> improvements. Disk latency can be reduced if we handle virito-blk requests
> in host kernel istead of passing them to QEMU. The patch adds vhost-blk
> kernel module to do so.
> 
> Some test setups:
> fio --direct=1 --rw=randread  --bs=4k  --ioengine=libaio --iodepth=128
> QEMU drive options: cache=none
> filesystem: xfs
> 
> SSD:
>                | randread, IOPS  | randwrite, IOPS |
> Host           |      95.8k      |      85.3k      |
> QEMU virtio    |      57.5k      |      79.4k      |
> QEMU vhost-blk |      95.6k      |      84.3k      |
> 
> RAMDISK (vq == vcpu):
>                  | randread, IOPS | randwrite, IOPS |
> virtio, 1vcpu    |      123k      |      129k       |
> virtio, 2vcpu    |      253k (??) |      250k (??)  |
> virtio, 4vcpu    |      158k      |      154k       |
> vhost-blk, 1vcpu |      110k      |      113k       |
> vhost-blk, 2vcpu |      247k      |      252k       |
> vhost-blk, 4vcpu |      576k      |      567k       |
> 
> Signed-off-by: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>


Sounds good to me. What this depends on is whether some userspace
will actually use it. In the past QEMU rejected support for vhost-blk,
if this time it fares better then I won't have a problem merging
the kernel bits.

> ---
>  drivers/vhost/Kconfig      |  12 +
>  drivers/vhost/Makefile     |   3 +
>  drivers/vhost/blk.c        | 831 +++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/vhost.h |   4 +
>  4 files changed, 850 insertions(+)
>  create mode 100644 drivers/vhost/blk.c
> 
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index 587fbae06182..bcd21a434885 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -89,4 +89,16 @@ config VHOST_CROSS_ENDIAN_LEGACY
>  
>  	  If unsure, say "N".
>  
> +config VHOST_BLK
> +	tristate "Host kernel accelerator for virtio-blk (EXPERIMENTAL)"
> +	depends on BLOCK && EVENTFD
> +	select VHOST
> +	default n
> +	help
> +	  This kernel module can be loaded in host kernel to accelerate
> +	  guest vm with virtio-blk driver.
> +
> +	  To compile this driver as a module, choose M here: the module will
> +	  be called vhost_blk.
> +
>  endif
> diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
> index f3e1897cce85..c76cc4f5fcd8 100644
> --- a/drivers/vhost/Makefile
> +++ b/drivers/vhost/Makefile
> @@ -17,3 +17,6 @@ obj-$(CONFIG_VHOST)	+= vhost.o
>  
>  obj-$(CONFIG_VHOST_IOTLB) += vhost_iotlb.o
>  vhost_iotlb-y := iotlb.o
> +
> +obj-$(CONFIG_VHOST_BLK) += vhost_blk.o
> +vhost_blk-y := blk.o
> diff --git a/drivers/vhost/blk.c b/drivers/vhost/blk.c
> new file mode 100644
> index 000000000000..2c3cda47b54f
> --- /dev/null
> +++ b/drivers/vhost/blk.c
> @@ -0,0 +1,831 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2011 Taobao, Inc.
> + * Author: Liu Yuan <tailai.ly@taobao.com>
> + *
> + * Copyright (C) 2012 Red Hat, Inc.
> + * Author: Asias He <asias@redhat.com>
> + *
> + * Copyright (c) 2022 Virtuozzo International GmbH.
> + * Author: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
> + *
> + * virtio-blk host kernel accelerator.
> + */
> +
> +#include <linux/miscdevice.h>
> +#include <linux/module.h>
> +#include <linux/vhost.h>
> +#include <linux/virtio_blk.h>
> +#include <linux/mutex.h>
> +#include <linux/file.h>
> +#include <linux/kthread.h>
> +#include <linux/blkdev.h>
> +#include <linux/llist.h>
> +
> +#include "vhost.h"
> +
> +enum {
> +	VHOST_BLK_FEATURES = VHOST_FEATURES |
> +			     (1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
> +			     (1ULL << VIRTIO_RING_F_EVENT_IDX) |
> +			     (1ULL << VIRTIO_BLK_F_MQ) |
> +			     (1ULL << VIRTIO_BLK_F_FLUSH),
> +};
> +
> +/*
> + * Max number of bytes transferred before requeueing the job.
> + * Using this limit prevents one virtqueue from starving others.
> + */
> +#define VHOST_DEV_WEIGHT 0x80000
> +
> +/*
> + * Max number of packets transferred before requeueing the job.
> + * Using this limit prevents one virtqueue from starving others with
> + * pkts.
> + */
> +#define VHOST_DEV_PKT_WEIGHT 256
> +
> +enum {
> +	VHOST_BLK_VQ = 0,
> +	VHOST_BLK_VQ_MAX = 8,
> +};
> +
> +#define VHOST_MAX_METADATA_IOV 1
> +
> +struct req_page_list {
> +	struct page **pages;
> +	int pages_nr;
> +};
> +
> +#define NR_INLINE 16
> +
> +struct vhost_blk_req {
> +	struct req_page_list inline_pl[NR_INLINE];
> +	struct page *inline_page[NR_INLINE];
> +	struct bio *inline_bio[NR_INLINE];
> +	struct req_page_list *pl;
> +	int during_flush;
> +	bool use_inline;
> +
> +	struct llist_node llnode;
> +
> +	struct vhost_blk *blk;
> +
> +	struct iovec *iov;
> +	int iov_nr;
> +
> +	struct bio **bio;
> +	atomic_t bio_nr;
> +
> +	struct iovec status[VHOST_MAX_METADATA_IOV];
> +
> +	sector_t sector;
> +	int bi_opf;
> +	u16 head;
> +	long len;
> +	int bio_err;
> +
> +	struct vhost_blk_vq *blk_vq;
> +};
> +
> +struct vhost_blk_vq {
> +	struct vhost_virtqueue vq;
> +	struct vhost_blk_req *req;
> +	struct iovec iov[UIO_MAXIOV];
> +	struct llist_head llhead;
> +	struct vhost_work work;
> +};
> +
> +struct vhost_blk {
> +	wait_queue_head_t flush_wait;
> +	struct vhost_blk_vq vqs[VHOST_BLK_VQ_MAX];
> +	atomic_t req_inflight[2];
> +	spinlock_t flush_lock;
> +	struct vhost_dev dev;
> +	int during_flush;
> +	struct file *backend;
> +	int index;
> +};
> +
> +static int gen;
> +
> +static int move_iovec(struct iovec *from, struct iovec *to,
> +		      size_t len, int iov_count_from, int iov_count_to)
> +{
> +	int moved_seg = 0, spent_seg = 0;
> +	size_t size;
> +
> +	while (len && spent_seg < iov_count_from && moved_seg < iov_count_to) {
> +		if (from->iov_len == 0) {
> +			++from;
> +			++spent_seg;
> +			continue;
> +		}
> +		size = min(from->iov_len, len);
> +		to->iov_base = from->iov_base;
> +		to->iov_len = size;
> +		from->iov_len -= size;
> +		from->iov_base += size;
> +		len -= size;
> +		++from;
> +		++to;
> +		++moved_seg;
> +		++spent_seg;
> +	}
> +
> +	return len ? -1 : moved_seg;
> +}
> +
> +static inline int iov_num_pages(struct iovec *iov)
> +{
> +	return (PAGE_ALIGN((unsigned long)iov->iov_base + iov->iov_len) -
> +	       ((unsigned long)iov->iov_base & PAGE_MASK)) >> PAGE_SHIFT;
> +}
> +
> +static inline int vhost_blk_set_status(struct vhost_blk_req *req, u8 status)
> +{
> +	struct iov_iter iter;
> +	int ret;
> +
> +	iov_iter_init(&iter, WRITE, req->status, ARRAY_SIZE(req->status), sizeof(status));
> +	ret = copy_to_iter(&status, sizeof(status), &iter);
> +	if (ret != sizeof(status)) {
> +		vq_err(&req->blk_vq->vq, "Failed to write status\n");
> +		return -EFAULT;
> +	}
> +
> +	return 0;
> +}
> +
> +static void vhost_blk_req_done(struct bio *bio)
> +{
> +	struct vhost_blk_req *req = bio->bi_private;
> +	struct vhost_blk *blk = req->blk;
> +
> +	req->bio_err = blk_status_to_errno(bio->bi_status);
> +
> +	if (atomic_dec_and_test(&req->bio_nr)) {
> +		llist_add(&req->llnode, &req->blk_vq->llhead);
> +		vhost_work_queue(&blk->dev, &req->blk_vq->work);
> +	}
> +
> +	bio_put(bio);
> +}
> +
> +static void vhost_blk_req_umap(struct vhost_blk_req *req)
> +{
> +	struct req_page_list *pl;
> +	int i, j;
> +
> +	if (req->pl) {
> +		for (i = 0; i < req->iov_nr; i++) {
> +			pl = &req->pl[i];
> +
> +			for (j = 0; j < pl->pages_nr; j++) {
> +				if (!req->bi_opf)
> +					set_page_dirty_lock(pl->pages[j]);
> +				put_page(pl->pages[j]);
> +			}
> +		}
> +	}
> +
> +	if (!req->use_inline)
> +		kfree(req->pl);
> +}
> +
> +static int vhost_blk_bio_make_simple(struct vhost_blk_req *req,
> +				     struct block_device *bdev)
> +{
> +	struct bio *bio;
> +
> +	req->use_inline = true;
> +	req->pl = NULL;
> +	req->bio = req->inline_bio;
> +
> +	bio = bio_alloc(GFP_KERNEL, 1);
> +	if (!bio)
> +		return -ENOMEM;
> +
> +	bio->bi_iter.bi_sector = req->sector;
> +	bio_set_dev(bio, bdev);
> +	bio->bi_private = req;
> +	bio->bi_end_io  = vhost_blk_req_done;
> +	bio->bi_opf	= req->bi_opf;
> +	req->bio[0] = bio;
> +
> +	atomic_set(&req->bio_nr, 1);
> +
> +	return 0;
> +}
> +
> +static struct page **vhost_blk_prepare_req(struct vhost_blk_req *req,
> +				 int total_pages, int iov_nr)
> +{
> +	int pl_len, page_len, bio_len;
> +	void *buf;
> +
> +	req->use_inline = false;
> +	pl_len = iov_nr * sizeof(req->pl[0]);
> +	page_len = total_pages * sizeof(struct page *);
> +	bio_len = total_pages * sizeof(struct bio *);
> +
> +	buf = kmalloc(pl_len + page_len + bio_len, GFP_KERNEL);
> +	if (!buf)
> +		return NULL;
> +
> +	req->pl	= buf;
> +	req->bio = buf + pl_len + page_len;
> +
> +	return buf + pl_len;
> +}
> +
> +static int vhost_blk_bio_make(struct vhost_blk_req *req,
> +			      struct block_device *bdev)
> +{
> +	int pages_nr_total, i, j, ret;
> +	struct iovec *iov = req->iov;
> +	int iov_nr = req->iov_nr;
> +	struct page **pages, *page;
> +	struct bio *bio = NULL;
> +	int bio_nr = 0;
> +
> +	if (unlikely(req->bi_opf == REQ_OP_FLUSH))
> +		return vhost_blk_bio_make_simple(req, bdev);
> +
> +	pages_nr_total = 0;
> +	for (i = 0; i < iov_nr; i++)
> +		pages_nr_total += iov_num_pages(&iov[i]);
> +
> +	if (pages_nr_total > NR_INLINE) {
> +		pages = vhost_blk_prepare_req(req, pages_nr_total, iov_nr);
> +		if (!pages)
> +			return -ENOMEM;
> +	} else {
> +		req->use_inline = true;
> +		req->pl = req->inline_pl;
> +		pages = req->inline_page;
> +		req->bio = req->inline_bio;
> +	}
> +
> +	req->iov_nr = 0;
> +	for (i = 0; i < iov_nr; i++) {
> +		int pages_nr = iov_num_pages(&iov[i]);
> +		unsigned long iov_base, iov_len;
> +		struct req_page_list *pl;
> +
> +		iov_base = (unsigned long)iov[i].iov_base;
> +		iov_len  = (unsigned long)iov[i].iov_len;
> +
> +		ret = get_user_pages_fast(iov_base, pages_nr,
> +					  !req->bi_opf, pages);
> +		if (ret != pages_nr)
> +			goto fail;
> +
> +		req->iov_nr++;
> +		pl = &req->pl[i];
> +		pl->pages_nr = pages_nr;
> +		pl->pages = pages;
> +
> +		for (j = 0; j < pages_nr; j++) {
> +			unsigned int off, len;
> +
> +			page = pages[j];
> +			off = iov_base & ~PAGE_MASK;
> +			len = PAGE_SIZE - off;
> +			if (len > iov_len)
> +				len = iov_len;
> +
> +			bio = bio_alloc(GFP_KERNEL, 1);
> +			if (!bio)
> +				goto fail;
> +			bio->bi_iter.bi_sector  = req->sector;
> +			bio_set_dev(bio, bdev);
> +			bio->bi_private = req;
> +			bio->bi_end_io  = vhost_blk_req_done;
> +			bio->bi_opf	= req->bi_opf;
> +			req->bio[bio_nr++] = bio;
> +			bio_add_page(bio, page, len, off);
> +			req->sector	+= len >> 9;
> +			iov_base	+= len;
> +			iov_len		-= len;
> +		}
> +
> +		pages += pages_nr;
> +	}
> +	atomic_set(&req->bio_nr, bio_nr);
> +	return 0;
> +
> +fail:
> +	for (i = 0; i < bio_nr; i++)
> +		bio_put(req->bio[i]);
> +	vhost_blk_req_umap(req);
> +	return -ENOMEM;
> +}
> +
> +static inline void vhost_blk_bio_send(struct vhost_blk_req *req)
> +{
> +	struct blk_plug plug;
> +	int i, bio_nr;
> +
> +	bio_nr = atomic_read(&req->bio_nr);
> +	blk_start_plug(&plug);
> +	for (i = 0; i < bio_nr; i++)
> +		submit_bio(req->bio[i]);
> +
> +	blk_finish_plug(&plug);
> +}
> +
> +static int vhost_blk_req_submit(struct vhost_blk_req *req, struct file *file)
> +{
> +
> +	struct inode *inode = file->f_mapping->host;
> +	struct block_device *bdev = I_BDEV(inode);
> +	int ret;
> +
> +	ret = vhost_blk_bio_make(req, bdev);
> +	if (ret < 0)
> +		return ret;
> +
> +	vhost_blk_bio_send(req);
> +
> +	spin_lock(&req->blk->flush_lock);
> +	req->during_flush = req->blk->during_flush;
> +	atomic_inc(&req->blk->req_inflight[req->during_flush]);
> +	spin_unlock(&req->blk->flush_lock);
> +
> +	return ret;
> +}
> +
> +static int vhost_blk_req_handle(struct vhost_virtqueue *vq,
> +				struct virtio_blk_outhdr *hdr,
> +				u16 head, u16 total_iov_nr,
> +				struct file *file)
> +{
> +	struct vhost_blk *blk = container_of(vq->dev, struct vhost_blk, dev);
> +	struct vhost_blk_vq *blk_vq = container_of(vq, struct vhost_blk_vq, vq);
> +	unsigned char id[VIRTIO_BLK_ID_BYTES];
> +	struct vhost_blk_req *req;
> +	struct iov_iter iter;
> +	int ret, len;
> +	u8 status;
> +
> +	req		= &blk_vq->req[head];
> +	req->blk_vq	= blk_vq;
> +	req->head	= head;
> +	req->blk	= blk;
> +	req->sector	= hdr->sector;
> +	req->iov	= blk_vq->iov;
> +
> +	req->len	= iov_length(vq->iov, total_iov_nr) - sizeof(status);
> +	req->iov_nr	= move_iovec(vq->iov, req->iov, req->len, total_iov_nr,
> +				     ARRAY_SIZE(blk_vq->iov));
> +
> +	move_iovec(vq->iov, req->status, sizeof(status), total_iov_nr, ARRAY_SIZE(req->status));
> +	if (req->iov_nr < 0)
> +		return -EINVAL;
> +
> +	switch (hdr->type) {
> +	case VIRTIO_BLK_T_OUT:
> +		req->bi_opf = REQ_OP_WRITE;
> +		ret = vhost_blk_req_submit(req, file);
> +		break;
> +	case VIRTIO_BLK_T_IN:
> +		req->bi_opf = REQ_OP_READ;
> +		ret = vhost_blk_req_submit(req, file);
> +		break;
> +	case VIRTIO_BLK_T_FLUSH:
> +		req->bi_opf = REQ_OP_FLUSH;
> +		ret = vhost_blk_req_submit(req, file);
> +		break;
> +	case VIRTIO_BLK_T_GET_ID:
> +		ret = snprintf(id, VIRTIO_BLK_ID_BYTES,
> +			       "vhost-blk%d", blk->index);
> +		if (ret < 0)
> +			break;
> +		len = ret;
> +		iov_iter_init(&iter, WRITE, req->iov, req->iov_nr, req->len);
> +		ret = copy_to_iter(id, len, &iter);
> +		status = ret < 0 ? VIRTIO_BLK_S_IOERR : VIRTIO_BLK_S_OK;
> +		ret = vhost_blk_set_status(req, status);
> +		if (ret)
> +			break;
> +		vhost_add_used_and_signal(&blk->dev, vq, head, len);
> +		break;
> +	default:
> +		vq_err(vq, "Unsupported request type %d\n", hdr->type);
> +		status = VIRTIO_BLK_S_UNSUPP;
> +		ret = vhost_blk_set_status(req, status);
> +		if (ret)
> +			break;
> +		vhost_add_used_and_signal(&blk->dev, vq, head, 0);
> +	}
> +
> +	return ret;
> +}
> +
> +static void vhost_blk_handle_guest_kick(struct vhost_work *work)
> +{
> +	struct virtio_blk_outhdr hdr;
> +	struct vhost_blk_vq *blk_vq;
> +	struct vhost_virtqueue *vq;
> +	struct iovec hdr_iovec[VHOST_MAX_METADATA_IOV];
> +	struct vhost_blk *blk;
> +	struct iov_iter iter;
> +	int in, out, ret;
> +	struct file *f;
> +	u16 head;
> +
> +	vq = container_of(work, struct vhost_virtqueue, poll.work);
> +	blk = container_of(vq->dev, struct vhost_blk, dev);
> +	blk_vq = container_of(vq, struct vhost_blk_vq, vq);
> +
> +	f = vhost_vq_get_backend(vq);
> +	if (!f)
> +		return;
> +
> +	vhost_disable_notify(&blk->dev, vq);
> +	for (;;) {
> +		head = vhost_get_vq_desc(vq, vq->iov,
> +					 ARRAY_SIZE(vq->iov),
> +					 &out, &in, NULL, NULL);
> +		if (unlikely(head < 0))
> +			break;
> +
> +		if (unlikely(head == vq->num)) {
> +			if (unlikely(vhost_enable_notify(&blk->dev, vq))) {
> +				vhost_disable_notify(&blk->dev, vq);
> +				continue;
> +			}
> +			break;
> +		}
> +
> +		ret = move_iovec(vq->iov, hdr_iovec, sizeof(hdr), in + out, ARRAY_SIZE(hdr_iovec));
> +		if (ret < 0) {
> +			vq_err(vq, "virtio_blk_hdr is too split!");
> +			vhost_discard_vq_desc(vq, 1);
> +			break;
> +		}
> +
> +		iov_iter_init(&iter, READ, hdr_iovec, ARRAY_SIZE(hdr_iovec), sizeof(hdr));
> +		ret = copy_from_iter(&hdr, sizeof(hdr), &iter);
> +		if (ret != sizeof(hdr)) {
> +			vq_err(vq, "Failed to get block header: read %d bytes instead of %ld!\n",
> +			       ret, sizeof(hdr));
> +			vhost_discard_vq_desc(vq, 1);
> +			break;
> +		}
> +
> +		if (vhost_blk_req_handle(vq, &hdr, head, out + in, f) < 0)
> +			break;
> +
> +		if (!llist_empty(&blk_vq->llhead)) {
> +			vhost_poll_queue(&vq->poll);
> +			break;
> +		}
> +	}
> +}
> +
> +static void vhost_blk_handle_host_kick(struct vhost_work *work)
> +{
> +	struct vhost_blk_vq *blk_vq;
> +	struct vhost_virtqueue *vq;
> +	struct vhost_blk_req *req;
> +	struct llist_node *llnode;
> +	struct vhost_blk *blk = NULL;
> +	bool added, zero;
> +	u8 status;
> +	int ret;
> +
> +	blk_vq = container_of(work, struct vhost_blk_vq, work);
> +	vq = &blk_vq->vq;
> +	llnode = llist_del_all(&blk_vq->llhead);
> +	added = false;
> +	while (llnode) {
> +		req = llist_entry(llnode, struct vhost_blk_req, llnode);
> +		llnode = llist_next(llnode);
> +
> +		if (!blk)
> +			blk = req->blk;
> +
> +		vhost_blk_req_umap(req);
> +
> +		status = req->bio_err == 0 ?  VIRTIO_BLK_S_OK : VIRTIO_BLK_S_IOERR;
> +		ret = vhost_blk_set_status(req, status);
> +		if (unlikely(ret))
> +			continue;
> +
> +		vhost_add_used(vq, req->head, req->len);
> +		added = true;
> +
> +		spin_lock(&req->blk->flush_lock);
> +		zero = atomic_dec_and_test(
> +				&req->blk->req_inflight[req->during_flush]);
> +		if (zero && !req->during_flush)
> +			wake_up(&blk->flush_wait);
> +		spin_unlock(&req->blk->flush_lock);
> +
> +	}
> +
> +	if (likely(added))
> +		vhost_signal(&blk->dev, vq);
> +}
> +
> +static void vhost_blk_flush(struct vhost_blk *blk)
> +{
> +	int i;
> +
> +	spin_lock(&blk->flush_lock);
> +	blk->during_flush = 1;
> +	spin_unlock(&blk->flush_lock);
> +
> +	for (i = 0; i < VHOST_BLK_VQ_MAX; i++)
> +		vhost_poll_flush(&blk->vqs[i].vq.poll);
> +	vhost_work_dev_flush(&blk->dev);
> +	/*
> +	 * Wait until requests fired before the flush to be finished
> +	 * req_inflight[0] is used to track the requests fired before the flush
> +	 * req_inflight[1] is used to track the requests fired during the flush
> +	 */
> +	wait_event(blk->flush_wait, !atomic_read(&blk->req_inflight[0]));
> +
> +	spin_lock(&blk->flush_lock);
> +	blk->during_flush = 0;
> +	spin_unlock(&blk->flush_lock);
> +}
> +
> +static inline void vhost_blk_drop_backends(struct vhost_blk *blk)
> +{
> +	struct vhost_virtqueue *vq;
> +	int i;
> +
> +	for (i = 0; i < VHOST_BLK_VQ_MAX; i++) {
> +		vq = &blk->vqs[i].vq;
> +
> +		mutex_lock(&vq->mutex);
> +		vhost_vq_set_backend(vq, NULL);
> +		mutex_unlock(&vq->mutex);
> +	}
> +}
> +
> +static int vhost_blk_open(struct inode *inode, struct file *file)
> +{
> +	struct vhost_blk *blk;
> +	struct vhost_virtqueue **vqs;
> +	int ret = 0, i = 0;
> +
> +	blk = kvzalloc(sizeof(*blk), GFP_KERNEL);
> +	if (!blk) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	vqs = kcalloc(VHOST_BLK_VQ_MAX, sizeof(*vqs), GFP_KERNEL);
> +	if (!vqs) {
> +		ret = -ENOMEM;
> +		goto out_blk;
> +	}
> +
> +	for (i = 0; i < VHOST_BLK_VQ_MAX; i++) {
> +		blk->vqs[i].vq.handle_kick = vhost_blk_handle_guest_kick;
> +		vqs[i] = &blk->vqs[i].vq;
> +	}
> +
> +	blk->index = gen++;
> +
> +	atomic_set(&blk->req_inflight[0], 0);
> +	atomic_set(&blk->req_inflight[1], 0);
> +	blk->during_flush = 0;
> +	spin_lock_init(&blk->flush_lock);
> +	init_waitqueue_head(&blk->flush_wait);
> +
> +	vhost_dev_init(&blk->dev, vqs, VHOST_BLK_VQ_MAX, UIO_MAXIOV,
> +		       VHOST_DEV_WEIGHT, VHOST_DEV_PKT_WEIGHT, true, NULL);
> +	file->private_data = blk;
> +
> +	for (i = 0; i < VHOST_BLK_VQ_MAX; i++)
> +		vhost_work_init(&blk->vqs[i].work, vhost_blk_handle_host_kick);
> +
> +	return ret;
> +out_blk:
> +	kvfree(blk);
> +out:
> +	return ret;
> +}
> +
> +static int vhost_blk_release(struct inode *inode, struct file *f)
> +{
> +	struct vhost_blk *blk = f->private_data;
> +	int i;
> +
> +	vhost_blk_drop_backends(blk);
> +	vhost_blk_flush(blk);
> +	vhost_dev_stop(&blk->dev);
> +	if (blk->backend)
> +		fput(blk->backend);
> +	vhost_dev_cleanup(&blk->dev);
> +	for (i = 0; i < VHOST_BLK_VQ_MAX; i++)
> +		kvfree(blk->vqs[i].req);
> +	kfree(blk->dev.vqs);
> +	kvfree(blk);
> +
> +	return 0;
> +}
> +
> +static int vhost_blk_set_features(struct vhost_blk *blk, u64 features)
> +{
> +	struct vhost_virtqueue *vq;
> +	int i;
> +
> +	mutex_lock(&blk->dev.mutex);
> +	if ((features & (1 << VHOST_F_LOG_ALL)) &&
> +	    !vhost_log_access_ok(&blk->dev)) {
> +		mutex_unlock(&blk->dev.mutex);
> +		return -EFAULT;
> +	}
> +
> +	for (i = 0; i < VHOST_BLK_VQ_MAX; i++) {
> +		vq = &blk->vqs[i].vq;
> +		mutex_lock(&vq->mutex);
> +		vq->acked_features = features & (VHOST_BLK_FEATURES);
> +		mutex_unlock(&vq->mutex);
> +	}
> +
> +	vhost_blk_flush(blk);
> +	mutex_unlock(&blk->dev.mutex);
> +
> +	return 0;
> +}
> +
> +static long vhost_blk_set_backend(struct vhost_blk *blk, int fd)
> +{
> +	struct vhost_virtqueue *vq;
> +	struct file *file, *oldfile = NULL;
> +	struct inode *inode;
> +	int ret, i;
> +
> +	mutex_lock(&blk->dev.mutex);
> +	ret = vhost_dev_check_owner(&blk->dev);
> +	if (ret)
> +		goto out_dev;
> +
> +	file = fget(fd);
> +	if (IS_ERR(file)) {
> +		ret = PTR_ERR(file);
> +		goto out_dev;
> +	}
> +
> +	if (file == blk->backend) {
> +		fput(file);
> +		goto out_dev;
> +	}
> +
> +	oldfile = blk->backend;
> +	blk->backend = file;
> +
> +	inode = file->f_mapping->host;
> +	if (!S_ISBLK(inode->i_mode)) {
> +		ret = -EFAULT;
> +		goto out_file;
> +	}
> +
> +	for (i = 0; i < VHOST_BLK_VQ_MAX; i++) {
> +		vq = &blk->vqs[i].vq;
> +		if (!vhost_vq_access_ok(vq)) {
> +			ret = -EFAULT;
> +			goto out_drop;
> +		}
> +
> +		mutex_lock(&vq->mutex);
> +		vhost_vq_set_backend(vq, file);
> +		ret = vhost_vq_init_access(vq);
> +		mutex_unlock(&vq->mutex);
> +	}
> +
> +	if (oldfile) {
> +		vhost_blk_flush(blk);
> +		fput(oldfile);
> +	}
> +
> +	mutex_unlock(&blk->dev.mutex);
> +	return 0;
> +
> +out_drop:
> +	vhost_blk_drop_backends(blk);
> +out_file:
> +	fput(file);
> +	blk->backend = NULL;
> +out_dev:
> +	mutex_unlock(&blk->dev.mutex);
> +	return ret;
> +}
> +
> +static long vhost_blk_reset_owner(struct vhost_blk *blk)
> +{
> +	struct vhost_iotlb *umem;
> +	int err, i;
> +
> +	mutex_lock(&blk->dev.mutex);
> +	err = vhost_dev_check_owner(&blk->dev);
> +	if (err)
> +		goto done;
> +	umem = vhost_dev_reset_owner_prepare();
> +	if (!umem) {
> +		err = -ENOMEM;
> +		goto done;
> +	}
> +	vhost_blk_drop_backends(blk);
> +	if (blk->backend) {
> +		fput(blk->backend);
> +		blk->backend = NULL;
> +	}
> +	vhost_blk_flush(blk);
> +	vhost_dev_stop(&blk->dev);
> +	vhost_dev_reset_owner(&blk->dev, umem);
> +
> +	for (i = 0; i < VHOST_BLK_VQ_MAX; i++) {
> +		kvfree(blk->vqs[i].req);
> +		blk->vqs[i].req = NULL;
> +	}
> +
> +done:
> +	mutex_unlock(&blk->dev.mutex);
> +	return err;
> +}
> +
> +static int vhost_blk_setup(struct vhost_blk *blk, void __user *argp)
> +{
> +	struct vhost_vring_state s;
> +
> +	if (copy_from_user(&s, argp, sizeof(s)))
> +		return -EFAULT;
> +
> +	if (blk->vqs[s.index].req)
> +		return 0;
> +
> +	blk->vqs[s.index].req = kvmalloc(sizeof(struct vhost_blk_req) * s.num, GFP_KERNEL);
> +	if (!blk->vqs[s.index].req)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
> +static long vhost_blk_ioctl(struct file *f, unsigned int ioctl,
> +			    unsigned long arg)
> +{
> +	struct vhost_blk *blk = f->private_data;
> +	void __user *argp = (void __user *)arg;
> +	struct vhost_vring_file backend;
> +	u64 __user *featurep = argp;
> +	u64 features;
> +	int ret;
> +
> +	switch (ioctl) {
> +	case VHOST_BLK_SET_BACKEND:
> +		if (copy_from_user(&backend, argp, sizeof(backend)))
> +			return -EFAULT;
> +		return vhost_blk_set_backend(blk, backend.fd);
> +	case VHOST_GET_FEATURES:
> +		features = VHOST_BLK_FEATURES;
> +		if (copy_to_user(featurep, &features, sizeof(features)))
> +			return -EFAULT;
> +		return 0;
> +	case VHOST_SET_FEATURES:
> +		if (copy_from_user(&features, featurep, sizeof(features)))
> +			return -EFAULT;
> +		if (features & ~VHOST_BLK_FEATURES)
> +			return -EOPNOTSUPP;
> +		return vhost_blk_set_features(blk, features);
> +	case VHOST_RESET_OWNER:
> +		return vhost_blk_reset_owner(blk);
> +	default:
> +		mutex_lock(&blk->dev.mutex);
> +		ret = vhost_dev_ioctl(&blk->dev, ioctl, argp);
> +		if (ret == -ENOIOCTLCMD)
> +			ret = vhost_vring_ioctl(&blk->dev, ioctl, argp);
> +		if (!ret && ioctl == VHOST_SET_VRING_NUM)
> +			ret = vhost_blk_setup(blk, argp);
> +		vhost_blk_flush(blk);
> +		mutex_unlock(&blk->dev.mutex);
> +		return ret;
> +	}
> +}
> +
> +static const struct file_operations vhost_blk_fops = {
> +	.owner          = THIS_MODULE,
> +	.open           = vhost_blk_open,
> +	.release        = vhost_blk_release,
> +	.llseek		= noop_llseek,
> +	.unlocked_ioctl = vhost_blk_ioctl,
> +};
> +
> +static struct miscdevice vhost_blk_misc = {
> +	MISC_DYNAMIC_MINOR,
> +	"vhost-blk",
> +	&vhost_blk_fops,
> +};
> +module_misc_device(vhost_blk_misc);
> +
> +MODULE_VERSION("0.0.1");
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Andrey Zhadchenko");
> +MODULE_DESCRIPTION("Host kernel accelerator for virtio_blk");
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index cab645d4a645..a54861e9633e 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -171,4 +171,8 @@
>  #define VHOST_VDPA_SET_GROUP_ASID	_IOW(VHOST_VIRTIO, 0x7C, \
>  					     struct vhost_vring_state)
>  
> +/* VHOST_BLK specific defines */
> +#define VHOST_BLK_SET_BACKEND		_IOW(VHOST_VIRTIO, 0x90, \
> +					     struct vhost_vring_file)
> +
>  #endif
> -- 
> 2.31.1

