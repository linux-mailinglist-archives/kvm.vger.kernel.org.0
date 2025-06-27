Return-Path: <kvm+bounces-50980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8776FAEB533
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 12:42:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1CAF9189177C
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 10:43:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D96522989B5;
	Fri, 27 Jun 2025 10:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c8GATjHk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A31296169;
	Fri, 27 Jun 2025 10:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751020959; cv=none; b=g+clTwVQsYIm4OgkptBDLbK1+EqI6VbqHslKn/mtQP1me58XNkMa966G/l8BCStCBN8Q0aNb99biFxf0LModp8dcJ1FEOZogJT4ogRynv3inbAWXDNLjdFwgkJiIkSIaY0Ofw0oep9IFkuPCHxXlkpRmuFkmqZO3CgTB8kJXqoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751020959; c=relaxed/simple;
	bh=s4SNJbgVVl5wgGD5pUu4CM0at/ywNXfl1l5qwi2MZv0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HqMW/ZsJK5c15Y3M33VY4eIgxd4E0gaI4UVlBy5A9rIDy0y2L551fbCLATOqrB/q3yWsY3P+/98jEFywFPzGDjs5OxCgMnxzTvmTND2yKkF2luRbfr3fLcJZdDOZWryNkN9G4pwDcbQRZP4eqxzzpb0cfr/3Ff+DQgtQSftT2ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c8GATjHk; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751020959; x=1782556959;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=s4SNJbgVVl5wgGD5pUu4CM0at/ywNXfl1l5qwi2MZv0=;
  b=c8GATjHkP5vlWQOg262t1Rci5o+6X2nvnvhQgaLvEPwE3U7+vG3z+sZe
   vAcWRtkOjp1pHE0PlPthA6ub0OqIUsDOiEbz4/1vYCfCDclhB8Bf1PB3A
   85LE7iJF/bBBPJqReTc4Qc/yOTCu8e+8OZsvehLKGpQpXGM7UHDkK119R
   74XY+aot7y9IUztzkR1+UuOQFOp+ebjH5BMyGMX3CvTyf2W9/FKO+hEBx
   we16qFi5XSZ7to72514Iy6n0fMaz5XRXW7VW/lYHosY8Pmp4WdaOyAjk8
   Hwoa2tjGZCmmYVeehlAYHH/gDGhuZBDEtaPIQ281Ig2APNBBy69ryQm7i
   A==;
X-CSE-ConnectionGUID: kG6VOYsRRJy2XvGSObPdDA==
X-CSE-MsgGUID: cVDsK26AS/K934kYTuo2Kg==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="40952401"
X-IronPort-AV: E=Sophos;i="6.16,270,1744095600"; 
   d="scan'208";a="40952401"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2025 03:42:38 -0700
X-CSE-ConnectionGUID: WLXeMLuQRL6ppBWUqOdM9g==
X-CSE-MsgGUID: CySObl8PRU+l7CdlnR0alw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,270,1744095600"; 
   d="scan'208";a="152953275"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa007.jf.intel.com with ESMTP; 27 Jun 2025 03:42:33 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id A8E716A; Fri, 27 Jun 2025 13:42:31 +0300 (EEST)
Date: Fri, 27 Jun 2025 13:42:31 +0300
From: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, Chao Gao <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, 
	Kai Huang <kai.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 01/12] x86/tdx: Consolidate TDX error handling
Message-ID: <yhoysoqiqcof3uf723p2chqmnfbcyw5nucn6uke6vfrsknui3o@tsm64jev6ngt>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <20250609191340.2051741-2-kirill.shutemov@linux.intel.com>
 <5cfb2e09-7ecb-4144-9122-c11152b18b5e@intel.com>
 <d897ab70d48be4508a8a9086de1ff3953041e063.camel@intel.com>
 <aFxpuRLYA2L6Qfsi@google.com>
 <vgk3ql5kcpmpsoxfw25hjcw4knyugszdaeqnzur6xl4qll73xy@xi7ttxlxot2r>
 <3e55fd58-1d1c-437a-9e0a-72ac92facbb5@intel.com>
 <aF1sjdV2UDEbAK2h@google.com>
 <1fbdfffa-ac43-419c-8d96-c5bb1bdac73f@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1fbdfffa-ac43-419c-8d96-c5bb1bdac73f@intel.com>

On Thu, Jun 26, 2025 at 09:59:47AM -0700, Dave Hansen wrote:
> On 6/26/25 08:51, Sean Christopherson wrote:
> > No, I was thinking:
> > 
> > 	if (IS_TDX_ERR_OPERAND_BUSY(err))
> > 
> > e.g. to so that it looks like IS_ERR(), which is a familiar pattern.
> 
> That would be a more more compelling if IS_ERR() worked on integers. It
> works on pointers, so I'm not sure it's a pattern we want to apply to
> integers here.

IS_ERR_VALUE() works on integers.

> I kind of hate all of this. I'd kinda prefer that we just shove the TDX
> error codes as far up into the helpers as possible rather than making
> them easier to deal with in random code.

Stripping info from error code early in handling can backfire if we ever
would need this inf (like need to know which argument is problematic). We
suddenly can suddenly be in position to rework all callers.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

