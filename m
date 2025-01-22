Return-Path: <kvm+bounces-36225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 584E3A18D1D
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 08:52:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 356891889FF6
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 07:52:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54C1C1C3BE6;
	Wed, 22 Jan 2025 07:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JnSIc1Vf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA57917DE36;
	Wed, 22 Jan 2025 07:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737532357; cv=none; b=lp95jdKW7p0IFDgR7zbJ1OOXlo0H3ANldlggqWWyuZrEp4uYGiGAfuedZq2+l4hj1hATsTzSsYFxG4g8coI8vDHycVaBFfEeEkp7i68T9HeEvWZi7fP0acf855gLLatJ58U3NjxoHnioh8lGBd+7ZV9Hg1jq743Zmwy4vrQ5+9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737532357; c=relaxed/simple;
	bh=Q6vLivM4jtrTFDwno2vu0WSq7oz0yBfS4ZY8fxV3sww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ap1kMZqLTqSU8CZthsWizmUFH5u+q+kBr3KUiIjQc2ydMFHyjeQMztAkASsUaR+wrdxbM8QHaGjQ0KIn1UJNTNgTg416PhMlHr1jcxvlQXSDhgKsD47C3tDPdZc8HN3o1bDxwULmAS3guDgnl9WDbxhGZIg4JURJO/Zmc/dOeYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JnSIc1Vf; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737532356; x=1769068356;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Q6vLivM4jtrTFDwno2vu0WSq7oz0yBfS4ZY8fxV3sww=;
  b=JnSIc1VfWEIYOKA6fUhnO2WIl5RK06biE++SvMXDXIq4zoM+2rSrVXVc
   wzEbthPHxdktJljDT8Gg3qtxv3gwJCC25ORgev9Q+u8N0gVZPYP2jOn0t
   okruKyZ7MY22JuxWsBlWU0TdZXbT9wL7LJtp0SDltYSYV/K3gMMxdkAdc
   t/CAsOh5zr0wUKXX8wJdwvW6485tu/DVhMP+3IFwp9uU7aLoKBYaO+frL
   WerQWseLSL2DqwHeNXSZCNlivSy2dysapoW2+G0xilGcjoKqeqjPpMxzo
   mp7ypCFNokCZXRtyKmtBlMHjktCmx+QAr6wrQU2PttqTDHEw8hXFBcQF4
   A==;
X-CSE-ConnectionGUID: swWQn6cWRq+NyxTeb6BR9g==
X-CSE-MsgGUID: gv0PjfTvRGiTkYeBzMai5A==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="38078310"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="38078310"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2025 23:52:36 -0800
X-CSE-ConnectionGUID: hO/pC5qwQhqEvwZAT8Sogw==
X-CSE-MsgGUID: dgmEoyUhSTiZpt0COjusRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="130353459"
Received: from mjarzebo-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.245])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2025 23:52:31 -0800
Date: Wed, 22 Jan 2025 09:52:26 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Francesco Lavra <francescolavra.fl@gmail.com>
Cc: rick.p.edgecombe@intel.com, isaku.yamahata@gmail.com,
	isaku.yamahata@intel.com, kai.huang@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, pbonzini@redhat.com,
	reinette.chatre@intel.com, seanjc@google.com, xiaoyao.li@intel.com,
	yan.y.zhao@intel.com
Subject: Re: [PATCH v2 11/25] KVM: TDX: Add placeholders for TDX VM/vCPU
 structures
Message-ID: <Z5Cjukf9K_1bTxVN@tlindgre-MOBL1>
References: <20241030190039.77971-12-rick.p.edgecombe@intel.com>
 <23ea8b82982950e171572615cd563da05dfa4f27.camel@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23ea8b82982950e171572615cd563da05dfa4f27.camel@gmail.com>

On Sun, Jan 05, 2025 at 11:58:12AM +0100, Francesco Lavra wrote:
> On 2024-10-30 at 19:00, Rick Edgecombe wrote:
> > --- a/arch/x86/kvm/vmx/tdx.h
> > +++ b/arch/x86/kvm/vmx/tdx.h
> > @@ -4,9 +4,58 @@
> >  #ifdef CONFIG_INTEL_TDX_HOST
...

> >  #else
> >  static inline void tdx_bringup(void) {}
> >  static inline void tdx_cleanup(void) {}
> > +
> > +#define enable_tdx	0
> > +
> > +struct kvm_tdx {
> > +	struct kvm kvm;
> > +};
> > +
> > +struct vcpu_tdx {
> > +	struct kvm_vcpu	vcpu;
> > +};
> > +
> > +static inline bool is_td(struct kvm *kvm) { return false; }
> > +static inline bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false;
> > }
> > +static inline struct kvm_tdx *to_kvm_tdx(struct kvm *kvm) { return
> > NULL; }
> > +static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu) {
> > return NULL; }
> 
> IMO the definitions of to_kvm_tdx() and to_tdx() shouldn't be there
> when CONFIG_INTEL_TDX_HOST is not defined: they are (and should be)
> only used in CONFIG_INTEL_TDX_HOST code.

Good idea.

How about let's just make to_kvm_tdx() and to_tdx() private to tdx.c?
They are not currently used anywhere else.

And we can add the #pragma poison GCC to_vmx at the top of tdx.c to avoid
accidental use of to_vmx() in tdx.c like Paolo suggested earlier at [0]
below.

The dummy struct kvm_tdx and vcpu_tdx if CONFIG_INTEL_TDX_HOST is
not defined we could get rid of with a few helpers to get the size.

Regards,

Tony

[0] https://lore.kernel.org/kvm/89657f96-0ed1-4543-9074-f13f62cc4694@redhat.com/

