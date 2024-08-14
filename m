Return-Path: <kvm+bounces-24078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B8D5951130
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 02:53:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE9EA1C228C3
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 00:53:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92BE3947E;
	Wed, 14 Aug 2024 00:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HEx1I8Q3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E794F171A5;
	Wed, 14 Aug 2024 00:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723596828; cv=none; b=JDek51/m5IcCD7D2zfkA8i9zu6G8rZ748k2+fNzYTXr5tsoCtLD4juF+7meK5HVpP8PjJymCwSGjgez5o917aw6jAPTxBxRhM9+0qgd6H+WV9NME8pqWRRKkMNkmXjbwgGd8Jb3WNfzjFYlIa7lb+Zj6HJdHRVcBpUEuraHKZFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723596828; c=relaxed/simple;
	bh=RMZYDQ24Wd2mO+vaoGlTsQlnxWg83fgryxlAoEv0KdA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IUFfHLxfOzeT91/HlTg64CarxOigOUlVMkkt8gJ2NolYQuBJszuIj90KRDc0HH3YX6IBM14dtidDmltgAbnLzDwR995oHIRnbai1upmkkVS7hAlG5AWFoVL2v5SlTFyb8vwrOk8tAfz/JpV5+i64H+x7JqZhsqdBdgWdQPBNAXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HEx1I8Q3; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723596827; x=1755132827;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RMZYDQ24Wd2mO+vaoGlTsQlnxWg83fgryxlAoEv0KdA=;
  b=HEx1I8Q3lXeO/yEJA8zWSBl8hsYqLxllfZ/gnnNWPHqIDd4JZNI2YA2F
   ME0Bz00Jb3NS+yBG5EBbZykYviHYpAzBT90Xg72Yce25mttn94CGqENVX
   s5cIOTJPklj2zWqqE61nhoLwnlrEFIn2LghRVWdbPZh7/qR/KbaafSQq/
   dCAYIeT473xrGGuhxB8q7yGcHF/0HLUBSfjSgVk61iZA/0dL/cUaDpXHc
   xoNgmCZPjHccfX5kGqEYv4WfLILJBkyRoJZxvHEPG0d+x0hbTk71GFRz2
   MkBupXZN6EUhtWEmRq1vlmdhuzTWpoToox4kWaUQ3dh60vegsoGA2sB0q
   g==;
X-CSE-ConnectionGUID: hi4ZnxggTdKZCBAt0sTrgQ==
X-CSE-MsgGUID: LN+GNln/TVuAuw3TPJYXxQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="21761041"
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="21761041"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 17:53:46 -0700
X-CSE-ConnectionGUID: EOHcmZ0JT4uyQ3rGjvvZtg==
X-CSE-MsgGUID: 7inkNjP2RtqAGmyXJILYDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="58476420"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 17:53:45 -0700
Date: Tue, 13 Aug 2024 17:53:45 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, pbonzini@redhat.com,
	seanjc@google.com, isaku.yamahata@intel.com,
	rick.p.edgecombe@intel.com, michael.roth@amd.com
Subject: Re: [PATCH v2 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
Message-ID: <ZrwAGc/UPtcrN4ug@ls.amr.corp.intel.com>
References: <20240813051256.2246612-1-binbin.wu@linux.intel.com>
 <20240813051256.2246612-2-binbin.wu@linux.intel.com>
 <d7ae5009-748f-4aa2-937e-d805a3172216@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d7ae5009-748f-4aa2-937e-d805a3172216@intel.com>

On Wed, Aug 14, 2024 at 11:16:44AM +1200,
"Huang, Kai" <kai.huang@intel.com> wrote:

> > ---
> >   arch/x86/kvm/x86.c | 4 ++--
> >   arch/x86/kvm/x86.h | 7 +++++++
> >   2 files changed, 9 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index af6c8cf6a37a..6e16c9751af7 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -10226,8 +10226,8 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> >   	cpl = kvm_x86_call(get_cpl)(vcpu);
> >   	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
> > -	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
> > -		/* MAP_GPA tosses the request to the user space. */
> > +	if (!ret && is_kvm_hc_exit_enabled(vcpu->kvm, nr))
> > +		/* The hypercall is requested to exit to userspace. */
> >   		return 0;
> 
> I believe you put "!ret" check first for a reason?  Perhaps you can add a
> comment.

I think he'd like to avoid to hit WARN_ON_ONCE().
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

