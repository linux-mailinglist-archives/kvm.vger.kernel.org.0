Return-Path: <kvm+bounces-11245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B47278745C5
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 02:52:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6844B1F248E8
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 01:52:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0049A53A9;
	Thu,  7 Mar 2024 01:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lrZLVNs1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABD74C7C;
	Thu,  7 Mar 2024 01:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709776316; cv=none; b=Y4ukDZyZCNlShpvzeS01T6oi7MLADPyvZkmV1DLmuJlbK+zEfbuZLjUZ5marnTeL2ay2GZEp8M8WxYfj6pGNb6B8TrgBG1hWQ6VZJ4vEUsbP/kUbMMWUL9gkap/2TgFt8tNz9RAHwIgv/SW7HC/7XbKZstVaE84nSdiXRHusnq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709776316; c=relaxed/simple;
	bh=iIB6+wE9OpkB3gzRbWGFl0PRdQ4qvk9fQg0LbRlU6xA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dVUOVm20hfq+m4EazIpcTP7vYU11bxav5upz4wWzWY5k6bYctFdL78jXca6AeQU7HSGpSBwCYetVrVImwJ8ybUZsPe4ua7Yom4T4yZo5+fk0bS+tTb/UFEHyeWPMBSiDZawfBDiWNcNRCKWwIHC5XIZqfp0h2seDtJVGZqtsoK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lrZLVNs1; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709776315; x=1741312315;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=iIB6+wE9OpkB3gzRbWGFl0PRdQ4qvk9fQg0LbRlU6xA=;
  b=lrZLVNs1L96cfvybam7+VY4mJnJTdcARvyllKsb3d32F5MPisJSs+sCA
   zBoidn0h8gQvJHMFaE5DdsKcUF4gI4+13YUgsKd9+hGt8VRlwZOnayKkd
   EQms1ymf5iy9kAu9rNa5Tr+NEWkH0x/xBdVzCegA6QIHsCV1wv3JCFLJG
   N7bgkqAwssPxcXgw9IVeZ2fPqV5Hv1OKcHgJDAYjAOS7duBI9rLh1LTLb
   juUuz5ZX3VhubaUeEW4s7Iyaq04IS+csgCvm1zo8FD//8nzI67iZcRcDB
   d1Sug8ixvp5nBxban7vcJrG5DbxY8z3GcABDu9RjMEaRisTmmM4tosv99
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="4284879"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="4284879"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 17:51:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="10379250"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 17:51:53 -0800
Date: Wed, 6 Mar 2024 17:51:51 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: David Matlack <dmatlack@google.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org, isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Federico Parola <federico.parola@polito.it>,
	isaku.yamahata@linux.intel.com
Subject: Re: [RFC PATCH 6/8] KVM: x86: Implement kvm_arch_{,
 pre_}vcpu_map_memory()
Message-ID: <20240307015151.GF368614@ls.amr.corp.intel.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <66a957f4ec4a8591d2ff2550686e361ec648b308.1709288671.git.isaku.yamahata@intel.com>
 <ZekKwlLdf6vm5e5u@google.com>
 <CALzav=dHNYP02q_CJncwk-JdL9OSB=613v4+siBm1Cp2rmxLLw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALzav=dHNYP02q_CJncwk-JdL9OSB=613v4+siBm1Cp2rmxLLw@mail.gmail.com>

On Wed, Mar 06, 2024 at 04:36:25PM -0800,
David Matlack <dmatlack@google.com> wrote:

> On Wed, Mar 6, 2024 at 4:31 PM David Matlack <dmatlack@google.com> wrote:
> >
> > On 2024-03-01 09:28 AM, isaku.yamahata@intel.com wrote:
> > >
> > > +     if (IS_ALIGNED(mapping->base_gfn, KVM_PAGES_PER_HPAGE(PG_LEVEL_1G)) &&
> > > +         mapping->nr_pages >= KVM_PAGES_PER_HPAGE(PG_LEVEL_1G))
> > > +             max_level = PG_LEVEL_1G;
> > > +     else if (IS_ALIGNED(mapping->base_gfn, KVM_PAGES_PER_HPAGE(PG_LEVEL_2M)) &&
> > > +              mapping->nr_pages >= KVM_PAGES_PER_HPAGE(PG_LEVEL_2M))
> > > +             max_level = PG_LEVEL_2M;
> > > +     else
> > > +             max_level = PG_LEVEL_4K;
> >
> > Is there a requirement that KVM must not map memory outside of the
> > requested region?
> 
> And if so, what if the requested region is already mapped with a larger page?

Yes. We'd like to map exact gpa range for SNP or TDX case. We don't want to map
zero at around range.  For SNP or TDX, we map page to GPA, it's one time
operation.  It updates measurement.

Say, we'd like to populate GPA1 and GPA2 with initial guest memory image.  And
they are within same 2M range.  Map GPA1 first. If GPA2 is also mapped with zero
with 2M page, the following mapping of GPA2 fails.  Even if mapping of GPA2
succeeds, measurement may be updated when mapping GPA1. 

It's user space VMM responsibility to map GPA range only once at most for SNP or
TDX.  Is this too strict requirement for default VM use case to mitigate KVM
page fault at guest boot up?  If so, what about a flag like EXACT_MAPPING or
something?
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

