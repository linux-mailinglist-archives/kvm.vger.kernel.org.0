Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6142C575461
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 20:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239797AbiGNSFw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 14:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiGNSFv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 14:05:51 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF85474DB;
        Thu, 14 Jul 2022 11:05:49 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id v7so2595283pfb.0;
        Thu, 14 Jul 2022 11:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=wAeTCbNpVTye55LsqI/1RZFMifstX2waTe55HendxN4=;
        b=Zcb30Vwb+EWfpvDZPDFZ7Nh/gA9xKTvI144exNdlQoIkFMpjf8dYcIc5EIM395cThb
         ddvlNvSWZX6JEAWq6e9CPpe4o1iINAb705/NUl7Yb9PS9WgFlHLnlVVS/K0mejMPqpea
         DqExWPacQTJWjufqXn1UIyGSI0ycgv+I6yJHceFe6FV1cmnfRsLECqCbW3dZK0VJXof/
         bTs9BMZSLnO7Rmrg7+yjqBzPkV3YVH9aNvURMebgDqls93z6aJADxhTZxv1OUBoMaV//
         58te2PDws01lZUfXMtVYLXLVkWIDFz0rUMVolrRvJ6B6qHAocKvjO40gRCRV4rfA9DKN
         eWMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=wAeTCbNpVTye55LsqI/1RZFMifstX2waTe55HendxN4=;
        b=yVrpZq0YLCjI+cJxYoILvkM4/ETRgDD0Tk2xuH/Xd6aGENAiXi+ZaRUgXccIVVZN6R
         t3UrvKserOQxmsra9z+/0PXc+ehn7hQv8YysauKdgvvBSNbuKgf5tByomhXD+bFHTWvn
         9bgvwROHUqf/SHdWDg32mYjQXSHbSvRWWXnVZ7bOf4UVkNuZNoYDIlESvFJfCKnrcEqv
         ZyvrgHmqz3eF5s3k/tNih9c0yaG3W5nXAwVkELz2J9ysrPUf5umGSiXoeYUzT2JYMzJf
         EMlcLqrijIdOhFO8CtQPKYfsVgu4Bv7USfOavrtSTA4OFRcO8zV2xD8ox2q51Lc8A20M
         MgWw==
X-Gm-Message-State: AJIora8TMWajFpf3SX6UaFDPQ+IYLUW4p3Ke37MAIP5VNXnznecbKUCv
        oxbJrKPMj8nX54OJrIaZA3A=
X-Google-Smtp-Source: AGRyM1ubZkLaPcCYZGzYA6WtaZKkua5iPZhIjrc0RSLWIuFW8mNQy2c2AqfhEKTyGEc9ndWF3EMFrA==
X-Received: by 2002:a63:5c5e:0:b0:412:a2f1:d0dd with SMTP id n30-20020a635c5e000000b00412a2f1d0ddmr8820289pgm.251.1657821949210;
        Thu, 14 Jul 2022 11:05:49 -0700 (PDT)
Received: from localhost (fmdmzpr02-ext.fm.intel.com. [192.55.54.37])
        by smtp.gmail.com with ESMTPSA id u13-20020a17090341cd00b00163e06e1a99sm1828595ple.120.2022.07.14.11.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 11:05:48 -0700 (PDT)
Date:   Thu, 14 Jul 2022 11:05:47 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v7 036/102] KVM: x86/mmu: Allow non-zero value for
 non-present SPTE
Message-ID: <20220714180547.GS1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <f74b05eca8815744ce1ad672c66033101be7369c.1656366338.git.isaku.yamahata@intel.com>
 <9340e6e23a2564d971786207773134507cb3db4e.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9340e6e23a2564d971786207773134507cb3db4e.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 30, 2022 at 11:03:56PM +1200,
Kai Huang <kai.huang@intel.com> wrote:

> On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > TDX introduced a new ETP, Secure-EPT, in addition to the existing EPT.
> > Secure-EPT maps protected guest memory, which is called private. Since
> > Secure-EPT page tables is also protected, those page tables is also called
> > private.  The existing EPT is often called shared EPT to distinguish from
> > Secure-EPT.  And also page tables for share EPT is also called shared.
> 
> Does this patch has anything to do with secure-EPT?
> 
> > 
> > Virtualization Exception, #VE, is a new processor exception in VMX non-root
> 
> #VE isn't new.  It's already in pre-TDX public spec AFAICT.
> 
> > operation.  In certain virtualizatoin-related conditions, #VE is injected
> > into guest instead of exiting from guest to VMM so that guest is given a
> > chance to inspect it.  One important one is EPT violation.  When
> > "ETP-violation #VE" VM-execution is set, "#VE suppress bit" in EPT entry
> > is cleared, #VE is injected instead of EPT violation.
> 
> We already know such fact based on pre-TDX public spec.  Instead of repeating it
> here, why not focusing on saying what's new in TDX, so your below paragraph of
> setting a non-zero value for non-present SPTE can be justified?

Ok, will drop those two paragraph above.


> > Because guest memory is protected with TDX, VMM can't parse instructions
> > in the guest memory.  Instead, MMIO hypercall is used for guest to pass
> > necessary information to VMM.
> > 
> > To make unmodified device driver work, guest TD expects #VE on accessing
> > shared GPA.  The #VE handler converts MMIO access into MMIO hypercall with
> > the EPT entry of enabled "#VE" by clearing "suppress #VE" bit.  Before VMM
> > enabling #VE, it needs to figure out the given GPA is for MMIO by EPT
> > violation.  
> > 
> 
> As I said above, before here, you need to explain in TDX VMCS is controlled by
> the TDX module and it always sets the "EPT-violation #VE" in execution control
> bit.
> 
> > So the execution flow looks like
> > 
> > - Allocate unused shared EPT entry with suppress #VE bit set.
> > - EPT violation on that GPA.
> > - VMM figures out the faulted GPA is for MMIO.
> > - VMM clears the suppress #VE bit.
> > - Guest TD gets #VE, and converts MMIO access into MMIO hypercall.
> > - If the GPA maps guest memory, VMM resolves it with guest pages.
> > 
> > For both cases, SPTE needs suppress #VE" bit set initially when it
> > is allocated or zapped, therefore non-zero non-present value for SPTE
> > needs to be allowed.
> > 
> > This change requires to update FNAME(sync_page) for shadow EPT.
> > "if(!sp->spte[i])" in FNAME(sync_page) means that the spte entry is the
> > initial value.  With the introduction of shadow_nonpresent_value which can
> > be non-zero, it doesn't hold any more. Replace zero check with
> > "!is_shadow_present_pte() && !is_mmio_spte()".
> 
> I don't think you need to mention above paragraph.  It's absolutely unclear how
> is_mmio_spte() will be impacted by this patch by reading above paragraphs.
> 
> From the "execution flow" you mentioned above, you will change MMIO fault from
> EPT misconfiguration to EPT violation (in order to get #VE), so theoretically
> you may effectively disable MMIO caching, in which case, if I understand
> correctly, is_mmio_spte() always returns false.
> 
> I guess you can just change to check:
> 
> 	if (sp->spte[i] != shadow_nonpresent_value)
> 
> Anyway, IMO you can just comment in the code.
> 
> After all, what is shadow_nonpresent_value, given you haven't explained what it
> is?

I'll drop the paragraph and add a comment on the code.


> > TDP MMU uses REMOVED_SPTE = 0x5a0ULL as special constant to indicate the
> > intermediate value to indicate one thread is operating on it and the value
> > should be semi-arbitrary value.  For TDX (more correctly to use #VE), the
> > value should include suppress #VE value which is SHADOW_NONPRESENT_VALUE.
> 
> What is SHADOW_NONPRESENT_VALUE?
> 
> > Rename REMOVED_SPTE to __REMOVED_SPTE and define REMOVED_SPTE as
> > SHADOW_NONPRESENT_VALUE | REMOVED_SPTE to set suppress #VE bit.
> 
> Ditto. IMHO you don't even need to mention REMOVED_SPTE in changelog.



> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c         | 55 ++++++++++++++++++++++++++++++----
> >  arch/x86/kvm/mmu/paging_tmpl.h |  3 +-
> >  arch/x86/kvm/mmu/spte.c        |  5 +++-
> >  arch/x86/kvm/mmu/spte.h        | 37 ++++++++++++++++++++---
> >  arch/x86/kvm/mmu/tdp_mmu.c     | 23 +++++++++-----
> >  5 files changed, 105 insertions(+), 18 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 51306b80f47c..f239b6cb5d53 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -668,6 +668,44 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
> >  	}
> >  }
> >  
> > +static inline void kvm_init_shadow_page(void *page)
> > +{
> > +#ifdef CONFIG_X86_64
> > +	int ign;
> > +
> > +	WARN_ON_ONCE(shadow_nonpresent_value != SHADOW_NONPRESENT_VALUE);
> > +	asm volatile (
> > +		"rep stosq\n\t"
> > +		: "=c"(ign), "=D"(page)
> > +		: "a"(SHADOW_NONPRESENT_VALUE), "c"(4096/8), "D"(page)
> > +		: "memory"
> > +	);
> > +#else
> > +	BUG();
> > +#endif
> > +}
> > +
> > +static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm_mmu_memory_cache *mc = &vcpu->arch.mmu_shadow_page_cache;
> > +	int start, end, i, r;
> > +	bool is_tdp_mmu = is_tdp_mmu_enabled(vcpu->kvm);
> > +
> > +	if (is_tdp_mmu && shadow_nonpresent_value)
> > +		start = kvm_mmu_memory_cache_nr_free_objects(mc);
> > +
> > +	r = kvm_mmu_topup_memory_cache(mc, PT64_ROOT_MAX_LEVEL);
> > +	if (r)
> > +		return r;
> > +
> > +	if (is_tdp_mmu && shadow_nonpresent_value) {
> > +		end = kvm_mmu_memory_cache_nr_free_objects(mc);
> > +		for (i = start; i < end; i++)
> > +			kvm_init_shadow_page(mc->objects[i]);
> > +	}
> 
> I think you can just extend this to legacy MMU too, but not only TDP MMU.
> 
> After all, before this patch, where have you declared that TDX only supports TDP
> MMU?  This is only enforced in:
> 
> 	[PATCH v7 043/102] KVM: x86/mmu: Focibly use TDP MMU for TDX
> 
> Which is 7 patches later.
> 
> Also, shadow_nonpresent_value is only used in couple of places, while
> SHADOW_NONPRESENT_VALUE is used directly in more places.  Does it make more
> sense to always use shadow_nonpresent_value, instead of using
> SHADOW_NONPRESENT_VALUE?
> 
> Similar to other shadow values, we can provide a function to let caller
> (VMX/SVM) to decide whether it wants to use non-zero for non-present SPTE.
> 
> 	void kvm_mmu_set_non_present_value(u64 value)
> 	{
> 		shadow_nonpresent_value = value;
> 	}

As you pointed out, those logic is independent of TDP MMU or legacy MMU.
So I'll remove is_tdp_mmu.I'll drop shadwo_nonpresent_value and use
SHADWO_NONPRESENT_VALUE.

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
