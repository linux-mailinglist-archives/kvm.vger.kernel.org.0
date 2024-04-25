Return-Path: <kvm+bounces-15949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F11E68B26C6
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 18:46:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEC9E2831FF
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 16:46:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDC8F14D457;
	Thu, 25 Apr 2024 16:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jti/QiDy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE83149E0E;
	Thu, 25 Apr 2024 16:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714063590; cv=none; b=LdDq0enzlP66UDfkvVSP7ZZ0D6KsE4CdKq41tGGiEmq62fsDdSiTyq6j8jF25io5xpU07Le2Ax7tQBHHqUMA8U8LpaPGwAoou8zzA4d9f0qhlYVaBQoDVYDLLXTeVVbGz7I3DXxiYeq0ZsspAljIO//2rpxAvgjlJHcqVZ/l95k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714063590; c=relaxed/simple;
	bh=ysF7TXAsd4zm/OuIu16TsdOJ8lw2epFcOFfDOSyjUUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j1r6OE3Q97pJ2kw57vShPqVOr4C85rIwE3JUAxQAwYlWuoTlWqq29dlG/G/2iEfSGWs3jfKxirJb8gialo5P8FK/MzB87JbqghmOeSp/7aOH52osBKPsp+V42r03PxNHQhKWHwMGDp+ffV8Sb1wmMcyx1pKoYOcFYisazGC96tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jti/QiDy; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714063587; x=1745599587;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ysF7TXAsd4zm/OuIu16TsdOJ8lw2epFcOFfDOSyjUUs=;
  b=Jti/QiDyH1ceRRyVrlZYBoPVo7Pr++JbhwccBpnPaI5A+AQwhlM3P6T9
   CPUmIYzpwqVOpe8rXWxqZ8iGTNaWMVHqcapafKRqzd2PWFyzxX+tXs974
   M9PPoEHd5hC3cDK962gqfAvtP4V/E9yPU7iHskQS1dBhVHL5GgJELUjD3
   DIbxtlS1oDcQF8Vmzj96AJGSQOUuoEJB/Z4j2GU8dBq+9oVSafryIEdSm
   sS9+q9DP1Yk8wPn2wRoO+s9thty9oKm9Rk/xDd3qghUUupP/mxYc9ZZmE
   KYXbiBvq8WK4+LWvwWmumVbyHrSQ/xi+YevcarnP4M13EVgjSA2cklZUg
   g==;
X-CSE-ConnectionGUID: ZIAN8y6uQxWivzKykqrgCw==
X-CSE-MsgGUID: 9ceAPrpGQYuLYV1xCytXGA==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="9592438"
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="9592438"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 09:46:26 -0700
X-CSE-ConnectionGUID: rMgnQaGYRO2JqGOTe9UkHw==
X-CSE-MsgGUID: hrs+5haTSKW8KY+vWSbgNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="25226349"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa010.fm.intel.com with ESMTP; 25 Apr 2024 09:46:23 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id D8DAF288; Thu, 25 Apr 2024 19:46:21 +0300 (EEST)
Date: Thu, 25 Apr 2024 19:46:21 +0300
From: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	Tina Zhang <tina.zhang@intel.com>, Dave Hansen <dave.hansen@intel.com>, 
	Hang Yuan <hang.yuan@intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	Kai Huang <kai.huang@intel.com>, Bo2 Chen <chen.bo@intel.com>, 
	"sagis@google.com" <sagis@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Erdem Aktas <erdemaktas@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
Message-ID: <faopalgfi6wwphg5ufki6nkwl54tsmzp3nvwgtwksg7fwktsti@zqhlij7ndyfl>
References: <e6e8f585-b718-4f53-88f6-89832a1e4b9f@intel.com>
 <bd21a37560d4d0695425245658a68fcc2a43f0c0.camel@intel.com>
 <54ae3bbb-34dc-4b10-a14e-2af9e9240ef1@intel.com>
 <ZfR4UHsW_Y1xWFF-@google.com>
 <ay724yrnkvsuqjffsedi663iharreuu574nzc4v7fc5mqbwdyx@6ffxkqo3x5rv>
 <39e9c5606b525f1b2e915be08cc95ac3aecc658b.camel@intel.com>
 <m536wofeimei4wdronpl3xlr3ljcap3zazi3ffknpxzdfbrzsr@plk4veaz5d22>
 <ZiFlw_lInUZgv3J_@google.com>
 <7otbchwoxaaqxoxjfqmifma27dmxxo4wlczyee5pv2ussguwyw@uqr2jbmawg6b>
 <ZiLLrzGqSIxoirwx@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZiLLrzGqSIxoirwx@google.com>

On Fri, Apr 19, 2024 at 12:53:19PM -0700, Sean Christopherson wrote:
> > But I guess we can make a *few* wrappers that covers all needed cases.
> 
> Yeah.  I suspect two will suffice.  One for the calls that say at or below four
> inputs, and one for the fat ones like ReportFatalError that use everything under
> the sun.

I ended up with three helpers:

  - tdvmcall_trampoline() as you proposed.
  
  - tdvmcall_report_fatal_error() that does ReportFatalError specificly.
    Pointer to char array as an input. Never returns: no need to
    save/restore registers.

  - hv_tdx_hypercall(). Hyper-V annoyingly uses R8 and RDX as parameters :/

> Not sure, haven't looked at them recently.  At a glance, something similar?  The
> use of high registers instead of RDI and RSI is damn annoying :-/

I defined three helpers: TDCALL_0(), TDCALL_1() and TDCALL_5(). All takes 4
input arguments.

I've updated the WIP branch with the new version:

https://github.com/intel/tdx/commits/guest-tdx-asm/

Any feedback is welcome.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

