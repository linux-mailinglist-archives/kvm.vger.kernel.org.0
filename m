Return-Path: <kvm+bounces-1845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EC197ECC2D
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 20:27:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C72B1C20B85
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 19:27:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49B7B41223;
	Wed, 15 Nov 2023 19:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ipjzapR9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6FEF1AB;
	Wed, 15 Nov 2023 11:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700076431; x=1731612431;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=I+mMbHRrdn5krrXbIHqhTFESIktjUGAwXJKl6TU3/ec=;
  b=ipjzapR9PRyq61AZichvhS4svsfE/zIjMAtdfYmZJfi6SN9GdKzipuaU
   deMjsUdqDCtoIvU21N/7vnoZOg7lJBbF/ZCVmFXXVu0fBC1OlUB/+fPuK
   Ixj6x7kaZV8S++xx87Ti3flc3OJ63ASaaUdAE0iZ4U8ZzwouVUgD2MEW/
   rzmQWcG5V0xWPMvrdWZ4+jJKGVO4G0DMLOUO6QL6VP7hU20+Kx3naWjd1
   X4gdbRW3+M56ix3DPKZ1DjuYYzY7FHmxQlMZ2wm9GU8h87Tzpsjbeaqw9
   wGqhiWCKJg1m4+bgDHfQEY4GtBWYAgAykKIVrxz748ThLGP3T1PI/vo4l
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="394858927"
X-IronPort-AV: E=Sophos;i="6.03,305,1694761200"; 
   d="scan'208";a="394858927"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 11:26:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="882482919"
X-IronPort-AV: E=Sophos;i="6.03,305,1694761200"; 
   d="scan'208";a="882482919"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 11:26:50 -0800
Date: Wed, 15 Nov 2023 11:26:50 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"sathyanarayanan.kuppuswamy@linux.intel.com" <sathyanarayanan.kuppuswamy@linux.intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>,
	"bagasdotme@gmail.com" <bagasdotme@gmail.com>,
	"Luck, Tony" <tony.luck@intel.com>,
	"ak@linux.intel.com" <ak@linux.intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"Shahar, Sagi" <sagis@google.com>,
	"imammedo@redhat.com" <imammedo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
	"rafael@kernel.org" <rafael@kernel.org>,
	"Brown, Len" <len.brown@intel.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v15 05/23] x86/virt/tdx: Handle SEAMCALL no entropy error
 in common code
Message-ID: <20231115192650.GB1109547@ls.amr.corp.intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
 <9565b2ccc347752607039e036fd8d19d78401b53.1699527082.git.kai.huang@intel.com>
 <20231114192447.GA1109547@ls.amr.corp.intel.com>
 <63e9754ec059190cd1734650b8968952cbe00ee9.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <63e9754ec059190cd1734650b8968952cbe00ee9.camel@intel.com>

On Wed, Nov 15, 2023 at 10:41:46AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> 
> > > +#include <asm/archrandom.h>
> > > +
> > > +typedef u64 (*sc_func_t)(u64 fn, struct tdx_module_args *args);
> > > +
> > > +static inline u64 sc_retry(sc_func_t func, u64 fn,
> > > +			   struct tdx_module_args *args)
> > > +{
> > > +	int retry = RDRAND_RETRY_LOOPS;
> > > +	u64 ret;
> > > +
> > > +	do {
> > > +		ret = func(fn, args);
> > > +	} while (ret == TDX_RND_NO_ENTROPY && --retry);
> > 
> > This loop assumes that args isn't touched when TDX_RND_NO_ENTRYPOY is returned.
> > It's not true.  TDH.SYS.INIT() and TDH.SYS.LP.INIT() clear RCX, RDX, etc on
> > error including TDX_RND_NO_ENTRY.  Because TDH.SYS.INIT() takes RCX as input,
> > this wrapper doesn't work.  TDH.SYS.LP.INIT() doesn't use RCX, RDX ... as
> > input. So it doesn't matter.
> > 
> > Other SEAMCALLs doesn't touch registers on the no entropy error.
> > TDH.EXPORTS.STATE.IMMUTABLE(), TDH.IMPORTS.STATE.IMMUTABLE(), TDH.MNG.ADDCX(),
> > and TDX.MNG.CREATE().  TDH.SYS.INIT() is an exception.
> 
> If I am reading the spec (TDX module 1.5 ABI) correctly the TDH.SYS.INIT doesn't
> return TDX_RND_NO_ENTROPY.

The next updated spec would fix it.
                                  

> TDH.SYS.LP.INIT indeed can return NO_ENTROPY but as
> you said it doesn't take any register as input.  So technically the code works
> fine.  (Even the TDH.SYS.INIT can return NO_ENTROPY the code still works fine
> because the RCX must be 0 for TDH.SYS.INIT.)

Ah yes, I agree with you. So it doesn't matter.


> Also, I can hardly think out of any reason why TDX module needs to clobber input
> registers in case of NO_ENTROPY for *ANY* SEAMCALL.  But despite that, I am not
> opposing the idea that it *MIGHT* be better to "not assume" NO_ENTROPY will
> never clobber registers either, e.g., for the sake of future extendibility.  In
> this case, the below diff should address:

Now we agreed that TDH.SYS.INIT() and TDH.SYS.LP.INIT() doesn't matter,
I'm fine with this patch. (TDX KVM handles other SEAMCALLS itself.)

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

