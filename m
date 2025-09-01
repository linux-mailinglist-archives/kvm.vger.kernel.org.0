Return-Path: <kvm+bounces-56460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42C9AB3E718
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 16:28:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FD7C1631E6
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 14:28:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ABBB34165A;
	Mon,  1 Sep 2025 14:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YzAQYKzY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B2D323E;
	Mon,  1 Sep 2025 14:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756736883; cv=none; b=JJ1oKNw60z5OB6C0ANjhf6NMq0gqsilPFNzW9n7405D/7Y2HtKvVfIccGyoZw4RLAZEPkaYH8ieSgsyhwOwuSf60PBR/3atwKRtC1nycPaTzBhmCzK0FW4s4u6HzXBPHog8nLgm89vr4p8paUNCq9hpGk7jX5NoSF2VjnOgMVz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756736883; c=relaxed/simple;
	bh=79YhD1biW7ZRAbWexbw6r9UIo8+R0Ehi9QzCMPNdDb0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l+67CZVVBuKTgMwKbyP3uD4iN/y7nzoPXqsrujBFjoqts9th7XzqL94l+5we92MjmVY8x7b9Fhs05pGiOKOfkw6bcTIs3UPRMfrSt7LwQhXaY8TiTfbrwFfNVHh84/hWI9qz0cMyzVio8iKYa7J5WzwKzTBULCib+h/N2WI13O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YzAQYKzY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF62C4CEF0;
	Mon,  1 Sep 2025 14:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756736882;
	bh=79YhD1biW7ZRAbWexbw6r9UIo8+R0Ehi9QzCMPNdDb0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YzAQYKzYOdJ3Q71t1i2a14NKnIRG3n/WMD3ZFyAehHTZcJusoFFuNtDI2+HYZCtj4
	 wk4jXKHQxLBdQ/Wwob+BiDoE7bcA3zFC9B0eRyi7Kfl4+gmWXl8HuIHV2Af5e9fgwA
	 k9kw3BDo2FcbU50hWaofq1m8IK+QrX0RmYGl2DNtGvaotpXICnparE35Y4MV2Fgiq5
	 5DMOJp4CNBhGnYB20E8CWFZprn65hFKxKfRI0r2dTONJbvqIUGV2TGTOHgvLj0O5JQ
	 t5EmUEtJBtKDLedgo9+7Jmh8ty/H6KSolSb9QH8nHkMnNj4dqhY7W8+tFatLVLqv3G
	 4q+9NkXdezl/A==
Date: Mon, 1 Sep 2025 17:27:53 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "ackerleytng@google.com" <ackerleytng@google.com>,
	"david@redhat.com" <david@redhat.com>,
	"Manwaring, Derek" <derekmn@amazon.com>,
	"Thomson, Jack" <jackabt@amazon.co.uk>,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"tabba@google.com" <tabba@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>,
	"will@kernel.org" <will@kernel.org>,
	"Cali, Marco" <xmarcalx@amazon.co.uk>
Subject: Re: [PATCH v5 04/12] KVM: guest_memfd: Add flag to remove from
 direct map
Message-ID: <aLWtaZYi65aLtTAP@kernel.org>
References: <aLBtwIhQpX6AR2Z6@kernel.org>
 <20250901142220.30610-1-roypat@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250901142220.30610-1-roypat@amazon.co.uk>

On Mon, Sep 01, 2025 at 02:22:22PM +0000, Roy, Patrick wrote:
> On Thu, 2025-08-28 at 15:54 +0100, Mike Rapoport wrote:
> > On Thu, Aug 28, 2025 at 09:39:21AM +0000, Roy, Patrick wrote:
> >
> >>  static inline void kvm_gmem_mark_prepared(struct folio *folio)
> >>  {
> >> +     struct inode *inode = folio_inode(folio);
> >> +
> >> +     if (kvm_gmem_test_no_direct_map(inode))
> >> +             set_direct_map_valid_noflush(folio_page(folio, 0), folio_nr_pages(folio), false);
> > 
> > This may fail to split large mapping in the direct map. Why not move this
> > to kvm_gmem_prepare_folio() where you can handle returned error?
> 
> Argh, yeah, got that the wrong way around. Will update the error handling.
> 
> > I think that using set_direct_map_invalid_noflush() here and
> > set_direct_map_default_noflush() in kvm_gmem_free_folio() better is
> > clearer and makes it more obvious that here the folio is removed from the
> > direct map and when freed it's direct mapping is restored.
> > 
> > This requires to export two symbols in patch 2, but I think it's worth it.
> 
> Mh, but set_direct_map_[default|invalid]_noflush() only take a single struct
> page * argument, so they'd either need to gain a npages argument, or we add yet
> more functions to set_memory.h.  Do you still think that's worth it? 

Ah, right, misremembered that. Let's keep set_direct_map_valid_noflush().
 
-- 
Sincerely yours,
Mike.

