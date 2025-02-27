Return-Path: <kvm+bounces-39573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A2B1DA47ED8
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 14:19:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2AC101895B17
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 13:17:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41BE622FE05;
	Thu, 27 Feb 2025 13:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KQQf0wJ/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C6117A305;
	Thu, 27 Feb 2025 13:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740662257; cv=none; b=mPYgadH+4VFq/1B3NvLBXK6Z0LYhl6wK7s8AJSTTdidISFTN2K+oofG5aVR9Ka5QKD6sfvSMJb36rsOD2U7uI6vy5tjxyufbInIUY/17dhvamTjCyOHduLITez/qIJunB5udsz63Tfh1Yzh0JGYP35KqzOObWQ/vNJcAix0qnbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740662257; c=relaxed/simple;
	bh=toSHPZ1YVa1gl//0kRiyLUjjHt9nXx8rDY0Mkemm0Mc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u5xZB48f6YgmP/Nc5+rxRM5+iMR0TQ7/MO3SIGzk+reQx4luNgP9b76WcHtJ45Gv9BDlnN5SatbcyLIDiD7tzSc7Sj1TPd/jKnb/Yje+cXexPhykInK3J1w/+JxCZlxT9eyuhiXLGTLfYiCD8AcmHaF9c5R2mZMrlF2MjmmhOyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KQQf0wJ/; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740662256; x=1772198256;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=toSHPZ1YVa1gl//0kRiyLUjjHt9nXx8rDY0Mkemm0Mc=;
  b=KQQf0wJ/MoVgzYrn//vvFyFlDbMGCmtaatMheq1icKYMMl3WBPqWx4to
   JgkxXQ/iOQu6LXdps7fqgAPUzpGy7XnqEPRhLMxH5WvuactwFDePLEeL4
   reAzqlZUD4alXZwA1LCJ3A5RHcywkzTkVNuZMagSjXgQbWKtpOmmBuHLW
   XZePs3hI00g5AXhySiw4YtRNVCqUO+04cfhX9ZDQWGmm8qC/zH7lznF+t
   j/38W0Rd7nDlDm+AdLz39q32lF3VTycFacLJolB2/tbZSfeLYUwfpap38
   +TSdilXJVSS/oGRKDpUhUxlzEjngjujMmQ1a9DOq9U56QU64bIGtgmJ9b
   A==;
X-CSE-ConnectionGUID: ZmQBd14vTDWxYnDPX2vT5Q==
X-CSE-MsgGUID: xjNWp1vhSX+U9nBf7XB2HQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="41433033"
X-IronPort-AV: E=Sophos;i="6.13,319,1732608000"; 
   d="scan'208";a="41433033"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 05:17:34 -0800
X-CSE-ConnectionGUID: sGPlddMNR0G8ZteOUDv6gg==
X-CSE-MsgGUID: QI2K/LkMQjKqVmN4JfZORA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="154208682"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa001.jf.intel.com with ESMTP; 27 Feb 2025 05:17:28 -0800
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id AD1B92D5; Thu, 27 Feb 2025 15:17:26 +0200 (EET)
Date: Thu, 27 Feb 2025 15:17:26 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Juergen Gross <jgross@suse.com>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Jan Kiszka <jan.kiszka@siemens.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Daniel Lezcano <daniel.lezcano@linaro.org>, John Stultz <jstultz@google.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-hyperv@vger.kernel.org, xen-devel@lists.xenproject.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Nikunj A Dadhania <nikunj@amd.com>
Subject: Re: [PATCH v2 30/38] x86/paravirt: Don't use a PV sched_clock in
 CoCo guests with trusted TSC
Message-ID: <okuuhll3ymxlvno46dlimlpnkhg5vcxm2jiaew7uce4f35sps3@xaommgjd447m>
References: <20250227021855.3257188-1-seanjc@google.com>
 <20250227021855.3257188-31-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250227021855.3257188-31-seanjc@google.com>

On Wed, Feb 26, 2025 at 06:18:46PM -0800, Sean Christopherson wrote:
> Silently ignore attempts to switch to a paravirt sched_clock when running
> as a CoCo guest with trusted TSC.  In hand-wavy theory, a misbehaving
> hypervisor could attack the guest by manipulating the PV clock to affect
> guest scheduling in some weird and/or predictable way.  More importantly,
> reading TSC on such platforms is faster than any PV clock, and sched_clock
> is all about speed.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kernel/paravirt.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
> index a3a1359cfc26..c538c608d9fb 100644
> --- a/arch/x86/kernel/paravirt.c
> +++ b/arch/x86/kernel/paravirt.c
> @@ -89,6 +89,15 @@ DEFINE_STATIC_CALL(pv_sched_clock, native_sched_clock);
>  int __init __paravirt_set_sched_clock(u64 (*func)(void), bool stable,
>  				      void (*save)(void), void (*restore)(void))
>  {
> +	/*
> +	 * Don't replace TSC with a PV clock when running as a CoCo guest and
> +	 * the TSC is secure/trusted; PV clocks are emulated by the hypervisor,
> +	 * which isn't in the guest's TCB.
> +	 */
> +	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC) ||
> +	    boot_cpu_has(X86_FEATURE_TDX_GUEST))
> +		return -EPERM;
> +

Looks like a call for generic CC_ATTR_GUEST_SECURE_TSC that would be true
for TDX and SEV with CC_ATTR_GUEST_SNP_SECURE_TSC.

>  	if (!stable)
>  		clear_sched_clock_stable();
>  
> -- 
> 2.48.1.711.g2feabab25a-goog
> 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

