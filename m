Return-Path: <kvm+bounces-12900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 98ACE88EF8E
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 20:52:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53E0C29EC52
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 19:52:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1CE3152517;
	Wed, 27 Mar 2024 19:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KASVTbbY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6B5152526;
	Wed, 27 Mar 2024 19:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711569128; cv=none; b=Q5+Fu07WB9YTrHz0Xt6tu6ETQG0PFpaphRDhxZVM3iUSfiBzr9xmAW/E1X604X6DMpqgDVfeS58l9x9Qt/7gGJIe+B/64IUzoRm4jtsuy3s5iMLu8hnx6y8WP6nk1fsumcUsLhaqJKFhuLakFMrEXR2/hJ5wbel0Uz1+lt8VJHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711569128; c=relaxed/simple;
	bh=NW/plT/lkw+bj9qL/voWkJkmE88rQnUU6wEQcKQY0HE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eONAc9XS9I9MxjP71jwuJ3hgo8ZWiJzf0Zz7bLDW1Wu+MBxeXKFJAo+tKESFcygYSZ7CbndqkSa7uCVSOlGI3lekEpqk8bocna9U+pPxIZjEWWH63xvoeR/VGHCSHKuuVVAhiIjSFyCe59qPio3NEacgnIaN9GUvWpvQ6xrmJWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KASVTbbY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235A0C433C7;
	Wed, 27 Mar 2024 19:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711569128;
	bh=NW/plT/lkw+bj9qL/voWkJkmE88rQnUU6wEQcKQY0HE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KASVTbbYdrxm95eqZVmCFpnLknJBDKYPdDamEQvTLthvPNOmRTdm47trn8eYWdN/T
	 brLftUfBJD4RKutIOC2d2WZN52a33/sMjKZW56z9vj+U8CV/nhi0bHaDOk3RBCU7oa
	 WzK2VOtcZ9sU2NPwoHINwlSOB94oflPngQS6nDfeF7iahMDXOFs2q/Loy66rDVcJoj
	 ylq2GULbNPQnko8sVJwURfcalqYZ/PK8FSqT3Pld5CTvT4CKC96k0c4FU7IY3BGXyY
	 xrbwHV+YPtuFxNvvJJWp/PFaQTVfQhVOubC+JPmOW0hjpxfRrPkwP/i1FMaSE+bXQZ
	 BuJI+CL8aoJBw==
Date: Wed, 27 Mar 2024 19:52:02 +0000
From: Will Deacon <will@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Gavin Shan <gshan@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"David S. Miller" <davem@davemloft.net>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [PATCH untested] vhost: order avail ring reads after index
 updates
Message-ID: <20240327195202.GB12000@willie-the-truck>
References: <f7be6f4ed4bc5405e9a6b848e5ac3dd1f9955c2a.1711560268.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7be6f4ed4bc5405e9a6b848e5ac3dd1f9955c2a.1711560268.git.mst@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Mar 27, 2024 at 01:26:23PM -0400, Michael S. Tsirkin wrote:
> vhost_get_vq_desc (correctly) uses smp_rmb to order
> avail ring reads after index reads.
> However, over time we added two more places that read the
> index and do not bother with barriers.
> Since vhost_get_vq_desc when it was written assumed it is the
> only reader when it sees a new index value is cached
> it does not bother with a barrier either, as a result,
> on the nvidia-gracehopper platform (arm64) available ring
> entry reads have been observed bypassing ring reads, causing
> a ring corruption.
> 
> To fix, factor out the correct index access code from vhost_get_vq_desc.
> As a side benefit, we also validate the index on all paths now, which
> will hopefully help catch future errors earlier.
> 
> Note: current code is inconsistent in how it handles errors:
> some places treat it as an empty ring, others - non empty.
> This patch does not attempt to change the existing behaviour.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Gavin Shan <gshan@redhat.com>
> Reported-by: Will Deacon <will@kernel.org>
> Suggested-by: Will Deacon <will@kernel.org>
> Fixes: 275bf960ac69 ("vhost: better detection of available buffers")
> Cc: "Jason Wang" <jasowang@redhat.com>
> Fixes: d3bb267bbdcb ("vhost: cache avail index in vhost_enable_notify()")
> Cc: "Stefano Garzarella" <sgarzare@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> I think it's better to bite the bullet and clean up the code.
> Note: this is still only built, not tested.
> Gavin could you help test please?
> Especially on the arm platform you have?
> 
> Will thanks so much for finding this race!

No problem, and I was also hoping that the smp_rmb() could be
consolidated into a single helper like you've done here.

One minor comment below:

>  drivers/vhost/vhost.c | 80 +++++++++++++++++++++++--------------------
>  1 file changed, 42 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 045f666b4f12..26b70b1fd9ff 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -1290,10 +1290,38 @@ static void vhost_dev_unlock_vqs(struct vhost_dev *d)
>  		mutex_unlock(&d->vqs[i]->mutex);
>  }
>  
> -static inline int vhost_get_avail_idx(struct vhost_virtqueue *vq,
> -				      __virtio16 *idx)
> +static inline int vhost_get_avail_idx(struct vhost_virtqueue *vq)
>  {
> -	return vhost_get_avail(vq, *idx, &vq->avail->idx);
> +	__virtio16 idx;
> +	u16 avail_idx;
> +	int r = vhost_get_avail(vq, idx, &vq->avail->idx);
> +
> +	if (unlikely(r < 0)) {
> +		vq_err(vq, "Failed to access avail idx at %p: %d\n",
> +		       &vq->avail->idx, r);
> +		return -EFAULT;
> +	}
> +
> +	avail_idx = vhost16_to_cpu(vq, idx);
> +
> +	/* Check it isn't doing very strange things with descriptor numbers. */
> +	if (unlikely((u16)(avail_idx - vq->last_avail_idx) > vq->num)) {
> +		vq_err(vq, "Guest moved used index from %u to %u",
> +		       vq->last_avail_idx, vq->avail_idx);
> +		return -EFAULT;
> +	}
> +
> +	/* Nothing new? We are done. */
> +	if (avail_idx == vq->avail_idx)
> +		return 0;
> +
> +	vq->avail_idx = avail_idx;
> +
> +	/* We updated vq->avail_idx so we need a memory barrier between
> +	 * the index read above and the caller reading avail ring entries.
> +	 */
> +	smp_rmb();

I think you could use smp_acquire__after_ctrl_dep() if you're feeling
brave, but to be honest I'd prefer we went in the opposite direction
and used READ/WRITE_ONCE + smp_load_acquire()/smp_store_release() across
the board. It's just a thankless, error-prone task to get there :(

So, for the patch as-is:

Acked-by: Will Deacon <will@kernel.org>

(I've not tested it either though, so definitely wait for Gavin on that!)

Cheers,

Will

