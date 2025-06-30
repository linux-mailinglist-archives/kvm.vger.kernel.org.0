Return-Path: <kvm+bounces-51084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7958AED81A
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 11:03:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D3C187A4C83
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 09:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4397B2397BE;
	Mon, 30 Jun 2025 09:03:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDFDA1DED64
	for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 09:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751274185; cv=none; b=VZJFv1Dsa7fQHpkVvtrRjnJvLpDWvwuA5tHKrvP16/HTVG80KWPub+6eUWUdYLvX8XHs5VV4WpPWC8d0Yb06b6Tb0mm+iRteVxBL5MaFAeVw2LxHZNACDNqD6s9VRqW9UVNVkg17+dLbDYlvkbnil3OOZwOciwYTZMK7tdDjJB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751274185; c=relaxed/simple;
	bh=/tLAvbOkjV6rXu7eAWbLvm/sztcTqFJVoLXw6BMCSxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=usfalWj6NKLi6JW8Eu8iElwZP/AFyRAvw6IPM6eaLnycOGQhL4FNf5StuWrAuy1MohzXpS9em0J1g4rW9LXVghI/ckJ1GgG5HOrUtID7ofuQP6aofGCC/c12JFWUyV/YB1aaW/9z89pdMVEiA2UxcErI3xF4nqLq84hOX9Njk+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 15D6A1D34;
	Mon, 30 Jun 2025 02:02:47 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 45C1A3F6A8;
	Mon, 30 Jun 2025 02:03:02 -0700 (PDT)
Date: Mon, 30 Jun 2025 10:02:58 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Thomas Perale <thomas.perale@mind.be>
Cc: kvm@vger.kernel.org
Subject: Re: [PATCH kvmtool] vfio: include libgen.h (for musl compatibility)
Message-ID: <aGJSwh8CqUUF2CgZ@raptor>
References: <20250629202221.893360-1-thomas.perale@mind.be>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250629202221.893360-1-thomas.perale@mind.be>

Hi,

On Sun, Jun 29, 2025 at 10:22:21PM +0200, Thomas Perale wrote:
> Starting GCC14 'implicit-function-declaration' are treated as errors by
> default. When building kvmtool with musl libc, the following error
> occurs due to missing declaration of 'basename':
> 
> vfio/core.c:537:22: error: implicit declaration of function ‘basename’ [-Wimplicit-function-declaration]
>   537 |         group_name = basename(group_path);
>       |                      ^~~~~~~~
> vfio/core.c:537:22: warning: nested extern declaration of ‘basename’ [-Wnested-externs]
> vfio/core.c:537:20: error: assignment to ‘char *’ from ‘int’ makes pointer from integer without a cast [-Wint-conversion]
>   537 |         group_name = basename(group_path);
>       |                    ^
> 
> This patch fixes the issue by including the appropriate header, ensuring
> compatibility with musl and GCC14.
> 
> Signed-off-by: Thomas Perale <thomas.perale@mind.be>
> Signed-off-by: Thomas Perale <perale.thomas@gmail.com>
> ---
>  vfio/core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/vfio/core.c b/vfio/core.c
> index 3ff2c0b..8f88489 100644
> --- a/vfio/core.c
> +++ b/vfio/core.c
> @@ -3,6 +3,7 @@
>  #include "kvm/ioport.h"
>  
>  #include <linux/list.h>
> +#include <libgen.h>

Looking at man 3 basename, there are two version of basename, one is the POSIX
version (this is the one you get by including libgen.h), the other one is the
GNU version.  I don't think kvmtool cares about the differences (group_path is
never '/', and it's not a static string), so if the POSIX version makes
compilation with musl possible:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Also checked that this is the only occurence of basename in the sources.

Thanks,
Alex

>  
>  #define VFIO_DEV_DIR		"/dev/vfio"
>  #define VFIO_DEV_NODE		VFIO_DEV_DIR "/vfio"
> -- 
> 2.50.0
> 
> 

