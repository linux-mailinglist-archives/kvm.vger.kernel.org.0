Return-Path: <kvm+bounces-12161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C2B3F880248
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 17:29:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 51CEF1F24820
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 16:29:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46C68839E3;
	Tue, 19 Mar 2024 16:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GJUedSXd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E5582D90;
	Tue, 19 Mar 2024 16:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710865567; cv=none; b=B6j2UtzH0riam+dY/P6LeSmrgMOrIlz0iw/SA8qlqndDrYsCC/+l9CJ3W8BbKohv1zG5DscKi1/Fxj4WbtwcSBIt1n8mYqPCvsMfzuIM+0ICsOCjnzMkMwTTdmkCFwIa1muEOAp1Cs5cdIjSeCEvCotzd9bkWRdAug2BPAPtbOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710865567; c=relaxed/simple;
	bh=7kIVwSlE4eFk99t/22vuOg96UN+8K/tPFulosQ2Saoc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B5NHkmB52IUQyqEWpTH0bjsIzMsI6e1MR+f+P5dta9ncT93H5wUafpAadembgIRCRjayDy5hktUF9Qi0IqComdLDFR4x+DpBjchumWawhotITuaJnGQieFrp+TVxOnaM3QllxPRgdxtVJveNtM89c7xGENeJFKAmOwTcH18uuCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GJUedSXd; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710865565; x=1742401565;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=7kIVwSlE4eFk99t/22vuOg96UN+8K/tPFulosQ2Saoc=;
  b=GJUedSXdJZX+mBqQn0SyRgFnoKphSinBGefkwki6QA8flipdje274xOi
   tB7TY6YAchNeYaPzXQtEv5aHJpj+O+axwWbLUFIT7M8lZZiya9KELZomO
   FEA6dQfYjvcF0tgrAIKW2LRxAqMUm9OStoPzdBG1U40JPfsUUFIyz1DHL
   ndaBpbiFCnjyyJHfo3Oia2X9qc/N2EupNtfAOAidhOTEeCIk5Qx5rVhij
   kW6PLoLLzKUOMUToYX7L98gTu049Sg6WCxhx4ln3GgMq9euof/zRAwY1k
   Tzt1/2CLz8KoDsawZOAXdIRSpopqZXSeNCvFuzUB4fiKIvcZozHHZLE9P
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11018"; a="16396031"
X-IronPort-AV: E=Sophos;i="6.07,137,1708416000"; 
   d="scan'208";a="16396031"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 09:26:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,137,1708416000"; 
   d="scan'208";a="13780395"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 09:26:03 -0700
Date: Tue, 19 Mar 2024 09:26:02 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: David Matlack <dmatlack@google.com>, isaku.yamahata@intel.com,
	kvm@vger.kernel.org, isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Federico Parola <federico.parola@polito.it>
Subject: Re: [RFC PATCH 6/8] KVM: x86: Implement kvm_arch_{,
 pre_}vcpu_map_memory()
Message-ID: <20240319162602.GF1645738@ls.amr.corp.intel.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <66a957f4ec4a8591d2ff2550686e361ec648b308.1709288671.git.isaku.yamahata@intel.com>
 <ZekKwlLdf6vm5e5u@google.com>
 <CALzav=dHNYP02q_CJncwk-JdL9OSB=613v4+siBm1Cp2rmxLLw@mail.gmail.com>
 <20240307015151.GF368614@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240307015151.GF368614@ls.amr.corp.intel.com>

On Wed, Mar 06, 2024 at 05:51:51PM -0800,
Isaku Yamahata <isaku.yamahata@linux.intel.com> wrote:

> On Wed, Mar 06, 2024 at 04:36:25PM -0800,
> David Matlack <dmatlack@google.com> wrote:
> 
> > On Wed, Mar 6, 2024 at 4:31 PM David Matlack <dmatlack@google.com> wrote:
> > >
> > > On 2024-03-01 09:28 AM, isaku.yamahata@intel.com wrote:
> > > >
> > > > +     if (IS_ALIGNED(mapping->base_gfn, KVM_PAGES_PER_HPAGE(PG_LEVEL_1G)) &&
> > > > +         mapping->nr_pages >= KVM_PAGES_PER_HPAGE(PG_LEVEL_1G))
> > > > +             max_level = PG_LEVEL_1G;
> > > > +     else if (IS_ALIGNED(mapping->base_gfn, KVM_PAGES_PER_HPAGE(PG_LEVEL_2M)) &&
> > > > +              mapping->nr_pages >= KVM_PAGES_PER_HPAGE(PG_LEVEL_2M))
> > > > +             max_level = PG_LEVEL_2M;
> > > > +     else
> > > > +             max_level = PG_LEVEL_4K;
> > >
> > > Is there a requirement that KVM must not map memory outside of the
> > > requested region?
> > 
> > And if so, what if the requested region is already mapped with a larger page?
> 
> Yes. We'd like to map exact gpa range for SNP or TDX case. We don't want to map
> zero at around range.  For SNP or TDX, we map page to GPA, it's one time
> operation.  It updates measurement.
> 
> Say, we'd like to populate GPA1 and GPA2 with initial guest memory image.  And
> they are within same 2M range.  Map GPA1 first. If GPA2 is also mapped with zero
> with 2M page, the following mapping of GPA2 fails.  Even if mapping of GPA2
> succeeds, measurement may be updated when mapping GPA1. 
> 
> It's user space VMM responsibility to map GPA range only once at most for SNP or
> TDX.  Is this too strict requirement for default VM use case to mitigate KVM
> page fault at guest boot up?  If so, what about a flag like EXACT_MAPPING or
> something?

I'm thinking as follows. What do you think?

- Allow mapping larger than requested with gmem_max_level hook:
  Depend on the following patch. [1]
  The gmem_max_level hook allows vendor-backend to determine max level.
  By default (for default VM or sw-protected), it allows KVM_MAX_HUGEPAGE_LEVEL
  mapping.  TDX allows only 4KB mapping.

  [1] https://lore.kernel.org/kvm/20231230172351.574091-31-michael.roth@amd.com/
  [PATCH v11 30/35] KVM: x86: Add gmem hook for determining max NPT mapping level

- Pure mapping without coco operation:
  As Sean suggested at [2], make KVM_MAP_MEMORY pure mapping without coco
  operation.  In the case of TDX, the API doesn't issue TDX specific operation
  like TDH.PAGE.ADD() and TDH.EXTEND.MR().  We need TDX specific API.

  [2] https://lore.kernel.org/kvm/Ze-XW-EbT9vXaagC@google.com/

- KVM_MAP_MEMORY on already mapped area potentially with large page:
  It succeeds. Not error.  It doesn't care whether the GPA is backed by large
  page or not.  Because the use case is pre-population before guest running, it
  doesn't matter if the given GPA was mapped or not, and what large page level
  it backs.

  Do you want error like -EEXIST?

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

