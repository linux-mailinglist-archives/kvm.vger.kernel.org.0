Return-Path: <kvm+bounces-43045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C068EA836F7
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 05:03:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67B144443E2
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 03:03:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BF3C1EA7F4;
	Thu, 10 Apr 2025 03:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="STSa3Rgq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEC84C9D;
	Thu, 10 Apr 2025 03:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744254208; cv=none; b=DyDacfrxV93PxV/jvJWSPEl2igMJVUiDntzBd5nIG9W+lBxyR152ZIiguVRSq3/Wcy3G+soN+HG8TudA0SfyvtGl+fmKBLB/LpmCOXete77k1J3WH2WicwqZhJCg0N98a2F1U+Xs89VqnW9XoRXP1kxUZBF8VpzM+D6jILrHzhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744254208; c=relaxed/simple;
	bh=O9I0+J35A+cZCeUgQWA6kZXE8j9emV43n4j/o0l0jew=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ge+e/qVNK+gKvaM59Pdfb+928nttJpqQRNYhqkkBn36qLsqgwjOnA1PVejvgHKqLIjmnILrDGStQ1X/k/6h57unSg4QgkXedHVfq88DC5xJGzWJweoUhHcGvTSVNDkG3s4xPPw+3nTAFegiuH1aP8sf86D5CKdkyDNOQTWqyDeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=STSa3Rgq; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744254206; x=1775790206;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=O9I0+J35A+cZCeUgQWA6kZXE8j9emV43n4j/o0l0jew=;
  b=STSa3RgqVkK28RnDdbMjGR4z1CuOvAVSKdlSw1/k9/bpZfh8MHLszoCD
   QWi9s/ChqOcbHeFMSWp706BcrST5bpIqY7RmAHrLkqOnZHhrfSSxeANii
   o5izFyj6bofh03FaBDjfl5aJVHN7fSizTzIiqIUMrv6pgIc6VfhP2SRVT
   9QrcnJwAJBgDsqQaDv2EFuj57pxqcdJWJI92N8odT5wc6i7IaqAkOyq3Z
   krVjeWauxyP3iyz+xBSYns5xFM7qHKltsXDqQVCTGSAvWfnV5WdWTPoSF
   ixxD/8KksQ3fWBrCNQItmwqHkozp480LRv10HepQS4BdD7dndezb+fdWV
   A==;
X-CSE-ConnectionGUID: pyU+lGkXSnCHcezq8PsrKA==
X-CSE-MsgGUID: Y3Y/07IlR36p0rAg0uaovg==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="56736309"
X-IronPort-AV: E=Sophos;i="6.15,201,1739865600"; 
   d="scan'208";a="56736309"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 20:03:26 -0700
X-CSE-ConnectionGUID: l1lzOau0TkaMmIqROxFXzg==
X-CSE-MsgGUID: HRIiJbvqTOWiDNn7i+TQTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,201,1739865600"; 
   d="scan'208";a="165983640"
Received: from yuntin1x-mobl1.ccr.corp.intel.com (HELO [10.238.11.203]) ([10.238.11.203])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 20:03:24 -0700
Message-ID: <f1445168-3a14-45da-a39b-3009b69f7b8d@linux.intel.com>
Date: Thu, 10 Apr 2025 11:03:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Documentation/virt/kvm: Fix TDX whitepaper footnote
 reference
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Documentation <linux-doc@vger.kernel.org>,
 Linux KVM <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Jonathan Corbet <corbet@lwn.net>, Isaku Yamahata <isaku.yamahata@intel.com>,
 Stephen Rothwell <sfr@canb.auug.org.au>
References: <20250410014057.14577-1-bagasdotme@gmail.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250410014057.14577-1-bagasdotme@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/10/2025 9:40 AM, Bagas Sanjaya wrote:
> Sphinx reports unreferenced footnote warning on TDX docs:
>
> Documentation/virt/kvm/x86/intel-tdx.rst:255: WARNING: Footnote [1] is not referenced. [ref.footnote]
>
> Fix footnote reference to the TDX docs on Intel website to squash away
> the warning.
>
> Fixes: 52f52ea79a4c ("Documentation/virt/kvm: Document on Trust Domain Extensions (TDX)")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Closes: https://lore.kernel.org/linux-next/20250409131356.48683f58@canb.auug.org.au/
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

And thanks for the fix.

> ---
>   Documentation/virt/kvm/x86/intel-tdx.rst | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
> index de41d4c01e5c68..2ab90131a6402a 100644
> --- a/Documentation/virt/kvm/x86/intel-tdx.rst
> +++ b/Documentation/virt/kvm/x86/intel-tdx.rst
> @@ -11,7 +11,7 @@ host and physical attacks.  A CPU-attested software module called 'the TDX
>   module' runs inside a new CPU isolated range to provide the functionalities to
>   manage and run protected VMs, a.k.a, TDX guests or TDs.
>   
> -Please refer to [1] for the whitepaper, specifications and other resources.
> +Please refer to [1]_ for the whitepaper, specifications and other resources.
>   
>   This documentation describes TDX-specific KVM ABIs.  The TDX module needs to be
>   initialized before it can be used by KVM to run any TDX guests.  The host
>
> base-commit: fd02aa45bda6d2f2fedcab70e828867332ef7e1c


