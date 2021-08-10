Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8FB53E1E36
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 23:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbhHEV7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 17:59:44 -0400
Received: from mga12.intel.com ([192.55.52.136]:65246 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229437AbhHEV7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 17:59:43 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10067"; a="193854179"
X-IronPort-AV: E=Sophos;i="5.84,296,1620716400"; 
   d="scan'208";a="193854179"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2021 14:59:28 -0700
X-IronPort-AV: E=Sophos;i="5.84,296,1620716400"; 
   d="scan'208";a="586393590"
Received: from dawntan-mobl1.gar.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.52.64])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2021 14:59:24 -0700
Date:   Fri, 6 Aug 2021 09:59:22 +1200
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [RFC PATCH v2 41/69] KVM: x86: Add infrastructure for stolen
 GPA bits
Message-Id: <20210806095922.6e2ca6587dc6f5b4fe8d52e7@intel.com>
In-Reply-To: <YQwMkbBFUuNGnGFw@google.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
        <c958a131ded780808a687b0f25c02127ca14418a.1625186503.git.isaku.yamahata@intel.com>
        <20210805234424.d14386b79413845b990a18ac@intel.com>
        <YQwMkbBFUuNGnGFw@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 5 Aug 2021 16:06:41 +0000 Sean Christopherson wrote:
> On Thu, Aug 05, 2021, Kai Huang wrote:
> > On Fri, 2 Jul 2021 15:04:47 -0700 isaku.yamahata@intel.com wrote:
> > > From: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > > @@ -2020,6 +2032,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
> > >  	sp = kvm_mmu_alloc_page(vcpu, direct);
> > >  
> > >  	sp->gfn = gfn;
> > > +	sp->gfn_stolen_bits = gfn_stolen_bits;
> > >  	sp->role = role;
> > >  	hlist_add_head(&sp->hash_link, sp_list);
> > >  	if (!direct) {
> > > @@ -2044,6 +2057,13 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
> > >  	return sp;
> > >  }
> > 
> > 
> > Sorry for replying old thread,
> 
> Ha, one month isn't old, it's barely even mature.
> 
> > but to me it looks weird to have gfn_stolen_bits
> > in 'struct kvm_mmu_page'.  If I understand correctly, above code basically
> > means that GFN with different stolen bit will have different 'struct
> > kvm_mmu_page', but in the context of this patch, mappings with different
> > stolen bits still use the same root,
> 
> You're conflating "mapping" with "PTE".  The GFN is a per-PTE value.  Yes, there
> is a final GFN that is representative of the mapping, but more directly the final
> GFN is associated with the leaf PTE.
> 
> TDX effectively adds the restriction that all PTEs used for a mapping must have
> the same shared/private status, so mapping and PTE are somewhat interchangeable
> when talking about stolen bits (the shared bit), but in the context of this patch,
> the stolen bits are a property of the PTE.

Yes it is a property of PTE, this is the reason that I think it's weird to have
stolen bits in 'struct kvm_mmu_page'. Shouldn't stolen bits in 'struct
kvm_mmu_page' imply that all PTEs (whether leaf or not) share the same
stolen bit?

> 
> Back to your statement, it's incorrect.  PTEs (effectively mappings in TDX) with
> different stolen bits will _not_ use the same root.  kvm_mmu_get_page() includes
> the stolen bits in both the hash lookup and in the comparison, i.e. restores the
> stolen bits when looking for an existing shadow page at the target GFN.
> 
> @@ -1978,9 +1990,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>                 role.quadrant = quadrant;
>         }
> 
> -       sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
> +       sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn_and_stolen)];
>         for_each_valid_sp(vcpu->kvm, sp, sp_list) {
> -               if (sp->gfn != gfn) {
> +               if ((sp->gfn | sp->gfn_stolen_bits) != gfn_and_stolen) {
>                         collisions++;
>                         continue;
>                 }
> 

This only works for non-root table, but there's only one single
vcpu->arch.mmu->root_hpa, we don't have an array to have one root for each
stolen bit, i.e. do a loop in mmu_alloc_direct_roots(), so effectively all
stolen bits share one single root.

> > which means gfn_stolen_bits doesn't make a lot of sense at least for root
> > page table. 
> 
> It does make sense, even without a follow-up patch.  In Rick's original series,
> stealing a bit for execute-only guest memory, there was only a single root.  And
> except for TDX, there can only ever be a single root because the shared EPTP isn't
> usable, i.e. there's only the regular/private EPTP.
> 
> > Instead, having gfn_stolen_bits in 'struct kvm_mmu_page' only makes sense in
> > the context of TDX, since TDX requires two separate roots for private and
> > shared mappings.
> 
> > So given we cannot tell whether the same root, or different roots should be
> > used for different stolen bits, I think we should not add 'gfn_stolen_bits' to
> > 'struct kvm_mmu_page' and use it to determine whether to allocate a new table
> > for the same GFN, but should use a new role (i.e role.private) to determine.
> 
> A new role would work, too, but it has the disadvantage of not automagically
> working for all uses of stolen bits, e.g. XO support would have to add another
> role bit.

For each purpose of particular stolen bit, a new role can be defined.  For
instance, in __direct_map(), if you see stolen bit is TDX shared bit, you don't
set role.private (otherwise set role.private).  For XO, if you see the stolen
bit is XO, you set role.xo.

We already have info of 'gfn_stolen_mask' in vcpu, so we just need to make sure
all code paths can find the actual stolen bit based on sp->role and vcpu (I
haven't gone through all though, assuming the annoying part is rmap).

> 
> > And removing 'gfn_stolen_bits' in 'struct kvm_mmu_page' could also save some
> > memory.
> 
> But I do like saving memory...  One potentially bad idea would be to unionize
> gfn and stolen bits by shifting the stolen bits after they're extracted from the
> gpa, e.g.
> 
> 	union {
> 		gfn_t gfn_and_stolen;
> 		struct {
> 			gfn_t gfn:52;
> 			gfn_t stolen:12;
> 		}
> 	};
> 
> the downsides being that accessing just the gfn would require an additional masking
> operation, and the stolen bits wouldn't align with reality.
