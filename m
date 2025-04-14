Return-Path: <kvm+bounces-43249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8055DA88581
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 16:45:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3DB01190046F
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 14:39:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60B5E28E610;
	Mon, 14 Apr 2025 14:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QUA7AlVw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF17825393E;
	Mon, 14 Apr 2025 14:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744640346; cv=none; b=eCoG/RLmAhLvtXHTxGZ68Px3ky61385KsvWiW9VaepqxzgAZ3A0lZMMMREg7vtiH8dGVMyzMi8JC2vpukuXJIUt5yNHFosvSbIpAEvUDdf7cnZFSZcR+HIRVb1fxWQQlLPamPHFu3AsUTpndlKKLIKXuUVPRD8MwdMX1CMoW4dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744640346; c=relaxed/simple;
	bh=ZGi0N7JihKaxW674HLf7YHreoEQlnROr2bpo9jFgkBk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ACUrKkOerBbAr83hIlllfIo1GuaKqbl3Y/mmNaYIvyy24WkgY/aRSDK1X2XpQTdB1m6Pt8VnT3KCa1JGMq0Dl1CBhsHWH2qH+2EiI1s/ToYCHWFeY5pww1+JCo3uF0DvepMkaUpCLD0TYgaS/e7fuFg4ST283OCLcjanEIH+Yfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QUA7AlVw; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744640345; x=1776176345;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZGi0N7JihKaxW674HLf7YHreoEQlnROr2bpo9jFgkBk=;
  b=QUA7AlVwIvji7X2oQkm5MguJFZFv6Ya9MvgWHHoBS8GjYXdD2qtgZ4OD
   dGksD8F5iix/KeoRnxu/Bg2HeY6EZ5GAOBB1VBMIYOcWkHJ4MObfbzewx
   EZUscpRcw7PkNVCBMgnNBYLGOIiVtLxR3Mef+zyl3Rst1BB/MuaxocTJI
   uVmMg1Wb3abEFoPJUwiMw1/5DBjN3JALFczxzY0+hjiqTJutfppogvJtY
   Lw3yyAQnR+Yoi4ZJHoNMgw4SCxJWmi7Jr6Mxba2arOV84DcWIV2fOwnAr
   uhIC4MML94sUbylrApSulhWz5EQc7ddB3Wk2WwSe/nJ+F1AjNokUdRc3c
   w==;
X-CSE-ConnectionGUID: APLhuhZPRqmDiM+cvhAWGg==
X-CSE-MsgGUID: wvrQDerTTKuIpcUfMoS8BQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11403"; a="46121904"
X-IronPort-AV: E=Sophos;i="6.15,212,1739865600"; 
   d="scan'208";a="46121904"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 07:19:04 -0700
X-CSE-ConnectionGUID: iD5gBL39T6eCeoWX3qQdxA==
X-CSE-MsgGUID: vxa1uwQ/TFKThLpIjYggyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,212,1739865600"; 
   d="scan'208";a="130383960"
Received: from johunt-mobl9.ger.corp.intel.com (HELO [10.124.222.39]) ([10.124.222.39])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 07:19:03 -0700
Message-ID: <a641e123-be70-41ab-b0ce-6710d7fd0c2d@intel.com>
Date: Mon, 14 Apr 2025 07:19:02 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [tip: x86/urgent] x86/e820: Discard high memory that can't be
 addressed by 32-bit systems
To: linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Cc: Arnd Bergmann <arnd@kernel.org>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Ingo Molnar
 <mingo@kernel.org>, Andy Shevchenko <andy@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Davide Ciminaghi <ciminaghi@gnudd.com>,
 "H. Peter Anvin" <hpa@zytor.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, x86@kernel.org
References: <20250413080858.743221-1-rppt@kernel.org>
 <174453620439.31282.5525507256376485910.tip-bot2@tip-bot2>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <174453620439.31282.5525507256376485910.tip-bot2@tip-bot2>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/13/25 02:23, tip-bot2 for Mike Rapoport (Microsoft) wrote:
> +	/*
> +	 * 32-bit systems are limited to 4BG of memory even with HIGHMEM and
> +	 * to even less without it.
> +	 * Discard memory after max_pfn - the actual limit detected at runtime.
> +	 */
> +	if (IS_ENABLED(CONFIG_X86_32))
> +		memblock_remove(PFN_PHYS(max_pfn), -1);

Mike, thanks for the quick fix! I did verify that this gets my silly
test VM booting again.

The patch obviously _works_. But in the case I was hitting max_pfn was
set MAX_NONPAE_PFN. The unfortunate part about this hunk is that it's
far away from the related warning:

>         if (max_pfn > MAX_NONPAE_PFN) {
>                 max_pfn = MAX_NONPAE_PFN;
>                 printk(KERN_WARNING MSG_HIGHMEM_TRIMMED);
>         }

and it's logically doing the same thing: truncating memory at
MAX_NONPAE_PFN.

How about we reuse 'MAX_NONPAE_PFN' like this:

	if (IS_ENABLED(CONFIG_X86_32))
		memblock_remove(PFN_PHYS(MAX_NONPAE_PFN), -1);

Would that make the connection more obvious?

