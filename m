Return-Path: <kvm+bounces-24075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D0754951109
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 02:31:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F7C51C22A0B
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 00:31:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 791584A08;
	Wed, 14 Aug 2024 00:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ADLG5qeG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDCC197;
	Wed, 14 Aug 2024 00:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723595494; cv=none; b=BWrCrRTR6uygJe/WXikGHO4gf6yPsm8XSpGUupGT1OcFFEifelI3Wl3tokPNrWTfh7jIXyfG/RTouccVB/15+fjDYsszVFhAUReVwU3Uasmu+LhfJyM+KKWNCszQerM2Mc3ylstjlPN3oH66SK/b1VHGbuoA+iLj4JYPEhHr9EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723595494; c=relaxed/simple;
	bh=2VowRBQ8IBJnrbd0/sfwIDHlM3DOIZJecXLmUDPFIZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mQfLNUbvd9cC3/Df2iUFdwB0NVJ2Uy2mDLG624Hd6MekwQEsysiiU+fzC3HpSNx2DSNnsBt+ZTZVoF4QPRvpice7Mz2Q4CQzORbU2qTC8BOPBKbEDEw4wtqjqhBiiTK2Tr557QfebvDmel3C+Uq8lIf4MRHjHu/R+MjqX6F47w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ADLG5qeG; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723595493; x=1755131493;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2VowRBQ8IBJnrbd0/sfwIDHlM3DOIZJecXLmUDPFIZs=;
  b=ADLG5qeGqJTFQMOV3p920ma+5LPNvkGasZPpCTf6csvWPjogPLw+4+2C
   qIYKS7gteUWQQKJcixQCI4JzSvC/YJ4xTjolM+2Z4KmbxWTipAA66rjP9
   yY+0RD0CDeRKpjkc/pggyCswlMYap0G70t3Mg9lgrzLV0P9wbAKrZZRhg
   y6Y4DiPW+liXqfHxoFfnVzLZKn2KzpecsD0mBAu2OkVz4e/I2fW6+H4Pg
   k0yCs4uIvblWbaBI3F3LjhHL6Bz+jeDeThdKLUzqLiT5dSu54vPuwDWFg
   +ZDdJnXBfMjMcWUtGJu4pv/ipNZ9MFDyvKSLnSnfUuWr+uhymOqu0NdK0
   Q==;
X-CSE-ConnectionGUID: mPvgW1ppT4uVJ+Lv8Hjz3w==
X-CSE-MsgGUID: whK+C9yLTjGZ4gY8rf4m6w==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="32934850"
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="32934850"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 17:31:33 -0700
X-CSE-ConnectionGUID: HQkH7PpOReaiw4S1u6o3rw==
X-CSE-MsgGUID: HeBVIraOSmOWlHXTCorPag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="58832649"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 17:31:33 -0700
Date: Tue, 13 Aug 2024 17:31:31 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"Li, Xiaoyao" <Xiaoyao.Li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	"Yao, Yuan" <yuan.yao@intel.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH 05/25] KVM: TDX: Add helper functions to print TDX
 SEAMCALL error
Message-ID: <Zrv649ijpYchVlyL@ls.amr.corp.intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-6-rick.p.edgecombe@intel.com>
 <ZruKrWWDtB+E3kwr@ls.amr.corp.intel.com>
 <61b550ed-c5d1-44a6-89de-cfa04ddd59c8@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <61b550ed-c5d1-44a6-89de-cfa04ddd59c8@intel.com>

On Wed, Aug 14, 2024 at 10:34:11AM +1200,
"Huang, Kai" <kai.huang@intel.com> wrote:

> 
> > > +#define pr_tdx_error(__fn, __err)	\
> > > +	pr_err_ratelimited("SEAMCALL %s failed: 0x%llx\n", #__fn, __err)
> > > +
> > > +#define pr_tdx_error_N(__fn, __err, __fmt, ...)		\
> > > +	pr_err_ratelimited("SEAMCALL %s failed: 0x%llx, " __fmt, #__fn, __err,  __VA_ARGS__)
> > 
> > Stringify in the inner macro results in expansion of __fn.  It means value
> > itself, not symbolic string.  Stringify should be in the outer macro.
> > "SEAMCALL 7 failed" vs "SEAMCALL TDH_MEM_RANGE_BLOCK failed"
> > 
> > #define __pr_tdx_error_N(__fn_str, __err, __fmt, ...)           \
> >          pr_err_ratelimited("SEAMCALL " __fn_str " failed: 0x%llx, " __fmt,  __err,  __VA_ARGS__)
> > 
> > #define pr_tdx_error_N(__fn, __err, __fmt, ...)         \
> >          __pr_tdx_error_N(#__fn, __err, __fmt, __VA_ARGS__)
> > 
> > #define pr_tdx_error_1(__fn, __err, __rcx)              \
> >          __pr_tdx_error_N(#__fn, __err, "rcx 0x%llx\n", __rcx)
> > 
> > #define pr_tdx_error_2(__fn, __err, __rcx, __rdx)       \
> >          __pr_tdx_error_N(#__fn, __err, "rcx 0x%llx, rdx 0x%llx\n", __rcx, __rdx)
> > 
> > #define pr_tdx_error_3(__fn, __err, __rcx, __rdx, __r8) \
> >          __pr_tdx_error_N(#__fn, __err, "rcx 0x%llx, rdx 0x%llx, r8 0x%llx\n", __rcx, __rdx, __r8)
> > 
> 
> You are right.  Thanks for catching this!
> 
> The above code looks good to me, except we don't need pr_tdx_error_N()
> anymore.
> 
> I think we can just replace the old pr_tdx_error_N() with your
> __pr_tdx_error_N().

Agreed, we don't have the direct user of pr_tdx_error_N().
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

