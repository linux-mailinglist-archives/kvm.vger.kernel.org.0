Return-Path: <kvm+bounces-385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F1DB07DF29F
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 13:39:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2DFD61C20F3D
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 12:39:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B27E53B9;
	Thu,  2 Nov 2023 12:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iQ+de6Cu"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F02523BF
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 12:39:04 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A571F18A;
	Thu,  2 Nov 2023 05:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698928739; x=1730464739;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=76z3Un6rKgu/Gfrm6QEwK9fIGnZpQFZgYPQm9HswN+g=;
  b=iQ+de6CuGtch6oDMHFQDy89/yxmwmDtYhT607T0OLBoR/8PQrbqG3lbZ
   r8KFmuXLiwzuugFXdjXXI5DMRumdsydU5Dq/QHe+nDt/yR1w1hp4SPrFF
   Ao72LR7/+2E03tWl8SiRnJTvixnyOp1n9cUbZFT+KBNno2jYQHTAvbPg8
   ktPBMKVlfYpTSXM54e1fOwhznvFW18hk2GgZahmnE3/wcEZKnBczIRHeb
   6bVQgxRsVjcLJcjcP+0q/T5HBsgahyMcNj1rVoCmp/K4WCCGo/LGn3pU3
   i5rRyBPnLtSYBs9LZbDYMdK3RMBUbwHC67VoS/xH20ThGmZ0qn/xMJ83W
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10881"; a="7342530"
X-IronPort-AV: E=Sophos;i="6.03,271,1694761200"; 
   d="scan'208";a="7342530"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2023 05:38:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10881"; a="764901219"
X-IronPort-AV: E=Sophos;i="6.03,271,1694761200"; 
   d="scan'208";a="764901219"
Received: from arajan-mobl.amr.corp.intel.com (HELO box.shutemov.name) ([10.251.215.101])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2023 05:38:54 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
	id 01E1210A312; Thu,  2 Nov 2023 15:38:51 +0300 (+03)
Date: Thu, 2 Nov 2023 15:38:51 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: "Nikunj A. Dadhania" <nikunj@amd.com>, seanjc@google.com,
	pbonzini@redhat.com
Cc: Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
	thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
	bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, dionnaglaze@google.com,
	pgonda@google.com
Subject: Re: [PATCH v5 13/14] x86/tsc: Mark Secure TSC as reliable clocksource
Message-ID: <20231102123851.jsdolkfz7sd3jys7@box>
References: <20231030063652.68675-1-nikunj@amd.com>
 <20231030063652.68675-14-nikunj@amd.com>
 <57d63309-51cd-4138-889d-43fbdf5ec790@intel.com>
 <ae267e31-5722-4784-9146-28bb13ca7cf5@amd.com>
 <20231102103306.v7ydmrobd5ibs4yn@box.shutemov.name>
 <5d8040b2-c761-4cea-a2ec-39319603e94a@amd.com>
 <cf92b26e-d940-4dc8-a339-56903952cee2@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf92b26e-d940-4dc8-a339-56903952cee2@amd.com>

On Thu, Nov 02, 2023 at 05:46:26PM +0530, Nikunj A. Dadhania wrote:
> On 11/2/2023 5:37 PM, Nikunj A. Dadhania wrote:
> > On 11/2/2023 4:03 PM, Kirill A. Shutemov wrote:
> >> On Thu, Nov 02, 2023 at 11:23:34AM +0530, Nikunj A. Dadhania wrote:
> >>> On 10/30/2023 10:48 PM, Dave Hansen wrote:
> >>>> On 10/29/23 23:36, Nikunj A Dadhania wrote:
> >>>> ...
> >>>>> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> >>>>> index 15f97c0abc9d..b0a8546d3703 100644
> >>>>> --- a/arch/x86/kernel/tsc.c
> >>>>> +++ b/arch/x86/kernel/tsc.c
> >>>>> @@ -1241,7 +1241,7 @@ static void __init check_system_tsc_reliable(void)
> >>>>>  			tsc_clocksource_reliable = 1;
> >>>>>  	}
> >>>>>  #endif
> >>>>> -	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE))
> >>>>> +	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE) || cc_platform_has(CC_ATTR_GUEST_SECURE_TSC))
> >>>>>  		tsc_clocksource_reliable = 1;
> >>>>
> >>>> Why can't you just set X86_FEATURE_TSC_RELIABLE?
> >>>
> >>> Last time when I tried, I had removed my kvmclock changes and I had set
> >>> the X86_FEATURE_TSC_RELIABLE similar to Kirill's patch[1], this did not
> >>> select the SecureTSC.
> >>>
> >>> Let me try setting X86_FEATURE_TSC_RELIABLE and retaining my patch for
> >>> skipping kvmclock.
> >>
> >> kvmclock lowers its rating if TSC is good enough:
> >>
> >> 	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
> >> 	    boot_cpu_has(X86_FEATURE_NONSTOP_TSC) &&
> >> 	    !check_tsc_unstable())
> >> 		kvm_clock.rating = 299;
> >>
> >> Does your TSC meet the requirements?
> > 
> > I have set TscInvariant (bit 8) in CPUID_8000_0007_edx and TSC is set as reliable.
> > 
> > With this I see kvm_clock rating being lowered, but kvm-clock is still being picked as clock-source.
> 
> Ah.. at later point TSC is picked up, is this expected ?
> 
> [    2.564052] clocksource: Switched to clocksource kvm-clock
> [    2.678136] clocksource: Switched to clocksource tsc

On bare metal I see switch from tsc-early to tsc. tsc-early rating is
equal to kvmclock rating after it gets lowered.

Maybe kvmclock rating has to be even lower after detecting sane TSC?

Sean, Paolo, any comments?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

