Return-Path: <kvm+bounces-52096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C01E7B014C2
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 09:33:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AFC001891047
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 07:33:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E88491EFF8B;
	Fri, 11 Jul 2025 07:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XNWRWlQ4"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC69197A6C;
	Fri, 11 Jul 2025 07:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752219187; cv=none; b=uRaAEtBlvFUALRKFDCAEeej+XrwLa8j9kKSPCGpy/cTGxDt/cRoNnGTXbA4cZfvUB9/OD1yRKJvu3v+duJ5/BsBToSqhLPDjUZQRy1djEok+1CmbbBAOYlxPessPI4C3tHZxgDmbi+o9nnp7bMB0Tk+2GqxoxR78vusPgYohqWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752219187; c=relaxed/simple;
	bh=4+cMq7WmCP7QhJEBuMAp8KaJDQvkZ/CG9iiej1+tkVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e1wsc0LfupCfdQSVdROMEAKZmiUlW/02R4NUfINc3rjSSwSQq6FzQ6JyY7H5TSuHnkfiTHn0gE7w85dtuYIIWODsJeKwHk0BIjjaoz44WKu2zVzRjE5zx5EijDGJfkyJQIJJKe5AmNUrqV4Suw3SXxPpPGP0gSK9akL9Mapc7rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XNWRWlQ4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4+cMq7WmCP7QhJEBuMAp8KaJDQvkZ/CG9iiej1+tkVo=; b=XNWRWlQ4dgmJ6wpuZvxs5QUPjb
	HN6OlB+k1idOw1y0xPiAzlZRJd4/RLvfKq2eqTe4IvanbkVeSmJGXNEYogwnKoR9NO2bhSYOfVnW7
	k+2uJVD6cvasP5jDsN0n6V+h1CAFG0LPxwv2czLF5KH/8qJuFm6i4FjMaP76W4N2rZNHS4M/oGesI
	Nz4DWWmpjgycR4V0Z/IzXAGxcplRWE7jEryFRWZbRFUSqVa22aBYPS80dCT2CLwFHEa2aRfcjK1G5
	Ht19QJbmhOGoH+mLrfTTQUDyB7+kzBykLRZDayXLMqlov0lsLKthJ9yi67NPQp4OeGHELod7npE9Y
	zyH/ZxZA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ua8Fd-0000000DzJT-3ext;
	Fri, 11 Jul 2025 07:32:57 +0000
Date: Fri, 11 Jul 2025 00:32:57 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thomas Huth <thuth@redhat.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-spdx@vger.kernel.org
Subject: Re: [PATCH v2] powerpc: Replace the obsolete address of the FSF
Message-ID: <aHC-Ke2oLri_m7p6@infradead.org>
References: <20250711053509.194751-1-thuth@redhat.com>
 <2025071125-talon-clammy-4971@gregkh>
 <9f7242e8-1082-4a5d-bb6e-a80106d1b1f9@redhat.com>
 <2025071152-name-spoon-88e8@gregkh>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025071152-name-spoon-88e8@gregkh>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jul 11, 2025 at 09:30:31AM +0200, Greg Kroah-Hartman wrote:
> That's a crazy exception, and one that should probably be talked about
> with the FSF to determine exactly what the SPDX lines should be.

It is called the libgcc exception and has been around forever for the
files in libgcc.a that a lot of these low-level kernel helpers were
copied from as the kernel doesn't link libgcc.

