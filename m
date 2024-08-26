Return-Path: <kvm+bounces-25079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9747B95FAB6
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 22:33:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B2B628396E
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 20:33:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EFF419AA4E;
	Mon, 26 Aug 2024 20:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FqzNZqQr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A48713A3F6;
	Mon, 26 Aug 2024 20:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724704398; cv=none; b=V/oJpUgI7KLm7vY+2st3xZQJ6Uo/Z3kEdpWqfaY/Abl+zVJ/cEFdMhilufJUzg2dwKdz0+PhGRUjrniWgOem/+mPl/MgbikBNLfze5FXrZJ5kCZpbbquoGsoxcVznkDqjYG4HxPuP3dUzDoGOcY7dHW6dT8H8IzSmCs7ZbLdKUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724704398; c=relaxed/simple;
	bh=zidfGQagCPvVo5KYzTaWkFltmj5YSwV8SyVpz4qJII0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oms5NjTueVfI+A7z7XcwV/8pl/e5nf+wfy8I+NM9oB0LedoSphxxn2BYgCYCLu096i+8TZQWq9hWIpS3cp3VRs21UhMzda2NDmSD1mz5pD8mz9XEHug4wsSdAIE3wSiXMORWiBvnn4+DaV3sRPOPkczntVpGHo/zl2cJfIuSgew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FqzNZqQr; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724704397; x=1756240397;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zidfGQagCPvVo5KYzTaWkFltmj5YSwV8SyVpz4qJII0=;
  b=FqzNZqQrGwc1dOoe26U8aRwhbS9cSalJET3N5F9WdyLMziCfDguVHZ3R
   IgAPpUOkQkgN518jJI9+cQdIvtW66M0EbU57/cRJxYAGwnJslcLpZ8Iv+
   mBAEevx6hJMDvS8KLwSAuNEGphPAbx2aqu+vEBD45xLtudj8f6rkk9qHS
   m1IxMln3Cr7/nMpiGNBK/ayJnhaBPsoXKHBhkTpUmT+cymI5aihwMNsz0
   lVPrGpfphn092SrMObcdski0BM+OJAw3sqUpuuMWyWw/kkWhQYxDrvXpg
   iEvxjaqg6yTJSzhM8M9J//V3rlgkpt+wfYk36FQRxBiiw5Tff7hYHObex
   g==;
X-CSE-ConnectionGUID: ZmJzFKDESki6kNAMtVNoqQ==
X-CSE-MsgGUID: PkIp+WRfTjKLI34TrFtDFQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11176"; a="23329888"
X-IronPort-AV: E=Sophos;i="6.10,178,1719903600"; 
   d="scan'208";a="23329888"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2024 13:33:16 -0700
X-CSE-ConnectionGUID: dbgOfCT9RbyNKfbaJt3t7Q==
X-CSE-MsgGUID: MKdPP9egTOG6zYHM6OFVSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,178,1719903600"; 
   d="scan'208";a="85822083"
Received: from jsolisoc-mobl.amr.corp.intel.com (HELO desk) ([10.125.16.169])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2024 13:33:17 -0700
Date: Mon, 26 Aug 2024 13:33:08 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Jim Mattson <jmattson@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sandipan Das <sandipan.das@amd.com>,
	Kai Huang <kai.huang@intel.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 1/4] x86/cpufeatures: Clarify semantics of
 X86_FEATURE_IBPB
Message-ID: <20240826203308.litigvo6zomwapws@desk>
References: <20240823185323.2563194-1-jmattson@google.com>
 <20240823185323.2563194-2-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823185323.2563194-2-jmattson@google.com>

On Fri, Aug 23, 2024 at 11:53:10AM -0700, Jim Mattson wrote:
> Since this synthetic feature bit is set on AMD CPUs that don't flush
> the RSB on an IBPB, indicate as much in the comment, to avoid
> potential confusion with the Intel IBPB semantics.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/include/asm/cpufeatures.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index dd4682857c12..cabd6b58e8ec 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -215,7 +215,7 @@
>  #define X86_FEATURE_SPEC_STORE_BYPASS_DISABLE	( 7*32+23) /* Disable Speculative Store Bypass. */
>  #define X86_FEATURE_LS_CFG_SSBD		( 7*32+24)  /* AMD SSBD implementation via LS_CFG MSR */
>  #define X86_FEATURE_IBRS		( 7*32+25) /* "ibrs" Indirect Branch Restricted Speculation */
> -#define X86_FEATURE_IBPB		( 7*32+26) /* "ibpb" Indirect Branch Prediction Barrier */
> +#define X86_FEATURE_IBPB		( 7*32+26) /* "ibpb" Indirect Branch Prediction Barrier without RSB flush */

I don't think the comment is accurate for Intel. Maybe you meant to modify
X86_FEATURE_AMD_IBPB?

