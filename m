Return-Path: <kvm+bounces-17634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F1D5D8C88D9
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 16:59:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 80F86B22C74
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 14:59:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0618F82D75;
	Fri, 17 May 2024 14:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LKwiSCWx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C475B6A340;
	Fri, 17 May 2024 14:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715957625; cv=none; b=P0TwONB8Hy1WjK6l0ALldCMNaLRX4R6I9C7x53UqtiY8yedpvvQ6VcNGJCSo/lWlRr+EOzn2conGlFrhuOW/uZLSURZZA0c5Scdx2SsB8Siw2b+ns4i2Hf4NgK6oEpqFPSCurSjjtKlNUgev7P7USD5ZEYd9uFinBRWe9Xao+zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715957625; c=relaxed/simple;
	bh=2n+h1MqlBsTJSMPhCujG6lN011O4pI0ypxnNVsJHFUM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N8/CbSgSedLjcAq7rSmg2F4UMZrH0hjs6kwX/wFgRihKlo3DIJsoSzpo/hbYqtw2MJtxWIdeYP1RtEI7W2AcH+Z09n3YnHRXdR6xINqG+owFkm/ye/nJqvDwamdSwV/WpKXHjz9kieusPOimte4skB7e0LzT3QCgdPTKtaklyXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LKwiSCWx; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715957625; x=1747493625;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2n+h1MqlBsTJSMPhCujG6lN011O4pI0ypxnNVsJHFUM=;
  b=LKwiSCWxZoVu6hmcshu00yJbHNROpqAOYhEsbQNlqVo5Ph/aHC6MwyhL
   8TBYevQhT8dYVT1QZ8nrKSSGdi0eYLrCyLQWHWR4/yTvKcILAWIt2UC/Q
   7laxRFHisTeKgKbD0yEd27VocaM2bFMGHNVNTWnKIC1CprdTOfECmwjhu
   T0adE5QihQxw2DAUjjg7S64ihzphZfFJmx2qxz8qgBd3bL/1pEdf2v/Lh
   aXvJl8VwT3buE5xohULxeP5Ph/7JAJ5yQUHU185BuYsRjSe4Ghs/Qp3DV
   Qc1ZJ9qSnbAa+YH99Wg5mXyRStkgbJklRcE2CXL645JEU/vP7PXGQymGg
   w==;
X-CSE-ConnectionGUID: GmXP6sMKTJWAs6UrP8iNTA==
X-CSE-MsgGUID: Xz8rUX5ZR86W7y122n8ZmA==
X-IronPort-AV: E=McAfee;i="6600,9927,11075"; a="22715279"
X-IronPort-AV: E=Sophos;i="6.08,168,1712646000"; 
   d="scan'208";a="22715279"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 07:53:44 -0700
X-CSE-ConnectionGUID: gtAvEW35RFaJ2q05mclWJw==
X-CSE-MsgGUID: +kPeOz66SPeQE2gfER9KCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,168,1712646000"; 
   d="scan'208";a="36616975"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa005.jf.intel.com with ESMTP; 17 May 2024 07:53:40 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 6C30319E; Fri, 17 May 2024 17:53:38 +0300 (EEST)
Date: Fri, 17 May 2024 17:53:38 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Juergen Gross <jgross@suse.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>, 
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>, 
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, 
	hang.yuan@intel.com, tina.zhang@intel.com, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <etso5bvvs2gq3parvzukujgbatwqfb6lhzoxhenrapav6obbgl@o6lowhrcbucp>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
 <46mh5hinsv5mup2x7jv4iu2floxmajo2igrxb3haru3cgjukbg@v44nspjozm4h>
 <de344d2c-6790-49c5-85be-180bc4d92ea4@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de344d2c-6790-49c5-85be-180bc4d92ea4@suse.com>

On Fri, May 17, 2024 at 04:37:16PM +0200, Juergen Gross wrote:
> On 17.05.24 16:32, Kirill A. Shutemov wrote:
> > On Mon, Feb 26, 2024 at 12:25:41AM -0800, isaku.yamahata@intel.com wrote:
> > > @@ -725,6 +967,17 @@ static int __init tdx_module_setup(void)
> > >   	tdx_info->nr_tdcs_pages = tdcs_base_size / PAGE_SIZE;
> > > +	/*
> > > +	 * Make TDH.VP.ENTER preserve RBP so that the stack unwinder
> > > +	 * always work around it.  Query the feature.
> > > +	 */
> > > +	if (!(tdx_info->features0 & MD_FIELD_ID_FEATURES0_NO_RBP_MOD) &&
> > > +	    !IS_ENABLED(CONFIG_FRAME_POINTER)) {
> > 
> > I think it supposed to be IS_ENABLED(CONFIG_FRAME_POINTER). "!" shouldn't
> > be here.
> 
> No, I don't think so.
> 
> With CONFIG_FRAME_POINTER %rbp is being saved and restored, so there is no
> problem in case the seamcall is clobbering it.

Could you check setup_tdparams() in your tree?

Commit 

[SEAM-WORKAROUND] KVM: TDX: Don't use NO_RBP_MOD for backward compatibility

in my tree comments out the setting TDX_CONTROL_FLAG_NO_RBP_MOD.

I now remember there was problem in EDK2 using RBP. So the patch is
temporary until EDK2 is fixed.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

