Return-Path: <kvm+bounces-12329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A64FA881935
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 22:36:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 46CB31F21D34
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 21:36:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E90FA85C4E;
	Wed, 20 Mar 2024 21:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XGONm0er"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBA633062;
	Wed, 20 Mar 2024 21:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710970566; cv=none; b=eTxGCMNJvrp2H/h2GdKSSh8FiQtrmazQnuRaK2ly0OAMXL92UYlGJOXXR2SulE1xZvMVWTWLf/hNNqtocQpYich9XafBNantY7kDivYB1dhp3VARsDp0phxEuXusLCJ8D0sDGy3Rq5uo4FnIXQYWniwTOeL6VCcBW3FYZGZ6s4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710970566; c=relaxed/simple;
	bh=hX4pslLlcBSoPea9E2mRxNlAbfGvx83GcoZjftStHUw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BLKsK4hj6UwtO6Px5rGwUcZyQK9uQ9nNDwmNgEiCEBTUY1wCRRg/FtT9fm6U1p6hUrOMJTprNOfJKE+D8HxggTnU1vEzkxTnty/sOxlyGDFCd09P6EefeZN73iCDCXolNtwmIdpWFzh+Wq/Y0vDNtJaq4Ch79Q51UlN4y3H+kD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XGONm0er; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710970563; x=1742506563;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hX4pslLlcBSoPea9E2mRxNlAbfGvx83GcoZjftStHUw=;
  b=XGONm0er79JI42oC0Fi1tKlURM51T8UrS43sYJo8L4FVmHrUk02CM4H9
   tn5CXyouSSsi3f0PpZTYrwubVabORvXDxCPljNoZxA+tkSzDv4ashMLaW
   Nha4twMMDpHJ8lVpbCevsHz+2h3WAAUyPKaixkuQ3jTi0aQA1BVVOBfaN
   pxfcbclG2SfXlbrPwoU75sxmdz3BlWF2fNj8MiJAmSedZ+B11k8w+zAU8
   1UlCU4Ux140avVjqKqSMr1HVBe3TYBtiYdlN5HZIqLskpCbPlFWDSzwff
   lDwTn3JnW8lJz4SSqDJpJqkdhAsidrPmktaVsw7fNiYxLRW44jsjc9vfA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11019"; a="5783585"
X-IronPort-AV: E=Sophos;i="6.07,141,1708416000"; 
   d="scan'208";a="5783585"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 14:36:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,141,1708416000"; 
   d="scan'208";a="18869398"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 14:36:01 -0700
Date: Wed, 20 Mar 2024 14:36:00 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, chen.bo@intel.com,
	hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Yuan Yao <yuan.yao@intel.com>, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 029/130] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Message-ID: <20240320213600.GI1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7cfd33d896fce7b49bcf4b7179d0ded22c06b8c2.1708933498.git.isaku.yamahata@intel.com>
 <579cb765-8a5e-4058-bc1d-9de7ac4b95d1@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <579cb765-8a5e-4058-bc1d-9de7ac4b95d1@intel.com>

On Wed, Mar 20, 2024 at 01:03:21PM +1300,
"Huang, Kai" <kai.huang@intel.com> wrote:

> > +static inline u64 tdx_seamcall(u64 op, struct tdx_module_args *in,
> > +			       struct tdx_module_args *out)
> > +{
> > +	u64 ret;
> > +
> > +	if (out) {
> > +		*out = *in;
> > +		ret = seamcall_ret(op, out);
> > +	} else
> > +		ret = seamcall(op, in);
> 
> I think it's silly to have the @out argument in this way.
> 
> What is the main reason to still have it?
> 
> Yeah we used to have the @out in __seamcall() assembly function.  The
> assembly code checks the @out and skips copying registers to @out when it is
> NULL.
> 
> But it got removed when we tried to unify the assembly for TDCALL/TDVMCALL
> and SEAMCALL to have a *SINGLE* assembly macro.
> 
> https://lore.kernel.org/lkml/cover.1692096753.git.kai.huang@intel.com/
> 
> To me that means we should just accept the fact we will always have a valid
> @out.
> 
> But there might be some case that you _obviously_ need the @out and I
> missed?

As I replied at [1], those four wrappers need to return values.
The first three on error, the last one on success.

  [1] https://lore.kernel.org/kvm/20240320202040.GH1994522@ls.amr.corp.intel.com/

  tdh_mem_sept_add(kvm_tdx, gpa, tdx_level, hpa, &entry, &level_state);
  tdh_mem_page_aug(kvm_tdx, gpa, hpa, &entry, &level_state);
  tdh_mem_page_remove(kvm_tdx, gpa, tdx_level, &entry, &level_state);
  u64 tdh_vp_rd(struct vcpu_tdx *tdx, u64 field, u64 *value)

We can delete out from other wrappers.
Because only TDH.MNG.CREATE() and TDH.MNG.ADDCX() can return TDX_RND_NO_ENTROPY,
we can use __seamcall().  The TDX spec doesn't guarantee such error code
convention.  It's very unlikely, though.


> > +static inline u64 tdh_sys_lp_shutdown(void)
> > +{
> > +	struct tdx_module_args in = {
> > +	};
> > +
> > +	return tdx_seamcall(TDH_SYS_LP_SHUTDOWN, &in, NULL);
> > +}
> 
> As Sean already pointed out, I am sure it's/should not used in this series.
> 
> That being said, I found it's not easy to determine whether one wrapper will
> be used by this series or not.  The other option is we introduce the
> wrapper(s) when they get actally used, but I can see (especially at this
> stage) it's also a apple vs orange question that people may have different
> preference.
> 
> Perhaps we can say something like below in changelog ...
> 
> "
> Note, not all VM-managing related SEAMCALLs have a wrapper here, but only
> provide wrappers that are essential to the run the TDX guest with basic
> feature set.
> "
> 
> ... so that people will at least to pay attention to this during the review?

Makes sense. We can split this patch into other patches that first use the
wrappers.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

