Return-Path: <kvm+bounces-15126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B66958AA29E
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 21:20:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7CAD1C20F53
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 19:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 232CB17B4F1;
	Thu, 18 Apr 2024 19:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nCxSFVlK"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA81D17AD9D
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 19:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713468048; cv=none; b=JFRAw1Oz1woWNthUKSrJ/oTXZ1P5yePrvXUvZ8jVPmtAD8ee32QV6Xxqxj3/oNZctQkX4AGTwXyEbewm4Z++u6uhS6ngzIdXvKEktQRVfoSM3QZlUnk9wAksIKVEa02RoYtBuqWGCGXvk9DCgc4bqaUjhtDSWPx0rUbEbVl1fV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713468048; c=relaxed/simple;
	bh=r5ShLhpZxD0HrrVuRWOfoo4xgnpEPgpVWaBuJ8pt6wA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LriDL7c27YBwHWfzan1JqERHrOoeTfSIp6Jc9lDVMEAxl+2rOCvhDjPajmWbyd98kkLVWpSt75eHgpEl6VWNuA6P21Bba2Gmd/g669oC5O64L5AFLqwBuQjepRlZbwwf+HuQ+gSaY1ALs1rSAWKYixywMjy11M91mnMRe1CEeXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nCxSFVlK; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 18 Apr 2024 21:20:39 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713468043;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uzIAv+vT9qFfd9KlAxcjB8/u/z8hYOscGhGxp5vzwoc=;
	b=nCxSFVlKkOTTBCr2f3Eon32RAFIm0LmowdUaIYN8GVaKWaSLKGkyRYdmZDa/LPfsEtxJsS
	gqdGAozdJVC+uWqyNI2eelXDlIuJGUcrtNxzR/s/PzVyqBjTop+60ilt4ZHeR1rT6eDNr1
	zo6iROdT+8BQncXndWNcIUnpGUFrgI8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Jan Richter <jarichte@redhat.com>
Cc: thuth@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] test_migrate_unmapped_collection test
 fails during skip
Message-ID: <20240418-057e93240295617e456f221c@orel>
References: <20240418155549.71374-1-jarichte@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240418155549.71374-1-jarichte@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Apr 18, 2024 at 05:55:49PM +0200, Jan Richter wrote:
> The test_migrate_unmapped_collection test fails when the errata
> requirements are not meet and the test should be skipped. Instead of

met

> being skipped, the test returns `ERROR: Test exit before migration
> point.`
> 
> This is caused by changes in fa8914bccc226db86bd70d71bfd6022db252fc78

Please use the standard way of referencing commits, which, in this case,
would be

commit fa8914bccc22 ("migration: Add a migrate_skip command")

> which changes the behaviour of skipped migration tests. This fixes this
> issue by adding migrate_skip() method to
> test_migrate_unmapped_collection.

And we should add a Fixes tag

Fixes: fa8914bccc22 ("migration: Add a migrate_skip command")

> 
> Signed-off-by: Jan Richter <jarichte@redhat.com>
> ---
>  arm/gic.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index bbf828f1..256dd80d 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -829,6 +829,7 @@ static void test_migrate_unmapped_collection(void)
>  	if (!errata(ERRATA_UNMAPPED_COLLECTIONS)) {
>  		report_skip("Skipping test, as this test hangs without the fix. "
>  			    "Set %s=y to enable.", ERRATA_UNMAPPED_COLLECTIONS);
> +		migrate_skip();
>  		return;
>  	}
>  
> -- 
> 2.44.0
>

Otherwise LGTM

Thanks,
drew

