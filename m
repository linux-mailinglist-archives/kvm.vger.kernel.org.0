Return-Path: <kvm+bounces-50818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5123AE99EA
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 11:26:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B1F357A630E
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 09:24:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 382252BEFF2;
	Thu, 26 Jun 2025 09:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hg205bmN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2952E18C332;
	Thu, 26 Jun 2025 09:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750929939; cv=none; b=ST2IXytfz+jWLQ2CpQSOymz5OYQa/No+EpEwBlpVCfnw69eBCJVryPqvB1mKPpJWUfK87WvnpnVrle1TDWo44qu+RzmC6hKWgqIx2liSGWK5t5LI7ZBcAKvbiUlE9qyZHv/LhhcVgWmF2DfLtSMvX2IX8SxlPv22jyBwGESdnVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750929939; c=relaxed/simple;
	bh=xVxhsp9WJPwQPCXZFwvJKu5uUvkY6LGeigTfbmZtgn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RSKs2m/FkruP7YQcLNPeRYjajS+5OmpqpwZDDKJsIJCnN+sfCB1WFnD44q419a4G/R2QaflM1qZgQR+CXPCzQok80QoFOqyVSnhtwZZVmZ014tqM92VAcCMLrAXWN7/YaKGaaEa7b0llHncPGXKQvr/ZpYJKNhKtMziZsDhWpF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hg205bmN; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750929937; x=1782465937;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=xVxhsp9WJPwQPCXZFwvJKu5uUvkY6LGeigTfbmZtgn0=;
  b=Hg205bmN7kdu7OJtFny9cVHrS/NlKUu/A2E6bp1hyQef3FlKq9FzSaqD
   iqHut4QvS7U5meYNJ6NHfnIUfyRj5RLwavFMqWQiARqIALs+qSuYJV6iH
   z/kCHju5gsm5/IysDJscCOpXFOoN4zXee8vw+DQUygJ1PAM9grlcR3e5c
   xAE+oO+2Ut7O1cHGPxlu0hoXtesurA26Lq8R6Qr2Ybq2aTqWYEPlHkKOo
   FKEkK5isSgSV7B+qjQIZEJAZxR/rI71EPd9G+PH0PX0o7f8Bn2kPpOMbm
   RfOmQi5b/iTuc5BZwpFbJxe6GxIqN48DFoAKM4cSzlU2B/Rlh6c0n/b6l
   g==;
X-CSE-ConnectionGUID: smBY5ltDStW6sE8zSi/iQg==
X-CSE-MsgGUID: +//fv9XRQ9Sm65w8FoGnvQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="52942027"
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="52942027"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 02:25:37 -0700
X-CSE-ConnectionGUID: LBzYSVR0SY+K2h1P+OlghQ==
X-CSE-MsgGUID: eNqeFQRPSR2gVgy1xtUziw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="152980614"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa008.fm.intel.com with ESMTP; 26 Jun 2025 02:25:33 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 9586721E; Thu, 26 Jun 2025 12:25:31 +0300 (EEST)
Date: Thu, 26 Jun 2025 12:25:31 +0300
From: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Dave Hansen <dave.hansen@intel.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, Chao Gao <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, 
	Kai Huang <kai.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 01/12] x86/tdx: Consolidate TDX error handling
Message-ID: <vgk3ql5kcpmpsoxfw25hjcw4knyugszdaeqnzur6xl4qll73xy@xi7ttxlxot2r>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <20250609191340.2051741-2-kirill.shutemov@linux.intel.com>
 <5cfb2e09-7ecb-4144-9122-c11152b18b5e@intel.com>
 <d897ab70d48be4508a8a9086de1ff3953041e063.camel@intel.com>
 <aFxpuRLYA2L6Qfsi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aFxpuRLYA2L6Qfsi@google.com>

On Wed, Jun 25, 2025 at 02:27:21PM -0700, Sean Christopherson wrote:
> On Wed, Jun 25, 2025, Rick P Edgecombe wrote:
> > On Wed, 2025-06-25 at 10:58 -0700, Dave Hansen wrote:
> > > > --- a/arch/x86/kvm/vmx/tdx.c
> > > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > > @@ -202,12 +202,6 @@ static DEFINE_MUTEX(tdx_lock);
> > > >   
> > > >   static atomic_t nr_configured_hkid;
> > > >   
> > > > -static bool tdx_operand_busy(u64 err)
> > > > -{
> > > > -	return (err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY;
> > > > -}
> > > > -
> > > > -
> > > 
> > > Isaku, this one was yours (along with the whitespace damage). What do
> > > you think of this patch?
> > 
> > I think this actually got added by Paolo, suggested by Binbin. I like these
> > added helpers a lot. KVM code is often open coded for bitwise stuff, but since
> > Paolo added tdx_operand_busy(), I like the idea of following the pattern more
> > broadly. I'm on the fence about tdx_status() though.
> 
> Can we turn them into macros that make it super obvious they are checking if the
> error code *is* xyz?  E.g.
> 
> #define IS_TDX_ERR_OPERAND_BUSY
> #define IS_TDX_ERR_OPERAND_INVALID
> #define IS_TDX_ERR_NO_ENTROPY
> #define IS_TDX_ERR_SW_ERROR
> 
> As is, it's not at all clear that things like tdx_success() are simply checks,
> as opposed to commands.

I remember Dave explicitly asked for inline functions over macros where
possible.

Can we keep them as functions, but give the naming scheme you proposing
(but lowercase)?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

