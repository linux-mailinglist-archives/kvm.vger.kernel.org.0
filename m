Return-Path: <kvm+bounces-38192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6386FA3666B
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 20:46:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EC0AD7A1863
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 19:45:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF3F01C84B3;
	Fri, 14 Feb 2025 19:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mh3Db78j"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9D6193077;
	Fri, 14 Feb 2025 19:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739562394; cv=none; b=d3Xzfr1kjTsEUd5mYInc4LJhinZvOVzX5sOaYONtksSFYX4cd1rW+ujDTstpJiPlLijeIyGlT/7F2fQeuUYw5q3XvGyRy8E9KnYO/TGLMNQ1K+yOllipTqK/C1ky0BRVN4ARZ0kX7dHt7tMnb8xxdj60pxborhN8iLkDTqORJIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739562394; c=relaxed/simple;
	bh=K8CvequWQfPeLPsTaoe2rAGt/ZrNRLSnGeyogDnWvzQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b/BBtopo+KWXtv6Cp2lXW2ipHffBtoxnHtkEjtb4wbqYn/EKwOswiyed0PwTX6iYyChbnPys7Ja2AW82Jm7rszXY7BiolbvUtFbV3gt8CtZ8OGiB9ITvoyfT7E1Ga2pQnkjG5n2VSbrwswwvgXz22O24e1/oMXlzi0mf8QbeZ54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mh3Db78j; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3rBg5vCEAAgnUtxvRHn6AXtCO6AMSncZuDs0Rzu+MJo=; b=mh3Db78jRgdg2/2ezGzMeHTNyt
	411bGOpRxUv0s8PGzJmh9lu41MzvPv8v6wt6EEyv92tt/hbxW+wE5KAILsevkkapm96sJ2y2ts6jQ
	0LzjYzj7v9QoQ9va3ZCpj/OLvhGqZ9PQ21LQ18eTEq4+mQ5BCd5Ax0qEPcE8O3deo1kE+MIw7zuj5
	qyHXOtq/MYzssJ3stq3QFR4MM7v3vYtotIoICvmHo5ds752jfXRdCIJrFk6R2xh0eIG1/N3TmjeHx
	pZVeGo88IXEydeBbjyMTMOJZgScB3hR48gVSCSOlcqPE6itHoNjVMBHNZd3Ey2S2aXHgwmom5o/fm
	+ggcvsUw==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tj1dn-0000000ByF2-0Vmr;
	Fri, 14 Feb 2025 19:46:23 +0000
Date: Fri, 14 Feb 2025 19:46:22 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterx@redhat.com,
	mitchell.augustin@canonical.com, clg@redhat.com,
	akpm@linux-foundation.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/5] vfio/type1: Use mapping page mask for pfnmaps
Message-ID: <Z6-djlOXYTDU12mc@casper.infradead.org>
References: <20250205231728.2527186-1-alex.williamson@redhat.com>
 <20250205231728.2527186-6-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250205231728.2527186-6-alex.williamson@redhat.com>

On Wed, Feb 05, 2025 at 04:17:21PM -0700, Alex Williamson wrote:
> +			if (is_invalid_reserved_pfn(*pfn)) {
> +				unsigned long epfn;
> +
> +				epfn = (((*pfn << PAGE_SHIFT) + ~pgmask + 1)
> +					& pgmask) >> PAGE_SHIFT;
> +				ret = min_t(int, npages, epfn - *pfn);

You've really made life hard for yourself by passing around a page mask
instead of an order (ie 0/PMD_ORDER/PUD_ORDER).  Why not:

				epfn = round_up(*pfn + 1, 1 << order);

Although if you insist on passing around a mask, this could be:

				unsigned long sz = (~pgmask >> PAGE_SHIFT) + 1;
				unsigned long epfn = round_up(*pfn + 1, sz)

