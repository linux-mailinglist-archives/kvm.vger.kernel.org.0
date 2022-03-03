Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6AFA4CC994
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 00:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbiCCXBU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 18:01:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbiCCXBT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 18:01:19 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E877737BC0
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 15:00:32 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id z4so5950575pgh.12
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 15:00:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+iEku6VLylBROAwohNbctWoLEYbG8sRCZosUKzOSFrE=;
        b=iPw3nyW7O+77cw2Y3PRLCMdZYnDq9qljB/j0Duv/Rp7t+z1/3eI+aEgIDQicdfk1Mh
         ggo7Aty6mMu7P/6ad1e9kwhEFqPHW5b9vJp5Si6KVXWuAaulPadQGkjbowlavSpEdZyB
         jQR/Po/fX97/MnOX2PyK1+9NnV5Rzj+k3YjJZ9RU7qssGWF3UFdNlef/CHSdo0DhzfGY
         Qc0+hs5qPFUSR5thPoBNMr+eJ9I3uYc5qzHDf8FQkG4DQqtojfCy6pVrwZuEasTh27d7
         tnvOVVWEjUP4gLKhnApvy/ZEsugUHm2vXXkiCWCY6+R09aZ8cB7tpc8xpA6eeaa5QPA+
         KOwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+iEku6VLylBROAwohNbctWoLEYbG8sRCZosUKzOSFrE=;
        b=tmYorvfrHBXD4k6Kr9TbZaAXLX+02MyLEoisoKi/YWu2o36WRyDly4LSHBdQGCb2GM
         j2x3yevoDUPkDXgH9FGnjBVbFOA6bDwXIM+7ht7TeYKzDG7TbTP0La8sylAVbb+TR616
         nJDT387J7LE27Kznc8BevdBdemx7k1RDjK8r+R0ikr+lzBJboC79h4KW17bvPFrzXY/E
         kRkBxItlm6H5zTy7LLtuytQLxS9bHxvzXCusf9tJYkW8m5SW6f2HvulV4n537RmacqHO
         wS85lC/37TWxNgVU1Of1uDMyMlslPwYK3K9j5xhIdMc2yOPgkVYxPRaXDLEKl/nJ7EWB
         UIOw==
X-Gm-Message-State: AOAM5305yIJqs7XuwebCzuE5eyiUetH9DAcniL3KSopa59p+9zNStO0k
        9avTBcNtnCMnjpyipz+PlSTPqA==
X-Google-Smtp-Source: ABdhPJxG1DSPN8NKSEX7NnRSfG53qAA0jua9TnlOahP1n3mNMGwu+wBKAhv7x6qW69H04nM+rUM5vw==
X-Received: by 2002:a65:4549:0:b0:378:c0b0:c153 with SMTP id x9-20020a654549000000b00378c0b0c153mr16475920pgr.177.1646348432238;
        Thu, 03 Mar 2022 15:00:32 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o11-20020a056a0015cb00b004ce19332265sm3704501pfu.34.2022.03.03.15.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 15:00:31 -0800 (PST)
Date:   Thu, 3 Mar 2022 23:00:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Subject: Re: [PATCH v2 4/7] KVM: x86/mmu: Zap only obsolete roots if a root
 shadow page is zapped
Message-ID: <YiFIjNVPLVVnRatm@google.com>
References: <20220225182248.3812651-1-seanjc@google.com>
 <20220225182248.3812651-5-seanjc@google.com>
 <40a22c39-9da4-6c37-8ad0-b33970e35a2b@redhat.com>
 <ee757515-4a0f-c5cb-cd57-04983f62f499@redhat.com>
 <Yh/JdHphCLOm4evG@google.com>
 <217cc048-8ca7-2b7b-141f-f44f0d95eec5@redhat.com>
 <Yh/1hPMhqeFKO0ih@google.com>
 <0c22b156-10c5-1988-7256-a9db7871989d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c22b156-10c5-1988-7256-a9db7871989d@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 03, 2022, Paolo Bonzini wrote:
> On 3/2/22 23:53, Sean Christopherson wrote:
> > > 
> > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > index c5e3f219803e..7899ca4748c7 100644
> > > --- a/arch/x86/kvm/svm/svm.c
> > > +++ b/arch/x86/kvm/svm/svm.c
> > > @@ -3857,6 +3857,9 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu,
> > > hpa_t root_hpa,
> > >          unsigned long cr3;
> > > 
> > >          if (npt_enabled) {
> > > +               if (is_tdp_mmu_root(root_hpa))
> > > +                       svm->current_vmcb->asid_generation = 0;
> > > +
> > >                  svm->vmcb->control.nested_cr3 = __sme_set(root_hpa);
> > >                  vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
> > > 
> > > Why not just new_asid
> > My mental coin flip came up tails?  new_asid() is definitely more intuitive.
> > 
> 
> Can you submit a patch (seems like 5.17+stable material)?

After a lot more thinking, there's no bug.  If KVM unloads all roots, e.g. fast zap,
then all vCPUs are guaranteed to go through kvm_mmu_load(), and that will flush the
current ASID.

So the only problematic path is KVM_REQ_LOAD_MMU_PGD, which has two users,
kvm_mmu_new_pgd() and load_pdptrs().  load_pdptrs() is benign because it triggers
a "false" PGD load only top get PDPTRs updated on EPT, the actual PGD doesn't change
(or rather isn't forced to change by load_pdptrs().

Nested SVM's use of kvm_mmu_new_pgd() is "ok" because KVM currently flushes on
every transition.

That leaves kvm_set_cr3() via kvm_mmu_new_pgd().  For NPT, lack of a flush is
moot because KVM shouldn't be loading a new PGD in the first place (see our other
discussion about doing:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf17af4d6904..f11199b41ca8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1212,7 +1212,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
        if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
                return 1;

-       if (cr3 != kvm_read_cr3(vcpu))
+       if (!tdp_enabled && cr3 != kvm_read_cr3(vcpu))
                kvm_mmu_new_pgd(vcpu, cr3);

        vcpu->arch.cr3 = cr3;


Non-NPT shadow paging is ok because either the MOV CR3 will do a TLB flush, or the
guest explicitly says "don't do a TLB flush", in which case KVM is off the hook
from a correctness perspective (guest's responsibility to ensure MMU in sync'd),
and is ok from a safety perspective because the legacy MMU does a remote TLB flush
if it zaps any pages, i.e. the guest can't do use-after-free.

All that said, this is another argument against dropping kvm_mmu_unload() from
kvm_mmu_reset_context()[*]: SMM would theoretically be broken on AMD due to reusing
the same ASID for both non-SMM and SMM roots/memslots.

In practice, I don't think it can actually happen, but that's mostly dumb luck.
em_rsm() temporarily transitions back to Real Mode before loading the actual
non-SMM guest state, so only SMI that arrives with CR0.PG=0 is problematic.  In
that case, TLB flushes may not be triggered by kvm_set_cr0() or kvm_set_cr4(),
but kvm_set_cr3() will always trigger a flush because the "no flush" PCID bit
will always be clear.  Well, unless the SMM handler writes the read-only SMRAM
field, at which point it deserves to die :-)

Anyways, before we transitions SMM away from kvm_mmu_reset_context(), we should
add an explicit KVM_REQ_TLB_FLUSH_CURRENT in svm_{enter,leave}_smm(), with a TODO
similar to nested_svm_transition_tlb_flush() to document that the explicit flush
can go away when KVM ensures unique ASIDs for non-SMM vs. SMM.

[*] https://lore.kernel.org/all/20220209170020.1775368-13-pbonzini@redhat.com
