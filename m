Return-Path: <kvm+bounces-16074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 39EF88B3F7A
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 20:38:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C23B51F24EE1
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 18:38:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2382747F;
	Fri, 26 Apr 2024 18:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dP0YN4Yv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935EB4A23;
	Fri, 26 Apr 2024 18:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714156725; cv=none; b=kMuHPB5sA/YbrdxnNPucyYtPo0O9/4E9352L42DvLqospNE2Q89jlBMnkjiSWr9QbxL/rpeI1BjGBd1n79jSPB/hLCruxouZAZammZpGQT26qy8aNOLm4io55KDUPSBQc6ft118UyCdP7CGzfV6kdK9kJJHQl6duleTrMe2qw7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714156725; c=relaxed/simple;
	bh=SZ0a+QERSJsoCy997xFEiy87bwh0vfwyXGIDwWShdug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JbVsFURzJHvgdm4sZi6sPeeHH2nE1q3as9b4AKurqSaDQm3EBPhHDe14jBQI1qvV/6w7x09g+o0iGC7HAhG/94aR2LODTHMjZOg+c8fyJynSOI+WDxf7dzoPrlMhGesQCSt3BUiONmsT4UjdYjUj/CNZcM13qiZVe9dmu4iIGUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dP0YN4Yv; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714156722; x=1745692722;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=SZ0a+QERSJsoCy997xFEiy87bwh0vfwyXGIDwWShdug=;
  b=dP0YN4Yv7eLnxKP4lEU0UQUQtGYw/Zvm/kjteQ7O+su9Wrcm7FVFSbNB
   2hD8YsQ/GYW9I3aIo5qVxbxvXZdWa7EyhfIh4wKsjPy01McsjrrnfPtVB
   yRtvUcEMxhnDtVfrzbnL083iUcSHMvvWZlgfJ8Mm3lDckJlzFhkPr2Her
   X/Nv0rlExSvJIvDvuW0Xos3bols4J3wGaqPiVBxoNRfhWAE/3YNEN7PMR
   aORKIWjyTlLqNddrE8Q9smwCLbu4BQkWroq30QLd5qxZOWBMZ8NYykhjv
   EOD4SBNkvN2RidwenfoBV5lhNjBSRff4OHEnc0Yf0rAjB0Njtfk2a47Ds
   A==;
X-CSE-ConnectionGUID: dG6bj8PoQ5q0DnXJfcLYpw==
X-CSE-MsgGUID: vtS7jOpCTpqxO5KoMJJ8CA==
X-IronPort-AV: E=McAfee;i="6600,9927,11056"; a="21319197"
X-IronPort-AV: E=Sophos;i="6.07,233,1708416000"; 
   d="scan'208";a="21319197"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 11:38:41 -0700
X-CSE-ConnectionGUID: v6j26nX0R82E5FYAD0zYSg==
X-CSE-MsgGUID: SfU9mithQd2X9XTpF3XgXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,233,1708416000"; 
   d="scan'208";a="30298889"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 11:38:41 -0700
Date: Fri, 26 Apr 2024 11:38:40 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yao, Yuan" <yuan.yao@intel.com>, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 030/130] KVM: TDX: Add helper functions to print TDX
 SEAMCALL error
Message-ID: <20240426183840.GS3596705@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <1259755bde3a07ec4dc2c78626fa348cf7323b33.1708933498.git.isaku.yamahata@intel.com>
 <434f5ea4807cdfbe59ec8cbe078ba9c87933e5e7.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <434f5ea4807cdfbe59ec8cbe078ba9c87933e5e7.camel@intel.com>

On Wed, Apr 24, 2024 at 12:11:25AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Mon, 2024-02-26 at 00:25 -0800, isaku.yamahata@intel.com wrote:
> > --- a/arch/x86/kvm/vmx/tdx_ops.h
> > +++ b/arch/x86/kvm/vmx/tdx_ops.h
> > @@ -40,6 +40,10 @@ static inline u64 tdx_seamcall(u64 op, struct tdx_module_args *in,
> >  	return ret;
> >  }
> >  
> > +#ifdef CONFIG_INTEL_TDX_HOST
> > +void pr_tdx_error(u64 op, u64 error_code, const struct tdx_module_args *out);
> > +#endif
> > +
> 
> Why this needs to be inside the CONFIG_INTEL_TDX_HOST while other
> tdh_xxx() don't?
> 
> I suppose all tdh_xxx() together with this pr_tdx_error() should only be
> called tdx.c, which is only built when CONFIG_INTEL_TDX_HOST is true?
> 
> In fact, tdx_seamcall() directly calls seamcall() and seamcall_ret(),
> which are only present when CONFIG_INTEL_TDX_HOST is on.
> 
> So things are really confused here.  I do believe we should just remove
> this CONFIG_INTEL_TDX_HOST around pr_tdx_error() so all functions in
> "tdx_ops.h" should only be used in tdx.c.

You're right, please go clean them up.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

