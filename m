Return-Path: <kvm+bounces-25477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38D6B965AA5
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 10:44:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA261283176
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 08:44:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A3AC16F0EF;
	Fri, 30 Aug 2024 08:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ANmUWpk+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6725916EB77;
	Fri, 30 Aug 2024 08:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725007470; cv=none; b=RcsLZYoimUM1JpZ8yau0PLMKb225vL/3hnryHCAz8vLEBzK4Xlrt+C5MU1c744f8uJHl3UaYfinzc6uvLQeXjGc07fEZLC+m8yCCDBCe5PO9LhxewWEDktw4gMXtSOFvmPzciUYq//tK6CaObEKeJrvV+bzhjYj2Ej3Su2MihLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725007470; c=relaxed/simple;
	bh=nWORpDjHBlmvyxz56zK8RG+lMeot8yHSeyqRH13vmP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mhQfEwpoYuHN78WHgROIKSlT+Md1Eu0x38M/e3RlDjSKc5M/PEF4kmrJtDgGvFFExAruaayvI3Dytykdrxasmy9JRBet06+1B3M5VJFtuSf1+R0Pgzhot28KfJbOaFF5BwfN+At8HKgVZgaOvc0S847KiWqTUWUHR63DSkyxLxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ANmUWpk+; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725007468; x=1756543468;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nWORpDjHBlmvyxz56zK8RG+lMeot8yHSeyqRH13vmP0=;
  b=ANmUWpk+jgqmdhQtltlvgVSwlT+8cRPP8Vlt/D5jJSXWutW1KdlnkkjW
   /uBGiKgbvs5ZrRVtqy1o9SkEEhaQnYO15vG9cEUsLF9vma1XF+JTcS0K+
   W7C/oY+9+K7MB/gt7W2M6d8kn0fvXX7VJFfdZvADOaITRGnd9flVF5ndI
   6D8lwdRWW/1Q9NLee1DDsMHEMUNkACqfGgsX36BW85BoAmHgpFqniZ68C
   4Mac2cZQMGYDR55a+3wQqToEvCj2uN3Sf1dS9gtJ5l0Pko85+aVjwmMbC
   K2Vlc8wVq7ikfyaRqbJw0sjwYxTlzT/T380yo6git5sGxWhMoJjWufr2T
   g==;
X-CSE-ConnectionGUID: PBEUvDZXTFCQjSD3bq5tRA==
X-CSE-MsgGUID: 77LFr8eZSuqPxWcEFvtz4A==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="46150404"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="46150404"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 01:44:28 -0700
X-CSE-ConnectionGUID: AKOPcsXaRnS5rUr6GjQcew==
X-CSE-MsgGUID: Mysq7RXlT6alWhWasCxvsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="63798628"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.63])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 01:44:23 -0700
Date: Fri, 30 Aug 2024 11:44:18 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "Gao, Chao" <chao.gao@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/25] KVM: TDX: Initialize KVM supported capabilities
 when module setup
Message-ID: <ZtGGYmE3rE7d1wiu@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-11-rick.p.edgecombe@intel.com>
 <ZrrSMaAxyqMBcp8a@chao-email>
 <185d2a6c0317fe74fdb449df62dbafcb922a74f3.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <185d2a6c0317fe74fdb449df62dbafcb922a74f3.camel@intel.com>

On Tue, Aug 13, 2024 at 05:26:06AM +0000, Huang, Kai wrote:
> On Tue, 2024-08-13 at 11:25 +0800, Chao Gao wrote:
> > > +	for (i = 0; i < td_conf->num_cpuid_config; i++) {
> > > +		struct kvm_tdx_cpuid_config source = {
> > > +			.leaf = (u32)td_conf->cpuid_config_leaves[i],
> > > +			.sub_leaf = td_conf->cpuid_config_leaves[i] >> 32,
> > > +			.eax = (u32)td_conf->cpuid_config_values[i].eax_ebx,
> > > +			.ebx = td_conf->cpuid_config_values[i].eax_ebx >> 32,
> > > +			.ecx = (u32)td_conf->cpuid_config_values[i].ecx_edx,
> > > +			.edx = td_conf->cpuid_config_values[i].ecx_edx >> 32,
> > > +		};
> > > +		struct kvm_tdx_cpuid_config *dest =
> > > +			&kvm_tdx_caps->cpuid_configs[i];
> > > +
> > > +		memcpy(dest, &source, sizeof(struct kvm_tdx_cpuid_config));
> > 
> > this memcpy() looks superfluous. does this work?
> > 
> > 		kvm_tdx_caps->cpuid_configs[i] = {
> > 			.leaf = (u32)td_conf->cpuid_config_leaves[i],
> > 			.sub_leaf = td_conf->cpuid_config_leaves[i] >> 32,
> > 			.eax = (u32)td_conf->cpuid_config_values[i].eax_ebx,
> > 			.ebx = td_conf->cpuid_config_values[i].eax_ebx >> 32,
> > 			.ecx = (u32)td_conf->cpuid_config_values[i].ecx_edx,
> > 			.edx = td_conf->cpuid_config_values[i].ecx_edx >> 32,
> > 		};
> 
> This looks good to me.  I didn't try to optimize because it's done in the
> module loading time.

I'll do a patch to initialize dest directly without a memcpy().

Tony

