Return-Path: <kvm+bounces-12448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F0C0886363
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 23:39:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 30B8D283EAF
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 22:39:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A77D1E51D;
	Thu, 21 Mar 2024 22:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dVmcYEXE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F356134C0;
	Thu, 21 Mar 2024 22:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711060771; cv=none; b=kyvKWcVLgjt3i5xmf2HmMRRwFlgOQgGHmb1AvVbI+/0w0MAO/zbRfeNEbx/nxgykynLHnv757wFnxplIvzdyrPdPnA9xJP++MUrcOrZNlrsSALhYXwiF81c18uviPy1W6sh7UMMjtz+83EMp/WR/rJ7k9Dcp7vesfs6UWGwSSDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711060771; c=relaxed/simple;
	bh=HK3DIECxWhDEtg9oSuf2Tuafx490ajKINGhAPpWVxfs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JXMZJKZjxgBZ/pM/Ov0G7jdVkGQQOdlSWkpy3HIQ06GcTT/qqDojwQbxg1AGAqLyKiaLqnSEJGOlMJ3qs1qejRjbrHlcXSD2Md38hXNoTjrU9txhukX40cO2Q4L00q8G1nebs0Qq4tfeYkSwybmHnkvEzRKpBaRVPaI0tqDdwMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dVmcYEXE; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711060770; x=1742596770;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=HK3DIECxWhDEtg9oSuf2Tuafx490ajKINGhAPpWVxfs=;
  b=dVmcYEXEoQnpNzQyc8cURTdK7/Pa1f/yEX3htjhn4HYR6lm2R61U0LH2
   +TcJdcsVs4zLfR3H/Uk7MhAebXRj07IYUWcCXRfGJdJVPG2HRHrDWTOlz
   W8YEwYe2A0GAneNvrnsh6C18uX3aj3jWdf9Ed7ctpvFP+K8KUtuHbEiA0
   qKcsLp4XaVLMT8DuhS3fbFSUZKLW8Pmotbmxo/jo2lRJ9vKNTde/gTDPv
   r/b8uJUOlv88UzJwP8g6kKmhpzrAzEFJC/IZfJNRNmhkHIvGMgl5Kna78
   nsvToJREHpg9XsJ2zqAZPPkFJuTOn5x3OVVMUCOsaho9EMxC6VcS8S5BN
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="5943658"
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="5943658"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 15:39:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="19326191"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 15:39:28 -0700
Date: Thu, 21 Mar 2024 15:39:28 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Message-ID: <20240321223928.GT1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <1ed955a44cd81738b498fe52823766622d8ad57f.1708933498.git.isaku.yamahata@intel.com>
 <618614fa6c62a232d95da55546137251e1847f48.camel@intel.com>
 <20240319235654.GC1994522@ls.amr.corp.intel.com>
 <1c2283aab681bd882111d14e8e71b4b35549e345.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1c2283aab681bd882111d14e8e71b4b35549e345.camel@intel.com>

On Wed, Mar 20, 2024 at 12:56:38AM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Tue, 2024-03-19 at 16:56 -0700, Isaku Yamahata wrote:
> > When we zap a page from the guest, and add it again on TDX even with
> > the same
> > GPA, the page is zeroed.  We'd like to keep memory contents for those
> > cases.
> > 
> > Ok, let me add those whys and drop migration part. Here is the
> > updated one.
> > 
> > TDX supports only write-back(WB) memory type for private memory
> > architecturally so that (virtualized) memory type change doesn't make
> > sense for private memory.  When we remove the private page from the
> > guest
> > and re-add it with the same GPA, the page is zeroed.
> > 
> > Regarding memory type change (mtrr virtualization and lapic page
> > mapping change), the current implementation zaps pages, and populate
>                                                                      s^
> > the page with new memory type on the next KVM page fault.  
>                                ^s
> 
> > It doesn't work for TDX to have zeroed pages.
> What does this mean? Above you mention how all the pages are zeroed. Do
> you mean it doesn't work for TDX to zero a running guest's pages. Which
> would happen for the operations that would expect the pages could get
> faulted in again just fine.

(non-TDX part of) KVM assumes that page contents are preserved after zapping and
re-populate.  This isn't true for TDX.  The guest would suddenly see zero pages
instead of the old memory contents and would be upset.


> > Because TDX supports only WB, we
> > ignore the request for MTRR and lapic page change to not zap private
> > pages on unmapping for those two cases
> 
> Hmm. I need to go back and look at this again. It's not clear from the
> description why it is safe for the host to not zap pages if requested
> to. I see why the guest wouldn't want them to be zapped.

KVM siltently ignores the request to change memory types.


> > TDX Secure-EPT requires removing the guest pages first and leaf
> > Secure-EPT pages in order. It doesn't allow zap a Secure-EPT entry
> > that has child pages.  It doesn't work with the current TDP MMU
> > zapping logic that zaps the root page table without touching child
> > pages.  Instead, zap only leaf SPTEs for KVM mmu that has a shared
> > bit
> > mask.
> 
> Could this be better as two patches that each address a separate thing?
> 1. Leaf only zapping
> 2. Don't zap for MTRR, etc.

Makes sense. Let's split it.


> > > There seems to be an attempt to abstract away the existence of
> > > Secure-
> > > EPT in mmu.c, that is not fully successful. In this case the code
> > > checks kvm_gfn_shared_mask() to see if it needs to handle the
> > > zapping
> > > in a way specific needed by S-EPT. It ends up being a little
> > > confusing
> > > because the actual check is about whether there is a shared bit. It
> > > only works because only S-EPT is the only thing that has a
> > > kvm_gfn_shared_mask().
> > > 
> > > Doing something like (kvm->arch.vm_type == KVM_X86_TDX_VM) looks
> > > wrong,
> > > but is more honest about what we are getting up to here. I'm not
> > > sure
> > > though, what do you think?
> > 
> > Right, I attempted and failed in zapping case.  This is due to the
> > restriction
> > that the Secure-EPT pages must be removed from the leaves.  the VMX
> > case (also
> > NPT, even SNP) heavily depends on zapping root entry as optimization.
> > 
> > I can think of
> > - add TDX check. Looks wrong
> > - Use kvm_gfn_shared_mask(kvm). confusing
> > - Give other name for this check like zap_from_leafs (or better
> > name?)
> >   The implementation is same to kvm_gfn_shared_mask() with comment.
> >   - Or we can add a boolean variable to struct kvm
> 
> Hmm, maybe wrap it in a function like:
> static inline bool kvm_can_only_zap_leafs(const struct kvm *kvm)
> {
> 	/* A comment explaining what is going on */
> 	return kvm->arch.vm_type == KVM_X86_TDX_VM;
> }
> 
> But KVM seems to be a bit more on the open coded side when it comes to
> things like this, so not sure what maintainers would prefer. My opinion
> is the kvm_gfn_shared_mask() check is too strange and it's worth a new
> helper. If that is bad, then just open coded kvm->arch.vm_type ==
> KVM_X86_TDX_VM is the second best I think.
> 
> I feel both strongly that it should be changed, and unsure what
> maintainers would prefer. Hopefully one will chime in.

Now compile time config is dropped, open code is option.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

