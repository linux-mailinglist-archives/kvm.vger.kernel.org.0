Return-Path: <kvm+bounces-44005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A560DA997D0
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 20:25:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 909EB1B846C5
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 18:25:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD65C28EA4A;
	Wed, 23 Apr 2025 18:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OpgQG9q8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D6028E5E5
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 18:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745432696; cv=none; b=DhWroRL42BMHh/i8E9zBRVCXvdV7rcCOwWXl7Uo+Ej0NWCv9b0+Px5IyB/AKfKzB6wfNUKyGIBJmAQizByv1FLj8DWaCdvdD+Rx4GnXgzH9BXhVilx64gQxNVLWPCk+9Gy38ftNuIW2DEzGET4Jg8dP/+4IXDRUI9FnYXhIsAag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745432696; c=relaxed/simple;
	bh=2kFipTkI9R4lAA/fVQ77ATu/54yZGXXZ2osRGeIHD58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BXoaFlPGHyo6Gs9X9ypjVkdbHKtXwTwrGJT5xRowSB1OWYRnnenkI3Lx7fR13kwo5SFaZ64rnSnZn/U18sGPvG7dY020X9tlgshpS22d43hZo26oVQdMd+TDMuRzaxySSW35PXHruLg6OTXKL7w6W60//HFd4HVuCjCYDwOP0YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OpgQG9q8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745432692;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xDiBetsqPmhwr4oXU09zlLKMEaFLxeBh720CI/G1T2w=;
	b=OpgQG9q8b0itO72TcgBEOSd6FzqLEEPc8YaBpjR9gAu0aDlRwBIlKPDMi3HN6qFaDcNkCq
	6fSRX7/OAXHYt9wfhtrReqlw9LFxmabPcowCS9HnghbChjDKKpBu//fz44JDEG6E0uzugt
	RT4J4uvcsQ4rMiatUB78zAiV6uVR5Lk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-139-t5bu37EEMJ2zOTxPvJQhag-1; Wed, 23 Apr 2025 14:24:50 -0400
X-MC-Unique: t5bu37EEMJ2zOTxPvJQhag-1
X-Mimecast-MFC-AGG-ID: t5bu37EEMJ2zOTxPvJQhag_1745432688
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43eea5a5d80so581575e9.1
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 11:24:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745432688; x=1746037488;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xDiBetsqPmhwr4oXU09zlLKMEaFLxeBh720CI/G1T2w=;
        b=C9lZMJqcLD9a2yD/F6T4x7p/SQL2oBudNDAwpyljbi3Wlk+dlHSvmrRJ8/egtifAuQ
         ftsrhdj/ImEqetYvwBNoWrTuAY2BYnOYzwXhvbfqIqkhNK6jGlSDUGf3jRL2UFuSOkw6
         EVVX3oIMHZvcInQc6fnNBEuG2GiEkwQYHno6qwH4052BnmfJRnV29LE6JGhiYEcO47Zv
         YYJhSSiSZeNPhbYlnwFX60FGf3wyGDlz7tRKqOwPpjFPfDI8nTaZVklpx4oYV4nOFJpL
         +9p7ja7kYm5o8JAanNSdAhp+5gF3OyApDRd5BNRmZqufbO3uyy2oqq06ezYfO113DwIq
         /OkA==
X-Forwarded-Encrypted: i=1; AJvYcCVYQ/701zZu3Youf7/rmtr/77EMKAxjWSMtxzaaCALk+GgHtbcy/hiDHeivfsCdF4c6IXY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzf+wTQJxmBmU5cLorI2XwWqIc2I7MUV5oJKHu0SjGlvxLwuWeL
	ZZumQ9CGFRsL0Xr9Pksi+LZ/Jis7k6JtFELSYCaz+gw7A8+grCh6iEY3KIpPrL6k8KLup/R00dq
	cepVcmEKCYKpfN/y3P7Q1Otvp6FonN/GCWcYkVnuaTUxOwy9JCA==
X-Gm-Gg: ASbGncv3YQ7cEmgqNBWJkKPWdIvlSfwMmoDutJSZF0oTfDdYcUaAaPKz8WVNX6MBpxU
	uQhSTcNaOYi7An2M4jh3CgE3mmCAx60L0bDSPR3fpLmpHWi6RrmPrvDpLE5xGbxJn22hzp8wtQA
	3TK+O7McN+dzYDOWNF4aEz97SkwKcJTAOHeCiBuNIbvGdwGYKZ4z+l6DNWLuVhHj4hlxVNPmiMG
	7M0YQPwMAz5GuOm+10UG/dUegJt8Rf8aScestoo+aKWP9Sac1x/N6uwBZUAmhEJgV1iMN3KL71f
	rXeHNg==
X-Received: by 2002:a05:600c:1d18:b0:43c:f3e4:d6f6 with SMTP id 5b1f17b1804b1-4406ac27928mr208905335e9.31.1745432688446;
        Wed, 23 Apr 2025 11:24:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGhMUybKS0xk+duePsY3EIBDyJlRwfswDnOg4sEpKMj9IfeNCbDaS3GP/dkavlx5C/2n4m6hA==
X-Received: by 2002:a05:600c:1d18:b0:43c:f3e4:d6f6 with SMTP id 5b1f17b1804b1-4406ac27928mr208905055e9.31.1745432687961;
        Wed, 23 Apr 2025 11:24:47 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa4931acsm19793032f8f.72.2025.04.23.11.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 11:24:47 -0700 (PDT)
Date: Wed, 23 Apr 2025 14:24:42 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Mina Almasry <almasrymina@google.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, io-uring@vger.kernel.org,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Donald Hunter <donald.hunter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Jeroen de Borst <jeroendb@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Neal Cardwell <ncardwell@google.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Shuah Khan <shuah@kernel.org>, sdf@fomichev.me, dw@davidwei.uk,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Kaiyuan Zhang <kaiyuanz@google.com>
Subject: Re: [PATCH net-next v10 4/9] net: devmem: Implement TX path
Message-ID: <20250423140931-mutt-send-email-mst@kernel.org>
References: <20250423031117.907681-1-almasrymina@google.com>
 <20250423031117.907681-5-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423031117.907681-5-almasrymina@google.com>

some nits

On Wed, Apr 23, 2025 at 03:11:11AM +0000, Mina Almasry wrote:
> @@ -189,43 +200,44 @@ net_devmem_bind_dmabuf(struct net_device *dev, unsigned int dmabuf_fd,
>  	}
>  
>  	binding->dev = dev;
> -
> -	err = xa_alloc_cyclic(&net_devmem_dmabuf_bindings, &binding->id,
> -			      binding, xa_limit_32b, &id_alloc_next,
> -			      GFP_KERNEL);
> -	if (err < 0)
> -		goto err_free_binding;
> -
>  	xa_init_flags(&binding->bound_rxqs, XA_FLAGS_ALLOC);
> -
>  	refcount_set(&binding->ref, 1);
> -
>  	binding->dmabuf = dmabuf;
>

given you keep iterating, don't tweak whitespace in the same patch-
will make the review a tiny bit easier.

  
>  	binding->attachment = dma_buf_attach(binding->dmabuf, dev->dev.parent);
>  	if (IS_ERR(binding->attachment)) {
>  		err = PTR_ERR(binding->attachment);
>  		NL_SET_ERR_MSG(extack, "Failed to bind dmabuf to device");
> -		goto err_free_id;
> +		goto err_free_binding;
>  	}
>  
>  	binding->sgt = dma_buf_map_attachment_unlocked(binding->attachment,
> -						       DMA_FROM_DEVICE);
> +						       direction);
>  	if (IS_ERR(binding->sgt)) {
>  		err = PTR_ERR(binding->sgt);
>  		NL_SET_ERR_MSG(extack, "Failed to map dmabuf attachment");
>  		goto err_detach;
>  	}
>  
> +	if (direction == DMA_TO_DEVICE) {
> +		binding->tx_vec = kvmalloc_array(dmabuf->size / PAGE_SIZE,
> +						 sizeof(struct net_iov *),
> +						 GFP_KERNEL);
> +		if (!binding->tx_vec) {
> +			err = -ENOMEM;
> +			goto err_unmap;
> +		}
> +	}
> +
>  	/* For simplicity we expect to make PAGE_SIZE allocations, but the
>  	 * binding can be much more flexible than that. We may be able to
>  	 * allocate MTU sized chunks here. Leave that for future work...
>  	 */
> -	binding->chunk_pool =
> -		gen_pool_create(PAGE_SHIFT, dev_to_node(&dev->dev));
> +	binding->chunk_pool = gen_pool_create(PAGE_SHIFT,
> +					      dev_to_node(&dev->dev));
>  	if (!binding->chunk_pool) {
>  		err = -ENOMEM;
> -		goto err_unmap;
> +		goto err_tx_vec;
>  	}
>  
>  	virtual = 0;
> @@ -270,24 +282,34 @@ net_devmem_bind_dmabuf(struct net_device *dev, unsigned int dmabuf_fd,
>  			niov->owner = &owner->area;
>  			page_pool_set_dma_addr_netmem(net_iov_to_netmem(niov),
>  						      net_devmem_get_dma_addr(niov));
> +			if (direction == DMA_TO_DEVICE)
> +				binding->tx_vec[owner->area.base_virtual / PAGE_SIZE + i] = niov;
>  		}
>  
>  		virtual += len;
>  	}
>  
> +	err = xa_alloc_cyclic(&net_devmem_dmabuf_bindings, &binding->id,
> +			      binding, xa_limit_32b, &id_alloc_next,
> +			      GFP_KERNEL);
> +	if (err < 0)
> +		goto err_free_id;
> +
>  	return binding;
>  
> +err_free_id:
> +	xa_erase(&net_devmem_dmabuf_bindings, binding->id);
>  err_free_chunks:
>  	gen_pool_for_each_chunk(binding->chunk_pool,
>  				net_devmem_dmabuf_free_chunk_owner, NULL);
>  	gen_pool_destroy(binding->chunk_pool);
> +err_tx_vec:
> +	kvfree(binding->tx_vec);
>  err_unmap:
>  	dma_buf_unmap_attachment_unlocked(binding->attachment, binding->sgt,
>  					  DMA_FROM_DEVICE);
>  err_detach:
>  	dma_buf_detach(dmabuf, binding->attachment);
> -err_free_id:
> -	xa_erase(&net_devmem_dmabuf_bindings, binding->id);
>  err_free_binding:
>  	kfree(binding);
>  err_put_dmabuf:
> @@ -295,6 +317,21 @@ net_devmem_bind_dmabuf(struct net_device *dev, unsigned int dmabuf_fd,
>  	return ERR_PTR(err);
>  }
>  
> +struct net_devmem_dmabuf_binding *net_devmem_lookup_dmabuf(u32 id)
> +{
> +	struct net_devmem_dmabuf_binding *binding;
> +
> +	rcu_read_lock();
> +	binding = xa_load(&net_devmem_dmabuf_bindings, id);
> +	if (binding) {
> +		if (!net_devmem_dmabuf_binding_get(binding))
> +			binding = NULL;
> +	}
> +	rcu_read_unlock();
> +
> +	return binding;
> +}
> +
>  void net_devmem_get_net_iov(struct net_iov *niov)
>  {
>  	net_devmem_dmabuf_binding_get(net_devmem_iov_binding(niov));
> @@ -305,6 +342,53 @@ void net_devmem_put_net_iov(struct net_iov *niov)
>  	net_devmem_dmabuf_binding_put(net_devmem_iov_binding(niov));
>  }
>  
> +struct net_devmem_dmabuf_binding *net_devmem_get_binding(struct sock *sk,
> +							 unsigned int dmabuf_id)
> +{
> +	struct net_devmem_dmabuf_binding *binding;
> +	struct dst_entry *dst = __sk_dst_get(sk);
> +	int err = 0;
> +
> +	binding = net_devmem_lookup_dmabuf(dmabuf_id);

why not initialize binding together with the declaration?

> +	if (!binding || !binding->tx_vec) {
> +		err = -EINVAL;
> +		goto out_err;
> +	}
> +
> +	/* The dma-addrs in this binding are only reachable to the corresponding
> +	 * net_device.
> +	 */
> +	if (!dst || !dst->dev || dst->dev->ifindex != binding->dev->ifindex) {
> +		err = -ENODEV;
> +		goto out_err;
> +	}
> +
> +	return binding;
> +
> +out_err:
> +	if (binding)
> +		net_devmem_dmabuf_binding_put(binding);
> +
> +	return ERR_PTR(err);
> +}
> +
> +struct net_iov *
> +net_devmem_get_niov_at(struct net_devmem_dmabuf_binding *binding,
> +		       size_t virt_addr, size_t *off, size_t *size)
> +{
> +	size_t idx;
> +
> +	if (virt_addr >= binding->dmabuf->size)
> +		return NULL;
> +
> +	idx = virt_addr / PAGE_SIZE;

init this at where it's declared?
or where it's used.


> +
> +	*off = virt_addr % PAGE_SIZE;
> +	*size = PAGE_SIZE - *off;



> +
> +	return binding->tx_vec[idx];
> +}
> +
>  /*** "Dmabuf devmem memory provider" ***/
>  
>  int mp_dmabuf_devmem_init(struct page_pool *pool)


-- 
MST


