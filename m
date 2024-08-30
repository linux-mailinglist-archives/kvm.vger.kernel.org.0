Return-Path: <kvm+bounces-25453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 517DD965689
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 06:46:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 002F81F237C5
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 04:46:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76B9A14C5BA;
	Fri, 30 Aug 2024 04:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QljYKkWG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1BB79D1;
	Fri, 30 Aug 2024 04:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724993152; cv=none; b=spBCd33rrNSbdTTmApEsNeNjZSX6brM6i3mzujdG5oY/jTjrjPWfcp28IU1GHhc2iZ3ODfkBCcldGhAxVKjteYI61sRyb+13wSb8lVpRkeAi8NfSHNGUCmpHclC3J/Y3a4xJPNHlbXwip5akNAOqpSWHtRdQ05NFIZCwdJRN4s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724993152; c=relaxed/simple;
	bh=wRJn/TMf+3XcekLnsBtbI0Uw/swrIGxEprAnYqY1FuY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oeYnvu/UsEyV5i/GtHd5TGvFk0tprKkOUn6W5+9vBYjcorrS1fL+I1zLzMVOHoIwq2/kofSHfc7DqhFh+Rf+3PCBMWxdISLirekYaWVsfcvrIeaN0qmMwLEvoWotkbr6gbteHNlHKRyAcnzgLsLZrlba7I/v0R9Wv/Ffb/mEotc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QljYKkWG; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724993151; x=1756529151;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=wRJn/TMf+3XcekLnsBtbI0Uw/swrIGxEprAnYqY1FuY=;
  b=QljYKkWGLS/SWMN7kAiFobpD2w3/TzBJfpIcVfkKxjSJkIkufGIb20Tx
   bVizT4Ps2Rx/JtwJsovE8T7yfys9lvzHcXyJZs88uVbZh0lqWx1+ULiJ8
   WXndzciEzJaCH+WkRDr4k6qQUIIYrN1ZiBZeqG/9gxB9Crw4xdAZbrM+2
   SG4F3grn8cGCrSp7C+vI/SycgZCaSnOP1TKZylNNYdfskt+0qLICcSMgl
   S4wRgqv7UKulhysSI/gev2imGxEC8oJVn8k43Z+9olyGtHQ6xJm4Ne3Ic
   n+9n8Mri3cmBPAMmq4BxIFuDvs946MIMKdVSwbqXXJMjq5tnu5PIbUcaj
   A==;
X-CSE-ConnectionGUID: wXmmY/h1QpSHY2tnpE9tmA==
X-CSE-MsgGUID: E5Fy2rY1Qhm3cQl7vypBEQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="23420258"
X-IronPort-AV: E=Sophos;i="6.10,187,1719903600"; 
   d="scan'208";a="23420258"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 21:45:50 -0700
X-CSE-ConnectionGUID: wyRj3+I2SI+wmN+ruL72Cw==
X-CSE-MsgGUID: 6S0ghhVuQiGBokGn90cCSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,187,1719903600"; 
   d="scan'208";a="94605146"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.63])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 21:45:45 -0700
Date: Fri, 30 Aug 2024 07:45:41 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/25] KVM: TDX: Define TDX architectural definitions
Message-ID: <ZtFOdSmJobs8Kw5X@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-3-rick.p.edgecombe@intel.com>
 <4eb4a26e-ebad-478e-9635-93f7fbed103b@intel.com>
 <4de6d1fa5f72274af51d063dc17726625de535ac.camel@intel.com>
 <e686a7ac-fc50-4de8-a279-e674ad8a84f4@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e686a7ac-fc50-4de8-a279-e674ad8a84f4@intel.com>

On Fri, Aug 30, 2024 at 09:29:19AM +0800, Xiaoyao Li wrote:
> On 8/30/2024 3:46 AM, Edgecombe, Rick P wrote:
> > On Thu, 2024-08-29 at 21:25 +0800, Xiaoyao Li wrote:
> > > On 8/13/2024 6:47 AM, Rick Edgecombe wrote:
> > > > +/*
> > > > + * TD_PARAMS is provided as an input to TDH_MNG_INIT, the size of which is
> > > > 1024B.
> > > > + */
> > > > +struct td_params {
> > > > +       u64 attributes;
> > > > +       u64 xfam;
> > > > +       u16 max_vcpus;
> > > > +       u8 reserved0[6];
> > > > +
> > > > +       u64 eptp_controls;
> > > > +       u64 exec_controls;
> > > 
> > > TDX 1.5 renames 'exec_controls' to 'config_flags', maybe we need update
> > > it to match TDX 1.5 since the minimum supported TDX module of linux
> > > starts from 1.5.
> > 
> > Agreed.

I'm doing a patch for this FYI.
 
> > > Besides, TDX 1.5 defines more fields that was reserved in TDX 1.0, but
> > > most of them are not used by current TDX enabling patches. If we update
> > > TD_PARAMS to match with TDX 1.5, should we add them as well?
> > 
> > You mean config_flags or supported "features0"? For config_flags, it seems just
> > one is missing. I don't think we need to add it.
> 
> No. I meant NUM_L2_VMS, MSR_CONFIG_CTLS, IA32_ARCH_CAPABILITIES_CONFIG,
> MRCONFIGSVN and MROWNERCONFIGSVN introduced in TD_PARAMS from TDX 1.5.
> 
> Only MSR_CONFIG_CTLS and IA32_ARCH_CAPABILITIES_CONFIG likely need enabling
> for now since they relates to MSR_IA32_ARCH_CAPABILITIES virtualization of
> TDs.

Seems these changes can be separate additional patches.

Regards,

Tony

