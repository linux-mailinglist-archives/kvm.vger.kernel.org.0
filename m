Return-Path: <kvm+bounces-12426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 12121885FC4
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 18:31:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B402F283907
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 17:31:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD57E8592F;
	Thu, 21 Mar 2024 17:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WBeCzKEC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C3BC2E9;
	Thu, 21 Mar 2024 17:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711042252; cv=none; b=CQuQ1eRbz+l41I9y8l6urzI3AlAi33ocf0rLIhpwWA+cNStJ96KGe6kt0BGvmlCWBa5MU2nUWxdSzrTsYLMtwqtDEqPMnNx47AdLHraY0x/zMrN/x7W4LUuaXKVIRv8kO0+z+LAwsKyvbqfCQNZwkZK9i31vQ1+qKWDhDz/iBRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711042252; c=relaxed/simple;
	bh=JBLJEKTf/KkuhDCxb+brKIpIFlLuBd/PKeVfqKF77IM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UOBYSnCydJGD9eMwvc/AwGqo1/vCx0AlSs9AYzMpTIbupsD/En27vnvX2XefviGY6E7UjaOM7QVmtIfWXFLseW/nJYRNSCGccxQM5lxKNFK/M6xNwUsDG2jKkg99n4pwtOwpMHtbf+Xtjiq+8MMwGzsNgLJAedaRsbFB43wAfeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WBeCzKEC; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711042250; x=1742578250;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JBLJEKTf/KkuhDCxb+brKIpIFlLuBd/PKeVfqKF77IM=;
  b=WBeCzKEC5yY0DLvSmCADAbZnDgHFtzQo9MHvc1wIidB4biheFPZL+L43
   fK9xByi5NZgjHWlXBu7YONhNmIif9rnhrNsxKZSVxRd6nBIeiOIf9aVMI
   8ezuMjN3P9DLQIjCEesoecjQuVCOq1h1ePwj3grJT44xqjc4w/KlDg3/2
   Ut4rq6h+r7PxtlKp9YPDd+Fay0LfwbaFrmJbgTqsGNmq9UWMPVWkLX2lq
   YzW2XX5afuzBBDADuZSh1U1e2h8LBxw/wpYr9xbyaiXh1mSsrR1VdMYQH
   vUbDIZi8+f2Ri3m7v9HtA+yyp3yy4WuxaSmrVtNnWFqYdMS7QoFiekEqd
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="6236039"
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="6236039"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 10:30:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="19157301"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 10:30:24 -0700
Date: Thu, 21 Mar 2024 10:30:24 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <20240321173024.GM1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
 <5702443b-510e-4ce5-823f-999582a6aced@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5702443b-510e-4ce5-823f-999582a6aced@intel.com>

On Wed, Mar 20, 2024 at 04:15:23PM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
> 
> ...
> 
> > +static int setup_tdparams_xfam(struct kvm_cpuid2 *cpuid, struct td_params *td_params)
> > +{
> > +	const struct kvm_cpuid_entry2 *entry;
> > +	u64 guest_supported_xcr0;
> > +	u64 guest_supported_xss;
> > +
> > +	/* Setup td_params.xfam */
> > +	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0xd, 0);
> > +	if (entry)
> > +		guest_supported_xcr0 = (entry->eax | ((u64)entry->edx << 32));
> > +	else
> > +		guest_supported_xcr0 = 0;
> > +	guest_supported_xcr0 &= kvm_caps.supported_xcr0;
> > +
> > +	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0xd, 1);
> > +	if (entry)
> > +		guest_supported_xss = (entry->ecx | ((u64)entry->edx << 32));
> > +	else
> > +		guest_supported_xss = 0;
> > +
> > +	/*
> > +	 * PT and CET can be exposed to TD guest regardless of KVM's XSS, PT
> > +	 * and, CET support.
> > +	 */
> > +	guest_supported_xss &=
> > +		(kvm_caps.supported_xss | XFEATURE_MASK_PT | TDX_TD_XFAM_CET);
> > +
> > +	td_params->xfam = guest_supported_xcr0 | guest_supported_xss;
> > +	if (td_params->xfam & XFEATURE_MASK_LBR) {
> > +		/*
> > +		 * TODO: once KVM supports LBR(save/restore LBR related
> > +		 * registers around TDENTER), remove this guard.
> > +		 */
> > +#define MSG_LBR	"TD doesn't support LBR yet. KVM needs to save/restore IA32_LBR_DEPTH properly.\n"
> > +		pr_warn(MSG_LBR);
> > +		return -EOPNOTSUPP;
> 
> This unsupported behavior is totally decided by KVM even if TDX module
> supports it. I think we need to reflect it in tdx_info->xfam_fixed0, which
> gets reported to userspace via KVM_TDX_CAPABILITIES. So userspace will aware
> that LBR is not supported for TDs.

Yes, we can suppress KVM unpported features. I replied at
https://lore.kernel.org/kvm/20240321155513.GL1994522@ls.amr.corp.intel.com/

So far we used KVM_TDX_CAPABILITIES for feature enumeration. I'm wondering about
KVM_GET_DEVICE_ATTR [1].  It's future extensible. It's also consistent with SEV.

[1] https://lore.kernel.org/r/20240226190344.787149-7-pbonzini@redhat.com
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

