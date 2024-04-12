Return-Path: <kvm+bounces-14575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ECB58A3706
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 22:23:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CAA8BB24CD9
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 20:23:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2046C1514CF;
	Fri, 12 Apr 2024 20:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K2C91B5K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660C114A091;
	Fri, 12 Apr 2024 20:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712953390; cv=none; b=ZJ4N4S43lP1HBiibPKF15+2s3QFTFtrrL78O9qysbrJa33aRNtKrYyzflUmilX8Sv4e/fuG7W9c/uZTvheDIftq6dIA/828YuqmLr9zw7cO4aEc5I4pKhz8KH5i58LCJw7aDZ2pEiTki7jUZPUch3SbrH2KrdU5Zxp5ugNLoTYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712953390; c=relaxed/simple;
	bh=0e7QtWcrYcZu/1mJ7SvXgWqTcC4MGPyYxRyJTfLNCFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O4NqD4OGhj4krKU2EPhgzrriscCUqfYFm+xgXiaytEuISXahmxiHNaFWs+75J4qEYy0P+3Ovh38WdGVU3eb2yPDLeODMoszGNx8dDSqa0kcK9G/kobVHJMaSUSfu/1xPfQfv5lB2Wy+xgK+btMDNRmKOwL9fA3uHORtg1x8Du2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K2C91B5K; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712953388; x=1744489388;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0e7QtWcrYcZu/1mJ7SvXgWqTcC4MGPyYxRyJTfLNCFQ=;
  b=K2C91B5KQ4EHbsE8OKE5yBLv4NPiwNZ6ukRG2Ewk5q3G3QSipmUwjTHv
   hOPvHpmspN2WR6jpUM7CMp/ljLJnSCcrku2m2zYCG8A3RKu3B/o8AGTub
   DNtY36iua5IhE47uY8k9/f4eo4Nt85uCVTFHNwbyoeEMNSNguKMrtSp/V
   bRX+TyCcWZ2G4XJ9X4LrcdG3Ya+E/6Vt27lK5cjDpNXulcIgzG+XWo2gD
   E1QkXTmadArl+ZXIbkzYOun2V60Wr+eB7v8LdPmYSk69oAtaOy5+fwpAm
   YZrq7TThb1khWhryNQdhFS9zsY0OG7lPrv0lL3jzpSz4z7U2ystKzPX4o
   Q==;
X-CSE-ConnectionGUID: pj698n8mRc2b4tF8c6yiNQ==
X-CSE-MsgGUID: T8XUXINVQ7OpF4NMyD7I+w==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="8553140"
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="8553140"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 13:23:08 -0700
X-CSE-ConnectionGUID: mzZrOC12T4ifdGfSPIm59Q==
X-CSE-MsgGUID: CpZlv0XMRLa7zOC7/sxuqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="21901413"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 13:23:07 -0700
Date: Fri, 12 Apr 2024 13:23:05 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Chao Gao <chao.gao@intel.com>, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 081/130] KVM: x86: Allow to update cached values in
 kvm_user_return_msrs w/o wrmsr
Message-ID: <20240412202305.GL3039520@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <ac270005b09c45512504e1e99a80c56f3019496a.1708933498.git.isaku.yamahata@intel.com>
 <bd193eed-25c0-4b00-86be-cc08d994343e@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bd193eed-25c0-4b00-86be-cc08d994343e@linux.intel.com>

On Sun, Apr 07, 2024 at 01:36:46PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index b361d948140f..1b189e86a1f1 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -440,6 +440,15 @@ static void kvm_user_return_msr_cpu_online(void)
> >   	}
> >   }
> > +static void kvm_user_return_register_notifier(struct kvm_user_return_msrs *msrs)
> > +{
> > +	if (!msrs->registered) {
> > +		msrs->urn.on_user_return = kvm_on_user_return;
> > +		user_return_notifier_register(&msrs->urn);
> > +		msrs->registered = true;
> > +	}
> > +}
> > +
> >   int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
> >   {
> >   	unsigned int cpu = smp_processor_id();
> > @@ -454,15 +463,21 @@ int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
> >   		return 1;
> >   	msrs->values[slot].curr = value;
> > -	if (!msrs->registered) {
> > -		msrs->urn.on_user_return = kvm_on_user_return;
> > -		user_return_notifier_register(&msrs->urn);
> > -		msrs->registered = true;
> > -	}
> > +	kvm_user_return_register_notifier(msrs);
> >   	return 0;
> >   }
> >   EXPORT_SYMBOL_GPL(kvm_set_user_return_msr);
> > +/* Update the cache, "curr", and register the notifier */
> Not sure this comment is necessary, since the code is simple.

Ok, let's remove it.


> > +void kvm_user_return_update_cache(unsigned int slot, u64 value)
> 
> As a public API, is it better to use "kvm_user_return_msr_update_cache"
> instead of "kvm_user_return_update_cache"?
> Although it makes the API name longer...

Yes, other functions consistently user user_return_msr. We should do so.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

