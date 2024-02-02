Return-Path: <kvm+bounces-7850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DC73846EA6
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 12:07:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7EFF21C236C4
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 11:07:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6578413D51A;
	Fri,  2 Feb 2024 11:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ho5GDTwl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293F73CF68;
	Fri,  2 Feb 2024 11:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706872012; cv=none; b=lCmDh4pCq4kilULhjnm9/0OsXHsLQl9NOzhqjqkj9qTSTODfFhCDubH3PiufU7QcmyguX2gDTRnJhuRKY8eoR0QIIrde8wvtLNEjH/BMDUngh/FgBYoPkEzMF5FTkzNTSn/EfJifxr4dZImyHXDqSOQQxChssNM7N2rxLQBASDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706872012; c=relaxed/simple;
	bh=BVUwIZJrucltWjChM5sdx0WIRPV1ARt3HSFLPgQ09cY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N17Eqxwb7fWOom6HdLhodXPggJZq8gdpzHwsg++IN3rEqM6uZGhiJLVnvMuH2JpF4NhJq8JmgLLVgenvekpFPlMQ59D/M0RLBUBXiELKP5EYSQXubUQuPizH0+dXMrK4l+qTm0WDEMZWiXF5QitINgMaI1XauPAjRtxRgJ1Re3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ho5GDTwl; arc=none smtp.client-ip=192.55.52.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706872011; x=1738408011;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BVUwIZJrucltWjChM5sdx0WIRPV1ARt3HSFLPgQ09cY=;
  b=ho5GDTwlMBGA+gxEOrHI1BJSeGJch+F/5a9MWfwkWkiZsY1pG+sNxSFa
   QJgPEM7Cb4vNsWFdX6xmgY8/LKkU6kUAfBgGUm7MaALnnJz9YYrotcHx9
   HCden4/w6670/kmJmXWiPZtW4I20/RpDVZv56lCa2lqdciiV9/SeOOO/f
   3a33ryFZep9FlEunf9puODelaEbW67OJNErugIKBMfwb8hr6+zXkm/5nS
   mSPo7YSUmVK8mOJ638I1+sAWRxqOYBAm1m803zVH1HUsa0BUzc+aWyvFo
   yOoS1AoDSNpdAhoR3ceLBE34CNCsZISrjQ9K6zypqTVE93NloN2WeZHtS
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="435276218"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="435276218"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 03:06:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="908542663"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="908542663"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 02 Feb 2024 03:06:46 -0800
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 40191128; Fri,  2 Feb 2024 12:30:29 +0200 (EET)
Date: Fri, 2 Feb 2024 12:30:29 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Wanpeng Li <wanpengli@tencent.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Rientjes <rientjes@google.com>, llvm@lists.linux.dev
Subject: Re: [PATCH, RESEND] x86/sev: Fix SEV check in sev_map_percpu_data()
Message-ID: <lbs5nwm2teoc3ihnht3kt5xdgwjktufjybdpx2cvzmovxtkp26@5txa5ye7mzpa>
References: <20240124130317.495519-1-kirill.shutemov@linux.intel.com>
 <20240201193809.GA2710596@dev-arch.thelio-3990X>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240201193809.GA2710596@dev-arch.thelio-3990X>

On Thu, Feb 01, 2024 at 12:38:09PM -0700, Nathan Chancellor wrote:
> Perhaps another solution would be to just
> 
>   #define cc_vendor (CC_VENDOR_NONE)
> 
> if CONFIG_ARCH_HAS_CC_PLATFORM is not set, since it can never be changed
> from the default in arch/x86/coco/core.c.

I think this approach is cleaner.

Could you post a proper patch?

> 
> diff --git a/arch/x86/include/asm/coco.h b/arch/x86/include/asm/coco.h
> index 6ae2d16a7613..f3909894f82f 100644
> --- a/arch/x86/include/asm/coco.h
> +++ b/arch/x86/include/asm/coco.h
> @@ -10,13 +10,13 @@ enum cc_vendor {
>  	CC_VENDOR_INTEL,
>  };
>  
> -extern enum cc_vendor cc_vendor;
> -
>  #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
> +extern enum cc_vendor cc_vendor;
>  void cc_set_mask(u64 mask);
>  u64 cc_mkenc(u64 val);
>  u64 cc_mkdec(u64 val);
>  #else
> +#define cc_vendor (CC_VENDOR_NONE)
>  static inline u64 cc_mkenc(u64 val)
>  {
>  	return val;
> 
> Cheers,
> Nathan
> 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

