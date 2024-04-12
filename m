Return-Path: <kvm+bounces-14578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C1038A371F
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 22:35:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DCB45285FB3
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 20:35:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9275F27469;
	Fri, 12 Apr 2024 20:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DBnftRm7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D147B17C7F;
	Fri, 12 Apr 2024 20:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712954107; cv=none; b=CWzVPbj94dDdBle2RKrfSJrf9jJfbCpNazMviJnkdCRMa9+KDvumnDHPppvjsATpfbgoCXDK62/5ZNUF0mqG9x2Jp85U6CDAVSo4YtlQODJ5oYT/P3wuLn88C6obwQlOVPH+w7S4SbShAEgVPGkH0Zs08B0TI+v6JCUQNa8TgXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712954107; c=relaxed/simple;
	bh=0J9mzZPgX2hVvKlUVY3N4MBqc7JbB6OQKzDXwHDC1QQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lSv+D6bLPy8Qixh66Ekk/1JnaAX2Xe84W1NKIaY93snWvJaREqUIZrcbWumO4TZ218AROv7Kpbj8Dd0Vcip1AbLvMvUM0CxF0JKCY3GolxWGh8J+KaUnBCeuRo8jXYzMtpqT2IlkIopEqqGcY8V4keknFiyrFARXuTGrRfSb12w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DBnftRm7; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712954106; x=1744490106;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0J9mzZPgX2hVvKlUVY3N4MBqc7JbB6OQKzDXwHDC1QQ=;
  b=DBnftRm77ALMF/Oj+qGtIsN6hrwoMrB8JxSSRWE3eAfA2Mir4tzLpb+I
   umE5qSNEV1x1bW0NdEH/jaAy779vWFUUdOGukPUH/rxJ7MzrTlpSKJxtn
   w1e7wlO8juZ8o748sHCYSVwqNdup/ewGKy6NCr9OPzkSZgPNJ/Jczgovd
   7yf/RNwvUKE4be9WfQJygyYjaPayC+He3na5b8sHTRfTRWpHKZRhitpnv
   5T17GFniUD4Pnyn/ajHOnXc9A9ukUJ6JYhtAu/Xbe/nT3T0VjPNk+MXHZ
   13OQhuHpzfbUXuKEOEqtgUfgzS+HWsMn3yo/wgEeUTtrSirw+opwLVRc5
   w==;
X-CSE-ConnectionGUID: uu27hSEHQayWp6+1PMS4aQ==
X-CSE-MsgGUID: tTEtgK5iR0iiJXLeSEGkkQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="8534610"
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="8534610"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 13:35:05 -0700
X-CSE-ConnectionGUID: nFmbpTc4TYeZZ3LMA4IvLg==
X-CSE-MsgGUID: frT9CWq4Tbuow49Qfberhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="21831600"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 13:35:05 -0700
Date: Fri, 12 Apr 2024 13:35:04 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Yang Weijiang <weijiang.yang@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 083/130] KVM: TDX: Add TSX_CTRL msr into uret_msrs
 list
Message-ID: <20240412203504.GN3039520@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <06135e0897ae90c3dc7fd608948f8bdcd30a17ae.1708933498.git.isaku.yamahata@intel.com>
 <dec685d5-96a7-453d-8b1b-7c662e222977@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dec685d5-96a7-453d-8b1b-7c662e222977@linux.intel.com>

On Sun, Apr 07, 2024 at 03:05:21PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> > From: Yang Weijiang <weijiang.yang@intel.com>
> > 
> > TDX module resets the TSX_CTRL MSR to 0 at TD exit if TSX is enabled for
> > TD. Or it preserves the TSX_CTRL MSR if TSX is disabled for TD.  VMM can
> > rely on uret_msrs mechanism to defer the reload of host value until exiting
> > to user space.
> > 
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> > v19:
> > - fix the type of tdx_uret_tsx_ctrl_slot. unguent int => int.
> > ---
> >   arch/x86/kvm/vmx/tdx.c | 33 +++++++++++++++++++++++++++++++--
> >   arch/x86/kvm/vmx/tdx.h |  8 ++++++++
> >   2 files changed, 39 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 7e2b1e554246..83dcaf5b6fbd 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -547,14 +547,21 @@ static struct tdx_uret_msr tdx_uret_msrs[] = {
> >   	{.msr = MSR_LSTAR,},
> >   	{.msr = MSR_TSC_AUX,},
> >   };
> > +static int tdx_uret_tsx_ctrl_slot;
> > -static void tdx_user_return_update_cache(void)
> > +static void tdx_user_return_update_cache(struct kvm_vcpu *vcpu)
> >   {
> >   	int i;
> >   	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++)
> >   		kvm_user_return_update_cache(tdx_uret_msrs[i].slot,
> >   					     tdx_uret_msrs[i].defval);
> > +	/*
> > +	 * TSX_CTRL is reset to 0 if guest TSX is supported. Otherwise
> > +	 * preserved.
> > +	 */
> > +	if (to_kvm_tdx(vcpu->kvm)->tsx_supported && tdx_uret_tsx_ctrl_slot != -1)
> 
> If to_kvm_tdx(vcpu->kvm)->tsx_supported is true, tdx_uret_tsx_ctrl_slot
> shouldn't be -1 at this point.
> Otherwise, it's a KVM bug, right?
> Not sure if it needs a warning if tdx_uret_tsx_ctrl_slot is -1, or just
> remove the check?

You're right. Let me remove the != -1 check.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

