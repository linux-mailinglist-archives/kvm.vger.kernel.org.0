Return-Path: <kvm+bounces-25478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E490B965C24
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 10:54:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A42E7287607
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 08:54:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3787116EBE0;
	Fri, 30 Aug 2024 08:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S2wos1Ty"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCFD16DED4;
	Fri, 30 Aug 2024 08:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725008022; cv=none; b=E+9K+HaIhg37siKWyDM8U0bvtVmx2EUNU0tDd1cW5gfm7AfsnO9pMFu10JBMj7f03R0MTk1zLfsybhEv1SU56o52AJgqWNZFRdCo8miLNiUpJx5dUq2BkSO/DVP0XMwIvAr+OnkdA5sNuPA5/JmCx929hi+t4Yw9RF/XmBW+8Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725008022; c=relaxed/simple;
	bh=TU3MSrwb8TrLODtBDsBEhrcdIGfc0V68Tw319uiHy2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rhjBr7a0+lZi9NyoYVhbB9Jto4hqJm9zbjR/j9nxwqf4UxsUscfvWw1x37Xry/oG+yzc4Og7RWEzXFSJEz6rZczalsDCnPSsPMBjZef/xyjNMdHXRnvfMOe3mwIUENkqO04E+ebftLNpmDtrteX3rEE8VHGZbSCHFFy86y+ckJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S2wos1Ty; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725008021; x=1756544021;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TU3MSrwb8TrLODtBDsBEhrcdIGfc0V68Tw319uiHy2o=;
  b=S2wos1Tyu9VSsP1ejHADlJEwHVzEkcRMwfm5zvow6yMimxwmyUbZmg07
   GIvqev8fHHmTBqES2ZVOMON9XWod0nhk5UTS42VP74iG+XV5zD7z8uq7I
   zerKzP1gI9M3xdv4hB1MSAnBO3dAmVP5eXX93XEGublBMLhZEIsR8v4Ix
   FnxCfOXqyrR9MkcK01JIrc07AgFDj+xpYxWRQPUn/rd+xcW0cvPoYTDni
   N0Bkk6qSHAzoLuPPOjJn7DSEkW2Sruqlfvf5lsVP87Jel/kLho0d1B9dN
   /rRkEg4p6HpOnT6P/0WJuYwfgoQ4e3gzSfS4y5wx6PCGe7avvkpZ3n1zY
   g==;
X-CSE-ConnectionGUID: SkmqpBNtSfi3w0+DklGxXQ==
X-CSE-MsgGUID: 6nQTe/MeTB2w9jDb+/IRrA==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="41120957"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="41120957"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 01:53:40 -0700
X-CSE-ConnectionGUID: /p3lcBR8QNG8crPNLRB9mQ==
X-CSE-MsgGUID: umQ0sSEgRA6ZBUmG4rrPjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="64186982"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.63])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 01:53:37 -0700
Date: Fri, 30 Aug 2024 11:53:31 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Tao Su <tao1.su@linux.intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org, kai.huang@intel.com,
	isaku.yamahata@gmail.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [PATCH 12/25] KVM: TDX: Allow userspace to configure maximum
 vCPUs for TDX guests
Message-ID: <ZtGIi_G-3s17_n58@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-13-rick.p.edgecombe@intel.com>
 <ZsKdFu9KTdoLJEBV@linux.bj.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsKdFu9KTdoLJEBV@linux.bj.intel.com>

On Mon, Aug 19, 2024 at 09:17:10AM +0800, Tao Su wrote:
> On Mon, Aug 12, 2024 at 03:48:07PM -0700, Rick Edgecombe wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -44,6 +44,35 @@ struct kvm_tdx_caps {
> >  
> >  static struct kvm_tdx_caps *kvm_tdx_caps;
> >  
> > +int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
> > +{
> > +	int r;
> > +
> > +	switch (cap->cap) {
> > +	case KVM_CAP_MAX_VCPUS: {
> 
> How about delete the curly braces on the case?

Thanks I'll do a patch to drop these. And there's an unpaired if else
bracket cosmetic issue there too.

> > +		if (cap->flags || cap->args[0] == 0)
> > +			return -EINVAL;
> > +		if (cap->args[0] > KVM_MAX_VCPUS ||
> > +		    cap->args[0] > tdx_sysinfo->td_conf.max_vcpus_per_td)
> > +			return -E2BIG;
> > +
> > +		mutex_lock(&kvm->lock);
> > +		if (kvm->created_vcpus)
> > +			r = -EBUSY;
> > +		else {
> > +			kvm->max_vcpus = cap->args[0];
> > +			r = 0;
> > +		}
> > +		mutex_unlock(&kvm->lock);
> > +		break;
> > +	}
> > +	default:
> > +		r = -EINVAL;
> > +		break;
> > +	}

And adding a line break here after the switch.

> > +	return r;
> > +}

Regards,

Tony

