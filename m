Return-Path: <kvm+bounces-31669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6224D9C6303
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 22:02:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E1FA71F23760
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 21:02:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35BA3219E3A;
	Tue, 12 Nov 2024 21:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gJT9L+T9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4E213FD99
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 21:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731445320; cv=none; b=tO4aYTW6kTO5YINmdtOlcX6fiEIKyeq5MAxY9awdU0Wg1f4RBTvf7Fejf/5/nkUatPIXw5MPDU5X2nGEs2JFhSVKJYuKpRA1bL1fbP8rwrvBMAkFu9rxdXaXKAgEiIjqxLwdSj3BOOQDFSTRy6juYpJFHy/scBB3opYLXYMO/sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731445320; c=relaxed/simple;
	bh=lE8+hKVXI3533LUYOTxuSIVIhh77vHJWphzhjamaQlk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bmv2lOI8kGFsQ6OGzk1jTW0yzq5nc1XXyWm8095ZUx/wB7XT9xI058BQCtWzU8EFDqmFUnJ/Wih13K+zBUed7yLvAumMkH4dBm2RRH9/7X3gvP9NfMpGjcia532x0eeq8JLisvEbq7c8yX5TGoqOAvY1S9xopv0WRg5fr/MyzeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gJT9L+T9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731445317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QdtsPtEgy/GqbYpllDqET8ibZDA5+N3hhfAC0l8hEiQ=;
	b=gJT9L+T9zXEGaSye+c9sxVIAbsXAG2W0d4BUQEfQnp831T5OvZfoDjupwvGHFaT8cg0pF/
	U6tv7Kzg3rkz/spaVDy4wYilIosQWwtr30bKFH+4Ho9ZUuze449g77NejCJnM++z5Ak5l8
	1ad4PrpVE9o20OjRUF2t6Mj32FlrcK8=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-557-QSKvgMWzOKWCeqnbw8mCZQ-1; Tue, 12 Nov 2024 16:01:56 -0500
X-MC-Unique: QSKvgMWzOKWCeqnbw8mCZQ-1
X-Mimecast-MFC-AGG-ID: QSKvgMWzOKWCeqnbw8mCZQ
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-718137f9eeaso161312a34.1
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 13:01:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731445315; x=1732050115;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QdtsPtEgy/GqbYpllDqET8ibZDA5+N3hhfAC0l8hEiQ=;
        b=AZN3Kc4XxZWp85SxreUqyps62tVhXBq0D5nLqCSlyY+4OU3GFb7JSf2FKOj28ri30u
         mU8PVHvUvH9LYylzmrUB278Rej4/rcBPot95eHukZE0BaS2NpC5SGOUzwlHyfIx4FcAr
         WNokMaHA1XwSk4N2nWX/ozRVX5OKBTJ8fqdcgU6ixlDPk95lLvgf8TyL0kiANAByHEq6
         TOwxidZq3QuNaaEdOXqdkaxA0cN4vBHAPJBaC5IyEeh4Hwh8o38u3KLORn/dgk5XJfhd
         QoNWku+qpTo3SjyUziQcWvwy8ySP443BOR/fgHYA6eylJ8ComxuyRq4zMdbf+uCW91a2
         E+vw==
X-Forwarded-Encrypted: i=1; AJvYcCXh8uj7kqyamFK+JCs5KePWJw5Wv2AZUB3cAPrqo+tCeU1UtGl7I2E5lyGuAgy0elR1TP0=@vger.kernel.org
X-Gm-Message-State: AOJu0YywMm7acoUVxRI7c4VHvdQIGsXzESmfNn58btAs0US7XHxD8WjE
	KVweGipcgttD/1qkRFzh2aakaLWLLjtTqW5zu9tLFSVGbC6EGQ4ycyL2lzOa40S2r+6opEBV0Tz
	WPTJ6M7wlL3UCjTcFGb6hxnyVbpHHqbWKhHFvg5IxXwIBwA6c2g==
X-Received: by 2002:a05:6830:6dc5:b0:718:83f7:9875 with SMTP id 46e09a7af769-71a1c1c73ebmr3765375a34.1.1731445315241;
        Tue, 12 Nov 2024 13:01:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFP6e69f0/gmTt/8CcCYYQyUpNYOQNiDkqnm2OdfCSY9FzVz9MST8wwnENJwdpKjXTonJjqTQ==
X-Received: by 2002:a05:6830:6dc5:b0:718:83f7:9875 with SMTP id 46e09a7af769-71a1c1c73ebmr3765370a34.1.1731445314909;
        Tue, 12 Nov 2024 13:01:54 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-71a5fe6381bsm69536a34.15.2024.11.12.13.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 13:01:54 -0800 (PST)
Date: Tue, 12 Nov 2024 14:01:51 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: <mst@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
 <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
 <parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
 <joao.m.martins@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V3 vfio 5/7] vfio/virtio: Add support for the basic live
 migration functionality
Message-ID: <20241112140151.3c03ff98.alex.williamson@redhat.com>
In-Reply-To: <20241112083729.145005-6-yishaih@nvidia.com>
References: <20241112083729.145005-1-yishaih@nvidia.com>
	<20241112083729.145005-6-yishaih@nvidia.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 12 Nov 2024 10:37:27 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:
> diff --git a/drivers/vfio/pci/virtio/migrate.c b/drivers/vfio/pci/virtio/migrate.c
> new file mode 100644
> index 000000000000..3d5eaa1cbcdb
> --- /dev/null
> +++ b/drivers/vfio/pci/virtio/migrate.c
...
> +static int virtiovf_add_migration_pages(struct virtiovf_data_buffer *buf,
> +					unsigned int npages)
> +{
> +	unsigned int to_alloc = npages;
> +	struct page **page_list;
> +	unsigned long filled;
> +	unsigned int to_fill;
> +	int ret;
> +
> +	to_fill = min_t(unsigned int, npages, PAGE_SIZE / sizeof(*page_list));
> +	page_list = kvzalloc(to_fill * sizeof(*page_list), GFP_KERNEL_ACCOUNT);
> +	if (!page_list)
> +		return -ENOMEM;
> +
> +	do {
> +		filled = alloc_pages_bulk_array(GFP_KERNEL_ACCOUNT, to_fill,
> +						page_list);
> +		if (!filled) {
> +			ret = -ENOMEM;
> +			goto err;
> +		}
> +		to_alloc -= filled;
> +		ret = sg_alloc_append_table_from_pages(&buf->table, page_list,
> +			filled, 0, filled << PAGE_SHIFT, UINT_MAX,
> +			SG_MAX_SINGLE_ALLOC, GFP_KERNEL_ACCOUNT);
> +
> +		if (ret)
> +			goto err;

Cleanup here has me a bit concerned.  I see this pattern in
mlx5vf_add_migration_pages() as well.  IIUC, if we hit the previous
ENOMEM condition we simply free page_list and return error because any
pages we've already added to the sg table will be freed in the next
function below.  But what happens here?  It looks like we've allocated
a bunch of pages, failed to added them to the sg table and we drop them
on the floor.  Am I wrong?

> +		buf->allocated_length += filled * PAGE_SIZE;
> +		/* clean input for another bulk allocation */
> +		memset(page_list, 0, filled * sizeof(*page_list));
> +		to_fill = min_t(unsigned int, to_alloc,
> +				PAGE_SIZE / sizeof(*page_list));
> +	} while (to_alloc > 0);
> +
> +	kvfree(page_list);
> +	return 0;
> +
> +err:
> +	kvfree(page_list);
> +	return ret;

If ret were initialized to zero it looks like we wouldn't need
duplicate code for the success path, but that might change if we need
more unwind for the above.  Thanks,

Alex

> +}
> +
> +static void virtiovf_free_data_buffer(struct virtiovf_data_buffer *buf)
> +{
> +	struct sg_page_iter sg_iter;
> +
> +	/* Undo alloc_pages_bulk_array() */
> +	for_each_sgtable_page(&buf->table.sgt, &sg_iter, 0)
> +		__free_page(sg_page_iter_page(&sg_iter));
> +	sg_free_append_table(&buf->table);
> +	kfree(buf);
> +}


