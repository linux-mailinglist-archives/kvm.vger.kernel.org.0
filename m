Return-Path: <kvm+bounces-13634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B6198993F1
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 05:43:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AF9B8B231DF
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 03:43:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1619F1C68F;
	Fri,  5 Apr 2024 03:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BiUkNHHy"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27FE256D;
	Fri,  5 Apr 2024 03:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712288573; cv=none; b=F+GH+WdaSljr64UyIk1mDDefzCiz+c/Tn4SiR8C+lHSQIUEQ2FCvqoB8XcUN/rSDN2qVK+AKQ3aAOU92HY7DZ/bpaiwTVWuSvKMgAGjP8g8dgnEjTPOqSAfNlOEYNcYkRw0kccdmvVPNg92kiw70f5hA3R/5SpD6c1/dI/S3YTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712288573; c=relaxed/simple;
	bh=1E4q9iSNFoJ5e8ve8agC1zRQQ+0F+2ROOW1SmEusQhQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V0H3eQUy6jAdgvlXEGrQ2qZgCUt0qSpk/pgAMe7nMfw+qImX5+KotZnzOBX4pqm+YWoxKFN6VQgXyvMLHZP6WVnGERtaG1fAq7hWuGU4qhxisSZIHMsjtirV/ePo4i4sxq9Q24+4XdcK0adz35W5/9mDEsUWUA8YWpf6Cz4isps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BiUkNHHy; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GdrhCCARPBrZ0BeKtdp/2ujXMzoo79cn9UM+NnhXtOc=; b=BiUkNHHyRubp6ozZi9ENrekA++
	yQOYyCgQCr+0Q/os9bqKoxPFMAbMbxNG6VK3KHRf8d5VUDBhQK2d5+yLPqCJMWNEi9A5Np7eRoKb/
	DBIczCaUGUP4hAyXgNPEyzczgbll9TcpKdoOXd+GyloI5jB85moOyOiFUm+70vucequYLSfNiLsla
	ICHIK+mjkvj8DeY0YHxe+itsx+qAUbmLmj20OriZ1nYpu04O7xrCKDWqCrYQ3Hc+/LOOT/Nc628nG
	LvjTUu+/BGPTLzt1GjKxZsMEhtwzjcQrf4qkNfEQ7hNy60oBEO1E+Qkxv1rZfhKyXuJ6e19bJTSD+
	hTAIPaBg==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rsaTY-00000009Y3j-2mgL;
	Fri, 05 Apr 2024 03:42:48 +0000
Date: Fri, 5 Apr 2024 04:42:48 +0100
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
Subject: Re: [PATCH v1 0/5] s390: page_mapcount(), page_has_private() and
 PG_arch_1
Message-ID: <Zg9zOJowhmOozmcp@casper.infradead.org>
References: <20240404163642.1125529-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240404163642.1125529-1-david@redhat.com>

On Thu, Apr 04, 2024 at 06:36:37PM +0200, David Hildenbrand wrote:
> On my journey to remove page_mapcount(), I got hooked up on other folio
> cleanups that Willy most certainly will enjoy.
> 
> This series removes the s390x usage of:
> * page_mapcount() [patches WIP]
> * page_has_private() [have patches to remove it]
> 
> ... and makes PG_arch_1 only be set on folio->flags (i.e., never on tail
> pages of large folios).
> 
> Further, one "easy" fix upfront.

Looks like you didn't see:

https://lore.kernel.org/linux-s390/20240322161149.2327518-1-willy@infradead.org/

> ... unfortunately there is one other issue I spotted that I am not
> tackling in this series, because I am not 100% sure what we want to
> do: the usage of page_ref_freeze()/folio_ref_freeze() in
> make_folio_secure() is unsafe. :(
> 
> In make_folio_secure(), we're holding the folio lock, the mmap lock and
> the PT lock. So we are protected against concurrent fork(), zap, GUP,
> swapin, migration ... The page_ref_freeze()/ folio_ref_freeze() should
> also block concurrent GUP-fast very reliably.
> 
> But if the folio is mapped into multiple page tables, we could see
> concurrent zapping of the folio, a pagecache folios could get mapped/
> accessed concurrent, we could see fork() sharing the page in another
> process, GUP ... trying to adjust the folio refcount while we froze it.
> Very bad.

Hmmm.  Why is that not then a problem for, eg, splitting or migrating?
Is it because they unmap first and then try to freeze?

> For anonymous folios, it would likely be sufficient to check that
> folio_mapcount() == 1. For pagecache folios, that's insufficient, likely
> we would have to lock the pagecache. To handle folios mapped into
> multiple page tables, we would have to do what
> split_huge_page_to_list_to_order() does (temporary migration entries).
> 
> So it's a bit more involved, and I'll have to leave that to s390x folks to
> figure out. There are othe reasonable cleanups I think, but I'll have to
> focus on other stuff.
> 
> Compile tested, but not runtime tested, I'll appreiate some testing help
> from people with UV access and experience.
> 
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Sven Schnelle <svens@linux.ibm.com>
> Cc: Janosch Frank <frankja@linux.ibm.com>
> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Thomas Huth <thuth@redhat.com>
> 
> David Hildenbrand (5):
>   s390/uv: don't call wait_on_page_writeback() without a reference
>   s390/uv: convert gmap_make_secure() to work on folios
>   s390/uv: convert PG_arch_1 users to only work on small folios
>   s390/uv: update PG_arch_1 comment
>   s390/hugetlb: convert PG_arch_1 code to work on folio->flags
> 
>  arch/s390/include/asm/page.h |   2 +
>  arch/s390/kernel/uv.c        | 112 ++++++++++++++++++++++-------------
>  arch/s390/mm/gmap.c          |   4 +-
>  arch/s390/mm/hugetlbpage.c   |   8 +--
>  4 files changed, 79 insertions(+), 47 deletions(-)
> 
> -- 
> 2.44.0
> 

