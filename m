Return-Path: <kvm+bounces-2171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 662147F2A57
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 11:27:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9BD5DB2195B
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 10:27:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7F2D46525;
	Tue, 21 Nov 2023 10:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JvTTUpVd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8ADB9;
	Tue, 21 Nov 2023 02:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700562450; x=1732098450;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Qh3fdjbbMdJuENlB0cjZTsBrtO692dC9NzB07N0J9LI=;
  b=JvTTUpVdS6DwCxMK+subBsIeLWaPvBBju2s/Q7rBqGGFh7tdGOGdTma/
   U6B1ofeNMx6BowhSqSrFvDbsTkYSp348TJRsialAb5+5uWMfSj4a99vJ7
   0OZAdFVFotnXcQw5mwvdaOgtLKzj73VhgBdsexPw6MBHyWNd+ZfG99Tim
   9wJYk7ghGCCKve6GIArkSJImeBRWISeRPk8te+Y0NU39qnyISrnQQ95s+
   5MvQduaspMk+ZqZP4Uz8bI07j19UtoUIFHA7mZOUM8ZlY9oGmF/xMuhK9
   z1GrfUhaQd/aqaEp9oZlC7XN04+T2sLsIQn0l6xiXuJ8yLeXtjOIB/463
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="391587948"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="391587948"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 02:27:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="760061390"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="760061390"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 02:27:23 -0800
Date: Tue, 21 Nov 2023 02:27:23 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
	hang.yuan@intel.com, tina.zhang@intel.com,
	Xiaoyao Li <xiaoyao.li@intel.com>, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v6 09/16] KVM: TDX: Pass desired page level in err code
 for page fault handler
Message-ID: <20231121102723.GG1109547@ls.amr.corp.intel.com>
References: <cover.1699368363.git.isaku.yamahata@intel.com>
 <71943490df987be8a3a3e131b12750e8c6d82afc.1699368363.git.isaku.yamahata@intel.com>
 <815d893b-63fc-4dec-8c04-6580344c7eef@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <815d893b-63fc-4dec-8c04-6580344c7eef@linux.intel.com>

On Mon, Nov 20, 2023 at 07:24:51PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 11/7/2023 11:00 PM, isaku.yamahata@intel.com wrote:
> > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > 
> > For TDX, EPT violation can happen when TDG.MEM.PAGE.ACCEPT.
> > And TDG.MEM.PAGE.ACCEPT contains the desired accept page level of TD guest.
> > 
> > 1. KVM can map it with 4KB page while TD guest wants to accept 2MB page.
> > 
> >    TD geust will get TDX_PAGE_SIZE_MISMATCH and it should try to accept
> >    4KB size.
> > 
> > 2. KVM can map it with 2MB page while TD guest wants to accept 4KB page.
> > 
> >    KVM needs to honor it because
> >    a) there is no way to tell guest KVM maps it as 2MB size. And
> >    b) guest accepts it in 4KB size since guest knows some other 4KB page
> >       in the same 2MB range will be used as shared page.
> > 
> > For case 2, it need to pass desired page level to MMU's
> > page_fault_handler. Use bit 29:31 of kvm PF error code for this purpose.
> The shortlog is the same as patch 7/16..., I am a bit confused by the
> structure of this patch series...
> Can this patch be squashed into 7/16?

Patch 7 should include the changes to arch/x86/include/asm/kvm_host.h and
arch/x86/kvm/mmu/mmu.c. and use PFERR_LEVEL().
Patch 9 should include the changes arch/x86/kvm/vmx/*.

I'll fix them.


> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index eed36c1eedb7..c16823f3326e 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -285,6 +285,8 @@ enum x86_intercept_stage;
> >   				 PFERR_WRITE_MASK |		\
> >   				 PFERR_PRESENT_MASK)
> > +#define PFERR_LEVEL(err_code)	(((err_code) & PFERR_LEVEL_MASK) >> PFERR_LEVEL_START_BIT)
> It's defined, but never used?

I'll make kvm_tdp_page_fault() use it.


> > diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
> > index 9f93250d22b9..ba41fefa47ee 100644
> > --- a/arch/x86/kvm/vmx/tdx_arch.h
> > +++ b/arch/x86/kvm/vmx/tdx_arch.h
> > @@ -218,4 +218,23 @@ union tdx_sept_level_state {
> >   	u64 raw;
> >   };
> > +union tdx_ext_exit_qualification {
> > +	struct {
> > +		u64 type		:  4;
> > +		u64 reserved0		: 28;
> > +		u64 req_sept_level	:  3;
> > +		u64 err_sept_level	:  3;
> > +		u64 err_sept_state	:  8;
> > +		u64 err_sept_is_leaf	:  1;
> > +		u64 reserved1		: 17;
> > +	};
> > +	u64 full;
> > +};
> > +
> > +enum tdx_ext_exit_qualification_type {
> > +	EXT_EXIT_QUAL_NONE = 0,
> > +	EXT_EXIT_QUAL_ACCEPT,
> Since this value should be fixed to 1, maybe better to initialize it to 1
> for future proof?

ok.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

