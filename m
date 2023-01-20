Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 514F2674EAD
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 08:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjATHvV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 02:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbjATHvK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 02:51:10 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F29083848
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 23:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674201058; x=1705737058;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=H98K8MxYCxTHqPHCBZ/rQtlZywkJvBGcVMGc1/GmB/E=;
  b=H0t0XA+x/HTYqTlano4GlbAQZVOW4dahCI3+FNy98wh58O+8M1DEJFln
   bPkBXqNHoRlxNXb7wBrqnCq/XyTEojSjqjpoCf7djTKrSZedIhVMK/Ah1
   4BqDxY7stCz/OYB1aa71K9RbplaeWV5Xfp3iosf7MzRBMJZJbHrsJTZlD
   Wv0tBpBh7Vm3EYaimrh5+MtF5j16qCjWexYPi33nBBcVWSv1TzQAnw3Et
   9IsaVD4o8M6gE7ETp0B6DMwGUHebL3FsNiBqxofMma29e8KhLbsoQEaeW
   7BAHDCOu9tRY8/K+19BVseEHYsXXHotRn0CJak4qDgDre0UQc5pRqoN1q
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="313416291"
X-IronPort-AV: E=Sophos;i="5.97,231,1669104000"; 
   d="scan'208";a="313416291"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 23:50:42 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="749263309"
X-IronPort-AV: E=Sophos;i="5.97,231,1669104000"; 
   d="scan'208";a="749263309"
Received: from wanglis1-mobl.ccr.corp.intel.com (HELO localhost) ([10.254.214.163])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 23:50:40 -0800
Date:   Fri, 20 Jan 2023 15:50:37 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH] KVM: MMU: Add wrapper to check whether MMU is in direct
 mode
Message-ID: <20230120075037.2m2ophbjthkgs77f@linux.intel.com>
References: <20221206073951.172450-1-yu.c.zhang@linux.intel.com>
 <Y8nr9SZAnUguf3qU@google.com>
 <20230120073824.unzbsnfwfovjfzss@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230120073824.unzbsnfwfovjfzss@linux.intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 20, 2023 at 03:38:24PM +0800, Yu Zhang wrote:
> On Fri, Jan 20, 2023 at 01:18:45AM +0000, Sean Christopherson wrote:
> > +David and Ben
> > 
> > On Tue, Dec 06, 2022, Yu Zhang wrote:
> > > Simplify the code by introducing a wrapper, mmu_is_direct(),
> > > instead of using vcpu->arch.mmu->root_role.direct everywhere.
> > > 
> > > Meanwhile, use temporary variable 'direct', in routines such
> > > as kvm_mmu_load()/kvm_mmu_page_fault() etc. instead of checking
> > > vcpu->arch.mmu->root_role.direct repeatedly.
> 
> Thanks Sean. I already forgot the existence of this patch. :)
> > 
> > I've looked at this patch at least four times and still can't decide whether or
> > not I like the helper.  On one had, it's shorter and easier to read.  On the other
> > hand, I don't love that mmu_is_nested() looks at a completely different MMU, which
> > is weird if not confusing.
> 
> Do you mean mmu_is_direct()? Why it's about a different MMU? 
> 
> > 
> > Anyone else have an opinion?
> > 
> > > No functional change intended.
> > > 
> > > Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c | 26 +++++++++++++-------------
> > >  arch/x86/kvm/x86.c     |  9 +++++----
> > >  arch/x86/kvm/x86.h     |  5 +++++
> > >  3 files changed, 23 insertions(+), 17 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 4736d7849c60..d2d0fabdb702 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -2280,7 +2280,7 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
> > >  
> > >  	if (iterator->level >= PT64_ROOT_4LEVEL &&
> > >  	    vcpu->arch.mmu->cpu_role.base.level < PT64_ROOT_4LEVEL &&
> > > -	    !vcpu->arch.mmu->root_role.direct)
> > > +	    !mmu_is_direct(vcpu))
> > >  		iterator->level = PT32E_ROOT_LEVEL;
> > >  
> > >  	if (iterator->level == PT32E_ROOT_LEVEL) {
> > > @@ -2677,7 +2677,7 @@ static int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
> > >  	gpa_t gpa;
> > >  	int r;
> > >  
> > > -	if (vcpu->arch.mmu->root_role.direct)
> > > +	if (mmu_is_direct(vcpu))
> > >  		return 0;
> > >  
> > >  	gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, NULL);
> > > @@ -3918,7 +3918,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
> > >  	int i;
> > >  	struct kvm_mmu_page *sp;
> > >  
> > > -	if (vcpu->arch.mmu->root_role.direct)
> > > +	if (mmu_is_direct(vcpu))
> > >  		return;
> > >  
> > >  	if (!VALID_PAGE(vcpu->arch.mmu->root.hpa))
> > > @@ -4147,7 +4147,7 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> > >  
> > >  	arch.token = alloc_apf_token(vcpu);
> > >  	arch.gfn = gfn;
> > > -	arch.direct_map = vcpu->arch.mmu->root_role.direct;
> > > +	arch.direct_map = mmu_is_direct(vcpu);
> > >  	arch.cr3 = vcpu->arch.mmu->get_guest_pgd(vcpu);
> > >  
> > >  	return kvm_setup_async_pf(vcpu, cr2_or_gpa,
> > > @@ -4157,17 +4157,16 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> > >  void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
> > >  {
> > >  	int r;
> > > +	bool direct = mmu_is_direct(vcpu);
> > 
> > I would prefer to not add local bools and instead due a 1:1 replacement.  "direct"
> > loses too much context (direct what?), and performance wise I doubt it will
> > influence the compiler.
> 
> If we want to use a new temp value, how about "mmu_direct_mode"?
> 
> But I am also open to use mmu_is_direct(). Because I just realized the benifit
> is too marginal: the second read of vcpu->arch.mmu->root_role.direct should be
> a cache hit, so the gain of adding a local variable is to only reduce one L1
> cache read.
Sorry, should be one TLB and one cache access(I guess VIPT will also bring some
parallelism).

B.R.
Yu
