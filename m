Return-Path: <kvm+bounces-26497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15C73975075
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 13:07:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D09CB28EA20
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 11:07:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C5EE186E3C;
	Wed, 11 Sep 2024 11:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bwv2ng3S"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16308185B69;
	Wed, 11 Sep 2024 11:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726052865; cv=none; b=l1APqNbdrNme4Ou0BqcYEtUpzTIlf3ESlr2cELF+zGjt/oyFO4CYEtVKlrdIj0s72agiMZf4br1glp0VzDDCWUn2grx2CamPsgFu0/dnr4YEexGOuRo2fXUhXSqF5Q9UYOfOpnHStmpygFHzDkx+5D6C/IwilvueQ6N0dmWjbIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726052865; c=relaxed/simple;
	bh=EHzJ4DgGly8FnJWERlM/+1lYAmY4UaR+IJ8d2rg5vDw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cYrkvGpa+yrmpRYdsy/TI3G5nmvVHwg/N/93mdPO8TFUeXyXZxwoVALIN0OKgR3yGpW5LSxqQnfh5kEW0dQSdwo0ejDFcSPKZh5+UzywkWUxkeY08yak4Ng0Qd2+km7ZUaG6YaJ+oIe15QGUsmr23GalNwGD9UZOt5Wb67VcJrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bwv2ng3S; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726052864; x=1757588864;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EHzJ4DgGly8FnJWERlM/+1lYAmY4UaR+IJ8d2rg5vDw=;
  b=bwv2ng3S3/fGmGjKeicEd+VfAPJFrirXOp+5mM/EpYPNzCYCcLuHn/24
   HoyF/qRDs9tOQEqMFUvgAoISgQYO2NbQFrAyJYitlEXlAUbwBAUkSdaBJ
   wkqarf3Oloup4H0rjFrC3PF5IY4jnD5Xv3Yk7PDrwk4EBWhINtYclkC40
   HEXgEIB1m/5e/EtBzbMqANAWcG7nFYEuj3Bh+Ci7W4T+0F70t3WWPaWxh
   vBJ6AbhU/H/p06wvuVSFuAj1dKYN2wrhx4rSCFe/6LBDAO9+3Wnf3xE5t
   AV64IZTIc/Pom+ZH291nImJ+Eq9p6fmonxw7pv0l7QOJJBLO9DiRY/98N
   w==;
X-CSE-ConnectionGUID: 2AzrkqcPQamqJLBj9u17dg==
X-CSE-MsgGUID: +Buv0wppQ425gMFi9C4jhg==
X-IronPort-AV: E=McAfee;i="6700,10204,11191"; a="28732148"
X-IronPort-AV: E=Sophos;i="6.10,219,1719903600"; 
   d="scan'208";a="28732148"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2024 04:07:43 -0700
X-CSE-ConnectionGUID: K9+7JlZKSVScMwmx0QkKLQ==
X-CSE-MsgGUID: 1YJCfvayT9C+IAsjs91Fqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,219,1719903600"; 
   d="scan'208";a="72109615"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.117])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2024 04:07:40 -0700
Date: Wed, 11 Sep 2024 14:07:35 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Chao Gao <chao.gao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	kvm@vger.kernel.org, kai.huang@intel.com, isaku.yamahata@gmail.com,
	xiaoyao.li@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/25] KVM: TDX: Initialize KVM supported capabilities
 when module setup
Message-ID: <ZuF59wAEskIq_9Ve@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-11-rick.p.edgecombe@intel.com>
 <ZrrSMaAxyqMBcp8a@chao-email>
 <ZtGEBiAS7-NzBIoE@tlindgre-MOBL1>
 <9aa024ba-a0b7-41b4-80e1-e9979a9495ec@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9aa024ba-a0b7-41b4-80e1-e9979a9495ec@redhat.com>

On Tue, Sep 10, 2024 at 06:58:06PM +0200, Paolo Bonzini wrote:
> On 8/30/24 10:34, Tony Lindgren wrote:
> > On Tue, Aug 13, 2024 at 11:25:37AM +0800, Chao Gao wrote:
> > > On Mon, Aug 12, 2024 at 03:48:05PM -0700, Rick Edgecombe wrote:
> > > > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > > > +static int __init setup_kvm_tdx_caps(void)
> > > > +{
> > > > +	const struct tdx_sysinfo_td_conf *td_conf = &tdx_sysinfo->td_conf;
> > > > +	u64 kvm_supported;
> > > > +	int i;
> > > > +
> > > > +	kvm_tdx_caps = kzalloc(sizeof(*kvm_tdx_caps) +
> > > > +			       sizeof(struct kvm_tdx_cpuid_config) * td_conf->num_cpuid_config,
> > > 
> > > struct_size()
> > > 
> > > > +			       GFP_KERNEL);
> > > > +	if (!kvm_tdx_caps)
> > > > +		return -ENOMEM;
> > 
> > This will go away with the dropping of struct kvm_tdx_caps. Should be checked
> > for other places though.
> 
> What do you mean exactly by dropping of struct kvm_tdx_caps?

I think we can initialize the data as needed based on td_conf.

Regards,

Tony

