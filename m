Return-Path: <kvm+bounces-17206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 13A468C2986
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 19:47:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44FCD1C216E0
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 17:47:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 566C520309;
	Fri, 10 May 2024 17:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mo9r8pbZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C6B17BCE;
	Fri, 10 May 2024 17:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715363236; cv=none; b=b6fvb+oFn2Qu4CkbvaK3GpXrtYISsyIgzRCkkwkqNoasKz8HS106o1HWRHEFm0b1Y3kiLfAogXqcN8SZ5XVsV8xlj+FEXLtUf7REg/qJUYrBd7ZU6oTb293zp42UNPxRdIf5x69Z7ES0iXTRljAkHAixYo9kII9XBevJJrkcVw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715363236; c=relaxed/simple;
	bh=1Bjsxi6FLuGOj7RtmewtKis8IikuC8YQFkIP8lxG5to=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u5T3lJZqU+pYeeRUMrYRDVBrHjUkNOTTEMDWEjFRkOBgSVvBlWo2Yye1HXn7bbZGQqX3eRIJBywL+2Gy/FSl2oxmnMG6LD6IQhMpvSyRVrhMz7qqxDOrJznj+ey27zrbE6zjCtYoB2ju/NZhsAU338eoF6RDJStx6yVHedVG6Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mo9r8pbZ; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715363233; x=1746899233;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=1Bjsxi6FLuGOj7RtmewtKis8IikuC8YQFkIP8lxG5to=;
  b=mo9r8pbZaddQo66fKnUFxYa3VXdeT6zw22vXRzy+hrTnO5fvK60sOq7X
   oTGvodPqOtSKQ61Hs09oCprMqHGmq6TD9BHj7Ggj1XBtP0TXpvu58EvK3
   47LxBt4bmz5ObdYR78kUqwZdNfmApII5hqmsPU3uZ9ZgDjavOWlfDRVmY
   ilXBCTgXwYJ0IwTTX8lkgu5Hg1zOD5MEZ74idNXAovMRfHdfI8PS0TlcU
   7+dLado7JffDbe2plzBOfawUY3VEtTAxHBy4nUPSOZxOOjc75lh3N9QRw
   po/wZkS9hP1G8emUrTwMZVEbH1H4P6JoWNNj8mDmlI7u5T7eOH+4h0ac4
   w==;
X-CSE-ConnectionGUID: erBKYM42T3SkBkru9IGRlw==
X-CSE-MsgGUID: 9CUYCF3WQ5eBwE8kMPZ6wg==
X-IronPort-AV: E=McAfee;i="6600,9927,11069"; a="22764913"
X-IronPort-AV: E=Sophos;i="6.08,151,1712646000"; 
   d="scan'208";a="22764913"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2024 10:47:02 -0700
X-CSE-ConnectionGUID: 9BuGuE57RSmgVyrAKM/GPQ==
X-CSE-MsgGUID: qwl5bYPFRgeN0WD4/7PfJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,151,1712646000"; 
   d="scan'208";a="29540130"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2024 10:47:01 -0700
Date: Fri, 10 May 2024 10:47:00 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Michael Roth <michael.roth@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
	ardb@kernel.org, vkuznets@redhat.com, jmattson@google.com,
	luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
	pgonda@google.com, peterz@infradead.org,
	srinivas.pandruvada@linux.intel.com, rientjes@google.com,
	dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, vbabka@suse.cz,
	kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com, liam.merwick@oracle.com, papaluri@amd.com,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	isaku.yamahata@linux.intel.com, rick.p.edgecombe@intel.com
Subject: Re: [PATCH v15 21/23] KVM: MMU: Disable fast path for private
 memslots
Message-ID: <20240510174700.GB480079@ls.amr.corp.intel.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240510015822.503071-1-michael.roth@amd.com>
 <Zj4lebCMsRvGn7ws@google.com>
 <CABgObfboqrSw8=+yZMDi_k9d6L3AoiU5o8d-sRb9Y5AXDTmp5w@mail.gmail.com>
 <20240510152744.ejdy4jqawc2zd2dt@amd.com>
 <Zj5ETYPTUo9T4Nuf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zj5ETYPTUo9T4Nuf@google.com>

On Fri, May 10, 2024 at 08:59:09AM -0700,
Sean Christopherson <seanjc@google.com> wrote:

> On Fri, May 10, 2024, Michael Roth wrote:
> > On Fri, May 10, 2024 at 03:50:26PM +0200, Paolo Bonzini wrote:
> > > On Fri, May 10, 2024 at 3:47 PM Sean Christopherson <seanjc@google.com> wrote:
> > > >
> > > > > +      * Since software-protected VMs don't have a notion of a shared vs.
> > > > > +      * private that's separate from what KVM is tracking, the above
> > > > > +      * KVM_EXIT_MEMORY_FAULT condition wouldn't occur, so avoid the
> > > > > +      * special handling for that case for now.
> > > >
> > > > Very technically, it can occur if userspace _just_ modified the attributes.  And
> > > > as I've said multiple times, at least for now, I want to avoid special casing
> > > > SW-protected VMs unless it is *absolutely* necessary, because their sole purpose
> > > > is to allow testing flows that are impossible to excercise without SNP/TDX hardware.
> > > 
> > > Yep, it is not like they have to be optimized.
> > 
> > Ok, I thought there were maybe some future plans to use sw-protected VMs
> > to get some added protections from userspace. But even then there'd
> > probably still be extra considerations for how to handle access tracking
> > so white-listing them probably isn't right anyway.
> > 
> > I was also partly tempted to take this route because it would cover this
> > TDX patch as well:
> > 
> >   https://lore.kernel.org/lkml/91c797997b57056224571e22362321a23947172f.1705965635.git.isaku.yamahata@intel.com/
> 
> Hmm, I'm pretty sure that patch is trying to fix the exact same issue you are
> fixing, just in a less precise way.  S-EPT entries only support RWX=0 and RWX=111b,
> i.e. it should be impossible to have a write-fault to a present S-EPT entry.
> 
> And if TDX is running afoul of this code:
> 
> 	if (!fault->present)
> 		return !kvm_ad_enabled();
> 
> then KVM should do the sane thing and require A/D support be enabled for TDX.
> 
> And if it's something else entirely, that changelog has some explaining to do.

Yes, it's for KVM_EXIT_MEMORY_FAULT case.  Because Secure-EPT has non-present or
all RWX allowed, fast page fault always returns RET_PF_INVALID by
is_shadow_present_pte() check.

I lightly tested the patch at [1] and it works for TDX KVM.

[1] https://github.com/mdroth/linux/commit/39643f9f6da6265d39d633a703c53997985c1208

Just in case for that patch,
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

