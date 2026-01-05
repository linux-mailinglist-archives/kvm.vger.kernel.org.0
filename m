Return-Path: <kvm+bounces-67048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C8D3CF38FD
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 13:39:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0FE713023D1C
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 12:38:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE76230F545;
	Mon,  5 Jan 2026 12:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MhOlG5P0";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Eq9VP6sj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005662F4A19
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 12:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767616662; cv=none; b=ENMJa5J0KDnG8Cb7c+IDw1jlqH4aO5vgVOoyco5IhpCIVgQkP1vbjoiZmkTpfstkZTxKRaD48l8oNizRtTar7TF6jBqPxQxKmj4K2MKxexfGHSU/+mm8+uXSXyhwgRMpHjPth4ghoo2VjZ58k124bnlCjBhZFTGvb5AY1dYcwiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767616662; c=relaxed/simple;
	bh=wLc+K6BlGcNsSRvAX+itXhvo8Atf/pzYe91W0J7xGew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jzr5fMq+aMwKFE357FQoN1XHYZM9LKujlHaRVfpaEo/P+R6znBL+Dt5R+Q/+g99vngZQMwRy7/NqPF8fz6DorwIbbbZrUmVIcwLlnNd7r/cYVEINlv6b0qEryvpJFbdZQ9pIzdTnTdAkK20OdSjAPWGZht/Yrf3mxk729bwrZJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MhOlG5P0; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Eq9VP6sj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767616660;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v0XYhWIefjZGWouNSFIeJyo4tnXXaglCJukd6oVTUw8=;
	b=MhOlG5P0idq6Bzrv+lG8qxhdjt7GgNlImjWYzDBpggPW1ZZMRJfG88LkMQ4EFc0y3oQjaf
	ddi0CVVD9zlms2kq3LhuHMj1Ui+BcdpP77NK05HqjsCAwjZNaxYU59u7P23fqG17FdPKSL
	DLVUPKGwgjc1nPbgjQdZK86N/n2OFY8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-rnmZ6pyvOnm8SjKjOGGFAA-1; Mon, 05 Jan 2026 07:37:38 -0500
X-MC-Unique: rnmZ6pyvOnm8SjKjOGGFAA-1
X-Mimecast-MFC-AGG-ID: rnmZ6pyvOnm8SjKjOGGFAA_1767616657
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47d3c4468d8so48217625e9.2
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 04:37:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767616657; x=1768221457; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v0XYhWIefjZGWouNSFIeJyo4tnXXaglCJukd6oVTUw8=;
        b=Eq9VP6sjxuj4fpuGOHuc4AZBvfHXrpCCOnPIPzUujno9eG7uEynix2xsUwCFeYLEX2
         n4M0oaPhL31ZruKM6s4vKMiSNzS6rKwTJbX/iQmJYQbcHIEKwk4C2EiYrbQgPqMEFhuT
         /+Stu7UAv9UdB8EUdFcVQg+zkqWn1gKxrCaQuoj4IjtvV4AYRJQqR7O/vf+yoDOjZiKO
         lKBuBr6wFYLKJ7rudUdZUu8AZGbPLPG6rdlBUlHO7CYO9YmELzP+zYAEqbU0F66sbTOz
         uuqkHWVPe71/f++6ZyR6hNwSgIMm2alWZQwxH45jEnIe8cmJxZ0o5Id66WIu9hwwUvj3
         k6dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767616657; x=1768221457;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v0XYhWIefjZGWouNSFIeJyo4tnXXaglCJukd6oVTUw8=;
        b=vZrwysMR6LouhOI4odJ9j9kSLI0HChs0dlTc5OAG9AsDfKXIb+v2Ot8GKjJ5pNX5di
         /Z3arsqMkhTLHDj9UjUnSh/8ggen9DHQ3ZLBCQwYnzazlhAL+lhDhKJ6K48kLkb3sGjw
         T88KSJqVJTIJb3TiG7Ua502q1cYShohU4EkPEYHgU+B/bldqQqfb9/fPJOmXkfN0/3n9
         MePqD156khmI4mdmqGy0pJb4kDa5AeJ/c3MbF6nPGDK5FEPVbD6WWJtlfyALxlI1SO+a
         Fg1NaAdYkeXAysDpxuI1pc+Zf67rfE/SkaZvWpIiPHt3D8xFUK5Fr9Lfg1zmPtT2JBYh
         XZ1A==
X-Forwarded-Encrypted: i=1; AJvYcCUIYMXqS67uaHH+QZGY6ncnX1bIubVWtlqcm1lX+HZiqri6cnazJOzwk/1jPsvlMgiXQvE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzn5+t9cBMdflz4zt070MN6pGTkUvJYtfaUzs1DhR1LcEpTsxPv
	Ra+WGfF5Uu5SoA70LzA1nXzAUnh8Wuq85Hqawqbj+ztWzckVZjaoAveCbQoBV8QbLL3k1P/6i8m
	6u7REJUUDoiVFWUyimtfTZbbLbQooRIeif4g8sid7678BXnSq9wKMYQ==
X-Gm-Gg: AY/fxX5tqqd83hCMxjcocekUUerUc/umBq1rZgRPvCGPCxQcUW4bQoyZyLxZMZg4jNc
	NtmmC1tJPKRIMSSzNjED9ACt7Tx9J2yDo7r9fEyIkRrSZBqV3DW0xZeiCEUbOzaaASIK9s+bXTt
	iReQWYToJTEEMvz4Omcn2ruAeJjRPjeLl40RIkJZAr+0NhYE4F1LPjgdnBQ5sjxAcifCD3mjE4K
	X+LPQta+LFF8bX7MJCGhW8rXfjVwLzRe10GFq3SvbHyUJbEyPCRoxXhzYZKtIarSNho4DaWjXve
	YOOPexxyg2CoU7tXsNVlRw7WFHciuj8wAWoO/vRBJHKv7E5MiHfisO0ejRQgGXxgUTokvIriuqL
	kHbOpB7y+fQt0U77aS9iw1bzkEXxxLKY/UQ==
X-Received: by 2002:a05:600c:6388:b0:477:7b16:5f88 with SMTP id 5b1f17b1804b1-47d1953345cmr554873025e9.6.1767616657333;
        Mon, 05 Jan 2026 04:37:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG5CrfHKpTC4/iHV/NtFp0xVhQZAcSLZVRFoYkUoGChs4u9sh46HLHw+pax4aqs2/BHfMQ+jQ==
X-Received: by 2002:a05:600c:6388:b0:477:7b16:5f88 with SMTP id 5b1f17b1804b1-47d1953345cmr554872465e9.6.1767616656787;
        Mon, 05 Jan 2026 04:37:36 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4327791d2f3sm69930171f8f.11.2026.01.05.04.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 04:37:35 -0800 (PST)
Date: Mon, 5 Jan 2026 07:37:31 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Petr Tesarik <ptesarik@suse.com>
Cc: linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Bartosz Golaszewski <brgl@kernel.org>, linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org, virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 05/15] dma-debug: track cache clean flag in entries
Message-ID: <20260105073621-mutt-send-email-mst@kernel.org>
References: <cover.1767601130.git.mst@redhat.com>
 <0ffb3513d18614539c108b4548cdfbc64274a7d1.1767601130.git.mst@redhat.com>
 <20260105105433.5b875ce3@mordecai>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105105433.5b875ce3@mordecai>

On Mon, Jan 05, 2026 at 10:54:33AM +0100, Petr Tesarik wrote:
> On Mon, 5 Jan 2026 03:23:10 -0500
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > If a driver is buggy and has 2 overlapping mappings but only
> > sets cache clean flag on the 1st one of them, we warn.
> > But if it only does it for the 2nd one, we don't.
> > 
> > Fix by tracking cache clean flag in the entry.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  kernel/dma/debug.c | 27 ++++++++++++++++++++++-----
> >  1 file changed, 22 insertions(+), 5 deletions(-)
> > 
> > diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
> > index 7e66d863d573..43d6a996d7a7 100644
> > --- a/kernel/dma/debug.c
> > +++ b/kernel/dma/debug.c
> > @@ -63,6 +63,7 @@ enum map_err_types {
> >   * @sg_mapped_ents: 'mapped_ents' from dma_map_sg
> >   * @paddr: physical start address of the mapping
> >   * @map_err_type: track whether dma_mapping_error() was checked
> > + * @is_cache_clean: driver promises not to write to buffer while mapped
> >   * @stack_len: number of backtrace entries in @stack_entries
> >   * @stack_entries: stack of backtrace history
> >   */
> > @@ -76,7 +77,8 @@ struct dma_debug_entry {
> >  	int		 sg_call_ents;
> >  	int		 sg_mapped_ents;
> >  	phys_addr_t	 paddr;
> > -	enum map_err_types  map_err_type;
> > +	enum map_err_types map_err_type;
> 
> *nitpick* unnecessary change in white space (breaks git-blame).
> 
> Other than that, LGTM. I'm not formally a reviewer, but FWIW:
> 
> Reviewed-by: Petr Tesarik <ptesarik@suse.com>
> 
> Petr T


I mean, yes it's not really required here, but the padding we had before
was broken (two spaces not aligning to anything).

> > +	bool		 is_cache_clean;
> >  #ifdef CONFIG_STACKTRACE
> >  	unsigned int	stack_len;
> >  	unsigned long	stack_entries[DMA_DEBUG_STACKTRACE_ENTRIES];
> > @@ -472,12 +474,15 @@ static int active_cacheline_dec_overlap(phys_addr_t cln)
> >  	return active_cacheline_set_overlap(cln, --overlap);
> >  }
> >  
> > -static int active_cacheline_insert(struct dma_debug_entry *entry)
> > +static int active_cacheline_insert(struct dma_debug_entry *entry,
> > +				   bool *overlap_cache_clean)
> >  {
> >  	phys_addr_t cln = to_cacheline_number(entry);
> >  	unsigned long flags;
> >  	int rc;
> >  
> > +	*overlap_cache_clean = false;
> > +
> >  	/* If the device is not writing memory then we don't have any
> >  	 * concerns about the cpu consuming stale data.  This mitigates
> >  	 * legitimate usages of overlapping mappings.
> > @@ -487,8 +492,16 @@ static int active_cacheline_insert(struct dma_debug_entry *entry)
> >  
> >  	spin_lock_irqsave(&radix_lock, flags);
> >  	rc = radix_tree_insert(&dma_active_cacheline, cln, entry);
> > -	if (rc == -EEXIST)
> > +	if (rc == -EEXIST) {
> > +		struct dma_debug_entry *existing;
> > +
> >  		active_cacheline_inc_overlap(cln);
> > +		existing = radix_tree_lookup(&dma_active_cacheline, cln);
> > +		/* A lookup failure here after we got -EEXIST is unexpected. */
> > +		WARN_ON(!existing);
> > +		if (existing)
> > +			*overlap_cache_clean = existing->is_cache_clean;
> > +	}
> >  	spin_unlock_irqrestore(&radix_lock, flags);
> >  
> >  	return rc;
> > @@ -583,20 +596,24 @@ DEFINE_SHOW_ATTRIBUTE(dump);
> >   */
> >  static void add_dma_entry(struct dma_debug_entry *entry, unsigned long attrs)
> >  {
> > +	bool overlap_cache_clean;
> >  	struct hash_bucket *bucket;
> >  	unsigned long flags;
> >  	int rc;
> >  
> > +	entry->is_cache_clean = !!(attrs & DMA_ATTR_CPU_CACHE_CLEAN);
> > +
> >  	bucket = get_hash_bucket(entry, &flags);
> >  	hash_bucket_add(bucket, entry);
> >  	put_hash_bucket(bucket, flags);
> >  
> > -	rc = active_cacheline_insert(entry);
> > +	rc = active_cacheline_insert(entry, &overlap_cache_clean);
> >  	if (rc == -ENOMEM) {
> >  		pr_err_once("cacheline tracking ENOMEM, dma-debug disabled\n");
> >  		global_disable = true;
> >  	} else if (rc == -EEXIST &&
> > -		   !(attrs & (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_CPU_CACHE_CLEAN)) &&
> > +		   !(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
> > +		   !(entry->is_cache_clean && overlap_cache_clean) &&
> >  		   !(IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) &&
> >  		     is_swiotlb_active(entry->dev))) {
> >  		err_printk(entry->dev, entry,


