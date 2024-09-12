Return-Path: <kvm+bounces-26735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4106976D82
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 17:18:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BEE828DABC
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 15:18:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E47A1BB6AB;
	Thu, 12 Sep 2024 15:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F6DKnAzs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0B13D556;
	Thu, 12 Sep 2024 15:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726154071; cv=none; b=NP4kEkyu/j/LPZP+LGwsRsESyiNH2EhH32zkUY3lz1LjVdIGTfdq/7n4/uJW7hgAfEOTpNpFLZdCBcp+9bAasbihVe4+gPiThXk/kJmRrOMlAqBKLyjHt3JZjiFsY2nMCGlS7KSQyX3+o75z5ssdtZUjIN4jnTYWProWwuEjFzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726154071; c=relaxed/simple;
	bh=OqYBncCOsRFJXj2W2xLk61t0Etw1t1e+BtsalnxHR1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IVHPxdIR+HA4VwE6w5aQMv7qDeFVep9mgL8Q7by/m/uKYwpSGyC9Su8zmuhXXJaCnnL1oBF2L+R4e6zzxrKAFiVjAr4gy87ye3SwLFeTUSL9n8bNKHIHbtgt2ASTLC6WpmL4eCE4erpLty440OpQN4m7LNPB/+GTT4avNgGUwOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F6DKnAzs; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726154070; x=1757690070;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OqYBncCOsRFJXj2W2xLk61t0Etw1t1e+BtsalnxHR1Q=;
  b=F6DKnAzsuKJT9G/o268PKW5RSdelMwIBtOPwqbVsIwrFF1MGZgT8P5E+
   IYq4RL9m7UmJRhe31BVjUZosia2oGtjKB79icexg5hiuA2VJG2/zvjvUj
   KVnpKh0W7eYOkDsP71Z9tuKQsC0iFt5I9RpCC6V7ArwqsaD2uTinK0/+b
   wLzxHdBSVvaa0C4f3R4YAEw54LoHT0yjxbs0nNd8lJKDG7N3huqxtVI3n
   HGlpacbGPi0ujdNKzAERRCjcFAvzjmJpJ/IqdOhrGUcwsb0/1X7EYl9f7
   y+M4mas3t/9ywQ1ghbpCrBUWugdTJrfPZ+RP70TfqqAqyWZscNabmYa/+
   w==;
X-CSE-ConnectionGUID: QH8H2HB8R1KfgXJ26dj8SA==
X-CSE-MsgGUID: JnfoxkNSQj+x0ULZJQpnDQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11193"; a="42531125"
X-IronPort-AV: E=Sophos;i="6.10,223,1719903600"; 
   d="scan'208";a="42531125"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 08:14:23 -0700
X-CSE-ConnectionGUID: peLbucsgSMaypBL1ZUmDUw==
X-CSE-MsgGUID: LMTRJlOQQMOFhvuZE4d7Ag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,223,1719903600"; 
   d="scan'208";a="71854677"
Received: from merlinax-mobl.amr.corp.intel.com (HELO desk) ([10.125.147.150])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 08:14:22 -0700
Date: Thu, 12 Sep 2024 08:14:10 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Jon Kohler <jon@nutanix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH] x86/bhi: avoid hardware mitigation for
 'spectre_bhi=vmexit'
Message-ID: <20240912151410.bazw4tdc7dugtl6c@desk>
References: <20240912141156.231429-1-jon@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240912141156.231429-1-jon@nutanix.com>

On Thu, Sep 12, 2024 at 07:11:56AM -0700, Jon Kohler wrote:
> On hardware that supports BHI_DIS_S/X86_FEATURE_BHI_CTRL, do not use
> hardware mitigation when using BHI_MITIGATION_VMEXIT_ONLY, as this
> causes the value of MSR_IA32_SPEC_CTRL to change, which inflicts
> additional KVM overhead.
> 
> Example: In a typical eIBRS enabled system, such as Intel SPR, the
> SPEC_CTRL may be commonly set to val == 1 to reflect eIBRS enablement;
> however, SPEC_CTRL_BHI_DIS_S causes val == 1025. If the guests that
> KVM is virtualizing do not also set the guest side value == 1025,
> KVM will constantly have to wrmsr toggle the guest vs host value on
> both entry and exit, delaying both.
> 
> Signed-off-by: Jon Kohler <jon@nutanix.com>
> ---
>  arch/x86/kernel/cpu/bugs.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index 45675da354f3..df7535f5e882 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -1662,8 +1662,16 @@ static void __init bhi_select_mitigation(void)
>  			return;
>  	}
>  
> -	/* Mitigate in hardware if supported */
> -	if (spec_ctrl_bhi_dis())
> +	/*
> +	 * Mitigate in hardware if appropriate.
> +	 * Note: for vmexit only, do not mitigate in hardware to avoid changing
> +	 * the value of MSR_IA32_SPEC_CTRL to include SPEC_CTRL_BHI_DIS_S. If a
> +	 * guest does not also set their own SPEC_CTRL to include this, KVM has
> +	 * to toggle on every vmexit and vmentry if the host value does not
> +	 * match the guest value. Instead, depend on software loop mitigation
> +	 * only.
> +	 */
> +	if (bhi_mitigation != BHI_MITIGATION_VMEXIT_ONLY && spec_ctrl_bhi_dis())
>  		return;

This makes the system vulnerable. The current software loop is not
effective on parts that support BHI_DIS_S. There is a separate loop for
SPR, see Listing 2(long sequence) in Software BHB-clearing sequence
section here:

  https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/branch-history-injection.html

It is only worth implementing the long sequence in VMEXIT_ONLY mode if it is
significantly better than toggling the MSR.

