Return-Path: <kvm+bounces-11394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 93C36876C19
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 21:58:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 494AC2834E1
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 20:58:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97AFC5F47B;
	Fri,  8 Mar 2024 20:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fI0l4AwK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E7F5E062;
	Fri,  8 Mar 2024 20:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709931521; cv=none; b=Ygx9+LN+d0zCvx8YuS0V4Us3YllorbZdwcp+/QjWZMTRkJ/s4N6l6JECasq3Bt/7TyBKJrjy6croES6NjkShDA8yMxmC58+h+AVuV0gTWfGTPmtx7ejdgoOJNCuY7Bx22xw9cLuLigv5IXVXDpVg/xj8nVm6Sfvika7P6n+ETE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709931521; c=relaxed/simple;
	bh=ouGvOwjRtMXmy8kwxtlJZ9GeTTI+/olVPO7iYCKpTLo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P7/2jUZNM+bxzgH7B29hcWIDqvupRu1FlKq43VknVXOYuqL085ENjsX0TR8FErzcoe6MunpavLxHOcorwfgw1ELxFfTdvG54yznrLryp7TwH/MbRKKvOp3CtWdF4pO42UXydj8cva4HzUOQY0PN1XWwJX/aYzHJkOVMIhCZy7r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fI0l4AwK; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709931520; x=1741467520;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ouGvOwjRtMXmy8kwxtlJZ9GeTTI+/olVPO7iYCKpTLo=;
  b=fI0l4AwKVCO2hP85BQV+LsVHsHI1kTsHHASM9acEYRwpBDKSnTdRplZQ
   ahQ9A7N4FbRrvT94Zb5vIyHxGCzJ+g1gD0Wl4itXYd3le58j9NqJgsKLP
   jrPOOsuhdM8hv61fO/i5BolTc6FZ+QqbWVnekYW4vHXqIJ9+x4GiBlnUj
   /JSRahRDtAUHAEmOB+3Uoa5Tt64/ogfx1RGS45EiX9R2xyUj4TM18kzgI
   kASjb1nNoKkh8OFrrI6v85a3Zaxez2yN2rD11PnNSibLvyWMF+beGkbUP
   6XEGIv9g/W4W1lwuEOkg5PTl6LiD8VgyhaC/l4l0KC6AFRsZcJ2Ttgs+A
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11007"; a="27141048"
X-IronPort-AV: E=Sophos;i="6.07,110,1708416000"; 
   d="scan'208";a="27141048"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2024 12:58:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,110,1708416000"; 
   d="scan'208";a="41542112"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2024 12:58:38 -0800
Date: Fri, 8 Mar 2024 12:58:38 -0800
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Chen Yu <yu.c.chen@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 080/130] KVM: TDX: restore host xsave state when exit
 from the guest TD
Message-ID: <20240308205838.GA713729@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <2894ed10014279f4b8caab582e3b7e7061b5dad3.1708933498.git.isaku.yamahata@intel.com>
 <Zel7kFS31SSVsSaJ@chenyu5-mobl2>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zel7kFS31SSVsSaJ@chenyu5-mobl2>

On Thu, Mar 07, 2024 at 04:32:16PM +0800,
Chen Yu <yu.c.chen@intel.com> wrote:

> On 2024-02-26 at 00:26:22 -0800, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > On exiting from the guest TD, xsave state is clobbered.  Restore xsave
> > state on TD exit.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> > v19:
> > - Add EXPORT_SYMBOL_GPL(host_xcr0)
> > 
> > v15 -> v16:
> > - Added CET flag mask
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/vmx/tdx.c | 19 +++++++++++++++++++
> >  arch/x86/kvm/x86.c     |  1 +
> >  2 files changed, 20 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 9616b1aab6ce..199226c6cf55 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -2,6 +2,7 @@
> >  #include <linux/cpu.h>
> >  #include <linux/mmu_context.h>
> >  
> > +#include <asm/fpu/xcr.h>
> >  #include <asm/tdx.h>
> >  
> >  #include "capabilities.h"
> > @@ -534,6 +535,23 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> >  	 */
> >  }
> >  
> > +static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> > +
> > +	if (static_cpu_has(X86_FEATURE_XSAVE) &&
> > +	    host_xcr0 != (kvm_tdx->xfam & kvm_caps.supported_xcr0))
> > +		xsetbv(XCR_XFEATURE_ENABLED_MASK, host_xcr0);
> > +	if (static_cpu_has(X86_FEATURE_XSAVES) &&
> > +	    /* PT can be exposed to TD guest regardless of KVM's XSS support */
> > +	    host_xss != (kvm_tdx->xfam &
> > +			 (kvm_caps.supported_xss | XFEATURE_MASK_PT | TDX_TD_XFAM_CET)))
> > +		wrmsrl(MSR_IA32_XSS, host_xss);
> > +	if (static_cpu_has(X86_FEATURE_PKU) &&
> > +	    (kvm_tdx->xfam & XFEATURE_MASK_PKRU))
> > +		write_pkru(vcpu->arch.host_pkru);
> > +}
> 
> Maybe one minor question regarding the pkru restore. In the non-TDX version
> kvm_load_host_xsave_state(), it first tries to read the current setting
> vcpu->arch.pkru = rdpkru(); if this setting does not equal to host_pkru,
> it trigger the write_pkru on host. Does it mean we can also leverage that mechanism
> in TDX to avoid 1 pkru write(I guess pkru write is costly than a read pkru)?

Yes, that's the intention.  When we set the PKRU feature for the guest, TDX
module unconditionally initialize pkru.  Do you have use case that wrpkru()
(without rdpkru()) is better?
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

