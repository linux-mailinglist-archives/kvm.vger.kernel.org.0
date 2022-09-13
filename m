Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22E405B6CBE
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 14:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbiIMMHa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Sep 2022 08:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbiIMMH3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Sep 2022 08:07:29 -0400
Received: from out0-137.mail.aliyun.com (out0-137.mail.aliyun.com [140.205.0.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6805F11C;
        Tue, 13 Sep 2022 05:07:26 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047208;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---.PEXKKLn_1663070841;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.PEXKKLn_1663070841)
          by smtp.aliyun-inc.com;
          Tue, 13 Sep 2022 20:07:21 +0800
Date:   Tue, 13 Sep 2022 20:07:21 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] KVM: x86/mmu: Fix wrong gfn range of tlb flushing
 in validate_direct_spte()
Message-ID: <20220913120721.GA113257@k08j02272.eu95sqa>
References: <cover.1661331396.git.houwenlong.hwl@antgroup.com>
 <c0ee12e44f2d218a0857a5e05628d05462b32bf9.1661331396.git.houwenlong.hwl@antgroup.com>
 <YxjYWtgLZMxFBrjl@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxjYWtgLZMxFBrjl@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 08, 2022 at 01:43:54AM +0800, David Matlack wrote:
> On Wed, Aug 24, 2022 at 05:29:18PM +0800, Hou Wenlong wrote:
> > The spte pointing to the children SP is dropped, so the
> > whole gfn range covered by the children SP should be flushed.
> > Although, Hyper-V may treat a 1-page flush the same if the
> > address points to a huge page, it still would be better
> > to use the correct size of huge page. Also introduce
> > a helper function to do range-based flushing when a direct
> > SP is dropped, which would help prevent future buggy use
> > of kvm_flush_remote_tlbs_with_address() in such case.
> > 
> > Fixes: c3134ce240eed ("KVM: Replace old tlb flush function with new one to flush a specified range.")
> > Suggested-by: David Matlack <dmatlack@google.com>
> > Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index e418ef3ecfcb..a3578abd8bbc 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -260,6 +260,14 @@ void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
> >  	kvm_flush_remote_tlbs_with_range(kvm, &range);
> >  }
> >  
> > +/* Flush all memory mapped by the given direct SP. */
> > +static void kvm_flush_remote_tlbs_direct_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
> > +{
> > +	WARN_ON_ONCE(!sp->role.direct);
> > +	kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
> > +					   KVM_PAGES_PER_HPAGE(sp->role.level + 1));
> 
> nit: I think it would make sense to introduce
> kvm_flush_remote_tlbs_gfn() in this patch since you are going to
> eventually use it here anyway.
>
OK, I'll do it in the next version. Thanks!
 
> > +}
> > +
> >  static void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 gfn,
> >  			   unsigned int access)
> >  {
> > @@ -2341,7 +2349,7 @@ static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
> >  			return;
> >  
> >  		drop_parent_pte(child, sptep);
> > -		kvm_flush_remote_tlbs_with_address(vcpu->kvm, child->gfn, 1);
> > +		kvm_flush_remote_tlbs_direct_sp(vcpu->kvm, child);
> >  	}
> >  }
> >  
> > -- 
> > 2.31.1
> > 
