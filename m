Return-Path: <kvm+bounces-67041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 582A3CF2E18
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 10:59:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0D644304C2A6
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 09:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11CC7314A82;
	Mon,  5 Jan 2026 09:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ffEZM5wY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D746D2EDD76
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 09:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767606880; cv=none; b=M3ixpXnHvJhPI0iKkwy6ol2OHCUwEScjg+kSJvPAlLx4PjBc9NaJFqDjzmQsbd8CrbmMzcnVjDYT7B9oRDuEDPJjNjGkLwL5OJ/b1p1KX+LE+0r6S1M6aQ4JgTG/tfL/kY8hcEvR3+IqunjKwtwwZ+OG+8RHwQqqmuGbemy8/e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767606880; c=relaxed/simple;
	bh=wXFmNIC/qDvBQEFG+wgffuOhNELOXXRRjb7mFhAEKgs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t3hQl98zkHyRXStJW3dDAa9gt/HA/kKYdCTScxrmpAsdzf5amzTpdOqqKJQJIQbsi5kmuGtSMTe8CGaaca1vsQaSukb4ZkmfKTB0lIcpKmsHq+mp5UOVubenXRtJeWUkXHtyr7gOuZPXAWNMWlCSI0R7vAh+f71X/7su3J8XJsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ffEZM5wY; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47797676c62so13840515e9.1
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 01:54:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767606876; x=1768211676; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=krMWk6w/ET9jlziL1ByZGuECNStB5raCBd10vVl3Cwk=;
        b=ffEZM5wYjLowDrXA4xaSpIi2pFvBN4FE1EoCZo0Fec05RUVb4iUP3cGiukc0p1LJb+
         rIT9SOdwr9B+68xWURDNqb2/tc/1mV3PlKcJS+ELN84uJN7yfPGtZUGRHPAtVQspTae2
         P95JDGWra16XZDGDYS1t6xhng0CHo9sU6xE2urL/CfzoeDV+KKcSx4Nr76kEr4slxh1I
         ivn0b5CqSictH6wVcC2RDiepQfTdWu1DJ3m9a4PsnFKG5lMgnR5L6GZc6IwkL4xZi2Vt
         Hha2DO31zFOEsBJ93XtGdBnZbdovT7TtLHII/tiP39Elj2gfSaPocQILiff9rnSv0ZQv
         H7Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767606876; x=1768211676;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=krMWk6w/ET9jlziL1ByZGuECNStB5raCBd10vVl3Cwk=;
        b=b12ZoNDYjlRbRenaAaegd2MiYG5WNU8PwrnXen0bxBJBMzgTtnmokcCKs8tZV/k4Zt
         S7oILXmV1WQBmRCWys2Oykg3M2+k/aT1fB6iJaacU8m1agT82IiVqSmwpwSWEasjNln+
         98OApqyKfkW4a5VcaRj4oGym2KwedLWQRzPx3nb9Ko+mddjgl21Foecn1woSxqMYD6V/
         K8oqbQMFmJEx70yi4o9GHhpl3gEVmjZ3yhedsftUefw/I1ok1xbMaxmqkFAbx84GpeWE
         5vnYLKsGwcqPwShhsnc/5VKmoSQnTK1gKN2gjkYz3vXwzPb2+n0NZaKwNuPC8O3hFU6H
         RXMg==
X-Forwarded-Encrypted: i=1; AJvYcCUwheKHM3kl7wQT/45vXDZilwsHWeqqUypWdfYYDYLeBv+3sJwaPYjMKDgPUXi9psWrCpU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvUs4t6dhIc2uCTYV3U0PRVainlzN9z89bbwESBRMWL9UN+vTU
	NRFjWOA8locO7v12effQs/Cg00zsAoLp65d6MGrjzVF/3HDoM/EviUiKQBIdvZ81Hpg=
X-Gm-Gg: AY/fxX6xA4MpLXzzsHq2itSzGd6a1qTOvJyAgOxDvL+cNZDHkRdcfQO3K51TSbMNI52
	stGKMGRaglA3aNMdBVdSr7gC3V7ktGmi9k19/mmziIcbWbCGyjtrms9dIU2ykmTBzkSay5tgFK1
	9mcjn88VCMUtMk661PkQag9LvvCxVMiq8jwYPndSgUtnHcPG+nCz4rUT8pMnWdLWf0I8Hos+Jy8
	MV2WCTPHQ7TyG4UP9WJ5hYXGHPEuU0V+4SNsuEphAVsmKxdFAH8N4Sa1n8hexg77C+JLWIDl8fa
	pZPIcw6CPpJtPUWWL3ifumAdE2ZZepfAEp3GEXnwjp4Rf+lilF3fpaBXaaSh6/0sg0TKJTg3ca4
	ZSzYBzofgrSI82VulR1lkVSmMA5t5KcnnYipacWM0eGc9woDpTwC5QHwvVdSK8lg1RdKRArrV2v
	uB/e3mSR/1iItCn+AC5h2jksNio/cm+yPe4sJSLY8k+ihIkEByaEaytuJpe6Y+RqtMKi7upPFnQ
	R4q
X-Google-Smtp-Source: AGHT+IHQlDd3ApAqySAKrzOJImjG5fh/mxoydDR5ocBXIPbbqS40zRTIMIivPVO9L9JjpTgyuVG6FQ==
X-Received: by 2002:a05:600c:4447:b0:46f:ab96:58e9 with SMTP id 5b1f17b1804b1-47d194c27femr344501805e9.0.1767606876178;
        Mon, 05 Jan 2026 01:54:36 -0800 (PST)
Received: from mordecai (dynamic-2a00-1028-83b8-1e7a-3010-3bd6-8521-caf1.ipv6.o2.cz. [2a00:1028:83b8:1e7a:3010:3bd6:8521:caf1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d6d452be4sm144233885e9.10.2026.01.05.01.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 01:54:35 -0800 (PST)
Date: Mon, 5 Jan 2026 10:54:33 +0100
From: Petr Tesarik <ptesarik@suse.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Jason Wang <jasowang@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 Eugenio =?UTF-8?B?UMOpcmV6?= <eperezma@redhat.com>, "James E.J. Bottomley"
 <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Gerd Hoffmann <kraxel@redhat.com>, Xuan Zhuo
 <xuanzhuo@linux.alibaba.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Stefano Garzarella
 <sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Leon Romanovsky
 <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Bartosz Golaszewski
 <brgl@kernel.org>, linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org,
 virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
 iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 05/15] dma-debug: track cache clean flag in entries
Message-ID: <20260105105433.5b875ce3@mordecai>
In-Reply-To: <0ffb3513d18614539c108b4548cdfbc64274a7d1.1767601130.git.mst@redhat.com>
References: <cover.1767601130.git.mst@redhat.com>
	<0ffb3513d18614539c108b4548cdfbc64274a7d1.1767601130.git.mst@redhat.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 5 Jan 2026 03:23:10 -0500
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> If a driver is buggy and has 2 overlapping mappings but only
> sets cache clean flag on the 1st one of them, we warn.
> But if it only does it for the 2nd one, we don't.
> 
> Fix by tracking cache clean flag in the entry.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  kernel/dma/debug.c | 27 ++++++++++++++++++++++-----
>  1 file changed, 22 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
> index 7e66d863d573..43d6a996d7a7 100644
> --- a/kernel/dma/debug.c
> +++ b/kernel/dma/debug.c
> @@ -63,6 +63,7 @@ enum map_err_types {
>   * @sg_mapped_ents: 'mapped_ents' from dma_map_sg
>   * @paddr: physical start address of the mapping
>   * @map_err_type: track whether dma_mapping_error() was checked
> + * @is_cache_clean: driver promises not to write to buffer while mapped
>   * @stack_len: number of backtrace entries in @stack_entries
>   * @stack_entries: stack of backtrace history
>   */
> @@ -76,7 +77,8 @@ struct dma_debug_entry {
>  	int		 sg_call_ents;
>  	int		 sg_mapped_ents;
>  	phys_addr_t	 paddr;
> -	enum map_err_types  map_err_type;
> +	enum map_err_types map_err_type;

*nitpick* unnecessary change in white space (breaks git-blame).

Other than that, LGTM. I'm not formally a reviewer, but FWIW:

Reviewed-by: Petr Tesarik <ptesarik@suse.com>

Petr T

> +	bool		 is_cache_clean;
>  #ifdef CONFIG_STACKTRACE
>  	unsigned int	stack_len;
>  	unsigned long	stack_entries[DMA_DEBUG_STACKTRACE_ENTRIES];
> @@ -472,12 +474,15 @@ static int active_cacheline_dec_overlap(phys_addr_t cln)
>  	return active_cacheline_set_overlap(cln, --overlap);
>  }
>  
> -static int active_cacheline_insert(struct dma_debug_entry *entry)
> +static int active_cacheline_insert(struct dma_debug_entry *entry,
> +				   bool *overlap_cache_clean)
>  {
>  	phys_addr_t cln = to_cacheline_number(entry);
>  	unsigned long flags;
>  	int rc;
>  
> +	*overlap_cache_clean = false;
> +
>  	/* If the device is not writing memory then we don't have any
>  	 * concerns about the cpu consuming stale data.  This mitigates
>  	 * legitimate usages of overlapping mappings.
> @@ -487,8 +492,16 @@ static int active_cacheline_insert(struct dma_debug_entry *entry)
>  
>  	spin_lock_irqsave(&radix_lock, flags);
>  	rc = radix_tree_insert(&dma_active_cacheline, cln, entry);
> -	if (rc == -EEXIST)
> +	if (rc == -EEXIST) {
> +		struct dma_debug_entry *existing;
> +
>  		active_cacheline_inc_overlap(cln);
> +		existing = radix_tree_lookup(&dma_active_cacheline, cln);
> +		/* A lookup failure here after we got -EEXIST is unexpected. */
> +		WARN_ON(!existing);
> +		if (existing)
> +			*overlap_cache_clean = existing->is_cache_clean;
> +	}
>  	spin_unlock_irqrestore(&radix_lock, flags);
>  
>  	return rc;
> @@ -583,20 +596,24 @@ DEFINE_SHOW_ATTRIBUTE(dump);
>   */
>  static void add_dma_entry(struct dma_debug_entry *entry, unsigned long attrs)
>  {
> +	bool overlap_cache_clean;
>  	struct hash_bucket *bucket;
>  	unsigned long flags;
>  	int rc;
>  
> +	entry->is_cache_clean = !!(attrs & DMA_ATTR_CPU_CACHE_CLEAN);
> +
>  	bucket = get_hash_bucket(entry, &flags);
>  	hash_bucket_add(bucket, entry);
>  	put_hash_bucket(bucket, flags);
>  
> -	rc = active_cacheline_insert(entry);
> +	rc = active_cacheline_insert(entry, &overlap_cache_clean);
>  	if (rc == -ENOMEM) {
>  		pr_err_once("cacheline tracking ENOMEM, dma-debug disabled\n");
>  		global_disable = true;
>  	} else if (rc == -EEXIST &&
> -		   !(attrs & (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_CPU_CACHE_CLEAN)) &&
> +		   !(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
> +		   !(entry->is_cache_clean && overlap_cache_clean) &&
>  		   !(IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) &&
>  		     is_swiotlb_active(entry->dev))) {
>  		err_printk(entry->dev, entry,


