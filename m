Return-Path: <kvm+bounces-67050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F11FCF3E57
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 14:44:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0C4B6307E966
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 13:40:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D42FF34164B;
	Mon,  5 Jan 2026 13:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="evTaGoQ9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEA4341050
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 13:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767620438; cv=none; b=JEsaRIu/9sKRhnxSgMSm4VRIEW8CTdUPBUwM2eRaaY8rcKxSaPkgnl0RnTkMc0K0G4Ewep0mwyrJydgkS9uYGZumLdF3fXR3PaO50OL55oAMjLn2nbYSR3EhZv9GB66UaRTHYdJ2AKSR41YpfEXYcEiBKVDJFg+ZEW4sb+5ctv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767620438; c=relaxed/simple;
	bh=x4FbGO9rb3oDBd7srLGxGoyKvyyHdSRpv19OZNd+OHs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Is1Ym7xXUCMdrWEXKEcvjjsXtHA/GRK0kv35ayHrbTxtIg0UPKdR6P7U2qRdnYN4YX2vaGvP+R+MHY06rCPZfW4g6z+dPRU6rPqsZFHI1ZIViA+o7hqebf6fkKBXYwSOj3kBOGys6Wgyv5CnoSsCaXBu4ojFIOQpZloLlkjjL8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=evTaGoQ9; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4779d8286d8so10634695e9.0
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 05:40:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767620435; x=1768225235; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f1KqtsDg02Q4tg0OrM0LKqtAMxJWRmTEsyj+AQ7lEeQ=;
        b=evTaGoQ9l965cOyOTnh5VeYas0tCw9526mqa7n8ccT6uk26o1WsIjbUtdKQbDGbx4d
         G2GkqZOAzx3cG8kDJBRARj1WHAcZp8JBG6V2+xoKtykO4SQSvnFxlQdkrRGYiPmjojNe
         IdwH0iXrrYMhGOenSzOtBl69bfNzL4tIb/SQ1uszrJUVD4UZBKvBq7VjOkxVT86eauBU
         fu3Rs0ay8tUh2p57vfgbGKbnK/vsXvASvojK4Kd7UM7Z3+BcDXgn5VILNDkNGCnCHFYk
         jsL3Dpvs/yOtHsxPsOy2suz8e6pLKLJm8DEMC/vfNW05+rfyc9ywYYRerKXn/pw9sK+K
         8gjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767620435; x=1768225235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f1KqtsDg02Q4tg0OrM0LKqtAMxJWRmTEsyj+AQ7lEeQ=;
        b=sGzezTbEAkErVq7doJPXsunH8iXeuj8JuXVdnTRbUSqA9AHeSLbNI33X674PR7ShZ6
         GQLxlT2rLWzbCXq0tnTtiIs1L4CyYuWNiKwJ5Nt2WgLWx2PMhzeI9JXuZ7DySuWwIHJ6
         NoJ1MYDzOhe6kwTl6aus/v8i1+DPXDMTsPOsWfIIRbUMCloNcYRHvQb2TRzxUBtgm++k
         IKoOdPqOEawf0kyp/E3T2FHWwJayHArrhwqS4xyItWpI0sCLErw6wSZ2DpWp1dsafCcV
         o48adKpIIWG/ZOw9zfR+cehFgedrDMNXvfo8IMJ6mpmLZa8tx+qnPAfjug8g+vR3Qj+1
         +UGA==
X-Forwarded-Encrypted: i=1; AJvYcCW3VupnurVLvx47lfEecLaTbHLvHB6LmbRt8+fKBwxvDibNfk4oQ/EMj+8w3Qh5dYtIQPQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQAVrFuCsZpcqgkeotXyFINpxOZgrPwoHmEA2koXNIYu06cKXB
	7/APfRY07fOSL6n/z0O2TspvXBWIMOOMdqjgDgqwK/noUmdkNzcpMf4o6HkB4QQr4yc=
X-Gm-Gg: AY/fxX7DAcG7zSoDCm6G35JUJP0np0NfTu7j8G90/9qRwRg5g0esn+kA7UdesPda+S2
	gUKEBJyH00zwLZu7IX/y4euiJYvm5z1CG1XwvjIQnBAJHyb1fnQf/w5LnqVPdOIXA25BxQo6g+E
	baFaa0sqCdZX499YtaCNVT9OpTtUaQyl9GkN5V0A666HGGksX6P1xDzTZvt4UE8WwoTMFeIexum
	93DKHEGyBdUkowaWW38qfdkhI5Z8a7/aUFJ9Mpn/CuCOzSwDTtcAgkNnvGTDEOj7960T1rUlZ6C
	aQ73HgaLoQ2G4zSRq+qrNUsceyn0knZ0Hpm20menO/UapQjs5D32FS6zWHwuVq+6g6OnKO8b2Dp
	5s5BsqHcKCLmDiKZhBjaT7Qr9PoU1AIphx57gJ+6bsN+hv/hGcPFQuKta+qYWxm5M/UEBw0xuKb
	pt7p4X7RX5lViC+7QdiDfYdJhz8q6bBdYwh66q1qF+D+kLJVIKTcafSoqV+qydfM6K+BEOaWdXy
	+A/
X-Google-Smtp-Source: AGHT+IFwXSkFSnAzDpXmvBfpaag5Ig2x/hY7lR/fPaiKG8l/aTMnGjVbJNKYUdmZgkyBxJqwrNsd/A==
X-Received: by 2002:a05:600c:4ed2:b0:477:9c9e:ec7e with SMTP id 5b1f17b1804b1-47d19597517mr371677315e9.6.1767620434763;
        Mon, 05 Jan 2026 05:40:34 -0800 (PST)
Received: from mordecai (dynamic-2a00-1028-83b8-1e7a-3010-3bd6-8521-caf1.ipv6.o2.cz. [2a00:1028:83b8:1e7a:3010:3bd6:8521:caf1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d6be2ce32sm61878015e9.2.2026.01.05.05.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 05:40:34 -0800 (PST)
Date: Mon, 5 Jan 2026 14:40:31 +0100
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
Message-ID: <20260105144031.2520c81b@mordecai>
In-Reply-To: <20260105073621-mutt-send-email-mst@kernel.org>
References: <cover.1767601130.git.mst@redhat.com>
	<0ffb3513d18614539c108b4548cdfbc64274a7d1.1767601130.git.mst@redhat.com>
	<20260105105433.5b875ce3@mordecai>
	<20260105073621-mutt-send-email-mst@kernel.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 5 Jan 2026 07:37:31 -0500
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Mon, Jan 05, 2026 at 10:54:33AM +0100, Petr Tesarik wrote:
> > On Mon, 5 Jan 2026 03:23:10 -0500
> > "Michael S. Tsirkin" <mst@redhat.com> wrote:
> >   
> > > If a driver is buggy and has 2 overlapping mappings but only
> > > sets cache clean flag on the 1st one of them, we warn.
> > > But if it only does it for the 2nd one, we don't.
> > > 
> > > Fix by tracking cache clean flag in the entry.
> > > 
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > ---
> > >  kernel/dma/debug.c | 27 ++++++++++++++++++++++-----
> > >  1 file changed, 22 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
> > > index 7e66d863d573..43d6a996d7a7 100644
> > > --- a/kernel/dma/debug.c
> > > +++ b/kernel/dma/debug.c
> > > @@ -63,6 +63,7 @@ enum map_err_types {
> > >   * @sg_mapped_ents: 'mapped_ents' from dma_map_sg
> > >   * @paddr: physical start address of the mapping
> > >   * @map_err_type: track whether dma_mapping_error() was checked
> > > + * @is_cache_clean: driver promises not to write to buffer while mapped
> > >   * @stack_len: number of backtrace entries in @stack_entries
> > >   * @stack_entries: stack of backtrace history
> > >   */
> > > @@ -76,7 +77,8 @@ struct dma_debug_entry {
> > >  	int		 sg_call_ents;
> > >  	int		 sg_mapped_ents;
> > >  	phys_addr_t	 paddr;
> > > -	enum map_err_types  map_err_type;
> > > +	enum map_err_types map_err_type;  
> > 
> > *nitpick* unnecessary change in white space (breaks git-blame).
> > 
> > Other than that, LGTM. I'm not formally a reviewer, but FWIW:
> > 
> > Reviewed-by: Petr Tesarik <ptesarik@suse.com>
> > 
> > Petr T  
> 
> 
> I mean, yes it's not really required here, but the padding we had before
> was broken (two spaces not aligning to anything).

Oh, you're right! Yes, then let's fix it now, because you touch the
neighbouring line.

Sorry for the noise.

Petr T

> > > +	bool		 is_cache_clean;
> > >  #ifdef CONFIG_STACKTRACE
> > >  	unsigned int	stack_len;
> > >  	unsigned long	stack_entries[DMA_DEBUG_STACKTRACE_ENTRIES];
> > > @@ -472,12 +474,15 @@ static int active_cacheline_dec_overlap(phys_addr_t cln)
> > >  	return active_cacheline_set_overlap(cln, --overlap);
> > >  }
> > >  
> > > -static int active_cacheline_insert(struct dma_debug_entry *entry)
> > > +static int active_cacheline_insert(struct dma_debug_entry *entry,
> > > +				   bool *overlap_cache_clean)
> > >  {
> > >  	phys_addr_t cln = to_cacheline_number(entry);
> > >  	unsigned long flags;
> > >  	int rc;
> > >  
> > > +	*overlap_cache_clean = false;
> > > +
> > >  	/* If the device is not writing memory then we don't have any
> > >  	 * concerns about the cpu consuming stale data.  This mitigates
> > >  	 * legitimate usages of overlapping mappings.
> > > @@ -487,8 +492,16 @@ static int active_cacheline_insert(struct dma_debug_entry *entry)
> > >  
> > >  	spin_lock_irqsave(&radix_lock, flags);
> > >  	rc = radix_tree_insert(&dma_active_cacheline, cln, entry);
> > > -	if (rc == -EEXIST)
> > > +	if (rc == -EEXIST) {
> > > +		struct dma_debug_entry *existing;
> > > +
> > >  		active_cacheline_inc_overlap(cln);
> > > +		existing = radix_tree_lookup(&dma_active_cacheline, cln);
> > > +		/* A lookup failure here after we got -EEXIST is unexpected. */
> > > +		WARN_ON(!existing);
> > > +		if (existing)
> > > +			*overlap_cache_clean = existing->is_cache_clean;
> > > +	}
> > >  	spin_unlock_irqrestore(&radix_lock, flags);
> > >  
> > >  	return rc;
> > > @@ -583,20 +596,24 @@ DEFINE_SHOW_ATTRIBUTE(dump);
> > >   */
> > >  static void add_dma_entry(struct dma_debug_entry *entry, unsigned long attrs)
> > >  {
> > > +	bool overlap_cache_clean;
> > >  	struct hash_bucket *bucket;
> > >  	unsigned long flags;
> > >  	int rc;
> > >  
> > > +	entry->is_cache_clean = !!(attrs & DMA_ATTR_CPU_CACHE_CLEAN);
> > > +
> > >  	bucket = get_hash_bucket(entry, &flags);
> > >  	hash_bucket_add(bucket, entry);
> > >  	put_hash_bucket(bucket, flags);
> > >  
> > > -	rc = active_cacheline_insert(entry);
> > > +	rc = active_cacheline_insert(entry, &overlap_cache_clean);
> > >  	if (rc == -ENOMEM) {
> > >  		pr_err_once("cacheline tracking ENOMEM, dma-debug disabled\n");
> > >  		global_disable = true;
> > >  	} else if (rc == -EEXIST &&
> > > -		   !(attrs & (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_CPU_CACHE_CLEAN)) &&
> > > +		   !(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
> > > +		   !(entry->is_cache_clean && overlap_cache_clean) &&
> > >  		   !(IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) &&
> > >  		     is_swiotlb_active(entry->dev))) {
> > >  		err_printk(entry->dev, entry,  
> 


