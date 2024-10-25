Return-Path: <kvm+bounces-29734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E21699B08CB
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 17:46:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F12A1C219C1
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 15:46:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 907E315ADAB;
	Fri, 25 Oct 2024 15:46:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 995EC1411E0
	for <kvm@vger.kernel.org>; Fri, 25 Oct 2024 15:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729871171; cv=none; b=kuAoZs0B6VVpR1pFpD4XxpbVphYrKZvKhE3TwgQaTaCQudCf8jNlXQKcSXjx3sA9bosWuqhqrO3/vdk/oG32irioT5VBWtyRDVpJY194dCrw6BHKY3/NKk/fzYMZrAhikEOz48o2wL6T2iPC+0fBaERMoarHI7f/UBfa+aSHnJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729871171; c=relaxed/simple;
	bh=E0n7nO+3obEoljEtO63VirXpJr5kVqVzmje2qTj39zw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CvqXamwZDC33J+crifZSKzsk3UM5hCFemev1KxmvcyNpIlHptL0AgGB0PuzrEIcfA7CrpuZfY2BSS27hupc9BSo5aHiXONnO9mkpgoLOlH+Fiimk+fQ1I029qFeCam8RIEVIzz7uri0PXD5rO/XZCswlZFSkANsMSbyoDhruxTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 97E6C339;
	Fri, 25 Oct 2024 08:46:36 -0700 (PDT)
Received: from arm.com (unknown [10.57.25.65])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 62C283F73B;
	Fri, 25 Oct 2024 08:46:01 -0700 (PDT)
Date: Fri, 25 Oct 2024 16:45:54 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, thuth@redhat.com,
	lvivier@redhat.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
	nrb@linux.ibm.com, npiggin@gmail.com
Subject: Re: [RFC kvm-unit-tests PATCH] lib/report: Return pass/fail result
 from report
Message-ID: <Zxu9MkAob0zVCsYQ@arm.com>
References: <20241023165347.174745-2-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023165347.174745-2-andrew.jones@linux.dev>

Hi Drew,

On Wed, Oct 23, 2024 at 06:53:48PM +0200, Andrew Jones wrote:
> A nice pattern to use in order to try and maintain parsable reports,
> but also output unexpected values, is
> 
>     if (!report(value == expected_value, "my test")) {
>         report_info("failure due to unexpected value (received %d, expected %d)",
>                     value, expected_value);
>     }

This looks like a good idea to me, makes the usage of report() similar to
the kernel pattern of wrapping an if condition around WARN_ON():

	if (WARN_ON(condition)) {
		do_stuff()
	}

Plus, current users are not affected by the change so I see no reason not
to have the choice.

> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  lib/libcflat.h |  6 +++---
>  lib/report.c   | 28 +++++++++++++++++++++-------
>  2 files changed, 24 insertions(+), 10 deletions(-)
> 
> diff --git a/lib/libcflat.h b/lib/libcflat.h
> index eec34c3f2710..b4110b9ec91b 100644
> --- a/lib/libcflat.h
> +++ b/lib/libcflat.h
> @@ -97,11 +97,11 @@ void report_prefix_pushf(const char *prefix_fmt, ...)
>  extern void report_prefix_push(const char *prefix);
>  extern void report_prefix_pop(void);
>  extern void report_prefix_popn(int n);
> -extern void report(bool pass, const char *msg_fmt, ...)
> +extern bool report(bool pass, const char *msg_fmt, ...)
>  		__attribute__((format(printf, 2, 3), nonnull(2)));
> -extern void report_xfail(bool xfail, bool pass, const char *msg_fmt, ...)
> +extern bool report_xfail(bool xfail, bool pass, const char *msg_fmt, ...)
>  		__attribute__((format(printf, 3, 4), nonnull(3)));
> -extern void report_kfail(bool kfail, bool pass, const char *msg_fmt, ...)
> +extern bool report_kfail(bool kfail, bool pass, const char *msg_fmt, ...)
>  		__attribute__((format(printf, 3, 4), nonnull(3)));
>  extern void report_abort(const char *msg_fmt, ...)
>  					__attribute__((format(printf, 1, 2)))
> diff --git a/lib/report.c b/lib/report.c
> index 0756e64e6f10..43c0102c1b0e 100644
> --- a/lib/report.c
> +++ b/lib/report.c
> @@ -89,7 +89,7 @@ void report_prefix_popn(int n)
>  	spin_unlock(&lock);
>  }
>  
> -static void va_report(const char *msg_fmt,
> +static bool va_report(const char *msg_fmt,
>  		bool pass, bool xfail, bool kfail, bool skip, va_list va)
>  {
>  	const char *prefix = skip ? "SKIP"
> @@ -114,14 +114,20 @@ static void va_report(const char *msg_fmt,
>  		failures++;
>  
>  	spin_unlock(&lock);
> +
> +	return pass || xfail;

va_report() has 4 boolean parameters that the callers set. 'kfail' can be
ignored, because all it does is control which variable serves as the
accumulator for the failure.

I was thinking about the 'skip' parameter - report_skip() sets pass = xfail
= false, skip = true. Does it matter that va_report() returns false for
report_skip()? I don't think so (report_skip() returns void), just wanting
to make sure we've considered all the cases.  Sorry if this looks like
nitpicking.

Other than that, the patch looks good to me.

Thanks,
Alex

>  }
>  
> -void report(bool pass, const char *msg_fmt, ...)
> +bool report(bool pass, const char *msg_fmt, ...)
>  {
>  	va_list va;
> +	bool ret;
> +
>  	va_start(va, msg_fmt);
> -	va_report(msg_fmt, pass, false, false, false, va);
> +	ret = va_report(msg_fmt, pass, false, false, false, va);
>  	va_end(va);
> +
> +	return ret;
>  }
>  
>  void report_pass(const char *msg_fmt, ...)
> @@ -142,24 +148,32 @@ void report_fail(const char *msg_fmt, ...)
>  	va_end(va);
>  }
>  
> -void report_xfail(bool xfail, bool pass, const char *msg_fmt, ...)
> +bool report_xfail(bool xfail, bool pass, const char *msg_fmt, ...)
>  {
> +	bool ret;
> +
>  	va_list va;
>  	va_start(va, msg_fmt);
> -	va_report(msg_fmt, pass, xfail, false, false, va);
> +	ret = va_report(msg_fmt, pass, xfail, false, false, va);
>  	va_end(va);
> +
> +	return ret;
>  }
>  
>  /*
>   * kfail is known failure. If kfail is true then test will succeed
>   * regardless of pass.
>   */
> -void report_kfail(bool kfail, bool pass, const char *msg_fmt, ...)
> +bool report_kfail(bool kfail, bool pass, const char *msg_fmt, ...)
>  {
> +	bool ret;
> +
>  	va_list va;
>  	va_start(va, msg_fmt);
> -	va_report(msg_fmt, pass, false, kfail, false, va);
> +	ret = va_report(msg_fmt, pass, false, kfail, false, va);
>  	va_end(va);
> +
> +	return ret;
>  }
>  
>  void report_skip(const char *msg_fmt, ...)
> -- 
> 2.47.0
> 
> 

