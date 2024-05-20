Return-Path: <kvm+bounces-17794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 315D58CA258
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 20:58:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 512AB1C21158
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 18:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 641101384B0;
	Mon, 20 May 2024 18:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bgG3KtzJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B02F11184;
	Mon, 20 May 2024 18:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716231500; cv=none; b=FiDEAWPukyQriOCBjVLIRXmkLNMSSMFsHr4JLXQF2A5nqD2GQrgh+QmnzGXqsEqqt6EPoyulAzUadRM4e1L4CyZVt017jUbQHFOM+d8eT4LgDyTjbPus4KMKK9obw4i2H0p+rqJEo0bErs4zvTnmfDYHlZ4mJOT+Ah3W9oAZx7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716231500; c=relaxed/simple;
	bh=zCVfPHtFdl24qGKfhZpxufSzkK5YhpA0Qi+1Ng74FcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JHz6K2KYSVozfWNzGVksOYt60x7kS4S1uHK0VFiS1Twuszez1Musf0kpBzGqx6FkXhNXe73j+sjMZMcCNruUil//Cld1j283Y/ed1WrB7xdaSWW+mif34NXmfMmLgf8v4rNmb0RvK9iCtajJoQztGs2VZVBdOF3OdzLOsfeJRQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bgG3KtzJ; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716231498; x=1747767498;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=zCVfPHtFdl24qGKfhZpxufSzkK5YhpA0Qi+1Ng74FcM=;
  b=bgG3KtzJl7Q7hkhS6rQmdhTlzhWtExQ9qOe6gAsIaovlzBir6/BRpIlI
   sh/NiHpLUzSJusL5TX01BBshXhT4NBri1Sivl+h1Rf3EaXlPbpLpVYDEk
   GYmHm0ta58P2FqbusCmU/uigxVHURcy2aLB9rHofF7D64WDccL23wY5Wk
   ivfxW7a/X5c4A3WQsXeq5H9RnfCgzsa0bBi9U3DJvgW+HHRG6qvCPnENV
   CwgmCM2dGlsxr1Fs5BuLPfAp7CmOyDUH9e2RKf5uUPOEb4ES0Uyaz6W2X
   pfoQgTkRjGRv21cCCDen9uds1Zd1NnFRdA6hWILFlOLC3KzFcAr6ytZUl
   A==;
X-CSE-ConnectionGUID: wKZz8huySYmM/8JlR8wzDA==
X-CSE-MsgGUID: yAB4O0PbQQCg9moOpUjLqQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12570599"
X-IronPort-AV: E=Sophos;i="6.08,175,1712646000"; 
   d="scan'208";a="12570599"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 11:58:17 -0700
X-CSE-ConnectionGUID: cjNgy7dmSFGVTL6X04FSIw==
X-CSE-MsgGUID: 1mGvnA+/RZGn6tKB/BalNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,175,1712646000"; 
   d="scan'208";a="63869176"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 11:58:17 -0700
Date: Mon, 20 May 2024 11:58:17 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Message-ID: <20240520185817.GA22775@ls.amr.corp.intel.com>
References: <a08779dc-056c-421c-a573-f0b1ba9da8ad@intel.com>
 <588d801796415df61136ce457156d9ff3f2a2661.camel@intel.com>
 <021e8ee11c87bfac90e886e78795d825ddab32ee.camel@intel.com>
 <eb7417cccf1065b9ac5762c4215195150c114ef8.camel@intel.com>
 <20240516194209.GL168153@ls.amr.corp.intel.com>
 <ffd24fa5-b573-4334-95c6-42429fd9ee38@intel.com>
 <20240517081440.GM168153@ls.amr.corp.intel.com>
 <b6ca3e0a18d7a472d89eeb48aaa22f5b019a769c.camel@intel.com>
 <0d48522f37d75d63f09d2a5091e3fa91913531ee.camel@intel.com>
 <791ab3de8170d90909f3e053bf91485784d36c61.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <791ab3de8170d90909f3e053bf91485784d36c61.camel@intel.com>

On Mon, May 20, 2024 at 10:38:58AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Sat, 2024-05-18 at 15:41 +0000, Edgecombe, Rick P wrote:
> > On Sat, 2024-05-18 at 05:42 +0000, Huang, Kai wrote:
> > > 
> > > No.  I meant "using kvm_mmu_page.role.mirrored_pt to determine whether to
> > > invoke kvm_x86_ops::xx_private_spt()" is not correct.
> > 
> > I agree this looks wrong.
> > 
> > >   Instead, we should
> > > use fault->is_private to determine:
> > > 
> > >         if (fault->is_private && kvm_x86_ops::xx_private_spt())
> > >                 kvm_x86_ops::xx_private_spte();
> > >         else
> > >                 // normal TDP MMU operation
> > > 
> > > The reason is this pattern works not just for TDX, but also for SNP (and
> > > SW_PROTECTED_VM) if they ever need specific page table ops.

Do you want to split the concept from invoking hooks from mirrored PT
and to allow invoking hooks even for shared PT (probably without
mirrored PT)?  So far I tied the mirrored PT to invoking the hooks as
those hooks are to reflect the changes on mirrored PT to private PT.

Is there any use case to allow hook for shared PT?

- SEV_SNP
  Although I can't speak for SNP folks, I guess they don't need hooks.
  I guess they want to stay away from directly modifying the TDP MMU
  (to add TDP MMU hooks).  Instead, They added hooks to guest_memfd.
  RMP (Reverse mapping table) doesn't have to be consistent with NPT.

  Anyway, I'll reply to
  https://lore.kernel.org/lkml/20240501085210.2213060-1-michael.roth@amd.com/T/#m8ca554a6d4bad7fa94dedefcf5914df19c9b8051
 
TDX
  I don't see immediate need to allow hooks for shared PT.

SW_PROTECTED (today)
  It uses only shared PT and don't need hooks.

SW_PROTECTED (with mirrored pt with shared mask in future in theory)
  This would be similar to TDX, we wouldn't need hooks for shared PT.

SW_PROTECTED (shared PT only without mirrored pt in future in theory)
  I don't see necessity hooks for shared PT.
  (Or I don't see value of this SW_PROTECTED case.)


> > I think the problem is there are a lot of things that are more on the mirrored
> > concept side:
> >  - Allocating the "real" PTE pages (i.e. sp->private_spt)
> >  - Setting the PTE when the mirror changes
> >  - Zapping the real PTE when the mirror is zapped (and there is no fault)
> >  - etc
> > 
> > And on the private side there is just knowing that private faults should operate
> > on the mirror root.
> 
> ... and issue SEAMCALL to operate the real private page table?

For zapping case,
- SEV-SNP
  They use the hook for guest_memfd.
- SW_PROTECTED (with mirrored pt in future in theory)
  This would be similar to TDX.


> > The xx_private_spte() operations are actually just updating the real PTE for the
> > mirror. In some ways it doesn't have to be about "private". It could be a mirror
> > of something else and still need the updates. For SNP and others they don't need
> > to do anything like that. (AFAIU)
> 
> AFAICT xx_private_spte() should issue SEAMCALL to operate the real private
> page table?
> 
> > 
> > So based on that, I tried to change the naming of xx_private_spt() to reflect
> > that. Like:
> > if (role.mirrored)
> >   update_mirrored_pte()
> > 
> > The TDX code could encapsulate that mirrored updates need to update private EPT.
> > Then I had a helper that answered the question of whether to handle private
> > faults on the mirrored root.
> 
> I am fine with this too, but I am also fine with the existing pattern:
> 
> That we update the mirrored_pt using normal TDP MMU operation, and then
> invoke the xx_private_spte() for private GPA.
> 
> My only true comment is, to me it seems more reasonable to invoke
> xx_private_spte() based on fault->is_private, but not on
> 'use_mirrored_pt'.
> 
> See my reply to your question whether SNP needs special handling below.
> 
> > 
> > The FREEZE stuff actually made a bit more sense too, because it was clear it
> > wasn't a special TDX private memory thing, but just about the atomicity.
> > 
> > The problem was I couldn't get rid of all special things that are private (can't
> > remember what now).
> > 
> > I wonder if I should give it a more proper try. What do you think?
> > 
> > At this point, I was just going to change the "mirrored" name to
> > "private_mirrored". Then code that does either mirrored things or private things
> > both looks correct. Basically making it clear that the MMU only supports
> > mirroring private memory.
> 
> I don't have preference on name.  "mirrored_private" also works for me.

For hook names, we can use mirrored_private or reflect or handle?
(or whatever better name)

The current hook names
  {link, free}_private_spt(),
  {set, remove, zap}_private_spte()

=>
  # use mirrored_private
  {link, free}_mirrored_private_spt(),
  {set, remove, zap}_mirrored_private_spte()

  or 
  # use reflect (update or handle?) mirrored to private
  reflect_{linked, freeed}_mirrored_spt(),
  reflect_{set, removed, zapped}_mirrored_spte()

  or 
  # Don't add anything.  I think this would be confusing. 
  {link, free}_spt(),
  {set, remove, zap}_spte()


I think we should also rename the internal functions in TDP MMU.
- handle_removed_private_spte()
- set_private_spte_present()
handle and set is inconsistent. They should have consistent name.

=>
handle_{removed, set}_mirrored_private_spte()
or 
reflect_{removed, set}_mirrored_spte()


> > >         bool mirrored_pt = fault->is_private && kvm_use_mirrored_pt(kvm);
> > > 
> > >         tdp_mmu_for_each_pte(iter, mmu, mirrored_pt, raw_gfn, raw_gfn +
> > > 1) 
> > >         {
> > >                 ...
> > >         }
> > > 
> > > #define tdp_mmu_for_each_pte(_iter, _mmu, _mirrored_pt, _start, _end)   \
> > >         for_each_tdp_pte(_iter,                                         \
> > >                  root_to_sp((_mirrored_pt) ? _mmu->private_root_hpa :   \
> > >                                 _mmu->root.hpa),                        \
> > >                 _start, _end)
> > > 
> > > If you somehow needs the mirrored_pt in later time when handling the page
> > > fault, you don't need another "mirrored_pt" in tdp_iter, because you can
> > > easily get it from the sptep (or just get from the root):
> > > 
> > >         mirrored_pt = sptep_to_sp(sptep)->role.mirrored_pt;
> > > 
> > > What we really need to pass in is the fault->is_private, because we are
> > > not able to get whether a GPN is private based on kvm_shared_gfn_mask()
> > > for SNP and SW_PROTECTED_VM.
> > 
> > SNP and SW_PROTECTED_VM (today) don't need do anything special here, right?
> 
> Conceptually, I think SNP also needs to at least issue some command(s) to
> update the RMP table to reflect the GFN<->PFN relationship.  From this
> point, I do see a fit.
> 
> I briefly looked into SNP patchset, and I also raised the discussion there
> (with you and Isaku copied):
> 
> https://lore.kernel.org/lkml/20240501085210.2213060-1-michael.roth@amd.com/T/#m8ca554a6d4bad7fa94dedefcf5914df19c9b8051
> 
> I could be wrong, though.

I'll reply to it.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

