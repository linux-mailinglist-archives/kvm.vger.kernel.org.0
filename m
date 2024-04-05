Return-Path: <kvm+bounces-13632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04B218993E2
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 05:30:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 359421C21F47
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 03:30:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 344731C6A8;
	Fri,  5 Apr 2024 03:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c4PKRUYm"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA53171BB;
	Fri,  5 Apr 2024 03:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712287812; cv=none; b=atbz/TL8B/21hKxX+ihqYaB10NKMvHaMoSZRa2XdFuhjdFFQYnmqQdkRQPORQlIE602ymXtq52SrC2qjtfzL8PwMhF8eSEbNcFf+Wiq17VDoHyhDoiZDQxzTWlCIf5FdHoMY8gmbADPCEqc/8BGgj5xdBmmm7H1p31IMI+80yAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712287812; c=relaxed/simple;
	bh=9S5aVYYlu5b0KrEcvJvCPbhRHx5GpSovTdOY1LLeUPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GOQo4Yr3tsR7ZIJJnswzYaNt/66BqC02woqxDzIfONILY5YgvdICjrkXKoe3tRL1KUgodw9XCjf1YMb6693RPhi4OAzqOZhbA5yggFUZUOfYMKRHQ+HT/N1w3rykyUv1diX1FWSpO3fZYPP/oMEMLgoT+XEY/CbzcoRSm+XRE3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=c4PKRUYm; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nYBlmZvCfxDiPXzoD2BqbqURGZdXD7THNfKAAFvn1H8=; b=c4PKRUYm0vWrldtHRDUvi96coi
	TUywfXMyhbUrd8MKHAHGS9hGmdD29iIsIqaBICKWb5zDiMo6p8r8+QrezGG4Xzyo0AYgz0y+2rGPe
	SinGuvf4s+J3v16SXltvM0HFS8AL/GIwXlEr1dOsEAowHyL1nMvI29akqz5O5TnfvpTLG12n1PoV5
	ZhgDu75wJCDPhoyGB1DUXK7ZsQg9XANxgc65w4HYeM6QD/Kmd5N5oaZWQvN3VdzcP2apljjz9ohx1
	weSahDMBUUV62a6NWMLBWXpugzS+gvyD6Gqki9VtvLESXqjuqssEUPoqdln6hSrH/ZWQIQWQhjKZl
	SDA8shfw==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rsaH6-00000009WHm-2K1c;
	Fri, 05 Apr 2024 03:29:56 +0000
Date: Fri, 5 Apr 2024 04:29:56 +0100
From: Matthew Wilcox <willy@infradead.org>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-s390@vger.kernel.org, kvm@vger.kernel.org,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v1 2/5] s390/uv: convert gmap_make_secure() to work on
 folios
Message-ID: <Zg9wNKTu4JxGXrHs@casper.infradead.org>
References: <20240404163642.1125529-1-david@redhat.com>
 <20240404163642.1125529-3-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240404163642.1125529-3-david@redhat.com>

On Thu, Apr 04, 2024 at 06:36:39PM +0200, David Hildenbrand wrote:
> +		/* We might get PTE-mapped large folios; split them first. */
> +		if (folio_test_large(folio)) {
> +			rc = -E2BIG;

We agree to this point.  I just turned this into -EINVAL.

>  
> +	if (rc == -E2BIG) {
> +		/*
> +		 * Splitting might fail with -EBUSY due to unexpected folio
> +		 * references, just like make_folio_secure(). So handle it
> +		 * ahead of time without the PTL being held.
> +		 */
> +		folio_lock(folio);
> +		rc = split_folio(folio);
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	}

Ummm ... if split_folio() succeeds, aren't we going to return 0 from
this function, which will be interpreted as make_folio_secure() having
succeeded?


