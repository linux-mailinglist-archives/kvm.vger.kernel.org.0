Return-Path: <kvm+bounces-13334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 833B4894B1C
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 08:04:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A108A1C21E3D
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 06:04:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCFEA18E29;
	Tue,  2 Apr 2024 06:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BP9XaOaW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BC51F94B;
	Tue,  2 Apr 2024 06:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712037841; cv=none; b=uhnBB8KyQ3TJu3W2RWHP+0JP/mEr/DXNIYlAychII95NCFi8gSqfjUX38nMjdunjkSJSphMAZZw116uPbRPse2XDkwX9cxVLr9lEqyG7XQet8StPZaUmP07+traZNMJWSE308L4YaM4fzdx3NLiorx84fE6n3jAiOebmK2r2ydg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712037841; c=relaxed/simple;
	bh=kE7S8uISbfo4+U7tsSlfxnO64cVl+efxc7PoWKseenk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lAZPUvb2btbvwElG75AKEbp07bzMDDbtyg5e+zDyfpG/7bHQCBSbRH2pY/bJ/ailZd+zB5Sy7cBUALpspv20DBApHH+046C14TxA5qW76l+tOXB9nYMwk3yUvTSvSFa3d0WmyNdqOI8aumoNLrYQ3Yf2W9MEioTHAl6Am3n8S/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BP9XaOaW; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712037839; x=1743573839;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kE7S8uISbfo4+U7tsSlfxnO64cVl+efxc7PoWKseenk=;
  b=BP9XaOaWJt7Rxt0YpRI/Iw8qQ4DK3hDb4AsvkB7rcbGfbXJhSMKTkd6k
   jBg3pmFWRk0pVGfzgV8b8FK0UrIms4c3fXJMUrcnHObF0KNpxRRtcUYlN
   Iy71P7QsDuYiujnm7wHiHY3dHlZd+ATl0ATNAZF5YMB/FShMe7xnPJQ1I
   T9qAfmlcy2wt5rMhXnFGzwJkCgCZMdJpEHqXgq9h4lgvEn/2E6uO+PJTJ
   9Cgi0p28jNLXvg8VEduYeJIlKmwyszNwlQ9YM4K29zQieWEqWt1SvXWt5
   6pxfaq2rGQlIi+XaoVHnKh2RFRy3PseYixeww/0Ce4OllHx+GOQwmzD6y
   g==;
X-CSE-ConnectionGUID: XNcZqTPdSJCOq01L0VOSiQ==
X-CSE-MsgGUID: Ghp2sBvITAWFI1JK8dJbVw==
X-IronPort-AV: E=McAfee;i="6600,9927,11031"; a="10972238"
X-IronPort-AV: E=Sophos;i="6.07,174,1708416000"; 
   d="scan'208";a="10972238"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 23:03:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,174,1708416000"; 
   d="scan'208";a="22394265"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 23:03:58 -0700
Date: Mon, 1 Apr 2024 23:03:57 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 069/130] KVM: TDX: Require TDP MMU and mmio caching
 for TDX
Message-ID: <20240402060357.GV2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <f6a80dd212e8c3fd14b40049eed33187008cf35a.1708933498.git.isaku.yamahata@intel.com>
 <ZgrwDbZLFqiyS_5e@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZgrwDbZLFqiyS_5e@google.com>

On Mon, Apr 01, 2024 at 10:34:05AM -0700,
Sean Christopherson <seanjc@google.com> wrote:

> On Mon, Feb 26, 2024, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > As TDP MMU is becoming main stream than the legacy MMU, the legacy MMU
> > support for TDX isn't implemented.  TDX requires KVM mmio caching.  Disable
> > TDX support when TDP MMU or mmio caching aren't supported.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c  |  1 +
> >  arch/x86/kvm/vmx/main.c | 13 +++++++++++++
> >  2 files changed, 14 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 0e0321ad9ca2..b8d6ce02e66d 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -104,6 +104,7 @@ module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
> >   * If the hardware supports that we don't need to do shadow paging.
> >   */
> >  bool tdp_enabled = false;
> > +EXPORT_SYMBOL_GPL(tdp_enabled);
> 
> I haven't looked at the rest of the series, but this should be unnecessary.  Just
> use enable_ept.  Ah, the code is wrong.
> 
> >  static bool __ro_after_init tdp_mmu_allowed;
> >  
> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > index 076a471d9aea..54df6653193e 100644
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -3,6 +3,7 @@
> >  
> >  #include "x86_ops.h"
> >  #include "vmx.h"
> > +#include "mmu.h"
> >  #include "nested.h"
> >  #include "pmu.h"
> >  #include "tdx.h"
> > @@ -36,6 +37,18 @@ static __init int vt_hardware_setup(void)
> >  	if (ret)
> >  		return ret;
> >  
> > +	/* TDX requires KVM TDP MMU. */
> 
> This is a useless comment (assuming the code is correctly written), it's quite
> obvious from:
> 
> 	if (!tdp_mmu_enabled)
> 		enable_tdx = false;
> 
> that the TDP MMU is required.  Explaining *why* could be useful, but I'd probably
> just omit a comment.  In the not too distant future, it will likely be common
> knowledge that the shadow MMU doesn't support newfangled features, and it _should_
> be very easy for someone to get the info from the changelog.
> 
> > +	if (enable_tdx && !tdp_enabled) {
> 
> tdp_enabled can be true without the TDP MMU, you want tdp_mmu_enabled.
> 
> > +		enable_tdx = false;
> > +		pr_warn_ratelimited("TDX requires TDP MMU.  Please enable TDP MMU for TDX.\n");
> 
> Drop the pr_warn(), TDX will presumably be on by default at some point, I don't
> want to get spam every time I test with TDP disabled.
> 
> Also, ratelimiting this code is pointless (as is _once()), it should only ever
> be called once per module module, and the limiting/once protections are tied to
> the module, i.e. effectively get reset when a module is reloaded.
> 
> > +	}
> > +
> > +	/* TDX requires MMIO caching. */
> > +	if (enable_tdx && !enable_mmio_caching) {
> > +		enable_tdx = false;
> > +		pr_warn_ratelimited("TDX requires mmio caching.  Please enable mmio caching for TDX.\n");
> 
> Same comments here.
> 
> > +	}
> > +
> >  	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
> 
> All of the above code belongs in tdx_hardware_setup(), especially since you need
> tdp_mmu_enabled, not enable_ept.

Thanks for review.  With tdp_mmu_enabled, removing warning and comments,
I come up with the followings.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index aa66b0510062..ba2738cc6e98 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -110,6 +110,7 @@ static bool __ro_after_init tdp_mmu_allowed;
 #ifdef CONFIG_X86_64
 bool __read_mostly tdp_mmu_enabled = true;
 module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0444);
+EXPORT_SYMBOL_GPL(tdp_mmu_enabled);
 #endif
 
 static int max_huge_page_level __read_mostly;
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 976cf5e37f0f..e6f66f7c04bb 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1253,14 +1253,9 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 	int r = 0;
 	int i;
 
-	if (!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)) {
-		pr_warn("MOVDIR64B is reqiured for TDX\n");
+	if (!tdp_mmu_enabled || !enable_mmio_caching ||
+	    !cpu_feature_enabled(X86_FEATURE_MOVDIR64B))
 		return -EOPNOTSUPP;
-	}
-	if (!enable_ept) {
-		pr_warn("Cannot enable TDX with EPT disabled\n");
-		return -EINVAL;
-	}
 
 	max_pkgs = topology_max_packages();
 	tdx_mng_key_config_lock = kcalloc(max_pkgs, sizeof(*tdx_mng_key_config_lock),
-- 
2.43.2

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

