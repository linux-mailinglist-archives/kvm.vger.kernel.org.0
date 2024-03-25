Return-Path: <kvm+bounces-12619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2025888B2D4
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 22:31:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFF583243F1
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 21:31:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEE9D6E61F;
	Mon, 25 Mar 2024 21:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FeDtuX5g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E61C5D8E8;
	Mon, 25 Mar 2024 21:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711402285; cv=none; b=W8fs3SchCK1b5cIxyf72i1aWvNhcSWQYwc4omIrkwASJLN/8MvHtDIGBoFB5d/gx3DRBm0wAqcAcM69Ygbyo23MxnfWJCAmtsPVPsNgfyuD6Fxh0l5cFYePSAMJ8w3OueNZiTPZZJF58h/UspRvqIok82jtoeBnl5/WbDfK8SWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711402285; c=relaxed/simple;
	bh=a0171MH8GwAhsRwHjY+zW/6uyiF7puogHyCqDwYlDOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m8VrUxZUZNVlhKckLTdmIJBUOXdJFxtze1ovgVmZo9VoYCFjGO0J+CfIHLgxsMw3g8rAzqxU0AEQgJLJWQp8l3drB4hG28MadVNWHoAvRQaMBYaMowewZfe2mPhVGn73QaeXiHaEKUVFFHjTkGsGBKHN9bpkLcHelwAQPvgxDbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FeDtuX5g; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711402283; x=1742938283;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=a0171MH8GwAhsRwHjY+zW/6uyiF7puogHyCqDwYlDOI=;
  b=FeDtuX5g6dvvAy/qjU780H7Hpn1uP82D9n0pEidr1Y08SIkgYLDrFTGC
   dZlGwEm4c15pPKEaU7mHQhSNAM67sCoR9aSxasrLCD7jJ/rEXZBzox7Pw
   DRgSyeRqAnFFXeYfNeGrXVVRti+L0hKJjZTLqXaycPLPxEOU2hZXWWaE4
   6/n/Ft/edeakMc0s3Bp9z2A6EoZCpqSTfBvW2ffBfWb8Wc0Lfw+kKm9hJ
   MFGloz2AYoKaODFCT0G0Hu6YmZJvVrL3gtiqscqKvsoU103OH/GhGIkSn
   tOZrojTZpnkFO8zb1igCXBtoKS66JlJW3I4f71paLFsO1w3tQp31xb/zZ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11024"; a="7026446"
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="7026446"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 14:31:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="15800539"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 14:31:19 -0700
Date: Mon, 25 Mar 2024 14:31:18 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, chen.bo@intel.com,
	hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend
 specific
Message-ID: <20240325213118.GL2357401@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9bd868a287599eb2a854f6983f13b4500f47d2ae.1708933498.git.isaku.yamahata@intel.com>
 <a0155c6f-918b-47cd-9979-693118f896fc@intel.com>
 <20240323011335.GC2357401@ls.amr.corp.intel.com>
 <fde1729f-aca7-4cf8-a2cb-a7fde5b4f936@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fde1729f-aca7-4cf8-a2cb-a7fde5b4f936@linux.intel.com>

On Mon, Mar 25, 2024 at 04:42:36PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 3/23/2024 9:13 AM, Isaku Yamahata wrote:
> > On Fri, Mar 22, 2024 at 12:36:40PM +1300,
> > "Huang, Kai" <kai.huang@intel.com> wrote:
> > 
> > > So how about:
> > Thanks for it. I'll update the commit message with some minor fixes.
> > 
> > > "
> > > TDX has its own mechanism to control the maximum number of VCPUs that the
> > > TDX guest can use.  When creating a TDX guest, the maximum number of vcpus
> > > needs to be passed to the TDX module as part of the measurement of the
> > > guest.
> > > 
> > > Because the value is part of the measurement, thus part of attestation, it
> >                                                                             ^'s
> > > better to allow the userspace to be able to configure it.  E.g. the users
> >                    the userspace to configure it                 ^,
> > > may want to precisely control the maximum number of vcpus their precious VMs
> > > can use.
> > > 
> > > The actual control itself must be done via the TDH.MNG.INIT SEAMCALL itself,
> > > where the number of maximum cpus is an input to the TDX module, but KVM
> > > needs to support the "per-VM number of maximum vcpus" and reflect that in
> >                          per-VM maximum number of vcpus
> > > the KVM_CAP_MAX_VCPUS.
> > > 
> > > Currently, the KVM x86 always reports KVM_MAX_VCPUS for all VMs but doesn't
> > > allow to enable KVM_CAP_MAX_VCPUS to configure the number of maximum vcpus
> >                                                       maximum number of vcpus
> > > on VM-basis.
> > > 
> > > Add "per-VM maximum vcpus" to KVM x86/TDX to accommodate TDX's needs.
> > > 
> > > The userspace-configured value then can be verified when KVM is actually
> >                                               used
> 
> Here, "verified", I think Kai wanted to emphasize that the value of
> max_vcpus passed in via
> KVM_TDX_INIT_VM should be checked against the value configured via
> KVM_CAP_MAX_VCPUS?
> 
> Maybe "verified and used" ?

Ok. I don't have strong opinion here.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

