Return-Path: <kvm+bounces-9986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 662098680B0
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 20:16:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F2CB294DD0
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:16:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A20E130ADB;
	Mon, 26 Feb 2024 19:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BRCLsaeV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7909B6A006;
	Mon, 26 Feb 2024 19:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708974906; cv=none; b=Fl9snUwU8EjQV3CVoqzLyLGsk70dx7wGPL//pSLWraVJns+5732Ij3bkUAGstRyTLRFdWwRddmsJJwu5JURVbKB9NyHOJ4PWPhDlnh/cGyGhRxd1slN3+o0cjSnrlnmpcHdSRLdD06L9+G6EtbwcaoTyBp44td+iQCFzhtDQ1iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708974906; c=relaxed/simple;
	bh=LJiXX+ulWwWSULerhyjRE2sXzGGRm+4Qph36BbfVcE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MaKj5Aw4/tj6j7mrDzWcMOfqU4ovKko9hoqycOqT4l4wk3Ot/owQoYvnozZc4sBYIVQxupmFKlqNhCfpV7zHq4gfXfEiKQHek9+a2Py6cO7QwpumIm+aQzm1R1OyjEHX45bKcOwPE2hqpk3hr2zlJVf4vpb2nqtwYXUHfnj1LuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BRCLsaeV; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708974905; x=1740510905;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LJiXX+ulWwWSULerhyjRE2sXzGGRm+4Qph36BbfVcE8=;
  b=BRCLsaeVlWmJmFikCx+S8jt1Z+7a2V27dCKSG6IeDqZTG8yWq+3K7egn
   HMYbvBadP6Hn2zBxn2HwIxr221BaTmtmjMkGgJJxqGUsnNS+nGn7jDWpf
   KMpz/9RKGmFDquBuR9jC8zrvVThSvce3+pI9v7flA/n3/+/whPF+0IkAz
   dzLFplxFDjPwleVdktuUJisys0ud3dD1cWsTzwab6ULL7ur9mpRMwv3e4
   yYjhBXtlZdxS+4acxckM7nLUQZf6XcxrlthYfd5waC1vIM26yinDHm1nK
   iyNqLO++pBc8SiXZhL164MZ4jAEdQ/8RV0igIF452whBEzLilmY5IhMEy
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="14721893"
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="14721893"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 11:15:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="6912300"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 11:15:03 -0800
Date: Mon, 26 Feb 2024 11:15:02 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v18 057/121] KVM: TDX: Add load_mmu_pgd method for TDX
Message-ID: <20240226191502.GO177224@ls.amr.corp.intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <bd5256f2f58c36c6e8712e8137525815eede3bc8.1705965635.git.isaku.yamahata@intel.com>
 <9d024bfc-4b1d-4da5-81ba-36e60cf5e284@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9d024bfc-4b1d-4da5-81ba-36e60cf5e284@linux.intel.com>

On Mon, Feb 05, 2024 at 10:23:34AM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 59d170709f82..25510b6740a3 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -501,6 +501,11 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> >   	 */
> >   }
> > +void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
> > +{
> > +	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
> 
> If we have concern about the alignment of root_hpa, shouldn't we do some
> check instead of masking the address quietly?

Makes sense. I'll add WARN_ON_ONCE(root_hpa & ~PAGE_MASK)
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

