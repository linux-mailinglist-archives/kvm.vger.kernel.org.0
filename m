Return-Path: <kvm+bounces-13344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B221894BC9
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 08:49:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF0E51F22BBC
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 06:49:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E63F33CD2;
	Tue,  2 Apr 2024 06:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lmichel.fr header.i=@lmichel.fr header.b="Fgx8vkzP"
X-Original-To: kvm@vger.kernel.org
Received: from pharaoh.lmichel.fr (pharaoh.lmichel.fr [149.202.28.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58652556F
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 06:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=149.202.28.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712040559; cv=none; b=tZvKP5z5q+o5cIUkmQFVyZa74ueheTi6zgIJH0hWjjhsPlM8sG6/ctM8r4etttaQNt6xGTXCnkaPv+cVz6T0/GrGIapugBmiGSUkWi2ZxgR1fhx2gBApS8Nw+aSwr+atzDH42qeAsaK/mwWF7AwahmqQvibze7NU5KIP9orV0KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712040559; c=relaxed/simple;
	bh=AAzVEryX1n4kNxll+fyBaazQXDjjJcoVin+IAYh3j/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aMMcq12sGWXG5fUycJrz7zXz+VcYYTWqxuAH8IimICej3kiwQjsMa/rk47INBMi1x6MuhpjMZQhDpUjBO7po9iY0bLt0g0mIWsvP8dOmzIjVqaNunRV4dk05qhQ7DyS/j9vO9F0BLpMjGym3EcMc+yeDR1pIhynBF8l7SDhZ/y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lmichel.fr; spf=pass smtp.mailfrom=lmichel.fr; dkim=pass (2048-bit key) header.d=lmichel.fr header.i=@lmichel.fr header.b=Fgx8vkzP; arc=none smtp.client-ip=149.202.28.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lmichel.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lmichel.fr
Received: from localhost (sekoia-laptop.home.lmichel.fr [192.168.61.102])
	by pharaoh.lmichel.fr (Postfix) with ESMTPSA id 809C0C60172;
	Tue,  2 Apr 2024 08:42:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lmichel.fr; s=pharaoh;
	t=1712040131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ftWxsJLpk+n6OGLzL+MJBExDwuhHf9jlwwOi9Ck5Flk=;
	b=Fgx8vkzPjjg6bRUR0z/pECMZ7VSzKyitWZbHXjGRK+gLt8kBQh6aPdGYnWk2vsN3Yg5EKZ
	2NKCzqVFGLnYkNH+6hPe58k2vtF5TeuUxMN/prsPeirlCYDZkAxrw9l5F8VgMXlKOTwaSL
	cGXKI4M2U7+unSOOZNv0TbD2MCIHO0HIs9MounSQC7iY4pPgewOuBNIwMZShWDX6alXa1G
	s8F4suDCurXDNVtzRHBdZWzh/QzJRFIfDsNhljr07dNbFV+Ch4Hlc+3RXSkYUIiYGQSgG4
	vUwpo37WsTFaCVz3BQbZZ73O6fGM5Wcg7euCk3McXsYSRegOkSesJbt7oHg9Rw==
Date: Tue, 2 Apr 2024 08:42:11 +0200
From: Luc Michel <luc@lmichel.fr>
To: Stefan Weil <sw@weilnetz.de>
Cc: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Thomas Huth <thuth@redhat.com>, Eric Blake <eblake@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	qemu-devel@nongnu.org, qemu-trivial@nongnu.org
Subject: Re: [PATCH for-9.0] Fix some typos in documentation (found by
 codespell)
Message-ID: <Zguow643FFMzxbfk@michell-laptop.localdomain>
References: <20240331161526.1746598-1-sw@weilnetz.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240331161526.1746598-1-sw@weilnetz.de>

On 18:15 Sun 31 Mar     , Stefan Weil wrote:
> Signed-off-by: Stefan Weil <sw@weilnetz.de>

Reviewed-by: Luc Michel <luc@lmichel.fr>

> ---
>  docs/devel/atomics.rst     | 2 +-
>  docs/devel/ci-jobs.rst.inc | 2 +-
>  docs/devel/clocks.rst      | 2 +-
>  docs/system/i386/sgx.rst   | 2 +-
>  qapi/qom.json              | 2 +-
>  5 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/docs/devel/atomics.rst b/docs/devel/atomics.rst
> index ff9b5ee30c..b77c6e13e1 100644
> --- a/docs/devel/atomics.rst
> +++ b/docs/devel/atomics.rst
> @@ -119,7 +119,7 @@ The only guarantees that you can rely upon in this case are:
>    ordinary accesses instead cause data races if they are concurrent with
>    other accesses of which at least one is a write.  In order to ensure this,
>    the compiler will not optimize accesses out of existence, create unsolicited
> -  accesses, or perform other similar optimzations.
> +  accesses, or perform other similar optimizations.
>  
>  - acquire operations will appear to happen, with respect to the other
>    components of the system, before all the LOAD or STORE operations
> diff --git a/docs/devel/ci-jobs.rst.inc b/docs/devel/ci-jobs.rst.inc
> index ec33e6ee2b..be06322279 100644
> --- a/docs/devel/ci-jobs.rst.inc
> +++ b/docs/devel/ci-jobs.rst.inc
> @@ -115,7 +115,7 @@ CI pipeline.
>  QEMU_JOB_SKIPPED
>  ~~~~~~~~~~~~~~~~
>  
> -The job is not reliably successsful in general, so is not
> +The job is not reliably successful in general, so is not
>  currently suitable to be run by default. Ideally this should
>  be a temporary marker until the problems can be addressed, or
>  the job permanently removed.
> diff --git a/docs/devel/clocks.rst b/docs/devel/clocks.rst
> index b2d1148cdb..177ee1c90d 100644
> --- a/docs/devel/clocks.rst
> +++ b/docs/devel/clocks.rst
> @@ -279,7 +279,7 @@ You can change the multiplier and divider of a clock at runtime,
>  so you can use this to model clock controller devices which
>  have guest-programmable frequency multipliers or dividers.
>  
> -Similary to ``clock_set()``, ``clock_set_mul_div()`` returns ``true`` if
> +Similarly to ``clock_set()``, ``clock_set_mul_div()`` returns ``true`` if
>  the clock state was modified; that is, if the multiplier or the diviser
>  or both were changed by the call.
>  
> diff --git a/docs/system/i386/sgx.rst b/docs/system/i386/sgx.rst
> index 0f0a73f758..c293f7f44e 100644
> --- a/docs/system/i386/sgx.rst
> +++ b/docs/system/i386/sgx.rst
> @@ -6,7 +6,7 @@ Overview
>  
>  Intel Software Guard eXtensions (SGX) is a set of instructions and mechanisms
>  for memory accesses in order to provide security accesses for sensitive
> -applications and data. SGX allows an application to use it's pariticular
> +applications and data. SGX allows an application to use its particular
>  address space as an *enclave*, which is a protected area provides confidentiality
>  and integrity even in the presence of privileged malware. Accesses to the
>  enclave memory area from any software not resident in the enclave are prevented,
> diff --git a/qapi/qom.json b/qapi/qom.json
> index 8d4ca8ed92..85e6b4f84a 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -802,7 +802,7 @@
>  #
>  # @fd: file descriptor name previously passed via 'getfd' command,
>  #     which represents a pre-opened /dev/iommu.  This allows the
> -#     iommufd object to be shared accross several subsystems (VFIO,
> +#     iommufd object to be shared across several subsystems (VFIO,
>  #     VDPA, ...), and the file descriptor to be shared with other
>  #     process, e.g. DPDK.  (default: QEMU opens /dev/iommu by itself)
>  #
> -- 
> 2.39.2
> 

-- 

