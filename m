Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8EE674E39
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 08:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjATHic (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 02:38:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjATHib (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 02:38:31 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7419E798C4
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 23:38:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674200310; x=1705736310;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SVru9cELkABb6Qrazbefilxlua7Zs1hZCoNHq+LuZuU=;
  b=YRbAeoNVTSXx+hlEHSKBMF1Gv6Nyl4jbBZrb73nkt2g+sLX2X1EUn2V9
   D5nefZkG93bxJalq5VkQ7UYU1MwoqUj8TYjb3Ca7p2jkofixo/yE0nGbc
   JZ7q8lqXRlikBaFvHgzsPIfqQuYYVHT5JtgtL9/v3cIojTz+BnYRmPp+p
   BAi7p0pWFFAUhEVKs/+V2KPkFymQFF4XCVCZWmBEFCDFQj6IX9zZ6YK7s
   hq8/GOv2AAX+Igww0W/khUVogcwdjD9NOXWAzOU8+DSZQSZc4BNVB4t4n
   eo0zwlMk0xn7ES7UwKOSpsW2bL3hCmfyTj8EbaF+z4UisNqLt+sTXyMhp
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="305891229"
X-IronPort-AV: E=Sophos;i="5.97,231,1669104000"; 
   d="scan'208";a="305891229"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 23:38:30 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="834327642"
X-IronPort-AV: E=Sophos;i="5.97,231,1669104000"; 
   d="scan'208";a="834327642"
Received: from wanglis1-mobl.ccr.corp.intel.com (HELO localhost) ([10.254.214.163])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 23:38:27 -0800
Date:   Fri, 20 Jan 2023 15:38:24 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH] KVM: MMU: Add wrapper to check whether MMU is in direct
 mode
Message-ID: <20230120073824.unzbsnfwfovjfzss@linux.intel.com>
References: <20221206073951.172450-1-yu.c.zhang@linux.intel.com>
 <Y8nr9SZAnUguf3qU@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8nr9SZAnUguf3qU@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 20, 2023 at 01:18:45AM +0000, Sean Christopherson wrote:
> +David and Ben
> 
> On Tue, Dec 06, 2022, Yu Zhang wrote:
> > Simplify the code by introducing a wrapper, mmu_is_direct(),
> > instead of using vcpu->arch.mmu->root_role.direct everywhere.
> > 
> > Meanwhile, use temporary variable 'direct', in routines such
> > as kvm_mmu_load()/kvm_mmu_page_fault() etc. instead of checking
> > vcpu->arch.mmu->root_role.direct repeatedly.

Thanks Sean. I already forgot the existence of this patch. :)
> 
> I've looked at this patch at least four times and still can't decide whether or
> not I like the helper.  On one had, it's shorter and easier to read.  On the other
> hand, I don't love that mmu_is_nested() looks at a completely different MMU, which
> is weird if not confusing.

Do you mean mmu_is_direct()? Why it's about a different MMU? 

> 
> Anyone else have an opinion?
> 
> > No functional change intended.
> > 
> > Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 26 +++++++++++++-------------
> >  arch/x86/kvm/x86.c     |  9 +++++----
> >  arch/x86/kvm/x86.h     |  5 +++++
> >  3 files changed, 23 insertions(+), 17 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 4736d7849c60..d2d0fabdb702 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -2280,7 +2280,7 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
> >  
> >  	if (iterator->level >= PT64_ROOT_4LEVEL &&
> >  	    vcpu->arch.mmu->cpu_role.base.level < PT64_ROOT_4LEVEL &&
> > -	    !vcpu->arch.mmu->root_role.direct)
> > +	    !mmu_is_direct(vcpu))
> >  		iterator->level = PT32E_ROOT_LEVEL;
> >  
> >  	if (iterator->level == PT32E_ROOT_LEVEL) {
> > @@ -2677,7 +2677,7 @@ static int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
> >  	gpa_t gpa;
> >  	int r;
> >  
> > -	if (vcpu->arch.mmu->root_role.direct)
> > +	if (mmu_is_direct(vcpu))
> >  		return 0;
> >  
> >  	gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, NULL);
> > @@ -3918,7 +3918,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
> >  	int i;
> >  	struct kvm_mmu_page *sp;
> >  
> > -	if (vcpu->arch.mmu->root_role.direct)
> > +	if (mmu_is_direct(vcpu))
> >  		return;
> >  
> >  	if (!VALID_PAGE(vcpu->arch.mmu->root.hpa))
> > @@ -4147,7 +4147,7 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> >  
> >  	arch.token = alloc_apf_token(vcpu);
> >  	arch.gfn = gfn;
> > -	arch.direct_map = vcpu->arch.mmu->root_role.direct;
> > +	arch.direct_map = mmu_is_direct(vcpu);
> >  	arch.cr3 = vcpu->arch.mmu->get_guest_pgd(vcpu);
> >  
> >  	return kvm_setup_async_pf(vcpu, cr2_or_gpa,
> > @@ -4157,17 +4157,16 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> >  void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
> >  {
> >  	int r;
> > +	bool direct = mmu_is_direct(vcpu);
> 
> I would prefer to not add local bools and instead due a 1:1 replacement.  "direct"
> loses too much context (direct what?), and performance wise I doubt it will
> influence the compiler.

If we want to use a new temp value, how about "mmu_direct_mode"?

But I am also open to use mmu_is_direct(). Because I just realized the benifit
is too marginal: the second read of vcpu->arch.mmu->root_role.direct should be
a cache hit, so the gain of adding a local variable is to only reduce one L1
cache read.

Below are the dumpings of the current kvm_arch_async_page_ready() and of the
one with local bool (in case you are interested): 

The current kvm_arch_async_page_ready():
        if ((vcpu->arch.mmu->root_role.direct != work->arch.direct_map) ||
   11243:       48 8b 97 88 02 00 00    mov    0x288(%rdi),%rdx
{
   1124a:       65 48 8b 04 25 28 00    mov    %gs:0x28,%rax
   11251:       00 00
   11253:       48 89 44 24 48          mov    %rax,0x48(%rsp)
   11258:       31 c0                   xor    %eax,%eax
        if ((vcpu->arch.mmu->root_role.direct != work->arch.direct_map) ||
   1125a:       0f b6 42 50             movzbl 0x50(%rdx),%eax
   						^
						+- here comes the "vcpu->arch.mmu->root_role.direct"

   1125e:       c0 e8 07                shr    $0x7,%al
   11261:       3a 46 78                cmp    0x78(%rsi),%al
   11264:       0f 85 de 00 00 00       jne    11348 <kvm_arch_async_page_ready+0x118>
              work->wakeup_all)
		...
        if (!vcpu->arch.mmu->root_role.direct &&
   1128c:       44 0f b6 42 50          movzbl 0x50(%rdx),%r8d
   						^
						+-  %rdx is reused, storing the "vcpu->arch.mmu"

   11291:       45 84 c0                test   %r8b,%r8b
   11294:       78 24                   js     112ba <kvm_arch_async_page_ready+0x8a>


The new kvm_arch_async_page_ready():

        bool direct = vcpu->arch.mmu->root_role.direct;
   11243:       48 8b 97 88 02 00 00    mov    0x288(%rdi),%rdx
{
   1124a:       65 48 8b 04 25 28 00    mov    %gs:0x28,%rax
   11251:       00 00  
   11253:       48 89 44 24 48          mov    %rax,0x48(%rsp)
   11258:       31 c0                   xor    %eax,%eax
        bool direct = vcpu->arch.mmu->root_role.direct;
   1125a:       44 0f b6 62 50          movzbl 0x50(%rdx),%r12d
   1125f:       41 c0 ec 07             shr    $0x7,%r12b
   						     ^
						     +- %r12 is the local variable "direct"
        if ((work->arch.direct_map != direct) ||
   11263:       44 3a 66 78             cmp    0x78(%rsi),%r12b
   11267:       0f 85 d5 00 00 00       jne    11342 <kvm_arch_async_page_ready+0x112>
              work->wakeup_all)
		...
        if (!direct && work->arch.cr3 != vcpu->arch.mmu->get_guest_pgd(vcpu))
   1128f:       45 84 e4                test   %r12b,%r12b
   						^
						+- one less read from 0x50(%rdx)
   11292:       75 1f                   jne    112b3 <kvm_arch_async_page_ready+0x83>


B.R.
Yu


> 
