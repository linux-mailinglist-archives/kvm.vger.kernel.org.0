Return-Path: <kvm+bounces-25457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC58496572F
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 07:57:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1CB6FB23CFE
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 05:57:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A34F1531D5;
	Fri, 30 Aug 2024 05:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R9ncg7g/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032C914A603;
	Fri, 30 Aug 2024 05:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724997400; cv=none; b=Rkx4YO15VnM2w4buZw1nV35p/3oPC8Z1nj0e7ZvqvkvZKxcBncAT7F4hML7DrIur2MuVOdEcWjjuAYi07caOzJAIqUQsJ73T6lrsF7Za0eWEWwBqgYOUYngWXoCJ5ovgZTdNJlC1yHkDB2NezlIC6b3B2RVO75xfVaQ0x9/JD/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724997400; c=relaxed/simple;
	bh=cMoYR2+lL+zTWmUeEiZIZmwGSiC2Mz51wmGtrZkVE4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bx7nMex9qAGQci0nEEY/RD4mNjQtIcQVJIt6Y1lczUKkK1lZ+GLvHhh28K49r3AvMmR/y5ehK7QRaAintSpC8EltfIPFx8UAMmD++CdbjTe9wNbYbdTRNVNqspO+yRSuswzhfD0aSxDKhp7kXrnm4miAEl/OUQK5zISFd98EvCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R9ncg7g/; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724997399; x=1756533399;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cMoYR2+lL+zTWmUeEiZIZmwGSiC2Mz51wmGtrZkVE4Y=;
  b=R9ncg7g/SF1zq7cftgRWxkf2VipPgh/cTgg0h6Bz40ClripvnojT563r
   LH5AUV/WeFBpN3W58QgpGvE/8ZQ1AheJ5bkX7ITv/Xh0N0J7mFSRgVt0j
   FqFw0cJ+hmlqK5JDuufEHsDqLaJ5ZDUOG6R+AnDusA3hsV++q6jhkTWEx
   YNQAVu9sTFO6tBs67tC2IoaMmdTVSxKZrsQpOInjtN8YEpIaetkYD0AY2
   mbqhTUFSSlBHBL8qzW6DZmPuP4AH057h+JoFuzzXtVvKaHTtNXgLHRARI
   ZU7OQ3369dbkrxHwlPYO4Fgc3vJOUSv68oS7Ativ+hvy6/grugav6/R6s
   Q==;
X-CSE-ConnectionGUID: YuNLxGg9S5KddOLPUVjxFQ==
X-CSE-MsgGUID: +CH4pKK7QhutUPSHpJbgaQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="49009775"
X-IronPort-AV: E=Sophos;i="6.10,187,1719903600"; 
   d="scan'208";a="49009775"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 22:56:38 -0700
X-CSE-ConnectionGUID: RtiO9UGQQjezeJIRqv1OUg==
X-CSE-MsgGUID: eWqTYxmIRe+0sEEFrgr6LQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,187,1719903600"; 
   d="scan'208";a="63790147"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.63])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 22:56:33 -0700
Date: Fri, 30 Aug 2024 08:56:27 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: "Huang, Kai" <kai.huang@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Li, Xiaoyao" <Xiaoyao.Li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	"Yao, Yuan" <yuan.yao@intel.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH 05/25] KVM: TDX: Add helper functions to print TDX
 SEAMCALL error
Message-ID: <ZtFfC0P1slHZjOVV@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-6-rick.p.edgecombe@intel.com>
 <ZruKrWWDtB+E3kwr@ls.amr.corp.intel.com>
 <61b550ed-c5d1-44a6-89de-cfa04ddd59c8@intel.com>
 <Zrv649ijpYchVlyL@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zrv649ijpYchVlyL@ls.amr.corp.intel.com>

On Tue, Aug 13, 2024 at 05:31:31PM -0700, Isaku Yamahata wrote:
> On Wed, Aug 14, 2024 at 10:34:11AM +1200,
> "Huang, Kai" <kai.huang@intel.com> wrote:
> 
> > 
> > > > +#define pr_tdx_error(__fn, __err)	\
> > > > +	pr_err_ratelimited("SEAMCALL %s failed: 0x%llx\n", #__fn, __err)
> > > > +
> > > > +#define pr_tdx_error_N(__fn, __err, __fmt, ...)		\
> > > > +	pr_err_ratelimited("SEAMCALL %s failed: 0x%llx, " __fmt, #__fn, __err,  __VA_ARGS__)
> > > 
> > > Stringify in the inner macro results in expansion of __fn.  It means value
> > > itself, not symbolic string.  Stringify should be in the outer macro.
> > > "SEAMCALL 7 failed" vs "SEAMCALL TDH_MEM_RANGE_BLOCK failed"
> > > 
> > > #define __pr_tdx_error_N(__fn_str, __err, __fmt, ...)           \
> > >          pr_err_ratelimited("SEAMCALL " __fn_str " failed: 0x%llx, " __fmt,  __err,  __VA_ARGS__)
> > > 
> > > #define pr_tdx_error_N(__fn, __err, __fmt, ...)         \
> > >          __pr_tdx_error_N(#__fn, __err, __fmt, __VA_ARGS__)
> > > 
> > > #define pr_tdx_error_1(__fn, __err, __rcx)              \
> > >          __pr_tdx_error_N(#__fn, __err, "rcx 0x%llx\n", __rcx)
> > > 
> > > #define pr_tdx_error_2(__fn, __err, __rcx, __rdx)       \
> > >          __pr_tdx_error_N(#__fn, __err, "rcx 0x%llx, rdx 0x%llx\n", __rcx, __rdx)
> > > 
> > > #define pr_tdx_error_3(__fn, __err, __rcx, __rdx, __r8) \
> > >          __pr_tdx_error_N(#__fn, __err, "rcx 0x%llx, rdx 0x%llx, r8 0x%llx\n", __rcx, __rdx, __r8)
> > > 
> > 
> > You are right.  Thanks for catching this!
> > 
> > The above code looks good to me, except we don't need pr_tdx_error_N()
> > anymore.
> > 
> > I think we can just replace the old pr_tdx_error_N() with your
> > __pr_tdx_error_N().
> 
> Agreed, we don't have the direct user of pr_tdx_error_N().

I'll do a patch for these changes.

Tony

