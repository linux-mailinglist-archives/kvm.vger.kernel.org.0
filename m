Return-Path: <kvm+bounces-24834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2920695BB31
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 17:59:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D50C41F23EBD
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 15:59:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F36321CCEC4;
	Thu, 22 Aug 2024 15:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Zg2/ERtz"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E0B1CC163;
	Thu, 22 Aug 2024 15:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724342366; cv=none; b=T8TcuGPxejFRn/C9CJmtfMXfnzfLz3BfgNRcdmItt9kWlMszjpYtiDFf42QnUV45LWZzcK4s3Uq0VKUBK8nrLcsMcFKYrzIhq5ny75CdB3wp8myr4RjkWav2mKC6SOh1nW/H4oHiq4iP70ewdOySpm8L1/2rHTONgjXAqAue9GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724342366; c=relaxed/simple;
	bh=Y8drUIvJIcCbcixOSkBjNbdd6RONq+Jb+ugzY1/l7/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GAbx3wpcxhZSa74PT2TIMyhTBFfvK4f+KM6wHO//yUBNZbKOlCfvOLdhh5DIG3tq9oAVFhB04IGfTsnjxAcTatMCUWeijGPRXrcnBaokrW3Fk9Y9BFptfYRKy7kMryT0C99OsejXQMOW5KprhzJdvsKbNAJRpzJGAYCVcqYQZTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Zg2/ERtz; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wdCkTioVy4H98qjBudwR7Eibp4zwLP2NEVyZt58Gsxk=; b=Zg2/ERtzNldDIv3sX8B9pYDh8e
	RA5Bq7s14UEhg8//A34o4UPKQ/w8yYFhKZVOPEL0KIH9oCxpbSBfPx0PygYLNAUPBb0ENSvyD/fIq
	TDoIy/egZ3dRtvbxOCZYIKQj8Qm8hNrq+kC/usLJsYuf3o1jaFM4ldERmZHOM6l97d9fw/NUgED6W
	t7Hfo4s0xc6Q2PL3PxSrCB5CO4LqS8RyynpUKgkP0LyGtgYBHI3cnHpXUW0c9w6yzq4GZ7Jpvd9c0
	w2+NbfdppYdWYbp7pT787kXUF/tfyOE1TKNa1PWoBF/Pb3zffG7HAaehDBux8Bv0wDKyBuTR/vyen
	pDUXgvsw==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shADX-0000000AgiD-0Oqw;
	Thu, 22 Aug 2024 15:59:19 +0000
Date: Thu, 22 Aug 2024 16:59:18 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: pbonzini@redhat.com, chao.p.peng@linux.intel.com, seanjc@google.com,
	Liam.Howlett@oracle.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org
Subject: Re: [PATCH RFC] KVM: Use maple tree to manage memory attributes.
Message-ID: <ZsdgVoBxh9qe2Fjs@casper.infradead.org>
References: <20240822065544.65013-1-zhangpeng.00@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240822065544.65013-1-zhangpeng.00@bytedance.com>

On Thu, Aug 22, 2024 at 02:55:44PM +0800, Peng Zhang wrote:
> +	mt_init_flags(&kvm->mem_attr_mtree, MT_FLAGS_LOCK_EXTERN);

using an external lock is a HACK.  it should go away, not be mindlessly
propagated.

