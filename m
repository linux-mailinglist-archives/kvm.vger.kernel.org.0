Return-Path: <kvm+bounces-12541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A786887666
	for <lists+kvm@lfdr.de>; Sat, 23 Mar 2024 02:36:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9074B1C2153A
	for <lists+kvm@lfdr.de>; Sat, 23 Mar 2024 01:36:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6476E138A;
	Sat, 23 Mar 2024 01:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Nuc9giT2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC3EA41;
	Sat, 23 Mar 2024 01:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711157805; cv=none; b=tkEQl19ab/g93yUknkiYZ6888+RyiEYxCXFws7KVR2poYhogz8u3x63QgPL+fuky7glvKUTDYIi7tIcDu8DVWFStR4u9NNcABy8bJeecO0wwBJG8xLMfkU0mQgdAvvAml1/rOji6e1pQ6BZn4iMxaBS5YQOUpU4oy4rZHc9MYyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711157805; c=relaxed/simple;
	bh=65ixw4lK/doWtlz4tMa11O5NDcLxBpEhPUhTqIqJZnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O2VPuz+stAOf7fiBOGW1SvVc+zk2N0mEdS5HDy6LZ2iQeq0Tzihi58cYB853SHWXPL+7qw482VMkuID1nYBURtofYRx6BumVKSdrBI/HWh3nv6pHWagYITZlqe0+37E6Ol3iJrc9ZdZfOjqsORQzph9qZP6560r2AygLqsvGWYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Nuc9giT2; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711157804; x=1742693804;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=65ixw4lK/doWtlz4tMa11O5NDcLxBpEhPUhTqIqJZnQ=;
  b=Nuc9giT2/b3TU6hrnMlSBdtU12p5Ca34ACV0W9UxoRY8V68sTGw0Rx0g
   2G2zc32LMMkSAdURy8TAQ6btMzZATvBimaMyc7HN6KwmssvkZvr3b99Md
   nG6rcJwiiW3NNAT/NGyYtZmjKKGOmnTmeeD9A+fpfKG/eVQK/nwWzu2li
   6PP4UMN6ptteg6LPxh8Mmn9VvmxkmhFUJ4SO4OQdKMIZz3a133NBKOwNx
   kdrIPWoQ1Tn+V8yFhu/UrYpt0PXpTFX7FE/lOtVCJIVqNd3dGkw+NW6jW
   WLnF5XVkoKKeVr4cucbzOSPrneAkvcsIbJstYow1X7LhaKYSVSywvjWDj
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11021"; a="6434356"
X-IronPort-AV: E=Sophos;i="6.07,147,1708416000"; 
   d="scan'208";a="6434356"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 18:36:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,147,1708416000"; 
   d="scan'208";a="14992270"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 18:36:43 -0700
Date: Fri, 22 Mar 2024 18:36:42 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 038/130] KVM: TDX: create/destroy VM structure
Message-ID: <20240323013642.GE2357401@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
 <c0e49a87-410e-4685-a677-069bc3abef7c@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c0e49a87-410e-4685-a677-069bc3abef7c@intel.com>

On Fri, Mar 22, 2024 at 02:06:19PM +1300,
"Huang, Kai" <kai.huang@intel.com> wrote:

> Roughly checking the code, you have implemented many things including
> MNG.KEY.CONFIG staff.  It's worth to add some text here to give reviewer a
> rough idea what's going on here.
> 
> > 
> > Before tearing down private page tables, TDX requires some resources of the
> > guest TD to be destroyed (i.e. HKID must have been reclaimed, etc).  Add
> > mmu notifier release callback before tearing down private page tables for
> > it. >
> > Add vm_free() of kvm_x86_ops hook at the end of kvm_arch_destroy_vm()
> > because some per-VM TDX resources, e.g. TDR, need to be freed after other
> > TDX resources, e.g. HKID, were freed.
> 
> I think we should split the "adding callbacks' part out, given you have ...
> 
> 	9 files changed, 520 insertions(+), 8 deletions(-)
> 
> ... in this patch.
> 
> IMHO, >500 LOC change normally means there are too many things in this
> patch, thus hard to review, and we should split.
> 
> I think perhaps we can split this big patch to smaller pieces based on the
> steps, like we did for the init_tdx_module() function in the TDX host
> patchset??
> 
> (But I would like to hear from others too.)

Ok, how about those steps
- tdr allocation/free
- allocate+configure/release HKID
- phyemme cache wb
- tdcs allocation/free
- clearing page

520/5 = 104.  Want more steps?


> > +	if (WARN_ON_ONCE(err))
> > +		pr_tdx_error(TDH_PHYMEM_CACHE_WB, err, NULL);
> > +}
> 
> [snip]
> 
> I am stopping here, because I need to take a break.
> 
> Again I think we should split this patch, there are just too many things to
> review here.

Thank you so much for the review. Let me try to break this patch.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

