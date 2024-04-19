Return-Path: <kvm+bounces-15356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C8D948AB4CD
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 20:09:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C42C31C21564
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 18:09:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F57713BC3A;
	Fri, 19 Apr 2024 18:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="apzDTbgX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126E9131E5D;
	Fri, 19 Apr 2024 18:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713550167; cv=none; b=QDPLWz6Q2WicKXDlMaqRPR5G77eY0IFteIL4nq/xLicHOa7z7FvVkJiJL5vlTZq/HNotkQuNGLqhcoK6ZvPeAkpgiLw6ffODppKMNMAQ4Rrydj9d80Hm+tajHlb1tfipt7Qcuk5e4Xcx+/TKqzK9MpV/xR+vZjogPNuu4gimYe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713550167; c=relaxed/simple;
	bh=e7jNr9kYB2x5cikV8oLhMvEBPShgCKfsjNNIEuQnRyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fjq319lS0a7wxJ1ukxSeeHJDE3byyzKtF7ICrHJ9S+jQVMPhKv6TLCXTAQOUIWm2FcleLh3Q2H5wMB8OUYp0lQ14+Cb/vb2m3a/0OIqydMrvyT6QLJCwUl1g0Dugw75L3ilQHqKqo0YoBVXUaVkven5d79IuEsJHGLfGYH8Mou8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=apzDTbgX; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713550167; x=1745086167;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=e7jNr9kYB2x5cikV8oLhMvEBPShgCKfsjNNIEuQnRyQ=;
  b=apzDTbgXYXeC1IEg1AVdDqkjqyimY6SfBWFt12UlTEgFkOr9DurOcln1
   15IDvQlZe4SSW+3CsBcdJGKGnx0BvRqz8HtR0QDAVqM9PKIMwo1WapHps
   dHPJaA/1BXUHCh5g1pE/EoFeZmLbemxitH8DGskVL+ctLOOypBP+KzGJ2
   sg0j23w3ykiCfCukgFIH3NhGFdgDeOAqsQEkeqo4j0LDHhqsGU0+qYO5Z
   1WBzI3U8v8kxE3b4MC0utEWx/eZlinkTbbNfwBCJZRKvz31zSor8OZCb/
   xpgin9fOLKA2cmZACdneW6ZQgEKooOs2Y3gblHfaV2I69ZThSWpoB+uT9
   A==;
X-CSE-ConnectionGUID: fkLieX0PQUOxSeGT2Wrn8A==
X-CSE-MsgGUID: zr+EMvTUTaC5Siw0Up8P8w==
X-IronPort-AV: E=McAfee;i="6600,9927,11049"; a="9035858"
X-IronPort-AV: E=Sophos;i="6.07,214,1708416000"; 
   d="scan'208";a="9035858"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 11:09:26 -0700
X-CSE-ConnectionGUID: VL1qnNktR9+XfXkdif5CoA==
X-CSE-MsgGUID: P50mIDhyQ7KRoiYzPz6vDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,214,1708416000"; 
   d="scan'208";a="27863989"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 11:09:25 -0700
Date: Fri, 19 Apr 2024 11:09:24 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 118/130] KVM: TDX: Add methods to ignore accesses to
 CPU state
Message-ID: <20240419180924.GF3596705@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9258b492295c0ef953f36b9fee60bf3a1873d71b.1708933498.git.isaku.yamahata@intel.com>
 <10b79413-f8ee-4e57-8346-0ac525254888@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <10b79413-f8ee-4e57-8346-0ac525254888@linux.intel.com>

On Fri, Apr 19, 2024 at 06:04:10PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 2/26/2024 4:27 PM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > TDX protects TDX guest state from VMM.  Implement access methods for TDX
> > guest state to ignore them or return zero.  Because those methods can be
> > called by kvm ioctls to set/get cpu registers, they don't have KVM_BUG_ON
> > except one method.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >   arch/x86/kvm/vmx/main.c    | 289 +++++++++++++++++++++++++++++++++----
> >   arch/x86/kvm/vmx/tdx.c     |  48 +++++-
> >   arch/x86/kvm/vmx/x86_ops.h |  13 ++
> >   3 files changed, 321 insertions(+), 29 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > index 84d2dc818cf7..9fb3f28d8259 100644
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -375,6 +375,200 @@ static void vt_vcpu_deliver_init(struct kvm_vcpu *vcpu)
> >   	kvm_vcpu_deliver_init(vcpu);
> >   }
> > +static void vt_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> > +{
> > +	if (is_td_vcpu(vcpu))
> > +		return;
> > +
> > +	vmx_vcpu_after_set_cpuid(vcpu);
> > +}
> > +
> > +static void vt_update_exception_bitmap(struct kvm_vcpu *vcpu)
> > +{
> > +	if (is_td_vcpu(vcpu))
> > +		return;
> > +
> > +	vmx_update_exception_bitmap(vcpu);
> > +}
> > +
> > +static u64 vt_get_segment_base(struct kvm_vcpu *vcpu, int seg)
> > +{
> > +	if (is_td_vcpu(vcpu))
> > +		return tdx_get_segment_base(vcpu, seg);
> Could just return 0?
> Not need to add a function, since it's only called here and it's more
> straight forward to read the code without jump to the definition of these
> functions.
> 
> Similarly, we can use open code for tdx_get_cpl(), tdx_get_rflags() and
> tdx_get_segment(), which return 0 or memset with 0.

Yes, we should drop them. They came from the TDX guest debug.  But right now
we drop the support and we have guard with vcpu->arch.guest_state_protected.

guest debug is a future topic now.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

