Return-Path: <kvm+bounces-15544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 53F118AD354
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 19:34:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D5D9DB20F08
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 17:34:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC1B2153BF5;
	Mon, 22 Apr 2024 17:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gNx/9Y6w"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D354146A6A;
	Mon, 22 Apr 2024 17:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713807259; cv=none; b=O7475xpMNMib79axnx42znY6Xi1kOoOSXYINaq+ZKIZVtj0YmLsBStg5fBE9Xdhs5nu70QM9Cdxb/76wkUUVggeFTKsKcPEWzb7srXAkwqfE1r28V2h30TnZ19G805BLi/E/QWW4g8oBYUb8et5e6Rt2Rg8ntkidjKnFFfeY8e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713807259; c=relaxed/simple;
	bh=CtkdzXdAdH5gbzYeGAqYpxDqL2frKUxXG+eSiaqEq0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uXljtWTgY02hgk07iQRmh0TGag8WlGg3ZpjoB/YdubgxDRTCUAKTxalhechPSIZYeBd7nm1ePh21PzfSzaUy2cEaBK2/wXcniLaO+x6xJMpitaoBShCWAzf0pcHf3A2fPXm/CPRCV0x3+B2Rc+dc4UWL4uvfB/VDknwY8u70IzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gNx/9Y6w; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713807258; x=1745343258;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CtkdzXdAdH5gbzYeGAqYpxDqL2frKUxXG+eSiaqEq0Y=;
  b=gNx/9Y6wXT6VI62sAu4ehpCtj1zss+8AIAaEqAqs197hI+8qzJTzKZDf
   VxOEVtgGebhQ3OsJ13KDi3CCtuBkyHE/sql6sNcBLaj05uPL85iXX2uoC
   6CW5YzHoUBJxlmy7h9mZT/zFBvMLlTPyY9QkDQX7XHBqEUIXFp5q/vgaR
   4k0pLvFie3i2rue/GiUcmjjvUAHqCHM4QAQspcgI6kEyt9oMHMMq7/8HZ
   ApnUHCmtxUJMlfeEC3z6bYNRHne1iN0rxMsyFj1N/4LJAMVQl9zXTDjJb
   OJ4jDwvJYsWsVkL6ACBaZajY9lXZL4QHaV/6BlzxPkCQFChP5WEcz4IF6
   Q==;
X-CSE-ConnectionGUID: ToG5ZEPiSHiM67+vxm0Ctg==
X-CSE-MsgGUID: giGBvsBKQmeT4wZIC/WXVA==
X-IronPort-AV: E=McAfee;i="6600,9927,11052"; a="13193756"
X-IronPort-AV: E=Sophos;i="6.07,221,1708416000"; 
   d="scan'208";a="13193756"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 10:34:18 -0700
X-CSE-ConnectionGUID: 0Kr9rkLySKmCW5Evqz0lKQ==
X-CSE-MsgGUID: piQOTgyTQmCywsB4u+mvfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,221,1708416000"; 
   d="scan'208";a="55019332"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 10:34:16 -0700
Date: Mon, 22 Apr 2024 10:34:15 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 125/130] KVM: TDX: Add methods to ignore virtual apic
 related operation
Message-ID: <20240422173415.GK3596705@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <52300c655b1e7d6cc0a13727d977f1f02729a4bb.1708933498.git.isaku.yamahata@intel.com>
 <1a3f4283-0dfd-4b7d-ae1b-f22c13a8c4e1@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1a3f4283-0dfd-4b7d-ae1b-f22c13a8c4e1@linux.intel.com>

On Mon, Apr 22, 2024 at 09:56:05AM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 2/26/2024 4:27 PM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > TDX protects TDX guest APIC state from VMM.  Implement access methods of
> > TDX guest vAPIC state to ignore them or return zero.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >   arch/x86/kvm/vmx/main.c    | 61 ++++++++++++++++++++++++++++++++++----
> >   arch/x86/kvm/vmx/tdx.c     |  6 ++++
> >   arch/x86/kvm/vmx/x86_ops.h |  3 ++
> >   3 files changed, 64 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > index fae5a3668361..c46c860be0f2 100644
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -352,6 +352,14 @@ static bool vt_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
> >   	return vmx_apic_init_signal_blocked(vcpu);
> >   }
> > +static void vt_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
> > +{
> > +	if (is_td_vcpu(vcpu))
> > +		return tdx_set_virtual_apic_mode(vcpu);
> Can open code this function...

Yes, the function is empty currently.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

