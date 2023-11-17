Return-Path: <kvm+bounces-1892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FDC17EEA1F
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 01:02:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A31881F24633
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 00:02:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C555B8F78;
	Fri, 17 Nov 2023 00:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JP2iU9SV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B050EA;
	Thu, 16 Nov 2023 16:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700179326; x=1731715326;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jlgZtbFmLpOkbqAFRrH5mbiBpW6onu1KLogo8/lD2eA=;
  b=JP2iU9SVQydZPPvmZnr+wU7CuV4Un9pYLSAA2xpr70iiVNlXMCfM00YN
   sG5qR4FDU9iHyMjb59dx8bB9cRNtF54wHYRlsDP0GCfEGfdRHZMKR3n1r
   cysNc/56j9oUojFQQZ6ACFBEQi3YmEEYK6lHqv+TwrOz/8QZU3POow11s
   imDtcwRE1uOZU+cvMxQM0uUUoCnuD9UHUqhrM3vruiZQ2aRUOAyWGyI6G
   4kwYbDxbrpHwZbX+CiPIvuXxGDco8WfbrSqZQiylXJUk0PkC+9J3HMlr5
   XdzC5IivFURUuwpeIQiukkaz0WhyNPG3yyg2mmupAG4mOsePitbUhqyif
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10896"; a="376255657"
X-IronPort-AV: E=Sophos;i="6.04,205,1695711600"; 
   d="scan'208";a="376255657"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2023 16:02:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10896"; a="882937579"
X-IronPort-AV: E=Sophos;i="6.04,205,1695711600"; 
   d="scan'208";a="882937579"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2023 16:02:05 -0800
Date: Thu, 16 Nov 2023 16:02:05 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Chenyi Qiang <chenyi.qiang@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
	hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v17 015/116] x86/cpu: Add helper functions to
 allocate/free TDX private host key id
Message-ID: <20231117000205.GA1277973@ls.amr.corp.intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
 <69281f4f2e4d2c3c906518d83bc6ec9c0debda16.1699368322.git.isaku.yamahata@intel.com>
 <35cd1aad-87b6-4606-9811-ab56530cf896@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <35cd1aad-87b6-4606-9811-ab56530cf896@intel.com>

On Wed, Nov 15, 2023 at 03:35:11PM +0800,
Chenyi Qiang <chenyi.qiang@intel.com> wrote:

> > diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> > index 38ec6815a42a..c01cbfc81fbb 100644
> > --- a/arch/x86/virt/vmx/tdx/tdx.c
> > +++ b/arch/x86/virt/vmx/tdx/tdx.c
> > @@ -37,7 +37,8 @@
> >  #include <asm/tdx.h>
> >  #include "tdx.h"
> >  
> > -static u32 tdx_global_keyid __ro_after_init;
> > +u32 tdx_global_keyid __ro_after_init;
> > +EXPORT_SYMBOL_GPL(tdx_global_keyid);
> >  static u32 tdx_guest_keyid_start __ro_after_init;
> >  static u32 tdx_nr_guest_keyids __ro_after_init;
> >  
> > @@ -105,6 +106,31 @@ static inline int sc_retry_prerr(sc_func_t func, sc_err_func_t err_func,
> >  #define seamcall_prerr_ret(__fn, __args)					\
> >  	sc_retry_prerr(__seamcall_ret, seamcall_err_ret, (__fn), (__args))
> >  
> > +/* TDX KeyID pool */
> > +static DEFINE_IDA(tdx_guest_keyid_pool);
> > +
> > +int tdx_guest_keyid_alloc(void)
> > +{
> > +	if (WARN_ON_ONCE(!tdx_guest_keyid_start || !tdx_nr_guest_keyids))
> > +		return -EINVAL;
> > +
> > +	/* The first keyID is reserved for the global key. */
> > +	return ida_alloc_range(&tdx_guest_keyid_pool, tdx_guest_keyid_start + 1,
> 
> Per
> https://lore.kernel.org/all/121aab11b48b4e6550cfe6d23b4daab744ee2076.1697532085.git.kai.huang@intel.com/
> tdx_guest_keyid_start has already reserved the first keyID for global
> key, I think we don't need to reserve another one here.

Nice catch. Will fix it with the next respin.

-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

