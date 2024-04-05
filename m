Return-Path: <kvm+bounces-13633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96C668993EA
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 05:36:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1AB5CB2147B
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 03:36:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 734771CA81;
	Fri,  5 Apr 2024 03:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KnE1kdDH"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF4418E1D;
	Fri,  5 Apr 2024 03:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712288172; cv=none; b=T3aA17MKotJYEDJVnjf7ixv0kHUBi98/D+CqQtPGpfZNbVvMm14gE7/qIheu0PWfqAfGVIt133f2O1eC/51S28gRQBmniY7tZ5DREQR63oKlvTgjwrJ+SGf/yywDkAqf2PkRM5n5zkF15bqE3I2SaGSGYI2XsSxC30I8lmFE/Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712288172; c=relaxed/simple;
	bh=nX0IsLE4uVhgju3AbBgeFZE2Nzchyo4GvdtLkkz2gpw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rAd1oKhjNLdliqh/wSdHRt7G5CYSaGkE37kKFwigvzEMhOPsy1paETphB2TClXCDziYSnh/udzYxJW4ZG/1rrcFptP3dofDFnImzwFrg9ncz9cuznIdFHWpp1ltmZaKHtSoW4qud6egWmmRMRlnNQ4BU6uWQmmC0R050afSqz/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KnE1kdDH; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YgypSeYH3i2VABJBdQ8n7O1Ci6MVKApCIW3w9teQa8g=; b=KnE1kdDHQ0+l2RtYnPW39XvQWB
	/ksbFn1pVcUQUu4ygucs3d4oLZHk5vz/36cnC8w++liHerMj4JvmmT+ibU/H2Ne7i+dONxaTiubEm
	N2U0ftWzAoCFMZNqG/3tYwYWWCBxYLYlINejPHjsmJcWFfxgInzDx0DB9c7wNajpNRqU/RFUAqWyp
	ySQs6mpkVjqbQbO6Or/dvuyk5c8In5hauv66Nu5dt/Bw/3lLkq9jfwLBuboMzS9KuMEz1+h8DgnN9
	6GkXjRtNfImP2ol2DN86NzhhuAQhqwtry62chyZip0s0Z+CgH7SjYPQi8Vlq5J+eRs+Cfc1oJGF8g
	3Mb5S23w==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rsaN1-00000009X85-3Ksj;
	Fri, 05 Apr 2024 03:36:04 +0000
Date: Fri, 5 Apr 2024 04:36:03 +0100
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
Subject: Re: [PATCH v1 3/5] s390/uv: convert PG_arch_1 users to only work on
 small folios
Message-ID: <Zg9xozcubKUYe-BV@casper.infradead.org>
References: <20240404163642.1125529-1-david@redhat.com>
 <20240404163642.1125529-4-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240404163642.1125529-4-david@redhat.com>

On Thu, Apr 04, 2024 at 06:36:40PM +0200, David Hildenbrand wrote:
> Now that make_folio_secure() may only set PG_arch_1 for small folios,
> let's convert relevant remaining UV code to only work on (small) folios
> and simply reject large folios early. This way, we'll never end up
> touching PG_arch_1 on tail pages of a large folio in UV code.
> 
> The folio_get()/folio_put() for functions that are documented to already
> hold a folio reference look weird and it should probably be removed.
> Similarly, uv_destroy_owned_page() and uv_convert_owned_from_secure()
> should really consume a folio reference instead. But these are cleanups for
> another day.

Yes, and we should convert arch_make_page_accessible() to
arch_make_folio_accessible() ... one of the two callers already has the
folio (and page-writeback already calls arch_make_folio_accessible()

