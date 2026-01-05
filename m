Return-Path: <kvm+bounces-67019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8327BCF2768
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 09:37:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DC359305222D
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 08:32:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B5D0314A94;
	Mon,  5 Jan 2026 08:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OkJ9m35O";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="VZcWQa1q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4575532471C
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 08:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601400; cv=none; b=qwvOiObXlzR56MFiDVffvG3GOzBOr5pLFITeAYgdzKY8A8x7dy6Rz6a9Be1zkNhEDrOUqHkbrKkDhBm31mqf1+FSfZnB+ltZYwc0jXmVnYiZaQSLt15uXz7+IXZG+/AIRN9/ldiCctknTFMWOcYuV9p5q99CCnwvqMRGEiFOkmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601400; c=relaxed/simple;
	bh=9iEzgPHvQMQc1JPQHZR4+0WH0pS0RVDvpJpTVteo84E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AUU38NbfGlRvBNZpt3Lpg80YqgnOjH7JbAAyCowpNfPA/x9iSQWfLvI0nr5iSIwA0Kr5EaI/10nMtN5hC5qv57WDWRxrPrSIN4gpBmpaFuc/6VItpfuyGVOuV61/gh9PFJgIMYQKmdG4h9sbquA9CLqx82hweKiCe69bkDAqMLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OkJ9m35O; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=VZcWQa1q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767601398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ceg01Cw9H4aJK1m/G33nz2CzBje4q7tNz5vOwZlPzjQ=;
	b=OkJ9m35OxyogYFe81sl3PtZ+rAxvLVS8Bj/sQwvCGn1yKxcIpEh2GHLFKUq0oda106zQ3i
	NevIe6tIPBMmAU8VArmEXiy9noLdP1uSsCsNQdRXs6CbbLoyPNgod4l2VSh/nC1YWwXqOW
	fySZXCEgl/RuGchr/o0Z5Xov5dGCa5E=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-169-fMjth6ktM4S_jEjkuEfD-g-1; Mon, 05 Jan 2026 03:23:15 -0500
X-MC-Unique: fMjth6ktM4S_jEjkuEfD-g-1
X-Mimecast-MFC-AGG-ID: fMjth6ktM4S_jEjkuEfD-g_1767601394
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-47a97b785bdso95837145e9.3
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 00:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767601394; x=1768206194; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ceg01Cw9H4aJK1m/G33nz2CzBje4q7tNz5vOwZlPzjQ=;
        b=VZcWQa1qe1Jsgfjpqig0asowpCApYa2eecngGEWLmC8TnpZr9mMiVTb0FNYSqZFbsc
         6YO7u39UlcI8nUODOltXH4XeMzmlo2hJcsGo+AxGNg+UUfoWJok0zK8atoP1LeAOTpn/
         XNUzOLQhTvYog47OacKq3ax8btPEDwfWVhzmQSRnwSGRno/Cvi98pkidMV0kJykd6R2h
         DwmlkMytnLHf2iWS7fv83jUjeo3EsOiHPpMAywJT6HBreDCJoWsLFTr1ryrCzK76E9PI
         gWquKjl8xaR5ZCBCzRKdYmxnbP+LIyrWgnDGNDy+eJIC1cI5slv16lHgOtEZMJnaFItj
         mC3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767601394; x=1768206194;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ceg01Cw9H4aJK1m/G33nz2CzBje4q7tNz5vOwZlPzjQ=;
        b=PK7F8LiTtbwszzxCV1fNv02LMSzPQvNtcx5zG2bvxJrD5zpY0JDwAgfzXjTXZHDiRT
         FRcRzTiZGSyqJ/9brOH8y+e3112fSFM7XR7cmMqZWjMBeA4OboKykhDnBjnLeCqedCZ5
         9Qi11gvefsVyw7A8RTHLsWR2WjAmbCuSKvEwgnu9OiELQvCqAriYBqSa0JAj7JL1ZHdM
         SmA68uZdTFt2kaYDT0Etuwe3hMGEtlQVvrDSTQqnU3z0dC7jKx33/wzBa1j7rofG2sGr
         t7EAwUwCasgebbLkO1eJVqLcWqOyVlo7iadgA9u4NLyQxVJSG7BKiqmFTcIzeXsILoD4
         V87A==
X-Forwarded-Encrypted: i=1; AJvYcCWHrTQYx5n0oZ3251AfigoDLXV3b8yMwRjqoVLk5HkRSmiIIO9QDSQsvr7L7dnmyh8lbzI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOeZ1ixl2S7ynuaqRryZEBPFZrv8IqY9ThVEEQm460iKdMuElT
	lW9zp+SLwsYx+BngNYHm9J6fOpxntv/TCatFqb7h+ibKD6DODM95pGNIuPYfEfu7/NuYWPScWX7
	SlV+oaEnQ6IswJpYnkZEy5EVsIosTm7OVJUFCJucpo0htV0N/x30mJw==
X-Gm-Gg: AY/fxX6vv6PL6K6aB1IvNJozo9cUnfiTokVIUmvyP42nf7WqsDUyYtiX5IU1Q4vpihL
	WE2p9Pver5NAWQ9Vas5Xms8MDrwwVaYT8jA++menH3Ai/a41Fb3XbqHV1Kxe/CzD0O5uSQ6jXjI
	ddgb12V5Zycj8T7bJ3g0J2ac7D7lHJnfJlMMrDKhJdLR9GvphwsrwXGvvKZyVMKdwRrSPoy9iP/
	q5C//EWI27D2+JynOfCLNAsFSM4GuxycyduqY+U/RAFM98twG24urXBVz0iWv5Gbk7PLRECRaHk
	e4EVgpJ1GvJsjlbHsIVnRS321/gCX+qoFoN0iJBZi/A1HYCNeGt+rY3vp25tTEAWdvR1DiSaXtr
	tRrEmWKaVcfIcUO7ep5YbqM+YwyZYBBX6Aw==
X-Received: by 2002:a05:600c:8710:b0:475:da13:2568 with SMTP id 5b1f17b1804b1-47d19592102mr548338235e9.25.1767601394173;
        Mon, 05 Jan 2026 00:23:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHQnvRLWDf0aCqCDaI87q/fN7cE8aCZoYxHw4jznq03tUl25BjWNTLdD3S8QBVZUoY2t9i3vg==
X-Received: by 2002:a05:600c:8710:b0:475:da13:2568 with SMTP id 5b1f17b1804b1-47d19592102mr548337795e9.25.1767601393663;
        Mon, 05 Jan 2026 00:23:13 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d6d13ed34sm142315025e9.2.2026.01.05.00.23.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 00:23:13 -0800 (PST)
Date: Mon, 5 Jan 2026 03:23:10 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Cong Wang <xiyou.wangcong@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
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
	Simon Horman <horms@kernel.org>, Petr Tesarik <ptesarik@suse.com>,
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Bartosz Golaszewski <brgl@kernel.org>, linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org, virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 05/15] dma-debug: track cache clean flag in entries
Message-ID: <0ffb3513d18614539c108b4548cdfbc64274a7d1.1767601130.git.mst@redhat.com>
References: <cover.1767601130.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1767601130.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

If a driver is buggy and has 2 overlapping mappings but only
sets cache clean flag on the 1st one of them, we warn.
But if it only does it for the 2nd one, we don't.

Fix by tracking cache clean flag in the entry.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 kernel/dma/debug.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index 7e66d863d573..43d6a996d7a7 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -63,6 +63,7 @@ enum map_err_types {
  * @sg_mapped_ents: 'mapped_ents' from dma_map_sg
  * @paddr: physical start address of the mapping
  * @map_err_type: track whether dma_mapping_error() was checked
+ * @is_cache_clean: driver promises not to write to buffer while mapped
  * @stack_len: number of backtrace entries in @stack_entries
  * @stack_entries: stack of backtrace history
  */
@@ -76,7 +77,8 @@ struct dma_debug_entry {
 	int		 sg_call_ents;
 	int		 sg_mapped_ents;
 	phys_addr_t	 paddr;
-	enum map_err_types  map_err_type;
+	enum map_err_types map_err_type;
+	bool		 is_cache_clean;
 #ifdef CONFIG_STACKTRACE
 	unsigned int	stack_len;
 	unsigned long	stack_entries[DMA_DEBUG_STACKTRACE_ENTRIES];
@@ -472,12 +474,15 @@ static int active_cacheline_dec_overlap(phys_addr_t cln)
 	return active_cacheline_set_overlap(cln, --overlap);
 }
 
-static int active_cacheline_insert(struct dma_debug_entry *entry)
+static int active_cacheline_insert(struct dma_debug_entry *entry,
+				   bool *overlap_cache_clean)
 {
 	phys_addr_t cln = to_cacheline_number(entry);
 	unsigned long flags;
 	int rc;
 
+	*overlap_cache_clean = false;
+
 	/* If the device is not writing memory then we don't have any
 	 * concerns about the cpu consuming stale data.  This mitigates
 	 * legitimate usages of overlapping mappings.
@@ -487,8 +492,16 @@ static int active_cacheline_insert(struct dma_debug_entry *entry)
 
 	spin_lock_irqsave(&radix_lock, flags);
 	rc = radix_tree_insert(&dma_active_cacheline, cln, entry);
-	if (rc == -EEXIST)
+	if (rc == -EEXIST) {
+		struct dma_debug_entry *existing;
+
 		active_cacheline_inc_overlap(cln);
+		existing = radix_tree_lookup(&dma_active_cacheline, cln);
+		/* A lookup failure here after we got -EEXIST is unexpected. */
+		WARN_ON(!existing);
+		if (existing)
+			*overlap_cache_clean = existing->is_cache_clean;
+	}
 	spin_unlock_irqrestore(&radix_lock, flags);
 
 	return rc;
@@ -583,20 +596,24 @@ DEFINE_SHOW_ATTRIBUTE(dump);
  */
 static void add_dma_entry(struct dma_debug_entry *entry, unsigned long attrs)
 {
+	bool overlap_cache_clean;
 	struct hash_bucket *bucket;
 	unsigned long flags;
 	int rc;
 
+	entry->is_cache_clean = !!(attrs & DMA_ATTR_CPU_CACHE_CLEAN);
+
 	bucket = get_hash_bucket(entry, &flags);
 	hash_bucket_add(bucket, entry);
 	put_hash_bucket(bucket, flags);
 
-	rc = active_cacheline_insert(entry);
+	rc = active_cacheline_insert(entry, &overlap_cache_clean);
 	if (rc == -ENOMEM) {
 		pr_err_once("cacheline tracking ENOMEM, dma-debug disabled\n");
 		global_disable = true;
 	} else if (rc == -EEXIST &&
-		   !(attrs & (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_CPU_CACHE_CLEAN)) &&
+		   !(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
+		   !(entry->is_cache_clean && overlap_cache_clean) &&
 		   !(IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) &&
 		     is_swiotlb_active(entry->dev))) {
 		err_printk(entry->dev, entry,
-- 
MST


