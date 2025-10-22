Return-Path: <kvm+bounces-60813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6E29BFAFEB
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 10:55:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBBBD5851A9
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 08:54:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59E3630DEA9;
	Wed, 22 Oct 2025 08:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qLcz8g00"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBB320B7E1;
	Wed, 22 Oct 2025 08:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761123288; cv=none; b=CJvkMwmjOT/wLk7aJ0agqSzQvY9K/Ynl47lE5OcObrhuIIwfQ+kH9NJ+NeBk+Iyhi2Lx1eg5x+THw/rRf29ehRXStmE2VWZj+5OhgJ8BEYQLMCElqLArNcG5uo2SNS/lMgY+Pgjd41M4obGDGKtO+lOV+hGk1VYR4tS9wZ6udwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761123288; c=relaxed/simple;
	bh=R3jzD6CzBSxf1gumv5ZW163Wkyn/4GrrIV6HRnjDdNU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ExydYOmlcroZi6h4E6dgrckP/FCGXL/tf/Su2MLqi+G9SY6JXzQuEilZ50VKiMLHveBnkkojZSCjWajppzqed8rSv617DdfSQpWLqcX3WXX76ujmpUA+j6TRvHE/bVfLFsU9lgzWaYZ/sItBgiNZ5ASAHGXWOltR6Cst3J4jCvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qLcz8g00; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=ekrlHcjYC4m+Xa92FKOsdA1s49hcSWsjk1pkcgl5E+k=; b=qLcz8g00L1gzbpYWiRi/cu4S1p
	usSj8RVOMmWMZgf4y2wbCSdJhgMsMX1N73GTCjukUVhY6b6sJmzuCtQ1q+PdvNK2j3jJ6gkdxrXUD
	4PHLPPkxikg13WgqYYIy2yii8vwE3DtXYc4GizGh4pptGBzuuvGcRzWz5L7vzyBJ7fmkLphcp5BbH
	xSkrzJDZOfLNWaEG0/5MoKNxcgKLDjb1T2lO9Stgd1pGTOTVWKWWdvpLFwblsY4hSIqhZzbD9aJyk
	dReYdVT2/Rwq3bgM4jL0y6MXDSts9kssqRURqwMz67+sQuXFCprDicW1aGK+k9N6jTXdsc1bSXx/Q
	kK4o/EYg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBUcE-000000029rJ-20Q7;
	Wed, 22 Oct 2025 08:54:42 +0000
Date: Wed, 22 Oct 2025 01:54:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: =?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>, intel-xe@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Matthew Brost <matthew.brost@intel.com>,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	dri-devel@lists.freedesktop.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Lukasz Laguna <lukasz.laguna@intel.com>
Subject: Re: [PATCH v2 26/26] vfio/xe: Add vendor-specific vfio_pci driver
 for Intel graphics
Message-ID: <aPib0tHn1yK9qx2x@infradead.org>
References: <20251021224133.577765-1-michal.winiarski@intel.com>
 <20251021224133.577765-27-michal.winiarski@intel.com>
 <aPiDwUn-D2_oyx2T@infradead.org>
 <ilv4dmjtei7llmoamwdjb3eb32rowzg6lwpjhdtilouoi6hyop@xnpkhbezzbcv>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ilv4dmjtei7llmoamwdjb3eb32rowzg6lwpjhdtilouoi6hyop@xnpkhbezzbcv>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 22, 2025 at 10:52:34AM +0200, Michał Winiarski wrote:
> On Wed, Oct 22, 2025 at 12:12:01AM -0700, Christoph Hellwig wrote:
> > There is absolutely nothing vendor-specific here, it is a device variant
> > driver.  In fact in Linux basically nothing is ever vendor specific,
> > because vendor is not a concept that does matter in any practical sense
> > except for tiny details like the vendor ID as one of the IDs to match
> > on in device probing.
> > 
> > I have no idea why people keep trying to inject this term again and
> > again.
> 
> Hi,
> 
> The reasoning was that in this case we're matching vendor ID + class
> combination to match all Intel GPUs, and not just selected device ID,
> but I get your point.

Which sounds like a really bad idea.  Is this going to work on i810
devices?  Or the odd parts povervr based parts?


