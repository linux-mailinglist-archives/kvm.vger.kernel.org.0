Return-Path: <kvm+bounces-41522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CCB79A69BD9
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 23:13:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3DAB1188B830
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 22:13:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1112821859F;
	Wed, 19 Mar 2025 22:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bet/bQTs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADFB20899C
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 22:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742422415; cv=none; b=CfHv58h+Eu7Si/E8+sZBJJ2K+RtIQ87jCEkEjpemgmBYG89/I1p3wusBNMFUWpMVGy3h721/Sw/dAzlGz9jjIHhGcm7vjxa0oHDAOUDDooA2/4QuppX1M7nbSxk78hRULr4vU/ZauxvWTIJF66HRKcZTx5d33lOc51e9xyIXaMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742422415; c=relaxed/simple;
	bh=qnScDBSJ3R9O74B9eP383x1WJ8iVdJtGp5bq/wzDgUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cOean2cc+t8wmtUh1NoMdJKMgxxIGrxVIvXiDM+0sSkOKv3z8Cc5ClAW/0EpHdxsE8iWCQXN4UhDqzq+sckbeqCdCtN9HwGojRX815grd+EeniyaBvnS0FJkVQC1zOfNIEzaFZwBjOvvMDPRhjoGqMK90dygFf0Nt5K5+niHy/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bet/bQTs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76136C4CEE7;
	Wed, 19 Mar 2025 22:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742422414;
	bh=qnScDBSJ3R9O74B9eP383x1WJ8iVdJtGp5bq/wzDgUs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bet/bQTsqri9XssnOOwhShFPCXuZr4aqhkKuepf0vZv66uzuz5WOp4DAwy4xMuCIH
	 c7GrkzPlHg0DtFqCvFTXQ22ZZDhiEmLkOoHgMQXzr+FQckaHjeHi82cBVwRkQbMvq/
	 W8CY/D8B0OuQpnoiQlxubBrhsTMmXMp5EOCFBt7Y+EiJ0+7npAu2bD6VLcMXNXEYQw
	 sr2/ZMny0FviiX3/QqXGck6LKj8YQz7jx9zAJaaLziUZhQvC/HAPwdUwuV4PI4Ru+e
	 3Akm54FqN/KWUQPHkHBeWfCO+prMYaVf1fDMhThh921c4S2UV1x/aSwyR5HXeXdX/U
	 mrnWev3JBHHSw==
Date: Wed, 19 Mar 2025 16:13:31 -0600
From: Keith Busch <kbusch@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio/type1: conditional rescheduling while pinning
Message-ID: <Z9tBixVi-orYROTt@kbusch-mbp.dhcp.thefacebook.com>
References: <20250312225255.617869-1-kbusch@meta.com>
 <20250317154417.7503c094.alex.williamson@redhat.com>
 <Z9iilzUTwLKzcVfK@kbusch-mbp.dhcp.thefacebook.com>
 <20250317165347.269621e5.alex.williamson@redhat.com>
 <Z9rm-Y-B2et9uvKc@kbusch-mbp>
 <20250319121704.7744c73e.alex.williamson@redhat.com>
 <Z9sOPykPIqJWYzca@kbusch-mbp>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9sOPykPIqJWYzca@kbusch-mbp>

On Wed, Mar 19, 2025 at 12:34:39PM -0600, Keith Busch wrote:
> On Wed, Mar 19, 2025 at 12:17:04PM -0600, Alex Williamson wrote:
> > Since you mention folding in the changes, are you working on an upstream
> > kernel or a downstream backport?  Huge pfnmap support was added in
> > v6.12 via [1].  Without that you'd never see better than a order-a
> > fault.  I hope that's it because with all the kernel pieces in place it
> > should "Just work".  Thanks,
> 
> Yep, this is a backport to 6.11, and I included that series. There were
> a few extra patches outside it needed to port that far back, but nothing
> difficult.
> 
> Anyway since my last email, things are looking more successful now. We
> changed a few things in both user and kernel side, so we're just doing
> more tests to confirm what part was the necessary change.

Looks like we're okay now. I think the user space part was missing a
MADV_HUGEPAGE in one of the paths, so we were never getting the huge
faults.

