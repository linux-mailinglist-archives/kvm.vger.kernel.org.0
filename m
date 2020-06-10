Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835D91F52D3
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 13:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgFJLFU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 07:05:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28150 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728331AbgFJLFS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 07:05:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591787114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+mk26jPfFqmgR4ZNEZAyeCX9ZrGHsYfrK97m1CG1piI=;
        b=amUZZJ3z/x1M2/Uoz01xfYGaAH+2zAa/lZzk/H5/LRzAKUp+ngdbNcqgVfFD3ISszd8BjH
        fX0hZPSvLOuk6aJYZXixFXQbUC/Ney3qksN3fwKR8joKh65yGFAucPYU62ld+uePSaFltK
        eqPRtdfvI3cVmo4hKoxxD56D55sUmcE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-lZD5QfhuOAq5mMVw-ylryQ-1; Wed, 10 Jun 2020 07:05:10 -0400
X-MC-Unique: lZD5QfhuOAq5mMVw-ylryQ-1
Received: by mail-wm1-f69.google.com with SMTP id b63so1783457wme.1
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 04:05:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+mk26jPfFqmgR4ZNEZAyeCX9ZrGHsYfrK97m1CG1piI=;
        b=lB3A9QxsR6o3PI9wSj17dNV3X3wh2Sd0JYqgAKlLaLkVaZ/eyywJGaJC+1W/USaj3Q
         OF+/bJHE7eBUDRvT6ghL264nTzVcHuwIy2JSsUVB187fHQRVmbEUrEM+11aGYswV8x02
         mJCUwQoMI0KmoI3VfOuLaKEN9o1/ltyoB0T/XSmtfh5i86IRgc93VLZ9bN63+bPcH2uU
         Hrcubp6CO9H9/u9E+MESoLbGJIYX3UNla/fkoEk4eAsp3u/d3brx4h6tn9NIXd37K9fp
         o2pXolaPWGPxosV+NRZuTW49Vfx8k3E8ZG5QkTpry8bhqn1IwQd13Wl0cLfp+cIIv5aH
         srQg==
X-Gm-Message-State: AOAM530yHx7vUtLqix4nYrVf47Pz08xPOQ7CMec4hSBxWV8SGQOmU+tk
        ZCB2sAx43QSPitou68QaQ0YMmjYJegVyOyyU+ilAQptas4G1UShBmYK/nJ7+GehDp9xmCyBXlZa
        bwj1XZ2UyHeVh
X-Received: by 2002:a5d:684d:: with SMTP id o13mr3041682wrw.364.1591787109436;
        Wed, 10 Jun 2020 04:05:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz2guq17q1FmR9wZfh7EC5QlcT81ur3UoVFADRnJrG6I7wD3FEnpM9mzzIYPsBXs1biRDCYyA==
X-Received: by 2002:a5d:684d:: with SMTP id o13mr3041644wrw.364.1591787109015;
        Wed, 10 Jun 2020 04:05:09 -0700 (PDT)
Received: from redhat.com ([212.92.121.57])
        by smtp.gmail.com with ESMTPSA id a14sm7854905wrv.20.2020.06.10.04.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 04:05:08 -0700 (PDT)
Date:   Wed, 10 Jun 2020 07:05:05 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        eperezma@redhat.com
Subject: Re: [PATCH RFC v6 02/11] vhost: use batched get_vq_desc version
Message-ID: <20200610070259-mutt-send-email-mst@kernel.org>
References: <20200608125238.728563-1-mst@redhat.com>
 <20200608125238.728563-3-mst@redhat.com>
 <81904cc5-b662-028d-3b4a-bdfdbd2deb8c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <81904cc5-b662-028d-3b4a-bdfdbd2deb8c@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 10, 2020 at 11:14:49AM +0800, Jason Wang wrote:
> 
> On 2020/6/8 下午8:52, Michael S. Tsirkin wrote:
> > As testing shows no performance change, switch to that now.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
> > Link: https://lore.kernel.org/r/20200401183118.8334-3-eperezma@redhat.com
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >   drivers/vhost/test.c  |   2 +-
> >   drivers/vhost/vhost.c | 318 ++++++++----------------------------------
> >   drivers/vhost/vhost.h |   7 +-
> >   3 files changed, 65 insertions(+), 262 deletions(-)
> > 
> > diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> > index 0466921f4772..7d69778aaa26 100644
> > --- a/drivers/vhost/test.c
> > +++ b/drivers/vhost/test.c
> > @@ -119,7 +119,7 @@ static int vhost_test_open(struct inode *inode, struct file *f)
> >   	dev = &n->dev;
> >   	vqs[VHOST_TEST_VQ] = &n->vqs[VHOST_TEST_VQ];
> >   	n->vqs[VHOST_TEST_VQ].handle_kick = handle_vq_kick;
> > -	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV,
> > +	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV + 64,
> >   		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT, true, NULL);
> >   	f->private_data = n;
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index 180b7b58c76b..41d6b132c234 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -304,6 +304,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
> >   {
> >   	vq->num = 1;
> >   	vq->ndescs = 0;
> > +	vq->first_desc = 0;
> >   	vq->desc = NULL;
> >   	vq->avail = NULL;
> >   	vq->used = NULL;
> > @@ -372,6 +373,11 @@ static int vhost_worker(void *data)
> >   	return 0;
> >   }
> > +static int vhost_vq_num_batch_descs(struct vhost_virtqueue *vq)
> > +{
> > +	return vq->max_descs - UIO_MAXIOV;
> > +}
> > +
> >   static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
> >   {
> >   	kfree(vq->descs);
> > @@ -394,6 +400,9 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
> >   	for (i = 0; i < dev->nvqs; ++i) {
> >   		vq = dev->vqs[i];
> >   		vq->max_descs = dev->iov_limit;
> > +		if (vhost_vq_num_batch_descs(vq) < 0) {
> > +			return -EINVAL;
> > +		}
> >   		vq->descs = kmalloc_array(vq->max_descs,
> >   					  sizeof(*vq->descs),
> >   					  GFP_KERNEL);
> > @@ -1610,6 +1619,7 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
> >   		vq->last_avail_idx = s.num;
> >   		/* Forget the cached index value. */
> >   		vq->avail_idx = vq->last_avail_idx;
> > +		vq->ndescs = vq->first_desc = 0;
> >   		break;
> >   	case VHOST_GET_VRING_BASE:
> >   		s.index = idx;
> > @@ -2078,253 +2088,6 @@ static unsigned next_desc(struct vhost_virtqueue *vq, struct vring_desc *desc)
> >   	return next;
> >   }
> > -static int get_indirect(struct vhost_virtqueue *vq,
> > -			struct iovec iov[], unsigned int iov_size,
> > -			unsigned int *out_num, unsigned int *in_num,
> > -			struct vhost_log *log, unsigned int *log_num,
> > -			struct vring_desc *indirect)
> > -{
> > -	struct vring_desc desc;
> > -	unsigned int i = 0, count, found = 0;
> > -	u32 len = vhost32_to_cpu(vq, indirect->len);
> > -	struct iov_iter from;
> > -	int ret, access;
> > -
> > -	/* Sanity check */
> > -	if (unlikely(len % sizeof desc)) {
> > -		vq_err(vq, "Invalid length in indirect descriptor: "
> > -		       "len 0x%llx not multiple of 0x%zx\n",
> > -		       (unsigned long long)len,
> > -		       sizeof desc);
> > -		return -EINVAL;
> > -	}
> > -
> > -	ret = translate_desc(vq, vhost64_to_cpu(vq, indirect->addr), len, vq->indirect,
> > -			     UIO_MAXIOV, VHOST_ACCESS_RO);
> > -	if (unlikely(ret < 0)) {
> > -		if (ret != -EAGAIN)
> > -			vq_err(vq, "Translation failure %d in indirect.\n", ret);
> > -		return ret;
> > -	}
> > -	iov_iter_init(&from, READ, vq->indirect, ret, len);
> > -
> > -	/* We will use the result as an address to read from, so most
> > -	 * architectures only need a compiler barrier here. */
> > -	read_barrier_depends();
> > -
> > -	count = len / sizeof desc;
> > -	/* Buffers are chained via a 16 bit next field, so
> > -	 * we can have at most 2^16 of these. */
> > -	if (unlikely(count > USHRT_MAX + 1)) {
> > -		vq_err(vq, "Indirect buffer length too big: %d\n",
> > -		       indirect->len);
> > -		return -E2BIG;
> > -	}
> > -
> > -	do {
> > -		unsigned iov_count = *in_num + *out_num;
> > -		if (unlikely(++found > count)) {
> > -			vq_err(vq, "Loop detected: last one at %u "
> > -			       "indirect size %u\n",
> > -			       i, count);
> > -			return -EINVAL;
> > -		}
> > -		if (unlikely(!copy_from_iter_full(&desc, sizeof(desc), &from))) {
> > -			vq_err(vq, "Failed indirect descriptor: idx %d, %zx\n",
> > -			       i, (size_t)vhost64_to_cpu(vq, indirect->addr) + i * sizeof desc);
> > -			return -EINVAL;
> > -		}
> > -		if (unlikely(desc.flags & cpu_to_vhost16(vq, VRING_DESC_F_INDIRECT))) {
> > -			vq_err(vq, "Nested indirect descriptor: idx %d, %zx\n",
> > -			       i, (size_t)vhost64_to_cpu(vq, indirect->addr) + i * sizeof desc);
> > -			return -EINVAL;
> > -		}
> > -
> > -		if (desc.flags & cpu_to_vhost16(vq, VRING_DESC_F_WRITE))
> > -			access = VHOST_ACCESS_WO;
> > -		else
> > -			access = VHOST_ACCESS_RO;
> > -
> > -		ret = translate_desc(vq, vhost64_to_cpu(vq, desc.addr),
> > -				     vhost32_to_cpu(vq, desc.len), iov + iov_count,
> > -				     iov_size - iov_count, access);
> > -		if (unlikely(ret < 0)) {
> > -			if (ret != -EAGAIN)
> > -				vq_err(vq, "Translation failure %d indirect idx %d\n",
> > -					ret, i);
> > -			return ret;
> > -		}
> > -		/* If this is an input descriptor, increment that count. */
> > -		if (access == VHOST_ACCESS_WO) {
> > -			*in_num += ret;
> > -			if (unlikely(log && ret)) {
> > -				log[*log_num].addr = vhost64_to_cpu(vq, desc.addr);
> > -				log[*log_num].len = vhost32_to_cpu(vq, desc.len);
> > -				++*log_num;
> > -			}
> > -		} else {
> > -			/* If it's an output descriptor, they're all supposed
> > -			 * to come before any input descriptors. */
> > -			if (unlikely(*in_num)) {
> > -				vq_err(vq, "Indirect descriptor "
> > -				       "has out after in: idx %d\n", i);
> > -				return -EINVAL;
> > -			}
> > -			*out_num += ret;
> > -		}
> > -	} while ((i = next_desc(vq, &desc)) != -1);
> > -	return 0;
> > -}
> > -
> > -/* This looks in the virtqueue and for the first available buffer, and converts
> > - * it to an iovec for convenient access.  Since descriptors consist of some
> > - * number of output then some number of input descriptors, it's actually two
> > - * iovecs, but we pack them into one and note how many of each there were.
> > - *
> > - * This function returns the descriptor number found, or vq->num (which is
> > - * never a valid descriptor number) if none was found.  A negative code is
> > - * returned on error. */
> > -int vhost_get_vq_desc(struct vhost_virtqueue *vq,
> > -		      struct iovec iov[], unsigned int iov_size,
> > -		      unsigned int *out_num, unsigned int *in_num,
> > -		      struct vhost_log *log, unsigned int *log_num)
> > -{
> > -	struct vring_desc desc;
> > -	unsigned int i, head, found = 0;
> > -	u16 last_avail_idx;
> > -	__virtio16 avail_idx;
> > -	__virtio16 ring_head;
> > -	int ret, access;
> > -
> > -	/* Check it isn't doing very strange things with descriptor numbers. */
> > -	last_avail_idx = vq->last_avail_idx;
> > -
> > -	if (vq->avail_idx == vq->last_avail_idx) {
> > -		if (unlikely(vhost_get_avail_idx(vq, &avail_idx))) {
> > -			vq_err(vq, "Failed to access avail idx at %p\n",
> > -				&vq->avail->idx);
> > -			return -EFAULT;
> > -		}
> > -		vq->avail_idx = vhost16_to_cpu(vq, avail_idx);
> > -
> > -		if (unlikely((u16)(vq->avail_idx - last_avail_idx) > vq->num)) {
> > -			vq_err(vq, "Guest moved used index from %u to %u",
> > -				last_avail_idx, vq->avail_idx);
> > -			return -EFAULT;
> > -		}
> > -
> > -		/* If there's nothing new since last we looked, return
> > -		 * invalid.
> > -		 */
> > -		if (vq->avail_idx == last_avail_idx)
> > -			return vq->num;
> > -
> > -		/* Only get avail ring entries after they have been
> > -		 * exposed by guest.
> > -		 */
> > -		smp_rmb();
> > -	}
> > -
> > -	/* Grab the next descriptor number they're advertising, and increment
> > -	 * the index we've seen. */
> > -	if (unlikely(vhost_get_avail_head(vq, &ring_head, last_avail_idx))) {
> > -		vq_err(vq, "Failed to read head: idx %d address %p\n",
> > -		       last_avail_idx,
> > -		       &vq->avail->ring[last_avail_idx % vq->num]);
> > -		return -EFAULT;
> > -	}
> > -
> > -	head = vhost16_to_cpu(vq, ring_head);
> > -
> > -	/* If their number is silly, that's an error. */
> > -	if (unlikely(head >= vq->num)) {
> > -		vq_err(vq, "Guest says index %u > %u is available",
> > -		       head, vq->num);
> > -		return -EINVAL;
> > -	}
> > -
> > -	/* When we start there are none of either input nor output. */
> > -	*out_num = *in_num = 0;
> > -	if (unlikely(log))
> > -		*log_num = 0;
> > -
> > -	i = head;
> > -	do {
> > -		unsigned iov_count = *in_num + *out_num;
> > -		if (unlikely(i >= vq->num)) {
> > -			vq_err(vq, "Desc index is %u > %u, head = %u",
> > -			       i, vq->num, head);
> > -			return -EINVAL;
> > -		}
> > -		if (unlikely(++found > vq->num)) {
> > -			vq_err(vq, "Loop detected: last one at %u "
> > -			       "vq size %u head %u\n",
> > -			       i, vq->num, head);
> > -			return -EINVAL;
> > -		}
> > -		ret = vhost_get_desc(vq, &desc, i);
> > -		if (unlikely(ret)) {
> > -			vq_err(vq, "Failed to get descriptor: idx %d addr %p\n",
> > -			       i, vq->desc + i);
> > -			return -EFAULT;
> > -		}
> > -		if (desc.flags & cpu_to_vhost16(vq, VRING_DESC_F_INDIRECT)) {
> > -			ret = get_indirect(vq, iov, iov_size,
> > -					   out_num, in_num,
> > -					   log, log_num, &desc);
> > -			if (unlikely(ret < 0)) {
> > -				if (ret != -EAGAIN)
> > -					vq_err(vq, "Failure detected "
> > -						"in indirect descriptor at idx %d\n", i);
> > -				return ret;
> > -			}
> > -			continue;
> > -		}
> > -
> > -		if (desc.flags & cpu_to_vhost16(vq, VRING_DESC_F_WRITE))
> > -			access = VHOST_ACCESS_WO;
> > -		else
> > -			access = VHOST_ACCESS_RO;
> > -		ret = translate_desc(vq, vhost64_to_cpu(vq, desc.addr),
> > -				     vhost32_to_cpu(vq, desc.len), iov + iov_count,
> > -				     iov_size - iov_count, access);
> > -		if (unlikely(ret < 0)) {
> > -			if (ret != -EAGAIN)
> > -				vq_err(vq, "Translation failure %d descriptor idx %d\n",
> > -					ret, i);
> > -			return ret;
> > -		}
> > -		if (access == VHOST_ACCESS_WO) {
> > -			/* If this is an input descriptor,
> > -			 * increment that count. */
> > -			*in_num += ret;
> > -			if (unlikely(log && ret)) {
> > -				log[*log_num].addr = vhost64_to_cpu(vq, desc.addr);
> > -				log[*log_num].len = vhost32_to_cpu(vq, desc.len);
> > -				++*log_num;
> > -			}
> > -		} else {
> > -			/* If it's an output descriptor, they're all supposed
> > -			 * to come before any input descriptors. */
> > -			if (unlikely(*in_num)) {
> > -				vq_err(vq, "Descriptor has out after in: "
> > -				       "idx %d\n", i);
> > -				return -EINVAL;
> > -			}
> > -			*out_num += ret;
> > -		}
> > -	} while ((i = next_desc(vq, &desc)) != -1);
> > -
> > -	/* On success, increment avail index. */
> > -	vq->last_avail_idx++;
> > -
> > -	/* Assume notifications from guest are disabled at this point,
> > -	 * if they aren't we would need to update avail_event index. */
> > -	BUG_ON(!(vq->used_flags & VRING_USED_F_NO_NOTIFY));
> > -	return head;
> > -}
> > -EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
> > -
> >   static struct vhost_desc *peek_split_desc(struct vhost_virtqueue *vq)
> >   {
> >   	BUG_ON(!vq->ndescs);
> > @@ -2428,7 +2191,7 @@ static int fetch_indirect_descs(struct vhost_virtqueue *vq,
> >   /* This function returns a value > 0 if a descriptor was found, or 0 if none were found.
> >    * A negative code is returned on error. */
> > -static int fetch_descs(struct vhost_virtqueue *vq)
> > +static int fetch_buf(struct vhost_virtqueue *vq)
> >   {
> >   	unsigned int i, head, found = 0;
> >   	struct vhost_desc *last;
> > @@ -2441,7 +2204,11 @@ static int fetch_descs(struct vhost_virtqueue *vq)
> >   	/* Check it isn't doing very strange things with descriptor numbers. */
> >   	last_avail_idx = vq->last_avail_idx;
> > -	if (vq->avail_idx == vq->last_avail_idx) {
> > +	if (unlikely(vq->avail_idx == vq->last_avail_idx)) {
> > +		/* If we already have work to do, don't bother re-checking. */
> > +		if (likely(vq->ndescs))
> > +			return 1;
> > +
> >   		if (unlikely(vhost_get_avail_idx(vq, &avail_idx))) {
> >   			vq_err(vq, "Failed to access avail idx at %p\n",
> >   				&vq->avail->idx);
> > @@ -2532,6 +2299,41 @@ static int fetch_descs(struct vhost_virtqueue *vq)
> >   	return 1;
> >   }
> > +/* This function returns a value > 0 if a descriptor was found, or 0 if none were found.
> > + * A negative code is returned on error. */
> > +static int fetch_descs(struct vhost_virtqueue *vq)
> > +{
> > +	int ret;
> > +
> > +	if (unlikely(vq->first_desc >= vq->ndescs)) {
> > +		vq->first_desc = 0;
> > +		vq->ndescs = 0;
> > +	}
> > +
> > +	if (vq->ndescs)
> > +		return 1;
> > +
> > +	for (ret = 1;
> > +	     ret > 0 && vq->ndescs <= vhost_vq_num_batch_descs(vq);
> > +	     ret = fetch_buf(vq))
> > +		;
> > +
> > +	/* On success we expect some descs */
> > +	BUG_ON(ret > 0 && !vq->ndescs);
> > +	return ret;
> > +}
> > +
> > +/* Reverse the effects of fetch_descs */
> > +static void unfetch_descs(struct vhost_virtqueue *vq)
> > +{
> > +	int i;
> > +
> > +	for (i = vq->first_desc; i < vq->ndescs; ++i)
> > +		if (!(vq->descs[i].flags & VRING_DESC_F_NEXT))
> > +			vq->last_avail_idx -= 1;
> > +	vq->ndescs = 0;
> > +}
> 
> 
> Is it better to set first_desc to zero here?
> 
> 
> > +
> >   /* This looks in the virtqueue and for the first available buffer, and converts
> >    * it to an iovec for convenient access.  Since descriptors consist of some
> >    * number of output then some number of input descriptors, it's actually two
> > @@ -2540,7 +2342,7 @@ static int fetch_descs(struct vhost_virtqueue *vq)
> >    * This function returns the descriptor number found, or vq->num (which is
> >    * never a valid descriptor number) if none was found.  A negative code is
> >    * returned on error. */
> > -int vhost_get_vq_desc_batch(struct vhost_virtqueue *vq,
> > +int vhost_get_vq_desc(struct vhost_virtqueue *vq,
> >   		      struct iovec iov[], unsigned int iov_size,
> >   		      unsigned int *out_num, unsigned int *in_num,
> >   		      struct vhost_log *log, unsigned int *log_num)
> > @@ -2549,7 +2351,7 @@ int vhost_get_vq_desc_batch(struct vhost_virtqueue *vq,
> >   	int i;
> >   	if (ret <= 0)
> > -		goto err_fetch;
> > +		goto err;
> >   	/* Now convert to IOV */
> >   	/* When we start there are none of either input nor output. */
> > @@ -2557,7 +2359,7 @@ int vhost_get_vq_desc_batch(struct vhost_virtqueue *vq,
> >   	if (unlikely(log))
> >   		*log_num = 0;
> > -	for (i = 0; i < vq->ndescs; ++i) {
> > +	for (i = vq->first_desc; i < vq->ndescs; ++i) {
> >   		unsigned iov_count = *in_num + *out_num;
> >   		struct vhost_desc *desc = &vq->descs[i];
> >   		int access;
> > @@ -2603,24 +2405,26 @@ int vhost_get_vq_desc_batch(struct vhost_virtqueue *vq,
> >   		}
> >   		ret = desc->id;
> > +
> > +		if (!(desc->flags & VRING_DESC_F_NEXT))
> > +			break;
> >   	}
> > -	vq->ndescs = 0;
> > +	vq->first_desc = i + 1;
> >   	return ret;
> >   err:
> > -	vhost_discard_vq_desc(vq, 1);
> > -err_fetch:
> > -	vq->ndescs = 0;
> > +	unfetch_descs(vq);
> >   	return ret;
> >   }
> > -EXPORT_SYMBOL_GPL(vhost_get_vq_desc_batch);
> > +EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
> >   /* Reverse the effect of vhost_get_vq_desc. Useful for error handling. */
> >   void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
> >   {
> > +	unfetch_descs(vq);
> >   	vq->last_avail_idx -= n;
> 
> 
> So unfetch_descs() has decreased last_avail_idx.
> Can we fix this by letting unfetch_descs() return the number and then we can
> do:
> 
> int d = unfetch_descs(vq);
> vq->last_avail_idx -= (n > d) ? n - d: 0;
> 
> Thanks


That's intentional I think - we need both.

Unfetch_descs drops the descriptors in the cache that were
*not returned to caller* through get_vq_desc.

vhost_discard_vq_desc drops the ones that were returned through get_vq_desc.

Did I miss anything?



> 
> >   }
> >   EXPORT_SYMBOL_GPL(vhost_discard_vq_desc);
> > diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> > index 87089d51490d..fed36af5c444 100644
> > --- a/drivers/vhost/vhost.h
> > +++ b/drivers/vhost/vhost.h
> > @@ -81,6 +81,7 @@ struct vhost_virtqueue {
> >   	struct vhost_desc *descs;
> >   	int ndescs;
> > +	int first_desc;
> >   	int max_descs;
> >   	struct file *kick;
> > @@ -189,10 +190,6 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
> >   bool vhost_vq_access_ok(struct vhost_virtqueue *vq);
> >   bool vhost_log_access_ok(struct vhost_dev *);
> > -int vhost_get_vq_desc_batch(struct vhost_virtqueue *,
> > -		      struct iovec iov[], unsigned int iov_count,
> > -		      unsigned int *out_num, unsigned int *in_num,
> > -		      struct vhost_log *log, unsigned int *log_num);
> >   int vhost_get_vq_desc(struct vhost_virtqueue *,
> >   		      struct iovec iov[], unsigned int iov_count,
> >   		      unsigned int *out_num, unsigned int *in_num,
> > @@ -261,6 +258,8 @@ static inline void vhost_vq_set_backend(struct vhost_virtqueue *vq,
> >   					void *private_data)
> >   {
> >   	vq->private_data = private_data;
> > +	vq->ndescs = 0;
> > +	vq->first_desc = 0;
> >   }
> >   /**

