Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB3194EE5E4
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 04:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243944AbiDACMN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 22:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234917AbiDACMM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 22:12:12 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B285C1C60D1;
        Thu, 31 Mar 2022 19:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648779023; x=1680315023;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=84qWD+sVjw+7gL9tA4NoHNvtIquSIjsobGfuCQglOSk=;
  b=i5Pows7C2X43OsL0WI9e2ABarddV3Jr4NDiISLTQTNMCZ20tcScuJbtX
   kOIMYBRTfxdSwzODe/S2JxacoBD5LLCbkQIsNDtqCEWOcHYNdToPScgkv
   O3dN+4I5wMJjEN+CBkgQs2pR0Muja6r0UhGN8F54sFDFcv9NTOzqAE1eC
   WGtC4G9e3Pd1SWq2/J7EzmHvAZ4ci6+Y22d3l2PF/j6RkNB/WZpvCy6/X
   a4xZHeZJd2fujszpLHjS9/2ccqt5aQ7BEr0JG02FpOZfdNmoh0nlflb6M
   QOofZ8PrHZtfdg/ixUPtID21z1PsVK03XuanJbPipsl7oeLso0V3AptFZ
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10303"; a="260202613"
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="260202613"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 19:10:19 -0700
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="788647447"
Received: from tswork-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.29.39])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 19:10:17 -0700
Message-ID: <28c858a4b70739d449b91aaccd7f1db4ff573403.camel@intel.com>
Subject: Re: [RFC PATCH v5 033/104] KVM: x86: Add infrastructure for stolen
 GPA bits
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Fri, 01 Apr 2022 15:10:15 +1300
In-Reply-To: <2b8038c17b85658a054191b362840240bd66e46b.camel@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <a21c1f9065cf27db54820b2b504db4e507835584.1646422845.git.isaku.yamahata@intel.com>
         <2b8038c17b85658a054191b362840240bd66e46b.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-04-01 at 00:16 +1300, Kai Huang wrote:
> On Fri, 2022-03-04 at 11:48 -0800, isaku.yamahata@intel.com wrote:
> > From: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > 
> > Add support in KVM's MMU for aliasing multiple GPAs (from a hardware
> > perspective) to a single GPA (from a memslot perspective). GPA aliasing
> > will be used to repurpose GPA bits as attribute bits, e.g. to expose an
> > execute-only permission bit to the guest. To keep the implementation
> > simple (relatively speaking), GPA aliasing is only supported via TDP.
> > 
> > Today KVM assumes two things that are broken by GPA aliasing.
> >   1. GPAs coming from hardware can be simply shifted to get the GFNs.
> >   2. GPA bits 51:MAXPHYADDR are reserved to zero.
> > 
> > With GPA aliasing, translating a GPA to GFN requires masking off the
> > repurposed bit, and a repurposed bit may reside in 51:MAXPHYADDR.
> > 
> > To support GPA aliasing, introduce the concept of per-VM GPA stolen bits,
> > that is, bits stolen from the GPA to act as new virtualized attribute
> > bits. A bit in the mask will cause the MMU code to create aliases of the
> > GPA. It can also be used to find the GFN out of a GPA coming from a tdp
> > fault.
> > 
> > To handle case (1) from above, retain any stolen bits when passing a GPA
> > in KVM's MMU code, but strip them when converting to a GFN so that the
> > GFN contains only the "real" GFN, i.e. never has repurposed bits set.
> > 
> > GFNs (without stolen bits) continue to be used to:
> >   - Specify physical memory by userspace via memslots
> >   - Map GPAs to TDP PTEs via RMAP
> >   - Specify dirty tracking and write protection
> >   - Look up MTRR types
> >   - Inject async page faults
> > 
> > Since there are now multiple aliases for the same aliased GPA, when
> > userspace memory backing the memslots is paged out, both aliases need to be
> > modified. Fortunately, this happens automatically. Since rmap supports
> > multiple mappings for the same GFN for PTE shadowing based paging, by
> > adding/removing each alias PTE with its GFN, kvm_handle_hva() based
> > operations will be applied to both aliases.
> > 
> > In the case of the rmap being removed in the future, the needed
> > information could be recovered by iterating over the stolen bits and
> > walking the TDP page tables.
> > 
> > For TLB flushes that are address based, make sure to flush both aliases
> > in the case of stolen bits.
> > 
> > Only support stolen bits in 64 bit guest paging modes (long, PAE).
> > Features that use this infrastructure should restrict the stolen bits to
> > exclude the other paging modes. Don't support stolen bits for shadow EPT.
> > 
> > Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  2 ++
> >  arch/x86/kvm/mmu.h              | 51 +++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/mmu/mmu.c          | 19 ++++++++++--
> >  arch/x86/kvm/mmu/paging_tmpl.h  | 25 +++++++++-------
> >  4 files changed, 84 insertions(+), 13 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 208b29b0e637..d8b78d6abc10 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1235,7 +1235,9 @@ struct kvm_arch {
> >  	spinlock_t hv_root_tdp_lock;
> >  #endif
> >  
> > +#ifdef CONFIG_KVM_MMU_PRIVATE
> >  	gfn_t gfn_shared_mask;
> > +#endif
> >  };
> >  
> >  struct kvm_vm_stat {
> > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > index e9fbb2c8bbe2..3fb530359f81 100644
> > --- a/arch/x86/kvm/mmu.h
> > +++ b/arch/x86/kvm/mmu.h
> > @@ -365,4 +365,55 @@ static inline gpa_t kvm_translate_gpa(struct kvm_vcpu *vcpu,
> >  		return gpa;
> >  	return translate_nested_gpa(vcpu, gpa, access, exception);
> >  }
> > +
> > +static inline gfn_t kvm_gfn_stolen_mask(struct kvm *kvm)
> > +{
> > +#ifdef CONFIG_KVM_MMU_PRIVATE
> > +	return kvm->arch.gfn_shared_mask;
> > +#else
> > +	return 0;
> > +#endif
> > +}
> > +
> > +static inline gpa_t kvm_gpa_stolen_mask(struct kvm *kvm)
> > +{
> > +	return gfn_to_gpa(kvm_gfn_stolen_mask(kvm));
> > +}
> > +
> > +static inline gpa_t kvm_gpa_unalias(struct kvm *kvm, gpa_t gpa)
> > +{
> > +	return gpa & ~kvm_gpa_stolen_mask(kvm);
> > +}
> > +
> > +static inline gfn_t kvm_gfn_unalias(struct kvm *kvm, gfn_t gfn)
> > +{
> > +	return gfn & ~kvm_gfn_stolen_mask(kvm);
> > +}
> > +
> > +static inline gfn_t kvm_gfn_shared(struct kvm *kvm, gfn_t gfn)
> > +{
> > +	return gfn | kvm_gfn_stolen_mask(kvm);
> > +}
> > +
> > +static inline gfn_t kvm_gfn_private(struct kvm *kvm, gfn_t gfn)
> > +{
> > +	return gfn & ~kvm_gfn_stolen_mask(kvm);
> > +}
> > +
> > +static inline gpa_t kvm_gpa_private(struct kvm *kvm, gpa_t gpa)
> > +{
> > +	return gpa & ~kvm_gpa_stolen_mask(kvm);
> > +}
> > +
> > +static inline bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
> > +{
> > +	gfn_t mask = kvm_gfn_stolen_mask(kvm);
> > +
> > +	return mask && !(gfn & mask);
> > +}
> > +
> > +static inline bool kvm_is_private_gpa(struct kvm *kvm, gpa_t gpa)
> > +{
> > +	return kvm_is_private_gfn(kvm, gpa_to_gfn(gpa));
> > +}
> 
> The patch title and commit message say nothing about private/shared, but only
> mention stolen bits in general.  It's weird to introduce those *private* related
> helpers here.
> 
> I think you can just ditch the concept of stolen bit infrastructure, but just
> adopt what TDX needs.
> 
> 
> >  #endif
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 8e24f73bf60b..b68191aa39bf 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -276,11 +276,24 @@ static inline bool kvm_available_flush_tlb_with_range(void)
> >  static void kvm_flush_remote_tlbs_with_range(struct kvm *kvm,
> >  		struct kvm_tlb_range *range)
> >  {
> > -	int ret = -ENOTSUPP;
> > +	int ret = -EOPNOTSUPP;
> 
> Change doesn't belong to this patch.
> 
> > +	u64 gfn_stolen_mask;
> >  
> > -	if (range && kvm_x86_ops.tlb_remote_flush_with_range)
> > +	/*
> > +	 * Fall back to the big hammer flush if there is more than one
> > +	 * GPA alias that needs to be flushed.
> > +	 */
> > +	gfn_stolen_mask = kvm_gfn_stolen_mask(kvm);
> > +	if (hweight64(gfn_stolen_mask) > 1)
> > +		goto generic_flush;
> > +
> > +	if (range && kvm_available_flush_tlb_with_range()) {
> > +		/* Callback should flush both private GFN and shared GFN. */
> > +		range->start_gfn = kvm_gfn_unalias(kvm, range->start_gfn);
> 
> This seems wrong.  It seems the intention of this function is to flush TLB for
> all aliases for a given GFN range.  Here it seems you are unconditionally change
> to range to always exclude the stolen bits.
> 
> >  		ret = static_call(kvm_x86_tlb_remote_flush_with_range)(kvm, range);
> > +	}
> 
> And you always fall through to do big hammer flush, which is obviously not
> intended.
> 
> >  
> > +generic_flush:
> >  	if (ret)
> >  		kvm_flush_remote_tlbs(kvm);
> >  }
> > @@ -4010,7 +4023,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
> >  	unsigned long mmu_seq;
> >  	int r;
> >  
> > -	fault->gfn = fault->addr >> PAGE_SHIFT;
> > +	fault->gfn = kvm_gfn_unalias(vcpu->kvm, gpa_to_gfn(fault->addr));
> >  	fault->slot = kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);
> >  
> >  	if (page_fault_handle_page_track(vcpu, fault))

Looking at code more, I think this patch is broken.  There are couple of issues
if I understand correctly:

- Rick's original patch has stolen_bits_mask encoded in 'struct kvm_mmu_page',
so basically a new page table is allocated for different aliasing GPA.  Sean
suggested to use role.private instead of stolen_bits_mask so I changed but that
was lost in this patch too.  Therefore essentially, with this patch, all
aliasing GFNs share the same page table and the same mapping.  There's slight
difference between TDP MMU and legacy MMU, that the former purely uses 'fault-
>gfn' (which doesn't have aliasing bit) to iterate page table and the latter
uses 'fault->addr' (which contains the aliasing bit), but this makes little
difference.  With this patch, all aliasing GFNs share page table and the
mapping.  This is not what we want, and this is wrong.

- The original change to get GFN w/o aliasing for MTRR check (below) is lost. 
And there are some other changes that are also lost (such as don't support
aliasing for private (user-invisible, not TDX private) memory slot), but it's
not immediately apparent to me whether this is an issue.

@@ -3833,7 +3865,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa,
u32 error_code,
 	     max_level > PG_LEVEL_4K;
 	     max_level--) {
 		int page_num = KVM_PAGES_PER_HPAGE(max_level);
-		gfn_t base = (gpa >> PAGE_SHIFT) & ~(page_num - 1);
+		gfn_t base = vcpu_gpa_to_gfn_unalias(vcpu, gpa) & ~(page_num -
1);

Another thing is above change to kvm_flush_remote_tlbs_with_range() to make it
flush TLBs for mappings for all aliasing for a given GFN range doesn't fit for
TDX.  TDX private mapping and shared mapping cannot co-exist therefore when a
page that has multiple aliasing mapped to it is taken out, only one mapping is
valid (not to mention private page cannot be taken out).  This is one of the
reasons that I think this GPA stolen bits infrastructure isn't that mandatory
for TDX.  I think it's OK to ditch this infrastructure and adopt what TDX needs
(the concept of private/shared mapping).


-- 
Thanks,
-Kai


